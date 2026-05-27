using System;

namespace ODCrypt;

public class MD5
{
	private const int m_w = 16;

	private uint m_r;

	private uint m_m;

	private uint m_h;

	private uint c;

	private uint[] x = new uint[16];

	private int s;

	private const int n = 64;

	private byte[] i;

	private int d;

	private long y;

	private static readonly int t;

	private static readonly int o;

	private static readonly int j;

	private static readonly int e;

	private static readonly int z;

	private static readonly int u;

	private static readonly int p;

	private static readonly int k;

	private static readonly int f;

	private static readonly int a;

	private static readonly int v;

	private static readonly int q;

	private static readonly int l;

	private static readonly int g;

	private static readonly int b;

	private static readonly int w5;

	public string AlgorithmName
	{
		get
		{
			int a_ = 5;
			short num = 6256;
			short num2 = num;
			num = 6256;
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
			return Sha3.b("ᙚᥜ橞", a_);
		}
	}

	public MD5()
	{
		i = new byte[16];
		Reset();
	}

	public MD5(MD5 t)
	{
		w(t);
	}

	public static byte[] Hash(byte[] plaintext)
	{
		short num = -24304;
		short num2 = num;
		num = -24304;
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
		MD5 mD = new MD5();
		mD.BlockUpdate(plaintext, 0, plaintext.Length);
		return DoFinal(mD);
	}

	private void w(MD5 A_0)
	{
		short num = -23959;
		short num2 = num;
		num = -23959;
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
		Array.Copy(A_0.i, 0, i, 0, A_0.i.Length);
		d = A_0.d;
		y = A_0.y;
		this.m_r = A_0.m_r;
		this.m_m = A_0.m_m;
		this.m_h = A_0.m_h;
		c = A_0.c;
		Array.Copy(A_0.x, 0, x, 0, A_0.x.Length);
		s = A_0.s;
	}

	public int GetDigestSize()
	{
		short num = 16970;
		short num2 = num;
		num = 16970;
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
		return 16;
	}

