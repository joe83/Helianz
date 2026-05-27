using System;

namespace ODCrypt;

public class KeccakDigest
{
	private static readonly ulong[] m_w;

	private static readonly int[] m_r;

	protected byte[] state = new byte[200];

	protected byte[] dataQueue = new byte[192];

	protected int rate;

	protected int bitsInQueue;

	protected int fixedOutputLength;

	protected bool squeezing;

	protected int bitsAvailableForSqueezing;

	protected byte[] chunk;

	protected byte[] oneByte;

	private ulong[] m_m = new ulong[5];

	private ulong[] m_h = new ulong[25];

	private ulong[] m_c = new ulong[5];

	public virtual string AlgorithmName
	{
		get
		{
			int a_ = 19;
			short num = -2085;
			short num2 = num;
			num = -2085;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				break;
			case true:
				break;
			}
			num = 1;
			if (num != 0)
			{
			}
			num = 0;
			if (num != 0)
			{
			}
			return Sha3.b("≨\u0e6a\u0e6c౮ၰᡲ塴", a_) + fixedOutputLength;
		}
	}

	private static ulong[] h()
	{
		short num = 0;
		int num2 = num;
		switch (num2)
		{
		default:
		{
			byte b = default(byte);
			int num3 = default(int);
			ulong[] array = default(ulong[]);
			switch (0)
			{
			default:
			{
				int num4 = default(int);
				int num6 = default(int);
				while (true)
				{
					switch (num2)
					{
					case 2:
					case 11:
						num = 5;
						num2 = num;
						continue;
					case 5:
						goto IL_00a3;
					case 4:
						b ^= 0x71;
						num = 13;
						num2 = num;
						continue;
					case 13:
						num = 1;
						if (num == 0)
						{
						}
						goto IL_01ec;
					case 8:
						goto IL_0133;
					case 0:
						num3++;
						num = 9;
						num2 = num;
						continue;
					case 7:
					case 9:
						num = 10;
						num2 = num;
						continue;
					case 10:
						goto IL_0225;
					case 12:
						goto IL_0247;
					case 6:
					{
						bool num5 = (b & 0x80) != 0;
						b <<= 1;
						if (num5)
						{
							num = 4;
							num2 = num;
							continue;
						}
						goto IL_01ec;
					}
					case 1:
						num = 0;
						_ = num;
						array[num3] ^= (ulong)(1L << num4);
						num = 12;
						num2 = num;
						continue;
					case 3:
						{
							return array;
						}
						IL_01ec:
						num6++;
						num = 11;
						num2 = num;
						continue;
					}
					break;
					IL_0225:
					if (num3 < 24)
					{
						array[num3] = 0uL;
						num6 = 0;
						num = 2;
						num2 = num;
					}
					else
					{
						num = 3;
						num2 = num;
					}
					continue;
					IL_0247:
					num = 6;
					num2 = num;
					continue;
					IL_00a3:
					if (num6 >= 7)
					{
						num = 0;
						num2 = num;
					}
					else
					{
						num4 = (1 << num6) - 1;
						num = 8;
						num2 = num;
					}
					continue;
					IL_0133:
					num = -30015;
					short num7 = num;
					num = -30015;
					switch (num7 == num)
					{
					case false:
					case true:
						break;
					default:
						goto IL_0169;
					}
					goto IL_0072;
					IL_0169:
					num = 0;
					if (num != 0)
					{
					}
					if ((b & 1) != 0)
					{
						num = 1;
						num2 = num;
						continue;
					}
					goto IL_0247;
				}
				goto case 0;
			}
			case 0:
				{
					array = new ulong[24];
					b = 1;
					num3 = 0;
					goto IL_0072;
				}
				IL_0072:
				num = 7;
				num2 = num;
				goto default;
			}
		}
		}
	}

	private static int[] m()
	{
		short num = -15422;
		short num2 = num;
		num = -15422;
		int num3;
		int[] array = default(int[]);
		int num4 = default(int);
		int num5 = default(int);
		int num6 = default(int);
		int num7 = default(int);
		switch (num2 == num)
		{
		default:
			num = 0;
			if (num != 0)
			{
			}
			num = 0;
			num3 = num;
			switch (num3)
			{
			}
			switch (0)
			{
			case 0:
				goto IL_0089;
			}
			goto IL_0072;
		case false:
		case true:
			goto IL_00b6;
			IL_00e0:
			num = 1;
			num3 = num;
			goto IL_0072;
			IL_0089:
			array = new int[25];
			num4 = (array[0] = 0);
			num5 = 1;
			num6 = 0;
			num7 = 1;
			num = 0;
			num3 = num;
			goto IL_0072;
			IL_0072:
			while (true)
			{
				switch (num3)
				{
				case 0:
					goto IL_00b6;
				case 2:
					goto IL_00e0;
				case 1:
					goto IL_00f8;
				case 3:
					return array;
				}
				break;
				IL_00f8:
				if (num7 >= 25)
				{
					num = 3;
					num3 = num;
					continue;
				}
				num4 = (num4 + num7) & 0x3F;
				array[num5 % 5 + 5 * (num6 % 5)] = num4;
				int num8 = num6 % 5;
				int num9 = (2 * num5 + 3 * num6) % 5;
				num5 = num8;
				num6 = num9;
				num7++;
				num = 0;
				_ = num;
				num = 2;
				num3 = num;
			}
			goto IL_0089;
			IL_00b6:
			num = 1;
			if (num == 0)
			{
			}
			goto IL_00e0;
		}
	}

	private void r(int A_0, int A_1)
	{
		short num = 0;
		_ = num;
		num = 16615;
		short num2 = num;
		num = 16615;
		int num3 = default(int);
		int num4 = default(int);
		switch (num2 == num)
		{
		default:
			num = 0;
			if (num != 0)
			{
			}
			switch (0)
			{
			case 0:
				goto IL_0093;
			}
			goto IL_007d;
		case false:
		case true:
			goto IL_00d2;
			IL_0093:
			num3 = A_0;
			num = 0;
			num4 = num;
			goto IL_007d;
			IL_007d:
			while (true)
			{
				switch (num4)
				{
				case 0:
					num = 1;
					if (num == 0)
					{
					}
					goto IL_00d2;
				case 2:
					goto IL_00d2;
				case 1:
					goto IL_00e7;
				case 3:
					return;
				}
				break;
				IL_00e7:
				if (num3 == A_0 + A_1)
				{
					num = 3;
					num4 = num;
					continue;
				}
				dataQueue[num3] = 0;
				num3++;
				num = 2;
				num4 = num;
			}
			goto IL_0093;
			IL_00d2:
			num = 1;
			num4 = num;
			goto IL_007d;
		}
	}

	public KeccakDigest()
		: this(288)
	{
	}

	public KeccakDigest(int bitLength)
	{
		w(bitLength);
	}

	public KeccakDigest(KeccakDigest source)
	{
		w(source);
	}

	private void w(KeccakDigest A_0)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		num = 25830;
		short num2 = num;
		num = 25830;
		switch (num2 == num)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		Array.Copy(A_0.state, 0, state, 0, A_0.state.Length);
		Array.Copy(A_0.dataQueue, 0, dataQueue, 0, A_0.dataQueue.Length);
		rate = A_0.rate;
		bitsInQueue = A_0.bitsInQueue;
		fixedOutputLength = A_0.fixedOutputLength;
		squeezing = A_0.squeezing;
		bitsAvailableForSqueezing = A_0.bitsAvailableForSqueezing;
		chunk = Arrays.Clone(A_0.chunk);
		oneByte = Arrays.Clone(A_0.oneByte);
	}

	public virtual int GetDigestSize()
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		num = -13207;
		short num2 = num;
		num = -13207;
		switch (num2 == num)
		{
		default:
			num = 0;
			if (num != 0)
			{
			}
			return fixedOutputLength / 8;
		}
	}

	public virtual void Update(byte input)
	{
		short num = 26324;
		short num2 = num;
		num = 26324;
		switch (num2 == num)
		{
		default:
			num = 0;
			_ = num;
			break;
		case true:
			break;
		}
		num = 1;
		if (num != 0)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		oneByte[0] = input;
		Absorb(oneByte, 0, 8L);
	}

	public virtual void BlockUpdate(byte[] input, int inOff, int len)
	{
		short num = 18995;
		short num2 = num;
		num = 18995;
		switch (num2 == num)
		{
		default:
			num = 0;
			_ = num;
			break;
		case true:
			break;
		}
		num = 1;
		if (num != 0)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		Absorb(input, inOff, (long)len * 8L);
	}

	public virtual int DoFinal(byte[] output, int outOff)
	{
		short num = 16118;
		short num2 = num;
		num = 16118;
		switch (num2 == num)
		{
		default:
			num = 0;
			_ = num;
			break;
		case true:
			break;
		}
		num = 1;
		if (num != 0)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		Squeeze(output, outOff, fixedOutputLength);
		Reset();
		return GetDigestSize();
	}

	protected virtual int DoFinal(byte[] output, int outOff, byte partialByte, int partialBits)
	{
		short num = 0;
		_ = num;
		num = 0;
		int num2 = num;
		while (true)
		{
			switch (num2)
			{
			case 0:
			{
				num = 13726;
				short num3 = num;
				num = 13726;
				switch (num3 == num)
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
					switch (0)
					{
					default:
						continue;
					case 0:
						break;
					}
					break;
				case false:
				case true:
					break;
				}
				goto default;
			}
			default:
				if (partialBits > 0)
				{
					num = 2;
					num2 = num;
					continue;
				}
				break;
			case 2:
				oneByte[0] = partialByte;
				Absorb(oneByte, 0, partialBits);
				num = 1;
				num2 = num;
				continue;
			case 1:
				break;
			}
			break;
		}
		Squeeze(output, outOff, fixedOutputLength);
		Reset();
		return GetDigestSize();
	}

	public virtual void Reset()
	{
		short num = -20696;
		short num2 = num;
		num = -20696;
		switch (num2 == num)
		{
		default:
			num = 0;
			_ = num;
			break;
		case true:
			break;
		}
		num = 0;
		if (num != 0)
		{
		}
		num = 1;
		if (num != 0)
		{
		}
		w(fixedOutputLength);
	}

	public virtual int GetByteLength()
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		num = 1082;
		short num2 = num;
		num = 1082;
		switch (num2 == num)
		{
		default:
			num = 0;
			if (num != 0)
			{
			}
			return rate / 8;
		}
	}

	private void w(int A_0)
	{
		int a_ = 9;
		short num = 1;
		int num2 = num;
		while (true)
		{
			switch (num2)
			{
			case 1:
				switch (0)
				{
				default:
					goto end_IL_0029;
				case 0:
					break;
				}
				goto default;
			default:
				while (true)
				{
					if (A_0 <= 256)
					{
						num = -3767;
						short num3 = num;
						num = -3767;
						switch (num3 == num)
						{
						case false:
						case true:
							continue;
						}
						num = 0;
						if (num != 0)
						{
						}
						num = 7;
						num2 = num;
					}
					else
					{
						num = 11;
						num2 = num;
					}
					break;
				}
				break;
			case 5:
				num = 9;
				num2 = num;
				break;
			case 8:
				num = 12;
				num2 = num;
				break;
			case 12:
				if (A_0 != 256)
				{
					num = 6;
					num2 = num;
					break;
				}
				w(1088, 512);
				return;
			case 4:
				num = 10;
				num2 = num;
				break;
			case 10:
				if (A_0 == 224)
				{
					w(1152, 448);
					return;
				}
				num = 8;
				num2 = num;
				break;
			case 3:
				num = 2;
				num2 = num;
				break;
			case 2:
				if (A_0 == 512)
				{
					w(576, 1024);
					return;
				}
				num = 5;
				num2 = num;
				break;
			case 6:
				num = 15;
				num2 = num;
				break;
			case 11:
				if (A_0 == 288)
				{
					w(1024, 576);
					return;
				}
				num = 0;
				num2 = num;
				break;
			case 7:
				num = 13;
				num2 = num;
				break;
			case 13:
				if (A_0 == 128)
				{
					w(1344, 256);
					return;
				}
				num = 4;
				num2 = num;
				break;
			case 0:
				num = 0;
				_ = num;
				num = 14;
				num2 = num;
				break;
			case 14:
				num = 1;
				if (num != 0)
				{
				}
				if (A_0 == 384)
				{
					w(832, 768);
					return;
				}
				num = 3;
				num2 = num;
				break;
			case 9:
			case 15:
				{
					throw new ArgumentException(Sha3.b("㉞ᑠ\u1062ᅤ䝦୨\u0e6a䵬nὰᙲ啴ᡶὸ孺䱼䵾릀꾂ꖄ떆뮈뾊ꆌ꾎ꎐꚒꎔ뮖릘ꦚꖜꞞ趠莢隤龦鶨螪趬삮쎰鎲肴蚶许閺", a_), Sha3.b("㵞ࡠᝢ⥤ɦݨ౪ᥬݮ", a_));
				}
				end_IL_0029:
				break;
			}
		}
	}

	private void w(int A_0, int A_1)
	{
		int a_ = 14;
		short num = -23456;
		short num2 = num;
		num = -23456;
		switch (num2 == num)
		{
		case false:
		case true:
			goto IL_00bf;
		}
		num = 0;
		if (num != 0)
		{
		}
		num = 1;
		int num3 = num;
		goto IL_0071;
		IL_0071:
		while (true)
		{
			switch (num3)
			{
			case 1:
				switch (0)
				{
				default:
					continue;
				case 0:
					break;
				}
				goto default;
			default:
				if (A_0 + A_1 != 1600)
				{
					num = 4;
					num3 = num;
				}
				else
				{
					num = 6;
					num3 = num;
				}
				continue;
			case 0:
				num = 1;
				if (num != 0)
				{
				}
				if (A_0 % 64 != 0)
				{
					num = 3;
					num3 = num;
					continue;
				}
				rate = A_0;
				fixedOutputLength = 0;
				Arrays.Fill(state, 0);
				Arrays.Fill(dataQueue, 0);
				bitsInQueue = 0;
				squeezing = false;
				bitsAvailableForSqueezing = 0;
				fixedOutputLength = A_1 / 2;
				chunk = new byte[A_0 / 8];
				oneByte = new byte[1];
				return;
			case 2:
				num = 7;
				num3 = num;
				continue;
			case 7:
				if (A_0 < 1600)
				{
					num = 5;
					num3 = num;
					continue;
				}
				goto case 3;
			case 5:
				break;
			case 4:
				throw new InvalidOperationException(Sha3.b("ᙣݥᱧཀྵ䱫䕭偯ᅱᕳٵ\u1977\u1979ᕻ\u0a7d勵ꊁꖃ뮅ꢇ뮉몋뺍ꂏ", a_));
			case 3:
				throw new InvalidOperationException(Sha3.b("\u0d63ࡥṧ୩kݭᑯ剱ٳ\u1775౷ό屻ࡽ\ue17f\uee81\uf183\ue385", a_));
			case 6:
				if (A_0 > 0)
				{
					num = 2;
					num3 = num;
					continue;
				}
				goto case 3;
			}
			break;
		}
		num = 0;
		_ = num;
		goto IL_00bf;
		IL_00bf:
		num = 0;
		num3 = num;
		goto IL_0071;
	}

	private void r()
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		num = 14169;
		short num2 = num;
		num = 14169;
		switch (num2 == num)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		r(state, dataQueue, rate / 8);
		bitsInQueue = 0;
	}

	protected virtual void Absorb(byte[] data, int off, long databitlen)
	{
		int a_ = 12;
		short num = 0;
		switch (num)
		{
		default:
		{
			num = 3;
			int num2 = num;
			int num7 = default(int);
			long num5 = default(long);
			long num4 = default(long);
			long num3 = default(long);
			int num9 = default(int);
			while (true)
			{
				switch (num2)
				{
				case 3:
					switch (0)
					{
					default:
						goto end_IL_0049;
					case 0:
						break;
					}
					goto default;
				default:
					if (bitsInQueue % 8 != 0)
					{
						num = 1;
						num2 = num;
					}
					else
					{
						num = 14;
						num2 = num;
					}
					break;
				case 17:
					num7 = rate - bitsInQueue;
					num = 4;
					num2 = num;
					break;
				case 2:
				case 19:
					num = 10;
					num2 = num;
					break;
				case 10:
					if (num5 >= num4)
					{
						num = 20;
						num2 = num;
						break;
					}
					Array.Copy(data, (int)(off + num3 / 8 + num5 * chunk.Length), chunk, 0, chunk.Length);
					r(state, chunk, chunk.Length);
					num5++;
					num = 19;
					num2 = num;
					break;
				case 26:
					num = 12;
					num2 = num;
					break;
				case 12:
					if (num9 > 0)
					{
						num = 23;
						num2 = num;
						break;
					}
					goto case 8;
				case 14:
					if (!squeezing)
					{
						num3 = 0L;
						num = 13;
						num2 = num;
					}
					else
					{
						num = 5;
						num2 = num;
					}
					break;
				case 21:
					if (num7 + bitsInQueue > rate)
					{
						num = 0;
						_ = num;
						num = 17;
						num2 = num;
						break;
					}
					goto case 4;
				case 23:
				{
					int num8 = (1 << num9) - 1;
					dataQueue[bitsInQueue / 8] = (byte)(data[off + (int)(num3 / 8)] & num8);
					bitsInQueue += num9;
					num3 += num9;
					num = 16;
					num2 = num;
					break;
				}
				case 0:
					if (bitsInQueue == 0)
					{
						num = 1;
						if (num != 0)
						{
						}
						num = 11;
						num2 = num;
						break;
					}
					goto IL_01f2;
				case 25:
					r();
					num = 26;
					num2 = num;
					break;
				case 8:
				case 13:
				case 16:
				{
					num = 12655;
					short num6 = num;
					num = 12655;
					switch (num6 == num)
					{
					default:
						num = 0;
						if (num != 0)
						{
						}
						num = 15;
						num2 = num;
						goto end_IL_0049;
					case false:
					case true:
						break;
					}
					goto case 7;
				}
				case 15:
					if (num3 < databitlen)
					{
						num = 0;
						num2 = num;
					}
					else
					{
						num = 6;
						num2 = num;
					}
					break;
				case 6:
					return;
				case 18:
					num = 7;
					num2 = num;
					break;
				case 7:
					if (num3 <= databitlen - rate)
					{
						num = 22;
						num2 = num;
						break;
					}
					goto IL_01f2;
				case 1:
					throw new InvalidOperationException(Sha3.b("\u0361\u1063ብ൧ݩᱫ\u1a6d偯ٱ\u1b73噵\u1977\u1879\u0f7bᅽ\uf27f\ue081ꒃ\uf185\ue187ﺉ\ue48b꺍ﾏ\uf691\uf093뚕\uf497ﾙ\uf29b劣풟쪡蒣\ud7a5\udda7쾩\ud9ab쮭麯", a_));
				case 5:
					throw new InvalidOperationException(Sha3.b("\u0361\u1063ብ൧ݩᱫ\u1a6d偯ٱ\u1b73噵\u1977\u1879\u0f7bᅽ\uf27f\ue081ꒃ\uf185\ue087\ue389\ue08b\ueb8d낏\ue191\ue593\ue395ﶗﾙ\ue69b\uf79d캟얡誣", a_));
				case 11:
					num = 24;
					num2 = num;
					break;
				case 24:
					if (databitlen >= rate)
					{
						num = 18;
						num2 = num;
						break;
					}
					goto IL_01f2;
				case 22:
					num4 = (databitlen - num3) / rate;
					num5 = 0L;
					num = 2;
					num2 = num;
					break;
				case 4:
					num9 = num7 % 8;
					num7 -= num9;
					Array.Copy(data, off + (int)(num3 / 8), dataQueue, bitsInQueue / 8, num7 / 8);
					bitsInQueue += num7;
					num3 += num7;
					num = 9;
					num2 = num;
					break;
				case 9:
					if (bitsInQueue == rate)
					{
						num = 25;
						num2 = num;
						break;
					}
					goto case 26;
				case 20:
					{
						num3 += num4 * rate;
						num = 8;
						num2 = num;
						break;
					}
					IL_01f2:
					num7 = (int)(databitlen - num3);
					num = 21;
					num2 = num;
					break;
					end_IL_0049:
					break;
				}
			}
		}
		}
	}

	private void w()
	{
		short num = 27680;
		short num2 = num;
		num = 27680;
		int num3;
		switch (num2 == num)
		{
		default:
			num = 0;
			if (num != 0)
			{
			}
			num = 1;
			num3 = num;
			goto IL_006b;
		case false:
		case true:
			{
				dataQueue[bitsInQueue / 8] |= (byte)(1 << bitsInQueue % 8);
				r();
				r(0, rate / 8);
				num = 5;
				num3 = num;
				goto IL_006b;
			}
			IL_006b:
			while (true)
			{
				switch (num3)
				{
				case 1:
					switch (0)
					{
					default:
						continue;
					case 0:
						break;
					}
					goto default;
				default:
					if (bitsInQueue + 1 == rate)
					{
						num = 4;
						num3 = num;
						continue;
					}
					r((bitsInQueue + 7) / 8, rate / 8 - (bitsInQueue + 7) / 8);
					dataQueue[bitsInQueue / 8] |= (byte)(1 << bitsInQueue % 8);
					num = 2;
					num3 = num;
					continue;
				case 7:
					w(state, dataQueue);
					bitsAvailableForSqueezing = 1024;
					num = 0;
					num3 = num;
					continue;
				case 2:
					dataQueue[(rate - 1) / 8] |= (byte)(1 << (rate - 1) % 8);
					r();
					num = 3;
					num3 = num;
					continue;
				case 3:
					if (rate == 1024)
					{
						num = 7;
						num3 = num;
						continue;
					}
					w(state, dataQueue, rate / 64);
					bitsAvailableForSqueezing = rate;
					num = 6;
					num3 = num;
					continue;
				case 4:
					break;
				case 5:
					num = 0;
					_ = num;
					goto case 2;
				case 6:
					num = 1;
					if (num == 0)
					{
					}
					goto case 0;
				case 0:
					squeezing = true;
					return;
				}
				break;
			}
			goto case false;
		}
	}

	protected virtual void Squeeze(byte[] output, int offset, long outputLength)
	{
		int a_ = 16;
		short num = 1;
		int num2 = num;
		int num4 = default(int);
		long num5 = default(long);
		while (true)
		{
			switch (num2)
			{
			case 1:
				switch (0)
				{
				default:
					goto end_IL_002a;
				case 0:
					break;
				}
				goto default;
			default:
				if (!squeezing)
				{
					num = 3;
					num2 = num;
					break;
				}
				goto case 15;
			case 7:
			case 14:
				num4 = bitsAvailableForSqueezing;
				num = 11;
				num2 = num;
				break;
			case 11:
				if (num4 > outputLength - num5)
				{
					num = 5;
					num2 = num;
					break;
				}
				goto case 2;
			case 16:
				w(state, dataQueue);
				bitsAvailableForSqueezing = 1024;
				num = 14;
				num2 = num;
				break;
			case 10:
				throw new InvalidOperationException(Sha3.b("॥ᵧṩᱫ\u1b6dѯ㹱ᅳᡵί\u0e79ᑻ幽\uee7f\ued81\uf083ꚅ\ue987ꪉ\ue18bﮍﲏ\ue691ﶓ\ue695\uf497ﾙ벛\uf19d욟芡鲣", a_));
			case 2:
				Array.Copy(dataQueue, (rate - bitsAvailableForSqueezing) / 8, output, offset + (int)(num5 / 8), num4 / 8);
				bitsAvailableForSqueezing -= num4;
				num5 += num4;
				num = 8;
				num2 = num;
				break;
			case 15:
				num = 12;
				num2 = num;
				break;
			case 12:
				if (outputLength % 8 != 0L)
				{
					num = 10;
					num2 = num;
				}
				else
				{
					num5 = 0L;
					num = 9;
					num2 = num;
				}
				break;
			case 8:
			case 9:
				num = 4;
				num2 = num;
				break;
			case 4:
				num = 1;
				if (num != 0)
				{
				}
				if (num5 >= outputLength)
				{
					num = 6;
					num2 = num;
				}
				else
				{
					num = 17;
					num2 = num;
				}
				break;
			case 17:
				if (bitsAvailableForSqueezing == 0)
				{
					num = 13;
					num2 = num;
					break;
				}
				goto case 7;
			case 3:
				w();
				num = 15;
				num2 = num;
				break;
			case 5:
				num4 = (int)(outputLength - num5);
				num = 2;
				num2 = num;
				break;
			case 13:
				w(state);
				num = 0;
				num2 = num;
				break;
			case 0:
				if (rate != 1024)
				{
					w(state, dataQueue, rate / 64);
					bitsAvailableForSqueezing = rate;
					num = 22168;
					short num3 = num;
					num = 22168;
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
						num = 7;
						num2 = num;
						goto end_IL_002a;
					}
					goto case 7;
				}
				num = 16;
				num2 = num;
				break;
			case 6:
				{
					num = 0;
					_ = num;
					return;
				}
				end_IL_002a:
				break;
			}
		}
	}

	private static void w(ulong[] A_0, byte[] A_1)
	{
		short num = -9261;
		short num2 = num;
		num = -9261;
		int num3 = default(int);
		int num4 = default(int);
		int num5 = default(int);
		int num6 = default(int);
		switch (num2 == num)
		{
		default:
			num = 0;
			if (num != 0)
			{
			}
			switch (0)
			{
			case 0:
				goto IL_007b;
			}
			goto IL_0055;
		case false:
		case true:
			goto IL_013b;
			IL_007b:
			num3 = 0;
			num = 1;
			num4 = num;
			goto IL_0055;
			IL_0055:
			while (true)
			{
				switch (num4)
				{
				case 2:
				case 7:
					num = 0;
					num4 = num;
					continue;
				case 0:
					goto IL_00cb;
				case 3:
					num = 0;
					_ = num;
					num3++;
					num = 4;
					num4 = num;
					continue;
				case 1:
				case 4:
					goto IL_013b;
				case 5:
					goto IL_0153;
				case 6:
					return;
				}
				break;
				IL_0153:
				num = 1;
				if (num != 0)
				{
				}
				if (num3 < 25)
				{
					A_0[num3] = 0uL;
					num5 = num3 * 8;
					num6 = 0;
					num = 7;
					num4 = num;
				}
				else
				{
					num = 6;
					num4 = num;
				}
				continue;
				IL_00cb:
				if (num6 >= 8)
				{
					num = 3;
					num4 = num;
					continue;
				}
				A_0[num3] |= ((ulong)A_1[num5 + num6] & 0xFFuL) << 8 * num6;
				num6++;
				num = 2;
				num4 = num;
			}
			goto IL_007b;
			IL_013b:
			num = 5;
			num4 = num;
			goto IL_0055;
		}
	}

	private static void w(byte[] A_0, ulong[] A_1)
	{
		short num = 13624;
		short num2 = num;
		num = 13624;
		int num3 = default(int);
		int num4 = default(int);
		int num5 = default(int);
		int num6 = default(int);
		switch (num2 == num)
		{
		default:
			num = 0;
			if (num != 0)
			{
			}
			switch (0)
			{
			case 0:
				goto IL_007c;
			}
			goto IL_0056;
		case false:
		case true:
			goto IL_0161;
			IL_007c:
			num3 = 0;
			num = 1;
			num4 = num;
			goto IL_0056;
			IL_0056:
			while (true)
			{
				switch (num4)
				{
				case 3:
					num3++;
					num = 4;
					num4 = num;
					continue;
				case 2:
				case 7:
					num = 0;
					num4 = num;
					continue;
				case 0:
					goto IL_00ca;
				case 1:
				case 4:
					goto IL_0161;
				case 5:
					goto IL_017a;
				case 6:
					return;
				}
				break;
				IL_017a:
				if (num3 < 25)
				{
					num5 = num3 * 8;
					num6 = 0;
					num = 7;
					num4 = num;
				}
				else
				{
					num = 6;
					num4 = num;
				}
				continue;
				IL_00ca:
				num = 1;
				if (num != 0)
				{
				}
				if (num6 >= 8)
				{
					num = 0;
					_ = num;
					num = 3;
					num4 = num;
				}
				else
				{
					A_0[num5 + num6] = (byte)(A_1[num3] >> 8 * num6);
					num6++;
					num = 2;
					num4 = num;
				}
			}
			goto IL_007c;
			IL_0161:
			num = 5;
			num4 = num;
			goto IL_0056;
		}
	}

	private void w(byte[] A_0)
	{
		short num = 7623;
		short num2 = num;
		num = 7623;
		switch (num2 == num)
		{
		default:
			num = 0;
			_ = num;
			break;
		case true:
			break;
		}
		num = 0;
		if (num != 0)
		{
		}
		num = 1;
		if (num != 0)
		{
		}
		ulong[] array = new ulong[A_0.Length / 8];
		w(array, A_0);
		c(array);
		w(A_0, array);
	}

	private void m(byte[] A_0, byte[] A_1, int A_2)
	{
		short num = 0;
		_ = num;
		num = -1497;
		short num2 = num;
		num = -1497;
		int num3 = default(int);
		int num4 = default(int);
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
			switch (0)
			{
			case 0:
				goto IL_00bd;
			}
			goto IL_00a7;
		case false:
		case true:
			goto IL_00d5;
			IL_00d5:
			num = 1;
			num3 = num;
			goto IL_00a7;
			IL_00bd:
			num4 = 0;
			num = 0;
			num3 = num;
			goto IL_00a7;
			IL_00a7:
			while (true)
			{
				switch (num3)
				{
				case 0:
				case 2:
					goto IL_00d5;
				case 1:
					goto IL_00ea;
				case 3:
					w(A_0);
					return;
				}
				break;
				IL_00ea:
				if (num4 >= A_2)
				{
					num = 3;
					num3 = num;
					continue;
				}
				A_0[num4] ^= A_1[num4];
				num4++;
				num = 2;
				num3 = num;
			}
			goto IL_00bd;
		}
	}

	private void c(ulong[] A_0)
	{
		short num = 0;
		_ = num;
		num = 11484;
		short num2 = num;
		num = 11484;
		int num3 = default(int);
		int num4 = default(int);
		switch (num2 == num)
		{
		default:
			num = 0;
			if (num != 0)
			{
			}
			switch (0)
			{
			case 0:
				goto IL_0092;
			}
			goto IL_007c;
		case false:
		case true:
			goto IL_00d1;
			IL_0092:
			num = 1;
			if (num != 0)
			{
			}
			num3 = 0;
			num = 0;
			num4 = num;
			goto IL_007c;
			IL_007c:
			while (true)
			{
				switch (num4)
				{
				case 0:
				case 2:
					goto IL_00d1;
				case 1:
					goto IL_00e6;
				case 3:
					return;
				}
				break;
				IL_00e6:
				if (num3 >= 24)
				{
					num = 3;
					num4 = num;
					continue;
				}
				h(A_0);
				m(A_0);
				r(A_0);
				w(A_0);
				w(A_0, num3);
				num3++;
				num = 2;
				num4 = num;
			}
			goto IL_0092;
			IL_00d1:
			num = 1;
			num4 = num;
			goto IL_007c;
		}
	}

	private void h(ulong[] A_0)
	{
		short num = 0;
		int num2 = num;
		switch (num2)
		{
		default:
		{
			int num3 = default(int);
			switch (0)
			{
			default:
			{
				int num5 = default(int);
				int num7 = default(int);
				ulong num6 = default(ulong);
				int num4 = default(int);
				while (true)
				{
					switch (num2)
					{
					case 1:
					{
						num = 1537;
						short num8 = num;
						num = 1537;
						switch (num8 == num)
						{
						case false:
						case true:
							goto IL_0321;
						}
						num = 0;
						if (num == 0)
						{
						}
						goto case 3;
					}
					case 0:
						num5 = 0;
						num = 9;
						num2 = num;
						continue;
					case 2:
						num5++;
						num = 6;
						num2 = num;
						continue;
					case 10:
						num = 0;
						_ = num;
						goto case 12;
					case 7:
					case 14:
						num = 8;
						num2 = num;
						continue;
					case 8:
						if (num7 < 5)
						{
							A_0[num5 + 5 * num7] ^= num6;
							num7++;
							num = 7;
							num2 = num;
						}
						else
						{
							num = 2;
							num2 = num;
						}
						continue;
					case 6:
					case 9:
						num = 1;
						if (num != 0)
						{
						}
						num = 5;
						num2 = num;
						continue;
					case 5:
						if (num5 >= 5)
						{
							num = 15;
							num2 = num;
							continue;
						}
						num6 = (this.m_m[(num5 + 1) % 5] << 1) ^ (this.m_m[(num5 + 1) % 5] >> 63) ^ this.m_m[(num5 + 4) % 5];
						num7 = 0;
						goto IL_0321;
					case 15:
						return;
					case 3:
						num = 11;
						num2 = num;
						continue;
					case 11:
						if (num3 < 5)
						{
							this.m_m[num3] = 0uL;
							num4 = 0;
							num = 10;
							num2 = num;
						}
						else
						{
							num = 0;
							num2 = num;
						}
						continue;
					case 12:
						num = 13;
						num2 = num;
						continue;
					case 13:
						if (num4 < 5)
						{
							this.m_m[num3] ^= A_0[num3 + 5 * num4];
							num4++;
							num = 12;
							num2 = num;
						}
						else
						{
							num = 4;
							num2 = num;
						}
						continue;
					case 4:
						{
							num3++;
							num = 3;
							num2 = num;
							continue;
						}
						IL_0321:
						num = 14;
						num2 = num;
						continue;
					}
					break;
				}
				goto case 0;
			}
			case 0:
				num3 = 0;
				num = 1;
				num2 = num;
				goto default;
			}
		}
		}
	}

	private void m(ulong[] A_0)
	{
		int num = default(int);
		int num5 = default(int);
		int num6 = default(int);
		int num4 = default(int);
		while (true)
		{
			switch (0)
			{
			default:
				while (true)
				{
					short num2;
					switch (num)
					{
					case 5:
						A_0[num5] = ((KeccakDigest.m_r[num5] == 0) ? A_0[num5] : ((A_0[num5] << KeccakDigest.m_r[num5]) ^ (A_0[num5] >> 64 - KeccakDigest.m_r[num5])));
						num6++;
						num2 = 6;
						num = num2;
						continue;
					case 2:
					case 4:
						num2 = 0;
						num = num2;
						continue;
					case 0:
						goto IL_00bc;
					case 1:
						return;
					case 3:
						num2 = 1;
						if (num2 != 0)
						{
						}
						num4++;
						num2 = 4;
						num = num2;
						continue;
					case 8:
					{
						num2 = -30820;
						short num3 = num2;
						num2 = -30820;
						switch (num3 == num2)
						{
						case false:
						case true:
							break;
						default:
							goto IL_0194;
						}
						goto end_IL_0001;
					}
					case 6:
						num2 = 7;
						num = num2;
						continue;
					case 7:
						goto IL_01e8;
						IL_0194:
						num2 = 0;
						if (num2 == 0)
						{
						}
						goto case 6;
					}
					break;
					IL_01e8:
					if (num6 < 5)
					{
						num2 = 0;
						_ = num2;
						num5 = num4 + 5 * num6;
						num2 = 5;
						num = num2;
					}
					else
					{
						num2 = 3;
						num = num2;
					}
					continue;
					IL_00bc:
					if (num4 >= 5)
					{
						num2 = 1;
						num = num2;
					}
					else
					{
						num6 = 0;
						num2 = 8;
						num = num2;
					}
				}
				goto case 0;
			case 0:
				{
					num4 = 0;
					short num2 = 2;
					num = num2;
					goto default;
				}
				end_IL_0001:
				break;
			}
		}
	}

	private void r(ulong[] A_0)
	{
		short num = 12605;
		short num2 = num;
		num = 12605;
		int num3 = default(int);
		int num4 = default(int);
		int num5 = default(int);
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
			switch (0)
			{
			case 0:
				goto IL_00a1;
			}
			goto IL_007b;
		case false:
		case true:
			goto IL_0167;
			IL_0167:
			num = 5;
			num3 = num;
			goto IL_007b;
			IL_00a1:
			Array.Copy(A_0, 0, this.m_h, 0, this.m_h.Length);
			num4 = 0;
			num = 1;
			num3 = num;
			goto IL_007b;
			IL_007b:
			while (true)
			{
				switch (num3)
				{
				case 3:
					num4++;
					num = 4;
					num3 = num;
					continue;
				case 2:
				case 7:
					num = 0;
					num3 = num;
					continue;
				case 0:
					goto IL_0103;
				case 1:
				case 4:
					goto IL_0167;
				case 5:
					goto IL_017f;
				case 6:
					return;
				}
				break;
				IL_017f:
				if (num4 < 5)
				{
					num5 = 0;
					num = 7;
					num3 = num;
				}
				else
				{
					num = 6;
					num3 = num;
				}
				continue;
				IL_0103:
				if (num5 >= 5)
				{
					num = 0;
					_ = num;
					num = 3;
					num3 = num;
				}
				else
				{
					A_0[num5 + 5 * ((2 * num4 + 3 * num5) % 5)] = this.m_h[num4 + 5 * num5];
					num5++;
					num = 2;
					num3 = num;
				}
			}
			goto IL_00a1;
		}
	}

	private void w(ulong[] A_0)
	{
		int num = default(int);
		int num5 = default(int);
		switch (0)
		{
		default:
		{
			int num6 = default(int);
			int num4 = default(int);
			while (true)
			{
				switch (num)
				{
				case 1:
				case 6:
				{
					short num2 = 5;
					num = num2;
					continue;
				}
				case 5:
				{
					short num2;
					if (num6 >= 5)
					{
						num2 = 8;
						num = num2;
						continue;
					}
					A_0[num6 + 5 * num5] = this.m_c[num6];
					num6++;
					num2 = 6;
					num = num2;
					continue;
				}
				case 8:
				{
					short num2 = 1;
					if (num2 != 0)
					{
					}
					num5++;
					num2 = 9;
					num = num2;
					continue;
				}
				case 3:
				case 9:
				{
					short num2 = 2;
					num = num2;
					continue;
				}
				case 2:
					if (num5 >= 5)
					{
						short num2 = 4;
						num = num2;
					}
					else
					{
						num4 = 0;
						short num2 = 11;
						num = num2;
					}
					continue;
				case 7:
				{
					num6 = 0;
					short num2 = 1;
					num = num2;
					continue;
				}
				case 0:
				case 11:
				{
					short num2 = 10;
					num = num2;
					continue;
				}
				case 10:
					if (num4 < 5)
					{
						this.m_c[num4] = A_0[num4 + 5 * num5] ^ (~A_0[(num4 + 1) % 5 + 5 * num5] & A_0[(num4 + 2) % 5 + 5 * num5]);
						num4++;
						short num2 = 0;
						_ = num2;
						num2 = 0;
						num = num2;
					}
					else
					{
						short num2 = 7;
						num = num2;
					}
					continue;
				case 4:
				{
					short num2 = -21354;
					short num3 = num2;
					num2 = -21354;
					switch (num3 == num2)
					{
					case false:
					case true:
						continue;
					}
					num2 = 0;
					if (num2 == 0)
					{
					}
					return;
				}
				}
				break;
			}
			goto case 0;
		}
		case 0:
		{
			num5 = 0;
			short num2 = 3;
			num = num2;
			goto default;
		}
		}
	}

	private static void w(ulong[] A_0, int A_1)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		num = -4758;
		short num2 = num;
		num = -4758;
		switch (num2 == num)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		A_0[0] ^= KeccakDigest.m_w[A_1];
	}

	private void r(byte[] A_0, byte[] A_1, int A_2)
	{
		short num = -12107;
		short num2 = num;
		num = -12107;
		switch (num2 == num)
		{
		default:
			num = 0;
			_ = num;
			break;
		case true:
			break;
		}
		num = 1;
		if (num != 0)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		m(A_0, A_1, A_2);
	}

	private void w(byte[] A_0, byte[] A_1)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		num = -18601;
		short num2 = num;
		num = -18601;
		switch (num2 == num)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		Array.Copy(A_0, 0, A_1, 0, 128);
	}

	private void w(byte[] A_0, byte[] A_1, int A_2)
	{
		short num = 15023;
		short num2 = num;
		num = 15023;
		switch (num2 == num)
		{
		default:
			num = 0;
			_ = num;
			break;
		case true:
			break;
		}
		num = 0;
		if (num != 0)
		{
		}
		num = 1;
		if (num != 0)
		{
		}
		Array.Copy(A_0, 0, A_1, 0, A_2 * 8);
	}

	static KeccakDigest()
	{
		short num = -9540;
		short num2 = num;
		num = -9540;
		switch (num2 == num)
		{
		default:
			num = 0;
			_ = num;
			break;
		case true:
			break;
		}
		num = 1;
		if (num != 0)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		KeccakDigest.m_w = h();
		KeccakDigest.m_r = m();
	}
}
