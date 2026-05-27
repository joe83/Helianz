// ODCryptMono.cs
// Mono-compatible reimplementation of ODCrypt.dll.
// The original DLL is Dotfuscated; the obfuscated control-flow produces
// IL patterns that Mono 6.12's JIT rejects with InvalidProgramException.
// This file reimplements the public API surface used by HelianzBusiness:
//
//   ODCrypt.Sha3.Hash(byte[])          → SHA-3-512 (NIST FIPS 202)
//   ODCrypt.MD5.Hash(byte[])           → MD5
//   ODCrypt.CryptUtil.ConstantEquals   → constant-time string comparison
//   ODCrypt.CryptUtil.GenerateSalt     → cryptographically random salt (base-64)
//   ODCrypt.CryptUtil.RandomString     → cryptographically random base-64 string
//   ODCrypt.CryptUtil.Random<T>        → random value of primitive type T
//   ODCrypt.Encryption.*               → stubs (not used by core login flow)
//
// SHA-3-512 implementation based on NIST FIPS PUB 202 / Keccak reference.
// Test vectors (verified against original ODCrypt.dll on Windows CLR):
//   Hash([])    = a69f73cca23a9ac5c8b567dc185a756e...281dcd26
//   Hash("abc") = b751850b1a57168a5693cd924b6b096e...eec53f0

using System;
using System.Security.Cryptography;
using System.Text;

namespace ODCrypt
{
    // -------------------------------------------------------------------------
    // SHA-3-512  (Keccak sponge with SHA-3 domain byte 0x06)
    // -------------------------------------------------------------------------
    public class Sha3
    {
        // Rate = 576 bits = 72 bytes for SHA-3-512
        private const int RATE_BYTES = 72;
        private const int OUTPUT_BYTES = 64;

        // Keccak-f[1600] round constants
        private static readonly ulong[] RC = new ulong[24] {
            0x0000000000000001UL, 0x0000000000008082UL,
            0x800000000000808AUL, 0x8000000080008000UL,
            0x000000000000808BUL, 0x0000000080000001UL,
            0x8000000080008081UL, 0x8000000000008009UL,
            0x000000000000008AUL, 0x0000000000000088UL,
            0x0000000080008009UL, 0x000000008000000AUL,
            0x000000008000808BUL, 0x800000000000008BUL,
            0x8000000000008089UL, 0x8000000000008003UL,
            0x8000000000008002UL, 0x8000000000000080UL,
            0x000000000000800AUL, 0x800000008000000AUL,
            0x8000000080008081UL, 0x8000000000008080UL,
            0x0000000080000001UL, 0x8000000080008008UL
        };

        private static ulong RotL(ulong x, int n) { return (x << n) | (x >> (64 - n)); }

