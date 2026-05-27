using System;

namespace ODCrypt;

public class Sha3 : KeccakDigest
{
	public override string AlgorithmName
	{
		get
		{
			int a_ = 10;
			short num = -29501;
			short num2 = num;
			num = -29501;
			switch (num2 == num)
			{
			default:
				num = 1;
				if (num != 0)
				{
				}
				num = 0;
				if (num != 0)
				{
				}
				num = 0;
				_ = num;
				return b("㍟⩡╣啥䕧", a_) + fixedOutputLength;
			}
		}
	}

	private static int w(int A_0)
	{
		int a_ = 17;
		short num = 3;
		int num2 = num;
		while (true)
		{
			switch (num2)
			{
			case 3:
				switch (0)
				{
				default:
					continue;
				case 0:
					break;
				}
				goto default;
			default:
				num = 1;
				if (num != 0)
				{
				}
				if (A_0 <= 256)
				{
					num = 0;
					num2 = num;
				}
				else
				{
					num = 8;
					num2 = num;
				}
				continue;
			case 6:
				num = 1;
				num2 = num;
				continue;
			case 1:
				if (A_0 == 512)
				{
					num = 9;
					num2 = num;
					continue;
				}
				break;
			case 7:
				num = 10;
				num2 = num;
				continue;
			case 0:
				num = 2;
				num2 = num;
				continue;
			case 2:
				if (A_0 != 224)
				{
					num = 4;
					num2 = num;
					continue;
				}
				goto case 9;
			case 4:
			{
				num = -21659;
				short num3 = num;
				num = -21659;
				switch (num3 == num)
				{
				default:
					num = 0;
					if (num != 0)
					{
					}
					num = 5;
					num2 = num;
					continue;
				case false:
				case true:
					break;
				}
				goto IL_01f9;
			}
			case 9:
				return A_0;
			case 5:
				if (A_0 != 256)
				{
					num = 7;
					num2 = num;
					continue;
				}
				goto case 9;
			case 8:
				if (A_0 == 384)
				{
					goto case 9;
				}
				goto IL_01f9;
			case 10:
				break;
				IL_01f9:
				num = 0;
				_ = num;
				num = 6;
				num2 = num;
				continue;
			}
			break;
		}
		throw new ArgumentException(A_0 + b("䝦ݨѪᥬ佮ɰٲմݶᙸॺॼ\u1a7e\ue580ꎂ\ue384\ue886ﮈꮊ\ude8c잎킐뺒Ꚕ", a_), b("զhὪⅬ੮ὰᑲŴὶ", a_));
	}

	public Sha3()
		: this(512)
	{
	}

	public Sha3(int bitLength)
		: base(w(bitLength))
	{
	}

	public Sha3(Sha3 source)
		: base(source)
	{
	}

	public static byte[] Hash(byte[] plaintext)
	{
		short num = -24593;
		short num2 = num;
		num = -24593;
		switch (num2 == num)
		{
		default:
		{
			num = 1;
			if (num != 0)
			{
			}
			num = 0;
			if (num != 0)
			{
			}
			num = 0;
			_ = num;
			Sha3 sha = new Sha3();
			sha.BlockUpdate(plaintext, 0, plaintext.Length);
			return DoFinal(sha);
		}
		}
	}

	public override int DoFinal(byte[] output, int outOff)
	{
		short num = 4015;
		short num2 = num;
		num = 4015;
		switch (num2 == num)
		{
		default:
			num = 0;
			if (num != 0)
			{
			}
			num = 1;
			if (num != 0)
			{
			}
			num = 0;
			_ = num;
			Absorb(new byte[1] { 2 }, 0, 2L);
			return base.DoFinal(output, outOff);
		}
	}

	public static byte[] DoFinal(Sha3 digest)
	{
		short num = 5969;
		short num2 = num;
		num = 5969;
		switch (num2 == num)
		{
		default:
		{
			num = 0;
			if (num != 0)
			{
			}
			num = 1;
			if (num != 0)
			{
			}
			num = 0;
			_ = num;
			byte[] array = new byte[digest.GetDigestSize()];
			digest.DoFinal(array, 0);
			return array;
		}
		}
	}

