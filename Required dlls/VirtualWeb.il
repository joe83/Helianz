
//  Microsoft (R) .NET Framework IL Disassembler.  Version 4.8.3928.0
//  Copyright (c) Microsoft Corporation.  All rights reserved.



// Metadata version: v4.0.30319
.assembly extern mscorlib
{
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 )                         // .z\V.4..
  .ver 4:0:0:0
}
.assembly VirtualWeb
{
  .custom instance void [mscorlib]System.Runtime.CompilerServices.CompilationRelaxationsAttribute::.ctor(int32) = ( 01 00 08 00 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Runtime.CompilerServices.RuntimeCompatibilityAttribute::.ctor() = ( 01 00 01 00 54 02 16 57 72 61 70 4E 6F 6E 45 78   // ....T..WrapNonEx
                                                                                                             63 65 70 74 69 6F 6E 54 68 72 6F 77 73 01 )       // ceptionThrows.

  // --- The following custom attribute is added automatically, do not uncomment -------
  //  .custom instance void [mscorlib]System.Diagnostics.DebuggableAttribute::.ctor(valuetype [mscorlib]System.Diagnostics.DebuggableAttribute/DebuggingModes) = ( 01 00 02 00 00 00 00 00 ) 

  .custom instance void [mscorlib]System.Reflection.AssemblyTitleAttribute::.ctor(string) = ( 01 00 03 57 65 62 00 00 )                         // ...Web..
  .custom instance void [mscorlib]System.Reflection.AssemblyDescriptionAttribute::.ctor(string) = ( 01 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Reflection.AssemblyConfigurationAttribute::.ctor(string) = ( 01 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Reflection.AssemblyCompanyAttribute::.ctor(string) = ( 01 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Reflection.AssemblyProductAttribute::.ctor(string) = ( 01 00 03 57 65 62 00 00 )                         // ...Web..
  .custom instance void [mscorlib]System.Reflection.AssemblyCopyrightAttribute::.ctor(string) = ( 01 00 12 43 6F 70 79 72 69 67 68 74 20 C2 A9 20   // ...Copyright .. 
                                                                                                  20 32 30 31 39 00 00 )                            //  2019..
  .custom instance void [mscorlib]System.Reflection.AssemblyTrademarkAttribute::.ctor(string) = ( 01 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Runtime.InteropServices.ComVisibleAttribute::.ctor(bool) = ( 01 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Runtime.InteropServices.GuidAttribute::.ctor(string) = ( 01 00 24 34 65 64 33 64 66 32 66 2D 65 39 37 65   // ..$4ed3df2f-e97e
                                                                                                  2D 34 62 63 33 2D 61 65 35 66 2D 61 61 33 31 61   // -4bc3-ae5f-aa31a
                                                                                                  31 31 61 66 35 37 66 00 00 )                      // 11af57f..
  .custom instance void [mscorlib]System.Runtime.Versioning.TargetFrameworkAttribute::.ctor(string) = ( 01 00 1C 2E 4E 45 54 46 72 61 6D 65 77 6F 72 6B   // ....NETFramework
                                                                                                        2C 56 65 72 73 69 6F 6E 3D 76 34 2E 35 2E 32 01   // ,Version=v4.5.2.
                                                                                                        00 54 0E 14 46 72 61 6D 65 77 6F 72 6B 44 69 73   // .T..FrameworkDis
                                                                                                        70 6C 61 79 4E 61 6D 65 14 2E 4E 45 54 20 46 72   // playName..NET Fr
                                                                                                        61 6D 65 77 6F 72 6B 20 34 2E 35 2E 32 )          // amework 4.5.2
  .hash algorithm 0x00008004
  .ver 22:1:0:0
}
.module VirtualWeb.dll
// MVID: {26C9BFEA-C991-4DA7-B167-ED3A5C8099BB}
.imagebase 0x10000000
.file alignment 0x00000200
.stackreserve 0x00100000
.subsystem 0x0003       // WINDOWS_CUI
.corflags 0x00000001    //  ILONLY
// Image base: 0x00000240BA560000


// =============== CLASS MEMBERS DECLARATION ===================

.class public abstract auto ansi sealed beforefieldinit Helianz.Web
       extends [mscorlib]System.Object
{
  .field public static bool IsWeb
  .field public static class [mscorlib]System.Action OnCloseHandler
  .method public hidebysig static bool  Start() cil managed
  {
    // Code size       2 (0x2)
    .maxstack  8
    IL_0000:  ldc.i4.0
    IL_0001:  ret
  } // end of method Web::Start

} // end of class Helianz.Web

.class public auto ansi beforefieldinit Helianz.Thinfinity.Browser
       extends [mscorlib]System.Object
{
  .class auto ansi nested private beforefieldinit SafeUrlData
         extends [mscorlib]System.Object
  {
    .field public string FilePath
    .field public string SafeUrl
    .field public valuetype [mscorlib]System.DateTime DateTimeExpire
    .method public hidebysig specialname rtspecialname 
            instance void  .ctor(string filePath,
                                 string safeUrl,
                                 valuetype [mscorlib]System.DateTime expire) cil managed
    {
      // Code size       28 (0x1c)
      .maxstack  8
      IL_0000:  ldarg.0
      IL_0001:  call       instance void [mscorlib]System.Object::.ctor()
      IL_0006:  ldarg.0
      IL_0007:  ldarg.1
      IL_0008:  stfld      string Helianz.Thinfinity.Browser/SafeUrlData::FilePath
      IL_000d:  ldarg.0
      IL_000e:  ldarg.2
      IL_000f:  stfld      string Helianz.Thinfinity.Browser/SafeUrlData::SafeUrl
      IL_0014:  ldarg.0
      IL_0015:  ldarg.3
      IL_0016:  stfld      valuetype [mscorlib]System.DateTime Helianz.Thinfinity.Browser/SafeUrlData::DateTimeExpire
      IL_001b:  ret
    } // end of method SafeUrlData::.ctor

  } // end of class SafeUrlData

  .field public static class [mscorlib]System.Action`1<string> ProcessApiRequest
  .method public hidebysig static void  SendData(string data,
                                                 int32 browserAction,
                                                 [opt] class [mscorlib]System.Action`1<string> onReceivedResponse) cil managed
  {
    .param [3] = nullref
    // Code size       1 (0x1)
    .maxstack  8
    IL_0000:  ret
  } // end of method Browser::SendData

  .method public hidebysig static string 
          GetComputerNameCookie() cil managed
  {
    // Code size       6 (0x6)
    .maxstack  8
    IL_0000:  ldstr      ""
    IL_0005:  ret
  } // end of method Browser::GetComputerNameCookie

  .method public hidebysig static string 
          GetComputerIpAddress() cil managed
  {
    // Code size       6 (0x6)
    .maxstack  8
    IL_0000:  ldstr      ""
    IL_0005:  ret
  } // end of method Browser::GetComputerIpAddress

  .method public hidebysig static string 
          GetSafeUrl(string filepath) cil managed
  {
    // Code size       6 (0x6)
    .maxstack  8
    IL_0000:  ldstr      ""
    IL_0005:  ret
  } // end of method Browser::GetSafeUrl

  .method public hidebysig static string 
          InsertIframe(native int handle,
                       [opt] string url,
                       [opt] bool isHidden) cil managed
  {
    .param [2] = ""
    .param [3] = bool(false)
    // Code size       6 (0x6)
    .maxstack  8
    IL_0000:  ldstr      ""
    IL_0005:  ret
  } // end of method Browser::InsertIframe

  .method public hidebysig specialname rtspecialname 
          instance void  .ctor() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  call       instance void [mscorlib]System.Object::.ctor()
    IL_0006:  ret
  } // end of method Browser::.ctor

} // end of class Helianz.Thinfinity.Browser

.class public auto ansi beforefieldinit Helianz.Thinfinity.ThinfinityUtils
       extends [mscorlib]System.Object
{
  .method public hidebysig static void  HandleFile(string filePath) cil managed
  {
    // Code size       1 (0x1)
    .maxstack  8
    IL_0000:  ret
  } // end of method ThinfinityUtils::HandleFile

  .method public hidebysig static void  ExportForDownload(string exportFilePath) cil managed
  {
    // Code size       1 (0x1)
    .maxstack  8
    IL_0000:  ret
  } // end of method ThinfinityUtils::ExportForDownload

  .method public hidebysig static void  ExportForDownload(string exportFileName,
                                                          string dataString) cil managed
  {
    // Code size       1 (0x1)
    .maxstack  8
    IL_0000:  ret
  } // end of method ThinfinityUtils::ExportForDownload

  .method public hidebysig static string 
          CombinePaths(string[] paths) cil managed
  {
    // Code size       79 (0x4f)
    .maxstack  3
    .locals init (string V_0,
             int32 V_1,
             string V_2,
             char V_3)
    IL_0000:  ldstr      ""
    IL_0005:  stloc.0
    IL_0006:  ldc.i4.0
    IL_0007:  stloc.1
    IL_0008:  br.s       IL_0047

    IL_000a:  ldarg.0
    IL_000b:  ldloc.1
    IL_000c:  ldelem.ref
    IL_000d:  call       string Helianz.Thinfinity.ThinfinityUtils::RemoveTrailingSeparators(string)
    IL_0012:  stloc.2
    IL_0013:  ldloc.1
    IL_0014:  ldarg.0
    IL_0015:  ldlen
    IL_0016:  conv.i4
    IL_0017:  ldc.i4.1
    IL_0018:  sub
    IL_0019:  bge.s      IL_003b

    IL_001b:  ldloc.2
    IL_001c:  brfalse.s  IL_003b

    IL_001e:  ldloc.2
    IL_001f:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_0024:  ldc.i4.0
    IL_0025:  ble.s      IL_003b

    IL_0027:  ldloc.2
    IL_0028:  ldsfld     char [mscorlib]System.IO.Path::DirectorySeparatorChar
    IL_002d:  stloc.3
    IL_002e:  ldloca.s   V_3
    IL_0030:  call       instance string [mscorlib]System.Char::ToString()
    IL_0035:  call       string [mscorlib]System.String::Concat(string,
                                                                string)
    IL_003a:  stloc.2
    IL_003b:  ldloc.0
    IL_003c:  ldloc.2
    IL_003d:  call       string [mscorlib]System.String::Concat(string,
                                                                string)
    IL_0042:  stloc.0
    IL_0043:  ldloc.1
    IL_0044:  ldc.i4.1
    IL_0045:  add
    IL_0046:  stloc.1
    IL_0047:  ldloc.1
    IL_0048:  ldarg.0
    IL_0049:  ldlen
    IL_004a:  conv.i4
    IL_004b:  blt.s      IL_000a

    IL_004d:  ldloc.0
    IL_004e:  ret
  } // end of method ThinfinityUtils::CombinePaths

  .method public hidebysig static string 
          RemoveTrailingSeparators(string path) cil managed
  {
    // Code size       69 (0x45)
    .maxstack  4
    IL_0000:  br.s       IL_0013

    IL_0002:  ldarg.0
    IL_0003:  ldc.i4.0
    IL_0004:  ldarg.0
    IL_0005:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_000a:  ldc.i4.1
    IL_000b:  sub
    IL_000c:  callvirt   instance string [mscorlib]System.String::Substring(int32,
                                                                            int32)
    IL_0011:  starg.s    path
    IL_0013:  ldarg.0
    IL_0014:  brfalse.s  IL_0043

    IL_0016:  ldarg.0
    IL_0017:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_001c:  ldc.i4.0
    IL_001d:  ble.s      IL_0043

    IL_001f:  ldarg.0
    IL_0020:  ldarg.0
    IL_0021:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_0026:  ldc.i4.1
    IL_0027:  sub
    IL_0028:  callvirt   instance char [mscorlib]System.String::get_Chars(int32)
    IL_002d:  ldc.i4.s   92
    IL_002f:  beq.s      IL_0002

    IL_0031:  ldarg.0
    IL_0032:  ldarg.0
    IL_0033:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_0038:  ldc.i4.1
    IL_0039:  sub
    IL_003a:  callvirt   instance char [mscorlib]System.String::get_Chars(int32)
    IL_003f:  ldc.i4.s   47
    IL_0041:  beq.s      IL_0002

    IL_0043:  ldarg.0
    IL_0044:  ret
  } // end of method ThinfinityUtils::RemoveTrailingSeparators

  .method public hidebysig static string 
          GetTempLocalPathForFile(string filePath) cil managed
  {
    // Code size       54 (0x36)
    .maxstack  4
    .locals init (string V_0)
    IL_0000:  ldarg.0
    IL_0001:  stloc.0
    .try
    {
      IL_0002:  ldc.i4.3
      IL_0003:  newarr     [mscorlib]System.String
      IL_0008:  dup
      IL_0009:  ldc.i4.0
      IL_000a:  call       string [mscorlib]System.IO.Path::GetTempPath()
      IL_000f:  stelem.ref
      IL_0010:  dup
      IL_0011:  ldc.i4.1
      IL_0012:  ldstr      "Helianz"
      IL_0017:  stelem.ref
      IL_0018:  dup
      IL_0019:  ldc.i4.2
      IL_001a:  ldarg.0
      IL_001b:  call       string [mscorlib]System.IO.Path::GetFileName(string)
      IL_0020:  stelem.ref
      IL_0021:  call       string Helianz.Thinfinity.ThinfinityUtils::CombinePaths(string[])
      IL_0026:  stloc.0
      IL_0027:  ldarg.0
      IL_0028:  ldloc.0
      IL_0029:  ldc.i4.1
      IL_002a:  call       void [mscorlib]System.IO.File::Copy(string,
                                                               string,
                                                               bool)
      IL_002f:  leave.s    IL_0034

    }  // end .try
    catch [mscorlib]System.Exception 
    {
      IL_0031:  pop
      IL_0032:  leave.s    IL_0034

    }  // end handler
    IL_0034:  ldloc.0
    IL_0035:  ret
  } // end of method ThinfinityUtils::GetTempLocalPathForFile

  .method public hidebysig specialname rtspecialname 
          instance void  .ctor() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  call       instance void [mscorlib]System.Object::.ctor()
    IL_0006:  ret
  } // end of method ThinfinityUtils::.ctor

} // end of class Helianz.Thinfinity.ThinfinityUtils


// =============================================================

// *********** DISASSEMBLY COMPLETE ***********************
// WARNING: Created Win32 resource file Required dlls\VirtualWeb.res
