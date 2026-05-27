using System;
using System.Security.Cryptography;

namespace ODCrypt;

public static class CryptUtil
{
	public static T Random<T>()
	{
		int a_ = 18;
		short num = 0;
		int num2 = num;
		Type typeFromHandle = default(Type);
		RandomNumberGenerator randomNumberGenerator = default(RandomNumberGenerator);
		T result = default(T);
		byte[] array = default(byte[]);
		switch (num2)
		{
		default:
			{
				switch (0)
				{
				case 0:
					goto IL_0055;
				}
				goto IL_0032;
			}
			IL_0032:
			while (true)
			{
				switch (num2)
				{
				case 0:
					if (!typeFromHandle.IsValueType)
					{
						num = 3;
						num2 = num;
					}
					else
					{
						num = 5;
						num2 = num;
					}
					continue;
				case 6:
					throw new ApplicationException(Sha3.b("㹧୩k\u1b6dᕯ剱\u1773\u1775ᙷᑹ፻\u0a7dꁿ\ue081\ue183ꚅ\ue987ꪉﾋ揄\ue28fﮑ望\uf195뚗", a_));
				case 5:
				{
					num = 9078;
					short num3 = num;
					num = 9078;
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
						num = 0;
						_ = num;
						if (typeFromHandle.IsEnum)
						{
							num = 1;
							num2 = num;
						}
						else
						{
							num = 2;
							num2 = num;
						}
						continue;
					case false:
					case true:
						break;
					}
					goto case 1;
				}
				case 3:
					throw new ApplicationException(Sha3.b("㹧୩k\u1b6dᕯ剱ᥳ\u0375୷\u0e79屻ᱽ\ue57fꊁ튃\ue785\ue487ﾉ\ue98b\uda8d\ue98f\ue291\uf193뢕", a_));
				case 4:
					try
					{
						num = 11;
						num2 = num;
						while (true)
						{
							switch (num2)
							{
							case 11:
								switch (0)
								{
								default:
									continue;
								case 0:
									break;
								}
								goto default;
							default:
								if (typeFromHandle == typeof(bool))
								{
									num = 27;
									num2 = num;
								}
								else
								{
									num = 40;
									num2 = num;
								}
								continue;
							case 24:
							{
								byte[] array12 = new byte[1];
								randomNumberGenerator.GetBytes(array12);
								result = (T)Convert.ChangeType(Convert.ToSByte(array12[0] % 127), typeFromHandle);
								num = 19;
								num2 = num;
								continue;
							}
							case 19:
								break;
							case 17:
								if (typeFromHandle == typeof(ulong))
								{
									num = 31;
									num2 = num;
								}
								else
								{
									num = 14;
									num2 = num;
								}
								continue;
							case 30:
							{
								byte[] array13 = new byte[2];
								randomNumberGenerator.GetBytes(array13);
								result = (T)Convert.ChangeType(BitConverter.ToUInt16(array13, 0), typeFromHandle);
								num = 22;
								num2 = num;
								continue;
							}
							case 22:
								break;
							case 12:
								if (typeFromHandle == typeof(double))
								{
									num = 9;
									num2 = num;
								}
								else
								{
									num = 37;
									num2 = num;
								}
								continue;
							case 27:
								array = new byte[1];
								randomNumberGenerator.GetBytes(array);
								num = 33;
								num2 = num;
								continue;
							case 33:
								if (array[0] % 2 == 0)
								{
									num = 21;
									num2 = num;
								}
								else
								{
									result = (T)Convert.ChangeType(false, typeFromHandle);
									num = 18;
									num2 = num;
								}
								continue;
							case 7:
								if (typeFromHandle == typeof(sbyte))
								{
									num = 24;
									num2 = num;
								}
								else
								{
									num = 25;
									num2 = num;
								}
								continue;
							case 0:
							{
								byte[] array11 = new byte[1];
								randomNumberGenerator.GetBytes(array11);
								result = (T)Convert.ChangeType(array11[0], typeFromHandle);
								num = 3;
								num2 = num;
								continue;
							}
							case 3:
								break;
							case 16:
							{
								byte[] array9 = new byte[1];
								randomNumberGenerator.GetBytes(array9);
								result = (T)Convert.ChangeType(array9[0], typeFromHandle);
								num = 8;
								num2 = num;
								continue;
							}
							case 8:
								break;
							case 31:
							{
								byte[] array8 = new byte[8];
								randomNumberGenerator.GetBytes(array8);
								result = (T)Convert.ChangeType(BitConverter.ToUInt64(array8, 0), typeFromHandle);
								num = 20;
								num2 = num;
								continue;
							}
							case 20:
								break;
							case 4:
							{
								byte[] array4 = new byte[2];
								randomNumberGenerator.GetBytes(array4);
								result = (T)Convert.ChangeType(BitConverter.ToInt16(array4, 0), typeFromHandle);
								num = 15;
								num2 = num;
								continue;
							}
							case 15:
								break;
							case 9:
							{
								byte[] array3 = new byte[8];
								randomNumberGenerator.GetBytes(array3);
								result = (T)Convert.ChangeType(BitConverter.ToDouble(array3, 0), typeFromHandle);
								num = 29;
								num2 = num;
								continue;
							}
							case 29:
								break;
							case 37:
								if (typeFromHandle == typeof(float))
								{
									num = 38;
									num2 = num;
								}
								else
								{
									num = 28;
									num2 = num;
								}
								continue;
							case 36:
								if (typeFromHandle == typeof(long))
								{
									num = 39;
									num2 = num;
								}
								else
								{
									num = 41;
									num2 = num;
								}
								continue;
							case 13:
								if (!(typeFromHandle == typeof(decimal)))
								{
									num = 12;
									num2 = num;
								}
								else
								{
									num = 34;
									num2 = num;
								}
								continue;
							case 40:
								if (!(typeFromHandle == typeof(byte)))
								{
									num = 7;
									num2 = num;
								}
								else
								{
									num = 0;
									num2 = num;
								}
								continue;
							case 6:
								if (!(typeFromHandle == typeof(uint)))
								{
									num = 17;
									num2 = num;
								}
								else
								{
									num = 26;
									num2 = num;
								}
								continue;
							case 34:
							{
								byte[] array10 = new byte[16];
								randomNumberGenerator.GetBytes(array10);
								result = (T)Convert.ChangeType(Convert.ToDecimal(BitConverter.ToDouble(array10, 0) % 7.922816251426434E+28), typeFromHandle);
								num = 32;
								num2 = num;
								continue;
							}
							case 32:
								break;
							case 25:
								if (!(typeFromHandle == typeof(char)))
								{
									num = 13;
									num2 = num;
								}
								else
								{
									num = 16;
									num2 = num;
								}
								continue;
							case 38:
							{
								byte[] array7 = new byte[4];
								randomNumberGenerator.GetBytes(array7);
								result = (T)Convert.ChangeType(BitConverter.ToSingle(array7, 0), typeFromHandle);
								num = 2;
								num2 = num;
								continue;
							}
							case 2:
								break;
							case 39:
							{
								byte[] array6 = new byte[8];
								randomNumberGenerator.GetBytes(array6);
								result = (T)Convert.ChangeType(BitConverter.ToInt64(array6, 0), typeFromHandle);
								num = 35;
								num2 = num;
								continue;
							}
							case 35:
								break;
							case 21:
								result = (T)Convert.ChangeType(true, typeFromHandle);
								num = 10;
								num2 = num;
								continue;
							case 10:
								break;
							case 5:
							{
								byte[] array5 = new byte[4];
								randomNumberGenerator.GetBytes(array5);
								result = (T)Convert.ChangeType(BitConverter.ToInt32(array5, 0), typeFromHandle);
								num = 1;
								num2 = num;
								continue;
							}
							case 1:
								break;
							case 28:
								if (!(typeFromHandle == typeof(int)))
								{
									num = 36;
									num2 = num;
								}
								else
								{
									num = 5;
									num2 = num;
								}
								continue;
							case 26:
							{
								byte[] array2 = new byte[4];
								randomNumberGenerator.GetBytes(array2);
								result = (T)Convert.ChangeType(BitConverter.ToUInt32(array2, 0), typeFromHandle);
								num = 23;
								num2 = num;
								continue;
							}
							case 23:
								break;
							case 41:
								if (!(typeFromHandle == typeof(short)))
								{
									num = 6;
									num2 = num;
								}
								else
								{
									num = 4;
									num2 = num;
								}
								continue;
							case 14:
								if (typeFromHandle == typeof(ushort))
								{
									num = 30;
									num2 = num;
									continue;
								}
								throw new ApplicationException(Sha3.b("㱧፩ᱫ୭偯ᅱųѵ\u0a77όቻ\u0a7d\uec7fﮁꒃ\ue885\ue787ﺉ겋ﶍ\ue58f\ue291\ue493秊\uea97\uee99鍊瞧骟芡", a_) + typeof(T).Name);
							case 18:
								break;
							}
							break;
						}
					}
					finally
					{
						num = 0;
						num2 = num;
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
								if (randomNumberGenerator != null)
								{
									num = 1;
									num2 = num;
									continue;
								}
								break;
							case 1:
								((IDisposable)randomNumberGenerator).Dispose();
								num = 2;
								num2 = num;
								continue;
							case 2:
								break;
							}
							break;
						}
					}
					return result;
				case 2:
					if (!(typeFromHandle == typeof(string)))
					{
						randomNumberGenerator = new RNGCryptoServiceProvider();
						num = 4;
						num2 = num;
					}
					else
					{
						num = 6;
						num2 = num;
					}
					continue;
				case 1:
					throw new ApplicationException(Sha3.b("㹧୩k\u1b6dᕯ剱\u1773\u1775ᙷᑹ፻\u0a7dꁿ\ue081\ue183ꚅ\ue987\ue489겋\ueb8dﺏ\ue791煉뢕", a_));
				}
				break;
			}
			goto IL_0055;
			IL_0055:
			typeFromHandle = typeof(T);
			num = 0;
			num2 = num;
			goto IL_0032;
		}
	}

	public static string RandomString(int numberOfBits)
	{
		short num = 7629;
		short num2 = num;
		num = 7629;
		switch (num2 == num)
		{
		default:
		{
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
			RandomNumberGenerator randomNumberGenerator = new RNGCryptoServiceProvider();
			try
			{
				byte[] array = new byte[(int)Math.Ceiling((double)numberOfBits * 1.0 / 8.0)];
				randomNumberGenerator.GetBytes(array);
				return Convert.ToBase64String(array);
			}
			finally
			{
				num = 0;
				int num3 = num;
				while (true)
				{
					switch (num3)
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
						if (randomNumberGenerator != null)
						{
							num = 1;
							num3 = num;
							continue;
						}
						break;
					case 1:
						((IDisposable)randomNumberGenerator).Dispose();
						num = 2;
						num3 = num;
						continue;
					case 2:
						break;
					}
					break;
				}
			}
		}
		case false:
		case true:
		{
			string result = default(string);
			return result;
		}
		}
	}

	public static bool ConstantEquals(string lhs, string rhs)
	{
		int num = default(int);
		int num4 = default(int);
		int num5 = default(int);
		switch (0)
		{
		default:
			while (true)
			{
				switch (num)
				{
				case 2:
				{
					short num2;
					if (num4 >= rhs.Length)
					{
						num2 = 4;
						num = num2;
						continue;
					}
					num5 |= lhs[num4] ^ rhs[num4];
					num4++;
					num2 = 5;
					num = num2;
					continue;
				}
				case 1:
				case 5:
				{
					short num2 = 0;
					num = num2;
					continue;
				}
				case 0:
					if (num4 < lhs.Length)
					{
						short num2 = 3;
						num = num2;
						continue;
					}
					goto case 4;
				case 3:
				{
					short num2 = 12697;
					short num3 = num2;
					num2 = 12697;
					switch (num3 == num2)
					{
					case false:
					case true:
						continue;
					}
					num2 = 0;
					_ = num2;
					num2 = 0;
					if (num2 != 0)
					{
					}
					num2 = 2;
					num = num2;
					continue;
				}
				case 4:
				{
					short num2 = 1;
					if (num2 != 0)
					{
					}
					return num5 == 0;
				}
				}
				break;
			}
			goto case 0;
		case 0:
		{
			num5 = lhs.Length ^ rhs.Length;
			num4 = 0;
			short num2 = 1;
			num = num2;
			goto default;
		}
		}
	}

	public static string GenerateSalt(int saltSize = 64)
	{
		short num = 0;
		int num2 = num;
		byte[] array = default(byte[]);
		RNGCryptoServiceProvider rNGCryptoServiceProvider = default(RNGCryptoServiceProvider);
		while (true)
		{
			switch (num2)
			{
			case 0:
				switch (0)
				{
				default:
					goto end_IL_001f;
				case 0:
					break;
				}
				goto default;
			default:
				if (saltSize <= 0)
				{
					num = 1;
					num2 = num;
					break;
				}
				array = new byte[saltSize];
				rNGCryptoServiceProvider = new RNGCryptoServiceProvider();
				num = 2;
				num2 = num;
				break;
			case 2:
			{
				num = 1;
				if (num != 0)
				{
				}
				try
				{
					rNGCryptoServiceProvider.GetNonZeroBytes(array);
				}
				finally
				{
					num = 0;
					num2 = num;
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
							if (rNGCryptoServiceProvider != null)
							{
								num = 1;
								num2 = num;
								continue;
							}
							break;
						case 1:
							((IDisposable)rNGCryptoServiceProvider).Dispose();
							num = 2;
							num2 = num;
							continue;
						case 2:
							break;
						}
						break;
					}
				}
				num = -23759;
				short num3 = num;
				num = -23759;
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
					return Convert.ToBase64String(array);
				}
				goto case 0;
			}
			case 1:
				{
					return "";
				}
				end_IL_001f:
				break;
			}
		}
	}
}
