// IL code: ODCrypt
.class private auto ansi '<Module>'
{
} // end of class <Module>

.class public auto ansi sealed beforefieldinit DotfuscatorAttribute
	extends [mscorlib]System.Attribute
{
	.custom instance void [mscorlib]System.AttributeUsageAttribute::.ctor(valuetype [mscorlib]System.AttributeTargets) = (
		01 00 01 00 00 00 00 00
	)
	.custom instance void [mscorlib]System.Runtime.InteropServices.ComVisibleAttribute::.ctor(bool) = (
		01 00 00 00 00
	)
	// Fields
	.field private string a
	.field private int32 c

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			string a,
			int32 c
		) cil managed 
	{
		// Method begins at RVA 0x2050
		// Header size: 12
		// Code size: 21 (0x15)
		.maxstack 2

		IL_0000: ldarg.0
		IL_0001: dup
		IL_0002: call instance void [mscorlib]System.Attribute::.ctor()
		IL_0007: ldarg.1
		IL_0008: stfld string DotfuscatorAttribute::a
		IL_000d: ldarg.0
		IL_000e: ldarg.2
		IL_000f: stfld int32 DotfuscatorAttribute::c
		IL_0014: ret
	} // end of method DotfuscatorAttribute::.ctor

	.method public hidebysig 
		instance string a () cil managed 
	{
		// Method begins at RVA 0x2074
		// Header size: 12
		// Code size: 7 (0x7)
		.maxstack 1

		IL_0000: ldarg.0
		IL_0001: ldfld string DotfuscatorAttribute::a
		IL_0006: ret
	} // end of method DotfuscatorAttribute::a

	.method public hidebysig 
		instance int32 c () cil managed 
	{
		// Method begins at RVA 0x2088
		// Header size: 12
		// Code size: 7 (0x7)
		.maxstack 1

		IL_0000: ldarg.0
		IL_0001: ldfld int32 DotfuscatorAttribute::c
		IL_0006: ret
	} // end of method DotfuscatorAttribute::c

	// Properties
	.property instance string A()
	{
		.get instance string DotfuscatorAttribute::a()
	}
	.property instance int32 C()
	{
		.get instance int32 DotfuscatorAttribute::c()
	}

} // end of class DotfuscatorAttribute

.class public auto ansi abstract beforefieldinit ODCrypt.Arrays
	extends [mscorlib]System.Object
{
	// Methods
	.method public hidebysig static 
		bool AreEqual (
			bool[] a,
			bool[] b
		) cil managed 
	{
		// Method begins at RVA 0x209c
		// Header size: 12
		// Code size: 366 (0x16e)
		.maxstack 2
		.locals init (
			[0] int32,
			[1] int16
		)

		IL_0000: ldc.i4 1129381892
		IL_0005: nop
		IL_0006: stloc 1
		IL_000a: nop
		IL_000b: ldloca 1
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: conv.i
		IL_0012: stloc.0
		IL_0013: br.s IL_001f
		// loop start (head: IL_001f)
			IL_0015: ldc.i4.0
			IL_0016: switch (IL_003d)

			IL_001f: ldloc.0
			IL_0020: switch (IL_011a, IL_0099, IL_00b7, IL_0059, IL_0015, IL_015d)
		// end loop

		IL_003d: ldarg.0
		IL_003e: ldarg.1
		IL_003f: bne.un IL_0103

		IL_0044: ldc.i4 1959723011
		IL_0049: nop
		IL_004a: stloc 1
		IL_004e: nop
		IL_004f: ldloca 1
		IL_0053: ldind.i2
		IL_0054: conv.i2
		IL_0055: conv.i
		IL_0056: stloc.0
		IL_0057: br.s IL_001f

		IL_0059: ldc.i4 1487405057
		IL_005e: stloc 1
		IL_0062: nop
		IL_0063: ldloca 1
		IL_0067: nop
		IL_0068: ldind.i2
		IL_0069: conv.i2
		IL_006a: br.s IL_007e

		IL_006c: ldc.i4 487260160
		IL_0071: stloc 1
		IL_0075: nop
		IL_0076: ldloca 1
		IL_007a: ldind.i2
		IL_007b: conv.i2
		IL_007c: br.s IL_007e

		IL_007e: brfalse.s IL_0080

		IL_0080: br IL_0162

		IL_0085: ldc.i4 1460862977
		IL_008a: stloc 1
		IL_008e: ldloca 1
		IL_0092: nop
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: conv.i
		IL_0096: stloc.0
		IL_0097: br.s IL_001f

		IL_0099: ldarg.1
		IL_009a: brtrue IL_0166

		IL_009f: ldc.i4 1222115330
		IL_00a4: nop
		IL_00a5: stloc 1
		IL_00a9: ldloca 1
		IL_00ad: nop
		IL_00ae: ldind.i2
		IL_00af: conv.i2
		IL_00b0: conv.i
		IL_00b1: stloc.0
		IL_00b2: br IL_001f

		IL_00b7: ldc.i4 1459758596
		IL_00bc: stloc 1
		IL_00c0: ldloca 1
		IL_00c4: nop
		IL_00c5: ldind.i2
		IL_00c6: conv.i2
		IL_00c7: ldc.i4 2094540292
		IL_00cc: stloc 1
		IL_00d0: ldloca 1
		IL_00d4: nop
		IL_00d5: ldind.i2
		IL_00d6: conv.i2
		IL_00d7: ceq
		IL_00d9: switch (IL_015d, IL_00eb, IL_015d)

		IL_00ea: nop

		IL_00eb: ldc.i4 483459072
		IL_00f0: nop
		IL_00f1: stloc 1
		IL_00f5: ldloca 1
		IL_00f9: nop
		IL_00fa: ldind.i2
		IL_00fb: conv.i2
		IL_00fc: brfalse IL_0101

		IL_0101: br.s IL_0164

		IL_0103: ldc.i4 1852833792
		IL_0108: stloc 1
		IL_010c: ldloca 1
		IL_0110: nop
		IL_0111: ldind.i2
		IL_0112: conv.i2
		IL_0113: conv.i
		IL_0114: stloc.0
		IL_0115: br IL_001f

		IL_011a: ldarg.0
		IL_011b: brfalse.s IL_0164

		IL_011d: br.s IL_0132

		IL_011f: ldc.i4 548208640
		IL_0124: nop
		IL_0125: stloc 1
		IL_0129: ldloca 1
		IL_012d: ldind.i2
		IL_012e: conv.i2

		IL_012f: pop
		IL_0130: br.s IL_0145

		IL_0132: ldc.i4 1922433024
		IL_0137: stloc 1
		IL_013b: nop
		IL_013c: ldloca 1
		IL_0140: nop
		IL_0141: ldind.i2
		IL_0142: conv.i2
		IL_0143: br.s IL_012f

		IL_0145: nop
		IL_0146: ldc.i4 694878213
		IL_014b: stloc 1
		IL_014f: ldloca 1
		IL_0153: nop
		IL_0154: ldind.i2
		IL_0155: conv.i2
		IL_0156: conv.i
		IL_0157: stloc.0
		IL_0158: br IL_001f

		IL_015d: br IL_0085

		IL_0162: ldc.i4.1
		IL_0163: ret

		IL_0164: ldc.i4.0
		IL_0165: ret

		IL_0166: ldarg.0
		IL_0167: ldarg.1
		IL_0168: call bool ODCrypt.Arrays::w(bool[], bool[])
		IL_016d: ret
	} // end of method Arrays::AreEqual

	.method public hidebysig static 
		bool AreEqual (
			char[] a,
			char[] b
		) cil managed 
	{
		// Method begins at RVA 0x2218
		// Header size: 12
		// Code size: 366 (0x16e)
		.maxstack 2
		.locals init (
			[0] int32,
			[1] int16
		)

		IL_0000: ldc.i4 1569914881
		IL_0005: nop
		IL_0006: stloc 1
		IL_000a: nop
		IL_000b: ldloca 1
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: conv.i
		IL_0012: stloc.0
		IL_0013: br.s IL_001f
		// loop start (head: IL_001f)
			IL_0015: ldc.i4.0
			IL_0016: switch (IL_003d)

			IL_001f: ldloc.0
			IL_0020: switch (IL_0059, IL_0015, IL_015d, IL_00b6, IL_0099, IL_011a)
		// end loop

		IL_003d: ldarg.0
		IL_003e: ldarg.1
		IL_003f: bne.un IL_0103

		IL_0044: ldc.i4 1747976192
		IL_0049: nop
		IL_004a: stloc 1
		IL_004e: nop
		IL_004f: ldloca 1
		IL_0053: ldind.i2
		IL_0054: conv.i2
		IL_0055: conv.i
		IL_0056: stloc.0
		IL_0057: br.s IL_001f

		IL_0059: br IL_0162

		IL_005e: ldc.i4 290521089
		IL_0063: nop
		IL_0064: stloc 1
		IL_0068: ldloca 1
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: br.s IL_0083

		IL_0070: ldc.i4 834732032
		IL_0075: nop
		IL_0076: stloc 1
		IL_007a: nop
		IL_007b: ldloca 1
		IL_007f: ldind.i2
		IL_0080: conv.i2
		IL_0081: br.s IL_0083

		IL_0083: brfalse.s IL_0085

		IL_0085: ldc.i4 1642463236
		IL_008a: stloc 1
		IL_008e: nop
		IL_008f: ldloca 1
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: conv.i
		IL_0096: stloc.0
		IL_0097: br.s IL_001f

		IL_0099: ldarg.1
		IL_009a: brtrue IL_0166

		IL_009f: ldc.i4 1748697091
		IL_00a4: stloc 1
		IL_00a8: nop
		IL_00a9: ldloca 1
		IL_00ad: ldind.i2
		IL_00ae: conv.i2
		IL_00af: conv.i
		IL_00b0: stloc.0
		IL_00b1: br IL_001f

		IL_00b6: ldc.i4 1205989920
		IL_00bb: stloc 1
		IL_00bf: nop
		IL_00c0: ldloca 1
		IL_00c4: nop
		IL_00c5: ldind.i2
		IL_00c6: conv.i2
		IL_00c7: ldc.i4 2037969440
		IL_00cc: stloc 1
		IL_00d0: nop
		IL_00d1: ldloca 1
		IL_00d5: nop
		IL_00d6: ldind.i2
		IL_00d7: conv.i2
		IL_00d8: ceq
		IL_00da: switch (IL_015d, IL_00ec, IL_015d)

		IL_00eb: nop

		IL_00ec: ldc.i4 1441988608
		IL_00f1: stloc 1
		IL_00f5: ldloca 1
		IL_00f9: nop
		IL_00fa: ldind.i2
		IL_00fb: conv.i2
		IL_00fc: brfalse IL_0101

		IL_0101: br.s IL_0164

		IL_0103: ldc.i4 114688005
		IL_0108: nop
		IL_0109: stloc 1
		IL_010d: ldloca 1
		IL_0111: ldind.i2
		IL_0112: conv.i2
		IL_0113: conv.i
		IL_0114: stloc.0
		IL_0115: br IL_001f

		IL_011a: ldarg.0
		IL_011b: brfalse.s IL_0164

		IL_011d: br.s IL_0132

		IL_011f: ldc.i4 1272184832
		IL_0124: nop
		IL_0125: stloc 1
		IL_0129: ldloca 1
		IL_012d: ldind.i2
		IL_012e: conv.i2

		IL_012f: pop
		IL_0130: br.s IL_0144

		IL_0132: ldc.i4 670564352
		IL_0137: stloc 1
		IL_013b: ldloca 1
		IL_013f: nop
		IL_0140: ldind.i2
		IL_0141: conv.i2
		IL_0142: br.s IL_012f

		IL_0144: nop
		IL_0145: ldc.i4 1884618754
		IL_014a: nop
		IL_014b: stloc 1
		IL_014f: nop
		IL_0150: ldloca 1
		IL_0154: ldind.i2
		IL_0155: conv.i2
		IL_0156: conv.i
		IL_0157: stloc.0
		IL_0158: br IL_001f

		IL_015d: br IL_005e

		IL_0162: ldc.i4.1
		IL_0163: ret

		IL_0164: ldc.i4.0
		IL_0165: ret

		IL_0166: ldarg.0
		IL_0167: ldarg.1
		IL_0168: call bool ODCrypt.Arrays::w(char[], char[])
		IL_016d: ret
	} // end of method Arrays::AreEqual

	.method public hidebysig static 
		bool AreEqual (
			uint8[] a,
			uint8[] b
		) cil managed 
	{
		// Method begins at RVA 0x2394
		// Header size: 12
		// Code size: 366 (0x16e)
		.maxstack 2
		.locals init (
			[0] int32,
			[1] int16
		)

		IL_0000: ldc.i4 1308491777
		IL_0005: stloc 1
		IL_0009: nop
		IL_000a: ldloca 1
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: conv.i
		IL_0011: stloc.0
		IL_0012: br.s IL_001e
		// loop start (head: IL_001e)
			IL_0014: ldc.i4.0
			IL_0015: switch (IL_003c)

			IL_001e: ldloc.0
			IL_001f: switch (IL_0056, IL_0014, IL_0134, IL_008a, IL_006f, IL_00a6)
		// end loop

		IL_003c: ldarg.0
		IL_003d: ldarg.1
		IL_003e: bne.un.s IL_008f

		IL_0040: ldc.i4 1523318784
		IL_0045: nop
		IL_0046: stloc 1
		IL_004a: nop
		IL_004b: ldloca 1
		IL_004f: nop
		IL_0050: ldind.i2
		IL_0051: conv.i2
		IL_0052: conv.i
		IL_0053: stloc.0
		IL_0054: br.s IL_001e

		IL_0056: br IL_0162

		IL_005b: ldc.i4 78970884
		IL_0060: stloc 1
		IL_0064: ldloca 1
		IL_0068: nop
		IL_0069: ldind.i2
		IL_006a: conv.i2
		IL_006b: conv.i
		IL_006c: stloc.0
		IL_006d: br.s IL_001e

		IL_006f: ldarg.1
		IL_0070: brtrue IL_0166

		IL_0075: ldc.i4 347734019
		IL_007a: nop
		IL_007b: stloc 1
		IL_007f: ldloca 1
		IL_0083: nop
		IL_0084: ldind.i2
		IL_0085: conv.i2
		IL_0086: conv.i
		IL_0087: stloc.0
		IL_0088: br.s IL_001e

		IL_008a: br IL_0164

		IL_008f: ldc.i4 2130116613
		IL_0094: stloc 1
		IL_0098: nop
		IL_0099: ldloca 1
		IL_009d: ldind.i2
		IL_009e: conv.i2
		IL_009f: conv.i
		IL_00a0: stloc.0
		IL_00a1: br IL_001e

		IL_00a6: ldc.i4 2074957607
		IL_00ab: nop
		IL_00ac: stloc 1
		IL_00b0: nop
		IL_00b1: ldloca 1
		IL_00b5: nop
		IL_00b6: ldind.i2
		IL_00b7: conv.i2
		IL_00b8: ldc.i4 2105759527
		IL_00bd: nop
		IL_00be: stloc 1
		IL_00c2: ldloca 1
		IL_00c6: nop
		IL_00c7: ldind.i2
		IL_00c8: conv.i2
		IL_00c9: ceq
		IL_00cb: switch (IL_006f, IL_00dd, IL_006f)

		IL_00dc: nop

		IL_00dd: ldc.i4 283836416
		IL_00e2: nop
		IL_00e3: stloc 1
		IL_00e7: nop
		IL_00e8: ldloca 1
		IL_00ec: ldind.i2
		IL_00ed: conv.i2
		IL_00ee: brfalse IL_00f3

		IL_00f3: ldarg.0
		IL_00f4: brfalse.s IL_0164

		IL_00f6: ldc.i4 1328021505
		IL_00fb: stloc 1
		IL_00ff: nop
		IL_0100: ldloca 1
		IL_0104: nop
		IL_0105: ldind.i2
		IL_0106: conv.i2
		IL_0107: br.s IL_011b

		IL_0109: ldc.i4 1484587008
		IL_010e: nop
		IL_010f: stloc 1
		IL_0113: ldloca 1
		IL_0117: ldind.i2
		IL_0118: conv.i2
		IL_0119: br.s IL_011b

		IL_011b: brfalse.s IL_011d

		IL_011d: ldc.i4 1998127106
		IL_0122: stloc 1
		IL_0126: ldloca 1
		IL_012a: nop
		IL_012b: ldind.i2
		IL_012c: conv.i2
		IL_012d: conv.i
		IL_012e: stloc.0
		IL_012f: br IL_001e

		IL_0134: br.s IL_0149

		IL_0136: ldc.i4 648675328
		IL_013b: stloc 1
		IL_013f: ldloca 1
		IL_0143: nop
		IL_0144: ldind.i2
		IL_0145: conv.i2

		IL_0146: pop
		IL_0147: br.s IL_015c

		IL_0149: ldc.i4 422576128
		IL_014e: nop
		IL_014f: stloc 1
		IL_0153: nop
		IL_0154: ldloca 1
		IL_0158: ldind.i2
		IL_0159: conv.i2
		IL_015a: br.s IL_0146

		IL_015c: nop
		IL_015d: br IL_005b

		IL_0162: ldc.i4.1
		IL_0163: ret

		IL_0164: ldc.i4.0
		IL_0165: ret

		IL_0166: ldarg.0
		IL_0167: ldarg.1
		IL_0168: call bool ODCrypt.Arrays::w(uint8[], uint8[])
		IL_016d: ret
	} // end of method Arrays::AreEqual

	.method public hidebysig static 
		bool AreSame (
			uint8[] a,
			uint8[] b
		) cil managed 
	{
		.custom instance void [mscorlib]System.ObsoleteAttribute::.ctor(string) = (
			01 00 1d 55 73 65 20 27 41 72 65 45 71 75 61 6c
			27 20 6d 65 74 68 6f 64 20 69 6e 73 74 65 61 64
			00 00
		)
		// Method begins at RVA 0x2510
		// Header size: 12
		// Code size: 161 (0xa1)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 383834026
		IL_0005: stloc 0
		IL_0009: nop
		IL_000a: ldloca 0
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1716639658
		IL_0015: stloc 0
		IL_0019: ldloca 0
		IL_001d: nop
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_005d, IL_0033)

		IL_0033: br.s IL_0048

		IL_0035: ldc.i4 899481600
		IL_003a: stloc 0
		IL_003e: ldloca 0
		IL_0042: nop
		IL_0043: ldind.i2
		IL_0044: conv.i2

		IL_0045: pop
		IL_0046: br.s IL_005b

		IL_0048: ldc.i4 293797888
		IL_004d: nop
		IL_004e: stloc 0
		IL_0052: ldloca 0
		IL_0056: nop
		IL_0057: ldind.i2
		IL_0058: conv.i2
		IL_0059: br.s IL_0045

		IL_005b: nop
		IL_005c: nop

		IL_005d: ldc.i4 1832910848
		IL_0062: stloc 0
		IL_0066: ldloca 0
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: brfalse IL_0072

		IL_0072: ldc.i4 1632763905
		IL_0077: nop
		IL_0078: stloc 0
		IL_007c: ldloca 0
		IL_0080: ldind.i2
		IL_0081: conv.i2
		IL_0082: br.s IL_0097

		IL_0084: ldc.i4 1912406016
		IL_0089: stloc 0
		IL_008d: nop
		IL_008e: ldloca 0
		IL_0092: nop
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: br.s IL_0097

		IL_0097: brfalse.s IL_0099

		IL_0099: ldarg.0
		IL_009a: ldarg.1
		IL_009b: call bool ODCrypt.Arrays::AreEqual(uint8[], uint8[])
		IL_00a0: ret
	} // end of method Arrays::AreSame

	.method public hidebysig static 
		bool ConstantTimeAreEqual (
			uint8[] a,
			uint8[] b
		) cil managed 
	{
		// Method begins at RVA 0x25c0
		// Header size: 12
		// Code size: 375 (0x177)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0028)

		IL_000a: ldloc.2
		IL_000b: switch (IL_0081, IL_005c, IL_00c5, IL_00e2, IL_0126, IL_0042)

		IL_0028: ldarg.0
		IL_0029: ldlen
		IL_002a: conv.i4
		IL_002b: stloc.0
		IL_002c: ldc.i4 118161413
		IL_0031: nop
		IL_0032: stloc 3
		IL_0036: nop
		IL_0037: ldloca 3
		IL_003b: nop
		IL_003c: ldind.i2
		IL_003d: conv.i2
		IL_003e: conv.i
		IL_003f: stloc.2
		IL_0040: br.s IL_000a

		IL_0042: ldloc.0
		IL_0043: ldarg.1
		IL_0044: ldlen
		IL_0045: conv.i4
		IL_0046: beq.s IL_0083

		IL_0048: ldc.i4 1226571777
		IL_004d: stloc 3
		IL_0051: nop
		IL_0052: ldloca 3
		IL_0056: ldind.i2
		IL_0057: conv.i2
		IL_0058: conv.i
		IL_0059: stloc.2
		IL_005a: br.s IL_000a

		IL_005c: br.s IL_00c7

		IL_005e: ldloc.0
		IL_005f: ldc.i4.1
		IL_0060: sub
		IL_0061: stloc.0
		IL_0062: ldloc.1
		IL_0063: ldarg.0
		IL_0064: ldloc.0
		IL_0065: ldelem.u1
		IL_0066: ldarg.1
		IL_0067: ldloc.0
		IL_0068: ldelem.u1
		IL_0069: xor
		IL_006a: or
		IL_006b: stloc.1
		IL_006c: ldc.i4 953876480
		IL_0071: nop
		IL_0072: stloc 3
		IL_0076: nop
		IL_0077: ldloca 3
		IL_007b: ldind.i2
		IL_007c: conv.i2
		IL_007d: conv.i
		IL_007e: stloc.2
		IL_007f: br.s IL_000a

		IL_0081: br.s IL_00c9

		IL_0083: ldc.i4.0
		IL_0084: stloc.1
		IL_0085: br.s IL_009b

		IL_0087: ldc.i4 199950336
		IL_008c: nop
		IL_008d: stloc 3
		IL_0091: nop
		IL_0092: ldloca 3
		IL_0096: ldind.i2
		IL_0097: conv.i2

		IL_0098: pop
		IL_0099: br.s IL_00ad

		IL_009b: ldc.i4 1043791872
		IL_00a0: nop
		IL_00a1: stloc 3
		IL_00a5: ldloca 3
		IL_00a9: ldind.i2
		IL_00aa: conv.i2
		IL_00ab: br.s IL_0098

		IL_00ad: nop
		IL_00ae: ldc.i4 2001469442
		IL_00b3: nop
		IL_00b4: stloc 3
		IL_00b8: ldloca 3
		IL_00bc: ldind.i2
		IL_00bd: conv.i2
		IL_00be: conv.i
		IL_00bf: stloc.2
		IL_00c0: br IL_000a

		IL_00c5: br.s IL_00c9

		IL_00c7: ldc.i4.0
		IL_00c8: ret

		IL_00c9: ldc.i4 399769603
		IL_00ce: nop
		IL_00cf: stloc 3
		IL_00d3: nop
		IL_00d4: ldloca 3
		IL_00d8: nop
		IL_00d9: ldind.i2
		IL_00da: conv.i2
		IL_00db: conv.i
		IL_00dc: stloc.2
		IL_00dd: br IL_000a

		IL_00e2: ldloc.0
		IL_00e3: brtrue IL_005e

		IL_00e8: ldc.i4 726728705
		IL_00ed: stloc 3
		IL_00f1: nop
		IL_00f2: ldloca 3
		IL_00f6: ldind.i2
		IL_00f7: conv.i2
		IL_00f8: br.s IL_010c

		IL_00fa: ldc.i4 228196352
		IL_00ff: stloc 3
		IL_0103: ldloca 3
		IL_0107: nop
		IL_0108: ldind.i2
		IL_0109: conv.i2
		IL_010a: br.s IL_010c

		IL_010c: brfalse.s IL_010e

		IL_010e: ldc.i4 225968132
		IL_0113: nop
		IL_0114: stloc 3
		IL_0118: ldloca 3
		IL_011c: nop
		IL_011d: ldind.i2
		IL_011e: conv.i2
		IL_011f: conv.i
		IL_0120: stloc.2
		IL_0121: br IL_000a

		IL_0126: ldc.i4 1888840354
		IL_012b: stloc 3
		IL_012f: nop
		IL_0130: ldloca 3
		IL_0134: nop
		IL_0135: ldind.i2
		IL_0136: conv.i2
		IL_0137: ldc.i4 1394829986
		IL_013c: stloc 3
		IL_0140: ldloca 3
		IL_0144: nop
		IL_0145: ldind.i2
		IL_0146: conv.i2
		IL_0147: ceq
		IL_0149: switch (IL_005e, IL_015b, IL_005e)

		IL_015a: nop

		IL_015b: ldc.i4 303366144
		IL_0160: stloc 3
		IL_0164: ldloca 3
		IL_0168: nop
		IL_0169: ldind.i2
		IL_016a: conv.i2
		IL_016b: brfalse IL_0170

		IL_0170: br.s IL_0172

		IL_0172: ldloc.1
		IL_0173: ldc.i4.0
		IL_0174: ceq
		IL_0176: ret
	} // end of method Arrays::ConstantTimeAreEqual

	.method public hidebysig static 
		bool AreEqual (
			int32[] a,
			int32[] b
		) cil managed 
	{
		// Method begins at RVA 0x2744
		// Header size: 12
		// Code size: 369 (0x171)
		.maxstack 2
		.locals init (
			[0] int32,
			[1] int16
		)

		IL_0000: ldc.i4 163774469
		IL_0005: stloc 1
		IL_0009: nop
		IL_000a: ldloca 1
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: conv.i
		IL_0012: stloc.0
		IL_0013: br.s IL_001f
		// loop start (head: IL_001f)
			IL_0015: ldc.i4.0
			IL_0016: switch (IL_003d)

			IL_001f: ldloc.0
			IL_0020: switch (IL_0096, IL_0055, IL_00b3, IL_00cf, IL_0135, IL_0015)
		// end loop

		IL_003d: ldarg.0
		IL_003e: ldarg.1
		IL_003f: bne.un.s IL_00b8

		IL_0041: ldc.i4 54984705
		IL_0046: nop
		IL_0047: stloc 1
		IL_004b: ldloca 1
		IL_004f: ldind.i2
		IL_0050: conv.i2
		IL_0051: conv.i
		IL_0052: stloc.0
		IL_0053: br.s IL_001f

		IL_0055: br IL_0165

		IL_005a: ldc.i4 1990393857
		IL_005f: nop
		IL_0060: stloc 1
		IL_0064: nop
		IL_0065: ldloca 1
		IL_0069: ldind.i2
		IL_006a: conv.i2
		IL_006b: br.s IL_007f

		IL_006d: ldc.i4 2038759424
		IL_0072: stloc 1
		IL_0076: nop
		IL_0077: ldloca 1
		IL_007b: ldind.i2
		IL_007c: conv.i2
		IL_007d: br.s IL_007f

		IL_007f: brfalse.s IL_0081

		IL_0081: ldc.i4 385155072
		IL_0086: stloc 1
		IL_008a: nop
		IL_008b: ldloca 1
		IL_008f: nop
		IL_0090: ldind.i2
		IL_0091: conv.i2
		IL_0092: conv.i
		IL_0093: stloc.0
		IL_0094: br.s IL_001f

		IL_0096: ldarg.1
		IL_0097: brtrue IL_0169

		IL_009c: ldc.i4 1415184386
		IL_00a1: nop
		IL_00a2: stloc 1
		IL_00a6: ldloca 1
		IL_00aa: ldind.i2
		IL_00ab: conv.i2
		IL_00ac: conv.i
		IL_00ad: stloc.0
		IL_00ae: br IL_001f

		IL_00b3: br IL_0167

		IL_00b8: ldc.i4 1032978435
		IL_00bd: stloc 1
		IL_00c1: ldloca 1
		IL_00c5: nop
		IL_00c6: ldind.i2
		IL_00c7: conv.i2
		IL_00c8: conv.i
		IL_00c9: stloc.0
		IL_00ca: br IL_001f

		IL_00cf: ldc.i4 969093340
		IL_00d4: nop
		IL_00d5: stloc 1
		IL_00d9: nop
		IL_00da: ldloca 1
		IL_00de: ldind.i2
		IL_00df: conv.i2
		IL_00e0: ldc.i4 1104359644
		IL_00e5: stloc 1
		IL_00e9: ldloca 1
		IL_00ed: nop
		IL_00ee: ldind.i2
		IL_00ef: conv.i2
		IL_00f0: ceq
		IL_00f2: switch (IL_0096, IL_0104, IL_0096)

		IL_0103: nop

		IL_0104: ldc.i4 337707008
		IL_0109: nop
		IL_010a: stloc 1
		IL_010e: ldloca 1
		IL_0112: nop
		IL_0113: ldind.i2
		IL_0114: conv.i2
		IL_0115: brfalse IL_011a

		IL_011a: ldarg.0
		IL_011b: brfalse.s IL_0167

		IL_011d: ldc.i4 1104412676
		IL_0122: nop
		IL_0123: stloc 1
		IL_0127: ldloca 1
		IL_012b: nop
		IL_012c: ldind.i2
		IL_012d: conv.i2
		IL_012e: conv.i
		IL_012f: stloc.0
		IL_0130: br IL_001f

		IL_0135: br.s IL_014b

		IL_0137: ldc.i4 2054225920
		IL_013c: nop
		IL_013d: stloc 1
		IL_0141: nop
		IL_0142: ldloca 1
		IL_0146: ldind.i2
		IL_0147: conv.i2

		IL_0148: pop
		IL_0149: br.s IL_015f

		IL_014b: ldc.i4 689504256
		IL_0150: nop
		IL_0151: stloc 1
		IL_0155: nop
		IL_0156: ldloca 1
		IL_015a: nop
		IL_015b: ldind.i2
		IL_015c: conv.i2
		IL_015d: br.s IL_0148

		IL_015f: nop
		IL_0160: br IL_005a

		IL_0165: ldc.i4.1
		IL_0166: ret

		IL_0167: ldc.i4.0
		IL_0168: ret

		IL_0169: ldarg.0
		IL_016a: ldarg.1
		IL_016b: call bool ODCrypt.Arrays::w(int32[], int32[])
		IL_0170: ret
	} // end of method Arrays::AreEqual

	.method public hidebysig static 
		bool AreEqual (
			uint32[] a,
			uint32[] b
		) cil managed 
	{
		// Method begins at RVA 0x28c4
		// Header size: 12
		// Code size: 371 (0x173)
		.maxstack 2
		.locals init (
			[0] int32,
			[1] int16
		)

		IL_0000: ldc.i4 1893400581
		IL_0005: nop
		IL_0006: stloc 1
		IL_000a: nop
		IL_000b: ldloca 1
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: conv.i
		IL_0013: stloc.0
		IL_0014: br.s IL_0020
		// loop start (head: IL_0020)
			IL_0016: ldc.i4.0
			IL_0017: switch (IL_003e)

			IL_0020: ldloc.0
			IL_0021: switch (IL_0097, IL_0056, IL_00b5, IL_00d2, IL_0139, IL_0016)
		// end loop

		IL_003e: ldarg.0
		IL_003f: ldarg.1
		IL_0040: bne.un.s IL_00ba

		IL_0042: ldc.i4 1887305729
		IL_0047: nop
		IL_0048: stloc 1
		IL_004c: ldloca 1
		IL_0050: ldind.i2
		IL_0051: conv.i2
		IL_0052: conv.i
		IL_0053: stloc.0
		IL_0054: br.s IL_0020

		IL_0056: ldc.i4 1596456961
		IL_005b: nop
		IL_005c: stloc 1
		IL_0060: nop
		IL_0061: ldloca 1
		IL_0065: ldind.i2
		IL_0066: conv.i2
		IL_0067: br.s IL_007c

		IL_0069: ldc.i4 1724514304
		IL_006e: nop
		IL_006f: stloc 1
		IL_0073: ldloca 1
		IL_0077: nop
		IL_0078: ldind.i2
		IL_0079: conv.i2
		IL_007a: br.s IL_007c

		IL_007c: brfalse.s IL_007e

		IL_007e: br IL_0167

		IL_0083: ldc.i4 1029898240
		IL_0088: stloc 1
		IL_008c: ldloca 1
		IL_0090: nop
		IL_0091: ldind.i2
		IL_0092: conv.i2
		IL_0093: conv.i
		IL_0094: stloc.0
		IL_0095: br.s IL_0020

		IL_0097: ldarg.1
		IL_0098: brtrue IL_016b

		IL_009d: ldc.i4 346423298
		IL_00a2: nop
		IL_00a3: stloc 1
		IL_00a7: nop
		IL_00a8: ldloca 1
		IL_00ac: ldind.i2
		IL_00ad: conv.i2
		IL_00ae: conv.i
		IL_00af: stloc.0
		IL_00b0: br IL_0020

		IL_00b5: br IL_0169

		IL_00ba: ldc.i4 757202947
		IL_00bf: nop
		IL_00c0: stloc 1
		IL_00c4: ldloca 1
		IL_00c8: nop
		IL_00c9: ldind.i2
		IL_00ca: conv.i2
		IL_00cb: conv.i
		IL_00cc: stloc.0
		IL_00cd: br IL_0020

		IL_00d2: ldc.i4 529311546
		IL_00d7: stloc 1
		IL_00db: nop
		IL_00dc: ldloca 1
		IL_00e0: ldind.i2
		IL_00e1: conv.i2
		IL_00e2: ldc.i4 1836885818
		IL_00e7: nop
		IL_00e8: stloc 1
		IL_00ec: ldloca 1
		IL_00f0: nop
		IL_00f1: ldind.i2
		IL_00f2: conv.i2
		IL_00f3: ceq
		IL_00f5: switch (IL_0097, IL_0107, IL_0097)

		IL_0106: nop

		IL_0107: ldc.i4 475004928
		IL_010c: nop
		IL_010d: stloc 1
		IL_0111: ldloca 1
		IL_0115: nop
		IL_0116: ldind.i2
		IL_0117: conv.i2
		IL_0118: brfalse IL_011d

		IL_011d: ldarg.0
		IL_011e: brfalse.s IL_0169

		IL_0120: ldc.i4 155123716
		IL_0125: nop
		IL_0126: stloc 1
		IL_012a: nop
		IL_012b: ldloca 1
		IL_012f: nop
		IL_0130: ldind.i2
		IL_0131: conv.i2
		IL_0132: conv.i
		IL_0133: stloc.0
		IL_0134: br IL_0020

		IL_0139: br.s IL_014e

		IL_013b: ldc.i4 1048051712
		IL_0140: stloc 1
		IL_0144: ldloca 1
		IL_0148: nop
		IL_0149: ldind.i2
		IL_014a: conv.i2

		IL_014b: pop
		IL_014c: br.s IL_0161

		IL_014e: ldc.i4 1380909056
		IL_0153: stloc 1
		IL_0157: nop
		IL_0158: ldloca 1
		IL_015c: nop
		IL_015d: ldind.i2
		IL_015e: conv.i2
		IL_015f: br.s IL_014b

		IL_0161: nop
		IL_0162: br IL_0083

		IL_0167: ldc.i4.1
		IL_0168: ret

		IL_0169: ldc.i4.0
		IL_016a: ret

		IL_016b: ldarg.0
		IL_016c: ldarg.1
		IL_016d: call bool ODCrypt.Arrays::w(uint32[], uint32[])
		IL_0172: ret
	} // end of method Arrays::AreEqual

	.method private hidebysig static 
		bool w (
			bool[] A_0,
			bool[] A_1
		) cil managed 
	{
		// Method begins at RVA 0x2a44
		// Header size: 12
		// Code size: 372 (0x174)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0028)

		IL_000a: ldloc.1
		IL_000b: switch (IL_007c, IL_005f, IL_00c5, IL_0106, IL_0124, IL_0041)

		IL_0028: ldarg.0
		IL_0029: ldlen
		IL_002a: conv.i4
		IL_002b: stloc.0
		IL_002c: ldc.i4 1513422853
		IL_0031: nop
		IL_0032: stloc 2
		IL_0036: nop
		IL_0037: ldloca 2
		IL_003b: ldind.i2
		IL_003c: conv.i2
		IL_003d: conv.i
		IL_003e: stloc.1
		IL_003f: br.s IL_000a

		IL_0041: ldloc.0
		IL_0042: ldarg.1
		IL_0043: ldlen
		IL_0044: conv.i4
		IL_0045: beq IL_00c9

		IL_004a: ldc.i4 1267466241
		IL_004f: stloc 2
		IL_0053: nop
		IL_0054: ldloca 2
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: conv.i
		IL_005c: stloc.1
		IL_005d: br.s IL_000a

		IL_005f: br.s IL_00c7

		IL_0061: ldc.i4.0
		IL_0062: ret

		IL_0063: ldloc.0
		IL_0064: ldc.i4.1
		IL_0065: sub
		IL_0066: stloc.0
		IL_0067: ldc.i4 194838528
		IL_006c: stloc 2
		IL_0070: nop
		IL_0071: ldloca 2
		IL_0075: nop
		IL_0076: ldind.i2
		IL_0077: conv.i2
		IL_0078: conv.i
		IL_0079: stloc.1
		IL_007a: br.s IL_000a

		IL_007c: ldarg.0
		IL_007d: ldloc.0
		IL_007e: ldelem.u1
		IL_007f: ldarg.1
		IL_0080: ldloc.0
		IL_0081: ldelem.u1
		IL_0082: beq.s IL_00c9

		IL_0084: br.s IL_009a

		IL_0086: ldc.i4 2106392576
		IL_008b: nop
		IL_008c: stloc 2
		IL_0090: nop
		IL_0091: ldloca 2
		IL_0095: ldind.i2
		IL_0096: conv.i2

		IL_0097: pop
		IL_0098: br.s IL_00ac

		IL_009a: ldc.i4 112394240
		IL_009f: stloc 2
		IL_00a3: ldloca 2
		IL_00a7: nop
		IL_00a8: ldind.i2
		IL_00a9: conv.i2
		IL_00aa: br.s IL_0097

		IL_00ac: nop
		IL_00ad: ldc.i4 20971522
		IL_00b2: nop
		IL_00b3: stloc 2
		IL_00b7: nop
		IL_00b8: ldloca 2
		IL_00bc: ldind.i2
		IL_00bd: conv.i2
		IL_00be: conv.i
		IL_00bf: stloc.1
		IL_00c0: br IL_000a

		IL_00c5: br.s IL_0061

		IL_00c7: ldc.i4.0
		IL_00c8: ret

		IL_00c9: ldc.i4 2087845889
		IL_00ce: nop
		IL_00cf: stloc 2
		IL_00d3: ldloca 2
		IL_00d7: ldind.i2
		IL_00d8: conv.i2
		IL_00d9: br.s IL_00ed

		IL_00db: ldc.i4 1966997504
		IL_00e0: stloc 2
		IL_00e4: ldloca 2
		IL_00e8: nop
		IL_00e9: ldind.i2
		IL_00ea: conv.i2
		IL_00eb: br.s IL_00ed

		IL_00ed: brfalse.s IL_00ef

		IL_00ef: ldc.i4 2068381699
		IL_00f4: stloc 2
		IL_00f8: ldloca 2
		IL_00fc: nop
		IL_00fd: ldind.i2
		IL_00fe: conv.i2
		IL_00ff: conv.i
		IL_0100: stloc.1
		IL_0101: br IL_000a

		IL_0106: ldloc.0
		IL_0107: brtrue IL_0063

		IL_010c: ldc.i4 332398596
		IL_0111: nop
		IL_0112: stloc 2
		IL_0116: nop
		IL_0117: ldloca 2
		IL_011b: ldind.i2
		IL_011c: conv.i2
		IL_011d: conv.i
		IL_011e: stloc.1
		IL_011f: br IL_000a

		IL_0124: ldc.i4 1217791975
		IL_0129: nop
		IL_012a: stloc 2
		IL_012e: ldloca 2
		IL_0132: nop
		IL_0133: ldind.i2
		IL_0134: conv.i2
		IL_0135: ldc.i4 206505959
		IL_013a: stloc 2
		IL_013e: nop
		IL_013f: ldloca 2
		IL_0143: nop
		IL_0144: ldind.i2
		IL_0145: conv.i2
		IL_0146: ceq
		IL_0148: switch (IL_0061, IL_015a, IL_0061)

		IL_0159: nop

		IL_015a: ldc.i4 1695154176
		IL_015f: stloc 2
		IL_0163: nop
		IL_0164: ldloca 2
		IL_0168: nop
		IL_0169: ldind.i2
		IL_016a: conv.i2
		IL_016b: brfalse IL_0170

		IL_0170: br.s IL_0172

		IL_0172: ldc.i4.1
		IL_0173: ret
	} // end of method Arrays::w

	.method private hidebysig static 
		bool w (
			char[] A_0,
			char[] A_1
		) cil managed 
	{
		// Method begins at RVA 0x2bc4
		// Header size: 12
		// Code size: 374 (0x176)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0028)

		IL_000a: ldloc.1
		IL_000b: switch (IL_00a4, IL_005e, IL_00ed, IL_010a, IL_0127, IL_0041)

		IL_0028: ldarg.0
		IL_0029: ldlen
		IL_002a: conv.i4
		IL_002b: stloc.0
		IL_002c: ldc.i4 1146552325
		IL_0031: nop
		IL_0032: stloc 2
		IL_0036: ldloca 2
		IL_003a: nop
		IL_003b: ldind.i2
		IL_003c: conv.i2
		IL_003d: conv.i
		IL_003e: stloc.1
		IL_003f: br.s IL_000a

		IL_0041: ldloc.0
		IL_0042: ldarg.1
		IL_0043: ldlen
		IL_0044: conv.i4
		IL_0045: beq IL_00f1

		IL_004a: ldc.i4 1109131265
		IL_004f: stloc 2
		IL_0053: ldloca 2
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: conv.i
		IL_005b: stloc.1
		IL_005c: br.s IL_000a

		IL_005e: ldc.i4 270204929
		IL_0063: stloc 2
		IL_0067: ldloca 2
		IL_006b: nop
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: br.s IL_0083

		IL_0070: ldc.i4 1511587840
		IL_0075: stloc 2
		IL_0079: nop
		IL_007a: ldloca 2
		IL_007e: nop
		IL_007f: ldind.i2
		IL_0080: conv.i2
		IL_0081: br.s IL_0083

		IL_0083: brfalse.s IL_0085

		IL_0085: br.s IL_00ef

		IL_0087: ldc.i4.0
		IL_0088: ret

		IL_0089: ldloc.0
		IL_008a: ldc.i4.1
		IL_008b: sub
		IL_008c: stloc.0
		IL_008d: ldc.i4 809435136
		IL_0092: nop
		IL_0093: stloc 2
		IL_0097: ldloca 2
		IL_009b: ldind.i2
		IL_009c: conv.i2
		IL_009d: conv.i
		IL_009e: stloc.1
		IL_009f: br IL_000a

		IL_00a4: br.s IL_00b9

		IL_00a6: ldc.i4 999620608
		IL_00ab: stloc 2
		IL_00af: ldloca 2
		IL_00b3: nop
		IL_00b4: ldind.i2
		IL_00b5: conv.i2

		IL_00b6: pop
		IL_00b7: br.s IL_00cb

		IL_00b9: ldc.i4 428605440
		IL_00be: stloc 2
		IL_00c2: ldloca 2
		IL_00c6: nop
		IL_00c7: ldind.i2
		IL_00c8: conv.i2
		IL_00c9: br.s IL_00b6

		IL_00cb: nop
		IL_00cc: ldarg.0
		IL_00cd: ldloc.0
		IL_00ce: ldelem.u2
		IL_00cf: ldarg.1
		IL_00d0: ldloc.0
		IL_00d1: ldelem.u2
		IL_00d2: beq.s IL_00f1

		IL_00d4: ldc.i4 630325250
		IL_00d9: nop
		IL_00da: stloc 2
		IL_00de: nop
		IL_00df: ldloca 2
		IL_00e3: nop
		IL_00e4: ldind.i2
		IL_00e5: conv.i2
		IL_00e6: conv.i
		IL_00e7: stloc.1
		IL_00e8: br IL_000a

		IL_00ed: br.s IL_0087

		IL_00ef: ldc.i4.0
		IL_00f0: ret

		IL_00f1: ldc.i4 1648885763
		IL_00f6: nop
		IL_00f7: stloc 2
		IL_00fb: nop
		IL_00fc: ldloca 2
		IL_0100: nop
		IL_0101: ldind.i2
		IL_0102: conv.i2
		IL_0103: conv.i
		IL_0104: stloc.1
		IL_0105: br IL_000a

		IL_010a: ldloc.0
		IL_010b: brtrue IL_0089

		IL_0110: ldc.i4 1650786308
		IL_0115: stloc 2
		IL_0119: nop
		IL_011a: ldloca 2
		IL_011e: ldind.i2
		IL_011f: conv.i2
		IL_0120: conv.i
		IL_0121: stloc.1
		IL_0122: br IL_000a

		IL_0127: ldc.i4 1162952145
		IL_012c: nop
		IL_012d: stloc 2
		IL_0131: ldloca 2
		IL_0135: nop
		IL_0136: ldind.i2
		IL_0137: conv.i2
		IL_0138: ldc.i4 1960263121
		IL_013d: stloc 2
		IL_0141: nop
		IL_0142: ldloca 2
		IL_0146: nop
		IL_0147: ldind.i2
		IL_0148: conv.i2
		IL_0149: ceq
		IL_014b: switch (IL_0087, IL_015d, IL_0087)

		IL_015c: nop

		IL_015d: ldc.i4 125566976
		IL_0162: nop
		IL_0163: stloc 2
		IL_0167: ldloca 2
		IL_016b: ldind.i2
		IL_016c: conv.i2
		IL_016d: brfalse IL_0172

		IL_0172: br.s IL_0174

		IL_0174: ldc.i4.1
		IL_0175: ret
	} // end of method Arrays::w

	.method private hidebysig static 
		bool w (
			uint8[] A_0,
			uint8[] A_1
		) cil managed 
	{
		// Method begins at RVA 0x2d48
		// Header size: 12
		// Code size: 373 (0x175)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0028)

		IL_000a: ldloc.1
		IL_000b: switch (IL_007b, IL_005e, IL_00c4, IL_00e1, IL_0100, IL_0040)

		IL_0028: ldarg.0
		IL_0029: ldlen
		IL_002a: conv.i4
		IL_002b: stloc.0
		IL_002c: ldc.i4 8978437
		IL_0031: stloc 2
		IL_0035: nop
		IL_0036: ldloca 2
		IL_003a: ldind.i2
		IL_003b: conv.i2
		IL_003c: conv.i
		IL_003d: stloc.1
		IL_003e: br.s IL_000a

		IL_0040: ldloc.0
		IL_0041: ldarg.1
		IL_0042: ldlen
		IL_0043: conv.i4
		IL_0044: beq IL_00c8

		IL_0049: ldc.i4 836435969
		IL_004e: stloc 2
		IL_0052: nop
		IL_0053: ldloca 2
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: conv.i
		IL_005b: stloc.1
		IL_005c: br.s IL_000a

		IL_005e: br.s IL_00c6

		IL_0060: ldc.i4.0
		IL_0061: ret

		IL_0062: ldloc.0
		IL_0063: ldc.i4.1
		IL_0064: sub
		IL_0065: stloc.0
		IL_0066: ldc.i4 1628897280
		IL_006b: nop
		IL_006c: stloc 2
		IL_0070: ldloca 2
		IL_0074: nop
		IL_0075: ldind.i2
		IL_0076: conv.i2
		IL_0077: conv.i
		IL_0078: stloc.1
		IL_0079: br.s IL_000a

		IL_007b: ldarg.0
		IL_007c: ldloc.0
		IL_007d: ldelem.u1
		IL_007e: ldarg.1
		IL_007f: ldloc.0
		IL_0080: ldelem.u1
		IL_0081: beq.s IL_00c8

		IL_0083: br.s IL_009a

		IL_0085: ldc.i4 1414791168
		IL_008a: nop
		IL_008b: stloc 2
		IL_008f: nop
		IL_0090: ldloca 2
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2

		IL_0097: pop
		IL_0098: br.s IL_00ac

		IL_009a: ldc.i4 1825177600
		IL_009f: stloc 2
		IL_00a3: ldloca 2
		IL_00a7: nop
		IL_00a8: ldind.i2
		IL_00a9: conv.i2
		IL_00aa: br.s IL_0097

		IL_00ac: nop
		IL_00ad: ldc.i4 140836866
		IL_00b2: stloc 2
		IL_00b6: nop
		IL_00b7: ldloca 2
		IL_00bb: ldind.i2
		IL_00bc: conv.i2
		IL_00bd: conv.i
		IL_00be: stloc.1
		IL_00bf: br IL_000a

		IL_00c4: br.s IL_0060

		IL_00c6: ldc.i4.0
		IL_00c7: ret

		IL_00c8: ldc.i4 164757507
		IL_00cd: nop
		IL_00ce: stloc 2
		IL_00d2: nop
		IL_00d3: ldloca 2
		IL_00d7: nop
		IL_00d8: ldind.i2
		IL_00d9: conv.i2
		IL_00da: conv.i
		IL_00db: stloc.1
		IL_00dc: br IL_000a

		IL_00e1: ldloc.0
		IL_00e2: brtrue IL_0062

		IL_00e7: ldc.i4 1319370756
		IL_00ec: nop
		IL_00ed: stloc 2
		IL_00f1: nop
		IL_00f2: ldloca 2
		IL_00f6: nop
		IL_00f7: ldind.i2
		IL_00f8: conv.i2
		IL_00f9: conv.i
		IL_00fa: stloc.1
		IL_00fb: br IL_000a

		IL_0100: ldc.i4 1301963289
		IL_0105: stloc 2
		IL_0109: ldloca 2
		IL_010d: nop
		IL_010e: ldind.i2
		IL_010f: conv.i2
		IL_0110: ldc.i4 417882649
		IL_0115: stloc 2
		IL_0119: nop
		IL_011a: ldloca 2
		IL_011e: nop
		IL_011f: ldind.i2
		IL_0120: conv.i2
		IL_0121: ceq
		IL_0123: switch (IL_0060, IL_0135, IL_0060)

		IL_0134: nop

		IL_0135: ldc.i4 765853697
		IL_013a: stloc 2
		IL_013e: nop
		IL_013f: ldloca 2
		IL_0143: nop
		IL_0144: ldind.i2
		IL_0145: conv.i2
		IL_0146: br.s IL_015a

		IL_0148: ldc.i4 482279424
		IL_014d: stloc 2
		IL_0151: ldloca 2
		IL_0155: nop
		IL_0156: ldind.i2
		IL_0157: conv.i2
		IL_0158: br.s IL_015a

		IL_015a: brfalse.s IL_015c

		IL_015c: ldc.i4 1225654272
		IL_0161: stloc 2
		IL_0165: nop
		IL_0166: ldloca 2
		IL_016a: ldind.i2
		IL_016b: conv.i2
		IL_016c: brfalse IL_0171

		IL_0171: br.s IL_0173

		IL_0173: ldc.i4.1
		IL_0174: ret
	} // end of method Arrays::w

	.method private hidebysig static 
		bool w (
			int32[] A_0,
			int32[] A_1
		) cil managed 
	{
		// Method begins at RVA 0x2ecc
		// Header size: 12
		// Code size: 376 (0x178)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0028)

		IL_000a: ldloc.1
		IL_000b: switch (IL_00a5, IL_0084, IL_00f0, IL_010c, IL_0129, IL_0067)

		IL_0028: ldc.i4 1135935489
		IL_002d: stloc 2
		IL_0031: ldloca 2
		IL_0035: nop
		IL_0036: ldind.i2
		IL_0037: conv.i2
		IL_0038: br.s IL_004c

		IL_003a: ldc.i4 572588032
		IL_003f: nop
		IL_0040: stloc 2
		IL_0044: ldloca 2
		IL_0048: ldind.i2
		IL_0049: conv.i2
		IL_004a: br.s IL_004c

		IL_004c: brfalse.s IL_004e

		IL_004e: ldarg.0
		IL_004f: ldlen
		IL_0050: conv.i4
		IL_0051: stloc.0
		IL_0052: ldc.i4 1861353477
		IL_0057: nop
		IL_0058: stloc 2
		IL_005c: ldloca 2
		IL_0060: nop
		IL_0061: ldind.i2
		IL_0062: conv.i2
		IL_0063: conv.i
		IL_0064: stloc.1
		IL_0065: br.s IL_000a

		IL_0067: ldloc.0
		IL_0068: ldarg.1
		IL_0069: ldlen
		IL_006a: conv.i4
		IL_006b: beq IL_00f4

		IL_0070: ldc.i4 382664705
		IL_0075: stloc 2
		IL_0079: ldloca 2
		IL_007d: nop
		IL_007e: ldind.i2
		IL_007f: conv.i2
		IL_0080: conv.i
		IL_0081: stloc.1
		IL_0082: br.s IL_000a

		IL_0084: br.s IL_00f2

		IL_0086: ldc.i4.0
		IL_0087: ret

		IL_0088: ldloc.0
		IL_0089: ldc.i4.1
		IL_008a: sub
		IL_008b: stloc.0
		IL_008c: ldc.i4 1381892096
		IL_0091: nop
		IL_0092: stloc 2
		IL_0096: nop
		IL_0097: ldloca 2
		IL_009b: nop
		IL_009c: ldind.i2
		IL_009d: conv.i2
		IL_009e: conv.i
		IL_009f: stloc.1
		IL_00a0: br IL_000a

		IL_00a5: br.s IL_00bc

		IL_00a7: ldc.i4 1667432448
		IL_00ac: nop
		IL_00ad: stloc 2
		IL_00b1: nop
		IL_00b2: ldloca 2
		IL_00b6: nop
		IL_00b7: ldind.i2
		IL_00b8: conv.i2

		IL_00b9: pop
		IL_00ba: br.s IL_00ce

		IL_00bc: ldc.i4 2023161856
		IL_00c1: nop
		IL_00c2: stloc 2
		IL_00c6: ldloca 2
		IL_00ca: ldind.i2
		IL_00cb: conv.i2
		IL_00cc: br.s IL_00b9

		IL_00ce: nop
		IL_00cf: ldarg.0
		IL_00d0: ldloc.0
		IL_00d1: ldelem.i4
		IL_00d2: ldarg.1
		IL_00d3: ldloc.0
		IL_00d4: ldelem.i4
		IL_00d5: beq.s IL_00f4

		IL_00d7: ldc.i4 723386370
		IL_00dc: nop
		IL_00dd: stloc 2
		IL_00e1: nop
		IL_00e2: ldloca 2
		IL_00e6: nop
		IL_00e7: ldind.i2
		IL_00e8: conv.i2
		IL_00e9: conv.i
		IL_00ea: stloc.1
		IL_00eb: br IL_000a

		IL_00f0: br.s IL_0086

		IL_00f2: ldc.i4.0
		IL_00f3: ret

		IL_00f4: ldc.i4 1763049475
		IL_00f9: stloc 2
		IL_00fd: nop
		IL_00fe: ldloca 2
		IL_0102: nop
		IL_0103: ldind.i2
		IL_0104: conv.i2
		IL_0105: conv.i
		IL_0106: stloc.1
		IL_0107: br IL_000a

		IL_010c: ldloc.0
		IL_010d: brtrue IL_0088

		IL_0112: ldc.i4 83623940
		IL_0117: stloc 2
		IL_011b: nop
		IL_011c: ldloca 2
		IL_0120: ldind.i2
		IL_0121: conv.i2
		IL_0122: conv.i
		IL_0123: stloc.1
		IL_0124: br IL_000a

		IL_0129: ldc.i4 1318174136
		IL_012e: stloc 2
		IL_0132: ldloca 2
		IL_0136: nop
		IL_0137: ldind.i2
		IL_0138: conv.i2
		IL_0139: ldc.i4 1093975480
		IL_013e: nop
		IL_013f: stloc 2
		IL_0143: ldloca 2
		IL_0147: nop
		IL_0148: ldind.i2
		IL_0149: conv.i2
		IL_014a: ceq
		IL_014c: switch (IL_0086, IL_015e, IL_0086)

		IL_015d: nop

		IL_015e: ldc.i4 1739325440
		IL_0163: nop
		IL_0164: stloc 2
		IL_0168: ldloca 2
		IL_016c: nop
		IL_016d: ldind.i2
		IL_016e: conv.i2
		IL_016f: brfalse IL_0174

		IL_0174: br.s IL_0176

		IL_0176: ldc.i4.1
		IL_0177: ret
	} // end of method Arrays::w

	.method private hidebysig static 
		bool w (
			uint32[] A_0,
			uint32[] A_1
		) cil managed 
	{
		// Method begins at RVA 0x3050
		// Header size: 12
		// Code size: 383 (0x17f)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0028)

		IL_000a: ldloc.1
		IL_000b: switch (IL_00a7, IL_005e, IL_00f1, IL_0111, IL_012f, IL_0041)

		IL_0028: ldarg.0
		IL_0029: ldlen
		IL_002a: conv.i4
		IL_002b: stloc.0
		IL_002c: ldc.i4 919732229
		IL_0031: nop
		IL_0032: stloc 2
		IL_0036: nop
		IL_0037: ldloca 2
		IL_003b: ldind.i2
		IL_003c: conv.i2
		IL_003d: conv.i
		IL_003e: stloc.1
		IL_003f: br.s IL_000a

		IL_0041: ldloc.0
		IL_0042: ldarg.1
		IL_0043: ldlen
		IL_0044: conv.i4
		IL_0045: beq IL_00f8

		IL_004a: ldc.i4 688586753
		IL_004f: stloc 2
		IL_0053: ldloca 2
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: conv.i
		IL_005b: stloc.1
		IL_005c: br.s IL_000a

		IL_005e: br IL_00f6

		IL_0063: ldc.i4 242155521
		IL_0068: stloc 2
		IL_006c: ldloca 2
		IL_0070: nop
		IL_0071: ldind.i2
		IL_0072: conv.i2
		IL_0073: br.s IL_0087

		IL_0075: ldc.i4 481361920
		IL_007a: stloc 2
		IL_007e: ldloca 2
		IL_0082: nop
		IL_0083: ldind.i2
		IL_0084: conv.i2
		IL_0085: br.s IL_0087

		IL_0087: brfalse.s IL_0089

		IL_0089: ldc.i4.0
		IL_008a: ret

		IL_008b: ldloc.0
		IL_008c: ldc.i4.1
		IL_008d: sub
		IL_008e: stloc.0
		IL_008f: ldc.i4 1956315136
		IL_0094: stloc 2
		IL_0098: nop
		IL_0099: ldloca 2
		IL_009d: nop
		IL_009e: ldind.i2
		IL_009f: conv.i2
		IL_00a0: conv.i
		IL_00a1: stloc.1
		IL_00a2: br IL_000a

		IL_00a7: br.s IL_00be

		IL_00a9: ldc.i4 372441088
		IL_00ae: nop
		IL_00af: stloc 2
		IL_00b3: nop
		IL_00b4: ldloca 2
		IL_00b8: nop
		IL_00b9: ldind.i2
		IL_00ba: conv.i2

		IL_00bb: pop
		IL_00bc: br.s IL_00d0

		IL_00be: ldc.i4 1536229376
		IL_00c3: nop
		IL_00c4: stloc 2
		IL_00c8: ldloca 2
		IL_00cc: ldind.i2
		IL_00cd: conv.i2
		IL_00ce: br.s IL_00bb

		IL_00d0: nop
		IL_00d1: ldarg.0
		IL_00d2: ldloc.0
		IL_00d3: ldelem.u4
		IL_00d4: ldarg.1
		IL_00d5: ldloc.0
		IL_00d6: ldelem.u4
		IL_00d7: beq.s IL_00f8

		IL_00d9: ldc.i4 1958805506
		IL_00de: stloc 2
		IL_00e2: nop
		IL_00e3: ldloca 2
		IL_00e7: nop
		IL_00e8: ldind.i2
		IL_00e9: conv.i2
		IL_00ea: conv.i
		IL_00eb: stloc.1
		IL_00ec: br IL_000a

		IL_00f1: br IL_0063

		IL_00f6: ldc.i4.0
		IL_00f7: ret

		IL_00f8: ldc.i4 1215037443
		IL_00fd: nop
		IL_00fe: stloc 2
		IL_0102: nop
		IL_0103: ldloca 2
		IL_0107: nop
		IL_0108: ldind.i2
		IL_0109: conv.i2
		IL_010a: conv.i
		IL_010b: stloc.1
		IL_010c: br IL_000a

		IL_0111: ldloc.0
		IL_0112: brtrue IL_008b

		IL_0117: ldc.i4 214827012
		IL_011c: nop
		IL_011d: stloc 2
		IL_0121: ldloca 2
		IL_0125: nop
		IL_0126: ldind.i2
		IL_0127: conv.i2
		IL_0128: conv.i
		IL_0129: stloc.1
		IL_012a: br IL_000a

		IL_012f: ldc.i4 1434583882
		IL_0134: stloc 2
		IL_0138: nop
		IL_0139: ldloca 2
		IL_013d: nop
		IL_013e: ldind.i2
		IL_013f: conv.i2
		IL_0140: ldc.i4 1678181194
		IL_0145: nop
		IL_0146: stloc 2
		IL_014a: ldloca 2
		IL_014e: nop
		IL_014f: ldind.i2
		IL_0150: conv.i2
		IL_0151: ceq
		IL_0153: switch (IL_0063, IL_0165, IL_0063)

		IL_0164: nop

		IL_0165: ldc.i4 347996160
		IL_016a: nop
		IL_016b: stloc 2
		IL_016f: nop
		IL_0170: ldloca 2
		IL_0174: ldind.i2
		IL_0175: conv.i2
		IL_0176: brfalse IL_017b

		IL_017b: br.s IL_017d

		IL_017d: ldc.i4.1
		IL_017e: ret
	} // end of method Arrays::w

	.method public hidebysig static 
		string ToString (
			object[] a
		) cil managed 
	{
		// Method begins at RVA 0x31dc
		// Header size: 12
		// Code size: 431 (0x1af)
		.maxstack 3
		.locals init (
			[0] class [mscorlib]System.Text.StringBuilder,
			[1] int32,
			[2] int32,
			[3] int16,
			[4] int32
		)

		IL_0000: ldc.i4 14
		IL_0005: stloc 4
		IL_0009: ldc.i4.0
		IL_000a: switch (IL_0031)

		IL_0013: ldloc.2
		IL_0014: switch (IL_011b, IL_0069, IL_0138, IL_0174, IL_019a, IL_004e)

		IL_0031: ldc.i4.s 91
		IL_0033: newobj instance void [mscorlib]System.Text.StringBuilder::.ctor(int32)
		IL_0038: stloc.0
		IL_0039: ldc.i4 917241861
		IL_003e: nop
		IL_003f: stloc 3
		IL_0043: nop
		IL_0044: ldloca 3
		IL_0048: ldind.i2
		IL_0049: conv.i2
		IL_004a: conv.i
		IL_004b: stloc.2
		IL_004c: br.s IL_0013

		IL_004e: ldarg.0
		IL_004f: ldlen
		IL_0050: brfalse IL_019f

		IL_0055: ldc.i4 966983681
		IL_005a: nop
		IL_005b: stloc 3
		IL_005f: ldloca 3
		IL_0063: ldind.i2
		IL_0064: conv.i2
		IL_0065: conv.i
		IL_0066: stloc.2
		IL_0067: br.s IL_0013

		IL_0069: ldc.i4 1761280001
		IL_006e: stloc 3
		IL_0072: ldloca 3
		IL_0076: nop
		IL_0077: ldind.i2
		IL_0078: conv.i2
		IL_0079: br.s IL_008d

		IL_007b: ldc.i4 725680128
		IL_0080: stloc 3
		IL_0084: nop
		IL_0085: ldloca 3
		IL_0089: ldind.i2
		IL_008a: conv.i2
		IL_008b: br.s IL_008d

		IL_008d: brfalse.s IL_008f

		IL_008f: ldc.i4 1088239012
		IL_0094: nop
		IL_0095: stloc 3
		IL_0099: ldloca 3
		IL_009d: ldind.i2
		IL_009e: conv.i2
		IL_009f: ldc.i4 326514084
		IL_00a4: nop
		IL_00a5: stloc 3
		IL_00a9: ldloca 3
		IL_00ad: ldind.i2
		IL_00ae: conv.i2
		IL_00af: ceq
		IL_00b1: switch (IL_0176, IL_00c3, IL_0176)

		IL_00c2: nop

		IL_00c3: br.s IL_00d8

		IL_00c5: ldc.i4 188088320
		IL_00ca: stloc 3
		IL_00ce: nop
		IL_00cf: ldloca 3
		IL_00d3: ldind.i2
		IL_00d4: conv.i2

		IL_00d5: pop
		IL_00d6: br.s IL_00ea

		IL_00d8: ldc.i4 136445952
		IL_00dd: stloc 3
		IL_00e1: nop
		IL_00e2: ldloca 3
		IL_00e6: ldind.i2
		IL_00e7: conv.i2
		IL_00e8: br.s IL_00d5

		IL_00ea: nop
		IL_00eb: ldc.i4 977141760
		IL_00f0: nop
		IL_00f1: stloc 3
		IL_00f5: nop
		IL_00f6: ldloca 3
		IL_00fa: ldind.i2
		IL_00fb: conv.i2
		IL_00fc: brfalse IL_0101

		IL_0101: br.s IL_0176

		IL_0103: ldc.i4 1423310848
		IL_0108: nop
		IL_0109: stloc 3
		IL_010d: nop
		IL_010e: ldloca 3
		IL_0112: ldind.i2
		IL_0113: conv.i2
		IL_0114: conv.i
		IL_0115: stloc.2
		IL_0116: br IL_0013

		IL_011b: ldloc.1
		IL_011c: ldarg.0
		IL_011d: ldlen
		IL_011e: conv.i4
		IL_011f: blt.s IL_013a

		IL_0121: ldc.i4 845938690
		IL_0126: stloc 3
		IL_012a: ldloca 3
		IL_012e: nop
		IL_012f: ldind.i2
		IL_0130: conv.i2
		IL_0131: conv.i
		IL_0132: stloc.2
		IL_0133: br IL_0013

		IL_0138: br.s IL_019f

		IL_013a: ldloc.0
		IL_013b: ldstr "??"
		IL_0140: ldloc 4
		IL_0144: call string ODCrypt.Sha3::b(string, int32)
		IL_0149: callvirt instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
		IL_014e: ldarg.0
		IL_014f: ldloc.1
		IL_0150: ldelem.ref
		IL_0151: callvirt instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(object)
		IL_0156: pop
		IL_0157: ldloc.1
		IL_0158: ldc.i4.1
		IL_0159: add
		IL_015a: stloc.1
		IL_015b: ldc.i4 569573379
		IL_0160: nop
		IL_0161: stloc 3
		IL_0165: nop
		IL_0166: ldloca 3
		IL_016a: nop
		IL_016b: ldind.i2
		IL_016c: conv.i2
		IL_016d: conv.i
		IL_016e: stloc.2
		IL_016f: br IL_0013

		IL_0174: br.s IL_0103

		IL_0176: ldloc.0
		IL_0177: ldarg.0
		IL_0178: ldc.i4.0
		IL_0179: ldelem.ref
		IL_017a: callvirt instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(object)
		IL_017f: pop
		IL_0180: ldc.i4.1
		IL_0181: stloc.1
		IL_0182: ldc.i4 436928516
		IL_0187: stloc 3
		IL_018b: nop
		IL_018c: ldloca 3
		IL_0190: nop
		IL_0191: ldind.i2
		IL_0192: conv.i2
		IL_0193: conv.i
		IL_0194: stloc.2
		IL_0195: br IL_0013

		IL_019a: br IL_0103

		IL_019f: ldloc.0
		IL_01a0: ldc.i4.s 93
		IL_01a2: callvirt instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(char)
		IL_01a7: pop
		IL_01a8: ldloc.0
		IL_01a9: callvirt instance string [mscorlib]System.Object::ToString()
		IL_01ae: ret
	} // end of method Arrays::ToString

	.method public hidebysig static 
		int32 GetHashCode (
			uint8[] data
		) cil managed 
	{
		// Method begins at RVA 0x3398
		// Header size: 12
		// Code size: 384 (0x180)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4 987234309
		IL_0005: stloc 3
		IL_0009: ldloca 3
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: conv.i
		IL_0011: stloc.2
		IL_0012: br.s IL_001e
		// loop start (head: IL_001e)
			IL_0014: ldc.i4.0
			IL_0015: switch (IL_003c)

			IL_001e: ldloc.2
			IL_001f: switch (IL_011c, IL_0058, IL_013d, IL_0159, IL_017c, IL_0014)
		// end loop

		IL_003c: ldarg.0
		IL_003d: brtrue IL_011e

		IL_0042: ldc.i4 309657601
		IL_0047: nop
		IL_0048: stloc 3
		IL_004c: nop
		IL_004d: ldloca 3
		IL_0051: nop
		IL_0052: ldind.i2
		IL_0053: conv.i2
		IL_0054: conv.i
		IL_0055: stloc.2
		IL_0056: br.s IL_001e

		IL_0058: br IL_013f

		IL_005d: ldc.i4 2087569215
		IL_0062: stloc 3
		IL_0066: ldloca 3
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: ldc.i4 292210495
		IL_0072: nop
		IL_0073: stloc 3
		IL_0077: ldloca 3
		IL_007b: ldind.i2
		IL_007c: conv.i2
		IL_007d: ceq
		IL_007f: switch (IL_0159, IL_0091, IL_0159)

		IL_0090: nop

		IL_0091: ldc.i4 797376513
		IL_0096: stloc 3
		IL_009a: ldloca 3
		IL_009e: nop
		IL_009f: ldind.i2
		IL_00a0: conv.i2
		IL_00a1: br.s IL_00b5

		IL_00a3: ldc.i4 1399717888
		IL_00a8: stloc 3
		IL_00ac: nop
		IL_00ad: ldloca 3
		IL_00b1: ldind.i2
		IL_00b2: conv.i2
		IL_00b3: br.s IL_00b5

		IL_00b5: brfalse.s IL_00b7

		IL_00b7: br.s IL_00cc

		IL_00b9: ldc.i4 56557568
		IL_00be: nop
		IL_00bf: stloc 3
		IL_00c3: ldloca 3
		IL_00c7: ldind.i2
		IL_00c8: conv.i2

		IL_00c9: pop
		IL_00ca: br.s IL_00de

		IL_00cc: ldc.i4 1112276992
		IL_00d1: stloc 3
		IL_00d5: ldloca 3
		IL_00d9: nop
		IL_00da: ldind.i2
		IL_00db: conv.i2
		IL_00dc: br.s IL_00c9

		IL_00de: nop
		IL_00df: ldc.i4 846397440
		IL_00e4: nop
		IL_00e5: stloc 3
		IL_00e9: ldloca 3
		IL_00ed: nop
		IL_00ee: ldind.i2
		IL_00ef: conv.i2
		IL_00f0: brfalse IL_00f5

		IL_00f5: ldloc.1
		IL_00f6: ldc.i4 257
		IL_00fb: mul
		IL_00fc: stloc.1
		IL_00fd: ldloc.1
		IL_00fe: ldarg.0
		IL_00ff: ldloc.0
		IL_0100: ldelem.u1
		IL_0101: xor
		IL_0102: stloc.1
		IL_0103: ldc.i4 1671954432
		IL_0108: nop
		IL_0109: stloc 3
		IL_010d: nop
		IL_010e: ldloca 3
		IL_0112: nop
		IL_0113: ldind.i2
		IL_0114: conv.i2
		IL_0115: conv.i
		IL_0116: stloc.2
		IL_0117: br IL_001e

		IL_011c: br.s IL_0141

		IL_011e: ldarg.0
		IL_011f: ldlen
		IL_0120: conv.i4
		IL_0121: stloc.0
		IL_0122: ldloc.0
		IL_0123: ldc.i4.1
		IL_0124: add
		IL_0125: stloc.1
		IL_0126: ldc.i4 1223622658
		IL_012b: nop
		IL_012c: stloc 3
		IL_0130: ldloca 3
		IL_0134: ldind.i2
		IL_0135: conv.i2
		IL_0136: conv.i
		IL_0137: stloc.2
		IL_0138: br IL_001e

		IL_013d: br.s IL_0141

		IL_013f: ldc.i4.0
		IL_0140: ret

		IL_0141: ldc.i4 1983905795
		IL_0146: nop
		IL_0147: stloc 3
		IL_014b: nop
		IL_014c: ldloca 3
		IL_0150: ldind.i2
		IL_0151: conv.i2
		IL_0152: conv.i
		IL_0153: stloc.2
		IL_0154: br IL_001e

		IL_0159: ldloc.0
		IL_015a: ldc.i4.1
		IL_015b: sub
		IL_015c: dup
		IL_015d: stloc.0
		IL_015e: ldc.i4.0
		IL_015f: bge IL_005d

		IL_0164: ldc.i4 318504964
		IL_0169: stloc 3
		IL_016d: nop
		IL_016e: ldloca 3
		IL_0172: nop
		IL_0173: ldind.i2
		IL_0174: conv.i2
		IL_0175: conv.i
		IL_0176: stloc.2
		IL_0177: br IL_001e

		IL_017c: br.s IL_017e

		IL_017e: ldloc.1
		IL_017f: ret
	} // end of method Arrays::GetHashCode

	.method public hidebysig static 
		int32 GetHashCode (
			uint8[] data,
			int32 off,
			int32 len
		) cil managed 
	{
		// Method begins at RVA 0x3524
		// Header size: 12
		// Code size: 386 (0x182)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4 1616642053
		IL_0005: nop
		IL_0006: stloc 3
		IL_000a: ldloca 3
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: conv.i
		IL_0011: stloc.2
		IL_0012: br.s IL_001e
		// loop start (head: IL_001e)
			IL_0014: ldc.i4.0
			IL_0015: switch (IL_003c)

			IL_001e: ldloc.2
			IL_001f: switch (IL_0121, IL_0057, IL_0140, IL_015b, IL_017e, IL_0014)
		// end loop

		IL_003c: ldarg.0
		IL_003d: brtrue IL_0123

		IL_0042: ldc.i4 572260353
		IL_0047: stloc 3
		IL_004b: nop
		IL_004c: ldloca 3
		IL_0050: nop
		IL_0051: ldind.i2
		IL_0052: conv.i2
		IL_0053: conv.i
		IL_0054: stloc.2
		IL_0055: br.s IL_001e

		IL_0057: br IL_0142

		IL_005c: ldc.i4 721761185
		IL_0061: stloc 3
		IL_0065: ldloca 3
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: ldc.i4 589575073
		IL_0071: nop
		IL_0072: stloc 3
		IL_0076: nop
		IL_0077: ldloca 3
		IL_007b: nop
		IL_007c: ldind.i2
		IL_007d: conv.i2
		IL_007e: ceq
		IL_0080: switch (IL_015b, IL_0092, IL_015b)

		IL_0091: nop

		IL_0092: ldc.i4 1732640768
		IL_0097: stloc 3
		IL_009b: nop
		IL_009c: ldloca 3
		IL_00a0: nop
		IL_00a1: ldind.i2
		IL_00a2: conv.i2
		IL_00a3: brfalse IL_00a8

		IL_00a8: br.s IL_00bd

		IL_00aa: ldc.i4 33423360
		IL_00af: stloc 3
		IL_00b3: ldloca 3
		IL_00b7: nop
		IL_00b8: ldind.i2
		IL_00b9: conv.i2

		IL_00ba: pop
		IL_00bb: br.s IL_00d0

		IL_00bd: ldc.i4 1155399680
		IL_00c2: stloc 3
		IL_00c6: nop
		IL_00c7: ldloca 3
		IL_00cb: nop
		IL_00cc: ldind.i2
		IL_00cd: conv.i2
		IL_00ce: br.s IL_00ba

		IL_00d0: nop
		IL_00d1: ldc.i4 475398145
		IL_00d6: nop
		IL_00d7: stloc 3
		IL_00db: nop
		IL_00dc: ldloca 3
		IL_00e0: ldind.i2
		IL_00e1: conv.i2
		IL_00e2: br.s IL_00f7

		IL_00e4: ldc.i4 877395968
		IL_00e9: nop
		IL_00ea: stloc 3
		IL_00ee: nop
		IL_00ef: ldloca 3
		IL_00f3: ldind.i2
		IL_00f4: conv.i2
		IL_00f5: br.s IL_00f7

		IL_00f7: brfalse.s IL_00f9

		IL_00f9: ldloc.1
		IL_00fa: ldc.i4 257
		IL_00ff: mul
		IL_0100: stloc.1
		IL_0101: ldloc.1
		IL_0102: ldarg.0
		IL_0103: ldarg.1
		IL_0104: ldloc.0
		IL_0105: add
		IL_0106: ldelem.u1
		IL_0107: xor
		IL_0108: stloc.1
		IL_0109: ldc.i4 372244480
		IL_010e: nop
		IL_010f: stloc 3
		IL_0113: nop
		IL_0114: ldloca 3
		IL_0118: ldind.i2
		IL_0119: conv.i2
		IL_011a: conv.i
		IL_011b: stloc.2
		IL_011c: br IL_001e

		IL_0121: br.s IL_0144

		IL_0123: ldarg.2
		IL_0124: stloc.0
		IL_0125: ldloc.0
		IL_0126: ldc.i4.1
		IL_0127: add
		IL_0128: stloc.1
		IL_0129: ldc.i4 1138950146
		IL_012e: stloc 3
		IL_0132: ldloca 3
		IL_0136: nop
		IL_0137: ldind.i2
		IL_0138: conv.i2
		IL_0139: conv.i
		IL_013a: stloc.2
		IL_013b: br IL_001e

		IL_0140: br.s IL_0144

		IL_0142: ldc.i4.0
		IL_0143: ret

		IL_0144: ldc.i4 2010710019
		IL_0149: stloc 3
		IL_014d: ldloca 3
		IL_0151: nop
		IL_0152: ldind.i2
		IL_0153: conv.i2
		IL_0154: conv.i
		IL_0155: stloc.2
		IL_0156: br IL_001e

		IL_015b: ldloc.0
		IL_015c: ldc.i4.1
		IL_015d: sub
		IL_015e: dup
		IL_015f: stloc.0
		IL_0160: ldc.i4.0
		IL_0161: bge IL_005c

		IL_0166: ldc.i4 1066598404
		IL_016b: nop
		IL_016c: stloc 3
		IL_0170: nop
		IL_0171: ldloca 3
		IL_0175: ldind.i2
		IL_0176: conv.i2
		IL_0177: conv.i
		IL_0178: stloc.2
		IL_0179: br IL_001e

		IL_017e: br.s IL_0180

		IL_0180: ldloc.1
		IL_0181: ret
	} // end of method Arrays::GetHashCode

	.method public hidebysig static 
		int32 GetHashCode (
			int32[] data
		) cil managed 
	{
		// Method begins at RVA 0x36b4
		// Header size: 12
		// Code size: 384 (0x180)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4 616300549
		IL_0005: nop
		IL_0006: stloc 3
		IL_000a: nop
		IL_000b: ldloca 3
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: conv.i
		IL_0012: stloc.2
		IL_0013: br.s IL_0046
		// loop start (head: IL_0046)
			IL_0015: ldc.i4 1664876545
			IL_001a: nop
			IL_001b: stloc 3
			IL_001f: nop
			IL_0020: ldloca 3
			IL_0024: ldind.i2
			IL_0025: conv.i2
			IL_0026: br.s IL_003a

			IL_0028: ldc.i4 1652293632
			IL_002d: stloc 3
			IL_0031: nop
			IL_0032: ldloca 3
			IL_0036: ldind.i2
			IL_0037: conv.i2
			IL_0038: br.s IL_003a

			IL_003a: brfalse.s IL_003c

			IL_003c: ldc.i4.0
			IL_003d: switch (IL_0064)

			IL_0046: ldloc.2
			IL_0047: switch (IL_011b, IL_007e, IL_013c, IL_0159, IL_017c, IL_0015)
		// end loop

		IL_0064: ldarg.0
		IL_0065: brtrue IL_011d

		IL_006a: ldc.i4 1630797825
		IL_006f: nop
		IL_0070: stloc 3
		IL_0074: ldloca 3
		IL_0078: ldind.i2
		IL_0079: conv.i2
		IL_007a: conv.i
		IL_007b: stloc.2
		IL_007c: br.s IL_0046

		IL_007e: br IL_013e

		IL_0083: ldc.i4 554585185
		IL_0088: nop
		IL_0089: stloc 3
		IL_008d: nop
		IL_008e: ldloca 3
		IL_0092: ldind.i2
		IL_0093: conv.i2
		IL_0094: ldc.i4 1196969057
		IL_0099: stloc 3
		IL_009d: nop
		IL_009e: ldloca 3
		IL_00a2: ldind.i2
		IL_00a3: conv.i2
		IL_00a4: ceq
		IL_00a6: switch (IL_0159, IL_00b8, IL_0159)

		IL_00b7: nop

		IL_00b8: br.s IL_00cd

		IL_00ba: ldc.i4 452001792
		IL_00bf: stloc 3
		IL_00c3: nop
		IL_00c4: ldloca 3
		IL_00c8: ldind.i2
		IL_00c9: conv.i2

		IL_00ca: pop
		IL_00cb: br.s IL_00e0

		IL_00cd: ldc.i4 641794048
		IL_00d2: nop
		IL_00d3: stloc 3
		IL_00d7: nop
		IL_00d8: ldloca 3
		IL_00dc: ldind.i2
		IL_00dd: conv.i2
		IL_00de: br.s IL_00ca

		IL_00e0: nop
		IL_00e1: ldc.i4 628621312
		IL_00e6: stloc 3
		IL_00ea: ldloca 3
		IL_00ee: nop
		IL_00ef: ldind.i2
		IL_00f0: conv.i2
		IL_00f1: brfalse IL_00f6

		IL_00f6: ldloc.1
		IL_00f7: ldc.i4 257
		IL_00fc: mul
		IL_00fd: stloc.1
		IL_00fe: ldloc.1
		IL_00ff: ldarg.0
		IL_0100: ldloc.0
		IL_0101: ldelem.i4
		IL_0102: xor
		IL_0103: stloc.1
		IL_0104: ldc.i4 1119158272
		IL_0109: stloc 3
		IL_010d: ldloca 3
		IL_0111: nop
		IL_0112: ldind.i2
		IL_0113: conv.i2
		IL_0114: conv.i
		IL_0115: stloc.2
		IL_0116: br IL_0046

		IL_011b: br.s IL_0140

		IL_011d: ldarg.0
		IL_011e: ldlen
		IL_011f: conv.i4
		IL_0120: stloc.0
		IL_0121: ldloc.0
		IL_0122: ldc.i4.1
		IL_0123: add
		IL_0124: stloc.1
		IL_0125: ldc.i4 288161794
		IL_012a: stloc 3
		IL_012e: ldloca 3
		IL_0132: nop
		IL_0133: ldind.i2
		IL_0134: conv.i2
		IL_0135: conv.i
		IL_0136: stloc.2
		IL_0137: br IL_0046

		IL_013c: br.s IL_0140

		IL_013e: ldc.i4.0
		IL_013f: ret

		IL_0140: ldc.i4 998244355
		IL_0145: nop
		IL_0146: stloc 3
		IL_014a: nop
		IL_014b: ldloca 3
		IL_014f: nop
		IL_0150: ldind.i2
		IL_0151: conv.i2
		IL_0152: conv.i
		IL_0153: stloc.2
		IL_0154: br IL_0046

		IL_0159: ldloc.0
		IL_015a: ldc.i4.1
		IL_015b: sub
		IL_015c: dup
		IL_015d: stloc.0
		IL_015e: ldc.i4.0
		IL_015f: bge IL_0083

		IL_0164: ldc.i4 513015812
		IL_0169: stloc 3
		IL_016d: nop
		IL_016e: ldloca 3
		IL_0172: nop
		IL_0173: ldind.i2
		IL_0174: conv.i2
		IL_0175: conv.i
		IL_0176: stloc.2
		IL_0177: br IL_0046

		IL_017c: br.s IL_017e

		IL_017e: ldloc.1
		IL_017f: ret
	} // end of method Arrays::GetHashCode

	.method public hidebysig static 
		int32 GetHashCode (
			int32[] data,
			int32 off,
			int32 len
		) cil managed 
	{
		// Method begins at RVA 0x3840
		// Header size: 12
		// Code size: 386 (0x182)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4 1469448197
		IL_0005: stloc 3
		IL_0009: nop
		IL_000a: ldloca 3
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: conv.i
		IL_0011: stloc.2
		IL_0012: br.s IL_001e
		// loop start (head: IL_001e)
			IL_0014: ldc.i4.0
			IL_0015: switch (IL_003c)

			IL_001e: ldloc.2
			IL_001f: switch (IL_00f8, IL_0056, IL_0118, IL_0133, IL_017e, IL_0014)
		// end loop

		IL_003c: ldarg.0
		IL_003d: brtrue IL_00fa

		IL_0042: ldc.i4 912982017
		IL_0047: stloc 3
		IL_004b: ldloca 3
		IL_004f: nop
		IL_0050: ldind.i2
		IL_0051: conv.i2
		IL_0052: conv.i
		IL_0053: stloc.2
		IL_0054: br.s IL_001e

		IL_0056: br IL_011a

		IL_005b: ldc.i4 47170285
		IL_0060: nop
		IL_0061: stloc 3
		IL_0065: nop
		IL_0066: ldloca 3
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: ldc.i4 16892653
		IL_0071: nop
		IL_0072: stloc 3
		IL_0076: nop
		IL_0077: ldloca 3
		IL_007b: ldind.i2
		IL_007c: conv.i2
		IL_007d: ceq
		IL_007f: switch (IL_0133, IL_0091, IL_0133)

		IL_0090: nop

		IL_0091: ldc.i4 1344667648
		IL_0096: nop
		IL_0097: stloc 3
		IL_009b: nop
		IL_009c: ldloca 3
		IL_00a0: ldind.i2
		IL_00a1: conv.i2
		IL_00a2: brfalse IL_00a7

		IL_00a7: br.s IL_00bd

		IL_00a9: ldc.i4 1218707456
		IL_00ae: stloc 3
		IL_00b2: nop
		IL_00b3: ldloca 3
		IL_00b7: nop
		IL_00b8: ldind.i2
		IL_00b9: conv.i2

		IL_00ba: pop
		IL_00bb: br.s IL_00d0

		IL_00bd: ldc.i4 1690697728
		IL_00c2: nop
		IL_00c3: stloc 3
		IL_00c7: nop
		IL_00c8: ldloca 3
		IL_00cc: ldind.i2
		IL_00cd: conv.i2
		IL_00ce: br.s IL_00ba

		IL_00d0: nop
		IL_00d1: ldloc.1
		IL_00d2: ldc.i4 257
		IL_00d7: mul
		IL_00d8: stloc.1
		IL_00d9: ldloc.1
		IL_00da: ldarg.0
		IL_00db: ldarg.1
		IL_00dc: ldloc.0
		IL_00dd: add
		IL_00de: ldelem.i4
		IL_00df: xor
		IL_00e0: stloc.1
		IL_00e1: ldc.i4 1099038720
		IL_00e6: stloc 3
		IL_00ea: ldloca 3
		IL_00ee: nop
		IL_00ef: ldind.i2
		IL_00f0: conv.i2
		IL_00f1: conv.i
		IL_00f2: stloc.2
		IL_00f3: br IL_001e

		IL_00f8: br.s IL_011c

		IL_00fa: ldarg.2
		IL_00fb: stloc.0
		IL_00fc: ldloc.0
		IL_00fd: ldc.i4.1
		IL_00fe: add
		IL_00ff: stloc.1
		IL_0100: ldc.i4 1656750082
		IL_0105: stloc 3
		IL_0109: nop
		IL_010a: ldloca 3
		IL_010e: nop
		IL_010f: ldind.i2
		IL_0110: conv.i2
		IL_0111: conv.i
		IL_0112: stloc.2
		IL_0113: br IL_001e

		IL_0118: br.s IL_011c

		IL_011a: ldc.i4.0
		IL_011b: ret

		IL_011c: ldc.i4 979369987
		IL_0121: stloc 3
		IL_0125: ldloca 3
		IL_0129: nop
		IL_012a: ldind.i2
		IL_012b: conv.i2
		IL_012c: conv.i
		IL_012d: stloc.2
		IL_012e: br IL_001e

		IL_0133: ldc.i4 1594163201
		IL_0138: nop
		IL_0139: stloc 3
		IL_013d: ldloca 3
		IL_0141: nop
		IL_0142: ldind.i2
		IL_0143: conv.i2
		IL_0144: br.s IL_015a

		IL_0146: ldc.i4 955056128
		IL_014b: nop
		IL_014c: stloc 3
		IL_0150: nop
		IL_0151: ldloca 3
		IL_0155: nop
		IL_0156: ldind.i2
		IL_0157: conv.i2
		IL_0158: br.s IL_015a

		IL_015a: brfalse.s IL_015c

		IL_015c: ldloc.0
		IL_015d: ldc.i4.1
		IL_015e: sub
		IL_015f: dup
		IL_0160: stloc.0
		IL_0161: ldc.i4.0
		IL_0162: bge IL_005b

		IL_0167: ldc.i4 1238958084
		IL_016c: stloc 3
		IL_0170: ldloca 3
		IL_0174: nop
		IL_0175: ldind.i2
		IL_0176: conv.i2
		IL_0177: conv.i
		IL_0178: stloc.2
		IL_0179: br IL_001e

		IL_017e: br.s IL_0180

		IL_0180: ldloc.1
		IL_0181: ret
	} // end of method Arrays::GetHashCode

	.method public hidebysig static 
		int32 GetHashCode (
			uint32[] data
		) cil managed 
	{
		// Method begins at RVA 0x39d0
		// Header size: 12
		// Code size: 386 (0x182)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4 1683685381
		IL_0005: stloc 3
		IL_0009: ldloca 3
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: conv.i
		IL_0011: stloc.2
		IL_0012: br.s IL_001e
		// loop start (head: IL_001e)
			IL_0014: ldc.i4.0
			IL_0015: switch (IL_003c)

			IL_001e: ldloc.2
			IL_001f: switch (IL_011e, IL_0057, IL_0140, IL_015c, IL_017e, IL_0014)
		// end loop

		IL_003c: ldarg.0
		IL_003d: brtrue IL_0120

		IL_0042: ldc.i4 651821057
		IL_0047: stloc 3
		IL_004b: nop
		IL_004c: ldloca 3
		IL_0050: nop
		IL_0051: ldind.i2
		IL_0052: conv.i2
		IL_0053: conv.i
		IL_0054: stloc.2
		IL_0055: br.s IL_001e

		IL_0057: br IL_0142

		IL_005c: ldc.i4 1214785564
		IL_0061: stloc 3
		IL_0065: ldloca 3
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: ldc.i4 1906911260
		IL_0071: stloc 3
		IL_0075: ldloca 3
		IL_0079: nop
		IL_007a: ldind.i2
		IL_007b: conv.i2
		IL_007c: ceq
		IL_007e: switch (IL_015c, IL_0090, IL_015c)

		IL_008f: nop

		IL_0090: ldc.i4 921436161
		IL_0095: stloc 3
		IL_0099: nop
		IL_009a: ldloca 3
		IL_009e: ldind.i2
		IL_009f: conv.i2
		IL_00a0: br.s IL_00b4

		IL_00a2: ldc.i4 2064121856
		IL_00a7: stloc 3
		IL_00ab: ldloca 3
		IL_00af: nop
		IL_00b0: ldind.i2
		IL_00b1: conv.i2
		IL_00b2: br.s IL_00b4

		IL_00b4: brfalse.s IL_00b6

		IL_00b6: br.s IL_00cd

		IL_00b8: ldc.i4 1948385280
		IL_00bd: nop
		IL_00be: stloc 3
		IL_00c2: nop
		IL_00c3: ldloca 3
		IL_00c7: nop
		IL_00c8: ldind.i2
		IL_00c9: conv.i2

		IL_00ca: pop
		IL_00cb: br.s IL_00e1

		IL_00cd: ldc.i4 1821048832
		IL_00d2: nop
		IL_00d3: stloc 3
		IL_00d7: nop
		IL_00d8: ldloca 3
		IL_00dc: nop
		IL_00dd: ldind.i2
		IL_00de: conv.i2
		IL_00df: br.s IL_00ca

		IL_00e1: nop
		IL_00e2: ldc.i4 64946176
		IL_00e7: nop
		IL_00e8: stloc 3
		IL_00ec: nop
		IL_00ed: ldloca 3
		IL_00f1: nop
		IL_00f2: ldind.i2
		IL_00f3: conv.i2
		IL_00f4: brfalse IL_00f9

		IL_00f9: ldloc.1
		IL_00fa: ldc.i4 257
		IL_00ff: mul
		IL_0100: stloc.1
		IL_0101: ldloc.1
		IL_0102: ldarg.0
		IL_0103: ldloc.0
		IL_0104: ldelem.u4
		IL_0105: xor
		IL_0106: stloc.1
		IL_0107: ldc.i4 838205440
		IL_010c: nop
		IL_010d: stloc 3
		IL_0111: ldloca 3
		IL_0115: ldind.i2
		IL_0116: conv.i2
		IL_0117: conv.i
		IL_0118: stloc.2
		IL_0119: br IL_001e

		IL_011e: br.s IL_0144

		IL_0120: ldarg.0
		IL_0121: ldlen
		IL_0122: conv.i4
		IL_0123: stloc.0
		IL_0124: ldloc.0
		IL_0125: ldc.i4.1
		IL_0126: add
		IL_0127: stloc.1
		IL_0128: ldc.i4 426573826
		IL_012d: nop
		IL_012e: stloc 3
		IL_0132: nop
		IL_0133: ldloca 3
		IL_0137: ldind.i2
		IL_0138: conv.i2
		IL_0139: conv.i
		IL_013a: stloc.2
		IL_013b: br IL_001e

		IL_0140: br.s IL_0144

		IL_0142: ldc.i4.0
		IL_0143: ret

		IL_0144: ldc.i4 483328003
		IL_0149: nop
		IL_014a: stloc 3
		IL_014e: ldloca 3
		IL_0152: nop
		IL_0153: ldind.i2
		IL_0154: conv.i2
		IL_0155: conv.i
		IL_0156: stloc.2
		IL_0157: br IL_001e

		IL_015c: ldloc.0
		IL_015d: ldc.i4.1
		IL_015e: sub
		IL_015f: dup
		IL_0160: stloc.0
		IL_0161: ldc.i4.0
		IL_0162: bge IL_005c

		IL_0167: ldc.i4 1821376516
		IL_016c: stloc 3
		IL_0170: nop
		IL_0171: ldloca 3
		IL_0175: ldind.i2
		IL_0176: conv.i2
		IL_0177: conv.i
		IL_0178: stloc.2
		IL_0179: br IL_001e

		IL_017e: br.s IL_0180

		IL_0180: ldloc.1
		IL_0181: ret
	} // end of method Arrays::GetHashCode

	.method public hidebysig static 
		int32 GetHashCode (
			uint32[] data,
			int32 off,
			int32 len
		) cil managed 
	{
		// Method begins at RVA 0x3b60
		// Header size: 12
		// Code size: 386 (0x182)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4 423297029
		IL_0005: stloc 3
		IL_0009: ldloca 3
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: conv.i
		IL_0011: stloc.2
		IL_0012: br.s IL_001e
		// loop start (head: IL_001e)
			IL_0014: ldc.i4.0
			IL_0015: switch (IL_003c)

			IL_001e: ldloc.2
			IL_001f: switch (IL_00f9, IL_0057, IL_0118, IL_0133, IL_0156, IL_0014)
		// end loop

		IL_003c: ldarg.0
		IL_003d: brtrue IL_00fb

		IL_0042: ldc.i4 1507459073
		IL_0047: nop
		IL_0048: stloc 3
		IL_004c: nop
		IL_004d: ldloca 3
		IL_0051: ldind.i2
		IL_0052: conv.i2
		IL_0053: conv.i
		IL_0054: stloc.2
		IL_0055: br.s IL_001e

		IL_0057: br IL_011a

		IL_005c: ldc.i4 47056058
		IL_0061: nop
		IL_0062: stloc 3
		IL_0066: nop
		IL_0067: ldloca 3
		IL_006b: nop
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: ldc.i4 1224475834
		IL_0073: nop
		IL_0074: stloc 3
		IL_0078: ldloca 3
		IL_007c: nop
		IL_007d: ldind.i2
		IL_007e: conv.i2
		IL_007f: ceq
		IL_0081: switch (IL_0133, IL_0093, IL_0133)

		IL_0092: nop

		IL_0093: ldc.i4 204800000
		IL_0098: nop
		IL_0099: stloc 3
		IL_009d: ldloca 3
		IL_00a1: ldind.i2
		IL_00a2: conv.i2
		IL_00a3: brfalse IL_00a8

		IL_00a8: br.s IL_00bd

		IL_00aa: ldc.i4 915079168
		IL_00af: stloc 3
		IL_00b3: ldloca 3
		IL_00b7: nop
		IL_00b8: ldind.i2
		IL_00b9: conv.i2

		IL_00ba: pop
		IL_00bb: br.s IL_00d0

		IL_00bd: ldc.i4 1328939008
		IL_00c2: nop
		IL_00c3: stloc 3
		IL_00c7: nop
		IL_00c8: ldloca 3
		IL_00cc: ldind.i2
		IL_00cd: conv.i2
		IL_00ce: br.s IL_00ba

		IL_00d0: nop
		IL_00d1: ldloc.1
		IL_00d2: ldc.i4 257
		IL_00d7: mul
		IL_00d8: stloc.1
		IL_00d9: ldloc.1
		IL_00da: ldarg.0
		IL_00db: ldarg.1
		IL_00dc: ldloc.0
		IL_00dd: add
		IL_00de: ldelem.u4
		IL_00df: xor
		IL_00e0: stloc.1
		IL_00e1: ldc.i4 2126118912
		IL_00e6: nop
		IL_00e7: stloc 3
		IL_00eb: ldloca 3
		IL_00ef: nop
		IL_00f0: ldind.i2
		IL_00f1: conv.i2
		IL_00f2: conv.i
		IL_00f3: stloc.2
		IL_00f4: br IL_001e

		IL_00f9: br.s IL_011c

		IL_00fb: ldarg.2
		IL_00fc: stloc.0
		IL_00fd: ldloc.0
		IL_00fe: ldc.i4.1
		IL_00ff: add
		IL_0100: stloc.1
		IL_0101: ldc.i4 2034958338
		IL_0106: nop
		IL_0107: stloc 3
		IL_010b: ldloca 3
		IL_010f: ldind.i2
		IL_0110: conv.i2
		IL_0111: conv.i
		IL_0112: stloc.2
		IL_0113: br IL_001e

		IL_0118: br.s IL_011c

		IL_011a: ldc.i4.0
		IL_011b: ret

		IL_011c: ldc.i4 906756099
		IL_0121: stloc 3
		IL_0125: ldloca 3
		IL_0129: nop
		IL_012a: ldind.i2
		IL_012b: conv.i2
		IL_012c: conv.i
		IL_012d: stloc.2
		IL_012e: br IL_001e

		IL_0133: ldloc.0
		IL_0134: ldc.i4.1
		IL_0135: sub
		IL_0136: dup
		IL_0137: stloc.0
		IL_0138: ldc.i4.0
		IL_0139: bge IL_005c

		IL_013e: ldc.i4 90701828
		IL_0143: nop
		IL_0144: stloc 3
		IL_0148: ldloca 3
		IL_014c: nop
		IL_014d: ldind.i2
		IL_014e: conv.i2
		IL_014f: conv.i
		IL_0150: stloc.2
		IL_0151: br IL_001e

		IL_0156: br.s IL_0158

		IL_0158: ldc.i4 608829441
		IL_015d: nop
		IL_015e: stloc 3
		IL_0162: nop
		IL_0163: ldloca 3
		IL_0167: nop
		IL_0168: ldind.i2
		IL_0169: conv.i2
		IL_016a: br.s IL_017e

		IL_016c: ldc.i4 1260978176
		IL_0171: nop
		IL_0172: stloc 3
		IL_0176: ldloca 3
		IL_017a: ldind.i2
		IL_017b: conv.i2
		IL_017c: br.s IL_017e

		IL_017e: brfalse.s IL_0180

		IL_0180: ldloc.1
		IL_0181: ret
	} // end of method Arrays::GetHashCode

	.method public hidebysig static 
		int32 GetHashCode (
			uint64[] data
		) cil managed 
	{
		// Method begins at RVA 0x3cf0
		// Header size: 12
		// Code size: 404 (0x194)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] uint64,
			[3] int32,
			[4] int16
		)

		IL_0000: ldc.i4 1263992837
		IL_0005: stloc 4
		IL_0009: nop
		IL_000a: ldloca 4
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: conv.i
		IL_0012: stloc.3
		IL_0013: br.s IL_001f
		// loop start (head: IL_001f)
			IL_0015: ldc.i4.0
			IL_0016: switch (IL_003d)

			IL_001f: ldloc.3
			IL_0020: switch (IL_0131, IL_007f, IL_0153, IL_016e, IL_0190, IL_0015)
		// end loop

		IL_003d: ldc.i4 428605441
		IL_0042: nop
		IL_0043: stloc 4
		IL_0047: nop
		IL_0048: ldloca 4
		IL_004c: ldind.i2
		IL_004d: conv.i2
		IL_004e: br.s IL_0063

		IL_0050: ldc.i4 1806499840
		IL_0055: nop
		IL_0056: stloc 4
		IL_005a: ldloca 4
		IL_005e: nop
		IL_005f: ldind.i2
		IL_0060: conv.i2
		IL_0061: br.s IL_0063

		IL_0063: brfalse.s IL_0065

		IL_0065: ldarg.0
		IL_0066: brtrue IL_0133

		IL_006b: ldc.i4 1305804801
		IL_0070: stloc 4
		IL_0074: nop
		IL_0075: ldloca 4
		IL_0079: ldind.i2
		IL_007a: conv.i2
		IL_007b: conv.i
		IL_007c: stloc.3
		IL_007d: br.s IL_001f

		IL_007f: br IL_0155

		IL_0084: ldc.i4 1767461586
		IL_0089: nop
		IL_008a: stloc 4
		IL_008e: nop
		IL_008f: ldloca 4
		IL_0093: nop
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: ldc.i4 1110201042
		IL_009b: stloc 4
		IL_009f: ldloca 4
		IL_00a3: nop
		IL_00a4: ldind.i2
		IL_00a5: conv.i2
		IL_00a6: ceq
		IL_00a8: switch (IL_016e, IL_00ba, IL_016e)

		IL_00b9: nop

		IL_00ba: br.s IL_00cf

		IL_00bc: ldc.i4 2134114304
		IL_00c1: stloc 4
		IL_00c5: nop
		IL_00c6: ldloca 4
		IL_00ca: ldind.i2
		IL_00cb: conv.i2

		IL_00cc: pop
		IL_00cd: br.s IL_00e1

		IL_00cf: ldc.i4 694091776
		IL_00d4: stloc 4
		IL_00d8: ldloca 4
		IL_00dc: nop
		IL_00dd: ldind.i2
		IL_00de: conv.i2
		IL_00df: br.s IL_00cc

		IL_00e1: nop
		IL_00e2: ldc.i4 1526792192
		IL_00e7: nop
		IL_00e8: stloc 4
		IL_00ec: ldloca 4
		IL_00f0: nop
		IL_00f1: ldind.i2
		IL_00f2: conv.i2
		IL_00f3: brfalse IL_00f8

		IL_00f8: ldarg.0
		IL_00f9: ldloc.0
		IL_00fa: ldelem.i8
		IL_00fb: stloc.2
		IL_00fc: ldloc.1
		IL_00fd: ldc.i4 257
		IL_0102: mul
		IL_0103: stloc.1
		IL_0104: ldloc.1
		IL_0105: ldloc.2
		IL_0106: conv.i4
		IL_0107: xor
		IL_0108: stloc.1
		IL_0109: ldloc.1
		IL_010a: ldc.i4 257
		IL_010f: mul
		IL_0110: stloc.1
		IL_0111: ldloc.1
		IL_0112: ldloc.2
		IL_0113: ldc.i4.s 32
		IL_0115: shr.un
		IL_0116: conv.i4
		IL_0117: xor
		IL_0118: stloc.1
		IL_0119: ldc.i4 1628176384
		IL_011e: stloc 4
		IL_0122: nop
		IL_0123: ldloca 4
		IL_0127: nop
		IL_0128: ldind.i2
		IL_0129: conv.i2
		IL_012a: conv.i
		IL_012b: stloc.3
		IL_012c: br IL_001f

		IL_0131: br.s IL_0157

		IL_0133: ldarg.0
		IL_0134: ldlen
		IL_0135: conv.i4
		IL_0136: stloc.0
		IL_0137: ldloc.0
		IL_0138: ldc.i4.1
		IL_0139: add
		IL_013a: stloc.1
		IL_013b: ldc.i4 1304887298
		IL_0140: nop
		IL_0141: stloc 4
		IL_0145: nop
		IL_0146: ldloca 4
		IL_014a: ldind.i2
		IL_014b: conv.i2
		IL_014c: conv.i
		IL_014d: stloc.3
		IL_014e: br IL_001f

		IL_0153: br.s IL_0157

		IL_0155: ldc.i4.0
		IL_0156: ret

		IL_0157: ldc.i4 1080164355
		IL_015c: stloc 4
		IL_0160: ldloca 4
		IL_0164: nop
		IL_0165: ldind.i2
		IL_0166: conv.i2
		IL_0167: conv.i
		IL_0168: stloc.3
		IL_0169: br IL_001f

		IL_016e: ldloc.0
		IL_016f: ldc.i4.1
		IL_0170: sub
		IL_0171: dup
		IL_0172: stloc.0
		IL_0173: ldc.i4.0
		IL_0174: bge IL_0084

		IL_0179: ldc.i4 2073690116
		IL_017e: nop
		IL_017f: stloc 4
		IL_0183: ldloca 4
		IL_0187: ldind.i2
		IL_0188: conv.i2
		IL_0189: conv.i
		IL_018a: stloc.3
		IL_018b: br IL_001f

		IL_0190: br.s IL_0192

		IL_0192: ldloc.1
		IL_0193: ret
	} // end of method Arrays::GetHashCode

	.method public hidebysig static 
		int32 GetHashCode (
			uint64[] data,
			int32 off,
			int32 len
		) cil managed 
	{
		// Method begins at RVA 0x3e90
		// Header size: 12
		// Code size: 402 (0x192)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] uint64,
			[3] int32,
			[4] int16
		)

		IL_0000: ldc.i4 1944453125
		IL_0005: stloc 4
		IL_0009: ldloca 4
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: conv.i
		IL_0011: stloc.3
		IL_0012: br.s IL_001e
		// loop start (head: IL_001e)
			IL_0014: ldc.i4.0
			IL_0015: switch (IL_003c)

			IL_001e: ldloc.3
			IL_001f: switch (IL_010a, IL_0058, IL_0150, IL_016c, IL_018e, IL_0014)
		// end loop

		IL_003c: ldarg.0
		IL_003d: brtrue IL_010c

		IL_0042: ldc.i4 915996673
		IL_0047: nop
		IL_0048: stloc 4
		IL_004c: nop
		IL_004d: ldloca 4
		IL_0051: nop
		IL_0052: ldind.i2
		IL_0053: conv.i2
		IL_0054: conv.i
		IL_0055: stloc.3
		IL_0056: br.s IL_001e

		IL_0058: br IL_0152

		IL_005d: ldc.i4 102335797
		IL_0062: stloc 4
		IL_0066: nop
		IL_0067: ldloca 4
		IL_006b: nop
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: ldc.i4 1911391541
		IL_0073: nop
		IL_0074: stloc 4
		IL_0078: ldloca 4
		IL_007c: ldind.i2
		IL_007d: conv.i2
		IL_007e: ceq
		IL_0080: switch (IL_016c, IL_0092, IL_016c)

		IL_0091: nop

		IL_0092: ldc.i4 2139226112
		IL_0097: stloc 4
		IL_009b: nop
		IL_009c: ldloca 4
		IL_00a0: ldind.i2
		IL_00a1: conv.i2
		IL_00a2: brfalse IL_00a7

		IL_00a7: br.s IL_00bc

		IL_00a9: ldc.i4 923074560
		IL_00ae: stloc 4
		IL_00b2: ldloca 4
		IL_00b6: nop
		IL_00b7: ldind.i2
		IL_00b8: conv.i2

		IL_00b9: pop
		IL_00ba: br.s IL_00ce

		IL_00bc: ldc.i4 712048640
		IL_00c1: stloc 4
		IL_00c5: ldloca 4
		IL_00c9: nop
		IL_00ca: ldind.i2
		IL_00cb: conv.i2
		IL_00cc: br.s IL_00b9

		IL_00ce: nop
		IL_00cf: ldarg.0
		IL_00d0: ldarg.1
		IL_00d1: ldloc.0
		IL_00d2: add
		IL_00d3: ldelem.i8
		IL_00d4: stloc.2
		IL_00d5: ldloc.1
		IL_00d6: ldc.i4 257
		IL_00db: mul
		IL_00dc: stloc.1
		IL_00dd: ldloc.1
		IL_00de: ldloc.2
		IL_00df: conv.i4
		IL_00e0: xor
		IL_00e1: stloc.1
		IL_00e2: ldloc.1
		IL_00e3: ldc.i4 257
		IL_00e8: mul
		IL_00e9: stloc.1
		IL_00ea: ldloc.1
		IL_00eb: ldloc.2
		IL_00ec: ldc.i4.s 32
		IL_00ee: shr.un
		IL_00ef: conv.i4
		IL_00f0: xor
		IL_00f1: stloc.1
		IL_00f2: ldc.i4 1400307712
		IL_00f7: nop
		IL_00f8: stloc 4
		IL_00fc: nop
		IL_00fd: ldloca 4
		IL_0101: ldind.i2
		IL_0102: conv.i2
		IL_0103: conv.i
		IL_0104: stloc.3
		IL_0105: br IL_001e

		IL_010a: br.s IL_0154

		IL_010c: ldc.i4 225771521
		IL_0111: nop
		IL_0112: stloc 4
		IL_0116: ldloca 4
		IL_011a: ldind.i2
		IL_011b: conv.i2
		IL_011c: br.s IL_0131

		IL_011e: ldc.i4 1601961984
		IL_0123: nop
		IL_0124: stloc 4
		IL_0128: ldloca 4
		IL_012c: nop
		IL_012d: ldind.i2
		IL_012e: conv.i2
		IL_012f: br.s IL_0131

		IL_0131: brfalse.s IL_0133

		IL_0133: ldarg.2
		IL_0134: stloc.0
		IL_0135: ldloc.0
		IL_0136: ldc.i4.1
		IL_0137: add
		IL_0138: stloc.1
		IL_0139: ldc.i4 272433154
		IL_013e: stloc 4
		IL_0142: nop
		IL_0143: ldloca 4
		IL_0147: ldind.i2
		IL_0148: conv.i2
		IL_0149: conv.i
		IL_014a: stloc.3
		IL_014b: br IL_001e

		IL_0150: br.s IL_0154

		IL_0152: ldc.i4.0
		IL_0153: ret

		IL_0154: ldc.i4 980221955
		IL_0159: stloc 4
		IL_015d: nop
		IL_015e: ldloca 4
		IL_0162: nop
		IL_0163: ldind.i2
		IL_0164: conv.i2
		IL_0165: conv.i
		IL_0166: stloc.3
		IL_0167: br IL_001e

		IL_016c: ldloc.0
		IL_016d: ldc.i4.1
		IL_016e: sub
		IL_016f: dup
		IL_0170: stloc.0
		IL_0171: ldc.i4.0
		IL_0172: bge IL_005d

		IL_0177: ldc.i4 2062483460
		IL_017c: stloc 4
		IL_0180: nop
		IL_0181: ldloca 4
		IL_0185: ldind.i2
		IL_0186: conv.i2
		IL_0187: conv.i
		IL_0188: stloc.3
		IL_0189: br IL_001e

		IL_018e: br.s IL_0190

		IL_0190: ldloc.1
		IL_0191: ret
	} // end of method Arrays::GetHashCode

	.method public hidebysig static 
		uint8[] Clone (
			uint8[] data
		) cil managed 
	{
		// Method begins at RVA 0x4030
		// Header size: 12
		// Code size: 175 (0xaf)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldarg.0
		IL_0001: brfalse IL_00ad

		IL_0006: ldc.i4 2056724471
		IL_000b: stloc 0
		IL_000f: ldloca 0
		IL_0013: nop
		IL_0014: ldind.i2
		IL_0015: conv.i2
		IL_0016: ldc.i4 126951415
		IL_001b: stloc 0
		IL_001f: ldloca 0
		IL_0023: nop
		IL_0024: ldind.i2
		IL_0025: conv.i2
		IL_0026: ceq
		IL_0028: switch (IL_007b, IL_003a, IL_007b)

		IL_0039: nop

		IL_003a: br.s IL_004f

		IL_003c: ldc.i4 178323456
		IL_0041: stloc 0
		IL_0045: nop
		IL_0046: ldloca 0
		IL_004a: ldind.i2
		IL_004b: conv.i2

		IL_004c: pop
		IL_004d: br.s IL_0062

		IL_004f: ldc.i4 1972502528
		IL_0054: nop
		IL_0055: stloc 0
		IL_0059: ldloca 0
		IL_005d: nop
		IL_005e: ldind.i2
		IL_005f: conv.i2
		IL_0060: br.s IL_004c

		IL_0062: nop
		IL_0063: ldc.i4 893779968
		IL_0068: stloc 0
		IL_006c: nop
		IL_006d: ldloca 0
		IL_0071: nop
		IL_0072: ldind.i2
		IL_0073: conv.i2
		IL_0074: brfalse IL_0079

		IL_0079: br.s IL_007b

		IL_007b: ldc.i4 1833172993
		IL_0080: stloc 0
		IL_0084: ldloca 0
		IL_0088: nop
		IL_0089: ldind.i2
		IL_008a: conv.i2
		IL_008b: br.s IL_009f

		IL_008d: ldc.i4 93126656
		IL_0092: stloc 0
		IL_0096: nop
		IL_0097: ldloca 0
		IL_009b: ldind.i2
		IL_009c: conv.i2
		IL_009d: br.s IL_009f

		IL_009f: brfalse.s IL_00a1

		IL_00a1: ldarg.0
		IL_00a2: callvirt instance object [mscorlib]System.Array::Clone()
		IL_00a7: castclass uint8[]
		IL_00ac: ret

		IL_00ad: ldnull
		IL_00ae: ret
	} // end of method Arrays::Clone

	.method public hidebysig static 
		uint8[] Clone (
			uint8[] data,
			uint8[] existing
		) cil managed 
	{
		// Method begins at RVA 0x40ec
		// Header size: 12
		// Code size: 381 (0x17d)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] int16
		)

		IL_0000: ldc.i4 53936133
		IL_0005: stloc 1
		IL_0009: nop
		IL_000a: ldloca 1
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: conv.i
		IL_0012: stloc.0
		IL_0013: br.s IL_0046
		// loop start (head: IL_0046)
			IL_0015: ldc.i4 1395720193
			IL_001a: stloc 1
			IL_001e: ldloca 1
			IL_0022: nop
			IL_0023: ldind.i2
			IL_0024: conv.i2
			IL_0025: br.s IL_003a

			IL_0027: ldc.i4 751501312
			IL_002c: stloc 1
			IL_0030: nop
			IL_0031: ldloca 1
			IL_0035: nop
			IL_0036: ldind.i2
			IL_0037: conv.i2
			IL_0038: br.s IL_003a

			IL_003a: brfalse.s IL_003c

			IL_003c: ldc.i4.0
			IL_003d: switch (IL_0064)

			IL_0046: ldloc.0
			IL_0047: switch (IL_0095, IL_007b, IL_00b4, IL_00d2, IL_0138, IL_0015)
		// end loop

		IL_0064: ldarg.0
		IL_0065: brtrue.s IL_00b9

		IL_0067: ldc.i4 520028161
		IL_006c: stloc 1
		IL_0070: ldloca 1
		IL_0074: nop
		IL_0075: ldind.i2
		IL_0076: conv.i2
		IL_0077: conv.i
		IL_0078: stloc.0
		IL_0079: br.s IL_0046

		IL_007b: br IL_0166

		IL_0080: ldc.i4 1703608320
		IL_0085: nop
		IL_0086: stloc 1
		IL_008a: ldloca 1
		IL_008e: nop
		IL_008f: ldind.i2
		IL_0090: conv.i2
		IL_0091: conv.i
		IL_0092: stloc.0
		IL_0093: br.s IL_0046

		IL_0095: ldarg.1
		IL_0096: ldlen
		IL_0097: conv.i4
		IL_0098: ldarg.0
		IL_0099: ldlen
		IL_009a: conv.i4
		IL_009b: beq IL_016f

		IL_00a0: ldc.i4 629407746
		IL_00a5: stloc 1
		IL_00a9: ldloca 1
		IL_00ad: nop
		IL_00ae: ldind.i2
		IL_00af: conv.i2
		IL_00b0: conv.i
		IL_00b1: stloc.0
		IL_00b2: br.s IL_0046

		IL_00b4: br IL_0168

		IL_00b9: ldc.i4 736231427
		IL_00be: nop
		IL_00bf: stloc 1
		IL_00c3: nop
		IL_00c4: ldloca 1
		IL_00c8: nop
		IL_00c9: ldind.i2
		IL_00ca: conv.i2
		IL_00cb: conv.i
		IL_00cc: stloc.0
		IL_00cd: br IL_0046

		IL_00d2: ldc.i4 1225709155
		IL_00d7: stloc 1
		IL_00db: nop
		IL_00dc: ldloca 1
		IL_00e0: nop
		IL_00e1: ldind.i2
		IL_00e2: conv.i2
		IL_00e3: ldc.i4 1532352099
		IL_00e8: stloc 1
		IL_00ec: nop
		IL_00ed: ldloca 1
		IL_00f1: ldind.i2
		IL_00f2: conv.i2
		IL_00f3: ceq
		IL_00f5: switch (IL_0095, IL_0107, IL_0095)

		IL_0106: nop

		IL_0107: ldc.i4 1795817472
		IL_010c: stloc 1
		IL_0110: ldloca 1
		IL_0114: nop
		IL_0115: ldind.i2
		IL_0116: conv.i2
		IL_0117: brfalse IL_011c

		IL_011c: ldarg.1
		IL_011d: brfalse.s IL_0168

		IL_011f: ldc.i4 1879048196
		IL_0124: nop
		IL_0125: stloc 1
		IL_0129: nop
		IL_012a: ldloca 1
		IL_012e: nop
		IL_012f: ldind.i2
		IL_0130: conv.i2
		IL_0131: conv.i
		IL_0132: stloc.0
		IL_0133: br IL_0046

		IL_0138: br.s IL_014e

		IL_013a: ldc.i4 817364992
		IL_013f: nop
		IL_0140: stloc 1
		IL_0144: nop
		IL_0145: ldloca 1
		IL_0149: ldind.i2
		IL_014a: conv.i2

		IL_014b: pop
		IL_014c: br.s IL_0160

		IL_014e: ldc.i4 993001472
		IL_0153: nop
		IL_0154: stloc 1
		IL_0158: ldloca 1
		IL_015c: ldind.i2
		IL_015d: conv.i2
		IL_015e: br.s IL_014b

		IL_0160: nop
		IL_0161: br IL_0080

		IL_0166: ldnull
		IL_0167: ret

		IL_0168: ldarg.0
		IL_0169: call uint8[] ODCrypt.Arrays::Clone(uint8[])
		IL_016e: ret

		IL_016f: ldarg.0
		IL_0170: ldc.i4.0
		IL_0171: ldarg.1
		IL_0172: ldc.i4.0
		IL_0173: ldarg.1
		IL_0174: ldlen
		IL_0175: conv.i4
		IL_0176: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_017b: ldarg.1
		IL_017c: ret
	} // end of method Arrays::Clone

	.method public hidebysig static 
		int32[] Clone (
			int32[] data
		) cil managed 
	{
		// Method begins at RVA 0x4278
		// Header size: 12
		// Code size: 178 (0xb2)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldarg.0
		IL_0001: brfalse IL_00b0

		IL_0006: ldc.i4 131631154
		IL_000b: stloc 0
		IL_000f: nop
		IL_0010: ldloca 0
		IL_0014: nop
		IL_0015: ldind.i2
		IL_0016: conv.i2
		IL_0017: ldc.i4 1409779762
		IL_001c: nop
		IL_001d: stloc 0
		IL_0021: ldloca 0
		IL_0025: ldind.i2
		IL_0026: conv.i2
		IL_0027: ceq
		IL_0029: switch (IL_00a4, IL_003b, IL_00a4)

		IL_003a: nop

		IL_003b: br.s IL_0051

		IL_003d: ldc.i4 644022272
		IL_0042: stloc 0
		IL_0046: nop
		IL_0047: ldloca 0
		IL_004b: nop
		IL_004c: ldind.i2
		IL_004d: conv.i2

		IL_004e: pop
		IL_004f: br.s IL_0063

		IL_0051: ldc.i4 949026816
		IL_0056: stloc 0
		IL_005a: ldloca 0
		IL_005e: nop
		IL_005f: ldind.i2
		IL_0060: conv.i2
		IL_0061: br.s IL_004e

		IL_0063: nop
		IL_0064: ldc.i4 1006174208
		IL_0069: stloc 0
		IL_006d: ldloca 0
		IL_0071: nop
		IL_0072: ldind.i2
		IL_0073: conv.i2
		IL_0074: brfalse IL_0079

		IL_0079: ldc.i4 1443102721
		IL_007e: nop
		IL_007f: stloc 0
		IL_0083: ldloca 0
		IL_0087: nop
		IL_0088: ldind.i2
		IL_0089: conv.i2
		IL_008a: br.s IL_00a0

		IL_008c: ldc.i4 1115160576
		IL_0091: nop
		IL_0092: stloc 0
		IL_0096: nop
		IL_0097: ldloca 0
		IL_009b: nop
		IL_009c: ldind.i2
		IL_009d: conv.i2
		IL_009e: br.s IL_00a0

		IL_00a0: brfalse.s IL_00a2

		IL_00a2: br.s IL_00a4

		IL_00a4: ldarg.0
		IL_00a5: callvirt instance object [mscorlib]System.Array::Clone()
		IL_00aa: castclass int32[]
		IL_00af: ret

		IL_00b0: ldnull
		IL_00b1: ret
	} // end of method Arrays::Clone

	.method assembly hidebysig static 
		uint32[] w (
			uint32[] A_0
		) cil managed 
	{
		// Method begins at RVA 0x4338
		// Header size: 12
		// Code size: 176 (0xb0)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldarg.0
		IL_0001: brfalse IL_0088

		IL_0006: ldc.i4 477432192
		IL_000b: nop
		IL_000c: stloc 0
		IL_0010: ldloca 0
		IL_0014: nop
		IL_0015: ldind.i2
		IL_0016: conv.i2
		IL_0017: ldc.i4 1839925632
		IL_001c: stloc 0
		IL_0020: ldloca 0
		IL_0024: nop
		IL_0025: ldind.i2
		IL_0026: conv.i2
		IL_0027: ceq
		IL_0029: switch (IL_007c, IL_003b, IL_007c)

		IL_003a: nop

		IL_003b: br.s IL_0050

		IL_003d: ldc.i4 698220544
		IL_0042: stloc 0
		IL_0046: nop
		IL_0047: ldloca 0
		IL_004b: ldind.i2
		IL_004c: conv.i2

		IL_004d: pop
		IL_004e: br.s IL_0063

		IL_0050: ldc.i4 2039873536
		IL_0055: nop
		IL_0056: stloc 0
		IL_005a: ldloca 0
		IL_005e: nop
		IL_005f: ldind.i2
		IL_0060: conv.i2
		IL_0061: br.s IL_004d

		IL_0063: nop
		IL_0064: ldc.i4 1334640640
		IL_0069: nop
		IL_006a: stloc 0
		IL_006e: ldloca 0
		IL_0072: nop
		IL_0073: ldind.i2
		IL_0074: conv.i2
		IL_0075: brfalse IL_007a

		IL_007a: br.s IL_007c

		IL_007c: ldarg.0
		IL_007d: callvirt instance object [mscorlib]System.Array::Clone()
		IL_0082: castclass uint32[]
		IL_0087: ret

		IL_0088: ldc.i4 180617217
		IL_008d: stloc 0
		IL_0091: ldloca 0
		IL_0095: nop
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: br.s IL_00ac

		IL_009a: ldc.i4 652935168
		IL_009f: nop
		IL_00a0: stloc 0
		IL_00a4: ldloca 0
		IL_00a8: ldind.i2
		IL_00a9: conv.i2
		IL_00aa: br.s IL_00ac

		IL_00ac: brfalse.s IL_00ae

		IL_00ae: ldnull
		IL_00af: ret
	} // end of method Arrays::w

	.method public hidebysig static 
		int64[] Clone (
			int64[] data
		) cil managed 
	{
		// Method begins at RVA 0x43f4
		// Header size: 12
		// Code size: 178 (0xb2)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldarg.0
		IL_0001: brfalse IL_00b0

		IL_0006: ldc.i4 1312646931
		IL_000b: stloc 0
		IL_000f: ldloca 0
		IL_0013: nop
		IL_0014: ldind.i2
		IL_0015: conv.i2
		IL_0016: ldc.i4 426927891
		IL_001b: stloc 0
		IL_001f: nop
		IL_0020: ldloca 0
		IL_0024: nop
		IL_0025: ldind.i2
		IL_0026: conv.i2
		IL_0027: ceq
		IL_0029: switch (IL_007c, IL_003b, IL_007c)

		IL_003a: nop

		IL_003b: br.s IL_0051

		IL_003d: ldc.i4 602669056
		IL_0042: nop
		IL_0043: stloc 0
		IL_0047: ldloca 0
		IL_004b: nop
		IL_004c: ldind.i2
		IL_004d: conv.i2

		IL_004e: pop
		IL_004f: br.s IL_0064

		IL_0051: ldc.i4 527761408
		IL_0056: nop
		IL_0057: stloc 0
		IL_005b: nop
		IL_005c: ldloca 0
		IL_0060: ldind.i2
		IL_0061: conv.i2
		IL_0062: br.s IL_004e

		IL_0064: nop
		IL_0065: ldc.i4 417595392
		IL_006a: stloc 0
		IL_006e: ldloca 0
		IL_0072: nop
		IL_0073: ldind.i2
		IL_0074: conv.i2
		IL_0075: brfalse IL_007a

		IL_007a: br.s IL_007c

		IL_007c: ldc.i4 1596456961
		IL_0081: nop
		IL_0082: stloc 0
		IL_0086: ldloca 0
		IL_008a: nop
		IL_008b: ldind.i2
		IL_008c: conv.i2
		IL_008d: br.s IL_00a2

		IL_008f: ldc.i4 1727332352
		IL_0094: nop
		IL_0095: stloc 0
		IL_0099: nop
		IL_009a: ldloca 0
		IL_009e: ldind.i2
		IL_009f: conv.i2
		IL_00a0: br.s IL_00a2

		IL_00a2: brfalse.s IL_00a4

		IL_00a4: ldarg.0
		IL_00a5: callvirt instance object [mscorlib]System.Array::Clone()
		IL_00aa: castclass int64[]
		IL_00af: ret

		IL_00b0: ldnull
		IL_00b1: ret
	} // end of method Arrays::Clone

	.method public hidebysig static 
		uint64[] Clone (
			uint64[] data
		) cil managed 
	{
		// Method begins at RVA 0x44b4
		// Header size: 12
		// Code size: 181 (0xb5)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldarg.0
		IL_0001: brfalse IL_00b3

		IL_0006: ldc.i4 507502103
		IL_000b: nop
		IL_000c: stloc 0
		IL_0010: nop
		IL_0011: ldloca 0
		IL_0015: ldind.i2
		IL_0016: conv.i2
		IL_0017: ldc.i4 720428567
		IL_001c: stloc 0
		IL_0020: nop
		IL_0021: ldloca 0
		IL_0025: ldind.i2
		IL_0026: conv.i2
		IL_0027: ceq
		IL_0029: switch (IL_00a7, IL_003b, IL_00a7)

		IL_003a: nop

		IL_003b: br.s IL_0052

		IL_003d: ldc.i4 1732771840
		IL_0042: nop
		IL_0043: stloc 0
		IL_0047: nop
		IL_0048: ldloca 0
		IL_004c: nop
		IL_004d: ldind.i2
		IL_004e: conv.i2

		IL_004f: pop
		IL_0050: br.s IL_0065

		IL_0052: ldc.i4 5832704
		IL_0057: nop
		IL_0058: stloc 0
		IL_005c: ldloca 0
		IL_0060: nop
		IL_0061: ldind.i2
		IL_0062: conv.i2
		IL_0063: br.s IL_004f

		IL_0065: nop
		IL_0066: ldc.i4 558301185
		IL_006b: stloc 0
		IL_006f: nop
		IL_0070: ldloca 0
		IL_0074: ldind.i2
		IL_0075: conv.i2
		IL_0076: br.s IL_008c

		IL_0078: ldc.i4 263454720
		IL_007d: nop
		IL_007e: stloc 0
		IL_0082: nop
		IL_0083: ldloca 0
		IL_0087: nop
		IL_0088: ldind.i2
		IL_0089: conv.i2
		IL_008a: br.s IL_008c

		IL_008c: brfalse.s IL_008e

		IL_008e: ldc.i4 1812332544
		IL_0093: nop
		IL_0094: stloc 0
		IL_0098: nop
		IL_0099: ldloca 0
		IL_009d: nop
		IL_009e: ldind.i2
		IL_009f: conv.i2
		IL_00a0: brfalse IL_00a5

		IL_00a5: br.s IL_00a7

		IL_00a7: ldarg.0
		IL_00a8: callvirt instance object [mscorlib]System.Array::Clone()
		IL_00ad: castclass uint64[]
		IL_00b2: ret

		IL_00b3: ldnull
		IL_00b4: ret
	} // end of method Arrays::Clone

	.method public hidebysig static 
		uint64[] Clone (
			uint64[] data,
			uint64[] existing
		) cil managed 
	{
		// Method begins at RVA 0x4578
		// Header size: 12
		// Code size: 380 (0x17c)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] int16
		)

		IL_0000: ldc.i4 2053963781
		IL_0005: stloc 1
		IL_0009: nop
		IL_000a: ldloca 1
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: conv.i
		IL_0012: stloc.0
		IL_0013: br.s IL_001f
		// loop start (head: IL_001f)
			IL_0015: ldc.i4.0
			IL_0016: switch (IL_003d)

			IL_001f: ldloc.0
			IL_0020: switch (IL_006d, IL_0054, IL_008c, IL_00a9, IL_0137, IL_0015)
		// end loop

		IL_003d: ldarg.0
		IL_003e: brtrue.s IL_0091

		IL_0040: ldc.i4 903806977
		IL_0045: nop
		IL_0046: stloc 1
		IL_004a: ldloca 1
		IL_004e: ldind.i2
		IL_004f: conv.i2
		IL_0050: conv.i
		IL_0051: stloc.0
		IL_0052: br.s IL_001f

		IL_0054: br IL_0165

		IL_0059: ldc.i4 1807613952
		IL_005e: stloc 1
		IL_0062: ldloca 1
		IL_0066: nop
		IL_0067: ldind.i2
		IL_0068: conv.i2
		IL_0069: conv.i
		IL_006a: stloc.0
		IL_006b: br.s IL_001f

		IL_006d: ldarg.1
		IL_006e: ldlen
		IL_006f: conv.i4
		IL_0070: ldarg.0
		IL_0071: ldlen
		IL_0072: conv.i4
		IL_0073: beq IL_016e

		IL_0078: ldc.i4 841220098
		IL_007d: stloc 1
		IL_0081: nop
		IL_0082: ldloca 1
		IL_0086: ldind.i2
		IL_0087: conv.i2
		IL_0088: conv.i
		IL_0089: stloc.0
		IL_008a: br.s IL_001f

		IL_008c: br IL_0167

		IL_0091: ldc.i4 1358233603
		IL_0096: nop
		IL_0097: stloc 1
		IL_009b: nop
		IL_009c: ldloca 1
		IL_00a0: ldind.i2
		IL_00a1: conv.i2
		IL_00a2: conv.i
		IL_00a3: stloc.0
		IL_00a4: br IL_001f

		IL_00a9: ldc.i4 503906655
		IL_00ae: stloc 1
		IL_00b2: ldloca 1
		IL_00b6: nop
		IL_00b7: ldind.i2
		IL_00b8: conv.i2
		IL_00b9: ldc.i4 129630559
		IL_00be: nop
		IL_00bf: stloc 1
		IL_00c3: ldloca 1
		IL_00c7: ldind.i2
		IL_00c8: conv.i2
		IL_00c9: ceq
		IL_00cb: switch (IL_006d, IL_00dd, IL_006d)

		IL_00dc: nop

		IL_00dd: ldc.i4 1946681344
		IL_00e2: stloc 1
		IL_00e6: nop
		IL_00e7: ldloca 1
		IL_00eb: nop
		IL_00ec: ldind.i2
		IL_00ed: conv.i2
		IL_00ee: brfalse IL_00f3

		IL_00f3: ldc.i4 1309081601
		IL_00f8: nop
		IL_00f9: stloc 1
		IL_00fd: nop
		IL_00fe: ldloca 1
		IL_0102: nop
		IL_0103: ldind.i2
		IL_0104: conv.i2
		IL_0105: br.s IL_0119

		IL_0107: ldc.i4 2002976768
		IL_010c: stloc 1
		IL_0110: nop
		IL_0111: ldloca 1
		IL_0115: ldind.i2
		IL_0116: conv.i2
		IL_0117: br.s IL_0119

		IL_0119: brfalse.s IL_011b

		IL_011b: ldarg.1
		IL_011c: brfalse.s IL_0167

		IL_011e: ldc.i4 350420996
		IL_0123: nop
		IL_0124: stloc 1
		IL_0128: nop
		IL_0129: ldloca 1
		IL_012d: nop
		IL_012e: ldind.i2
		IL_012f: conv.i2
		IL_0130: conv.i
		IL_0131: stloc.0
		IL_0132: br IL_001f

		IL_0137: br.s IL_014c

		IL_0139: ldc.i4 1559756800
		IL_013e: stloc 1
		IL_0142: ldloca 1
		IL_0146: nop
		IL_0147: ldind.i2
		IL_0148: conv.i2

		IL_0149: pop
		IL_014a: br.s IL_015f

		IL_014c: ldc.i4 540540928
		IL_0151: nop
		IL_0152: stloc 1
		IL_0156: nop
		IL_0157: ldloca 1
		IL_015b: ldind.i2
		IL_015c: conv.i2
		IL_015d: br.s IL_0149

		IL_015f: nop
		IL_0160: br IL_0059

		IL_0165: ldnull
		IL_0166: ret

		IL_0167: ldarg.0
		IL_0168: call uint64[] ODCrypt.Arrays::Clone(uint64[])
		IL_016d: ret

		IL_016e: ldarg.0
		IL_016f: ldc.i4.0
		IL_0170: ldarg.1
		IL_0171: ldc.i4.0
		IL_0172: ldarg.1
		IL_0173: ldlen
		IL_0174: conv.i4
		IL_0175: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_017a: ldarg.1
		IL_017b: ret
	} // end of method Arrays::Clone

	.method public hidebysig static 
		bool Contains (
			uint8[] a,
			uint8 n
		) cil managed 
	{
		// Method begins at RVA 0x4700
		// Header size: 12
		// Code size: 370 (0x172)
		.maxstack 2
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0028)

		IL_000a: ldloc.1
		IL_000b: switch (IL_00f1, IL_00d4, IL_0111, IL_012b, IL_016e, IL_003f)

		IL_0028: ldc.i4.0
		IL_0029: stloc.0
		IL_002a: ldc.i4 118620165
		IL_002f: stloc 2
		IL_0033: nop
		IL_0034: ldloca 2
		IL_0038: nop
		IL_0039: ldind.i2
		IL_003a: conv.i2
		IL_003b: conv.i
		IL_003c: stloc.1
		IL_003d: br.s IL_000a

		IL_003f: br IL_0113

		IL_0044: ldloc.0
		IL_0045: ldc.i4.1
		IL_0046: add
		IL_0047: stloc.0
		IL_0048: ldc.i4 1379534746
		IL_004d: nop
		IL_004e: stloc 2
		IL_0052: nop
		IL_0053: ldloca 2
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: ldc.i4 1984169882
		IL_005f: stloc 2
		IL_0063: nop
		IL_0064: ldloca 2
		IL_0068: ldind.i2
		IL_0069: conv.i2
		IL_006a: ceq
		IL_006c: switch (IL_012b, IL_007e, IL_012b)

		IL_007d: nop

		IL_007e: ldc.i4 88866816
		IL_0083: nop
		IL_0084: stloc 2
		IL_0088: ldloca 2
		IL_008c: ldind.i2
		IL_008d: conv.i2
		IL_008e: brfalse IL_0093

		IL_0093: br.s IL_00a8

		IL_0095: ldc.i4 1907884032
		IL_009a: stloc 2
		IL_009e: ldloca 2
		IL_00a2: nop
		IL_00a3: ldind.i2
		IL_00a4: conv.i2

		IL_00a5: pop
		IL_00a6: br.s IL_00bb

		IL_00a8: ldc.i4 2016804864
		IL_00ad: nop
		IL_00ae: stloc 2
		IL_00b2: nop
		IL_00b3: ldloca 2
		IL_00b7: ldind.i2
		IL_00b8: conv.i2
		IL_00b9: br.s IL_00a5

		IL_00bb: nop
		IL_00bc: ldc.i4 889192449
		IL_00c1: nop
		IL_00c2: stloc 2
		IL_00c6: nop
		IL_00c7: ldloca 2
		IL_00cb: ldind.i2
		IL_00cc: conv.i2
		IL_00cd: conv.i
		IL_00ce: stloc.1
		IL_00cf: br IL_000a

		IL_00d4: br.s IL_0113

		IL_00d6: ldc.i4.1
		IL_00d7: ret

		IL_00d8: ldc.i4 35520512
		IL_00dd: nop
		IL_00de: stloc 2
		IL_00e2: nop
		IL_00e3: ldloca 2
		IL_00e7: nop
		IL_00e8: ldind.i2
		IL_00e9: conv.i2
		IL_00ea: conv.i
		IL_00eb: stloc.1
		IL_00ec: br IL_000a

		IL_00f1: ldarg.0
		IL_00f2: ldloc.0
		IL_00f3: ldelem.u1
		IL_00f4: ldarg.1
		IL_00f5: bne.un IL_0044

		IL_00fa: ldc.i4 741015554
		IL_00ff: stloc 2
		IL_0103: ldloca 2
		IL_0107: nop
		IL_0108: ldind.i2
		IL_0109: conv.i2
		IL_010a: conv.i
		IL_010b: stloc.1
		IL_010c: br IL_000a

		IL_0111: br.s IL_00d6

		IL_0113: ldc.i4 1690238979
		IL_0118: nop
		IL_0119: stloc 2
		IL_011d: ldloca 2
		IL_0121: nop
		IL_0122: ldind.i2
		IL_0123: conv.i2
		IL_0124: conv.i
		IL_0125: stloc.1
		IL_0126: br IL_000a

		IL_012b: ldc.i4 235667457
		IL_0130: stloc 2
		IL_0134: ldloca 2
		IL_0138: nop
		IL_0139: ldind.i2
		IL_013a: conv.i2
		IL_013b: br.s IL_014f

		IL_013d: ldc.i4 1246625792
		IL_0142: stloc 2
		IL_0146: ldloca 2
		IL_014a: nop
		IL_014b: ldind.i2
		IL_014c: conv.i2
		IL_014d: br.s IL_014f

		IL_014f: brfalse.s IL_0151

		IL_0151: ldloc.0
		IL_0152: ldarg.0
		IL_0153: ldlen
		IL_0154: conv.i4
		IL_0155: blt.s IL_00d8

		IL_0157: ldc.i4 507379716
		IL_015c: stloc 2
		IL_0160: ldloca 2
		IL_0164: nop
		IL_0165: ldind.i2
		IL_0166: conv.i2
		IL_0167: conv.i
		IL_0168: stloc.1
		IL_0169: br IL_000a

		IL_016e: br.s IL_0170

		IL_0170: ldc.i4.0
		IL_0171: ret
	} // end of method Arrays::Contains

	.method public hidebysig static 
		bool Contains (
			int16[] a,
			int16 n
		) cil managed 
	{
		// Method begins at RVA 0x4880
		// Header size: 12
		// Code size: 370 (0x172)
		.maxstack 2
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0028)

		IL_000a: ldloc.1
		IL_000b: switch (IL_0117, IL_00fc, IL_0137, IL_0151, IL_016e, IL_003e)

		IL_0028: ldc.i4.0
		IL_0029: stloc.0
		IL_002a: ldc.i4 1822883845
		IL_002f: stloc 2
		IL_0033: ldloca 2
		IL_0037: nop
		IL_0038: ldind.i2
		IL_0039: conv.i2
		IL_003a: conv.i
		IL_003b: stloc.1
		IL_003c: br.s IL_000a

		IL_003e: ldc.i4 1149960193
		IL_0043: nop
		IL_0044: stloc 2
		IL_0048: nop
		IL_0049: ldloca 2
		IL_004d: nop
		IL_004e: ldind.i2
		IL_004f: conv.i2
		IL_0050: br.s IL_0064

		IL_0052: ldc.i4 316669952
		IL_0057: nop
		IL_0058: stloc 2
		IL_005c: ldloca 2
		IL_0060: ldind.i2
		IL_0061: conv.i2
		IL_0062: br.s IL_0064

		IL_0064: brfalse.s IL_0066

		IL_0066: br IL_0139

		IL_006b: ldloc.0
		IL_006c: ldc.i4.1
		IL_006d: add
		IL_006e: stloc.0
		IL_006f: ldc.i4 307367545
		IL_0074: stloc 2
		IL_0078: nop
		IL_0079: ldloca 2
		IL_007d: nop
		IL_007e: ldind.i2
		IL_007f: conv.i2
		IL_0080: ldc.i4 1122242169
		IL_0085: nop
		IL_0086: stloc 2
		IL_008a: nop
		IL_008b: ldloca 2
		IL_008f: ldind.i2
		IL_0090: conv.i2
		IL_0091: ceq
		IL_0093: switch (IL_0151, IL_00a5, IL_0151)

		IL_00a4: nop

		IL_00a5: br.s IL_00bb

		IL_00a7: ldc.i4 1322647552
		IL_00ac: stloc 2
		IL_00b0: nop
		IL_00b1: ldloca 2
		IL_00b5: nop
		IL_00b6: ldind.i2
		IL_00b7: conv.i2

		IL_00b8: pop
		IL_00b9: br.s IL_00cd

		IL_00bb: ldc.i4 1410007040
		IL_00c0: stloc 2
		IL_00c4: ldloca 2
		IL_00c8: nop
		IL_00c9: ldind.i2
		IL_00ca: conv.i2
		IL_00cb: br.s IL_00b8

		IL_00cd: nop
		IL_00ce: ldc.i4 1343094784
		IL_00d3: nop
		IL_00d4: stloc 2
		IL_00d8: ldloca 2
		IL_00dc: nop
		IL_00dd: ldind.i2
		IL_00de: conv.i2
		IL_00df: brfalse IL_00e4

		IL_00e4: ldc.i4 1219297281
		IL_00e9: stloc 2
		IL_00ed: nop
		IL_00ee: ldloca 2
		IL_00f2: nop
		IL_00f3: ldind.i2
		IL_00f4: conv.i2
		IL_00f5: conv.i
		IL_00f6: stloc.1
		IL_00f7: br IL_000a

		IL_00fc: br.s IL_0139

		IL_00fe: ldc.i4.1
		IL_00ff: ret

		IL_0100: ldc.i4 468844544
		IL_0105: stloc 2
		IL_0109: ldloca 2
		IL_010d: nop
		IL_010e: ldind.i2
		IL_010f: conv.i2
		IL_0110: conv.i
		IL_0111: stloc.1
		IL_0112: br IL_000a

		IL_0117: ldarg.0
		IL_0118: ldloc.0
		IL_0119: ldelem.i2
		IL_011a: ldarg.1
		IL_011b: bne.un IL_006b

		IL_0120: ldc.i4 1697775618
		IL_0125: stloc 2
		IL_0129: ldloca 2
		IL_012d: nop
		IL_012e: ldind.i2
		IL_012f: conv.i2
		IL_0130: conv.i
		IL_0131: stloc.1
		IL_0132: br IL_000a

		IL_0137: br.s IL_00fe

		IL_0139: ldc.i4 392232963
		IL_013e: nop
		IL_013f: stloc 2
		IL_0143: ldloca 2
		IL_0147: nop
		IL_0148: ldind.i2
		IL_0149: conv.i2
		IL_014a: conv.i
		IL_014b: stloc.1
		IL_014c: br IL_000a

		IL_0151: ldloc.0
		IL_0152: ldarg.0
		IL_0153: ldlen
		IL_0154: conv.i4
		IL_0155: blt.s IL_0100

		IL_0157: ldc.i4 221315076
		IL_015c: stloc 2
		IL_0160: ldloca 2
		IL_0164: nop
		IL_0165: ldind.i2
		IL_0166: conv.i2
		IL_0167: conv.i
		IL_0168: stloc.1
		IL_0169: br IL_000a

		IL_016e: br.s IL_0170

		IL_0170: ldc.i4.0
		IL_0171: ret
	} // end of method Arrays::Contains

	.method public hidebysig static 
		bool Contains (
			int32[] a,
			int32 n
		) cil managed 
	{
		// Method begins at RVA 0x4a00
		// Header size: 12
		// Code size: 365 (0x16d)
		.maxstack 2
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_004e)

		IL_000a: ldc.i4 1101791233
		IL_000f: stloc 2
		IL_0013: nop
		IL_0014: ldloca 2
		IL_0018: ldind.i2
		IL_0019: conv.i2
		IL_001a: br.s IL_002e

		IL_001c: ldc.i4 452067328
		IL_0021: stloc 2
		IL_0025: ldloca 2
		IL_0029: nop
		IL_002a: ldind.i2
		IL_002b: conv.i2
		IL_002c: br.s IL_002e

		IL_002e: brfalse.s IL_0030

		IL_0030: ldloc.1
		IL_0031: switch (IL_0113, IL_00f7, IL_0133, IL_014c, IL_0169, IL_0064)

		IL_004e: ldc.i4.0
		IL_004f: stloc.0
		IL_0050: ldc.i4 687603717
		IL_0055: nop
		IL_0056: stloc 2
		IL_005a: ldloca 2
		IL_005e: ldind.i2
		IL_005f: conv.i2
		IL_0060: conv.i
		IL_0061: stloc.1
		IL_0062: br.s IL_000a

		IL_0064: br IL_0135

		IL_0069: ldloc.0
		IL_006a: ldc.i4.1
		IL_006b: add
		IL_006c: stloc.0
		IL_006d: ldc.i4 474010271
		IL_0072: nop
		IL_0073: stloc 2
		IL_0077: ldloca 2
		IL_007b: nop
		IL_007c: ldind.i2
		IL_007d: conv.i2
		IL_007e: ldc.i4 1424347807
		IL_0083: nop
		IL_0084: stloc 2
		IL_0088: nop
		IL_0089: ldloca 2
		IL_008d: ldind.i2
		IL_008e: conv.i2
		IL_008f: ceq
		IL_0091: switch (IL_014c, IL_00a3, IL_014c)

		IL_00a2: nop

		IL_00a3: br.s IL_00b8

		IL_00a5: ldc.i4 957153280
		IL_00aa: stloc 2
		IL_00ae: ldloca 2
		IL_00b2: nop
		IL_00b3: ldind.i2
		IL_00b4: conv.i2

		IL_00b5: pop
		IL_00b6: br.s IL_00ca

		IL_00b8: ldc.i4 1920335872
		IL_00bd: stloc 2
		IL_00c1: ldloca 2
		IL_00c5: nop
		IL_00c6: ldind.i2
		IL_00c7: conv.i2
		IL_00c8: br.s IL_00b5

		IL_00ca: nop
		IL_00cb: ldc.i4 1138032640
		IL_00d0: stloc 2
		IL_00d4: ldloca 2
		IL_00d8: nop
		IL_00d9: ldind.i2
		IL_00da: conv.i2
		IL_00db: brfalse IL_00e0

		IL_00e0: ldc.i4 480051201
		IL_00e5: stloc 2
		IL_00e9: nop
		IL_00ea: ldloca 2
		IL_00ee: ldind.i2
		IL_00ef: conv.i2
		IL_00f0: conv.i
		IL_00f1: stloc.1
		IL_00f2: br IL_000a

		IL_00f7: br.s IL_0135

		IL_00f9: ldc.i4.1
		IL_00fa: ret

		IL_00fb: ldc.i4 124715008
		IL_0100: nop
		IL_0101: stloc 2
		IL_0105: ldloca 2
		IL_0109: nop
		IL_010a: ldind.i2
		IL_010b: conv.i2
		IL_010c: conv.i
		IL_010d: stloc.1
		IL_010e: br IL_000a

		IL_0113: ldarg.0
		IL_0114: ldloc.0
		IL_0115: ldelem.i4
		IL_0116: ldarg.1
		IL_0117: bne.un IL_0069

		IL_011c: ldc.i4 1077673986
		IL_0121: stloc 2
		IL_0125: ldloca 2
		IL_0129: nop
		IL_012a: ldind.i2
		IL_012b: conv.i2
		IL_012c: conv.i
		IL_012d: stloc.1
		IL_012e: br IL_000a

		IL_0133: br.s IL_00f9

		IL_0135: ldc.i4 498270211
		IL_013a: stloc 2
		IL_013e: ldloca 2
		IL_0142: nop
		IL_0143: ldind.i2
		IL_0144: conv.i2
		IL_0145: conv.i
		IL_0146: stloc.1
		IL_0147: br IL_000a

		IL_014c: ldloc.0
		IL_014d: ldarg.0
		IL_014e: ldlen
		IL_014f: conv.i4
		IL_0150: blt.s IL_00fb

		IL_0152: ldc.i4 1674838020
		IL_0157: nop
		IL_0158: stloc 2
		IL_015c: ldloca 2
		IL_0160: ldind.i2
		IL_0161: conv.i2
		IL_0162: conv.i
		IL_0163: stloc.1
		IL_0164: br IL_000a

		IL_0169: br.s IL_016b

		IL_016b: ldc.i4.0
		IL_016c: ret
	} // end of method Arrays::Contains

	.method public hidebysig static 
		void Fill (
			uint8[] buf,
			uint8 b
		) cil managed 
	{
		// Method begins at RVA 0x4b7c
		// Header size: 12
		// Code size: 306 (0x132)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0020)

		IL_000a: ldloc.1
		IL_000b: switch (IL_0050, IL_0109, IL_012c, IL_0039)

		IL_0020: ldarg.0
		IL_0021: ldlen
		IL_0022: conv.i4
		IL_0023: stloc.0
		IL_0024: ldc.i4 1168113667
		IL_0029: nop
		IL_002a: stloc 2
		IL_002e: nop
		IL_002f: ldloca 2
		IL_0033: ldind.i2
		IL_0034: conv.i2
		IL_0035: conv.i
		IL_0036: stloc.1
		IL_0037: br.s IL_000a

		IL_0039: br.s IL_003b

		IL_003b: ldc.i4 2126053376
		IL_0040: nop
		IL_0041: stloc 2
		IL_0045: nop
		IL_0046: ldloca 2
		IL_004a: ldind.i2
		IL_004b: conv.i2
		IL_004c: conv.i
		IL_004d: stloc.1
		IL_004e: br.s IL_000a

		IL_0050: ldloc.0
		IL_0051: ldc.i4.0
		IL_0052: bgt IL_010b

		IL_0057: ldc.i4 1570513416
		IL_005c: stloc 2
		IL_0060: nop
		IL_0061: ldloca 2
		IL_0065: ldind.i2
		IL_0066: conv.i2
		IL_0067: ldc.i4 199303688
		IL_006c: stloc 2
		IL_0070: ldloca 2
		IL_0074: nop
		IL_0075: ldind.i2
		IL_0076: conv.i2
		IL_0077: ceq
		IL_0079: switch (IL_0039, IL_008b, IL_0039)

		IL_008a: nop

		IL_008b: ldc.i4 662896640
		IL_0090: stloc 2
		IL_0094: nop
		IL_0095: ldloca 2
		IL_0099: ldind.i2
		IL_009a: conv.i2
		IL_009b: brfalse IL_00a0

		IL_00a0: ldc.i4 785842177
		IL_00a5: nop
		IL_00a6: stloc 2
		IL_00aa: ldloca 2
		IL_00ae: ldind.i2
		IL_00af: conv.i2
		IL_00b0: br.s IL_00c5

		IL_00b2: ldc.i4 1597964288
		IL_00b7: nop
		IL_00b8: stloc 2
		IL_00bc: ldloca 2
		IL_00c0: nop
		IL_00c1: ldind.i2
		IL_00c2: conv.i2
		IL_00c3: br.s IL_00c5

		IL_00c5: brfalse.s IL_00c7

		IL_00c7: br.s IL_00dd

		IL_00c9: ldc.i4 1182138368
		IL_00ce: nop
		IL_00cf: stloc 2
		IL_00d3: nop
		IL_00d4: ldloca 2
		IL_00d8: ldind.i2
		IL_00d9: conv.i2

		IL_00da: pop
		IL_00db: br.s IL_00f0

		IL_00dd: ldc.i4 1799421952
		IL_00e2: nop
		IL_00e3: stloc 2
		IL_00e7: ldloca 2
		IL_00eb: nop
		IL_00ec: ldind.i2
		IL_00ed: conv.i2
		IL_00ee: br.s IL_00da

		IL_00f0: nop
		IL_00f1: ldc.i4 1104478209
		IL_00f6: stloc 2
		IL_00fa: nop
		IL_00fb: ldloca 2
		IL_00ff: nop
		IL_0100: ldind.i2
		IL_0101: conv.i2
		IL_0102: conv.i
		IL_0103: stloc.1
		IL_0104: br IL_000a

		IL_0109: br.s IL_0131

		IL_010b: ldarg.0
		IL_010c: ldloc.0
		IL_010d: ldc.i4.1
		IL_010e: sub
		IL_010f: dup
		IL_0110: stloc.0
		IL_0111: ldarg.1
		IL_0112: stelem.i1
		IL_0113: ldc.i4 192413698
		IL_0118: nop
		IL_0119: stloc 2
		IL_011d: nop
		IL_011e: ldloca 2
		IL_0122: nop
		IL_0123: ldind.i2
		IL_0124: conv.i2
		IL_0125: conv.i
		IL_0126: stloc.1
		IL_0127: br IL_000a

		IL_012c: br IL_003b

		IL_0131: ret
	} // end of method Arrays::Fill

	.method public hidebysig static 
		uint8[] CopyOf (
			uint8[] data,
			int32 newLength
		) cil managed 
	{
		// Method begins at RVA 0x4cbc
		// Header size: 12
		// Code size: 184 (0xb8)
		.maxstack 6
		.locals init (
			[0] uint8[],
			[1] int16
		)

		IL_0000: ldc.i4 1673274083
		IL_0005: nop
		IL_0006: stloc 1
		IL_000a: ldloca 1
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 867640035
		IL_0015: stloc 1
		IL_0019: nop
		IL_001a: ldloca 1
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0060, IL_0034)

		IL_0034: br.s IL_004a

		IL_0036: ldc.i4 1303511040
		IL_003b: stloc 1
		IL_003f: nop
		IL_0040: ldloca 1
		IL_0044: nop
		IL_0045: ldind.i2
		IL_0046: conv.i2

		IL_0047: pop
		IL_0048: br.s IL_005e

		IL_004a: ldc.i4 1649672192
		IL_004f: nop
		IL_0050: stloc 1
		IL_0054: nop
		IL_0055: ldloca 1
		IL_0059: nop
		IL_005a: ldind.i2
		IL_005b: conv.i2
		IL_005c: br.s IL_0047

		IL_005e: nop
		IL_005f: nop

		IL_0060: ldc.i4 1271267329
		IL_0065: nop
		IL_0066: stloc 1
		IL_006a: ldloca 1
		IL_006e: ldind.i2
		IL_006f: conv.i2
		IL_0070: br.s IL_0084

		IL_0072: ldc.i4 483328000
		IL_0077: stloc 1
		IL_007b: ldloca 1
		IL_007f: nop
		IL_0080: ldind.i2
		IL_0081: conv.i2
		IL_0082: br.s IL_0084

		IL_0084: brfalse.s IL_0086

		IL_0086: ldc.i4 814612480
		IL_008b: nop
		IL_008c: stloc 1
		IL_0090: nop
		IL_0091: ldloca 1
		IL_0095: nop
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: brfalse IL_009d

		IL_009d: ldarg.1
		IL_009e: newarr [mscorlib]System.Byte
		IL_00a3: stloc.0
		IL_00a4: ldarg.0
		IL_00a5: ldc.i4.0
		IL_00a6: ldloc.0
		IL_00a7: ldc.i4.0
		IL_00a8: ldarg.1
		IL_00a9: ldarg.0
		IL_00aa: ldlen
		IL_00ab: conv.i4
		IL_00ac: call int32 [mscorlib]System.Math::Min(int32, int32)
		IL_00b1: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00b6: ldloc.0
		IL_00b7: ret
	} // end of method Arrays::CopyOf

	.method public hidebysig static 
		char[] CopyOf (
			char[] data,
			int32 newLength
		) cil managed 
	{
		// Method begins at RVA 0x4d80
		// Header size: 12
		// Code size: 181 (0xb5)
		.maxstack 6
		.locals init (
			[0] char[],
			[1] int16
		)

		IL_0000: ldc.i4 1555580817
		IL_0005: stloc 1
		IL_0009: nop
		IL_000a: ldloca 1
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 447367057
		IL_0015: nop
		IL_0016: stloc 1
		IL_001a: ldloca 1
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_005f, IL_0034)

		IL_0034: br.s IL_0049

		IL_0036: ldc.i4 1733361664
		IL_003b: stloc 1
		IL_003f: ldloca 1
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2

		IL_0046: pop
		IL_0047: br.s IL_005d

		IL_0049: ldc.i4 1389297664
		IL_004e: nop
		IL_004f: stloc 1
		IL_0053: nop
		IL_0054: ldloca 1
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_0046

		IL_005d: nop
		IL_005e: nop

		IL_005f: ldc.i4 2139095041
		IL_0064: stloc 1
		IL_0068: ldloca 1
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: br.s IL_0083

		IL_0071: ldc.i4 2100035584
		IL_0076: stloc 1
		IL_007a: ldloca 1
		IL_007e: nop
		IL_007f: ldind.i2
		IL_0080: conv.i2
		IL_0081: br.s IL_0083

		IL_0083: brfalse.s IL_0085

		IL_0085: ldc.i4 166723584
		IL_008a: stloc 1
		IL_008e: nop
		IL_008f: ldloca 1
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: brfalse IL_009a

		IL_009a: ldarg.1
		IL_009b: newarr [mscorlib]System.Char
		IL_00a0: stloc.0
		IL_00a1: ldarg.0
		IL_00a2: ldc.i4.0
		IL_00a3: ldloc.0
		IL_00a4: ldc.i4.0
		IL_00a5: ldarg.1
		IL_00a6: ldarg.0
		IL_00a7: ldlen
		IL_00a8: conv.i4
		IL_00a9: call int32 [mscorlib]System.Math::Min(int32, int32)
		IL_00ae: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00b3: ldloc.0
		IL_00b4: ret
	} // end of method Arrays::CopyOf

	.method public hidebysig static 
		int32[] CopyOf (
			int32[] data,
			int32 newLength
		) cil managed 
	{
		// Method begins at RVA 0x4e44
		// Header size: 12
		// Code size: 185 (0xb9)
		.maxstack 6
		.locals init (
			[0] int32[],
			[1] int16
		)

		IL_0000: ldc.i4 1740914023
		IL_0005: nop
		IL_0006: stloc 1
		IL_000a: nop
		IL_000b: ldloca 1
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 930168167
		IL_0017: nop
		IL_0018: stloc 1
		IL_001c: nop
		IL_001d: ldloca 1
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: ceq
		IL_0025: switch (IL_0036, IL_0061, IL_0036)

		IL_0036: br.s IL_004c

		IL_0038: ldc.i4 343998464
		IL_003d: nop
		IL_003e: stloc 1
		IL_0042: nop
		IL_0043: ldloca 1
		IL_0047: ldind.i2
		IL_0048: conv.i2

		IL_0049: pop
		IL_004a: br.s IL_005f

		IL_004c: ldc.i4 1383333888
		IL_0051: nop
		IL_0052: stloc 1
		IL_0056: nop
		IL_0057: ldloca 1
		IL_005b: ldind.i2
		IL_005c: conv.i2
		IL_005d: br.s IL_0049

		IL_005f: nop
		IL_0060: nop

		IL_0061: ldc.i4 1188298753
		IL_0066: nop
		IL_0067: stloc 1
		IL_006b: ldloca 1
		IL_006f: nop
		IL_0070: ldind.i2
		IL_0071: conv.i2
		IL_0072: br.s IL_0086

		IL_0074: ldc.i4 1317142528
		IL_0079: nop
		IL_007a: stloc 1
		IL_007e: ldloca 1
		IL_0082: ldind.i2
		IL_0083: conv.i2
		IL_0084: br.s IL_0086

		IL_0086: brfalse.s IL_0088

		IL_0088: ldc.i4 480706560
		IL_008d: nop
		IL_008e: stloc 1
		IL_0092: nop
		IL_0093: ldloca 1
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: brfalse IL_009e

		IL_009e: ldarg.1
		IL_009f: newarr [mscorlib]System.Int32
		IL_00a4: stloc.0
		IL_00a5: ldarg.0
		IL_00a6: ldc.i4.0
		IL_00a7: ldloc.0
		IL_00a8: ldc.i4.0
		IL_00a9: ldarg.1
		IL_00aa: ldarg.0
		IL_00ab: ldlen
		IL_00ac: conv.i4
		IL_00ad: call int32 [mscorlib]System.Math::Min(int32, int32)
		IL_00b2: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00b7: ldloc.0
		IL_00b8: ret
	} // end of method Arrays::CopyOf

	.method public hidebysig static 
		int64[] CopyOf (
			int64[] data,
			int32 newLength
		) cil managed 
	{
		// Method begins at RVA 0x4f0c
		// Header size: 12
		// Code size: 182 (0xb6)
		.maxstack 6
		.locals init (
			[0] int64[],
			[1] int16
		)

		IL_0000: ldc.i4 289295659
		IL_0005: stloc 1
		IL_0009: nop
		IL_000a: ldloca 1
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1247169835
		IL_0015: nop
		IL_0016: stloc 1
		IL_001a: nop
		IL_001b: ldloca 1
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0060, IL_0035)

		IL_0035: br.s IL_004b

		IL_0037: ldc.i4 385351680
		IL_003c: stloc 1
		IL_0040: nop
		IL_0041: ldloca 1
		IL_0045: nop
		IL_0046: ldind.i2
		IL_0047: conv.i2

		IL_0048: pop
		IL_0049: br.s IL_005e

		IL_004b: ldc.i4 940376064
		IL_0050: nop
		IL_0051: stloc 1
		IL_0055: ldloca 1
		IL_0059: nop
		IL_005a: ldind.i2
		IL_005b: conv.i2
		IL_005c: br.s IL_0048

		IL_005e: nop
		IL_005f: nop

		IL_0060: ldc.i4 1074855937
		IL_0065: stloc 1
		IL_0069: nop
		IL_006a: ldloca 1
		IL_006e: ldind.i2
		IL_006f: conv.i2
		IL_0070: br.s IL_0084

		IL_0072: ldc.i4 1909784576
		IL_0077: stloc 1
		IL_007b: ldloca 1
		IL_007f: nop
		IL_0080: ldind.i2
		IL_0081: conv.i2
		IL_0082: br.s IL_0084

		IL_0084: brfalse.s IL_0086

		IL_0086: ldc.i4 1314848768
		IL_008b: stloc 1
		IL_008f: nop
		IL_0090: ldloca 1
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: brfalse IL_009b

		IL_009b: ldarg.1
		IL_009c: newarr [mscorlib]System.Int64
		IL_00a1: stloc.0
		IL_00a2: ldarg.0
		IL_00a3: ldc.i4.0
		IL_00a4: ldloc.0
		IL_00a5: ldc.i4.0
		IL_00a6: ldarg.1
		IL_00a7: ldarg.0
		IL_00a8: ldlen
		IL_00a9: conv.i4
		IL_00aa: call int32 [mscorlib]System.Math::Min(int32, int32)
		IL_00af: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00b4: ldloc.0
		IL_00b5: ret
	} // end of method Arrays::CopyOf

	.method public hidebysig static 
		uint8[] CopyOfRange (
			uint8[] data,
			int32 from,
			int32 'to'
		) cil managed 
	{
		// Method begins at RVA 0x4fd0
		// Header size: 12
		// Code size: 190 (0xbe)
		.maxstack 7
		.locals init (
			[0] int32,
			[1] uint8[],
			[2] int16
		)

		IL_0000: ldc.i4 1792293652
		IL_0005: stloc 2
		IL_0009: nop
		IL_000a: ldloca 2
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 2139241236
		IL_0016: stloc 2
		IL_001a: nop
		IL_001b: ldloca 2
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_005e, IL_0034)

		IL_0034: br.s IL_0049

		IL_0036: ldc.i4 289865728
		IL_003b: stloc 2
		IL_003f: ldloca 2
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2

		IL_0046: pop
		IL_0047: br.s IL_005c

		IL_0049: ldc.i4 767885312
		IL_004e: nop
		IL_004f: stloc 2
		IL_0053: ldloca 2
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_0046

		IL_005c: nop
		IL_005d: nop

		IL_005e: ldc.i4 1504313345
		IL_0063: nop
		IL_0064: stloc 2
		IL_0068: ldloca 2
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: br.s IL_0082

		IL_0070: ldc.i4 162267136
		IL_0075: stloc 2
		IL_0079: nop
		IL_007a: ldloca 2
		IL_007e: ldind.i2
		IL_007f: conv.i2
		IL_0080: br.s IL_0082

		IL_0082: brfalse.s IL_0084

		IL_0084: ldc.i4 458162176
		IL_0089: stloc 2
		IL_008d: ldloca 2
		IL_0091: nop
		IL_0092: ldind.i2
		IL_0093: conv.i2
		IL_0094: brfalse IL_0099

		IL_0099: ldarg.1
		IL_009a: ldarg.2
		IL_009b: call int32 ODCrypt.Arrays::w(int32, int32)
		IL_00a0: stloc.0
		IL_00a1: ldloc.0
		IL_00a2: newarr [mscorlib]System.Byte
		IL_00a7: stloc.1
		IL_00a8: ldarg.0
		IL_00a9: ldarg.1
		IL_00aa: ldloc.1
		IL_00ab: ldc.i4.0
		IL_00ac: ldloc.0
		IL_00ad: ldarg.0
		IL_00ae: ldlen
		IL_00af: conv.i4
		IL_00b0: ldarg.1
		IL_00b1: sub
		IL_00b2: call int32 [mscorlib]System.Math::Min(int32, int32)
		IL_00b7: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00bc: ldloc.1
		IL_00bd: ret
	} // end of method Arrays::CopyOfRange

	.method public hidebysig static 
		int32[] CopyOfRange (
			int32[] data,
			int32 from,
			int32 'to'
		) cil managed 
	{
		// Method begins at RVA 0x509c
		// Header size: 12
		// Code size: 192 (0xc0)
		.maxstack 7
		.locals init (
			[0] int32,
			[1] int32[],
			[2] int16
		)

		IL_0000: ldc.i4 408485889
		IL_0005: nop
		IL_0006: stloc 2
		IL_000a: ldloca 2
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: br.s IL_0026

		IL_0013: ldc.i4 1538523136
		IL_0018: stloc 2
		IL_001c: nop
		IL_001d: ldloca 2
		IL_0021: nop
		IL_0022: ldind.i2
		IL_0023: conv.i2
		IL_0024: br.s IL_0026

		IL_0026: brfalse.s IL_0028

		IL_0028: br.s IL_003d

		IL_002a: ldc.i4 148439040
		IL_002f: stloc 2
		IL_0033: nop
		IL_0034: ldloca 2
		IL_0038: ldind.i2
		IL_0039: conv.i2

		IL_003a: pop
		IL_003b: br.s IL_004f

		IL_003d: ldc.i4 126746624
		IL_0042: stloc 2
		IL_0046: nop
		IL_0047: ldloca 2
		IL_004b: ldind.i2
		IL_004c: conv.i2
		IL_004d: br.s IL_003a

		IL_004f: nop
		IL_0050: ldc.i4 538453186
		IL_0055: nop
		IL_0056: stloc 2
		IL_005a: ldloca 2
		IL_005e: nop
		IL_005f: ldind.i2
		IL_0060: conv.i2
		IL_0061: ldc.i4 310256834
		IL_0066: nop
		IL_0067: stloc 2
		IL_006b: nop
		IL_006c: ldloca 2
		IL_0070: ldind.i2
		IL_0071: conv.i2
		IL_0072: ceq
		IL_0074: switch (IL_0085, IL_0086, IL_0085)

		IL_0085: nop

		IL_0086: ldc.i4 646381568
		IL_008b: stloc 2
		IL_008f: ldloca 2
		IL_0093: nop
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: brfalse IL_009b

		IL_009b: ldarg.1
		IL_009c: ldarg.2
		IL_009d: call int32 ODCrypt.Arrays::w(int32, int32)
		IL_00a2: stloc.0
		IL_00a3: ldloc.0
		IL_00a4: newarr [mscorlib]System.Int32
		IL_00a9: stloc.1
		IL_00aa: ldarg.0
		IL_00ab: ldarg.1
		IL_00ac: ldloc.1
		IL_00ad: ldc.i4.0
		IL_00ae: ldloc.0
		IL_00af: ldarg.0
		IL_00b0: ldlen
		IL_00b1: conv.i4
		IL_00b2: ldarg.1
		IL_00b3: sub
		IL_00b4: call int32 [mscorlib]System.Math::Min(int32, int32)
		IL_00b9: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00be: ldloc.1
		IL_00bf: ret
	} // end of method Arrays::CopyOfRange

	.method public hidebysig static 
		int64[] CopyOfRange (
			int64[] data,
			int32 from,
			int32 'to'
		) cil managed 
	{
		// Method begins at RVA 0x5168
		// Header size: 12
		// Code size: 195 (0xc3)
		.maxstack 7
		.locals init (
			[0] int32,
			[1] int64[],
			[2] int16
		)

		IL_0000: ldc.i4 2025381730
		IL_0005: stloc 2
		IL_0009: ldloca 2
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 596893538
		IL_0015: stloc 2
		IL_0019: nop
		IL_001a: ldloca 2
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_005f, IL_0033)

		IL_0033: br.s IL_0049

		IL_0035: ldc.i4 884736000
		IL_003a: nop
		IL_003b: stloc 2
		IL_003f: nop
		IL_0040: ldloca 2
		IL_0044: ldind.i2
		IL_0045: conv.i2

		IL_0046: pop
		IL_0047: br.s IL_005d

		IL_0049: ldc.i4 199491584
		IL_004e: nop
		IL_004f: stloc 2
		IL_0053: nop
		IL_0054: ldloca 2
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_0046

		IL_005d: nop
		IL_005e: nop

		IL_005f: ldc.i4 1921974273
		IL_0064: stloc 2
		IL_0068: ldloca 2
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: br.s IL_0085

		IL_0071: ldc.i4 623247360
		IL_0076: nop
		IL_0077: stloc 2
		IL_007b: nop
		IL_007c: ldloca 2
		IL_0080: nop
		IL_0081: ldind.i2
		IL_0082: conv.i2
		IL_0083: br.s IL_0085

		IL_0085: brfalse.s IL_0087

		IL_0087: ldc.i4 78249984
		IL_008c: nop
		IL_008d: stloc 2
		IL_0091: nop
		IL_0092: ldloca 2
		IL_0096: nop
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: brfalse IL_009e

		IL_009e: ldarg.1
		IL_009f: ldarg.2
		IL_00a0: call int32 ODCrypt.Arrays::w(int32, int32)
		IL_00a5: stloc.0
		IL_00a6: ldloc.0
		IL_00a7: newarr [mscorlib]System.Int64
		IL_00ac: stloc.1
		IL_00ad: ldarg.0
		IL_00ae: ldarg.1
		IL_00af: ldloc.1
		IL_00b0: ldc.i4.0
		IL_00b1: ldloc.0
		IL_00b2: ldarg.0
		IL_00b3: ldlen
		IL_00b4: conv.i4
		IL_00b5: ldarg.1
		IL_00b6: sub
		IL_00b7: call int32 [mscorlib]System.Math::Min(int32, int32)
		IL_00bc: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00c1: ldloc.1
		IL_00c2: ret
	} // end of method Arrays::CopyOfRange

	.method private hidebysig static 
		int32 w (
			int32 A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0x5238
		// Header size: 12
		// Code size: 215 (0xd7)
		.maxstack 4
		.locals init (
			[0] int16,
			[1] int32
		)

		IL_0000: ldc.i4 1
		IL_0005: stloc 1
		IL_0009: ldc.i4 1582366721
		IL_000e: nop
		IL_000f: stloc 0
		IL_0013: nop
		IL_0014: ldloca 0
		IL_0018: ldind.i2
		IL_0019: conv.i2
		IL_001a: br.s IL_002f

		IL_001c: ldc.i4 1000079360
		IL_0021: nop
		IL_0022: stloc 0
		IL_0026: nop
		IL_0027: ldloca 0
		IL_002b: ldind.i2
		IL_002c: conv.i2
		IL_002d: br.s IL_002f

		IL_002f: brfalse.s IL_0031

		IL_0031: br.s IL_0047

		IL_0033: ldc.i4 735117312
		IL_0038: nop
		IL_0039: stloc 0
		IL_003d: nop
		IL_003e: ldloca 0
		IL_0042: ldind.i2
		IL_0043: conv.i2

		IL_0044: pop
		IL_0045: br.s IL_0059

		IL_0047: ldc.i4 824705024
		IL_004c: stloc 0
		IL_0050: nop
		IL_0051: ldloca 0
		IL_0055: ldind.i2
		IL_0056: conv.i2
		IL_0057: br.s IL_0044

		IL_0059: nop
		IL_005a: ldc.i4 478709757
		IL_005f: nop
		IL_0060: stloc 0
		IL_0064: nop
		IL_0065: ldloca 0
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: ldc.i4 240355325
		IL_0071: stloc 0
		IL_0075: ldloca 0
		IL_0079: nop
		IL_007a: ldind.i2
		IL_007b: conv.i2
		IL_007c: ceq
		IL_007e: switch (IL_008f, IL_0090, IL_008f)

		IL_008f: nop

		IL_0090: ldc.i4 1707474944
		IL_0095: nop
		IL_0096: stloc 0
		IL_009a: nop
		IL_009b: ldloca 0
		IL_009f: ldind.i2
		IL_00a0: conv.i2
		IL_00a1: brfalse IL_00a6

		IL_00a6: ldarg.1
		IL_00a7: ldarg.0
		IL_00a8: sub
		IL_00a9: dup
		IL_00aa: ldc.i4.0
		IL_00ab: bge.s IL_00d6

		IL_00ad: br.s IL_00af

		IL_00af: ldarga.s A_0
		IL_00b1: call instance string [mscorlib]System.Int32::ToString()
		IL_00b6: ldstr "???"
		IL_00bb: ldloc 1
		IL_00bf: call string ODCrypt.Sha3::b(string, int32)
		IL_00c4: ldarga.s A_1
		IL_00c6: call instance string [mscorlib]System.Int32::ToString()
		IL_00cb: call string [mscorlib]System.String::Concat(string, string, string)
		IL_00d0: newobj instance void [mscorlib]System.ArgumentException::.ctor(string)
		IL_00d5: throw

		IL_00d6: ret
	} // end of method Arrays::w

	.method public hidebysig static 
		uint8[] Append (
			uint8[] a,
			uint8 b
		) cil managed 
	{
		// Method begins at RVA 0x531c
		// Header size: 12
		// Code size: 204 (0xcc)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] uint8[],
			[2] int16
		)

		IL_0000: ldarg.0
		IL_0001: brtrue IL_00af

		IL_0006: ldc.i4 1659699201
		IL_000b: stloc 2
		IL_000f: ldloca 2
		IL_0013: nop
		IL_0014: ldind.i2
		IL_0015: conv.i2
		IL_0016: br.s IL_002c

		IL_0018: ldc.i4 2107310080
		IL_001d: nop
		IL_001e: stloc 2
		IL_0022: nop
		IL_0023: ldloca 2
		IL_0027: nop
		IL_0028: ldind.i2
		IL_0029: conv.i2
		IL_002a: br.s IL_002c

		IL_002c: brfalse.s IL_002e

		IL_002e: ldc.i4 1458881442
		IL_0033: stloc 2
		IL_0037: ldloca 2
		IL_003b: nop
		IL_003c: ldind.i2
		IL_003d: conv.i2
		IL_003e: ldc.i4 786744226
		IL_0043: stloc 2
		IL_0047: ldloca 2
		IL_004b: nop
		IL_004c: ldind.i2
		IL_004d: conv.i2
		IL_004e: ceq
		IL_0050: switch (IL_00a4, IL_008c, IL_00a4)

		IL_0061: br.s IL_0077

		IL_0063: ldc.i4 1816199168
		IL_0068: nop
		IL_0069: stloc 2
		IL_006d: nop
		IL_006e: ldloca 2
		IL_0072: ldind.i2
		IL_0073: conv.i2

		IL_0074: pop
		IL_0075: br.s IL_008a

		IL_0077: ldc.i4 2065563648
		IL_007c: nop
		IL_007d: stloc 2
		IL_0081: ldloca 2
		IL_0085: nop
		IL_0086: ldind.i2
		IL_0087: conv.i2
		IL_0088: br.s IL_0074

		IL_008a: nop
		IL_008b: nop

		IL_008c: ldc.i4 1903558656
		IL_0091: stloc 2
		IL_0095: nop
		IL_0096: ldloca 2
		IL_009a: nop
		IL_009b: ldind.i2
		IL_009c: conv.i2
		IL_009d: brfalse IL_00a2

		IL_00a2: br.s IL_00a4

		IL_00a4: ldc.i4.1
		IL_00a5: newarr [mscorlib]System.Byte
		IL_00aa: dup
		IL_00ab: ldc.i4.0
		IL_00ac: ldarg.1
		IL_00ad: stelem.i1
		IL_00ae: ret

		IL_00af: ldarg.0
		IL_00b0: ldlen
		IL_00b1: conv.i4
		IL_00b2: stloc.0
		IL_00b3: ldloc.0
		IL_00b4: ldc.i4.1
		IL_00b5: add
		IL_00b6: newarr [mscorlib]System.Byte
		IL_00bb: stloc.1
		IL_00bc: ldarg.0
		IL_00bd: ldc.i4.0
		IL_00be: ldloc.1
		IL_00bf: ldc.i4.0
		IL_00c0: ldloc.0
		IL_00c1: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00c6: ldloc.1
		IL_00c7: ldloc.0
		IL_00c8: ldarg.1
		IL_00c9: stelem.i1
		IL_00ca: ldloc.1
		IL_00cb: ret
	} // end of method Arrays::Append

	.method public hidebysig static 
		int16[] Append (
			int16[] a,
			int16 b
		) cil managed 
	{
		// Method begins at RVA 0x53f4
		// Header size: 12
		// Code size: 200 (0xc8)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] int16[],
			[2] int16
		)

		IL_0000: ldarg.0
		IL_0001: brtrue IL_00ab

		IL_0006: ldc.i4 87882356
		IL_000b: stloc 2
		IL_000f: ldloca 2
		IL_0013: nop
		IL_0014: ldind.i2
		IL_0015: conv.i2
		IL_0016: ldc.i4 751106676
		IL_001b: nop
		IL_001c: stloc 2
		IL_0020: ldloca 2
		IL_0024: ldind.i2
		IL_0025: conv.i2
		IL_0026: ceq
		IL_0028: switch (IL_00a0, IL_003a, IL_00a0)

		IL_0039: nop

		IL_003a: br.s IL_004f

		IL_003c: ldc.i4 1239744512
		IL_0041: stloc 2
		IL_0045: ldloca 2
		IL_0049: nop
		IL_004a: ldind.i2
		IL_004b: conv.i2

		IL_004c: pop
		IL_004d: br.s IL_0061

		IL_004f: ldc.i4 1060306944
		IL_0054: stloc 2
		IL_0058: ldloca 2
		IL_005c: nop
		IL_005d: ldind.i2
		IL_005e: conv.i2
		IL_005f: br.s IL_004c

		IL_0061: nop
		IL_0062: ldc.i4 1062469633
		IL_0067: nop
		IL_0068: stloc 2
		IL_006c: ldloca 2
		IL_0070: ldind.i2
		IL_0071: conv.i2
		IL_0072: br.s IL_0086

		IL_0074: ldc.i4 201785344
		IL_0079: stloc 2
		IL_007d: ldloca 2
		IL_0081: nop
		IL_0082: ldind.i2
		IL_0083: conv.i2
		IL_0084: br.s IL_0086

		IL_0086: brfalse.s IL_0088

		IL_0088: ldc.i4 1066467328
		IL_008d: stloc 2
		IL_0091: nop
		IL_0092: ldloca 2
		IL_0096: nop
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: brfalse IL_009e

		IL_009e: br.s IL_00a0

		IL_00a0: ldc.i4.1
		IL_00a1: newarr [mscorlib]System.Int16
		IL_00a6: dup
		IL_00a7: ldc.i4.0
		IL_00a8: ldarg.1
		IL_00a9: stelem.i2
		IL_00aa: ret

		IL_00ab: ldarg.0
		IL_00ac: ldlen
		IL_00ad: conv.i4
		IL_00ae: stloc.0
		IL_00af: ldloc.0
		IL_00b0: ldc.i4.1
		IL_00b1: add
		IL_00b2: newarr [mscorlib]System.Int16
		IL_00b7: stloc.1
		IL_00b8: ldarg.0
		IL_00b9: ldc.i4.0
		IL_00ba: ldloc.1
		IL_00bb: ldc.i4.0
		IL_00bc: ldloc.0
		IL_00bd: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00c2: ldloc.1
		IL_00c3: ldloc.0
		IL_00c4: ldarg.1
		IL_00c5: stelem.i2
		IL_00c6: ldloc.1
		IL_00c7: ret
	} // end of method Arrays::Append

	.method public hidebysig static 
		int32[] Append (
			int32[] a,
			int32 b
		) cil managed 
	{
		// Method begins at RVA 0x54c8
		// Header size: 12
		// Code size: 204 (0xcc)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] int32[],
			[2] int16
		)

		IL_0000: ldarg.0
		IL_0001: brtrue IL_00af

		IL_0006: ldc.i4 1695702068
		IL_000b: nop
		IL_000c: stloc 2
		IL_0010: nop
		IL_0011: ldloca 2
		IL_0015: nop
		IL_0016: ldind.i2
		IL_0017: conv.i2
		IL_0018: ldc.i4 1298095156
		IL_001d: nop
		IL_001e: stloc 2
		IL_0022: ldloca 2
		IL_0026: ldind.i2
		IL_0027: conv.i2
		IL_0028: ceq
		IL_002a: switch (IL_00a4, IL_003c, IL_00a4)

		IL_003b: nop

		IL_003c: br.s IL_0051

		IL_003e: ldc.i4 1056964608
		IL_0043: stloc 2
		IL_0047: ldloca 2
		IL_004b: nop
		IL_004c: ldind.i2
		IL_004d: conv.i2

		IL_004e: pop
		IL_004f: br.s IL_0064

		IL_0051: ldc.i4 989462528
		IL_0056: stloc 2
		IL_005a: nop
		IL_005b: ldloca 2
		IL_005f: nop
		IL_0060: ldind.i2
		IL_0061: conv.i2
		IL_0062: br.s IL_004e

		IL_0064: nop
		IL_0065: ldc.i4 110886913
		IL_006a: nop
		IL_006b: stloc 2
		IL_006f: ldloca 2
		IL_0073: nop
		IL_0074: ldind.i2
		IL_0075: conv.i2
		IL_0076: br.s IL_008a

		IL_0078: ldc.i4 135135232
		IL_007d: stloc 2
		IL_0081: ldloca 2
		IL_0085: nop
		IL_0086: ldind.i2
		IL_0087: conv.i2
		IL_0088: br.s IL_008a

		IL_008a: brfalse.s IL_008c

		IL_008c: ldc.i4 1188102144
		IL_0091: nop
		IL_0092: stloc 2
		IL_0096: ldloca 2
		IL_009a: nop
		IL_009b: ldind.i2
		IL_009c: conv.i2
		IL_009d: brfalse IL_00a2

		IL_00a2: br.s IL_00a4

		IL_00a4: ldc.i4.1
		IL_00a5: newarr [mscorlib]System.Int32
		IL_00aa: dup
		IL_00ab: ldc.i4.0
		IL_00ac: ldarg.1
		IL_00ad: stelem.i4
		IL_00ae: ret

		IL_00af: ldarg.0
		IL_00b0: ldlen
		IL_00b1: conv.i4
		IL_00b2: stloc.0
		IL_00b3: ldloc.0
		IL_00b4: ldc.i4.1
		IL_00b5: add
		IL_00b6: newarr [mscorlib]System.Int32
		IL_00bb: stloc.1
		IL_00bc: ldarg.0
		IL_00bd: ldc.i4.0
		IL_00be: ldloc.1
		IL_00bf: ldc.i4.0
		IL_00c0: ldloc.0
		IL_00c1: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00c6: ldloc.1
		IL_00c7: ldloc.0
		IL_00c8: ldarg.1
		IL_00c9: stelem.i4
		IL_00ca: ldloc.1
		IL_00cb: ret
	} // end of method Arrays::Append

	.method public hidebysig static 
		uint8[] Concatenate (
			uint8[] a,
			uint8[] b
		) cil managed 
	{
		// Method begins at RVA 0x55a0
		// Header size: 12
		// Code size: 343 (0x157)
		.maxstack 5
		.locals init (
			[0] uint8[],
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4 1149239299
		IL_0005: nop
		IL_0006: stloc 2
		IL_000a: nop
		IL_000b: ldloca 2
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: conv.i
		IL_0012: stloc.1
		IL_0013: br.s IL_001f
		// loop start (head: IL_001f)
			IL_0015: ldc.i4.0
			IL_0016: switch (IL_0035)

			IL_001f: ldloc.1
			IL_0020: switch (IL_004c, IL_0108, IL_0122, IL_0015)
		// end loop

		IL_0035: ldarg.0
		IL_0036: brtrue.s IL_0058

		IL_0038: ldc.i4 62980096
		IL_003d: nop
		IL_003e: stloc 2
		IL_0042: ldloca 2
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: conv.i
		IL_0049: stloc.1
		IL_004a: br.s IL_001f

		IL_004c: br IL_0127

		IL_0051: ldarg.0
		IL_0052: call uint8[] ODCrypt.Arrays::Clone(uint8[])
		IL_0057: ret

		IL_0058: ldc.i4 1904711036
		IL_005d: stloc 2
		IL_0061: ldloca 2
		IL_0065: nop
		IL_0066: ldind.i2
		IL_0067: conv.i2
		IL_0068: ldc.i4 380605820
		IL_006d: stloc 2
		IL_0071: nop
		IL_0072: ldloca 2
		IL_0076: ldind.i2
		IL_0077: conv.i2
		IL_0078: ceq
		IL_007a: switch (IL_0038, IL_008c, IL_0038)

		IL_008b: nop

		IL_008c: ldc.i4 1504313345
		IL_0091: nop
		IL_0092: stloc 2
		IL_0096: ldloca 2
		IL_009a: ldind.i2
		IL_009b: conv.i2
		IL_009c: br.s IL_00b0

		IL_009e: ldc.i4 1462501376
		IL_00a3: stloc 2
		IL_00a7: ldloca 2
		IL_00ab: nop
		IL_00ac: ldind.i2
		IL_00ad: conv.i2
		IL_00ae: br.s IL_00b0

		IL_00b0: brfalse.s IL_00b2

		IL_00b2: ldc.i4 2046820352
		IL_00b7: stloc 2
		IL_00bb: nop
		IL_00bc: ldloca 2
		IL_00c0: nop
		IL_00c1: ldind.i2
		IL_00c2: conv.i2
		IL_00c3: brfalse IL_00c8

		IL_00c8: br.s IL_00dd

		IL_00ca: ldc.i4 1080819712
		IL_00cf: stloc 2
		IL_00d3: ldloca 2
		IL_00d7: nop
		IL_00d8: ldind.i2
		IL_00d9: conv.i2

		IL_00da: pop
		IL_00db: br.s IL_00ef

		IL_00dd: ldc.i4 18350080
		IL_00e2: stloc 2
		IL_00e6: ldloca 2
		IL_00ea: nop
		IL_00eb: ldind.i2
		IL_00ec: conv.i2
		IL_00ed: br.s IL_00da

		IL_00ef: nop
		IL_00f0: ldc.i4 1062076417
		IL_00f5: stloc 2
		IL_00f9: nop
		IL_00fa: ldloca 2
		IL_00fe: nop
		IL_00ff: ldind.i2
		IL_0100: conv.i2
		IL_0101: conv.i
		IL_0102: stloc.1
		IL_0103: br IL_001f

		IL_0108: ldarg.1
		IL_0109: brtrue.s IL_012e

		IL_010b: ldc.i4 896401410
		IL_0110: stloc 2
		IL_0114: ldloca 2
		IL_0118: nop
		IL_0119: ldind.i2
		IL_011a: conv.i2
		IL_011b: conv.i
		IL_011c: stloc.1
		IL_011d: br IL_001f

		IL_0122: br IL_0051

		IL_0127: ldarg.1
		IL_0128: call uint8[] ODCrypt.Arrays::Clone(uint8[])
		IL_012d: ret

		IL_012e: ldarg.0
		IL_012f: ldlen
		IL_0130: conv.i4
		IL_0131: ldarg.1
		IL_0132: ldlen
		IL_0133: conv.i4
		IL_0134: add
		IL_0135: newarr [mscorlib]System.Byte
		IL_013a: stloc.0
		IL_013b: ldarg.0
		IL_013c: ldc.i4.0
		IL_013d: ldloc.0
		IL_013e: ldc.i4.0
		IL_013f: ldarg.0
		IL_0140: ldlen
		IL_0141: conv.i4
		IL_0142: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_0147: ldarg.1
		IL_0148: ldc.i4.0
		IL_0149: ldloc.0
		IL_014a: ldarg.0
		IL_014b: ldlen
		IL_014c: conv.i4
		IL_014d: ldarg.1
		IL_014e: ldlen
		IL_014f: conv.i4
		IL_0150: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_0155: ldloc.0
		IL_0156: ret
	} // end of method Arrays::Concatenate

	.method public hidebysig static 
		uint8[] ConcatenateAll (
			uint8[][] vs
		) cil managed 
	{
		.param [1]
			.custom instance void [mscorlib]System.ParamArrayAttribute::.ctor() = (
				01 00 00 00
			)
		// Method begins at RVA 0x5704
		// Header size: 12
		// Code size: 667 (0x29b)
		.maxstack 5
		.locals init (
			[0] uint8[][],
			[1] int32,
			[2] int32,
			[3] uint8[],
			[4] int32,
			[5] int32,
			[6] uint8[],
			[7] int32,
			[8] uint8[],
			[9] int32,
			[10] int16
		)

		IL_0000: ldc.i4 1568735232
		IL_0005: nop
		IL_0006: stloc 10
		IL_000a: ldloca 10
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: stloc.s 9
		IL_0013: ldloc.s 9
		IL_0015: switch (IL_001e)

		IL_001e: ldc.i4.0
		IL_001f: switch (IL_005b)

		IL_0028: ldloc.s 9
		IL_002a: switch (IL_015b, IL_00e7, IL_0270, IL_01a3, IL_022e, IL_0210, IL_0112, IL_00c4, IL_0294, IL_00a6, IL_0081)

		IL_005b: ldarg.0
		IL_005c: ldlen
		IL_005d: conv.i4
		IL_005e: newarr uint8[]
		IL_0063: stloc.0
		IL_0064: ldc.i4.0
		IL_0065: stloc.1
		IL_0066: ldc.i4.0
		IL_0067: stloc.2
		IL_0068: ldc.i4.0
		IL_0069: stloc.s 5
		IL_006b: ldc.i4 1835073546
		IL_0070: stloc 10
		IL_0074: nop
		IL_0075: ldloca 10
		IL_0079: nop
		IL_007a: ldind.i2
		IL_007b: conv.i2
		IL_007c: conv.i
		IL_007d: stloc.s 9
		IL_007f: br.s IL_0028

		IL_0081: br.s IL_00ab

		IL_0083: ldloc.2
		IL_0084: newarr [mscorlib]System.Byte
		IL_0089: stloc.3
		IL_008a: ldc.i4.0
		IL_008b: stloc.s 4
		IL_008d: ldc.i4.0
		IL_008e: stloc.s 7
		IL_0090: ldc.i4 1265893385
		IL_0095: nop
		IL_0096: stloc 10
		IL_009a: ldloca 10
		IL_009e: nop
		IL_009f: ldind.i2
		IL_00a0: conv.i2
		IL_00a1: conv.i
		IL_00a2: stloc.s 9
		IL_00a4: br.s IL_0028

		IL_00a6: br IL_0142

		IL_00ab: ldc.i4 259784711
		IL_00b0: stloc 10
		IL_00b4: nop
		IL_00b5: ldloca 10
		IL_00b9: nop
		IL_00ba: ldind.i2
		IL_00bb: conv.i2
		IL_00bc: conv.i
		IL_00bd: stloc.s 9
		IL_00bf: br IL_0028

		IL_00c4: ldloc.s 5
		IL_00c6: ldarg.0
		IL_00c7: ldlen
		IL_00c8: conv.i4
		IL_00c9: blt IL_01f2

		IL_00ce: ldc.i4 466485249
		IL_00d3: nop
		IL_00d4: stloc 10
		IL_00d8: nop
		IL_00d9: ldloca 10
		IL_00dd: ldind.i2
		IL_00de: conv.i2
		IL_00df: conv.i
		IL_00e0: stloc.s 9
		IL_00e2: br IL_0028

		IL_00e7: br.s IL_0083

		IL_00e9: ldloc.0
		IL_00ea: ldloc.1
		IL_00eb: dup
		IL_00ec: ldc.i4.1
		IL_00ed: add
		IL_00ee: stloc.1
		IL_00ef: ldloc.s 6
		IL_00f1: stelem.ref
		IL_00f2: ldloc.2
		IL_00f3: ldloc.s 6
		IL_00f5: ldlen
		IL_00f6: conv.i4
		IL_00f7: add
		IL_00f8: stloc.2
		IL_00f9: ldc.i4 532611078
		IL_00fe: stloc 10
		IL_0102: nop
		IL_0103: ldloca 10
		IL_0107: nop
		IL_0108: ldind.i2
		IL_0109: conv.i2
		IL_010a: conv.i
		IL_010b: stloc.s 9
		IL_010d: br IL_0028

		IL_0112: br.s IL_0129

		IL_0114: ldc.i4 1375797248
		IL_0119: nop
		IL_011a: stloc 10
		IL_011e: nop
		IL_011f: ldloca 10
		IL_0123: nop
		IL_0124: ldind.i2
		IL_0125: conv.i2

		IL_0126: pop
		IL_0127: br.s IL_013c

		IL_0129: ldc.i4 1111883776
		IL_012e: stloc 10
		IL_0132: nop
		IL_0133: ldloca 10
		IL_0137: nop
		IL_0138: ldind.i2
		IL_0139: conv.i2
		IL_013a: br.s IL_0126

		IL_013c: nop
		IL_013d: br IL_0275

		IL_0142: ldc.i4 116195328
		IL_0147: stloc 10
		IL_014b: nop
		IL_014c: ldloca 10
		IL_0150: nop
		IL_0151: ldind.i2
		IL_0152: conv.i2
		IL_0153: conv.i
		IL_0154: stloc.s 9
		IL_0156: br IL_0028

		IL_015b: ldc.i4 493682689
		IL_0160: stloc 10
		IL_0164: nop
		IL_0165: ldloca 10
		IL_0169: ldind.i2
		IL_016a: conv.i2
		IL_016b: br.s IL_0181

		IL_016d: ldc.i4 303038464
		IL_0172: nop
		IL_0173: stloc 10
		IL_0177: nop
		IL_0178: ldloca 10
		IL_017c: nop
		IL_017d: ldind.i2
		IL_017e: conv.i2
		IL_017f: br.s IL_0181

		IL_0181: brfalse.s IL_0183

		IL_0183: ldloc.s 7
		IL_0185: ldloc.1
		IL_0186: blt IL_0233

		IL_018b: ldc.i4 789708803
		IL_0190: nop
		IL_0191: stloc 10
		IL_0195: ldloca 10
		IL_0199: ldind.i2
		IL_019a: conv.i2
		IL_019b: conv.i
		IL_019c: stloc.s 9
		IL_019e: br IL_0028

		IL_01a3: ldc.i4 1948590924
		IL_01a8: stloc 10
		IL_01ac: ldloca 10
		IL_01b0: nop
		IL_01b1: ldind.i2
		IL_01b2: conv.i2
		IL_01b3: ldc.i4 1311712076
		IL_01b8: nop
		IL_01b9: stloc 10
		IL_01bd: ldloca 10
		IL_01c1: ldind.i2
		IL_01c2: conv.i2
		IL_01c3: ceq
		IL_01c5: switch (IL_0275, IL_01d7, IL_0275)

		IL_01d6: nop

		IL_01d7: ldc.i4 467533824
		IL_01dc: stloc 10
		IL_01e0: nop
		IL_01e1: ldloca 10
		IL_01e5: nop
		IL_01e6: ldind.i2
		IL_01e7: conv.i2
		IL_01e8: brfalse IL_01ed

		IL_01ed: br IL_0299

		IL_01f2: ldarg.0
		IL_01f3: ldloc.s 5
		IL_01f5: ldelem.ref
		IL_01f6: stloc.s 6
		IL_01f8: ldc.i4 1875378181
		IL_01fd: nop
		IL_01fe: stloc 10
		IL_0202: ldloca 10
		IL_0206: ldind.i2
		IL_0207: conv.i2
		IL_0208: conv.i
		IL_0209: stloc.s 9
		IL_020b: br IL_0028

		IL_0210: ldloc.s 6
		IL_0212: brfalse.s IL_0275

		IL_0214: ldc.i4 1463287812
		IL_0219: nop
		IL_021a: stloc 10
		IL_021e: nop
		IL_021f: ldloca 10
		IL_0223: nop
		IL_0224: ldind.i2
		IL_0225: conv.i2
		IL_0226: conv.i
		IL_0227: stloc.s 9
		IL_0229: br IL_0028

		IL_022e: br IL_00e9

		IL_0233: ldloc.0
		IL_0234: ldloc.s 7
		IL_0236: ldelem.ref
		IL_0237: stloc.s 8
		IL_0239: ldloc.s 8
		IL_023b: ldc.i4.0
		IL_023c: ldloc.3
		IL_023d: ldloc.s 4
		IL_023f: ldloc.s 8
		IL_0241: ldlen
		IL_0242: conv.i4
		IL_0243: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_0248: ldloc.s 4
		IL_024a: ldloc.s 8
		IL_024c: ldlen
		IL_024d: conv.i4
		IL_024e: add
		IL_024f: stloc.s 4
		IL_0251: ldloc.s 7
		IL_0253: ldc.i4.1
		IL_0254: add
		IL_0255: stloc.s 7
		IL_0257: ldc.i4 655622146
		IL_025c: stloc 10
		IL_0260: nop
		IL_0261: ldloca 10
		IL_0265: nop
		IL_0266: ldind.i2
		IL_0267: conv.i2
		IL_0268: conv.i
		IL_0269: stloc.s 9
		IL_026b: br IL_0028

		IL_0270: br IL_0142

		IL_0275: ldloc.s 5
		IL_0277: ldc.i4.1
		IL_0278: add
		IL_0279: stloc.s 5
		IL_027b: ldc.i4 14155784
		IL_0280: nop
		IL_0281: stloc 10
		IL_0285: ldloca 10
		IL_0289: nop
		IL_028a: ldind.i2
		IL_028b: conv.i2
		IL_028c: conv.i
		IL_028d: stloc.s 9
		IL_028f: br IL_0028

		IL_0294: br IL_00ab

		IL_0299: ldloc.3
		IL_029a: ret
	} // end of method Arrays::ConcatenateAll

	.method public hidebysig static 
		int32[] Concatenate (
			int32[] a,
			int32[] b
		) cil managed 
	{
		// Method begins at RVA 0x59ac
		// Header size: 12
		// Code size: 342 (0x156)
		.maxstack 5
		.locals init (
			[0] int32[],
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4 897974275
		IL_0005: stloc 2
		IL_0009: ldloca 2
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: conv.i
		IL_0011: stloc.1
		IL_0012: br.s IL_001e
		// loop start (head: IL_001e)
			IL_0014: ldc.i4.0
			IL_0015: switch (IL_0034)

			IL_001e: ldloc.1
			IL_001f: switch (IL_004b, IL_0107, IL_0121, IL_0014)
		// end loop

		IL_0034: ldarg.0
		IL_0035: brtrue.s IL_007d

		IL_0037: ldc.i4 1885274112
		IL_003c: nop
		IL_003d: stloc 2
		IL_0041: ldloca 2
		IL_0045: ldind.i2
		IL_0046: conv.i2
		IL_0047: conv.i
		IL_0048: stloc.1
		IL_0049: br.s IL_001e

		IL_004b: br IL_0126

		IL_0050: ldc.i4 941293569
		IL_0055: stloc 2
		IL_0059: nop
		IL_005a: ldloca 2
		IL_005e: ldind.i2
		IL_005f: conv.i2
		IL_0060: br.s IL_0074

		IL_0062: ldc.i4 287178752
		IL_0067: stloc 2
		IL_006b: ldloca 2
		IL_006f: nop
		IL_0070: ldind.i2
		IL_0071: conv.i2
		IL_0072: br.s IL_0074

		IL_0074: brfalse.s IL_0076

		IL_0076: ldarg.0
		IL_0077: call int32[] ODCrypt.Arrays::Clone(int32[])
		IL_007c: ret

		IL_007d: ldc.i4 380637604
		IL_0082: stloc 2
		IL_0086: nop
		IL_0087: ldloca 2
		IL_008b: nop
		IL_008c: ldind.i2
		IL_008d: conv.i2
		IL_008e: ldc.i4 581112228
		IL_0093: nop
		IL_0094: stloc 2
		IL_0098: ldloca 2
		IL_009c: nop
		IL_009d: ldind.i2
		IL_009e: conv.i2
		IL_009f: ceq
		IL_00a1: switch (IL_0037, IL_00b3, IL_0037)

		IL_00b2: nop

		IL_00b3: ldc.i4 783351808
		IL_00b8: stloc 2
		IL_00bc: nop
		IL_00bd: ldloca 2
		IL_00c1: ldind.i2
		IL_00c2: conv.i2
		IL_00c3: brfalse IL_00c8

		IL_00c8: br.s IL_00dd

		IL_00ca: ldc.i4 2123497472
		IL_00cf: stloc 2
		IL_00d3: ldloca 2
		IL_00d7: nop
		IL_00d8: ldind.i2
		IL_00d9: conv.i2

		IL_00da: pop
		IL_00db: br.s IL_00ef

		IL_00dd: ldc.i4 591724544
		IL_00e2: nop
		IL_00e3: stloc 2
		IL_00e7: ldloca 2
		IL_00eb: ldind.i2
		IL_00ec: conv.i2
		IL_00ed: br.s IL_00da

		IL_00ef: nop
		IL_00f0: ldc.i4 1986723841
		IL_00f5: stloc 2
		IL_00f9: nop
		IL_00fa: ldloca 2
		IL_00fe: ldind.i2
		IL_00ff: conv.i2
		IL_0100: conv.i
		IL_0101: stloc.1
		IL_0102: br IL_001e

		IL_0107: ldarg.1
		IL_0108: brtrue.s IL_012d

		IL_010a: ldc.i4 13631490
		IL_010f: nop
		IL_0110: stloc 2
		IL_0114: ldloca 2
		IL_0118: ldind.i2
		IL_0119: conv.i2
		IL_011a: conv.i
		IL_011b: stloc.1
		IL_011c: br IL_001e

		IL_0121: br IL_0050

		IL_0126: ldarg.1
		IL_0127: call int32[] ODCrypt.Arrays::Clone(int32[])
		IL_012c: ret

		IL_012d: ldarg.0
		IL_012e: ldlen
		IL_012f: conv.i4
		IL_0130: ldarg.1
		IL_0131: ldlen
		IL_0132: conv.i4
		IL_0133: add
		IL_0134: newarr [mscorlib]System.Int32
		IL_0139: stloc.0
		IL_013a: ldarg.0
		IL_013b: ldc.i4.0
		IL_013c: ldloc.0
		IL_013d: ldc.i4.0
		IL_013e: ldarg.0
		IL_013f: ldlen
		IL_0140: conv.i4
		IL_0141: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_0146: ldarg.1
		IL_0147: ldc.i4.0
		IL_0148: ldloc.0
		IL_0149: ldarg.0
		IL_014a: ldlen
		IL_014b: conv.i4
		IL_014c: ldarg.1
		IL_014d: ldlen
		IL_014e: conv.i4
		IL_014f: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_0154: ldloc.0
		IL_0155: ret
	} // end of method Arrays::Concatenate

	.method public hidebysig static 
		uint8[] Prepend (
			uint8[] a,
			uint8 b
		) cil managed 
	{
		// Method begins at RVA 0x5b10
		// Header size: 12
		// Code size: 205 (0xcd)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] uint8[],
			[2] int16
		)

		IL_0000: ldarg.0
		IL_0001: brtrue IL_00b0

		IL_0006: ldc.i4 1831770793
		IL_000b: stloc 2
		IL_000f: ldloca 2
		IL_0013: nop
		IL_0014: ldind.i2
		IL_0015: conv.i2
		IL_0016: ldc.i4 625842857
		IL_001b: nop
		IL_001c: stloc 2
		IL_0020: nop
		IL_0021: ldloca 2
		IL_0025: ldind.i2
		IL_0026: conv.i2
		IL_0027: ceq
		IL_0029: switch (IL_00a5, IL_003b, IL_00a5)

		IL_003a: nop

		IL_003b: br.s IL_0051

		IL_003d: ldc.i4 776077312
		IL_0042: nop
		IL_0043: stloc 2
		IL_0047: nop
		IL_0048: ldloca 2
		IL_004c: ldind.i2
		IL_004d: conv.i2

		IL_004e: pop
		IL_004f: br.s IL_0064

		IL_0051: ldc.i4 1563033600
		IL_0056: nop
		IL_0057: stloc 2
		IL_005b: ldloca 2
		IL_005f: nop
		IL_0060: ldind.i2
		IL_0061: conv.i2
		IL_0062: br.s IL_004e

		IL_0064: nop
		IL_0065: ldc.i4 94896129
		IL_006a: nop
		IL_006b: stloc 2
		IL_006f: nop
		IL_0070: ldloca 2
		IL_0074: ldind.i2
		IL_0075: conv.i2
		IL_0076: br.s IL_008c

		IL_0078: ldc.i4 661127168
		IL_007d: nop
		IL_007e: stloc 2
		IL_0082: nop
		IL_0083: ldloca 2
		IL_0087: nop
		IL_0088: ldind.i2
		IL_0089: conv.i2
		IL_008a: br.s IL_008c

		IL_008c: brfalse.s IL_008e

		IL_008e: ldc.i4 1397751808
		IL_0093: stloc 2
		IL_0097: ldloca 2
		IL_009b: nop
		IL_009c: ldind.i2
		IL_009d: conv.i2
		IL_009e: brfalse IL_00a3

		IL_00a3: br.s IL_00a5

		IL_00a5: ldc.i4.1
		IL_00a6: newarr [mscorlib]System.Byte
		IL_00ab: dup
		IL_00ac: ldc.i4.0
		IL_00ad: ldarg.1
		IL_00ae: stelem.i1
		IL_00af: ret

		IL_00b0: ldarg.0
		IL_00b1: ldlen
		IL_00b2: conv.i4
		IL_00b3: stloc.0
		IL_00b4: ldloc.0
		IL_00b5: ldc.i4.1
		IL_00b6: add
		IL_00b7: newarr [mscorlib]System.Byte
		IL_00bc: stloc.1
		IL_00bd: ldarg.0
		IL_00be: ldc.i4.0
		IL_00bf: ldloc.1
		IL_00c0: ldc.i4.1
		IL_00c1: ldloc.0
		IL_00c2: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00c7: ldloc.1
		IL_00c8: ldc.i4.0
		IL_00c9: ldarg.1
		IL_00ca: stelem.i1
		IL_00cb: ldloc.1
		IL_00cc: ret
	} // end of method Arrays::Prepend

	.method public hidebysig static 
		int16[] Prepend (
			int16[] a,
			int16 b
		) cil managed 
	{
		// Method begins at RVA 0x5bec
		// Header size: 12
		// Code size: 203 (0xcb)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] int16[],
			[2] int16
		)

		IL_0000: ldarg.0
		IL_0001: brtrue IL_00ae

		IL_0006: ldc.i4 928645121
		IL_000b: stloc 2
		IL_000f: nop
		IL_0010: ldloca 2
		IL_0014: ldind.i2
		IL_0015: conv.i2
		IL_0016: br.s IL_002a

		IL_0018: ldc.i4 2125529088
		IL_001d: stloc 2
		IL_0021: nop
		IL_0022: ldloca 2
		IL_0026: ldind.i2
		IL_0027: conv.i2
		IL_0028: br.s IL_002a

		IL_002a: brfalse.s IL_002c

		IL_002c: ldc.i4 865892163
		IL_0031: stloc 2
		IL_0035: ldloca 2
		IL_0039: nop
		IL_003a: ldind.i2
		IL_003b: conv.i2
		IL_003c: ldc.i4 1534228291
		IL_0041: stloc 2
		IL_0045: nop
		IL_0046: ldloca 2
		IL_004a: nop
		IL_004b: ldind.i2
		IL_004c: conv.i2
		IL_004d: ceq
		IL_004f: switch (IL_00a3, IL_008b, IL_00a3)

		IL_0060: br.s IL_0077

		IL_0062: ldc.i4 479002624
		IL_0067: nop
		IL_0068: stloc 2
		IL_006c: nop
		IL_006d: ldloca 2
		IL_0071: nop
		IL_0072: ldind.i2
		IL_0073: conv.i2

		IL_0074: pop
		IL_0075: br.s IL_0089

		IL_0077: ldc.i4 566755328
		IL_007c: stloc 2
		IL_0080: nop
		IL_0081: ldloca 2
		IL_0085: ldind.i2
		IL_0086: conv.i2
		IL_0087: br.s IL_0074

		IL_0089: nop
		IL_008a: nop

		IL_008b: ldc.i4 97124352
		IL_0090: stloc 2
		IL_0094: nop
		IL_0095: ldloca 2
		IL_0099: nop
		IL_009a: ldind.i2
		IL_009b: conv.i2
		IL_009c: brfalse IL_00a1

		IL_00a1: br.s IL_00a3

		IL_00a3: ldc.i4.1
		IL_00a4: newarr [mscorlib]System.Int16
		IL_00a9: dup
		IL_00aa: ldc.i4.0
		IL_00ab: ldarg.1
		IL_00ac: stelem.i2
		IL_00ad: ret

		IL_00ae: ldarg.0
		IL_00af: ldlen
		IL_00b0: conv.i4
		IL_00b1: stloc.0
		IL_00b2: ldloc.0
		IL_00b3: ldc.i4.1
		IL_00b4: add
		IL_00b5: newarr [mscorlib]System.Int16
		IL_00ba: stloc.1
		IL_00bb: ldarg.0
		IL_00bc: ldc.i4.0
		IL_00bd: ldloc.1
		IL_00be: ldc.i4.1
		IL_00bf: ldloc.0
		IL_00c0: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00c5: ldloc.1
		IL_00c6: ldc.i4.0
		IL_00c7: ldarg.1
		IL_00c8: stelem.i2
		IL_00c9: ldloc.1
		IL_00ca: ret
	} // end of method Arrays::Prepend

	.method public hidebysig static 
		int32[] Prepend (
			int32[] a,
			int32 b
		) cil managed 
	{
		// Method begins at RVA 0x5cc4
		// Header size: 12
		// Code size: 204 (0xcc)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] int32[],
			[2] int16
		)

		IL_0000: ldarg.0
		IL_0001: brtrue IL_00af

		IL_0006: ldc.i4 892909355
		IL_000b: stloc 2
		IL_000f: nop
		IL_0010: ldloca 2
		IL_0014: nop
		IL_0015: ldind.i2
		IL_0016: conv.i2
		IL_0017: ldc.i4 824031019
		IL_001c: nop
		IL_001d: stloc 2
		IL_0021: nop
		IL_0022: ldloca 2
		IL_0026: ldind.i2
		IL_0027: conv.i2
		IL_0028: ceq
		IL_002a: switch (IL_00a4, IL_003c, IL_00a4)

		IL_003b: nop

		IL_003c: br.s IL_0051

		IL_003e: ldc.i4 1730347008
		IL_0043: nop
		IL_0044: stloc 2
		IL_0048: ldloca 2
		IL_004c: ldind.i2
		IL_004d: conv.i2

		IL_004e: pop
		IL_004f: br.s IL_0065

		IL_0051: ldc.i4 63438848
		IL_0056: nop
		IL_0057: stloc 2
		IL_005b: nop
		IL_005c: ldloca 2
		IL_0060: nop
		IL_0061: ldind.i2
		IL_0062: conv.i2
		IL_0063: br.s IL_004e

		IL_0065: nop
		IL_0066: ldc.i4 1520828417
		IL_006b: stloc 2
		IL_006f: ldloca 2
		IL_0073: nop
		IL_0074: ldind.i2
		IL_0075: conv.i2
		IL_0076: br.s IL_008b

		IL_0078: ldc.i4 1336737792
		IL_007d: nop
		IL_007e: stloc 2
		IL_0082: ldloca 2
		IL_0086: nop
		IL_0087: ldind.i2
		IL_0088: conv.i2
		IL_0089: br.s IL_008b

		IL_008b: brfalse.s IL_008d

		IL_008d: ldc.i4 1380450304
		IL_0092: stloc 2
		IL_0096: ldloca 2
		IL_009a: nop
		IL_009b: ldind.i2
		IL_009c: conv.i2
		IL_009d: brfalse IL_00a2

		IL_00a2: br.s IL_00a4

		IL_00a4: ldc.i4.1
		IL_00a5: newarr [mscorlib]System.Int32
		IL_00aa: dup
		IL_00ab: ldc.i4.0
		IL_00ac: ldarg.1
		IL_00ad: stelem.i4
		IL_00ae: ret

		IL_00af: ldarg.0
		IL_00b0: ldlen
		IL_00b1: conv.i4
		IL_00b2: stloc.0
		IL_00b3: ldloc.0
		IL_00b4: ldc.i4.1
		IL_00b5: add
		IL_00b6: newarr [mscorlib]System.Int32
		IL_00bb: stloc.1
		IL_00bc: ldarg.0
		IL_00bd: ldc.i4.0
		IL_00be: ldloc.1
		IL_00bf: ldc.i4.1
		IL_00c0: ldloc.0
		IL_00c1: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00c6: ldloc.1
		IL_00c7: ldc.i4.0
		IL_00c8: ldarg.1
		IL_00c9: stelem.i4
		IL_00ca: ldloc.1
		IL_00cb: ret
	} // end of method Arrays::Prepend

	.method public hidebysig static 
		uint8[] Reverse (
			uint8[] a
		) cil managed 
	{
		// Method begins at RVA 0x5d9c
		// Header size: 12
		// Code size: 387 (0x183)
		.maxstack 6
		.locals init (
			[0] int32,
			[1] int32,
			[2] uint8[],
			[3] int32,
			[4] int16
		)

		IL_0000: ldc.i4 405536773
		IL_0005: nop
		IL_0006: stloc 4
		IL_000a: ldloca 4
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: conv.i
		IL_0012: stloc.3
		IL_0013: br.s IL_001f
		// loop start (head: IL_001f)
			IL_0015: ldc.i4.0
			IL_0016: switch (IL_003d)

			IL_001f: ldloc.3
			IL_0020: switch (IL_00ca, IL_00a7, IL_0119, IL_015c, IL_017f, IL_0015)
		// end loop

		IL_003d: ldarg.0
		IL_003e: brtrue IL_00f4

		IL_0043: ldc.i4 2077739172
		IL_0048: stloc 4
		IL_004c: ldloca 4
		IL_0050: nop
		IL_0051: ldind.i2
		IL_0052: conv.i2
		IL_0053: ldc.i4 867616932
		IL_0058: stloc 4
		IL_005c: nop
		IL_005d: ldloca 4
		IL_0061: nop
		IL_0062: ldind.i2
		IL_0063: conv.i2
		IL_0064: ceq
		IL_0066: switch (IL_0167, IL_0078, IL_0167)

		IL_0077: nop

		IL_0078: ldc.i4 115343360
		IL_007d: nop
		IL_007e: stloc 4
		IL_0082: ldloca 4
		IL_0086: nop
		IL_0087: ldind.i2
		IL_0088: conv.i2
		IL_0089: brfalse IL_008e

		IL_008e: ldc.i4 690683905
		IL_0093: nop
		IL_0094: stloc 4
		IL_0098: nop
		IL_0099: ldloca 4
		IL_009d: nop
		IL_009e: ldind.i2
		IL_009f: conv.i2
		IL_00a0: conv.i
		IL_00a1: stloc.3
		IL_00a2: br IL_001f

		IL_00a7: br.s IL_011b

		IL_00a9: ldloc.2
		IL_00aa: ldloc.1
		IL_00ab: ldarg.0
		IL_00ac: ldloc.0
		IL_00ad: dup
		IL_00ae: ldc.i4.1
		IL_00af: add
		IL_00b0: stloc.0
		IL_00b1: ldelem.u1
		IL_00b2: stelem.i1
		IL_00b3: ldc.i4 1623392256
		IL_00b8: nop
		IL_00b9: stloc 4
		IL_00bd: ldloca 4
		IL_00c1: ldind.i2
		IL_00c2: conv.i2
		IL_00c3: conv.i
		IL_00c4: stloc.3
		IL_00c5: br IL_001f

		IL_00ca: br.s IL_00df

		IL_00cc: ldc.i4 314048512
		IL_00d1: nop
		IL_00d2: stloc 4
		IL_00d6: ldloca 4
		IL_00da: ldind.i2
		IL_00db: conv.i2

		IL_00dc: pop
		IL_00dd: br.s IL_00f1

		IL_00df: ldc.i4 1034420224
		IL_00e4: stloc 4
		IL_00e8: ldloca 4
		IL_00ec: nop
		IL_00ed: ldind.i2
		IL_00ee: conv.i2
		IL_00ef: br.s IL_00dc

		IL_00f1: nop
		IL_00f2: br.s IL_011d

		IL_00f4: ldc.i4.0
		IL_00f5: stloc.0
		IL_00f6: ldarg.0
		IL_00f7: ldlen
		IL_00f8: conv.i4
		IL_00f9: stloc.1
		IL_00fa: ldloc.1
		IL_00fb: newarr [mscorlib]System.Byte
		IL_0100: stloc.2
		IL_0101: ldc.i4 1113194498
		IL_0106: stloc 4
		IL_010a: nop
		IL_010b: ldloca 4
		IL_010f: nop
		IL_0110: ldind.i2
		IL_0111: conv.i2
		IL_0112: conv.i
		IL_0113: stloc.3
		IL_0114: br IL_001f

		IL_0119: br.s IL_011d

		IL_011b: ldnull
		IL_011c: ret

		IL_011d: ldc.i4 1890516993
		IL_0122: nop
		IL_0123: stloc 4
		IL_0127: ldloca 4
		IL_012b: nop
		IL_012c: ldind.i2
		IL_012d: conv.i2
		IL_012e: br.s IL_0142

		IL_0130: ldc.i4 1045102592
		IL_0135: nop
		IL_0136: stloc 4
		IL_013a: ldloca 4
		IL_013e: ldind.i2
		IL_013f: conv.i2
		IL_0140: br.s IL_0142

		IL_0142: brfalse.s IL_0144

		IL_0144: ldc.i4 1758003203
		IL_0149: nop
		IL_014a: stloc 4
		IL_014e: ldloca 4
		IL_0152: nop
		IL_0153: ldind.i2
		IL_0154: conv.i2
		IL_0155: conv.i
		IL_0156: stloc.3
		IL_0157: br IL_001f

		IL_015c: ldloc.1
		IL_015d: ldc.i4.1
		IL_015e: sub
		IL_015f: dup
		IL_0160: stloc.1
		IL_0161: ldc.i4.0
		IL_0162: bge IL_00a9

		IL_0167: ldc.i4 2071920644
		IL_016c: nop
		IL_016d: stloc 4
		IL_0171: nop
		IL_0172: ldloca 4
		IL_0176: ldind.i2
		IL_0177: conv.i2
		IL_0178: conv.i
		IL_0179: stloc.3
		IL_017a: br IL_001f

		IL_017f: br.s IL_0181

		IL_0181: ldloc.2
		IL_0182: ret
	} // end of method Arrays::Reverse

	.method public hidebysig static 
		int32[] Reverse (
			int32[] a
		) cil managed 
	{
		// Method begins at RVA 0x5f2c
		// Header size: 12
		// Code size: 383 (0x17f)
		.maxstack 6
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32[],
			[3] int32,
			[4] int16
		)

		IL_0000: ldc.i4 1515847681
		IL_0005: nop
		IL_0006: stloc 4
		IL_000a: ldloca 4
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: conv.i
		IL_0011: stloc.3
		IL_0012: br.s IL_001e
		// loop start (head: IL_001e)
			IL_0014: ldc.i4.0
			IL_0015: switch (IL_003c)

			IL_001e: ldloc.3
			IL_001f: switch (IL_0115, IL_0014, IL_00a2, IL_0132, IL_00c5, IL_017b)
		// end loop

		IL_003c: ldarg.0
		IL_003d: brtrue IL_00f0

		IL_0042: ldc.i4 659937498
		IL_0047: nop
		IL_0048: stloc 4
		IL_004c: ldloca 4
		IL_0050: ldind.i2
		IL_0051: conv.i2
		IL_0052: ldc.i4 1996085466
		IL_0057: stloc 4
		IL_005b: ldloca 4
		IL_005f: nop
		IL_0060: ldind.i2
		IL_0061: conv.i2
		IL_0062: ceq
		IL_0064: switch (IL_013d, IL_0076, IL_013d)

		IL_0075: nop

		IL_0076: ldc.i4 2028077056
		IL_007b: stloc 4
		IL_007f: ldloca 4
		IL_0083: nop
		IL_0084: ldind.i2
		IL_0085: conv.i2
		IL_0086: brfalse IL_008b

		IL_008b: ldc.i4 599195650
		IL_0090: stloc 4
		IL_0094: ldloca 4
		IL_0098: nop
		IL_0099: ldind.i2
		IL_009a: conv.i2
		IL_009b: conv.i
		IL_009c: stloc.3
		IL_009d: br IL_001e

		IL_00a2: br.s IL_0117

		IL_00a4: ldloc.2
		IL_00a5: ldloc.1
		IL_00a6: ldarg.0
		IL_00a7: ldloc.0
		IL_00a8: dup
		IL_00a9: ldc.i4.1
		IL_00aa: add
		IL_00ab: stloc.0
		IL_00ac: ldelem.i4
		IL_00ad: stelem.i4
		IL_00ae: ldc.i4 453574660
		IL_00b3: nop
		IL_00b4: stloc 4
		IL_00b8: ldloca 4
		IL_00bc: ldind.i2
		IL_00bd: conv.i2
		IL_00be: conv.i
		IL_00bf: stloc.3
		IL_00c0: br IL_001e

		IL_00c5: br.s IL_00da

		IL_00c7: ldc.i4 1207762944
		IL_00cc: stloc 4
		IL_00d0: nop
		IL_00d1: ldloca 4
		IL_00d5: ldind.i2
		IL_00d6: conv.i2

		IL_00d7: pop
		IL_00d8: br.s IL_00ed

		IL_00da: ldc.i4 345440256
		IL_00df: stloc 4
		IL_00e3: nop
		IL_00e4: ldloca 4
		IL_00e8: nop
		IL_00e9: ldind.i2
		IL_00ea: conv.i2
		IL_00eb: br.s IL_00d7

		IL_00ed: nop
		IL_00ee: br.s IL_0119

		IL_00f0: ldc.i4.0
		IL_00f1: stloc.0
		IL_00f2: ldarg.0
		IL_00f3: ldlen
		IL_00f4: conv.i4
		IL_00f5: stloc.1
		IL_00f6: ldloc.1
		IL_00f7: newarr [mscorlib]System.Int32
		IL_00fc: stloc.2
		IL_00fd: ldc.i4 423821312
		IL_0102: nop
		IL_0103: stloc 4
		IL_0107: nop
		IL_0108: ldloca 4
		IL_010c: ldind.i2
		IL_010d: conv.i2
		IL_010e: conv.i
		IL_010f: stloc.3
		IL_0110: br IL_001e

		IL_0115: br.s IL_0119

		IL_0117: ldnull
		IL_0118: ret

		IL_0119: ldc.i4 1624571907
		IL_011e: nop
		IL_011f: stloc 4
		IL_0123: nop
		IL_0124: ldloca 4
		IL_0128: nop
		IL_0129: ldind.i2
		IL_012a: conv.i2
		IL_012b: conv.i
		IL_012c: stloc.3
		IL_012d: br IL_001e

		IL_0132: ldloc.1
		IL_0133: ldc.i4.1
		IL_0134: sub
		IL_0135: dup
		IL_0136: stloc.1
		IL_0137: ldc.i4.0
		IL_0138: bge IL_00a4

		IL_013d: ldc.i4 509607937
		IL_0142: stloc 4
		IL_0146: ldloca 4
		IL_014a: nop
		IL_014b: ldind.i2
		IL_014c: conv.i2
		IL_014d: br.s IL_0161

		IL_014f: ldc.i4 1122762752
		IL_0154: stloc 4
		IL_0158: nop
		IL_0159: ldloca 4
		IL_015d: ldind.i2
		IL_015e: conv.i2
		IL_015f: br.s IL_0161

		IL_0161: brfalse.s IL_0163

		IL_0163: ldc.i4 693043205
		IL_0168: nop
		IL_0169: stloc 4
		IL_016d: nop
		IL_016e: ldloca 4
		IL_0172: ldind.i2
		IL_0173: conv.i2
		IL_0174: conv.i
		IL_0175: stloc.3
		IL_0176: br IL_001e

		IL_017b: br.s IL_017d

		IL_017d: ldloc.2
		IL_017e: ret
	} // end of method Arrays::Reverse

	.method family hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x60b8
		// Header size: 12
		// Code size: 7 (0x7)
		.maxstack 1

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ret
	} // end of method Arrays::.ctor

} // end of class ODCrypt.Arrays

.class private auto ansi sealed beforefieldinit w
	extends [mscorlib]System.Object
{
	// Methods
	.method private hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x60cc
		// Header size: 12
		// Code size: 7 (0x7)
		.maxstack 1

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ret
	} // end of method w::.ctor

	.method assembly hidebysig static 
		void r (
			uint16 A_0,
			uint8[] A_1
		) cil managed 
	{
		// Method begins at RVA 0x60e0
		// Header size: 12
		// Code size: 168 (0xa8)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 585592038
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1133669606
		IL_0016: nop
		IL_0017: stloc 0
		IL_001b: nop
		IL_001c: ldloca 0
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0036, IL_0035)

		IL_0035: nop

		IL_0036: ldc.i4 316866561
		IL_003b: stloc 0
		IL_003f: nop
		IL_0040: ldloca 0
		IL_0044: nop
		IL_0045: ldind.i2
		IL_0046: conv.i2
		IL_0047: br.s IL_005b

		IL_0049: ldc.i4 1233649664
		IL_004e: stloc 0
		IL_0052: ldloca 0
		IL_0056: nop
		IL_0057: ldind.i2
		IL_0058: conv.i2
		IL_0059: br.s IL_005b

		IL_005b: brfalse.s IL_005d

		IL_005d: ldc.i4 627900416
		IL_0062: stloc 0
		IL_0066: ldloca 0
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: brfalse IL_0072

		IL_0072: br.s IL_0087

		IL_0074: ldc.i4 1399848960
		IL_0079: nop
		IL_007a: stloc 0
		IL_007e: ldloca 0
		IL_0082: ldind.i2
		IL_0083: conv.i2

		IL_0084: pop
		IL_0085: br.s IL_009a

		IL_0087: ldc.i4 1186332672
		IL_008c: nop
		IL_008d: stloc 0
		IL_0091: ldloca 0
		IL_0095: nop
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: br.s IL_0084

		IL_009a: nop
		IL_009b: ldarg.1
		IL_009c: ldc.i4.0
		IL_009d: ldarg.0
		IL_009e: ldc.i4.8
		IL_009f: shr
		IL_00a0: conv.u1
		IL_00a1: stelem.i1
		IL_00a2: ldarg.1
		IL_00a3: ldc.i4.1
		IL_00a4: ldarg.0
		IL_00a5: conv.u1
		IL_00a6: stelem.i1
		IL_00a7: ret
	} // end of method w::r

	.method assembly hidebysig static 
		void r (
			uint16 A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x6194
		// Header size: 12
		// Code size: 172 (0xac)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 415254403
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 220809091
		IL_0016: stloc 0
		IL_001a: ldloca 0
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 585695232
		IL_003a: nop
		IL_003b: stloc 0
		IL_003f: ldloca 0
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: brfalse IL_004b

		IL_004b: ldc.i4 1285357569
		IL_0050: nop
		IL_0051: stloc 0
		IL_0055: nop
		IL_0056: ldloca 0
		IL_005a: ldind.i2
		IL_005b: conv.i2
		IL_005c: br.s IL_0070

		IL_005e: ldc.i4 379191296
		IL_0063: nop
		IL_0064: stloc 0
		IL_0068: ldloca 0
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: br.s IL_0070

		IL_0070: brfalse.s IL_0072

		IL_0072: br.s IL_0088

		IL_0074: ldc.i4 1416232960
		IL_0079: nop
		IL_007a: stloc 0
		IL_007e: ldloca 0
		IL_0082: nop
		IL_0083: ldind.i2
		IL_0084: conv.i2

		IL_0085: pop
		IL_0086: br.s IL_009c

		IL_0088: ldc.i4 2064908288
		IL_008d: nop
		IL_008e: stloc 0
		IL_0092: nop
		IL_0093: ldloca 0
		IL_0097: nop
		IL_0098: ldind.i2
		IL_0099: conv.i2
		IL_009a: br.s IL_0085

		IL_009c: nop
		IL_009d: ldarg.1
		IL_009e: ldarg.2
		IL_009f: ldarg.0
		IL_00a0: ldc.i4.8
		IL_00a1: shr
		IL_00a2: conv.u1
		IL_00a3: stelem.i1
		IL_00a4: ldarg.1
		IL_00a5: ldarg.2
		IL_00a6: ldc.i4.1
		IL_00a7: add
		IL_00a8: ldarg.0
		IL_00a9: conv.u1
		IL_00aa: stelem.i1
		IL_00ab: ret
	} // end of method w::r

	.method assembly hidebysig static 
		uint16 x (
			uint8[] A_0
		) cil managed 
	{
		// Method begins at RVA 0x624c
		// Header size: 12
		// Code size: 168 (0xa8)
		.maxstack 3
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1032745320
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 622621032
		IL_0017: stloc 0
		IL_001b: nop
		IL_001c: ldloca 0
		IL_0020: nop
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: ceq
		IL_0025: switch (IL_0036, IL_0037, IL_0036)

		IL_0036: nop

		IL_0037: ldc.i4 579600385
		IL_003c: nop
		IL_003d: stloc 0
		IL_0041: nop
		IL_0042: ldloca 0
		IL_0046: nop
		IL_0047: ldind.i2
		IL_0048: conv.i2
		IL_0049: br.s IL_005d

		IL_004b: ldc.i4 1577648128
		IL_0050: stloc 0
		IL_0054: ldloca 0
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_005d

		IL_005d: brfalse.s IL_005f

		IL_005f: ldc.i4 795344896
		IL_0064: stloc 0
		IL_0068: nop
		IL_0069: ldloca 0
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: brfalse IL_0074

		IL_0074: br.s IL_008a

		IL_0076: ldc.i4 93782016
		IL_007b: stloc 0
		IL_007f: nop
		IL_0080: ldloca 0
		IL_0084: nop
		IL_0085: ldind.i2
		IL_0086: conv.i2

		IL_0087: pop
		IL_0088: br.s IL_009c

		IL_008a: ldc.i4 1220476928
		IL_008f: stloc 0
		IL_0093: nop
		IL_0094: ldloca 0
		IL_0098: ldind.i2
		IL_0099: conv.i2
		IL_009a: br.s IL_0087

		IL_009c: nop
		IL_009d: ldarg.0
		IL_009e: ldc.i4.0
		IL_009f: ldelem.u1
		IL_00a0: ldc.i4.8
		IL_00a1: shl
		IL_00a2: ldarg.0
		IL_00a3: ldc.i4.1
		IL_00a4: ldelem.u1
		IL_00a5: or
		IL_00a6: conv.u2
		IL_00a7: ret
	} // end of method w::x

	.method assembly hidebysig static 
		uint16 x (
			uint8[] A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0x6300
		// Header size: 12
		// Code size: 169 (0xa9)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 730894489
		IL_0005: stloc 0
		IL_0009: ldloca 0
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 594514073
		IL_0015: stloc 0
		IL_0019: nop
		IL_001a: ldloca 0
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_0034, IL_0033)

		IL_0033: nop

		IL_0034: ldc.i4 1411579905
		IL_0039: nop
		IL_003a: stloc 0
		IL_003e: nop
		IL_003f: ldloca 0
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: br.s IL_005a

		IL_0047: ldc.i4 190185472
		IL_004c: stloc 0
		IL_0050: nop
		IL_0051: ldloca 0
		IL_0055: nop
		IL_0056: ldind.i2
		IL_0057: conv.i2
		IL_0058: br.s IL_005a

		IL_005a: brfalse.s IL_005c

		IL_005c: ldc.i4 1854210048
		IL_0061: nop
		IL_0062: stloc 0
		IL_0066: nop
		IL_0067: ldloca 0
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: brfalse IL_0072

		IL_0072: br.s IL_0088

		IL_0074: ldc.i4 663158784
		IL_0079: nop
		IL_007a: stloc 0
		IL_007e: ldloca 0
		IL_0082: nop
		IL_0083: ldind.i2
		IL_0084: conv.i2

		IL_0085: pop
		IL_0086: br.s IL_009b

		IL_0088: ldc.i4 1169096704
		IL_008d: nop
		IL_008e: stloc 0
		IL_0092: nop
		IL_0093: ldloca 0
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: br.s IL_0085

		IL_009b: nop
		IL_009c: ldarg.0
		IL_009d: ldarg.1
		IL_009e: ldelem.u1
		IL_009f: ldc.i4.8
		IL_00a0: shl
		IL_00a1: ldarg.0
		IL_00a2: ldarg.1
		IL_00a3: ldc.i4.1
		IL_00a4: add
		IL_00a5: ldelem.u1
		IL_00a6: or
		IL_00a7: conv.u2
		IL_00a8: ret
	} // end of method w::x

	.method assembly hidebysig static 
		uint8[] r (
			uint32 A_0
		) cil managed 
	{
		// Method begins at RVA 0x63b8
		// Header size: 12
		// Code size: 171 (0xab)
		.maxstack 3
		.locals init (
			[0] uint8[],
			[1] int16
		)

		IL_0000: ldc.i4 2056165093
		IL_0005: stloc 1
		IL_0009: ldloca 1
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 715691749
		IL_0015: nop
		IL_0016: stloc 1
		IL_001a: ldloca 1
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_0034, IL_0033)

		IL_0033: nop

		IL_0034: ldc.i4 551485441
		IL_0039: stloc 1
		IL_003d: nop
		IL_003e: ldloca 1
		IL_0042: nop
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: br.s IL_0059

		IL_0047: ldc.i4 1519452160
		IL_004c: nop
		IL_004d: stloc 1
		IL_0051: ldloca 1
		IL_0055: ldind.i2
		IL_0056: conv.i2
		IL_0057: br.s IL_0059

		IL_0059: brfalse.s IL_005b

		IL_005b: ldc.i4 1660223488
		IL_0060: stloc 1
		IL_0064: nop
		IL_0065: ldloca 1
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: brfalse IL_0071

		IL_0071: br.s IL_0087

		IL_0073: ldc.i4 795213824
		IL_0078: nop
		IL_0079: stloc 1
		IL_007d: nop
		IL_007e: ldloca 1
		IL_0082: ldind.i2
		IL_0083: conv.i2

		IL_0084: pop
		IL_0085: br.s IL_0099

		IL_0087: ldc.i4 589037568
		IL_008c: stloc 1
		IL_0090: ldloca 1
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: br.s IL_0084

		IL_0099: nop
		IL_009a: ldc.i4.4
		IL_009b: newarr [mscorlib]System.Byte
		IL_00a0: stloc.0
		IL_00a1: ldarg.0
		IL_00a2: ldloc.0
		IL_00a3: ldc.i4.0
		IL_00a4: call void w::r(uint32, uint8[], int32)
		IL_00a9: ldloc.0
		IL_00aa: ret
	} // end of method w::r

	.method assembly hidebysig static 
		void r (
			uint32 A_0,
			uint8[] A_1
		) cil managed 
	{
		// Method begins at RVA 0x6470
		// Header size: 12
		// Code size: 183 (0xb7)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 157825765
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 1956264677
		IL_0017: stloc 0
		IL_001b: ldloca 0
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0036, IL_0035)

		IL_0035: nop

		IL_0036: ldc.i4 1614020608
		IL_003b: nop
		IL_003c: stloc 0
		IL_0040: ldloca 0
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: brfalse IL_004b

		IL_004b: ldc.i4 1323171841
		IL_0050: stloc 0
		IL_0054: ldloca 0
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_006f

		IL_005d: ldc.i4 1133182976
		IL_0062: stloc 0
		IL_0066: nop
		IL_0067: ldloca 0
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: br.s IL_006f

		IL_006f: brfalse.s IL_0071

		IL_0071: br.s IL_0087

		IL_0073: ldc.i4 1265041408
		IL_0078: stloc 0
		IL_007c: nop
		IL_007d: ldloca 0
		IL_0081: nop
		IL_0082: ldind.i2
		IL_0083: conv.i2

		IL_0084: pop
		IL_0085: br.s IL_0099

		IL_0087: ldc.i4 707592192
		IL_008c: stloc 0
		IL_0090: ldloca 0
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: br.s IL_0084

		IL_0099: nop
		IL_009a: ldarg.1
		IL_009b: ldc.i4.0
		IL_009c: ldarg.0
		IL_009d: ldc.i4.s 24
		IL_009f: shr.un
		IL_00a0: conv.u1
		IL_00a1: stelem.i1
		IL_00a2: ldarg.1
		IL_00a3: ldc.i4.1
		IL_00a4: ldarg.0
		IL_00a5: ldc.i4.s 16
		IL_00a7: shr.un
		IL_00a8: conv.u1
		IL_00a9: stelem.i1
		IL_00aa: ldarg.1
		IL_00ab: ldc.i4.2
		IL_00ac: ldarg.0
		IL_00ad: ldc.i4.8
		IL_00ae: shr.un
		IL_00af: conv.u1
		IL_00b0: stelem.i1
		IL_00b1: ldarg.1
		IL_00b2: ldc.i4.3
		IL_00b3: ldarg.0
		IL_00b4: conv.u1
		IL_00b5: stelem.i1
		IL_00b6: ret
	} // end of method w::r

	.method assembly hidebysig static 
		void r (
			uint32 A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x6534
		// Header size: 12
		// Code size: 188 (0xbc)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1410063690
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1128521034
		IL_0016: stloc 0
		IL_001a: ldloca 0
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 1308426241
		IL_003a: stloc 0
		IL_003e: ldloca 0
		IL_0042: nop
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: br.s IL_0059

		IL_0047: ldc.i4 1450246144
		IL_004c: stloc 0
		IL_0050: ldloca 0
		IL_0054: nop
		IL_0055: ldind.i2
		IL_0056: conv.i2
		IL_0057: br.s IL_0059

		IL_0059: brfalse.s IL_005b

		IL_005b: ldc.i4 1085276160
		IL_0060: stloc 0
		IL_0064: nop
		IL_0065: ldloca 0
		IL_0069: ldind.i2
		IL_006a: conv.i2
		IL_006b: brfalse IL_0070

		IL_0070: br.s IL_0086

		IL_0072: ldc.i4 941752320
		IL_0077: nop
		IL_0078: stloc 0
		IL_007c: nop
		IL_007d: ldloca 0
		IL_0081: ldind.i2
		IL_0082: conv.i2

		IL_0083: pop
		IL_0084: br.s IL_0098

		IL_0086: ldc.i4 866058240
		IL_008b: nop
		IL_008c: stloc 0
		IL_0090: ldloca 0
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: br.s IL_0083

		IL_0098: nop
		IL_0099: ldarg.1
		IL_009a: ldarg.2
		IL_009b: ldarg.0
		IL_009c: ldc.i4.s 24
		IL_009e: shr.un
		IL_009f: conv.u1
		IL_00a0: stelem.i1
		IL_00a1: ldarg.1
		IL_00a2: ldarg.2
		IL_00a3: ldc.i4.1
		IL_00a4: add
		IL_00a5: ldarg.0
		IL_00a6: ldc.i4.s 16
		IL_00a8: shr.un
		IL_00a9: conv.u1
		IL_00aa: stelem.i1
		IL_00ab: ldarg.1
		IL_00ac: ldarg.2
		IL_00ad: ldc.i4.2
		IL_00ae: add
		IL_00af: ldarg.0
		IL_00b0: ldc.i4.8
		IL_00b1: shr.un
		IL_00b2: conv.u1
		IL_00b3: stelem.i1
		IL_00b4: ldarg.1
		IL_00b5: ldarg.2
		IL_00b6: ldc.i4.3
		IL_00b7: add
		IL_00b8: ldarg.0
		IL_00b9: conv.u1
		IL_00ba: stelem.i1
		IL_00bb: ret
	} // end of method w::r

	.method assembly hidebysig static 
		uint8[] r (
			uint32[] A_0
		) cil managed 
	{
		// Method begins at RVA 0x65fc
		// Header size: 12
		// Code size: 175 (0xaf)
		.maxstack 3
		.locals init (
			[0] uint8[],
			[1] int16
		)

		IL_0000: ldc.i4 1716569758
		IL_0005: stloc 1
		IL_0009: ldloca 1
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 168806046
		IL_0015: stloc 1
		IL_0019: nop
		IL_001a: ldloca 1
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 493813761
		IL_003a: stloc 1
		IL_003e: ldloca 1
		IL_0042: nop
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: br.s IL_0059

		IL_0047: ldc.i4 589627392
		IL_004c: stloc 1
		IL_0050: nop
		IL_0051: ldloca 1
		IL_0055: ldind.i2
		IL_0056: conv.i2
		IL_0057: br.s IL_0059

		IL_0059: brfalse.s IL_005b

		IL_005b: ldc.i4 1571815424
		IL_0060: nop
		IL_0061: stloc 1
		IL_0065: nop
		IL_0066: ldloca 1
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: brfalse IL_0071

		IL_0071: br.s IL_0086

		IL_0073: ldc.i4 1774583808
		IL_0078: nop
		IL_0079: stloc 1
		IL_007d: ldloca 1
		IL_0081: ldind.i2
		IL_0082: conv.i2

		IL_0083: pop
		IL_0084: br.s IL_0099

		IL_0086: ldc.i4 2125856768
		IL_008b: stloc 1
		IL_008f: nop
		IL_0090: ldloca 1
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: br.s IL_0083

		IL_0099: nop
		IL_009a: ldc.i4.4
		IL_009b: ldarg.0
		IL_009c: ldlen
		IL_009d: conv.i4
		IL_009e: mul
		IL_009f: newarr [mscorlib]System.Byte
		IL_00a4: stloc.0
		IL_00a5: ldarg.0
		IL_00a6: ldloc.0
		IL_00a7: ldc.i4.0
		IL_00a8: call void w::r(uint32[], uint8[], int32)
		IL_00ad: ldloc.0
		IL_00ae: ret
	} // end of method w::r

	.method assembly hidebysig static 
		void r (
			uint32[] A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x66b8
		// Header size: 12
		// Code size: 308 (0x134)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0020)

		IL_000a: ldloc.1
		IL_000b: switch (IL_0068, IL_0036, IL_0094, IL_004c)

		IL_0020: ldc.i4.0
		IL_0021: stloc.0
		IL_0022: ldc.i4 527499265
		IL_0027: stloc 2
		IL_002b: ldloca 2
		IL_002f: nop
		IL_0030: ldind.i2
		IL_0031: conv.i2
		IL_0032: conv.i
		IL_0033: stloc.1
		IL_0034: br.s IL_000a

		IL_0036: br.s IL_0038

		IL_0038: ldc.i4 741343235
		IL_003d: stloc 2
		IL_0041: ldloca 2
		IL_0045: nop
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: conv.i
		IL_0049: stloc.1
		IL_004a: br.s IL_000a

		IL_004c: ldloc.0
		IL_004d: ldarg.0
		IL_004e: ldlen
		IL_004f: conv.i4
		IL_0050: blt.s IL_006a

		IL_0052: ldc.i4 70844416
		IL_0057: nop
		IL_0058: stloc 2
		IL_005c: nop
		IL_005d: ldloca 2
		IL_0061: nop
		IL_0062: ldind.i2
		IL_0063: conv.i2
		IL_0064: conv.i
		IL_0065: stloc.1
		IL_0066: br.s IL_000a

		IL_0068: br.s IL_00c3

		IL_006a: ldarg.0
		IL_006b: ldloc.0
		IL_006c: ldelem.u4
		IL_006d: ldarg.1
		IL_006e: ldarg.2
		IL_006f: call void w::r(uint32, uint8[], int32)
		IL_0074: ldarg.2
		IL_0075: ldc.i4.4
		IL_0076: add
		IL_0077: starg.s A_2
		IL_0079: ldloc.0
		IL_007a: ldc.i4.1
		IL_007b: add
		IL_007c: stloc.0

		IL_007d: ldc.i4 89653250
		IL_0082: stloc 2
		IL_0086: ldloca 2
		IL_008a: nop
		IL_008b: ldind.i2
		IL_008c: conv.i2
		IL_008d: conv.i
		IL_008e: stloc.1
		IL_008f: br IL_000a

		IL_0094: br.s IL_00aa

		IL_0096: ldc.i4 1750401024
		IL_009b: nop
		IL_009c: stloc 2
		IL_00a0: nop
		IL_00a1: ldloca 2
		IL_00a5: ldind.i2
		IL_00a6: conv.i2

		IL_00a7: pop
		IL_00a8: br.s IL_00bd

		IL_00aa: ldc.i4 2094333952
		IL_00af: nop
		IL_00b0: stloc 2
		IL_00b4: ldloca 2
		IL_00b8: nop
		IL_00b9: ldind.i2
		IL_00ba: conv.i2
		IL_00bb: br.s IL_00a7

		IL_00bd: nop
		IL_00be: br IL_0038

		IL_00c3: ldc.i4 1642340307
		IL_00c8: stloc 2
		IL_00cc: nop
		IL_00cd: ldloca 2
		IL_00d1: ldind.i2
		IL_00d2: conv.i2
		IL_00d3: ldc.i4 1427120083
		IL_00d8: stloc 2
		IL_00dc: nop
		IL_00dd: ldloca 2
		IL_00e1: nop
		IL_00e2: ldind.i2
		IL_00e3: conv.i2
		IL_00e4: ceq
		IL_00e6: switch (IL_007d, IL_00f8, IL_007d)

		IL_00f7: nop

		IL_00f8: ldc.i4 2023948289
		IL_00fd: stloc 2
		IL_0101: ldloca 2
		IL_0105: nop
		IL_0106: ldind.i2
		IL_0107: conv.i2
		IL_0108: br.s IL_011c

		IL_010a: ldc.i4 1173749760
		IL_010f: stloc 2
		IL_0113: nop
		IL_0114: ldloca 2
		IL_0118: ldind.i2
		IL_0119: conv.i2
		IL_011a: br.s IL_011c

		IL_011c: brfalse.s IL_011e

		IL_011e: ldc.i4 470548480
		IL_0123: nop
		IL_0124: stloc 2
		IL_0128: ldloca 2
		IL_012c: ldind.i2
		IL_012d: conv.i2
		IL_012e: brfalse IL_0133

		IL_0133: ret
	} // end of method w::r

	.method assembly hidebysig static 
		uint32 c (
			uint8[] A_0
		) cil managed 
	{
		// Method begins at RVA 0x67f8
		// Header size: 12
		// Code size: 177 (0xb1)
		.maxstack 3
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 900168042
		IL_0005: stloc 0
		IL_0009: nop
		IL_000a: ldloca 0
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 688945514
		IL_0016: stloc 0
		IL_001a: ldloca 0
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 1784348673
		IL_003a: nop
		IL_003b: stloc 0
		IL_003f: ldloca 0
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: br.s IL_0059

		IL_0047: ldc.i4 2099118080
		IL_004c: stloc 0
		IL_0050: ldloca 0
		IL_0054: nop
		IL_0055: ldind.i2
		IL_0056: conv.i2
		IL_0057: br.s IL_0059

		IL_0059: brfalse.s IL_005b

		IL_005b: ldc.i4 828899328
		IL_0060: nop
		IL_0061: stloc 0
		IL_0065: ldloca 0
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: brfalse IL_0071

		IL_0071: br.s IL_0086

		IL_0073: ldc.i4 2125201408
		IL_0078: stloc 0
		IL_007c: nop
		IL_007d: ldloca 0
		IL_0081: ldind.i2
		IL_0082: conv.i2

		IL_0083: pop
		IL_0084: br.s IL_0098

		IL_0086: ldc.i4 572260352
		IL_008b: stloc 0
		IL_008f: ldloca 0
		IL_0093: nop
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: br.s IL_0083

		IL_0098: nop
		IL_0099: ldarg.0
		IL_009a: ldc.i4.0
		IL_009b: ldelem.u1
		IL_009c: ldc.i4.s 24
		IL_009e: shl
		IL_009f: ldarg.0
		IL_00a0: ldc.i4.1
		IL_00a1: ldelem.u1
		IL_00a2: ldc.i4.s 16
		IL_00a4: shl
		IL_00a5: or
		IL_00a6: ldarg.0
		IL_00a7: ldc.i4.2
		IL_00a8: ldelem.u1
		IL_00a9: ldc.i4.8
		IL_00aa: shl
		IL_00ab: or
		IL_00ac: ldarg.0
		IL_00ad: ldc.i4.3
		IL_00ae: ldelem.u1
		IL_00af: or
		IL_00b0: ret
	} // end of method w::c

	.method assembly hidebysig static 
		uint32 c (
			uint8[] A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0x68b8
		// Header size: 12
		// Code size: 188 (0xbc)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 2067529729
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: br.s IL_0026

		IL_0014: ldc.i4 130285568
		IL_0019: stloc 0
		IL_001d: ldloca 0
		IL_0021: nop
		IL_0022: ldind.i2
		IL_0023: conv.i2
		IL_0024: br.s IL_0026

		IL_0026: brfalse.s IL_0028

		IL_0028: ldc.i4 1033075069
		IL_002d: nop
		IL_002e: stloc 0
		IL_0032: ldloca 0
		IL_0036: nop
		IL_0037: ldind.i2
		IL_0038: conv.i2
		IL_0039: ldc.i4 454261117
		IL_003e: stloc 0
		IL_0042: nop
		IL_0043: ldloca 0
		IL_0047: nop
		IL_0048: ldind.i2
		IL_0049: conv.i2
		IL_004a: ceq
		IL_004c: switch (IL_005d, IL_005e, IL_005d)

		IL_005d: nop

		IL_005e: ldc.i4 38076416
		IL_0063: nop
		IL_0064: stloc 0
		IL_0068: nop
		IL_0069: ldloca 0
		IL_006d: nop
		IL_006e: ldind.i2
		IL_006f: conv.i2
		IL_0070: brfalse IL_0075

		IL_0075: br.s IL_008b

		IL_0077: ldc.i4 824770560
		IL_007c: nop
		IL_007d: stloc 0
		IL_0081: ldloca 0
		IL_0085: nop
		IL_0086: ldind.i2
		IL_0087: conv.i2

		IL_0088: pop
		IL_0089: br.s IL_009d

		IL_008b: ldc.i4 593887232
		IL_0090: stloc 0
		IL_0094: nop
		IL_0095: ldloca 0
		IL_0099: ldind.i2
		IL_009a: conv.i2
		IL_009b: br.s IL_0088

		IL_009d: nop
		IL_009e: ldarg.0
		IL_009f: ldarg.1
		IL_00a0: ldelem.u1
		IL_00a1: ldc.i4.s 24
		IL_00a3: shl
		IL_00a4: ldarg.0
		IL_00a5: ldarg.1
		IL_00a6: ldc.i4.1
		IL_00a7: add
		IL_00a8: ldelem.u1
		IL_00a9: ldc.i4.s 16
		IL_00ab: shl
		IL_00ac: or
		IL_00ad: ldarg.0
		IL_00ae: ldarg.1
		IL_00af: ldc.i4.2
		IL_00b0: add
		IL_00b1: ldelem.u1
		IL_00b2: ldc.i4.8
		IL_00b3: shl
		IL_00b4: or
		IL_00b5: ldarg.0
		IL_00b6: ldarg.1
		IL_00b7: ldc.i4.3
		IL_00b8: add
		IL_00b9: ldelem.u1
		IL_00ba: or
		IL_00bb: ret
	} // end of method w::c

	.method assembly hidebysig static 
		void r (
			uint8[] A_0,
			int32 A_1,
			uint32[] A_2
		) cil managed 
	{
		// Method begins at RVA 0x6980
		// Header size: 12
		// Code size: 315 (0x13b)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0020)

		IL_000a: ldloc.1
		IL_000b: switch (IL_0091, IL_0036, IL_00e9, IL_004c)

		IL_0020: ldc.i4.0
		IL_0021: stloc.0
		IL_0022: ldc.i4 150142977
		IL_0027: stloc 2
		IL_002b: ldloca 2
		IL_002f: nop
		IL_0030: ldind.i2
		IL_0031: conv.i2
		IL_0032: conv.i
		IL_0033: stloc.1
		IL_0034: br.s IL_000a

		IL_0036: br.s IL_0038

		IL_0038: ldc.i4 1030356995
		IL_003d: nop
		IL_003e: stloc 2
		IL_0042: ldloca 2
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: conv.i
		IL_0049: stloc.1
		IL_004a: br.s IL_000a

		IL_004c: ldc.i4 1243545601
		IL_0051: stloc 2
		IL_0055: nop
		IL_0056: ldloca 2
		IL_005a: nop
		IL_005b: ldind.i2
		IL_005c: conv.i2
		IL_005d: br.s IL_0071

		IL_005f: ldc.i4 354877440
		IL_0064: stloc 2
		IL_0068: ldloca 2
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: br.s IL_0071

		IL_0071: brfalse.s IL_0073

		IL_0073: ldloc.0
		IL_0074: ldarg.2
		IL_0075: ldlen
		IL_0076: conv.i4
		IL_0077: blt.s IL_0093

		IL_0079: ldc.i4 1129971712
		IL_007e: nop
		IL_007f: stloc 2
		IL_0083: ldloca 2
		IL_0087: nop
		IL_0088: ldind.i2
		IL_0089: conv.i2
		IL_008a: conv.i
		IL_008b: stloc.1
		IL_008c: br IL_000a

		IL_0091: br.s IL_00ee

		IL_0093: ldarg.2
		IL_0094: ldloc.0
		IL_0095: ldarg.0
		IL_0096: ldarg.1
		IL_0097: call uint32 w::c(uint8[], int32)
		IL_009c: stelem.i4
		IL_009d: ldarg.1
		IL_009e: ldc.i4.4
		IL_009f: add
		IL_00a0: starg.s A_1
		IL_00a2: ldloc.0
		IL_00a3: ldc.i4.1
		IL_00a4: add
		IL_00a5: stloc.0

		IL_00a6: br.s IL_00bd

		IL_00a8: ldc.i4 575275008
		IL_00ad: nop
		IL_00ae: stloc 2
		IL_00b2: nop
		IL_00b3: ldloca 2
		IL_00b7: nop
		IL_00b8: ldind.i2
		IL_00b9: conv.i2

		IL_00ba: pop
		IL_00bb: br.s IL_00d1

		IL_00bd: ldc.i4 1433600000
		IL_00c2: nop
		IL_00c3: stloc 2
		IL_00c7: nop
		IL_00c8: ldloca 2
		IL_00cc: nop
		IL_00cd: ldind.i2
		IL_00ce: conv.i2
		IL_00cf: br.s IL_00ba

		IL_00d1: nop
		IL_00d2: ldc.i4 761266178
		IL_00d7: stloc 2
		IL_00db: ldloca 2
		IL_00df: nop
		IL_00e0: ldind.i2
		IL_00e1: conv.i2
		IL_00e2: conv.i
		IL_00e3: stloc.1
		IL_00e4: br IL_000a

		IL_00e9: br IL_0038

		IL_00ee: ldc.i4 1041991582
		IL_00f3: nop
		IL_00f4: stloc 2
		IL_00f8: nop
		IL_00f9: ldloca 2
		IL_00fd: ldind.i2
		IL_00fe: conv.i2
		IL_00ff: ldc.i4 1040025502
		IL_0104: nop
		IL_0105: stloc 2
		IL_0109: ldloca 2
		IL_010d: nop
		IL_010e: ldind.i2
		IL_010f: conv.i2
		IL_0110: ceq
		IL_0112: switch (IL_00a6, IL_0124, IL_00a6)

		IL_0123: nop

		IL_0124: ldc.i4 358612992
		IL_0129: stloc 2
		IL_012d: nop
		IL_012e: ldloca 2
		IL_0132: nop
		IL_0133: ldind.i2
		IL_0134: conv.i2
		IL_0135: brfalse IL_013a

		IL_013a: ret
	} // end of method w::r

	.method assembly hidebysig static 
		uint8[] r (
			uint64 A_0
		) cil managed 
	{
		// Method begins at RVA 0x6ac8
		// Header size: 12
		// Code size: 173 (0xad)
		.maxstack 3
		.locals init (
			[0] uint8[],
			[1] int16
		)

		IL_0000: ldc.i4 1768175
		IL_0005: stloc 1
		IL_0009: ldloca 1
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 695335663
		IL_0015: nop
		IL_0016: stloc 1
		IL_001a: ldloca 1
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 1427767297
		IL_003a: stloc 1
		IL_003e: nop
		IL_003f: ldloca 1
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: br.s IL_005a

		IL_0048: ldc.i4 1759510528
		IL_004d: stloc 1
		IL_0051: ldloca 1
		IL_0055: nop
		IL_0056: ldind.i2
		IL_0057: conv.i2
		IL_0058: br.s IL_005a

		IL_005a: brfalse.s IL_005c

		IL_005c: ldc.i4 1119748096
		IL_0061: nop
		IL_0062: stloc 1
		IL_0066: nop
		IL_0067: ldloca 1
		IL_006b: nop
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: brfalse IL_0073

		IL_0073: br.s IL_0089

		IL_0075: ldc.i4 1307574272
		IL_007a: nop
		IL_007b: stloc 1
		IL_007f: nop
		IL_0080: ldloca 1
		IL_0084: ldind.i2
		IL_0085: conv.i2

		IL_0086: pop
		IL_0087: br.s IL_009b

		IL_0089: ldc.i4 332464128
		IL_008e: stloc 1
		IL_0092: ldloca 1
		IL_0096: nop
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: br.s IL_0086

		IL_009b: nop
		IL_009c: ldc.i4.8
		IL_009d: newarr [mscorlib]System.Byte
		IL_00a2: stloc.0
		IL_00a3: ldarg.0
		IL_00a4: ldloc.0
		IL_00a5: ldc.i4.0
		IL_00a6: call void w::r(uint64, uint8[], int32)
		IL_00ab: ldloc.0
		IL_00ac: ret
	} // end of method w::r

	.method assembly hidebysig static 
		void r (
			uint64 A_0,
			uint8[] A_1
		) cil managed 
	{
		// Method begins at RVA 0x6b84
		// Header size: 12
		// Code size: 179 (0xb3)
		.maxstack 3
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 129029227
		IL_0005: stloc 0
		IL_0009: nop
		IL_000a: ldloca 0
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 336254059
		IL_0016: stloc 0
		IL_001a: nop
		IL_001b: ldloca 0
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0036, IL_0035)

		IL_0035: nop

		IL_0036: ldc.i4 401670145
		IL_003b: stloc 0
		IL_003f: ldloca 0
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: br.s IL_005c

		IL_0048: ldc.i4 664010752
		IL_004d: nop
		IL_004e: stloc 0
		IL_0052: nop
		IL_0053: ldloca 0
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_005c

		IL_005c: brfalse.s IL_005e

		IL_005e: ldc.i4 2051407872
		IL_0063: nop
		IL_0064: stloc 0
		IL_0068: nop
		IL_0069: ldloca 0
		IL_006d: nop
		IL_006e: ldind.i2
		IL_006f: conv.i2
		IL_0070: brfalse IL_0075

		IL_0075: br.s IL_008b

		IL_0077: ldc.i4 40960000
		IL_007c: nop
		IL_007d: stloc 0
		IL_0081: nop
		IL_0082: ldloca 0
		IL_0086: ldind.i2
		IL_0087: conv.i2

		IL_0088: pop
		IL_0089: br.s IL_009d

		IL_008b: ldc.i4 1535836160
		IL_0090: nop
		IL_0091: stloc 0
		IL_0095: ldloca 0
		IL_0099: ldind.i2
		IL_009a: conv.i2
		IL_009b: br.s IL_0088

		IL_009d: nop
		IL_009e: ldarg.0
		IL_009f: ldc.i4.s 32
		IL_00a1: shr.un
		IL_00a2: conv.u4
		IL_00a3: ldarg.1
		IL_00a4: call void w::r(uint32, uint8[])
		IL_00a9: ldarg.0
		IL_00aa: conv.u4
		IL_00ab: ldarg.1
		IL_00ac: ldc.i4.4
		IL_00ad: call void w::r(uint32, uint8[], int32)
		IL_00b2: ret
	} // end of method w::r

	.method assembly hidebysig static 
		void r (
			uint64 A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x6c44
		// Header size: 12
		// Code size: 176 (0xb0)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1608606505
		IL_0005: stloc 0
		IL_0009: nop
		IL_000a: ldloca 0
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1265066793
		IL_0015: nop
		IL_0016: stloc 0
		IL_001a: ldloca 0
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_0034, IL_0033)

		IL_0033: nop

		IL_0034: ldc.i4 365232128
		IL_0039: stloc 0
		IL_003d: nop
		IL_003e: ldloca 0
		IL_0042: ldind.i2
		IL_0043: conv.i2
		IL_0044: brfalse IL_0049

		IL_0049: ldc.i4 1182072833
		IL_004e: stloc 0
		IL_0052: nop
		IL_0053: ldloca 0
		IL_0057: ldind.i2
		IL_0058: conv.i2
		IL_0059: br.s IL_006e

		IL_005b: ldc.i4 1493827584
		IL_0060: stloc 0
		IL_0064: nop
		IL_0065: ldloca 0
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: br.s IL_006e

		IL_006e: brfalse.s IL_0070

		IL_0070: br.s IL_0085

		IL_0072: ldc.i4 573243392
		IL_0077: stloc 0
		IL_007b: ldloca 0
		IL_007f: nop
		IL_0080: ldind.i2
		IL_0081: conv.i2

		IL_0082: pop
		IL_0083: br.s IL_0097

		IL_0085: ldc.i4 953090048
		IL_008a: stloc 0
		IL_008e: nop
		IL_008f: ldloca 0
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: br.s IL_0082

		IL_0097: nop
		IL_0098: ldarg.0
		IL_0099: ldc.i4.s 32
		IL_009b: shr.un
		IL_009c: conv.u4
		IL_009d: ldarg.1
		IL_009e: ldarg.2
		IL_009f: call void w::r(uint32, uint8[], int32)
		IL_00a4: ldarg.0
		IL_00a5: conv.u4
		IL_00a6: ldarg.1
		IL_00a7: ldarg.2
		IL_00a8: ldc.i4.4
		IL_00a9: add
		IL_00aa: call void w::r(uint32, uint8[], int32)
		IL_00af: ret
	} // end of method w::r

	.method assembly hidebysig static 
		uint8[] w (
			uint64[] A_0
		) cil managed 
	{
		// Method begins at RVA 0x6d00
		// Header size: 12
		// Code size: 174 (0xae)
		.maxstack 3
		.locals init (
			[0] uint8[],
			[1] int16
		)

		IL_0000: ldc.i4 955862751
		IL_0005: stloc 1
		IL_0009: nop
		IL_000a: ldloca 1
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 93933279
		IL_0015: stloc 1
		IL_0019: ldloca 1
		IL_001d: nop
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_0034, IL_0033)

		IL_0033: nop

		IL_0034: ldc.i4 1306853377
		IL_0039: stloc 1
		IL_003d: ldloca 1
		IL_0041: nop
		IL_0042: ldind.i2
		IL_0043: conv.i2
		IL_0044: br.s IL_0058

		IL_0046: ldc.i4 156631040
		IL_004b: stloc 1
		IL_004f: ldloca 1
		IL_0053: nop
		IL_0054: ldind.i2
		IL_0055: conv.i2
		IL_0056: br.s IL_0058

		IL_0058: brfalse.s IL_005a

		IL_005a: ldc.i4 25362432
		IL_005f: stloc 1
		IL_0063: ldloca 1
		IL_0067: nop
		IL_0068: ldind.i2
		IL_0069: conv.i2
		IL_006a: brfalse IL_006f

		IL_006f: br.s IL_0085

		IL_0071: ldc.i4 200867840
		IL_0076: nop
		IL_0077: stloc 1
		IL_007b: nop
		IL_007c: ldloca 1
		IL_0080: ldind.i2
		IL_0081: conv.i2

		IL_0082: pop
		IL_0083: br.s IL_0098

		IL_0085: ldc.i4 37355520
		IL_008a: nop
		IL_008b: stloc 1
		IL_008f: ldloca 1
		IL_0093: nop
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: br.s IL_0082

		IL_0098: nop
		IL_0099: ldc.i4.8
		IL_009a: ldarg.0
		IL_009b: ldlen
		IL_009c: conv.i4
		IL_009d: mul
		IL_009e: newarr [mscorlib]System.Byte
		IL_00a3: stloc.0
		IL_00a4: ldarg.0
		IL_00a5: ldloc.0
		IL_00a6: ldc.i4.0
		IL_00a7: call void w::w(uint64[], uint8[], int32)
		IL_00ac: ldloc.0
		IL_00ad: ret
	} // end of method w::w

	.method assembly hidebysig static 
		void w (
			uint64[] A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x6dbc
		// Header size: 12
		// Code size: 310 (0x136)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0020)

		IL_000a: ldloc.1
		IL_000b: switch (IL_0066, IL_0036, IL_0095, IL_004c)

		IL_0020: ldc.i4.0
		IL_0021: stloc.0
		IL_0022: ldc.i4 1944322049
		IL_0027: stloc 2
		IL_002b: nop
		IL_002c: ldloca 2
		IL_0030: ldind.i2
		IL_0031: conv.i2
		IL_0032: conv.i
		IL_0033: stloc.1
		IL_0034: br.s IL_000a

		IL_0036: br.s IL_0038

		IL_0038: ldc.i4 2116878339
		IL_003d: nop
		IL_003e: stloc 2
		IL_0042: ldloca 2
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: conv.i
		IL_0049: stloc.1
		IL_004a: br.s IL_000a

		IL_004c: ldloc.0
		IL_004d: ldarg.0
		IL_004e: ldlen
		IL_004f: conv.i4
		IL_0050: blt.s IL_006b

		IL_0052: ldc.i4 64290816
		IL_0057: stloc 2
		IL_005b: nop
		IL_005c: ldloca 2
		IL_0060: ldind.i2
		IL_0061: conv.i2
		IL_0062: conv.i
		IL_0063: stloc.1
		IL_0064: br.s IL_000a

		IL_0066: br IL_00eb

		IL_006b: ldarg.0
		IL_006c: ldloc.0
		IL_006d: ldelem.i8
		IL_006e: ldarg.1
		IL_006f: ldarg.2
		IL_0070: call void w::r(uint64, uint8[], int32)
		IL_0075: ldarg.2
		IL_0076: ldc.i4.8
		IL_0077: add
		IL_0078: starg.s A_2
		IL_007a: ldloc.0
		IL_007b: ldc.i4.1
		IL_007c: add
		IL_007d: stloc.0

		IL_007e: ldc.i4 715325442
		IL_0083: stloc 2
		IL_0087: ldloca 2
		IL_008b: nop
		IL_008c: ldind.i2
		IL_008d: conv.i2
		IL_008e: conv.i
		IL_008f: stloc.1
		IL_0090: br IL_000a

		IL_0095: br.s IL_00ab

		IL_0097: ldc.i4 877264896
		IL_009c: nop
		IL_009d: stloc 2
		IL_00a1: nop
		IL_00a2: ldloca 2
		IL_00a6: ldind.i2
		IL_00a7: conv.i2

		IL_00a8: pop
		IL_00a9: br.s IL_00be

		IL_00ab: ldc.i4 422313984
		IL_00b0: stloc 2
		IL_00b4: nop
		IL_00b5: ldloca 2
		IL_00b9: nop
		IL_00ba: ldind.i2
		IL_00bb: conv.i2
		IL_00bc: br.s IL_00a8

		IL_00be: nop
		IL_00bf: ldc.i4 830275585
		IL_00c4: stloc 2
		IL_00c8: ldloca 2
		IL_00cc: nop
		IL_00cd: ldind.i2
		IL_00ce: conv.i2
		IL_00cf: br.s IL_00e4

		IL_00d1: ldc.i4 592052224
		IL_00d6: stloc 2
		IL_00da: nop
		IL_00db: ldloca 2
		IL_00df: nop
		IL_00e0: ldind.i2
		IL_00e1: conv.i2
		IL_00e2: br.s IL_00e4

		IL_00e4: brfalse.s IL_00e6

		IL_00e6: br IL_0038

		IL_00eb: ldc.i4 2104265711
		IL_00f0: stloc 2
		IL_00f4: nop
		IL_00f5: ldloca 2
		IL_00f9: ldind.i2
		IL_00fa: conv.i2
		IL_00fb: ldc.i4 1809091567
		IL_0100: nop
		IL_0101: stloc 2
		IL_0105: ldloca 2
		IL_0109: ldind.i2
		IL_010a: conv.i2
		IL_010b: ceq
		IL_010d: switch (IL_007e, IL_011f, IL_007e)

		IL_011e: nop

		IL_011f: ldc.i4 13041664
		IL_0124: nop
		IL_0125: stloc 2
		IL_0129: ldloca 2
		IL_012d: nop
		IL_012e: ldind.i2
		IL_012f: conv.i2
		IL_0130: brfalse IL_0135

		IL_0135: ret
	} // end of method w::w

	.method assembly hidebysig static 
		uint64 h (
			uint8[] A_0
		) cil managed 
	{
		// Method begins at RVA 0x6f00
		// Header size: 12
		// Code size: 176 (0xb0)
		.maxstack 3
		.locals init (
			[0] uint32,
			[1] int16
		)

		IL_0000: ldc.i4 1796732174
		IL_0005: stloc 1
		IL_0009: ldloca 1
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1190065422
		IL_0015: stloc 1
		IL_0019: ldloca 1
		IL_001d: nop
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_0034, IL_0033)

		IL_0033: nop

		IL_0034: ldc.i4 1679556608
		IL_0039: nop
		IL_003a: stloc 1
		IL_003e: nop
		IL_003f: ldloca 1
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: brfalse IL_004a

		IL_004a: ldc.i4 1619329025
		IL_004f: nop
		IL_0050: stloc 1
		IL_0054: ldloca 1
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_006f

		IL_005c: ldc.i4 575340544
		IL_0061: stloc 1
		IL_0065: nop
		IL_0066: ldloca 1
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: br.s IL_006f

		IL_006f: brfalse.s IL_0071

		IL_0071: br.s IL_0087

		IL_0073: ldc.i4 1605304320
		IL_0078: stloc 1
		IL_007c: nop
		IL_007d: ldloca 1
		IL_0081: nop
		IL_0082: ldind.i2
		IL_0083: conv.i2

		IL_0084: pop
		IL_0085: br.s IL_0099

		IL_0087: ldc.i4 2146107392
		IL_008c: stloc 1
		IL_0090: ldloca 1
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: br.s IL_0084

		IL_0099: nop
		IL_009a: ldarg.0
		IL_009b: call uint32 w::c(uint8[])
		IL_00a0: ldarg.0
		IL_00a1: ldc.i4.4
		IL_00a2: call uint32 w::c(uint8[], int32)
		IL_00a7: stloc.0
		IL_00a8: conv.u8
		IL_00a9: ldc.i4.s 32
		IL_00ab: shl
		IL_00ac: ldloc.0
		IL_00ad: conv.u8
		IL_00ae: or
		IL_00af: ret
	} // end of method w::h

	.method assembly hidebysig static 
		uint64 h (
			uint8[] A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0x6fbc
		// Header size: 12
		// Code size: 180 (0xb4)
		.maxstack 4
		.locals init (
			[0] uint32,
			[1] int16
		)

		IL_0000: ldc.i4 854808217
		IL_0005: nop
		IL_0006: stloc 1
		IL_000a: ldloca 1
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 416503449
		IL_0016: nop
		IL_0017: stloc 1
		IL_001b: ldloca 1
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0036, IL_0035)

		IL_0035: nop

		IL_0036: ldc.i4 2134900737
		IL_003b: stloc 1
		IL_003f: nop
		IL_0040: ldloca 1
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: br.s IL_005b

		IL_0048: ldc.i4 1471873024
		IL_004d: nop
		IL_004e: stloc 1
		IL_0052: ldloca 1
		IL_0056: nop
		IL_0057: ldind.i2
		IL_0058: conv.i2
		IL_0059: br.s IL_005b

		IL_005b: brfalse.s IL_005d

		IL_005d: ldc.i4 1355677696
		IL_0062: nop
		IL_0063: stloc 1
		IL_0067: ldloca 1
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: brfalse IL_0072

		IL_0072: br.s IL_0087

		IL_0074: ldc.i4 1469382656
		IL_0079: stloc 1
		IL_007d: ldloca 1
		IL_0081: nop
		IL_0082: ldind.i2
		IL_0083: conv.i2

		IL_0084: pop
		IL_0085: br.s IL_009a

		IL_0087: ldc.i4 1207894016
		IL_008c: nop
		IL_008d: stloc 1
		IL_0091: ldloca 1
		IL_0095: nop
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: br.s IL_0084

		IL_009a: nop
		IL_009b: ldarg.0
		IL_009c: ldarg.1
		IL_009d: call uint32 w::c(uint8[], int32)
		IL_00a2: ldarg.0
		IL_00a3: ldarg.1
		IL_00a4: ldc.i4.4
		IL_00a5: add
		IL_00a6: call uint32 w::c(uint8[], int32)
		IL_00ab: stloc.0
		IL_00ac: conv.u8
		IL_00ad: ldc.i4.s 32
		IL_00af: shl
		IL_00b0: ldloc.0
		IL_00b1: conv.u8
		IL_00b2: or
		IL_00b3: ret
	} // end of method w::h

	.method assembly hidebysig static 
		void w (
			uint8[] A_0,
			int32 A_1,
			uint64[] A_2
		) cil managed 
	{
		// Method begins at RVA 0x707c
		// Header size: 12
		// Code size: 306 (0x132)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0020)

		IL_000a: ldloc.1
		IL_000b: switch (IL_0066, IL_0036, IL_0092, IL_004c)

		IL_0020: ldc.i4.0
		IL_0021: stloc.0
		IL_0022: ldc.i4 554565633
		IL_0027: stloc 2
		IL_002b: nop
		IL_002c: ldloca 2
		IL_0030: ldind.i2
		IL_0031: conv.i2
		IL_0032: conv.i
		IL_0033: stloc.1
		IL_0034: br.s IL_000a

		IL_0036: br.s IL_0038

		IL_0038: ldc.i4 382468099
		IL_003d: stloc 2
		IL_0041: nop
		IL_0042: ldloca 2
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: conv.i
		IL_0049: stloc.1
		IL_004a: br.s IL_000a

		IL_004c: ldloc.0
		IL_004d: ldarg.2
		IL_004e: ldlen
		IL_004f: conv.i4
		IL_0050: blt.s IL_0068

		IL_0052: ldc.i4 752418816
		IL_0057: stloc 2
		IL_005b: ldloca 2
		IL_005f: nop
		IL_0060: ldind.i2
		IL_0061: conv.i2
		IL_0062: conv.i
		IL_0063: stloc.1
		IL_0064: br.s IL_000a

		IL_0066: br.s IL_00c1

		IL_0068: ldarg.2
		IL_0069: ldloc.0
		IL_006a: ldarg.0
		IL_006b: ldarg.1
		IL_006c: call uint64 w::h(uint8[], int32)
		IL_0071: stelem.i8
		IL_0072: ldarg.1
		IL_0073: ldc.i4.8
		IL_0074: add
		IL_0075: starg.s A_1
		IL_0077: ldloc.0
		IL_0078: ldc.i4.1
		IL_0079: add
		IL_007a: stloc.0

		IL_007b: ldc.i4 1892220930
		IL_0080: stloc 2
		IL_0084: nop
		IL_0085: ldloca 2
		IL_0089: ldind.i2
		IL_008a: conv.i2
		IL_008b: conv.i
		IL_008c: stloc.1
		IL_008d: br IL_000a

		IL_0092: br.s IL_00a9

		IL_0094: ldc.i4 1406074880
		IL_0099: nop
		IL_009a: stloc 2
		IL_009e: nop
		IL_009f: ldloca 2
		IL_00a3: nop
		IL_00a4: ldind.i2
		IL_00a5: conv.i2

		IL_00a6: pop
		IL_00a7: br.s IL_00bb

		IL_00a9: ldc.i4 2099314688
		IL_00ae: stloc 2
		IL_00b2: ldloca 2
		IL_00b6: nop
		IL_00b7: ldind.i2
		IL_00b8: conv.i2
		IL_00b9: br.s IL_00a6

		IL_00bb: nop
		IL_00bc: br IL_0038

		IL_00c1: ldc.i4 1798308370
		IL_00c6: nop
		IL_00c7: stloc 2
		IL_00cb: nop
		IL_00cc: ldloca 2
		IL_00d0: ldind.i2
		IL_00d1: conv.i2
		IL_00d2: ldc.i4 956826130
		IL_00d7: stloc 2
		IL_00db: nop
		IL_00dc: ldloca 2
		IL_00e0: ldind.i2
		IL_00e1: conv.i2
		IL_00e2: ceq
		IL_00e4: switch (IL_007b, IL_00f6, IL_007b)

		IL_00f5: nop

		IL_00f6: ldc.i4 1324744705
		IL_00fb: nop
		IL_00fc: stloc 2
		IL_0100: ldloca 2
		IL_0104: ldind.i2
		IL_0105: conv.i2
		IL_0106: br.s IL_011a

		IL_0108: ldc.i4 731643904
		IL_010d: nop
		IL_010e: stloc 2
		IL_0112: ldloca 2
		IL_0116: ldind.i2
		IL_0117: conv.i2
		IL_0118: br.s IL_011a

		IL_011a: brfalse.s IL_011c

		IL_011c: ldc.i4 445054976
		IL_0121: stloc 2
		IL_0125: ldloca 2
		IL_0129: nop
		IL_012a: ldind.i2
		IL_012b: conv.i2
		IL_012c: brfalse IL_0131

		IL_0131: ret
	} // end of method w::w

	.method assembly hidebysig static 
		void w (
			uint16 A_0,
			uint8[] A_1
		) cil managed 
	{
		// Method begins at RVA 0x71bc
		// Header size: 12
		// Code size: 172 (0xac)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1911783498
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1808367690
		IL_0016: nop
		IL_0017: stloc 0
		IL_001b: ldloca 0
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0036, IL_0035)

		IL_0035: nop

		IL_0036: ldc.i4 1297743873
		IL_003b: nop
		IL_003c: stloc 0
		IL_0040: ldloca 0
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: br.s IL_005c

		IL_0048: ldc.i4 339148800
		IL_004d: nop
		IL_004e: stloc 0
		IL_0052: nop
		IL_0053: ldloca 0
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_005c

		IL_005c: brfalse.s IL_005e

		IL_005e: ldc.i4 2115371008
		IL_0063: nop
		IL_0064: stloc 0
		IL_0068: ldloca 0
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: brfalse IL_0074

		IL_0074: br.s IL_008b

		IL_0076: ldc.i4 252444672
		IL_007b: nop
		IL_007c: stloc 0
		IL_0080: nop
		IL_0081: ldloca 0
		IL_0085: nop
		IL_0086: ldind.i2
		IL_0087: conv.i2

		IL_0088: pop
		IL_0089: br.s IL_009e

		IL_008b: ldc.i4 2125660160
		IL_0090: stloc 0
		IL_0094: nop
		IL_0095: ldloca 0
		IL_0099: nop
		IL_009a: ldind.i2
		IL_009b: conv.i2
		IL_009c: br.s IL_0088

		IL_009e: nop
		IL_009f: ldarg.1
		IL_00a0: ldc.i4.0
		IL_00a1: ldarg.0
		IL_00a2: conv.u1
		IL_00a3: stelem.i1
		IL_00a4: ldarg.1
		IL_00a5: ldc.i4.1
		IL_00a6: ldarg.0
		IL_00a7: ldc.i4.8
		IL_00a8: shr
		IL_00a9: conv.u1
		IL_00aa: stelem.i1
		IL_00ab: ret
	} // end of method w::w

	.method assembly hidebysig static 
		void w (
			uint16 A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x7274
		// Header size: 12
		// Code size: 168 (0xa8)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1290403841
		IL_0005: stloc 0
		IL_0009: ldloca 0
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: br.s IL_0026

		IL_0012: ldc.i4 442564608
		IL_0017: nop
		IL_0018: stloc 0
		IL_001c: nop
		IL_001d: ldloca 0
		IL_0021: nop
		IL_0022: ldind.i2
		IL_0023: conv.i2
		IL_0024: br.s IL_0026

		IL_0026: brfalse.s IL_0028

		IL_0028: ldc.i4 1570743470
		IL_002d: stloc 0
		IL_0031: ldloca 0
		IL_0035: nop
		IL_0036: ldind.i2
		IL_0037: conv.i2
		IL_0038: ldc.i4 28550318
		IL_003d: stloc 0
		IL_0041: ldloca 0
		IL_0045: nop
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: ceq
		IL_004a: switch (IL_005b, IL_005c, IL_005b)

		IL_005b: nop

		IL_005c: ldc.i4 1247805440
		IL_0061: stloc 0
		IL_0065: ldloca 0
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: brfalse IL_0071

		IL_0071: br.s IL_0086

		IL_0073: ldc.i4 1908473856
		IL_0078: nop
		IL_0079: stloc 0
		IL_007d: ldloca 0
		IL_0081: ldind.i2
		IL_0082: conv.i2

		IL_0083: pop
		IL_0084: br.s IL_0098

		IL_0086: ldc.i4 1892024320
		IL_008b: stloc 0
		IL_008f: ldloca 0
		IL_0093: nop
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: br.s IL_0083

		IL_0098: nop
		IL_0099: ldarg.1
		IL_009a: ldarg.2
		IL_009b: ldarg.0
		IL_009c: conv.u1
		IL_009d: stelem.i1
		IL_009e: ldarg.1
		IL_009f: ldarg.2
		IL_00a0: ldc.i4.1
		IL_00a1: add
		IL_00a2: ldarg.0
		IL_00a3: ldc.i4.8
		IL_00a4: shr
		IL_00a5: conv.u1
		IL_00a6: stelem.i1
		IL_00a7: ret
	} // end of method w::w

	.method assembly hidebysig static 
		uint16 m (
			uint8[] A_0
		) cil managed 
	{
		// Method begins at RVA 0x7328
		// Header size: 12
		// Code size: 163 (0xa3)
		.maxstack 3
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1995721032
		IL_0005: stloc 0
		IL_0009: ldloca 0
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1818839368
		IL_0015: stloc 0
		IL_0019: ldloca 0
		IL_001d: nop
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_0034, IL_0033)

		IL_0033: nop

		IL_0034: ldc.i4 1465778177
		IL_0039: nop
		IL_003a: stloc 0
		IL_003e: ldloca 0
		IL_0042: ldind.i2
		IL_0043: conv.i2
		IL_0044: br.s IL_0058

		IL_0046: ldc.i4 1026752512
		IL_004b: nop
		IL_004c: stloc 0
		IL_0050: ldloca 0
		IL_0054: ldind.i2
		IL_0055: conv.i2
		IL_0056: br.s IL_0058

		IL_0058: brfalse.s IL_005a

		IL_005a: ldc.i4 1374093312
		IL_005f: stloc 0
		IL_0063: nop
		IL_0064: ldloca 0
		IL_0068: ldind.i2
		IL_0069: conv.i2
		IL_006a: brfalse IL_006f

		IL_006f: br.s IL_0084

		IL_0071: ldc.i4 494141440
		IL_0076: stloc 0
		IL_007a: ldloca 0
		IL_007e: nop
		IL_007f: ldind.i2
		IL_0080: conv.i2

		IL_0081: pop
		IL_0082: br.s IL_0097

		IL_0084: ldc.i4 1939931136
		IL_0089: stloc 0
		IL_008d: nop
		IL_008e: ldloca 0
		IL_0092: nop
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: br.s IL_0081

		IL_0097: nop
		IL_0098: ldarg.0
		IL_0099: ldc.i4.0
		IL_009a: ldelem.u1
		IL_009b: ldarg.0
		IL_009c: ldc.i4.1
		IL_009d: ldelem.u1
		IL_009e: ldc.i4.8
		IL_009f: shl
		IL_00a0: or
		IL_00a1: conv.u2
		IL_00a2: ret
	} // end of method w::m

	.method assembly hidebysig static 
		uint16 m (
			uint8[] A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0x73d8
		// Header size: 12
		// Code size: 168 (0xa8)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 2121777696
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: ldloca 0
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1968488992
		IL_0016: nop
		IL_0017: stloc 0
		IL_001b: ldloca 0
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0036, IL_0035)

		IL_0035: nop

		IL_0036: ldc.i4 1711734785
		IL_003b: nop
		IL_003c: stloc 0
		IL_0040: nop
		IL_0041: ldloca 0
		IL_0045: nop
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: br.s IL_005c

		IL_004a: ldc.i4 1610547200
		IL_004f: stloc 0
		IL_0053: nop
		IL_0054: ldloca 0
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_005c

		IL_005c: brfalse.s IL_005e

		IL_005e: ldc.i4 1873018880
		IL_0063: nop
		IL_0064: stloc 0
		IL_0068: ldloca 0
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: brfalse IL_0073

		IL_0073: br.s IL_0088

		IL_0075: ldc.i4 725090304
		IL_007a: stloc 0
		IL_007e: nop
		IL_007f: ldloca 0
		IL_0083: ldind.i2
		IL_0084: conv.i2

		IL_0085: pop
		IL_0086: br.s IL_009a

		IL_0088: ldc.i4 247791616
		IL_008d: stloc 0
		IL_0091: ldloca 0
		IL_0095: nop
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: br.s IL_0085

		IL_009a: nop
		IL_009b: ldarg.0
		IL_009c: ldarg.1
		IL_009d: ldelem.u1
		IL_009e: ldarg.0
		IL_009f: ldarg.1
		IL_00a0: ldc.i4.1
		IL_00a1: add
		IL_00a2: ldelem.u1
		IL_00a3: ldc.i4.8
		IL_00a4: shl
		IL_00a5: or
		IL_00a6: conv.u2
		IL_00a7: ret
	} // end of method w::m

	.method assembly hidebysig static 
		uint8[] w (
			uint32 A_0
		) cil managed 
	{
		// Method begins at RVA 0x748c
		// Header size: 12
		// Code size: 175 (0xaf)
		.maxstack 3
		.locals init (
			[0] uint8[],
			[1] int16
		)

		IL_0000: ldc.i4 522125313
		IL_0005: nop
		IL_0006: stloc 1
		IL_000a: ldloca 1
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: br.s IL_0025

		IL_0013: ldc.i4 759562240
		IL_0018: stloc 1
		IL_001c: ldloca 1
		IL_0020: nop
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: br.s IL_0025

		IL_0025: brfalse.s IL_0027

		IL_0027: ldc.i4 1423063249
		IL_002c: nop
		IL_002d: stloc 1
		IL_0031: ldloca 1
		IL_0035: nop
		IL_0036: ldind.i2
		IL_0037: conv.i2
		IL_0038: ldc.i4 895629521
		IL_003d: stloc 1
		IL_0041: nop
		IL_0042: ldloca 1
		IL_0046: nop
		IL_0047: ldind.i2
		IL_0048: conv.i2
		IL_0049: ceq
		IL_004b: switch (IL_005c, IL_005d, IL_005c)

		IL_005c: nop

		IL_005d: ldc.i4 428539904
		IL_0062: stloc 1
		IL_0066: ldloca 1
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: brfalse IL_0072

		IL_0072: br.s IL_0089

		IL_0074: ldc.i4 1488781312
		IL_0079: nop
		IL_007a: stloc 1
		IL_007e: nop
		IL_007f: ldloca 1
		IL_0083: nop
		IL_0084: ldind.i2
		IL_0085: conv.i2

		IL_0086: pop
		IL_0087: br.s IL_009d

		IL_0089: ldc.i4 265355264
		IL_008e: nop
		IL_008f: stloc 1
		IL_0093: nop
		IL_0094: ldloca 1
		IL_0098: nop
		IL_0099: ldind.i2
		IL_009a: conv.i2
		IL_009b: br.s IL_0086

		IL_009d: nop
		IL_009e: ldc.i4.4
		IL_009f: newarr [mscorlib]System.Byte
		IL_00a4: stloc.0
		IL_00a5: ldarg.0
		IL_00a6: ldloc.0
		IL_00a7: ldc.i4.0
		IL_00a8: call void w::w(uint32, uint8[], int32)
		IL_00ad: ldloc.0
		IL_00ae: ret
	} // end of method w::w

	.method assembly hidebysig static 
		void w (
			uint32 A_0,
			uint8[] A_1
		) cil managed 
	{
		// Method begins at RVA 0x7548
		// Header size: 12
		// Code size: 183 (0xb7)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 2042704675
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: ldloca 0
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1961177891
		IL_0016: nop
		IL_0017: stloc 0
		IL_001b: nop
		IL_001c: ldloca 0
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0036, IL_0035)

		IL_0035: nop

		IL_0036: ldc.i4 154075137
		IL_003b: stloc 0
		IL_003f: nop
		IL_0040: ldloca 0
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: br.s IL_005a

		IL_0048: ldc.i4 1996619776
		IL_004d: stloc 0
		IL_0051: nop
		IL_0052: ldloca 0
		IL_0056: ldind.i2
		IL_0057: conv.i2
		IL_0058: br.s IL_005a

		IL_005a: brfalse.s IL_005c

		IL_005c: ldc.i4 498008064
		IL_0061: stloc 0
		IL_0065: nop
		IL_0066: ldloca 0
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: brfalse IL_0071

		IL_0071: br.s IL_0086

		IL_0073: ldc.i4 251133952
		IL_0078: stloc 0
		IL_007c: ldloca 0
		IL_0080: nop
		IL_0081: ldind.i2
		IL_0082: conv.i2

		IL_0083: pop
		IL_0084: br.s IL_0099

		IL_0086: ldc.i4 167313408
		IL_008b: nop
		IL_008c: stloc 0
		IL_0090: nop
		IL_0091: ldloca 0
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: br.s IL_0083

		IL_0099: nop
		IL_009a: ldarg.1
		IL_009b: ldc.i4.0
		IL_009c: ldarg.0
		IL_009d: conv.u1
		IL_009e: stelem.i1
		IL_009f: ldarg.1
		IL_00a0: ldc.i4.1
		IL_00a1: ldarg.0
		IL_00a2: ldc.i4.8
		IL_00a3: shr.un
		IL_00a4: conv.u1
		IL_00a5: stelem.i1
		IL_00a6: ldarg.1
		IL_00a7: ldc.i4.2
		IL_00a8: ldarg.0
		IL_00a9: ldc.i4.s 16
		IL_00ab: shr.un
		IL_00ac: conv.u1
		IL_00ad: stelem.i1
		IL_00ae: ldarg.1
		IL_00af: ldc.i4.3
		IL_00b0: ldarg.0
		IL_00b1: ldc.i4.s 24
		IL_00b3: shr.un
		IL_00b4: conv.u1
		IL_00b5: stelem.i1
		IL_00b6: ret
	} // end of method w::w

	.method assembly hidebysig static 
		void w (
			uint32 A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x760c
		// Header size: 12
		// Code size: 194 (0xc2)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 453911982
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 1569531310
		IL_0017: nop
		IL_0018: stloc 0
		IL_001c: nop
		IL_001d: ldloca 0
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: ceq
		IL_0025: switch (IL_0036, IL_0037, IL_0036)

		IL_0036: nop

		IL_0037: ldc.i4 114294785
		IL_003c: stloc 0
		IL_0040: nop
		IL_0041: ldloca 0
		IL_0045: nop
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: br.s IL_005d

		IL_004a: ldc.i4 908132352
		IL_004f: nop
		IL_0050: stloc 0
		IL_0054: ldloca 0
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_005d

		IL_005d: brfalse.s IL_005f

		IL_005f: ldc.i4 1990459392
		IL_0064: nop
		IL_0065: stloc 0
		IL_0069: nop
		IL_006a: ldloca 0
		IL_006e: ldind.i2
		IL_006f: conv.i2
		IL_0070: brfalse IL_0075

		IL_0075: br.s IL_008b

		IL_0077: ldc.i4 1871970304
		IL_007c: stloc 0
		IL_0080: nop
		IL_0081: ldloca 0
		IL_0085: nop
		IL_0086: ldind.i2
		IL_0087: conv.i2

		IL_0088: pop
		IL_0089: br.s IL_009e

		IL_008b: ldc.i4 1802633216
		IL_0090: stloc 0
		IL_0094: nop
		IL_0095: ldloca 0
		IL_0099: nop
		IL_009a: ldind.i2
		IL_009b: conv.i2
		IL_009c: br.s IL_0088

		IL_009e: nop
		IL_009f: ldarg.1
		IL_00a0: ldarg.2
		IL_00a1: ldarg.0
		IL_00a2: conv.u1
		IL_00a3: stelem.i1
		IL_00a4: ldarg.1
		IL_00a5: ldarg.2
		IL_00a6: ldc.i4.1
		IL_00a7: add
		IL_00a8: ldarg.0
		IL_00a9: ldc.i4.8
		IL_00aa: shr.un
		IL_00ab: conv.u1
		IL_00ac: stelem.i1
		IL_00ad: ldarg.1
		IL_00ae: ldarg.2
		IL_00af: ldc.i4.2
		IL_00b0: add
		IL_00b1: ldarg.0
		IL_00b2: ldc.i4.s 16
		IL_00b4: shr.un
		IL_00b5: conv.u1
		IL_00b6: stelem.i1
		IL_00b7: ldarg.1
		IL_00b8: ldarg.2
		IL_00b9: ldc.i4.3
		IL_00ba: add
		IL_00bb: ldarg.0
		IL_00bc: ldc.i4.s 24
		IL_00be: shr.un
		IL_00bf: conv.u1
		IL_00c0: stelem.i1
		IL_00c1: ret
	} // end of method w::w

	.method assembly hidebysig static 
		uint8[] w (
			uint32[] A_0
		) cil managed 
	{
		// Method begins at RVA 0x76dc
		// Header size: 12
		// Code size: 174 (0xae)
		.maxstack 3
		.locals init (
			[0] uint8[],
			[1] int16
		)

		IL_0000: ldc.i4 1678635045
		IL_0005: stloc 1
		IL_0009: ldloca 1
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 507899941
		IL_0015: nop
		IL_0016: stloc 1
		IL_001a: nop
		IL_001b: ldloca 1
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 1703936000
		IL_003a: stloc 1
		IL_003e: nop
		IL_003f: ldloca 1
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: brfalse IL_004a

		IL_004a: ldc.i4 441319425
		IL_004f: stloc 1
		IL_0053: ldloca 1
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_006f

		IL_005c: ldc.i4 1118568448
		IL_0061: nop
		IL_0062: stloc 1
		IL_0066: ldloca 1
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: br.s IL_006f

		IL_006f: brfalse.s IL_0071

		IL_0071: br.s IL_0086

		IL_0073: ldc.i4 1343225856
		IL_0078: stloc 1
		IL_007c: nop
		IL_007d: ldloca 1
		IL_0081: ldind.i2
		IL_0082: conv.i2

		IL_0083: pop
		IL_0084: br.s IL_0098

		IL_0086: ldc.i4 269025280
		IL_008b: stloc 1
		IL_008f: ldloca 1
		IL_0093: nop
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: br.s IL_0083

		IL_0098: nop
		IL_0099: ldc.i4.4
		IL_009a: ldarg.0
		IL_009b: ldlen
		IL_009c: conv.i4
		IL_009d: mul
		IL_009e: newarr [mscorlib]System.Byte
		IL_00a3: stloc.0
		IL_00a4: ldarg.0
		IL_00a5: ldloc.0
		IL_00a6: ldc.i4.0
		IL_00a7: call void w::w(uint32[], uint8[], int32)
		IL_00ac: ldloc.0
		IL_00ad: ret
	} // end of method w::w

	.method assembly hidebysig static 
		void w (
			uint32[] A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x7798
		// Header size: 12
		// Code size: 306 (0x132)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0020)

		IL_000a: ldloc.1
		IL_000b: switch (IL_0068, IL_0036, IL_0094, IL_004c)

		IL_0020: ldc.i4.0
		IL_0021: stloc.0
		IL_0022: ldc.i4 847183873
		IL_0027: stloc 2
		IL_002b: nop
		IL_002c: ldloca 2
		IL_0030: ldind.i2
		IL_0031: conv.i2
		IL_0032: conv.i
		IL_0033: stloc.1
		IL_0034: br.s IL_000a

		IL_0036: br.s IL_0038

		IL_0038: ldc.i4 733937667
		IL_003d: stloc 2
		IL_0041: ldloca 2
		IL_0045: nop
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: conv.i
		IL_0049: stloc.1
		IL_004a: br.s IL_000a

		IL_004c: ldloc.0
		IL_004d: ldarg.0
		IL_004e: ldlen
		IL_004f: conv.i4
		IL_0050: blt.s IL_006a

		IL_0052: ldc.i4 368246784
		IL_0057: nop
		IL_0058: stloc 2
		IL_005c: nop
		IL_005d: ldloca 2
		IL_0061: nop
		IL_0062: ldind.i2
		IL_0063: conv.i2
		IL_0064: conv.i
		IL_0065: stloc.1
		IL_0066: br.s IL_000a

		IL_0068: br.s IL_00c1

		IL_006a: ldarg.0
		IL_006b: ldloc.0
		IL_006c: ldelem.u4
		IL_006d: ldarg.1
		IL_006e: ldarg.2
		IL_006f: call void w::w(uint32, uint8[], int32)
		IL_0074: ldarg.2
		IL_0075: ldc.i4.4
		IL_0076: add
		IL_0077: starg.s A_2
		IL_0079: ldloc.0
		IL_007a: ldc.i4.1
		IL_007b: add
		IL_007c: stloc.0

		IL_007d: ldc.i4 636026882
		IL_0082: stloc 2
		IL_0086: ldloca 2
		IL_008a: nop
		IL_008b: ldind.i2
		IL_008c: conv.i2
		IL_008d: conv.i
		IL_008e: stloc.1
		IL_008f: br IL_000a

		IL_0094: br.s IL_00a9

		IL_0096: ldc.i4 790888448
		IL_009b: stloc 2
		IL_009f: nop
		IL_00a0: ldloca 2
		IL_00a4: ldind.i2
		IL_00a5: conv.i2

		IL_00a6: pop
		IL_00a7: br.s IL_00bb

		IL_00a9: ldc.i4 1326186496
		IL_00ae: stloc 2
		IL_00b2: nop
		IL_00b3: ldloca 2
		IL_00b7: ldind.i2
		IL_00b8: conv.i2
		IL_00b9: br.s IL_00a6

		IL_00bb: nop
		IL_00bc: br IL_0038

		IL_00c1: ldc.i4 114049567
		IL_00c6: stloc 2
		IL_00ca: ldloca 2
		IL_00ce: nop
		IL_00cf: ldind.i2
		IL_00d0: conv.i2
		IL_00d1: ldc.i4 1564033567
		IL_00d6: nop
		IL_00d7: stloc 2
		IL_00db: ldloca 2
		IL_00df: ldind.i2
		IL_00e0: conv.i2
		IL_00e1: ceq
		IL_00e3: switch (IL_007d, IL_00f5, IL_007d)

		IL_00f4: nop

		IL_00f5: ldc.i4 2105475073
		IL_00fa: stloc 2
		IL_00fe: ldloca 2
		IL_0102: nop
		IL_0103: ldind.i2
		IL_0104: conv.i2
		IL_0105: br.s IL_0119

		IL_0107: ldc.i4 1018363904
		IL_010c: nop
		IL_010d: stloc 2
		IL_0111: ldloca 2
		IL_0115: ldind.i2
		IL_0116: conv.i2
		IL_0117: br.s IL_0119

		IL_0119: brfalse.s IL_011b

		IL_011b: ldc.i4 1770520576
		IL_0120: nop
		IL_0121: stloc 2
		IL_0125: ldloca 2
		IL_0129: nop
		IL_012a: ldind.i2
		IL_012b: conv.i2
		IL_012c: brfalse IL_0131

		IL_0131: ret
	} // end of method w::w

	.method assembly hidebysig static 
		uint32 r (
			uint8[] A_0
		) cil managed 
	{
		// Method begins at RVA 0x78d8
		// Header size: 12
		// Code size: 181 (0xb5)
		.maxstack 3
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1033109505
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: br.s IL_0026

		IL_0014: ldc.i4 1833959424
		IL_0019: nop
		IL_001a: stloc 0
		IL_001e: ldloca 0
		IL_0022: ldind.i2
		IL_0023: conv.i2
		IL_0024: br.s IL_0026

		IL_0026: brfalse.s IL_0028

		IL_0028: ldc.i4 1494311651
		IL_002d: stloc 0
		IL_0031: nop
		IL_0032: ldloca 0
		IL_0036: ldind.i2
		IL_0037: conv.i2
		IL_0038: ldc.i4 1996186339
		IL_003d: stloc 0
		IL_0041: ldloca 0
		IL_0045: nop
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: ceq
		IL_004a: switch (IL_005b, IL_005c, IL_005b)

		IL_005b: nop

		IL_005c: ldc.i4 1322582016
		IL_0061: nop
		IL_0062: stloc 0
		IL_0066: ldloca 0
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: brfalse IL_0072

		IL_0072: br.s IL_0089

		IL_0074: ldc.i4 447152128
		IL_0079: nop
		IL_007a: stloc 0
		IL_007e: nop
		IL_007f: ldloca 0
		IL_0083: nop
		IL_0084: ldind.i2
		IL_0085: conv.i2

		IL_0086: pop
		IL_0087: br.s IL_009c

		IL_0089: ldc.i4 2069233664
		IL_008e: stloc 0
		IL_0092: nop
		IL_0093: ldloca 0
		IL_0097: nop
		IL_0098: ldind.i2
		IL_0099: conv.i2
		IL_009a: br.s IL_0086

		IL_009c: nop
		IL_009d: ldarg.0
		IL_009e: ldc.i4.0
		IL_009f: ldelem.u1
		IL_00a0: ldarg.0
		IL_00a1: ldc.i4.1
		IL_00a2: ldelem.u1
		IL_00a3: ldc.i4.8
		IL_00a4: shl
		IL_00a5: or
		IL_00a6: ldarg.0
		IL_00a7: ldc.i4.2
		IL_00a8: ldelem.u1
		IL_00a9: ldc.i4.s 16
		IL_00ab: shl
		IL_00ac: or
		IL_00ad: ldarg.0
		IL_00ae: ldc.i4.3
		IL_00af: ldelem.u1
		IL_00b0: ldc.i4.s 24
		IL_00b2: shl
		IL_00b3: or
		IL_00b4: ret
	} // end of method w::r

	.method assembly hidebysig static 
		uint32 r (
			uint8[] A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0x799c
		// Header size: 12
		// Code size: 189 (0xbd)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1320917739
		IL_0005: stloc 0
		IL_0009: ldloca 0
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1500224235
		IL_0015: stloc 0
		IL_0019: ldloca 0
		IL_001d: nop
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_0034, IL_0033)

		IL_0033: nop

		IL_0034: ldc.i4 2105212929
		IL_0039: stloc 0
		IL_003d: nop
		IL_003e: ldloca 0
		IL_0042: nop
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: br.s IL_005b

		IL_0047: ldc.i4 1194852352
		IL_004c: nop
		IL_004d: stloc 0
		IL_0051: nop
		IL_0052: ldloca 0
		IL_0056: nop
		IL_0057: ldind.i2
		IL_0058: conv.i2
		IL_0059: br.s IL_005b

		IL_005b: brfalse.s IL_005d

		IL_005d: ldc.i4 2130903040
		IL_0062: nop
		IL_0063: stloc 0
		IL_0067: nop
		IL_0068: ldloca 0
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: brfalse IL_0074

		IL_0074: br.s IL_008a

		IL_0076: ldc.i4 1007878144
		IL_007b: nop
		IL_007c: stloc 0
		IL_0080: ldloca 0
		IL_0084: nop
		IL_0085: ldind.i2
		IL_0086: conv.i2

		IL_0087: pop
		IL_0088: br.s IL_009e

		IL_008a: ldc.i4 1246363648
		IL_008f: nop
		IL_0090: stloc 0
		IL_0094: nop
		IL_0095: ldloca 0
		IL_0099: nop
		IL_009a: ldind.i2
		IL_009b: conv.i2
		IL_009c: br.s IL_0087

		IL_009e: nop
		IL_009f: ldarg.0
		IL_00a0: ldarg.1
		IL_00a1: ldelem.u1
		IL_00a2: ldarg.0
		IL_00a3: ldarg.1
		IL_00a4: ldc.i4.1
		IL_00a5: add
		IL_00a6: ldelem.u1
		IL_00a7: ldc.i4.8
		IL_00a8: shl
		IL_00a9: or
		IL_00aa: ldarg.0
		IL_00ab: ldarg.1
		IL_00ac: ldc.i4.2
		IL_00ad: add
		IL_00ae: ldelem.u1
		IL_00af: ldc.i4.s 16
		IL_00b1: shl
		IL_00b2: or
		IL_00b3: ldarg.0
		IL_00b4: ldarg.1
		IL_00b5: ldc.i4.3
		IL_00b6: add
		IL_00b7: ldelem.u1
		IL_00b8: ldc.i4.s 24
		IL_00ba: shl
		IL_00bb: or
		IL_00bc: ret
	} // end of method w::r

	.method assembly hidebysig static 
		void w (
			uint8[] A_0,
			int32 A_1,
			uint32[] A_2
		) cil managed 
	{
		// Method begins at RVA 0x7a68
		// Header size: 12
		// Code size: 309 (0x135)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4 2048065537
		IL_0005: stloc 2
		IL_0009: ldloca 2
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: br.s IL_0026

		IL_0012: ldc.i4 711131136
		IL_0017: nop
		IL_0018: stloc 2
		IL_001c: nop
		IL_001d: ldloca 2
		IL_0021: nop
		IL_0022: ldind.i2
		IL_0023: conv.i2
		IL_0024: br.s IL_0026

		IL_0026: brfalse.s IL_0028

		IL_0028: ldc.i4.0
		IL_0029: switch (IL_0048)

		IL_0032: ldloc.1
		IL_0033: switch (IL_008f, IL_005e, IL_00e5, IL_0075)

		IL_0048: ldc.i4.0
		IL_0049: stloc.0
		IL_004a: ldc.i4 689176577
		IL_004f: stloc 2
		IL_0053: ldloca 2
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: conv.i
		IL_005b: stloc.1
		IL_005c: br.s IL_0032

		IL_005e: br.s IL_0060

		IL_0060: ldc.i4 460521475
		IL_0065: nop
		IL_0066: stloc 2
		IL_006a: nop
		IL_006b: ldloca 2
		IL_006f: ldind.i2
		IL_0070: conv.i2
		IL_0071: conv.i
		IL_0072: stloc.1
		IL_0073: br.s IL_0032

		IL_0075: ldloc.0
		IL_0076: ldarg.2
		IL_0077: ldlen
		IL_0078: conv.i4
		IL_0079: blt.s IL_0091

		IL_007b: ldc.i4 432603136
		IL_0080: stloc 2
		IL_0084: ldloca 2
		IL_0088: nop
		IL_0089: ldind.i2
		IL_008a: conv.i2
		IL_008b: conv.i
		IL_008c: stloc.1
		IL_008d: br.s IL_0032

		IL_008f: br.s IL_00ea

		IL_0091: ldarg.2
		IL_0092: ldloc.0
		IL_0093: ldarg.0
		IL_0094: ldarg.1
		IL_0095: call uint32 w::r(uint8[], int32)
		IL_009a: stelem.i4
		IL_009b: ldarg.1
		IL_009c: ldc.i4.4
		IL_009d: add
		IL_009e: starg.s A_1
		IL_00a0: ldloc.0
		IL_00a1: ldc.i4.1
		IL_00a2: add
		IL_00a3: stloc.0

		IL_00a4: br.s IL_00ba

		IL_00a6: ldc.i4 440008704
		IL_00ab: nop
		IL_00ac: stloc 2
		IL_00b0: ldloca 2
		IL_00b4: nop
		IL_00b5: ldind.i2
		IL_00b6: conv.i2

		IL_00b7: pop
		IL_00b8: br.s IL_00cc

		IL_00ba: ldc.i4 532283392
		IL_00bf: stloc 2
		IL_00c3: ldloca 2
		IL_00c7: nop
		IL_00c8: ldind.i2
		IL_00c9: conv.i2
		IL_00ca: br.s IL_00b7

		IL_00cc: nop
		IL_00cd: ldc.i4 1350959106
		IL_00d2: nop
		IL_00d3: stloc 2
		IL_00d7: nop
		IL_00d8: ldloca 2
		IL_00dc: ldind.i2
		IL_00dd: conv.i2
		IL_00de: conv.i
		IL_00df: stloc.1
		IL_00e0: br IL_0032

		IL_00e5: br IL_0060

		IL_00ea: ldc.i4 297147310
		IL_00ef: nop
		IL_00f0: stloc 2
		IL_00f4: ldloca 2
		IL_00f8: nop
		IL_00f9: ldind.i2
		IL_00fa: conv.i2
		IL_00fb: ldc.i4 694229934
		IL_0100: stloc 2
		IL_0104: nop
		IL_0105: ldloca 2
		IL_0109: ldind.i2
		IL_010a: conv.i2
		IL_010b: ceq
		IL_010d: switch (IL_00a4, IL_011f, IL_00a4)

		IL_011e: nop

		IL_011f: ldc.i4 1333788672
		IL_0124: stloc 2
		IL_0128: ldloca 2
		IL_012c: nop
		IL_012d: ldind.i2
		IL_012e: conv.i2
		IL_012f: brfalse IL_0134

		IL_0134: ret
	} // end of method w::w

	.method assembly hidebysig static 
		void w (
			uint8[] A_0,
			int32 A_1,
			uint32[] A_2,
			int32 A_3,
			int32 A_4
		) cil managed 
	{
		// Method begins at RVA 0x7bac
		// Header size: 12
		// Code size: 312 (0x138)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0020)

		IL_000a: ldloc.1
		IL_000b: switch (IL_0067, IL_0037, IL_0095, IL_004d)

		IL_0020: ldc.i4.0
		IL_0021: stloc.0
		IL_0022: ldc.i4 293208065
		IL_0027: stloc 2
		IL_002b: nop
		IL_002c: ldloca 2
		IL_0030: nop
		IL_0031: ldind.i2
		IL_0032: conv.i2
		IL_0033: conv.i
		IL_0034: stloc.1
		IL_0035: br.s IL_000a

		IL_0037: br.s IL_0039

		IL_0039: ldc.i4 288489475
		IL_003e: stloc 2
		IL_0042: ldloca 2
		IL_0046: nop
		IL_0047: ldind.i2
		IL_0048: conv.i2
		IL_0049: conv.i
		IL_004a: stloc.1
		IL_004b: br.s IL_000a

		IL_004d: ldloc.0
		IL_004e: ldarg.s A_4
		IL_0050: blt.s IL_0069

		IL_0052: ldc.i4 1389494272
		IL_0057: stloc 2
		IL_005b: nop
		IL_005c: ldloca 2
		IL_0060: nop
		IL_0061: ldind.i2
		IL_0062: conv.i2
		IL_0063: conv.i
		IL_0064: stloc.1
		IL_0065: br.s IL_000a

		IL_0067: br.s IL_00c4

		IL_0069: ldarg.2
		IL_006a: ldarg.3
		IL_006b: ldloc.0
		IL_006c: add
		IL_006d: ldarg.0
		IL_006e: ldarg.1
		IL_006f: call uint32 w::r(uint8[], int32)
		IL_0074: stelem.i4
		IL_0075: ldarg.1
		IL_0076: ldc.i4.4
		IL_0077: add
		IL_0078: starg.s A_1
		IL_007a: ldloc.0
		IL_007b: ldc.i4.1
		IL_007c: add
		IL_007d: stloc.0

		IL_007e: ldc.i4 1401356290
		IL_0083: stloc 2
		IL_0087: nop
		IL_0088: ldloca 2
		IL_008c: ldind.i2
		IL_008d: conv.i2
		IL_008e: conv.i
		IL_008f: stloc.1
		IL_0090: br IL_000a

		IL_0095: br.s IL_00ac

		IL_0097: ldc.i4 1466040320
		IL_009c: nop
		IL_009d: stloc 2
		IL_00a1: nop
		IL_00a2: ldloca 2
		IL_00a6: nop
		IL_00a7: ldind.i2
		IL_00a8: conv.i2

		IL_00a9: pop
		IL_00aa: br.s IL_00be

		IL_00ac: ldc.i4 1607532544
		IL_00b1: stloc 2
		IL_00b5: ldloca 2
		IL_00b9: nop
		IL_00ba: ldind.i2
		IL_00bb: conv.i2
		IL_00bc: br.s IL_00a9

		IL_00be: nop
		IL_00bf: br IL_0039

		IL_00c4: ldc.i4 2103644715
		IL_00c9: stloc 2
		IL_00cd: ldloca 2
		IL_00d1: nop
		IL_00d2: ldind.i2
		IL_00d3: conv.i2
		IL_00d4: ldc.i4 1027281451
		IL_00d9: nop
		IL_00da: stloc 2
		IL_00de: nop
		IL_00df: ldloca 2
		IL_00e3: nop
		IL_00e4: ldind.i2
		IL_00e5: conv.i2
		IL_00e6: ceq
		IL_00e8: switch (IL_007e, IL_00fa, IL_007e)

		IL_00f9: nop

		IL_00fa: ldc.i4 598147073
		IL_00ff: stloc 2
		IL_0103: nop
		IL_0104: ldloca 2
		IL_0108: ldind.i2
		IL_0109: conv.i2
		IL_010a: br.s IL_011f

		IL_010c: ldc.i4 1711276032
		IL_0111: nop
		IL_0112: stloc 2
		IL_0116: nop
		IL_0117: ldloca 2
		IL_011b: ldind.i2
		IL_011c: conv.i2
		IL_011d: br.s IL_011f

		IL_011f: brfalse.s IL_0121

		IL_0121: ldc.i4 776404992
		IL_0126: nop
		IL_0127: stloc 2
		IL_012b: nop
		IL_012c: ldloca 2
		IL_0130: ldind.i2
		IL_0131: conv.i2
		IL_0132: brfalse IL_0137

		IL_0137: ret
	} // end of method w::w

	.method assembly hidebysig static 
		uint8[] w (
			uint64 A_0
		) cil managed 
	{
		// Method begins at RVA 0x7cf0
		// Header size: 12
		// Code size: 170 (0xaa)
		.maxstack 3
		.locals init (
			[0] uint8[],
			[1] int16
		)

		IL_0000: ldc.i4 185922332
		IL_0005: stloc 1
		IL_0009: nop
		IL_000a: ldloca 1
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1770386204
		IL_0015: stloc 1
		IL_0019: nop
		IL_001a: ldloca 1
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 693764097
		IL_003a: nop
		IL_003b: stloc 1
		IL_003f: ldloca 1
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: br.s IL_0059

		IL_0047: ldc.i4 505937920
		IL_004c: stloc 1
		IL_0050: nop
		IL_0051: ldloca 1
		IL_0055: ldind.i2
		IL_0056: conv.i2
		IL_0057: br.s IL_0059

		IL_0059: brfalse.s IL_005b

		IL_005b: ldc.i4 1774452736
		IL_0060: nop
		IL_0061: stloc 1
		IL_0065: ldloca 1
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: brfalse IL_0071

		IL_0071: br.s IL_0086

		IL_0073: ldc.i4 1220935680
		IL_0078: stloc 1
		IL_007c: ldloca 1
		IL_0080: nop
		IL_0081: ldind.i2
		IL_0082: conv.i2

		IL_0083: pop
		IL_0084: br.s IL_0098

		IL_0086: ldc.i4 787152896
		IL_008b: nop
		IL_008c: stloc 1
		IL_0090: ldloca 1
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: br.s IL_0083

		IL_0098: nop
		IL_0099: ldc.i4.8
		IL_009a: newarr [mscorlib]System.Byte
		IL_009f: stloc.0
		IL_00a0: ldarg.0
		IL_00a1: ldloc.0
		IL_00a2: ldc.i4.0
		IL_00a3: call void w::w(uint64, uint8[], int32)
		IL_00a8: ldloc.0
		IL_00a9: ret
	} // end of method w::w

	.method assembly hidebysig static 
		void w (
			uint64 A_0,
			uint8[] A_1
		) cil managed 
	{
		// Method begins at RVA 0x7da8
		// Header size: 12
		// Code size: 178 (0xb2)
		.maxstack 3
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 2030464470
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1507028438
		IL_0016: nop
		IL_0017: stloc 0
		IL_001b: nop
		IL_001c: ldloca 0
		IL_0020: nop
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: ceq
		IL_0025: switch (IL_0036, IL_0037, IL_0036)

		IL_0036: nop

		IL_0037: ldc.i4 1856897025
		IL_003c: nop
		IL_003d: stloc 0
		IL_0041: ldloca 0
		IL_0045: nop
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: br.s IL_005c

		IL_004a: ldc.i4 1057488896
		IL_004f: stloc 0
		IL_0053: ldloca 0
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_005c

		IL_005c: brfalse.s IL_005e

		IL_005e: ldc.i4 295174144
		IL_0063: nop
		IL_0064: stloc 0
		IL_0068: ldloca 0
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: brfalse IL_0074

		IL_0074: br.s IL_0089

		IL_0076: ldc.i4 1497497600
		IL_007b: stloc 0
		IL_007f: nop
		IL_0080: ldloca 0
		IL_0084: ldind.i2
		IL_0085: conv.i2

		IL_0086: pop
		IL_0087: br.s IL_009c

		IL_0089: ldc.i4 1380384768
		IL_008e: stloc 0
		IL_0092: nop
		IL_0093: ldloca 0
		IL_0097: nop
		IL_0098: ldind.i2
		IL_0099: conv.i2
		IL_009a: br.s IL_0086

		IL_009c: nop
		IL_009d: ldarg.0
		IL_009e: conv.u4
		IL_009f: ldarg.1
		IL_00a0: call void w::w(uint32, uint8[])
		IL_00a5: ldarg.0
		IL_00a6: ldc.i4.s 32
		IL_00a8: shr.un
		IL_00a9: conv.u4
		IL_00aa: ldarg.1
		IL_00ab: ldc.i4.4
		IL_00ac: call void w::w(uint32, uint8[], int32)
		IL_00b1: ret
	} // end of method w::w

	.method assembly hidebysig static 
		void w (
			uint64 A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x7e68
		// Header size: 12
		// Code size: 180 (0xb4)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 2111592845
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1820088717
		IL_0016: nop
		IL_0017: stloc 0
		IL_001b: nop
		IL_001c: ldloca 0
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0036, IL_0035)

		IL_0035: nop

		IL_0036: ldc.i4 773652481
		IL_003b: stloc 0
		IL_003f: ldloca 0
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: br.s IL_005b

		IL_0048: ldc.i4 197263360
		IL_004d: nop
		IL_004e: stloc 0
		IL_0052: ldloca 0
		IL_0056: nop
		IL_0057: ldind.i2
		IL_0058: conv.i2
		IL_0059: br.s IL_005b

		IL_005b: brfalse.s IL_005d

		IL_005d: ldc.i4 679739392
		IL_0062: stloc 0
		IL_0066: nop
		IL_0067: ldloca 0
		IL_006b: nop
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: brfalse IL_0073

		IL_0073: br.s IL_0088

		IL_0075: ldc.i4 218300416
		IL_007a: stloc 0
		IL_007e: nop
		IL_007f: ldloca 0
		IL_0083: ldind.i2
		IL_0084: conv.i2

		IL_0085: pop
		IL_0086: br.s IL_009b

		IL_0088: ldc.i4 1632305152
		IL_008d: nop
		IL_008e: stloc 0
		IL_0092: ldloca 0
		IL_0096: nop
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: br.s IL_0085

		IL_009b: nop
		IL_009c: ldarg.0
		IL_009d: conv.u4
		IL_009e: ldarg.1
		IL_009f: ldarg.2
		IL_00a0: call void w::w(uint32, uint8[], int32)
		IL_00a5: ldarg.0
		IL_00a6: ldc.i4.s 32
		IL_00a8: shr.un
		IL_00a9: conv.u4
		IL_00aa: ldarg.1
		IL_00ab: ldarg.2
		IL_00ac: ldc.i4.4
		IL_00ad: add
		IL_00ae: call void w::w(uint32, uint8[], int32)
		IL_00b3: ret
	} // end of method w::w

	.method assembly hidebysig static 
		uint64 w (
			uint8[] A_0
		) cil managed 
	{
		// Method begins at RVA 0x7f28
		// Header size: 12
		// Code size: 177 (0xb1)
		.maxstack 2
		.locals init (
			[0] uint32,
			[1] int16
		)

		IL_0000: ldc.i4 144322816
		IL_0005: stloc 1
		IL_0009: nop
		IL_000a: ldloca 1
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 98185472
		IL_0016: nop
		IL_0017: stloc 1
		IL_001b: nop
		IL_001c: ldloca 1
		IL_0020: nop
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: ceq
		IL_0025: switch (IL_0036, IL_0037, IL_0036)

		IL_0036: nop

		IL_0037: ldc.i4 2085617665
		IL_003c: stloc 1
		IL_0040: nop
		IL_0041: ldloca 1
		IL_0045: ldind.i2
		IL_0046: conv.i2
		IL_0047: br.s IL_005b

		IL_0049: ldc.i4 271253504
		IL_004e: stloc 1
		IL_0052: ldloca 1
		IL_0056: nop
		IL_0057: ldind.i2
		IL_0058: conv.i2
		IL_0059: br.s IL_005b

		IL_005b: brfalse.s IL_005d

		IL_005d: ldc.i4 258605056
		IL_0062: stloc 1
		IL_0066: ldloca 1
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: brfalse IL_0072

		IL_0072: br.s IL_0087

		IL_0074: ldc.i4 449839104
		IL_0079: stloc 1
		IL_007d: ldloca 1
		IL_0081: nop
		IL_0082: ldind.i2
		IL_0083: conv.i2

		IL_0084: pop
		IL_0085: br.s IL_009a

		IL_0087: ldc.i4 1799553024
		IL_008c: nop
		IL_008d: stloc 1
		IL_0091: nop
		IL_0092: ldloca 1
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: br.s IL_0084

		IL_009a: nop
		IL_009b: ldarg.0
		IL_009c: call uint32 w::r(uint8[])
		IL_00a1: stloc.0
		IL_00a2: ldarg.0
		IL_00a3: ldc.i4.4
		IL_00a4: call uint32 w::r(uint8[], int32)
		IL_00a9: conv.u8
		IL_00aa: ldc.i4.s 32
		IL_00ac: shl
		IL_00ad: ldloc.0
		IL_00ae: conv.u8
		IL_00af: or
		IL_00b0: ret
	} // end of method w::w

	.method assembly hidebysig static 
		uint64 w (
			uint8[] A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0x7fe8
		// Header size: 12
		// Code size: 180 (0xb4)
		.maxstack 3
		.locals init (
			[0] uint32,
			[1] int16
		)

		IL_0000: ldc.i4 2064418774
		IL_0005: stloc 1
		IL_0009: ldloca 1
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 203917270
		IL_0015: stloc 1
		IL_0019: ldloca 1
		IL_001d: nop
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_0034, IL_0033)

		IL_0033: nop

		IL_0034: ldc.i4 414056449
		IL_0039: nop
		IL_003a: stloc 1
		IL_003e: ldloca 1
		IL_0042: nop
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: br.s IL_005a

		IL_0047: ldc.i4 1027866624
		IL_004c: nop
		IL_004d: stloc 1
		IL_0051: nop
		IL_0052: ldloca 1
		IL_0056: ldind.i2
		IL_0057: conv.i2
		IL_0058: br.s IL_005a

		IL_005a: brfalse.s IL_005c

		IL_005c: ldc.i4 1395785728
		IL_0061: stloc 1
		IL_0065: nop
		IL_0066: ldloca 1
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: brfalse IL_0072

		IL_0072: br.s IL_0087

		IL_0074: ldc.i4 1928986624
		IL_0079: stloc 1
		IL_007d: ldloca 1
		IL_0081: nop
		IL_0082: ldind.i2
		IL_0083: conv.i2

		IL_0084: pop
		IL_0085: br.s IL_009a

		IL_0087: ldc.i4 481230848
		IL_008c: nop
		IL_008d: stloc 1
		IL_0091: ldloca 1
		IL_0095: nop
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: br.s IL_0084

		IL_009a: nop
		IL_009b: ldarg.0
		IL_009c: ldarg.1
		IL_009d: call uint32 w::r(uint8[], int32)
		IL_00a2: stloc.0
		IL_00a3: ldarg.0
		IL_00a4: ldarg.1
		IL_00a5: ldc.i4.4
		IL_00a6: add
		IL_00a7: call uint32 w::r(uint8[], int32)
		IL_00ac: conv.u8
		IL_00ad: ldc.i4.s 32
		IL_00af: shl
		IL_00b0: ldloc.0
		IL_00b1: conv.u8
		IL_00b2: or
		IL_00b3: ret
	} // end of method w::w

} // end of class w

.class public auto ansi abstract sealed beforefieldinit ODCrypt.CryptUtil
	extends [mscorlib]System.Object
{
	// Methods
	.method public hidebysig static 
		!!T Random<T> () cil managed 
	{
		// Method begins at RVA 0x80a8
		// Header size: 12
		// Code size: 2877 (0xb3d)
		.maxstack 2
		.locals init (
			[0] class [mscorlib]System.Type,
			[1] class [mscorlib]System.Security.Cryptography.RandomNumberGenerator,
			[2] uint8[],
			[3] !!T,
			[4] uint8[],
			[5] uint8[],
			[6] uint8[],
			[7] uint8[],
			[8] uint8[],
			[9] uint8[],
			[10] uint8[],
			[11] uint8[],
			[12] uint8[],
			[13] uint8[],
			[14] uint8[],
			[15] uint8[],
			[16] int32,
			[17] int16,
			[18] int32
		)

		IL_0000: ldc.i4 18
		IL_0005: stloc 18
		IL_0009: ldc.i4 611319808
		IL_000e: nop
		IL_000f: stloc 17
		IL_0013: nop
		IL_0014: ldloca 17
		IL_0018: nop
		IL_0019: ldind.i2
		IL_001a: conv.i2
		IL_001b: stloc.s 16
		IL_001d: ldloc.s 16
		IL_001f: switch (IL_0028)

		IL_0028: ldc.i4.0
		IL_0029: switch (IL_0055)

		IL_0032: ldloc.s 16
		IL_0034: switch (IL_0076, IL_01a5, IL_0af4, IL_0093, IL_00b7, IL_00e8, IL_0b22)

		IL_0055: ldtoken !!T
		IL_005a: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
		IL_005f: stloc.0
		IL_0060: ldc.i4 2052390912
		IL_0065: stloc 17
		IL_0069: nop
		IL_006a: ldloca 17
		IL_006e: nop
		IL_006f: ldind.i2
		IL_0070: conv.i2
		IL_0071: conv.i
		IL_0072: stloc.s 16
		IL_0074: br.s IL_0032

		IL_0076: ldloc.0
		IL_0077: callvirt instance bool [mscorlib]System.Type::get_IsValueType()
		IL_007c: brtrue.s IL_00d0

		IL_007e: ldc.i4 47316995
		IL_0083: nop
		IL_0084: stloc 17
		IL_0088: ldloca 17
		IL_008c: ldind.i2
		IL_008d: conv.i2
		IL_008e: conv.i
		IL_008f: stloc.s 16
		IL_0091: br.s IL_0032

		IL_0093: br IL_01aa

		IL_0098: newobj instance void [mscorlib]System.Security.Cryptography.RNGCryptoServiceProvider::.ctor()
		IL_009d: stloc.1
		IL_009e: ldc.i4 1266679812
		IL_00a3: stloc 17
		IL_00a7: nop
		IL_00a8: ldloca 17
		IL_00ac: nop
		IL_00ad: ldind.i2
		IL_00ae: conv.i2
		IL_00af: conv.i
		IL_00b0: stloc.s 16
		IL_00b2: br IL_0032

		IL_00b7: br IL_01be

		IL_00bc: ldstr "??k??????????????????????"
		IL_00c1: ldloc 18
		IL_00c5: call string ODCrypt.Sha3::b(string, int32)
		IL_00ca: newobj instance void [mscorlib]System.ApplicationException::.ctor(string)
		IL_00cf: throw

		IL_00d0: ldc.i4 755171333
		IL_00d5: nop
		IL_00d6: stloc 17
		IL_00da: ldloca 17
		IL_00de: ldind.i2
		IL_00df: conv.i2
		IL_00e0: conv.i
		IL_00e1: stloc.s 16
		IL_00e3: br IL_0032

		IL_00e8: ldc.i4 738206582
		IL_00ed: stloc 17
		IL_00f1: ldloca 17
		IL_00f5: nop
		IL_00f6: ldind.i2
		IL_00f7: conv.i2
		IL_00f8: ldc.i4 723067766
		IL_00fd: stloc 17
		IL_0101: ldloca 17
		IL_0105: nop
		IL_0106: ldind.i2
		IL_0107: conv.i2
		IL_0108: ceq
		IL_010a: switch (IL_01a5, IL_011c, IL_01a5)

		IL_011b: nop

		IL_011c: ldc.i4 87293953
		IL_0121: stloc 17
		IL_0125: nop
		IL_0126: ldloca 17
		IL_012a: nop
		IL_012b: ldind.i2
		IL_012c: conv.i2
		IL_012d: br.s IL_0142

		IL_012f: ldc.i4 1353580544
		IL_0134: nop
		IL_0135: stloc 17
		IL_0139: ldloca 17
		IL_013d: nop
		IL_013e: ldind.i2
		IL_013f: conv.i2
		IL_0140: br.s IL_0142

		IL_0142: brfalse.s IL_0144

		IL_0144: ldc.i4 547356672
		IL_0149: stloc 17
		IL_014d: ldloca 17
		IL_0151: nop
		IL_0152: ldind.i2
		IL_0153: conv.i2
		IL_0154: brfalse IL_0159

		IL_0159: br.s IL_016e

		IL_015b: ldc.i4 1053622272
		IL_0160: stloc 17
		IL_0164: ldloca 17
		IL_0168: nop
		IL_0169: ldind.i2
		IL_016a: conv.i2

		IL_016b: pop
		IL_016c: br.s IL_0180

		IL_016e: ldc.i4 1117519872
		IL_0173: stloc 17
		IL_0177: ldloca 17
		IL_017b: nop
		IL_017c: ldind.i2
		IL_017d: conv.i2
		IL_017e: br.s IL_016b

		IL_0180: nop
		IL_0181: ldloc.0
		IL_0182: callvirt instance bool [mscorlib]System.Type::get_IsEnum()
		IL_0187: brfalse IL_0adc

		IL_018c: ldc.i4 1809186817
		IL_0191: stloc 17
		IL_0195: nop
		IL_0196: ldloca 17
		IL_019a: nop
		IL_019b: ldind.i2
		IL_019c: conv.i2
		IL_019d: conv.i
		IL_019e: stloc.s 16
		IL_01a0: br IL_0032

		IL_01a5: br IL_0b27

		IL_01aa: ldstr "??k????????????????\uda8d????"
		IL_01af: ldloc 18
		IL_01b3: call string ODCrypt.Sha3::b(string, int32)
		IL_01b8: newobj instance void [mscorlib]System.ApplicationException::.ctor(string)
		IL_01bd: throw
		.try
		{
			IL_01be: ldc.i4 893059083
			IL_01c3: nop
			IL_01c4: stloc 17
			IL_01c8: ldloca 17
			IL_01cc: ldind.i2
			IL_01cd: conv.i2
			IL_01ce: conv.i
			IL_01cf: stloc.s 16
			IL_01d1: br.s IL_01dd
			// loop start (head: IL_01dd)
				IL_01d3: ldc.i4.0
				IL_01d4: switch (IL_028c)

				IL_01dd: ldloc.s 16
				IL_01df: switch (IL_0701, IL_08ef, IL_0832, IL_04bd, IL_09cd, IL_093a, IL_071e, IL_044e, IL_0501, IL_03e2, IL_08a9, IL_01d3, IL_03b3, IL_0689, IL_09ea, IL_058f, IL_07eb, IL_0323, IL_0a43, IL_0306, IL_0548, IL_042f, IL_0396, IL_0980, IL_047b, IL_07be, IL_074b, IL_02ba, IL_090d, IL_05d6, IL_0a14, IL_0350, IL_07a1, IL_040d, IL_06b6, IL_0878, IL_063f, IL_05f3, IL_0622, IL_066c, IL_06d4, IL_099f)
			// end loop

			IL_028c: ldloc.0
			IL_028d: ldtoken [mscorlib]System.Boolean
			IL_0292: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_0297: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_029c: brfalse IL_06bb

			IL_02a1: ldc.i4 1941045275
			IL_02a6: stloc 17
			IL_02aa: nop
			IL_02ab: ldloca 17
			IL_02af: nop
			IL_02b0: ldind.i2
			IL_02b1: conv.i2
			IL_02b2: conv.i
			IL_02b3: stloc.s 16
			IL_02b5: br IL_01dd

			IL_02ba: br IL_03e7

			IL_02bf: ldc.i4.1
			IL_02c0: newarr [mscorlib]System.Byte
			IL_02c5: stloc.s 5
			IL_02c7: ldloc.1
			IL_02c8: ldloc.s 5
			IL_02ca: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_02cf: ldloc.s 5
			IL_02d1: ldc.i4.0
			IL_02d2: ldelem.u1
			IL_02d3: ldc.i4.s 127
			IL_02d5: rem
			IL_02d6: call int8 [mscorlib]System.Convert::ToSByte(int32)
			IL_02db: box [mscorlib]System.SByte
			IL_02e0: ldloc.0
			IL_02e1: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_02e6: unbox.any !!T
			IL_02eb: stloc.3
			IL_02ec: ldc.i4 574816275
			IL_02f1: nop
			IL_02f2: stloc 17
			IL_02f6: nop
			IL_02f7: ldloca 17
			IL_02fb: nop
			IL_02fc: ldind.i2
			IL_02fd: conv.i2
			IL_02fe: conv.i
			IL_02ff: stloc.s 16
			IL_0301: br IL_01dd

			IL_0306: leave IL_0b3b

			IL_030b: ldc.i4 1289945105
			IL_0310: stloc 17
			IL_0314: ldloca 17
			IL_0318: nop
			IL_0319: ldind.i2
			IL_031a: conv.i2
			IL_031b: conv.i
			IL_031c: stloc.s 16
			IL_031e: br IL_01dd

			IL_0323: ldloc.0
			IL_0324: ldtoken [mscorlib]System.UInt64
			IL_0329: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_032e: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_0333: brfalse IL_09d2

			IL_0338: ldc.i4 254803999
			IL_033d: stloc 17
			IL_0341: ldloca 17
			IL_0345: nop
			IL_0346: ldind.i2
			IL_0347: conv.i2
			IL_0348: conv.i
			IL_0349: stloc.s 16
			IL_034b: br IL_01dd

			IL_0350: br IL_0506

			IL_0355: ldc.i4.2
			IL_0356: newarr [mscorlib]System.Byte
			IL_035b: stloc.s 15
			IL_035d: ldloc.1
			IL_035e: ldloc.s 15
			IL_0360: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_0365: ldloc.s 15
			IL_0367: ldc.i4.0
			IL_0368: call uint16 [mscorlib]System.BitConverter::ToUInt16(uint8[], int32)
			IL_036d: box [mscorlib]System.UInt16
			IL_0372: ldloc.0
			IL_0373: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_0378: unbox.any !!T
			IL_037d: stloc.3
			IL_037e: ldc.i4 1930035222
			IL_0383: nop
			IL_0384: stloc 17
			IL_0388: ldloca 17
			IL_038c: ldind.i2
			IL_038d: conv.i2
			IL_038e: conv.i
			IL_038f: stloc.s 16
			IL_0391: br IL_01dd

			IL_0396: leave IL_0b3b

			IL_039b: ldc.i4 1222377484
			IL_03a0: stloc 17
			IL_03a4: ldloca 17
			IL_03a8: nop
			IL_03a9: ldind.i2
			IL_03aa: conv.i2
			IL_03ab: conv.i
			IL_03ac: stloc.s 16
			IL_03ae: br IL_01dd

			IL_03b3: ldloc.0
			IL_03b4: ldtoken [mscorlib]System.Double
			IL_03b9: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_03be: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_03c3: brfalse IL_05db

			IL_03c8: ldc.i4 240910345
			IL_03cd: nop
			IL_03ce: stloc 17
			IL_03d2: nop
			IL_03d3: ldloca 17
			IL_03d7: nop
			IL_03d8: ldind.i2
			IL_03d9: conv.i2
			IL_03da: conv.i
			IL_03db: stloc.s 16
			IL_03dd: br IL_01dd

			IL_03e2: br IL_0594

			IL_03e7: ldc.i4.1
			IL_03e8: newarr [mscorlib]System.Byte
			IL_03ed: stloc.2
			IL_03ee: ldloc.1
			IL_03ef: ldloc.2
			IL_03f0: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_03f5: ldc.i4 304414753
			IL_03fa: stloc 17
			IL_03fe: nop
			IL_03ff: ldloca 17
			IL_0403: ldind.i2
			IL_0404: conv.i2
			IL_0405: conv.i
			IL_0406: stloc.s 16
			IL_0408: br IL_01dd

			IL_040d: ldloc.2
			IL_040e: ldc.i4.0
			IL_040f: ldelem.u1
			IL_0410: ldc.i4.2
			IL_0411: rem
			IL_0412: brtrue IL_0a19

			IL_0417: ldc.i4 870121493
			IL_041c: stloc 17
			IL_0420: nop
			IL_0421: ldloca 17
			IL_0425: ldind.i2
			IL_0426: conv.i2
			IL_0427: conv.i
			IL_0428: stloc.s 16
			IL_042a: br IL_01dd

			IL_042f: br IL_087d

			IL_0434: ldc.i4 2032730119
			IL_0439: nop
			IL_043a: stloc 17
			IL_043e: nop
			IL_043f: ldloca 17
			IL_0443: nop
			IL_0444: ldind.i2
			IL_0445: conv.i2
			IL_0446: conv.i
			IL_0447: stloc.s 16
			IL_0449: br IL_01dd

			IL_044e: ldloc.0
			IL_044f: ldtoken [mscorlib]System.SByte
			IL_0454: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_0459: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_045e: brfalse IL_07a6

			IL_0463: ldc.i4 238419992
			IL_0468: stloc 17
			IL_046c: nop
			IL_046d: ldloca 17
			IL_0471: ldind.i2
			IL_0472: conv.i2
			IL_0473: conv.i
			IL_0474: stloc.s 16
			IL_0476: br IL_01dd

			IL_047b: br IL_02bf

			IL_0480: ldc.i4.1
			IL_0481: newarr [mscorlib]System.Byte
			IL_0486: stloc.s 4
			IL_0488: ldloc.1
			IL_0489: ldloc.s 4
			IL_048b: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_0490: ldloc.s 4
			IL_0492: ldc.i4.0
			IL_0493: ldelem.u1
			IL_0494: box [mscorlib]System.Byte
			IL_0499: ldloc.0
			IL_049a: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_049f: unbox.any !!T
			IL_04a4: stloc.3
			IL_04a5: ldc.i4 1553006595
			IL_04aa: stloc 17
			IL_04ae: ldloca 17
			IL_04b2: nop
			IL_04b3: ldind.i2
			IL_04b4: conv.i2
			IL_04b5: conv.i
			IL_04b6: stloc.s 16
			IL_04b8: br IL_01dd

			IL_04bd: leave IL_0b3b

			IL_04c2: ldc.i4.1
			IL_04c3: newarr [mscorlib]System.Byte
			IL_04c8: stloc.s 6
			IL_04ca: ldloc.1
			IL_04cb: ldloc.s 6
			IL_04cd: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_04d2: ldloc.s 6
			IL_04d4: ldc.i4.0
			IL_04d5: ldelem.u1
			IL_04d6: box [mscorlib]System.Byte
			IL_04db: ldloc.0
			IL_04dc: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_04e1: unbox.any !!T
			IL_04e6: stloc.3
			IL_04e7: ldc.i4 791543816
			IL_04ec: nop
			IL_04ed: stloc 17
			IL_04f1: nop
			IL_04f2: ldloca 17
			IL_04f6: nop
			IL_04f7: ldind.i2
			IL_04f8: conv.i2
			IL_04f9: conv.i
			IL_04fa: stloc.s 16
			IL_04fc: br IL_01dd

			IL_0501: leave IL_0b3b

			IL_0506: ldc.i4.8
			IL_0507: newarr [mscorlib]System.Byte
			IL_050c: stloc.s 14
			IL_050e: ldloc.1
			IL_050f: ldloc.s 14
			IL_0511: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_0516: ldloc.s 14
			IL_0518: ldc.i4.0
			IL_0519: call uint64 [mscorlib]System.BitConverter::ToUInt64(uint8[], int32)
			IL_051e: box [mscorlib]System.UInt64
			IL_0523: ldloc.0
			IL_0524: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_0529: unbox.any !!T
			IL_052e: stloc.3
			IL_052f: ldc.i4 214433812
			IL_0534: stloc 17
			IL_0538: nop
			IL_0539: ldloca 17
			IL_053d: nop
			IL_053e: ldind.i2
			IL_053f: conv.i2
			IL_0540: conv.i
			IL_0541: stloc.s 16
			IL_0543: br IL_01dd

			IL_0548: leave IL_0b3b

			IL_054d: ldc.i4.2
			IL_054e: newarr [mscorlib]System.Byte
			IL_0553: stloc.s 12
			IL_0555: ldloc.1
			IL_0556: ldloc.s 12
			IL_0558: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_055d: ldloc.s 12
			IL_055f: ldc.i4.0
			IL_0560: call int16 [mscorlib]System.BitConverter::ToInt16(uint8[], int32)
			IL_0565: box [mscorlib]System.Int16
			IL_056a: ldloc.0
			IL_056b: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_0570: unbox.any !!T
			IL_0575: stloc.3
			IL_0576: ldc.i4 1044447247
			IL_057b: stloc 17
			IL_057f: nop
			IL_0580: ldloca 17
			IL_0584: nop
			IL_0585: ldind.i2
			IL_0586: conv.i2
			IL_0587: conv.i
			IL_0588: stloc.s 16
			IL_058a: br IL_01dd

			IL_058f: leave IL_0b3b

			IL_0594: ldc.i4.8
			IL_0595: newarr [mscorlib]System.Byte
			IL_059a: stloc.s 8
			IL_059c: ldloc.1
			IL_059d: ldloc.s 8
			IL_059f: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_05a4: ldloc.s 8
			IL_05a6: ldc.i4.0
			IL_05a7: call float64 [mscorlib]System.BitConverter::ToDouble(uint8[], int32)
			IL_05ac: box [mscorlib]System.Double
			IL_05b1: ldloc.0
			IL_05b2: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_05b7: unbox.any !!T
			IL_05bc: stloc.3
			IL_05bd: ldc.i4 1279459357
			IL_05c2: nop
			IL_05c3: stloc 17
			IL_05c7: ldloca 17
			IL_05cb: nop
			IL_05cc: ldind.i2
			IL_05cd: conv.i2
			IL_05ce: conv.i
			IL_05cf: stloc.s 16
			IL_05d1: br IL_01dd

			IL_05d6: leave IL_0b3b

			IL_05db: ldc.i4 1224278053
			IL_05e0: stloc 17
			IL_05e4: nop
			IL_05e5: ldloca 17
			IL_05e9: ldind.i2
			IL_05ea: conv.i2
			IL_05eb: conv.i
			IL_05ec: stloc.s 16
			IL_05ee: br IL_01dd

			IL_05f3: ldloc.0
			IL_05f4: ldtoken [mscorlib]System.Single
			IL_05f9: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_05fe: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_0603: brfalse IL_08f4

			IL_0608: ldc.i4 1676476454
			IL_060d: nop
			IL_060e: stloc 17
			IL_0612: nop
			IL_0613: ldloca 17
			IL_0617: nop
			IL_0618: ldind.i2
			IL_0619: conv.i2
			IL_061a: conv.i
			IL_061b: stloc.s 16
			IL_061d: br IL_01dd

			IL_0622: br IL_07f0

			IL_0627: ldc.i4 1434845220
			IL_062c: stloc 17
			IL_0630: nop
			IL_0631: ldloca 17
			IL_0635: ldind.i2
			IL_0636: conv.i2
			IL_0637: conv.i
			IL_0638: stloc.s 16
			IL_063a: br IL_01dd

			IL_063f: ldloc.0
			IL_0640: ldtoken [mscorlib]System.Int64
			IL_0645: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_064a: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_064f: brfalse IL_0985

			IL_0654: ldc.i4 2056650791
			IL_0659: stloc 17
			IL_065d: ldloca 17
			IL_0661: nop
			IL_0662: ldind.i2
			IL_0663: conv.i2
			IL_0664: conv.i
			IL_0665: stloc.s 16
			IL_0667: br IL_01dd

			IL_066c: br IL_0837

			IL_0671: ldc.i4 1800929293
			IL_0676: stloc 17
			IL_067a: nop
			IL_067b: ldloca 17
			IL_067f: ldind.i2
			IL_0680: conv.i2
			IL_0681: conv.i
			IL_0682: stloc.s 16
			IL_0684: br IL_01dd

			IL_0689: ldloc.0
			IL_068a: ldtoken [mscorlib]System.Decimal
			IL_068f: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_0694: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_0699: brfalse IL_039b

			IL_069e: ldc.i4 15990818
			IL_06a3: stloc 17
			IL_06a7: nop
			IL_06a8: ldloca 17
			IL_06ac: ldind.i2
			IL_06ad: conv.i2
			IL_06ae: conv.i
			IL_06af: stloc.s 16
			IL_06b1: br IL_01dd

			IL_06b6: br IL_0750

			IL_06bb: ldc.i4 2104557608
			IL_06c0: nop
			IL_06c1: stloc 17
			IL_06c5: ldloca 17
			IL_06c9: nop
			IL_06ca: ldind.i2
			IL_06cb: conv.i2
			IL_06cc: conv.i
			IL_06cd: stloc.s 16
			IL_06cf: br IL_01dd

			IL_06d4: ldloc.0
			IL_06d5: ldtoken [mscorlib]System.Byte
			IL_06da: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_06df: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_06e4: brfalse IL_0434

			IL_06e9: ldc.i4 577634304
			IL_06ee: stloc 17
			IL_06f2: ldloca 17
			IL_06f6: nop
			IL_06f7: ldind.i2
			IL_06f8: conv.i2
			IL_06f9: conv.i
			IL_06fa: stloc.s 16
			IL_06fc: br IL_01dd

			IL_0701: br IL_0480

			IL_0706: ldc.i4 799932422
			IL_070b: stloc 17
			IL_070f: nop
			IL_0710: ldloca 17
			IL_0714: ldind.i2
			IL_0715: conv.i2
			IL_0716: conv.i
			IL_0717: stloc.s 16
			IL_0719: br IL_01dd

			IL_071e: ldloc.0
			IL_071f: ldtoken [mscorlib]System.UInt32
			IL_0724: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_0729: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_072e: brfalse IL_030b

			IL_0733: ldc.i4 2012020762
			IL_0738: stloc 17
			IL_073c: ldloca 17
			IL_0740: nop
			IL_0741: ldind.i2
			IL_0742: conv.i2
			IL_0743: conv.i
			IL_0744: stloc.s 16
			IL_0746: br IL_01dd

			IL_074b: br IL_093f

			IL_0750: ldc.i4.s 16
			IL_0752: newarr [mscorlib]System.Byte
			IL_0757: stloc.s 7
			IL_0759: ldloc.1
			IL_075a: ldloc.s 7
			IL_075c: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_0761: ldloc.s 7
			IL_0763: ldc.i4.0
			IL_0764: call float64 [mscorlib]System.BitConverter::ToDouble(uint8[], int32)
			IL_0769: ldc.r8 7.922816251426434E+28
			IL_0772: rem
			IL_0773: call valuetype [mscorlib]System.Decimal [mscorlib]System.Convert::ToDecimal(float64)
			IL_0778: box [mscorlib]System.Decimal
			IL_077d: ldloc.0
			IL_077e: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_0783: unbox.any !!T
			IL_0788: stloc.3
			IL_0789: ldc.i4 42074144
			IL_078e: nop
			IL_078f: stloc 17
			IL_0793: ldloca 17
			IL_0797: ldind.i2
			IL_0798: conv.i2
			IL_0799: conv.i
			IL_079a: stloc.s 16
			IL_079c: br IL_01dd

			IL_07a1: leave IL_0b3b

			IL_07a6: ldc.i4 94634009
			IL_07ab: stloc 17
			IL_07af: ldloca 17
			IL_07b3: nop
			IL_07b4: ldind.i2
			IL_07b5: conv.i2
			IL_07b6: conv.i
			IL_07b7: stloc.s 16
			IL_07b9: br IL_01dd

			IL_07be: ldloc.0
			IL_07bf: ldtoken [mscorlib]System.Char
			IL_07c4: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_07c9: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_07ce: brfalse IL_0671

			IL_07d3: ldc.i4 282591248
			IL_07d8: stloc 17
			IL_07dc: nop
			IL_07dd: ldloca 17
			IL_07e1: ldind.i2
			IL_07e2: conv.i2
			IL_07e3: conv.i
			IL_07e4: stloc.s 16
			IL_07e6: br IL_01dd

			IL_07eb: br IL_04c2

			IL_07f0: ldc.i4.4
			IL_07f1: newarr [mscorlib]System.Byte
			IL_07f6: stloc.s 9
			IL_07f8: ldloc.1
			IL_07f9: ldloc.s 9
			IL_07fb: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_0800: ldloc.s 9
			IL_0802: ldc.i4.0
			IL_0803: call float32 [mscorlib]System.BitConverter::ToSingle(uint8[], int32)
			IL_0808: box [mscorlib]System.Single
			IL_080d: ldloc.0
			IL_080e: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_0813: unbox.any !!T
			IL_0818: stloc.3
			IL_0819: ldc.i4 1067319298
			IL_081e: nop
			IL_081f: stloc 17
			IL_0823: nop
			IL_0824: ldloca 17
			IL_0828: ldind.i2
			IL_0829: conv.i2
			IL_082a: conv.i
			IL_082b: stloc.s 16
			IL_082d: br IL_01dd

			IL_0832: leave IL_0b3b

			IL_0837: ldc.i4.8
			IL_0838: newarr [mscorlib]System.Byte
			IL_083d: stloc.s 11
			IL_083f: ldloc.1
			IL_0840: ldloc.s 11
			IL_0842: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_0847: ldloc.s 11
			IL_0849: ldc.i4.0
			IL_084a: call int64 [mscorlib]System.BitConverter::ToInt64(uint8[], int32)
			IL_084f: box [mscorlib]System.Int64
			IL_0854: ldloc.0
			IL_0855: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_085a: unbox.any !!T
			IL_085f: stloc.3
			IL_0860: ldc.i4 462225443
			IL_0865: stloc 17
			IL_0869: ldloca 17
			IL_086d: nop
			IL_086e: ldind.i2
			IL_086f: conv.i2
			IL_0870: conv.i
			IL_0871: stloc.s 16
			IL_0873: br IL_01dd

			IL_0878: leave IL_0b3b

			IL_087d: ldc.i4.1
			IL_087e: box [mscorlib]System.Boolean
			IL_0883: ldloc.0
			IL_0884: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_0889: unbox.any !!T
			IL_088e: stloc.3
			IL_088f: ldc.i4 988348426
			IL_0894: nop
			IL_0895: stloc 17
			IL_0899: nop
			IL_089a: ldloca 17
			IL_089e: nop
			IL_089f: ldind.i2
			IL_08a0: conv.i2
			IL_08a1: conv.i
			IL_08a2: stloc.s 16
			IL_08a4: br IL_01dd

			IL_08a9: leave IL_0b3b

			IL_08ae: ldc.i4.4
			IL_08af: newarr [mscorlib]System.Byte
			IL_08b4: stloc.s 10
			IL_08b6: ldloc.1
			IL_08b7: ldloc.s 10
			IL_08b9: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_08be: ldloc.s 10
			IL_08c0: ldc.i4.0
			IL_08c1: call int32 [mscorlib]System.BitConverter::ToInt32(uint8[], int32)
			IL_08c6: box [mscorlib]System.Int32
			IL_08cb: ldloc.0
			IL_08cc: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_08d1: unbox.any !!T
			IL_08d6: stloc.3
			IL_08d7: ldc.i4 636354561
			IL_08dc: stloc 17
			IL_08e0: ldloca 17
			IL_08e4: nop
			IL_08e5: ldind.i2
			IL_08e6: conv.i2
			IL_08e7: conv.i
			IL_08e8: stloc.s 16
			IL_08ea: br IL_01dd

			IL_08ef: leave IL_0b3b

			IL_08f4: ldc.i4 672727068
			IL_08f9: nop
			IL_08fa: stloc 17
			IL_08fe: ldloca 17
			IL_0902: nop
			IL_0903: ldind.i2
			IL_0904: conv.i2
			IL_0905: conv.i
			IL_0906: stloc.s 16
			IL_0908: br IL_01dd

			IL_090d: ldloc.0
			IL_090e: ldtoken [mscorlib]System.Int32
			IL_0913: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_0918: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_091d: brfalse IL_0627

			IL_0922: ldc.i4 339804165
			IL_0927: stloc 17
			IL_092b: nop
			IL_092c: ldloca 17
			IL_0930: ldind.i2
			IL_0931: conv.i2
			IL_0932: conv.i
			IL_0933: stloc.s 16
			IL_0935: br IL_01dd

			IL_093a: br IL_08ae

			IL_093f: ldc.i4.4
			IL_0940: newarr [mscorlib]System.Byte
			IL_0945: stloc.s 13
			IL_0947: ldloc.1
			IL_0948: ldloc.s 13
			IL_094a: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_094f: ldloc.s 13
			IL_0951: ldc.i4.0
			IL_0952: call uint32 [mscorlib]System.BitConverter::ToUInt32(uint8[], int32)
			IL_0957: box [mscorlib]System.UInt32
			IL_095c: ldloc.0
			IL_095d: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_0962: unbox.any !!T
			IL_0967: stloc.3
			IL_0968: ldc.i4 238551063
			IL_096d: nop
			IL_096e: stloc 17
			IL_0972: ldloca 17
			IL_0976: ldind.i2
			IL_0977: conv.i2
			IL_0978: conv.i
			IL_0979: stloc.s 16
			IL_097b: br IL_01dd

			IL_0980: leave IL_0b3b

			IL_0985: ldc.i4 2039480361
			IL_098a: nop
			IL_098b: stloc 17
			IL_098f: nop
			IL_0990: ldloca 17
			IL_0994: nop
			IL_0995: ldind.i2
			IL_0996: conv.i2
			IL_0997: conv.i
			IL_0998: stloc.s 16
			IL_099a: br IL_01dd

			IL_099f: ldloc.0
			IL_09a0: ldtoken [mscorlib]System.Int16
			IL_09a5: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_09aa: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_09af: brfalse IL_0706

			IL_09b4: ldc.i4 1713831940
			IL_09b9: nop
			IL_09ba: stloc 17
			IL_09be: ldloca 17
			IL_09c2: nop
			IL_09c3: ldind.i2
			IL_09c4: conv.i2
			IL_09c5: conv.i
			IL_09c6: stloc.s 16
			IL_09c8: br IL_01dd

			IL_09cd: br IL_054d

			IL_09d2: ldc.i4 1420034062
			IL_09d7: nop
			IL_09d8: stloc 17
			IL_09dc: ldloca 17
			IL_09e0: ldind.i2
			IL_09e1: conv.i2
			IL_09e2: conv.i
			IL_09e3: stloc.s 16
			IL_09e5: br IL_01dd

			IL_09ea: ldloc.0
			IL_09eb: ldtoken [mscorlib]System.UInt16
			IL_09f0: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_09f5: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
			IL_09fa: brfalse.s IL_0a48

			IL_09fc: ldc.i4 727973918
			IL_0a01: stloc 17
			IL_0a05: ldloca 17
			IL_0a09: nop
			IL_0a0a: ldind.i2
			IL_0a0b: conv.i2
			IL_0a0c: conv.i
			IL_0a0d: stloc.s 16
			IL_0a0f: br IL_01dd

			IL_0a14: br IL_0355

			IL_0a19: ldc.i4.0
			IL_0a1a: box [mscorlib]System.Boolean
			IL_0a1f: ldloc.0
			IL_0a20: call object [mscorlib]System.Convert::ChangeType(object, class [mscorlib]System.Type)
			IL_0a25: unbox.any !!T
			IL_0a2a: stloc.3
			IL_0a2b: ldc.i4 2090598418
			IL_0a30: stloc 17
			IL_0a34: ldloca 17
			IL_0a38: nop
			IL_0a39: ldind.i2
			IL_0a3a: conv.i2
			IL_0a3b: conv.i
			IL_0a3c: stloc.s 16
			IL_0a3e: br IL_01dd

			IL_0a43: leave IL_0b3b

			IL_0a48: ldstr "??????u???????????????????????"
			IL_0a4d: ldloc 18
			IL_0a51: call string ODCrypt.Sha3::b(string, int32)
			IL_0a56: ldtoken !!T
			IL_0a5b: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
			IL_0a60: callvirt instance string [mscorlib]System.Reflection.MemberInfo::get_Name()
			IL_0a65: call string [mscorlib]System.String::Concat(string, string)
			IL_0a6a: newobj instance void [mscorlib]System.ApplicationException::.ctor(string)
			IL_0a6f: throw
		} // end .try
		finally
		{
			IL_0a70: ldc.i4 341573632
			IL_0a75: nop
			IL_0a76: stloc 17
			IL_0a7a: nop
			IL_0a7b: ldloca 17
			IL_0a7f: ldind.i2
			IL_0a80: conv.i2
			IL_0a81: conv.i
			IL_0a82: stloc.s 16
			IL_0a84: br.s IL_0a90
			// loop start (head: IL_0a90)
				IL_0a86: ldc.i4.0
				IL_0a87: switch (IL_0aa3)

				IL_0a90: ldloc.s 16
				IL_0a92: switch (IL_0a86, IL_0abb, IL_0ad9)
			// end loop

			IL_0aa3: ldloc.1
			IL_0aa4: brfalse.s IL_0adb

			IL_0aa6: ldc.i4 1974992897
			IL_0aab: stloc 17
			IL_0aaf: ldloca 17
			IL_0ab3: nop
			IL_0ab4: ldind.i2
			IL_0ab5: conv.i2
			IL_0ab6: conv.i
			IL_0ab7: stloc.s 16
			IL_0ab9: br.s IL_0a90

			IL_0abb: br.s IL_0abd

			IL_0abd: ldloc.1
			IL_0abe: callvirt instance void [mscorlib]System.IDisposable::Dispose()
			IL_0ac3: ldc.i4 237174786
			IL_0ac8: nop
			IL_0ac9: stloc 17
			IL_0acd: ldloca 17
			IL_0ad1: nop
			IL_0ad2: ldind.i2
			IL_0ad3: conv.i2
			IL_0ad4: conv.i
			IL_0ad5: stloc.s 16
			IL_0ad7: br.s IL_0a90

			IL_0ad9: br.s IL_0adb

			IL_0adb: endfinally
		} // end handler

		IL_0adc: ldc.i4 265420802
		IL_0ae1: stloc 17
		IL_0ae5: ldloca 17
		IL_0ae9: nop
		IL_0aea: ldind.i2
		IL_0aeb: conv.i2
		IL_0aec: conv.i
		IL_0aed: stloc.s 16
		IL_0aef: br IL_0032

		IL_0af4: ldloc.0
		IL_0af5: ldtoken [mscorlib]System.String
		IL_0afa: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
		IL_0aff: call bool [mscorlib]System.Type::op_Equality(class [mscorlib]System.Type, class [mscorlib]System.Type)
		IL_0b04: brfalse IL_0098

		IL_0b09: ldc.i4 1950285830
		IL_0b0e: stloc 17
		IL_0b12: nop
		IL_0b13: ldloca 17
		IL_0b17: nop
		IL_0b18: ldind.i2
		IL_0b19: conv.i2
		IL_0b1a: conv.i
		IL_0b1b: stloc.s 16
		IL_0b1d: br IL_0032

		IL_0b22: br IL_00bc

		IL_0b27: ldstr "??k?????????????????????"
		IL_0b2c: ldloc 18
		IL_0b30: call string ODCrypt.Sha3::b(string, int32)
		IL_0b35: newobj instance void [mscorlib]System.ApplicationException::.ctor(string)
		IL_0b3a: throw

		IL_0b3b: ldloc.3
		IL_0b3c: ret
	} // end of method CryptUtil::Random

	.method public hidebysig static 
		string RandomString (
			int32 numberOfBits
		) cil managed 
	{
		// Method begins at RVA 0x8c10
		// Header size: 12
		// Code size: 321 (0x141)
		.maxstack 2
		.locals init (
			[0] class [mscorlib]System.Security.Cryptography.RandomNumberGenerator,
			[1] uint8[],
			[2] string,
			[3] int32,
			[4] int16
		)

		IL_0000: ldc.i4 1961827789
		IL_0005: stloc 4
		IL_0009: nop
		IL_000a: ldloca 4
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1557339597
		IL_0016: stloc 4
		IL_001a: nop
		IL_001b: ldloca 4
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_013f, IL_0036, IL_013f)

		IL_0035: nop

		IL_0036: ldc.i4 1348141057
		IL_003b: stloc 4
		IL_003f: ldloca 4
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: br.s IL_005b

		IL_0048: ldc.i4 1324089344
		IL_004d: nop
		IL_004e: stloc 4
		IL_0052: nop
		IL_0053: ldloca 4
		IL_0057: ldind.i2
		IL_0058: conv.i2
		IL_0059: br.s IL_005b

		IL_005b: brfalse.s IL_005d

		IL_005d: br.s IL_0074

		IL_005f: ldc.i4 1101856768
		IL_0064: nop
		IL_0065: stloc 4
		IL_0069: nop
		IL_006a: ldloca 4
		IL_006e: nop
		IL_006f: ldind.i2
		IL_0070: conv.i2

		IL_0071: pop
		IL_0072: br.s IL_0086

		IL_0074: ldc.i4 976617472
		IL_0079: stloc 4
		IL_007d: ldloca 4
		IL_0081: nop
		IL_0082: ldind.i2
		IL_0083: conv.i2
		IL_0084: br.s IL_0071

		IL_0086: nop
		IL_0087: ldc.i4 1968111616
		IL_008c: stloc 4
		IL_0090: ldloca 4
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: brfalse IL_009c

		IL_009c: newobj instance void [mscorlib]System.Security.Cryptography.RNGCryptoServiceProvider::.ctor()
		IL_00a1: stloc.0
		IL_00a2: br.s IL_00a4
		.try
		{
			IL_00a4: ldarg.0
			IL_00a5: conv.r8
			IL_00a6: ldc.r8 1
			IL_00af: mul
			IL_00b0: ldc.r8 8
			IL_00b9: div
			IL_00ba: call float64 [mscorlib]System.Math::Ceiling(float64)
			IL_00bf: conv.i4
			IL_00c0: newarr [mscorlib]System.Byte
			IL_00c5: stloc.1
			IL_00c6: ldloc.0
			IL_00c7: ldloc.1
			IL_00c8: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetBytes(uint8[])
			IL_00cd: ldloc.1
			IL_00ce: call string [mscorlib]System.Convert::ToBase64String(uint8[])
			IL_00d3: stloc.2
			IL_00d4: leave.s IL_013f
		} // end .try
		finally
		{
			IL_00d6: ldc.i4 37421056
			IL_00db: stloc 4
			IL_00df: nop
			IL_00e0: ldloca 4
			IL_00e4: ldind.i2
			IL_00e5: conv.i2
			IL_00e6: conv.i
			IL_00e7: stloc.3
			IL_00e8: br.s IL_00f4
			// loop start (head: IL_00f4)
				IL_00ea: ldc.i4.0
				IL_00eb: switch (IL_0106)

				IL_00f4: ldloc.3
				IL_00f5: switch (IL_00ea, IL_011f, IL_013c)
			// end loop

			IL_0106: ldloc.0
			IL_0107: brfalse.s IL_013e

			IL_0109: ldc.i4 116719617
			IL_010e: nop
			IL_010f: stloc 4
			IL_0113: nop
			IL_0114: ldloca 4
			IL_0118: nop
			IL_0119: ldind.i2
			IL_011a: conv.i2
			IL_011b: conv.i
			IL_011c: stloc.3
			IL_011d: br.s IL_00f4

			IL_011f: br.s IL_0121

			IL_0121: ldloc.0
			IL_0122: callvirt instance void [mscorlib]System.IDisposable::Dispose()
			IL_0127: ldc.i4 761266178
			IL_012c: nop
			IL_012d: stloc 4
			IL_0131: nop
			IL_0132: ldloca 4
			IL_0136: ldind.i2
			IL_0137: conv.i2
			IL_0138: conv.i
			IL_0139: stloc.3
			IL_013a: br.s IL_00f4

			IL_013c: br.s IL_013e

			IL_013e: endfinally
		} // end handler

		IL_013f: ldloc.2
		IL_0140: ret
	} // end of method CryptUtil::RandomString

	.method public hidebysig static 
		bool ConstantEquals (
			string lhs,
			string rhs
		) cil managed 
	{
		// Method begins at RVA 0x8d70
		// Header size: 12
		// Code size: 410 (0x19a)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0028)

		IL_000a: ldloc.2
		IL_000b: switch (IL_00a0, IL_004c, IL_0062, IL_00c5, IL_0083, IL_016a)

		IL_0028: ldarg.0
		IL_0029: callvirt instance int32 [mscorlib]System.String::get_Length()
		IL_002e: ldarg.1
		IL_002f: callvirt instance int32 [mscorlib]System.String::get_Length()
		IL_0034: xor
		IL_0035: stloc.0
		IL_0036: ldc.i4.0
		IL_0037: stloc.1
		IL_0038: ldc.i4 415563777
		IL_003d: stloc 3
		IL_0041: nop
		IL_0042: ldloca 3
		IL_0046: ldind.i2
		IL_0047: conv.i2
		IL_0048: conv.i
		IL_0049: stloc.2
		IL_004a: br.s IL_000a

		IL_004c: br.s IL_0088

		IL_004e: ldc.i4 1005191170
		IL_0053: nop
		IL_0054: stloc 3
		IL_0058: ldloca 3
		IL_005c: ldind.i2
		IL_005d: conv.i2
		IL_005e: conv.i
		IL_005f: stloc.2
		IL_0060: br.s IL_000a

		IL_0062: ldloc.1
		IL_0063: ldarg.1
		IL_0064: callvirt instance int32 [mscorlib]System.String::get_Length()
		IL_0069: blt IL_013c

		IL_006e: ldc.i4 458293252
		IL_0073: stloc 3
		IL_0077: nop
		IL_0078: ldloca 3
		IL_007c: nop
		IL_007d: ldind.i2
		IL_007e: conv.i2
		IL_007f: conv.i
		IL_0080: stloc.2
		IL_0081: br.s IL_000a

		IL_0083: br IL_016f

		IL_0088: ldc.i4 1813970944
		IL_008d: nop
		IL_008e: stloc 3
		IL_0092: nop
		IL_0093: ldloca 3
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: conv.i
		IL_009a: stloc.2
		IL_009b: br IL_000a

		IL_00a0: ldloc.1
		IL_00a1: ldarg.0
		IL_00a2: callvirt instance int32 [mscorlib]System.String::get_Length()
		IL_00a7: bge IL_016f

		IL_00ac: ldc.i4 261029891
		IL_00b1: nop
		IL_00b2: stloc 3
		IL_00b6: nop
		IL_00b7: ldloca 3
		IL_00bb: nop
		IL_00bc: ldind.i2
		IL_00bd: conv.i2
		IL_00be: conv.i
		IL_00bf: stloc.2
		IL_00c0: br IL_000a

		IL_00c5: ldc.i4 1975136665
		IL_00ca: stloc 3
		IL_00ce: nop
		IL_00cf: ldloca 3
		IL_00d3: ldind.i2
		IL_00d4: conv.i2
		IL_00d5: ldc.i4 1767977369
		IL_00da: stloc 3
		IL_00de: ldloca 3
		IL_00e2: nop
		IL_00e3: ldind.i2
		IL_00e4: conv.i2
		IL_00e5: ceq
		IL_00e7: switch (IL_000a, IL_00f9, IL_000a)

		IL_00f8: nop

		IL_00f9: br.s IL_010e

		IL_00fb: ldc.i4 1321074688
		IL_0100: stloc 3
		IL_0104: ldloca 3
		IL_0108: nop
		IL_0109: ldind.i2
		IL_010a: conv.i2

		IL_010b: pop
		IL_010c: br.s IL_0120

		IL_010e: ldc.i4 326631424
		IL_0113: stloc 3
		IL_0117: nop
		IL_0118: ldloca 3
		IL_011c: ldind.i2
		IL_011d: conv.i2
		IL_011e: br.s IL_010b

		IL_0120: nop
		IL_0121: ldc.i4 1737490432
		IL_0126: nop
		IL_0127: stloc 3
		IL_012b: nop
		IL_012c: ldloca 3
		IL_0130: ldind.i2
		IL_0131: conv.i2
		IL_0132: brfalse IL_0137

		IL_0137: br IL_004e

		IL_013c: ldloc.0
		IL_013d: ldarg.0
		IL_013e: ldloc.1
		IL_013f: callvirt instance char [mscorlib]System.String::get_Chars(int32)
		IL_0144: ldarg.1
		IL_0145: ldloc.1
		IL_0146: callvirt instance char [mscorlib]System.String::get_Chars(int32)
		IL_014b: xor
		IL_014c: or
		IL_014d: stloc.0
		IL_014e: ldloc.1
		IL_014f: ldc.i4.1
		IL_0150: add
		IL_0151: stloc.1
		IL_0152: ldc.i4 1576337413
		IL_0157: nop
		IL_0158: stloc 3
		IL_015c: ldloca 3
		IL_0160: nop
		IL_0161: ldind.i2
		IL_0162: conv.i2
		IL_0163: conv.i
		IL_0164: stloc.2
		IL_0165: br IL_000a

		IL_016a: br IL_0088

		IL_016f: ldc.i4 1838874625
		IL_0174: stloc 3
		IL_0178: ldloca 3
		IL_017c: nop
		IL_017d: ldind.i2
		IL_017e: conv.i2
		IL_017f: br.s IL_0193

		IL_0181: ldc.i4 1207762944
		IL_0186: nop
		IL_0187: stloc 3
		IL_018b: ldloca 3
		IL_018f: ldind.i2
		IL_0190: conv.i2
		IL_0191: br.s IL_0193

		IL_0193: brfalse.s IL_0195

		IL_0195: ldloc.0
		IL_0196: ldc.i4.0
		IL_0197: ceq
		IL_0199: ret
	} // end of method CryptUtil::ConstantEquals

	.method public hidebysig static 
		string GenerateSalt (
			[opt] int32 saltSize
		) cil managed 
	{
		.param [1] = int32(64)
		// Method begins at RVA 0x8f18
		// Header size: 12
		// Code size: 406 (0x196)
		.maxstack 2
		.locals init (
			[0] uint8[],
			[1] class [mscorlib]System.Security.Cryptography.RNGCryptoServiceProvider,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4 1248657408
		IL_0005: stloc 3
		IL_0009: nop
		IL_000a: ldloca 3
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: conv.i
		IL_0011: stloc.2
		IL_0012: br.s IL_001e
		// loop start (head: IL_001e)
			IL_0014: ldc.i4.0
			IL_0015: switch (IL_0030)

			IL_001e: ldloc.2
			IL_001f: switch (IL_0014, IL_004c, IL_00e8)

			IL_0030: ldarg.0
			IL_0031: ldc.i4.0
			IL_0032: bgt IL_00c4

			IL_0037: ldc.i4 887554049
			IL_003c: nop
			IL_003d: stloc 3
			IL_0041: ldloca 3
			IL_0045: nop
			IL_0046: ldind.i2
			IL_0047: conv.i2
			IL_0048: conv.i
			IL_0049: stloc.2
			IL_004a: br.s IL_001e

			IL_004c: br IL_0115
			.try
			{
				IL_0051: ldloc.1
				IL_0052: ldloc.0
				IL_0053: callvirt instance void [mscorlib]System.Security.Cryptography.RandomNumberGenerator::GetNonZeroBytes(uint8[])
				IL_0058: leave IL_011b
			} // end .try
			finally
			{
				IL_005d: ldc.i4 122421248
				IL_0062: stloc 3
				IL_0066: nop
				IL_0067: ldloca 3
				IL_006b: ldind.i2
				IL_006c: conv.i2
				IL_006d: conv.i
				IL_006e: stloc.2
				IL_006f: br.s IL_007b
				// loop start (head: IL_007b)
					IL_0071: ldc.i4.0
					IL_0072: switch (IL_008d)

					IL_007b: ldloc.2
					IL_007c: switch (IL_0071, IL_00a4, IL_00c1)
				// end loop

				IL_008d: ldloc.1
				IL_008e: brfalse.s IL_00c3

				IL_0090: ldc.i4 2035613697
				IL_0095: stloc 3
				IL_0099: nop
				IL_009a: ldloca 3
				IL_009e: ldind.i2
				IL_009f: conv.i2
				IL_00a0: conv.i
				IL_00a1: stloc.2
				IL_00a2: br.s IL_007b

				IL_00a4: br.s IL_00a6

				IL_00a6: ldloc.1
				IL_00a7: callvirt instance void [mscorlib]System.IDisposable::Dispose()
				IL_00ac: ldc.i4 1822228482
				IL_00b1: nop
				IL_00b2: stloc 3
				IL_00b6: ldloca 3
				IL_00ba: nop
				IL_00bb: ldind.i2
				IL_00bc: conv.i2
				IL_00bd: conv.i
				IL_00be: stloc.2
				IL_00bf: br.s IL_007b

				IL_00c1: br.s IL_00c3

				IL_00c3: endfinally
			} // end handler

			IL_00c4: ldarg.0
			IL_00c5: newarr [mscorlib]System.Byte
			IL_00ca: stloc.0
			IL_00cb: newobj instance void [mscorlib]System.Security.Cryptography.RNGCryptoServiceProvider::.ctor()
			IL_00d0: stloc.1
			IL_00d1: ldc.i4 838598658
			IL_00d6: stloc 3
			IL_00da: ldloca 3
			IL_00de: nop
			IL_00df: ldind.i2
			IL_00e0: conv.i2
			IL_00e1: conv.i
			IL_00e2: stloc.2
			IL_00e3: br IL_001e

			IL_00e8: ldc.i4 330301441
			IL_00ed: nop
			IL_00ee: stloc 3
			IL_00f2: nop
			IL_00f3: ldloca 3
			IL_00f7: nop
			IL_00f8: ldind.i2
			IL_00f9: conv.i2
			IL_00fa: br.s IL_010e

			IL_00fc: ldc.i4 1967980544
			IL_0101: stloc 3
			IL_0105: ldloca 3
			IL_0109: nop
			IL_010a: ldind.i2
			IL_010b: conv.i2
			IL_010c: br.s IL_010e

			IL_010e: brfalse.s IL_0110

			IL_0110: br IL_0051

			IL_0115: ldstr ""
			IL_011a: ret

			IL_011b: ldc.i4 451126065
			IL_0120: stloc 3
			IL_0124: ldloca 3
			IL_0128: nop
			IL_0129: ldind.i2
			IL_012a: conv.i2
			IL_012b: ldc.i4 362652465
			IL_0130: nop
			IL_0131: stloc 3
			IL_0135: ldloca 3
			IL_0139: nop
			IL_013a: ldind.i2
			IL_013b: conv.i2
			IL_013c: ceq
			IL_013e: switch (IL_0014, IL_0150, IL_0014)
		// end loop

		IL_014f: nop

		IL_0150: ldc.i4 800325632
		IL_0155: stloc 3
		IL_0159: ldloca 3
		IL_015d: nop
		IL_015e: ldind.i2
		IL_015f: conv.i2
		IL_0160: brfalse IL_0165

		IL_0165: br.s IL_017a

		IL_0167: ldc.i4 1473445888
		IL_016c: stloc 3
		IL_0170: ldloca 3
		IL_0174: nop
		IL_0175: ldind.i2
		IL_0176: conv.i2

		IL_0177: pop
		IL_0178: br.s IL_018e

		IL_017a: ldc.i4 1339949056
		IL_017f: nop
		IL_0180: stloc 3
		IL_0184: nop
		IL_0185: ldloca 3
		IL_0189: nop
		IL_018a: ldind.i2
		IL_018b: conv.i2
		IL_018c: br.s IL_0177

		IL_018e: nop
		IL_018f: ldloc.0
		IL_0190: call string [mscorlib]System.Convert::ToBase64String(uint8[])
		IL_0195: ret
	} // end of method CryptUtil::GenerateSalt

} // end of class ODCrypt.CryptUtil

.class public auto ansi beforefieldinit ODCrypt.Encryption
	extends [mscorlib]System.Object
{
	// Methods
	.method private hidebysig specialname static 
		string w () cil managed 
	{
		// Method begins at RVA 0x90cc
		// Header size: 12
		// Code size: 178 (0xb2)
		.maxstack 2
		.locals init (
			[0] int16,
			[1] int32
		)

		IL_0000: ldc.i4 12
		IL_0005: stloc 1
		IL_0009: ldc.i4 635241997
		IL_000e: nop
		IL_000f: stloc 0
		IL_0013: nop
		IL_0014: ldloca 0
		IL_0018: nop
		IL_0019: ldind.i2
		IL_001a: conv.i2
		IL_001b: ldc.i4 448923149
		IL_0020: nop
		IL_0021: stloc 0
		IL_0025: nop
		IL_0026: ldloca 0
		IL_002a: ldind.i2
		IL_002b: conv.i2
		IL_002c: ceq
		IL_002e: switch (IL_003f, IL_0040, IL_003f)

		IL_003f: nop

		IL_0040: ldc.i4 651689985
		IL_0045: stloc 0
		IL_0049: ldloca 0
		IL_004d: nop
		IL_004e: ldind.i2
		IL_004f: conv.i2
		IL_0050: br.s IL_0064

		IL_0052: ldc.i4 891027456
		IL_0057: stloc 0
		IL_005b: ldloca 0
		IL_005f: nop
		IL_0060: ldind.i2
		IL_0061: conv.i2
		IL_0062: br.s IL_0064

		IL_0064: brfalse.s IL_0066

		IL_0066: br.s IL_007b

		IL_0068: ldc.i4 1077477376
		IL_006d: nop
		IL_006e: stloc 0
		IL_0072: ldloca 0
		IL_0076: ldind.i2
		IL_0077: conv.i2

		IL_0078: pop
		IL_0079: br.s IL_008d

		IL_007b: ldc.i4 1582170112
		IL_0080: stloc 0
		IL_0084: ldloca 0
		IL_0088: nop
		IL_0089: ldind.i2
		IL_008a: conv.i2
		IL_008b: br.s IL_0078

		IL_008d: nop
		IL_008e: ldc.i4 1621950464
		IL_0093: stloc 0
		IL_0097: nop
		IL_0098: ldloca 0
		IL_009c: ldind.i2
		IL_009d: conv.i2
		IL_009e: brfalse IL_00a3

		IL_00a3: ldstr "??≥????????????????????????????????????????????????????????????\ud8df"
		IL_00a8: ldloc 1
		IL_00ac: call string ODCrypt.Sha3::b(string, int32)
		IL_00b1: ret
	} // end of method Encryption::w

	.method public hidebysig specialname static 
		string get_STATIC_INIT_VECTOR () cil managed 
	{
		// Method begins at RVA 0x918c
		// Header size: 12
		// Code size: 177 (0xb1)
		.maxstack 2
		.locals init (
			[0] int16,
			[1] int32
		)

		IL_0000: ldc.i4 0
		IL_0005: stloc 1
		IL_0009: ldc.i4 306060220
		IL_000e: nop
		IL_000f: stloc 0
		IL_0013: ldloca 0
		IL_0017: ldind.i2
		IL_0018: conv.i2
		IL_0019: ldc.i4 338697148
		IL_001e: stloc 0
		IL_0022: nop
		IL_0023: ldloca 0
		IL_0027: nop
		IL_0028: ldind.i2
		IL_0029: conv.i2
		IL_002a: ceq
		IL_002c: switch (IL_003d, IL_003e, IL_003d)

		IL_003d: nop

		IL_003e: ldc.i4 1468071937
		IL_0043: nop
		IL_0044: stloc 0
		IL_0048: ldloca 0
		IL_004c: ldind.i2
		IL_004d: conv.i2
		IL_004e: br.s IL_0063

		IL_0050: ldc.i4 1560739840
		IL_0055: nop
		IL_0056: stloc 0
		IL_005a: nop
		IL_005b: ldloca 0
		IL_005f: ldind.i2
		IL_0060: conv.i2
		IL_0061: br.s IL_0063

		IL_0063: brfalse.s IL_0065

		IL_0065: br.s IL_007a

		IL_0067: ldc.i4 7340032
		IL_006c: stloc 0
		IL_0070: nop
		IL_0071: ldloca 0
		IL_0075: ldind.i2
		IL_0076: conv.i2

		IL_0077: pop
		IL_0078: br.s IL_008c

		IL_007a: ldc.i4 910622720
		IL_007f: stloc 0
		IL_0083: ldloca 0
		IL_0087: nop
		IL_0088: ldind.i2
		IL_0089: conv.i2
		IL_008a: br.s IL_0077

		IL_008c: nop
		IL_008d: ldc.i4 1297285120
		IL_0092: stloc 0
		IL_0096: ldloca 0
		IL_009a: nop
		IL_009b: ldind.i2
		IL_009c: conv.i2
		IL_009d: brfalse IL_00a2

		IL_00a2: ldstr "????????????????????????????????"
		IL_00a7: ldloc 1
		IL_00ab: call string ODCrypt.Sha3::b(string, int32)
		IL_00b0: ret
	} // end of method Encryption::get_STATIC_INIT_VECTOR

	.method public hidebysig static 
		string GenerateKey () cil managed 
	{
		// Method begins at RVA 0x924c
		// Header size: 12
		// Code size: 293 (0x125)
		.maxstack 2
		.locals init (
			[0] class [mscorlib]System.Security.Cryptography.SymmetricAlgorithm,
			[1] string,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4 557187073
		IL_0005: nop
		IL_0006: stloc 3
		IL_000a: ldloca 3
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: br.s IL_0025

		IL_0012: ldc.i4 305004544
		IL_0017: nop
		IL_0018: stloc 3
		IL_001c: ldloca 3
		IL_0020: nop
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: br.s IL_0025

		IL_0025: brfalse.s IL_0027

		IL_0027: ldc.i4 2002898676
		IL_002c: stloc 3
		IL_0030: ldloca 3
		IL_0034: nop
		IL_0035: ldind.i2
		IL_0036: conv.i2
		IL_0037: ldc.i4 299814644
		IL_003c: nop
		IL_003d: stloc 3
		IL_0041: nop
		IL_0042: ldloca 3
		IL_0046: nop
		IL_0047: ldind.i2
		IL_0048: conv.i2
		IL_0049: ceq
		IL_004b: switch (IL_0123, IL_005d, IL_0123)

		IL_005c: nop

		IL_005d: br.s IL_0074

		IL_005f: ldc.i4 1922629632
		IL_0064: nop
		IL_0065: stloc 3
		IL_0069: nop
		IL_006a: ldloca 3
		IL_006e: nop
		IL_006f: ldind.i2
		IL_0070: conv.i2

		IL_0071: pop
		IL_0072: br.s IL_0087

		IL_0074: ldc.i4 1035730944
		IL_0079: stloc 3
		IL_007d: nop
		IL_007e: ldloca 3
		IL_0082: nop
		IL_0083: ldind.i2
		IL_0084: conv.i2
		IL_0085: br.s IL_0071

		IL_0087: nop
		IL_0088: ldc.i4 1046806528
		IL_008d: nop
		IL_008e: stloc 3
		IL_0092: nop
		IL_0093: ldloca 3
		IL_0097: nop
		IL_0098: ldind.i2
		IL_0099: conv.i2
		IL_009a: brfalse IL_009f

		IL_009f: newobj instance void [System.Core]System.Security.Cryptography.AesCryptoServiceProvider::.ctor()
		IL_00a4: stloc.0
		IL_00a5: br.s IL_00a7
		.try
		{
			IL_00a7: ldloc.0
			IL_00a8: callvirt instance void [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::GenerateKey()
			IL_00ad: ldloc.0
			IL_00ae: callvirt instance uint8[] [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::get_Key()
			IL_00b3: ldc.i4.1
			IL_00b4: call string ODCrypt.Encryption::BytesToString(uint8[], bool)
			IL_00b9: stloc.1
			IL_00ba: leave.s IL_0123
		} // end .try
		finally
		{
			IL_00bc: ldc.i4 674955264
			IL_00c1: stloc 3
			IL_00c5: nop
			IL_00c6: ldloca 3
			IL_00ca: ldind.i2
			IL_00cb: conv.i2
			IL_00cc: conv.i
			IL_00cd: stloc.2
			IL_00ce: br.s IL_00da
			// loop start (head: IL_00da)
				IL_00d0: ldc.i4.0
				IL_00d1: switch (IL_00ec)

				IL_00da: ldloc.2
				IL_00db: switch (IL_00d0, IL_0104, IL_0120)
			// end loop

			IL_00ec: ldloc.0
			IL_00ed: brfalse.s IL_0122

			IL_00ef: ldc.i4 1403125761
			IL_00f4: nop
			IL_00f5: stloc 3
			IL_00f9: ldloca 3
			IL_00fd: nop
			IL_00fe: ldind.i2
			IL_00ff: conv.i2
			IL_0100: conv.i
			IL_0101: stloc.2
			IL_0102: br.s IL_00da

			IL_0104: br.s IL_0106

			IL_0106: ldloc.0
			IL_0107: callvirt instance void [mscorlib]System.IDisposable::Dispose()
			IL_010c: ldc.i4 837746690
			IL_0111: stloc 3
			IL_0115: ldloca 3
			IL_0119: nop
			IL_011a: ldind.i2
			IL_011b: conv.i2
			IL_011c: conv.i
			IL_011d: stloc.2
			IL_011e: br.s IL_00da

			IL_0120: br.s IL_0122

			IL_0122: endfinally
		} // end handler

		IL_0123: ldloc.1
		IL_0124: ret
	} // end of method Encryption::GenerateKey

	.method public hidebysig static 
		string GenerateIV () cil managed 
	{
		// Method begins at RVA 0x9390
		// Header size: 12
		// Code size: 294 (0x126)
		.maxstack 2
		.locals init (
			[0] class [mscorlib]System.Security.Cryptography.SymmetricAlgorithm,
			[1] string,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4 1886572073
		IL_0005: stloc 3
		IL_0009: ldloca 3
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 741396009
		IL_0015: nop
		IL_0016: stloc 3
		IL_001a: nop
		IL_001b: ldloca 3
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0124, IL_0036, IL_0124)

		IL_0035: nop

		IL_0036: ldc.i4 1371078656
		IL_003b: stloc 3
		IL_003f: nop
		IL_0040: ldloca 3
		IL_0044: nop
		IL_0045: ldind.i2
		IL_0046: conv.i2
		IL_0047: brfalse IL_004c

		IL_004c: br.s IL_0061

		IL_004e: ldc.i4 272302080
		IL_0053: nop
		IL_0054: stloc 3
		IL_0058: ldloca 3
		IL_005c: ldind.i2
		IL_005d: conv.i2

		IL_005e: pop
		IL_005f: br.s IL_0073

		IL_0061: ldc.i4 1511522304
		IL_0066: stloc 3
		IL_006a: nop
		IL_006b: ldloca 3
		IL_006f: ldind.i2
		IL_0070: conv.i2
		IL_0071: br.s IL_005e

		IL_0073: nop
		IL_0074: newobj instance void [System.Core]System.Security.Cryptography.AesCryptoServiceProvider::.ctor()
		IL_0079: stloc.0
		IL_007a: br.s IL_007c
		.try
		{
			IL_007c: ldloc.0
			IL_007d: callvirt instance void [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::GenerateIV()
			IL_0082: ldloc.0
			IL_0083: callvirt instance uint8[] [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::get_IV()
			IL_0088: ldc.i4.1
			IL_0089: call string ODCrypt.Encryption::BytesToString(uint8[], bool)
			IL_008e: stloc.1
			IL_008f: leave IL_0124
		} // end .try
		finally
		{
			IL_0094: ldc.i4 1054932992
			IL_0099: stloc 3
			IL_009d: ldloca 3
			IL_00a1: nop
			IL_00a2: ldind.i2
			IL_00a3: conv.i2
			IL_00a4: conv.i
			IL_00a5: stloc.2
			IL_00a6: br.s IL_00b2
			// loop start (head: IL_00b2)
				IL_00a8: ldc.i4.0
				IL_00a9: switch (IL_00c4)

				IL_00b2: ldloc.2
				IL_00b3: switch (IL_00a8, IL_00dc, IL_00f9)
			// end loop

			IL_00c4: ldloc.0
			IL_00c5: brfalse.s IL_0123

			IL_00c7: ldc.i4 930152449
			IL_00cc: nop
			IL_00cd: stloc 3
			IL_00d1: ldloca 3
			IL_00d5: nop
			IL_00d6: ldind.i2
			IL_00d7: conv.i2
			IL_00d8: conv.i
			IL_00d9: stloc.2
			IL_00da: br.s IL_00b2

			IL_00dc: br.s IL_00de

			IL_00de: ldloc.0
			IL_00df: callvirt instance void [mscorlib]System.IDisposable::Dispose()
			IL_00e4: ldc.i4 1606615042
			IL_00e9: nop
			IL_00ea: stloc 3
			IL_00ee: ldloca 3
			IL_00f2: nop
			IL_00f3: ldind.i2
			IL_00f4: conv.i2
			IL_00f5: conv.i
			IL_00f6: stloc.2
			IL_00f7: br.s IL_00b2

			IL_00f9: ldc.i4 455671809
			IL_00fe: nop
			IL_00ff: stloc 3
			IL_0103: ldloca 3
			IL_0107: nop
			IL_0108: ldind.i2
			IL_0109: conv.i2
			IL_010a: br.s IL_011f

			IL_010c: ldc.i4 1480392704
			IL_0111: nop
			IL_0112: stloc 3
			IL_0116: nop
			IL_0117: ldloca 3
			IL_011b: ldind.i2
			IL_011c: conv.i2
			IL_011d: br.s IL_011f

			IL_011f: brfalse.s IL_0121

			IL_0121: br.s IL_0123

			IL_0123: endfinally
		} // end handler

		IL_0124: ldloc.1
		IL_0125: ret
	} // end of method Encryption::GenerateIV

	.method public hidebysig static 
		bool EncryptString (
			string plainText,
			bool makeWebFriendly,
			[out] string& encrypted,
			string& failText
		) cil managed 
	{
		// Method begins at RVA 0x94d4
		// Header size: 12
		// Code size: 296 (0x128)
		.maxstack 6
		.locals init (
			[0] bool,
			[1] class [mscorlib]System.Exception,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4 393543681
		IL_0005: stloc 3
		IL_0009: ldloca 3
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: br.s IL_0025

		IL_0012: ldc.i4 2115305472
		IL_0017: nop
		IL_0018: stloc 3
		IL_001c: nop
		IL_001d: ldloca 3
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: br.s IL_0025

		IL_0025: brfalse.s IL_0027

		IL_0027: ldc.i4 404292495
		IL_002c: nop
		IL_002d: stloc 3
		IL_0031: ldloca 3
		IL_0035: ldind.i2
		IL_0036: conv.i2
		IL_0037: ldc.i4 1512309647
		IL_003c: stloc 3
		IL_0040: ldloca 3
		IL_0044: nop
		IL_0045: ldind.i2
		IL_0046: conv.i2
		IL_0047: ceq
		IL_0049: switch (IL_0126, IL_005b, IL_0126)

		IL_005a: nop

		IL_005b: br.s IL_0070

		IL_005d: ldc.i4 736296960
		IL_0062: stloc 3
		IL_0066: ldloca 3
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2

		IL_006d: pop
		IL_006e: br.s IL_0082

		IL_0070: ldc.i4 1579220992
		IL_0075: stloc 3
		IL_0079: ldloca 3
		IL_007d: nop
		IL_007e: ldind.i2
		IL_007f: conv.i2
		IL_0080: br.s IL_006d

		IL_0082: nop
		IL_0083: ldc.i4 1368719360
		IL_0088: stloc 3
		IL_008c: ldloca 3
		IL_0090: nop
		IL_0091: ldind.i2
		IL_0092: conv.i2
		IL_0093: brfalse IL_0098

		IL_0098: ldarg.2
		IL_0099: ldarg.0
		IL_009a: stind.ref
		IL_009b: br.s IL_009d
		.try
		{
			IL_009d: ldc.i4 1200291840
			IL_00a2: stloc 3
			IL_00a6: ldloca 3
			IL_00aa: nop
			IL_00ab: ldind.i2
			IL_00ac: conv.i2
			IL_00ad: conv.i
			IL_00ae: stloc.2
			IL_00af: br.s IL_00bb
			// loop start (head: IL_00bb)
				IL_00b1: ldc.i4.0
				IL_00b2: switch (IL_00cd)

				IL_00bb: ldloc.2
				IL_00bc: switch (IL_00b1, IL_00f6, IL_0117)
			// end loop

			IL_00cd: ldarg.0
			IL_00ce: ldarg.1
			IL_00cf: call string ODCrypt.Encryption::w()
			IL_00d4: call string ODCrypt.Encryption::get_STATIC_INIT_VECTOR()
			IL_00d9: ldarg.2
			IL_00da: ldarg.3
			IL_00db: call bool ODCrypt.Encryption::EncryptString(string, bool, string, string, string&, string&)
			IL_00e0: brtrue.s IL_0100

			IL_00e2: ldc.i4 1060831233
			IL_00e7: stloc 3
			IL_00eb: nop
			IL_00ec: ldloca 3
			IL_00f0: ldind.i2
			IL_00f1: conv.i2
			IL_00f2: conv.i
			IL_00f3: stloc.2
			IL_00f4: br.s IL_00bb

			IL_00f6: br.s IL_00f8

			IL_00f8: ldarg.3
			IL_00f9: ldind.ref
			IL_00fa: newobj instance void [mscorlib]System.Exception::.ctor(string)
			IL_00ff: throw

			IL_0100: ldc.i4.1
			IL_0101: stloc.0
			IL_0102: ldc.i4 1846083586
			IL_0107: nop
			IL_0108: stloc 3
			IL_010c: ldloca 3
			IL_0110: nop
			IL_0111: ldind.i2
			IL_0112: conv.i2
			IL_0113: conv.i
			IL_0114: stloc.2
			IL_0115: br.s IL_00bb

			IL_0117: leave.s IL_0126
		} // end .try
		catch [mscorlib]System.Exception
		{
			IL_0119: stloc.1
			IL_011a: ldarg.3
			IL_011b: ldloc.1
			IL_011c: callvirt instance string [mscorlib]System.Exception::get_Message()
			IL_0121: stind.ref
			IL_0122: ldc.i4.0
			IL_0123: stloc.0
			IL_0124: leave.s IL_0126
		} // end handler

		IL_0126: ldloc.0
		IL_0127: ret
	} // end of method Encryption::EncryptString

	.method public hidebysig static 
		bool EncryptString (
			string plainText,
			bool makeWebFriendly,
			string key,
			string initVector,
			[out] string& encrypted,
			string& failText
		) cil managed 
	{
		// Method begins at RVA 0x9618
		// Header size: 12
		// Code size: 988 (0x3dc)
		.maxstack 4
		.locals init (
			[0] bool,
			[1] class [mscorlib]System.Security.Cryptography.SymmetricAlgorithm,
			[2] class [mscorlib]System.Security.Cryptography.ICryptoTransform,
			[3] class [mscorlib]System.IO.MemoryStream,
			[4] class [mscorlib]System.Security.Cryptography.CryptoStream,
			[5] class [mscorlib]System.IO.StreamWriter,
			[6] class [mscorlib]System.Exception,
			[7] int32,
			[8] int16
		)

		IL_0000: br.s IL_0017

		IL_0002: ldc.i4 887750656
		IL_0007: nop
		IL_0008: stloc 8
		IL_000c: nop
		IL_000d: ldloca 8
		IL_0011: nop
		IL_0012: ldind.i2
		IL_0013: conv.i2

		IL_0014: pop
		IL_0015: br.s IL_0029

		IL_0017: ldc.i4 2002059264
		IL_001c: stloc 8
		IL_0020: ldloca 8
		IL_0024: nop
		IL_0025: ldind.i2
		IL_0026: conv.i2
		IL_0027: br.s IL_0014

		IL_0029: nop
		IL_002a: ldc.i4 2101870592
		IL_002f: stloc 8
		IL_0033: ldloca 8
		IL_0037: nop
		IL_0038: ldind.i2
		IL_0039: conv.i2
		IL_003a: stloc.s 7
		IL_003c: ldloc.s 7
		IL_003e: switch (IL_0047)

		IL_0047: ldarg.s encrypted
		IL_0049: ldstr ""
		IL_004e: stind.ref
		IL_004f: br.s IL_0051
		.try
		{
			IL_0051: ldc.i4 1789001728
			IL_0056: nop
			IL_0057: stloc 8
			IL_005b: ldloca 8
			IL_005f: nop
			IL_0060: ldind.i2
			IL_0061: conv.i2
			IL_0062: conv.i
			IL_0063: stloc.s 7
			IL_0065: br.s IL_0071
			// loop start (head: IL_0071)
				IL_0067: ldc.i4.0
				IL_0068: switch (IL_0094)

				IL_0071: ldloc.s 7
				IL_0073: switch (IL_0067, IL_0106, IL_0382, IL_00ad, IL_00c6, IL_00e1, IL_03c8)
			// end loop

			IL_0094: ldarg.0
			IL_0095: brfalse.s IL_00af

			IL_0097: ldc.i4 2022113283
			IL_009c: nop
			IL_009d: stloc 8
			IL_00a1: nop
			IL_00a2: ldloca 8
			IL_00a6: ldind.i2
			IL_00a7: conv.i2
			IL_00a8: conv.i
			IL_00a9: stloc.s 7
			IL_00ab: br.s IL_0071

			IL_00ad: br.s IL_00cb

			IL_00af: ldc.i4.1
			IL_00b0: stloc.0
			IL_00b1: ldc.i4 560201732
			IL_00b6: stloc 8
			IL_00ba: ldloca 8
			IL_00be: nop
			IL_00bf: ldind.i2
			IL_00c0: conv.i2
			IL_00c1: conv.i
			IL_00c2: stloc.s 7
			IL_00c4: br.s IL_0071

			IL_00c6: leave IL_03da

			IL_00cb: ldc.i4 156565509
			IL_00d0: nop
			IL_00d1: stloc 8
			IL_00d5: ldloca 8
			IL_00d9: nop
			IL_00da: ldind.i2
			IL_00db: conv.i2
			IL_00dc: conv.i
			IL_00dd: stloc.s 7
			IL_00df: br.s IL_0071

			IL_00e1: ldarg.0
			IL_00e2: callvirt instance int32 [mscorlib]System.String::get_Length()
			IL_00e7: ldc.i4.0
			IL_00e8: bgt IL_035d

			IL_00ed: ldc.i4 1297416193
			IL_00f2: nop
			IL_00f3: stloc 8
			IL_00f7: nop
			IL_00f8: ldloca 8
			IL_00fc: ldind.i2
			IL_00fd: conv.i2
			IL_00fe: conv.i
			IL_00ff: stloc.s 7
			IL_0101: br IL_0071

			IL_0106: br.s IL_00af
			.try
			{
				IL_0108: ldloc.1
				IL_0109: ldarg.2
				IL_010a: ldc.i4.1
				IL_010b: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_0110: ldarg.3
				IL_0111: ldc.i4.1
				IL_0112: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_0117: callvirt instance class [mscorlib]System.Security.Cryptography.ICryptoTransform [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::CreateEncryptor(uint8[], uint8[])
				IL_011c: stloc.2
				IL_011d: newobj instance void [mscorlib]System.IO.MemoryStream::.ctor()
				IL_0122: stloc.3
				IL_0123: br.s IL_0125
				.try
				{
					IL_0125: ldc.i4 1920160452
					IL_012a: nop
					IL_012b: stloc 8
					IL_012f: ldloca 8
					IL_0133: nop
					IL_0134: ldind.i2
					IL_0135: conv.i2
					IL_0136: ldc.i4 2066043588
					IL_013b: stloc 8
					IL_013f: ldloca 8
					IL_0143: nop
					IL_0144: ldind.i2
					IL_0145: conv.i2
					IL_0146: ceq
					IL_0148: switch (IL_027f, IL_015a, IL_027f)

					IL_0159: nop

					IL_015a: ldc.i4 1926103040
					IL_015f: nop
					IL_0160: stloc 8
					IL_0164: nop
					IL_0165: ldloca 8
					IL_0169: nop
					IL_016a: ldind.i2
					IL_016b: conv.i2
					IL_016c: brfalse IL_0171

					IL_0171: ldloc.3
					IL_0172: ldloc.2
					IL_0173: ldc.i4.1
					IL_0174: newobj instance void [mscorlib]System.Security.Cryptography.CryptoStream::.ctor(class [mscorlib]System.IO.Stream, class [mscorlib]System.Security.Cryptography.ICryptoTransform, valuetype [mscorlib]System.Security.Cryptography.CryptoStreamMode)
					IL_0179: stloc.s 4
					IL_017b: br.s IL_017d
					.try
					{
						IL_017d: ldloc.s 4
						IL_017f: newobj instance void [mscorlib]System.IO.StreamWriter::.ctor(class [mscorlib]System.IO.Stream)
						IL_0184: stloc.s 5
						IL_0186: br.s IL_0188
						.try
						{
							IL_0188: ldloc.s 5
							IL_018a: ldarg.0
							IL_018b: callvirt instance void [mscorlib]System.IO.TextWriter::Write(string)
							IL_0190: leave.s IL_0201
						} // end .try
						finally
						{
							IL_0192: ldc.i4 1557790720
							IL_0197: nop
							IL_0198: stloc 8
							IL_019c: nop
							IL_019d: ldloca 8
							IL_01a1: ldind.i2
							IL_01a2: conv.i2
							IL_01a3: conv.i
							IL_01a4: stloc.s 7
							IL_01a6: br.s IL_01b2
							// loop start (head: IL_01b2)
								IL_01a8: ldc.i4.0
								IL_01a9: switch (IL_01c5)

								IL_01b2: ldloc.s 7
								IL_01b4: switch (IL_01a8, IL_01e0, IL_01fe)
							// end loop

							IL_01c5: ldloc.s 5
							IL_01c7: brfalse.s IL_0200

							IL_01c9: ldc.i4 438763521
							IL_01ce: nop
							IL_01cf: stloc 8
							IL_01d3: nop
							IL_01d4: ldloca 8
							IL_01d8: nop
							IL_01d9: ldind.i2
							IL_01da: conv.i2
							IL_01db: conv.i
							IL_01dc: stloc.s 7
							IL_01de: br.s IL_01b2

							IL_01e0: br.s IL_01e2

							IL_01e2: ldloc.s 5
							IL_01e4: callvirt instance void [mscorlib]System.IDisposable::Dispose()
							IL_01e9: ldc.i4 401997826
							IL_01ee: stloc 8
							IL_01f2: ldloca 8
							IL_01f6: nop
							IL_01f7: ldind.i2
							IL_01f8: conv.i2
							IL_01f9: conv.i
							IL_01fa: stloc.s 7
							IL_01fc: br.s IL_01b2

							IL_01fe: br.s IL_0200

							IL_0200: endfinally
						} // end handler

						IL_0201: ldarg.s encrypted
						IL_0203: ldloc.3
						IL_0204: callvirt instance uint8[] [mscorlib]System.IO.MemoryStream::ToArray()
						IL_0209: ldarg.1
						IL_020a: call string ODCrypt.Encryption::BytesToString(uint8[], bool)
						IL_020f: stind.ref
						IL_0210: leave.s IL_027f
					} // end .try
					finally
					{
						IL_0212: ldc.i4 391905280
						IL_0217: stloc 8
						IL_021b: nop
						IL_021c: ldloca 8
						IL_0220: ldind.i2
						IL_0221: conv.i2
						IL_0222: conv.i
						IL_0223: stloc.s 7
						IL_0225: br.s IL_0231
						// loop start (head: IL_0231)
							IL_0227: ldc.i4.0
							IL_0228: switch (IL_0244)

							IL_0231: ldloc.s 7
							IL_0233: switch (IL_0227, IL_025e, IL_027c)
						// end loop

						IL_0244: ldloc.s 4
						IL_0246: brfalse.s IL_027e

						IL_0248: ldc.i4 1315045377
						IL_024d: nop
						IL_024e: stloc 8
						IL_0252: ldloca 8
						IL_0256: nop
						IL_0257: ldind.i2
						IL_0258: conv.i2
						IL_0259: conv.i
						IL_025a: stloc.s 7
						IL_025c: br.s IL_0231

						IL_025e: br.s IL_0260

						IL_0260: ldloc.s 4
						IL_0262: callvirt instance void [mscorlib]System.IDisposable::Dispose()
						IL_0267: ldc.i4 1182400514
						IL_026c: nop
						IL_026d: stloc 8
						IL_0271: ldloca 8
						IL_0275: ldind.i2
						IL_0276: conv.i2
						IL_0277: conv.i
						IL_0278: stloc.s 7
						IL_027a: br.s IL_0231

						IL_027c: br.s IL_027e

						IL_027e: endfinally
					} // end handler

					IL_027f: leave.s IL_02ed
				} // end .try
				finally
				{
					IL_0281: ldc.i4 153288704
					IL_0286: nop
					IL_0287: stloc 8
					IL_028b: nop
					IL_028c: ldloca 8
					IL_0290: ldind.i2
					IL_0291: conv.i2
					IL_0292: conv.i
					IL_0293: stloc.s 7
					IL_0295: br.s IL_02a1
					// loop start (head: IL_02a1)
						IL_0297: ldc.i4.0
						IL_0298: switch (IL_02b4)

						IL_02a1: ldloc.s 7
						IL_02a3: switch (IL_0297, IL_02cd, IL_02ea)
					// end loop

					IL_02b4: ldloc.3
					IL_02b5: brfalse.s IL_02ec

					IL_02b7: ldc.i4 431554561
					IL_02bc: stloc 8
					IL_02c0: nop
					IL_02c1: ldloca 8
					IL_02c5: nop
					IL_02c6: ldind.i2
					IL_02c7: conv.i2
					IL_02c8: conv.i
					IL_02c9: stloc.s 7
					IL_02cb: br.s IL_02a1

					IL_02cd: br.s IL_02cf

					IL_02cf: ldloc.3
					IL_02d0: callvirt instance void [mscorlib]System.IDisposable::Dispose()
					IL_02d5: ldc.i4 1585381378
					IL_02da: stloc 8
					IL_02de: ldloca 8
					IL_02e2: nop
					IL_02e3: ldind.i2
					IL_02e4: conv.i2
					IL_02e5: conv.i
					IL_02e6: stloc.s 7
					IL_02e8: br.s IL_02a1

					IL_02ea: br.s IL_02ec

					IL_02ec: endfinally
				} // end handler

				IL_02ed: leave IL_03ae
			} // end .try
			finally
			{
				IL_02f2: ldc.i4 556859392
				IL_02f7: nop
				IL_02f8: stloc 8
				IL_02fc: ldloca 8
				IL_0300: ldind.i2
				IL_0301: conv.i2
				IL_0302: conv.i
				IL_0303: stloc.s 7
				IL_0305: br.s IL_0311
				// loop start (head: IL_0311)
					IL_0307: ldc.i4.0
					IL_0308: switch (IL_0324)

					IL_0311: ldloc.s 7
					IL_0313: switch (IL_0307, IL_033d, IL_035a)
				// end loop

				IL_0324: ldloc.1
				IL_0325: brfalse.s IL_035c

				IL_0327: ldc.i4 1700331521
				IL_032c: nop
				IL_032d: stloc 8
				IL_0331: ldloca 8
				IL_0335: nop
				IL_0336: ldind.i2
				IL_0337: conv.i2
				IL_0338: conv.i
				IL_0339: stloc.s 7
				IL_033b: br.s IL_0311

				IL_033d: br.s IL_033f

				IL_033f: ldloc.1
				IL_0340: callvirt instance void [mscorlib]System.IDisposable::Dispose()
				IL_0345: ldc.i4 27787266
				IL_034a: stloc 8
				IL_034e: ldloca 8
				IL_0352: nop
				IL_0353: ldind.i2
				IL_0354: conv.i2
				IL_0355: conv.i
				IL_0356: stloc.s 7
				IL_0358: br.s IL_0311

				IL_035a: br.s IL_035c

				IL_035c: endfinally
			} // end handler

			IL_035d: ldarg.2
			IL_035e: ldarg.3
			IL_035f: call void ODCrypt.Encryption::w(string, string)
			IL_0364: newobj instance void [System.Core]System.Security.Cryptography.AesCryptoServiceProvider::.ctor()
			IL_0369: stloc.1
			IL_036a: ldc.i4 1045561346
			IL_036f: nop
			IL_0370: stloc 8
			IL_0374: ldloca 8
			IL_0378: ldind.i2
			IL_0379: conv.i2
			IL_037a: conv.i
			IL_037b: stloc.s 7
			IL_037d: br IL_0071

			IL_0382: ldc.i4 1735327745
			IL_0387: nop
			IL_0388: stloc 8
			IL_038c: ldloca 8
			IL_0390: ldind.i2
			IL_0391: conv.i2
			IL_0392: br.s IL_03a7

			IL_0394: ldc.i4 1736441856
			IL_0399: stloc 8
			IL_039d: nop
			IL_039e: ldloca 8
			IL_03a2: nop
			IL_03a3: ldind.i2
			IL_03a4: conv.i2
			IL_03a5: br.s IL_03a7

			IL_03a7: brfalse.s IL_03a9

			IL_03a9: br IL_0108

			IL_03ae: ldc.i4.1
			IL_03af: stloc.0
			IL_03b0: ldc.i4 285802502
			IL_03b5: stloc 8
			IL_03b9: ldloca 8
			IL_03bd: nop
			IL_03be: ldind.i2
			IL_03bf: conv.i2
			IL_03c0: conv.i
			IL_03c1: stloc.s 7
			IL_03c3: br IL_0071

			IL_03c8: leave.s IL_03da
		} // end .try
		catch [mscorlib]System.Exception
		{
			IL_03ca: stloc.s 6
			IL_03cc: ldarg.s failText
			IL_03ce: ldloc.s 6
			IL_03d0: callvirt instance string [mscorlib]System.Exception::get_Message()
			IL_03d5: stind.ref
			IL_03d6: ldc.i4.0
			IL_03d7: stloc.0
			IL_03d8: leave.s IL_03da
		} // end handler

		IL_03da: ldloc.0
		IL_03db: ret
	} // end of method Encryption::EncryptString

	.method public hidebysig static 
		bool EncryptBytes (
			uint8[] byteArray,
			bool makeWebFriendly,
			string key,
			string initVector,
			[out] string& encrypted,
			string& failText
		) cil managed 
	{
		// Method begins at RVA 0x9a7c
		// Header size: 12
		// Code size: 863 (0x35f)
		.maxstack 4
		.locals init (
			[0] bool,
			[1] class [mscorlib]System.Security.Cryptography.SymmetricAlgorithm,
			[2] class [mscorlib]System.Security.Cryptography.ICryptoTransform,
			[3] class [mscorlib]System.IO.MemoryStream,
			[4] class [mscorlib]System.Security.Cryptography.CryptoStream,
			[5] class [mscorlib]System.Exception,
			[6] int32,
			[7] int16
		)

		IL_0000: br.s IL_0015

		IL_0002: ldc.i4 1643839488
		IL_0007: stloc 7
		IL_000b: ldloca 7
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2

		IL_0012: pop
		IL_0013: br.s IL_0028

		IL_0015: ldc.i4 109117440
		IL_001a: nop
		IL_001b: stloc 7
		IL_001f: ldloca 7
		IL_0023: nop
		IL_0024: ldind.i2
		IL_0025: conv.i2
		IL_0026: br.s IL_0012

		IL_0028: nop
		IL_0029: ldc.i4 1902093786
		IL_002e: stloc 7
		IL_0032: ldloca 7
		IL_0036: nop
		IL_0037: ldind.i2
		IL_0038: conv.i2
		IL_0039: ldc.i4 486712794
		IL_003e: stloc 7
		IL_0042: ldloca 7
		IL_0046: nop
		IL_0047: ldind.i2
		IL_0048: conv.i2
		IL_0049: ceq
		IL_004b: switch (IL_00b8, IL_005d, IL_00b8)

		IL_005c: nop

		IL_005d: ldc.i4 1285292033
		IL_0062: stloc 7
		IL_0066: nop
		IL_0067: ldloca 7
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: br.s IL_0082

		IL_006f: ldc.i4 82444288
		IL_0074: stloc 7
		IL_0078: nop
		IL_0079: ldloca 7
		IL_007d: nop
		IL_007e: ldind.i2
		IL_007f: conv.i2
		IL_0080: br.s IL_0082

		IL_0082: brfalse.s IL_0084

		IL_0084: ldc.i4 1962475520
		IL_0089: nop
		IL_008a: stloc 7
		IL_008e: ldloca 7
		IL_0092: nop
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: brfalse IL_009a

		IL_009a: ldc.i4 1937965056
		IL_009f: nop
		IL_00a0: stloc 7
		IL_00a4: nop
		IL_00a5: ldloca 7
		IL_00a9: ldind.i2
		IL_00aa: conv.i2
		IL_00ab: stloc.s 6
		IL_00ad: ldloc.s 6
		IL_00af: switch (IL_00b8)

		IL_00b8: ldarg.s encrypted
		IL_00ba: ldstr ""
		IL_00bf: stind.ref
		IL_00c0: br.s IL_00c2
		.try
		{
			IL_00c2: ldc.i4 1268776960
			IL_00c7: nop
			IL_00c8: stloc 7
			IL_00cc: ldloca 7
			IL_00d0: nop
			IL_00d1: ldind.i2
			IL_00d2: conv.i2
			IL_00d3: conv.i
			IL_00d4: stloc.s 6
			IL_00d6: br.s IL_00e2
			// loop start (head: IL_00e2)
				IL_00d8: ldc.i4.0
				IL_00d9: switch (IL_0105)

				IL_00e2: ldloc.s 6
				IL_00e4: switch (IL_00d8, IL_0170, IL_032c, IL_011d, IL_0136, IL_0150, IL_034b)
			// end loop

			IL_0105: ldarg.0
			IL_0106: brfalse.s IL_011f

			IL_0108: ldc.i4 1352663043
			IL_010d: nop
			IL_010e: stloc 7
			IL_0112: ldloca 7
			IL_0116: ldind.i2
			IL_0117: conv.i2
			IL_0118: conv.i
			IL_0119: stloc.s 6
			IL_011b: br.s IL_00e2

			IL_011d: br.s IL_013b

			IL_011f: ldc.i4.1
			IL_0120: stloc.0
			IL_0121: ldc.i4 272236548
			IL_0126: stloc 7
			IL_012a: ldloca 7
			IL_012e: nop
			IL_012f: ldind.i2
			IL_0130: conv.i2
			IL_0131: conv.i
			IL_0132: stloc.s 6
			IL_0134: br.s IL_00e2

			IL_0136: leave IL_035d

			IL_013b: ldc.i4 1165099013
			IL_0140: stloc 7
			IL_0144: ldloca 7
			IL_0148: nop
			IL_0149: ldind.i2
			IL_014a: conv.i2
			IL_014b: conv.i
			IL_014c: stloc.s 6
			IL_014e: br.s IL_00e2

			IL_0150: ldarg.0
			IL_0151: ldlen
			IL_0152: brtrue IL_0305

			IL_0157: ldc.i4 31129601
			IL_015c: nop
			IL_015d: stloc 7
			IL_0161: nop
			IL_0162: ldloca 7
			IL_0166: ldind.i2
			IL_0167: conv.i2
			IL_0168: conv.i
			IL_0169: stloc.s 6
			IL_016b: br IL_00e2

			IL_0170: br.s IL_011f
			.try
			{
				IL_0172: ldloc.1
				IL_0173: ldarg.2
				IL_0174: ldc.i4.1
				IL_0175: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_017a: ldarg.3
				IL_017b: ldc.i4.1
				IL_017c: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_0181: callvirt instance class [mscorlib]System.Security.Cryptography.ICryptoTransform [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::CreateEncryptor(uint8[], uint8[])
				IL_0186: stloc.2
				IL_0187: newobj instance void [mscorlib]System.IO.MemoryStream::.ctor()
				IL_018c: stloc.3
				IL_018d: br.s IL_018f
				.try
				{
					IL_018f: ldloc.3
					IL_0190: ldloc.2
					IL_0191: ldc.i4.1
					IL_0192: newobj instance void [mscorlib]System.Security.Cryptography.CryptoStream::.ctor(class [mscorlib]System.IO.Stream, class [mscorlib]System.Security.Cryptography.ICryptoTransform, valuetype [mscorlib]System.Security.Cryptography.CryptoStreamMode)
					IL_0197: stloc.s 4
					IL_0199: br.s IL_019b
					.try
					{
						IL_019b: ldloc.s 4
						IL_019d: ldarg.0
						IL_019e: ldc.i4.0
						IL_019f: ldarg.0
						IL_01a0: ldlen
						IL_01a1: conv.i4
						IL_01a2: callvirt instance void [mscorlib]System.IO.Stream::Write(uint8[], int32, int32)
						IL_01a7: ldarg.s encrypted
						IL_01a9: ldloc.3
						IL_01aa: callvirt instance uint8[] [mscorlib]System.IO.MemoryStream::ToArray()
						IL_01af: ldarg.1
						IL_01b0: call string ODCrypt.Encryption::BytesToString(uint8[], bool)
						IL_01b5: stind.ref
						IL_01b6: leave.s IL_0227
					} // end .try
					finally
					{
						IL_01b8: ldc.i4 1849360384
						IL_01bd: nop
						IL_01be: stloc 7
						IL_01c2: nop
						IL_01c3: ldloca 7
						IL_01c7: nop
						IL_01c8: ldind.i2
						IL_01c9: conv.i2
						IL_01ca: conv.i
						IL_01cb: stloc.s 6
						IL_01cd: br.s IL_01d9
						// loop start (head: IL_01d9)
							IL_01cf: ldc.i4.0
							IL_01d0: switch (IL_01ec)

							IL_01d9: ldloc.s 6
							IL_01db: switch (IL_01cf, IL_0205, IL_0224)
						// end loop

						IL_01ec: ldloc.s 4
						IL_01ee: brfalse.s IL_0226

						IL_01f0: ldc.i4 2085814273
						IL_01f5: stloc 7
						IL_01f9: nop
						IL_01fa: ldloca 7
						IL_01fe: ldind.i2
						IL_01ff: conv.i2
						IL_0200: conv.i
						IL_0201: stloc.s 6
						IL_0203: br.s IL_01d9

						IL_0205: br.s IL_0207

						IL_0207: ldloc.s 4
						IL_0209: callvirt instance void [mscorlib]System.IDisposable::Dispose()
						IL_020e: ldc.i4 1227096066
						IL_0213: stloc 7
						IL_0217: nop
						IL_0218: ldloca 7
						IL_021c: nop
						IL_021d: ldind.i2
						IL_021e: conv.i2
						IL_021f: conv.i
						IL_0220: stloc.s 6
						IL_0222: br.s IL_01d9

						IL_0224: br.s IL_0226

						IL_0226: endfinally
					} // end handler

					IL_0227: leave.s IL_0296
				} // end .try
				finally
				{
					IL_0229: ldc.i4 382402560
					IL_022e: stloc 7
					IL_0232: ldloca 7
					IL_0236: nop
					IL_0237: ldind.i2
					IL_0238: conv.i2
					IL_0239: conv.i
					IL_023a: stloc.s 6
					IL_023c: br.s IL_0248
					// loop start (head: IL_0248)
						IL_023e: ldc.i4.0
						IL_023f: switch (IL_025b)

						IL_0248: ldloc.s 6
						IL_024a: switch (IL_023e, IL_0274, IL_0293)
					// end loop

					IL_025b: ldloc.3
					IL_025c: brfalse.s IL_0295

					IL_025e: ldc.i4 1276182529
					IL_0263: nop
					IL_0264: stloc 7
					IL_0268: ldloca 7
					IL_026c: nop
					IL_026d: ldind.i2
					IL_026e: conv.i2
					IL_026f: conv.i
					IL_0270: stloc.s 6
					IL_0272: br.s IL_0248

					IL_0274: br.s IL_0276

					IL_0276: ldloc.3
					IL_0277: callvirt instance void [mscorlib]System.IDisposable::Dispose()
					IL_027c: ldc.i4 643432450
					IL_0281: nop
					IL_0282: stloc 7
					IL_0286: nop
					IL_0287: ldloca 7
					IL_028b: nop
					IL_028c: ldind.i2
					IL_028d: conv.i2
					IL_028e: conv.i
					IL_028f: stloc.s 6
					IL_0291: br.s IL_0248

					IL_0293: br.s IL_0295

					IL_0295: endfinally
				} // end handler

				IL_0296: leave IL_0331
			} // end .try
			finally
			{
				IL_029b: ldc.i4 167444480
				IL_02a0: stloc 7
				IL_02a4: nop
				IL_02a5: ldloca 7
				IL_02a9: ldind.i2
				IL_02aa: conv.i2
				IL_02ab: conv.i
				IL_02ac: stloc.s 6
				IL_02ae: br.s IL_02ba
				// loop start (head: IL_02ba)
					IL_02b0: ldc.i4.0
					IL_02b1: switch (IL_02cd)

					IL_02ba: ldloc.s 6
					IL_02bc: switch (IL_02b0, IL_02e5, IL_0302)
				// end loop

				IL_02cd: ldloc.1
				IL_02ce: brfalse.s IL_0304

				IL_02d0: ldc.i4 1744502785
				IL_02d5: stloc 7
				IL_02d9: nop
				IL_02da: ldloca 7
				IL_02de: ldind.i2
				IL_02df: conv.i2
				IL_02e0: conv.i
				IL_02e1: stloc.s 6
				IL_02e3: br.s IL_02ba

				IL_02e5: br.s IL_02e7

				IL_02e7: ldloc.1
				IL_02e8: callvirt instance void [mscorlib]System.IDisposable::Dispose()
				IL_02ed: ldc.i4 1673920514
				IL_02f2: nop
				IL_02f3: stloc 7
				IL_02f7: ldloca 7
				IL_02fb: ldind.i2
				IL_02fc: conv.i2
				IL_02fd: conv.i
				IL_02fe: stloc.s 6
				IL_0300: br.s IL_02ba

				IL_0302: br.s IL_0304

				IL_0304: endfinally
			} // end handler

			IL_0305: ldarg.2
			IL_0306: ldarg.3
			IL_0307: call void ODCrypt.Encryption::w(string, string)
			IL_030c: newobj instance void [System.Core]System.Security.Cryptography.AesCryptoServiceProvider::.ctor()
			IL_0311: stloc.1
			IL_0312: ldc.i4 1825964034
			IL_0317: nop
			IL_0318: stloc 7
			IL_031c: nop
			IL_031d: ldloca 7
			IL_0321: nop
			IL_0322: ldind.i2
			IL_0323: conv.i2
			IL_0324: conv.i
			IL_0325: stloc.s 6
			IL_0327: br IL_00e2

			IL_032c: br IL_0172

			IL_0331: ldc.i4.1
			IL_0332: stloc.0
			IL_0333: ldc.i4 1585512454
			IL_0338: nop
			IL_0339: stloc 7
			IL_033d: ldloca 7
			IL_0341: ldind.i2
			IL_0342: conv.i2
			IL_0343: conv.i
			IL_0344: stloc.s 6
			IL_0346: br IL_00e2

			IL_034b: leave.s IL_035d
		} // end .try
		catch [mscorlib]System.Exception
		{
			IL_034d: stloc.s 5
			IL_034f: ldarg.s failText
			IL_0351: ldloc.s 5
			IL_0353: callvirt instance string [mscorlib]System.Exception::get_Message()
			IL_0358: stind.ref
			IL_0359: ldc.i4.0
			IL_035a: stloc.0
			IL_035b: leave.s IL_035d
		} // end handler

		IL_035d: ldloc.0
		IL_035e: ret
	} // end of method Encryption::EncryptBytes

	.method public hidebysig static 
		bool EncryptFile (
			string originalFileName,
			string encryptedFileName,
			string key,
			string initVector,
			string& failText
		) cil managed 
	{
		// Method begins at RVA 0x9e4c
		// Header size: 12
		// Code size: 1037 (0x40d)
		.maxstack 4
		.locals init (
			[0] class [mscorlib]System.Security.Cryptography.SymmetricAlgorithm,
			[1] class [mscorlib]System.Security.Cryptography.ICryptoTransform,
			[2] class [mscorlib]System.IO.FileStream,
			[3] class [mscorlib]System.IO.FileStream,
			[4] class [mscorlib]System.Security.Cryptography.CryptoStream,
			[5] bool,
			[6] class [mscorlib]System.Exception,
			[7] int32,
			[8] int16,
			[9] int32
		)

		IL_0000: ldc.i4 6
		IL_0005: stloc 9
		.try
		{
			IL_0009: ldc.i4 862126080
			IL_000e: nop
			IL_000f: stloc 8
			IL_0013: ldloca 8
			IL_0017: ldind.i2
			IL_0018: conv.i2
			IL_0019: stloc.s 7
			IL_001b: ldloc.s 7
			IL_001d: switch (IL_0026)

			IL_0026: ldc.i4 345112576
			IL_002b: nop
			IL_002c: stloc 8
			IL_0030: ldloca 8
			IL_0034: nop
			IL_0035: ldind.i2
			IL_0036: conv.i2
			IL_0037: conv.i
			IL_0038: stloc.s 7
			IL_003a: br.s IL_0046
			// loop start (head: IL_0046)
				IL_003c: ldc.i4.0
				IL_003d: switch (IL_0069)

				IL_0046: ldloc.s 7
				IL_0048: switch (IL_003c, IL_0311, IL_0386, IL_008a, IL_02aa, IL_02ef, IL_03a7)
			// end loop

			IL_0069: ldarg.0
			IL_006a: call bool [mscorlib]System.IO.File::Exists(string)
			IL_006f: brtrue IL_02d7

			IL_0074: ldc.i4 312606723
			IL_0079: stloc 8
			IL_007d: nop
			IL_007e: ldloca 8
			IL_0082: nop
			IL_0083: ldind.i2
			IL_0084: conv.i2
			IL_0085: conv.i
			IL_0086: stloc.s 7
			IL_0088: br.s IL_0046

			IL_008a: br IL_02af
			.try
			{
				IL_008f: ldloc.0
				IL_0090: ldarg.2
				IL_0091: ldc.i4.1
				IL_0092: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_0097: ldarg.3
				IL_0098: ldc.i4.1
				IL_0099: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_009e: callvirt instance class [mscorlib]System.Security.Cryptography.ICryptoTransform [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::CreateEncryptor(uint8[], uint8[])
				IL_00a3: stloc.1
				IL_00a4: ldarg.0
				IL_00a5: ldc.i4.3
				IL_00a6: newobj instance void [mscorlib]System.IO.FileStream::.ctor(string, valuetype [mscorlib]System.IO.FileMode)
				IL_00ab: stloc.2
				IL_00ac: br.s IL_00ae
				.try
				{
					IL_00ae: ldarg.1
					IL_00af: ldc.i4.1
					IL_00b0: newobj instance void [mscorlib]System.IO.FileStream::.ctor(string, valuetype [mscorlib]System.IO.FileMode)
					IL_00b5: stloc.3
					IL_00b6: br.s IL_00b8
					.try
					{
						IL_00b8: ldloc.3
						IL_00b9: ldloc.1
						IL_00ba: ldc.i4.1
						IL_00bb: newobj instance void [mscorlib]System.Security.Cryptography.CryptoStream::.ctor(class [mscorlib]System.IO.Stream, class [mscorlib]System.Security.Cryptography.ICryptoTransform, valuetype [mscorlib]System.Security.Cryptography.CryptoStreamMode)
						IL_00c0: stloc.s 4
						IL_00c2: br.s IL_00c4
						.try
						{
							IL_00c4: ldloc.2
							IL_00c5: ldloc.s 4
							IL_00c7: callvirt instance void [mscorlib]System.IO.Stream::CopyTo(class [mscorlib]System.IO.Stream)
							IL_00cc: leave.s IL_013b
						} // end .try
						finally
						{
							IL_00ce: ldc.i4 364969984
							IL_00d3: stloc 8
							IL_00d7: ldloca 8
							IL_00db: nop
							IL_00dc: ldind.i2
							IL_00dd: conv.i2
							IL_00de: conv.i
							IL_00df: stloc.s 7
							IL_00e1: br.s IL_00ed
							// loop start (head: IL_00ed)
								IL_00e3: ldc.i4.0
								IL_00e4: switch (IL_0100)

								IL_00ed: ldloc.s 7
								IL_00ef: switch (IL_00e3, IL_011a, IL_0138)
							// end loop

							IL_0100: ldloc.s 4
							IL_0102: brfalse.s IL_013a

							IL_0104: ldc.i4 373817345
							IL_0109: stloc 8
							IL_010d: nop
							IL_010e: ldloca 8
							IL_0112: nop
							IL_0113: ldind.i2
							IL_0114: conv.i2
							IL_0115: conv.i
							IL_0116: stloc.s 7
							IL_0118: br.s IL_00ed

							IL_011a: br.s IL_011c

							IL_011c: ldloc.s 4
							IL_011e: callvirt instance void [mscorlib]System.IDisposable::Dispose()
							IL_0123: ldc.i4 1526792194
							IL_0128: stloc 8
							IL_012c: ldloca 8
							IL_0130: nop
							IL_0131: ldind.i2
							IL_0132: conv.i2
							IL_0133: conv.i
							IL_0134: stloc.s 7
							IL_0136: br.s IL_00ed

							IL_0138: br.s IL_013a

							IL_013a: endfinally
						} // end handler

						IL_013b: leave.s IL_01aa
					} // end .try
					finally
					{
						IL_013d: ldc.i4 1417609216
						IL_0142: nop
						IL_0143: stloc 8
						IL_0147: nop
						IL_0148: ldloca 8
						IL_014c: nop
						IL_014d: ldind.i2
						IL_014e: conv.i2
						IL_014f: conv.i
						IL_0150: stloc.s 7
						IL_0152: br.s IL_015e
						// loop start (head: IL_015e)
							IL_0154: ldc.i4.0
							IL_0155: switch (IL_0171)

							IL_015e: ldloc.s 7
							IL_0160: switch (IL_0154, IL_018a, IL_01a7)
						// end loop

						IL_0171: ldloc.3
						IL_0172: brfalse.s IL_01a9

						IL_0174: ldc.i4 934084609
						IL_0179: nop
						IL_017a: stloc 8
						IL_017e: nop
						IL_017f: ldloca 8
						IL_0183: ldind.i2
						IL_0184: conv.i2
						IL_0185: conv.i
						IL_0186: stloc.s 7
						IL_0188: br.s IL_015e

						IL_018a: br.s IL_018c

						IL_018c: ldloc.3
						IL_018d: callvirt instance void [mscorlib]System.IDisposable::Dispose()
						IL_0192: ldc.i4 1757347842
						IL_0197: stloc 8
						IL_019b: ldloca 8
						IL_019f: nop
						IL_01a0: ldind.i2
						IL_01a1: conv.i2
						IL_01a2: conv.i
						IL_01a3: stloc.s 7
						IL_01a5: br.s IL_015e

						IL_01a7: br.s IL_01a9

						IL_01a9: endfinally
					} // end handler

					IL_01aa: leave.s IL_0218
				} // end .try
				finally
				{
					IL_01ac: ldc.i4 1495531520
					IL_01b1: nop
					IL_01b2: stloc 8
					IL_01b6: nop
					IL_01b7: ldloca 8
					IL_01bb: ldind.i2
					IL_01bc: conv.i2
					IL_01bd: conv.i
					IL_01be: stloc.s 7
					IL_01c0: br.s IL_01cc
					// loop start (head: IL_01cc)
						IL_01c2: ldc.i4.0
						IL_01c3: switch (IL_01df)

						IL_01cc: ldloc.s 7
						IL_01ce: switch (IL_01c2, IL_01f8, IL_0215)
					// end loop

					IL_01df: ldloc.2
					IL_01e0: brfalse.s IL_0217

					IL_01e2: ldc.i4 1570439169
					IL_01e7: stloc 8
					IL_01eb: nop
					IL_01ec: ldloca 8
					IL_01f0: nop
					IL_01f1: ldind.i2
					IL_01f2: conv.i2
					IL_01f3: conv.i
					IL_01f4: stloc.s 7
					IL_01f6: br.s IL_01cc

					IL_01f8: br.s IL_01fa

					IL_01fa: ldloc.2
					IL_01fb: callvirt instance void [mscorlib]System.IDisposable::Dispose()
					IL_0200: ldc.i4 174325762
					IL_0205: stloc 8
					IL_0209: nop
					IL_020a: ldloca 8
					IL_020e: ldind.i2
					IL_020f: conv.i2
					IL_0210: conv.i
					IL_0211: stloc.s 7
					IL_0213: br.s IL_01cc

					IL_0215: br.s IL_0217

					IL_0217: endfinally
				} // end handler

				IL_0218: leave IL_038b
			} // end .try
			finally
			{
				IL_021d: ldc.i4 873398272
				IL_0222: nop
				IL_0223: stloc 8
				IL_0227: nop
				IL_0228: ldloca 8
				IL_022c: nop
				IL_022d: ldind.i2
				IL_022e: conv.i2
				IL_022f: conv.i
				IL_0230: stloc.s 7
				IL_0232: br.s IL_023e
				// loop start (head: IL_023e)
					IL_0234: ldc.i4.0
					IL_0235: switch (IL_0251)

					IL_023e: ldloc.s 7
					IL_0240: switch (IL_0234, IL_026a, IL_0289)
				// end loop

				IL_0251: ldloc.0
				IL_0252: brfalse.s IL_028b

				IL_0254: ldc.i4 775815169
				IL_0259: nop
				IL_025a: stloc 8
				IL_025e: ldloca 8
				IL_0262: nop
				IL_0263: ldind.i2
				IL_0264: conv.i2
				IL_0265: conv.i
				IL_0266: stloc.s 7
				IL_0268: br.s IL_023e

				IL_026a: br.s IL_026c

				IL_026c: ldloc.0
				IL_026d: callvirt instance void [mscorlib]System.IDisposable::Dispose()
				IL_0272: ldc.i4 67043330
				IL_0277: nop
				IL_0278: stloc 8
				IL_027c: nop
				IL_027d: ldloca 8
				IL_0281: nop
				IL_0282: ldind.i2
				IL_0283: conv.i2
				IL_0284: conv.i
				IL_0285: stloc.s 7
				IL_0287: br.s IL_023e

				IL_0289: br.s IL_028b

				IL_028b: endfinally
			} // end handler

			IL_028c: ldarg.1
			IL_028d: call void [mscorlib]System.IO.File::Delete(string)
			IL_0292: ldc.i4 310050820
			IL_0297: stloc 8
			IL_029b: nop
			IL_029c: ldloca 8
			IL_02a0: ldind.i2
			IL_02a1: conv.i2
			IL_02a2: conv.i
			IL_02a3: stloc.s 7
			IL_02a5: br IL_0046

			IL_02aa: br IL_0360

			IL_02af: ldstr "??????"
			IL_02b4: ldloc 9
			IL_02b8: call string ODCrypt.Sha3::b(string, int32)
			IL_02bd: ldarg.0
			IL_02be: ldstr "????t????????????"
			IL_02c3: ldloc 9
			IL_02c7: call string ODCrypt.Sha3::b(string, int32)
			IL_02cc: call string [mscorlib]System.String::Concat(string, string, string)
			IL_02d1: newobj instance void [mscorlib]System.Exception::.ctor(string)
			IL_02d6: throw

			IL_02d7: ldc.i4 1567162373
			IL_02dc: stloc 8
			IL_02e0: ldloca 8
			IL_02e4: nop
			IL_02e5: ldind.i2
			IL_02e6: conv.i2
			IL_02e7: conv.i
			IL_02e8: stloc.s 7
			IL_02ea: br IL_0046

			IL_02ef: ldarg.1
			IL_02f0: call bool [mscorlib]System.IO.File::Exists(string)
			IL_02f5: brfalse.s IL_0360

			IL_02f7: ldc.i4 1884291073
			IL_02fc: nop
			IL_02fd: stloc 8
			IL_0301: nop
			IL_0302: ldloca 8
			IL_0306: nop
			IL_0307: ldind.i2
			IL_0308: conv.i2
			IL_0309: conv.i
			IL_030a: stloc.s 7
			IL_030c: br IL_0046

			IL_0311: ldc.i4 1046020172
			IL_0316: stloc 8
			IL_031a: nop
			IL_031b: ldloca 8
			IL_031f: nop
			IL_0320: ldind.i2
			IL_0321: conv.i2
			IL_0322: ldc.i4 430768204
			IL_0327: stloc 8
			IL_032b: ldloca 8
			IL_032f: nop
			IL_0330: ldind.i2
			IL_0331: conv.i2
			IL_0332: ceq
			IL_0334: switch (IL_038e, IL_0346, IL_038e)

			IL_0345: nop

			IL_0346: ldc.i4 989134848
			IL_034b: nop
			IL_034c: stloc 8
			IL_0350: ldloca 8
			IL_0354: ldind.i2
			IL_0355: conv.i2
			IL_0356: brfalse IL_035b

			IL_035b: br IL_028c

			IL_0360: ldarg.2
			IL_0361: ldarg.3
			IL_0362: call void ODCrypt.Encryption::w(string, string)
			IL_0367: newobj instance void [System.Core]System.Security.Cryptography.AesCryptoServiceProvider::.ctor()
			IL_036c: stloc.0
			IL_036d: ldc.i4 729546754
			IL_0372: stloc 8
			IL_0376: nop
			IL_0377: ldloca 8
			IL_037b: nop
			IL_037c: ldind.i2
			IL_037d: conv.i2
			IL_037e: conv.i
			IL_037f: stloc.s 7
			IL_0381: br IL_0046

			IL_0386: br IL_008f

			IL_038b: ldc.i4.1
			IL_038c: stloc.s 5

			IL_038e: ldc.i4 2118123526
			IL_0393: stloc 8
			IL_0397: nop
			IL_0398: ldloca 8
			IL_039c: nop
			IL_039d: ldind.i2
			IL_039e: conv.i2
			IL_039f: conv.i
			IL_03a0: stloc.s 7
			IL_03a2: br IL_0046

			IL_03a7: leave.s IL_03ba
		} // end .try
		catch [mscorlib]System.Exception
		{
			IL_03a9: stloc.s 6
			IL_03ab: ldarg.s failText
			IL_03ad: ldloc.s 6
			IL_03af: callvirt instance string [mscorlib]System.Exception::get_Message()
			IL_03b4: stind.ref
			IL_03b5: ldc.i4.0
			IL_03b6: stloc.s 5
			IL_03b8: leave.s IL_03ba
		} // end handler

		IL_03ba: br.s IL_03cf

		IL_03bc: ldc.i4 469696512
		IL_03c1: nop
		IL_03c2: stloc 8
		IL_03c6: ldloca 8
		IL_03ca: ldind.i2
		IL_03cb: conv.i2

		IL_03cc: pop
		IL_03cd: br.s IL_03e2

		IL_03cf: ldc.i4 358285312
		IL_03d4: stloc 8
		IL_03d8: nop
		IL_03d9: ldloca 8
		IL_03dd: nop
		IL_03de: ldind.i2
		IL_03df: conv.i2
		IL_03e0: br.s IL_03cc

		IL_03e2: nop
		IL_03e3: ldc.i4 1065943041
		IL_03e8: stloc 8
		IL_03ec: nop
		IL_03ed: ldloca 8
		IL_03f1: ldind.i2
		IL_03f2: conv.i2
		IL_03f3: br.s IL_0408

		IL_03f5: ldc.i4 479133696
		IL_03fa: nop
		IL_03fb: stloc 8
		IL_03ff: ldloca 8
		IL_0403: nop
		IL_0404: ldind.i2
		IL_0405: conv.i2
		IL_0406: br.s IL_0408

		IL_0408: brfalse.s IL_040a

		IL_040a: ldloc.s 5
		IL_040c: ret
	} // end of method Encryption::EncryptFile

	.method public hidebysig static 
		string EncodeForUnicode (
			string plainText
		) cil managed 
	{
		// Method begins at RVA 0xa2e4
		// Header size: 12
		// Code size: 559 (0x22f)
		.maxstack 3
		.locals init (
			[0] class [mscorlib]System.Text.StringBuilder,
			[1] char[],
			[2] int32,
			[3] char,
			[4] string,
			[5] uint16,
			[6] int32,
			[7] int16,
			[8] int32
		)

		IL_0000: ldc.i4 18
		IL_0005: stloc 8
		IL_0009: ldc.i4 232980480
		IL_000e: stloc 7
		IL_0012: ldloca 7
		IL_0016: nop
		IL_0017: ldind.i2
		IL_0018: conv.i2
		IL_0019: stloc.s 6
		IL_001b: ldloc.s 6
		IL_001d: switch (IL_0026)

		IL_0026: ldc.i4.0
		IL_0027: switch (IL_0057)

		IL_0030: ldloc.s 6
		IL_0032: switch (IL_0155, IL_007c, IL_01b3, IL_0223, IL_0191, IL_0176, IL_009c, IL_00c2)

		IL_0057: newobj instance void [mscorlib]System.Text.StringBuilder::.ctor()
		IL_005c: stloc.0
		IL_005d: ldarg.0
		IL_005e: callvirt instance char[] [mscorlib]System.String::ToCharArray()
		IL_0063: stloc.1
		IL_0064: ldc.i4.0
		IL_0065: stloc.2
		IL_0066: ldc.i4 1808269313
		IL_006b: nop
		IL_006c: stloc 7
		IL_0070: ldloca 7
		IL_0074: nop
		IL_0075: ldind.i2
		IL_0076: conv.i2
		IL_0077: conv.i
		IL_0078: stloc.s 6
		IL_007a: br.s IL_0030

		IL_007c: br IL_0178

		IL_0081: ldloc.2
		IL_0082: ldc.i4.1
		IL_0083: add
		IL_0084: stloc.2
		IL_0085: ldc.i4 986251270
		IL_008a: nop
		IL_008b: stloc 7
		IL_008f: nop
		IL_0090: ldloca 7
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: conv.i
		IL_0098: stloc.s 6
		IL_009a: br.s IL_0030

		IL_009c: br IL_0178

		IL_00a1: ldloc.0
		IL_00a2: ldloc.3
		IL_00a3: callvirt instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(char)
		IL_00a8: pop
		IL_00a9: ldc.i4 278462471
		IL_00ae: stloc 7
		IL_00b2: nop
		IL_00b3: ldloca 7
		IL_00b7: nop
		IL_00b8: ldind.i2
		IL_00b9: conv.i2
		IL_00ba: conv.i
		IL_00bb: stloc.s 6
		IL_00bd: br IL_0030

		IL_00c2: br.s IL_0081

		IL_00c4: ldc.i4 1246298113
		IL_00c9: nop
		IL_00ca: stloc 7
		IL_00ce: nop
		IL_00cf: ldloca 7
		IL_00d3: ldind.i2
		IL_00d4: conv.i2
		IL_00d5: br.s IL_00ea

		IL_00d7: ldc.i4 458752
		IL_00dc: stloc 7
		IL_00e0: nop
		IL_00e1: ldloca 7
		IL_00e5: nop
		IL_00e6: ldind.i2
		IL_00e7: conv.i2
		IL_00e8: br.s IL_00ea

		IL_00ea: brfalse.s IL_00ec

		IL_00ec: ldc.i4 779300696
		IL_00f1: stloc 7
		IL_00f5: nop
		IL_00f6: ldloca 7
		IL_00fa: nop
		IL_00fb: ldind.i2
		IL_00fc: conv.i2
		IL_00fd: ldc.i4 122433368
		IL_0102: nop
		IL_0103: stloc 7
		IL_0107: nop
		IL_0108: ldloca 7
		IL_010c: ldind.i2
		IL_010d: conv.i2
		IL_010e: ceq
		IL_0110: switch (IL_0191, IL_0122, IL_0191)

		IL_0121: nop

		IL_0122: ldc.i4 1629945856
		IL_0127: nop
		IL_0128: stloc 7
		IL_012c: nop
		IL_012d: ldloca 7
		IL_0131: nop
		IL_0132: ldind.i2
		IL_0133: conv.i2
		IL_0134: brfalse IL_0139

		IL_0139: ldloc.1
		IL_013a: ldloc.2
		IL_013b: ldelem.u2
		IL_013c: stloc.3
		IL_013d: ldc.i4 267583488
		IL_0142: stloc 7
		IL_0146: nop
		IL_0147: ldloca 7
		IL_014b: ldind.i2
		IL_014c: conv.i2
		IL_014d: conv.i
		IL_014e: stloc.s 6
		IL_0150: br IL_0030

		IL_0155: ldloc.3
		IL_0156: ldc.i4.s 127
		IL_0158: ble IL_00a1

		IL_015d: ldc.i4 36700165
		IL_0162: stloc 7
		IL_0166: nop
		IL_0167: ldloca 7
		IL_016b: nop
		IL_016c: ldind.i2
		IL_016d: conv.i2
		IL_016e: conv.i
		IL_016f: stloc.s 6
		IL_0171: br IL_0030

		IL_0176: br.s IL_01b5

		IL_0178: ldc.i4 772014084
		IL_017d: nop
		IL_017e: stloc 7
		IL_0182: ldloca 7
		IL_0186: nop
		IL_0187: ldind.i2
		IL_0188: conv.i2
		IL_0189: conv.i
		IL_018a: stloc.s 6
		IL_018c: br IL_0030

		IL_0191: ldloc.2
		IL_0192: ldloc.1
		IL_0193: ldlen
		IL_0194: conv.i4
		IL_0195: blt IL_00c4

		IL_019a: ldc.i4 1273757698
		IL_019f: nop
		IL_01a0: stloc 7
		IL_01a4: nop
		IL_01a5: ldloca 7
		IL_01a9: ldind.i2
		IL_01aa: conv.i2
		IL_01ab: conv.i
		IL_01ac: stloc.s 6
		IL_01ae: br IL_0030

		IL_01b3: br.s IL_0228

		IL_01b5: br.s IL_01cc

		IL_01b7: ldc.i4 1149108224
		IL_01bc: nop
		IL_01bd: stloc 7
		IL_01c1: nop
		IL_01c2: ldloca 7
		IL_01c6: nop
		IL_01c7: ldind.i2
		IL_01c8: conv.i2

		IL_01c9: pop
		IL_01ca: br.s IL_01df

		IL_01cc: ldc.i4 1958739968
		IL_01d1: nop
		IL_01d2: stloc 7
		IL_01d6: nop
		IL_01d7: ldloca 7
		IL_01db: ldind.i2
		IL_01dc: conv.i2
		IL_01dd: br.s IL_01c9

		IL_01df: nop
		IL_01e0: ldloc.0
		IL_01e1: ldc.i4.0
		IL_01e2: callvirt instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(char)
		IL_01e7: pop
		IL_01e8: ldloc.3
		IL_01e9: stloc.s 5
		IL_01eb: ldloca.s 5
		IL_01ed: ldstr "??"
		IL_01f2: ldloc 8
		IL_01f6: call string ODCrypt.Sha3::b(string, int32)
		IL_01fb: call instance string [mscorlib]System.UInt16::ToString(string)
		IL_0200: stloc.s 4
		IL_0202: ldloc.0
		IL_0203: ldloc.s 4
		IL_0205: callvirt instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
		IL_020a: pop
		IL_020b: ldc.i4 1760755715
		IL_0210: stloc 7
		IL_0214: ldloca 7
		IL_0218: nop
		IL_0219: ldind.i2
		IL_021a: conv.i2
		IL_021b: conv.i
		IL_021c: stloc.s 6
		IL_021e: br IL_0030

		IL_0223: br IL_0081

		IL_0228: ldloc.0
		IL_0229: callvirt instance string [mscorlib]System.Object::ToString()
		IL_022e: ret
	} // end of method Encryption::EncodeForUnicode

	.method public hidebysig static 
		string DecodeForUnicode (
			string encoded
		) cil managed 
	{
		// Method begins at RVA 0xa520
		// Header size: 12
		// Code size: 544 (0x220)
		.maxstack 6
		.locals init (
			[0] class [mscorlib]System.Text.StringBuilder,
			[1] char[],
			[2] uint8[],
			[3] int32,
			[4] char,
			[5] int32,
			[6] int16
		)

		IL_0000: ldc.i4 1074528256
		IL_0005: nop
		IL_0006: stloc 6
		IL_000a: nop
		IL_000b: ldloca 6
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: stloc.s 5
		IL_0013: ldloc.s 5
		IL_0015: switch (IL_001e)

		IL_001e: ldc.i4 1186988033
		IL_0023: nop
		IL_0024: stloc 6
		IL_0028: ldloca 6
		IL_002c: ldind.i2
		IL_002d: conv.i2
		IL_002e: br.s IL_0043

		IL_0030: ldc.i4 1873084416
		IL_0035: stloc 6
		IL_0039: nop
		IL_003a: ldloca 6
		IL_003e: nop
		IL_003f: ldind.i2
		IL_0040: conv.i2
		IL_0041: br.s IL_0043

		IL_0043: brfalse.s IL_0045

		IL_0045: ldc.i4.0
		IL_0046: switch (IL_0072)

		IL_004f: ldloc.s 5
		IL_0051: switch (IL_00a3, IL_01f5, IL_0125, IL_0164, IL_0144, IL_0217, IL_00ca)

		IL_0072: newobj instance void [mscorlib]System.Text.StringBuilder::.ctor()
		IL_0077: stloc.0
		IL_0078: ldarg.0
		IL_0079: callvirt instance char[] [mscorlib]System.String::ToCharArray()
		IL_007e: stloc.1
		IL_007f: call class [mscorlib]System.Text.Encoding [mscorlib]System.Text.Encoding::get_UTF8()
		IL_0084: ldloc.1
		IL_0085: callvirt instance uint8[] [mscorlib]System.Text.Encoding::GetBytes(char[])
		IL_008a: stloc.2
		IL_008b: ldc.i4.0
		IL_008c: stloc.3
		IL_008d: ldc.i4 520617984
		IL_0092: nop
		IL_0093: stloc 6
		IL_0097: ldloca 6
		IL_009b: nop
		IL_009c: ldind.i2
		IL_009d: conv.i2
		IL_009e: conv.i
		IL_009f: stloc.s 5
		IL_00a1: br.s IL_004f

		IL_00a3: br IL_0169

		IL_00a8: ldloc.0
		IL_00a9: ldloc.s 4
		IL_00ab: callvirt instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(char)
		IL_00b0: pop
		IL_00b1: ldloc.3
		IL_00b2: ldc.i4.1
		IL_00b3: add
		IL_00b4: stloc.3

		IL_00b5: ldc.i4 845938694
		IL_00ba: stloc 6
		IL_00be: nop
		IL_00bf: ldloca 6
		IL_00c3: ldind.i2
		IL_00c4: conv.i2
		IL_00c5: conv.i
		IL_00c6: stloc.s 5
		IL_00c8: br.s IL_004f

		IL_00ca: br IL_0169

		IL_00cf: ldc.i4.4
		IL_00d0: newarr [mscorlib]System.Char
		IL_00d5: dup
		IL_00d6: ldc.i4.0
		IL_00d7: ldloc.2
		IL_00d8: ldloc.3
		IL_00d9: ldc.i4.1
		IL_00da: add
		IL_00db: ldelem.u1
		IL_00dc: stelem.i2
		IL_00dd: dup
		IL_00de: ldc.i4.1
		IL_00df: ldloc.2
		IL_00e0: ldloc.3
		IL_00e1: ldc.i4.2
		IL_00e2: add
		IL_00e3: ldelem.u1
		IL_00e4: stelem.i2
		IL_00e5: dup
		IL_00e6: ldc.i4.2
		IL_00e7: ldloc.2
		IL_00e8: ldloc.3
		IL_00e9: ldc.i4.3
		IL_00ea: add
		IL_00eb: ldelem.u1
		IL_00ec: stelem.i2
		IL_00ed: dup
		IL_00ee: ldc.i4.3
		IL_00ef: ldloc.2
		IL_00f0: ldloc.3
		IL_00f1: ldc.i4.4
		IL_00f2: add
		IL_00f3: ldelem.u1
		IL_00f4: stelem.i2
		IL_00f5: newobj instance void [mscorlib]System.String::.ctor(char[])
		IL_00fa: ldc.i4.s 16
		IL_00fc: call uint32 [mscorlib]System.Convert::ToUInt32(string, int32)
		IL_0101: call char [mscorlib]System.Convert::ToChar(uint32)
		IL_0106: stloc.s 4
		IL_0108: ldloc.3
		IL_0109: ldc.i4.4
		IL_010a: add
		IL_010b: stloc.3
		IL_010c: ldc.i4 467140610
		IL_0111: nop
		IL_0112: stloc 6
		IL_0116: nop
		IL_0117: ldloca 6
		IL_011b: ldind.i2
		IL_011c: conv.i2
		IL_011d: conv.i
		IL_011e: stloc.s 5
		IL_0120: br IL_004f

		IL_0125: br.s IL_00a8

		IL_0127: ldloc.2
		IL_0128: ldloc.3
		IL_0129: ldelem.u1
		IL_012a: stloc.s 4
		IL_012c: ldc.i4 227475460
		IL_0131: nop
		IL_0132: stloc 6
		IL_0136: ldloca 6
		IL_013a: ldind.i2
		IL_013b: conv.i2
		IL_013c: conv.i
		IL_013d: stloc.s 5
		IL_013f: br IL_004f

		IL_0144: ldloc.s 4
		IL_0146: brtrue IL_00a8

		IL_014b: ldc.i4 1088356355
		IL_0150: stloc 6
		IL_0154: nop
		IL_0155: ldloca 6
		IL_0159: nop
		IL_015a: ldind.i2
		IL_015b: conv.i2
		IL_015c: conv.i
		IL_015d: stloc.s 5
		IL_015f: br IL_004f

		IL_0164: br IL_00cf

		IL_0169: ldc.i4 369069946
		IL_016e: nop
		IL_016f: stloc 6
		IL_0173: ldloca 6
		IL_0177: nop
		IL_0178: ldind.i2
		IL_0179: conv.i2
		IL_017a: ldc.i4 1282379642
		IL_017f: stloc 6
		IL_0183: nop
		IL_0184: ldloca 6
		IL_0188: nop
		IL_0189: ldind.i2
		IL_018a: conv.i2
		IL_018b: ceq
		IL_018d: switch (IL_00b5, IL_01c8, IL_00b5)

		IL_019e: br.s IL_01b4

		IL_01a0: ldc.i4 1351024640
		IL_01a5: stloc 6
		IL_01a9: nop
		IL_01aa: ldloca 6
		IL_01ae: nop
		IL_01af: ldind.i2
		IL_01b0: conv.i2

		IL_01b1: pop
		IL_01b2: br.s IL_01c6

		IL_01b4: ldc.i4 88735744
		IL_01b9: stloc 6
		IL_01bd: ldloca 6
		IL_01c1: nop
		IL_01c2: ldind.i2
		IL_01c3: conv.i2
		IL_01c4: br.s IL_01b1

		IL_01c6: nop
		IL_01c7: nop

		IL_01c8: ldc.i4 1384382464
		IL_01cd: nop
		IL_01ce: stloc 6
		IL_01d2: ldloca 6
		IL_01d6: ldind.i2
		IL_01d7: conv.i2
		IL_01d8: brfalse IL_01dd

		IL_01dd: ldc.i4 2084503553
		IL_01e2: nop
		IL_01e3: stloc 6
		IL_01e7: ldloca 6
		IL_01eb: ldind.i2
		IL_01ec: conv.i2
		IL_01ed: conv.i
		IL_01ee: stloc.s 5
		IL_01f0: br IL_004f

		IL_01f5: ldloc.3
		IL_01f6: ldloc.2
		IL_01f7: ldlen
		IL_01f8: conv.i4
		IL_01f9: blt IL_0127

		IL_01fe: ldc.i4 1288306693
		IL_0203: stloc 6
		IL_0207: nop
		IL_0208: ldloca 6
		IL_020c: nop
		IL_020d: ldind.i2
		IL_020e: conv.i2
		IL_020f: conv.i
		IL_0210: stloc.s 5
		IL_0212: br IL_004f

		IL_0217: br.s IL_0219

		IL_0219: ldloc.0
		IL_021a: callvirt instance string [mscorlib]System.Object::ToString()
		IL_021f: ret
	} // end of method Encryption::DecodeForUnicode

	.method public hidebysig static 
		bool DecryptString (
			string encrypted,
			bool isWebFriendly,
			[out] string& plainText,
			string& failText
		) cil managed 
	{
		// Method begins at RVA 0xa74c
		// Header size: 12
		// Code size: 178 (0xb2)
		.maxstack 6
		.locals init (
			[0] int16
		)

		IL_0000: br.s IL_0016

		IL_0002: ldc.i4 206503936
		IL_0007: nop
		IL_0008: stloc 0
		IL_000c: nop
		IL_000d: ldloca 0
		IL_0011: ldind.i2
		IL_0012: conv.i2

		IL_0013: pop
		IL_0014: br.s IL_002a

		IL_0016: ldc.i4 1577582592
		IL_001b: nop
		IL_001c: stloc 0
		IL_0020: nop
		IL_0021: ldloca 0
		IL_0025: nop
		IL_0026: ldind.i2
		IL_0027: conv.i2
		IL_0028: br.s IL_0013

		IL_002a: nop
		IL_002b: ldc.i4 322411440
		IL_0030: nop
		IL_0031: stloc 0
		IL_0035: nop
		IL_0036: ldloca 0
		IL_003a: nop
		IL_003b: ldind.i2
		IL_003c: conv.i2
		IL_003d: ldc.i4 1641323440
		IL_0042: stloc 0
		IL_0046: nop
		IL_0047: ldloca 0
		IL_004b: nop
		IL_004c: ldind.i2
		IL_004d: conv.i2
		IL_004e: ceq
		IL_0050: switch (IL_0061, IL_0062, IL_0061)

		IL_0061: nop

		IL_0062: ldc.i4 333381632
		IL_0067: stloc 0
		IL_006b: ldloca 0
		IL_006f: nop
		IL_0070: ldind.i2
		IL_0071: conv.i2
		IL_0072: brfalse IL_0077

		IL_0077: ldc.i4 1993277441
		IL_007c: stloc 0
		IL_0080: nop
		IL_0081: ldloca 0
		IL_0085: nop
		IL_0086: ldind.i2
		IL_0087: conv.i2
		IL_0088: br.s IL_009c

		IL_008a: ldc.i4 205127680
		IL_008f: stloc 0
		IL_0093: ldloca 0
		IL_0097: nop
		IL_0098: ldind.i2
		IL_0099: conv.i2
		IL_009a: br.s IL_009c

		IL_009c: brfalse.s IL_009e

		IL_009e: ldarg.0
		IL_009f: ldarg.1
		IL_00a0: call string ODCrypt.Encryption::w()
		IL_00a5: call string ODCrypt.Encryption::get_STATIC_INIT_VECTOR()
		IL_00aa: ldarg.2
		IL_00ab: ldarg.3
		IL_00ac: call bool ODCrypt.Encryption::DecryptString(string, bool, string, string, string&, string&)
		IL_00b1: ret
	} // end of method Encryption::DecryptString

	.method public hidebysig static 
		bool DecryptString (
			string encrypted,
			bool isWebFriendly,
			string key,
			string initVector,
			[out] string& plainText,
			string& failText
		) cil managed 
	{
		// Method begins at RVA 0xa80c
		// Header size: 12
		// Code size: 1008 (0x3f0)
		.maxstack 3
		.locals init (
			[0] bool,
			[1] class [mscorlib]System.Security.Cryptography.SymmetricAlgorithm,
			[2] class [mscorlib]System.Security.Cryptography.ICryptoTransform,
			[3] class [mscorlib]System.IO.MemoryStream,
			[4] class [mscorlib]System.Security.Cryptography.CryptoStream,
			[5] class [mscorlib]System.IO.StreamReader,
			[6] class [mscorlib]System.Exception,
			[7] int32,
			[8] int16
		)

		IL_0000: br.s IL_0015

		IL_0002: ldc.i4 494796800
		IL_0007: stloc 8
		IL_000b: nop
		IL_000c: ldloca 8
		IL_0010: ldind.i2
		IL_0011: conv.i2

		IL_0012: pop
		IL_0013: br.s IL_0027

		IL_0015: ldc.i4 1563688960
		IL_001a: stloc 8
		IL_001e: nop
		IL_001f: ldloca 8
		IL_0023: ldind.i2
		IL_0024: conv.i2
		IL_0025: br.s IL_0012

		IL_0027: nop
		IL_0028: ldc.i4 1152516096
		IL_002d: stloc 8
		IL_0031: nop
		IL_0032: ldloca 8
		IL_0036: nop
		IL_0037: ldind.i2
		IL_0038: conv.i2
		IL_0039: stloc.s 7
		IL_003b: ldloc.s 7
		IL_003d: switch (IL_0046)

		IL_0046: ldc.i4 1624367207
		IL_004b: nop
		IL_004c: stloc 8
		IL_0050: ldloca 8
		IL_0054: nop
		IL_0055: ldind.i2
		IL_0056: conv.i2
		IL_0057: ldc.i4 1548214375
		IL_005c: stloc 8
		IL_0060: ldloca 8
		IL_0064: nop
		IL_0065: ldind.i2
		IL_0066: conv.i2
		IL_0067: ceq
		IL_0069: switch (IL_03ee, IL_007b, IL_03ee)

		IL_007a: nop

		IL_007b: ldc.i4 1422655488
		IL_0080: stloc 8
		IL_0084: nop
		IL_0085: ldloca 8
		IL_0089: ldind.i2
		IL_008a: conv.i2
		IL_008b: brfalse IL_0090

		IL_0090: ldarg.s plainText
		IL_0092: ldstr ""
		IL_0097: stind.ref
		IL_0098: br.s IL_009a
		.try
		{
			IL_009a: ldc.i4 274464768
			IL_009f: stloc 8
			IL_00a3: nop
			IL_00a4: ldloca 8
			IL_00a8: ldind.i2
			IL_00a9: conv.i2
			IL_00aa: conv.i
			IL_00ab: stloc.s 7
			IL_00ad: br.s IL_00b9
			// loop start (head: IL_00b9)
				IL_00af: ldc.i4.0
				IL_00b0: switch (IL_00dc)

				IL_00b9: ldloc.s 7
				IL_00bb: switch (IL_00af, IL_03bb, IL_0135, IL_0176, IL_0152, IL_03dc, IL_00f5)
			// end loop

			IL_00dc: ldarg.0
			IL_00dd: brfalse.s IL_011d

			IL_00df: ldc.i4 45613062
			IL_00e4: nop
			IL_00e5: stloc 8
			IL_00e9: ldloca 8
			IL_00ed: nop
			IL_00ee: ldind.i2
			IL_00ef: conv.i2
			IL_00f0: conv.i
			IL_00f1: stloc.s 7
			IL_00f3: br.s IL_00b9

			IL_00f5: ldc.i4 1202978817
			IL_00fa: nop
			IL_00fb: stloc 8
			IL_00ff: ldloca 8
			IL_0103: ldind.i2
			IL_0104: conv.i2
			IL_0105: br.s IL_0119

			IL_0107: ldc.i4 1006895104
			IL_010c: stloc 8
			IL_0110: nop
			IL_0111: ldloca 8
			IL_0115: ldind.i2
			IL_0116: conv.i2
			IL_0117: br.s IL_0119

			IL_0119: brfalse.s IL_011b

			IL_011b: br.s IL_013a

			IL_011d: ldc.i4.1
			IL_011e: stloc.0
			IL_011f: ldc.i4 1979580418
			IL_0124: nop
			IL_0125: stloc 8
			IL_0129: nop
			IL_012a: ldloca 8
			IL_012e: ldind.i2
			IL_012f: conv.i2
			IL_0130: conv.i
			IL_0131: stloc.s 7
			IL_0133: br.s IL_00b9

			IL_0135: leave IL_03ee

			IL_013a: ldc.i4 2104688644
			IL_013f: nop
			IL_0140: stloc 8
			IL_0144: ldloca 8
			IL_0148: ldind.i2
			IL_0149: conv.i2
			IL_014a: conv.i
			IL_014b: stloc.s 7
			IL_014d: br IL_00b9

			IL_0152: ldarg.0
			IL_0153: callvirt instance int32 [mscorlib]System.String::get_Length()
			IL_0158: ldc.i4.0
			IL_0159: bgt IL_0396

			IL_015e: ldc.i4 1808334851
			IL_0163: stloc 8
			IL_0167: ldloca 8
			IL_016b: nop
			IL_016c: ldind.i2
			IL_016d: conv.i2
			IL_016e: conv.i
			IL_016f: stloc.s 7
			IL_0171: br IL_00b9

			IL_0176: br.s IL_011d
			.try
			{
				IL_0178: ldloc.1
				IL_0179: ldarg.2
				IL_017a: ldc.i4.1
				IL_017b: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_0180: callvirt instance void [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::set_Key(uint8[])
				IL_0185: ldloc.1
				IL_0186: ldarg.3
				IL_0187: ldc.i4.1
				IL_0188: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_018d: callvirt instance void [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::set_IV(uint8[])
				IL_0192: ldloc.1
				IL_0193: ldloc.1
				IL_0194: callvirt instance uint8[] [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::get_Key()
				IL_0199: ldloc.1
				IL_019a: callvirt instance uint8[] [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::get_IV()
				IL_019f: callvirt instance class [mscorlib]System.Security.Cryptography.ICryptoTransform [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::CreateDecryptor(uint8[], uint8[])
				IL_01a4: stloc.2
				IL_01a5: ldarg.0
				IL_01a6: ldarg.1
				IL_01a7: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_01ac: newobj instance void [mscorlib]System.IO.MemoryStream::.ctor(uint8[])
				IL_01b1: stloc.3
				IL_01b2: br.s IL_01b4
				.try
				{
					IL_01b4: ldloc.3
					IL_01b5: ldloc.2
					IL_01b6: ldc.i4.0
					IL_01b7: newobj instance void [mscorlib]System.Security.Cryptography.CryptoStream::.ctor(class [mscorlib]System.IO.Stream, class [mscorlib]System.Security.Cryptography.ICryptoTransform, valuetype [mscorlib]System.Security.Cryptography.CryptoStreamMode)
					IL_01bc: stloc.s 4
					IL_01be: br.s IL_01c0
					.try
					{
						IL_01c0: ldloc.s 4
						IL_01c2: newobj instance void [mscorlib]System.IO.StreamReader::.ctor(class [mscorlib]System.IO.Stream)
						IL_01c7: stloc.s 5
						IL_01c9: br.s IL_01cb
						.try
						{
							IL_01cb: ldarg.s plainText
							IL_01cd: ldloc.s 5
							IL_01cf: callvirt instance string [mscorlib]System.IO.TextReader::ReadToEnd()
							IL_01d4: stind.ref
							IL_01d5: leave.s IL_0244
						} // end .try
						finally
						{
							IL_01d7: ldc.i4 961609730
							IL_01dc: nop
							IL_01dd: stloc 8
							IL_01e1: ldloca 8
							IL_01e5: ldind.i2
							IL_01e6: conv.i2
							IL_01e7: conv.i
							IL_01e8: stloc.s 7
							IL_01ea: br.s IL_01f6
							// loop start (head: IL_01f6)
								IL_01ec: ldc.i4.0
								IL_01ed: switch (IL_0209)

								IL_01f6: ldloc.s 7
								IL_01f8: switch (IL_0223, IL_0241, IL_01ec)
							// end loop

							IL_0209: ldloc.s 5
							IL_020b: brfalse.s IL_0243

							IL_020d: ldc.i4 1922105344
							IL_0212: stloc 8
							IL_0216: nop
							IL_0217: ldloca 8
							IL_021b: nop
							IL_021c: ldind.i2
							IL_021d: conv.i2
							IL_021e: conv.i
							IL_021f: stloc.s 7
							IL_0221: br.s IL_01f6

							IL_0223: br.s IL_0225

							IL_0225: ldloc.s 5
							IL_0227: callvirt instance void [mscorlib]System.IDisposable::Dispose()
							IL_022c: ldc.i4 1033043969
							IL_0231: stloc 8
							IL_0235: nop
							IL_0236: ldloca 8
							IL_023a: ldind.i2
							IL_023b: conv.i2
							IL_023c: conv.i
							IL_023d: stloc.s 7
							IL_023f: br.s IL_01f6

							IL_0241: br.s IL_0243

							IL_0243: endfinally
						} // end handler

						IL_0244: leave.s IL_02b6
					} // end .try
					finally
					{
						IL_0246: ldc.i4 833617922
						IL_024b: nop
						IL_024c: stloc 8
						IL_0250: nop
						IL_0251: ldloca 8
						IL_0255: nop
						IL_0256: ldind.i2
						IL_0257: conv.i2
						IL_0258: conv.i
						IL_0259: stloc.s 7
						IL_025b: br.s IL_0267
						// loop start (head: IL_0267)
							IL_025d: ldc.i4.0
							IL_025e: switch (IL_027a)

							IL_0267: ldloc.s 7
							IL_0269: switch (IL_0294, IL_02b3, IL_025d)
						// end loop

						IL_027a: ldloc.s 4
						IL_027c: brfalse.s IL_02b5

						IL_027e: ldc.i4 1998716928
						IL_0283: nop
						IL_0284: stloc 8
						IL_0288: ldloca 8
						IL_028c: nop
						IL_028d: ldind.i2
						IL_028e: conv.i2
						IL_028f: conv.i
						IL_0290: stloc.s 7
						IL_0292: br.s IL_0267

						IL_0294: br.s IL_0296

						IL_0296: ldloc.s 4
						IL_0298: callvirt instance void [mscorlib]System.IDisposable::Dispose()
						IL_029d: ldc.i4 1752825857
						IL_02a2: stloc 8
						IL_02a6: nop
						IL_02a7: ldloca 8
						IL_02ab: nop
						IL_02ac: ldind.i2
						IL_02ad: conv.i2
						IL_02ae: conv.i
						IL_02af: stloc.s 7
						IL_02b1: br.s IL_0267

						IL_02b3: br.s IL_02b5

						IL_02b5: endfinally
					} // end handler

					IL_02b6: leave.s IL_0324
				} // end .try
				finally
				{
					IL_02b8: ldc.i4 45809666
					IL_02bd: nop
					IL_02be: stloc 8
					IL_02c2: ldloca 8
					IL_02c6: nop
					IL_02c7: ldind.i2
					IL_02c8: conv.i2
					IL_02c9: conv.i
					IL_02ca: stloc.s 7
					IL_02cc: br.s IL_02d8
					// loop start (head: IL_02d8)
						IL_02ce: ldc.i4.0
						IL_02cf: switch (IL_02eb)

						IL_02d8: ldloc.s 7
						IL_02da: switch (IL_0304, IL_0321, IL_02ce)
					// end loop

					IL_02eb: ldloc.3
					IL_02ec: brfalse.s IL_0323

					IL_02ee: ldc.i4 1575092224
					IL_02f3: nop
					IL_02f4: stloc 8
					IL_02f8: ldloca 8
					IL_02fc: nop
					IL_02fd: ldind.i2
					IL_02fe: conv.i2
					IL_02ff: conv.i
					IL_0300: stloc.s 7
					IL_0302: br.s IL_02d8

					IL_0304: br.s IL_0306

					IL_0306: ldloc.3
					IL_0307: callvirt instance void [mscorlib]System.IDisposable::Dispose()
					IL_030c: ldc.i4 486998017
					IL_0311: stloc 8
					IL_0315: ldloca 8
					IL_0319: nop
					IL_031a: ldind.i2
					IL_031b: conv.i2
					IL_031c: conv.i
					IL_031d: stloc.s 7
					IL_031f: br.s IL_02d8

					IL_0321: br.s IL_0323

					IL_0323: endfinally
				} // end handler

				IL_0324: leave IL_03c0
			} // end .try
			finally
			{
				IL_0329: ldc.i4 1881473026
				IL_032e: nop
				IL_032f: stloc 8
				IL_0333: ldloca 8
				IL_0337: nop
				IL_0338: ldind.i2
				IL_0339: conv.i2
				IL_033a: conv.i
				IL_033b: stloc.s 7
				IL_033d: br.s IL_0349
				// loop start (head: IL_0349)
					IL_033f: ldc.i4.0
					IL_0340: switch (IL_035c)

					IL_0349: ldloc.s 7
					IL_034b: switch (IL_0376, IL_0393, IL_033f)
				// end loop

				IL_035c: ldloc.1
				IL_035d: brfalse.s IL_0395

				IL_035f: ldc.i4 1417281536
				IL_0364: nop
				IL_0365: stloc 8
				IL_0369: nop
				IL_036a: ldloca 8
				IL_036e: nop
				IL_036f: ldind.i2
				IL_0370: conv.i2
				IL_0371: conv.i
				IL_0372: stloc.s 7
				IL_0374: br.s IL_0349

				IL_0376: br.s IL_0378

				IL_0378: ldloc.1
				IL_0379: callvirt instance void [mscorlib]System.IDisposable::Dispose()
				IL_037e: ldc.i4 1616904193
				IL_0383: stloc 8
				IL_0387: ldloca 8
				IL_038b: nop
				IL_038c: ldind.i2
				IL_038d: conv.i2
				IL_038e: conv.i
				IL_038f: stloc.s 7
				IL_0391: br.s IL_0349

				IL_0393: br.s IL_0395

				IL_0395: endfinally
			} // end handler

			IL_0396: ldarg.2
			IL_0397: ldarg.3
			IL_0398: call void ODCrypt.Encryption::w(string, string)
			IL_039d: newobj instance void [System.Core]System.Security.Cryptography.AesCryptoServiceProvider::.ctor()
			IL_03a2: stloc.1
			IL_03a3: ldc.i4 1988362241
			IL_03a8: stloc 8
			IL_03ac: ldloca 8
			IL_03b0: nop
			IL_03b1: ldind.i2
			IL_03b2: conv.i2
			IL_03b3: conv.i
			IL_03b4: stloc.s 7
			IL_03b6: br IL_00b9

			IL_03bb: br IL_0178

			IL_03c0: ldc.i4.1
			IL_03c1: stloc.0
			IL_03c2: ldc.i4 1049755653
			IL_03c7: nop
			IL_03c8: stloc 8
			IL_03cc: nop
			IL_03cd: ldloca 8
			IL_03d1: nop
			IL_03d2: ldind.i2
			IL_03d3: conv.i2
			IL_03d4: conv.i
			IL_03d5: stloc.s 7
			IL_03d7: br IL_00b9

			IL_03dc: leave.s IL_03ee
		} // end .try
		catch [mscorlib]System.Exception
		{
			IL_03de: stloc.s 6
			IL_03e0: ldarg.s failText
			IL_03e2: ldloc.s 6
			IL_03e4: callvirt instance string [mscorlib]System.Exception::get_Message()
			IL_03e9: stind.ref
			IL_03ea: ldc.i4.0
			IL_03eb: stloc.0
			IL_03ec: leave.s IL_03ee
		} // end handler

		IL_03ee: ldloc.0
		IL_03ef: ret
	} // end of method Encryption::DecryptString

	.method public hidebysig static 
		bool DecryptString (
			string encrypted,
			bool isWebFriendly,
			string key,
			string initVector,
			[out] uint8[]& bytes,
			string& failText
		) cil managed 
	{
		// Method begins at RVA 0xac84
		// Header size: 12
		// Code size: 1069 (0x42d)
		.maxstack 3
		.locals init (
			[0] bool,
			[1] class [mscorlib]System.Security.Cryptography.SymmetricAlgorithm,
			[2] class [mscorlib]System.Security.Cryptography.ICryptoTransform,
			[3] class [mscorlib]System.IO.MemoryStream,
			[4] class [mscorlib]System.Security.Cryptography.CryptoStream,
			[5] class [mscorlib]System.IO.StreamReader,
			[6] class [mscorlib]System.IO.MemoryStream,
			[7] class [mscorlib]System.Exception,
			[8] int32,
			[9] int16
		)

		IL_0000: br.s IL_0016

		IL_0002: ldc.i4 1807613952
		IL_0007: nop
		IL_0008: stloc 9
		IL_000c: nop
		IL_000d: ldloca 9
		IL_0011: ldind.i2
		IL_0012: conv.i2

		IL_0013: pop
		IL_0014: br.s IL_0028

		IL_0016: ldc.i4 1330249728
		IL_001b: stloc 9
		IL_001f: ldloca 9
		IL_0023: nop
		IL_0024: ldind.i2
		IL_0025: conv.i2
		IL_0026: br.s IL_0013

		IL_0028: nop
		IL_0029: ldc.i4 12648448
		IL_002e: stloc 9
		IL_0032: nop
		IL_0033: ldloca 9
		IL_0037: nop
		IL_0038: ldind.i2
		IL_0039: conv.i2
		IL_003a: stloc.s 8
		IL_003c: ldloc.s 8
		IL_003e: switch (IL_0047)

		IL_0047: ldc.i4 1964305939
		IL_004c: stloc 9
		IL_0050: nop
		IL_0051: ldloca 9
		IL_0055: ldind.i2
		IL_0056: conv.i2
		IL_0057: ldc.i4 216002067
		IL_005c: nop
		IL_005d: stloc 9
		IL_0061: nop
		IL_0062: ldloca 9
		IL_0066: ldind.i2
		IL_0067: conv.i2
		IL_0068: ceq
		IL_006a: switch (IL_042b, IL_007c, IL_042b)

		IL_007b: nop

		IL_007c: ldc.i4 38666241
		IL_0081: nop
		IL_0082: stloc 9
		IL_0086: ldloca 9
		IL_008a: nop
		IL_008b: ldind.i2
		IL_008c: conv.i2
		IL_008d: br.s IL_00a1

		IL_008f: ldc.i4 1696464896
		IL_0094: stloc 9
		IL_0098: ldloca 9
		IL_009c: nop
		IL_009d: ldind.i2
		IL_009e: conv.i2
		IL_009f: br.s IL_00a1

		IL_00a1: brfalse.s IL_00a3

		IL_00a3: ldc.i4 1029636096
		IL_00a8: nop
		IL_00a9: stloc 9
		IL_00ad: nop
		IL_00ae: ldloca 9
		IL_00b2: ldind.i2
		IL_00b3: conv.i2
		IL_00b4: brfalse IL_00b9

		IL_00b9: ldarg.s bytes
		IL_00bb: ldnull
		IL_00bc: stind.ref
		IL_00bd: br.s IL_00bf
		.try
		{
			IL_00bf: ldc.i4 540672000
			IL_00c4: nop
			IL_00c5: stloc 9
			IL_00c9: ldloca 9
			IL_00cd: nop
			IL_00ce: ldind.i2
			IL_00cf: conv.i2
			IL_00d0: conv.i
			IL_00d1: stloc.s 8
			IL_00d3: br.s IL_00df
			// loop start (head: IL_00df)
				IL_00d5: ldc.i4.0
				IL_00d6: switch (IL_00fa)

				IL_00df: ldloc.s 8
				IL_00e1: switch (IL_00d5, IL_0159, IL_0132, IL_0419, IL_0118)
			// end loop

			IL_00fa: ldarg.0
			IL_00fb: call bool [mscorlib]System.String::IsNullOrEmpty(string)
			IL_0100: brfalse.s IL_0137

			IL_0102: ldc.i4 584384516
			IL_0107: nop
			IL_0108: stloc 9
			IL_010c: nop
			IL_010d: ldloca 9
			IL_0111: ldind.i2
			IL_0112: conv.i2
			IL_0113: conv.i
			IL_0114: stloc.s 8
			IL_0116: br.s IL_00df

			IL_0118: br.s IL_011a

			IL_011a: ldc.i4.1
			IL_011b: stloc.0
			IL_011c: ldc.i4 1290338306
			IL_0121: stloc 9
			IL_0125: nop
			IL_0126: ldloca 9
			IL_012a: nop
			IL_012b: ldind.i2
			IL_012c: conv.i2
			IL_012d: conv.i
			IL_012e: stloc.s 8
			IL_0130: br.s IL_00df

			IL_0132: leave IL_042b

			IL_0137: ldarg.2
			IL_0138: ldarg.3
			IL_0139: call void ODCrypt.Encryption::w(string, string)
			IL_013e: newobj instance void [System.Core]System.Security.Cryptography.AesCryptoServiceProvider::.ctor()
			IL_0143: stloc.1
			IL_0144: ldc.i4 991756289
			IL_0149: stloc 9
			IL_014d: nop
			IL_014e: ldloca 9
			IL_0152: ldind.i2
			IL_0153: conv.i2
			IL_0154: conv.i
			IL_0155: stloc.s 8
			IL_0157: br.s IL_00df

			IL_0159: br.s IL_015b
			.try
			{
				IL_015b: ldloc.1
				IL_015c: ldarg.2
				IL_015d: ldc.i4.1
				IL_015e: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_0163: callvirt instance void [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::set_Key(uint8[])
				IL_0168: ldloc.1
				IL_0169: ldarg.3
				IL_016a: ldc.i4.1
				IL_016b: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_0170: callvirt instance void [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::set_IV(uint8[])
				IL_0175: ldloc.1
				IL_0176: ldc.i4.1
				IL_0177: callvirt instance void [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::set_Padding(valuetype [mscorlib]System.Security.Cryptography.PaddingMode)
				IL_017c: ldloc.1
				IL_017d: ldloc.1
				IL_017e: callvirt instance uint8[] [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::get_Key()
				IL_0183: ldloc.1
				IL_0184: callvirt instance uint8[] [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::get_IV()
				IL_0189: callvirt instance class [mscorlib]System.Security.Cryptography.ICryptoTransform [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::CreateDecryptor(uint8[], uint8[])
				IL_018e: stloc.2
				IL_018f: ldarg.0
				IL_0190: ldarg.1
				IL_0191: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_0196: newobj instance void [mscorlib]System.IO.MemoryStream::.ctor(uint8[])
				IL_019b: stloc.3
				IL_019c: br.s IL_019e
				.try
				{
					IL_019e: ldloc.3
					IL_019f: ldloc.2
					IL_01a0: ldc.i4.0
					IL_01a1: newobj instance void [mscorlib]System.Security.Cryptography.CryptoStream::.ctor(class [mscorlib]System.IO.Stream, class [mscorlib]System.Security.Cryptography.ICryptoTransform, valuetype [mscorlib]System.Security.Cryptography.CryptoStreamMode)
					IL_01a6: stloc.s 4
					IL_01a8: br.s IL_01aa
					.try
					{
						IL_01aa: ldloc.s 4
						IL_01ac: newobj instance void [mscorlib]System.IO.StreamReader::.ctor(class [mscorlib]System.IO.Stream)
						IL_01b1: stloc.s 5
						IL_01b3: br.s IL_01b5
						.try
						{
							IL_01b5: newobj instance void [mscorlib]System.IO.MemoryStream::.ctor()
							IL_01ba: stloc.s 6
							IL_01bc: br.s IL_01be
							.try
							{
								IL_01be: ldloc.s 5
								IL_01c0: callvirt instance class [mscorlib]System.IO.Stream [mscorlib]System.IO.StreamReader::get_BaseStream()
								IL_01c5: ldloc.s 6
								IL_01c7: callvirt instance void [mscorlib]System.IO.Stream::CopyTo(class [mscorlib]System.IO.Stream)
								IL_01cc: ldarg.s bytes
								IL_01ce: ldloc.s 6
								IL_01d0: callvirt instance uint8[] [mscorlib]System.IO.MemoryStream::ToArray()
								IL_01d5: stind.ref
								IL_01d6: leave.s IL_0246
							} // end .try
							finally
							{
								IL_01d8: ldc.i4 2070282242
								IL_01dd: nop
								IL_01de: stloc 9
								IL_01e2: ldloca 9
								IL_01e6: ldind.i2
								IL_01e7: conv.i2
								IL_01e8: conv.i
								IL_01e9: stloc.s 8
								IL_01eb: br.s IL_01f7
								// loop start (head: IL_01f7)
									IL_01ed: ldc.i4.0
									IL_01ee: switch (IL_020a)

									IL_01f7: ldloc.s 8
									IL_01f9: switch (IL_0223, IL_0243, IL_01ed)
								// end loop

								IL_020a: ldloc.s 6
								IL_020c: brfalse.s IL_0245

								IL_020e: ldc.i4 312999936
								IL_0213: stloc 9
								IL_0217: ldloca 9
								IL_021b: nop
								IL_021c: ldind.i2
								IL_021d: conv.i2
								IL_021e: conv.i
								IL_021f: stloc.s 8
								IL_0221: br.s IL_01f7

								IL_0223: br.s IL_0225

								IL_0225: ldloc.s 6
								IL_0227: callvirt instance void [mscorlib]System.IDisposable::Dispose()
								IL_022c: ldc.i4 957153281
								IL_0231: nop
								IL_0232: stloc 9
								IL_0236: nop
								IL_0237: ldloca 9
								IL_023b: nop
								IL_023c: ldind.i2
								IL_023d: conv.i2
								IL_023e: conv.i
								IL_023f: stloc.s 8
								IL_0241: br.s IL_01f7

								IL_0243: br.s IL_0245

								IL_0245: endfinally
							} // end handler

							IL_0246: leave.s IL_02b5
						} // end .try
						finally
						{
							IL_0248: ldc.i4 156696578
							IL_024d: stloc 9
							IL_0251: ldloca 9
							IL_0255: nop
							IL_0256: ldind.i2
							IL_0257: conv.i2
							IL_0258: conv.i
							IL_0259: stloc.s 8
							IL_025b: br.s IL_0267
							// loop start (head: IL_0267)
								IL_025d: ldc.i4.0
								IL_025e: switch (IL_027a)

								IL_0267: ldloc.s 8
								IL_0269: switch (IL_0293, IL_02b2, IL_025d)
							// end loop

							IL_027a: ldloc.s 5
							IL_027c: brfalse.s IL_02b4

							IL_027e: ldc.i4 226230272
							IL_0283: stloc 9
							IL_0287: nop
							IL_0288: ldloca 9
							IL_028c: ldind.i2
							IL_028d: conv.i2
							IL_028e: conv.i
							IL_028f: stloc.s 8
							IL_0291: br.s IL_0267

							IL_0293: br.s IL_0295

							IL_0295: ldloc.s 5
							IL_0297: callvirt instance void [mscorlib]System.IDisposable::Dispose()
							IL_029c: ldc.i4 315817985
							IL_02a1: nop
							IL_02a2: stloc 9
							IL_02a6: nop
							IL_02a7: ldloca 9
							IL_02ab: ldind.i2
							IL_02ac: conv.i2
							IL_02ad: conv.i
							IL_02ae: stloc.s 8
							IL_02b0: br.s IL_0267

							IL_02b2: br.s IL_02b4

							IL_02b4: endfinally
						} // end handler

						IL_02b5: leave.s IL_0324
					} // end .try
					finally
					{
						IL_02b7: ldc.i4 1458241538
						IL_02bc: nop
						IL_02bd: stloc 9
						IL_02c1: nop
						IL_02c2: ldloca 9
						IL_02c6: ldind.i2
						IL_02c7: conv.i2
						IL_02c8: conv.i
						IL_02c9: stloc.s 8
						IL_02cb: br.s IL_02d7
						// loop start (head: IL_02d7)
							IL_02cd: ldc.i4.0
							IL_02ce: switch (IL_02ea)

							IL_02d7: ldloc.s 8
							IL_02d9: switch (IL_0303, IL_0321, IL_02cd)
						// end loop

						IL_02ea: ldloc.s 4
						IL_02ec: brfalse.s IL_0323

						IL_02ee: ldc.i4 803995648
						IL_02f3: stloc 9
						IL_02f7: nop
						IL_02f8: ldloca 9
						IL_02fc: ldind.i2
						IL_02fd: conv.i2
						IL_02fe: conv.i
						IL_02ff: stloc.s 8
						IL_0301: br.s IL_02d7

						IL_0303: br.s IL_0305

						IL_0305: ldloc.s 4
						IL_0307: callvirt instance void [mscorlib]System.IDisposable::Dispose()
						IL_030c: ldc.i4 1850408961
						IL_0311: stloc 9
						IL_0315: ldloca 9
						IL_0319: nop
						IL_031a: ldind.i2
						IL_031b: conv.i2
						IL_031c: conv.i
						IL_031d: stloc.s 8
						IL_031f: br.s IL_02d7

						IL_0321: br.s IL_0323

						IL_0323: endfinally
					} // end handler

					IL_0324: leave.s IL_0392
				} // end .try
				finally
				{
					IL_0326: ldc.i4 156368898
					IL_032b: nop
					IL_032c: stloc 9
					IL_0330: ldloca 9
					IL_0334: ldind.i2
					IL_0335: conv.i2
					IL_0336: conv.i
					IL_0337: stloc.s 8
					IL_0339: br.s IL_0345
					// loop start (head: IL_0345)
						IL_033b: ldc.i4.0
						IL_033c: switch (IL_0358)

						IL_0345: ldloc.s 8
						IL_0347: switch (IL_0371, IL_038f, IL_033b)
					// end loop

					IL_0358: ldloc.3
					IL_0359: brfalse.s IL_0391

					IL_035b: ldc.i4 556597248
					IL_0360: nop
					IL_0361: stloc 9
					IL_0365: ldloca 9
					IL_0369: nop
					IL_036a: ldind.i2
					IL_036b: conv.i2
					IL_036c: conv.i
					IL_036d: stloc.s 8
					IL_036f: br.s IL_0345

					IL_0371: br.s IL_0373

					IL_0373: ldloc.3
					IL_0374: callvirt instance void [mscorlib]System.IDisposable::Dispose()
					IL_0379: ldc.i4 1056309249
					IL_037e: nop
					IL_037f: stloc 9
					IL_0383: ldloca 9
					IL_0387: nop
					IL_0388: ldind.i2
					IL_0389: conv.i2
					IL_038a: conv.i
					IL_038b: stloc.s 8
					IL_038d: br.s IL_0345

					IL_038f: br.s IL_0391

					IL_0391: endfinally
				} // end handler

				IL_0392: leave.s IL_03fe
			} // end .try
			finally
			{
				IL_0394: ldc.i4 1545338882
				IL_0399: stloc 9
				IL_039d: nop
				IL_039e: ldloca 9
				IL_03a2: ldind.i2
				IL_03a3: conv.i2
				IL_03a4: conv.i
				IL_03a5: stloc.s 8
				IL_03a7: br.s IL_03b3
				// loop start (head: IL_03b3)
					IL_03a9: ldc.i4.0
					IL_03aa: switch (IL_03c6)

					IL_03b3: ldloc.s 8
					IL_03b5: switch (IL_03de, IL_03fb, IL_03a9)
				// end loop

				IL_03c6: ldloc.1
				IL_03c7: brfalse.s IL_03fd

				IL_03c9: ldc.i4 432144384
				IL_03ce: stloc 9
				IL_03d2: ldloca 9
				IL_03d6: nop
				IL_03d7: ldind.i2
				IL_03d8: conv.i2
				IL_03d9: conv.i
				IL_03da: stloc.s 8
				IL_03dc: br.s IL_03b3

				IL_03de: br.s IL_03e0

				IL_03e0: ldloc.1
				IL_03e1: callvirt instance void [mscorlib]System.IDisposable::Dispose()
				IL_03e6: ldc.i4 404488193
				IL_03eb: stloc 9
				IL_03ef: ldloca 9
				IL_03f3: nop
				IL_03f4: ldind.i2
				IL_03f5: conv.i2
				IL_03f6: conv.i
				IL_03f7: stloc.s 8
				IL_03f9: br.s IL_03b3

				IL_03fb: br.s IL_03fd

				IL_03fd: endfinally
			} // end handler

			IL_03fe: ldc.i4.1
			IL_03ff: stloc.0
			IL_0400: ldc.i4 1034092547
			IL_0405: nop
			IL_0406: stloc 9
			IL_040a: ldloca 9
			IL_040e: nop
			IL_040f: ldind.i2
			IL_0410: conv.i2
			IL_0411: conv.i
			IL_0412: stloc.s 8
			IL_0414: br IL_00df

			IL_0419: leave.s IL_042b
		} // end .try
		catch [mscorlib]System.Exception
		{
			IL_041b: stloc.s 7
			IL_041d: ldarg.s failText
			IL_041f: ldloc.s 7
			IL_0421: callvirt instance string [mscorlib]System.Exception::get_Message()
			IL_0426: stind.ref
			IL_0427: ldc.i4.0
			IL_0428: stloc.0
			IL_0429: leave.s IL_042b
		} // end handler

		IL_042b: ldloc.0
		IL_042c: ret
	} // end of method Encryption::DecryptString

	.method public hidebysig static 
		bool DecryptFile (
			string encryptedFileName,
			string decryptedFileName,
			string key,
			string initVector,
			string& failText
		) cil managed 
	{
		// Method begins at RVA 0xb154
		// Header size: 12
		// Code size: 1031 (0x407)
		.maxstack 4
		.locals init (
			[0] class [mscorlib]System.Security.Cryptography.SymmetricAlgorithm,
			[1] class [mscorlib]System.Security.Cryptography.ICryptoTransform,
			[2] class [mscorlib]System.IO.FileStream,
			[3] class [mscorlib]System.IO.FileStream,
			[4] class [mscorlib]System.Security.Cryptography.CryptoStream,
			[5] bool,
			[6] class [mscorlib]System.Exception,
			[7] int32,
			[8] int16,
			[9] int32
		)

		IL_0000: ldc.i4 12
		IL_0005: stloc 9
		.try
		{
			IL_0009: ldc.i4 67960832
			IL_000e: nop
			IL_000f: stloc 8
			IL_0013: nop
			IL_0014: ldloca 8
			IL_0018: nop
			IL_0019: ldind.i2
			IL_001a: conv.i2
			IL_001b: stloc.s 7
			IL_001d: ldloc.s 7
			IL_001f: switch (IL_0028)

			IL_0028: ldc.i4 18874368
			IL_002d: stloc 8
			IL_0031: nop
			IL_0032: ldloca 8
			IL_0036: ldind.i2
			IL_0037: conv.i2
			IL_0038: conv.i
			IL_0039: stloc.s 7
			IL_003b: br.s IL_0047
			// loop start (head: IL_0047)
				IL_003d: ldc.i4.0
				IL_003e: switch (IL_006a)

				IL_0047: ldloc.s 7
				IL_0049: switch (IL_003d, IL_0381, IL_02f1, IL_0355, IL_0335, IL_03a1, IL_008a)
			// end loop

			IL_006a: ldarg.0
			IL_006b: call bool [mscorlib]System.IO.File::Exists(string)
			IL_0070: brtrue IL_031b

			IL_0075: ldc.i4 537460742
			IL_007a: stloc 8
			IL_007e: nop
			IL_007f: ldloca 8
			IL_0083: ldind.i2
			IL_0084: conv.i2
			IL_0085: conv.i
			IL_0086: stloc.s 7
			IL_0088: br.s IL_0047

			IL_008a: br IL_02f3
			.try
			{
				IL_008f: ldloc.0
				IL_0090: ldarg.2
				IL_0091: ldc.i4.1
				IL_0092: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_0097: ldarg.3
				IL_0098: ldc.i4.1
				IL_0099: call uint8[] ODCrypt.Encryption::StringToBytes(string, bool)
				IL_009e: callvirt instance class [mscorlib]System.Security.Cryptography.ICryptoTransform [mscorlib]System.Security.Cryptography.SymmetricAlgorithm::CreateDecryptor(uint8[], uint8[])
				IL_00a3: stloc.1
				IL_00a4: ldarg.0
				IL_00a5: ldc.i4.3
				IL_00a6: newobj instance void [mscorlib]System.IO.FileStream::.ctor(string, valuetype [mscorlib]System.IO.FileMode)
				IL_00ab: stloc.2
				IL_00ac: br.s IL_00ae
				.try
				{
					// loop start (head: IL_00ae)
						IL_00ae: ldarg.1
						IL_00af: ldc.i4.1
						IL_00b0: newobj instance void [mscorlib]System.IO.FileStream::.ctor(string, valuetype [mscorlib]System.IO.FileMode)
						IL_00b5: stloc.3
						IL_00b6: br.s IL_00b8
						.try
						{
							IL_00b8: ldloc.3
							IL_00b9: ldloc.1
							IL_00ba: ldc.i4.1
							IL_00bb: newobj instance void [mscorlib]System.Security.Cryptography.CryptoStream::.ctor(class [mscorlib]System.IO.Stream, class [mscorlib]System.Security.Cryptography.ICryptoTransform, valuetype [mscorlib]System.Security.Cryptography.CryptoStreamMode)
							IL_00c0: stloc.s 4
							IL_00c2: br.s IL_00c4
							.try
							{
								IL_00c4: ldloc.2
								IL_00c5: ldloc.s 4
								IL_00c7: callvirt instance void [mscorlib]System.IO.Stream::CopyTo(class [mscorlib]System.IO.Stream)
								IL_00cc: leave.s IL_013a
							} // end .try
							finally
							{
								IL_00ce: ldc.i4 280559618
								IL_00d3: nop
								IL_00d4: stloc 8
								IL_00d8: ldloca 8
								IL_00dc: ldind.i2
								IL_00dd: conv.i2
								IL_00de: conv.i
								IL_00df: stloc.s 7
								IL_00e1: br.s IL_00ed
								// loop start (head: IL_00ed)
									IL_00e3: ldc.i4.0
									IL_00e4: switch (IL_0100)

									IL_00ed: ldloc.s 7
									IL_00ef: switch (IL_0119, IL_0137, IL_00e3)
								// end loop

								IL_0100: ldloc.s 4
								IL_0102: brfalse.s IL_0139

								IL_0104: ldc.i4 1926692864
								IL_0109: stloc 8
								IL_010d: nop
								IL_010e: ldloca 8
								IL_0112: ldind.i2
								IL_0113: conv.i2
								IL_0114: conv.i
								IL_0115: stloc.s 7
								IL_0117: br.s IL_00ed

								IL_0119: br.s IL_011b

								IL_011b: ldloc.s 4
								IL_011d: callvirt instance void [mscorlib]System.IDisposable::Dispose()
								IL_0122: ldc.i4 670564353
								IL_0127: nop
								IL_0128: stloc 8
								IL_012c: ldloca 8
								IL_0130: ldind.i2
								IL_0131: conv.i2
								IL_0132: conv.i
								IL_0133: stloc.s 7
								IL_0135: br.s IL_00ed

								IL_0137: br.s IL_0139

								IL_0139: endfinally
							} // end handler

							IL_013a: leave.s IL_01aa
						} // end .try
						finally
						{
							IL_013c: ldc.i4 1745551362
							IL_0141: stloc 8
							IL_0145: nop
							IL_0146: ldloca 8
							IL_014a: nop
							IL_014b: ldind.i2
							IL_014c: conv.i2
							IL_014d: conv.i
							IL_014e: stloc.s 7
							IL_0150: br.s IL_015c
							// loop start (head: IL_015c)
								IL_0152: ldc.i4.0
								IL_0153: switch (IL_016f)

								IL_015c: ldloc.s 7
								IL_015e: switch (IL_0188, IL_01a7, IL_0152)
							// end loop

							IL_016f: ldloc.3
							IL_0170: brfalse.s IL_01a9

							IL_0172: ldc.i4 181403648
							IL_0177: stloc 8
							IL_017b: nop
							IL_017c: ldloca 8
							IL_0180: nop
							IL_0181: ldind.i2
							IL_0182: conv.i2
							IL_0183: conv.i
							IL_0184: stloc.s 7
							IL_0186: br.s IL_015c

							IL_0188: br.s IL_018a

							IL_018a: ldloc.3
							IL_018b: callvirt instance void [mscorlib]System.IDisposable::Dispose()
							IL_0190: ldc.i4 2030239745
							IL_0195: nop
							IL_0196: stloc 8
							IL_019a: nop
							IL_019b: ldloca 8
							IL_019f: nop
							IL_01a0: ldind.i2
							IL_01a1: conv.i2
							IL_01a2: conv.i
							IL_01a3: stloc.s 7
							IL_01a5: br.s IL_015c

							IL_01a7: br.s IL_01a9

							IL_01a9: endfinally
						} // end handler

						IL_01aa: ldc.i4 1145604568
						IL_01af: stloc 8
						IL_01b3: ldloca 8
						IL_01b7: nop
						IL_01b8: ldind.i2
						IL_01b9: conv.i2
						IL_01ba: ldc.i4 1069517272
						IL_01bf: stloc 8
						IL_01c3: nop
						IL_01c4: ldloca 8
						IL_01c8: nop
						IL_01c9: ldind.i2
						IL_01ca: conv.i2
						IL_01cb: ceq
						IL_01cd: switch (IL_00ae, IL_01df, IL_00ae)
					// end loop
					IL_01de: nop

					IL_01df: ldc.i4 1319043072
					IL_01e4: stloc 8
					IL_01e8: ldloca 8
					IL_01ec: nop
					IL_01ed: ldind.i2
					IL_01ee: conv.i2
					IL_01ef: brfalse IL_01f4

					IL_01f4: leave.s IL_0262
				} // end .try
				finally
				{
					IL_01f6: ldc.i4 1506410498
					IL_01fb: nop
					IL_01fc: stloc 8
					IL_0200: nop
					IL_0201: ldloca 8
					IL_0205: ldind.i2
					IL_0206: conv.i2
					IL_0207: conv.i
					IL_0208: stloc.s 7
					IL_020a: br.s IL_0216
					// loop start (head: IL_0216)
						IL_020c: ldc.i4.0
						IL_020d: switch (IL_0229)

						IL_0216: ldloc.s 7
						IL_0218: switch (IL_0241, IL_025f, IL_020c)
					// end loop

					IL_0229: ldloc.2
					IL_022a: brfalse.s IL_0261

					IL_022c: ldc.i4 477429760
					IL_0231: stloc 8
					IL_0235: ldloca 8
					IL_0239: nop
					IL_023a: ldind.i2
					IL_023b: conv.i2
					IL_023c: conv.i
					IL_023d: stloc.s 7
					IL_023f: br.s IL_0216

					IL_0241: br.s IL_0243

					IL_0243: ldloc.2
					IL_0244: callvirt instance void [mscorlib]System.IDisposable::Dispose()
					IL_0249: ldc.i4 1972436993
					IL_024e: stloc 8
					IL_0252: nop
					IL_0253: ldloca 8
					IL_0257: nop
					IL_0258: ldind.i2
					IL_0259: conv.i2
					IL_025a: conv.i
					IL_025b: stloc.s 7
					IL_025d: br.s IL_0216

					IL_025f: br.s IL_0261

					IL_0261: endfinally
				} // end handler

				IL_0262: leave IL_0386
			} // end .try
			finally
			{
				IL_0267: ldc.i4 1384513538
				IL_026c: stloc 8
				IL_0270: nop
				IL_0271: ldloca 8
				IL_0275: nop
				IL_0276: ldind.i2
				IL_0277: conv.i2
				IL_0278: conv.i
				IL_0279: stloc.s 7
				IL_027b: br.s IL_0287
				// loop start (head: IL_0287)
					IL_027d: ldc.i4.0
					IL_027e: switch (IL_029a)

					IL_0287: ldloc.s 7
					IL_0289: switch (IL_02b2, IL_02d0, IL_027d)
				// end loop

				IL_029a: ldloc.0
				IL_029b: brfalse.s IL_02d2

				IL_029d: ldc.i4 868745216
				IL_02a2: stloc 8
				IL_02a6: ldloca 8
				IL_02aa: nop
				IL_02ab: ldind.i2
				IL_02ac: conv.i2
				IL_02ad: conv.i
				IL_02ae: stloc.s 7
				IL_02b0: br.s IL_0287

				IL_02b2: br.s IL_02b4

				IL_02b4: ldloc.0
				IL_02b5: callvirt instance void [mscorlib]System.IDisposable::Dispose()
				IL_02ba: ldc.i4 1734803457
				IL_02bf: nop
				IL_02c0: stloc 8
				IL_02c4: ldloca 8
				IL_02c8: nop
				IL_02c9: ldind.i2
				IL_02ca: conv.i2
				IL_02cb: conv.i
				IL_02cc: stloc.s 7
				IL_02ce: br.s IL_0287

				IL_02d0: br.s IL_02d2

				IL_02d2: endfinally
			} // end handler

			IL_02d3: ldarg.1
			IL_02d4: call void [mscorlib]System.IO.File::Delete(string)
			IL_02d9: ldc.i4 1794834434
			IL_02de: stloc 8
			IL_02e2: ldloca 8
			IL_02e6: nop
			IL_02e7: ldind.i2
			IL_02e8: conv.i2
			IL_02e9: conv.i
			IL_02ea: stloc.s 7
			IL_02ec: br IL_0047

			IL_02f1: br.s IL_035a

			IL_02f3: ldstr "??????"
			IL_02f8: ldloc 9
			IL_02fc: call string ODCrypt.Sha3::b(string, int32)
			IL_0301: ldarg.0
			IL_0302: ldstr "?????????s???????"
			IL_0307: ldloc 9
			IL_030b: call string ODCrypt.Sha3::b(string, int32)
			IL_0310: call string [mscorlib]System.String::Concat(string, string, string)
			IL_0315: newobj instance void [mscorlib]System.Exception::.ctor(string)
			IL_031a: throw

			IL_031b: ldc.i4 1057882116
			IL_0320: nop
			IL_0321: stloc 8
			IL_0325: nop
			IL_0326: ldloca 8
			IL_032a: nop
			IL_032b: ldind.i2
			IL_032c: conv.i2
			IL_032d: conv.i
			IL_032e: stloc.s 7
			IL_0330: br IL_0047

			IL_0335: ldarg.1
			IL_0336: call bool [mscorlib]System.IO.File::Exists(string)
			IL_033b: brfalse.s IL_035a

			IL_033d: ldc.i4 518717443
			IL_0342: stloc 8
			IL_0346: nop
			IL_0347: ldloca 8
			IL_034b: ldind.i2
			IL_034c: conv.i2
			IL_034d: conv.i
			IL_034e: stloc.s 7
			IL_0350: br IL_0047

			IL_0355: br IL_02d3

			IL_035a: ldarg.2
			IL_035b: ldarg.3
			IL_035c: call void ODCrypt.Encryption::w(string, string)
			IL_0361: newobj instance void [System.Core]System.Security.Cryptography.AesCryptoServiceProvider::.ctor()
			IL_0366: stloc.0
			IL_0367: ldc.i4 2063859713
			IL_036c: nop
			IL_036d: stloc 8
			IL_0371: nop
			IL_0372: ldloca 8
			IL_0376: nop
			IL_0377: ldind.i2
			IL_0378: conv.i2
			IL_0379: conv.i
			IL_037a: stloc.s 7
			IL_037c: br IL_0047

			IL_0381: br IL_008f

			IL_0386: ldc.i4.1
			IL_0387: stloc.s 5
			IL_0389: ldc.i4 65929221
			IL_038e: stloc 8
			IL_0392: ldloca 8
			IL_0396: nop
			IL_0397: ldind.i2
			IL_0398: conv.i2
			IL_0399: conv.i
			IL_039a: stloc.s 7
			IL_039c: br IL_0047

			IL_03a1: leave.s IL_03b4
		} // end .try
		catch [mscorlib]System.Exception
		{
			IL_03a3: stloc.s 6
			IL_03a5: ldarg.s failText
			IL_03a7: ldloc.s 6
			IL_03a9: callvirt instance string [mscorlib]System.Exception::get_Message()
			IL_03ae: stind.ref
			IL_03af: ldc.i4.0
			IL_03b0: stloc.s 5
			IL_03b2: leave.s IL_03b4
		} // end handler

		IL_03b4: ldc.i4 1915355137
		IL_03b9: stloc 8
		IL_03bd: nop
		IL_03be: ldloca 8
		IL_03c2: nop
		IL_03c3: ldind.i2
		IL_03c4: conv.i2
		IL_03c5: br.s IL_03da

		IL_03c7: ldc.i4 1682702336
		IL_03cc: nop
		IL_03cd: stloc 8
		IL_03d1: ldloca 8
		IL_03d5: nop
		IL_03d6: ldind.i2
		IL_03d7: conv.i2
		IL_03d8: br.s IL_03da

		IL_03da: brfalse.s IL_03dc

		IL_03dc: br.s IL_03f1

		IL_03de: ldc.i4 709427200
		IL_03e3: stloc 8
		IL_03e7: nop
		IL_03e8: ldloca 8
		IL_03ec: ldind.i2
		IL_03ed: conv.i2

		IL_03ee: pop
		IL_03ef: br.s IL_0403

		IL_03f1: ldc.i4 494075904
		IL_03f6: stloc 8
		IL_03fa: ldloca 8
		IL_03fe: nop
		IL_03ff: ldind.i2
		IL_0400: conv.i2
		IL_0401: br.s IL_03ee

		IL_0403: nop
		IL_0404: ldloc.s 5
		IL_0406: ret
	} // end of method Encryption::DecryptFile

	.method public hidebysig static 
		bool CompressString (
			string unzipped,
			[out] string& zipped,
			string& failText
		) cil managed 
	{
		// Method begins at RVA 0xb5e4
		// Header size: 12
		// Code size: 833 (0x341)
		.maxstack 2
		.locals init (
			[0] bool,
			[1] class [mscorlib]System.IO.MemoryStream,
			[2] class [mscorlib]System.IO.MemoryStream,
			[3] class [System]System.IO.Compression.GZipStream,
			[4] class [mscorlib]System.Exception,
			[5] int32,
			[6] int16
		)

		IL_0000: ldc.i4 28704769
		IL_0005: stloc 6
		IL_0009: ldloca 6
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: br.s IL_0024

		IL_0012: ldc.i4 1175126016
		IL_0017: stloc 6
		IL_001b: ldloca 6
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: br.s IL_0024

		IL_0024: brfalse.s IL_0026

		IL_0026: ldc.i4 1746796544
		IL_002b: nop
		IL_002c: stloc 6
		IL_0030: ldloca 6
		IL_0034: nop
		IL_0035: ldind.i2
		IL_0036: conv.i2
		IL_0037: stloc.s 5
		IL_0039: ldloc.s 5
		IL_003b: switch (IL_0044)

		IL_0044: br.s IL_005a

		IL_0046: ldc.i4 1674117120
		IL_004b: nop
		IL_004c: stloc 6
		IL_0050: ldloca 6
		IL_0054: nop
		IL_0055: ldind.i2
		IL_0056: conv.i2

		IL_0057: pop
		IL_0058: br.s IL_006d

		IL_005a: ldc.i4 754253824
		IL_005f: nop
		IL_0060: stloc 6
		IL_0064: nop
		IL_0065: ldloca 6
		IL_0069: ldind.i2
		IL_006a: conv.i2
		IL_006b: br.s IL_0057

		IL_006d: nop
		IL_006e: ldarg.1
		IL_006f: ldstr ""
		IL_0074: stind.ref
		IL_0075: br.s IL_0077
		.try
		{
			IL_0077: ldc.i4 1347485696
			IL_007c: nop
			IL_007d: stloc 6
			IL_0081: nop
			IL_0082: ldloca 6
			IL_0086: ldind.i2
			IL_0087: conv.i2
			IL_0088: conv.i
			IL_0089: stloc.s 5
			IL_008b: br.s IL_0097
			// loop start (head: IL_0097)
				IL_008d: ldc.i4.0
				IL_008e: switch (IL_00ba)

				IL_0097: ldloc.s 5
				IL_0099: switch (IL_008d, IL_030e, IL_00eb, IL_0129, IL_0105, IL_032e, IL_00d2)
			// end loop

			IL_00ba: ldarg.0
			IL_00bb: brfalse.s IL_00d4

			IL_00bd: ldc.i4 1020526598
			IL_00c2: stloc 6
			IL_00c6: ldloca 6
			IL_00ca: nop
			IL_00cb: ldind.i2
			IL_00cc: conv.i2
			IL_00cd: conv.i
			IL_00ce: stloc.s 5
			IL_00d0: br.s IL_0097

			IL_00d2: br.s IL_00f0

			IL_00d4: ldc.i4.1
			IL_00d5: stloc.0
			IL_00d6: ldc.i4 189464578
			IL_00db: stloc 6
			IL_00df: nop
			IL_00e0: ldloca 6
			IL_00e4: ldind.i2
			IL_00e5: conv.i2
			IL_00e6: conv.i
			IL_00e7: stloc.s 5
			IL_00e9: br.s IL_0097

			IL_00eb: leave IL_033f

			IL_00f0: ldc.i4 861667332
			IL_00f5: stloc 6
			IL_00f9: nop
			IL_00fa: ldloca 6
			IL_00fe: ldind.i2
			IL_00ff: conv.i2
			IL_0100: conv.i
			IL_0101: stloc.s 5
			IL_0103: br.s IL_0097

			IL_0105: ldarg.0
			IL_0106: callvirt instance int32 [mscorlib]System.String::get_Length()
			IL_010b: ldc.i4.0
			IL_010c: bgt IL_02e5

			IL_0111: ldc.i4 1086128131
			IL_0116: stloc 6
			IL_011a: nop
			IL_011b: ldloca 6
			IL_011f: ldind.i2
			IL_0120: conv.i2
			IL_0121: conv.i
			IL_0122: stloc.s 5
			IL_0124: br IL_0097

			IL_0129: br.s IL_00d4
			.try
			{
				// loop start (head: IL_012b)
					IL_012b: newobj instance void [mscorlib]System.IO.MemoryStream::.ctor()
					IL_0130: stloc.2
					IL_0131: br.s IL_0133
					.try
					{
						IL_0133: ldloc.2
						IL_0134: ldc.i4.1
						IL_0135: newobj instance void [System]System.IO.Compression.GZipStream::.ctor(class [mscorlib]System.IO.Stream, valuetype [System]System.IO.Compression.CompressionMode)
						IL_013a: stloc.3
						IL_013b: br.s IL_013d
						.try
						{
							IL_013d: ldloc.1
							IL_013e: ldloc.3
							IL_013f: call void ODCrypt.Encryption::w(class [mscorlib]System.IO.Stream, class [mscorlib]System.IO.Stream)
							IL_0144: leave.s IL_01b1
						} // end .try
						finally
						{
							IL_0146: ldc.i4 728694786
							IL_014b: stloc 6
							IL_014f: nop
							IL_0150: ldloca 6
							IL_0154: nop
							IL_0155: ldind.i2
							IL_0156: conv.i2
							IL_0157: conv.i
							IL_0158: stloc.s 5
							IL_015a: br.s IL_0166
							// loop start (head: IL_0166)
								IL_015c: ldc.i4.0
								IL_015d: switch (IL_0179)

								IL_0166: ldloc.s 5
								IL_0168: switch (IL_0191, IL_01ae, IL_015c)
							// end loop

							IL_0179: ldloc.3
							IL_017a: brfalse.s IL_01b0

							IL_017c: ldc.i4 437846016
							IL_0181: stloc 6
							IL_0185: ldloca 6
							IL_0189: nop
							IL_018a: ldind.i2
							IL_018b: conv.i2
							IL_018c: conv.i
							IL_018d: stloc.s 5
							IL_018f: br.s IL_0166

							IL_0191: br.s IL_0193

							IL_0193: ldloc.3
							IL_0194: callvirt instance void [mscorlib]System.IDisposable::Dispose()
							IL_0199: ldc.i4 2052456449
							IL_019e: nop
							IL_019f: stloc 6
							IL_01a3: ldloca 6
							IL_01a7: ldind.i2
							IL_01a8: conv.i2
							IL_01a9: conv.i
							IL_01aa: stloc.s 5
							IL_01ac: br.s IL_0166

							IL_01ae: br.s IL_01b0

							IL_01b0: endfinally
						} // end handler

						IL_01b1: ldarg.1
						IL_01b2: ldloc.2
						IL_01b3: callvirt instance uint8[] [mscorlib]System.IO.MemoryStream::ToArray()
						IL_01b8: call string [mscorlib]System.Convert::ToBase64String(uint8[])
						IL_01bd: stind.ref
						IL_01be: leave.s IL_022b
					} // end .try
					finally
					{
						IL_01c0: ldc.i4 200212482
						IL_01c5: stloc 6
						IL_01c9: nop
						IL_01ca: ldloca 6
						IL_01ce: ldind.i2
						IL_01cf: conv.i2
						IL_01d0: conv.i
						IL_01d1: stloc.s 5
						IL_01d3: br.s IL_01df
						// loop start (head: IL_01df)
							IL_01d5: ldc.i4.0
							IL_01d6: switch (IL_01f2)

							IL_01df: ldloc.s 5
							IL_01e1: switch (IL_020a, IL_0228, IL_01d5)
						// end loop

						IL_01f2: ldloc.2
						IL_01f3: brfalse.s IL_022a

						IL_01f5: ldc.i4 115933184
						IL_01fa: stloc 6
						IL_01fe: ldloca 6
						IL_0202: nop
						IL_0203: ldind.i2
						IL_0204: conv.i2
						IL_0205: conv.i
						IL_0206: stloc.s 5
						IL_0208: br.s IL_01df

						IL_020a: br.s IL_020c

						IL_020c: ldloc.2
						IL_020d: callvirt instance void [mscorlib]System.IDisposable::Dispose()
						IL_0212: ldc.i4 1147994113
						IL_0217: nop
						IL_0218: stloc 6
						IL_021c: ldloca 6
						IL_0220: nop
						IL_0221: ldind.i2
						IL_0222: conv.i2
						IL_0223: conv.i
						IL_0224: stloc.s 5
						IL_0226: br.s IL_01df

						IL_0228: br.s IL_022a

						IL_022a: endfinally
					} // end handler

					IL_022b: ldc.i4 263186038
					IL_0230: nop
					IL_0231: stloc 6
					IL_0235: ldloca 6
					IL_0239: ldind.i2
					IL_023a: conv.i2
					IL_023b: ldc.i4 381019766
					IL_0240: stloc 6
					IL_0244: ldloca 6
					IL_0248: nop
					IL_0249: ldind.i2
					IL_024a: conv.i2
					IL_024b: ceq
					IL_024d: switch (IL_012b, IL_025f, IL_012b)
				// end loop
				IL_025e: nop

				IL_025f: ldc.i4 1600454656
				IL_0264: stloc 6
				IL_0268: nop
				IL_0269: ldloca 6
				IL_026d: nop
				IL_026e: ldind.i2
				IL_026f: conv.i2
				IL_0270: brfalse IL_0275

				IL_0275: leave IL_0313
			} // end .try
			finally
			{
				IL_027a: ldc.i4 1801912322
				IL_027f: nop
				IL_0280: stloc 6
				IL_0284: ldloca 6
				IL_0288: nop
				IL_0289: ldind.i2
				IL_028a: conv.i2
				IL_028b: conv.i
				IL_028c: stloc.s 5
				IL_028e: br.s IL_029a
				// loop start (head: IL_029a)
					IL_0290: ldc.i4.0
					IL_0291: switch (IL_02ad)

					IL_029a: ldloc.s 5
					IL_029c: switch (IL_02c5, IL_02e2, IL_0290)
				// end loop

				IL_02ad: ldloc.1
				IL_02ae: brfalse.s IL_02e4

				IL_02b0: ldc.i4 519831552
				IL_02b5: nop
				IL_02b6: stloc 6
				IL_02ba: ldloca 6
				IL_02be: ldind.i2
				IL_02bf: conv.i2
				IL_02c0: conv.i
				IL_02c1: stloc.s 5
				IL_02c3: br.s IL_029a

				IL_02c5: br.s IL_02c7

				IL_02c7: ldloc.1
				IL_02c8: callvirt instance void [mscorlib]System.IDisposable::Dispose()
				IL_02cd: ldc.i4 1731526657
				IL_02d2: stloc 6
				IL_02d6: nop
				IL_02d7: ldloca 6
				IL_02db: ldind.i2
				IL_02dc: conv.i2
				IL_02dd: conv.i
				IL_02de: stloc.s 5
				IL_02e0: br.s IL_029a

				IL_02e2: br.s IL_02e4

				IL_02e4: endfinally
			} // end handler

			IL_02e5: call class [mscorlib]System.Text.Encoding [mscorlib]System.Text.Encoding::get_UTF8()
			IL_02ea: ldarg.0
			IL_02eb: callvirt instance uint8[] [mscorlib]System.Text.Encoding::GetBytes(string)
			IL_02f0: newobj instance void [mscorlib]System.IO.MemoryStream::.ctor(uint8[])
			IL_02f5: stloc.1
			IL_02f6: ldc.i4 490733569
			IL_02fb: stloc 6
			IL_02ff: ldloca 6
			IL_0303: nop
			IL_0304: ldind.i2
			IL_0305: conv.i2
			IL_0306: conv.i
			IL_0307: stloc.s 5
			IL_0309: br IL_0097

			IL_030e: br IL_012b

			IL_0313: ldc.i4.1
			IL_0314: stloc.0
			IL_0315: ldc.i4 1363345413
			IL_031a: stloc 6
			IL_031e: nop
			IL_031f: ldloca 6
			IL_0323: nop
			IL_0324: ldind.i2
			IL_0325: conv.i2
			IL_0326: conv.i
			IL_0327: stloc.s 5
			IL_0329: br IL_0097

			IL_032e: leave.s IL_033f
		} // end .try
		catch [mscorlib]System.Exception
		{
			IL_0330: stloc.s 4
			IL_0332: ldarg.2
			IL_0333: ldloc.s 4
			IL_0335: callvirt instance string [mscorlib]System.Exception::get_Message()
			IL_033a: stind.ref
			IL_033b: ldc.i4.0
			IL_033c: stloc.0
			IL_033d: leave.s IL_033f
		} // end handler

		IL_033f: ldloc.0
		IL_0340: ret
	} // end of method Encryption::CompressString

	.method public hidebysig static 
		bool DecompressString (
			string zipped,
			[out] string& plainText,
			string& failText
		) cil managed 
	{
		// Method begins at RVA 0xb998
		// Header size: 12
		// Code size: 839 (0x347)
		.maxstack 3
		.locals init (
			[0] bool,
			[1] class [mscorlib]System.IO.MemoryStream,
			[2] class [mscorlib]System.IO.MemoryStream,
			[3] class [System]System.IO.Compression.GZipStream,
			[4] class [mscorlib]System.Exception,
			[5] int32,
			[6] int16
		)

		IL_0000: ldc.i4 1626341377
		IL_0005: nop
		IL_0006: stloc 6
		IL_000a: ldloca 6
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: br.s IL_0026

		IL_0012: ldc.i4 1766129664
		IL_0017: nop
		IL_0018: stloc 6
		IL_001c: nop
		IL_001d: ldloca 6
		IL_0021: nop
		IL_0022: ldind.i2
		IL_0023: conv.i2
		IL_0024: br.s IL_0026

		IL_0026: brfalse.s IL_0028

		IL_0028: ldc.i4 934084608
		IL_002d: nop
		IL_002e: stloc 6
		IL_0032: nop
		IL_0033: ldloca 6
		IL_0037: nop
		IL_0038: ldind.i2
		IL_0039: conv.i2
		IL_003a: stloc.s 5
		IL_003c: ldloc.s 5
		IL_003e: switch (IL_0047)

		IL_0047: br.s IL_005c

		IL_0049: ldc.i4 287834112
		IL_004e: stloc 6
		IL_0052: nop
		IL_0053: ldloca 6
		IL_0057: ldind.i2
		IL_0058: conv.i2

		IL_0059: pop
		IL_005a: br.s IL_006f

		IL_005c: ldc.i4 1122304000
		IL_0061: stloc 6
		IL_0065: nop
		IL_0066: ldloca 6
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: br.s IL_0059

		IL_006f: nop
		IL_0070: ldarg.1
		IL_0071: ldstr ""
		IL_0076: stind.ref
		IL_0077: br.s IL_0079
		.try
		{
			IL_0079: ldc.i4 1743585280
			IL_007e: nop
			IL_007f: stloc 6
			IL_0083: nop
			IL_0084: ldloca 6
			IL_0088: nop
			IL_0089: ldind.i2
			IL_008a: conv.i2
			IL_008b: conv.i
			IL_008c: stloc.s 5
			IL_008e: br.s IL_009a
			// loop start (head: IL_009a)
				IL_0090: ldc.i4.0
				IL_0091: switch (IL_00bd)

				IL_009a: ldloc.s 5
				IL_009c: switch (IL_0090, IL_0314, IL_00ee, IL_012e, IL_0108, IL_0334, IL_00d5)
			// end loop

			IL_00bd: ldarg.0
			IL_00be: brfalse.s IL_00d7

			IL_00c0: ldc.i4 935657478
			IL_00c5: stloc 6
			IL_00c9: nop
			IL_00ca: ldloca 6
			IL_00ce: ldind.i2
			IL_00cf: conv.i2
			IL_00d0: conv.i
			IL_00d1: stloc.s 5
			IL_00d3: br.s IL_009a

			IL_00d5: br.s IL_00f3

			IL_00d7: ldc.i4.1
			IL_00d8: stloc.0
			IL_00d9: ldc.i4 552534018
			IL_00de: stloc 6
			IL_00e2: ldloca 6
			IL_00e6: nop
			IL_00e7: ldind.i2
			IL_00e8: conv.i2
			IL_00e9: conv.i
			IL_00ea: stloc.s 5
			IL_00ec: br.s IL_009a

			IL_00ee: leave IL_0345

			IL_00f3: ldc.i4 973340676
			IL_00f8: stloc 6
			IL_00fc: ldloca 6
			IL_0100: nop
			IL_0101: ldind.i2
			IL_0102: conv.i2
			IL_0103: conv.i
			IL_0104: stloc.s 5
			IL_0106: br.s IL_009a

			IL_0108: ldarg.0
			IL_0109: callvirt instance int32 [mscorlib]System.String::get_Length()
			IL_010e: ldc.i4.0
			IL_010f: bgt IL_02ef

			IL_0114: ldc.i4 1320550403
			IL_0119: nop
			IL_011a: stloc 6
			IL_011e: nop
			IL_011f: ldloca 6
			IL_0123: nop
			IL_0124: ldind.i2
			IL_0125: conv.i2
			IL_0126: conv.i
			IL_0127: stloc.s 5
			IL_0129: br IL_009a

			IL_012e: br.s IL_00d7
			.try
			{
				// loop start (head: IL_0130)
					IL_0130: newobj instance void [mscorlib]System.IO.MemoryStream::.ctor()
					IL_0135: stloc.2
					IL_0136: br.s IL_0138
					.try
					{
						IL_0138: ldloc.1
						IL_0139: ldc.i4.0
						IL_013a: newobj instance void [System]System.IO.Compression.GZipStream::.ctor(class [mscorlib]System.IO.Stream, valuetype [System]System.IO.Compression.CompressionMode)
						IL_013f: stloc.3
						IL_0140: br.s IL_0142
						.try
						{
							IL_0142: ldloc.3
							IL_0143: ldloc.2
							IL_0144: call void ODCrypt.Encryption::w(class [mscorlib]System.IO.Stream, class [mscorlib]System.IO.Stream)
							IL_0149: leave.s IL_01b6
						} // end .try
						finally
						{
							IL_014b: ldc.i4 629473282
							IL_0150: stloc 6
							IL_0154: ldloca 6
							IL_0158: nop
							IL_0159: ldind.i2
							IL_015a: conv.i2
							IL_015b: conv.i
							IL_015c: stloc.s 5
							IL_015e: br.s IL_016a
							// loop start (head: IL_016a)
								IL_0160: ldc.i4.0
								IL_0161: switch (IL_017d)

								IL_016a: ldloc.s 5
								IL_016c: switch (IL_0195, IL_01b3, IL_0160)
							// end loop

							IL_017d: ldloc.3
							IL_017e: brfalse.s IL_01b5

							IL_0180: ldc.i4 1317666816
							IL_0185: stloc 6
							IL_0189: nop
							IL_018a: ldloca 6
							IL_018e: ldind.i2
							IL_018f: conv.i2
							IL_0190: conv.i
							IL_0191: stloc.s 5
							IL_0193: br.s IL_016a

							IL_0195: br.s IL_0197

							IL_0197: ldloc.3
							IL_0198: callvirt instance void [mscorlib]System.IDisposable::Dispose()
							IL_019d: ldc.i4 585629697
							IL_01a2: nop
							IL_01a3: stloc 6
							IL_01a7: nop
							IL_01a8: ldloca 6
							IL_01ac: ldind.i2
							IL_01ad: conv.i2
							IL_01ae: conv.i
							IL_01af: stloc.s 5
							IL_01b1: br.s IL_016a

							IL_01b3: br.s IL_01b5

							IL_01b5: endfinally
						} // end handler

						IL_01b6: ldarg.1
						IL_01b7: call class [mscorlib]System.Text.Encoding [mscorlib]System.Text.Encoding::get_UTF8()
						IL_01bc: ldloc.2
						IL_01bd: callvirt instance uint8[] [mscorlib]System.IO.MemoryStream::ToArray()
						IL_01c2: callvirt instance string [mscorlib]System.Text.Encoding::GetString(uint8[])
						IL_01c7: stind.ref
						IL_01c8: leave.s IL_0234
					} // end .try
					finally
					{
						IL_01ca: ldc.i4 439484418
						IL_01cf: nop
						IL_01d0: stloc 6
						IL_01d4: ldloca 6
						IL_01d8: ldind.i2
						IL_01d9: conv.i2
						IL_01da: conv.i
						IL_01db: stloc.s 5
						IL_01dd: br.s IL_01e9
						// loop start (head: IL_01e9)
							IL_01df: ldc.i4.0
							IL_01e0: switch (IL_01fc)

							IL_01e9: ldloc.s 5
							IL_01eb: switch (IL_0214, IL_0231, IL_01df)
						// end loop

						IL_01fc: ldloc.2
						IL_01fd: brfalse.s IL_0233

						IL_01ff: ldc.i4 1173618688
						IL_0204: stloc 6
						IL_0208: nop
						IL_0209: ldloca 6
						IL_020d: ldind.i2
						IL_020e: conv.i2
						IL_020f: conv.i
						IL_0210: stloc.s 5
						IL_0212: br.s IL_01e9

						IL_0214: br.s IL_0216

						IL_0216: ldloc.2
						IL_0217: callvirt instance void [mscorlib]System.IDisposable::Dispose()
						IL_021c: ldc.i4 221642753
						IL_0221: stloc 6
						IL_0225: nop
						IL_0226: ldloca 6
						IL_022a: ldind.i2
						IL_022b: conv.i2
						IL_022c: conv.i
						IL_022d: stloc.s 5
						IL_022f: br.s IL_01e9

						IL_0231: br.s IL_0233

						IL_0233: endfinally
					} // end handler

					IL_0234: ldc.i4 220533068
					IL_0239: nop
					IL_023a: stloc 6
					IL_023e: ldloca 6
					IL_0242: ldind.i2
					IL_0243: conv.i2
					IL_0244: ldc.i4 2016285004
					IL_0249: nop
					IL_024a: stloc 6
					IL_024e: nop
					IL_024f: ldloca 6
					IL_0253: ldind.i2
					IL_0254: conv.i2
					IL_0255: ceq
					IL_0257: switch (IL_0130, IL_0269, IL_0130)
				// end loop
				IL_0268: nop

				IL_0269: ldc.i4 131334144
				IL_026e: stloc 6
				IL_0272: nop
				IL_0273: ldloca 6
				IL_0277: ldind.i2
				IL_0278: conv.i2
				IL_0279: brfalse IL_027e

				IL_027e: leave IL_0319
			} // end .try
			finally
			{
				IL_0283: ldc.i4 1817903106
				IL_0288: nop
				IL_0289: stloc 6
				IL_028d: nop
				IL_028e: ldloca 6
				IL_0292: nop
				IL_0293: ldind.i2
				IL_0294: conv.i2
				IL_0295: conv.i
				IL_0296: stloc.s 5
				IL_0298: br.s IL_02a4
				// loop start (head: IL_02a4)
					IL_029a: ldc.i4.0
					IL_029b: switch (IL_02b7)

					IL_02a4: ldloc.s 5
					IL_02a6: switch (IL_02cf, IL_02ec, IL_029a)
				// end loop

				IL_02b7: ldloc.1
				IL_02b8: brfalse.s IL_02ee

				IL_02ba: ldc.i4 1583611904
				IL_02bf: stloc 6
				IL_02c3: nop
				IL_02c4: ldloca 6
				IL_02c8: ldind.i2
				IL_02c9: conv.i2
				IL_02ca: conv.i
				IL_02cb: stloc.s 5
				IL_02cd: br.s IL_02a4

				IL_02cf: br.s IL_02d1

				IL_02d1: ldloc.1
				IL_02d2: callvirt instance void [mscorlib]System.IDisposable::Dispose()
				IL_02d7: ldc.i4 911867905
				IL_02dc: stloc 6
				IL_02e0: nop
				IL_02e1: ldloca 6
				IL_02e5: ldind.i2
				IL_02e6: conv.i2
				IL_02e7: conv.i
				IL_02e8: stloc.s 5
				IL_02ea: br.s IL_02a4

				IL_02ec: br.s IL_02ee

				IL_02ee: endfinally
			} // end handler

			IL_02ef: ldarg.0
			IL_02f0: call uint8[] [mscorlib]System.Convert::FromBase64String(string)
			IL_02f5: newobj instance void [mscorlib]System.IO.MemoryStream::.ctor(uint8[])
			IL_02fa: stloc.1
			IL_02fb: ldc.i4 941817857
			IL_0300: nop
			IL_0301: stloc 6
			IL_0305: nop
			IL_0306: ldloca 6
			IL_030a: ldind.i2
			IL_030b: conv.i2
			IL_030c: conv.i
			IL_030d: stloc.s 5
			IL_030f: br IL_009a

			IL_0314: br IL_0130

			IL_0319: ldc.i4.1
			IL_031a: stloc.0
			IL_031b: ldc.i4 857407493
			IL_0320: nop
			IL_0321: stloc 6
			IL_0325: ldloca 6
			IL_0329: nop
			IL_032a: ldind.i2
			IL_032b: conv.i2
			IL_032c: conv.i
			IL_032d: stloc.s 5
			IL_032f: br IL_009a

			IL_0334: leave.s IL_0345
		} // end .try
		catch [mscorlib]System.Exception
		{
			IL_0336: stloc.s 4
			IL_0338: ldarg.2
			IL_0339: ldloc.s 4
			IL_033b: callvirt instance string [mscorlib]System.Exception::get_Message()
			IL_0340: stind.ref
			IL_0341: ldc.i4.0
			IL_0342: stloc.0
			IL_0343: leave.s IL_0345
		} // end handler

		IL_0345: ldloc.0
		IL_0346: ret
	} // end of method Encryption::DecompressString

	.method private hidebysig static 
		void w (
			string A_0,
			string A_1
		) cil managed 
	{
		// Method begins at RVA 0xbd50
		// Header size: 12
		// Code size: 485 (0x1e5)
		.maxstack 2
		.locals init (
			[0] int32,
			[1] int16,
			[2] int32
		)

		IL_0000: ldc.i4 14
		IL_0005: stloc 2
		IL_0009: ldc.i4 507052033
		IL_000e: nop
		IL_000f: stloc 1
		IL_0013: nop
		IL_0014: ldloca 1
		IL_0018: nop
		IL_0019: ldind.i2
		IL_001a: conv.i2
		IL_001b: conv.i
		IL_001c: stloc.0
		IL_001d: br.s IL_0029
		// loop start (head: IL_0029)
			IL_001f: ldc.i4.0
			IL_0020: switch (IL_004f)

			IL_0029: ldloc.0
			IL_002a: switch (IL_00a6, IL_001f, IL_0170, IL_0193, IL_0154, IL_00c3, IL_006b, IL_0085)
		// end loop

		IL_004f: ldarg.0
		IL_0050: brfalse IL_01a9

		IL_0055: ldc.i4 2108424198
		IL_005a: nop
		IL_005b: stloc 1
		IL_005f: nop
		IL_0060: ldloca 1
		IL_0064: nop
		IL_0065: ldind.i2
		IL_0066: conv.i2
		IL_0067: conv.i
		IL_0068: stloc.0
		IL_0069: br.s IL_0029

		IL_006b: br IL_0159

		IL_0070: ldc.i4 2036531207
		IL_0075: stloc 1
		IL_0079: nop
		IL_007a: ldloca 1
		IL_007e: nop
		IL_007f: ldind.i2
		IL_0080: conv.i2
		IL_0081: conv.i
		IL_0082: stloc.0
		IL_0083: br.s IL_0029

		IL_0085: ldarg.1
		IL_0086: callvirt instance int32 [mscorlib]System.String::get_Length()
		IL_008b: ldc.i4.0
		IL_008c: bgt IL_01bd

		IL_0091: ldc.i4 1248526336
		IL_0096: nop
		IL_0097: stloc 1
		IL_009b: nop
		IL_009c: ldloca 1
		IL_00a0: ldind.i2
		IL_00a1: conv.i2
		IL_00a2: conv.i
		IL_00a3: stloc.0
		IL_00a4: br.s IL_0029

		IL_00a6: br IL_0195

		IL_00ab: ldc.i4 1082261509
		IL_00b0: nop
		IL_00b1: stloc 1
		IL_00b5: ldloca 1
		IL_00b9: nop
		IL_00ba: ldind.i2
		IL_00bb: conv.i2
		IL_00bc: conv.i
		IL_00bd: stloc.0
		IL_00be: br IL_0029

		IL_00c3: ldarg.1
		IL_00c4: brfalse IL_0195

		IL_00c9: br.s IL_00de

		IL_00cb: ldc.i4 1332543488
		IL_00d0: stloc 1
		IL_00d4: ldloca 1
		IL_00d8: nop
		IL_00d9: ldind.i2
		IL_00da: conv.i2

		IL_00db: pop
		IL_00dc: br.s IL_00f0

		IL_00de: ldc.i4 786497536
		IL_00e3: stloc 1
		IL_00e7: ldloca 1
		IL_00eb: nop
		IL_00ec: ldind.i2
		IL_00ed: conv.i2
		IL_00ee: br.s IL_00db

		IL_00f0: nop
		IL_00f1: ldc.i4 190094891
		IL_00f6: nop
		IL_00f7: stloc 1
		IL_00fb: nop
		IL_00fc: ldloca 1
		IL_0100: nop
		IL_0101: ldind.i2
		IL_0102: conv.i2
		IL_0103: ldc.i4 897752619
		IL_0108: stloc 1
		IL_010c: ldloca 1
		IL_0110: nop
		IL_0111: ldind.i2
		IL_0112: conv.i2
		IL_0113: ceq
		IL_0115: switch (IL_017c, IL_0127, IL_017c)

		IL_0126: nop

		IL_0127: ldc.i4 1676804096
		IL_012c: stloc 1
		IL_0130: nop
		IL_0131: ldloca 1
		IL_0135: nop
		IL_0136: ldind.i2
		IL_0137: conv.i2
		IL_0138: brfalse IL_013d

		IL_013d: ldc.i4 1199833092
		IL_0142: stloc 1
		IL_0146: ldloca 1
		IL_014a: nop
		IL_014b: ldind.i2
		IL_014c: conv.i2
		IL_014d: conv.i
		IL_014e: stloc.0
		IL_014f: br IL_0029

		IL_0154: br IL_0070

		IL_0159: ldc.i4 347078658
		IL_015e: stloc 1
		IL_0162: ldloca 1
		IL_0166: nop
		IL_0167: ldind.i2
		IL_0168: conv.i2
		IL_0169: conv.i
		IL_016a: stloc.0
		IL_016b: br IL_0029

		IL_0170: ldarg.0
		IL_0171: callvirt instance int32 [mscorlib]System.String::get_Length()
		IL_0176: ldc.i4.0
		IL_0177: bgt IL_00ab

		IL_017c: ldc.i4 1086521347
		IL_0181: nop
		IL_0182: stloc 1
		IL_0186: ldloca 1
		IL_018a: ldind.i2
		IL_018b: conv.i2
		IL_018c: conv.i
		IL_018d: stloc.0
		IL_018e: br IL_0029

		IL_0193: br.s IL_01a9

		IL_0195: ldstr "??t???????"
		IL_019a: ldloc 2
		IL_019e: call string ODCrypt.Sha3::b(string, int32)
		IL_01a3: newobj instance void [mscorlib]System.ArgumentNullException::.ctor(string)
		IL_01a8: throw

		IL_01a9: ldstr "???"
		IL_01ae: ldloc 2
		IL_01b2: call string ODCrypt.Sha3::b(string, int32)
		IL_01b7: newobj instance void [mscorlib]System.ArgumentNullException::.ctor(string)
		IL_01bc: throw

		IL_01bd: ldc.i4 935198721
		IL_01c2: nop
		IL_01c3: stloc 1
		IL_01c7: ldloca 1
		IL_01cb: nop
		IL_01cc: ldind.i2
		IL_01cd: conv.i2
		IL_01ce: br.s IL_01e2

		IL_01d0: ldc.i4 541392896
		IL_01d5: stloc 1
		IL_01d9: nop
		IL_01da: ldloca 1
		IL_01de: ldind.i2
		IL_01df: conv.i2
		IL_01e0: br.s IL_01e2

		IL_01e2: brfalse.s IL_01e4

		IL_01e4: ret
	} // end of method Encryption::w

	.method private hidebysig static 
		void w (
			class [mscorlib]System.IO.Stream A_0,
			class [mscorlib]System.IO.Stream A_1
		) cil managed 
	{
		// Method begins at RVA 0xbf44
		// Header size: 12
		// Code size: 324 (0x144)
		.maxstack 4
		.locals init (
			[0] uint8[],
			[1] int32,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0020)

		IL_000a: ldloc.2
		IL_000b: switch (IL_00a5, IL_0114, IL_0068, IL_007e)

		IL_0020: ldc.i4 979894273
		IL_0025: nop
		IL_0026: stloc 3
		IL_002a: ldloca 3
		IL_002e: ldind.i2
		IL_002f: conv.i2
		IL_0030: br.s IL_0046

		IL_0032: ldc.i4 1346043904
		IL_0037: nop
		IL_0038: stloc 3
		IL_003c: nop
		IL_003d: ldloca 3
		IL_0041: nop
		IL_0042: ldind.i2
		IL_0043: conv.i2
		IL_0044: br.s IL_0046

		IL_0046: brfalse.s IL_0048

		IL_0048: ldc.i4 4096
		IL_004d: newarr [mscorlib]System.Byte
		IL_0052: stloc.0
		IL_0053: ldc.i4 12910594
		IL_0058: nop
		IL_0059: stloc 3
		IL_005d: nop
		IL_005e: ldloca 3
		IL_0062: ldind.i2
		IL_0063: conv.i2
		IL_0064: conv.i
		IL_0065: stloc.2
		IL_0066: br.s IL_000a

		IL_0068: br.s IL_006a

		IL_006a: ldc.i4 2128478211
		IL_006f: nop
		IL_0070: stloc 3
		IL_0074: ldloca 3
		IL_0078: ldind.i2
		IL_0079: conv.i2
		IL_007a: conv.i
		IL_007b: stloc.2
		IL_007c: br.s IL_000a

		IL_007e: ldarg.0
		IL_007f: ldloc.0
		IL_0080: ldc.i4.0
		IL_0081: ldloc.0
		IL_0082: ldlen
		IL_0083: conv.i4
		IL_0084: callvirt instance int32 [mscorlib]System.IO.Stream::Read(uint8[], int32, int32)
		IL_0089: dup
		IL_008a: stloc.1
		IL_008b: brtrue.s IL_00aa

		IL_008d: ldc.i4 783155200
		IL_0092: stloc 3
		IL_0096: nop
		IL_0097: ldloca 3
		IL_009b: nop
		IL_009c: ldind.i2
		IL_009d: conv.i2
		IL_009e: conv.i
		IL_009f: stloc.2
		IL_00a0: br IL_000a

		IL_00a5: br IL_0143
		// loop start (head: IL_00aa)
			IL_00aa: ldarg.1
			IL_00ab: ldloc.0
			IL_00ac: ldc.i4.0
			IL_00ad: ldloc.1
			IL_00ae: callvirt instance void [mscorlib]System.IO.Stream::Write(uint8[], int32, int32)
			IL_00b3: ldc.i4 1436305594
			IL_00b8: stloc 3
			IL_00bc: ldloca 3
			IL_00c0: nop
			IL_00c1: ldind.i2
			IL_00c2: conv.i2
			IL_00c3: ldc.i4 1324042426
			IL_00c8: stloc 3
			IL_00cc: ldloca 3
			IL_00d0: nop
			IL_00d1: ldind.i2
			IL_00d2: conv.i2
			IL_00d3: ceq
			IL_00d5: switch (IL_00aa, IL_00e7, IL_00aa)
		// end loop

		IL_00e6: nop

		IL_00e7: ldc.i4 1391656960
		IL_00ec: nop
		IL_00ed: stloc 3
		IL_00f1: ldloca 3
		IL_00f5: nop
		IL_00f6: ldind.i2
		IL_00f7: conv.i2
		IL_00f8: brfalse IL_00fd

		IL_00fd: ldc.i4 291438593
		IL_0102: stloc 3
		IL_0106: ldloca 3
		IL_010a: nop
		IL_010b: ldind.i2
		IL_010c: conv.i2
		IL_010d: conv.i
		IL_010e: stloc.2
		IL_010f: br IL_000a

		IL_0114: br.s IL_012a

		IL_0116: ldc.i4 1666449408
		IL_011b: nop
		IL_011c: stloc 3
		IL_0120: nop
		IL_0121: ldloca 3
		IL_0125: ldind.i2
		IL_0126: conv.i2

		IL_0127: pop
		IL_0128: br.s IL_013d

		IL_012a: ldc.i4 1198522368
		IL_012f: nop
		IL_0130: stloc 3
		IL_0134: ldloca 3
		IL_0138: nop
		IL_0139: ldind.i2
		IL_013a: conv.i2
		IL_013b: br.s IL_0127

		IL_013d: nop
		IL_013e: br IL_006a

		IL_0143: ret
	} // end of method Encryption::w

	.method public hidebysig static 
		string BytesToString (
			uint8[] asBytes,
			bool outputAsHex
		) cil managed 
	{
		// Method begins at RVA 0xc094
		// Header size: 12
		// Code size: 608 (0x260)
		.maxstack 3
		.locals init (
			[0] class [mscorlib]System.Text.StringBuilder,
			[1] uint8[],
			[2] int32,
			[3] uint8,
			[4] int32,
			[5] int16,
			[6] int32
		)

		IL_0000: ldc.i4 5
		IL_0005: stloc 6
		IL_0009: ldc.i4 536281088
		IL_000e: stloc 5
		IL_0012: nop
		IL_0013: ldloca 5
		IL_0017: nop
		IL_0018: ldind.i2
		IL_0019: conv.i2
		IL_001a: stloc.s 4
		IL_001c: ldloc.s 4
		IL_001e: switch (IL_0027)

		IL_0027: ldc.i4 1743388675
		IL_002c: stloc 5
		IL_0030: ldloca 5
		IL_0034: nop
		IL_0035: ldind.i2
		IL_0036: conv.i2
		IL_0037: conv.i
		IL_0038: stloc.s 4
		IL_003a: br.s IL_0046
		// loop start (head: IL_0046)
			IL_003c: ldc.i4.0
			IL_003d: switch (IL_0075)

			IL_0046: ldloc.s 4
			IL_0048: switch (IL_01ed, IL_016a, IL_0104, IL_003c, IL_0236, IL_0188, IL_01c3, IL_01a6, IL_0254, IL_012b)
		// end loop

		IL_0075: ldarg.0
		IL_0076: brfalse IL_014c

		IL_007b: ldc.i4 469007548
		IL_0080: stloc 5
		IL_0084: nop
		IL_0085: ldloca 5
		IL_0089: nop
		IL_008a: ldind.i2
		IL_008b: conv.i2
		IL_008c: ldc.i4 1512799420
		IL_0091: stloc 5
		IL_0095: nop
		IL_0096: ldloca 5
		IL_009a: ldind.i2
		IL_009b: conv.i2
		IL_009c: ceq
		IL_009e: switch (IL_0170, IL_00b0, IL_0170)

		IL_00af: nop

		IL_00b0: ldc.i4 708575233
		IL_00b5: stloc 5
		IL_00b9: ldloca 5
		IL_00bd: nop
		IL_00be: ldind.i2
		IL_00bf: conv.i2
		IL_00c0: br.s IL_00d5

		IL_00c2: ldc.i4 288096256
		IL_00c7: nop
		IL_00c8: stloc 5
		IL_00cc: ldloca 5
		IL_00d0: nop
		IL_00d1: ldind.i2
		IL_00d2: conv.i2
		IL_00d3: br.s IL_00d5

		IL_00d5: brfalse.s IL_00d7

		IL_00d7: ldc.i4 1411776512
		IL_00dc: stloc 5
		IL_00e0: ldloca 5
		IL_00e4: nop
		IL_00e5: ldind.i2
		IL_00e6: conv.i2
		IL_00e7: brfalse IL_00ec

		IL_00ec: ldc.i4 1587478530
		IL_00f1: stloc 5
		IL_00f5: nop
		IL_00f6: ldloca 5
		IL_00fa: ldind.i2
		IL_00fb: conv.i2
		IL_00fc: conv.i
		IL_00fd: stloc.s 4
		IL_00ff: br IL_0046

		IL_0104: br IL_018d

		IL_0109: newobj instance void [mscorlib]System.Text.StringBuilder::.ctor()
		IL_010e: stloc.0
		IL_010f: ldarg.0
		IL_0110: stloc.1
		IL_0111: ldc.i4.0
		IL_0112: stloc.2
		IL_0113: ldc.i4 233963529
		IL_0118: stloc 5
		IL_011c: nop
		IL_011d: ldloca 5
		IL_0121: ldind.i2
		IL_0122: conv.i2
		IL_0123: conv.i
		IL_0124: stloc.s 4
		IL_0126: br IL_0046

		IL_012b: br.s IL_0152

		IL_012d: ldarg.0
		IL_012e: call string [mscorlib]System.BitConverter::ToString(uint8[])
		IL_0133: ldstr "?"
		IL_0138: ldloc 6
		IL_013c: call string ODCrypt.Sha3::b(string, int32)
		IL_0141: ldstr ""
		IL_0146: callvirt instance string [mscorlib]System.String::Replace(string, string)
		IL_014b: ret

		IL_014c: ldstr ""
		IL_0151: ret

		IL_0152: ldc.i4 184811521
		IL_0157: stloc 5
		IL_015b: ldloca 5
		IL_015f: nop
		IL_0160: ldind.i2
		IL_0161: conv.i2
		IL_0162: conv.i
		IL_0163: stloc.s 4
		IL_0165: br IL_0046

		IL_016a: ldloc.2
		IL_016b: ldloc.1
		IL_016c: ldlen
		IL_016d: conv.i4
		IL_016e: blt.s IL_01c5

		IL_0170: ldc.i4 1024983045
		IL_0175: stloc 5
		IL_0179: nop
		IL_017a: ldloca 5
		IL_017e: ldind.i2
		IL_017f: conv.i2
		IL_0180: conv.i
		IL_0181: stloc.s 4
		IL_0183: br IL_0046

		IL_0188: br IL_0259

		IL_018d: ldc.i4 1538129927
		IL_0192: stloc 5
		IL_0196: nop
		IL_0197: ldloca 5
		IL_019b: nop
		IL_019c: ldind.i2
		IL_019d: conv.i2
		IL_019e: conv.i
		IL_019f: stloc.s 4
		IL_01a1: br IL_0046

		IL_01a6: ldarg.0
		IL_01a7: ldlen
		IL_01a8: brtrue.s IL_021e

		IL_01aa: ldc.i4 9764870
		IL_01af: nop
		IL_01b0: stloc 5
		IL_01b4: ldloca 5
		IL_01b8: nop
		IL_01b9: ldind.i2
		IL_01ba: conv.i2
		IL_01bb: conv.i
		IL_01bc: stloc.s 4
		IL_01be: br IL_0046

		IL_01c3: br.s IL_014c

		IL_01c5: ldloc.1
		IL_01c6: ldloc.2
		IL_01c7: ldelem.u1
		IL_01c8: stloc.3
		IL_01c9: ldloc.0
		IL_01ca: ldloc.3
		IL_01cb: callvirt instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(char)
		IL_01d0: pop
		IL_01d1: ldloc.2
		IL_01d2: ldc.i4.1
		IL_01d3: add
		IL_01d4: stloc.2
		IL_01d5: ldc.i4 961609728
		IL_01da: stloc 5
		IL_01de: ldloca 5
		IL_01e2: nop
		IL_01e3: ldind.i2
		IL_01e4: conv.i2
		IL_01e5: conv.i
		IL_01e6: stloc.s 4
		IL_01e8: br IL_0046

		IL_01ed: br.s IL_0204

		IL_01ef: ldc.i4 437059584
		IL_01f4: nop
		IL_01f5: stloc 5
		IL_01f9: nop
		IL_01fa: ldloca 5
		IL_01fe: nop
		IL_01ff: ldind.i2
		IL_0200: conv.i2

		IL_0201: pop
		IL_0202: br.s IL_0218

		IL_0204: ldc.i4 1908408320
		IL_0209: nop
		IL_020a: stloc 5
		IL_020e: nop
		IL_020f: ldloca 5
		IL_0213: nop
		IL_0214: ldind.i2
		IL_0215: conv.i2
		IL_0216: br.s IL_0201

		IL_0218: nop
		IL_0219: br IL_0152

		IL_021e: ldc.i4 170196996
		IL_0223: stloc 5
		IL_0227: ldloca 5
		IL_022b: nop
		IL_022c: ldind.i2
		IL_022d: conv.i2
		IL_022e: conv.i
		IL_022f: stloc.s 4
		IL_0231: br IL_0046

		IL_0236: ldarg.1
		IL_0237: brfalse IL_0109

		IL_023c: ldc.i4 1093926920
		IL_0241: nop
		IL_0242: stloc 5
		IL_0246: ldloca 5
		IL_024a: ldind.i2
		IL_024b: conv.i2
		IL_024c: conv.i
		IL_024d: stloc.s 4
		IL_024f: br IL_0046

		IL_0254: br IL_012d

		IL_0259: ldloc.0
		IL_025a: callvirt instance string [mscorlib]System.Object::ToString()
		IL_025f: ret
	} // end of method Encryption::BytesToString

	.method public hidebysig static 
		uint8[] StringToBytes (
			string asString,
			bool inputIs7BitAscii
		) cil managed 
	{
		// Method begins at RVA 0xc300
		// Header size: 12
		// Code size: 970 (0x3ca)
		.maxstack 6
		.locals init (
			[0] uint8[],
			[1] int32,
			[2] class [mscorlib]System.IO.StringReader,
			[3] int32,
			[4] char[],
			[5] int32,
			[6] int32,
			[7] int16
		)

		IL_0000: ldc.i4 261685248
		IL_0005: stloc 7
		IL_0009: nop
		IL_000a: ldloca 7
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: stloc.s 6
		IL_0012: ldloc.s 6
		IL_0014: switch (IL_001d)

		IL_001d: ldc.i4 1465647108
		IL_0022: stloc 7
		IL_0026: ldloca 7
		IL_002a: nop
		IL_002b: ldind.i2
		IL_002c: conv.i2
		IL_002d: conv.i
		IL_002e: stloc.s 6
		IL_0030: br.s IL_003c
		// loop start (head: IL_003c)
			IL_0032: ldc.i4.0
			IL_0033: switch (IL_006f)

			IL_003c: ldloc.s 6
			IL_003e: switch (IL_02e7, IL_008b, IL_035f, IL_03a5, IL_0032, IL_0280, IL_02c3, IL_0329, IL_0304, IL_03c3, IL_00ba)
		// end loop

		IL_006f: ldarg.0
		IL_0070: brfalse IL_0250

		IL_0075: ldc.i4 1707999233
		IL_007a: stloc 7
		IL_007e: nop
		IL_007f: ldloca 7
		IL_0083: nop
		IL_0084: ldind.i2
		IL_0085: conv.i2
		IL_0086: conv.i
		IL_0087: stloc.s 6
		IL_0089: br.s IL_003c

		IL_008b: br IL_02ab

		IL_0090: ldarg.0
		IL_0091: callvirt instance char[] [mscorlib]System.String::ToCharArray()
		IL_0096: stloc.s 4
		IL_0098: ldloc.s 4
		IL_009a: ldlen
		IL_009b: conv.i4
		IL_009c: newarr [mscorlib]System.Byte
		IL_00a1: stloc.0
		IL_00a2: ldc.i4.0
		IL_00a3: stloc.s 5
		IL_00a5: ldc.i4 811991050
		IL_00aa: stloc 7
		IL_00ae: ldloca 7
		IL_00b2: nop
		IL_00b3: ldind.i2
		IL_00b4: conv.i2
		IL_00b5: conv.i
		IL_00b6: stloc.s 6
		IL_00b8: br.s IL_003c

		IL_00ba: br IL_02ec
		.try
		{
			IL_00bf: ldc.i4.0
			IL_00c0: switch (IL_00e4)

			IL_00c9: ldloc.s 6
			IL_00cb: switch (IL_0147, IL_01c5, IL_017e, IL_01e0, IL_0161)

			IL_00e4: ldc.i4 1811713840
			IL_00e9: nop
			IL_00ea: stloc 7
			IL_00ee: nop
			IL_00ef: ldloca 7
			IL_00f3: nop
			IL_00f4: ldind.i2
			IL_00f5: conv.i2
			IL_00f6: ldc.i4 904236848
			IL_00fb: stloc 7
			IL_00ff: ldloca 7
			IL_0103: nop
			IL_0104: ldind.i2
			IL_0105: conv.i2
			IL_0106: ceq
			IL_0108: switch (IL_0149, IL_011a, IL_0149)

			IL_0119: nop

			IL_011a: ldc.i4 678952960
			IL_011f: nop
			IL_0120: stloc 7
			IL_0124: ldloca 7
			IL_0128: ldind.i2
			IL_0129: conv.i2
			IL_012a: brfalse IL_012f

			IL_012f: ldc.i4.0
			IL_0130: stloc.3
			IL_0131: ldc.i4 1431830528
			IL_0136: nop
			IL_0137: stloc 7
			IL_013b: ldloca 7
			IL_013f: nop
			IL_0140: ldind.i2
			IL_0141: conv.i2
			IL_0142: conv.i
			IL_0143: stloc.s 6
			IL_0145: br.s IL_00c9

			IL_0147: br.s IL_0149

			IL_0149: ldc.i4 1933508612
			IL_014e: stloc 7
			IL_0152: nop
			IL_0153: ldloca 7
			IL_0157: ldind.i2
			IL_0158: conv.i2
			IL_0159: conv.i
			IL_015a: stloc.s 6
			IL_015c: br IL_00c9

			IL_0161: ldloc.3
			IL_0162: ldloc.1
			IL_0163: blt.s IL_0180

			IL_0165: ldc.i4 1293811714
			IL_016a: nop
			IL_016b: stloc 7
			IL_016f: nop
			IL_0170: ldloca 7
			IL_0174: ldind.i2
			IL_0175: conv.i2
			IL_0176: conv.i
			IL_0177: stloc.s 6
			IL_0179: br IL_00c9

			IL_017e: br.s IL_01c7

			IL_0180: ldloc.0
			IL_0181: ldloc.3
			IL_0182: ldc.i4.2
			IL_0183: newarr [mscorlib]System.Char
			IL_0188: dup
			IL_0189: ldc.i4.0
			IL_018a: ldloc.2
			IL_018b: callvirt instance int32 [mscorlib]System.IO.TextReader::Read()
			IL_0190: conv.u2
			IL_0191: stelem.i2
			IL_0192: dup
			IL_0193: ldc.i4.1
			IL_0194: ldloc.2
			IL_0195: callvirt instance int32 [mscorlib]System.IO.TextReader::Read()
			IL_019a: conv.u2
			IL_019b: stelem.i2
			IL_019c: newobj instance void [mscorlib]System.String::.ctor(char[])
			IL_01a1: ldc.i4.s 16
			IL_01a3: call uint8 [mscorlib]System.Convert::ToByte(string, int32)
			IL_01a8: stelem.i1
			IL_01a9: ldloc.3
			IL_01aa: ldc.i4.1
			IL_01ab: add
			IL_01ac: stloc.3
			IL_01ad: ldc.i4 1349320705
			IL_01b2: stloc 7
			IL_01b6: ldloca 7
			IL_01ba: nop
			IL_01bb: ldind.i2
			IL_01bc: conv.i2
			IL_01bd: conv.i
			IL_01be: stloc.s 6
			IL_01c0: br IL_00c9

			IL_01c5: br.s IL_0149

			IL_01c7: ldc.i4 371458051
			IL_01cc: nop
			IL_01cd: stloc 7
			IL_01d1: ldloca 7
			IL_01d5: nop
			IL_01d6: ldind.i2
			IL_01d7: conv.i2
			IL_01d8: conv.i
			IL_01d9: stloc.s 6
			IL_01db: br IL_00c9

			IL_01e0: leave IL_03c8
		} // end .try
		finally
		{
			IL_01e5: ldc.i4 18546690
			IL_01ea: stloc 7
			IL_01ee: ldloca 7
			IL_01f2: nop
			IL_01f3: ldind.i2
			IL_01f4: conv.i2
			IL_01f5: conv.i
			IL_01f6: stloc.s 6
			IL_01f8: br.s IL_0204
			// loop start (head: IL_0204)
				IL_01fa: ldc.i4.0
				IL_01fb: switch (IL_0217)

				IL_0204: ldloc.s 6
				IL_0206: switch (IL_022f, IL_024d, IL_01fa)
			// end loop

			IL_0217: ldloc.2
			IL_0218: brfalse.s IL_024f

			IL_021a: ldc.i4 1566572544
			IL_021f: stloc 7
			IL_0223: ldloca 7
			IL_0227: nop
			IL_0228: ldind.i2
			IL_0229: conv.i2
			IL_022a: conv.i
			IL_022b: stloc.s 6
			IL_022d: br.s IL_0204

			IL_022f: br.s IL_0231

			IL_0231: ldloc.2
			IL_0232: callvirt instance void [mscorlib]System.IDisposable::Dispose()
			IL_0237: ldc.i4 455999489
			IL_023c: nop
			IL_023d: stloc 7
			IL_0241: ldloca 7
			IL_0245: nop
			IL_0246: ldind.i2
			IL_0247: conv.i2
			IL_0248: conv.i
			IL_0249: stloc.s 6
			IL_024b: br.s IL_0204

			IL_024d: br.s IL_024f

			IL_024f: endfinally
		} // end handler

		IL_0250: ldc.i4.0
		IL_0251: newarr [mscorlib]System.Byte
		IL_0256: ret

		IL_0257: ldloc.0
		IL_0258: ldloc.s 5
		IL_025a: ldloc.s 4
		IL_025c: ldloc.s 5
		IL_025e: ldelem.u2
		IL_025f: conv.u1
		IL_0260: stelem.i1
		IL_0261: ldloc.s 5
		IL_0263: ldc.i4.1
		IL_0264: add
		IL_0265: stloc.s 5
		IL_0267: ldc.i4 217251845
		IL_026c: stloc 7
		IL_0270: nop
		IL_0271: ldloca 7
		IL_0275: nop
		IL_0276: ldind.i2
		IL_0277: conv.i2
		IL_0278: conv.i
		IL_0279: stloc.s 6
		IL_027b: br IL_003c

		IL_0280: ldc.i4 885522433
		IL_0285: nop
		IL_0286: stloc 7
		IL_028a: ldloca 7
		IL_028e: nop
		IL_028f: ldind.i2
		IL_0290: conv.i2
		IL_0291: br.s IL_02a7

		IL_0293: ldc.i4 1536425984
		IL_0298: nop
		IL_0299: stloc 7
		IL_029d: nop
		IL_029e: ldloca 7
		IL_02a2: nop
		IL_02a3: ldind.i2
		IL_02a4: conv.i2
		IL_02a5: br.s IL_02a7

		IL_02a7: brfalse.s IL_02a9

		IL_02a9: br.s IL_02ec

		IL_02ab: ldc.i4 1917452294
		IL_02b0: stloc 7
		IL_02b4: ldloca 7
		IL_02b8: nop
		IL_02b9: ldind.i2
		IL_02ba: conv.i2
		IL_02bb: conv.i
		IL_02bc: stloc.s 6
		IL_02be: br IL_003c

		IL_02c3: ldarg.0
		IL_02c4: callvirt instance int32 [mscorlib]System.String::get_Length()
		IL_02c9: ldc.i4.0
		IL_02ca: bgt IL_0364

		IL_02cf: ldc.i4 1663238144
		IL_02d4: stloc 7
		IL_02d8: ldloca 7
		IL_02dc: nop
		IL_02dd: ldind.i2
		IL_02de: conv.i2
		IL_02df: conv.i
		IL_02e0: stloc.s 6
		IL_02e2: br IL_003c

		IL_02e7: br IL_0250

		IL_02ec: ldc.i4 1087111176
		IL_02f1: stloc 7
		IL_02f5: ldloca 7
		IL_02f9: nop
		IL_02fa: ldind.i2
		IL_02fb: conv.i2
		IL_02fc: conv.i
		IL_02fd: stloc.s 6
		IL_02ff: br IL_003c

		IL_0304: ldloc.s 5
		IL_0306: ldloc.s 4
		IL_0308: ldlen
		IL_0309: conv.i4
		IL_030a: blt IL_0257

		IL_030f: ldc.i4 668532743
		IL_0314: nop
		IL_0315: stloc 7
		IL_0319: nop
		IL_031a: ldloca 7
		IL_031e: nop
		IL_031f: ldind.i2
		IL_0320: conv.i2
		IL_0321: conv.i
		IL_0322: stloc.s 6
		IL_0324: br IL_003c

		IL_0329: br IL_03c8

		IL_032e: ldarg.0
		IL_032f: callvirt instance int32 [mscorlib]System.String::get_Length()
		IL_0334: ldc.i4.2
		IL_0335: div
		IL_0336: stloc.1
		IL_0337: ldloc.1
		IL_0338: newarr [mscorlib]System.Byte
		IL_033d: stloc.0
		IL_033e: ldarg.0
		IL_033f: newobj instance void [mscorlib]System.IO.StringReader::.ctor(string)
		IL_0344: stloc.2
		IL_0345: ldc.i4 203423746
		IL_034a: nop
		IL_034b: stloc 7
		IL_034f: nop
		IL_0350: ldloca 7
		IL_0354: nop
		IL_0355: ldind.i2
		IL_0356: conv.i2
		IL_0357: conv.i
		IL_0358: stloc.s 6
		IL_035a: br IL_003c

		IL_035f: br IL_00bf

		IL_0364: br.s IL_0379

		IL_0366: ldc.i4 868941824
		IL_036b: stloc 7
		IL_036f: ldloca 7
		IL_0373: nop
		IL_0374: ldind.i2
		IL_0375: conv.i2

		IL_0376: pop
		IL_0377: br.s IL_038c

		IL_0379: ldc.i4 2057830400
		IL_037e: stloc 7
		IL_0382: nop
		IL_0383: ldloca 7
		IL_0387: nop
		IL_0388: ldind.i2
		IL_0389: conv.i2
		IL_038a: br.s IL_0376

		IL_038c: nop
		IL_038d: ldc.i4 496041987
		IL_0392: nop
		IL_0393: stloc 7
		IL_0397: ldloca 7
		IL_039b: ldind.i2
		IL_039c: conv.i2
		IL_039d: conv.i
		IL_039e: stloc.s 6
		IL_03a0: br IL_003c

		IL_03a5: ldarg.1
		IL_03a6: brfalse IL_0090

		IL_03ab: ldc.i4 2019622921
		IL_03b0: nop
		IL_03b1: stloc 7
		IL_03b5: ldloca 7
		IL_03b9: ldind.i2
		IL_03ba: conv.i2
		IL_03bb: conv.i
		IL_03bc: stloc.s 6
		IL_03be: br IL_003c

		IL_03c3: br IL_032e

		IL_03c8: ldloc.0
		IL_03c9: ret
	} // end of method Encryption::StringToBytes

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0xc6f4
		// Header size: 12
		// Code size: 7 (0x7)
		.maxstack 1

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ret
	} // end of method Encryption::.ctor

	// Properties
	.property string STATIC_KEY()
	{
		.get string ODCrypt.Encryption::w()
	}
	.property string STATIC_INIT_VECTOR()
	{
		.get string ODCrypt.Encryption::get_STATIC_INIT_VECTOR()
	}

} // end of class ODCrypt.Encryption

.class public auto ansi beforefieldinit ODCrypt.KeccakDigest
	extends [mscorlib]System.Object
{
	// Fields
	.field private static initonly uint64[] w
	.field private static initonly int32[] r
	.field family uint8[] state
	.field family uint8[] dataQueue
	.field family int32 rate
	.field family int32 bitsInQueue
	.field family int32 fixedOutputLength
	.field family bool squeezing
	.field family int32 bitsAvailableForSqueezing
	.field family uint8[] chunk
	.field family uint8[] oneByte
	.field private uint64[] m
	.field private uint64[] h
	.field private uint64[] c

	// Methods
	.method private hidebysig static 
		uint64[] h () cil managed 
	{
		// Method begins at RVA 0xc708
		// Header size: 12
		// Code size: 748 (0x2ec)
		.maxstack 5
		.locals init (
			[0] uint64[],
			[1] uint8,
			[2] int32,
			[3] int32,
			[4] int32,
			[5] int32,
			[6] int16
		)

		IL_0000: ldc.i4 1705443328
		IL_0005: stloc 6
		IL_0009: ldloca 6
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: stloc.s 5
		IL_0012: ldloc.s 5
		IL_0014: switch (IL_001d)

		IL_001d: ldc.i4.0
		IL_001e: switch (IL_0066)

		IL_0027: ldloc.s 5
		IL_0029: switch (IL_00c0, IL_01a2, IL_01e7, IL_0242, IL_028c, IL_00a3, IL_0260, IL_0089, IL_0133, IL_01c4, IL_0225, IL_0208, IL_02e5, IL_00e4)

		IL_0066: ldc.i4.s 24
		IL_0068: newarr [mscorlib]System.UInt64
		IL_006d: stloc.0
		IL_006e: ldc.i4.1
		IL_006f: stloc.1
		IL_0070: ldc.i4.0
		IL_0071: stloc.2

		IL_0072: ldc.i4 993918983
		IL_0077: nop
		IL_0078: stloc 6
		IL_007c: nop
		IL_007d: ldloca 6
		IL_0081: nop
		IL_0082: ldind.i2
		IL_0083: conv.i2
		IL_0084: conv.i
		IL_0085: stloc.s 5
		IL_0087: br.s IL_0027

		IL_0089: br IL_020d

		IL_008e: ldc.i4 1987117061
		IL_0093: nop
		IL_0094: stloc 6
		IL_0098: ldloca 6
		IL_009c: ldind.i2
		IL_009d: conv.i2
		IL_009e: conv.i
		IL_009f: stloc.s 5
		IL_00a1: br.s IL_0027

		IL_00a3: ldloc.3
		IL_00a4: ldc.i4.7
		IL_00a5: blt.s IL_0110

		IL_00a7: ldc.i4 510525440
		IL_00ac: nop
		IL_00ad: stloc 6
		IL_00b1: ldloca 6
		IL_00b5: nop
		IL_00b6: ldind.i2
		IL_00b7: conv.i2
		IL_00b8: conv.i
		IL_00b9: stloc.s 5
		IL_00bb: br IL_0027

		IL_00c0: br IL_01a7

		IL_00c5: ldloc.1
		IL_00c6: ldc.i4.s 113
		IL_00c8: xor
		IL_00c9: conv.u1
		IL_00ca: stloc.1
		IL_00cb: ldc.i4 29032461
		IL_00d0: stloc 6
		IL_00d4: nop
		IL_00d5: ldloca 6
		IL_00d9: nop
		IL_00da: ldind.i2
		IL_00db: conv.i2
		IL_00dc: conv.i
		IL_00dd: stloc.s 5
		IL_00df: br IL_0027

		IL_00e4: ldc.i4 757792769
		IL_00e9: stloc 6
		IL_00ed: nop
		IL_00ee: ldloca 6
		IL_00f2: nop
		IL_00f3: ldind.i2
		IL_00f4: conv.i2
		IL_00f5: br.s IL_0109

		IL_00f7: ldc.i4 862453760
		IL_00fc: stloc 6
		IL_0100: ldloca 6
		IL_0104: nop
		IL_0105: ldind.i2
		IL_0106: conv.i2
		IL_0107: br.s IL_0109

		IL_0109: brfalse.s IL_010b

		IL_010b: br IL_01ec

		IL_0110: ldc.i4.1
		IL_0111: ldloc.3
		IL_0112: ldc.i4.s 31
		IL_0114: and
		IL_0115: shl
		IL_0116: ldc.i4.1
		IL_0117: sub
		IL_0118: stloc.s 4
		IL_011a: ldc.i4 951386120
		IL_011f: nop
		IL_0120: stloc 6
		IL_0124: nop
		IL_0125: ldloca 6
		IL_0129: ldind.i2
		IL_012a: conv.i2
		IL_012b: conv.i
		IL_012c: stloc.s 5
		IL_012e: br IL_0027

		IL_0133: ldc.i4 447974081
		IL_0138: stloc 6
		IL_013c: nop
		IL_013d: ldloca 6
		IL_0141: nop
		IL_0142: ldind.i2
		IL_0143: conv.i2
		IL_0144: ldc.i4 1578994369
		IL_0149: nop
		IL_014a: stloc 6
		IL_014e: ldloca 6
		IL_0152: nop
		IL_0153: ldind.i2
		IL_0154: conv.i2
		IL_0155: ceq
		IL_0157: switch (IL_0072, IL_0169, IL_0072)

		IL_0168: nop

		IL_0169: ldc.i4 1693384704
		IL_016e: stloc 6
		IL_0172: nop
		IL_0173: ldloca 6
		IL_0177: nop
		IL_0178: ldind.i2
		IL_0179: conv.i2
		IL_017a: brfalse IL_017f

		IL_017f: ldloc.1
		IL_0180: ldc.i4.1
		IL_0181: and
		IL_0182: ldc.i4.0
		IL_0183: cgt.un
		IL_0185: brfalse IL_0247

		IL_018a: ldc.i4 1366097921
		IL_018f: stloc 6
		IL_0193: nop
		IL_0194: ldloca 6
		IL_0198: ldind.i2
		IL_0199: conv.i2
		IL_019a: conv.i
		IL_019b: stloc.s 5
		IL_019d: br IL_0027

		IL_01a2: br IL_0291

		IL_01a7: ldloc.2
		IL_01a8: ldc.i4.1
		IL_01a9: add
		IL_01aa: stloc.2
		IL_01ab: ldc.i4 1307574281
		IL_01b0: nop
		IL_01b1: stloc 6
		IL_01b5: nop
		IL_01b6: ldloca 6
		IL_01ba: ldind.i2
		IL_01bb: conv.i2
		IL_01bc: conv.i
		IL_01bd: stloc.s 5
		IL_01bf: br IL_0027

		IL_01c4: br.s IL_020d

		IL_01c6: ldloc.0
		IL_01c7: ldloc.2
		IL_01c8: ldc.i4.0
		IL_01c9: conv.i8
		IL_01ca: stelem.i8
		IL_01cb: ldc.i4.0
		IL_01cc: stloc.3
		IL_01cd: ldc.i4 1539244034
		IL_01d2: nop
		IL_01d3: stloc 6
		IL_01d7: nop
		IL_01d8: ldloca 6
		IL_01dc: nop
		IL_01dd: ldind.i2
		IL_01de: conv.i2
		IL_01df: conv.i
		IL_01e0: stloc.s 5
		IL_01e2: br IL_0027

		IL_01e7: br IL_008e

		IL_01ec: ldloc.3
		IL_01ed: ldc.i4.1
		IL_01ee: add
		IL_01ef: stloc.3
		IL_01f0: ldc.i4 1861222411
		IL_01f5: stloc 6
		IL_01f9: nop
		IL_01fa: ldloca 6
		IL_01fe: ldind.i2
		IL_01ff: conv.i2
		IL_0200: conv.i
		IL_0201: stloc.s 5
		IL_0203: br IL_0027

		IL_0208: br IL_008e

		IL_020d: ldc.i4 1551826954
		IL_0212: stloc 6
		IL_0216: ldloca 6
		IL_021a: nop
		IL_021b: ldind.i2
		IL_021c: conv.i2
		IL_021d: conv.i
		IL_021e: stloc.s 5
		IL_0220: br IL_0027

		IL_0225: ldloc.2
		IL_0226: ldc.i4.s 24
		IL_0228: blt.s IL_01c6

		IL_022a: ldc.i4 1559101443
		IL_022f: stloc 6
		IL_0233: nop
		IL_0234: ldloca 6
		IL_0238: ldind.i2
		IL_0239: conv.i2
		IL_023a: conv.i
		IL_023b: stloc.s 5
		IL_023d: br IL_0027

		IL_0242: br IL_02ea

		IL_0247: ldc.i4 1052049414
		IL_024c: stloc 6
		IL_0250: nop
		IL_0251: ldloca 6
		IL_0255: nop
		IL_0256: ldind.i2
		IL_0257: conv.i2
		IL_0258: conv.i
		IL_0259: stloc.s 5
		IL_025b: br IL_0027

		IL_0260: ldloc.1
		IL_0261: ldc.i4 128
		IL_0266: and
		IL_0267: ldc.i4.0
		IL_0268: cgt.un
		IL_026a: ldloc.1
		IL_026b: ldc.i4.1
		IL_026c: shl
		IL_026d: conv.u1
		IL_026e: stloc.1
		IL_026f: brfalse IL_01ec

		IL_0274: ldc.i4 426508292
		IL_0279: stloc 6
		IL_027d: ldloca 6
		IL_0281: nop
		IL_0282: ldind.i2
		IL_0283: conv.i2
		IL_0284: conv.i
		IL_0285: stloc.s 5
		IL_0287: br IL_0027

		IL_028c: br IL_00c5

		IL_0291: br.s IL_02a6

		IL_0293: ldc.i4 928055296
		IL_0298: nop
		IL_0299: stloc 6
		IL_029d: ldloca 6
		IL_02a1: ldind.i2
		IL_02a2: conv.i2

		IL_02a3: pop
		IL_02a4: br.s IL_02b8

		IL_02a6: ldc.i4 1995571200
		IL_02ab: stloc 6
		IL_02af: nop
		IL_02b0: ldloca 6
		IL_02b4: ldind.i2
		IL_02b5: conv.i2
		IL_02b6: br.s IL_02a3

		IL_02b8: nop
		IL_02b9: ldloc.0
		IL_02ba: ldloc.2
		IL_02bb: ldelema [mscorlib]System.UInt64
		IL_02c0: dup
		IL_02c1: ldind.i8
		IL_02c2: ldc.i4.1
		IL_02c3: conv.i8
		IL_02c4: ldloc.s 4
		IL_02c6: ldc.i4.s 63
		IL_02c8: and
		IL_02c9: shl
		IL_02ca: xor
		IL_02cb: stind.i8
		IL_02cc: ldc.i4 744030220
		IL_02d1: stloc 6
		IL_02d5: nop
		IL_02d6: ldloca 6
		IL_02da: nop
		IL_02db: ldind.i2
		IL_02dc: conv.i2
		IL_02dd: conv.i
		IL_02de: stloc.s 5
		IL_02e0: br IL_0027

		IL_02e5: br IL_0247

		IL_02ea: ldloc.0
		IL_02eb: ret
	} // end of method KeccakDigest::h

	.method private hidebysig static 
		int32[] m () cil managed 
	{
		// Method begins at RVA 0xca00
		// Header size: 12
		// Code size: 395 (0x18b)
		.maxstack 5
		.locals init (
			[0] int32[],
			[1] int32,
			[2] int32,
			[3] int32,
			[4] int32,
			[5] int32,
			[6] int32,
			[7] int16
		)

		IL_0000: ldc.i4 978633666
		IL_0005: nop
		IL_0006: stloc 7
		IL_000a: ldloca 7
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1287111618
		IL_0016: stloc 7
		IL_001a: nop
		IL_001b: ldloca 7
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_00b6, IL_0035, IL_00b6)

		IL_0034: nop

		IL_0035: ldc.i4 1712259072
		IL_003a: stloc 7
		IL_003e: ldloca 7
		IL_0042: nop
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: brfalse IL_004a

		IL_004a: ldc.i4 966328320
		IL_004f: stloc 7
		IL_0053: nop
		IL_0054: ldloca 7
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: stloc.s 6
		IL_005d: ldloc.s 6
		IL_005f: switch (IL_0068)

		IL_0068: ldc.i4.0
		IL_0069: switch (IL_0089)

		IL_0072: ldloc.s 6
		IL_0074: switch (IL_00b6, IL_00f8, IL_0184, IL_0116)

		IL_0089: ldc.i4.s 25
		IL_008b: newarr [mscorlib]System.Int32
		IL_0090: stloc.0
		IL_0091: ldc.i4.0
		IL_0092: stloc.s 5
		IL_0094: ldloc.0
		IL_0095: ldc.i4.0
		IL_0096: ldloc.s 5
		IL_0098: stelem.i4
		IL_0099: ldc.i4.1
		IL_009a: stloc.1
		IL_009b: ldc.i4.0
		IL_009c: stloc.2
		IL_009d: ldc.i4.1
		IL_009e: stloc.3
		IL_009f: ldc.i4 525533184
		IL_00a4: nop
		IL_00a5: stloc 7
		IL_00a9: nop
		IL_00aa: ldloca 7
		IL_00ae: nop
		IL_00af: ldind.i2
		IL_00b0: conv.i2
		IL_00b1: conv.i
		IL_00b2: stloc.s 6
		IL_00b4: br.s IL_0072

		IL_00b6: ldc.i4 53608449
		IL_00bb: nop
		IL_00bc: stloc 7
		IL_00c0: nop
		IL_00c1: ldloca 7
		IL_00c5: nop
		IL_00c6: ldind.i2
		IL_00c7: conv.i2
		IL_00c8: br.s IL_00dc

		IL_00ca: ldc.i4 1801912320
		IL_00cf: stloc 7
		IL_00d3: ldloca 7
		IL_00d7: nop
		IL_00d8: ldind.i2
		IL_00d9: conv.i2
		IL_00da: br.s IL_00dc

		IL_00dc: brfalse.s IL_00de

		IL_00de: br.s IL_00e0

		IL_00e0: ldc.i4 463273985
		IL_00e5: stloc 7
		IL_00e9: ldloca 7
		IL_00ed: nop
		IL_00ee: ldind.i2
		IL_00ef: conv.i2
		IL_00f0: conv.i
		IL_00f1: stloc.s 6
		IL_00f3: br IL_0072

		IL_00f8: ldloc.3
		IL_00f9: ldc.i4.s 25
		IL_00fb: blt.s IL_0118

		IL_00fd: ldc.i4 200867843
		IL_0102: nop
		IL_0103: stloc 7
		IL_0107: ldloca 7
		IL_010b: nop
		IL_010c: ldind.i2
		IL_010d: conv.i2
		IL_010e: conv.i
		IL_010f: stloc.s 6
		IL_0111: br IL_0072

		IL_0116: br.s IL_0189

		IL_0118: ldloc.s 5
		IL_011a: ldloc.3
		IL_011b: add
		IL_011c: ldc.i4.s 63
		IL_011e: and
		IL_011f: stloc.s 5
		IL_0121: ldloc.0
		IL_0122: ldloc.1
		IL_0123: ldc.i4.5
		IL_0124: rem
		IL_0125: ldc.i4.5
		IL_0126: ldloc.2
		IL_0127: ldc.i4.5
		IL_0128: rem
		IL_0129: mul
		IL_012a: add
		IL_012b: ldloc.s 5
		IL_012d: stelem.i4
		IL_012e: ldloc.2
		IL_012f: ldc.i4.5
		IL_0130: rem
		IL_0131: stloc.s 4
		IL_0133: ldc.i4.2
		IL_0134: ldloc.1
		IL_0135: mul
		IL_0136: ldc.i4.3
		IL_0137: ldloc.2
		IL_0138: mul
		IL_0139: add
		IL_013a: ldc.i4.5
		IL_013b: rem
		IL_013c: ldloc.s 4
		IL_013e: stloc.1
		IL_013f: stloc.2
		IL_0140: ldloc.3
		IL_0141: ldc.i4.1
		IL_0142: add
		IL_0143: stloc.3
		IL_0144: br.s IL_0159

		IL_0146: ldc.i4 97976320
		IL_014b: stloc 7
		IL_014f: ldloca 7
		IL_0153: nop
		IL_0154: ldind.i2
		IL_0155: conv.i2

		IL_0156: pop
		IL_0157: br.s IL_016b

		IL_0159: ldc.i4 1613955072
		IL_015e: nop
		IL_015f: stloc 7
		IL_0163: ldloca 7
		IL_0167: ldind.i2
		IL_0168: conv.i2
		IL_0169: br.s IL_0156

		IL_016b: nop
		IL_016c: ldc.i4 948699138
		IL_0171: stloc 7
		IL_0175: ldloca 7
		IL_0179: nop
		IL_017a: ldind.i2
		IL_017b: conv.i2
		IL_017c: conv.i
		IL_017d: stloc.s 6
		IL_017f: br IL_0072

		IL_0184: br IL_00e0

		IL_0189: ldloc.0
		IL_018a: ret
	} // end of method KeccakDigest::m

	.method private hidebysig 
		instance void r (
			int32 A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0xcb98
		// Header size: 12
		// Code size: 303 (0x12f)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: br.s IL_0015

		IL_0002: ldc.i4 730136576
		IL_0007: stloc 2
		IL_000b: ldloca 2
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2

		IL_0012: pop
		IL_0013: br.s IL_0027

		IL_0015: ldc.i4 313982976
		IL_001a: stloc 2
		IL_001e: ldloca 2
		IL_0022: nop
		IL_0023: ldind.i2
		IL_0024: conv.i2
		IL_0025: br.s IL_0012

		IL_0027: nop
		IL_0028: ldc.i4 367018215
		IL_002d: nop
		IL_002e: stloc 2
		IL_0032: nop
		IL_0033: ldloca 2
		IL_0037: ldind.i2
		IL_0038: conv.i2
		IL_0039: ldc.i4 701579495
		IL_003e: stloc 2
		IL_0042: ldloca 2
		IL_0046: nop
		IL_0047: ldind.i2
		IL_0048: conv.i2
		IL_0049: ceq
		IL_004b: switch (IL_00d2, IL_005d, IL_00d2)

		IL_005c: nop

		IL_005d: ldc.i4 1665073152
		IL_0062: nop
		IL_0063: stloc 2
		IL_0067: nop
		IL_0068: ldloca 2
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: brfalse IL_0073

		IL_0073: ldc.i4.0
		IL_0074: switch (IL_0093)

		IL_007d: ldloc.1
		IL_007e: switch (IL_00aa, IL_00e7, IL_012c, IL_0105)

		IL_0093: ldarg.1
		IL_0094: stloc.0
		IL_0095: ldc.i4 1317928960
		IL_009a: stloc 2
		IL_009e: nop
		IL_009f: ldloca 2
		IL_00a3: nop
		IL_00a4: ldind.i2
		IL_00a5: conv.i2
		IL_00a6: conv.i
		IL_00a7: stloc.1
		IL_00a8: br.s IL_007d

		IL_00aa: ldc.i4 690880513
		IL_00af: stloc 2
		IL_00b3: nop
		IL_00b4: ldloca 2
		IL_00b8: ldind.i2
		IL_00b9: conv.i2
		IL_00ba: br.s IL_00ce

		IL_00bc: ldc.i4 2055929856
		IL_00c1: stloc 2
		IL_00c5: nop
		IL_00c6: ldloca 2
		IL_00ca: ldind.i2
		IL_00cb: conv.i2
		IL_00cc: br.s IL_00ce

		IL_00ce: brfalse.s IL_00d0

		IL_00d0: br.s IL_00d2

		IL_00d2: ldc.i4 1176174593
		IL_00d7: stloc 2
		IL_00db: nop
		IL_00dc: ldloca 2
		IL_00e0: nop
		IL_00e1: ldind.i2
		IL_00e2: conv.i2
		IL_00e3: conv.i
		IL_00e4: stloc.1
		IL_00e5: br.s IL_007d

		IL_00e7: ldloc.0
		IL_00e8: ldarg.1
		IL_00e9: ldarg.2
		IL_00ea: add
		IL_00eb: bne.un.s IL_0107

		IL_00ed: ldc.i4 1147011075
		IL_00f2: nop
		IL_00f3: stloc 2
		IL_00f7: nop
		IL_00f8: ldloca 2
		IL_00fc: ldind.i2
		IL_00fd: conv.i2
		IL_00fe: conv.i
		IL_00ff: stloc.1
		IL_0100: br IL_007d

		IL_0105: br.s IL_012e

		IL_0107: ldarg.0
		IL_0108: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_010d: ldloc.0
		IL_010e: ldc.i4.0
		IL_010f: stelem.i1
		IL_0110: ldloc.0
		IL_0111: ldc.i4.1
		IL_0112: add
		IL_0113: stloc.0
		IL_0114: ldc.i4 1378156546
		IL_0119: nop
		IL_011a: stloc 2
		IL_011e: nop
		IL_011f: ldloca 2
		IL_0123: ldind.i2
		IL_0124: conv.i2
		IL_0125: conv.i
		IL_0126: stloc.1
		IL_0127: br IL_007d

		IL_012c: br.s IL_00d2

		IL_012e: ret
	} // end of method KeccakDigest::r

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0xccd4
		// Header size: 12
		// Code size: 12 (0xc)
		.maxstack 2

		IL_0000: ldarg.0
		IL_0001: ldc.i4 288
		IL_0006: call instance void ODCrypt.KeccakDigest::.ctor(int32)
		IL_000b: ret
	} // end of method KeccakDigest::.ctor

	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 bitLength
		) cil managed 
	{
		// Method begins at RVA 0xccec
		// Header size: 12
		// Code size: 83 (0x53)
		.maxstack 2

		IL_0000: ldarg.0
		IL_0001: ldc.i4 200
		IL_0006: newarr [mscorlib]System.Byte
		IL_000b: stfld uint8[] ODCrypt.KeccakDigest::state
		IL_0010: ldarg.0
		IL_0011: ldc.i4 192
		IL_0016: newarr [mscorlib]System.Byte
		IL_001b: stfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_0020: ldarg.0
		IL_0021: ldc.i4.5
		IL_0022: newarr [mscorlib]System.UInt64
		IL_0027: stfld uint64[] ODCrypt.KeccakDigest::m
		IL_002c: ldarg.0
		IL_002d: ldc.i4.s 25
		IL_002f: newarr [mscorlib]System.UInt64
		IL_0034: stfld uint64[] ODCrypt.KeccakDigest::h
		IL_0039: ldarg.0
		IL_003a: ldc.i4.5
		IL_003b: newarr [mscorlib]System.UInt64
		IL_0040: stfld uint64[] ODCrypt.KeccakDigest::c
		IL_0045: ldarg.0
		IL_0046: call instance void [mscorlib]System.Object::.ctor()
		IL_004b: ldarg.0
		IL_004c: ldarg.1
		IL_004d: call instance void ODCrypt.KeccakDigest::w(int32)
		IL_0052: ret
	} // end of method KeccakDigest::.ctor

	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			class ODCrypt.KeccakDigest source
		) cil managed 
	{
		// Method begins at RVA 0xcd4c
		// Header size: 12
		// Code size: 83 (0x53)
		.maxstack 2

		IL_0000: ldarg.0
		IL_0001: ldc.i4 200
		IL_0006: newarr [mscorlib]System.Byte
		IL_000b: stfld uint8[] ODCrypt.KeccakDigest::state
		IL_0010: ldarg.0
		IL_0011: ldc.i4 192
		IL_0016: newarr [mscorlib]System.Byte
		IL_001b: stfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_0020: ldarg.0
		IL_0021: ldc.i4.5
		IL_0022: newarr [mscorlib]System.UInt64
		IL_0027: stfld uint64[] ODCrypt.KeccakDigest::m
		IL_002c: ldarg.0
		IL_002d: ldc.i4.s 25
		IL_002f: newarr [mscorlib]System.UInt64
		IL_0034: stfld uint64[] ODCrypt.KeccakDigest::h
		IL_0039: ldarg.0
		IL_003a: ldc.i4.5
		IL_003b: newarr [mscorlib]System.UInt64
		IL_0040: stfld uint64[] ODCrypt.KeccakDigest::c
		IL_0045: ldarg.0
		IL_0046: call instance void [mscorlib]System.Object::.ctor()
		IL_004b: ldarg.0
		IL_004c: ldarg.1
		IL_004d: call instance void ODCrypt.KeccakDigest::w(class ODCrypt.KeccakDigest)
		IL_0052: ret
	} // end of method KeccakDigest::.ctor

	.method private hidebysig 
		instance void w (
			class ODCrypt.KeccakDigest A_0
		) cil managed 
	{
		// Method begins at RVA 0xcdac
		// Header size: 12
		// Code size: 303 (0x12f)
		.maxstack 5
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 733806593
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: br.s IL_0026

		IL_0014: ldc.i4 536018944
		IL_0019: stloc 0
		IL_001d: ldloca 0
		IL_0021: nop
		IL_0022: ldind.i2
		IL_0023: conv.i2
		IL_0024: br.s IL_0026

		IL_0026: brfalse.s IL_0028

		IL_0028: br.s IL_003d

		IL_002a: ldc.i4 1948123136
		IL_002f: nop
		IL_0030: stloc 0
		IL_0034: ldloca 0
		IL_0038: ldind.i2
		IL_0039: conv.i2

		IL_003a: pop
		IL_003b: br.s IL_0050

		IL_003d: ldc.i4 36044800
		IL_0042: stloc 0
		IL_0046: nop
		IL_0047: ldloca 0
		IL_004b: nop
		IL_004c: ldind.i2
		IL_004d: conv.i2
		IL_004e: br.s IL_003a

		IL_0050: nop
		IL_0051: ldc.i4 233399526
		IL_0056: stloc 0
		IL_005a: ldloca 0
		IL_005e: nop
		IL_005f: ldind.i2
		IL_0060: conv.i2
		IL_0061: ldc.i4 786523366
		IL_0066: stloc 0
		IL_006a: ldloca 0
		IL_006e: nop
		IL_006f: ldind.i2
		IL_0070: conv.i2
		IL_0071: ceq
		IL_0073: switch (IL_0084, IL_0085, IL_0084)

		IL_0084: nop

		IL_0085: ldc.i4 1484390400
		IL_008a: nop
		IL_008b: stloc 0
		IL_008f: ldloca 0
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: brfalse IL_009a

		IL_009a: ldarg.1
		IL_009b: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_00a0: ldc.i4.0
		IL_00a1: ldarg.0
		IL_00a2: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_00a7: ldc.i4.0
		IL_00a8: ldarg.1
		IL_00a9: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_00ae: ldlen
		IL_00af: conv.i4
		IL_00b0: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00b5: ldarg.1
		IL_00b6: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_00bb: ldc.i4.0
		IL_00bc: ldarg.0
		IL_00bd: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_00c2: ldc.i4.0
		IL_00c3: ldarg.1
		IL_00c4: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_00c9: ldlen
		IL_00ca: conv.i4
		IL_00cb: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00d0: ldarg.0
		IL_00d1: ldarg.1
		IL_00d2: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_00d7: stfld int32 ODCrypt.KeccakDigest::rate
		IL_00dc: ldarg.0
		IL_00dd: ldarg.1
		IL_00de: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_00e3: stfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_00e8: ldarg.0
		IL_00e9: ldarg.1
		IL_00ea: ldfld int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_00ef: stfld int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_00f4: ldarg.0
		IL_00f5: ldarg.1
		IL_00f6: ldfld bool ODCrypt.KeccakDigest::squeezing
		IL_00fb: stfld bool ODCrypt.KeccakDigest::squeezing
		IL_0100: ldarg.0
		IL_0101: ldarg.1
		IL_0102: ldfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_0107: stfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_010c: ldarg.0
		IL_010d: ldarg.1
		IL_010e: ldfld uint8[] ODCrypt.KeccakDigest::chunk
		IL_0113: call uint8[] ODCrypt.Arrays::Clone(uint8[])
		IL_0118: stfld uint8[] ODCrypt.KeccakDigest::chunk
		IL_011d: ldarg.0
		IL_011e: ldarg.1
		IL_011f: ldfld uint8[] ODCrypt.KeccakDigest::oneByte
		IL_0124: call uint8[] ODCrypt.Arrays::Clone(uint8[])
		IL_0129: stfld uint8[] ODCrypt.KeccakDigest::oneByte
		IL_012e: ret
	} // end of method KeccakDigest::w

	.method public hidebysig specialname newslot virtual 
		instance string get_AlgorithmName () cil managed 
	{
		// Method begins at RVA 0xcee8
		// Header size: 12
		// Code size: 194 (0xc2)
		.maxstack 2
		.locals init (
			[0] int16,
			[1] int32
		)

		IL_0000: ldc.i4 19
		IL_0005: stloc 1
		IL_0009: ldc.i4 1109587931
		IL_000e: nop
		IL_000f: stloc 0
		IL_0013: ldloca 0
		IL_0017: ldind.i2
		IL_0018: conv.i2
		IL_0019: ldc.i4 284096475
		IL_001e: stloc 0
		IL_0022: ldloca 0
		IL_0026: nop
		IL_0027: ldind.i2
		IL_0028: conv.i2
		IL_0029: ceq
		IL_002b: switch (IL_003c, IL_0066, IL_003c)

		IL_003c: br.s IL_0052

		IL_003e: ldc.i4 718536704
		IL_0043: stloc 0
		IL_0047: nop
		IL_0048: ldloca 0
		IL_004c: nop
		IL_004d: ldind.i2
		IL_004e: conv.i2

		IL_004f: pop
		IL_0050: br.s IL_0064

		IL_0052: ldc.i4 2037383168
		IL_0057: nop
		IL_0058: stloc 0
		IL_005c: ldloca 0
		IL_0060: ldind.i2
		IL_0061: conv.i2
		IL_0062: br.s IL_004f

		IL_0064: nop
		IL_0065: nop

		IL_0066: ldc.i4 93782017
		IL_006b: nop
		IL_006c: stloc 0
		IL_0070: ldloca 0
		IL_0074: nop
		IL_0075: ldind.i2
		IL_0076: conv.i2
		IL_0077: br.s IL_008b

		IL_0079: ldc.i4 678887424
		IL_007e: stloc 0
		IL_0082: ldloca 0
		IL_0086: nop
		IL_0087: ldind.i2
		IL_0088: conv.i2
		IL_0089: br.s IL_008b

		IL_008b: brfalse.s IL_008d

		IL_008d: ldc.i4 392691712
		IL_0092: nop
		IL_0093: stloc 0
		IL_0097: nop
		IL_0098: ldloca 0
		IL_009c: ldind.i2
		IL_009d: conv.i2
		IL_009e: brfalse IL_00a3

		IL_00a3: ldstr "???????"
		IL_00a8: ldloc 1
		IL_00ac: call string ODCrypt.Sha3::b(string, int32)
		IL_00b1: ldarg.0
		IL_00b2: ldflda int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_00b7: call instance string [mscorlib]System.Int32::ToString()
		IL_00bc: call string [mscorlib]System.String::Concat(string, string)
		IL_00c1: ret
	} // end of method KeccakDigest::get_AlgorithmName

	.method public hidebysig newslot virtual 
		instance int32 GetDigestSize () cil managed 
	{
		// Method begins at RVA 0xcfb8
		// Header size: 12
		// Code size: 163 (0xa3)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 602996737
		IL_0005: stloc 0
		IL_0009: nop
		IL_000a: ldloca 0
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: br.s IL_0025

		IL_0013: ldc.i4 1192230912
		IL_0018: stloc 0
		IL_001c: nop
		IL_001d: ldloca 0
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: br.s IL_0025

		IL_0025: brfalse.s IL_0027

		IL_0027: br.s IL_003d

		IL_0029: ldc.i4 1221591040
		IL_002e: stloc 0
		IL_0032: nop
		IL_0033: ldloca 0
		IL_0037: nop
		IL_0038: ldind.i2
		IL_0039: conv.i2

		IL_003a: pop
		IL_003b: br.s IL_004f

		IL_003d: ldc.i4 810745856
		IL_0042: stloc 0
		IL_0046: nop
		IL_0047: ldloca 0
		IL_004b: ldind.i2
		IL_004c: conv.i2
		IL_004d: br.s IL_003a

		IL_004f: nop
		IL_0050: ldc.i4 336907369
		IL_0055: stloc 0
		IL_0059: ldloca 0
		IL_005d: nop
		IL_005e: ldind.i2
		IL_005f: conv.i2
		IL_0060: ldc.i4 833670249
		IL_0065: stloc 0
		IL_0069: nop
		IL_006a: ldloca 0
		IL_006e: nop
		IL_006f: ldind.i2
		IL_0070: conv.i2
		IL_0071: ceq
		IL_0073: switch (IL_0084, IL_0085, IL_0084)

		IL_0084: nop

		IL_0085: ldc.i4 2045181952
		IL_008a: nop
		IL_008b: stloc 0
		IL_008f: ldloca 0
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: brfalse IL_009a

		IL_009a: ldarg.0
		IL_009b: ldfld int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_00a0: ldc.i4.8
		IL_00a1: div
		IL_00a2: ret
	} // end of method KeccakDigest::GetDigestSize

	.method public hidebysig newslot virtual 
		instance void Update (
			uint8 input
		) cil managed 
	{
		// Method begins at RVA 0xd068
		// Header size: 12
		// Code size: 182 (0xb6)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 473523924
		IL_0005: stloc 0
		IL_0009: ldloca 0
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 113403604
		IL_0015: stloc 0
		IL_0019: ldloca 0
		IL_001d: nop
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_005e, IL_0033)

		IL_0033: br.s IL_0049

		IL_0035: ldc.i4 807337984
		IL_003a: nop
		IL_003b: stloc 0
		IL_003f: ldloca 0
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2

		IL_0046: pop
		IL_0047: br.s IL_005c

		IL_0049: ldc.i4 295960576
		IL_004e: stloc 0
		IL_0052: nop
		IL_0053: ldloca 0
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_0046

		IL_005c: nop
		IL_005d: nop

		IL_005e: ldc.i4 587399169
		IL_0063: nop
		IL_0064: stloc 0
		IL_0068: ldloca 0
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: br.s IL_0084

		IL_0070: ldc.i4 808321024
		IL_0075: nop
		IL_0076: stloc 0
		IL_007a: nop
		IL_007b: ldloca 0
		IL_007f: nop
		IL_0080: ldind.i2
		IL_0081: conv.i2
		IL_0082: br.s IL_0084

		IL_0084: brfalse.s IL_0086

		IL_0086: ldc.i4 538574848
		IL_008b: nop
		IL_008c: stloc 0
		IL_0090: nop
		IL_0091: ldloca 0
		IL_0095: nop
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: brfalse IL_009d

		IL_009d: ldarg.0
		IL_009e: ldfld uint8[] ODCrypt.KeccakDigest::oneByte
		IL_00a3: ldc.i4.0
		IL_00a4: ldarg.1
		IL_00a5: stelem.i1
		IL_00a6: ldarg.0
		IL_00a7: ldarg.0
		IL_00a8: ldfld uint8[] ODCrypt.KeccakDigest::oneByte
		IL_00ad: ldc.i4.0
		IL_00ae: ldc.i4.8
		IL_00af: conv.i8
		IL_00b0: callvirt instance void ODCrypt.KeccakDigest::Absorb(uint8[], int32, int64)
		IL_00b5: ret
	} // end of method KeccakDigest::Update

	.method public hidebysig newslot virtual 
		instance void BlockUpdate (
			uint8[] input,
			int32 inOff,
			int32 len
		) cil managed 
	{
		// Method begins at RVA 0xd12c
		// Header size: 12
		// Code size: 171 (0xab)
		.maxstack 5
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1120553523
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1313950259
		IL_0016: stloc 0
		IL_001a: nop
		IL_001b: ldloca 0
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_005f, IL_0035)

		IL_0035: br.s IL_004a

		IL_0037: ldc.i4 310771712
		IL_003c: stloc 0
		IL_0040: ldloca 0
		IL_0044: nop
		IL_0045: ldind.i2
		IL_0046: conv.i2

		IL_0047: pop
		IL_0048: br.s IL_005d

		IL_004a: ldc.i4 1147994112
		IL_004f: nop
		IL_0050: stloc 0
		IL_0054: nop
		IL_0055: ldloca 0
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_0047

		IL_005d: nop
		IL_005e: nop

		IL_005f: ldc.i4 395444225
		IL_0064: nop
		IL_0065: stloc 0
		IL_0069: ldloca 0
		IL_006d: nop
		IL_006e: ldind.i2
		IL_006f: conv.i2
		IL_0070: br.s IL_0086

		IL_0072: ldc.i4 846462976
		IL_0077: nop
		IL_0078: stloc 0
		IL_007c: nop
		IL_007d: ldloca 0
		IL_0081: nop
		IL_0082: ldind.i2
		IL_0083: conv.i2
		IL_0084: br.s IL_0086

		IL_0086: brfalse.s IL_0088

		IL_0088: ldc.i4 1505492992
		IL_008d: nop
		IL_008e: stloc 0
		IL_0092: ldloca 0
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: brfalse IL_009d

		IL_009d: ldarg.0
		IL_009e: ldarg.1
		IL_009f: ldarg.2
		IL_00a0: ldarg.3
		IL_00a1: conv.i8
		IL_00a2: ldc.i4.8
		IL_00a3: conv.i8
		IL_00a4: mul
		IL_00a5: callvirt instance void ODCrypt.KeccakDigest::Absorb(uint8[], int32, int64)
		IL_00aa: ret
	} // end of method KeccakDigest::BlockUpdate

	.method public hidebysig newslot virtual 
		instance int32 DoFinal (
			uint8[] output,
			int32 outOff
		) cil managed 
	{
		// Method begins at RVA 0xd1e4
		// Header size: 12
		// Code size: 182 (0xb6)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 542850806
		IL_0005: stloc 0
		IL_0009: ldloca 0
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 991575798
		IL_0015: stloc 0
		IL_0019: ldloca 0
		IL_001d: nop
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_005e, IL_0033)

		IL_0033: br.s IL_0049

		IL_0035: ldc.i4 1097990144
		IL_003a: nop
		IL_003b: stloc 0
		IL_003f: ldloca 0
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2

		IL_0046: pop
		IL_0047: br.s IL_005c

		IL_0049: ldc.i4 516947968
		IL_004e: nop
		IL_004f: stloc 0
		IL_0053: nop
		IL_0054: ldloca 0
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_0046

		IL_005c: nop
		IL_005d: nop

		IL_005e: ldc.i4 55181313
		IL_0063: stloc 0
		IL_0067: nop
		IL_0068: ldloca 0
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: br.s IL_0083

		IL_0071: ldc.i4 1350369280
		IL_0076: stloc 0
		IL_007a: nop
		IL_007b: ldloca 0
		IL_007f: ldind.i2
		IL_0080: conv.i2
		IL_0081: br.s IL_0083

		IL_0083: brfalse.s IL_0085

		IL_0085: ldc.i4 867565568
		IL_008a: stloc 0
		IL_008e: ldloca 0
		IL_0092: nop
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: brfalse IL_009a

		IL_009a: ldarg.0
		IL_009b: ldarg.1
		IL_009c: ldarg.2
		IL_009d: ldarg.0
		IL_009e: ldfld int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_00a3: conv.i8
		IL_00a4: callvirt instance void ODCrypt.KeccakDigest::Squeeze(uint8[], int32, int64)
		IL_00a9: ldarg.0
		IL_00aa: callvirt instance void ODCrypt.KeccakDigest::Reset()
		IL_00af: ldarg.0
		IL_00b0: callvirt instance int32 ODCrypt.KeccakDigest::GetDigestSize()
		IL_00b5: ret
	} // end of method KeccakDigest::DoFinal

	.method family hidebysig newslot virtual 
		instance int32 DoFinal (
			uint8[] output,
			int32 outOff,
			uint8 partialByte,
			int32 partialBits
		) cil managed 
	{
		// Method begins at RVA 0xd2a8
		// Header size: 12
		// Code size: 313 (0x139)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int16
		)

		IL_0000: br.s IL_0015

		IL_0002: ldc.i4 1041104896
		IL_0007: stloc 1
		IL_000b: nop
		IL_000c: ldloca 1
		IL_0010: ldind.i2
		IL_0011: conv.i2

		IL_0012: pop
		IL_0013: br.s IL_0028

		IL_0015: ldc.i4 1196556288
		IL_001a: stloc 1
		IL_001e: nop
		IL_001f: ldloca 1
		IL_0023: nop
		IL_0024: ldind.i2
		IL_0025: conv.i2
		IL_0026: br.s IL_0012

		IL_0028: nop
		IL_0029: ldc.i4 1286406144
		IL_002e: stloc 1
		IL_0032: nop
		IL_0033: ldloca 1
		IL_0037: nop
		IL_0038: ldind.i2
		IL_0039: conv.i2
		IL_003a: conv.i
		IL_003b: stloc.0
		IL_003c: br IL_00c0
		// loop start (head: IL_00c0)
			IL_0041: ldc.i4 1167537566
			IL_0046: nop
			IL_0047: stloc 1
			IL_004b: ldloca 1
			IL_004f: ldind.i2
			IL_0050: conv.i2
			IL_0051: ldc.i4 764884382
			IL_0056: nop
			IL_0057: stloc 1
			IL_005b: nop
			IL_005c: ldloca 1
			IL_0060: nop
			IL_0061: ldind.i2
			IL_0062: conv.i2
			IL_0063: ceq
			IL_0065: switch (IL_00d2, IL_0077, IL_00d2)

			IL_0076: nop

			IL_0077: ldc.i4 93978625
			IL_007c: nop
			IL_007d: stloc 1
			IL_0081: nop
			IL_0082: ldloca 1
			IL_0086: nop
			IL_0087: ldind.i2
			IL_0088: conv.i2
			IL_0089: br.s IL_009f

			IL_008b: ldc.i4 2000879616
			IL_0090: nop
			IL_0091: stloc 1
			IL_0095: nop
			IL_0096: ldloca 1
			IL_009a: nop
			IL_009b: ldind.i2
			IL_009c: conv.i2
			IL_009d: br.s IL_009f

			IL_009f: brfalse.s IL_00a1

			IL_00a1: ldc.i4 1552547840
			IL_00a6: stloc 1
			IL_00aa: nop
			IL_00ab: ldloca 1
			IL_00af: ldind.i2
			IL_00b0: conv.i2
			IL_00b1: brfalse IL_00b6

			IL_00b6: ldc.i4.0
			IL_00b7: switch (IL_00d2)

			IL_00c0: ldloc.0
			IL_00c1: switch (IL_0041, IL_011b, IL_00ec)
		// end loop

		IL_00d2: ldarg.s partialBits
		IL_00d4: ldc.i4.0
		IL_00d5: ble.s IL_011d

		IL_00d7: ldc.i4 679673858
		IL_00dc: stloc 1
		IL_00e0: nop
		IL_00e1: ldloca 1
		IL_00e5: nop
		IL_00e6: ldind.i2
		IL_00e7: conv.i2
		IL_00e8: conv.i
		IL_00e9: stloc.0
		IL_00ea: br.s IL_00c0

		IL_00ec: br.s IL_00ee

		IL_00ee: ldarg.0
		IL_00ef: ldfld uint8[] ODCrypt.KeccakDigest::oneByte
		IL_00f4: ldc.i4.0
		IL_00f5: ldarg.3
		IL_00f6: stelem.i1
		IL_00f7: ldarg.0
		IL_00f8: ldarg.0
		IL_00f9: ldfld uint8[] ODCrypt.KeccakDigest::oneByte
		IL_00fe: ldc.i4.0
		IL_00ff: ldarg.s partialBits
		IL_0101: conv.i8
		IL_0102: callvirt instance void ODCrypt.KeccakDigest::Absorb(uint8[], int32, int64)
		IL_0107: ldc.i4 544866305
		IL_010c: stloc 1
		IL_0110: ldloca 1
		IL_0114: nop
		IL_0115: ldind.i2
		IL_0116: conv.i2
		IL_0117: conv.i
		IL_0118: stloc.0
		IL_0119: br.s IL_00c0

		IL_011b: br.s IL_011d

		IL_011d: ldarg.0
		IL_011e: ldarg.1
		IL_011f: ldarg.2
		IL_0120: ldarg.0
		IL_0121: ldfld int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_0126: conv.i8
		IL_0127: callvirt instance void ODCrypt.KeccakDigest::Squeeze(uint8[], int32, int64)
		IL_012c: ldarg.0
		IL_012d: callvirt instance void ODCrypt.KeccakDigest::Reset()
		IL_0132: ldarg.0
		IL_0133: callvirt instance int32 ODCrypt.KeccakDigest::GetDigestSize()
		IL_0138: ret
	} // end of method KeccakDigest::DoFinal

	.method public hidebysig newslot virtual 
		instance void Reset () cil managed 
	{
		// Method begins at RVA 0xd3f0
		// Header size: 12
		// Code size: 168 (0xa8)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 210743080
		IL_0005: stloc 0
		IL_0009: ldloca 0
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1227075368
		IL_0015: nop
		IL_0016: stloc 0
		IL_001a: nop
		IL_001b: ldloca 0
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_005e, IL_0035)

		IL_0035: br.s IL_004a

		IL_0037: ldc.i4 1247870976
		IL_003c: nop
		IL_003d: stloc 0
		IL_0041: ldloca 0
		IL_0045: ldind.i2
		IL_0046: conv.i2

		IL_0047: pop
		IL_0048: br.s IL_005c

		IL_004a: ldc.i4 726532096
		IL_004f: nop
		IL_0050: stloc 0
		IL_0054: ldloca 0
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_0047

		IL_005c: nop
		IL_005d: nop

		IL_005e: ldc.i4 764084224
		IL_0063: stloc 0
		IL_0067: ldloca 0
		IL_006b: nop
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: brfalse IL_0073

		IL_0073: ldc.i4 1425997825
		IL_0078: stloc 0
		IL_007c: ldloca 0
		IL_0080: nop
		IL_0081: ldind.i2
		IL_0082: conv.i2
		IL_0083: br.s IL_0099

		IL_0085: ldc.i4 130809856
		IL_008a: nop
		IL_008b: stloc 0
		IL_008f: nop
		IL_0090: ldloca 0
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: br.s IL_0099

		IL_0099: brfalse.s IL_009b

		IL_009b: ldarg.0
		IL_009c: ldarg.0
		IL_009d: ldfld int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_00a2: call instance void ODCrypt.KeccakDigest::w(int32)
		IL_00a7: ret
	} // end of method KeccakDigest::Reset

	.method public hidebysig newslot virtual 
		instance int32 GetByteLength () cil managed 
	{
		// Method begins at RVA 0xd4a4
		// Header size: 12
		// Code size: 162 (0xa2)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1241972737
		IL_0005: stloc 0
		IL_0009: ldloca 0
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: br.s IL_0024

		IL_0012: ldc.i4 1463418880
		IL_0017: stloc 0
		IL_001b: ldloca 0
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: br.s IL_0024

		IL_0024: brfalse.s IL_0026

		IL_0026: br.s IL_003c

		IL_0028: ldc.i4 1804730368
		IL_002d: nop
		IL_002e: stloc 0
		IL_0032: ldloca 0
		IL_0036: nop
		IL_0037: ldind.i2
		IL_0038: conv.i2

		IL_0039: pop
		IL_003a: br.s IL_004e

		IL_003c: ldc.i4 1072758784
		IL_0041: stloc 0
		IL_0045: ldloca 0
		IL_0049: nop
		IL_004a: ldind.i2
		IL_004b: conv.i2
		IL_004c: br.s IL_0039

		IL_004e: nop
		IL_004f: ldc.i4 146080826
		IL_0054: nop
		IL_0055: stloc 0
		IL_0059: ldloca 0
		IL_005d: nop
		IL_005e: ldind.i2
		IL_005f: conv.i2
		IL_0060: ldc.i4 2028143674
		IL_0065: stloc 0
		IL_0069: nop
		IL_006a: ldloca 0
		IL_006e: ldind.i2
		IL_006f: conv.i2
		IL_0070: ceq
		IL_0072: switch (IL_0083, IL_0084, IL_0083)

		IL_0083: nop

		IL_0084: ldc.i4 13369344
		IL_0089: stloc 0
		IL_008d: nop
		IL_008e: ldloca 0
		IL_0092: ldind.i2
		IL_0093: conv.i2
		IL_0094: brfalse IL_0099

		IL_0099: ldarg.0
		IL_009a: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_009f: ldc.i4.8
		IL_00a0: div
		IL_00a1: ret
	} // end of method KeccakDigest::GetByteLength

	.method private hidebysig 
		instance void w (
			int32 A_0
		) cil managed 
	{
		// Method begins at RVA 0xd554
		// Header size: 12
		// Code size: 863 (0x35f)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int16,
			[2] int32
		)

		IL_0000: ldc.i4 9
		IL_0005: stloc 2
		IL_0009: ldc.i4 908197889
		IL_000e: nop
		IL_000f: stloc 1
		IL_0013: ldloca 1
		IL_0017: nop
		IL_0018: ldind.i2
		IL_0019: conv.i2
		IL_001a: conv.i
		IL_001b: stloc.0
		IL_001c: br.s IL_0028
		// loop start (head: IL_0028)
			IL_001e: ldc.i4.0
			IL_001f: switch (IL_006e)

			IL_0028: ldloc.0
			IL_0029: switch (IL_0272, IL_001e, IL_01d3, IL_0338, IL_02aa, IL_01f3, IL_0144, IL_00d9, IL_0195, IL_0108, IL_0173, IL_024f, IL_0125, IL_028b, IL_02ee, IL_020f)
		// end loop
		// loop start (head: IL_006e)
			IL_006e: ldarg.1
			IL_006f: ldc.i4 256
			IL_0074: bgt IL_0236

			IL_0079: ldc.i4 1435234633
			IL_007e: nop
			IL_007f: stloc 1
			IL_0083: ldloca 1
			IL_0087: ldind.i2
			IL_0088: conv.i2
			IL_0089: ldc.i4 1417933129
			IL_008e: stloc 1
			IL_0092: ldloca 1
			IL_0096: nop
			IL_0097: ldind.i2
			IL_0098: conv.i2
			IL_0099: ceq
			IL_009b: switch (IL_006e, IL_00ad, IL_006e)
		// end loop

		IL_00ac: nop

		IL_00ad: ldc.i4 1713045504
		IL_00b2: stloc 1
		IL_00b6: nop
		IL_00b7: ldloca 1
		IL_00bb: ldind.i2
		IL_00bc: conv.i2
		IL_00bd: brfalse IL_00c2

		IL_00c2: ldc.i4 928055303
		IL_00c7: stloc 1
		IL_00cb: ldloca 1
		IL_00cf: nop
		IL_00d0: ldind.i2
		IL_00d1: conv.i2
		IL_00d2: conv.i
		IL_00d3: stloc.0
		IL_00d4: br IL_0028

		IL_00d9: br IL_0274

		IL_00de: ldarg.0
		IL_00df: ldc.i4 1152
		IL_00e4: ldc.i4 448
		IL_00e9: call instance void ODCrypt.KeccakDigest::w(int32, int32)
		IL_00ee: ret

		IL_00ef: ldc.i4 640221193
		IL_00f4: nop
		IL_00f5: stloc 1
		IL_00f9: nop
		IL_00fa: ldloca 1
		IL_00fe: nop
		IL_00ff: ldind.i2
		IL_0100: conv.i2
		IL_0101: conv.i
		IL_0102: stloc.0
		IL_0103: br IL_0028

		IL_0108: br IL_033d

		IL_010d: ldc.i4 1182269452
		IL_0112: nop
		IL_0113: stloc 1
		IL_0117: ldloca 1
		IL_011b: nop
		IL_011c: ldind.i2
		IL_011d: conv.i2
		IL_011e: conv.i
		IL_011f: stloc.0
		IL_0120: br IL_0028

		IL_0125: ldarg.1
		IL_0126: ldc.i4 256
		IL_012b: beq.s IL_019a

		IL_012d: ldc.i4 1580859398
		IL_0132: stloc 1
		IL_0136: ldloca 1
		IL_013a: nop
		IL_013b: ldind.i2
		IL_013c: conv.i2
		IL_013d: conv.i
		IL_013e: stloc.0
		IL_013f: br IL_0028

		IL_0144: br IL_01f8

		IL_0149: ldarg.0
		IL_014a: ldc.i4 1024
		IL_014f: ldc.i4 576
		IL_0154: call instance void ODCrypt.KeccakDigest::w(int32, int32)
		IL_0159: ret

		IL_015a: ldc.i4 1529413642
		IL_015f: nop
		IL_0160: stloc 1
		IL_0164: nop
		IL_0165: ldloca 1
		IL_0169: nop
		IL_016a: ldind.i2
		IL_016b: conv.i2
		IL_016c: conv.i
		IL_016d: stloc.0
		IL_016e: br IL_0028

		IL_0173: ldarg.1
		IL_0174: ldc.i4 224
		IL_0179: beq IL_00de

		IL_017e: ldc.i4 251002888
		IL_0183: stloc 1
		IL_0187: ldloca 1
		IL_018b: nop
		IL_018c: ldind.i2
		IL_018d: conv.i2
		IL_018e: conv.i
		IL_018f: stloc.0
		IL_0190: br IL_0028

		IL_0195: br IL_010d

		IL_019a: ldarg.0
		IL_019b: ldc.i4 1088
		IL_01a0: ldc.i4 512
		IL_01a5: call instance void ODCrypt.KeccakDigest::w(int32, int32)
		IL_01aa: ret

		IL_01ab: ldarg.0
		IL_01ac: ldc.i4 576
		IL_01b1: ldc.i4 1024
		IL_01b6: call instance void ODCrypt.KeccakDigest::w(int32, int32)
		IL_01bb: ret

		IL_01bc: ldc.i4 2043936770
		IL_01c1: stloc 1
		IL_01c5: nop
		IL_01c6: ldloca 1
		IL_01ca: ldind.i2
		IL_01cb: conv.i2
		IL_01cc: conv.i
		IL_01cd: stloc.0
		IL_01ce: br IL_0028

		IL_01d3: ldarg.1
		IL_01d4: ldc.i4 512
		IL_01d9: beq.s IL_01ab

		IL_01db: ldc.i4 534249477
		IL_01e0: nop
		IL_01e1: stloc 1
		IL_01e5: nop
		IL_01e6: ldloca 1
		IL_01ea: ldind.i2
		IL_01eb: conv.i2
		IL_01ec: conv.i
		IL_01ed: stloc.0
		IL_01ee: br IL_0028

		IL_01f3: br IL_00ef

		IL_01f8: ldc.i4 341508111
		IL_01fd: stloc 1
		IL_0201: ldloca 1
		IL_0205: nop
		IL_0206: ldind.i2
		IL_0207: conv.i2
		IL_0208: conv.i
		IL_0209: stloc.0
		IL_020a: br IL_0028

		IL_020f: br IL_033d

		IL_0214: ldarg.0
		IL_0215: ldc.i4 832
		IL_021a: ldc.i4 768
		IL_021f: call instance void ODCrypt.KeccakDigest::w(int32, int32)
		IL_0224: ret

		IL_0225: ldarg.0
		IL_0226: ldc.i4 1344
		IL_022b: ldc.i4 256
		IL_0230: call instance void ODCrypt.KeccakDigest::w(int32, int32)
		IL_0235: ret

		IL_0236: ldc.i4 1557004299
		IL_023b: nop
		IL_023c: stloc 1
		IL_0240: nop
		IL_0241: ldloca 1
		IL_0245: nop
		IL_0246: ldind.i2
		IL_0247: conv.i2
		IL_0248: conv.i
		IL_0249: stloc.0
		IL_024a: br IL_0028

		IL_024f: ldarg.1
		IL_0250: ldc.i4 288
		IL_0255: beq IL_0149

		IL_025a: ldc.i4 2106785792
		IL_025f: nop
		IL_0260: stloc 1
		IL_0264: ldloca 1
		IL_0268: nop
		IL_0269: ldind.i2
		IL_026a: conv.i2
		IL_026b: conv.i
		IL_026c: stloc.0
		IL_026d: br IL_0028

		IL_0272: br.s IL_02af

		IL_0274: ldc.i4 1871577101
		IL_0279: nop
		IL_027a: stloc 1
		IL_027e: ldloca 1
		IL_0282: ldind.i2
		IL_0283: conv.i2
		IL_0284: conv.i
		IL_0285: stloc.0
		IL_0286: br IL_0028

		IL_028b: ldarg.1
		IL_028c: ldc.i4 128
		IL_0291: beq.s IL_0225

		IL_0293: ldc.i4 1998979076
		IL_0298: nop
		IL_0299: stloc 1
		IL_029d: ldloca 1
		IL_02a1: ldind.i2
		IL_02a2: conv.i2
		IL_02a3: conv.i
		IL_02a4: stloc.0
		IL_02a5: br IL_0028

		IL_02aa: br IL_015a

		IL_02af: br.s IL_02c4

		IL_02b1: ldc.i4 978452480
		IL_02b6: nop
		IL_02b7: stloc 1
		IL_02bb: ldloca 1
		IL_02bf: ldind.i2
		IL_02c0: conv.i2

		IL_02c1: pop
		IL_02c2: br.s IL_02d6

		IL_02c4: ldc.i4 1919549440
		IL_02c9: stloc 1
		IL_02cd: nop
		IL_02ce: ldloca 1
		IL_02d2: ldind.i2
		IL_02d3: conv.i2
		IL_02d4: br.s IL_02c1

		IL_02d6: nop
		IL_02d7: ldc.i4 251527182
		IL_02dc: stloc 1
		IL_02e0: nop
		IL_02e1: ldloca 1
		IL_02e5: ldind.i2
		IL_02e6: conv.i2
		IL_02e7: conv.i
		IL_02e8: stloc.0
		IL_02e9: br IL_0028

		IL_02ee: ldc.i4 688193537
		IL_02f3: stloc 1
		IL_02f7: ldloca 1
		IL_02fb: nop
		IL_02fc: ldind.i2
		IL_02fd: conv.i2
		IL_02fe: br.s IL_0314

		IL_0300: ldc.i4 407109632
		IL_0305: nop
		IL_0306: stloc 1
		IL_030a: nop
		IL_030b: ldloca 1
		IL_030f: nop
		IL_0310: ldind.i2
		IL_0311: conv.i2
		IL_0312: br.s IL_0314

		IL_0314: brfalse.s IL_0316

		IL_0316: ldarg.1
		IL_0317: ldc.i4 384
		IL_031c: beq IL_0214

		IL_0321: ldc.i4 1119748099
		IL_0326: stloc 1
		IL_032a: ldloca 1
		IL_032e: nop
		IL_032f: ldind.i2
		IL_0330: conv.i2
		IL_0331: conv.i
		IL_0332: stloc.0
		IL_0333: br IL_0028

		IL_0338: br IL_01bc

		IL_033d: ldstr "????????n??????????????????????????????????????"
		IL_0342: ldloc 2
		IL_0346: call string ODCrypt.Sha3::b(string, int32)
		IL_034b: ldstr "?????????"
		IL_0350: ldloc 2
		IL_0354: call string ODCrypt.Sha3::b(string, int32)
		IL_0359: newobj instance void [mscorlib]System.ArgumentException::.ctor(string, string)
		IL_035e: throw
	} // end of method KeccakDigest::w

	.method private hidebysig 
		instance void w (
			int32 A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0xd8c0
		// Header size: 12
		// Code size: 573 (0x23d)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int16,
			[2] int32
		)

		IL_0000: ldc.i4 14
		IL_0005: stloc 2
		IL_0009: ldc.i4 272409696
		IL_000e: stloc 1
		IL_0012: nop
		IL_0013: ldloca 1
		IL_0017: ldind.i2
		IL_0018: conv.i2
		IL_0019: ldc.i4 897360992
		IL_001e: stloc 1
		IL_0022: nop
		IL_0023: ldloca 1
		IL_0027: ldind.i2
		IL_0028: conv.i2
		IL_0029: ceq
		IL_002b: switch (IL_00bf, IL_003d, IL_00bf)

		IL_003c: nop

		IL_003d: ldc.i4 918421504
		IL_0042: stloc 1
		IL_0046: nop
		IL_0047: ldloca 1
		IL_004b: nop
		IL_004c: ldind.i2
		IL_004d: conv.i2
		IL_004e: brfalse IL_0053

		IL_0053: ldc.i4 1359216641
		IL_0058: stloc 1
		IL_005c: nop
		IL_005d: ldloca 1
		IL_0061: ldind.i2
		IL_0062: conv.i2
		IL_0063: conv.i
		IL_0064: stloc.0
		IL_0065: br.s IL_0071
		// loop start (head: IL_0071)
			IL_0067: ldc.i4.0
			IL_0068: switch (IL_0097)

			IL_0071: ldloc.0
			IL_0072: switch (IL_00d4, IL_0067, IL_01d9, IL_011a, IL_00ba, IL_0152, IL_01be, IL_0133)
		// end loop

		IL_0097: ldarg.1
		IL_0098: ldarg.2
		IL_0099: add
		IL_009a: ldc.i4 1600
		IL_009f: beq IL_01a7

		IL_00a4: ldc.i4 123863044
		IL_00a9: nop
		IL_00aa: stloc 1
		IL_00ae: nop
		IL_00af: ldloca 1
		IL_00b3: nop
		IL_00b4: ldind.i2
		IL_00b5: conv.i2
		IL_00b6: conv.i
		IL_00b7: stloc.0
		IL_00b8: br.s IL_0071

		IL_00ba: br IL_017f

		IL_00bf: ldc.i4 122748928
		IL_00c4: stloc 1
		IL_00c8: nop
		IL_00c9: ldloca 1
		IL_00cd: nop
		IL_00ce: ldind.i2
		IL_00cf: conv.i2
		IL_00d0: conv.i
		IL_00d1: stloc.0
		IL_00d2: br.s IL_0071

		IL_00d4: ldc.i4 1119879169
		IL_00d9: stloc 1
		IL_00dd: ldloca 1
		IL_00e1: nop
		IL_00e2: ldind.i2
		IL_00e3: conv.i2
		IL_00e4: br.s IL_00f8

		IL_00e6: ldc.i4 1139081216
		IL_00eb: stloc 1
		IL_00ef: ldloca 1
		IL_00f3: nop
		IL_00f4: ldind.i2
		IL_00f5: conv.i2
		IL_00f6: br.s IL_00f8

		IL_00f8: brfalse.s IL_00fa

		IL_00fa: ldarg.1
		IL_00fb: ldc.i4.s 64
		IL_00fd: rem
		IL_00fe: brfalse IL_01de

		IL_0103: ldc.i4 898170883
		IL_0108: stloc 1
		IL_010c: ldloca 1
		IL_0110: nop
		IL_0111: ldind.i2
		IL_0112: conv.i2
		IL_0113: conv.i
		IL_0114: stloc.0
		IL_0115: br IL_0071

		IL_011a: br.s IL_0193

		IL_011c: ldc.i4 1347747847
		IL_0121: nop
		IL_0122: stloc 1
		IL_0126: ldloca 1
		IL_012a: ldind.i2
		IL_012b: conv.i2
		IL_012c: conv.i
		IL_012d: stloc.0
		IL_012e: br IL_0071

		IL_0133: ldarg.1
		IL_0134: ldc.i4 1600
		IL_0139: bge.s IL_0193

		IL_013b: ldc.i4 1677262853
		IL_0140: nop
		IL_0141: stloc 1
		IL_0145: ldloca 1
		IL_0149: ldind.i2
		IL_014a: conv.i2
		IL_014b: conv.i
		IL_014c: stloc.0
		IL_014d: br IL_0071

		IL_0152: br.s IL_0167

		IL_0154: ldc.i4 1047265280
		IL_0159: stloc 1
		IL_015d: ldloca 1
		IL_0161: nop
		IL_0162: ldind.i2
		IL_0163: conv.i2

		IL_0164: pop
		IL_0165: br.s IL_0179

		IL_0167: ldc.i4 450494464
		IL_016c: stloc 1
		IL_0170: ldloca 1
		IL_0174: nop
		IL_0175: ldind.i2
		IL_0176: conv.i2
		IL_0177: br.s IL_0164

		IL_0179: nop
		IL_017a: br IL_00bf

		IL_017f: ldstr "???????????????????????"
		IL_0184: ldloc 2
		IL_0188: call string ODCrypt.Sha3::b(string, int32)
		IL_018d: newobj instance void [mscorlib]System.InvalidOperationException::.ctor(string)
		IL_0192: throw

		IL_0193: ldstr "????k?????????????"
		IL_0198: ldloc 2
		IL_019c: call string ODCrypt.Sha3::b(string, int32)
		IL_01a1: newobj instance void [mscorlib]System.InvalidOperationException::.ctor(string)
		IL_01a6: throw

		IL_01a7: ldc.i4 717291526
		IL_01ac: stloc 1
		IL_01b0: nop
		IL_01b1: ldloca 1
		IL_01b5: ldind.i2
		IL_01b6: conv.i2
		IL_01b7: conv.i
		IL_01b8: stloc.0
		IL_01b9: br IL_0071

		IL_01be: ldarg.1
		IL_01bf: ldc.i4.0
		IL_01c0: ble.s IL_0193

		IL_01c2: ldc.i4 983826434
		IL_01c7: stloc 1
		IL_01cb: ldloca 1
		IL_01cf: nop
		IL_01d0: ldind.i2
		IL_01d1: conv.i2
		IL_01d2: conv.i
		IL_01d3: stloc.0
		IL_01d4: br IL_0071

		IL_01d9: br IL_011c

		IL_01de: ldarg.0
		IL_01df: ldarg.1
		IL_01e0: stfld int32 ODCrypt.KeccakDigest::rate
		IL_01e5: ldarg.0
		IL_01e6: ldc.i4.0
		IL_01e7: stfld int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_01ec: ldarg.0
		IL_01ed: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_01f2: ldc.i4.0
		IL_01f3: call void ODCrypt.Arrays::Fill(uint8[], uint8)
		IL_01f8: ldarg.0
		IL_01f9: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_01fe: ldc.i4.0
		IL_01ff: call void ODCrypt.Arrays::Fill(uint8[], uint8)
		IL_0204: ldarg.0
		IL_0205: ldc.i4.0
		IL_0206: stfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_020b: ldarg.0
		IL_020c: ldc.i4.0
		IL_020d: stfld bool ODCrypt.KeccakDigest::squeezing
		IL_0212: ldarg.0
		IL_0213: ldc.i4.0
		IL_0214: stfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_0219: ldarg.0
		IL_021a: ldarg.2
		IL_021b: ldc.i4.2
		IL_021c: div
		IL_021d: stfld int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_0222: ldarg.0
		IL_0223: ldarg.1
		IL_0224: ldc.i4.8
		IL_0225: div
		IL_0226: newarr [mscorlib]System.Byte
		IL_022b: stfld uint8[] ODCrypt.KeccakDigest::chunk
		IL_0230: ldarg.0
		IL_0231: ldc.i4.1
		IL_0232: newarr [mscorlib]System.Byte
		IL_0237: stfld uint8[] ODCrypt.KeccakDigest::oneByte
		IL_023c: ret
	} // end of method KeccakDigest::w

	.method private hidebysig 
		instance void r () cil managed 
	{
		// Method begins at RVA 0xdb0c
		// Header size: 12
		// Code size: 191 (0xbf)
		.maxstack 5
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 2011365377
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: ldloca 0
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: br.s IL_0026

		IL_0013: ldc.i4 915013632
		IL_0018: stloc 0
		IL_001c: nop
		IL_001d: ldloca 0
		IL_0021: nop
		IL_0022: ldind.i2
		IL_0023: conv.i2
		IL_0024: br.s IL_0026

		IL_0026: brfalse.s IL_0028

		IL_0028: br.s IL_003e

		IL_002a: ldc.i4 355270656
		IL_002f: nop
		IL_0030: stloc 0
		IL_0034: nop
		IL_0035: ldloca 0
		IL_0039: ldind.i2
		IL_003a: conv.i2

		IL_003b: pop
		IL_003c: br.s IL_0051

		IL_003e: ldc.i4 1287782400
		IL_0043: stloc 0
		IL_0047: nop
		IL_0048: ldloca 0
		IL_004c: nop
		IL_004d: ldind.i2
		IL_004e: conv.i2
		IL_004f: br.s IL_003b

		IL_0051: nop
		IL_0052: ldc.i4 225130329
		IL_0057: nop
		IL_0058: stloc 0
		IL_005c: ldloca 0
		IL_0060: nop
		IL_0061: ldind.i2
		IL_0062: conv.i2
		IL_0063: ldc.i4 2014263129
		IL_0068: nop
		IL_0069: stloc 0
		IL_006d: ldloca 0
		IL_0071: ldind.i2
		IL_0072: conv.i2
		IL_0073: ceq
		IL_0075: switch (IL_0086, IL_0087, IL_0086)

		IL_0086: nop

		IL_0087: ldc.i4 454950912
		IL_008c: nop
		IL_008d: stloc 0
		IL_0091: ldloca 0
		IL_0095: nop
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: brfalse IL_009d

		IL_009d: ldarg.0
		IL_009e: ldarg.0
		IL_009f: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_00a4: ldarg.0
		IL_00a5: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_00aa: ldarg.0
		IL_00ab: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_00b0: ldc.i4.8
		IL_00b1: div
		IL_00b2: call instance void ODCrypt.KeccakDigest::r(uint8[], uint8[], int32)
		IL_00b7: ldarg.0
		IL_00b8: ldc.i4.0
		IL_00b9: stfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_00be: ret
	} // end of method KeccakDigest::r

	.method family hidebysig newslot virtual 
		instance void Absorb (
			uint8[] data,
			int32 off,
			int64 databitlen
		) cil managed 
	{
		// Method begins at RVA 0xdbd8
		// Header size: 12
		// Code size: 1476 (0x5c4)
		.maxstack 6
		.locals init (
			[0] int64,
			[1] int64,
			[2] int64,
			[3] int32,
			[4] int32,
			[5] int32,
			[6] int32,
			[7] int16,
			[8] int32
		)

		IL_0000: ldc.i4 12
		IL_0005: stloc 8
		IL_0009: ldc.i4 1097400320
		IL_000e: stloc 7
		IL_0012: nop
		IL_0013: ldloca 7
		IL_0017: nop
		IL_0018: ldind.i2
		IL_0019: conv.i2
		IL_001a: stloc.s 6
		IL_001c: ldloc.s 6
		IL_001e: switch (IL_0027)

		IL_0027: ldc.i4 5177347
		IL_002c: nop
		IL_002d: stloc 7
		IL_0031: ldloca 7
		IL_0035: nop
		IL_0036: ldind.i2
		IL_0037: conv.i2
		IL_0038: conv.i
		IL_0039: stloc.s 6
		IL_003b: br.s IL_0047
		// loop start (head: IL_0047)
			IL_003d: ldc.i4.0
			IL_003e: switch (IL_00ba)

			IL_0047: ldloc.s 6
			IL_0049: switch (IL_0341, IL_00e0, IL_0513, IL_003d, IL_010b, IL_01ed, IL_0438, IL_0456, IL_05be, IL_056b, IL_0129, IL_038c, IL_0188, IL_016b, IL_01c8, IL_0419, IL_02bf, IL_0265, IL_04e5, IL_0324, IL_014a, IL_0210, IL_047d, IL_01aa, IL_04bf, IL_0595, IL_03af)
		// end loop

		IL_00ba: ldarg.0
		IL_00bb: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_00c0: ldc.i4.8
		IL_00c1: rem
		IL_00c2: brfalse IL_01af

		IL_00c7: ldc.i4 1824653313
		IL_00cc: nop
		IL_00cd: stloc 7
		IL_00d1: ldloca 7
		IL_00d5: nop
		IL_00d6: ldind.i2
		IL_00d7: conv.i2
		IL_00d8: conv.i
		IL_00d9: stloc.s 6
		IL_00db: br IL_0047

		IL_00e0: br IL_047f

		IL_00e5: ldarg.0
		IL_00e6: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_00eb: ldarg.0
		IL_00ec: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_00f1: sub
		IL_00f2: stloc.3
		IL_00f3: ldc.i4 289800196
		IL_00f8: stloc 7
		IL_00fc: ldloca 7
		IL_0100: nop
		IL_0101: ldind.i2
		IL_0102: conv.i2
		IL_0103: conv.i
		IL_0104: stloc.s 6
		IL_0106: br IL_0047

		IL_010b: br IL_0518

		IL_0110: ldc.i4 973209610
		IL_0115: nop
		IL_0116: stloc 7
		IL_011a: nop
		IL_011b: ldloca 7
		IL_011f: ldind.i2
		IL_0120: conv.i2
		IL_0121: conv.i
		IL_0122: stloc.s 6
		IL_0124: br IL_0047

		IL_0129: ldloc.1
		IL_012a: ldloc.2
		IL_012b: blt IL_02c4

		IL_0130: ldc.i4 545521684
		IL_0135: nop
		IL_0136: stloc 7
		IL_013a: nop
		IL_013b: ldloca 7
		IL_013f: nop
		IL_0140: ldind.i2
		IL_0141: conv.i2
		IL_0142: conv.i
		IL_0143: stloc.s 6
		IL_0145: br IL_0047

		IL_014a: br IL_059a

		IL_014f: ldc.i4.0
		IL_0150: conv.i8
		IL_0151: stloc.0
		IL_0152: ldc.i4 399704077
		IL_0157: nop
		IL_0158: stloc 7
		IL_015c: ldloca 7
		IL_0160: nop
		IL_0161: ldind.i2
		IL_0162: conv.i2
		IL_0163: conv.i
		IL_0164: stloc.s 6
		IL_0166: br IL_0047

		IL_016b: br IL_03b4

		IL_0170: ldc.i4 1064632332
		IL_0175: nop
		IL_0176: stloc 7
		IL_017a: ldloca 7
		IL_017e: ldind.i2
		IL_017f: conv.i2
		IL_0180: conv.i
		IL_0181: stloc.s 6
		IL_0183: br IL_0047

		IL_0188: ldloc.s 4
		IL_018a: ldc.i4.0
		IL_018b: ble IL_03b4

		IL_0190: ldc.i4 704970775
		IL_0195: nop
		IL_0196: stloc 7
		IL_019a: nop
		IL_019b: ldloca 7
		IL_019f: nop
		IL_01a0: ldind.i2
		IL_01a1: conv.i2
		IL_01a2: conv.i
		IL_01a3: stloc.s 6
		IL_01a5: br IL_0047

		IL_01aa: br IL_026a

		IL_01af: ldc.i4 206700558
		IL_01b4: stloc 7
		IL_01b8: nop
		IL_01b9: ldloca 7
		IL_01bd: nop
		IL_01be: ldind.i2
		IL_01bf: conv.i2
		IL_01c0: conv.i
		IL_01c1: stloc.s 6
		IL_01c3: br IL_0047

		IL_01c8: ldarg.0
		IL_01c9: ldfld bool ODCrypt.KeccakDigest::squeezing
		IL_01ce: brfalse IL_014f

		IL_01d3: ldc.i4 1556217861
		IL_01d8: nop
		IL_01d9: stloc 7
		IL_01dd: nop
		IL_01de: ldloca 7
		IL_01e2: nop
		IL_01e3: ldind.i2
		IL_01e4: conv.i2
		IL_01e5: conv.i
		IL_01e6: stloc.s 6
		IL_01e8: br IL_0047

		IL_01ed: br IL_0493

		IL_01f2: ldarg.3
		IL_01f3: ldloc.0
		IL_01f4: sub
		IL_01f5: conv.i4
		IL_01f6: stloc.3
		IL_01f7: ldc.i4 142934037
		IL_01fc: nop
		IL_01fd: stloc 7
		IL_0201: ldloca 7
		IL_0205: nop
		IL_0206: ldind.i2
		IL_0207: conv.i2
		IL_0208: conv.i
		IL_0209: stloc.s 6
		IL_020b: br IL_0047

		IL_0210: ldloc.3
		IL_0211: ldarg.0
		IL_0212: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0217: add
		IL_0218: ldarg.0
		IL_0219: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_021e: ble IL_0518

		IL_0223: br.s IL_023a

		IL_0225: ldc.i4 1811480576
		IL_022a: nop
		IL_022b: stloc 7
		IL_022f: nop
		IL_0230: ldloca 7
		IL_0234: nop
		IL_0235: ldind.i2
		IL_0236: conv.i2

		IL_0237: pop
		IL_0238: br.s IL_024c

		IL_023a: ldc.i4 92930048
		IL_023f: stloc 7
		IL_0243: ldloca 7
		IL_0247: nop
		IL_0248: ldind.i2
		IL_0249: conv.i2
		IL_024a: br.s IL_0237

		IL_024c: nop
		IL_024d: ldc.i4 834797585
		IL_0252: nop
		IL_0253: stloc 7
		IL_0257: ldloca 7
		IL_025b: ldind.i2
		IL_025c: conv.i2
		IL_025d: conv.i
		IL_025e: stloc.s 6
		IL_0260: br IL_0047

		IL_0265: br IL_00e5

		IL_026a: ldc.i4.1
		IL_026b: ldloc.s 4
		IL_026d: ldc.i4.s 31
		IL_026f: and
		IL_0270: shl
		IL_0271: ldc.i4.1
		IL_0272: sub
		IL_0273: stloc.s 5
		IL_0275: ldarg.0
		IL_0276: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_027b: ldarg.0
		IL_027c: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0281: ldc.i4.8
		IL_0282: div
		IL_0283: ldarg.1
		IL_0284: ldarg.2
		IL_0285: ldloc.0
		IL_0286: ldc.i4.8
		IL_0287: conv.i8
		IL_0288: div
		IL_0289: conv.i4
		IL_028a: add
		IL_028b: ldelem.u1
		IL_028c: ldloc.s 5
		IL_028e: and
		IL_028f: conv.u1
		IL_0290: stelem.i1
		IL_0291: ldarg.0
		IL_0292: ldarg.0
		IL_0293: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0298: ldloc.s 4
		IL_029a: add
		IL_029b: stfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_02a0: ldloc.0
		IL_02a1: ldloc.s 4
		IL_02a3: conv.i8
		IL_02a4: add
		IL_02a5: stloc.0
		IL_02a6: ldc.i4 97189904
		IL_02ab: stloc 7
		IL_02af: nop
		IL_02b0: ldloca 7
		IL_02b4: nop
		IL_02b5: ldind.i2
		IL_02b6: conv.i2
		IL_02b7: conv.i
		IL_02b8: stloc.s 6
		IL_02ba: br IL_0047

		IL_02bf: br IL_03b4

		IL_02c4: ldarg.1
		IL_02c5: ldarg.2
		IL_02c6: conv.i8
		IL_02c7: ldloc.0
		IL_02c8: ldc.i4.8
		IL_02c9: conv.i8
		IL_02ca: div
		IL_02cb: add
		IL_02cc: ldloc.1
		IL_02cd: ldarg.0
		IL_02ce: ldfld uint8[] ODCrypt.KeccakDigest::chunk
		IL_02d3: ldlen
		IL_02d4: conv.i4
		IL_02d5: conv.i8
		IL_02d6: mul
		IL_02d7: add
		IL_02d8: conv.i4
		IL_02d9: ldarg.0
		IL_02da: ldfld uint8[] ODCrypt.KeccakDigest::chunk
		IL_02df: ldc.i4.0
		IL_02e0: ldarg.0
		IL_02e1: ldfld uint8[] ODCrypt.KeccakDigest::chunk
		IL_02e6: ldlen
		IL_02e7: conv.i4
		IL_02e8: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_02ed: ldarg.0
		IL_02ee: ldarg.0
		IL_02ef: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_02f4: ldarg.0
		IL_02f5: ldfld uint8[] ODCrypt.KeccakDigest::chunk
		IL_02fa: ldarg.0
		IL_02fb: ldfld uint8[] ODCrypt.KeccakDigest::chunk
		IL_0300: ldlen
		IL_0301: conv.i4
		IL_0302: call instance void ODCrypt.KeccakDigest::r(uint8[], uint8[], int32)
		IL_0307: ldloc.1
		IL_0308: ldc.i4.1
		IL_0309: conv.i8
		IL_030a: add
		IL_030b: stloc.1
		IL_030c: ldc.i4 407633939
		IL_0311: stloc 7
		IL_0315: ldloca 7
		IL_0319: nop
		IL_031a: ldind.i2
		IL_031b: conv.i2
		IL_031c: conv.i
		IL_031d: stloc.s 6
		IL_031f: br IL_0047

		IL_0324: br IL_0110

		IL_0329: ldc.i4 1514668032
		IL_032e: nop
		IL_032f: stloc 7
		IL_0333: ldloca 7
		IL_0337: ldind.i2
		IL_0338: conv.i2
		IL_0339: conv.i
		IL_033a: stloc.s 6
		IL_033c: br IL_0047

		IL_0341: ldarg.0
		IL_0342: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0347: brtrue IL_01f2

		IL_034c: ldc.i4 804454401
		IL_0351: stloc 7
		IL_0355: nop
		IL_0356: ldloca 7
		IL_035a: nop
		IL_035b: ldind.i2
		IL_035c: conv.i2
		IL_035d: br.s IL_0372

		IL_035f: ldc.i4 517603328
		IL_0364: nop
		IL_0365: stloc 7
		IL_0369: nop
		IL_036a: ldloca 7
		IL_036e: ldind.i2
		IL_036f: conv.i2
		IL_0370: br.s IL_0372

		IL_0372: brfalse.s IL_0374

		IL_0374: ldc.i4 1388511243
		IL_0379: stloc 7
		IL_037d: nop
		IL_037e: ldloca 7
		IL_0382: ldind.i2
		IL_0383: conv.i2
		IL_0384: conv.i
		IL_0385: stloc.s 6
		IL_0387: br IL_0047

		IL_038c: br IL_04a7

		IL_0391: ldarg.0
		IL_0392: call instance void ODCrypt.KeccakDigest::r()
		IL_0397: ldc.i4 889061402
		IL_039c: stloc 7
		IL_03a0: nop
		IL_03a1: ldloca 7
		IL_03a5: ldind.i2
		IL_03a6: conv.i2
		IL_03a7: conv.i
		IL_03a8: stloc.s 6
		IL_03aa: br IL_0047

		IL_03af: br IL_0170

		IL_03b4: ldc.i4 673722735
		IL_03b9: nop
		IL_03ba: stloc 7
		IL_03be: ldloca 7
		IL_03c2: nop
		IL_03c3: ldind.i2
		IL_03c4: conv.i2
		IL_03c5: ldc.i4 1461989743
		IL_03ca: nop
		IL_03cb: stloc 7
		IL_03cf: nop
		IL_03d0: ldloca 7
		IL_03d4: ldind.i2
		IL_03d5: conv.i2
		IL_03d6: ceq
		IL_03d8: switch (IL_0456, IL_03ea, IL_0456)

		IL_03e9: nop

		IL_03ea: ldc.i4 1875312640
		IL_03ef: stloc 7
		IL_03f3: nop
		IL_03f4: ldloca 7
		IL_03f8: nop
		IL_03f9: ldind.i2
		IL_03fa: conv.i2
		IL_03fb: brfalse IL_0400

		IL_0400: ldc.i4 1351942159
		IL_0405: nop
		IL_0406: stloc 7
		IL_040a: ldloca 7
		IL_040e: nop
		IL_040f: ldind.i2
		IL_0410: conv.i2
		IL_0411: conv.i
		IL_0412: stloc.s 6
		IL_0414: br IL_0047

		IL_0419: ldloc.0
		IL_041a: ldarg.3
		IL_041b: blt IL_0329

		IL_0420: ldc.i4 697761798
		IL_0425: stloc 7
		IL_0429: ldloca 7
		IL_042d: nop
		IL_042e: ldind.i2
		IL_042f: conv.i2
		IL_0430: conv.i
		IL_0431: stloc.s 6
		IL_0433: br IL_0047

		IL_0438: br IL_05c3

		IL_043d: ldc.i4 582287367
		IL_0442: stloc 7
		IL_0446: nop
		IL_0447: ldloca 7
		IL_044b: nop
		IL_044c: ldind.i2
		IL_044d: conv.i2
		IL_044e: conv.i
		IL_044f: stloc.s 6
		IL_0451: br IL_0047

		IL_0456: ldloc.0
		IL_0457: ldarg.3
		IL_0458: ldarg.0
		IL_0459: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_045e: conv.i8
		IL_045f: sub
		IL_0460: bgt IL_01f2

		IL_0465: ldc.i4 138936342
		IL_046a: nop
		IL_046b: stloc 7
		IL_046f: ldloca 7
		IL_0473: ldind.i2
		IL_0474: conv.i2
		IL_0475: conv.i
		IL_0476: stloc.s 6
		IL_0478: br IL_0047

		IL_047d: br.s IL_04ea

		IL_047f: ldstr "???????????????????????????????????\udda7?\ud9ab??"
		IL_0484: ldloc 8
		IL_0488: call string ODCrypt.Sha3::b(string, int32)
		IL_048d: newobj instance void [mscorlib]System.InvalidOperationException::.ctor(string)
		IL_0492: throw

		IL_0493: ldstr "??????????????????????????????????"
		IL_0498: ldloc 8
		IL_049c: call string ODCrypt.Sha3::b(string, int32)
		IL_04a1: newobj instance void [mscorlib]System.InvalidOperationException::.ctor(string)
		IL_04a6: throw

		IL_04a7: ldc.i4 897974296
		IL_04ac: stloc 7
		IL_04b0: ldloca 7
		IL_04b4: nop
		IL_04b5: ldind.i2
		IL_04b6: conv.i2
		IL_04b7: conv.i
		IL_04b8: stloc.s 6
		IL_04ba: br IL_0047

		IL_04bf: ldarg.3
		IL_04c0: ldarg.0
		IL_04c1: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_04c6: conv.i8
		IL_04c7: blt IL_01f2

		IL_04cc: ldc.i4 540082194
		IL_04d1: nop
		IL_04d2: stloc 7
		IL_04d6: ldloca 7
		IL_04da: nop
		IL_04db: ldind.i2
		IL_04dc: conv.i2
		IL_04dd: conv.i
		IL_04de: stloc.s 6
		IL_04e0: br IL_0047

		IL_04e5: br IL_043d

		IL_04ea: ldarg.3
		IL_04eb: ldloc.0
		IL_04ec: sub
		IL_04ed: ldarg.0
		IL_04ee: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_04f3: conv.i8
		IL_04f4: div
		IL_04f5: stloc.2
		IL_04f6: ldc.i4.0
		IL_04f7: conv.i8
		IL_04f8: stloc.1
		IL_04f9: ldc.i4 1764687874
		IL_04fe: nop
		IL_04ff: stloc 7
		IL_0503: nop
		IL_0504: ldloca 7
		IL_0508: nop
		IL_0509: ldind.i2
		IL_050a: conv.i2
		IL_050b: conv.i
		IL_050c: stloc.s 6
		IL_050e: br IL_0047

		IL_0513: br IL_0110

		IL_0518: ldloc.3
		IL_0519: ldc.i4.8
		IL_051a: rem
		IL_051b: stloc.s 4
		IL_051d: ldloc.3
		IL_051e: ldloc.s 4
		IL_0520: sub
		IL_0521: stloc.3
		IL_0522: ldarg.1
		IL_0523: ldarg.2
		IL_0524: ldloc.0
		IL_0525: ldc.i4.8
		IL_0526: conv.i8
		IL_0527: div
		IL_0528: conv.i4
		IL_0529: add
		IL_052a: ldarg.0
		IL_052b: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_0530: ldarg.0
		IL_0531: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0536: ldc.i4.8
		IL_0537: div
		IL_0538: ldloc.3
		IL_0539: ldc.i4.8
		IL_053a: div
		IL_053b: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_0540: ldarg.0
		IL_0541: ldarg.0
		IL_0542: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0547: ldloc.3
		IL_0548: add
		IL_0549: stfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_054e: ldloc.0
		IL_054f: ldloc.3
		IL_0550: conv.i8
		IL_0551: add
		IL_0552: stloc.0
		IL_0553: ldc.i4 1156644873
		IL_0558: stloc 7
		IL_055c: ldloca 7
		IL_0560: nop
		IL_0561: ldind.i2
		IL_0562: conv.i2
		IL_0563: conv.i
		IL_0564: stloc.s 6
		IL_0566: br IL_0047

		IL_056b: ldarg.0
		IL_056c: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0571: ldarg.0
		IL_0572: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_0577: bne.un IL_0170

		IL_057c: ldc.i4 630063129
		IL_0581: stloc 7
		IL_0585: nop
		IL_0586: ldloca 7
		IL_058a: nop
		IL_058b: ldind.i2
		IL_058c: conv.i2
		IL_058d: conv.i
		IL_058e: stloc.s 6
		IL_0590: br IL_0047

		IL_0595: br IL_0391

		IL_059a: ldloc.0
		IL_059b: ldloc.2
		IL_059c: ldarg.0
		IL_059d: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_05a2: conv.i8
		IL_05a3: mul
		IL_05a4: add
		IL_05a5: stloc.0
		IL_05a6: ldc.i4 1834024968
		IL_05ab: stloc 7
		IL_05af: nop
		IL_05b0: ldloca 7
		IL_05b4: ldind.i2
		IL_05b5: conv.i2
		IL_05b6: conv.i
		IL_05b7: stloc.s 6
		IL_05b9: br IL_0047

		IL_05be: br IL_03b4

		IL_05c3: ret
	} // end of method KeccakDigest::Absorb

	.method private hidebysig 
		instance void w () cil managed 
	{
		// Method begins at RVA 0xe1a8
		// Header size: 12
		// Code size: 706 (0x2c2)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] int16
		)

		IL_0000: ldc.i4 1358261280
		IL_0005: nop
		IL_0006: stloc 1
		IL_000a: nop
		IL_000b: ldloca 1
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 1447455776
		IL_0017: nop
		IL_0018: stloc 1
		IL_001c: ldloca 1
		IL_0020: nop
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: ceq
		IL_0025: switch (IL_00b8, IL_0037, IL_00b8)

		IL_0036: nop

		IL_0037: ldc.i4 766115840
		IL_003c: stloc 1
		IL_0040: nop
		IL_0041: ldloca 1
		IL_0045: ldind.i2
		IL_0046: conv.i2
		IL_0047: brfalse IL_004c

		IL_004c: ldc.i4 332267521
		IL_0051: stloc 1
		IL_0055: nop
		IL_0056: ldloca 1
		IL_005a: nop
		IL_005b: ldind.i2
		IL_005c: conv.i2
		IL_005d: conv.i
		IL_005e: stloc.0
		IL_005f: br.s IL_006b
		// loop start (head: IL_006b)
			IL_0061: ldc.i4.0
			IL_0062: switch (IL_0091)

			IL_006b: ldloc.0
			IL_006c: switch (IL_00f1, IL_0061, IL_02b5, IL_013d, IL_00b8, IL_01bb, IL_0229, IL_0164)
		// end loop

		IL_0091: ldarg.0
		IL_0092: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0097: ldc.i4.1
		IL_0098: add
		IL_0099: ldarg.0
		IL_009a: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_009f: bne.un IL_0254

		IL_00a4: ldc.i4 1565589508
		IL_00a9: stloc 1
		IL_00ad: ldloca 1
		IL_00b1: nop
		IL_00b2: ldind.i2
		IL_00b3: conv.i2
		IL_00b4: conv.i
		IL_00b5: stloc.0
		IL_00b6: br.s IL_006b

		IL_00b8: br IL_0169

		IL_00bd: ldarg.0
		IL_00be: ldarg.0
		IL_00bf: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_00c4: ldarg.0
		IL_00c5: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_00ca: call instance void ODCrypt.KeccakDigest::w(uint8[], uint8[])
		IL_00cf: ldarg.0
		IL_00d0: ldc.i4 1024
		IL_00d5: stfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_00da: ldc.i4 1530396672
		IL_00df: stloc 1
		IL_00e3: ldloca 1
		IL_00e7: nop
		IL_00e8: ldind.i2
		IL_00e9: conv.i2
		IL_00ea: conv.i
		IL_00eb: stloc.0
		IL_00ec: br IL_006b

		IL_00f1: br IL_02ba

		IL_00f6: ldarg.0
		IL_00f7: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_00fc: ldarg.0
		IL_00fd: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_0102: ldc.i4.1
		IL_0103: sub
		IL_0104: ldc.i4.8
		IL_0105: div
		IL_0106: ldelema [mscorlib]System.Byte
		IL_010b: dup
		IL_010c: ldind.u1
		IL_010d: ldc.i4.1
		IL_010e: ldarg.0
		IL_010f: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_0114: ldc.i4.1
		IL_0115: sub
		IL_0116: ldc.i4.8
		IL_0117: rem
		IL_0118: ldc.i4.s 31
		IL_011a: and
		IL_011b: shl
		IL_011c: conv.u1
		IL_011d: or
		IL_011e: conv.u1
		IL_011f: stind.i1
		IL_0120: ldarg.0
		IL_0121: call instance void ODCrypt.KeccakDigest::r()
		IL_0126: ldc.i4 1056571395
		IL_012b: stloc 1
		IL_012f: nop
		IL_0130: ldloca 1
		IL_0134: ldind.i2
		IL_0135: conv.i2
		IL_0136: conv.i
		IL_0137: stloc.0
		IL_0138: br IL_006b

		IL_013d: ldarg.0
		IL_013e: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_0143: ldc.i4 1024
		IL_0148: bne.un IL_01eb

		IL_014d: ldc.i4 1827078151
		IL_0152: stloc 1
		IL_0156: nop
		IL_0157: ldloca 1
		IL_015b: ldind.i2
		IL_015c: conv.i2
		IL_015d: conv.i
		IL_015e: stloc.0
		IL_015f: br IL_006b

		IL_0164: br IL_00bd

		IL_0169: ldarg.0
		IL_016a: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_016f: ldarg.0
		IL_0170: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0175: ldc.i4.8
		IL_0176: div
		IL_0177: ldelema [mscorlib]System.Byte
		IL_017c: dup
		IL_017d: ldind.u1
		IL_017e: ldc.i4.1
		IL_017f: ldarg.0
		IL_0180: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0185: ldc.i4.8
		IL_0186: rem
		IL_0187: ldc.i4.s 31
		IL_0189: and
		IL_018a: shl
		IL_018b: conv.u1
		IL_018c: or
		IL_018d: conv.u1
		IL_018e: stind.i1
		IL_018f: ldarg.0
		IL_0190: call instance void ODCrypt.KeccakDigest::r()
		IL_0195: ldarg.0
		IL_0196: ldc.i4.0
		IL_0197: ldarg.0
		IL_0198: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_019d: ldc.i4.8
		IL_019e: div
		IL_019f: call instance void ODCrypt.KeccakDigest::r(int32, int32)
		IL_01a4: ldc.i4 900595717
		IL_01a9: stloc 1
		IL_01ad: ldloca 1
		IL_01b1: nop
		IL_01b2: ldind.i2
		IL_01b3: conv.i2
		IL_01b4: conv.i
		IL_01b5: stloc.0
		IL_01b6: br IL_006b

		IL_01bb: br.s IL_01d1

		IL_01bd: ldc.i4 1663434752
		IL_01c2: nop
		IL_01c3: stloc 1
		IL_01c7: nop
		IL_01c8: ldloca 1
		IL_01cc: ldind.i2
		IL_01cd: conv.i2

		IL_01ce: pop
		IL_01cf: br.s IL_01e5

		IL_01d1: ldc.i4 98435072
		IL_01d6: nop
		IL_01d7: stloc 1
		IL_01db: nop
		IL_01dc: ldloca 1
		IL_01e0: nop
		IL_01e1: ldind.i2
		IL_01e2: conv.i2
		IL_01e3: br.s IL_01ce

		IL_01e5: nop
		IL_01e6: br IL_00f6

		IL_01eb: ldarg.0
		IL_01ec: ldarg.0
		IL_01ed: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_01f2: ldarg.0
		IL_01f3: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_01f8: ldarg.0
		IL_01f9: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_01fe: ldc.i4.s 64
		IL_0200: div
		IL_0201: call instance void ODCrypt.KeccakDigest::w(uint8[], uint8[], int32)
		IL_0206: ldarg.0
		IL_0207: ldarg.0
		IL_0208: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_020d: stfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_0212: ldc.i4 1703542790
		IL_0217: stloc 1
		IL_021b: ldloca 1
		IL_021f: nop
		IL_0220: ldind.i2
		IL_0221: conv.i2
		IL_0222: conv.i
		IL_0223: stloc.0
		IL_0224: br IL_006b

		IL_0229: ldc.i4 1161166849
		IL_022e: nop
		IL_022f: stloc 1
		IL_0233: nop
		IL_0234: ldloca 1
		IL_0238: nop
		IL_0239: ldind.i2
		IL_023a: conv.i2
		IL_023b: br.s IL_0250

		IL_023d: ldc.i4 394788864
		IL_0242: nop
		IL_0243: stloc 1
		IL_0247: ldloca 1
		IL_024b: nop
		IL_024c: ldind.i2
		IL_024d: conv.i2
		IL_024e: br.s IL_0250

		IL_0250: brfalse.s IL_0252

		IL_0252: br.s IL_02ba

		IL_0254: ldarg.0
		IL_0255: ldarg.0
		IL_0256: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_025b: ldc.i4.7
		IL_025c: add
		IL_025d: ldc.i4.8
		IL_025e: div
		IL_025f: ldarg.0
		IL_0260: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_0265: ldc.i4.8
		IL_0266: div
		IL_0267: ldarg.0
		IL_0268: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_026d: ldc.i4.7
		IL_026e: add
		IL_026f: ldc.i4.8
		IL_0270: div
		IL_0271: sub
		IL_0272: call instance void ODCrypt.KeccakDigest::r(int32, int32)
		IL_0277: ldarg.0
		IL_0278: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_027d: ldarg.0
		IL_027e: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0283: ldc.i4.8
		IL_0284: div
		IL_0285: ldelema [mscorlib]System.Byte
		IL_028a: dup
		IL_028b: ldind.u1
		IL_028c: ldc.i4.1
		IL_028d: ldarg.0
		IL_028e: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_0293: ldc.i4.8
		IL_0294: rem
		IL_0295: ldc.i4.s 31
		IL_0297: and
		IL_0298: shl
		IL_0299: conv.u1
		IL_029a: or
		IL_029b: conv.u1
		IL_029c: stind.i1
		IL_029d: ldc.i4 353173506
		IL_02a2: nop
		IL_02a3: stloc 1
		IL_02a7: ldloca 1
		IL_02ab: nop
		IL_02ac: ldind.i2
		IL_02ad: conv.i2
		IL_02ae: conv.i
		IL_02af: stloc.0
		IL_02b0: br IL_006b

		IL_02b5: br IL_00f6

		IL_02ba: ldarg.0
		IL_02bb: ldc.i4.1
		IL_02bc: stfld bool ODCrypt.KeccakDigest::squeezing
		IL_02c1: ret
	} // end of method KeccakDigest::w

	.method family hidebysig newslot virtual 
		instance void Squeeze (
			uint8[] output,
			int32 offset,
			int64 outputLength
		) cil managed 
	{
		// Method begins at RVA 0xe478
		// Header size: 12
		// Code size: 965 (0x3c5)
		.maxstack 6
		.locals init (
			[0] int64,
			[1] int32,
			[2] int32,
			[3] int16,
			[4] int32
		)

		IL_0000: ldc.i4 16
		IL_0005: stloc 4
		IL_0009: ldc.i4 249364481
		IL_000e: nop
		IL_000f: stloc 3
		IL_0013: nop
		IL_0014: ldloca 3
		IL_0018: nop
		IL_0019: ldind.i2
		IL_001a: conv.i2
		IL_001b: conv.i
		IL_001c: stloc.2
		IL_001d: br.s IL_0029
		// loop start (head: IL_0029)
			IL_001f: ldc.i4.0
			IL_0020: switch (IL_0077)

			IL_0029: ldloc.2
			IL_002a: switch (IL_034f, IL_001f, IL_0326, IL_0097, IL_025e, IL_00d8, IL_02a5, IL_0241, IL_0177, IL_0397, IL_01b3, IL_00ba, IL_0193, IL_02e4, IL_0112, IL_0303, IL_0377, IL_02c2)
		// end loop

		IL_0077: ldarg.0
		IL_0078: ldfld bool ODCrypt.KeccakDigest::squeezing
		IL_007d: brtrue IL_017c

		IL_0082: ldc.i4 1567686659
		IL_0087: nop
		IL_0088: stloc 3
		IL_008c: nop
		IL_008d: ldloca 3
		IL_0091: ldind.i2
		IL_0092: conv.i2
		IL_0093: conv.i
		IL_0094: stloc.2
		IL_0095: br.s IL_0029

		IL_0097: br IL_02e6

		IL_009c: ldarg.0
		IL_009d: ldfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_00a2: stloc.1
		IL_00a3: ldc.i4 2122448907
		IL_00a8: stloc 3
		IL_00ac: ldloca 3
		IL_00b0: nop
		IL_00b1: ldind.i2
		IL_00b2: conv.i2
		IL_00b3: conv.i
		IL_00b4: stloc.2
		IL_00b5: br IL_0029

		IL_00ba: ldloc.1
		IL_00bb: conv.i8
		IL_00bc: ldarg.3
		IL_00bd: ldloc.0
		IL_00be: sub
		IL_00bf: ble.s IL_0128

		IL_00c1: ldc.i4 1854144517
		IL_00c6: stloc 3
		IL_00ca: ldloca 3
		IL_00ce: nop
		IL_00cf: ldind.i2
		IL_00d0: conv.i2
		IL_00d1: conv.i
		IL_00d2: stloc.2
		IL_00d3: br IL_0029

		IL_00d8: br IL_0308

		IL_00dd: ldarg.0
		IL_00de: ldarg.0
		IL_00df: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_00e4: ldarg.0
		IL_00e5: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_00ea: call instance void ODCrypt.KeccakDigest::w(uint8[], uint8[])
		IL_00ef: ldarg.0
		IL_00f0: ldc.i4 1024
		IL_00f5: stfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_00fa: ldc.i4 1670840334
		IL_00ff: nop
		IL_0100: stloc 3
		IL_0104: nop
		IL_0105: ldloca 3
		IL_0109: ldind.i2
		IL_010a: conv.i2
		IL_010b: conv.i
		IL_010c: stloc.2
		IL_010d: br IL_0029

		IL_0112: br.s IL_009c

		IL_0114: ldstr "????????????????????????????????"
		IL_0119: ldloc 4
		IL_011d: call string ODCrypt.Sha3::b(string, int32)
		IL_0122: newobj instance void [mscorlib]System.InvalidOperationException::.ctor(string)
		IL_0127: throw

		IL_0128: ldarg.0
		IL_0129: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_012e: ldarg.0
		IL_012f: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_0134: ldarg.0
		IL_0135: ldfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_013a: sub
		IL_013b: ldc.i4.8
		IL_013c: div
		IL_013d: ldarg.1
		IL_013e: ldarg.2
		IL_013f: ldloc.0
		IL_0140: ldc.i4.8
		IL_0141: conv.i8
		IL_0142: div
		IL_0143: conv.i4
		IL_0144: add
		IL_0145: ldloc.1
		IL_0146: ldc.i4.8
		IL_0147: div
		IL_0148: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_014d: ldarg.0
		IL_014e: ldarg.0
		IL_014f: ldfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_0154: ldloc.1
		IL_0155: sub
		IL_0156: stfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_015b: ldloc.0
		IL_015c: ldloc.1
		IL_015d: conv.i8
		IL_015e: add
		IL_015f: stloc.0
		IL_0160: ldc.i4 1958412296
		IL_0165: nop
		IL_0166: stloc 3
		IL_016a: ldloca 3
		IL_016e: ldind.i2
		IL_016f: conv.i2
		IL_0170: conv.i
		IL_0171: stloc.2
		IL_0172: br IL_0029

		IL_0177: br IL_0246

		IL_017c: ldc.i4 31784972
		IL_0181: stloc 3
		IL_0185: nop
		IL_0186: ldloca 3
		IL_018a: ldind.i2
		IL_018b: conv.i2
		IL_018c: conv.i
		IL_018d: stloc.2
		IL_018e: br IL_0029

		IL_0193: ldarg.3
		IL_0194: ldc.i4.8
		IL_0195: conv.i8
		IL_0196: rem
		IL_0197: brfalse IL_037c

		IL_019c: ldc.i4 1938948106
		IL_01a1: nop
		IL_01a2: stloc 3
		IL_01a6: ldloca 3
		IL_01aa: ldind.i2
		IL_01ab: conv.i2
		IL_01ac: conv.i
		IL_01ad: stloc.2
		IL_01ae: br IL_0029

		IL_01b3: br IL_0114

		IL_01b8: ldarg.0
		IL_01b9: ldarg.0
		IL_01ba: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_01bf: ldarg.0
		IL_01c0: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_01c5: ldarg.0
		IL_01c6: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_01cb: ldc.i4.s 64
		IL_01cd: div
		IL_01ce: call instance void ODCrypt.KeccakDigest::w(uint8[], uint8[], int32)
		IL_01d3: ldarg.0
		IL_01d4: ldarg.0
		IL_01d5: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_01da: stfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_01df: ldc.i4 882529944
		IL_01e4: stloc 3
		IL_01e8: nop
		IL_01e9: ldloca 3
		IL_01ed: ldind.i2
		IL_01ee: conv.i2
		IL_01ef: ldc.i4 1818711704
		IL_01f4: nop
		IL_01f5: stloc 3
		IL_01f9: ldloca 3
		IL_01fd: nop
		IL_01fe: ldind.i2
		IL_01ff: conv.i2
		IL_0200: ceq
		IL_0202: switch (IL_009c, IL_0214, IL_009c)

		IL_0213: nop

		IL_0214: ldc.i4 1635844096
		IL_0219: stloc 3
		IL_021d: nop
		IL_021e: ldloca 3
		IL_0222: nop
		IL_0223: ldind.i2
		IL_0224: conv.i2
		IL_0225: brfalse IL_022a

		IL_022a: ldc.i4 141754375
		IL_022f: stloc 3
		IL_0233: nop
		IL_0234: ldloca 3
		IL_0238: ldind.i2
		IL_0239: conv.i2
		IL_023a: conv.i
		IL_023b: stloc.2
		IL_023c: br IL_0029

		IL_0241: br IL_009c

		IL_0246: ldc.i4 1435631620
		IL_024b: nop
		IL_024c: stloc 3
		IL_0250: ldloca 3
		IL_0254: nop
		IL_0255: ldind.i2
		IL_0256: conv.i2
		IL_0257: conv.i
		IL_0258: stloc.2
		IL_0259: br IL_0029

		IL_025e: ldc.i4 788594689
		IL_0263: stloc 3
		IL_0267: nop
		IL_0268: ldloca 3
		IL_026c: nop
		IL_026d: ldind.i2
		IL_026e: conv.i2
		IL_026f: br.s IL_0283

		IL_0271: ldc.i4 10027008
		IL_0276: stloc 3
		IL_027a: ldloca 3
		IL_027e: nop
		IL_027f: ldind.i2
		IL_0280: conv.i2
		IL_0281: br.s IL_0283

		IL_0283: brfalse.s IL_0285

		IL_0285: ldloc.0
		IL_0286: ldarg.3
		IL_0287: blt IL_02aa

		IL_028c: ldc.i4 487391238
		IL_0291: nop
		IL_0292: stloc 3
		IL_0296: nop
		IL_0297: ldloca 3
		IL_029b: nop
		IL_029c: ldind.i2
		IL_029d: conv.i2
		IL_029e: conv.i
		IL_029f: stloc.2
		IL_02a0: br IL_0029

		IL_02a5: br IL_039c

		IL_02aa: ldc.i4 195428369
		IL_02af: nop
		IL_02b0: stloc 3
		IL_02b4: ldloca 3
		IL_02b8: nop
		IL_02b9: ldind.i2
		IL_02ba: conv.i2
		IL_02bb: conv.i
		IL_02bc: stloc.2
		IL_02bd: br IL_0029

		IL_02c2: ldarg.0
		IL_02c3: ldfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_02c8: brtrue IL_009c

		IL_02cd: ldc.i4 452067341
		IL_02d2: stloc 3
		IL_02d6: nop
		IL_02d7: ldloca 3
		IL_02db: ldind.i2
		IL_02dc: conv.i2
		IL_02dd: conv.i
		IL_02de: stloc.2
		IL_02df: br IL_0029

		IL_02e4: br.s IL_032b

		IL_02e6: ldarg.0
		IL_02e7: call instance void ODCrypt.KeccakDigest::w()
		IL_02ec: ldc.i4 1942421519
		IL_02f1: stloc 3
		IL_02f5: nop
		IL_02f6: ldloca 3
		IL_02fa: ldind.i2
		IL_02fb: conv.i2
		IL_02fc: conv.i
		IL_02fd: stloc.2
		IL_02fe: br IL_0029

		IL_0303: br IL_017c

		IL_0308: ldarg.3
		IL_0309: ldloc.0
		IL_030a: sub
		IL_030b: conv.i4
		IL_030c: stloc.1
		IL_030d: ldc.i4 899350530
		IL_0312: nop
		IL_0313: stloc 3
		IL_0317: nop
		IL_0318: ldloca 3
		IL_031c: nop
		IL_031d: ldind.i2
		IL_031e: conv.i2
		IL_031f: conv.i
		IL_0320: stloc.2
		IL_0321: br IL_0029

		IL_0326: br IL_0128

		IL_032b: ldarg.0
		IL_032c: ldarg.0
		IL_032d: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_0332: call instance void ODCrypt.KeccakDigest::w(uint8[])
		IL_0337: ldc.i4 1006305280
		IL_033c: stloc 3
		IL_0340: nop
		IL_0341: ldloca 3
		IL_0345: nop
		IL_0346: ldind.i2
		IL_0347: conv.i2
		IL_0348: conv.i
		IL_0349: stloc.2
		IL_034a: br IL_0029

		IL_034f: ldarg.0
		IL_0350: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_0355: ldc.i4 1024
		IL_035a: bne.un IL_01b8

		IL_035f: ldc.i4 8519696
		IL_0364: stloc 3
		IL_0368: nop
		IL_0369: ldloca 3
		IL_036d: nop
		IL_036e: ldind.i2
		IL_036f: conv.i2
		IL_0370: conv.i
		IL_0371: stloc.2
		IL_0372: br IL_0029

		IL_0377: br IL_00dd

		IL_037c: ldc.i4.0
		IL_037d: conv.i8
		IL_037e: stloc.0
		IL_037f: ldc.i4 494010377
		IL_0384: nop
		IL_0385: stloc 3
		IL_0389: ldloca 3
		IL_038d: nop
		IL_038e: ldind.i2
		IL_038f: conv.i2
		IL_0390: conv.i
		IL_0391: stloc.2
		IL_0392: br IL_0029

		IL_0397: br IL_0246

		IL_039c: br.s IL_03b1

		IL_039e: ldc.i4 683933696
		IL_03a3: stloc 3
		IL_03a7: ldloca 3
		IL_03ab: nop
		IL_03ac: ldind.i2
		IL_03ad: conv.i2

		IL_03ae: pop
		IL_03af: br.s IL_03c3

		IL_03b1: ldc.i4 2006384640
		IL_03b6: stloc 3
		IL_03ba: ldloca 3
		IL_03be: nop
		IL_03bf: ldind.i2
		IL_03c0: conv.i2
		IL_03c1: br.s IL_03ae

		IL_03c3: nop
		IL_03c4: ret
	} // end of method KeccakDigest::Squeeze

	.method private hidebysig static 
		void w (
			uint64[] A_0,
			uint8[] A_1
		) cil managed 
	{
		// Method begins at RVA 0xe84c
		// Header size: 12
		// Code size: 473 (0x1d9)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int32,
			[4] int16
		)

		IL_0000: ldc.i4 1160567763
		IL_0005: nop
		IL_0006: stloc 4
		IL_000a: nop
		IL_000b: ldloca 4
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 634903507
		IL_0017: stloc 4
		IL_001b: nop
		IL_001c: ldloca 4
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_013b, IL_0036, IL_013b)

		IL_0035: nop

		IL_0036: ldc.i4 849805312
		IL_003b: stloc 4
		IL_003f: nop
		IL_0040: ldloca 4
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: brfalse IL_004b

		IL_004b: ldc.i4.0
		IL_004c: switch (IL_007b)

		IL_0055: ldloc.3
		IL_0056: switch (IL_00cb, IL_0093, IL_01d3, IL_00e9, IL_00b2, IL_0153, IL_0196, IL_0136)

		IL_007b: ldc.i4.0
		IL_007c: stloc.0
		IL_007d: ldc.i4 2143485953
		IL_0082: nop
		IL_0083: stloc 4
		IL_0087: nop
		IL_0088: ldloca 4
		IL_008c: nop
		IL_008d: ldind.i2
		IL_008e: conv.i2
		IL_008f: conv.i
		IL_0090: stloc.3
		IL_0091: br.s IL_0055

		IL_0093: br IL_013b

		IL_0098: ldloc.0
		IL_0099: ldc.i4.1
		IL_009a: add
		IL_009b: stloc.0
		IL_009c: ldc.i4 1204682756
		IL_00a1: nop
		IL_00a2: stloc 4
		IL_00a6: nop
		IL_00a7: ldloca 4
		IL_00ab: nop
		IL_00ac: ldind.i2
		IL_00ad: conv.i2
		IL_00ae: conv.i
		IL_00af: stloc.3
		IL_00b0: br.s IL_0055

		IL_00b2: br IL_013b

		IL_00b7: ldc.i4 791019520
		IL_00bc: stloc 4
		IL_00c0: ldloca 4
		IL_00c4: nop
		IL_00c5: ldind.i2
		IL_00c6: conv.i2
		IL_00c7: conv.i
		IL_00c8: stloc.3
		IL_00c9: br.s IL_0055

		IL_00cb: ldloc.2
		IL_00cc: ldc.i4.8
		IL_00cd: blt IL_0198

		IL_00d2: ldc.i4 488767491
		IL_00d7: nop
		IL_00d8: stloc 4
		IL_00dc: ldloca 4
		IL_00e0: ldind.i2
		IL_00e1: conv.i2
		IL_00e2: conv.i
		IL_00e3: stloc.3
		IL_00e4: br IL_0055

		IL_00e9: br.s IL_00fe

		IL_00eb: ldc.i4 502988800
		IL_00f0: nop
		IL_00f1: stloc 4
		IL_00f5: ldloca 4
		IL_00f9: ldind.i2
		IL_00fa: conv.i2

		IL_00fb: pop
		IL_00fc: br.s IL_0111

		IL_00fe: ldc.i4 577568768
		IL_0103: stloc 4
		IL_0107: nop
		IL_0108: ldloca 4
		IL_010c: nop
		IL_010d: ldind.i2
		IL_010e: conv.i2
		IL_010f: br.s IL_00fb

		IL_0111: nop
		IL_0112: br.s IL_0098

		IL_0114: ldarg.0
		IL_0115: ldloc.0
		IL_0116: ldc.i4.0
		IL_0117: conv.i8
		IL_0118: stelem.i8
		IL_0119: ldloc.0
		IL_011a: ldc.i4.8
		IL_011b: mul
		IL_011c: stloc.1
		IL_011d: ldc.i4.0
		IL_011e: stloc.2
		IL_011f: ldc.i4 821559303
		IL_0124: stloc 4
		IL_0128: ldloca 4
		IL_012c: nop
		IL_012d: ldind.i2
		IL_012e: conv.i2
		IL_012f: conv.i
		IL_0130: stloc.3
		IL_0131: br IL_0055

		IL_0136: br IL_00b7

		IL_013b: ldc.i4 1025376261
		IL_0140: stloc 4
		IL_0144: nop
		IL_0145: ldloca 4
		IL_0149: nop
		IL_014a: ldind.i2
		IL_014b: conv.i2
		IL_014c: conv.i
		IL_014d: stloc.3
		IL_014e: br IL_0055

		IL_0153: ldc.i4 1664614401
		IL_0158: nop
		IL_0159: stloc 4
		IL_015d: ldloca 4
		IL_0161: nop
		IL_0162: ldind.i2
		IL_0163: conv.i2
		IL_0164: br.s IL_0178

		IL_0166: ldc.i4 1223884800
		IL_016b: nop
		IL_016c: stloc 4
		IL_0170: ldloca 4
		IL_0174: ldind.i2
		IL_0175: conv.i2
		IL_0176: br.s IL_0178

		IL_0178: brfalse.s IL_017a

		IL_017a: ldloc.0
		IL_017b: ldc.i4.s 25
		IL_017d: blt.s IL_0114

		IL_017f: ldc.i4 771424262
		IL_0184: stloc 4
		IL_0188: nop
		IL_0189: ldloca 4
		IL_018d: ldind.i2
		IL_018e: conv.i2
		IL_018f: conv.i
		IL_0190: stloc.3
		IL_0191: br IL_0055

		IL_0196: br.s IL_01d8

		IL_0198: ldarg.0
		IL_0199: ldloc.0
		IL_019a: ldelema [mscorlib]System.UInt64
		IL_019f: dup
		IL_01a0: ldind.i8
		IL_01a1: ldarg.1
		IL_01a2: ldloc.1
		IL_01a3: ldloc.2
		IL_01a4: add
		IL_01a5: ldelem.u1
		IL_01a6: conv.u8
		IL_01a7: ldc.i4 255
		IL_01ac: conv.i8
		IL_01ad: and
		IL_01ae: ldc.i4.8
		IL_01af: ldloc.2
		IL_01b0: mul
		IL_01b1: ldc.i4.s 63
		IL_01b3: and
		IL_01b4: shl
		IL_01b5: or
		IL_01b6: stind.i8
		IL_01b7: ldloc.2
		IL_01b8: ldc.i4.1
		IL_01b9: add
		IL_01ba: stloc.2
		IL_01bb: ldc.i4 139198466
		IL_01c0: nop
		IL_01c1: stloc 4
		IL_01c5: ldloca 4
		IL_01c9: nop
		IL_01ca: ldind.i2
		IL_01cb: conv.i2
		IL_01cc: conv.i
		IL_01cd: stloc.3
		IL_01ce: br IL_0055

		IL_01d3: br IL_00b7

		IL_01d8: ret
	} // end of method KeccakDigest::w

	.method private hidebysig static 
		void w (
			uint8[] A_0,
			uint64[] A_1
		) cil managed 
	{
		// Method begins at RVA 0xea34
		// Header size: 12
		// Code size: 457 (0x1c9)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int32,
			[4] int16
		)

		IL_0000: ldc.i4 1103115576
		IL_0005: stloc 4
		IL_0009: nop
		IL_000a: ldloca 4
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1487156536
		IL_0016: stloc 4
		IL_001a: nop
		IL_001b: ldloca 4
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0161, IL_0035, IL_0161)

		IL_0034: nop

		IL_0035: ldc.i4 690159616
		IL_003a: nop
		IL_003b: stloc 4
		IL_003f: nop
		IL_0040: ldloca 4
		IL_0044: nop
		IL_0045: ldind.i2
		IL_0046: conv.i2
		IL_0047: brfalse IL_004c

		IL_004c: ldc.i4.0
		IL_004d: switch (IL_007c)

		IL_0056: ldloc.3
		IL_0057: switch (IL_00ca, IL_0092, IL_01c3, IL_013a, IL_00b0, IL_017a, IL_0196, IL_015c)

		IL_007c: ldc.i4.0
		IL_007d: stloc.0
		IL_007e: ldc.i4 1081344001
		IL_0083: nop
		IL_0084: stloc 4
		IL_0088: ldloca 4
		IL_008c: ldind.i2
		IL_008d: conv.i2
		IL_008e: conv.i
		IL_008f: stloc.3
		IL_0090: br.s IL_0056

		IL_0092: br IL_0161

		IL_0097: ldloc.0
		IL_0098: ldc.i4.1
		IL_0099: add
		IL_009a: stloc.0
		IL_009b: ldc.i4 661061636
		IL_00a0: nop
		IL_00a1: stloc 4
		IL_00a5: ldloca 4
		IL_00a9: nop
		IL_00aa: ldind.i2
		IL_00ab: conv.i2
		IL_00ac: conv.i
		IL_00ad: stloc.3
		IL_00ae: br.s IL_0056

		IL_00b0: br IL_0161

		IL_00b5: ldc.i4 962920448
		IL_00ba: nop
		IL_00bb: stloc 4
		IL_00bf: ldloca 4
		IL_00c3: nop
		IL_00c4: ldind.i2
		IL_00c5: conv.i2
		IL_00c6: conv.i
		IL_00c7: stloc.3
		IL_00c8: br.s IL_0056

		IL_00ca: ldc.i4 908001281
		IL_00cf: nop
		IL_00d0: stloc 4
		IL_00d4: ldloca 4
		IL_00d8: nop
		IL_00d9: ldind.i2
		IL_00da: conv.i2
		IL_00db: br.s IL_00f1

		IL_00dd: ldc.i4 1177681920
		IL_00e2: nop
		IL_00e3: stloc 4
		IL_00e7: nop
		IL_00e8: ldloca 4
		IL_00ec: nop
		IL_00ed: ldind.i2
		IL_00ee: conv.i2
		IL_00ef: br.s IL_00f1

		IL_00f1: brfalse.s IL_00f3

		IL_00f3: ldloc.2
		IL_00f4: ldc.i4.8
		IL_00f5: blt IL_0198

		IL_00fa: br.s IL_0110

		IL_00fc: ldc.i4 244842496
		IL_0101: stloc 4
		IL_0105: nop
		IL_0106: ldloca 4
		IL_010a: nop
		IL_010b: ldind.i2
		IL_010c: conv.i2

		IL_010d: pop
		IL_010e: br.s IL_0122

		IL_0110: ldc.i4 1674969088
		IL_0115: nop
		IL_0116: stloc 4
		IL_011a: ldloca 4
		IL_011e: ldind.i2
		IL_011f: conv.i2
		IL_0120: br.s IL_010d

		IL_0122: nop
		IL_0123: ldc.i4 2135162883
		IL_0128: stloc 4
		IL_012c: ldloca 4
		IL_0130: nop
		IL_0131: ldind.i2
		IL_0132: conv.i2
		IL_0133: conv.i
		IL_0134: stloc.3
		IL_0135: br IL_0056

		IL_013a: br IL_0097

		IL_013f: ldloc.0
		IL_0140: ldc.i4.8
		IL_0141: mul
		IL_0142: stloc.1
		IL_0143: ldc.i4.0
		IL_0144: stloc.2
		IL_0145: ldc.i4 1378156551
		IL_014a: stloc 4
		IL_014e: ldloca 4
		IL_0152: nop
		IL_0153: ldind.i2
		IL_0154: conv.i2
		IL_0155: conv.i
		IL_0156: stloc.3
		IL_0157: br IL_0056

		IL_015c: br IL_00b5

		IL_0161: ldc.i4 2074411013
		IL_0166: nop
		IL_0167: stloc 4
		IL_016b: nop
		IL_016c: ldloca 4
		IL_0170: nop
		IL_0171: ldind.i2
		IL_0172: conv.i2
		IL_0173: conv.i
		IL_0174: stloc.3
		IL_0175: br IL_0056

		IL_017a: ldloc.0
		IL_017b: ldc.i4.s 25
		IL_017d: blt.s IL_013f

		IL_017f: ldc.i4 620101638
		IL_0184: stloc 4
		IL_0188: ldloca 4
		IL_018c: nop
		IL_018d: ldind.i2
		IL_018e: conv.i2
		IL_018f: conv.i
		IL_0190: stloc.3
		IL_0191: br IL_0056

		IL_0196: br.s IL_01c8

		IL_0198: ldarg.0
		IL_0199: ldloc.1
		IL_019a: ldloc.2
		IL_019b: add
		IL_019c: ldarg.1
		IL_019d: ldloc.0
		IL_019e: ldelem.i8
		IL_019f: ldc.i4.8
		IL_01a0: ldloc.2
		IL_01a1: mul
		IL_01a2: ldc.i4.s 63
		IL_01a4: and
		IL_01a5: shr.un
		IL_01a6: conv.u1
		IL_01a7: stelem.i1
		IL_01a8: ldloc.2
		IL_01a9: ldc.i4.1
		IL_01aa: add
		IL_01ab: stloc.2
		IL_01ac: ldc.i4 174587906
		IL_01b1: nop
		IL_01b2: stloc 4
		IL_01b6: ldloca 4
		IL_01ba: ldind.i2
		IL_01bb: conv.i2
		IL_01bc: conv.i
		IL_01bd: stloc.3
		IL_01be: br IL_0056

		IL_01c3: br IL_00b5

		IL_01c8: ret
	} // end of method KeccakDigest::w

	.method private hidebysig 
		instance void w (
			uint8[] A_0
		) cil managed 
	{
		// Method begins at RVA 0xec0c
		// Header size: 12
		// Code size: 189 (0xbd)
		.maxstack 2
		.locals init (
			[0] uint64[],
			[1] int16
		)

		IL_0000: ldc.i4 391060935
		IL_0005: nop
		IL_0006: stloc 1
		IL_000a: nop
		IL_000b: ldloca 1
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 1293360583
		IL_0017: stloc 1
		IL_001b: nop
		IL_001c: ldloca 1
		IL_0020: nop
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: ceq
		IL_0025: switch (IL_0036, IL_0061, IL_0036)

		IL_0036: br.s IL_004c

		IL_0038: ldc.i4 250347520
		IL_003d: nop
		IL_003e: stloc 1
		IL_0042: ldloca 1
		IL_0046: nop
		IL_0047: ldind.i2
		IL_0048: conv.i2

		IL_0049: pop
		IL_004a: br.s IL_005f

		IL_004c: ldc.i4 653459456
		IL_0051: nop
		IL_0052: stloc 1
		IL_0056: nop
		IL_0057: ldloca 1
		IL_005b: ldind.i2
		IL_005c: conv.i2
		IL_005d: br.s IL_0049

		IL_005f: nop
		IL_0060: nop

		IL_0061: ldc.i4 1134166016
		IL_0066: stloc 1
		IL_006a: nop
		IL_006b: ldloca 1
		IL_006f: ldind.i2
		IL_0070: conv.i2
		IL_0071: brfalse IL_0076

		IL_0076: ldc.i4 1683881985
		IL_007b: stloc 1
		IL_007f: ldloca 1
		IL_0083: nop
		IL_0084: ldind.i2
		IL_0085: conv.i2
		IL_0086: br.s IL_009a

		IL_0088: ldc.i4 405405696
		IL_008d: stloc 1
		IL_0091: ldloca 1
		IL_0095: nop
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: br.s IL_009a

		IL_009a: brfalse.s IL_009c

		IL_009c: ldarg.1
		IL_009d: ldlen
		IL_009e: conv.i4
		IL_009f: ldc.i4.8
		IL_00a0: div
		IL_00a1: newarr [mscorlib]System.UInt64
		IL_00a6: stloc.0
		IL_00a7: ldloc.0
		IL_00a8: ldarg.1
		IL_00a9: call void ODCrypt.KeccakDigest::w(uint64[], uint8[])
		IL_00ae: ldarg.0
		IL_00af: ldloc.0
		IL_00b0: call instance void ODCrypt.KeccakDigest::c(uint64[])
		IL_00b5: ldarg.1
		IL_00b6: ldloc.0
		IL_00b7: call void ODCrypt.KeccakDigest::w(uint8[], uint64[])
		IL_00bc: ret
	} // end of method KeccakDigest::w

	.method private hidebysig 
		instance void m (
			uint8[] A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0xecd8
		// Header size: 12
		// Code size: 312 (0x138)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: br.s IL_0016

		IL_0002: ldc.i4 882573312
		IL_0007: nop
		IL_0008: stloc 2
		IL_000c: nop
		IL_000d: ldloca 2
		IL_0011: ldind.i2
		IL_0012: conv.i2

		IL_0013: pop
		IL_0014: br.s IL_0029

		IL_0016: ldc.i4 258080768
		IL_001b: nop
		IL_001c: stloc 2
		IL_0020: nop
		IL_0021: ldloca 2
		IL_0025: ldind.i2
		IL_0026: conv.i2
		IL_0027: br.s IL_0013

		IL_0029: nop
		IL_002a: ldc.i4 173406759
		IL_002f: nop
		IL_0030: stloc 2
		IL_0034: nop
		IL_0035: ldloca 2
		IL_0039: ldind.i2
		IL_003a: conv.i2
		IL_003b: ldc.i4 1460664871
		IL_0040: nop
		IL_0041: stloc 2
		IL_0045: ldloca 2
		IL_0049: nop
		IL_004a: ldind.i2
		IL_004b: conv.i2
		IL_004c: ceq
		IL_004e: switch (IL_00d5, IL_0060, IL_00d5)

		IL_005f: nop

		IL_0060: ldc.i4 681443329
		IL_0065: nop
		IL_0066: stloc 2
		IL_006a: nop
		IL_006b: ldloca 2
		IL_006f: nop
		IL_0070: ldind.i2
		IL_0071: conv.i2
		IL_0072: br.s IL_0086

		IL_0074: ldc.i4 375128064
		IL_0079: stloc 2
		IL_007d: nop
		IL_007e: ldloca 2
		IL_0082: ldind.i2
		IL_0083: conv.i2
		IL_0084: br.s IL_0086

		IL_0086: brfalse.s IL_0088

		IL_0088: ldc.i4 494141440
		IL_008d: stloc 2
		IL_0091: ldloca 2
		IL_0095: nop
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: brfalse IL_009d

		IL_009d: ldc.i4.0
		IL_009e: switch (IL_00bd)

		IL_00a7: ldloc.1
		IL_00a8: switch (IL_00d3, IL_00ea, IL_012e, IL_0102)

		IL_00bd: ldc.i4.0
		IL_00be: stloc.0
		IL_00bf: ldc.i4 1669988352
		IL_00c4: stloc 2
		IL_00c8: ldloca 2
		IL_00cc: nop
		IL_00cd: ldind.i2
		IL_00ce: conv.i2
		IL_00cf: conv.i
		IL_00d0: stloc.1
		IL_00d1: br.s IL_00a7

		IL_00d3: br.s IL_00d5

		IL_00d5: ldc.i4 1437138945
		IL_00da: stloc 2
		IL_00de: nop
		IL_00df: ldloca 2
		IL_00e3: nop
		IL_00e4: ldind.i2
		IL_00e5: conv.i2
		IL_00e6: conv.i
		IL_00e7: stloc.1
		IL_00e8: br.s IL_00a7

		IL_00ea: ldloc.0
		IL_00eb: ldarg.3
		IL_00ec: blt.s IL_0104

		IL_00ee: ldc.i4 702349315
		IL_00f3: stloc 2
		IL_00f7: ldloca 2
		IL_00fb: nop
		IL_00fc: ldind.i2
		IL_00fd: conv.i2
		IL_00fe: conv.i
		IL_00ff: stloc.1
		IL_0100: br.s IL_00a7

		IL_0102: br.s IL_0130

		IL_0104: ldarg.1
		IL_0105: ldloc.0
		IL_0106: ldelema [mscorlib]System.Byte
		IL_010b: dup
		IL_010c: ldind.u1
		IL_010d: ldarg.2
		IL_010e: ldloc.0
		IL_010f: ldelem.u1
		IL_0110: xor
		IL_0111: conv.u1
		IL_0112: stind.i1
		IL_0113: ldloc.0
		IL_0114: ldc.i4.1
		IL_0115: add
		IL_0116: stloc.0
		IL_0117: ldc.i4 269811714
		IL_011c: nop
		IL_011d: stloc 2
		IL_0121: ldloca 2
		IL_0125: ldind.i2
		IL_0126: conv.i2
		IL_0127: conv.i
		IL_0128: stloc.1
		IL_0129: br IL_00a7

		IL_012e: br.s IL_00d5

		IL_0130: ldarg.0
		IL_0131: ldarg.1
		IL_0132: call instance void ODCrypt.KeccakDigest::w(uint8[])
		IL_0137: ret
	} // end of method KeccakDigest::m

	.method private hidebysig 
		instance void c (
			uint64[] A_0
		) cil managed 
	{
		// Method begins at RVA 0xee1c
		// Header size: 12
		// Code size: 327 (0x147)
		.maxstack 2
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: br.s IL_0016

		IL_0002: ldc.i4 107741184
		IL_0007: nop
		IL_0008: stloc 2
		IL_000c: nop
		IL_000d: ldloca 2
		IL_0011: ldind.i2
		IL_0012: conv.i2

		IL_0013: pop
		IL_0014: br.s IL_0028

		IL_0016: ldc.i4 278003712
		IL_001b: nop
		IL_001c: stloc 2
		IL_0020: ldloca 2
		IL_0024: ldind.i2
		IL_0025: conv.i2
		IL_0026: br.s IL_0013

		IL_0028: nop
		IL_0029: ldc.i4 492252380
		IL_002e: stloc 2
		IL_0032: ldloca 2
		IL_0036: nop
		IL_0037: ldind.i2
		IL_0038: conv.i2
		IL_0039: ldc.i4 631450844
		IL_003e: stloc 2
		IL_0042: ldloca 2
		IL_0046: nop
		IL_0047: ldind.i2
		IL_0048: conv.i2
		IL_0049: ceq
		IL_004b: switch (IL_00d1, IL_005d, IL_00d1)

		IL_005c: nop

		IL_005d: ldc.i4 1173225472
		IL_0062: stloc 2
		IL_0066: nop
		IL_0067: ldloca 2
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: brfalse IL_0072

		IL_0072: ldc.i4.0
		IL_0073: switch (IL_0092)

		IL_007c: ldloc.1
		IL_007d: switch (IL_00cf, IL_00e6, IL_0144, IL_0103)

		IL_0092: ldc.i4 400883713
		IL_0097: nop
		IL_0098: stloc 2
		IL_009c: nop
		IL_009d: ldloca 2
		IL_00a1: ldind.i2
		IL_00a2: conv.i2
		IL_00a3: br.s IL_00b7

		IL_00a5: ldc.i4 1596850176
		IL_00aa: stloc 2
		IL_00ae: nop
		IL_00af: ldloca 2
		IL_00b3: ldind.i2
		IL_00b4: conv.i2
		IL_00b5: br.s IL_00b7

		IL_00b7: brfalse.s IL_00b9

		IL_00b9: ldc.i4.0
		IL_00ba: stloc.0
		IL_00bb: ldc.i4 143589376
		IL_00c0: stloc 2
		IL_00c4: ldloca 2
		IL_00c8: nop
		IL_00c9: ldind.i2
		IL_00ca: conv.i2
		IL_00cb: conv.i
		IL_00cc: stloc.1
		IL_00cd: br.s IL_007c

		IL_00cf: br.s IL_00d1

		IL_00d1: ldc.i4 1111949313
		IL_00d6: stloc 2
		IL_00da: nop
		IL_00db: ldloca 2
		IL_00df: nop
		IL_00e0: ldind.i2
		IL_00e1: conv.i2
		IL_00e2: conv.i
		IL_00e3: stloc.1
		IL_00e4: br.s IL_007c

		IL_00e6: ldloc.0
		IL_00e7: ldc.i4.s 24
		IL_00e9: blt.s IL_0105

		IL_00eb: ldc.i4 1867972611
		IL_00f0: stloc 2
		IL_00f4: nop
		IL_00f5: ldloca 2
		IL_00f9: nop
		IL_00fa: ldind.i2
		IL_00fb: conv.i2
		IL_00fc: conv.i
		IL_00fd: stloc.1
		IL_00fe: br IL_007c

		IL_0103: br.s IL_0146

		IL_0105: ldarg.0
		IL_0106: ldarg.1
		IL_0107: call instance void ODCrypt.KeccakDigest::h(uint64[])
		IL_010c: ldarg.0
		IL_010d: ldarg.1
		IL_010e: call instance void ODCrypt.KeccakDigest::m(uint64[])
		IL_0113: ldarg.0
		IL_0114: ldarg.1
		IL_0115: call instance void ODCrypt.KeccakDigest::r(uint64[])
		IL_011a: ldarg.0
		IL_011b: ldarg.1
		IL_011c: call instance void ODCrypt.KeccakDigest::w(uint64[])
		IL_0121: ldarg.1
		IL_0122: ldloc.0
		IL_0123: call void ODCrypt.KeccakDigest::w(uint64[], int32)
		IL_0128: ldloc.0
		IL_0129: ldc.i4.1
		IL_012a: add
		IL_012b: stloc.0
		IL_012c: ldc.i4 1611988994
		IL_0131: nop
		IL_0132: stloc 2
		IL_0136: nop
		IL_0137: ldloca 2
		IL_013b: ldind.i2
		IL_013c: conv.i2
		IL_013d: conv.i
		IL_013e: stloc.1
		IL_013f: br IL_007c

		IL_0144: br.s IL_00d1

		IL_0146: ret
	} // end of method KeccakDigest::c

	.method private hidebysig 
		instance void h (
			uint64[] A_0
		) cil managed 
	{
		// Method begins at RVA 0xef70
		// Header size: 12
		// Code size: 865 (0x361)
		.maxstack 6
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] uint64,
			[4] int32,
			[5] int32,
			[6] int16
		)

		IL_0000: ldc.i4 1377632256
		IL_0005: nop
		IL_0006: stloc 6
		IL_000a: ldloca 6
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: stloc.s 5
		IL_0012: ldloc.s 5
		IL_0014: switch (IL_001d)

		IL_001d: ldc.i4.0
		IL_001e: switch (IL_006e)

		IL_0027: ldloc.s 5
		IL_0029: switch (IL_02b4, IL_0086, IL_0214, IL_035b, IL_02f0, IL_0259, IL_0181, IL_0105, IL_01f3, IL_0125, IL_01aa, IL_0295, IL_015e, IL_02d1, IL_0339, IL_0278)

		IL_006e: ldc.i4.0
		IL_006f: stloc.0
		IL_0070: ldc.i4 1599406081
		IL_0075: nop
		IL_0076: stloc 6
		IL_007a: ldloca 6
		IL_007e: nop
		IL_007f: ldind.i2
		IL_0080: conv.i2
		IL_0081: conv.i
		IL_0082: stloc.s 5
		IL_0084: br.s IL_0027

		IL_0086: ldc.i4 838796801
		IL_008b: stloc 6
		IL_008f: nop
		IL_0090: ldloca 6
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: ldc.i4 1241581057
		IL_009c: stloc 6
		IL_00a0: nop
		IL_00a1: ldloca 6
		IL_00a5: nop
		IL_00a6: ldind.i2
		IL_00a7: conv.i2
		IL_00a8: ceq
		IL_00aa: switch (IL_0321, IL_00bc, IL_0321)

		IL_00bb: nop

		IL_00bc: ldc.i4 1707737088
		IL_00c1: stloc 6
		IL_00c5: nop
		IL_00c6: ldloca 6
		IL_00ca: ldind.i2
		IL_00cb: conv.i2
		IL_00cc: brfalse IL_00d1

		IL_00d1: br IL_027d

		IL_00d6: ldarg.1
		IL_00d7: ldloc.2
		IL_00d8: ldc.i4.5
		IL_00d9: ldloc.s 4
		IL_00db: mul
		IL_00dc: add
		IL_00dd: ldelema [mscorlib]System.UInt64
		IL_00e2: dup
		IL_00e3: ldind.i8
		IL_00e4: ldloc.3
		IL_00e5: xor
		IL_00e6: stind.i8
		IL_00e7: ldloc.s 4
		IL_00e9: ldc.i4.1
		IL_00ea: add
		IL_00eb: stloc.s 4
		IL_00ed: ldc.i4 1190133767
		IL_00f2: stloc 6
		IL_00f6: ldloca 6
		IL_00fa: nop
		IL_00fb: ldind.i2
		IL_00fc: conv.i2
		IL_00fd: conv.i
		IL_00fe: stloc.s 5
		IL_0100: br IL_0027

		IL_0105: br IL_01d9

		IL_010a: ldc.i4.0
		IL_010b: stloc.2
		IL_010c: ldc.i4 1444151305
		IL_0111: nop
		IL_0112: stloc 6
		IL_0116: nop
		IL_0117: ldloca 6
		IL_011b: ldind.i2
		IL_011c: conv.i2
		IL_011d: conv.i
		IL_011e: stloc.s 5
		IL_0120: br IL_0027

		IL_0125: br IL_0219

		IL_012a: ldarg.0
		IL_012b: ldfld uint64[] ODCrypt.KeccakDigest::m
		IL_0130: ldloc.0
		IL_0131: ldelema [mscorlib]System.UInt64
		IL_0136: dup
		IL_0137: ldind.i8
		IL_0138: ldarg.1
		IL_0139: ldloc.0
		IL_013a: ldc.i4.5
		IL_013b: ldloc.1
		IL_013c: mul
		IL_013d: add
		IL_013e: ldelem.i8
		IL_013f: xor
		IL_0140: stind.i8
		IL_0141: ldloc.1
		IL_0142: ldc.i4.1
		IL_0143: add
		IL_0144: stloc.1
		IL_0145: ldc.i4 756547596
		IL_014a: stloc 6
		IL_014e: nop
		IL_014f: ldloca 6
		IL_0153: nop
		IL_0154: ldind.i2
		IL_0155: conv.i2
		IL_0156: conv.i
		IL_0157: stloc.s 5
		IL_0159: br IL_0027

		IL_015e: br IL_02b9

		IL_0163: ldloc.2
		IL_0164: ldc.i4.1
		IL_0165: add
		IL_0166: stloc.2
		IL_0167: ldc.i4 1733361670
		IL_016c: nop
		IL_016d: stloc 6
		IL_0171: nop
		IL_0172: ldloca 6
		IL_0176: nop
		IL_0177: ldind.i2
		IL_0178: conv.i2
		IL_0179: conv.i
		IL_017a: stloc.s 5
		IL_017c: br IL_0027

		IL_0181: br IL_0219

		IL_0186: ldarg.0
		IL_0187: ldfld uint64[] ODCrypt.KeccakDigest::m
		IL_018c: ldloc.0
		IL_018d: ldc.i4.0
		IL_018e: conv.i8
		IL_018f: stelem.i8
		IL_0190: ldc.i4.0
		IL_0191: stloc.1
		IL_0192: ldc.i4 1018298378
		IL_0197: stloc 6
		IL_019b: nop
		IL_019c: ldloca 6
		IL_01a0: ldind.i2
		IL_01a1: conv.i2
		IL_01a2: conv.i
		IL_01a3: stloc.s 5
		IL_01a5: br IL_0027

		IL_01aa: br.s IL_01c0

		IL_01ac: ldc.i4 857735168
		IL_01b1: nop
		IL_01b2: stloc 6
		IL_01b6: nop
		IL_01b7: ldloca 6
		IL_01bb: ldind.i2
		IL_01bc: conv.i2

		IL_01bd: pop
		IL_01be: br.s IL_01d3

		IL_01c0: ldc.i4 970391552
		IL_01c5: nop
		IL_01c6: stloc 6
		IL_01ca: nop
		IL_01cb: ldloca 6
		IL_01cf: ldind.i2
		IL_01d0: conv.i2
		IL_01d1: br.s IL_01bd

		IL_01d3: nop
		IL_01d4: br IL_02b9

		IL_01d9: ldc.i4 1885143048
		IL_01de: nop
		IL_01df: stloc 6
		IL_01e3: nop
		IL_01e4: ldloca 6
		IL_01e8: nop
		IL_01e9: ldind.i2
		IL_01ea: conv.i2
		IL_01eb: conv.i
		IL_01ec: stloc.s 5
		IL_01ee: br IL_0027

		IL_01f3: ldloc.s 4
		IL_01f5: ldc.i4.5
		IL_01f6: blt IL_00d6

		IL_01fb: ldc.i4 343277570
		IL_0200: nop
		IL_0201: stloc 6
		IL_0205: ldloca 6
		IL_0209: nop
		IL_020a: ldind.i2
		IL_020b: conv.i2
		IL_020c: conv.i
		IL_020d: stloc.s 5
		IL_020f: br IL_0027

		IL_0214: br IL_0163

		IL_0219: ldc.i4 967245825
		IL_021e: stloc 6
		IL_0222: ldloca 6
		IL_0226: nop
		IL_0227: ldind.i2
		IL_0228: conv.i2
		IL_0229: br.s IL_023e

		IL_022b: ldc.i4 898695168
		IL_0230: stloc 6
		IL_0234: nop
		IL_0235: ldloca 6
		IL_0239: nop
		IL_023a: ldind.i2
		IL_023b: conv.i2
		IL_023c: br.s IL_023e

		IL_023e: brfalse.s IL_0240

		IL_0240: ldc.i4 1927938053
		IL_0245: nop
		IL_0246: stloc 6
		IL_024a: ldloca 6
		IL_024e: nop
		IL_024f: ldind.i2
		IL_0250: conv.i2
		IL_0251: conv.i
		IL_0252: stloc.s 5
		IL_0254: br IL_0027

		IL_0259: ldloc.2
		IL_025a: ldc.i4.5
		IL_025b: blt IL_02f2

		IL_0260: ldc.i4 867893263
		IL_0265: stloc 6
		IL_0269: ldloca 6
		IL_026d: nop
		IL_026e: ldind.i2
		IL_026f: conv.i2
		IL_0270: conv.i
		IL_0271: stloc.s 5
		IL_0273: br IL_0027

		IL_0278: br IL_0360

		IL_027d: ldc.i4 2097872907
		IL_0282: nop
		IL_0283: stloc 6
		IL_0287: ldloca 6
		IL_028b: ldind.i2
		IL_028c: conv.i2
		IL_028d: conv.i
		IL_028e: stloc.s 5
		IL_0290: br IL_0027

		IL_0295: ldloc.0
		IL_0296: ldc.i4.5
		IL_0297: blt IL_0186

		IL_029c: ldc.i4 1170800640
		IL_02a1: nop
		IL_02a2: stloc 6
		IL_02a6: ldloca 6
		IL_02aa: ldind.i2
		IL_02ab: conv.i2
		IL_02ac: conv.i
		IL_02ad: stloc.s 5
		IL_02af: br IL_0027

		IL_02b4: br IL_010a

		IL_02b9: ldc.i4 1220083725
		IL_02be: stloc 6
		IL_02c2: ldloca 6
		IL_02c6: nop
		IL_02c7: ldind.i2
		IL_02c8: conv.i2
		IL_02c9: conv.i
		IL_02ca: stloc.s 5
		IL_02cc: br IL_0027

		IL_02d1: ldloc.1
		IL_02d2: ldc.i4.5
		IL_02d3: blt IL_012a

		IL_02d8: ldc.i4 834797572
		IL_02dd: stloc 6
		IL_02e1: ldloca 6
		IL_02e5: nop
		IL_02e6: ldind.i2
		IL_02e7: conv.i2
		IL_02e8: conv.i
		IL_02e9: stloc.s 5
		IL_02eb: br IL_0027

		IL_02f0: br.s IL_033e

		IL_02f2: ldarg.0
		IL_02f3: ldfld uint64[] ODCrypt.KeccakDigest::m
		IL_02f8: ldloc.2
		IL_02f9: ldc.i4.1
		IL_02fa: add
		IL_02fb: ldc.i4.5
		IL_02fc: rem
		IL_02fd: ldelem.i8
		IL_02fe: ldc.i4.1
		IL_02ff: shl
		IL_0300: ldarg.0
		IL_0301: ldfld uint64[] ODCrypt.KeccakDigest::m
		IL_0306: ldloc.2
		IL_0307: ldc.i4.1
		IL_0308: add
		IL_0309: ldc.i4.5
		IL_030a: rem
		IL_030b: ldelem.i8
		IL_030c: ldc.i4.s 63
		IL_030e: shr.un
		IL_030f: xor
		IL_0310: ldarg.0
		IL_0311: ldfld uint64[] ODCrypt.KeccakDigest::m
		IL_0316: ldloc.2
		IL_0317: ldc.i4.4
		IL_0318: add
		IL_0319: ldc.i4.5
		IL_031a: rem
		IL_031b: ldelem.i8
		IL_031c: xor
		IL_031d: stloc.3
		IL_031e: ldc.i4.0
		IL_031f: stloc.s 4

		IL_0321: ldc.i4 526516238
		IL_0326: nop
		IL_0327: stloc 6
		IL_032b: ldloca 6
		IL_032f: ldind.i2
		IL_0330: conv.i2
		IL_0331: conv.i
		IL_0332: stloc.s 5
		IL_0334: br IL_0027

		IL_0339: br IL_01d9

		IL_033e: ldloc.0
		IL_033f: ldc.i4.1
		IL_0340: add
		IL_0341: stloc.0
		IL_0342: ldc.i4 1989738499
		IL_0347: nop
		IL_0348: stloc 6
		IL_034c: ldloca 6
		IL_0350: nop
		IL_0351: ldind.i2
		IL_0352: conv.i2
		IL_0353: conv.i
		IL_0354: stloc.s 5
		IL_0356: br IL_0027

		IL_035b: br IL_027d

		IL_0360: ret
	} // end of method KeccakDigest::h

	.method private hidebysig 
		instance void m (
			uint64[] A_0
		) cil managed 
	{
		// Method begins at RVA 0xf2e0
		// Header size: 12
		// Code size: 525 (0x20d)
		.maxstack 7
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int32,
			[4] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0034)

		IL_000a: ldloc.3
		IL_000b: switch (IL_00bc, IL_00da, IL_004a, IL_0207, IL_0121, IL_0092, IL_01ce, IL_01e8, IL_015f)

		IL_0034: ldc.i4.0
		IL_0035: stloc.0
		IL_0036: ldc.i4 1258291202
		IL_003b: stloc 4
		IL_003f: ldloca 4
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: conv.i
		IL_0047: stloc.3
		IL_0048: br.s IL_000a

		IL_004a: br.s IL_00a5

		IL_004c: br.s IL_0061

		IL_004e: ldc.i4 1050017792
		IL_0053: stloc 4
		IL_0057: ldloca 4
		IL_005b: nop
		IL_005c: ldind.i2
		IL_005d: conv.i2

		IL_005e: pop
		IL_005f: br.s IL_0074

		IL_0061: ldc.i4 912392192
		IL_0066: nop
		IL_0067: stloc 4
		IL_006b: ldloca 4
		IL_006f: nop
		IL_0070: ldind.i2
		IL_0071: conv.i2
		IL_0072: br.s IL_005e

		IL_0074: nop
		IL_0075: ldloc.0
		IL_0076: ldc.i4.5
		IL_0077: ldloc.1
		IL_0078: mul
		IL_0079: add
		IL_007a: stloc.2
		IL_007b: ldc.i4 54657029
		IL_0080: nop
		IL_0081: stloc 4
		IL_0085: ldloca 4
		IL_0089: ldind.i2
		IL_008a: conv.i2
		IL_008b: conv.i
		IL_008c: stloc.3
		IL_008d: br IL_000a

		IL_0092: ldarg.1
		IL_0093: ldloc.2
		IL_0094: ldsfld int32[] ODCrypt.KeccakDigest::r
		IL_0099: ldloc.2
		IL_009a: ldelem.i4
		IL_009b: brtrue IL_0123

		IL_00a0: br IL_01ac

		IL_00a5: ldc.i4 480772096
		IL_00aa: nop
		IL_00ab: stloc 4
		IL_00af: ldloca 4
		IL_00b3: ldind.i2
		IL_00b4: conv.i2
		IL_00b5: conv.i
		IL_00b6: stloc.3
		IL_00b7: br IL_000a

		IL_00bc: ldloc.0
		IL_00bd: ldc.i4.5
		IL_00be: blt IL_0145

		IL_00c3: ldc.i4 1111490561
		IL_00c8: stloc 4
		IL_00cc: nop
		IL_00cd: ldloca 4
		IL_00d1: ldind.i2
		IL_00d2: conv.i2
		IL_00d3: conv.i
		IL_00d4: stloc.3
		IL_00d5: br IL_000a

		IL_00da: br IL_020c

		IL_00df: ldc.i4 1238827009
		IL_00e4: nop
		IL_00e5: stloc 4
		IL_00e9: ldloca 4
		IL_00ed: ldind.i2
		IL_00ee: conv.i2
		IL_00ef: br.s IL_0103

		IL_00f1: ldc.i4 162725888
		IL_00f6: nop
		IL_00f7: stloc 4
		IL_00fb: ldloca 4
		IL_00ff: ldind.i2
		IL_0100: conv.i2
		IL_0101: br.s IL_0103

		IL_0103: brfalse.s IL_0105

		IL_0105: ldloc.0
		IL_0106: ldc.i4.1
		IL_0107: add
		IL_0108: stloc.0
		IL_0109: ldc.i4 1521352708
		IL_010e: stloc 4
		IL_0112: nop
		IL_0113: ldloca 4
		IL_0117: nop
		IL_0118: ldind.i2
		IL_0119: conv.i2
		IL_011a: conv.i
		IL_011b: stloc.3
		IL_011c: br IL_000a

		IL_0121: br.s IL_00a5

		IL_0123: ldarg.1
		IL_0124: ldloc.2
		IL_0125: ldelem.i8
		IL_0126: ldsfld int32[] ODCrypt.KeccakDigest::r
		IL_012b: ldloc.2
		IL_012c: ldelem.i4
		IL_012d: ldc.i4.s 63
		IL_012f: and
		IL_0130: shl
		IL_0131: ldarg.1
		IL_0132: ldloc.2
		IL_0133: ldelem.i8
		IL_0134: ldc.i4.s 64
		IL_0136: ldsfld int32[] ODCrypt.KeccakDigest::r
		IL_013b: ldloc.2
		IL_013c: ldelem.i4
		IL_013d: sub
		IL_013e: ldc.i4.s 63
		IL_0140: and
		IL_0141: shr.un
		IL_0142: xor
		IL_0143: br.s IL_01b1

		IL_0145: ldc.i4.0
		IL_0146: stloc.1
		IL_0147: ldc.i4 677838856
		IL_014c: nop
		IL_014d: stloc 4
		IL_0151: ldloca 4
		IL_0155: nop
		IL_0156: ldind.i2
		IL_0157: conv.i2
		IL_0158: conv.i
		IL_0159: stloc.3
		IL_015a: br IL_000a

		IL_015f: ldc.i4 2054522780
		IL_0164: nop
		IL_0165: stloc 4
		IL_0169: nop
		IL_016a: ldloca 4
		IL_016e: ldind.i2
		IL_016f: conv.i2
		IL_0170: ldc.i4 1512802204
		IL_0175: stloc 4
		IL_0179: nop
		IL_017a: ldloca 4
		IL_017e: ldind.i2
		IL_017f: conv.i2
		IL_0180: ceq
		IL_0182: switch (IL_0000, IL_0194, IL_0000)

		IL_0193: nop

		IL_0194: ldc.i4 41418752
		IL_0199: stloc 4
		IL_019d: nop
		IL_019e: ldloca 4
		IL_01a2: nop
		IL_01a3: ldind.i2
		IL_01a4: conv.i2
		IL_01a5: brfalse IL_01aa

		IL_01aa: br.s IL_01d0

		IL_01ac: ldarg.1
		IL_01ad: ldloc.2
		IL_01ae: ldelem.i8
		IL_01af: br.s IL_01b1

		IL_01b1: stelem.i8
		IL_01b2: ldloc.1
		IL_01b3: ldc.i4.1
		IL_01b4: add
		IL_01b5: stloc.1
		IL_01b6: ldc.i4 2066415622
		IL_01bb: stloc 4
		IL_01bf: nop
		IL_01c0: ldloca 4
		IL_01c4: nop
		IL_01c5: ldind.i2
		IL_01c6: conv.i2
		IL_01c7: conv.i
		IL_01c8: stloc.3
		IL_01c9: br IL_000a

		IL_01ce: br.s IL_01d0

		IL_01d0: ldc.i4 1455620103
		IL_01d5: nop
		IL_01d6: stloc 4
		IL_01da: ldloca 4
		IL_01de: nop
		IL_01df: ldind.i2
		IL_01e0: conv.i2
		IL_01e1: conv.i
		IL_01e2: stloc.3
		IL_01e3: br IL_000a

		IL_01e8: ldloc.1
		IL_01e9: ldc.i4.5
		IL_01ea: blt IL_004c

		IL_01ef: ldc.i4 684589059
		IL_01f4: nop
		IL_01f5: stloc 4
		IL_01f9: ldloca 4
		IL_01fd: nop
		IL_01fe: ldind.i2
		IL_01ff: conv.i2
		IL_0200: conv.i
		IL_0201: stloc.3
		IL_0202: br IL_000a

		IL_0207: br IL_00df

		IL_020c: ret
	} // end of method KeccakDigest::m

	.method private hidebysig 
		instance void r (
			uint64[] A_0
		) cil managed 
	{
		// Method begins at RVA 0xf4fc
		// Header size: 12
		// Code size: 472 (0x1d8)
		.maxstack 6
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int16
		)

		IL_0000: ldc.i4 1998139709
		IL_0005: nop
		IL_0006: stloc 3
		IL_000a: ldloca 3
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 533606717
		IL_0016: nop
		IL_0017: stloc 3
		IL_001b: ldloca 3
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0167, IL_0035, IL_0167)

		IL_0034: nop

		IL_0035: ldc.i4 1263665153
		IL_003a: stloc 3
		IL_003e: nop
		IL_003f: ldloca 3
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: br.s IL_005a

		IL_0047: ldc.i4 1369767936
		IL_004c: nop
		IL_004d: stloc 3
		IL_0051: nop
		IL_0052: ldloca 3
		IL_0056: ldind.i2
		IL_0057: conv.i2
		IL_0058: br.s IL_005a

		IL_005a: brfalse.s IL_005c

		IL_005c: ldc.i4 1798569984
		IL_0061: stloc 3
		IL_0065: ldloca 3
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: brfalse IL_0071

		IL_0071: ldc.i4.0
		IL_0072: switch (IL_00a1)

		IL_007b: ldloc.2
		IL_007c: switch (IL_0103, IL_00cd, IL_01d2, IL_0149, IL_00ea, IL_017f, IL_019a, IL_0165)

		IL_00a1: ldarg.1
		IL_00a2: ldc.i4.0
		IL_00a3: ldarg.0
		IL_00a4: ldfld uint64[] ODCrypt.KeccakDigest::h
		IL_00a9: ldc.i4.0
		IL_00aa: ldarg.0
		IL_00ab: ldfld uint64[] ODCrypt.KeccakDigest::h
		IL_00b0: ldlen
		IL_00b1: conv.i4
		IL_00b2: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00b7: ldc.i4.0
		IL_00b8: stloc.0
		IL_00b9: ldc.i4 1024458753
		IL_00be: stloc 3
		IL_00c2: nop
		IL_00c3: ldloca 3
		IL_00c7: ldind.i2
		IL_00c8: conv.i2
		IL_00c9: conv.i
		IL_00ca: stloc.2
		IL_00cb: br.s IL_007b

		IL_00cd: br IL_0167

		IL_00d2: ldloc.0
		IL_00d3: ldc.i4.1
		IL_00d4: add
		IL_00d5: stloc.0
		IL_00d6: ldc.i4 1543372804
		IL_00db: stloc 3
		IL_00df: ldloca 3
		IL_00e3: nop
		IL_00e4: ldind.i2
		IL_00e5: conv.i2
		IL_00e6: conv.i
		IL_00e7: stloc.2
		IL_00e8: br.s IL_007b

		IL_00ea: br.s IL_0167

		IL_00ec: ldc.i4 1844445184
		IL_00f1: stloc 3
		IL_00f5: ldloca 3
		IL_00f9: nop
		IL_00fa: ldind.i2
		IL_00fb: conv.i2
		IL_00fc: conv.i
		IL_00fd: stloc.2
		IL_00fe: br IL_007b

		IL_0103: ldloc.1
		IL_0104: ldc.i4.5
		IL_0105: blt IL_019c

		IL_010a: br.s IL_011f

		IL_010c: ldc.i4 1817247744
		IL_0111: stloc 3
		IL_0115: nop
		IL_0116: ldloca 3
		IL_011a: ldind.i2
		IL_011b: conv.i2

		IL_011c: pop
		IL_011d: br.s IL_0131

		IL_011f: ldc.i4 1111883776
		IL_0124: nop
		IL_0125: stloc 3
		IL_0129: ldloca 3
		IL_012d: ldind.i2
		IL_012e: conv.i2
		IL_012f: br.s IL_011c

		IL_0131: nop
		IL_0132: ldc.i4 864616451
		IL_0137: stloc 3
		IL_013b: ldloca 3
		IL_013f: nop
		IL_0140: ldind.i2
		IL_0141: conv.i2
		IL_0142: conv.i
		IL_0143: stloc.2
		IL_0144: br IL_007b

		IL_0149: br.s IL_00d2

		IL_014b: ldc.i4.0
		IL_014c: stloc.1
		IL_014d: ldc.i4 684064775
		IL_0152: stloc 3
		IL_0156: nop
		IL_0157: ldloca 3
		IL_015b: nop
		IL_015c: ldind.i2
		IL_015d: conv.i2
		IL_015e: conv.i
		IL_015f: stloc.2
		IL_0160: br IL_007b

		IL_0165: br.s IL_00ec

		IL_0167: ldc.i4 575078405
		IL_016c: nop
		IL_016d: stloc 3
		IL_0171: nop
		IL_0172: ldloca 3
		IL_0176: ldind.i2
		IL_0177: conv.i2
		IL_0178: conv.i
		IL_0179: stloc.2
		IL_017a: br IL_007b

		IL_017f: ldloc.0
		IL_0180: ldc.i4.5
		IL_0181: blt.s IL_014b

		IL_0183: ldc.i4 1186267142
		IL_0188: stloc 3
		IL_018c: ldloca 3
		IL_0190: nop
		IL_0191: ldind.i2
		IL_0192: conv.i2
		IL_0193: conv.i
		IL_0194: stloc.2
		IL_0195: br IL_007b

		IL_019a: br.s IL_01d7

		IL_019c: ldarg.1
		IL_019d: ldloc.1
		IL_019e: ldc.i4.5
		IL_019f: ldc.i4.2
		IL_01a0: ldloc.0
		IL_01a1: mul
		IL_01a2: ldc.i4.3
		IL_01a3: ldloc.1
		IL_01a4: mul
		IL_01a5: add
		IL_01a6: ldc.i4.5
		IL_01a7: rem
		IL_01a8: mul
		IL_01a9: add
		IL_01aa: ldarg.0
		IL_01ab: ldfld uint64[] ODCrypt.KeccakDigest::h
		IL_01b0: ldloc.0
		IL_01b1: ldc.i4.5
		IL_01b2: ldloc.1
		IL_01b3: mul
		IL_01b4: add
		IL_01b5: ldelem.i8
		IL_01b6: stelem.i8
		IL_01b7: ldloc.1
		IL_01b8: ldc.i4.1
		IL_01b9: add
		IL_01ba: stloc.1
		IL_01bb: ldc.i4 729022466
		IL_01c0: stloc 3
		IL_01c4: ldloca 3
		IL_01c8: nop
		IL_01c9: ldind.i2
		IL_01ca: conv.i2
		IL_01cb: conv.i
		IL_01cc: stloc.2
		IL_01cd: br IL_007b

		IL_01d2: br IL_00ec

		IL_01d7: ret
	} // end of method KeccakDigest::r

	.method private hidebysig 
		instance void w (
			uint64[] A_0
		) cil managed 
	{
		// Method begins at RVA 0xf6e0
		// Header size: 12
		// Code size: 618 (0x26a)
		.maxstack 8
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int32,
			[4] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0040)

		IL_000a: ldloc.3
		IL_000b: switch (IL_0152, IL_01e2, IL_016f, IL_0057, IL_018a, IL_0070, IL_00df, IL_021d, IL_0089, IL_01c5, IL_01ff, IL_01a8)

		IL_0040: ldc.i4.0
		IL_0041: stloc.0
		IL_0042: ldc.i4 126681091
		IL_0047: nop
		IL_0048: stloc 4
		IL_004c: ldloca 4
		IL_0050: nop
		IL_0051: ldind.i2
		IL_0052: conv.i2
		IL_0053: conv.i
		IL_0054: stloc.3
		IL_0055: br.s IL_000a

		IL_0057: br IL_0157

		IL_005c: ldc.i4 475594757
		IL_0061: stloc 4
		IL_0065: ldloca 4
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: conv.i
		IL_006d: stloc.3
		IL_006e: br.s IL_000a

		IL_0070: ldloc.2
		IL_0071: ldc.i4.5
		IL_0072: blt.s IL_00b4

		IL_0074: ldc.i4 1464533000
		IL_0079: nop
		IL_007a: stloc 4
		IL_007e: ldloca 4
		IL_0082: nop
		IL_0083: ldind.i2
		IL_0084: conv.i2
		IL_0085: conv.i
		IL_0086: stloc.3
		IL_0087: br.s IL_000a

		IL_0089: ldc.i4 1506869249
		IL_008e: stloc 4
		IL_0092: nop
		IL_0093: ldloca 4
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: br.s IL_00ad

		IL_009b: ldc.i4 1125449728
		IL_00a0: nop
		IL_00a1: stloc 4
		IL_00a5: ldloca 4
		IL_00a9: ldind.i2
		IL_00aa: conv.i2
		IL_00ab: br.s IL_00ad

		IL_00ad: brfalse.s IL_00af

		IL_00af: br IL_01aa

		IL_00b4: ldarg.1
		IL_00b5: ldloc.2
		IL_00b6: ldc.i4.5
		IL_00b7: ldloc.0
		IL_00b8: mul
		IL_00b9: add
		IL_00ba: ldarg.0
		IL_00bb: ldfld uint64[] ODCrypt.KeccakDigest::c
		IL_00c0: ldloc.2
		IL_00c1: ldelem.i8
		IL_00c2: stelem.i8
		IL_00c3: ldloc.2
		IL_00c4: ldc.i4.1
		IL_00c5: add
		IL_00c6: stloc.2
		IL_00c7: ldc.i4 1836974086
		IL_00cc: nop
		IL_00cd: stloc 4
		IL_00d1: nop
		IL_00d2: ldloca 4
		IL_00d6: ldind.i2
		IL_00d7: conv.i2
		IL_00d8: conv.i
		IL_00d9: stloc.3
		IL_00da: br IL_000a

		IL_00df: br IL_005c

		IL_00e4: ldarg.0
		IL_00e5: ldfld uint64[] ODCrypt.KeccakDigest::c
		IL_00ea: ldloc.1
		IL_00eb: ldarg.1
		IL_00ec: ldloc.1
		IL_00ed: ldc.i4.5
		IL_00ee: ldloc.0
		IL_00ef: mul
		IL_00f0: add
		IL_00f1: ldelem.i8
		IL_00f2: ldarg.1
		IL_00f3: ldloc.1
		IL_00f4: ldc.i4.1
		IL_00f5: add
		IL_00f6: ldc.i4.5
		IL_00f7: rem
		IL_00f8: ldc.i4.5
		IL_00f9: ldloc.0
		IL_00fa: mul
		IL_00fb: add
		IL_00fc: ldelem.i8
		IL_00fd: not
		IL_00fe: ldarg.1
		IL_00ff: ldloc.1
		IL_0100: ldc.i4.2
		IL_0101: add
		IL_0102: ldc.i4.5
		IL_0103: rem
		IL_0104: ldc.i4.5
		IL_0105: ldloc.0
		IL_0106: mul
		IL_0107: add
		IL_0108: ldelem.i8
		IL_0109: and
		IL_010a: xor
		IL_010b: stelem.i8
		IL_010c: ldloc.1
		IL_010d: ldc.i4.1
		IL_010e: add
		IL_010f: stloc.1
		IL_0110: br.s IL_0125

		IL_0112: ldc.i4 947322880
		IL_0117: stloc 4
		IL_011b: ldloca 4
		IL_011f: nop
		IL_0120: ldind.i2
		IL_0121: conv.i2

		IL_0122: pop
		IL_0123: br.s IL_0138

		IL_0125: ldc.i4 1367539712
		IL_012a: nop
		IL_012b: stloc 4
		IL_012f: nop
		IL_0130: ldloca 4
		IL_0134: ldind.i2
		IL_0135: conv.i2
		IL_0136: br.s IL_0122

		IL_0138: nop
		IL_0139: ldc.i4 1983250432
		IL_013e: nop
		IL_013f: stloc 4
		IL_0143: nop
		IL_0144: ldloca 4
		IL_0148: nop
		IL_0149: ldind.i2
		IL_014a: conv.i2
		IL_014b: conv.i
		IL_014c: stloc.3
		IL_014d: br IL_000a

		IL_0152: br IL_01e7

		IL_0157: ldc.i4 1614348290
		IL_015c: nop
		IL_015d: stloc 4
		IL_0161: ldloca 4
		IL_0165: nop
		IL_0166: ldind.i2
		IL_0167: conv.i2
		IL_0168: conv.i
		IL_0169: stloc.3
		IL_016a: br IL_000a

		IL_016f: ldloc.0
		IL_0170: ldc.i4.5
		IL_0171: blt.s IL_018f

		IL_0173: ldc.i4 1594425348
		IL_0178: stloc 4
		IL_017c: nop
		IL_017d: ldloca 4
		IL_0181: ldind.i2
		IL_0182: conv.i2
		IL_0183: conv.i
		IL_0184: stloc.3
		IL_0185: br IL_000a

		IL_018a: br IL_021f

		IL_018f: ldc.i4.0
		IL_0190: stloc.1
		IL_0191: ldc.i4 663617547
		IL_0196: nop
		IL_0197: stloc 4
		IL_019b: ldloca 4
		IL_019f: ldind.i2
		IL_01a0: conv.i2
		IL_01a1: conv.i
		IL_01a2: stloc.3
		IL_01a3: br IL_000a

		IL_01a8: br.s IL_01e7

		IL_01aa: ldloc.0
		IL_01ab: ldc.i4.1
		IL_01ac: add
		IL_01ad: stloc.0
		IL_01ae: ldc.i4 1102446601
		IL_01b3: stloc 4
		IL_01b7: ldloca 4
		IL_01bb: nop
		IL_01bc: ldind.i2
		IL_01bd: conv.i2
		IL_01be: conv.i
		IL_01bf: stloc.3
		IL_01c0: br IL_000a

		IL_01c5: br.s IL_0157

		IL_01c7: ldc.i4.0
		IL_01c8: stloc.2
		IL_01c9: ldc.i4 844627969
		IL_01ce: nop
		IL_01cf: stloc 4
		IL_01d3: nop
		IL_01d4: ldloca 4
		IL_01d8: nop
		IL_01d9: ldind.i2
		IL_01da: conv.i2
		IL_01db: conv.i
		IL_01dc: stloc.3
		IL_01dd: br IL_000a

		IL_01e2: br IL_005c

		IL_01e7: ldc.i4 1192886282
		IL_01ec: stloc 4
		IL_01f0: nop
		IL_01f1: ldloca 4
		IL_01f5: nop
		IL_01f6: ldind.i2
		IL_01f7: conv.i2
		IL_01f8: conv.i
		IL_01f9: stloc.3
		IL_01fa: br IL_000a

		IL_01ff: ldloc.1
		IL_0200: ldc.i4.5
		IL_0201: blt IL_00e4

		IL_0206: ldc.i4 80543751
		IL_020b: stloc 4
		IL_020f: ldloca 4
		IL_0213: nop
		IL_0214: ldind.i2
		IL_0215: conv.i2
		IL_0216: conv.i
		IL_0217: stloc.3
		IL_0218: br IL_000a

		IL_021d: br.s IL_01c7

		IL_021f: ldc.i4 771337366
		IL_0224: nop
		IL_0225: stloc 4
		IL_0229: ldloca 4
		IL_022d: ldind.i2
		IL_022e: conv.i2
		IL_022f: ldc.i4 1670425750
		IL_0234: nop
		IL_0235: stloc 4
		IL_0239: ldloca 4
		IL_023d: nop
		IL_023e: ldind.i2
		IL_023f: conv.i2
		IL_0240: ceq
		IL_0242: switch (IL_000a, IL_0254, IL_000a)

		IL_0253: nop

		IL_0254: ldc.i4 1448607744
		IL_0259: stloc 4
		IL_025d: ldloca 4
		IL_0261: nop
		IL_0262: ldind.i2
		IL_0263: conv.i2
		IL_0264: brfalse IL_0269

		IL_0269: ret
	} // end of method KeccakDigest::w

	.method private hidebysig static 
		void w (
			uint64[] A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0xf958
		// Header size: 12
		// Code size: 173 (0xad)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1141440513
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: ldloca 0
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: br.s IL_0024

		IL_0012: ldc.i4 184942592
		IL_0017: nop
		IL_0018: stloc 0
		IL_001c: ldloca 0
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: br.s IL_0024

		IL_0024: brfalse.s IL_0026

		IL_0026: br.s IL_003b

		IL_0028: ldc.i4 903086080
		IL_002d: stloc 0
		IL_0031: ldloca 0
		IL_0035: nop
		IL_0036: ldind.i2
		IL_0037: conv.i2

		IL_0038: pop
		IL_0039: br.s IL_004e

		IL_003b: ldc.i4 975437824
		IL_0040: nop
		IL_0041: stloc 0
		IL_0045: nop
		IL_0046: ldloca 0
		IL_004a: ldind.i2
		IL_004b: conv.i2
		IL_004c: br.s IL_0038

		IL_004e: nop
		IL_004f: ldc.i4 1039461738
		IL_0054: stloc 0
		IL_0058: ldloca 0
		IL_005c: nop
		IL_005d: ldind.i2
		IL_005e: conv.i2
		IL_005f: ldc.i4 841411946
		IL_0064: nop
		IL_0065: stloc 0
		IL_0069: ldloca 0
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: ceq
		IL_0071: switch (IL_0082, IL_0083, IL_0082)

		IL_0082: nop

		IL_0083: ldc.i4 275513344
		IL_0088: nop
		IL_0089: stloc 0
		IL_008d: nop
		IL_008e: ldloca 0
		IL_0092: nop
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: brfalse IL_009a

		IL_009a: ldarg.0
		IL_009b: ldc.i4.0
		IL_009c: ldelema [mscorlib]System.UInt64
		IL_00a1: dup
		IL_00a2: ldind.i8
		IL_00a3: ldsfld uint64[] ODCrypt.KeccakDigest::w
		IL_00a8: ldarg.1
		IL_00a9: ldelem.i8
		IL_00aa: xor
		IL_00ab: stind.i8
		IL_00ac: ret
	} // end of method KeccakDigest::w

	.method private hidebysig 
		instance void r (
			uint8[] A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0xfa14
		// Header size: 12
		// Code size: 165 (0xa5)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 478793909
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 621924533
		IL_0017: stloc 0
		IL_001b: ldloca 0
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_005e, IL_0035)

		IL_0035: br.s IL_004a

		IL_0037: ldc.i4 83361792
		IL_003c: stloc 0
		IL_0040: ldloca 0
		IL_0044: nop
		IL_0045: ldind.i2
		IL_0046: conv.i2

		IL_0047: pop
		IL_0048: br.s IL_005c

		IL_004a: ldc.i4 1114570752
		IL_004f: stloc 0
		IL_0053: nop
		IL_0054: ldloca 0
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_0047

		IL_005c: nop
		IL_005d: nop

		IL_005e: ldc.i4 395771905
		IL_0063: stloc 0
		IL_0067: ldloca 0
		IL_006b: nop
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: br.s IL_0083

		IL_0070: ldc.i4 2009071616
		IL_0075: stloc 0
		IL_0079: nop
		IL_007a: ldloca 0
		IL_007e: nop
		IL_007f: ldind.i2
		IL_0080: conv.i2
		IL_0081: br.s IL_0083

		IL_0083: brfalse.s IL_0085

		IL_0085: ldc.i4 1726152704
		IL_008a: nop
		IL_008b: stloc 0
		IL_008f: ldloca 0
		IL_0093: nop
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: brfalse IL_009b

		IL_009b: ldarg.0
		IL_009c: ldarg.1
		IL_009d: ldarg.2
		IL_009e: ldarg.3
		IL_009f: call instance void ODCrypt.KeccakDigest::m(uint8[], uint8[], int32)
		IL_00a4: ret
	} // end of method KeccakDigest::r

	.method private hidebysig 
		instance void w (
			uint8[] A_0,
			uint8[] A_1
		) cil managed 
	{
		// Method begins at RVA 0xfac8
		// Header size: 12
		// Code size: 171 (0xab)
		.maxstack 5
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 212467713
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: br.s IL_0025

		IL_0013: ldc.i4 487784448
		IL_0018: stloc 0
		IL_001c: ldloca 0
		IL_0020: nop
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: br.s IL_0025

		IL_0025: brfalse.s IL_0027

		IL_0027: br.s IL_003e

		IL_0029: ldc.i4 2138636288
		IL_002e: nop
		IL_002f: stloc 0
		IL_0033: nop
		IL_0034: ldloca 0
		IL_0038: nop
		IL_0039: ldind.i2
		IL_003a: conv.i2

		IL_003b: pop
		IL_003c: br.s IL_0050

		IL_003e: ldc.i4 65404928
		IL_0043: nop
		IL_0044: stloc 0
		IL_0048: ldloca 0
		IL_004c: ldind.i2
		IL_004d: conv.i2
		IL_004e: br.s IL_003b

		IL_0050: nop
		IL_0051: ldc.i4 2009118551
		IL_0056: nop
		IL_0057: stloc 0
		IL_005b: nop
		IL_005c: ldloca 0
		IL_0060: nop
		IL_0061: ldind.i2
		IL_0062: conv.i2
		IL_0063: ldc.i4 597342039
		IL_0068: nop
		IL_0069: stloc 0
		IL_006d: ldloca 0
		IL_0071: ldind.i2
		IL_0072: conv.i2
		IL_0073: ceq
		IL_0075: switch (IL_0086, IL_0087, IL_0086)

		IL_0086: nop

		IL_0087: ldc.i4 1778974720
		IL_008c: nop
		IL_008d: stloc 0
		IL_0091: ldloca 0
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: brfalse IL_009c

		IL_009c: ldarg.1
		IL_009d: ldc.i4.0
		IL_009e: ldarg.2
		IL_009f: ldc.i4.0
		IL_00a0: ldc.i4 128
		IL_00a5: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00aa: ret
	} // end of method KeccakDigest::w

	.method private hidebysig 
		instance void w (
			uint8[] A_0,
			uint8[] A_1,
			int32 A_2
		) cil managed 
	{
		// Method begins at RVA 0xfb80
		// Header size: 12
		// Code size: 166 (0xa6)
		.maxstack 6
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 441727663
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: ldloca 0
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 847526575
		IL_0016: stloc 0
		IL_001a: ldloca 0
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_005d, IL_0034)

		IL_0034: br.s IL_0049

		IL_0036: ldc.i4 1101201408
		IL_003b: stloc 0
		IL_003f: nop
		IL_0040: ldloca 0
		IL_0044: ldind.i2
		IL_0045: conv.i2

		IL_0046: pop
		IL_0047: br.s IL_005b

		IL_0049: ldc.i4 729743360
		IL_004e: nop
		IL_004f: stloc 0
		IL_0053: ldloca 0
		IL_0057: ldind.i2
		IL_0058: conv.i2
		IL_0059: br.s IL_0046

		IL_005b: nop
		IL_005c: nop

		IL_005d: ldc.i4 309657600
		IL_0062: nop
		IL_0063: stloc 0
		IL_0067: nop
		IL_0068: ldloca 0
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: brfalse IL_0073

		IL_0073: ldc.i4 397410305
		IL_0078: nop
		IL_0079: stloc 0
		IL_007d: ldloca 0
		IL_0081: ldind.i2
		IL_0082: conv.i2
		IL_0083: br.s IL_0097

		IL_0085: ldc.i4 31064064
		IL_008a: stloc 0
		IL_008e: nop
		IL_008f: ldloca 0
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: br.s IL_0097

		IL_0097: brfalse.s IL_0099

		IL_0099: ldarg.1
		IL_009a: ldc.i4.0
		IL_009b: ldarg.2
		IL_009c: ldc.i4.0
		IL_009d: ldarg.3
		IL_009e: ldc.i4.8
		IL_009f: mul
		IL_00a0: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00a5: ret
	} // end of method KeccakDigest::w

	.method private hidebysig specialname rtspecialname static 
		void .cctor () cil managed 
	{
		// Method begins at RVA 0xfc34
		// Header size: 12
		// Code size: 180 (0xb4)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 377215676
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 1925569212
		IL_0017: stloc 0
		IL_001b: ldloca 0
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0062, IL_0035)

		IL_0035: br.s IL_004c

		IL_0037: ldc.i4 1205665792
		IL_003c: nop
		IL_003d: stloc 0
		IL_0041: nop
		IL_0042: ldloca 0
		IL_0046: nop
		IL_0047: ldind.i2
		IL_0048: conv.i2

		IL_0049: pop
		IL_004a: br.s IL_0060

		IL_004c: ldc.i4 1708261376
		IL_0051: nop
		IL_0052: stloc 0
		IL_0056: nop
		IL_0057: ldloca 0
		IL_005b: nop
		IL_005c: ldind.i2
		IL_005d: conv.i2
		IL_005e: br.s IL_0049

		IL_0060: nop
		IL_0061: nop

		IL_0062: ldc.i4 1044316161
		IL_0067: nop
		IL_0068: stloc 0
		IL_006c: ldloca 0
		IL_0070: ldind.i2
		IL_0071: conv.i2
		IL_0072: br.s IL_0087

		IL_0074: ldc.i4 1925709824
		IL_0079: nop
		IL_007a: stloc 0
		IL_007e: nop
		IL_007f: ldloca 0
		IL_0083: ldind.i2
		IL_0084: conv.i2
		IL_0085: br.s IL_0087

		IL_0087: brfalse.s IL_0089

		IL_0089: ldc.i4 1016332288
		IL_008e: nop
		IL_008f: stloc 0
		IL_0093: ldloca 0
		IL_0097: nop
		IL_0098: ldind.i2
		IL_0099: conv.i2
		IL_009a: brfalse IL_009f

		IL_009f: call uint64[] ODCrypt.KeccakDigest::h()
		IL_00a4: stsfld uint64[] ODCrypt.KeccakDigest::w
		IL_00a9: call int32[] ODCrypt.KeccakDigest::m()
		IL_00ae: stsfld int32[] ODCrypt.KeccakDigest::r
		IL_00b3: ret
	} // end of method KeccakDigest::.cctor

	// Properties
	.property instance string AlgorithmName()
	{
		.get instance string ODCrypt.KeccakDigest::get_AlgorithmName()
	}

} // end of class ODCrypt.KeccakDigest

.class public auto ansi beforefieldinit ODCrypt.MD5
	extends [mscorlib]System.Object
{
	// Fields
	.field private static literal int32 w = int32(16)
	.field private uint32 r
	.field private uint32 m
	.field private uint32 h
	.field private uint32 c
	.field private uint32[] x
	.field private int32 s
	.field private static literal int32 n = int32(64)
	.field private uint8[] i
	.field private int32 d
	.field private int64 y
	.field private static initonly int32 t
	.field private static initonly int32 o
	.field private static initonly int32 j
	.field private static initonly int32 e
	.field private static initonly int32 z
	.field private static initonly int32 u
	.field private static initonly int32 p
	.field private static initonly int32 k
	.field private static initonly int32 f
	.field private static initonly int32 a
	.field private static initonly int32 v
	.field private static initonly int32 q
	.field private static initonly int32 l
	.field private static initonly int32 g
	.field private static initonly int32 b
	.field private static initonly int32 w5

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0xfcf4
		// Header size: 12
		// Code size: 39 (0x27)
		.maxstack 2

		IL_0000: ldarg.0
		IL_0001: ldc.i4.s 16
		IL_0003: newarr [mscorlib]System.UInt32
		IL_0008: stfld uint32[] ODCrypt.MD5::x
		IL_000d: ldarg.0
		IL_000e: call instance void [mscorlib]System.Object::.ctor()
		IL_0013: ldarg.0
		IL_0014: ldc.i4.s 16
		IL_0016: newarr [mscorlib]System.Byte
		IL_001b: stfld uint8[] ODCrypt.MD5::i
		IL_0020: ldarg.0
		IL_0021: call instance void ODCrypt.MD5::Reset()
		IL_0026: ret
	} // end of method MD5::.ctor

	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			class ODCrypt.MD5 t
		) cil managed 
	{
		// Method begins at RVA 0xfd28
		// Header size: 12
		// Code size: 27 (0x1b)
		.maxstack 2

		IL_0000: ldarg.0
		IL_0001: ldc.i4.s 16
		IL_0003: newarr [mscorlib]System.UInt32
		IL_0008: stfld uint32[] ODCrypt.MD5::x
		IL_000d: ldarg.0
		IL_000e: call instance void [mscorlib]System.Object::.ctor()
		IL_0013: ldarg.0
		IL_0014: ldarg.1
		IL_0015: call instance void ODCrypt.MD5::w(class ODCrypt.MD5)
		IL_001a: ret
	} // end of method MD5::.ctor

	.method public hidebysig static 
		uint8[] Hash (
			uint8[] plaintext
		) cil managed 
	{
		// Method begins at RVA 0xfd50
		// Header size: 12
		// Code size: 177 (0xb1)
		.maxstack 5
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 70623504
		IL_0005: stloc 0
		IL_0009: nop
		IL_000a: ldloca 0
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1827119376
		IL_0016: stloc 0
		IL_001a: nop
		IL_001b: ldloca 0
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_005e, IL_0034)

		IL_0034: br.s IL_0049

		IL_0036: ldc.i4 498401280
		IL_003b: stloc 0
		IL_003f: ldloca 0
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2

		IL_0046: pop
		IL_0047: br.s IL_005c

		IL_0049: ldc.i4 1473970176
		IL_004e: stloc 0
		IL_0052: nop
		IL_0053: ldloca 0
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_0046

		IL_005c: nop
		IL_005d: nop

		IL_005e: ldc.i4 1210777601
		IL_0063: stloc 0
		IL_0067: nop
		IL_0068: ldloca 0
		IL_006c: ldind.i2
		IL_006d: conv.i2
		IL_006e: br.s IL_0084

		IL_0070: ldc.i4 647626752
		IL_0075: nop
		IL_0076: stloc 0
		IL_007a: nop
		IL_007b: ldloca 0
		IL_007f: nop
		IL_0080: ldind.i2
		IL_0081: conv.i2
		IL_0082: br.s IL_0084

		IL_0084: brfalse.s IL_0086

		IL_0086: ldc.i4 763101184
		IL_008b: nop
		IL_008c: stloc 0
		IL_0090: ldloca 0
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: brfalse IL_009b

		IL_009b: newobj instance void ODCrypt.MD5::.ctor()
		IL_00a0: dup
		IL_00a1: ldarg.0
		IL_00a2: ldc.i4.0
		IL_00a3: ldarg.0
		IL_00a4: ldlen
		IL_00a5: conv.i4
		IL_00a6: callvirt instance void ODCrypt.MD5::BlockUpdate(uint8[], int32, int32)
		IL_00ab: call uint8[] ODCrypt.MD5::DoFinal(class ODCrypt.MD5)
		IL_00b0: ret
	} // end of method MD5::Hash

	.method private hidebysig 
		instance void w (
			class ODCrypt.MD5 A_0
		) cil managed 
	{
		// Method begins at RVA 0xfe10
		// Header size: 12
		// Code size: 298 (0x12a)
		.maxstack 5
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1669964393
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 788832873
		IL_0017: stloc 0
		IL_001b: nop
		IL_001c: ldloca 0
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0061, IL_0035)

		IL_0035: br.s IL_004b

		IL_0037: ldc.i4 2134900736
		IL_003c: nop
		IL_003d: stloc 0
		IL_0041: ldloca 0
		IL_0045: nop
		IL_0046: ldind.i2
		IL_0047: conv.i2

		IL_0048: pop
		IL_0049: br.s IL_005f

		IL_004b: ldc.i4 517210112
		IL_0050: nop
		IL_0051: stloc 0
		IL_0055: nop
		IL_0056: ldloca 0
		IL_005a: nop
		IL_005b: ldind.i2
		IL_005c: conv.i2
		IL_005d: br.s IL_0048

		IL_005f: nop
		IL_0060: nop

		IL_0061: ldc.i4 40370176
		IL_0066: stloc 0
		IL_006a: ldloca 0
		IL_006e: nop
		IL_006f: ldind.i2
		IL_0070: conv.i2
		IL_0071: brfalse IL_0076

		IL_0076: ldc.i4 1532821505
		IL_007b: nop
		IL_007c: stloc 0
		IL_0080: ldloca 0
		IL_0084: nop
		IL_0085: ldind.i2
		IL_0086: conv.i2
		IL_0087: br.s IL_009d

		IL_0089: ldc.i4 1229914112
		IL_008e: nop
		IL_008f: stloc 0
		IL_0093: nop
		IL_0094: ldloca 0
		IL_0098: nop
		IL_0099: ldind.i2
		IL_009a: conv.i2
		IL_009b: br.s IL_009d

		IL_009d: brfalse.s IL_009f

		IL_009f: ldarg.1
		IL_00a0: ldfld uint8[] ODCrypt.MD5::i
		IL_00a5: ldc.i4.0
		IL_00a6: ldarg.0
		IL_00a7: ldfld uint8[] ODCrypt.MD5::i
		IL_00ac: ldc.i4.0
		IL_00ad: ldarg.1
		IL_00ae: ldfld uint8[] ODCrypt.MD5::i
		IL_00b3: ldlen
		IL_00b4: conv.i4
		IL_00b5: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00ba: ldarg.0
		IL_00bb: ldarg.1
		IL_00bc: ldfld int32 ODCrypt.MD5::d
		IL_00c1: stfld int32 ODCrypt.MD5::d
		IL_00c6: ldarg.0
		IL_00c7: ldarg.1
		IL_00c8: ldfld int64 ODCrypt.MD5::y
		IL_00cd: stfld int64 ODCrypt.MD5::y
		IL_00d2: ldarg.0
		IL_00d3: ldarg.1
		IL_00d4: ldfld uint32 ODCrypt.MD5::r
		IL_00d9: stfld uint32 ODCrypt.MD5::r
		IL_00de: ldarg.0
		IL_00df: ldarg.1
		IL_00e0: ldfld uint32 ODCrypt.MD5::m
		IL_00e5: stfld uint32 ODCrypt.MD5::m
		IL_00ea: ldarg.0
		IL_00eb: ldarg.1
		IL_00ec: ldfld uint32 ODCrypt.MD5::h
		IL_00f1: stfld uint32 ODCrypt.MD5::h
		IL_00f6: ldarg.0
		IL_00f7: ldarg.1
		IL_00f8: ldfld uint32 ODCrypt.MD5::c
		IL_00fd: stfld uint32 ODCrypt.MD5::c
		IL_0102: ldarg.1
		IL_0103: ldfld uint32[] ODCrypt.MD5::x
		IL_0108: ldc.i4.0
		IL_0109: ldarg.0
		IL_010a: ldfld uint32[] ODCrypt.MD5::x
		IL_010f: ldc.i4.0
		IL_0110: ldarg.1
		IL_0111: ldfld uint32[] ODCrypt.MD5::x
		IL_0116: ldlen
		IL_0117: conv.i4
		IL_0118: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_011d: ldarg.0
		IL_011e: ldarg.1
		IL_011f: ldfld int32 ODCrypt.MD5::s
		IL_0124: stfld int32 ODCrypt.MD5::s
		IL_0129: ret
	} // end of method MD5::w

	.method public hidebysig specialname 
		instance string get_AlgorithmName () cil managed 
	{
		// Method begins at RVA 0xff48
		// Header size: 12
		// Code size: 177 (0xb1)
		.maxstack 2
		.locals init (
			[0] int16,
			[1] int32
		)

		IL_0000: ldc.i4 5
		IL_0005: stloc 1
		IL_0009: ldc.i4 465901680
		IL_000e: stloc 0
		IL_0012: ldloca 0
		IL_0016: nop
		IL_0017: ldind.i2
		IL_0018: conv.i2
		IL_0019: ldc.i4 486676592
		IL_001e: stloc 0
		IL_0022: nop
		IL_0023: ldloca 0
		IL_0027: nop
		IL_0028: ldind.i2
		IL_0029: conv.i2
		IL_002a: ceq
		IL_002c: switch (IL_003d, IL_0067, IL_003d)

		IL_003d: br.s IL_0053

		IL_003f: ldc.i4 877199360
		IL_0044: stloc 0
		IL_0048: nop
		IL_0049: ldloca 0
		IL_004d: nop
		IL_004e: ldind.i2
		IL_004f: conv.i2

		IL_0050: pop
		IL_0051: br.s IL_0065

		IL_0053: ldc.i4 906952704
		IL_0058: stloc 0
		IL_005c: nop
		IL_005d: ldloca 0
		IL_0061: ldind.i2
		IL_0062: conv.i2
		IL_0063: br.s IL_0050

		IL_0065: nop
		IL_0066: nop

		IL_0067: ldc.i4 173932544
		IL_006c: stloc 0
		IL_0070: nop
		IL_0071: ldloca 0
		IL_0075: ldind.i2
		IL_0076: conv.i2
		IL_0077: brfalse IL_007c

		IL_007c: ldc.i4 105250817
		IL_0081: stloc 0
		IL_0085: ldloca 0
		IL_0089: nop
		IL_008a: ldind.i2
		IL_008b: conv.i2
		IL_008c: br.s IL_00a0

		IL_008e: ldc.i4 1613037568
		IL_0093: stloc 0
		IL_0097: ldloca 0
		IL_009b: nop
		IL_009c: ldind.i2
		IL_009d: conv.i2
		IL_009e: br.s IL_00a0

		IL_00a0: brfalse.s IL_00a2

		IL_00a2: ldstr "???"
		IL_00a7: ldloc 1
		IL_00ab: call string ODCrypt.Sha3::b(string, int32)
		IL_00b0: ret
	} // end of method MD5::get_AlgorithmName

	.method public hidebysig 
		instance int32 GetDigestSize () cil managed 
	{
		// Method begins at RVA 0x10008
		// Header size: 12
		// Code size: 157 (0x9d)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1027293770
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 1343111754
		IL_0017: stloc 0
		IL_001b: nop
		IL_001c: ldloca 0
		IL_0020: nop
		IL_0021: ldind.i2
		IL_0022: conv.i2
		IL_0023: ceq
		IL_0025: switch (IL_0036, IL_005f, IL_0036)

		IL_0036: br.s IL_004b

		IL_0038: ldc.i4 202244096
		IL_003d: stloc 0
		IL_0041: ldloca 0
		IL_0045: nop
		IL_0046: ldind.i2
		IL_0047: conv.i2

		IL_0048: pop
		IL_0049: br.s IL_005d

		IL_004b: ldc.i4 909901824
		IL_0050: stloc 0
		IL_0054: ldloca 0
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_0048

		IL_005d: nop
		IL_005e: nop

		IL_005f: ldc.i4 107806721
		IL_0064: stloc 0
		IL_0068: nop
		IL_0069: ldloca 0
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: br.s IL_0083

		IL_0071: ldc.i4 1937309696
		IL_0076: stloc 0
		IL_007a: ldloca 0
		IL_007e: nop
		IL_007f: ldind.i2
		IL_0080: conv.i2
		IL_0081: br.s IL_0083

		IL_0083: brfalse.s IL_0085

		IL_0085: ldc.i4 301858816
		IL_008a: stloc 0
		IL_008e: ldloca 0
		IL_0092: nop
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: brfalse IL_009a

		IL_009a: ldc.i4.s 16
		IL_009c: ret
	} // end of method MD5::GetDigestSize

	.method assembly hidebysig 
		instance void w (
			uint8[] A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0x100b4
		// Header size: 12
		// Code size: 307 (0x133)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_001c)

		IL_000a: ldloc.1
		IL_000b: switch (IL_00c9, IL_0130, IL_00e6)

		IL_001c: ldarg.0
		IL_001d: ldfld uint32[] ODCrypt.MD5::x
		IL_0022: ldarg.0
		IL_0023: ldfld int32 ODCrypt.MD5::s
		IL_0028: ldarg.1
		IL_0029: ldarg.2
		IL_002a: call uint32 w::r(uint8[], int32)
		IL_002f: stelem.i4
		IL_0030: ldarg.0
		IL_0031: ldarg.0
		IL_0032: ldfld int32 ODCrypt.MD5::s
		IL_0037: ldc.i4.1
		IL_0038: add
		IL_0039: stloc.0
		IL_003a: ldloc.0
		IL_003b: stfld int32 ODCrypt.MD5::s
		IL_0040: ldc.i4 1244584661
		IL_0045: stloc 2
		IL_0049: nop
		IL_004a: ldloca 2
		IL_004e: ldind.i2
		IL_004f: conv.i2
		IL_0050: ldc.i4 2116016853
		IL_0055: nop
		IL_0056: stloc 2
		IL_005a: nop
		IL_005b: ldloca 2
		IL_005f: nop
		IL_0060: ldind.i2
		IL_0061: conv.i2
		IL_0062: ceq
		IL_0064: switch (IL_00c9, IL_0076, IL_00c9)

		IL_0075: nop

		IL_0076: ldc.i4 1621032961
		IL_007b: stloc 2
		IL_007f: ldloca 2
		IL_0083: nop
		IL_0084: ldind.i2
		IL_0085: conv.i2
		IL_0086: br.s IL_009b

		IL_0088: ldc.i4 1605304320
		IL_008d: nop
		IL_008e: stloc 2
		IL_0092: ldloca 2
		IL_0096: nop
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: br.s IL_009b

		IL_009b: brfalse.s IL_009d

		IL_009d: ldc.i4 640942080
		IL_00a2: nop
		IL_00a3: stloc 2
		IL_00a7: ldloca 2
		IL_00ab: ldind.i2
		IL_00ac: conv.i2
		IL_00ad: brfalse IL_00b2

		IL_00b2: ldc.i4 384696320
		IL_00b7: stloc 2
		IL_00bb: ldloca 2
		IL_00bf: nop
		IL_00c0: ldind.i2
		IL_00c1: conv.i2
		IL_00c2: conv.i
		IL_00c3: stloc.1
		IL_00c4: br IL_000a

		IL_00c9: ldloc.0
		IL_00ca: ldc.i4.s 16
		IL_00cc: bne.un.s IL_0132

		IL_00ce: ldc.i4 1273233410
		IL_00d3: stloc 2
		IL_00d7: nop
		IL_00d8: ldloca 2
		IL_00dc: nop
		IL_00dd: ldind.i2
		IL_00de: conv.i2
		IL_00df: conv.i
		IL_00e0: stloc.1
		IL_00e1: br IL_000a

		IL_00e6: br.s IL_00fd

		IL_00e8: ldc.i4 340262912
		IL_00ed: nop
		IL_00ee: stloc 2
		IL_00f2: nop
		IL_00f3: ldloca 2
		IL_00f7: nop
		IL_00f8: ldind.i2
		IL_00f9: conv.i2

		IL_00fa: pop
		IL_00fb: br.s IL_0110

		IL_00fd: ldc.i4 2096431104
		IL_0102: stloc 2
		IL_0106: nop
		IL_0107: ldloca 2
		IL_010b: nop
		IL_010c: ldind.i2
		IL_010d: conv.i2
		IL_010e: br.s IL_00fa

		IL_0110: nop
		IL_0111: br.s IL_0113

		IL_0113: ldarg.0
		IL_0114: call instance void ODCrypt.MD5::w()
		IL_0119: ldc.i4 1323237377
		IL_011e: stloc 2
		IL_0122: ldloca 2
		IL_0126: nop
		IL_0127: ldind.i2
		IL_0128: conv.i2
		IL_0129: conv.i
		IL_012a: stloc.1
		IL_012b: br IL_000a

		IL_0130: br.s IL_0132

		IL_0132: ret
	} // end of method MD5::w

	.method assembly hidebysig 
		instance void w (
			int64 A_0
		) cil managed 
	{
		// Method begins at RVA 0x101f4
		// Header size: 12
		// Code size: 569 (0x239)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4 1288437763
		IL_0005: stloc 2
		IL_0009: nop
		IL_000a: ldloca 2
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: conv.i
		IL_0012: stloc.1
		IL_0013: br.s IL_001f

		IL_0015: ldc.i4.0
		IL_0016: switch (IL_004d)

		IL_001f: ldloc.1
		IL_0020: switch (IL_0070, IL_00b8, IL_00d5, IL_0015, IL_017d, IL_0145, IL_0094, IL_01c8, IL_01a4, IL_015e)

		IL_004d: ldarg.0
		IL_004e: ldfld int32 ODCrypt.MD5::s
		IL_0053: ldc.i4.s 14
		IL_0055: ble IL_01a9

		IL_005a: ldc.i4 989528064
		IL_005f: nop
		IL_0060: stloc 2
		IL_0064: nop
		IL_0065: ldloca 2
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: conv.i
		IL_006d: stloc.1
		IL_006e: br.s IL_001f

		IL_0070: br.s IL_00bd

		IL_0072: ldarg.0
		IL_0073: ldfld uint32[] ODCrypt.MD5::x
		IL_0078: ldloc.0
		IL_0079: ldc.i4.0
		IL_007a: stelem.i4
		IL_007b: ldloc.0
		IL_007c: ldc.i4.1
		IL_007d: add
		IL_007e: stloc.0
		IL_007f: ldc.i4 1823539206
		IL_0084: stloc 2
		IL_0088: nop
		IL_0089: ldloca 2
		IL_008d: nop
		IL_008e: ldind.i2
		IL_008f: conv.i2
		IL_0090: conv.i
		IL_0091: stloc.1
		IL_0092: br.s IL_001f

		IL_0094: br IL_0147

		IL_0099: ldarg.0
		IL_009a: call instance void ODCrypt.MD5::w()
		IL_009f: ldc.i4 1630535681
		IL_00a4: nop
		IL_00a5: stloc 2
		IL_00a9: nop
		IL_00aa: ldloca 2
		IL_00ae: nop
		IL_00af: ldind.i2
		IL_00b0: conv.i2
		IL_00b1: conv.i
		IL_00b2: stloc.1
		IL_00b3: br IL_001f

		IL_00b8: br IL_01a9

		IL_00bd: ldc.i4 899547138
		IL_00c2: nop
		IL_00c3: stloc 2
		IL_00c7: ldloca 2
		IL_00cb: nop
		IL_00cc: ldind.i2
		IL_00cd: conv.i2
		IL_00ce: conv.i
		IL_00cf: stloc.1
		IL_00d0: br IL_001f

		IL_00d5: ldarg.0
		IL_00d6: ldfld int32 ODCrypt.MD5::s
		IL_00db: ldc.i4.s 15
		IL_00dd: bne.un.s IL_0099

		IL_00df: ldc.i4 303065613
		IL_00e4: nop
		IL_00e5: stloc 2
		IL_00e9: nop
		IL_00ea: ldloca 2
		IL_00ee: nop
		IL_00ef: ldind.i2
		IL_00f0: conv.i2
		IL_00f1: ldc.i4 1454729741
		IL_00f6: nop
		IL_00f7: stloc 2
		IL_00fb: nop
		IL_00fc: ldloca 2
		IL_0100: nop
		IL_0101: ldind.i2
		IL_0102: conv.i2
		IL_0103: ceq
		IL_0105: switch (IL_0015, IL_0117, IL_0015)

		IL_0116: nop

		IL_0117: ldc.i4 260571136
		IL_011c: stloc 2
		IL_0120: nop
		IL_0121: ldloca 2
		IL_0125: nop
		IL_0126: ldind.i2
		IL_0127: conv.i2
		IL_0128: brfalse IL_012d

		IL_012d: ldc.i4 436011013
		IL_0132: nop
		IL_0133: stloc 2
		IL_0137: ldloca 2
		IL_013b: nop
		IL_013c: ldind.i2
		IL_013d: conv.i2
		IL_013e: conv.i
		IL_013f: stloc.1
		IL_0140: br IL_001f

		IL_0145: br.s IL_0182

		IL_0147: ldc.i4 2133983241
		IL_014c: stloc 2
		IL_0150: ldloca 2
		IL_0154: nop
		IL_0155: ldind.i2
		IL_0156: conv.i2
		IL_0157: conv.i
		IL_0158: stloc.1
		IL_0159: br IL_001f

		IL_015e: ldloc.0
		IL_015f: ldc.i4.s 14
		IL_0161: blt IL_0072

		IL_0166: ldc.i4 184745988
		IL_016b: stloc 2
		IL_016f: ldloca 2
		IL_0173: nop
		IL_0174: ldind.i2
		IL_0175: conv.i2
		IL_0176: conv.i
		IL_0177: stloc.1
		IL_0178: br IL_001f

		IL_017d: br IL_021f

		IL_0182: ldarg.0
		IL_0183: ldfld uint32[] ODCrypt.MD5::x
		IL_0188: ldc.i4.s 15
		IL_018a: ldc.i4.0
		IL_018b: stelem.i4
		IL_018c: ldc.i4 1923678216
		IL_0191: nop
		IL_0192: stloc 2
		IL_0196: ldloca 2
		IL_019a: nop
		IL_019b: ldind.i2
		IL_019c: conv.i2
		IL_019d: conv.i
		IL_019e: stloc.1
		IL_019f: br IL_001f

		IL_01a4: br IL_0099

		IL_01a9: ldarg.0
		IL_01aa: ldfld int32 ODCrypt.MD5::s
		IL_01af: stloc.0
		IL_01b0: ldc.i4 1556283399
		IL_01b5: nop
		IL_01b6: stloc 2
		IL_01ba: ldloca 2
		IL_01be: nop
		IL_01bf: ldind.i2
		IL_01c0: conv.i2
		IL_01c1: conv.i
		IL_01c2: stloc.1
		IL_01c3: br IL_001f

		IL_01c8: ldc.i4 87031809
		IL_01cd: stloc 2
		IL_01d1: ldloca 2
		IL_01d5: nop
		IL_01d6: ldind.i2
		IL_01d7: conv.i2
		IL_01d8: br.s IL_01ee

		IL_01da: ldc.i4 680132608
		IL_01df: nop
		IL_01e0: stloc 2
		IL_01e4: nop
		IL_01e5: ldloca 2
		IL_01e9: nop
		IL_01ea: ldind.i2
		IL_01eb: conv.i2
		IL_01ec: br.s IL_01ee

		IL_01ee: brfalse.s IL_01f0

		IL_01f0: br.s IL_0206

		IL_01f2: ldc.i4 587923456
		IL_01f7: stloc 2
		IL_01fb: nop
		IL_01fc: ldloca 2
		IL_0200: nop
		IL_0201: ldind.i2
		IL_0202: conv.i2

		IL_0203: pop
		IL_0204: br.s IL_0219

		IL_0206: ldc.i4 689569792
		IL_020b: stloc 2
		IL_020f: nop
		IL_0210: ldloca 2
		IL_0214: nop
		IL_0215: ldind.i2
		IL_0216: conv.i2
		IL_0217: br.s IL_0203

		IL_0219: nop
		IL_021a: br IL_0147

		IL_021f: ldarg.0
		IL_0220: ldfld uint32[] ODCrypt.MD5::x
		IL_0225: ldc.i4.s 14
		IL_0227: ldarg.1
		IL_0228: conv.u4
		IL_0229: stelem.i4
		IL_022a: ldarg.0
		IL_022b: ldfld uint32[] ODCrypt.MD5::x
		IL_0230: ldc.i4.s 15
		IL_0232: ldarg.1
		IL_0233: ldc.i4.s 32
		IL_0235: shr.un
		IL_0236: conv.u4
		IL_0237: stelem.i4
		IL_0238: ret
	} // end of method MD5::w

	.method public hidebysig 
		instance int32 DoFinal (
			uint8[] output,
			int32 outOff
		) cil managed 
	{
		// Method begins at RVA 0x1043c
		// Header size: 12
		// Code size: 396 (0x18c)
		.maxstack 4
		.locals init (
			[0] int64,
			[1] int32,
			[2] int16
		)

		IL_0000: br.s IL_0016

		IL_0002: ldc.i4 1496383488
		IL_0007: stloc 2
		IL_000b: nop
		IL_000c: ldloca 2
		IL_0010: nop
		IL_0011: ldind.i2
		IL_0012: conv.i2

		IL_0013: pop
		IL_0014: br.s IL_0029

		IL_0016: ldc.i4 2043478016
		IL_001b: nop
		IL_001c: stloc 2
		IL_0020: ldloca 2
		IL_0024: nop
		IL_0025: ldind.i2
		IL_0026: conv.i2
		IL_0027: br.s IL_0013

		IL_0029: nop
		IL_002a: ldc.i4 19650126
		IL_002f: nop
		IL_0030: stloc 2
		IL_0034: nop
		IL_0035: ldloca 2
		IL_0039: nop
		IL_003a: ldind.i2
		IL_003b: conv.i2
		IL_003c: ldc.i4 736679502
		IL_0041: nop
		IL_0042: stloc 2
		IL_0046: ldloca 2
		IL_004a: ldind.i2
		IL_004b: conv.i2
		IL_004c: ceq
		IL_004e: switch (IL_00e8, IL_0060, IL_00e8)

		IL_005f: nop

		IL_0060: ldc.i4 756678656
		IL_0065: nop
		IL_0066: stloc 2
		IL_006a: nop
		IL_006b: ldloca 2
		IL_006f: nop
		IL_0070: ldind.i2
		IL_0071: conv.i2
		IL_0072: brfalse IL_0077

		IL_0077: ldc.i4 1441333249
		IL_007c: stloc 2
		IL_0080: nop
		IL_0081: ldloca 2
		IL_0085: ldind.i2
		IL_0086: conv.i2
		IL_0087: br.s IL_009b

		IL_0089: ldc.i4 1820786688
		IL_008e: stloc 2
		IL_0092: ldloca 2
		IL_0096: nop
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: br.s IL_009b

		IL_009b: brfalse.s IL_009d

		IL_009d: ldc.i4.0
		IL_009e: switch (IL_00bd)

		IL_00a7: ldloc.1
		IL_00a8: switch (IL_00e6, IL_00fc, IL_0139, IL_0119)

		IL_00bd: ldarg.0
		IL_00be: ldfld int64 ODCrypt.MD5::y
		IL_00c3: ldc.i4.3
		IL_00c4: shl
		IL_00c5: stloc.0
		IL_00c6: ldarg.0
		IL_00c7: ldc.i4 128
		IL_00cc: call instance void ODCrypt.MD5::Update(uint8)
		IL_00d1: ldc.i4 1808334848
		IL_00d6: stloc 2
		IL_00da: nop
		IL_00db: ldloca 2
		IL_00df: nop
		IL_00e0: ldind.i2
		IL_00e1: conv.i2
		IL_00e2: conv.i
		IL_00e3: stloc.1
		IL_00e4: br.s IL_00a7

		IL_00e6: br.s IL_00e8

		IL_00e8: ldc.i4 117374977
		IL_00ed: stloc 2
		IL_00f1: ldloca 2
		IL_00f5: nop
		IL_00f6: ldind.i2
		IL_00f7: conv.i2
		IL_00f8: conv.i
		IL_00f9: stloc.1
		IL_00fa: br.s IL_00a7

		IL_00fc: ldarg.0
		IL_00fd: ldfld int32 ODCrypt.MD5::d
		IL_0102: brtrue.s IL_011b

		IL_0104: ldc.i4 454754307
		IL_0109: nop
		IL_010a: stloc 2
		IL_010e: nop
		IL_010f: ldloca 2
		IL_0113: ldind.i2
		IL_0114: conv.i2
		IL_0115: conv.i
		IL_0116: stloc.1
		IL_0117: br.s IL_00a7

		IL_0119: br.s IL_013b

		IL_011b: ldarg.0
		IL_011c: ldc.i4.0
		IL_011d: call instance void ODCrypt.MD5::Update(uint8)
		IL_0122: ldc.i4 298516482
		IL_0127: stloc 2
		IL_012b: ldloca 2
		IL_012f: nop
		IL_0130: ldind.i2
		IL_0131: conv.i2
		IL_0132: conv.i
		IL_0133: stloc.1
		IL_0134: br IL_00a7

		IL_0139: br.s IL_00e8

		IL_013b: ldarg.0
		IL_013c: ldloc.0
		IL_013d: call instance void ODCrypt.MD5::w(int64)
		IL_0142: ldarg.0
		IL_0143: call instance void ODCrypt.MD5::w()
		IL_0148: ldarg.0
		IL_0149: ldfld uint32 ODCrypt.MD5::r
		IL_014e: ldarg.1
		IL_014f: ldarg.2
		IL_0150: call void w::w(uint32, uint8[], int32)
		IL_0155: ldarg.0
		IL_0156: ldfld uint32 ODCrypt.MD5::m
		IL_015b: ldarg.1
		IL_015c: ldarg.2
		IL_015d: ldc.i4.4
		IL_015e: add
		IL_015f: call void w::w(uint32, uint8[], int32)
		IL_0164: ldarg.0
		IL_0165: ldfld uint32 ODCrypt.MD5::h
		IL_016a: ldarg.1
		IL_016b: ldarg.2
		IL_016c: ldc.i4.8
		IL_016d: add
		IL_016e: call void w::w(uint32, uint8[], int32)
		IL_0173: ldarg.0
		IL_0174: ldfld uint32 ODCrypt.MD5::c
		IL_0179: ldarg.1
		IL_017a: ldarg.2
		IL_017b: ldc.i4.s 12
		IL_017d: add
		IL_017e: call void w::w(uint32, uint8[], int32)
		IL_0183: ldarg.0
		IL_0184: call instance void ODCrypt.MD5::Reset()
		IL_0189: ldc.i4.s 16
		IL_018b: ret
	} // end of method MD5::DoFinal

	.method public hidebysig 
		instance void Reset () cil managed 
	{
		// Method begins at RVA 0x105d4
		// Header size: 12
		// Code size: 405 (0x195)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: br.s IL_0015

		IL_0002: ldc.i4 447873024
		IL_0007: stloc 2
		IL_000b: ldloca 2
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2

		IL_0012: pop
		IL_0013: br.s IL_0028

		IL_0015: ldc.i4 1578434560
		IL_001a: stloc 2
		IL_001e: nop
		IL_001f: ldloca 2
		IL_0023: nop
		IL_0024: ldind.i2
		IL_0025: conv.i2
		IL_0026: br.s IL_0012

		IL_0028: nop
		IL_0029: ldc.i4 1280259877
		IL_002e: stloc 2
		IL_0032: nop
		IL_0033: ldloca 2
		IL_0037: nop
		IL_0038: ldind.i2
		IL_0039: conv.i2
		IL_003a: ldc.i4 1625044773
		IL_003f: nop
		IL_0040: stloc 2
		IL_0044: ldloca 2
		IL_0048: ldind.i2
		IL_0049: conv.i2
		IL_004a: ceq
		IL_004c: switch (IL_0107, IL_005e, IL_0107)

		IL_005d: nop

		IL_005e: ldc.i4 1371340800
		IL_0063: nop
		IL_0064: stloc 2
		IL_0068: nop
		IL_0069: ldloca 2
		IL_006d: nop
		IL_006e: ldind.i2
		IL_006f: conv.i2
		IL_0070: brfalse IL_0075

		IL_0075: ldc.i4.0
		IL_0076: switch (IL_0095)

		IL_007f: ldloc.1
		IL_0080: switch (IL_0105, IL_011e, IL_018f, IL_0140)

		IL_0095: ldarg.0
		IL_0096: ldc.i4.0
		IL_0097: conv.i8
		IL_0098: stfld int64 ODCrypt.MD5::y
		IL_009d: ldarg.0
		IL_009e: ldc.i4.0
		IL_009f: stfld int32 ODCrypt.MD5::d
		IL_00a4: ldarg.0
		IL_00a5: ldfld uint8[] ODCrypt.MD5::i
		IL_00aa: ldc.i4.0
		IL_00ab: ldarg.0
		IL_00ac: ldfld uint8[] ODCrypt.MD5::i
		IL_00b1: ldlen
		IL_00b2: conv.i4
		IL_00b3: call void [mscorlib]System.Array::Clear(class [mscorlib]System.Array, int32, int32)
		IL_00b8: ldarg.0
		IL_00b9: ldc.i4 1732584193
		IL_00be: stfld uint32 ODCrypt.MD5::r
		IL_00c3: ldarg.0
		IL_00c4: ldc.i4 -271733879
		IL_00c9: stfld uint32 ODCrypt.MD5::m
		IL_00ce: ldarg.0
		IL_00cf: ldc.i4 -1732584194
		IL_00d4: stfld uint32 ODCrypt.MD5::h
		IL_00d9: ldarg.0
		IL_00da: ldc.i4 271733878
		IL_00df: stfld uint32 ODCrypt.MD5::c
		IL_00e4: ldarg.0
		IL_00e5: ldc.i4.0
		IL_00e6: stfld int32 ODCrypt.MD5::s
		IL_00eb: ldc.i4.0
		IL_00ec: stloc.0
		IL_00ed: ldc.i4 1225129984
		IL_00f2: nop
		IL_00f3: stloc 2
		IL_00f7: ldloca 2
		IL_00fb: nop
		IL_00fc: ldind.i2
		IL_00fd: conv.i2
		IL_00fe: conv.i
		IL_00ff: stloc.1
		IL_0100: br IL_007f

		IL_0105: br.s IL_0107

		IL_0107: ldc.i4 1331429377
		IL_010c: stloc 2
		IL_0110: ldloca 2
		IL_0114: nop
		IL_0115: ldind.i2
		IL_0116: conv.i2
		IL_0117: conv.i
		IL_0118: stloc.1
		IL_0119: br IL_007f

		IL_011e: ldloc.0
		IL_011f: ldarg.0
		IL_0120: ldfld uint32[] ODCrypt.MD5::x
		IL_0125: ldlen
		IL_0126: conv.i4
		IL_0127: bne.un.s IL_016b

		IL_0129: ldc.i4 1951727619
		IL_012e: stloc 2
		IL_0132: ldloca 2
		IL_0136: nop
		IL_0137: ldind.i2
		IL_0138: conv.i2
		IL_0139: conv.i
		IL_013a: stloc.1
		IL_013b: br IL_007f

		IL_0140: ldc.i4 421003265
		IL_0145: nop
		IL_0146: stloc 2
		IL_014a: nop
		IL_014b: ldloca 2
		IL_014f: nop
		IL_0150: ldind.i2
		IL_0151: conv.i2
		IL_0152: br.s IL_0167

		IL_0154: ldc.i4 911212544
		IL_0159: stloc 2
		IL_015d: nop
		IL_015e: ldloca 2
		IL_0162: nop
		IL_0163: ldind.i2
		IL_0164: conv.i2
		IL_0165: br.s IL_0167

		IL_0167: brfalse.s IL_0169

		IL_0169: br.s IL_0194

		IL_016b: ldarg.0
		IL_016c: ldfld uint32[] ODCrypt.MD5::x
		IL_0171: ldloc.0
		IL_0172: ldc.i4.0
		IL_0173: stelem.i4
		IL_0174: ldloc.0
		IL_0175: ldc.i4.1
		IL_0176: add
		IL_0177: stloc.0
		IL_0178: ldc.i4 1343160322
		IL_017d: stloc 2
		IL_0181: ldloca 2
		IL_0185: nop
		IL_0186: ldind.i2
		IL_0187: conv.i2
		IL_0188: conv.i
		IL_0189: stloc.1
		IL_018a: br IL_007f

		IL_018f: br IL_0107

		IL_0194: ret
	} // end of method MD5::Reset

	.method private hidebysig static 
		uint32 w (
			uint32 A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0x10778
		// Header size: 12
		// Code size: 174 (0xae)
		.maxstack 4
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1521478640
		IL_0005: stloc 0
		IL_0009: ldloca 0
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1399974896
		IL_0015: stloc 0
		IL_0019: ldloca 0
		IL_001d: nop
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_005f, IL_0033)

		IL_0033: br.s IL_004a

		IL_0035: ldc.i4 1293746176
		IL_003a: nop
		IL_003b: stloc 0
		IL_003f: nop
		IL_0040: ldloca 0
		IL_0044: nop
		IL_0045: ldind.i2
		IL_0046: conv.i2

		IL_0047: pop
		IL_0048: br.s IL_005d

		IL_004a: ldc.i4 1433796608
		IL_004f: nop
		IL_0050: stloc 0
		IL_0054: ldloca 0
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_0047

		IL_005d: nop
		IL_005e: nop

		IL_005f: ldc.i4 1837629440
		IL_0064: nop
		IL_0065: stloc 0
		IL_0069: ldloca 0
		IL_006d: nop
		IL_006e: ldind.i2
		IL_006f: conv.i2
		IL_0070: brfalse IL_0075

		IL_0075: ldc.i4 655753217
		IL_007a: stloc 0
		IL_007e: nop
		IL_007f: ldloca 0
		IL_0083: nop
		IL_0084: ldind.i2
		IL_0085: conv.i2
		IL_0086: br.s IL_009b

		IL_0088: ldc.i4 1278017536
		IL_008d: nop
		IL_008e: stloc 0
		IL_0092: ldloca 0
		IL_0096: nop
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: br.s IL_009b

		IL_009b: brfalse.s IL_009d

		IL_009d: ldarg.0
		IL_009e: ldarg.1
		IL_009f: ldc.i4.s 31
		IL_00a1: and
		IL_00a2: shl
		IL_00a3: ldarg.0
		IL_00a4: ldc.i4.s 32
		IL_00a6: ldarg.1
		IL_00a7: sub
		IL_00a8: ldc.i4.s 31
		IL_00aa: and
		IL_00ab: shr.un
		IL_00ac: or
		IL_00ad: ret
	} // end of method MD5::w

	.method private hidebysig static 
		uint32 h (
			uint32 A_0,
			uint32 A_1,
			uint32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x10834
		// Header size: 12
		// Code size: 164 (0xa4)
		.maxstack 3
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 365714343
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: ldloca 0
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 201153447
		IL_0016: nop
		IL_0017: stloc 0
		IL_001b: ldloca 0
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_005e, IL_0035)

		IL_0035: br.s IL_004a

		IL_0037: ldc.i4 203685888
		IL_003c: stloc 0
		IL_0040: nop
		IL_0041: ldloca 0
		IL_0045: ldind.i2
		IL_0046: conv.i2

		IL_0047: pop
		IL_0048: br.s IL_005c

		IL_004a: ldc.i4 1718943744
		IL_004f: stloc 0
		IL_0053: ldloca 0
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_0047

		IL_005c: nop
		IL_005d: nop

		IL_005e: ldc.i4 1592918017
		IL_0063: stloc 0
		IL_0067: nop
		IL_0068: ldloca 0
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: br.s IL_0084

		IL_0071: ldc.i4 480968704
		IL_0076: nop
		IL_0077: stloc 0
		IL_007b: ldloca 0
		IL_007f: nop
		IL_0080: ldind.i2
		IL_0081: conv.i2
		IL_0082: br.s IL_0084

		IL_0084: brfalse.s IL_0086

		IL_0086: ldc.i4 1278148608
		IL_008b: stloc 0
		IL_008f: ldloca 0
		IL_0093: nop
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: brfalse IL_009b

		IL_009b: ldarg.0
		IL_009c: ldarg.1
		IL_009d: and
		IL_009e: ldarg.0
		IL_009f: not
		IL_00a0: ldarg.2
		IL_00a1: and
		IL_00a2: or
		IL_00a3: ret
	} // end of method MD5::h

	.method private hidebysig static 
		uint32 m (
			uint32 A_0,
			uint32 A_1,
			uint32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x108e4
		// Header size: 12
		// Code size: 165 (0xa5)
		.maxstack 3
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1072939349
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: nop
		IL_0010: ldind.i2
		IL_0011: conv.i2
		IL_0012: ldc.i4 2067710293
		IL_0017: nop
		IL_0018: stloc 0
		IL_001c: ldloca 0
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_005f, IL_0035)

		IL_0035: br.s IL_004b

		IL_0037: ldc.i4 575471616
		IL_003c: nop
		IL_003d: stloc 0
		IL_0041: ldloca 0
		IL_0045: nop
		IL_0046: ldind.i2
		IL_0047: conv.i2

		IL_0048: pop
		IL_0049: br.s IL_005d

		IL_004b: ldc.i4 943587328
		IL_0050: stloc 0
		IL_0054: ldloca 0
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_0048

		IL_005d: nop
		IL_005e: nop

		IL_005f: ldc.i4 785317888
		IL_0064: nop
		IL_0065: stloc 0
		IL_0069: nop
		IL_006a: ldloca 0
		IL_006e: nop
		IL_006f: ldind.i2
		IL_0070: conv.i2
		IL_0071: brfalse IL_0076

		IL_0076: ldc.i4 2117795841
		IL_007b: stloc 0
		IL_007f: ldloca 0
		IL_0083: nop
		IL_0084: ldind.i2
		IL_0085: conv.i2
		IL_0086: br.s IL_009a

		IL_0088: ldc.i4 716701696
		IL_008d: stloc 0
		IL_0091: nop
		IL_0092: ldloca 0
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: br.s IL_009a

		IL_009a: brfalse.s IL_009c

		IL_009c: ldarg.0
		IL_009d: ldarg.2
		IL_009e: and
		IL_009f: ldarg.1
		IL_00a0: ldarg.2
		IL_00a1: not
		IL_00a2: and
		IL_00a3: or
		IL_00a4: ret
	} // end of method MD5::m

	.method private hidebysig static 
		uint32 r (
			uint32 A_0,
			uint32 A_1,
			uint32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x10998
		// Header size: 12
		// Code size: 163 (0xa3)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 24967609
		IL_0005: stloc 0
		IL_0009: nop
		IL_000a: ldloca 0
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1526462905
		IL_0015: nop
		IL_0016: stloc 0
		IL_001a: ldloca 0
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_005f, IL_0033)

		IL_0033: br.s IL_0049

		IL_0035: ldc.i4 2024144896
		IL_003a: nop
		IL_003b: stloc 0
		IL_003f: nop
		IL_0040: ldloca 0
		IL_0044: ldind.i2
		IL_0045: conv.i2

		IL_0046: pop
		IL_0047: br.s IL_005d

		IL_0049: ldc.i4 135069696
		IL_004e: nop
		IL_004f: stloc 0
		IL_0053: nop
		IL_0054: ldloca 0
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_0046

		IL_005d: nop
		IL_005e: nop

		IL_005f: ldc.i4 1507917824
		IL_0064: stloc 0
		IL_0068: ldloca 0
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: brfalse IL_0074

		IL_0074: ldc.i4 1739390977
		IL_0079: stloc 0
		IL_007d: nop
		IL_007e: ldloca 0
		IL_0082: nop
		IL_0083: ldind.i2
		IL_0084: conv.i2
		IL_0085: br.s IL_009b

		IL_0087: ldc.i4 587399168
		IL_008c: nop
		IL_008d: stloc 0
		IL_0091: nop
		IL_0092: ldloca 0
		IL_0096: nop
		IL_0097: ldind.i2
		IL_0098: conv.i2
		IL_0099: br.s IL_009b

		IL_009b: brfalse.s IL_009d

		IL_009d: ldarg.0
		IL_009e: ldarg.1
		IL_009f: xor
		IL_00a0: ldarg.2
		IL_00a1: xor
		IL_00a2: ret
	} // end of method MD5::r

	.method private hidebysig static 
		uint32 w (
			uint32 A_0,
			uint32 A_1,
			uint32 A_2
		) cil managed 
	{
		// Method begins at RVA 0x10a48
		// Header size: 12
		// Code size: 165 (0xa5)
		.maxstack 3
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 380035154
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: ldloca 0
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 444260434
		IL_0016: stloc 0
		IL_001a: ldloca 0
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 1491664896
		IL_003a: nop
		IL_003b: stloc 0
		IL_003f: nop
		IL_0040: ldloca 0
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: brfalse IL_004b

		IL_004b: ldc.i4 631963649
		IL_0050: stloc 0
		IL_0054: ldloca 0
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_0071

		IL_005d: ldc.i4 545652736
		IL_0062: nop
		IL_0063: stloc 0
		IL_0067: nop
		IL_0068: ldloca 0
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: br.s IL_0071

		IL_0071: brfalse.s IL_0073

		IL_0073: br.s IL_0089

		IL_0075: ldc.i4 302972928
		IL_007a: nop
		IL_007b: stloc 0
		IL_007f: ldloca 0
		IL_0083: nop
		IL_0084: ldind.i2
		IL_0085: conv.i2

		IL_0086: pop
		IL_0087: br.s IL_009d

		IL_0089: ldc.i4 1039990784
		IL_008e: nop
		IL_008f: stloc 0
		IL_0093: nop
		IL_0094: ldloca 0
		IL_0098: nop
		IL_0099: ldind.i2
		IL_009a: conv.i2
		IL_009b: br.s IL_0086

		IL_009d: nop
		IL_009e: ldarg.1
		IL_009f: ldarg.0
		IL_00a0: ldarg.2
		IL_00a1: not
		IL_00a2: or
		IL_00a3: xor
		IL_00a4: ret
	} // end of method MD5::w

	.method assembly hidebysig 
		instance void w () cil managed 
	{
		// Method begins at RVA 0x10afc
		// Header size: 12
		// Code size: 2706 (0xa92)
		.maxstack 4
		.locals init (
			[0] uint32,
			[1] uint32,
			[2] uint32,
			[3] uint32,
			[4] int16
		)

		IL_0000: ldc.i4 460298102
		IL_0005: stloc 4
		IL_0009: nop
		IL_000a: ldloca 4
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 124163958
		IL_0015: stloc 4
		IL_0019: nop
		IL_001a: ldloca 4
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 747569153
		IL_003a: stloc 4
		IL_003e: ldloca 4
		IL_0042: nop
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: br.s IL_0059

		IL_0047: ldc.i4 2040070144
		IL_004c: stloc 4
		IL_0050: ldloca 4
		IL_0054: nop
		IL_0055: ldind.i2
		IL_0056: conv.i2
		IL_0057: br.s IL_0059

		IL_0059: brfalse.s IL_005b

		IL_005b: ldc.i4 2093416448
		IL_0060: stloc 4
		IL_0064: nop
		IL_0065: ldloca 4
		IL_0069: ldind.i2
		IL_006a: conv.i2
		IL_006b: brfalse IL_0070

		IL_0070: br.s IL_0085

		IL_0072: ldc.i4 58720256
		IL_0077: nop
		IL_0078: stloc 4
		IL_007c: ldloca 4
		IL_0080: ldind.i2
		IL_0081: conv.i2

		IL_0082: pop
		IL_0083: br.s IL_0099

		IL_0085: ldc.i4 1906114560
		IL_008a: nop
		IL_008b: stloc 4
		IL_008f: nop
		IL_0090: ldloca 4
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: br.s IL_0082

		IL_0099: nop
		IL_009a: ldarg.0
		IL_009b: ldfld uint32 ODCrypt.MD5::r
		IL_00a0: stloc.0
		IL_00a1: ldarg.0
		IL_00a2: ldfld uint32 ODCrypt.MD5::m
		IL_00a7: stloc.1
		IL_00a8: ldarg.0
		IL_00a9: ldfld uint32 ODCrypt.MD5::h
		IL_00ae: stloc.2
		IL_00af: ldarg.0
		IL_00b0: ldfld uint32 ODCrypt.MD5::c
		IL_00b5: stloc.3
		IL_00b6: ldloc.0
		IL_00b7: ldloc.1
		IL_00b8: ldloc.2
		IL_00b9: ldloc.3
		IL_00ba: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_00bf: add
		IL_00c0: ldarg.0
		IL_00c1: ldfld uint32[] ODCrypt.MD5::x
		IL_00c6: ldc.i4.0
		IL_00c7: ldelem.u4
		IL_00c8: add
		IL_00c9: ldc.i4 -680876936
		IL_00ce: add
		IL_00cf: ldsfld int32 ODCrypt.MD5::t
		IL_00d4: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_00d9: ldloc.1
		IL_00da: add
		IL_00db: stloc.0
		IL_00dc: ldloc.3
		IL_00dd: ldloc.0
		IL_00de: ldloc.1
		IL_00df: ldloc.2
		IL_00e0: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_00e5: add
		IL_00e6: ldarg.0
		IL_00e7: ldfld uint32[] ODCrypt.MD5::x
		IL_00ec: ldc.i4.1
		IL_00ed: ldelem.u4
		IL_00ee: add
		IL_00ef: ldc.i4 -389564586
		IL_00f4: add
		IL_00f5: ldsfld int32 ODCrypt.MD5::o
		IL_00fa: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_00ff: ldloc.0
		IL_0100: add
		IL_0101: stloc.3
		IL_0102: ldloc.2
		IL_0103: ldloc.3
		IL_0104: ldloc.0
		IL_0105: ldloc.1
		IL_0106: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_010b: add
		IL_010c: ldarg.0
		IL_010d: ldfld uint32[] ODCrypt.MD5::x
		IL_0112: ldc.i4.2
		IL_0113: ldelem.u4
		IL_0114: add
		IL_0115: ldc.i4 606105819
		IL_011a: add
		IL_011b: ldsfld int32 ODCrypt.MD5::j
		IL_0120: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0125: ldloc.3
		IL_0126: add
		IL_0127: stloc.2
		IL_0128: ldloc.1
		IL_0129: ldloc.2
		IL_012a: ldloc.3
		IL_012b: ldloc.0
		IL_012c: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_0131: add
		IL_0132: ldarg.0
		IL_0133: ldfld uint32[] ODCrypt.MD5::x
		IL_0138: ldc.i4.3
		IL_0139: ldelem.u4
		IL_013a: add
		IL_013b: ldc.i4 -1044525330
		IL_0140: add
		IL_0141: ldsfld int32 ODCrypt.MD5::e
		IL_0146: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_014b: ldloc.2
		IL_014c: add
		IL_014d: stloc.1
		IL_014e: ldloc.0
		IL_014f: ldloc.1
		IL_0150: ldloc.2
		IL_0151: ldloc.3
		IL_0152: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_0157: add
		IL_0158: ldarg.0
		IL_0159: ldfld uint32[] ODCrypt.MD5::x
		IL_015e: ldc.i4.4
		IL_015f: ldelem.u4
		IL_0160: add
		IL_0161: ldc.i4 -176418897
		IL_0166: add
		IL_0167: ldsfld int32 ODCrypt.MD5::t
		IL_016c: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0171: ldloc.1
		IL_0172: add
		IL_0173: stloc.0
		IL_0174: ldloc.3
		IL_0175: ldloc.0
		IL_0176: ldloc.1
		IL_0177: ldloc.2
		IL_0178: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_017d: add
		IL_017e: ldarg.0
		IL_017f: ldfld uint32[] ODCrypt.MD5::x
		IL_0184: ldc.i4.5
		IL_0185: ldelem.u4
		IL_0186: add
		IL_0187: ldc.i4 1200080426
		IL_018c: add
		IL_018d: ldsfld int32 ODCrypt.MD5::o
		IL_0192: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0197: ldloc.0
		IL_0198: add
		IL_0199: stloc.3
		IL_019a: ldloc.2
		IL_019b: ldloc.3
		IL_019c: ldloc.0
		IL_019d: ldloc.1
		IL_019e: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_01a3: add
		IL_01a4: ldarg.0
		IL_01a5: ldfld uint32[] ODCrypt.MD5::x
		IL_01aa: ldc.i4.6
		IL_01ab: ldelem.u4
		IL_01ac: add
		IL_01ad: ldc.i4 -1473231341
		IL_01b2: add
		IL_01b3: ldsfld int32 ODCrypt.MD5::j
		IL_01b8: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_01bd: ldloc.3
		IL_01be: add
		IL_01bf: stloc.2
		IL_01c0: ldloc.1
		IL_01c1: ldloc.2
		IL_01c2: ldloc.3
		IL_01c3: ldloc.0
		IL_01c4: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_01c9: add
		IL_01ca: ldarg.0
		IL_01cb: ldfld uint32[] ODCrypt.MD5::x
		IL_01d0: ldc.i4.7
		IL_01d1: ldelem.u4
		IL_01d2: add
		IL_01d3: ldc.i4 -45705983
		IL_01d8: add
		IL_01d9: ldsfld int32 ODCrypt.MD5::e
		IL_01de: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_01e3: ldloc.2
		IL_01e4: add
		IL_01e5: stloc.1
		IL_01e6: ldloc.0
		IL_01e7: ldloc.1
		IL_01e8: ldloc.2
		IL_01e9: ldloc.3
		IL_01ea: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_01ef: add
		IL_01f0: ldarg.0
		IL_01f1: ldfld uint32[] ODCrypt.MD5::x
		IL_01f6: ldc.i4.8
		IL_01f7: ldelem.u4
		IL_01f8: add
		IL_01f9: ldc.i4 1770035416
		IL_01fe: add
		IL_01ff: ldsfld int32 ODCrypt.MD5::t
		IL_0204: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0209: ldloc.1
		IL_020a: add
		IL_020b: stloc.0
		IL_020c: ldloc.3
		IL_020d: ldloc.0
		IL_020e: ldloc.1
		IL_020f: ldloc.2
		IL_0210: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_0215: add
		IL_0216: ldarg.0
		IL_0217: ldfld uint32[] ODCrypt.MD5::x
		IL_021c: ldc.i4.s 9
		IL_021e: ldelem.u4
		IL_021f: add
		IL_0220: ldc.i4 -1958414417
		IL_0225: add
		IL_0226: ldsfld int32 ODCrypt.MD5::o
		IL_022b: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0230: ldloc.0
		IL_0231: add
		IL_0232: stloc.3
		IL_0233: ldloc.2
		IL_0234: ldloc.3
		IL_0235: ldloc.0
		IL_0236: ldloc.1
		IL_0237: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_023c: add
		IL_023d: ldarg.0
		IL_023e: ldfld uint32[] ODCrypt.MD5::x
		IL_0243: ldc.i4.s 10
		IL_0245: ldelem.u4
		IL_0246: add
		IL_0247: ldc.i4 -42063
		IL_024c: add
		IL_024d: ldsfld int32 ODCrypt.MD5::j
		IL_0252: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0257: ldloc.3
		IL_0258: add
		IL_0259: stloc.2
		IL_025a: ldloc.1
		IL_025b: ldloc.2
		IL_025c: ldloc.3
		IL_025d: ldloc.0
		IL_025e: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_0263: add
		IL_0264: ldarg.0
		IL_0265: ldfld uint32[] ODCrypt.MD5::x
		IL_026a: ldc.i4.s 11
		IL_026c: ldelem.u4
		IL_026d: add
		IL_026e: ldc.i4 -1990404162
		IL_0273: add
		IL_0274: ldsfld int32 ODCrypt.MD5::e
		IL_0279: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_027e: ldloc.2
		IL_027f: add
		IL_0280: stloc.1
		IL_0281: ldloc.0
		IL_0282: ldloc.1
		IL_0283: ldloc.2
		IL_0284: ldloc.3
		IL_0285: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_028a: add
		IL_028b: ldarg.0
		IL_028c: ldfld uint32[] ODCrypt.MD5::x
		IL_0291: ldc.i4.s 12
		IL_0293: ldelem.u4
		IL_0294: add
		IL_0295: ldc.i4 1804603682
		IL_029a: add
		IL_029b: ldsfld int32 ODCrypt.MD5::t
		IL_02a0: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_02a5: ldloc.1
		IL_02a6: add
		IL_02a7: stloc.0
		IL_02a8: ldloc.3
		IL_02a9: ldloc.0
		IL_02aa: ldloc.1
		IL_02ab: ldloc.2
		IL_02ac: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_02b1: add
		IL_02b2: ldarg.0
		IL_02b3: ldfld uint32[] ODCrypt.MD5::x
		IL_02b8: ldc.i4.s 13
		IL_02ba: ldelem.u4
		IL_02bb: add
		IL_02bc: ldc.i4 -40341101
		IL_02c1: add
		IL_02c2: ldsfld int32 ODCrypt.MD5::o
		IL_02c7: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_02cc: ldloc.0
		IL_02cd: add
		IL_02ce: stloc.3
		IL_02cf: ldloc.2
		IL_02d0: ldloc.3
		IL_02d1: ldloc.0
		IL_02d2: ldloc.1
		IL_02d3: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_02d8: add
		IL_02d9: ldarg.0
		IL_02da: ldfld uint32[] ODCrypt.MD5::x
		IL_02df: ldc.i4.s 14
		IL_02e1: ldelem.u4
		IL_02e2: add
		IL_02e3: ldc.i4 -1502002290
		IL_02e8: add
		IL_02e9: ldsfld int32 ODCrypt.MD5::j
		IL_02ee: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_02f3: ldloc.3
		IL_02f4: add
		IL_02f5: stloc.2
		IL_02f6: ldloc.1
		IL_02f7: ldloc.2
		IL_02f8: ldloc.3
		IL_02f9: ldloc.0
		IL_02fa: call uint32 ODCrypt.MD5::h(uint32, uint32, uint32)
		IL_02ff: add
		IL_0300: ldarg.0
		IL_0301: ldfld uint32[] ODCrypt.MD5::x
		IL_0306: ldc.i4.s 15
		IL_0308: ldelem.u4
		IL_0309: add
		IL_030a: ldc.i4 1236535329
		IL_030f: add
		IL_0310: ldsfld int32 ODCrypt.MD5::e
		IL_0315: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_031a: ldloc.2
		IL_031b: add
		IL_031c: stloc.1
		IL_031d: ldloc.0
		IL_031e: ldloc.1
		IL_031f: ldloc.2
		IL_0320: ldloc.3
		IL_0321: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_0326: add
		IL_0327: ldarg.0
		IL_0328: ldfld uint32[] ODCrypt.MD5::x
		IL_032d: ldc.i4.1
		IL_032e: ldelem.u4
		IL_032f: add
		IL_0330: ldc.i4 -165796510
		IL_0335: add
		IL_0336: ldsfld int32 ODCrypt.MD5::z
		IL_033b: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0340: ldloc.1
		IL_0341: add
		IL_0342: stloc.0
		IL_0343: ldloc.3
		IL_0344: ldloc.0
		IL_0345: ldloc.1
		IL_0346: ldloc.2
		IL_0347: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_034c: add
		IL_034d: ldarg.0
		IL_034e: ldfld uint32[] ODCrypt.MD5::x
		IL_0353: ldc.i4.6
		IL_0354: ldelem.u4
		IL_0355: add
		IL_0356: ldc.i4 -1069501632
		IL_035b: add
		IL_035c: ldsfld int32 ODCrypt.MD5::u
		IL_0361: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0366: ldloc.0
		IL_0367: add
		IL_0368: stloc.3
		IL_0369: ldloc.2
		IL_036a: ldloc.3
		IL_036b: ldloc.0
		IL_036c: ldloc.1
		IL_036d: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_0372: add
		IL_0373: ldarg.0
		IL_0374: ldfld uint32[] ODCrypt.MD5::x
		IL_0379: ldc.i4.s 11
		IL_037b: ldelem.u4
		IL_037c: add
		IL_037d: ldc.i4 643717713
		IL_0382: add
		IL_0383: ldsfld int32 ODCrypt.MD5::p
		IL_0388: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_038d: ldloc.3
		IL_038e: add
		IL_038f: stloc.2
		IL_0390: ldloc.1
		IL_0391: ldloc.2
		IL_0392: ldloc.3
		IL_0393: ldloc.0
		IL_0394: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_0399: add
		IL_039a: ldarg.0
		IL_039b: ldfld uint32[] ODCrypt.MD5::x
		IL_03a0: ldc.i4.0
		IL_03a1: ldelem.u4
		IL_03a2: add
		IL_03a3: ldc.i4 -373897302
		IL_03a8: add
		IL_03a9: ldsfld int32 ODCrypt.MD5::k
		IL_03ae: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_03b3: ldloc.2
		IL_03b4: add
		IL_03b5: stloc.1
		IL_03b6: ldloc.0
		IL_03b7: ldloc.1
		IL_03b8: ldloc.2
		IL_03b9: ldloc.3
		IL_03ba: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_03bf: add
		IL_03c0: ldarg.0
		IL_03c1: ldfld uint32[] ODCrypt.MD5::x
		IL_03c6: ldc.i4.5
		IL_03c7: ldelem.u4
		IL_03c8: add
		IL_03c9: ldc.i4 -701558691
		IL_03ce: add
		IL_03cf: ldsfld int32 ODCrypt.MD5::z
		IL_03d4: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_03d9: ldloc.1
		IL_03da: add
		IL_03db: stloc.0
		IL_03dc: ldloc.3
		IL_03dd: ldloc.0
		IL_03de: ldloc.1
		IL_03df: ldloc.2
		IL_03e0: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_03e5: add
		IL_03e6: ldarg.0
		IL_03e7: ldfld uint32[] ODCrypt.MD5::x
		IL_03ec: ldc.i4.s 10
		IL_03ee: ldelem.u4
		IL_03ef: add
		IL_03f0: ldc.i4 38016083
		IL_03f5: add
		IL_03f6: ldsfld int32 ODCrypt.MD5::u
		IL_03fb: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0400: ldloc.0
		IL_0401: add
		IL_0402: stloc.3
		IL_0403: ldloc.2
		IL_0404: ldloc.3
		IL_0405: ldloc.0
		IL_0406: ldloc.1
		IL_0407: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_040c: add
		IL_040d: ldarg.0
		IL_040e: ldfld uint32[] ODCrypt.MD5::x
		IL_0413: ldc.i4.s 15
		IL_0415: ldelem.u4
		IL_0416: add
		IL_0417: ldc.i4 -660478335
		IL_041c: add
		IL_041d: ldsfld int32 ODCrypt.MD5::p
		IL_0422: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0427: ldloc.3
		IL_0428: add
		IL_0429: stloc.2
		IL_042a: ldloc.1
		IL_042b: ldloc.2
		IL_042c: ldloc.3
		IL_042d: ldloc.0
		IL_042e: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_0433: add
		IL_0434: ldarg.0
		IL_0435: ldfld uint32[] ODCrypt.MD5::x
		IL_043a: ldc.i4.4
		IL_043b: ldelem.u4
		IL_043c: add
		IL_043d: ldc.i4 -405537848
		IL_0442: add
		IL_0443: ldsfld int32 ODCrypt.MD5::k
		IL_0448: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_044d: ldloc.2
		IL_044e: add
		IL_044f: stloc.1
		IL_0450: ldloc.0
		IL_0451: ldloc.1
		IL_0452: ldloc.2
		IL_0453: ldloc.3
		IL_0454: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_0459: add
		IL_045a: ldarg.0
		IL_045b: ldfld uint32[] ODCrypt.MD5::x
		IL_0460: ldc.i4.s 9
		IL_0462: ldelem.u4
		IL_0463: add
		IL_0464: ldc.i4 568446438
		IL_0469: add
		IL_046a: ldsfld int32 ODCrypt.MD5::z
		IL_046f: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0474: ldloc.1
		IL_0475: add
		IL_0476: stloc.0
		IL_0477: ldloc.3
		IL_0478: ldloc.0
		IL_0479: ldloc.1
		IL_047a: ldloc.2
		IL_047b: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_0480: add
		IL_0481: ldarg.0
		IL_0482: ldfld uint32[] ODCrypt.MD5::x
		IL_0487: ldc.i4.s 14
		IL_0489: ldelem.u4
		IL_048a: add
		IL_048b: ldc.i4 -1019803690
		IL_0490: add
		IL_0491: ldsfld int32 ODCrypt.MD5::u
		IL_0496: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_049b: ldloc.0
		IL_049c: add
		IL_049d: stloc.3
		IL_049e: ldloc.2
		IL_049f: ldloc.3
		IL_04a0: ldloc.0
		IL_04a1: ldloc.1
		IL_04a2: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_04a7: add
		IL_04a8: ldarg.0
		IL_04a9: ldfld uint32[] ODCrypt.MD5::x
		IL_04ae: ldc.i4.3
		IL_04af: ldelem.u4
		IL_04b0: add
		IL_04b1: ldc.i4 -187363961
		IL_04b6: add
		IL_04b7: ldsfld int32 ODCrypt.MD5::p
		IL_04bc: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_04c1: ldloc.3
		IL_04c2: add
		IL_04c3: stloc.2
		IL_04c4: ldloc.1
		IL_04c5: ldloc.2
		IL_04c6: ldloc.3
		IL_04c7: ldloc.0
		IL_04c8: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_04cd: add
		IL_04ce: ldarg.0
		IL_04cf: ldfld uint32[] ODCrypt.MD5::x
		IL_04d4: ldc.i4.8
		IL_04d5: ldelem.u4
		IL_04d6: add
		IL_04d7: ldc.i4 1163531501
		IL_04dc: add
		IL_04dd: ldsfld int32 ODCrypt.MD5::k
		IL_04e2: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_04e7: ldloc.2
		IL_04e8: add
		IL_04e9: stloc.1
		IL_04ea: ldloc.0
		IL_04eb: ldloc.1
		IL_04ec: ldloc.2
		IL_04ed: ldloc.3
		IL_04ee: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_04f3: add
		IL_04f4: ldarg.0
		IL_04f5: ldfld uint32[] ODCrypt.MD5::x
		IL_04fa: ldc.i4.s 13
		IL_04fc: ldelem.u4
		IL_04fd: add
		IL_04fe: ldc.i4 -1444681467
		IL_0503: add
		IL_0504: ldsfld int32 ODCrypt.MD5::z
		IL_0509: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_050e: ldloc.1
		IL_050f: add
		IL_0510: stloc.0
		IL_0511: ldloc.3
		IL_0512: ldloc.0
		IL_0513: ldloc.1
		IL_0514: ldloc.2
		IL_0515: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_051a: add
		IL_051b: ldarg.0
		IL_051c: ldfld uint32[] ODCrypt.MD5::x
		IL_0521: ldc.i4.2
		IL_0522: ldelem.u4
		IL_0523: add
		IL_0524: ldc.i4 -51403784
		IL_0529: add
		IL_052a: ldsfld int32 ODCrypt.MD5::u
		IL_052f: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0534: ldloc.0
		IL_0535: add
		IL_0536: stloc.3
		IL_0537: ldloc.2
		IL_0538: ldloc.3
		IL_0539: ldloc.0
		IL_053a: ldloc.1
		IL_053b: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_0540: add
		IL_0541: ldarg.0
		IL_0542: ldfld uint32[] ODCrypt.MD5::x
		IL_0547: ldc.i4.7
		IL_0548: ldelem.u4
		IL_0549: add
		IL_054a: ldc.i4 1735328473
		IL_054f: add
		IL_0550: ldsfld int32 ODCrypt.MD5::p
		IL_0555: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_055a: ldloc.3
		IL_055b: add
		IL_055c: stloc.2
		IL_055d: ldloc.1
		IL_055e: ldloc.2
		IL_055f: ldloc.3
		IL_0560: ldloc.0
		IL_0561: call uint32 ODCrypt.MD5::m(uint32, uint32, uint32)
		IL_0566: add
		IL_0567: ldarg.0
		IL_0568: ldfld uint32[] ODCrypt.MD5::x
		IL_056d: ldc.i4.s 12
		IL_056f: ldelem.u4
		IL_0570: add
		IL_0571: ldc.i4 -1926607734
		IL_0576: add
		IL_0577: ldsfld int32 ODCrypt.MD5::k
		IL_057c: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0581: ldloc.2
		IL_0582: add
		IL_0583: stloc.1
		IL_0584: ldloc.0
		IL_0585: ldloc.1
		IL_0586: ldloc.2
		IL_0587: ldloc.3
		IL_0588: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_058d: add
		IL_058e: ldarg.0
		IL_058f: ldfld uint32[] ODCrypt.MD5::x
		IL_0594: ldc.i4.5
		IL_0595: ldelem.u4
		IL_0596: add
		IL_0597: ldc.i4 -378558
		IL_059c: add
		IL_059d: ldsfld int32 ODCrypt.MD5::f
		IL_05a2: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_05a7: ldloc.1
		IL_05a8: add
		IL_05a9: stloc.0
		IL_05aa: ldloc.3
		IL_05ab: ldloc.0
		IL_05ac: ldloc.1
		IL_05ad: ldloc.2
		IL_05ae: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_05b3: add
		IL_05b4: ldarg.0
		IL_05b5: ldfld uint32[] ODCrypt.MD5::x
		IL_05ba: ldc.i4.8
		IL_05bb: ldelem.u4
		IL_05bc: add
		IL_05bd: ldc.i4 -2022574463
		IL_05c2: add
		IL_05c3: ldsfld int32 ODCrypt.MD5::a
		IL_05c8: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_05cd: ldloc.0
		IL_05ce: add
		IL_05cf: stloc.3
		IL_05d0: ldloc.2
		IL_05d1: ldloc.3
		IL_05d2: ldloc.0
		IL_05d3: ldloc.1
		IL_05d4: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_05d9: add
		IL_05da: ldarg.0
		IL_05db: ldfld uint32[] ODCrypt.MD5::x
		IL_05e0: ldc.i4.s 11
		IL_05e2: ldelem.u4
		IL_05e3: add
		IL_05e4: ldc.i4 1839030562
		IL_05e9: add
		IL_05ea: ldsfld int32 ODCrypt.MD5::v
		IL_05ef: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_05f4: ldloc.3
		IL_05f5: add
		IL_05f6: stloc.2
		IL_05f7: ldloc.1
		IL_05f8: ldloc.2
		IL_05f9: ldloc.3
		IL_05fa: ldloc.0
		IL_05fb: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_0600: add
		IL_0601: ldarg.0
		IL_0602: ldfld uint32[] ODCrypt.MD5::x
		IL_0607: ldc.i4.s 14
		IL_0609: ldelem.u4
		IL_060a: add
		IL_060b: ldc.i4 -35309556
		IL_0610: add
		IL_0611: ldsfld int32 ODCrypt.MD5::q
		IL_0616: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_061b: ldloc.2
		IL_061c: add
		IL_061d: stloc.1
		IL_061e: ldloc.0
		IL_061f: ldloc.1
		IL_0620: ldloc.2
		IL_0621: ldloc.3
		IL_0622: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_0627: add
		IL_0628: ldarg.0
		IL_0629: ldfld uint32[] ODCrypt.MD5::x
		IL_062e: ldc.i4.1
		IL_062f: ldelem.u4
		IL_0630: add
		IL_0631: ldc.i4 -1530992060
		IL_0636: add
		IL_0637: ldsfld int32 ODCrypt.MD5::f
		IL_063c: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0641: ldloc.1
		IL_0642: add
		IL_0643: stloc.0
		IL_0644: ldloc.3
		IL_0645: ldloc.0
		IL_0646: ldloc.1
		IL_0647: ldloc.2
		IL_0648: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_064d: add
		IL_064e: ldarg.0
		IL_064f: ldfld uint32[] ODCrypt.MD5::x
		IL_0654: ldc.i4.4
		IL_0655: ldelem.u4
		IL_0656: add
		IL_0657: ldc.i4 1272893353
		IL_065c: add
		IL_065d: ldsfld int32 ODCrypt.MD5::a
		IL_0662: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0667: ldloc.0
		IL_0668: add
		IL_0669: stloc.3
		IL_066a: ldloc.2
		IL_066b: ldloc.3
		IL_066c: ldloc.0
		IL_066d: ldloc.1
		IL_066e: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_0673: add
		IL_0674: ldarg.0
		IL_0675: ldfld uint32[] ODCrypt.MD5::x
		IL_067a: ldc.i4.7
		IL_067b: ldelem.u4
		IL_067c: add
		IL_067d: ldc.i4 -155497632
		IL_0682: add
		IL_0683: ldsfld int32 ODCrypt.MD5::v
		IL_0688: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_068d: ldloc.3
		IL_068e: add
		IL_068f: stloc.2
		IL_0690: ldloc.1
		IL_0691: ldloc.2
		IL_0692: ldloc.3
		IL_0693: ldloc.0
		IL_0694: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_0699: add
		IL_069a: ldarg.0
		IL_069b: ldfld uint32[] ODCrypt.MD5::x
		IL_06a0: ldc.i4.s 10
		IL_06a2: ldelem.u4
		IL_06a3: add
		IL_06a4: ldc.i4 -1094730640
		IL_06a9: add
		IL_06aa: ldsfld int32 ODCrypt.MD5::q
		IL_06af: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_06b4: ldloc.2
		IL_06b5: add
		IL_06b6: stloc.1
		IL_06b7: ldloc.0
		IL_06b8: ldloc.1
		IL_06b9: ldloc.2
		IL_06ba: ldloc.3
		IL_06bb: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_06c0: add
		IL_06c1: ldarg.0
		IL_06c2: ldfld uint32[] ODCrypt.MD5::x
		IL_06c7: ldc.i4.s 13
		IL_06c9: ldelem.u4
		IL_06ca: add
		IL_06cb: ldc.i4 681279174
		IL_06d0: add
		IL_06d1: ldsfld int32 ODCrypt.MD5::f
		IL_06d6: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_06db: ldloc.1
		IL_06dc: add
		IL_06dd: stloc.0
		IL_06de: ldloc.3
		IL_06df: ldloc.0
		IL_06e0: ldloc.1
		IL_06e1: ldloc.2
		IL_06e2: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_06e7: add
		IL_06e8: ldarg.0
		IL_06e9: ldfld uint32[] ODCrypt.MD5::x
		IL_06ee: ldc.i4.0
		IL_06ef: ldelem.u4
		IL_06f0: add
		IL_06f1: ldc.i4 -358537222
		IL_06f6: add
		IL_06f7: ldsfld int32 ODCrypt.MD5::a
		IL_06fc: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0701: ldloc.0
		IL_0702: add
		IL_0703: stloc.3
		IL_0704: ldloc.2
		IL_0705: ldloc.3
		IL_0706: ldloc.0
		IL_0707: ldloc.1
		IL_0708: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_070d: add
		IL_070e: ldarg.0
		IL_070f: ldfld uint32[] ODCrypt.MD5::x
		IL_0714: ldc.i4.3
		IL_0715: ldelem.u4
		IL_0716: add
		IL_0717: ldc.i4 -722521979
		IL_071c: add
		IL_071d: ldsfld int32 ODCrypt.MD5::v
		IL_0722: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0727: ldloc.3
		IL_0728: add
		IL_0729: stloc.2
		IL_072a: ldloc.1
		IL_072b: ldloc.2
		IL_072c: ldloc.3
		IL_072d: ldloc.0
		IL_072e: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_0733: add
		IL_0734: ldarg.0
		IL_0735: ldfld uint32[] ODCrypt.MD5::x
		IL_073a: ldc.i4.6
		IL_073b: ldelem.u4
		IL_073c: add
		IL_073d: ldc.i4 76029189
		IL_0742: add
		IL_0743: ldsfld int32 ODCrypt.MD5::q
		IL_0748: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_074d: ldloc.2
		IL_074e: add
		IL_074f: stloc.1
		IL_0750: ldloc.0
		IL_0751: ldloc.1
		IL_0752: ldloc.2
		IL_0753: ldloc.3
		IL_0754: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_0759: add
		IL_075a: ldarg.0
		IL_075b: ldfld uint32[] ODCrypt.MD5::x
		IL_0760: ldc.i4.s 9
		IL_0762: ldelem.u4
		IL_0763: add
		IL_0764: ldc.i4 -640364487
		IL_0769: add
		IL_076a: ldsfld int32 ODCrypt.MD5::f
		IL_076f: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0774: ldloc.1
		IL_0775: add
		IL_0776: stloc.0
		IL_0777: ldloc.3
		IL_0778: ldloc.0
		IL_0779: ldloc.1
		IL_077a: ldloc.2
		IL_077b: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_0780: add
		IL_0781: ldarg.0
		IL_0782: ldfld uint32[] ODCrypt.MD5::x
		IL_0787: ldc.i4.s 12
		IL_0789: ldelem.u4
		IL_078a: add
		IL_078b: ldc.i4 -421815835
		IL_0790: add
		IL_0791: ldsfld int32 ODCrypt.MD5::a
		IL_0796: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_079b: ldloc.0
		IL_079c: add
		IL_079d: stloc.3
		IL_079e: ldloc.2
		IL_079f: ldloc.3
		IL_07a0: ldloc.0
		IL_07a1: ldloc.1
		IL_07a2: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_07a7: add
		IL_07a8: ldarg.0
		IL_07a9: ldfld uint32[] ODCrypt.MD5::x
		IL_07ae: ldc.i4.s 15
		IL_07b0: ldelem.u4
		IL_07b1: add
		IL_07b2: ldc.i4 530742520
		IL_07b7: add
		IL_07b8: ldsfld int32 ODCrypt.MD5::v
		IL_07bd: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_07c2: ldloc.3
		IL_07c3: add
		IL_07c4: stloc.2
		IL_07c5: ldloc.1
		IL_07c6: ldloc.2
		IL_07c7: ldloc.3
		IL_07c8: ldloc.0
		IL_07c9: call uint32 ODCrypt.MD5::r(uint32, uint32, uint32)
		IL_07ce: add
		IL_07cf: ldarg.0
		IL_07d0: ldfld uint32[] ODCrypt.MD5::x
		IL_07d5: ldc.i4.2
		IL_07d6: ldelem.u4
		IL_07d7: add
		IL_07d8: ldc.i4 -995338651
		IL_07dd: add
		IL_07de: ldsfld int32 ODCrypt.MD5::q
		IL_07e3: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_07e8: ldloc.2
		IL_07e9: add
		IL_07ea: stloc.1
		IL_07eb: ldloc.0
		IL_07ec: ldloc.1
		IL_07ed: ldloc.2
		IL_07ee: ldloc.3
		IL_07ef: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_07f4: add
		IL_07f5: ldarg.0
		IL_07f6: ldfld uint32[] ODCrypt.MD5::x
		IL_07fb: ldc.i4.0
		IL_07fc: ldelem.u4
		IL_07fd: add
		IL_07fe: ldc.i4 -198630844
		IL_0803: add
		IL_0804: ldsfld int32 ODCrypt.MD5::l
		IL_0809: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_080e: ldloc.1
		IL_080f: add
		IL_0810: stloc.0
		IL_0811: ldloc.3
		IL_0812: ldloc.0
		IL_0813: ldloc.1
		IL_0814: ldloc.2
		IL_0815: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_081a: add
		IL_081b: ldarg.0
		IL_081c: ldfld uint32[] ODCrypt.MD5::x
		IL_0821: ldc.i4.7
		IL_0822: ldelem.u4
		IL_0823: add
		IL_0824: ldc.i4 1126891415
		IL_0829: add
		IL_082a: ldsfld int32 ODCrypt.MD5::g
		IL_082f: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0834: ldloc.0
		IL_0835: add
		IL_0836: stloc.3
		IL_0837: ldloc.2
		IL_0838: ldloc.3
		IL_0839: ldloc.0
		IL_083a: ldloc.1
		IL_083b: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_0840: add
		IL_0841: ldarg.0
		IL_0842: ldfld uint32[] ODCrypt.MD5::x
		IL_0847: ldc.i4.s 14
		IL_0849: ldelem.u4
		IL_084a: add
		IL_084b: ldc.i4 -1416354905
		IL_0850: add
		IL_0851: ldsfld int32 ODCrypt.MD5::b
		IL_0856: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_085b: ldloc.3
		IL_085c: add
		IL_085d: stloc.2
		IL_085e: ldloc.1
		IL_085f: ldloc.2
		IL_0860: ldloc.3
		IL_0861: ldloc.0
		IL_0862: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_0867: add
		IL_0868: ldarg.0
		IL_0869: ldfld uint32[] ODCrypt.MD5::x
		IL_086e: ldc.i4.5
		IL_086f: ldelem.u4
		IL_0870: add
		IL_0871: ldc.i4 -57434055
		IL_0876: add
		IL_0877: ldsfld int32 ODCrypt.MD5::w5
		IL_087c: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0881: ldloc.2
		IL_0882: add
		IL_0883: stloc.1
		IL_0884: ldloc.0
		IL_0885: ldloc.1
		IL_0886: ldloc.2
		IL_0887: ldloc.3
		IL_0888: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_088d: add
		IL_088e: ldarg.0
		IL_088f: ldfld uint32[] ODCrypt.MD5::x
		IL_0894: ldc.i4.s 12
		IL_0896: ldelem.u4
		IL_0897: add
		IL_0898: ldc.i4 1700485571
		IL_089d: add
		IL_089e: ldsfld int32 ODCrypt.MD5::l
		IL_08a3: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_08a8: ldloc.1
		IL_08a9: add
		IL_08aa: stloc.0
		IL_08ab: ldloc.3
		IL_08ac: ldloc.0
		IL_08ad: ldloc.1
		IL_08ae: ldloc.2
		IL_08af: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_08b4: add
		IL_08b5: ldarg.0
		IL_08b6: ldfld uint32[] ODCrypt.MD5::x
		IL_08bb: ldc.i4.3
		IL_08bc: ldelem.u4
		IL_08bd: add
		IL_08be: ldc.i4 -1894986606
		IL_08c3: add
		IL_08c4: ldsfld int32 ODCrypt.MD5::g
		IL_08c9: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_08ce: ldloc.0
		IL_08cf: add
		IL_08d0: stloc.3
		IL_08d1: ldloc.2
		IL_08d2: ldloc.3
		IL_08d3: ldloc.0
		IL_08d4: ldloc.1
		IL_08d5: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_08da: add
		IL_08db: ldarg.0
		IL_08dc: ldfld uint32[] ODCrypt.MD5::x
		IL_08e1: ldc.i4.s 10
		IL_08e3: ldelem.u4
		IL_08e4: add
		IL_08e5: ldc.i4 -1051523
		IL_08ea: add
		IL_08eb: ldsfld int32 ODCrypt.MD5::b
		IL_08f0: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_08f5: ldloc.3
		IL_08f6: add
		IL_08f7: stloc.2
		IL_08f8: ldloc.1
		IL_08f9: ldloc.2
		IL_08fa: ldloc.3
		IL_08fb: ldloc.0
		IL_08fc: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_0901: add
		IL_0902: ldarg.0
		IL_0903: ldfld uint32[] ODCrypt.MD5::x
		IL_0908: ldc.i4.1
		IL_0909: ldelem.u4
		IL_090a: add
		IL_090b: ldc.i4 -2054922799
		IL_0910: add
		IL_0911: ldsfld int32 ODCrypt.MD5::w5
		IL_0916: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_091b: ldloc.2
		IL_091c: add
		IL_091d: stloc.1
		IL_091e: ldloc.0
		IL_091f: ldloc.1
		IL_0920: ldloc.2
		IL_0921: ldloc.3
		IL_0922: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_0927: add
		IL_0928: ldarg.0
		IL_0929: ldfld uint32[] ODCrypt.MD5::x
		IL_092e: ldc.i4.8
		IL_092f: ldelem.u4
		IL_0930: add
		IL_0931: ldc.i4 1873313359
		IL_0936: add
		IL_0937: ldsfld int32 ODCrypt.MD5::l
		IL_093c: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0941: ldloc.1
		IL_0942: add
		IL_0943: stloc.0
		IL_0944: ldloc.3
		IL_0945: ldloc.0
		IL_0946: ldloc.1
		IL_0947: ldloc.2
		IL_0948: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_094d: add
		IL_094e: ldarg.0
		IL_094f: ldfld uint32[] ODCrypt.MD5::x
		IL_0954: ldc.i4.s 15
		IL_0956: ldelem.u4
		IL_0957: add
		IL_0958: ldc.i4 -30611744
		IL_095d: add
		IL_095e: ldsfld int32 ODCrypt.MD5::g
		IL_0963: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0968: ldloc.0
		IL_0969: add
		IL_096a: stloc.3
		IL_096b: ldloc.2
		IL_096c: ldloc.3
		IL_096d: ldloc.0
		IL_096e: ldloc.1
		IL_096f: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_0974: add
		IL_0975: ldarg.0
		IL_0976: ldfld uint32[] ODCrypt.MD5::x
		IL_097b: ldc.i4.6
		IL_097c: ldelem.u4
		IL_097d: add
		IL_097e: ldc.i4 -1560198380
		IL_0983: add
		IL_0984: ldsfld int32 ODCrypt.MD5::b
		IL_0989: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_098e: ldloc.3
		IL_098f: add
		IL_0990: stloc.2
		IL_0991: ldloc.1
		IL_0992: ldloc.2
		IL_0993: ldloc.3
		IL_0994: ldloc.0
		IL_0995: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_099a: add
		IL_099b: ldarg.0
		IL_099c: ldfld uint32[] ODCrypt.MD5::x
		IL_09a1: ldc.i4.s 13
		IL_09a3: ldelem.u4
		IL_09a4: add
		IL_09a5: ldc.i4 1309151649
		IL_09aa: add
		IL_09ab: ldsfld int32 ODCrypt.MD5::w5
		IL_09b0: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_09b5: ldloc.2
		IL_09b6: add
		IL_09b7: stloc.1
		IL_09b8: ldloc.0
		IL_09b9: ldloc.1
		IL_09ba: ldloc.2
		IL_09bb: ldloc.3
		IL_09bc: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_09c1: add
		IL_09c2: ldarg.0
		IL_09c3: ldfld uint32[] ODCrypt.MD5::x
		IL_09c8: ldc.i4.4
		IL_09c9: ldelem.u4
		IL_09ca: add
		IL_09cb: ldc.i4 -145523070
		IL_09d0: add
		IL_09d1: ldsfld int32 ODCrypt.MD5::l
		IL_09d6: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_09db: ldloc.1
		IL_09dc: add
		IL_09dd: stloc.0
		IL_09de: ldloc.3
		IL_09df: ldloc.0
		IL_09e0: ldloc.1
		IL_09e1: ldloc.2
		IL_09e2: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_09e7: add
		IL_09e8: ldarg.0
		IL_09e9: ldfld uint32[] ODCrypt.MD5::x
		IL_09ee: ldc.i4.s 11
		IL_09f0: ldelem.u4
		IL_09f1: add
		IL_09f2: ldc.i4 -1120210379
		IL_09f7: add
		IL_09f8: ldsfld int32 ODCrypt.MD5::g
		IL_09fd: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0a02: ldloc.0
		IL_0a03: add
		IL_0a04: stloc.3
		IL_0a05: ldloc.2
		IL_0a06: ldloc.3
		IL_0a07: ldloc.0
		IL_0a08: ldloc.1
		IL_0a09: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_0a0e: add
		IL_0a0f: ldarg.0
		IL_0a10: ldfld uint32[] ODCrypt.MD5::x
		IL_0a15: ldc.i4.2
		IL_0a16: ldelem.u4
		IL_0a17: add
		IL_0a18: ldc.i4 718787259
		IL_0a1d: add
		IL_0a1e: ldsfld int32 ODCrypt.MD5::b
		IL_0a23: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0a28: ldloc.3
		IL_0a29: add
		IL_0a2a: stloc.2
		IL_0a2b: ldloc.1
		IL_0a2c: ldloc.2
		IL_0a2d: ldloc.3
		IL_0a2e: ldloc.0
		IL_0a2f: call uint32 ODCrypt.MD5::w(uint32, uint32, uint32)
		IL_0a34: add
		IL_0a35: ldarg.0
		IL_0a36: ldfld uint32[] ODCrypt.MD5::x
		IL_0a3b: ldc.i4.s 9
		IL_0a3d: ldelem.u4
		IL_0a3e: add
		IL_0a3f: ldc.i4 -343485551
		IL_0a44: add
		IL_0a45: ldsfld int32 ODCrypt.MD5::w5
		IL_0a4a: call uint32 ODCrypt.MD5::w(uint32, int32)
		IL_0a4f: ldloc.2
		IL_0a50: add
		IL_0a51: stloc.1
		IL_0a52: ldarg.0
		IL_0a53: ldarg.0
		IL_0a54: ldfld uint32 ODCrypt.MD5::r
		IL_0a59: ldloc.0
		IL_0a5a: add
		IL_0a5b: stfld uint32 ODCrypt.MD5::r
		IL_0a60: ldarg.0
		IL_0a61: ldarg.0
		IL_0a62: ldfld uint32 ODCrypt.MD5::m
		IL_0a67: ldloc.1
		IL_0a68: add
		IL_0a69: stfld uint32 ODCrypt.MD5::m
		IL_0a6e: ldarg.0
		IL_0a6f: ldarg.0
		IL_0a70: ldfld uint32 ODCrypt.MD5::h
		IL_0a75: ldloc.2
		IL_0a76: add
		IL_0a77: stfld uint32 ODCrypt.MD5::h
		IL_0a7c: ldarg.0
		IL_0a7d: ldarg.0
		IL_0a7e: ldfld uint32 ODCrypt.MD5::c
		IL_0a83: ldloc.3
		IL_0a84: add
		IL_0a85: stfld uint32 ODCrypt.MD5::c
		IL_0a8a: ldarg.0
		IL_0a8b: ldc.i4.0
		IL_0a8c: stfld int32 ODCrypt.MD5::s
		IL_0a91: ret
	} // end of method MD5::w

	.method public hidebysig 
		instance class ODCrypt.MD5 Copy () cil managed 
	{
		// Method begins at RVA 0x1159c
		// Header size: 12
		// Code size: 161 (0xa1)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1029631774
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: ldloca 0
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1203171102
		IL_0015: nop
		IL_0016: stloc 0
		IL_001a: ldloca 0
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_0034, IL_0033)

		IL_0033: nop

		IL_0034: ldc.i4 792723457
		IL_0039: nop
		IL_003a: stloc 0
		IL_003e: nop
		IL_003f: ldloca 0
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: br.s IL_005a

		IL_0048: ldc.i4 2098331648
		IL_004d: stloc 0
		IL_0051: ldloca 0
		IL_0055: nop
		IL_0056: ldind.i2
		IL_0057: conv.i2
		IL_0058: br.s IL_005a

		IL_005a: brfalse.s IL_005c

		IL_005c: ldc.i4 1245184000
		IL_0061: nop
		IL_0062: stloc 0
		IL_0066: ldloca 0
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: brfalse IL_0071

		IL_0071: br.s IL_0087

		IL_0073: ldc.i4 1292173312
		IL_0078: nop
		IL_0079: stloc 0
		IL_007d: nop
		IL_007e: ldloca 0
		IL_0082: ldind.i2
		IL_0083: conv.i2

		IL_0084: pop
		IL_0085: br.s IL_0099

		IL_0087: ldc.i4 656408576
		IL_008c: stloc 0
		IL_0090: ldloca 0
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: br.s IL_0084

		IL_0099: nop
		IL_009a: ldarg.0
		IL_009b: newobj instance void ODCrypt.MD5::.ctor(class ODCrypt.MD5)
		IL_00a0: ret
	} // end of method MD5::Copy

	.method public hidebysig 
		instance void Reset (
			class ODCrypt.MD5 other
		) cil managed 
	{
		// Method begins at RVA 0x1164c
		// Header size: 12
		// Code size: 164 (0xa4)
		.maxstack 2
		.locals init (
			[0] class ODCrypt.MD5,
			[1] int16
		)

		IL_0000: ldc.i4 121307137
		IL_0005: nop
		IL_0006: stloc 1
		IL_000a: ldloca 1
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: br.s IL_0024

		IL_0012: ldc.i4 239140864
		IL_0017: stloc 1
		IL_001b: ldloca 1
		IL_001f: nop
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: br.s IL_0024

		IL_0024: brfalse.s IL_0026

		IL_0026: ldc.i4 215042483
		IL_002b: nop
		IL_002c: stloc 1
		IL_0030: ldloca 1
		IL_0034: ldind.i2
		IL_0035: conv.i2
		IL_0036: ldc.i4 1195002291
		IL_003b: stloc 1
		IL_003f: ldloca 1
		IL_0043: nop
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: ceq
		IL_0048: switch (IL_0059, IL_005a, IL_0059)

		IL_0059: nop

		IL_005a: ldc.i4 701956096
		IL_005f: stloc 1
		IL_0063: nop
		IL_0064: ldloca 1
		IL_0068: nop
		IL_0069: ldind.i2
		IL_006a: conv.i2
		IL_006b: brfalse IL_0070

		IL_0070: br.s IL_0085

		IL_0072: ldc.i4 1954676736
		IL_0077: stloc 1
		IL_007b: ldloca 1
		IL_007f: nop
		IL_0080: ldind.i2
		IL_0081: conv.i2

		IL_0082: pop
		IL_0083: br.s IL_0099

		IL_0085: ldc.i4 689766400
		IL_008a: nop
		IL_008b: stloc 1
		IL_008f: nop
		IL_0090: ldloca 1
		IL_0094: nop
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: br.s IL_0082

		IL_0099: nop
		IL_009a: ldarg.1
		IL_009b: stloc.0
		IL_009c: ldarg.0
		IL_009d: ldloc.0
		IL_009e: call instance void ODCrypt.MD5::w(class ODCrypt.MD5)
		IL_00a3: ret
	} // end of method MD5::Reset

	.method public hidebysig 
		instance void Update (
			uint8 input
		) cil managed 
	{
		// Method begins at RVA 0x116fc
		// Header size: 12
		// Code size: 339 (0x153)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] int32,
			[2] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0069)

		IL_000a: ldc.i4 1012945535
		IL_000f: nop
		IL_0010: stloc 2
		IL_0014: ldloca 2
		IL_0018: nop
		IL_0019: ldind.i2
		IL_001a: conv.i2
		IL_001b: ldc.i4 1160663679
		IL_0020: nop
		IL_0021: stloc 2
		IL_0025: nop
		IL_0026: ldloca 2
		IL_002a: nop
		IL_002b: ldind.i2
		IL_002c: conv.i2
		IL_002d: ceq
		IL_002f: switch (IL_0069, IL_0041, IL_0069)

		IL_0040: nop

		IL_0041: ldc.i4 1439432704
		IL_0046: stloc 2
		IL_004a: nop
		IL_004b: ldloca 2
		IL_004f: nop
		IL_0050: ldind.i2
		IL_0051: conv.i2
		IL_0052: brfalse IL_0057

		IL_0057: ldloc.1
		IL_0058: switch (IL_0141, IL_009a, IL_00c4)

		IL_0069: ldarg.0
		IL_006a: ldfld uint8[] ODCrypt.MD5::i
		IL_006f: ldarg.0
		IL_0070: ldarg.0
		IL_0071: ldfld int32 ODCrypt.MD5::d
		IL_0076: stloc.0
		IL_0077: ldloc.0
		IL_0078: ldc.i4.1
		IL_0079: add
		IL_007a: stfld int32 ODCrypt.MD5::d
		IL_007f: ldloc.0
		IL_0080: ldarg.1
		IL_0081: stelem.i1
		IL_0082: ldc.i4 347209729
		IL_0087: nop
		IL_0088: stloc 2
		IL_008c: ldloca 2
		IL_0090: nop
		IL_0091: ldind.i2
		IL_0092: conv.i2
		IL_0093: conv.i
		IL_0094: stloc.1
		IL_0095: br IL_000a

		IL_009a: ldarg.0
		IL_009b: ldfld int32 ODCrypt.MD5::d
		IL_00a0: ldarg.0
		IL_00a1: ldfld uint8[] ODCrypt.MD5::i
		IL_00a6: ldlen
		IL_00a7: conv.i4
		IL_00a8: bne.un IL_0143

		IL_00ad: ldc.i4 917438466
		IL_00b2: stloc 2
		IL_00b6: ldloca 2
		IL_00ba: nop
		IL_00bb: ldind.i2
		IL_00bc: conv.i2
		IL_00bd: conv.i
		IL_00be: stloc.1
		IL_00bf: br IL_000a

		IL_00c4: ldc.i4 2064187393
		IL_00c9: stloc 2
		IL_00cd: ldloca 2
		IL_00d1: nop
		IL_00d2: ldind.i2
		IL_00d3: conv.i2
		IL_00d4: br.s IL_00ea

		IL_00d6: ldc.i4 1265827840
		IL_00db: nop
		IL_00dc: stloc 2
		IL_00e0: nop
		IL_00e1: ldloca 2
		IL_00e5: nop
		IL_00e6: ldind.i2
		IL_00e7: conv.i2
		IL_00e8: br.s IL_00ea

		IL_00ea: brfalse.s IL_00ec

		IL_00ec: br.s IL_00ee

		IL_00ee: ldarg.0
		IL_00ef: ldarg.0
		IL_00f0: ldfld uint8[] ODCrypt.MD5::i
		IL_00f5: ldc.i4.0
		IL_00f6: call instance void ODCrypt.MD5::w(uint8[], int32)
		IL_00fb: ldarg.0
		IL_00fc: ldc.i4.0
		IL_00fd: stfld int32 ODCrypt.MD5::d
		IL_0102: br.s IL_0117

		IL_0104: ldc.i4 850591744
		IL_0109: nop
		IL_010a: stloc 2
		IL_010e: ldloca 2
		IL_0112: ldind.i2
		IL_0113: conv.i2

		IL_0114: pop
		IL_0115: br.s IL_0129

		IL_0117: ldc.i4 496697344
		IL_011c: stloc 2
		IL_0120: nop
		IL_0121: ldloca 2
		IL_0125: ldind.i2
		IL_0126: conv.i2
		IL_0127: br.s IL_0114

		IL_0129: nop
		IL_012a: ldc.i4 179044352
		IL_012f: stloc 2
		IL_0133: ldloca 2
		IL_0137: nop
		IL_0138: ldind.i2
		IL_0139: conv.i2
		IL_013a: conv.i
		IL_013b: stloc.1
		IL_013c: br IL_000a

		IL_0141: br.s IL_0143

		IL_0143: ldarg.0
		IL_0144: ldarg.0
		IL_0145: ldfld int64 ODCrypt.MD5::y
		IL_014a: ldc.i4.1
		IL_014b: conv.i8
		IL_014c: add
		IL_014d: stfld int64 ODCrypt.MD5::y
		IL_0152: ret
	} // end of method MD5::Update

	.method public hidebysig 
		instance void BlockUpdate (
			uint8[] input,
			int32 inOff,
			int32 length
		) cil managed 
	{
		// Method begins at RVA 0x1185c
		// Header size: 12
		// Code size: 832 (0x340)
		.maxstack 7
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int32,
			[4] int16
		)

		IL_0000: ldc.i4.0
		IL_0001: switch (IL_0050)

		IL_000a: ldloc.3
		IL_000b: switch (IL_0308, IL_020b, IL_032b, IL_00d8, IL_00ae, IL_0267, IL_022b, IL_006f, IL_0092, IL_01ef, IL_0248, IL_01d0, IL_0177, IL_0117, IL_013a, IL_0191)

		IL_0050: ldc.i4.0
		IL_0051: ldarg.3
		IL_0052: call int32 [mscorlib]System.Math::Max(int32, int32)
		IL_0057: starg.s length
		IL_0059: ldc.i4.0
		IL_005a: stloc.0
		IL_005b: ldc.i4 1398145031
		IL_0060: stloc 4
		IL_0064: ldloca 4
		IL_0068: nop
		IL_0069: ldind.i2
		IL_006a: conv.i2
		IL_006b: conv.i
		IL_006c: stloc.3
		IL_006d: br.s IL_000a

		IL_006f: ldarg.0
		IL_0070: ldfld int32 ODCrypt.MD5::d
		IL_0075: brfalse IL_030a

		IL_007a: ldc.i4 368050184
		IL_007f: nop
		IL_0080: stloc 4
		IL_0084: nop
		IL_0085: ldloca 4
		IL_0089: ldind.i2
		IL_008a: conv.i2
		IL_008b: conv.i
		IL_008c: stloc.3
		IL_008d: br IL_000a

		IL_0092: br IL_0179

		IL_0097: ldc.i4 409010180
		IL_009c: stloc 4
		IL_00a0: ldloca 4
		IL_00a4: nop
		IL_00a5: ldind.i2
		IL_00a6: conv.i2
		IL_00a7: conv.i
		IL_00a8: stloc.3
		IL_00a9: br IL_000a

		IL_00ae: br IL_01f4

		IL_00b3: ldarg.0
		IL_00b4: ldarg.1
		IL_00b5: ldarg.2
		IL_00b6: ldloc.0
		IL_00b7: add
		IL_00b8: call instance void ODCrypt.MD5::w(uint8[], int32)
		IL_00bd: ldloc.0
		IL_00be: ldc.i4.4
		IL_00bf: add
		IL_00c0: stloc.0
		IL_00c1: ldc.i4 1790574595
		IL_00c6: stloc 4
		IL_00ca: ldloca 4
		IL_00ce: nop
		IL_00cf: ldind.i2
		IL_00d0: conv.i2
		IL_00d1: conv.i
		IL_00d2: stloc.3
		IL_00d3: br IL_000a

		IL_00d8: br IL_01b9

		IL_00dd: ldarg.0
		IL_00de: ldfld uint8[] ODCrypt.MD5::i
		IL_00e3: ldarg.0
		IL_00e4: ldarg.0
		IL_00e5: ldfld int32 ODCrypt.MD5::d
		IL_00ea: stloc.2
		IL_00eb: ldloc.2
		IL_00ec: ldc.i4.1
		IL_00ed: add
		IL_00ee: stfld int32 ODCrypt.MD5::d
		IL_00f3: ldloc.2
		IL_00f4: ldarg.1
		IL_00f5: ldarg.2
		IL_00f6: ldloc.0
		IL_00f7: dup
		IL_00f8: ldc.i4.1
		IL_00f9: add
		IL_00fa: stloc.0
		IL_00fb: add
		IL_00fc: ldelem.u1
		IL_00fd: stelem.i1
		IL_00fe: ldc.i4 262275085
		IL_0103: nop
		IL_0104: stloc 4
		IL_0108: nop
		IL_0109: ldloca 4
		IL_010d: nop
		IL_010e: ldind.i2
		IL_010f: conv.i2
		IL_0110: conv.i
		IL_0111: stloc.3
		IL_0112: br IL_000a

		IL_0117: ldarg.0
		IL_0118: ldfld int32 ODCrypt.MD5::d
		IL_011d: ldc.i4.4
		IL_011e: bne.un IL_0230

		IL_0123: ldc.i4 334757902
		IL_0128: stloc 4
		IL_012c: ldloca 4
		IL_0130: nop
		IL_0131: ldind.i2
		IL_0132: conv.i2
		IL_0133: conv.i
		IL_0134: stloc.3
		IL_0135: br IL_000a

		IL_013a: br IL_02b3

		IL_013f: ldarg.0
		IL_0140: ldfld uint8[] ODCrypt.MD5::i
		IL_0145: ldarg.0
		IL_0146: ldarg.0
		IL_0147: ldfld int32 ODCrypt.MD5::d
		IL_014c: stloc.2
		IL_014d: ldloc.2
		IL_014e: ldc.i4.1
		IL_014f: add
		IL_0150: stfld int32 ODCrypt.MD5::d
		IL_0155: ldloc.2
		IL_0156: ldarg.1
		IL_0157: ldarg.2
		IL_0158: ldloc.0
		IL_0159: dup
		IL_015a: ldc.i4.1
		IL_015b: add
		IL_015c: stloc.0
		IL_015d: add
		IL_015e: ldelem.u1
		IL_015f: stelem.i1
		IL_0160: ldc.i4 1170407436
		IL_0165: stloc 4
		IL_0169: ldloca 4
		IL_016d: nop
		IL_016e: ldind.i2
		IL_016f: conv.i2
		IL_0170: conv.i
		IL_0171: stloc.3
		IL_0172: br IL_000a

		IL_0177: br.s IL_01f4

		IL_0179: ldc.i4 1409548303
		IL_017e: nop
		IL_017f: stloc 4
		IL_0183: ldloca 4
		IL_0187: nop
		IL_0188: ldind.i2
		IL_0189: conv.i2
		IL_018a: conv.i
		IL_018b: stloc.3
		IL_018c: br IL_000a

		IL_0191: ldc.i4 1877147649
		IL_0196: stloc 4
		IL_019a: ldloca 4
		IL_019e: nop
		IL_019f: ldind.i2
		IL_01a0: conv.i2
		IL_01a1: br.s IL_01b5

		IL_01a3: ldc.i4 1459224576
		IL_01a8: stloc 4
		IL_01ac: ldloca 4
		IL_01b0: nop
		IL_01b1: ldind.i2
		IL_01b2: conv.i2
		IL_01b3: br.s IL_01b5

		IL_01b5: brfalse.s IL_01b7

		IL_01b7: br.s IL_0230

		IL_01b9: ldc.i4 1462304779
		IL_01be: stloc 4
		IL_01c2: nop
		IL_01c3: ldloca 4
		IL_01c7: ldind.i2
		IL_01c8: conv.i2
		IL_01c9: conv.i
		IL_01ca: stloc.3
		IL_01cb: br IL_000a

		IL_01d0: ldloc.0
		IL_01d1: ldloc.1
		IL_01d2: blt IL_00b3

		IL_01d7: ldc.i4 1301676041
		IL_01dc: nop
		IL_01dd: stloc 4
		IL_01e1: ldloca 4
		IL_01e5: nop
		IL_01e6: ldind.i2
		IL_01e7: conv.i2
		IL_01e8: conv.i
		IL_01e9: stloc.3
		IL_01ea: br IL_000a

		IL_01ef: br IL_0097

		IL_01f4: ldc.i4 1910177793
		IL_01f9: stloc 4
		IL_01fd: nop
		IL_01fe: ldloca 4
		IL_0202: ldind.i2
		IL_0203: conv.i2
		IL_0204: conv.i
		IL_0205: stloc.3
		IL_0206: br IL_000a

		IL_020b: ldloc.0
		IL_020c: ldarg.3
		IL_020d: blt IL_013f

		IL_0212: ldc.i4 105381894
		IL_0217: nop
		IL_0218: stloc 4
		IL_021c: nop
		IL_021d: ldloca 4
		IL_0221: nop
		IL_0222: ldind.i2
		IL_0223: conv.i2
		IL_0224: conv.i
		IL_0225: stloc.3
		IL_0226: br IL_000a

		IL_022b: br IL_0330

		IL_0230: ldc.i4 786169866
		IL_0235: stloc 4
		IL_0239: nop
		IL_023a: ldloca 4
		IL_023e: nop
		IL_023f: ldind.i2
		IL_0240: conv.i2
		IL_0241: conv.i
		IL_0242: stloc.3
		IL_0243: br IL_000a

		IL_0248: ldloc.0
		IL_0249: ldarg.3
		IL_024a: blt IL_00dd

		IL_024f: ldc.i4 759824389
		IL_0254: nop
		IL_0255: stloc 4
		IL_0259: ldloca 4
		IL_025d: nop
		IL_025e: ldind.i2
		IL_025f: conv.i2
		IL_0260: conv.i
		IL_0261: stloc.3
		IL_0262: br IL_000a

		IL_0267: ldc.i4 668185862
		IL_026c: nop
		IL_026d: stloc 4
		IL_0271: ldloca 4
		IL_0275: ldind.i2
		IL_0276: conv.i2
		IL_0277: ldc.i4 972731654
		IL_027c: nop
		IL_027d: stloc 4
		IL_0281: ldloca 4
		IL_0285: ldind.i2
		IL_0286: conv.i2
		IL_0287: ceq
		IL_0289: switch (IL_013a, IL_029b, IL_013a)

		IL_029a: nop

		IL_029b: ldc.i4 444071936
		IL_02a0: nop
		IL_02a1: stloc 4
		IL_02a5: nop
		IL_02a6: ldloca 4
		IL_02aa: ldind.i2
		IL_02ab: conv.i2
		IL_02ac: brfalse IL_02b1

		IL_02b1: br.s IL_030a

		IL_02b3: ldarg.0
		IL_02b4: ldarg.0
		IL_02b5: ldfld uint8[] ODCrypt.MD5::i
		IL_02ba: ldc.i4.0
		IL_02bb: call instance void ODCrypt.MD5::w(uint8[], int32)
		IL_02c0: ldarg.0
		IL_02c1: ldc.i4.0
		IL_02c2: stfld int32 ODCrypt.MD5::d
		IL_02c7: br.s IL_02dd

		IL_02c9: ldc.i4 464060416
		IL_02ce: stloc 4
		IL_02d2: nop
		IL_02d3: ldloca 4
		IL_02d7: nop
		IL_02d8: ldind.i2
		IL_02d9: conv.i2

		IL_02da: pop
		IL_02db: br.s IL_02f0

		IL_02dd: ldc.i4 1530134528
		IL_02e2: nop
		IL_02e3: stloc 4
		IL_02e7: ldloca 4
		IL_02eb: nop
		IL_02ec: ldind.i2
		IL_02ed: conv.i2
		IL_02ee: br.s IL_02da

		IL_02f0: nop
		IL_02f1: ldc.i4 840892416
		IL_02f6: stloc 4
		IL_02fa: nop
		IL_02fb: ldloca 4
		IL_02ff: ldind.i2
		IL_0300: conv.i2
		IL_0301: conv.i
		IL_0302: stloc.3
		IL_0303: br IL_000a

		IL_0308: br.s IL_030a

		IL_030a: ldarg.3
		IL_030b: ldloc.0
		IL_030c: sub
		IL_030d: ldc.i4.s -4
		IL_030f: and
		IL_0310: ldloc.0
		IL_0311: add
		IL_0312: stloc.1
		IL_0313: ldc.i4 2047475714
		IL_0318: nop
		IL_0319: stloc 4
		IL_031d: ldloca 4
		IL_0321: nop
		IL_0322: ldind.i2
		IL_0323: conv.i2
		IL_0324: conv.i
		IL_0325: stloc.3
		IL_0326: br IL_000a

		IL_032b: br IL_01b9

		IL_0330: ldarg.0
		IL_0331: ldarg.0
		IL_0332: ldfld int64 ODCrypt.MD5::y
		IL_0337: ldarg.3
		IL_0338: conv.i8
		IL_0339: add
		IL_033a: stfld int64 ODCrypt.MD5::y
		IL_033f: ret
	} // end of method MD5::BlockUpdate

	.method public hidebysig static 
		uint8[] DoFinal (
			class ODCrypt.MD5 digest
		) cil managed 
	{
		// Method begins at RVA 0x11ba8
		// Header size: 12
		// Code size: 180 (0xb4)
		.maxstack 3
		.locals init (
			[0] uint8[],
			[1] int16
		)

		IL_0000: ldc.i4 1751819564
		IL_0005: nop
		IL_0006: stloc 1
		IL_000a: ldloca 1
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1701160236
		IL_0015: stloc 1
		IL_0019: nop
		IL_001a: ldloca 1
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 915668993
		IL_003a: nop
		IL_003b: stloc 1
		IL_003f: nop
		IL_0040: ldloca 1
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: br.s IL_005c

		IL_0048: ldc.i4 2065694720
		IL_004d: nop
		IL_004e: stloc 1
		IL_0052: nop
		IL_0053: ldloca 1
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_005c

		IL_005c: brfalse.s IL_005e

		IL_005e: ldc.i4 2048917504
		IL_0063: nop
		IL_0064: stloc 1
		IL_0068: nop
		IL_0069: ldloca 1
		IL_006d: nop
		IL_006e: ldind.i2
		IL_006f: conv.i2
		IL_0070: brfalse IL_0075

		IL_0075: br.s IL_008a

		IL_0077: ldc.i4 134283264
		IL_007c: stloc 1
		IL_0080: nop
		IL_0081: ldloca 1
		IL_0085: ldind.i2
		IL_0086: conv.i2

		IL_0087: pop
		IL_0088: br.s IL_009c

		IL_008a: ldc.i4 1203240960
		IL_008f: stloc 1
		IL_0093: ldloca 1
		IL_0097: nop
		IL_0098: ldind.i2
		IL_0099: conv.i2
		IL_009a: br.s IL_0087

		IL_009c: nop
		IL_009d: ldarg.0
		IL_009e: callvirt instance int32 ODCrypt.MD5::GetDigestSize()
		IL_00a3: newarr [mscorlib]System.Byte
		IL_00a8: stloc.0
		IL_00a9: ldarg.0
		IL_00aa: ldloc.0
		IL_00ab: ldc.i4.0
		IL_00ac: callvirt instance int32 ODCrypt.MD5::DoFinal(uint8[], int32)
		IL_00b1: pop
		IL_00b2: ldloc.0
		IL_00b3: ret
	} // end of method MD5::DoFinal

	.method private hidebysig specialname rtspecialname static 
		void .cctor () cil managed 
	{
		// Method begins at RVA 0x11c68
		// Header size: 12
		// Code size: 266 (0x10a)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 18630546
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: ldloca 0
		IL_000e: nop
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1117734802
		IL_0016: nop
		IL_0017: stloc 0
		IL_001b: nop
		IL_001c: ldloca 0
		IL_0020: ldind.i2
		IL_0021: conv.i2
		IL_0022: ceq
		IL_0024: switch (IL_0035, IL_0036, IL_0035)

		IL_0035: nop

		IL_0036: ldc.i4 1316421633
		IL_003b: stloc 0
		IL_003f: nop
		IL_0040: ldloca 0
		IL_0044: nop
		IL_0045: ldind.i2
		IL_0046: conv.i2
		IL_0047: br.s IL_005d

		IL_0049: ldc.i4 642383872
		IL_004e: nop
		IL_004f: stloc 0
		IL_0053: nop
		IL_0054: ldloca 0
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_005d

		IL_005d: brfalse.s IL_005f

		IL_005f: ldc.i4 1357119488
		IL_0064: stloc 0
		IL_0068: ldloca 0
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: brfalse IL_0074

		IL_0074: br.s IL_008a

		IL_0076: ldc.i4 1236926464
		IL_007b: stloc 0
		IL_007f: nop
		IL_0080: ldloca 0
		IL_0084: nop
		IL_0085: ldind.i2
		IL_0086: conv.i2

		IL_0087: pop
		IL_0088: br.s IL_009c

		IL_008a: ldc.i4 1782841344
		IL_008f: stloc 0
		IL_0093: ldloca 0
		IL_0097: nop
		IL_0098: ldind.i2
		IL_0099: conv.i2
		IL_009a: br.s IL_0087

		IL_009c: nop
		IL_009d: ldc.i4.7
		IL_009e: stsfld int32 ODCrypt.MD5::t
		IL_00a3: ldc.i4.s 12
		IL_00a5: stsfld int32 ODCrypt.MD5::o
		IL_00aa: ldc.i4.s 17
		IL_00ac: stsfld int32 ODCrypt.MD5::j
		IL_00b1: ldc.i4.s 22
		IL_00b3: stsfld int32 ODCrypt.MD5::e
		IL_00b8: ldc.i4.5
		IL_00b9: stsfld int32 ODCrypt.MD5::z
		IL_00be: ldc.i4.s 9
		IL_00c0: stsfld int32 ODCrypt.MD5::u
		IL_00c5: ldc.i4.s 14
		IL_00c7: stsfld int32 ODCrypt.MD5::p
		IL_00cc: ldc.i4.s 20
		IL_00ce: stsfld int32 ODCrypt.MD5::k
		IL_00d3: ldc.i4.4
		IL_00d4: stsfld int32 ODCrypt.MD5::f
		IL_00d9: ldc.i4.s 11
		IL_00db: stsfld int32 ODCrypt.MD5::a
		IL_00e0: ldc.i4.s 16
		IL_00e2: stsfld int32 ODCrypt.MD5::v
		IL_00e7: ldc.i4.s 23
		IL_00e9: stsfld int32 ODCrypt.MD5::q
		IL_00ee: ldc.i4.6
		IL_00ef: stsfld int32 ODCrypt.MD5::l
		IL_00f4: ldc.i4.s 10
		IL_00f6: stsfld int32 ODCrypt.MD5::g
		IL_00fb: ldc.i4.s 15
		IL_00fd: stsfld int32 ODCrypt.MD5::b
		IL_0102: ldc.i4.s 21
		IL_0104: stsfld int32 ODCrypt.MD5::w5
		IL_0109: ret
	} // end of method MD5::.cctor

	// Properties
	.property instance string AlgorithmName()
	{
		.get instance string ODCrypt.MD5::get_AlgorithmName()
	}

} // end of class ODCrypt.MD5

.class public auto ansi beforefieldinit ODCrypt.Sha3
	extends ODCrypt.KeccakDigest
{
	// Methods
	.method private hidebysig static 
		int32 w (
			int32 A_0
		) cil managed 
	{
		// Method begins at RVA 0x11d80
		// Header size: 12
		// Code size: 600 (0x258)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int16,
			[2] int32
		)

		IL_0000: ldc.i4 17
		IL_0005: stloc 2
		IL_0009: ldc.i4 1968570371
		IL_000e: nop
		IL_000f: stloc 1
		IL_0013: nop
		IL_0014: ldloca 1
		IL_0018: nop
		IL_0019: ldind.i2
		IL_001a: conv.i2
		IL_001b: conv.i
		IL_001c: stloc.0
		IL_001d: br.s IL_0029
		// loop start (head: IL_0029)
			IL_001f: ldc.i4.0
			IL_0020: switch (IL_005b)

			IL_0029: ldloc.0
			IL_002a: switch (IL_00a2, IL_00bd, IL_011a, IL_001f, IL_013a, IL_01a0, IL_0225, IL_01c0, IL_01dc, IL_00df, IL_00fd)
		// end loop

		IL_005b: ldc.i4 35979265
		IL_0060: nop
		IL_0061: stloc 1
		IL_0065: ldloca 1
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: br.s IL_0080

		IL_006e: ldc.i4 1950351360
		IL_0073: stloc 1
		IL_0077: ldloca 1
		IL_007b: nop
		IL_007c: ldind.i2
		IL_007d: conv.i2
		IL_007e: br.s IL_0080

		IL_0080: brfalse.s IL_0082

		IL_0082: ldarg.0
		IL_0083: ldc.i4 256
		IL_0088: bgt IL_01c5

		IL_008d: ldc.i4 2134507520
		IL_0092: nop
		IL_0093: stloc 1
		IL_0097: nop
		IL_0098: ldloca 1
		IL_009c: ldind.i2
		IL_009d: conv.i2
		IL_009e: conv.i
		IL_009f: stloc.0
		IL_00a0: br.s IL_0029

		IL_00a2: br.s IL_0102

		IL_00a4: ldc.i4 526254081
		IL_00a9: nop
		IL_00aa: stloc 1
		IL_00ae: nop
		IL_00af: ldloca 1
		IL_00b3: nop
		IL_00b4: ldind.i2
		IL_00b5: conv.i2
		IL_00b6: conv.i
		IL_00b7: stloc.0
		IL_00b8: br IL_0029

		IL_00bd: ldarg.0
		IL_00be: ldc.i4 512
		IL_00c3: bne.un IL_022a

		IL_00c8: ldc.i4 1398407177
		IL_00cd: stloc 1
		IL_00d1: ldloca 1
		IL_00d5: nop
		IL_00d6: ldind.i2
		IL_00d7: conv.i2
		IL_00d8: conv.i
		IL_00d9: stloc.0
		IL_00da: br IL_0029

		IL_00df: br IL_0186

		IL_00e4: ldc.i4 36306954
		IL_00e9: nop
		IL_00ea: stloc 1
		IL_00ee: nop
		IL_00ef: ldloca 1
		IL_00f3: nop
		IL_00f4: ldind.i2
		IL_00f5: conv.i2
		IL_00f6: conv.i
		IL_00f7: stloc.0
		IL_00f8: br IL_0029

		IL_00fd: br IL_022a

		IL_0102: ldc.i4 81068034
		IL_0107: nop
		IL_0108: stloc 1
		IL_010c: ldloca 1
		IL_0110: nop
		IL_0111: ldind.i2
		IL_0112: conv.i2
		IL_0113: conv.i
		IL_0114: stloc.0
		IL_0115: br IL_0029

		IL_011a: ldarg.0
		IL_011b: ldc.i4 224
		IL_0120: beq.s IL_0186

		IL_0122: ldc.i4 1828847620
		IL_0127: nop
		IL_0128: stloc 1
		IL_012c: ldloca 1
		IL_0130: nop
		IL_0131: ldind.i2
		IL_0132: conv.i2
		IL_0133: conv.i
		IL_0134: stloc.0
		IL_0135: br IL_0029

		IL_013a: ldc.i4 1473817445
		IL_013f: stloc 1
		IL_0143: ldloca 1
		IL_0147: nop
		IL_0148: ldind.i2
		IL_0149: conv.i2
		IL_014a: ldc.i4 1764600677
		IL_014f: stloc 1
		IL_0153: ldloca 1
		IL_0157: nop
		IL_0158: ldind.i2
		IL_0159: conv.i2
		IL_015a: ceq
		IL_015c: switch (IL_01e4, IL_016e, IL_01e4)

		IL_016d: nop

		IL_016e: ldc.i4 1272315904
		IL_0173: nop
		IL_0174: stloc 1
		IL_0178: ldloca 1
		IL_017c: nop
		IL_017d: ldind.i2
		IL_017e: conv.i2
		IL_017f: brfalse IL_0184

		IL_0184: br.s IL_0188

		IL_0186: ldarg.0
		IL_0187: ret

		IL_0188: ldc.i4 1901723653
		IL_018d: stloc 1
		IL_0191: nop
		IL_0192: ldloca 1
		IL_0196: nop
		IL_0197: ldind.i2
		IL_0198: conv.i2
		IL_0199: conv.i
		IL_019a: stloc.0
		IL_019b: br IL_0029

		IL_01a0: ldarg.0
		IL_01a1: ldc.i4 256
		IL_01a6: beq.s IL_0186

		IL_01a8: ldc.i4 621543431
		IL_01ad: nop
		IL_01ae: stloc 1
		IL_01b2: nop
		IL_01b3: ldloca 1
		IL_01b7: ldind.i2
		IL_01b8: conv.i2
		IL_01b9: conv.i
		IL_01ba: stloc.0
		IL_01bb: br IL_0029

		IL_01c0: br IL_00e4

		IL_01c5: ldc.i4 1604648968
		IL_01ca: stloc 1
		IL_01ce: ldloca 1
		IL_01d2: nop
		IL_01d3: ldind.i2
		IL_01d4: conv.i2
		IL_01d5: conv.i
		IL_01d6: stloc.0
		IL_01d7: br IL_0029

		IL_01dc: ldarg.0
		IL_01dd: ldc.i4 384
		IL_01e2: beq.s IL_0186

		IL_01e4: br.s IL_01f9

		IL_01e6: ldc.i4 2096168960
		IL_01eb: stloc 1
		IL_01ef: ldloca 1
		IL_01f3: nop
		IL_01f4: ldind.i2
		IL_01f5: conv.i2

		IL_01f6: pop
		IL_01f7: br.s IL_020b

		IL_01f9: ldc.i4 916586496
		IL_01fe: nop
		IL_01ff: stloc 1
		IL_0203: ldloca 1
		IL_0207: ldind.i2
		IL_0208: conv.i2
		IL_0209: br.s IL_01f6

		IL_020b: nop
		IL_020c: ldc.i4 115408902
		IL_0211: nop
		IL_0212: stloc 1
		IL_0216: nop
		IL_0217: ldloca 1
		IL_021b: nop
		IL_021c: ldind.i2
		IL_021d: conv.i2
		IL_021e: conv.i
		IL_021f: stloc.0
		IL_0220: br IL_0029

		IL_0225: br IL_00a4

		IL_022a: ldarga.s A_0
		IL_022c: call instance string [mscorlib]System.Int32::ToString()
		IL_0231: ldstr "???????????????????\ude8c????"
		IL_0236: ldloc 2
		IL_023a: call string ODCrypt.Sha3::b(string, int32)
		IL_023f: call string [mscorlib]System.String::Concat(string, string)
		IL_0244: ldstr "?h?????W?"
		IL_0249: ldloc 2
		IL_024d: call string ODCrypt.Sha3::b(string, int32)
		IL_0252: newobj instance void [mscorlib]System.ArgumentException::.ctor(string, string)
		IL_0257: throw
	} // end of method Sha3::w

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x11fe4
		// Header size: 12
		// Code size: 12 (0xc)
		.maxstack 2

		IL_0000: ldarg.0
		IL_0001: ldc.i4 512
		IL_0006: call instance void ODCrypt.Sha3::.ctor(int32)
		IL_000b: ret
	} // end of method Sha3::.ctor

	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 bitLength
		) cil managed 
	{
		// Method begins at RVA 0x11ffc
		// Header size: 12
		// Code size: 13 (0xd)
		.maxstack 2

		IL_0000: ldarg.0
		IL_0001: ldarg.1
		IL_0002: call int32 ODCrypt.Sha3::w(int32)
		IL_0007: call instance void ODCrypt.KeccakDigest::.ctor(int32)
		IL_000c: ret
	} // end of method Sha3::.ctor

	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			class ODCrypt.Sha3 source
		) cil managed 
	{
		// Method begins at RVA 0x12018
		// Header size: 12
		// Code size: 8 (0x8)
		.maxstack 2

		IL_0000: ldarg.0
		IL_0001: ldarg.1
		IL_0002: call instance void ODCrypt.KeccakDigest::.ctor(class ODCrypt.KeccakDigest)
		IL_0007: ret
	} // end of method Sha3::.ctor

	.method public hidebysig static 
		uint8[] Hash (
			uint8[] plaintext
		) cil managed 
	{
		// Method begins at RVA 0x1202c
		// Header size: 12
		// Code size: 181 (0xb5)
		.maxstack 5
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1352835055
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: nop
		IL_000b: ldloca 0
		IL_000f: ldind.i2
		IL_0010: conv.i2
		IL_0011: ldc.i4 1495637999
		IL_0016: stloc 0
		IL_001a: ldloca 0
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 947912705
		IL_003a: nop
		IL_003b: stloc 0
		IL_003f: nop
		IL_0040: ldloca 0
		IL_0044: nop
		IL_0045: ldind.i2
		IL_0046: conv.i2
		IL_0047: br.s IL_005c

		IL_0049: ldc.i4 447086592
		IL_004e: nop
		IL_004f: stloc 0
		IL_0053: ldloca 0
		IL_0057: nop
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_005c

		IL_005c: brfalse.s IL_005e

		IL_005e: ldc.i4 958136320
		IL_0063: stloc 0
		IL_0067: nop
		IL_0068: ldloca 0
		IL_006c: nop
		IL_006d: ldind.i2
		IL_006e: conv.i2
		IL_006f: brfalse IL_0074

		IL_0074: br.s IL_008a

		IL_0076: ldc.i4 593559552
		IL_007b: nop
		IL_007c: stloc 0
		IL_0080: nop
		IL_0081: ldloca 0
		IL_0085: ldind.i2
		IL_0086: conv.i2

		IL_0087: pop
		IL_0088: br.s IL_009e

		IL_008a: ldc.i4 443154432
		IL_008f: nop
		IL_0090: stloc 0
		IL_0094: nop
		IL_0095: ldloca 0
		IL_0099: nop
		IL_009a: ldind.i2
		IL_009b: conv.i2
		IL_009c: br.s IL_0087

		IL_009e: nop
		IL_009f: newobj instance void ODCrypt.Sha3::.ctor()
		IL_00a4: dup
		IL_00a5: ldarg.0
		IL_00a6: ldc.i4.0
		IL_00a7: ldarg.0
		IL_00a8: ldlen
		IL_00a9: conv.i4
		IL_00aa: callvirt instance void ODCrypt.KeccakDigest::BlockUpdate(uint8[], int32, int32)
		IL_00af: call uint8[] ODCrypt.Sha3::DoFinal(class ODCrypt.Sha3)
		IL_00b4: ret
	} // end of method Sha3::Hash

	.method public hidebysig specialname virtual 
		instance string get_AlgorithmName () cil managed 
	{
		// Method begins at RVA 0x120f0
		// Header size: 12
		// Code size: 194 (0xc2)
		.maxstack 2
		.locals init (
			[0] int16,
			[1] int32
		)

		IL_0000: ldc.i4 10
		IL_0005: stloc 1
		IL_0009: ldc.i4 2080083139
		IL_000e: stloc 0
		IL_0012: nop
		IL_0013: ldloca 0
		IL_0017: ldind.i2
		IL_0018: conv.i2
		IL_0019: ldc.i4 699436227
		IL_001e: stloc 0
		IL_0022: nop
		IL_0023: ldloca 0
		IL_0027: nop
		IL_0028: ldind.i2
		IL_0029: conv.i2
		IL_002a: ceq
		IL_002c: switch (IL_003d, IL_003e, IL_003d)

		IL_003d: nop

		IL_003e: ldc.i4 1347289089
		IL_0043: stloc 0
		IL_0047: ldloca 0
		IL_004b: nop
		IL_004c: ldind.i2
		IL_004d: conv.i2
		IL_004e: br.s IL_0063

		IL_0050: ldc.i4 612958208
		IL_0055: nop
		IL_0056: stloc 0
		IL_005a: nop
		IL_005b: ldloca 0
		IL_005f: ldind.i2
		IL_0060: conv.i2
		IL_0061: br.s IL_0063

		IL_0063: brfalse.s IL_0065

		IL_0065: ldc.i4 386531328
		IL_006a: nop
		IL_006b: stloc 0
		IL_006f: nop
		IL_0070: ldloca 0
		IL_0074: ldind.i2
		IL_0075: conv.i2
		IL_0076: brfalse IL_007b

		IL_007b: br.s IL_0090

		IL_007d: ldc.i4 1024196608
		IL_0082: stloc 0
		IL_0086: ldloca 0
		IL_008a: nop
		IL_008b: ldind.i2
		IL_008c: conv.i2

		IL_008d: pop
		IL_008e: br.s IL_00a2

		IL_0090: ldc.i4 960495616
		IL_0095: stloc 0
		IL_0099: ldloca 0
		IL_009d: nop
		IL_009e: ldind.i2
		IL_009f: conv.i2
		IL_00a0: br.s IL_008d

		IL_00a2: nop
		IL_00a3: ldstr "??╣??"
		IL_00a8: ldloc 1
		IL_00ac: call string ODCrypt.Sha3::b(string, int32)
		IL_00b1: ldarg.0
		IL_00b2: ldflda int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_00b7: call instance string [mscorlib]System.Int32::ToString()
		IL_00bc: call string [mscorlib]System.String::Concat(string, string)
		IL_00c1: ret
	} // end of method Sha3::get_AlgorithmName

	.method public hidebysig virtual 
		instance int32 DoFinal (
			uint8[] output,
			int32 outOff
		) cil managed 
	{
		// Method begins at RVA 0x121c0
		// Header size: 12
		// Code size: 181 (0xb5)
		.maxstack 5
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1812860847
		IL_0005: nop
		IL_0006: stloc 0
		IL_000a: ldloca 0
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 980094895
		IL_0015: nop
		IL_0016: stloc 0
		IL_001a: ldloca 0
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_0034, IL_0033)

		IL_0033: nop

		IL_0034: ldc.i4 536543232
		IL_0039: stloc 0
		IL_003d: nop
		IL_003e: ldloca 0
		IL_0042: ldind.i2
		IL_0043: conv.i2
		IL_0044: brfalse IL_0049

		IL_0049: ldc.i4 2074411009
		IL_004e: nop
		IL_004f: stloc 0
		IL_0053: nop
		IL_0054: ldloca 0
		IL_0058: ldind.i2
		IL_0059: conv.i2
		IL_005a: br.s IL_006e

		IL_005c: ldc.i4 1494024192
		IL_0061: stloc 0
		IL_0065: ldloca 0
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: br.s IL_006e

		IL_006e: brfalse.s IL_0070

		IL_0070: br.s IL_0086

		IL_0072: ldc.i4 763625472
		IL_0077: stloc 0
		IL_007b: nop
		IL_007c: ldloca 0
		IL_0080: nop
		IL_0081: ldind.i2
		IL_0082: conv.i2

		IL_0083: pop
		IL_0084: br.s IL_0098

		IL_0086: ldc.i4 2087190528
		IL_008b: stloc 0
		IL_008f: ldloca 0
		IL_0093: nop
		IL_0094: ldind.i2
		IL_0095: conv.i2
		IL_0096: br.s IL_0083

		IL_0098: nop
		IL_0099: ldarg.0
		IL_009a: ldc.i4.1
		IL_009b: newarr [mscorlib]System.Byte
		IL_00a0: dup
		IL_00a1: ldc.i4.0
		IL_00a2: ldc.i4.2
		IL_00a3: stelem.i1
		IL_00a4: ldc.i4.0
		IL_00a5: ldc.i4.2
		IL_00a6: conv.i8
		IL_00a7: callvirt instance void ODCrypt.KeccakDigest::Absorb(uint8[], int32, int64)
		IL_00ac: ldarg.0
		IL_00ad: ldarg.1
		IL_00ae: ldarg.2
		IL_00af: call instance int32 ODCrypt.KeccakDigest::DoFinal(uint8[], int32)
		IL_00b4: ret
	} // end of method Sha3::DoFinal

	.method public hidebysig static 
		uint8[] DoFinal (
			class ODCrypt.Sha3 digest
		) cil managed 
	{
		// Method begins at RVA 0x12284
		// Header size: 12
		// Code size: 178 (0xb2)
		.maxstack 3
		.locals init (
			[0] uint8[],
			[1] int16
		)

		IL_0000: ldc.i4 2073368401
		IL_0005: stloc 1
		IL_0009: nop
		IL_000a: ldloca 1
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1830754129
		IL_0015: nop
		IL_0016: stloc 1
		IL_001a: ldloca 1
		IL_001e: nop
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 1391722496
		IL_003a: nop
		IL_003b: stloc 1
		IL_003f: nop
		IL_0040: ldloca 1
		IL_0044: ldind.i2
		IL_0045: conv.i2
		IL_0046: brfalse IL_004b

		IL_004b: ldc.i4 44498945
		IL_0050: stloc 1
		IL_0054: ldloca 1
		IL_0058: nop
		IL_0059: ldind.i2
		IL_005a: conv.i2
		IL_005b: br.s IL_006f

		IL_005d: ldc.i4 2067595264
		IL_0062: stloc 1
		IL_0066: ldloca 1
		IL_006a: nop
		IL_006b: ldind.i2
		IL_006c: conv.i2
		IL_006d: br.s IL_006f

		IL_006f: brfalse.s IL_0071

		IL_0071: br.s IL_0086

		IL_0073: ldc.i4 698679296
		IL_0078: nop
		IL_0079: stloc 1
		IL_007d: ldloca 1
		IL_0081: ldind.i2
		IL_0082: conv.i2

		IL_0083: pop
		IL_0084: br.s IL_009a

		IL_0086: ldc.i4 193134592
		IL_008b: nop
		IL_008c: stloc 1
		IL_0090: nop
		IL_0091: ldloca 1
		IL_0095: nop
		IL_0096: ldind.i2
		IL_0097: conv.i2
		IL_0098: br.s IL_0083

		IL_009a: nop
		IL_009b: ldarg.0
		IL_009c: callvirt instance int32 ODCrypt.KeccakDigest::GetDigestSize()
		IL_00a1: newarr [mscorlib]System.Byte
		IL_00a6: stloc.0
		IL_00a7: ldarg.0
		IL_00a8: ldloc.0
		IL_00a9: ldc.i4.0
		IL_00aa: callvirt instance int32 ODCrypt.KeccakDigest::DoFinal(uint8[], int32)
		IL_00af: pop
		IL_00b0: ldloc.0
		IL_00b1: ret
	} // end of method Sha3::DoFinal

	.method family hidebysig virtual 
		instance int32 DoFinal (
			uint8[] output,
			int32 outOff,
			uint8 partialByte,
			int32 partialBits
		) cil managed 
	{
		// Method begins at RVA 0x12344
		// Header size: 12
		// Code size: 501 (0x1f5)
		.maxstack 5
		.locals init (
			[0] int32,
			[1] int32,
			[2] int32,
			[3] int16,
			[4] int32
		)

		IL_0000: ldc.i4 6
		IL_0005: stloc 4
		IL_0009: ldc.i4 1913323520
		IL_000e: stloc 3
		IL_0012: ldloca 3
		IL_0016: nop
		IL_0017: ldind.i2
		IL_0018: conv.i2
		IL_0019: conv.i
		IL_001a: stloc.2
		IL_001b: br.s IL_0027
		// loop start (head: IL_0027)
			IL_001d: ldc.i4.0
			IL_001e: switch (IL_0049)

			IL_0027: ldloc.2
			IL_0028: switch (IL_001d, IL_01e7, IL_015f, IL_00f1, IL_0062, IL_0093, IL_00b2)
		// end loop

		IL_0049: ldarg.s partialBits
		IL_004b: ldc.i4.0
		IL_004c: blt.s IL_00b7

		IL_004e: ldc.i4 1115881476
		IL_0053: stloc 3
		IL_0057: ldloca 3
		IL_005b: nop
		IL_005c: ldind.i2
		IL_005d: conv.i2
		IL_005e: conv.i
		IL_005f: stloc.2
		IL_0060: br.s IL_0027

		IL_0062: br.s IL_00d9

		IL_0064: ldarg.3
		IL_0065: ldc.i4.1
		IL_0066: ldarg.s partialBits
		IL_0068: ldc.i4.s 31
		IL_006a: and
		IL_006b: shl
		IL_006c: ldc.i4.1
		IL_006d: sub
		IL_006e: and
		IL_006f: ldc.i4.2
		IL_0070: ldarg.s partialBits
		IL_0072: ldc.i4.s 31
		IL_0074: and
		IL_0075: shl
		IL_0076: or
		IL_0077: stloc.0
		IL_0078: ldarg.s partialBits
		IL_007a: ldc.i4.2
		IL_007b: add
		IL_007c: stloc.1
		IL_007d: ldc.i4 1358757893
		IL_0082: nop
		IL_0083: stloc 3
		IL_0087: nop
		IL_0088: ldloca 3
		IL_008c: nop
		IL_008d: ldind.i2
		IL_008e: conv.i2
		IL_008f: conv.i
		IL_0090: stloc.2
		IL_0091: br.s IL_0027

		IL_0093: ldloc.1
		IL_0094: ldc.i4.8
		IL_0095: blt IL_01e9

		IL_009a: ldc.i4 1881145350
		IL_009f: stloc 3
		IL_00a3: nop
		IL_00a4: ldloca 3
		IL_00a8: nop
		IL_00a9: ldind.i2
		IL_00aa: conv.i2
		IL_00ab: conv.i
		IL_00ac: stloc.2
		IL_00ad: br IL_0027

		IL_00b2: br IL_0164

		IL_00b7: ldstr "?????????m???????????\udd85????"
		IL_00bc: ldloc 4
		IL_00c0: call string ODCrypt.Sha3::b(string, int32)
		IL_00c5: ldstr "???????????"
		IL_00ca: ldloc 4
		IL_00ce: call string ODCrypt.Sha3::b(string, int32)
		IL_00d3: newobj instance void [mscorlib]System.ArgumentException::.ctor(string, string)
		IL_00d8: throw

		IL_00d9: ldc.i4 1084686339
		IL_00de: stloc 3
		IL_00e2: nop
		IL_00e3: ldloca 3
		IL_00e7: nop
		IL_00e8: ldind.i2
		IL_00e9: conv.i2
		IL_00ea: conv.i
		IL_00eb: stloc.2
		IL_00ec: br IL_0027

		IL_00f1: ldarg.s partialBits
		IL_00f3: ldc.i4.7
		IL_00f4: ble IL_0064

		IL_00f9: ldc.i4 393216001
		IL_00fe: stloc 3
		IL_0102: ldloca 3
		IL_0106: nop
		IL_0107: ldind.i2
		IL_0108: conv.i2
		IL_0109: br.s IL_011d

		IL_010b: ldc.i4 1504837632
		IL_0110: stloc 3
		IL_0114: ldloca 3
		IL_0118: nop
		IL_0119: ldind.i2
		IL_011a: conv.i2
		IL_011b: br.s IL_011d

		IL_011d: brfalse.s IL_011f

		IL_011f: br.s IL_0135

		IL_0121: ldc.i4 373030912
		IL_0126: stloc 3
		IL_012a: nop
		IL_012b: ldloca 3
		IL_012f: nop
		IL_0130: ldind.i2
		IL_0131: conv.i2

		IL_0132: pop
		IL_0133: br.s IL_0147

		IL_0135: ldc.i4 1758265344
		IL_013a: nop
		IL_013b: stloc 3
		IL_013f: ldloca 3
		IL_0143: ldind.i2
		IL_0144: conv.i2
		IL_0145: br.s IL_0132

		IL_0147: nop
		IL_0148: ldc.i4 1185808386
		IL_014d: stloc 3
		IL_0151: nop
		IL_0152: ldloca 3
		IL_0156: ldind.i2
		IL_0157: conv.i2
		IL_0158: conv.i
		IL_0159: stloc.2
		IL_015a: br IL_0027

		IL_015f: br IL_00b7

		IL_0164: ldc.i4 1902342790
		IL_0169: stloc 3
		IL_016d: nop
		IL_016e: ldloca 3
		IL_0172: nop
		IL_0173: ldind.i2
		IL_0174: conv.i2
		IL_0175: ldc.i4 2081124998
		IL_017a: stloc 3
		IL_017e: nop
		IL_017f: ldloca 3
		IL_0183: ldind.i2
		IL_0184: conv.i2
		IL_0185: ceq
		IL_0187: switch (IL_00b7, IL_0199, IL_00b7)

		IL_0198: nop

		IL_0199: ldc.i4 1525743616
		IL_019e: stloc 3
		IL_01a2: nop
		IL_01a3: ldloca 3
		IL_01a7: nop
		IL_01a8: ldind.i2
		IL_01a9: conv.i2
		IL_01aa: brfalse IL_01af

		IL_01af: ldarg.0
		IL_01b0: ldfld uint8[] ODCrypt.KeccakDigest::oneByte
		IL_01b5: ldc.i4.0
		IL_01b6: ldloc.0
		IL_01b7: conv.u1
		IL_01b8: stelem.i1
		IL_01b9: ldarg.0
		IL_01ba: ldarg.0
		IL_01bb: ldfld uint8[] ODCrypt.KeccakDigest::oneByte
		IL_01c0: ldc.i4.0
		IL_01c1: ldc.i4.8
		IL_01c2: conv.i8
		IL_01c3: callvirt instance void ODCrypt.KeccakDigest::Absorb(uint8[], int32, int64)
		IL_01c8: ldloc.1
		IL_01c9: ldc.i4.8
		IL_01ca: sub
		IL_01cb: stloc.1
		IL_01cc: ldloc.0
		IL_01cd: ldc.i4.8
		IL_01ce: shr
		IL_01cf: stloc.0
		IL_01d0: ldc.i4 974979073
		IL_01d5: stloc 3
		IL_01d9: ldloca 3
		IL_01dd: nop
		IL_01de: ldind.i2
		IL_01df: conv.i2
		IL_01e0: conv.i
		IL_01e1: stloc.2
		IL_01e2: br IL_0027

		IL_01e7: br.s IL_01e9

		IL_01e9: ldarg.0
		IL_01ea: ldarg.1
		IL_01eb: ldarg.2
		IL_01ec: ldloc.0
		IL_01ed: conv.u1
		IL_01ee: ldloc.1
		IL_01ef: call instance int32 ODCrypt.KeccakDigest::DoFinal(uint8[], int32, uint8, int32)
		IL_01f4: ret
	} // end of method Sha3::DoFinal

	.method public hidebysig 
		instance class ODCrypt.Sha3 Copy () cil managed 
	{
		// Method begins at RVA 0x12548
		// Header size: 12
		// Code size: 159 (0x9f)
		.maxstack 2
		.locals init (
			[0] int16
		)

		IL_0000: ldc.i4 1417273897
		IL_0005: stloc 0
		IL_0009: ldloca 0
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 1395384873
		IL_0015: stloc 0
		IL_0019: ldloca 0
		IL_001d: nop
		IL_001e: ldind.i2
		IL_001f: conv.i2
		IL_0020: ceq
		IL_0022: switch (IL_0033, IL_0034, IL_0033)

		IL_0033: nop

		IL_0034: ldc.i4 1124597761
		IL_0039: nop
		IL_003a: stloc 0
		IL_003e: ldloca 0
		IL_0042: ldind.i2
		IL_0043: conv.i2
		IL_0044: br.s IL_0058

		IL_0046: ldc.i4 1229651968
		IL_004b: stloc 0
		IL_004f: nop
		IL_0050: ldloca 0
		IL_0054: ldind.i2
		IL_0055: conv.i2
		IL_0056: br.s IL_0058

		IL_0058: brfalse.s IL_005a

		IL_005a: ldc.i4 1157431296
		IL_005f: nop
		IL_0060: stloc 0
		IL_0064: ldloca 0
		IL_0068: ldind.i2
		IL_0069: conv.i2
		IL_006a: brfalse IL_006f

		IL_006f: br.s IL_0084

		IL_0071: ldc.i4 1142882304
		IL_0076: stloc 0
		IL_007a: ldloca 0
		IL_007e: nop
		IL_007f: ldind.i2
		IL_0080: conv.i2

		IL_0081: pop
		IL_0082: br.s IL_0097

		IL_0084: ldc.i4 2028404736
		IL_0089: stloc 0
		IL_008d: nop
		IL_008e: ldloca 0
		IL_0092: nop
		IL_0093: ldind.i2
		IL_0094: conv.i2
		IL_0095: br.s IL_0081

		IL_0097: nop
		IL_0098: ldarg.0
		IL_0099: newobj instance void ODCrypt.Sha3::.ctor(class ODCrypt.Sha3)
		IL_009e: ret
	} // end of method Sha3::Copy

	.method public hidebysig 
		instance void Reset (
			class ODCrypt.Sha3 other
		) cil managed 
	{
		// Method begins at RVA 0x125f4
		// Header size: 12
		// Code size: 305 (0x131)
		.maxstack 5
		.locals init (
			[0] class ODCrypt.Sha3,
			[1] int16
		)

		IL_0000: ldc.i4 1321613750
		IL_0005: stloc 1
		IL_0009: ldloca 1
		IL_000d: nop
		IL_000e: ldind.i2
		IL_000f: conv.i2
		IL_0010: ldc.i4 496712118
		IL_0015: nop
		IL_0016: stloc 1
		IL_001a: nop
		IL_001b: ldloca 1
		IL_001f: ldind.i2
		IL_0020: conv.i2
		IL_0021: ceq
		IL_0023: switch (IL_0034, IL_0035, IL_0034)

		IL_0034: nop

		IL_0035: ldc.i4 2114584577
		IL_003a: stloc 1
		IL_003e: nop
		IL_003f: ldloca 1
		IL_0043: ldind.i2
		IL_0044: conv.i2
		IL_0045: br.s IL_005a

		IL_0047: ldc.i4 1491861504
		IL_004c: stloc 1
		IL_0050: nop
		IL_0051: ldloca 1
		IL_0055: nop
		IL_0056: ldind.i2
		IL_0057: conv.i2
		IL_0058: br.s IL_005a

		IL_005a: brfalse.s IL_005c

		IL_005c: ldc.i4 2098266112
		IL_0061: stloc 1
		IL_0065: ldloca 1
		IL_0069: nop
		IL_006a: ldind.i2
		IL_006b: conv.i2
		IL_006c: brfalse IL_0071

		IL_0071: br.s IL_0086

		IL_0073: ldc.i4 199557120
		IL_0078: nop
		IL_0079: stloc 1
		IL_007d: ldloca 1
		IL_0081: ldind.i2
		IL_0082: conv.i2

		IL_0083: pop
		IL_0084: br.s IL_0099

		IL_0086: ldc.i4 1306132480
		IL_008b: nop
		IL_008c: stloc 1
		IL_0090: nop
		IL_0091: ldloca 1
		IL_0095: ldind.i2
		IL_0096: conv.i2
		IL_0097: br.s IL_0083

		IL_0099: nop
		IL_009a: ldarg.1
		IL_009b: stloc.0
		IL_009c: ldloc.0
		IL_009d: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_00a2: ldc.i4.0
		IL_00a3: ldarg.0
		IL_00a4: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_00a9: ldc.i4.0
		IL_00aa: ldloc.0
		IL_00ab: ldfld uint8[] ODCrypt.KeccakDigest::state
		IL_00b0: ldlen
		IL_00b1: conv.i4
		IL_00b2: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00b7: ldloc.0
		IL_00b8: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_00bd: ldc.i4.0
		IL_00be: ldarg.0
		IL_00bf: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_00c4: ldc.i4.0
		IL_00c5: ldloc.0
		IL_00c6: ldfld uint8[] ODCrypt.KeccakDigest::dataQueue
		IL_00cb: ldlen
		IL_00cc: conv.i4
		IL_00cd: call void [mscorlib]System.Array::Copy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_00d2: ldarg.0
		IL_00d3: ldloc.0
		IL_00d4: ldfld int32 ODCrypt.KeccakDigest::rate
		IL_00d9: stfld int32 ODCrypt.KeccakDigest::rate
		IL_00de: ldarg.0
		IL_00df: ldloc.0
		IL_00e0: ldfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_00e5: stfld int32 ODCrypt.KeccakDigest::bitsInQueue
		IL_00ea: ldarg.0
		IL_00eb: ldloc.0
		IL_00ec: ldfld int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_00f1: stfld int32 ODCrypt.KeccakDigest::fixedOutputLength
		IL_00f6: ldarg.0
		IL_00f7: ldloc.0
		IL_00f8: ldfld bool ODCrypt.KeccakDigest::squeezing
		IL_00fd: stfld bool ODCrypt.KeccakDigest::squeezing
		IL_0102: ldarg.0
		IL_0103: ldloc.0
		IL_0104: ldfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_0109: stfld int32 ODCrypt.KeccakDigest::bitsAvailableForSqueezing
		IL_010e: ldarg.0
		IL_010f: ldloc.0
		IL_0110: ldfld uint8[] ODCrypt.KeccakDigest::chunk
		IL_0115: call uint8[] ODCrypt.Arrays::Clone(uint8[])
		IL_011a: stfld uint8[] ODCrypt.KeccakDigest::chunk
		IL_011f: ldarg.0
		IL_0120: ldloc.0
		IL_0121: ldfld uint8[] ODCrypt.KeccakDigest::oneByte
		IL_0126: call uint8[] ODCrypt.Arrays::Clone(uint8[])
		IL_012b: stfld uint8[] ODCrypt.KeccakDigest::oneByte
		IL_0130: ret
	} // end of method Sha3::Reset

	.method assembly hidebysig static 
		string b (
			string A_0,
			int32 A_1
		) cil managed 
	{
		// Method begins at RVA 0x12734
		// Header size: 12
		// Code size: 104 (0x68)
		.maxstack 8
		.locals init (
			[0] char[],
			[1] int32,
			[2] int32,
			[3] uint8,
			[4] uint8
		)

		IL_0000: ldarg.0
		IL_0001: callvirt instance char[] [mscorlib]System.String::ToCharArray()
		IL_0006: stloc.0
		IL_0007: ldc.i4 117490377
		IL_000c: ldarg.1
		IL_000d: add
		IL_000e: ldc.i4 86
		IL_0013: conv.i
		IL_0014: add
		IL_0015: ldc.i4 54
		IL_001a: conv.i
		IL_001b: add
		IL_001c: stloc.1
		IL_001d: ldc.i4.0
		IL_001e: dup
		IL_001f: ldc.i4.1
		IL_0020: blt.s IL_0055

		IL_0022: dup
		IL_0023: stloc.2
		IL_0024: ldloc.0
		IL_0025: ldloc.2
		IL_0026: ldloc.0
		IL_0027: ldloc.2
		IL_0028: ldelem.i2
		IL_0029: dup
		IL_002a: ldc.i4 255
		IL_002f: and
		IL_0030: ldloc.1
		IL_0031: dup
		IL_0032: ldc.i4.1
		IL_0033: add
		IL_0034: stloc.1
		IL_0035: xor
		IL_0036: conv.u1
		IL_0037: stloc.3
		IL_0038: dup
		IL_0039: ldc.i4.8
		IL_003a: shr
		IL_003b: ldloc.1
		IL_003c: dup
		IL_003d: ldc.i4.1
		IL_003e: add
		IL_003f: stloc.1
		IL_0040: xor
		IL_0041: conv.u1
		IL_0042: stloc.s 4
		IL_0044: pop
		IL_0045: ldloc.s 4
		IL_0047: ldloc.3
		IL_0048: stloc.s 4
		IL_004a: stloc.3
		IL_004b: ldloc.s 4
		IL_004d: ldc.i4.8
		IL_004e: shl
		IL_004f: ldloc.3
		IL_0050: or
		IL_0051: conv.u2
		IL_0052: stelem.i2
		IL_0053: ldc.i4.1
		IL_0054: add

		IL_0055: dup
		IL_0056: ldloc.0
		IL_0057: ldlen
		IL_0058: conv.i4
		IL_0059: blt.s IL_0022

		IL_005b: pop
		IL_005c: ldloc.0
		IL_005d: newobj instance void [mscorlib]System.String::.ctor(char[])
		IL_0062: call string [mscorlib]System.String::Intern(string)
		IL_0067: ret
	} // end of method Sha3::b

	// Properties
	.property instance string AlgorithmName()
	{
		.get instance string ODCrypt.Sha3::get_AlgorithmName()
	}

} // end of class ODCrypt.Sha3

You are not using the latest version of the tool, please update.
Latest version is '10.1.0.8386' (yours is '9.1.0.7988')
