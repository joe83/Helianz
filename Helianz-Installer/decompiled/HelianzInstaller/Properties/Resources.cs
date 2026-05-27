using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Globalization;
using System.Resources;
using System.Runtime.CompilerServices;

namespace HelianzInstaller.Properties
{
  [GeneratedCode("System.Resources.Tools.StronglyTypedResourceBuilder", "17.0.0.0")]
  [DebuggerNonUserCode]
  [CompilerGenerated]
  internal class Resources
  {
    private static ResourceManager resourceMan;
    private static CultureInfo resourceCulture;

    internal Resources()
    {
    }

    [EditorBrowsable(EditorBrowsableState.Advanced)]
    internal static ResourceManager ResourceManager
    {
      get
      {
        if (HelianzInstaller.Properties.Resources.resourceMan == null)
          HelianzInstaller.Properties.Resources.resourceMan = new ResourceManager("HelianzInstaller.Properties.Resources", typeof(HelianzInstaller.Properties.Resources).Assembly);
        return HelianzInstaller.Properties.Resources.resourceMan;
      }
    }

    [EditorBrowsable(EditorBrowsableState.Advanced)]
    internal static CultureInfo Culture
    {
      get => HelianzInstaller.Properties.Resources.resourceCulture;
      set => HelianzInstaller.Properties.Resources.resourceCulture = value;
    }

    internal static string MariaDBLicense => HelianzInstaller.Properties.Resources.ResourceManager.GetString(nameof(MariaDBLicense), HelianzInstaller.Properties.Resources.resourceCulture);
  }
}