	protected override int DoFinal(byte[] output, int outOff, byte partialByte, int partialBits)
	{
		int a_ = 6;
		short num = 0;
		int num2 = num;
		int num5 = default(int);
		int num4 = default(int);
		while (true)
		{
			switch (num2)
			{
			case 0:
				switch (0)
				{
				default:
					continue;
				case 0:
					break;
				}
				goto default;
			default:
				if (partialBits >= 0)
				{
					num = 4;
					num2 = num;
					continue;
				}
				goto case 2;
			case 5:
				if (num5 >= 8)
				{
					num = 6;
					num2 = num;
					continue;
				}
				break;
			case 2:
				throw new ArgumentException(b("ㅛ⭝\u135fᙡ䑣ѥ൧䩩իm偯ٱᱳ፵塷ࡹᵻၽ\ue77f\ue781ꒃ\udd85뢇ꚉ뮋펍", a_), b("ⱛ㽝\u125fᙡ\u0d63ݥѧ⡩ի\u1a6d\u036f", a_));
			case 4:
				num = 3;
				num2 = num;
				continue;
			case 3:
				if (partialBits <= 7)
				{
					num4 = (partialByte & ((1 << partialBits) - 1)) | (2 << partialBits);
					num5 = partialBits + 2;
					num = 5;
					num2 = num;
					continue;
				}
				num = 1;
				if (num != 0)
				{
				}
				num = 0;
				_ = num;
				num = 2;
				num2 = num;
				continue;
			case 6:
			{
				num = 29318;
				short num3 = num;
				num = 29318;
				switch (num3 == num)
				{
				case false:
				case true:
					break;
				default:
					num = 0;
					if (num != 0)
					{
					}
					oneByte[0] = (byte)num4;
					Absorb(oneByte, 0, 8L);
					num5 -= 8;
					num4 >>= 8;
					num = 1;
					num2 = num;
					continue;
				}
				goto case 2;
			}
			case 1:
				break;
			}
			break;
		}
		return base.DoFinal(output, outOff, (byte)num4, num5);
	}

	public Sha3 Copy()
	{
		short num = -7639;
		short num2 = num;
		num = -7639;
		switch (num2 == num)
		{
		default:
			num = 1;
			if (num != 0)
			{
			}
			num = 0;
			if (num != 0)
			{
			}
			num = 0;
			_ = num;
			return new Sha3(this);
		}
	}

	public void Reset(Sha3 other)
	{
		short num = 14774;
		short num2 = num;
		num = 14774;
		switch (num2 == num)
		{
		}
		num = 1;
		if (num != 0)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		Array.Copy(other.state, 0, state, 0, other.state.Length);
		Array.Copy(other.dataQueue, 0, dataQueue, 0, other.dataQueue.Length);
		rate = other.rate;
		bitsInQueue = other.bitsInQueue;
		fixedOutputLength = other.fixedOutputLength;
		squeezing = other.squeezing;
		bitsAvailableForSqueezing = other.bitsAvailableForSqueezing;
		chunk = Arrays.Clone(other.chunk);
		oneByte = Arrays.Clone(other.oneByte);
	}

	internal static string b(string A_0, int A_1)
	{
		char[] array = A_0.ToCharArray();
		int num = (int)((nint)(117490377 + A_1) + (nint)86 + 54);
		int num2 = 0;
		if (num2 >= 1)
		{
			goto IL_0022;
		}
		goto IL_0055;
		IL_0022:
		int num3 = num2;
		char num4 = array[num3];
		byte b = (byte)((num4 & 0xFF) ^ num++);
		byte b2 = (byte)(((int)num4 >> 8) ^ num++);
		byte num5 = b2;
		b2 = b;
		b = num5;
		array[num3] = (char)((b2 << 8) | b);
		num2++;
		goto IL_0055;
		IL_0055:
		if (num2 >= array.Length)
		{
			return string.Intern(new string(array));
		}
		goto IL_0022;
	}
}
