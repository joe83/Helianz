using System;
using System.IO;
using System.IO.Compression;
using System.Security.Cryptography;
using System.Text;

namespace ODCrypt;

public class Encryption
{
	private static string STATIC_KEY
	{
		get
		{
			int a_ = 12;
			short num = 1549;
			short num2 = num;
			num = 1549;
			switch (num2 == num)
			{
			default:
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
				return Sha3.b("♡啣≥奧彩屫⽭䕯㙱䕳䑵㱷䩹㡻㩽뉿랁얃놅춇뺉릋쪍햏횑킓꒕ꦗꦙ궛ꦝ\ue19f鞡\ue1a3鎥馧骩閫\uecad\uf5af薱肳\uf4b5覆莹ﾻ\ufbbd樂\uf1c1\uf3c3菅ￇ柳ￋ\uf8cd\ue7cf\uebd1韓铕鳗\ue2d9鷛\ue7dd\ud8df", a_);
			}
		}
	}

	public static string STATIC_INIT_VECTOR
	{
		get
		{
			int a_ = 0;
			short num = 7100;
			short num2 = num;
			num = 7100;
			switch (num2 == num)
			{
			default:
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
				return Sha3.b("晕桗橙汛湝偟剡呣噥塧婩屫幭䁯䉱䑳䙵䡷䩹䱻乽끿늁뒃뚅뢇몉벋뺍ꂏꊑ꒓", a_);
			}
		}
	}

