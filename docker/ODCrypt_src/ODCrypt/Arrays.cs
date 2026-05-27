using System;
using System.Text;

namespace ODCrypt;

public abstract class Arrays
{
	public static bool AreEqual(bool[] a, bool[] b)
	{
		short num = 4;
		int num2 = num;
		while (true)
		{
			switch (num2)
			{
			case 4:
				switch (0)
				{
				default:
					continue;
				case 0:
					break;
				}
				goto default;
			default:
				if (a == b)
				{
					num = 3;
					num2 = num;
				}
				else
				{
					num = 0;
					num2 = num;
				}
				continue;
			case 3:
				num = 1;
				if (num != 0)
				{
				}
				return true;
			case 5:
				num = 1;
				num2 = num;
				continue;
			case 1:
				if (b == null)
				{
					num = 2;
					num2 = num;
					continue;
				}
				return w(a, b);
			case 2:
			{
				num = 9732;
				short num3 = num;
				num = 9732;
				switch (num3 == num)
				{
				case false:
				case true:
					break;
				default:
					goto IL_00eb;
				}
				goto case 5;
			}
			case 0:
				{
					if (a != null)
					{
						num = 0;
						_ = num;
						num = 5;
						num2 = num;
						continue;
					}
					break;
				}
				IL_00eb:
				num = 0;
				if (num == 0)
				{
				}
				break;
			}
			break;
		}
		return false;
	}

