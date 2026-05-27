# =============================================================================
# Dockerfile  –  Build and run OpenDentalServer on Mono 6 / Linux
# =============================================================================
# Part of the linux-deploy/ package.
# Build context must be the OpenDentalNew repo root (or a directory with
# symlinks that look like the repo root), with docker/ pointing to linux-deploy/src/.
#
# Build:  docker build -f linux-deploy/Dockerfile -t opendental-server-mono .
# Run via compose: see linux-deploy/docker-compose.yml
# =============================================================================

# ─────────────────────────────────────────────────────────────────────────────
# Stage 1 – Build
# ─────────────────────────────────────────────────────────────────────────────
# mono:6.12 full image ships with msbuild — no apt-get needed in builder.
FROM mono:6.12 AS builder

WORKDIR /src

# ── Reference DLLs (HintPath targets, compile-time only) ─────────────────────
COPY ["Required dlls/", "Required dlls/"]

# ── Source projects (dependency order) ───────────────────────────────────────
COPY ["CodeBase/",              "CodeBase/"]
COPY ["DataConnectionBase/",    "DataConnectionBase/"]
COPY ["OpenDentalCloud/",       "OpenDentalCloud/"]
COPY ["PasswordVaultWrapper/",  "PasswordVaultWrapper/"]
COPY ["OpenDentBusiness/",      "OpenDentBusiness/"]
COPY ["OpenDentalServer/",      "OpenDentalServer/"]

# ── Patch 1: Linux PasswordVaultWrapper (no Windows WinRT dependency) ────────
COPY ["linux-deploy/src/PasswordVaultWrapper.Linux.csproj",    "PasswordVaultWrapper/PasswordVaultWrapper.csproj"]
COPY ["linux-deploy/src/WindowsPasswordVaultWrapper.Linux.cs", "PasswordVaultWrapper/WindowsPasswordVaultWrapper.cs"]

# ── Patch 2: Remove assembly refs absent from Mono GAC ───────────────────────
RUN sed -i \
      '/<Reference Include="System\.Web\.DynamicData"/d; \
       /<Reference Include="System\.Web\.Entity"/d; \
       /<Reference Include="System\.Web\.ApplicationServices"/d' \
    OpenDentalServer/OpenDentalServer.csproj

# ── Patch 3: Stub System.Windows.Clipboard (WPF / PresentationCore) ──────────
RUN sed -i \
      's/System\.Windows\.Clipboard\.SetText([^;]*);/\/\/ no-op on Linux/g' \
    CodeBase/Utilities/ODClipboard.cs

# ── Patch 4: Remove COM references (ADODB, CDO) ──────────────────────────────
RUN perl -i -0pe \
      's|<ItemGroup>\s*<COMReference\b.*?</ItemGroup>||gms' \
    OpenDentBusiness/OpenDentBusiness.csproj

# ── Patch 5: Lowercase-mirror Resources/ for Mono ResXFileRef resolution ─────
RUN mkdir -p OpenDentBusiness/resources \
 && find OpenDentBusiness/Resources -mindepth 1 -type d | while IFS= read -r d; do \
      rel=$(printf '%s' "${d#OpenDentBusiness/Resources}" | tr 'A-Z' 'a-z'); \
      mkdir -p "OpenDentBusiness/resources${rel}"; \
    done \
 && find OpenDentBusiness/Resources -type f | while IFS= read -r f; do \
      rel=$(printf '%s' "${f#OpenDentBusiness/Resources/}" | tr 'A-Z' 'a-z'); \
      cp -- "$f" "OpenDentBusiness/resources/${rel}"; \
    done

# ── Patch 6: Compile WPF/CDO stub DLL (PresentationCore unavailable on Mono) ─
COPY ["linux-deploy/src/WpfCdoStubs.cs", "linux-deploy/src/WpfCdoStubs.cs"]
RUN mcs -target:library -r:WindowsBase.dll -out:"Required dlls/WpfCdoStubs.dll" linux-deploy/src/WpfCdoStubs.cs \
 && sed -i '$s|</Project>|<ItemGroup><Reference Include="WpfCdoStubs"><HintPath>../Required dlls/WpfCdoStubs.dll</HintPath></Reference></ItemGroup></Project>|' \
    OpenDentBusiness/OpenDentBusiness.csproj

# ── Patch 7: Comment out unused Windows-only using directives ────────────────
RUN sed -i \
      's|^using CDO;|// [Linux] using CDO;|g; \
       s|^using ADODB;|// [Linux] using ADODB;|g; \
       s|^using System.Windows.Navigation;|// [Linux] using System.Windows.Navigation;|g; \
       s|^using System.Windows.Media.Imaging;|// [Linux] using System.Windows.Media.Imaging;|g; \
       s|^using System.Windows.Controls;|// [Linux] using System.Windows.Controls;|g; \
       s|^using System.Windows.Controls.Primitives;|// [Linux] using System.Windows.Controls.Primitives;|g; \
       s|^using System.Windows.Media.Media3D;|// [Linux] using System.Windows.Media.Media3D;|g' \
    "OpenDentBusiness/Data Interface/Accounts.cs" \
    "OpenDentBusiness/Data Interface/EmailMessages.cs" \
    "OpenDentBusiness/Eclaims/CanadianOutput.cs" \
    "OpenDentBusiness/Misc/ConvertDatabases7.cs" \
    "OpenDentBusiness/Misc/ConvertDatabases8.cs" \
    "OpenDentBusiness/SheetFramework/ToothChartHelper.cs" \
    "OpenDentBusiness/WebBridges/PayConnect2.cs"

# ── Patch 8: Replace Dotfuscated ODCrypt.dll with clean Mono-compatible build ─
# Original DLL is obfuscated; Mono 6.12 JIT rejects its IL with InvalidProgramException.
COPY ["linux-deploy/src/ODCryptMono.cs", "linux-deploy/src/ODCryptMono.cs"]
RUN mcs -target:library -out:"Required dlls/ODCrypt.dll" linux-deploy/src/ODCryptMono.cs

# ── MSBuild ───────────────────────────────────────────────────────────────────
RUN msbuild OpenDentalServer/OpenDentalServer.csproj \
      /p:Configuration=Release \
      /p:Platform=AnyCPU \
      /p:ResGenToolArchitecture=ManagedIL \
      /p:TargetFrameworkVersion=v4.8 \
      /t:Build \
      /v:minimal \
      /nologo

# ─────────────────────────────────────────────────────────────────────────────
# Stage 2 – Runtime
# ─────────────────────────────────────────────────────────────────────────────
FROM mono:6.12-slim AS runtime

# Install mono-xsp4 (Mono's lightweight ASP.NET host).
# Fix Debian Buster EOL apt repos before installing.
RUN sed -i \
      's|http://deb.debian.org/debian|http://archive.debian.org/debian|g; \
       s|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' \
      /etc/apt/sources.list \
 && sed -i '/buster-updates/d' /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends mono-xsp4 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /src/OpenDentalServer/ServiceMain.asmx  ./
COPY --from=builder /src/OpenDentalServer/Web.config        ./
COPY --from=builder /src/OpenDentalServer/bin/              bin/

# Default config (overridden at runtime by docker-compose volume mount)
COPY linux-deploy/config/OpenDentServerConfig.xml  OpenDentalServerConfig.xml

EXPOSE 9390

# Keep stdin open (sleep infinity pipe) so xsp4's Console.ReadLine() never
# returns EOF — without this the server exits immediately in Docker.
ENTRYPOINT ["sh", "-c", "sleep infinity | xsp4 --root=/app --address=0.0.0.0 --port=9390"]