	public static string GenerateKey()
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = -12556;
		short num2 = num;
		num = -12556;
		switch (num2 == num)
		{
		default:
		{
			num = 0;
			_ = num;
			num = 0;
			if (num != 0)
			{
			}
			SymmetricAlgorithm symmetricAlgorithm = new AesCryptoServiceProvider();
			try
			{
				symmetricAlgorithm.GenerateKey();
				return BytesToString(symmetricAlgorithm.Key, outputAsHex: true);
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
						if (symmetricAlgorithm != null)
						{
							num = 1;
							num3 = num;
							continue;
						}
						break;
					case 1:
						((IDisposable)symmetricAlgorithm).Dispose();
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

	public static string GenerateIV()
	{
		short num = -12759;
		short num2 = num;
		num = -12759;
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
			SymmetricAlgorithm symmetricAlgorithm = new AesCryptoServiceProvider();
			try
			{
				symmetricAlgorithm.GenerateIV();
				return BytesToString(symmetricAlgorithm.IV, outputAsHex: true);
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
						if (symmetricAlgorithm != null)
						{
							num = 1;
							num3 = num;
							continue;
						}
						break;
					case 1:
						((IDisposable)symmetricAlgorithm).Dispose();
						num = 2;
						num3 = num;
						continue;
					case 2:
						num = 1;
						if (num == 0)
						{
						}
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

	public static bool EncryptString(string plainText, bool makeWebFriendly, out string encrypted, ref string failText)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 911;
		short num2 = num;
		num = 911;
		bool result = default(bool);
		switch (num2 == num)
		{
		default:
			num = 0;
			_ = num;
			num = 0;
			if (num != 0)
			{
			}
			encrypted = plainText;
			try
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
						if (!EncryptString(plainText, makeWebFriendly, STATIC_KEY, STATIC_INIT_VECTOR, out encrypted, ref failText))
						{
							num = 1;
							num3 = num;
						}
						else
						{
							result = true;
							num = 2;
							num3 = num;
						}
						continue;
					case 1:
						throw new Exception(failText);
					case 2:
						break;
					}
					break;
				}
			}
			catch (Exception ex)
			{
				failText = ex.Message;
				result = false;
			}
			break;
		case false:
		case true:
			break;
		}
		return result;
	}

	public static bool EncryptString(string plainText, bool makeWebFriendly, string key, string initVector, out string encrypted, ref string failText)
	{
		short num = 0;
		_ = num;
		num = 0;
		switch (num)
		{
		default:
		{
			encrypted = "";
			bool result = default(bool);
			try
			{
				num = 0;
				int num2 = num;
				SymmetricAlgorithm symmetricAlgorithm = default(SymmetricAlgorithm);
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
						if (plainText != null)
						{
							num = 3;
							num2 = num;
							continue;
						}
						goto case 1;
					case 1:
						result = true;
						num = 4;
						num2 = num;
						continue;
					case 4:
						break;
					case 3:
						num = 5;
						num2 = num;
						continue;
					case 5:
						if (plainText.Length <= 0)
						{
							num = 1;
							num2 = num;
							continue;
						}
						w(key, initVector);
						symmetricAlgorithm = new AesCryptoServiceProvider();
						num = 2;
						num2 = num;
						continue;
					case 2:
						num = 1;
						if (num != 0)
						{
						}
						try
						{
							ICryptoTransform transform = symmetricAlgorithm.CreateEncryptor(StringToBytes(key, inputIs7BitAscii: true), StringToBytes(initVector, inputIs7BitAscii: true));
							MemoryStream memoryStream = new MemoryStream();
							try
							{
								num = 21188;
								short num3 = num;
								num = 21188;
								switch (num3 == num)
								{
								default:
								{
									num = 0;
									if (num != 0)
									{
									}
									CryptoStream cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Write);
									try
									{
										StreamWriter streamWriter = new StreamWriter(cryptoStream);
										try
										{
											streamWriter.Write(plainText);
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
													if (streamWriter != null)
													{
														num = 1;
														num2 = num;
														continue;
													}
													break;
												case 1:
													((IDisposable)streamWriter).Dispose();
													num = 2;
													num2 = num;
													continue;
												case 2:
													break;
												}
												break;
											}
										}
										encrypted = BytesToString(memoryStream.ToArray(), makeWebFriendly);
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
												if (cryptoStream != null)
												{
													num = 1;
													num2 = num;
													continue;
												}
												break;
											case 1:
												((IDisposable)cryptoStream).Dispose();
												num = 2;
												num2 = num;
												continue;
											case 2:
												break;
											}
											break;
										}
									}
									break;
								}
								case false:
								case true:
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
										if (memoryStream != null)
										{
											num = 1;
											num2 = num;
											continue;
										}
										break;
									case 1:
										((IDisposable)memoryStream).Dispose();
										num = 2;
										num2 = num;
										continue;
									case 2:
										break;
									}
									break;
								}
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
									if (symmetricAlgorithm != null)
									{
										num = 1;
										num2 = num;
										continue;
									}
									break;
								case 1:
									((IDisposable)symmetricAlgorithm).Dispose();
									num = 2;
									num2 = num;
									continue;
								case 2:
									break;
								}
								break;
							}
						}
						result = true;
						num = 6;
						num2 = num;
						continue;
					case 6:
						break;
					}
					break;
				}
			}
			catch (Exception ex)
			{
				failText = ex.Message;
				result = false;
			}
			return result;
		}
		}
	}

	public static bool EncryptBytes(byte[] byteArray, bool makeWebFriendly, string key, string initVector, out string encrypted, ref string failText)
	{
		short num = 0;
		_ = num;
		num = -23078;
		short num2 = num;
		num = -23078;
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
			switch (num)
			{
			}
			break;
		case false:
		case true:
			break;
		}
		encrypted = "";
		bool result = default(bool);
		try
		{
			num = 0;
			int num3 = num;
			SymmetricAlgorithm symmetricAlgorithm = default(SymmetricAlgorithm);
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
					if (byteArray != null)
					{
						num = 3;
						num3 = num;
						continue;
					}
					goto case 1;
				case 1:
					result = true;
					num = 4;
					num3 = num;
					continue;
				case 4:
					break;
				case 3:
					num = 5;
					num3 = num;
					continue;
				case 5:
					if (byteArray.Length == 0)
					{
						num = 1;
						num3 = num;
						continue;
					}
					w(key, initVector);
					symmetricAlgorithm = new AesCryptoServiceProvider();
					num = 2;
					num3 = num;
					continue;
				case 2:
					try
					{
						ICryptoTransform transform = symmetricAlgorithm.CreateEncryptor(StringToBytes(key, inputIs7BitAscii: true), StringToBytes(initVector, inputIs7BitAscii: true));
						MemoryStream memoryStream = new MemoryStream();
						try
						{
							CryptoStream cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Write);
							try
							{
								cryptoStream.Write(byteArray, 0, byteArray.Length);
								encrypted = BytesToString(memoryStream.ToArray(), makeWebFriendly);
							}
							finally
							{
								num = 0;
								num3 = num;
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
										if (cryptoStream != null)
										{
											num = 1;
											num3 = num;
											continue;
										}
										break;
									case 1:
										((IDisposable)cryptoStream).Dispose();
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
						finally
						{
							num = 0;
							num3 = num;
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
									if (memoryStream != null)
									{
										num = 1;
										num3 = num;
										continue;
									}
									break;
								case 1:
									((IDisposable)memoryStream).Dispose();
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
					finally
					{
						num = 0;
						num3 = num;
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
								if (symmetricAlgorithm != null)
								{
									num = 1;
									num3 = num;
									continue;
								}
								break;
							case 1:
								((IDisposable)symmetricAlgorithm).Dispose();
								num = 2;
								num3 = num;
								continue;
							case 2:
								break;
							}
							break;
						}
					}
					result = true;
					num = 6;
					num3 = num;
					continue;
				case 6:
					break;
				}
				break;
			}
		}
		catch (Exception ex)
		{
			failText = ex.Message;
			result = false;
		}
		return result;
	}

	public static bool EncryptFile(string originalFileName, string encryptedFileName, string key, string initVector, ref string failText)
	{
		int a_ = 6;
		bool result = default(bool);
		short num;
		try
		{
			num = 0;
			switch (num)
			{
			default:
			{
				num = 0;
				int num2 = num;
				SymmetricAlgorithm symmetricAlgorithm = default(SymmetricAlgorithm);
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
						if (!File.Exists(originalFileName))
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
					case 2:
						try
						{
							ICryptoTransform transform = symmetricAlgorithm.CreateEncryptor(StringToBytes(key, inputIs7BitAscii: true), StringToBytes(initVector, inputIs7BitAscii: true));
							FileStream fileStream = new FileStream(originalFileName, FileMode.Open);
							try
							{
								FileStream fileStream2 = new FileStream(encryptedFileName, FileMode.CreateNew);
								try
								{
									CryptoStream cryptoStream = new CryptoStream(fileStream2, transform, CryptoStreamMode.Write);
									try
									{
										fileStream.CopyTo(cryptoStream);
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
												if (cryptoStream != null)
												{
													num = 1;
													num2 = num;
													continue;
												}
												break;
											case 1:
												((IDisposable)cryptoStream).Dispose();
												num = 2;
												num2 = num;
												continue;
											case 2:
												break;
											}
											break;
										}
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
											if (fileStream2 != null)
											{
												num = 1;
												num2 = num;
												continue;
											}
											break;
										case 1:
											((IDisposable)fileStream2).Dispose();
											num = 2;
											num2 = num;
											continue;
										case 2:
											break;
										}
										break;
									}
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
										if (fileStream != null)
										{
											num = 1;
											num2 = num;
											continue;
										}
										break;
									case 1:
										((IDisposable)fileStream).Dispose();
										num = 2;
										num2 = num;
										continue;
									case 2:
										break;
									}
									break;
								}
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
									if (symmetricAlgorithm != null)
									{
										num = 1;
										num2 = num;
										continue;
									}
									break;
								case 1:
									((IDisposable)symmetricAlgorithm).Dispose();
									num = 2;
									num2 = num;
									continue;
								case 2:
									break;
								}
								break;
							}
						}
						result = true;
						break;
					case 3:
						throw new Exception(Sha3.b("\u1a5b㝝\u0c5fݡ䑣䅥", a_) + originalFileName + Sha3.b("筛繝џൡţᕥ䡧ѩ\u036b\u1a6d偯\u1771\u0c73ή୷\u0e79剻", a_));
					case 5:
						if (File.Exists(encryptedFileName))
						{
							num = 1;
							num2 = num;
							continue;
						}
						goto case 4;
					case 1:
					{
						num = 76;
						short num3 = num;
						num = 76;
						switch (num3 == num)
						{
						default:
							num = 0;
							if (num != 0)
							{
							}
							File.Delete(encryptedFileName);
							num = 4;
							num2 = num;
							continue;
						case false:
						case true:
							break;
						}
						break;
					}
					case 4:
						w(key, initVector);
						symmetricAlgorithm = new AesCryptoServiceProvider();
						num = 2;
						num2 = num;
						continue;
					case 6:
						goto end_IL_0046;
					}
					num = 6;
					num2 = num;
					continue;
					end_IL_0046:
					break;
				}
				break;
			}
			}
		}
		catch (Exception ex)
		{
			failText = ex.Message;
			result = false;
		}
		num = 0;
		_ = num;
		num = 1;
		if (num != 0)
		{
		}
		return result;
	}

	public static string EncodeForUnicode(string plainText)
	{
		int a_ = 18;
		short num = 0;
		int num2 = num;
		switch (num2)
		{
		default:
		{
			int num4 = default(int);
			StringBuilder stringBuilder = default(StringBuilder);
			char[] array = default(char[]);
			switch (0)
			{
			default:
			{
				char c = default(char);
				while (true)
				{
					switch (num2)
					{
					case 3:
					case 7:
						num4++;
						num = 6;
						num2 = num;
						continue;
					case 0:
						if (c <= '\u007f')
						{
							stringBuilder.Append(c);
							num = 7;
							num2 = num;
						}
						else
						{
							num = 5;
							num2 = num;
						}
						continue;
					case 1:
					case 6:
						num = 4;
						num2 = num;
						continue;
					case 4:
						while (true)
						{
							if (num4 < array.Length)
							{
								num = 1;
								if (num != 0)
								{
								}
								num = 12120;
								short num5 = num;
								num = 12120;
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
								c = array[num4];
								num = 0;
								num2 = num;
							}
							else
							{
								num = 2;
								num2 = num;
							}
							break;
						}
						continue;
					case 5:
					{
						num = 0;
						_ = num;
						stringBuilder.Append('\0');
						ushort num3 = c;
						string value = num3.ToString(Sha3.b("\u1067幩", a_));
						stringBuilder.Append(value);
						num = 3;
						num2 = num;
						continue;
					}
					case 2:
						return stringBuilder.ToString();
					}
					break;
				}
				goto case 0;
			}
			case 0:
				stringBuilder = new StringBuilder();
				array = plainText.ToCharArray();
				num4 = 0;
				num = 1;
				num2 = num;
				goto default;
			}
		}
		}
	}

	public static string DecodeForUnicode(string encoded)
	{
		short num = 0;
		int num2 = num;
		switch (num2)
		{
		default:
		{
			num = 1;
			if (num != 0)
			{
			}
			StringBuilder stringBuilder = default(StringBuilder);
			int num3 = default(int);
			byte[] bytes = default(byte[]);
			switch (0)
			{
			default:
			{
				char c = default(char);
				while (true)
				{
					switch (num2)
					{
					case 2:
						stringBuilder.Append(c);
						num3++;
						goto IL_00b5;
					case 3:
						c = Convert.ToChar(Convert.ToUInt32(new string(new char[4]
						{
							(char)bytes[num3 + 1],
							(char)bytes[num3 + 2],
							(char)bytes[num3 + 3],
							(char)bytes[num3 + 4]
						}), 16));
						num3 += 4;
						num = 2;
						num2 = num;
						continue;
					case 4:
						if (c == '\0')
						{
							num = 3;
							num2 = num;
							continue;
						}
						goto case 2;
					case 0:
					case 6:
					{
						num = -28806;
						short num4 = num;
						num = -28806;
						switch (num4 == num)
						{
						case false:
						case true:
							break;
						default:
							num = 0;
							_ = num;
							goto case true;
						case true:
							num = 0;
							if (num != 0)
							{
							}
							num = 1;
							num2 = num;
							continue;
						}
						goto IL_00b5;
					}
					case 1:
						if (num3 < bytes.Length)
						{
							c = (char)bytes[num3];
							num = 4;
							num2 = num;
						}
						else
						{
							num = 5;
							num2 = num;
						}
						continue;
					case 5:
						{
							return stringBuilder.ToString();
						}
						IL_00b5:
						num = 6;
						num2 = num;
						continue;
					}
					break;
				}
				goto case 0;
			}
			case 0:
			{
				stringBuilder = new StringBuilder();
				char[] chars = encoded.ToCharArray();
				bytes = Encoding.UTF8.GetBytes(chars);
				num3 = 0;
				num = 0;
				num2 = num;
				goto default;
			}
			}
		}
		}
	}

	public static bool DecryptString(string encrypted, bool isWebFriendly, out string plainText, ref string failText)
	{
		short num = 0;
		_ = num;
		num = -25680;
		short num2 = num;
		num = -25680;
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
			return DecryptString(encrypted, isWebFriendly, STATIC_KEY, STATIC_INIT_VECTOR, out plainText, ref failText);
		}
	}

	public static bool DecryptString(string encrypted, bool isWebFriendly, string key, string initVector, out string plainText, ref string failText)
	{
		short num = 0;
		_ = num;
		num = 0;
		switch (num)
		{
		default:
		{
			num = -8089;
			short num2 = num;
			num = -8089;
			bool result = default(bool);
			switch (num2 == num)
			{
			default:
				num = 0;
				if (num != 0)
				{
				}
				plainText = "";
				try
				{
					num = 0;
					int num3 = num;
					SymmetricAlgorithm symmetricAlgorithm = default(SymmetricAlgorithm);
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
							if (encrypted != null)
							{
								num = 6;
								num3 = num;
								continue;
							}
							goto case 3;
						case 6:
							num = 1;
							if (num != 0)
							{
							}
							num = 4;
							num3 = num;
							continue;
						case 3:
							result = true;
							num = 2;
							num3 = num;
							continue;
						case 2:
							break;
						case 4:
							if (encrypted.Length <= 0)
							{
								num = 3;
								num3 = num;
								continue;
							}
							w(key, initVector);
							symmetricAlgorithm = new AesCryptoServiceProvider();
							num = 1;
							num3 = num;
							continue;
						case 1:
							try
							{
								symmetricAlgorithm.Key = StringToBytes(key, inputIs7BitAscii: true);
								symmetricAlgorithm.IV = StringToBytes(initVector, inputIs7BitAscii: true);
								ICryptoTransform transform = symmetricAlgorithm.CreateDecryptor(symmetricAlgorithm.Key, symmetricAlgorithm.IV);
								MemoryStream memoryStream = new MemoryStream(StringToBytes(encrypted, isWebFriendly));
								try
								{
									CryptoStream cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Read);
									try
									{
										StreamReader streamReader = new StreamReader(cryptoStream);
										try
										{
											plainText = streamReader.ReadToEnd();
										}
										finally
										{
											num = 2;
											num3 = num;
											while (true)
											{
												switch (num3)
												{
												case 2:
													switch (0)
													{
													default:
														continue;
													case 0:
														break;
													}
													goto default;
												default:
													if (streamReader != null)
													{
														num = 0;
														num3 = num;
														continue;
													}
													break;
												case 0:
													((IDisposable)streamReader).Dispose();
													num = 1;
													num3 = num;
													continue;
												case 1:
													break;
												}
												break;
											}
										}
									}
									finally
									{
										num = 2;
										num3 = num;
										while (true)
										{
											switch (num3)
											{
											case 2:
												switch (0)
												{
												default:
													continue;
												case 0:
													break;
												}
												goto default;
											default:
												if (cryptoStream != null)
												{
													num = 0;
													num3 = num;
													continue;
												}
												break;
											case 0:
												((IDisposable)cryptoStream).Dispose();
												num = 1;
												num3 = num;
												continue;
											case 1:
												break;
											}
											break;
										}
									}
								}
								finally
								{
									num = 2;
									num3 = num;
									while (true)
									{
										switch (num3)
										{
										case 2:
											switch (0)
											{
											default:
												continue;
											case 0:
												break;
											}
											goto default;
										default:
											if (memoryStream != null)
											{
												num = 0;
												num3 = num;
												continue;
											}
											break;
										case 0:
											((IDisposable)memoryStream).Dispose();
											num = 1;
											num3 = num;
											continue;
										case 1:
											break;
										}
										break;
									}
								}
							}
							finally
							{
								num = 2;
								num3 = num;
								while (true)
								{
									switch (num3)
									{
									case 2:
										switch (0)
										{
										default:
											continue;
										case 0:
											break;
										}
										goto default;
									default:
										if (symmetricAlgorithm != null)
										{
											num = 0;
											num3 = num;
											continue;
										}
										break;
									case 0:
										((IDisposable)symmetricAlgorithm).Dispose();
										num = 1;
										num3 = num;
										continue;
									case 1:
										break;
									}
									break;
								}
							}
							result = true;
							num = 5;
							num3 = num;
							continue;
						case 5:
							break;
						}
						break;
					}
				}
				catch (Exception ex)
				{
					failText = ex.Message;
					result = false;
				}
				break;
			case false:
			case true:
				break;
			}
			return result;
		}
		}
	}

	public static bool DecryptString(string encrypted, bool isWebFriendly, string key, string initVector, out byte[] bytes, ref string failText)
	{
		short num = 0;
		_ = num;
		num = 0;
		switch (num)
		{
		default:
		{
			num = -4589;
			short num2 = num;
			num = -4589;
			bool result = default(bool);
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
				bytes = null;
				try
				{
					num = 0;
					int num3 = num;
					SymmetricAlgorithm symmetricAlgorithm = default(SymmetricAlgorithm);
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
							if (string.IsNullOrEmpty(encrypted))
							{
								num = 4;
								num3 = num;
								continue;
							}
							w(key, initVector);
							symmetricAlgorithm = new AesCryptoServiceProvider();
							num = 1;
							num3 = num;
							continue;
						case 4:
							result = true;
							num = 2;
							num3 = num;
							continue;
						case 2:
							break;
						case 1:
							try
							{
								symmetricAlgorithm.Key = StringToBytes(key, inputIs7BitAscii: true);
								symmetricAlgorithm.IV = StringToBytes(initVector, inputIs7BitAscii: true);
								symmetricAlgorithm.Padding = PaddingMode.None;
								ICryptoTransform transform = symmetricAlgorithm.CreateDecryptor(symmetricAlgorithm.Key, symmetricAlgorithm.IV);
								MemoryStream memoryStream = new MemoryStream(StringToBytes(encrypted, isWebFriendly));
								try
								{
									CryptoStream cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Read);
									try
									{
										StreamReader streamReader = new StreamReader(cryptoStream);
										try
										{
											MemoryStream memoryStream2 = new MemoryStream();
											try
											{
												streamReader.BaseStream.CopyTo(memoryStream2);
												bytes = memoryStream2.ToArray();
											}
											finally
											{
												num = 2;
												num3 = num;
												while (true)
												{
													switch (num3)
													{
													case 2:
														switch (0)
														{
														default:
															continue;
														case 0:
															break;
														}
														goto default;
													default:
														if (memoryStream2 != null)
														{
															num = 0;
															num3 = num;
															continue;
														}
														break;
													case 0:
														((IDisposable)memoryStream2).Dispose();
														num = 1;
														num3 = num;
														continue;
													case 1:
														break;
													}
													break;
												}
											}
										}
										finally
										{
											num = 2;
											num3 = num;
											while (true)
											{
												switch (num3)
												{
												case 2:
													switch (0)
													{
													default:
														continue;
													case 0:
														break;
													}
													goto default;
												default:
													if (streamReader != null)
													{
														num = 0;
														num3 = num;
														continue;
													}
													break;
												case 0:
													((IDisposable)streamReader).Dispose();
													num = 1;
													num3 = num;
													continue;
												case 1:
													break;
												}
												break;
											}
										}
									}
									finally
									{
										num = 2;
										num3 = num;
										while (true)
										{
											switch (num3)
											{
											case 2:
												switch (0)
												{
												default:
													continue;
												case 0:
													break;
												}
												goto default;
											default:
												if (cryptoStream != null)
												{
													num = 0;
													num3 = num;
													continue;
												}
												break;
											case 0:
												((IDisposable)cryptoStream).Dispose();
												num = 1;
												num3 = num;
												continue;
											case 1:
												break;
											}
											break;
										}
									}
								}
								finally
								{
									num = 2;
									num3 = num;
									while (true)
									{
										switch (num3)
										{
										case 2:
											switch (0)
											{
											default:
												continue;
											case 0:
												break;
											}
											goto default;
										default:
											if (memoryStream != null)
											{
												num = 0;
												num3 = num;
												continue;
											}
											break;
										case 0:
											((IDisposable)memoryStream).Dispose();
											num = 1;
											num3 = num;
											continue;
										case 1:
											break;
										}
										break;
									}
								}
							}
							finally
							{
								num = 2;
								num3 = num;
								while (true)
								{
									switch (num3)
									{
									case 2:
										switch (0)
										{
										default:
											continue;
										case 0:
											break;
										}
										goto default;
									default:
										if (symmetricAlgorithm != null)
										{
											num = 0;
											num3 = num;
											continue;
										}
										break;
									case 0:
										((IDisposable)symmetricAlgorithm).Dispose();
										num = 1;
										num3 = num;
										continue;
									case 1:
										break;
									}
									break;
								}
							}
							result = true;
							num = 3;
							num3 = num;
							continue;
						case 3:
							break;
						}
						break;
					}
				}
				catch (Exception ex)
				{
					failText = ex.Message;
					result = false;
				}
				break;
			case false:
			case true:
				break;
			}
			return result;
		}
		}
	}

	public static bool DecryptFile(string encryptedFileName, string decryptedFileName, string key, string initVector, ref string failText)
	{
		int a_ = 12;
		bool result = default(bool);
		short num;
		try
		{
			num = 0;
			switch (num)
			{
			default:
			{
				num = 0;
				int num2 = num;
				SymmetricAlgorithm symmetricAlgorithm = default(SymmetricAlgorithm);
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
						if (!File.Exists(encryptedFileName))
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
					case 1:
						try
						{
							ICryptoTransform transform = symmetricAlgorithm.CreateDecryptor(StringToBytes(key, inputIs7BitAscii: true), StringToBytes(initVector, inputIs7BitAscii: true));
							FileStream fileStream = new FileStream(encryptedFileName, FileMode.Open);
							try
							{
								while (true)
								{
									FileStream fileStream2 = new FileStream(decryptedFileName, FileMode.CreateNew);
									try
									{
										CryptoStream cryptoStream = new CryptoStream(fileStream2, transform, CryptoStreamMode.Write);
										try
										{
											fileStream.CopyTo(cryptoStream);
										}
										finally
										{
											num = 2;
											num2 = num;
											while (true)
											{
												switch (num2)
												{
												case 2:
													switch (0)
													{
													default:
														continue;
													case 0:
														break;
													}
													goto default;
												default:
													if (cryptoStream != null)
													{
														num = 0;
														num2 = num;
														continue;
													}
													break;
												case 0:
													((IDisposable)cryptoStream).Dispose();
													num = 1;
													num2 = num;
													continue;
												case 1:
													break;
												}
												break;
											}
										}
									}
									finally
									{
										num = 2;
										num2 = num;
										while (true)
										{
											switch (num2)
											{
											case 2:
												switch (0)
												{
												default:
													continue;
												case 0:
													break;
												}
												goto default;
											default:
												if (fileStream2 != null)
												{
													num = 0;
													num2 = num;
													continue;
												}
												break;
											case 0:
												((IDisposable)fileStream2).Dispose();
												num = 1;
												num2 = num;
												continue;
											case 1:
												break;
											}
											break;
										}
									}
									num = -30248;
									short num3 = num;
									num = -30248;
									switch (num3 == num)
									{
									case false:
									case true:
										continue;
									}
									num = 0;
									if (num == 0)
									{
									}
									break;
								}
							}
							finally
							{
								num = 2;
								num2 = num;
								while (true)
								{
									switch (num2)
									{
									case 2:
										switch (0)
										{
										default:
											continue;
										case 0:
											break;
										}
										goto default;
									default:
										if (fileStream != null)
										{
											num = 0;
											num2 = num;
											continue;
										}
										break;
									case 0:
										((IDisposable)fileStream).Dispose();
										num = 1;
										num2 = num;
										continue;
									case 1:
										break;
									}
									break;
								}
							}
						}
						finally
						{
							num = 2;
							num2 = num;
							while (true)
							{
								switch (num2)
								{
								case 2:
									switch (0)
									{
									default:
										continue;
									case 0:
										break;
									}
									goto default;
								default:
									if (symmetricAlgorithm != null)
									{
										num = 0;
										num2 = num;
										continue;
									}
									break;
								case 0:
									((IDisposable)symmetricAlgorithm).Dispose();
									num = 1;
									num2 = num;
									continue;
								case 1:
									break;
								}
								break;
							}
						}
						result = true;
						num = 5;
						num2 = num;
						continue;
					case 3:
						File.Delete(decryptedFileName);
						num = 2;
						num2 = num;
						continue;
					case 6:
						throw new Exception(Sha3.b("②\u0d63\u0a65൧䩩䭫", a_) + encryptedFileName + Sha3.b("䕡䑣ɥݧཀྵὫ乭ṯᵱs噵ᵷɹᕻൽ\uf47f겁", a_));
					case 4:
						if (File.Exists(decryptedFileName))
						{
							num = 3;
							num2 = num;
							continue;
						}
						break;
					case 2:
						break;
					case 5:
						goto end_IL_0047;
					}
					w(key, initVector);
					symmetricAlgorithm = new AesCryptoServiceProvider();
					num = 1;
					num2 = num;
					continue;
					end_IL_0047:
					break;
				}
				break;
			}
			}
		}
		catch (Exception ex)
		{
			failText = ex.Message;
			result = false;
		}
		num = 1;
		if (num != 0)
		{
		}
		num = 0;
		_ = num;
		return result;
	}

	public static bool CompressString(string unzipped, out string zipped, ref string failText)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 0;
		switch (num)
		{
		default:
		{
			num = 0;
			_ = num;
			zipped = "";
			bool result = default(bool);
			try
			{
				num = 0;
				int num2 = num;
				MemoryStream memoryStream2 = default(MemoryStream);
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
						if (unzipped != null)
						{
							num = 6;
							num2 = num;
							continue;
						}
						goto case 3;
					case 3:
						result = true;
						num = 2;
						num2 = num;
						continue;
					case 2:
						break;
					case 6:
						num = 4;
						num2 = num;
						continue;
					case 4:
						if (unzipped.Length <= 0)
						{
							num = 3;
							num2 = num;
						}
						else
						{
							memoryStream2 = new MemoryStream(Encoding.UTF8.GetBytes(unzipped));
							num = 1;
							num2 = num;
						}
						continue;
					case 1:
						try
						{
							while (true)
							{
								MemoryStream memoryStream = new MemoryStream();
								try
								{
									GZipStream gZipStream = new GZipStream(memoryStream, CompressionMode.Compress);
									try
									{
										w(memoryStream2, gZipStream);
									}
									finally
									{
										num = 2;
										num2 = num;
										while (true)
										{
											switch (num2)
											{
											case 2:
												switch (0)
												{
												default:
													continue;
												case 0:
													break;
												}
												goto default;
											default:
												if (gZipStream != null)
												{
													num = 0;
													num2 = num;
													continue;
												}
												break;
											case 0:
												((IDisposable)gZipStream).Dispose();
												num = 1;
												num2 = num;
												continue;
											case 1:
												break;
											}
											break;
										}
									}
									zipped = Convert.ToBase64String(memoryStream.ToArray());
								}
								finally
								{
									num = 2;
									num2 = num;
									while (true)
									{
										switch (num2)
										{
										case 2:
											switch (0)
											{
											default:
												continue;
											case 0:
												break;
											}
											goto default;
										default:
											if (memoryStream != null)
											{
												num = 0;
												num2 = num;
												continue;
											}
											break;
										case 0:
											((IDisposable)memoryStream).Dispose();
											num = 1;
											num2 = num;
											continue;
										case 1:
											break;
										}
										break;
									}
								}
								num = -6538;
								short num3 = num;
								num = -6538;
								switch (num3 == num)
								{
								case false:
								case true:
									continue;
								}
								num = 0;
								if (num == 0)
								{
								}
								break;
							}
						}
						finally
						{
							num = 2;
							num2 = num;
							while (true)
							{
								switch (num2)
								{
								case 2:
									switch (0)
									{
									default:
										continue;
									case 0:
										break;
									}
									goto default;
								default:
									if (memoryStream2 != null)
									{
										num = 0;
										num2 = num;
										continue;
									}
									break;
								case 0:
									((IDisposable)memoryStream2).Dispose();
									num = 1;
									num2 = num;
									continue;
								case 1:
									break;
								}
								break;
							}
						}
						result = true;
						num = 5;
						num2 = num;
						continue;
					case 5:
						break;
					}
					break;
				}
			}
			catch (Exception ex)
			{
				failText = ex.Message;
				result = false;
			}
			return result;
		}
		}
	}

	public static bool DecompressString(string zipped, out string plainText, ref string failText)
	{
		short num = 1;
		if (num != 0)
		{
		}
		num = 0;
		switch (num)
		{
		default:
		{
			num = 0;
			_ = num;
			plainText = "";
			bool result = default(bool);
			try
			{
				num = 0;
				int num2 = num;
				MemoryStream memoryStream2 = default(MemoryStream);
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
						if (zipped != null)
						{
							num = 6;
							num2 = num;
							continue;
						}
						goto case 3;
					case 3:
						result = true;
						num = 2;
						num2 = num;
						continue;
					case 2:
						break;
					case 6:
						num = 4;
						num2 = num;
						continue;
					case 4:
						if (zipped.Length <= 0)
						{
							num = 3;
							num2 = num;
						}
						else
						{
							memoryStream2 = new MemoryStream(Convert.FromBase64String(zipped));
							num = 1;
							num2 = num;
						}
						continue;
					case 1:
						try
						{
							while (true)
							{
								MemoryStream memoryStream = new MemoryStream();
								try
								{
									GZipStream gZipStream = new GZipStream(memoryStream2, CompressionMode.Decompress);
									try
									{
										w(gZipStream, memoryStream);
									}
									finally
									{
										num = 2;
										num2 = num;
										while (true)
										{
											switch (num2)
											{
											case 2:
												switch (0)
												{
												default:
													continue;
												case 0:
													break;
												}
												goto default;
											default:
												if (gZipStream != null)
												{
													num = 0;
													num2 = num;
													continue;
												}
												break;
											case 0:
												((IDisposable)gZipStream).Dispose();
												num = 1;
												num2 = num;
												continue;
											case 1:
												break;
											}
											break;
										}
									}
									plainText = Encoding.UTF8.GetString(memoryStream.ToArray());
								}
								finally
								{
									num = 2;
									num2 = num;
									while (true)
									{
										switch (num2)
										{
										case 2:
											switch (0)
											{
											default:
												continue;
											case 0:
												break;
											}
											goto default;
										default:
											if (memoryStream != null)
											{
												num = 0;
												num2 = num;
												continue;
											}
											break;
										case 0:
											((IDisposable)memoryStream).Dispose();
											num = 1;
											num2 = num;
											continue;
										case 1:
											break;
										}
										break;
									}
								}
								num = 4428;
								short num3 = num;
								num = 4428;
								switch (num3 == num)
								{
								case false:
								case true:
									continue;
								}
								num = 0;
								if (num == 0)
								{
								}
								break;
							}
						}
						finally
						{
							num = 2;
							num2 = num;
							while (true)
							{
								switch (num2)
								{
								case 2:
									switch (0)
									{
									default:
										continue;
									case 0:
										break;
									}
									goto default;
								default:
									if (memoryStream2 != null)
									{
										num = 0;
										num2 = num;
										continue;
									}
									break;
								case 0:
									((IDisposable)memoryStream2).Dispose();
									num = 1;
									num2 = num;
									continue;
								case 1:
									break;
								}
								break;
							}
						}
						result = true;
						num = 5;
						num2 = num;
						continue;
					case 5:
						break;
					}
					break;
				}
			}
			catch (Exception ex)
			{
				failText = ex.Message;
				result = false;
			}
			return result;
		}
		}
	}

	private static void w(string A_0, string A_1)
	{
		int a_ = 14;
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
					goto end_IL_002a;
				case 0:
					break;
				}
				goto default;
			default:
				if (A_0 != null)
				{
					num = 6;
					num2 = num;
					break;
				}
				goto case 3;
			case 4:
				num = 7;
				num2 = num;
				break;
			case 7:
				if (A_1.Length <= 0)
				{
					num = 0;
					num2 = num;
					break;
				}
				num = 1;
				if (num == 0)
				{
				}
				return;
			case 5:
				if (A_1 != null)
				{
					num = 0;
					_ = num;
					num = -25045;
					short num3 = num;
					num = -25045;
					switch (num3 == num)
					{
					default:
						num = 0;
						if (num != 0)
						{
						}
						num = 4;
						num2 = num;
						goto end_IL_002a;
					case false:
					case true:
						break;
					}
					goto IL_017c;
				}
				goto case 0;
			case 6:
				num = 2;
				num2 = num;
				break;
			case 2:
				if (A_0.Length > 0)
				{
					num = 5;
					num2 = num;
					break;
				}
				goto IL_017c;
			case 0:
				throw new ArgumentNullException(Sha3.b("\u0d63ࡥŧṩ㩫୭፯ٱ\u1b73ѵ", a_));
			case 3:
				{
					throw new ArgumentNullException(Sha3.b("ལ\u0365ᅧ", a_));
				}
				IL_017c:
				num = 3;
				num2 = num;
				break;
				end_IL_002a:
				break;
			}
		}
	}

	private static void w(Stream A_0, Stream A_1)
	{
		int num = default(int);
		byte[] array = default(byte[]);
		switch (0)
		{
		default:
			while (true)
			{
				switch (num)
				{
				case 2:
				{
					short num2 = 3;
					num = num2;
					continue;
				}
				case 3:
				{
					int count;
					short num2;
					if ((count = A_0.Read(array, 0, array.Length)) == 0)
					{
						num2 = 0;
						num = num2;
						continue;
					}
					while (true)
					{
						A_1.Write(array, 0, count);
						num2 = 18618;
						short num3 = num2;
						num2 = 18618;
						switch (num3 == num2)
						{
						case false:
						case true:
							continue;
						}
						break;
					}
					num2 = 0;
					if (num2 != 0)
					{
					}
					num2 = 1;
					num = num2;
					continue;
				}
				case 0:
					return;
				case 1:
				{
					short num2 = 0;
					_ = num2;
					goto case 2;
				}
				}
				break;
			}
			goto case 0;
		case 0:
		{
			short num2 = 1;
			if (num2 != 0)
			{
			}
			array = new byte[4096];
			num2 = 2;
			num = num2;
			goto default;
		}
		}
	}

	public static string BytesToString(byte[] asBytes, bool outputAsHex)
	{
		int a_ = 5;
		short num = 0;
		switch (num)
		{
		default:
		{
			num = 3;
			int num2 = num;
			int num3 = default(int);
			byte[] array = default(byte[]);
			StringBuilder stringBuilder = default(StringBuilder);
			while (true)
			{
				switch (num2)
				{
				case 3:
					switch (0)
					{
					default:
						goto end_IL_0048;
					case 0:
						break;
					}
					goto default;
				default:
				{
					if (asBytes == null)
					{
						goto case 6;
					}
					num = 31932;
					short num4 = num;
					num = 31932;
					switch (num4 == num)
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
						num = 2;
						num2 = num;
						goto end_IL_0048;
					case false:
					case true:
						break;
					}
					goto IL_0170;
				}
				case 8:
					return BitConverter.ToString(asBytes).Replace(Sha3.b("癚", a_), "");
				case 6:
					return "";
				case 9:
					num = 1;
					num2 = num;
					break;
				case 1:
					if (num3 < array.Length)
					{
						byte value = array[num3];
						stringBuilder.Append((char)value);
						num3++;
						num = 0;
						num2 = num;
						break;
					}
					goto IL_0170;
				case 2:
					num = 7;
					num2 = num;
					break;
				case 7:
					if (asBytes.Length == 0)
					{
						num = 6;
						num2 = num;
					}
					else
					{
						num = 4;
						num2 = num;
					}
					break;
				case 0:
					num = 0;
					_ = num;
					goto case 9;
				case 4:
					if (!outputAsHex)
					{
						stringBuilder = new StringBuilder();
						array = asBytes;
						num3 = 0;
						num = 9;
						num2 = num;
					}
					else
					{
						num = 8;
						num2 = num;
					}
					break;
				case 5:
					{
						return stringBuilder.ToString();
					}
					IL_0170:
					num = 5;
					num2 = num;
					break;
					end_IL_0048:
					break;
				}
			}
		}
		}
	}

	public static byte[] StringToBytes(string asString, bool inputIs7BitAscii)
	{
		short num = 0;
		switch (num)
		{
		default:
		{
			num = 4;
			int num2 = num;
			int num5 = default(int);
			int num4 = default(int);
			byte[] array2 = default(byte[]);
			StringReader stringReader = default(StringReader);
			int num3 = default(int);
			char[] array = default(char[]);
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
					if (asString != null)
					{
						num = 1;
						num2 = num;
						continue;
					}
					goto case 0;
				case 2:
					try
					{
						switch (0)
						{
						default:
							while (true)
							{
								switch (num2)
								{
								case 0:
								case 1:
									goto IL_0149;
								case 4:
									goto IL_0161;
								case 2:
									num = 3;
									num2 = num;
									continue;
								case 3:
									goto end_IL_00c0;
								}
								break;
								IL_0161:
								if (num5 >= num4)
								{
									num = 2;
									num2 = num;
									continue;
								}
								array2[num5] = Convert.ToByte(new string(new char[2]
								{
									(char)stringReader.Read(),
									(char)stringReader.Read()
								}), 16);
								num5++;
								num = 1;
								num2 = num;
							}
							goto case 0;
						case 0:
							{
								num = -28880;
								short num6 = num;
								num = -28880;
								switch (num6 == num)
								{
								case false:
								case true:
									goto IL_0149;
								}
								num = 0;
								if (num != 0)
								{
								}
								num5 = 0;
								num = 0;
								num2 = num;
								goto default;
							}
							IL_0149:
							num = 4;
							num2 = num;
							goto default;
							end_IL_00c0:
							break;
						}
					}
					finally
					{
						num = 2;
						num2 = num;
						while (true)
						{
							switch (num2)
							{
							case 2:
								switch (0)
								{
								default:
									continue;
								case 0:
									break;
								}
								goto default;
							default:
								if (stringReader != null)
								{
									num = 0;
									num2 = num;
									continue;
								}
								break;
							case 0:
								((IDisposable)stringReader).Dispose();
								num = 1;
								num2 = num;
								continue;
							case 1:
								break;
							}
							break;
						}
					}
					break;
				case 0:
					return new byte[0];
				case 5:
					num = 1;
					if (num == 0)
					{
					}
					goto case 10;
				case 1:
					num = 6;
					num2 = num;
					continue;
				case 6:
					if (asString.Length <= 0)
					{
						num = 0;
						num2 = num;
						continue;
					}
					num = 0;
					_ = num;
					num = 3;
					num2 = num;
					continue;
				case 10:
					num = 8;
					num2 = num;
					continue;
				case 8:
					if (num3 < array.Length)
					{
						array2[num3] = (byte)array[num3];
						num3++;
						num = 5;
						num2 = num;
					}
					else
					{
						num = 7;
						num2 = num;
					}
					continue;
				case 9:
					num4 = asString.Length / 2;
					array2 = new byte[num4];
					stringReader = new StringReader(asString);
					num = 2;
					num2 = num;
					continue;
				case 3:
					if (!inputIs7BitAscii)
					{
						array = asString.ToCharArray();
						array2 = new byte[array.Length];
						num3 = 0;
						num = 10;
						num2 = num;
					}
					else
					{
						num = 9;
						num2 = num;
					}
					continue;
				case 7:
					break;
				}
				break;
			}
			return array2;
		}
		}
	}
}