	public static bool AreEqual(char[] a, char[] b)
	{
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
					continue;
				case 0:
					break;
				}
				goto default;
			default:
				if (a == b)
				{
					num = 0;
					num2 = num;
				}
				else
				{
					num = 5;
					num2 = num;
				}
				continue;
			case 2:
				num = 1;
				if (num != 0)
				{
				}
				num = 4;
				num2 = num;
				continue;
			case 4:
				if (b == null)
				{
					num = 3;
					num2 = num;
					continue;
				}
				return w(a, b);
			case 3:
			{
				num = -3552;
				short num3 = num;
				num = -3552;
				switch (num3 == num)
				{
				case false:
				case true:
					break;
				default:
					goto IL_00ec;
				}
				goto case 2;
			}
			case 5:
				if (a != null)
				{
					num = 0;
					_ = num;
					num = 2;
					num2 = num;
					continue;
				}
				break;
			case 0:
				{
					return true;
				}
				IL_00ec:
				num = 0;
				if (num == 0)
				{
				}
				break;
			}
			break;
		}
		return false;
	}

	public static bool AreEqual(byte[] a, byte[] b)
	{
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
					continue;
				case 0:
					break;
				}
				goto default;
			default:
				if (a == b)
				{
					num = 0;
					num2 = num;
				}
				else
				{
					num = 5;
					num2 = num;
				}
				continue;
			case 4:
				if (b == null)
				{
					num = 3;
					num2 = num;
					continue;
				}
				return w(a, b);
			case 5:
			{
				num = 22311;
				short num3 = num;
				num = 22311;
				switch (num3 == num)
				{
				case false:
				case true:
					break;
				default:
					goto IL_00dd;
				}
				goto case 4;
			}
			case 2:
				num = 0;
				_ = num;
				num = 4;
				num2 = num;
				continue;
			case 0:
				return true;
			case 3:
				break;
				IL_00dd:
				num = 0;
				if (num != 0)
				{
				}
				if (a != null)
				{
					num = 1;
					if (num != 0)
					{
					}
					num = 2;
					num2 = num;
					continue;
				}
				break;
			}
			break;
		}
		return false;
	}

	[Obsolete("Use 'AreEqual' method instead")]
	public static bool AreSame(byte[] a, byte[] b)
	{
		short num = -10326;
		short num2 = num;
		num = -10326;
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
		return AreEqual(a, b);
	}

	public static bool ConstantTimeAreEqual(byte[] a, byte[] b)
	{
		int num = default(int);
		int num5 = default(int);
		switch (0)
		{
		default:
		{
			int num4 = default(int);
			while (true)
			{
				short num2;
				switch (num)
				{
				case 5:
					if (num5 != b.Length)
					{
						num2 = 1;
						num = num2;
						continue;
					}
					num4 = 0;
					num2 = 0;
					_ = num2;
					num2 = 2;
					num = num2;
					continue;
				case 1:
					return false;
				case 0:
				case 2:
					num2 = 3;
					num = num2;
					continue;
				case 3:
					if (num5 == 0)
					{
						num2 = 1;
						if (num2 != 0)
						{
						}
						num2 = 4;
						num = num2;
						continue;
					}
					goto IL_005e;
				case 4:
					{
						num2 = 27298;
						short num3 = num2;
						num2 = 27298;
						switch (num3 == num2)
						{
						case false:
						case true:
							break;
						default:
							num2 = 0;
							if (num2 != 0)
							{
							}
							return num4 == 0;
						}
						goto IL_005e;
					}
					IL_005e:
					num5--;
					num4 |= a[num5] ^ b[num5];
					num2 = 0;
					num = num2;
					continue;
				}
				break;
			}
			goto case 0;
		}
		case 0:
		{
			num5 = a.Length;
			short num2 = 5;
			num = num2;
			goto default;
		}
		}
	}

	public static bool AreEqual(int[] a, int[] b)
	{
		short num = 5;
		int num2 = num;
		while (true)
		{
			switch (num2)
			{
			case 5:
				switch (0)
				{
				default:
					continue;
				case 0:
					break;
				}
				goto default;
			default:
				if (a == b)
				{
					num = 1;
					num2 = num;
				}
				else
				{
					num = 3;
					num2 = num;
				}
				continue;
			case 0:
				if (b == null)
				{
					num = 2;
					num2 = num;
					continue;
				}
				return w(a, b);
			case 3:
			{
				num = 12508;
				short num3 = num;
				num = 12508;
				switch (num3 == num)
				{
				case false:
				case true:
					break;
				default:
					goto IL_0104;
				}
				goto case 0;
			}
			case 4:
				num = 0;
				_ = num;
				num = 1;
				if (num != 0)
				{
				}
				num = 0;
				num2 = num;
				continue;
			case 1:
				return true;
			case 2:
				break;
				IL_0104:
				num = 0;
				if (num != 0)
				{
				}
				if (a != null)
				{
					num = 4;
					num2 = num;
					continue;
				}
				break;
			}
			break;
		}
		return false;
	}

	public static bool AreEqual(uint[] a, uint[] b)
	{
		short num = 5;
		int num2 = num;
		while (true)
		{
			switch (num2)
			{
			case 5:
				switch (0)
				{
				default:
					continue;
				case 0:
					break;
				}
				goto default;
			default:
				if (a == b)
				{
					num = 1;
					num2 = num;
				}
				else
				{
					num = 3;
					num2 = num;
				}
				continue;
			case 1:
				num = 1;
				if (num != 0)
				{
				}
				return true;
			case 0:
				if (b == null)
				{
					num = 2;
					num2 = num;
					continue;
				}
				return w(a, b);
			case 3:
			{
				num = -22726;
				short num3 = num;
				num = -22726;
				switch (num3 == num)
				{
				case false:
				case true:
					break;
				default:
					goto IL_0107;
				}
				goto case 0;
			}
			case 4:
				num = 0;
				_ = num;
				num = 0;
				num2 = num;
				continue;
			case 2:
				break;
				IL_0107:
				num = 0;
				if (num != 0)
				{
				}
				if (a != null)
				{
					num = 4;
					num2 = num;
					continue;
				}
				break;
			}
			break;
		}
		return false;
	}

	private static bool w(bool[] A_0, bool[] A_1)
	{
		switch (0)
		{
		case 0:
			goto IL_0028;
		}
		goto IL_000a;
		IL_000a:
		int num = default(int);
		int num4 = default(int);
		short num2;
		while (true)
		{
			switch (num)
			{
			case 5:
				if (num4 != A_1.Length)
				{
					num2 = 1;
					num = num2;
					continue;
				}
				goto IL_00c9;
			case 2:
				return false;
			case 0:
				if (A_0[num4] != A_1[num4])
				{
					num2 = 0;
					_ = num2;
					num2 = 2;
					num = num2;
					continue;
				}
				goto IL_00c9;
			case 1:
				return false;
			case 3:
				if (num4 != 0)
				{
					num4--;
					num2 = 0;
					num = num2;
				}
				else
				{
					num2 = 4;
					num = num2;
				}
				continue;
			case 4:
				{
					num2 = 2023;
					short num3 = num2;
					num2 = 2023;
					switch (num3 == num2)
					{
					case false:
					case true:
						break;
					default:
						num2 = 0;
						if (num2 != 0)
						{
						}
						return true;
					}
					goto case 2;
				}
				IL_00c9:
				num2 = 1;
				if (num2 != 0)
				{
				}
				num2 = 3;
				num = num2;
				continue;
			}
			break;
		}
		goto IL_0028;
		IL_0028:
		num4 = A_0.Length;
		num2 = 5;
		num = num2;
		goto IL_000a;
	}

	private static bool w(char[] A_0, char[] A_1)
	{
		switch (0)
		{
		case 0:
			goto IL_0028;
		}
		goto IL_000a;
		IL_000a:
		int num = default(int);
		int num4 = default(int);
		short num2;
		while (true)
		{
			switch (num)
			{
			case 5:
				if (num4 != A_1.Length)
				{
					num2 = 1;
					num = num2;
					continue;
				}
				goto IL_00f1;
			case 1:
				num2 = 1;
				if (num2 != 0)
				{
				}
				return false;
			case 2:
				return false;
			case 0:
				num2 = 0;
				_ = num2;
				if (A_0[num4] != A_1[num4])
				{
					num2 = 2;
					num = num2;
					continue;
				}
				goto IL_00f1;
			case 3:
				if (num4 != 0)
				{
					num4--;
					num2 = 0;
					num = num2;
				}
				else
				{
					num2 = 4;
					num = num2;
				}
				continue;
			case 4:
				{
					num2 = 15825;
					short num3 = num2;
					num2 = 15825;
					switch (num3 == num2)
					{
					case false:
					case true:
						break;
					default:
						num2 = 0;
						if (num2 != 0)
						{
						}
						return true;
					}
					goto case 2;
				}
				IL_00f1:
				num2 = 3;
				num = num2;
				continue;
			}
			break;
		}
		goto IL_0028;
		IL_0028:
		num4 = A_0.Length;
		num2 = 5;
		num = num2;
		goto IL_000a;
	}

	private static bool w(byte[] A_0, byte[] A_1)
	{
		switch (0)
		{
		case 0:
			goto IL_0028;
		}
		goto IL_000a;
		IL_000a:
		int num = default(int);
		int num4 = default(int);
		short num2;
		while (true)
		{
			switch (num)
			{
			case 5:
				if (num4 != A_1.Length)
				{
					num2 = 1;
					num = num2;
					continue;
				}
				goto IL_00c8;
			case 2:
				return false;
			case 0:
				if (A_0[num4] != A_1[num4])
				{
					num2 = 0;
					_ = num2;
					num2 = 2;
					num = num2;
					continue;
				}
				goto IL_00c8;
			case 1:
				return false;
			case 3:
				if (num4 != 0)
				{
					num4--;
					num2 = 0;
					num = num2;
				}
				else
				{
					num2 = 4;
					num = num2;
				}
				continue;
			case 4:
				{
					num2 = 25113;
					short num3 = num2;
					num2 = 25113;
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
						if (num2 != 0)
						{
						}
						return true;
					}
					goto case 2;
				}
				IL_00c8:
				num2 = 3;
				num = num2;
				continue;
			}
			break;
		}
		goto IL_0028;
		IL_0028:
		num4 = A_0.Length;
		num2 = 5;
		num = num2;
		goto IL_000a;
	}

	private static bool w(int[] A_0, int[] A_1)
	{
		switch (0)
		{
		case 0:
			goto IL_0028;
		}
		goto IL_000a;
		IL_000a:
		int num = default(int);
		int num4 = default(int);
		short num2;
		while (true)
		{
			switch (num)
			{
			case 5:
				if (num4 != A_1.Length)
				{
					num2 = 1;
					num = num2;
					continue;
				}
				goto IL_00f4;
			case 2:
				return false;
			case 0:
				num2 = 0;
				_ = num2;
				if (A_0[num4] != A_1[num4])
				{
					num2 = 2;
					num = num2;
					continue;
				}
				goto IL_00f4;
			case 1:
				return false;
			case 3:
				if (num4 != 0)
				{
					num4--;
					num2 = 0;
					num = num2;
				}
				else
				{
					num2 = 4;
					num = num2;
				}
				continue;
			case 4:
				{
					num2 = -16968;
					short num3 = num2;
					num2 = -16968;
					switch (num3 == num2)
					{
					case false:
					case true:
						break;
					default:
						num2 = 0;
						if (num2 != 0)
						{
						}
						return true;
					}
					goto case 2;
				}
				IL_00f4:
				num2 = 3;
				num = num2;
				continue;
			}
			break;
		}
		goto IL_0028;
		IL_0028:
		num2 = 1;
		if (num2 != 0)
		{
		}
		num4 = A_0.Length;
		num2 = 5;
		num = num2;
		goto IL_000a;
	}

	private static bool w(uint[] A_0, uint[] A_1)
	{
		switch (0)
		{
		case 0:
			goto IL_0028;
		}
		goto IL_000a;
		IL_000a:
		int num = default(int);
		int num4 = default(int);
		short num2;
		while (true)
		{
			switch (num)
			{
			case 5:
				if (num4 != A_1.Length)
				{
					num2 = 1;
					num = num2;
					continue;
				}
				goto IL_00f8;
			case 2:
				num2 = 1;
				if (num2 != 0)
				{
				}
				return false;
			case 0:
				num2 = 0;
				_ = num2;
				if (A_0[num4] != A_1[num4])
				{
					num2 = 2;
					num = num2;
					continue;
				}
				goto IL_00f8;
			case 1:
				return false;
			case 3:
				if (num4 != 0)
				{
					num4--;
					num2 = 0;
					num = num2;
				}
				else
				{
					num2 = 4;
					num = num2;
				}
				continue;
			case 4:
				{
					num2 = 842;
					short num3 = num2;
					num2 = 842;
					switch (num3 == num2)
					{
					case false:
					case true:
						break;
					default:
						num2 = 0;
						if (num2 != 0)
						{
						}
						return true;
					}
					goto case 2;
				}
				IL_00f8:
				num2 = 3;
				num = num2;
				continue;
			}
			break;
		}
		goto IL_0028;
		IL_0028:
		num4 = A_0.Length;
		num2 = 5;
		num = num2;
		goto IL_000a;
	}

	public static string ToString(object[] a)
	{
		int a_ = 14;
		int num = default(int);
		StringBuilder stringBuilder = default(StringBuilder);
		switch (0)
		{
		default:
		{
			int num2 = default(int);
			while (true)
			{
				switch (num)
				{
				case 5:
					if (a.Length != 0)
					{
						short num3 = 1;
						num = num3;
						continue;
					}
					goto case 2;
				case 1:
				{
					short num3 = 1;
					if (num3 != 0)
					{
					}
					num3 = 13732;
					short num4 = num3;
					num3 = 13732;
					switch (num4 == num3)
					{
					default:
						num3 = 0;
						_ = num3;
						num3 = 0;
						if (num3 == 0)
						{
						}
						break;
					case false:
					case true:
						break;
					}
					stringBuilder.Append(a[0]);
					num2 = 1;
					num3 = 4;
					num = num3;
					continue;
				}
				case 3:
				case 4:
				{
					short num3 = 0;
					num = num3;
					continue;
				}
				case 0:
				{
					short num3;
					if (num2 >= a.Length)
					{
						num3 = 2;
						num = num3;
						continue;
					}
					stringBuilder.Append(Sha3.b("䡣䙥", a_)).Append(a[num2]);
					num2++;
					num3 = 3;
					num = num3;
					continue;
				}
				case 2:
					stringBuilder.Append(']');
					return stringBuilder.ToString();
				}
				break;
			}
			goto case 0;
		}
		case 0:
		{
			stringBuilder = new StringBuilder(91);
			short num3 = 5;
			num = num3;
			goto default;
		}
		}
	}

	public static int GetHashCode(byte[] data)
	{
		short num = 5;
		int num2 = num;
		int num4 = default(int);
		int num3 = default(int);
		while (true)
		{
			switch (num2)
			{
			case 5:
				switch (0)
				{
				default:
					goto end_IL_001f;
				case 0:
					break;
				}
				goto default;
			default:
				if (data == null)
				{
					num = 1;
					num2 = num;
					break;
				}
				num4 = data.Length;
				num3 = num4 + 1;
				num = 2;
				num2 = num;
				break;
			case 1:
				return 0;
			case 0:
			case 2:
				num = 3;
				num2 = num;
				break;
			case 3:
				while (true)
				{
					if (--num4 >= 0)
					{
						num = -14529;
						short num5 = num;
						num = -14529;
						switch (num5 == num)
						{
						case false:
						case true:
							continue;
						}
						num = 1;
						if (num != 0)
						{
						}
						num = 0;
						_ = num;
						num = 0;
						if (num != 0)
						{
						}
						num3 *= 257;
						num3 ^= data[num4];
						num = 0;
						num2 = num;
					}
					else
					{
						num = 4;
						num2 = num;
					}
					break;
				}
				break;
			case 4:
				{
					return num3;
				}
				end_IL_001f:
				break;
			}
		}
	}

	public static int GetHashCode(byte[] data, int off, int len)
	{
		short num = 5;
		int num2 = num;
		int num4 = default(int);
		int num3 = default(int);
		while (true)
		{
			switch (num2)
			{
			case 5:
				switch (0)
				{
				default:
					goto end_IL_001f;
				case 0:
					break;
				}
				goto default;
			default:
				if (data == null)
				{
					num = 1;
					num2 = num;
					break;
				}
				num4 = len;
				num3 = num4 + 1;
				num = 2;
				num2 = num;
				break;
			case 1:
				return 0;
			case 0:
			case 2:
				num = 3;
				num2 = num;
				break;
			case 3:
				while (true)
				{
					if (--num4 >= 0)
					{
						num = 13217;
						short num5 = num;
						num = 13217;
						switch (num5 == num)
						{
						case false:
						case true:
							continue;
						}
						num = 0;
						if (num != 0)
						{
						}
						num = 0;
						_ = num;
						num = 1;
						if (num != 0)
						{
						}
						num3 *= 257;
						num3 ^= data[off + num4];
						num = 0;
						num2 = num;
					}
					else
					{
						num = 4;
						num2 = num;
					}
					break;
				}
				break;
			case 4:
				{
					return num3;
				}
				end_IL_001f:
				break;
			}
		}
	}

	public static int GetHashCode(int[] data)
	{
		short num = 5;
		int num2 = num;
		int num4 = default(int);
		int num3 = default(int);
		while (true)
		{
			switch (num2)
			{
			case 5:
				num = 1;
				if (num != 0)
				{
				}
				switch (0)
				{
				default:
					goto end_IL_0047;
				case 0:
					break;
				}
				goto default;
			default:
				if (data == null)
				{
					num = 1;
					num2 = num;
					break;
				}
				num4 = data.Length;
				num3 = num4 + 1;
				num = 2;
				num2 = num;
				break;
			case 1:
				return 0;
			case 0:
			case 2:
				num = 3;
				num2 = num;
				break;
			case 3:
				while (true)
				{
					if (--num4 >= 0)
					{
						num = 19553;
						short num5 = num;
						num = 19553;
						switch (num5 == num)
						{
						case false:
						case true:
							continue;
						}
						num = 0;
						_ = num;
						num = 0;
						if (num != 0)
						{
						}
						num3 *= 257;
						num3 ^= data[num4];
						num = 0;
						num2 = num;
					}
					else
					{
						num = 4;
						num2 = num;
					}
					break;
				}
				break;
			case 4:
				{
					return num3;
				}
				end_IL_0047:
				break;
			}
		}
	}

	public static int GetHashCode(int[] data, int off, int len)
	{
		short num = 5;
		int num2 = num;
		int num4 = default(int);
		int num3 = default(int);
		while (true)
		{
			switch (num2)
			{
			case 5:
				switch (0)
				{
				default:
					goto end_IL_001f;
				case 0:
					break;
				}
				goto default;
			default:
				if (data == null)
				{
					num = 1;
					num2 = num;
					break;
				}
				num4 = len;
				num3 = num4 + 1;
				num = 2;
				num2 = num;
				break;
			case 1:
				return 0;
			case 0:
			case 2:
				num = 3;
				num2 = num;
				break;
			case 3:
				while (true)
				{
					num = 1;
					if (num != 0)
					{
					}
					if (--num4 >= 0)
					{
						num = -15635;
						short num5 = num;
						num = -15635;
						switch (num5 == num)
						{
						case false:
						case true:
							continue;
						}
						num = 0;
						if (num != 0)
						{
						}
						num = 0;
						_ = num;
						num3 *= 257;
						num3 ^= data[off + num4];
						num = 0;
						num2 = num;
					}
					else
					{
						num = 4;
						num2 = num;
					}
					break;
				}
				break;
			case 4:
				{
					return num3;
				}
				end_IL_001f:
				break;
			}
		}
	}

	public static int GetHashCode(uint[] data)
	{
		short num = 5;
		int num2 = num;
		int num4 = default(int);
		int num3 = default(int);
		while (true)
		{
			switch (num2)
			{
			case 5:
				switch (0)
				{
				default:
					goto end_IL_001f;
				case 0:
					break;
				}
				goto default;
			default:
				if (data == null)
				{
					num = 1;
					num2 = num;
					break;
				}
				num4 = data.Length;
				num3 = num4 + 1;
				num = 2;
				num2 = num;
				break;
			case 1:
				return 0;
			case 0:
			case 2:
				num = 3;
				num2 = num;
				break;
			case 3:
				while (true)
				{
					if (--num4 >= 0)
					{
						num = 10268;
						short num5 = num;
						num = 10268;
						switch (num5 == num)
						{
						case false:
						case true:
							continue;
						}
						num = 1;
						if (num != 0)
						{
						}
						num = 0;
						_ = num;
						num = 0;
						if (num != 0)
						{
						}
						num3 *= 257;
						num3 ^= (int)data[num4];
						num = 0;
						num2 = num;
					}
					else
					{
						num = 4;
						num2 = num;
					}
					break;
				}
				break;
			case 4:
				{
					return num3;
				}
				end_IL_001f:
				break;
			}
		}
	}

	public static int GetHashCode(uint[] data, int off, int len)
	{
		short num = 5;
		int num2 = num;
		int num4 = default(int);
		int num3 = default(int);
		while (true)
		{
			switch (num2)
			{
			case 5:
				switch (0)
				{
				default:
					goto end_IL_001f;
				case 0:
					break;
				}
				goto default;
			default:
				if (data == null)
				{
					num = 1;
					num2 = num;
					break;
				}
				num4 = len;
				num3 = num4 + 1;
				num = 2;
				num2 = num;
				break;
			case 1:
				return 0;
			case 0:
			case 2:
				num = 3;
				num2 = num;
				break;
			case 3:
				while (true)
				{
					if (--num4 >= 0)
					{
						num = 1210;
						short num5 = num;
						num = 1210;
						switch (num5 == num)
						{
						case false:
						case true:
							continue;
						}
						num = 0;
						if (num != 0)
						{
						}
						num = 0;
						_ = num;
						num3 *= 257;
						num3 ^= (int)data[off + num4];
						num = 0;
						num2 = num;
					}
					else
					{
						num = 4;
						num2 = num;
					}
					break;
				}
				break;
			case 4:
				{
					num = 1;
					if (num != 0)
					{
					}
					return num3;
				}
				end_IL_001f:
				break;
			}
		}
	}

	public static int GetHashCode(ulong[] data)
	{
		short num = 5;
		int num2 = num;
		int num4 = default(int);
		int num3 = default(int);
		while (true)
		{
			switch (num2)
			{
			case 5:
				switch (0)
				{
				default:
					goto end_IL_0020;
				case 0:
					break;
				}
				goto default;
			default:
				num = 1;
				if (num != 0)
				{
				}
				if (data == null)
				{
					num = 1;
					num2 = num;
					break;
				}
				num4 = data.Length;
				num3 = num4 + 1;
				num = 2;
				num2 = num;
				break;
			case 1:
				return 0;
			case 0:
			case 2:
				num = 3;
				num2 = num;
				break;
			case 3:
				while (true)
				{
					if (--num4 >= 0)
					{
						num = 21202;
						short num5 = num;
						num = 21202;
						switch (num5 == num)
						{
						case false:
						case true:
							continue;
						}
						num = 0;
						_ = num;
						num = 0;
						if (num != 0)
						{
						}
						ulong num6 = data[num4];
						num3 *= 257;
						num3 ^= (int)num6;
						num3 *= 257;
						num3 ^= (int)(num6 >> 32);
						num = 0;
						num2 = num;
					}
					else
					{
						num = 4;
						num2 = num;
					}
					break;
				}
				break;
			case 4:
				{
					return num3;
				}
				end_IL_0020:
				break;
			}
		}
	}

	public static int GetHashCode(ulong[] data, int off, int len)
	{
		short num = 5;
		int num2 = num;
		int num4 = default(int);
		int num3 = default(int);
		while (true)
		{
			switch (num2)
			{
			case 5:
				switch (0)
				{
				default:
					goto end_IL_001f;
				case 0:
					break;
				}
				goto default;
			default:
				if (data == null)
				{
					num = 1;
					num2 = num;
					break;
				}
				num = 1;
				if (num != 0)
				{
				}
				num4 = len;
				num3 = num4 + 1;
				num = 2;
				num2 = num;
				break;
			case 1:
				return 0;
			case 0:
			case 2:
				num = 3;
				num2 = num;
				break;
			case 3:
				while (true)
				{
					if (--num4 >= 0)
					{
						num = -31435;
						short num5 = num;
						num = -31435;
						switch (num5 == num)
						{
						case false:
						case true:
							continue;
						}
						num = 0;
						if (num != 0)
						{
						}
						num = 0;
						_ = num;
						ulong num6 = data[off + num4];
						num3 *= 257;
						num3 ^= (int)num6;
						num3 *= 257;
						num3 ^= (int)(num6 >> 32);
						num = 0;
						num2 = num;
					}
					else
					{
						num = 4;
						num2 = num;
					}
					break;
				}
				break;
			case 4:
				{
					return num3;
				}
				end_IL_001f:
				break;
			}
		}
	}

	public static byte[] Clone(byte[] data)
	{
		if (data != null)
		{
			short num = 8183;
			short num2 = num;
			num = 8183;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				num = 0;
				if (num == 0)
				{
				}
				break;
			case false:
			case true:
				break;
			}
			num = 1;
			if (num != 0)
			{
			}
			return (byte[])data.Clone();
		}
		return null;
	}

	public static byte[] Clone(byte[] data, byte[] existing)
	{
		short num = 5;
		int num2 = num;
		while (true)
		{
			switch (num2)
			{
			case 5:
				num = 1;
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
				goto default;
			default:
				if (data == null)
				{
					num = 1;
					num2 = num;
				}
				else
				{
					num = 3;
					num2 = num;
				}
				continue;
			case 0:
				if (existing.Length != data.Length)
				{
					num = 2;
					num2 = num;
					continue;
				}
				Array.Copy(data, 0, existing, 0, existing.Length);
				return existing;
			case 3:
			{
				num = -10653;
				short num3 = num;
				num = -10653;
				switch (num3 == num)
				{
				case false:
				case true:
					break;
				default:
					goto IL_0107;
				}
				goto case 0;
			}
			case 4:
				num = 0;
				_ = num;
				num = 0;
				num2 = num;
				continue;
			case 1:
				return null;
			case 2:
				break;
				IL_0107:
				num = 0;
				if (num != 0)
				{
				}
				if (existing != null)
				{
					num = 4;
					num2 = num;
					continue;
				}
				break;
			}
			break;
		}
		return Clone(data);
	}

	public static int[] Clone(int[] data)
	{
		if (data != null)
		{
			short num = -30670;
			short num2 = num;
			num = -30670;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				num = 0;
				if (num != 0)
				{
				}
				num = 1;
				if (num == 0)
				{
				}
				break;
			case false:
			case true:
				break;
			}
			return (int[])data.Clone();
		}
		return null;
	}

	internal static uint[] w(uint[] A_0)
	{
		short num;
		if (A_0 != null)
		{
			num = 2432;
			short num2 = num;
			num = 2432;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				num = 0;
				if (num == 0)
				{
				}
				break;
			case false:
			case true:
				break;
			}
			return (uint[])A_0.Clone();
		}
		num = 1;
		if (num != 0)
		{
		}
		return null;
	}

	public static long[] Clone(long[] data)
	{
		if (data != null)
		{
			short num = 26387;
			short num2 = num;
			num = 26387;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				num = 0;
				if (num == 0)
				{
				}
				break;
			case false:
			case true:
				break;
			}
			num = 1;
			if (num != 0)
			{
			}
			return (long[])data.Clone();
		}
		return null;
	}

	public static ulong[] Clone(ulong[] data)
	{
		if (data != null)
		{
			short num = -8681;
			short num2 = num;
			num = -8681;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				num = 1;
				if (num != 0)
				{
				}
				num = 0;
				if (num == 0)
				{
				}
				break;
			case false:
			case true:
				break;
			}
			return (ulong[])data.Clone();
		}
		return null;
	}

	public static ulong[] Clone(ulong[] data, ulong[] existing)
	{
		short num = 5;
		int num2 = num;
		while (true)
		{
			switch (num2)
			{
			case 5:
				switch (0)
				{
				default:
					continue;
				case 0:
					break;
				}
				goto default;
			default:
				if (data == null)
				{
					num = 1;
					num2 = num;
				}
				else
				{
					num = 3;
					num2 = num;
				}
				continue;
			case 0:
				if (existing.Length != data.Length)
				{
					num = 2;
					num2 = num;
					continue;
				}
				Array.Copy(data, 0, existing, 0, existing.Length);
				return existing;
			case 3:
			{
				num = 351;
				short num3 = num;
				num = 351;
				switch (num3 == num)
				{
				case false:
				case true:
					break;
				default:
					goto IL_00dd;
				}
				goto case 0;
			}
			case 4:
				num = 0;
				_ = num;
				num = 0;
				num2 = num;
				continue;
			case 1:
				return null;
			case 2:
				break;
				IL_00dd:
				num = 0;
				if (num != 0)
				{
				}
				num = 1;
				if (num != 0)
				{
				}
				if (existing != null)
				{
					num = 4;
					num2 = num;
					continue;
				}
				break;
			}
			break;
		}
		return Clone(data);
	}

	public static bool Contains(byte[] a, byte n)
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
				case 2:
					return true;
				case 0:
				{
					short num2;
					if (a[num3] != n)
					{
						num3++;
						num2 = 1946;
						short num4 = num2;
						num2 = 1946;
						switch (num4 == num2)
						{
						default:
							num2 = 0;
							if (num2 != 0)
							{
							}
							num2 = 0;
							_ = num2;
							num2 = 1;
							num = num2;
							continue;
						case false:
						case true:
							break;
						}
						goto case 3;
					}
					num2 = 2;
					num = num2;
					continue;
				}
				case 1:
				case 5:
				{
					short num2 = 3;
					num = num2;
					continue;
				}
				case 3:
				{
					short num2 = 1;
					if (num2 != 0)
					{
					}
					if (num3 < a.Length)
					{
						num2 = 0;
						num = num2;
					}
					else
					{
						num2 = 4;
						num = num2;
					}
					continue;
				}
				case 4:
					return false;
				}
				break;
			}
			goto case 0;
		case 0:
		{
			num3 = 0;
			short num2 = 5;
			num = num2;
			goto default;
		}
		}
	}

	public static bool Contains(short[] a, short n)
	{
		int num = default(int);
		int num2 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				switch (num)
				{
				case 5:
				{
					short num3 = 1;
					if (num3 == 0)
					{
					}
					goto case 1;
				}
				case 2:
					return true;
				case 0:
				{
					short num3;
					if (a[num2] != n)
					{
						num2++;
						num3 = 3705;
						short num4 = num3;
						num3 = 3705;
						switch (num4 == num3)
						{
						default:
							num3 = 0;
							_ = num3;
							num3 = 0;
							if (num3 != 0)
							{
							}
							num3 = 1;
							num = num3;
							continue;
						case false:
						case true:
							break;
						}
						goto case 3;
					}
					num3 = 2;
					num = num3;
					continue;
				}
				case 1:
				{
					short num3 = 3;
					num = num3;
					continue;
				}
				case 3:
					if (num2 < a.Length)
					{
						short num3 = 0;
						num = num3;
					}
					else
					{
						short num3 = 4;
						num = num3;
					}
					continue;
				case 4:
					return false;
				}
				break;
			}
			goto case 0;
		case 0:
		{
			num2 = 0;
			short num3 = 5;
			num = num3;
			goto default;
		}
		}
	}

	public static bool Contains(int[] a, int n)
	{
		int num2 = default(int);
		int num3 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				short num = 1;
				if (num != 0)
				{
				}
				switch (num2)
				{
				case 2:
					return true;
				case 0:
					if (a[num3] != n)
					{
						num3++;
						num = -11617;
						short num4 = num;
						num = -11617;
						switch (num4 == num)
						{
						default:
							num = 0;
							_ = num;
							num = 0;
							if (num != 0)
							{
							}
							num = 1;
							num2 = num;
							continue;
						case false:
						case true:
							break;
						}
						goto case 3;
					}
					num = 2;
					num2 = num;
					continue;
				case 1:
				case 5:
					num = 3;
					num2 = num;
					continue;
				case 3:
					if (num3 < a.Length)
					{
						num = 0;
						num2 = num;
					}
					else
					{
						num = 4;
						num2 = num;
					}
					continue;
				case 4:
					return false;
				}
				break;
			}
			goto case 0;
		case 0:
		{
			num3 = 0;
			short num = 5;
			num2 = num;
			goto default;
		}
		}
	}

	public static void Fill(byte[] buf, byte b)
	{
		int num = default(int);
		int num2 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				switch (num)
				{
				case 2:
				case 3:
				{
					short num3 = 0;
					num = num3;
					continue;
				}
				case 0:
				{
					short num3;
					if (num2 <= 0)
					{
						num3 = 8712;
						short num4 = num3;
						num3 = 8712;
						switch (num4 == num3)
						{
						case false:
						case true:
							break;
						default:
							num3 = 0;
							if (num3 != 0)
							{
							}
							num3 = 1;
							if (num3 != 0)
							{
							}
							num3 = 0;
							_ = num3;
							num3 = 1;
							num = num3;
							continue;
						}
						goto case 2;
					}
					buf[--num2] = b;
					num3 = 2;
					num = num3;
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
			num2 = buf.Length;
			short num3 = 3;
			num = num3;
			goto default;
		}
		}
	}

	public static byte[] CopyOf(byte[] data, int newLength)
	{
		short num = 8931;
		short num2 = num;
		num = 8931;
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
		byte[] array = new byte[newLength];
		Array.Copy(data, 0, array, 0, Math.Min(newLength, data.Length));
		return array;
	}

	public static char[] CopyOf(char[] data, int newLength)
	{
		short num = 18321;
		short num2 = num;
		num = 18321;
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
		char[] array = new char[newLength];
		Array.Copy(data, 0, array, 0, Math.Min(newLength, data.Length));
		return array;
	}

	public static int[] CopyOf(int[] data, int newLength)
	{
		short num = 15719;
		short num2 = num;
		num = 15719;
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
		int[] array = new int[newLength];
		Array.Copy(data, 0, array, 0, Math.Min(newLength, data.Length));
		return array;
	}

	public static long[] CopyOf(long[] data, int newLength)
	{
		short num = 19755;
		short num2 = num;
		num = 19755;
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
		long[] array = new long[newLength];
		Array.Copy(data, 0, array, 0, Math.Min(newLength, data.Length));
		return array;
	}

	public static byte[] CopyOfRange(byte[] data, int from, int to)
	{
		short num = 15124;
		short num2 = num;
		num = 15124;
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
		int num3 = w(from, to);
		byte[] array = new byte[num3];
		Array.Copy(data, from, array, 0, Math.Min(num3, data.Length - from));
		return array;
	}

	public static int[] CopyOfRange(int[] data, int from, int to)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		num = 9410;
		short num2 = num;
		num = 9410;
		switch (num2 == num)
		{
		default:
		{
			num = 0;
			if (num != 0)
			{
			}
			int num3 = w(from, to);
			int[] array = new int[num3];
			Array.Copy(data, from, array, 0, Math.Min(num3, data.Length - from));
			return array;
		}
		}
	}

	public static long[] CopyOfRange(long[] data, int from, int to)
	{
		short num = -8350;
		short num2 = num;
		num = -8350;
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
		int num3 = w(from, to);
		long[] array = new long[num3];
		Array.Copy(data, from, array, 0, Math.Min(num3, data.Length - from));
		return array;
	}

	private static int w(int A_0, int A_1)
	{
		int a_ = 1;
		short num = 1;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		num = -30723;
		short num2 = num;
		num = -30723;
		switch (num2 == num)
		{
		default:
		{
			num = 0;
			if (num != 0)
			{
			}
			int num3 = A_1 - A_0;
			if (num3 < 0)
			{
				throw new ArgumentException(A_0 + Sha3.b("睖杘筚", a_) + A_1);
			}
			return num3;
		}
		}
	}

	public static byte[] Append(byte[] a, byte b)
	{
		if (a == null)
		{
			short num = 1;
			if (num != 0)
			{
			}
			num = -15454;
			short num2 = num;
			num = -15454;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				goto case true;
			case true:
				num = 0;
				if (num == 0)
				{
				}
				break;
			case false:
			case true:
				break;
			}
			return new byte[1] { b };
		}
		int num3 = a.Length;
		byte[] array = new byte[num3 + 1];
		Array.Copy(a, 0, array, 0, num3);
		array[num3] = b;
		return array;
	}

	public static short[] Append(short[] a, short b)
	{
		if (a == null)
		{
			short num = -1420;
			short num2 = num;
			num = -1420;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				num = 1;
				if (num != 0)
				{
				}
				num = 0;
				if (num == 0)
				{
				}
				break;
			case false:
			case true:
				break;
			}
			return new short[1] { b };
		}
		int num3 = a.Length;
		short[] array = new short[num3 + 1];
		Array.Copy(a, 0, array, 0, num3);
		array[num3] = b;
		return array;
	}

	public static int[] Append(int[] a, int b)
	{
		if (a == null)
		{
			short num = 23604;
			short num2 = num;
			num = 23604;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				num = 1;
				if (num != 0)
				{
				}
				num = 0;
				if (num == 0)
				{
				}
				break;
			case false:
			case true:
				break;
			}
			return new int[1] { b };
		}
		int num3 = a.Length;
		int[] array = new int[num3 + 1];
		Array.Copy(a, 0, array, 0, num3);
		array[num3] = b;
		return array;
	}

	public static byte[] Concatenate(byte[] a, byte[] b)
	{
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
					goto end_IL_0020;
				case 0:
					break;
				}
				goto default;
			default:
				if (a != null)
				{
					num = -27268;
					short num3 = num;
					num = -27268;
					switch (num3 == num)
					{
					case false:
					case true:
						break;
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
						num = 1;
						num2 = num;
						goto end_IL_0020;
					}
				}
				num = 0;
				num2 = num;
				break;
			case 2:
				return Clone(a);
			case 1:
			{
				if (b == null)
				{
					num = 2;
					num2 = num;
					break;
				}
				byte[] array = new byte[a.Length + b.Length];
				Array.Copy(a, 0, array, 0, a.Length);
				Array.Copy(b, 0, array, a.Length, b.Length);
				return array;
			}
			case 0:
				{
					return Clone(b);
				}
				end_IL_0020:
				break;
			}
		}
	}

	public static byte[] ConcatenateAll(params byte[][] vs)
	{
		short num = 0;
		int num2 = num;
		switch (num2)
		{
		default:
		{
			int num4 = default(int);
			int num8 = default(int);
			byte[][] array2 = default(byte[][]);
			int num3 = default(int);
			switch (0)
			{
			default:
			{
				byte[] array3 = default(byte[]);
				int num7 = default(int);
				int num6 = default(int);
				byte[] array = default(byte[]);
				while (true)
				{
					switch (num2)
					{
					case 1:
						array3 = new byte[num4];
						num7 = 0;
						num6 = 0;
						num = 9;
						num2 = num;
						continue;
					case 8:
					case 10:
						num = 7;
						num2 = num;
						continue;
					case 7:
						if (num8 >= vs.Length)
						{
							num = 1;
							num2 = num;
						}
						else
						{
							array = vs[num8];
							num = 5;
							num2 = num;
						}
						continue;
					case 4:
						array2[num3++] = array;
						num4 += array.Length;
						num = 6;
						num2 = num;
						continue;
					case 6:
						num = 0;
						_ = num;
						goto IL_0275;
					case 2:
					case 9:
						num = 0;
						num2 = num;
						continue;
					case 0:
					{
						num = 1;
						if (num != 0)
						{
						}
						if (num6 >= num3)
						{
							num = 3;
							num2 = num;
							continue;
						}
						byte[] array4 = array2[num6];
						Array.Copy(array4, 0, array3, num7, array4.Length);
						num7 += array4.Length;
						num6++;
						num = 2;
						num2 = num;
						continue;
					}
					case 3:
					{
						num = 9036;
						short num5 = num;
						num = 9036;
						switch (num5 == num)
						{
						default:
							num = 0;
							if (num != 0)
							{
							}
							return array3;
						case false:
						case true:
							break;
						}
						goto IL_0275;
					}
					case 5:
						{
							if (array != null)
							{
								num = 4;
								num2 = num;
								continue;
							}
							goto IL_0275;
						}
						IL_0275:
						num8++;
						num = 8;
						num2 = num;
						continue;
					}
					break;
				}
				goto case 0;
			}
			case 0:
				array2 = new byte[vs.Length][];
				num3 = 0;
				num4 = 0;
				num8 = 0;
				num = 10;
				num2 = num;
				goto default;
			}
		}
		}
	}

	public static int[] Concatenate(int[] a, int[] b)
	{
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
					goto end_IL_001f;
				case 0:
					break;
				}
				goto default;
			default:
				if (a != null)
				{
					num = 4516;
					short num3 = num;
					num = 4516;
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
						num = 0;
						_ = num;
						num = 1;
						num2 = num;
						goto end_IL_001f;
					}
				}
				num = 0;
				num2 = num;
				break;
			case 2:
				num = 1;
				if (num != 0)
				{
				}
				return Clone(a);
			case 1:
			{
				if (b == null)
				{
					num = 2;
					num2 = num;
					break;
				}
				int[] array = new int[a.Length + b.Length];
				Array.Copy(a, 0, array, 0, a.Length);
				Array.Copy(b, 0, array, a.Length, b.Length);
				return array;
			}
			case 0:
				{
					return Clone(b);
				}
				end_IL_001f:
				break;
			}
		}
	}

	public static byte[] Prepend(byte[] a, byte b)
	{
		if (a == null)
		{
			short num = -25943;
			short num2 = num;
			num = -25943;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				num = 1;
				if (num != 0)
				{
				}
				num = 0;
				if (num == 0)
				{
				}
				break;
			case false:
			case true:
				break;
			}
			return new byte[1] { b };
		}
		int num3 = a.Length;
		byte[] array = new byte[num3 + 1];
		Array.Copy(a, 0, array, 1, num3);
		array[0] = b;
		return array;
	}

	public static short[] Prepend(short[] a, short b)
	{
		if (a == null)
		{
			short num = 1;
			if (num != 0)
			{
			}
			num = 30531;
			short num2 = num;
			num = 30531;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				goto case true;
			case true:
				num = 0;
				if (num == 0)
				{
				}
				break;
			case false:
			case true:
				break;
			}
			return new short[1] { b };
		}
		int num3 = a.Length;
		short[] array = new short[num3 + 1];
		Array.Copy(a, 0, array, 1, num3);
		array[0] = b;
		return array;
	}

	public static int[] Prepend(int[] a, int b)
	{
		if (a == null)
		{
			short num = -18645;
			short num2 = num;
			num = -18645;
			switch (num2 == num)
			{
			default:
				num = 0;
				_ = num;
				num = 1;
				if (num != 0)
				{
				}
				num = 0;
				if (num == 0)
				{
				}
				break;
			case false:
			case true:
				break;
			}
			return new int[1] { b };
		}
		int num3 = a.Length;
		int[] array = new int[num3 + 1];
		Array.Copy(a, 0, array, 1, num3);
		array[0] = b;
		return array;
	}

	public static byte[] Reverse(byte[] a)
	{
		short num = 5;
		int num2 = num;
		int num4 = default(int);
		int num3 = default(int);
		byte[] array = default(byte[]);
		while (true)
		{
			switch (num2)
			{
			case 5:
				switch (0)
				{
				default:
					goto end_IL_0020;
				case 0:
					break;
				}
				goto default;
			default:
				if (a == null)
				{
					num = -14172;
					short num5 = num;
					num = -14172;
					switch (num5 == num)
					{
					default:
						num = 0;
						if (num != 0)
						{
						}
						num = 1;
						num2 = num;
						goto end_IL_0020;
					case false:
					case true:
						break;
					}
					goto IL_0167;
				}
				num4 = 0;
				num3 = a.Length;
				array = new byte[num3];
				num = 2;
				num2 = num;
				break;
			case 0:
				num = 0;
				_ = num;
				goto case 2;
			case 1:
				return null;
			case 2:
				num = 1;
				if (num != 0)
				{
				}
				num = 3;
				num2 = num;
				break;
			case 3:
				if (--num3 >= 0)
				{
					array[num3] = a[num4++];
					num = 0;
					num2 = num;
					break;
				}
				goto IL_0167;
			case 4:
				{
					return array;
				}
				IL_0167:
				num = 4;
				num2 = num;
				break;
				end_IL_0020:
				break;
			}
		}
	}

	public static int[] Reverse(int[] a)
	{
		short num = 1;
		int num2 = num;
		int num4 = default(int);
		int num3 = default(int);
		int[] array = default(int[]);
		while (true)
		{
			switch (num2)
			{
			case 1:
				switch (0)
				{
				default:
					goto end_IL_001f;
				case 0:
					break;
				}
				goto default;
			default:
				if (a == null)
				{
					num = -10022;
					short num5 = num;
					num = -10022;
					switch (num5 == num)
					{
					default:
						num = 0;
						if (num != 0)
						{
						}
						num = 2;
						num2 = num;
						goto end_IL_001f;
					case false:
					case true:
						break;
					}
					goto IL_013d;
				}
				num4 = 0;
				num3 = a.Length;
				array = new int[num3];
				num = 0;
				num2 = num;
				break;
			case 4:
				num = 0;
				_ = num;
				goto case 0;
			case 2:
				return null;
			case 0:
				num = 3;
				num2 = num;
				break;
			case 3:
				if (--num3 >= 0)
				{
					array[num3] = a[num4++];
					num = 4;
					num2 = num;
					break;
				}
				goto IL_013d;
			case 5:
				{
					return array;
				}
				IL_013d:
				num = 1;
				if (num != 0)
				{
				}
				num = 5;
				num2 = num;
				break;
				end_IL_001f:
				break;
			}
		}
	}
}