        // Keccak-f[1600] permutation — fully unrolled Theta/Rho+Pi/Chi/Iota.
        private static void KeccakF(ulong[] A)
        {
            for (int r = 0; r < 24; r++)
            {
                // --- Theta ---
                ulong C0 = A[0] ^ A[5] ^ A[10] ^ A[15] ^ A[20];
                ulong C1 = A[1] ^ A[6] ^ A[11] ^ A[16] ^ A[21];
                ulong C2 = A[2] ^ A[7] ^ A[12] ^ A[17] ^ A[22];
                ulong C3 = A[3] ^ A[8] ^ A[13] ^ A[18] ^ A[23];
                ulong C4 = A[4] ^ A[9] ^ A[14] ^ A[19] ^ A[24];

                ulong D0 = C4 ^ RotL(C1, 1);
                ulong D1 = C0 ^ RotL(C2, 1);
                ulong D2 = C1 ^ RotL(C3, 1);
                ulong D3 = C2 ^ RotL(C4, 1);
                ulong D4 = C3 ^ RotL(C0, 1);

                A[ 0] ^= D0; A[ 5] ^= D0; A[10] ^= D0; A[15] ^= D0; A[20] ^= D0;
                A[ 1] ^= D1; A[ 6] ^= D1; A[11] ^= D1; A[16] ^= D1; A[21] ^= D1;
                A[ 2] ^= D2; A[ 7] ^= D2; A[12] ^= D2; A[17] ^= D2; A[22] ^= D2;
                A[ 3] ^= D3; A[ 8] ^= D3; A[13] ^= D3; A[18] ^= D3; A[23] ^= D3;
                A[ 4] ^= D4; A[ 9] ^= D4; A[14] ^= D4; A[19] ^= D4; A[24] ^= D4;

                // --- Rho + Pi (combined, unrolled "spiral" path) ---
                ulong t = A[1];
                A[ 1] = RotL(A[ 6], 44); A[ 6] = RotL(A[ 9], 20); A[ 9] = RotL(A[22], 61);
                A[22] = RotL(A[14], 39); A[14] = RotL(A[20], 18); A[20] = RotL(A[ 2], 62);
                A[ 2] = RotL(A[12], 43); A[12] = RotL(A[13], 25); A[13] = RotL(A[19],  8);
                A[19] = RotL(A[23], 56); A[23] = RotL(A[15], 41); A[15] = RotL(A[ 4], 27);
                A[ 4] = RotL(A[24], 14); A[24] = RotL(A[21],  2); A[21] = RotL(A[ 8], 55);
                A[ 8] = RotL(A[16], 45); A[16] = RotL(A[ 5], 36); A[ 5] = RotL(A[ 3], 28);
                A[ 3] = RotL(A[18], 21); A[18] = RotL(A[17], 15); A[17] = RotL(A[11], 10);
                A[11] = RotL(A[ 7],  6); A[ 7] = RotL(A[10],  3); A[10] = RotL(t,  1);

                // --- Chi ---
                for (int y = 0; y < 25; y += 5)
                {
                    ulong B0 = A[y    ], B1 = A[y + 1], B2 = A[y + 2],
                          B3 = A[y + 3], B4 = A[y + 4];
                    A[y    ] = B0 ^ (~B1 & B2);
                    A[y + 1] = B1 ^ (~B2 & B3);
                    A[y + 2] = B2 ^ (~B3 & B4);
                    A[y + 3] = B3 ^ (~B4 & B0);
                    A[y + 4] = B4 ^ (~B0 & B1);
                }

                // --- Iota ---
                A[0] ^= RC[r];
            }
        }

        // Absorb bytes into the state (little-endian lane loading).
        private static void AbsorbBlock(ulong[] A, byte[] block, int offset, int count)
        {
            for (int i = 0; i < count; i += 8)
            {
                ulong lane = 0;
                int laneBytes = Math.Min(8, count - i);
                for (int b = 0; b < laneBytes; b++)
                    lane |= (ulong)block[offset + i + b] << (8 * b);
                A[i / 8] ^= lane;
            }
        }

        /// <summary>
        /// SHA-3-512 hash (NIST FIPS 202).
        /// Drop-in replacement for the original ODCrypt.Sha3.Hash(byte[]).
        /// </summary>
        public static byte[] Hash(byte[] input)
        {
            if (input == null) input = new byte[0];

            ulong[] A = new ulong[25];

            // --- Absorb full-rate blocks ---
            int inputOff = 0;
            while (inputOff + RATE_BYTES <= input.Length)
            {
                AbsorbBlock(A, input, inputOff, RATE_BYTES);
                KeccakF(A);
                inputOff += RATE_BYTES;
            }

            // --- Absorb final (padded) block ---
            byte[] pad = new byte[RATE_BYTES];
            int remaining = input.Length - inputOff;
            Buffer.BlockCopy(input, inputOff, pad, 0, remaining);
            pad[remaining]          = 0x06; // SHA-3 domain separation
            pad[RATE_BYTES - 1]    |= 0x80; // multi-rate padding end bit
            AbsorbBlock(A, pad, 0, RATE_BYTES);
            KeccakF(A);

            // --- Squeeze OUTPUT_BYTES (64) from state ---
            byte[] output = new byte[OUTPUT_BYTES];
            for (int i = 0; i < OUTPUT_BYTES / 8; i++)
            {
                ulong lane = A[i];
                for (int b = 0; b < 8; b++)
                    output[i * 8 + b] = (byte)(lane >> (8 * b));
            }
            return output;
        }
    }

    // -------------------------------------------------------------------------
    // MD5  (delegates to BCL System.Security.Cryptography.MD5)
    // -------------------------------------------------------------------------
    public class MD5
    {
        public static byte[] Hash(byte[] input)
        {
            using (var md5 = System.Security.Cryptography.MD5.Create())
                return md5.ComputeHash(input ?? new byte[0]);
        }
    }

