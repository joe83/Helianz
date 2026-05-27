internal sealed class w
{
	private w()
	{
	}

	internal static void r(ushort A_0, byte[] A_1)
	{
		short num = 27878;
		short num2 = num;
		num = 27878;
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
		A_1[0] = (byte)(A_0 >> 8);
		A_1[1] = (byte)A_0;
	}

	internal static void r(ushort A_0, byte[] A_1, int A_2)
	{
		short num = 18307;
		short num2 = num;
		num = 18307;
		switch (num2 == num)
		{
		}
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
		A_1[A_2] = (byte)(A_0 >> 8);
		A_1[A_2 + 1] = (byte)A_0;
	}

	internal static ushort x(byte[] A_0)
	{
		short num = 29032;
		short num2 = num;
		num = 29032;
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
			return (ushort)((A_0[0] << 8) | A_0[1]);
		}
	}

	internal static ushort x(byte[] A_0, int A_1)
	{
		short num = -28519;
		short num2 = num;
		num = -28519;
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
			return (ushort)((A_0[A_1] << 8) | A_0[A_1 + 1]);
		}
	}

	internal static byte[] r(uint A_0)
	{
		short num = -26907;
		short num2 = num;
		num = -26907;
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
			byte[] array = new byte[4];
			r(A_0, array, 0);
			return array;
		}
		}
	}

	internal static void r(uint A_0, byte[] A_1)
	{
		short num = 15077;
		short num2 = num;
		num = 15077;
		switch (num2 == num)
		{
		}
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
		A_1[0] = (byte)(A_0 >> 24);
		A_1[1] = (byte)(A_0 >> 16);
		A_1[2] = (byte)(A_0 >> 8);
		A_1[3] = (byte)A_0;
	}

	internal static void r(uint A_0, byte[] A_1, int A_2)
	{
		short num = -8886;
		short num2 = num;
		num = -8886;
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
		A_1[A_2] = (byte)(A_0 >> 24);
		A_1[A_2 + 1] = (byte)(A_0 >> 16);
		A_1[A_2 + 2] = (byte)(A_0 >> 8);
		A_1[A_2 + 3] = (byte)A_0;
	}

	internal static byte[] r(uint[] A_0)
	{
		short num = -14690;
		short num2 = num;
		num = -14690;
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
			byte[] array = new byte[4 * A_0.Length];
			r(A_0, array, 0);
			return array;
		}
		}
	}

	internal static void r(uint[] A_0, byte[] A_1, int A_2)
	{
		int num = default(int);
		int num4 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				short num2;
				switch (num)
				{
				case 1:
					num2 = 3;
					num = num2;
					continue;
				case 3:
					if (num4 >= A_0.Length)
					{
						num2 = 0;
						num = num2;
						continue;
					}
					r(A_0[num4], A_1, A_2);
					A_2 += 4;
					num4++;
					goto IL_007d;
				case 2:
					num2 = 0;
					_ = num2;
					goto case 1;
				case 0:
					{
						num2 = 8147;
						short num3 = num2;
						num2 = 8147;
						switch (num3 == num2)
						{
						case false:
						case true:
							break;
						default:
							num2 = 1;
							if (num2 != 0)
							{
							}
							num2 = 0;
							if (num2 == 0)
							{
							}
							return;
						}
						goto IL_007d;
					}
					IL_007d:
					num2 = 2;
					num = num2;
					continue;
				}
				break;
			}
			goto case 0;
		case 0:
		{
			num4 = 0;
			short num2 = 1;
			num = num2;
			goto default;
		}
		}
	}

	internal static uint c(byte[] A_0)
	{
		short num = 31082;
		short num2 = num;
		num = 31082;
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
			return (uint)((A_0[0] << 24) | (A_0[1] << 16) | (A_0[2] << 8) | A_0[3]);
		}
	}

	internal static uint c(byte[] A_0, int A_1)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 31101;
		short num2 = num;
		num = 31101;
		switch (num2 == num)
		{
		default:
			num = 0;
			if (num != 0)
			{
			}
			num = 0;
			_ = num;
			return (uint)((A_0[A_1] << 24) | (A_0[A_1 + 1] << 16) | (A_0[A_1 + 2] << 8) | A_0[A_1 + 3]);
		}
	}

	internal static void r(byte[] A_0, int A_1, uint[] A_2)
	{
		int num = default(int);
		int num4 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				short num2;
				switch (num)
				{
				case 1:
				case 2:
					num2 = 3;
					num = num2;
					continue;
				case 3:
					num2 = 1;
					if (num2 != 0)
					{
					}
					if (num4 >= A_2.Length)
					{
						num2 = 0;
						num = num2;
						continue;
					}
					A_2[num4] = c(A_0, A_1);
					A_1 += 4;
					num4++;
					goto IL_00bd;
				case 0:
					{
						num2 = -30818;
						short num3 = num2;
						num2 = -30818;
						switch (num3 == num2)
						{
						case false:
						case true:
							break;
						default:
							num2 = 0;
							if (num2 == 0)
							{
							}
							return;
						}
						goto IL_00bd;
					}
					IL_00bd:
					num2 = 0;
					_ = num2;
					num2 = 2;
					num = num2;
					continue;
				}
				break;
			}
			goto case 0;
		case 0:
		{
			num4 = 0;
			short num2 = 1;
			num = num2;
			goto default;
		}
		}
	}

	internal static byte[] r(ulong A_0)
	{
		short num = -1297;
		short num2 = num;
		num = -1297;
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
			byte[] array = new byte[8];
			r(A_0, array, 0);
			return array;
		}
		}
	}

	internal static void r(ulong A_0, byte[] A_1)
	{
		short num = -11157;
		short num2 = num;
		num = -11157;
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
		r((uint)(A_0 >> 32), A_1);
		r((uint)A_0, A_1, 4);
	}

	internal static void r(ulong A_0, byte[] A_1, int A_2)
	{
		short num = 25385;
		short num2 = num;
		num = 25385;
		switch (num2 == num)
		{
		}
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
		r((uint)(A_0 >> 32), A_1, A_2);
		r((uint)A_0, A_1, A_2 + 4);
	}

	internal static byte[] w(ulong[] A_0)
	{
		short num = 20191;
		short num2 = num;
		num = 20191;
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
			byte[] array = new byte[8 * A_0.Length];
			w(A_0, array, 0);
			return array;
		}
		}
	}

	internal static void w(ulong[] A_0, byte[] A_1, int A_2)
	{
		int num = default(int);
		int num4 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				short num2;
				switch (num)
				{
				case 1:
					num2 = 3;
					num = num2;
					continue;
				case 3:
					if (num4 >= A_0.Length)
					{
						num2 = 0;
						num = num2;
						continue;
					}
					r(A_0[num4], A_1, A_2);
					A_2 += 8;
					num4++;
					goto IL_007e;
				case 2:
					num2 = 0;
					_ = num2;
					num2 = 1;
					if (num2 == 0)
					{
					}
					goto case 1;
				case 0:
					{
						num2 = -29713;
						short num3 = num2;
						num2 = -29713;
						switch (num3 == num2)
						{
						case false:
						case true:
							break;
						default:
							num2 = 0;
							if (num2 == 0)
							{
							}
							return;
						}
						goto IL_007e;
					}
					IL_007e:
					num2 = 2;
					num = num2;
					continue;
				}
				break;
			}
			goto case 0;
		case 0:
		{
			num4 = 0;
			short num2 = 1;
			num = num2;
			goto default;
		}
		}
	}

	internal static ulong h(byte[] A_0)
	{
		short num = -2802;
		short num2 = num;
		num = -2802;
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
			uint num3 = c(A_0);
			uint num4 = c(A_0, 4);
			return ((ulong)num3 << 32) | num4;
		}
		}
	}

	internal static ulong h(byte[] A_0, int A_1)
	{
		short num = 22169;
		short num2 = num;
		num = 22169;
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
			uint num3 = c(A_0, A_1);
			uint num4 = c(A_0, A_1 + 4);
			return ((ulong)num3 << 32) | num4;
		}
		}
	}

	internal static void w(byte[] A_0, int A_1, ulong[] A_2)
	{
		int num = default(int);
		int num4 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				short num2;
				switch (num)
				{
				case 1:
					num2 = 3;
					num = num2;
					continue;
				case 3:
					if (num4 >= A_2.Length)
					{
						num2 = 0;
						num = num2;
						continue;
					}
					A_2[num4] = h(A_0, A_1);
					A_1 += 8;
					num4++;
					goto IL_007b;
				case 2:
					num2 = 0;
					_ = num2;
					goto case 1;
				case 0:
					{
						num2 = 530;
						short num3 = num2;
						num2 = 530;
						switch (num3 == num2)
						{
						case false:
						case true:
							break;
						default:
							num2 = 1;
							if (num2 != 0)
							{
							}
							num2 = 0;
							if (num2 == 0)
							{
							}
							return;
						}
						goto IL_007b;
					}
					IL_007b:
					num2 = 2;
					num = num2;
					continue;
				}
				break;
			}
			goto case 0;
		case 0:
		{
			num4 = 0;
			short num2 = 1;
			num = num2;
			goto default;
		}
		}
	}

	internal static void w(ushort A_0, byte[] A_1)
	{
		short num = -32694;
		short num2 = num;
		num = -32694;
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
		A_1[0] = (byte)A_0;
		A_1[1] = (byte)(A_0 >> 8);
	}

	internal static void w(ushort A_0, byte[] A_1, int A_2)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = -23378;
		short num2 = num;
		num = -23378;
		switch (num2 == num)
		{
		}
		num = 0;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		A_1[A_2] = (byte)A_0;
		A_1[A_2 + 1] = (byte)(A_0 >> 8);
	}

	internal static ushort m(byte[] A_0)
	{
		short num = 18760;
		short num2 = num;
		num = 18760;
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
			return (ushort)(A_0[0] | (A_0[1] << 8));
		}
	}

	internal static ushort m(byte[] A_0, int A_1)
	{
		short num = -15840;
		short num2 = num;
		num = -15840;
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
			return (ushort)(A_0[A_1] | (A_0[A_1 + 1] << 8));
		}
	}

	internal static byte[] w(uint A_0)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 14545;
		short num2 = num;
		num = 14545;
		switch (num2 == num)
		{
		default:
		{
			num = 0;
			if (num != 0)
			{
			}
			num = 0;
			_ = num;
			byte[] array = new byte[4];
			w(A_0, array, 0);
			return array;
		}
		}
	}

	internal static void w(uint A_0, byte[] A_1)
	{
		short num = 13091;
		short num2 = num;
		num = 13091;
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
		A_1[0] = (byte)A_0;
		A_1[1] = (byte)(A_0 >> 8);
		A_1[2] = (byte)(A_0 >> 16);
		A_1[3] = (byte)(A_0 >> 24);
	}

	internal static void w(uint A_0, byte[] A_1, int A_2)
	{
		short num = 9646;
		short num2 = num;
		num = 9646;
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
		A_1[A_2] = (byte)A_0;
		A_1[A_2 + 1] = (byte)(A_0 >> 8);
		A_1[A_2 + 2] = (byte)(A_0 >> 16);
		A_1[A_2 + 3] = (byte)(A_0 >> 24);
	}

	internal static byte[] w(uint[] A_0)
	{
		short num = -4059;
		short num2 = num;
		num = -4059;
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
			byte[] array = new byte[4 * A_0.Length];
			w(A_0, array, 0);
			return array;
		}
		}
	}

	internal static void w(uint[] A_0, byte[] A_1, int A_2)
	{
		int num = default(int);
		int num4 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				short num2;
				switch (num)
				{
				case 1:
					num2 = 3;
					num = num2;
					continue;
				case 3:
					if (num4 >= A_0.Length)
					{
						num2 = 0;
						num = num2;
						continue;
					}
					w(A_0[num4], A_1, A_2);
					A_2 += 4;
					num4++;
					goto IL_007d;
				case 2:
					num2 = 0;
					_ = num2;
					goto case 1;
				case 0:
					{
						num2 = 16927;
						short num3 = num2;
						num2 = 16927;
						switch (num3 == num2)
						{
						case false:
						case true:
							break;
						default:
							num2 = 1;
							if (num2 != 0)
							{
							}
							num2 = 0;
							if (num2 == 0)
							{
							}
							return;
						}
						goto IL_007d;
					}
					IL_007d:
					num2 = 2;
					num = num2;
					continue;
				}
				break;
			}
			goto case 0;
		case 0:
		{
			num4 = 0;
			short num2 = 1;
			num = num2;
			goto default;
		}
		}
	}

	internal static uint r(byte[] A_0)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 25315;
		short num2 = num;
		num = 25315;
		switch (num2 == num)
		{
		default:
			num = 0;
			if (num != 0)
			{
			}
			num = 0;
			_ = num;
			return (uint)(A_0[0] | (A_0[1] << 8) | (A_0[2] << 16) | (A_0[3] << 24));
		}
	}

	internal static uint r(byte[] A_0, int A_1)
	{
		short num = -25877;
		short num2 = num;
		num = -25877;
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
			return (uint)(A_0[A_1] | (A_0[A_1 + 1] << 8) | (A_0[A_1 + 2] << 16) | (A_0[A_1 + 3] << 24));
		}
	}

	internal static void w(byte[] A_0, int A_1, uint[] A_2)
	{
		short num = 1;
		if (num != 0)
		{
		}
		int num2 = default(int);
		int num4 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				switch (num2)
				{
				case 1:
				case 2:
					num = 3;
					num2 = num;
					continue;
				case 3:
					if (num4 >= A_2.Length)
					{
						num = 0;
						num2 = num;
						continue;
					}
					A_2[num4] = r(A_0, A_1);
					A_1 += 4;
					num4++;
					goto IL_00ba;
				case 0:
					{
						num = 7086;
						short num3 = num;
						num = 7086;
						switch (num3 == num)
						{
						case false:
						case true:
							break;
						default:
							num = 0;
							if (num == 0)
							{
							}
							return;
						}
						goto IL_00ba;
					}
					IL_00ba:
					num = 0;
					_ = num;
					num = 2;
					num2 = num;
					continue;
				}
				break;
			}
			goto case 0;
		case 0:
			num4 = 0;
			num = 1;
			num2 = num;
			goto default;
		}
	}

	internal static void w(byte[] A_0, int A_1, uint[] A_2, int A_3, int A_4)
	{
		int num = default(int);
		int num4 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				short num2;
				switch (num)
				{
				case 1:
					num2 = 3;
					num = num2;
					continue;
				case 3:
					if (num4 >= A_4)
					{
						num2 = 0;
						num = num2;
						continue;
					}
					A_2[A_3 + num4] = r(A_0, A_1);
					A_1 += 4;
					num4++;
					goto IL_007e;
				case 2:
					num2 = 0;
					_ = num2;
					goto case 1;
				case 0:
					{
						num2 = 4651;
						short num3 = num2;
						num2 = 4651;
						switch (num3 == num2)
						{
						case false:
						case true:
							break;
						default:
							num2 = 1;
							if (num2 != 0)
							{
							}
							num2 = 0;
							if (num2 == 0)
							{
							}
							return;
						}
						goto IL_007e;
					}
					IL_007e:
					num2 = 2;
					num = num2;
					continue;
				}
				break;
			}
			goto case 0;
		case 0:
		{
			num4 = 0;
			short num2 = 1;
			num = num2;
			goto default;
		}
		}
	}

	internal static byte[] w(ulong A_0)
	{
		short num = -3300;
		short num2 = num;
		num = -3300;
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
			byte[] array = new byte[8];
			w(A_0, array, 0);
			return array;
		}
		}
	}

	internal static void w(ulong A_0, byte[] A_1)
	{
		short num = 28118;
		short num2 = num;
		num = 28118;
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
		w((uint)A_0, A_1);
		w((uint)(A_0 >> 32), A_1, 4);
	}

	internal static void w(ulong A_0, byte[] A_1, int A_2)
	{
		short num = 22925;
		short num2 = num;
		num = 22925;
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
		w((uint)A_0, A_1, A_2);
		w((uint)(A_0 >> 32), A_1, A_2 + 4);
	}

	internal static ulong w(byte[] A_0)
	{
		short num = 12544;
		short num2 = num;
		num = 12544;
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
			uint num3 = r(A_0);
			return ((ulong)r(A_0, 4) << 32) | num3;
		}
		}
	}

	internal static ulong w(byte[] A_0, int A_1)
	{
		short num = -30762;
		short num2 = num;
		num = -30762;
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
			uint num3 = r(A_0, A_1);
			return ((ulong)r(A_0, A_1 + 4) << 32) | num3;
		}
		}
	}
}
