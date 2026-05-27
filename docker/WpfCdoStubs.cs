// =============================================================================
// WpfCdoStubs.cs  –  Minimal stub types for Linux/Mono compilation
// =============================================================================
// These stub types exist only to allow OpenDentBusiness to compile on Mono
// where PresentationCore, PresentationFramework, and CDO COM assemblies are
// unavailable.  None of the stub types function at runtime; any code path that
// invokes them will throw PlatformNotSupportedException.
// =============================================================================
using System;
using System.Collections.Generic;

// ---------------------------------------------------------------------------
// CDO (Collaboration Data Objects) stubs
// Used in: Email/SendEmails.cs (implicit-SSL email path, never exercised on Linux)
// ---------------------------------------------------------------------------
namespace CDO {

    public class Field {
        public object Value { get; set; }
    }

    public class Fields {
        private readonly Dictionary<string, Field> _map = new Dictionary<string, Field>();
        public Field this[string key] {
            get {
                Field f;
                if (!_map.TryGetValue(key, out f)) { f = new Field(); _map[key] = f; }
                return f;
            }
        }
        public void Update() { }
    }

    public class BodyPart {
        public Fields Fields { get; } = new Fields();
    }

    public class Configuration {
        public Fields Fields { get; } = new Fields();
    }

    public class Message {
        public string From    { get; set; }
        public string To      { get; set; }
        public string CC      { get; set; }
        public string BCC     { get; set; }
        public string Subject { get; set; }
        public string HTMLBody{ get; set; }
        public string TextBody{ get; set; }
        public Configuration Configuration { get; } = new Configuration();
        public BodyPart AddAttachment(string url) { return new BodyPart(); }
        public void Send() { throw new PlatformNotSupportedException("CDO (Windows Collaboration Data Objects) is not available on Linux."); }
    }
}

// ---------------------------------------------------------------------------
// System.Windows.Media stubs  (PresentationCore – not in Mono)
// Used in: SheetFramework/GraphicsHelper.cs, Db Multi Table/DashboardQueries.cs
// ---------------------------------------------------------------------------
namespace System.Windows.Media {

    public enum SweepDirection { Counterclockwise = 0, Clockwise = 1 }

    /// <summary>Stub for System.Windows.Media.Color (PresentationCore).</summary>
    public struct Color {
        public byte A { get; set; }
        public byte R { get; set; }
        public byte G { get; set; }
        public byte B { get; set; }
        public static Color FromArgb(byte a, byte r, byte g, byte b) {
            return new Color { A = a, R = r, G = g, B = b };
        }
    }

    public abstract class PathSegment { }

    public class PathSegmentCollection : List<PathSegment> { }

    public class PathFigureCollection : List<PathFigure> { }

    public class PathFigure {
        public System.Windows.Point StartPoint { get; set; }
        public PathSegmentCollection Segments { get; } = new PathSegmentCollection();
    }

    public class PathGeometry {
        public PathFigureCollection Figures { get; } = new PathFigureCollection();
    }

    public class LineSegment : PathSegment {
        public LineSegment(System.Windows.Point point, bool isStroked) { }
    }

    public class ArcSegment : PathSegment {
        public ArcSegment(System.Windows.Point point, System.Windows.Size size,
            double rotationAngle, bool isLargeArc, SweepDirection sweepDirection, bool isStroked) { }
    }
}

// ---------------------------------------------------------------------------
// System.Windows.Shapes stubs  (PresentationFramework – not in Mono)
// Used in: SheetFramework/GraphicsHelper.cs
// ---------------------------------------------------------------------------
namespace System.Windows.Shapes {
    public class Path {
        public System.Windows.Media.PathGeometry Data { get; set; }
        public object Stroke              { get; set; }
        public double StrokeThickness     { get; set; }
    }
}

// ---------------------------------------------------------------------------
// System.Windows.Documents stubs  (PresentationFramework – not in Mono)
// Used in: Data Interface/EFormFields.cs
// ---------------------------------------------------------------------------
namespace System.Windows.Documents {
    public class FlowDocument {
        public System.Windows.Thickness PagePadding { get; set; }
        public bool AllowDrop { get; set; }
    }
}

// ---------------------------------------------------------------------------
// System.Windows stubs  (PresentationCore / PresentationFramework – not in Mono)
// Used in: Eclaims/Ramq.cs (MessageBox), SheetFramework/GraphicsHelper.cs (Clipboard)
// ---------------------------------------------------------------------------
namespace System.Windows {
    public struct Thickness {
        public Thickness(double uniformLength) { }
        public Thickness(double left, double top, double right, double bottom) { }
    }

    public static class MessageBox {
        public static void Show(string text) { }
        public static void Show(string text, string caption) { }
        public static void Show(string text, string caption, int buttons) { }
    }

    public static class Clipboard {
        public static bool ContainsText() { return false; }
    }
}

// ---------------------------------------------------------------------------
// System.Windows.Input stubs  (PresentationCore – not in Mono)
// Used in: UI/GridOld.cs, UI/GridOD.cs (Keyboard.IsKeyDown)
// NOTE: System.Windows.Input.Key is already defined in WindowsBase.dll – do NOT redefine it.
// ---------------------------------------------------------------------------
namespace System.Windows.Input {
    public static class Keyboard {
        public static bool IsKeyDown(System.Windows.Input.Key key) { return false; }
    }
}

// ---------------------------------------------------------------------------
// System.Windows.Markup stubs  (PresentationFramework – not in Mono)
// Used in: Data Interface/EFormFields.cs (XamlReader.Load, XamlWriter.Save)
// ---------------------------------------------------------------------------
namespace System.Windows.Markup {
    public static class XamlReader {
        public static object Load(object reader) {
            throw new PlatformNotSupportedException("XamlReader is not available on Linux/Mono.");
        }
    }

    public static class XamlWriter {
        public static void Save(object value, object writer) {
            throw new PlatformNotSupportedException("XamlWriter is not available on Linux/Mono.");
        }
    }
}