    // -------------------------------------------------------------------------
    // CryptUtil
    // -------------------------------------------------------------------------
    public static class CryptUtil
    {
        /// <summary>Constant-time string equality check (timing-attack resistant).</summary>
        public static bool ConstantEquals(string lhs, string rhs)
        {
            if (lhs == null && rhs == null) return true;
            if (lhs == null || rhs == null) return false;
            byte[] a = Encoding.UTF8.GetBytes(lhs);
            byte[] b = Encoding.UTF8.GetBytes(rhs);
            return ConstantEquals(a, b);
        }

        /// <summary>Constant-time byte array equality check.</summary>
        public static bool ConstantEquals(byte[] lhs, byte[] rhs)
        {
            if (lhs == null && rhs == null) return true;
            if (lhs == null || rhs == null) return false;
            int diff = lhs.Length ^ rhs.Length;
            int len  = Math.Min(lhs.Length, rhs.Length);
            for (int i = 0; i < len; i++) diff |= lhs[i] ^ rhs[i];
            return diff == 0;
        }

        /// <summary>Generates a cryptographically random base-64 encoded salt.</summary>
        public static string GenerateSalt(int byteLength)
        {
            byte[] salt = new byte[byteLength];
            using (var rng = RandomNumberGenerator.Create())
                rng.GetBytes(salt);
            return Convert.ToBase64String(salt);
        }

        /// <summary>Generates a cryptographically random base-64 string of the given byte length.</summary>
        public static string RandomString(int byteLength)
        {
            byte[] buf = new byte[byteLength];
            using (var rng = RandomNumberGenerator.Create())
                rng.GetBytes(buf);
            return Convert.ToBase64String(buf);
        }

        /// <summary>Returns a cryptographically random value of the requested primitive type.</summary>
        public static T Random<T>()
        {
            int size = System.Runtime.InteropServices.Marshal.SizeOf(typeof(T));
            byte[] buf = new byte[size];
            using (var rng = RandomNumberGenerator.Create())
                rng.GetBytes(buf);
            if (typeof(T) == typeof(int))    return (T)(object)BitConverter.ToInt32(buf, 0);
            if (typeof(T) == typeof(uint))   return (T)(object)BitConverter.ToUInt32(buf, 0);
            if (typeof(T) == typeof(long))   return (T)(object)BitConverter.ToInt64(buf, 0);
            if (typeof(T) == typeof(ulong))  return (T)(object)BitConverter.ToUInt64(buf, 0);
            if (typeof(T) == typeof(double)) return (T)(object)BitConverter.ToDouble(buf, 0);
            if (typeof(T) == typeof(float))  return (T)(object)BitConverter.ToSingle(buf, 0);
            throw new ApplicationException("ODCrypt.CryptUtil.Random<T>: unsupported type " + typeof(T).Name);
        }
    }

    // -------------------------------------------------------------------------
    // Encryption  (stubs — AES key is embedded/obfuscated in original DLL;
    // these methods are only called for eConnector statistics, not core login)
    // -------------------------------------------------------------------------
    public class Encryption
    {
        public static string STATIC_INIT_VECTOR { get { return ""; } }

        /// <summary>Stub: returns false. eConnector stats are non-critical on Linux.</summary>
        public static bool DecompressString(string compressed, out string plainText, ref string errorStr)
        {
            plainText = "";
            errorStr  = "ODCryptMono: Encryption.DecompressString not supported on Linux.";
            return false;
        }

        /// <summary>Stub: returns false. eConnector stats are non-critical on Linux.</summary>
        public static bool CompressString(string plainText, out string compressed, ref string errorStr)
        {
            compressed = "";
            errorStr   = "ODCryptMono: Encryption.CompressString not supported on Linux.";
            return false;
        }

        /// <summary>Stub: returns false. eConnector/HQ proxy encryption not supported on Linux.</summary>
        public static bool EncryptString(string plainText, bool useCompression, out string encrypted, ref string errorStr)
        {
            encrypted = "";
            errorStr  = "ODCryptMono: Encryption.EncryptString not supported on Linux.";
            return false;
        }
    }
}