	internal void w(byte[] A_0, int A_1)
	{
		int num = default(int);
		int num3 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				switch (num)
				{
				case 0:
					goto IL_00c9;
				case 2:
				{
					short num2 = 0;
					_ = num2;
					w();
					num2 = 1;
					num = num2;
					continue;
				}
				case 1:
					return;
				}
				break;
			}
			goto case 0;
		case 0:
			{
				x[s] = global::w.r(A_0, A_1);
				num3 = ++s;
				short num2 = -9515;
				short num4 = num2;
				num2 = -9515;
				switch (num4 == num2)
				{
				case false:
				case true:
					goto IL_00c9;
				}
				num2 = 1;
				if (num2 != 0)
				{
				}
				num2 = 0;
				if (num2 != 0)
				{
				}
				num2 = 0;
				num = num2;
				goto default;
			}
			IL_00c9:
			if (num3 == 16)
			{
				short num2 = 2;
				num = num2;
				goto default;
			}
			break;
		}
	}

	internal void w(long A_0)
	{
		short num = 3;
		int num2 = num;
		int num3 = default(int);
		while (true)
		{
			switch (num2)
			{
			case 3:
				switch (0)
				{
				default:
					goto end_IL_0020;
				case 0:
					break;
				}
				goto default;
			default:
				if (s > 14)
				{
					num = 0;
					num2 = num;
					break;
				}
				goto case 1;
			case 8:
				w();
				num = 1;
				num2 = num;
				break;
			case 0:
				num = 2;
				num2 = num;
				break;
			case 2:
				if (s == 15)
				{
					num = 27149;
					short num4 = num;
					num = 27149;
					switch (num4 == num)
					{
					case false:
					case true:
						break;
					default:
						num = 0;
						if (num != 0)
						{
						}
						num = 5;
						num2 = num;
						goto end_IL_0020;
					}
					goto case 3;
				}
				goto case 8;
			case 6:
				num = 9;
				num2 = num;
				break;
			case 9:
				if (num3 < 14)
				{
					x[num3] = 0u;
					num3++;
					num = 6;
					num2 = num;
				}
				else
				{
					num = 4;
					num2 = num;
				}
				break;
			case 5:
				x[15] = 0u;
				num = 8;
				num2 = num;
				break;
			case 1:
				num3 = s;
				num = 7;
				num2 = num;
				break;
			case 7:
				num = 1;
				if (num != 0)
				{
				}
				num = 0;
				_ = num;
				goto case 6;
			case 4:
				{
					x[14] = (uint)A_0;
					x[15] = (uint)((ulong)A_0 >> 32);
					return;
				}
				end_IL_0020:
				break;
			}
		}
	}

	public int DoFinal(byte[] output, int outOff)
	{
		short num = 0;
		_ = num;
		num = -10674;
		short num2 = num;
		num = -10674;
		int num3 = default(int);
		long a_ = default(long);
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
			switch (0)
			{
			case 0:
				goto IL_00bd;
			}
			goto IL_00a7;
		case false:
		case true:
			goto IL_00e8;
			IL_00e8:
			num = 1;
			num3 = num;
			goto IL_00a7;
			IL_00bd:
			a_ = y << 3;
			Update(128);
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
					goto IL_00e8;
				case 1:
					goto IL_00fc;
				case 3:
					w(a_);
					w();
					global::w.w(this.m_r, output, outOff);
					global::w.w(this.m_m, output, outOff + 4);
					global::w.w(this.m_h, output, outOff + 8);
					global::w.w(c, output, outOff + 12);
					Reset();
					return 16;
				}
				break;
				IL_00fc:
				if (d == 0)
				{
					num = 3;
					num3 = num;
				}
				else
				{
					Update(0);
					num = 2;
					num3 = num;
				}
			}
			goto IL_00bd;
		}
	}

	public void Reset()
	{
		short num = 0;
		_ = num;
		num = 14117;
		short num2 = num;
		num = 14117;
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
				goto IL_0095;
			}
			goto IL_007f;
		case false:
		case true:
			goto IL_0107;
			IL_0095:
			y = 0L;
			d = 0;
			Array.Clear(i, 0, i.Length);
			this.m_r = 1732584193u;
			this.m_m = 4023233417u;
			this.m_h = 2562383102u;
			c = 271733878u;
			s = 0;
			num3 = 0;
			num = 0;
			num4 = num;
			goto IL_007f;
			IL_007f:
			while (true)
			{
				switch (num4)
				{
				case 0:
				case 2:
					goto IL_0107;
				case 1:
					goto IL_011e;
				case 3:
					num = 1;
					if (num == 0)
					{
					}
					return;
				}
				break;
				IL_011e:
				if (num3 == x.Length)
				{
					num = 3;
					num4 = num;
					continue;
				}
				x[num3] = 0u;
				num3++;
				num = 2;
				num4 = num;
			}
			goto IL_0095;
			IL_0107:
			num = 1;
			num4 = num;
			goto IL_007f;
		}
	}

	private static uint w(uint A_0, int A_1)
	{
		short num = -5136;
		short num2 = num;
		num = -5136;
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
		return (A_0 << A_1) | (A_0 >> 32 - A_1);
	}

	private static uint h(uint A_0, uint A_1, uint A_2)
	{
		short num = 23463;
		short num2 = num;
		num = 23463;
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
		return (A_0 & A_1) | (~A_0 & A_2);
	}

	private static uint m(uint A_0, uint A_1, uint A_2)
	{
		short num = -16043;
		short num2 = num;
		num = -16043;
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
		return (A_0 & A_2) | (A_1 & ~A_2);
	}

	private static uint r(uint A_0, uint A_1, uint A_2)
	{
		short num = -1607;
		short num2 = num;
		num = -1607;
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
		return A_0 ^ A_1 ^ A_2;
	}

	private static uint w(uint A_0, uint A_1, uint A_2)
	{
		short num = -8110;
		short num2 = num;
		num = -8110;
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
			return A_1 ^ (A_0 | ~A_2);
		}
	}

	internal void w()
	{
		short num = -26762;
		short num2 = num;
		num = -26762;
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
		uint num3 = this.m_r;
		uint num4 = this.m_m;
		uint num5 = this.m_h;
		uint num6 = c;
		num3 = w(num3 + h(num4, num5, num6) + x[0] + 3614090360u, t) + num4;
		num6 = w(num6 + h(num3, num4, num5) + x[1] + 3905402710u, o) + num3;
		num5 = w(num5 + h(num6, num3, num4) + x[2] + 606105819, j) + num6;
		num4 = w(num4 + h(num5, num6, num3) + x[3] + 3250441966u, e) + num5;
		num3 = w(num3 + h(num4, num5, num6) + x[4] + 4118548399u, t) + num4;
		num6 = w(num6 + h(num3, num4, num5) + x[5] + 1200080426, o) + num3;
		num5 = w(num5 + h(num6, num3, num4) + x[6] + 2821735955u, j) + num6;
		num4 = w(num4 + h(num5, num6, num3) + x[7] + 4249261313u, e) + num5;
		num3 = w(num3 + h(num4, num5, num6) + x[8] + 1770035416, t) + num4;
		num6 = w(num6 + h(num3, num4, num5) + x[9] + 2336552879u, o) + num3;
		num5 = w(num5 + h(num6, num3, num4) + x[10] + 4294925233u, j) + num6;
		num4 = w(num4 + h(num5, num6, num3) + x[11] + 2304563134u, e) + num5;
		num3 = w(num3 + h(num4, num5, num6) + x[12] + 1804603682, t) + num4;
		num6 = w(num6 + h(num3, num4, num5) + x[13] + 4254626195u, o) + num3;
		num5 = w(num5 + h(num6, num3, num4) + x[14] + 2792965006u, j) + num6;
		num4 = w(num4 + h(num5, num6, num3) + x[15] + 1236535329, e) + num5;
		num3 = w(num3 + m(num4, num5, num6) + x[1] + 4129170786u, z) + num4;
		num6 = w(num6 + m(num3, num4, num5) + x[6] + 3225465664u, u) + num3;
		num5 = w(num5 + m(num6, num3, num4) + x[11] + 643717713, p) + num6;
		num4 = w(num4 + m(num5, num6, num3) + x[0] + 3921069994u, k) + num5;
		num3 = w(num3 + m(num4, num5, num6) + x[5] + 3593408605u, z) + num4;
		num6 = w(num6 + m(num3, num4, num5) + x[10] + 38016083, u) + num3;
		num5 = w(num5 + m(num6, num3, num4) + x[15] + 3634488961u, p) + num6;
		num4 = w(num4 + m(num5, num6, num3) + x[4] + 3889429448u, k) + num5;
		num3 = w(num3 + m(num4, num5, num6) + x[9] + 568446438, z) + num4;
		num6 = w(num6 + m(num3, num4, num5) + x[14] + 3275163606u, u) + num3;
		num5 = w(num5 + m(num6, num3, num4) + x[3] + 4107603335u, p) + num6;
		num4 = w(num4 + m(num5, num6, num3) + x[8] + 1163531501, k) + num5;
		num3 = w(num3 + m(num4, num5, num6) + x[13] + 2850285829u, z) + num4;
		num6 = w(num6 + m(num3, num4, num5) + x[2] + 4243563512u, u) + num3;
		num5 = w(num5 + m(num6, num3, num4) + x[7] + 1735328473, p) + num6;
		num4 = w(num4 + m(num5, num6, num3) + x[12] + 2368359562u, k) + num5;
		num3 = w(num3 + r(num4, num5, num6) + x[5] + 4294588738u, f) + num4;
		num6 = w(num6 + r(num3, num4, num5) + x[8] + 2272392833u, a) + num3;
		num5 = w(num5 + r(num6, num3, num4) + x[11] + 1839030562, v) + num6;
		num4 = w(num4 + r(num5, num6, num3) + x[14] + 4259657740u, q) + num5;
		num3 = w(num3 + r(num4, num5, num6) + x[1] + 2763975236u, f) + num4;
		num6 = w(num6 + r(num3, num4, num5) + x[4] + 1272893353, a) + num3;
		num5 = w(num5 + r(num6, num3, num4) + x[7] + 4139469664u, v) + num6;
		num4 = w(num4 + r(num5, num6, num3) + x[10] + 3200236656u, q) + num5;
		num3 = w(num3 + r(num4, num5, num6) + x[13] + 681279174, f) + num4;
		num6 = w(num6 + r(num3, num4, num5) + x[0] + 3936430074u, a) + num3;
		num5 = w(num5 + r(num6, num3, num4) + x[3] + 3572445317u, v) + num6;
		num4 = w(num4 + r(num5, num6, num3) + x[6] + 76029189, q) + num5;
		num3 = w(num3 + r(num4, num5, num6) + x[9] + 3654602809u, f) + num4;
		num6 = w(num6 + r(num3, num4, num5) + x[12] + 3873151461u, a) + num3;
		num5 = w(num5 + r(num6, num3, num4) + x[15] + 530742520, v) + num6;
		num4 = w(num4 + r(num5, num6, num3) + x[2] + 3299628645u, q) + num5;
		num3 = w(num3 + w(num4, num5, num6) + x[0] + 4096336452u, l) + num4;
		num6 = w(num6 + w(num3, num4, num5) + x[7] + 1126891415, g) + num3;
		num5 = w(num5 + w(num6, num3, num4) + x[14] + 2878612391u, b) + num6;
		num4 = w(num4 + w(num5, num6, num3) + x[5] + 4237533241u, w5) + num5;
		num3 = w(num3 + w(num4, num5, num6) + x[12] + 1700485571, l) + num4;
		num6 = w(num6 + w(num3, num4, num5) + x[3] + 2399980690u, g) + num3;
		num5 = w(num5 + w(num6, num3, num4) + x[10] + 4293915773u, b) + num6;
		num4 = w(num4 + w(num5, num6, num3) + x[1] + 2240044497u, w5) + num5;
		num3 = w(num3 + w(num4, num5, num6) + x[8] + 1873313359, l) + num4;
		num6 = w(num6 + w(num3, num4, num5) + x[15] + 4264355552u, g) + num3;
		num5 = w(num5 + w(num6, num3, num4) + x[6] + 2734768916u, b) + num6;
		num4 = w(num4 + w(num5, num6, num3) + x[13] + 1309151649, w5) + num5;
		num3 = w(num3 + w(num4, num5, num6) + x[4] + 4149444226u, l) + num4;
		num6 = w(num6 + w(num3, num4, num5) + x[11] + 3174756917u, g) + num3;
		num5 = w(num5 + w(num6, num3, num4) + x[2] + 718787259, b) + num6;
		num4 = w(num4 + w(num5, num6, num3) + x[9] + 3951481745u, w5) + num5;
		this.m_r += num3;
		this.m_m += num4;
		this.m_h += num5;
		c += num6;
		s = 0;
	}

	public MD5 Copy()
	{
		short num = -4322;
		short num2 = num;
		num = -4322;
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
			return new MD5(this);
		}
	}

	public void Reset(MD5 other)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 18867;
		short num2 = num;
		num = 18867;
		switch (num2 == num)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		w(other);
	}

	public void Update(byte input)
	{
		int num3 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				short num = 21119;
				short num2 = num;
				num = 21119;
				switch (num2 == num)
				{
				default:
					num = 0;
					if (num != 0)
					{
					}
					switch (num3)
					{
					case 1:
						if (d == i.Length)
						{
							num = 2;
							num3 = num;
							continue;
						}
						goto case 0;
					case 2:
						num = 1;
						if (num != 0)
						{
						}
						w(i, 0);
						d = 0;
						num = 0;
						_ = num;
						num = 0;
						num3 = num;
						continue;
					case 0:
						y++;
						return;
					}
					break;
				case false:
				case true:
					break;
				}
				break;
			}
			goto case 0;
		case 0:
		{
			i[d++] = input;
			short num = 1;
			num3 = num;
			goto default;
		}
		}
	}

	public void BlockUpdate(byte[] input, int inOff, int length)
	{
		int num = default(int);
		int num4 = default(int);
		switch (0)
		{
		default:
		{
			int num5 = default(int);
			while (true)
			{
				short num2;
				switch (num)
				{
				case 7:
					if (d != 0)
					{
						num2 = 8;
						num = num2;
						continue;
					}
					goto case 0;
				case 9:
					num2 = 4;
					num = num2;
					continue;
				case 13:
					if (d == 4)
					{
						num2 = 14;
						num = num2;
						continue;
					}
					goto IL_0230;
				case 8:
					num2 = 15;
					num = num2;
					continue;
				case 15:
					num2 = 1;
					if (num2 == 0)
					{
					}
					goto IL_0230;
				case 2:
				case 3:
					num2 = 11;
					num = num2;
					continue;
				case 11:
					if (num4 < num5)
					{
						w(input, inOff + num4);
						num4 += 4;
						num2 = 3;
						num = num2;
					}
					else
					{
						num2 = 9;
						num = num2;
					}
					continue;
				case 4:
				case 12:
					num2 = 1;
					num = num2;
					continue;
				case 1:
					if (num4 < length)
					{
						i[d++] = input[inOff + num4++];
						num2 = 12;
						num = num2;
					}
					else
					{
						num2 = 6;
						num = num2;
					}
					continue;
				case 10:
					if (num4 < length)
					{
						i[d++] = input[inOff + num4++];
						num2 = 13;
						num = num2;
					}
					else
					{
						num2 = 5;
						num = num2;
					}
					continue;
				case 5:
				{
					num2 = -19194;
					short num3 = num2;
					num2 = -19194;
					switch (num3 == num2)
					{
					case false:
					case true:
						goto IL_02b3;
					}
					num2 = 0;
					if (num2 == 0)
					{
					}
					goto case 0;
				}
				case 14:
					goto IL_02b3;
				case 0:
					num5 = ((length - num4) & -4) + num4;
					num2 = 2;
					num = num2;
					continue;
				case 6:
					{
						y += length;
						return;
					}
					IL_02b3:
					w(i, 0);
					d = 0;
					num2 = 0;
					_ = num2;
					num2 = 0;
					num = num2;
					continue;
					IL_0230:
					num2 = 10;
					num = num2;
					continue;
				}
				break;
			}
			goto case 0;
		}
		case 0:
		{
			length = Math.Max(0, length);
			num4 = 0;
			short num2 = 7;
			num = num2;
			goto default;
		}
		}
	}

	public static byte[] DoFinal(MD5 digest)
	{
		short num = -23252;
		short num2 = num;
		num = -23252;
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
			byte[] array = new byte[digest.GetDigestSize()];
			digest.DoFinal(array, 0);
			return array;
		}
		}
	}

	static MD5()
	{
		short num = 18322;
		short num2 = num;
		num = 18322;
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
		t = 7;
		o = 12;
		j = 17;
		e = 22;
		z = 5;
		u = 9;
		p = 14;
		k = 20;
		f = 4;
		a = 11;
		v = 16;
		q = 23;
		l = 6;
		g = 10;
		b = 15;
		w5 = 21;
	}
}
