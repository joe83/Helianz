# Helianz Middle-Tier — Linux Deployment Guide

Deploys **HelianzServer** (the .NET middle-tier web service) on Linux using
Docker + Mono 6. Replaces the Windows/IIS host with XSP4 (Mono's ASP.NET server)
and a MySQL 8.0 database container.

```
Client (Helianz.exe, Windows)
        │  HTTP  port 9390
        ▼
┌─────────────────────────┐      ┌───────────────────┐
│  helianz-server      │─────▶│  mysql            │
│  mono:6.12-slim + xsp4  │      │  mysql:8.0        │
│  /app/ServiceMain.asmx  │      │  db: helianz   │
│  port 9390              │      │  port 3306        │
└─────────────────────────┘      └───────────────────┘
```

---

## Folder Contents

```
linux-deploy/
├── README.md                        ← this file
├── deploy.sh                        ← one-command deployment script
├── dump-db.ps1                      ← (Windows) dump local MariaDB → helianz.sql.gz
├── Dockerfile                       ← multi-stage Mono build
├── docker-compose.yml               ← orchestrates MySQL + HelianzServer
├── .dockerignore                    ← keeps image layer small
├── config/
│   └── HelianzServerConfig.xml     ← DB connection config (edit before deploy)
└── src/
    ├── ODCryptMono.cs               ← SHA-3 reimplementation (replaces Dotfuscated DLL)
    ├── WpfCdoStubs.cs               ← WPF/CDO stubs for Mono
    ├── WindowsPasswordVaultWrapper.Linux.cs  ← no-op stub
    ├── PasswordVaultWrapper.Linux.csproj     ← stub project file
    └── grant_oduser.sql             ← MySQL privilege grant
```

The **source code** of HelianzServer must be present in the **parent directory**
(i.e. the HelianzNew repo root) when building the Docker image, because the
Dockerfile COPYs source from `../`.  Run `deploy.sh` from inside `linux-deploy/`.

---

## Prerequisites

### Linux server
- Docker Engine ≥ 24  
- Docker Compose plugin (`docker compose` — note: not `docker-compose`)  
- At least 4 GB RAM, 10 GB disk

### Operator machine (Windows, for initial DB export)
- MariaDB / MySQL client tools (`mysqldump` available on `PATH`)
- PowerShell 5+ or PowerShell 7+
- OpenSSH client

---

## Quick Start

### Step 1 — Export the database (Windows)

Run from the repo root:

```powershell
cd linux-deploy
.\dump-db.ps1 `
    -Host     localhost `
    -Port     3306 `
    -User     root `
    -Password "YourLocalRootPassword" `
    -Database helianz `
    -OutFile  data\helianz.sql.gz
```

This creates `linux-deploy\data\helianz.sql.gz`.

### Step 2 — Upload the entire repo to the server

The Dockerfile needs the Helianz source code (`CodeBase/`, `HelianzBusiness/`,
`HelianzServer/`, etc.) at build time, so the **whole repo** must be on the server —
not just `linux-deploy/`.

```powershell
# From Windows (PowerShell) — upload the full repo (this includes linux-deploy/ inside it)
scp -r "D:\path\to\HelianzNew" root@YOUR_SERVER_IP:/opt/helianz-src
```

> Tip: if the repo is large, you can upload only the required sub-folders:
> `CodeBase`, `DataConnectionBase`, `HelianzCloud`, `PasswordVaultWrapper`,
> `HelianzBusiness`, `HelianzServer`, `Required dlls`, and `linux-deploy`.

### Step 3 — Run the deploy script

```bash
ssh root@YOUR_SERVER_IP

# deploy.sh is inside the repo; --src defaults to its parent (the repo root)
cd /opt/helianz-src/linux-deploy
bash deploy.sh --db data/helianz.sql.gz
```

`deploy.sh` will build the Docker image, start MySQL, import the database,
start HelianzServer, and verify the endpoint.

### Step 3 — Verify

```bash
curl http://localhost:9390/ServiceMain.asmx
# Expected: HTTP 200 with an ASMX service description HTML page
```

### Step 4 — Configure the Helianz client (Windows)

In the Helianz client: **Setup → Advanced → Server URL**  
Set to: `http://YOUR_SERVER_IP:9390/ServiceMain.asmx`

---

## Configuration

### `config/HelianzServerConfig.xml`

```xml
<ConnectionSettings>
  <ServerPort>9390</ServerPort>
  <DatabaseConnection>
    <ComputerName>mysql</ComputerName>   <!-- Docker service name, do not change -->
    <Database>helianz</Database>
    <User>oduser</User>
    <Password>odpass</Password>
    <UserLow>oduser</UserLow>
    <PasswordLow>odpass</PasswordLow>
  </DatabaseConnection>
</ConnectionSettings>
```

To change the DB password, edit this file **and** update `MYSQL_PASSWORD`/`MYSQL_USER`
in `docker-compose.yml`, then run `deploy.sh` again (or `docker compose up -d`).

### Ports

| Port | Service | Notes |
|------|---------|-------|
| 9390 | HelianzServer (XSP4) | Exposed to clients |
| 3307 | MySQL (host-side) | Internal; not needed by clients |

Change the host-side MySQL port in `docker-compose.yml` if 3307 is in use.

---

## How It Was Built — Technical Notes

### Problem: HelianzServer targets .NET 4.8 / Windows

HelianzServer is a classic ASP.NET Web Service (.asmx) that was designed to
run on Windows + IIS. Getting it onto Linux required resolving five categories of
incompatibility:

#### 1. PasswordVaultWrapper uses Windows WinRT (Windows.winmd)

`PasswordVaultWrapper.csproj` references `Windows.winmd` (Windows Runtime) which
does not exist on Linux. **Fix**: replaced with `src/PasswordVaultWrapper.Linux.csproj`
+ `src/WindowsPasswordVaultWrapper.Linux.cs` — a no-op stub that satisfies the
interface without any Windows dependency.

#### 2. Missing Mono GAC assemblies

`HelianzServer.csproj` references `System.Web.DynamicData`,
`System.Web.Entity`, and `System.Web.ApplicationServices` — assemblies that exist
in the full .NET Framework but not in Mono's GAC.  
**Fix**: `sed` removes the `<Reference>` items at build time.

#### 3. WPF / CDO assemblies unavailable on Mono

`HelianzBusiness` imports types from `PresentationCore`, `PresentationFramework`,
and `CDO` (Collaboration Data Objects, a Windows COM library).  
**Fix**: `src/WpfCdoStubs.cs` compiles a `WpfCdoStubs.dll` with stub types for all
referenced names. Uses `-r:WindowsBase.dll` (available in Mono's GAC). The stubs
satisfy the compiler; the WPF/CDO code paths are never hit by the server at runtime.

#### 4. ODCrypt.dll is Dotfuscated (obfuscated)

The original `Required dlls/ODCrypt.dll` was processed by Dotfuscator. It produces
IL control-flow patterns (`pop` after a jump, etc.) that the Mono 6.12 JIT rejects
with `InvalidProgramException: Invalid IL code in ODCrypt.Sha3:Hash`.  
**Fix**: `src/ODCryptMono.cs` is a clean reimplementation of the full `ODCrypt`
public API (SHA-3-512 per NIST FIPS 202, MD5, CryptUtil, Encryption stubs). The
Dockerfile compiles it with `mcs` and overwrites the DLL in-tree before the MSBuild
step.

#### 5. ResGen tool architecture mismatch

`ResGenToolArchitecture=Managed32Bit` fails on 64-bit Linux.  
**Fix**: MSBuild flag `/p:ResGenToolArchitecture=ManagedIL`.

#### 6. XSP4 exits immediately in Docker (no TTY)

XSP4 calls `Console.ReadLine()` internally to wait for a stop signal. In Docker
with no terminal attached, stdin is immediately EOF → `ReadLine()` returns `null` →
server exits.  
**Fix**: `ENTRYPOINT ["sh", "-c", "sleep infinity | xsp4 ..."]` — the pipe keeps
stdin open indefinitely.

#### 7. MySQL 8.0 strict mode rejects zero-dates

Helianz stores dates as `0000-00-00 00:00:00` (MariaDB default). MySQL 8.0's
default `sql_mode` includes `NO_ZERO_DATE` and `NO_ZERO_IN_DATE` which rejects
these as invalid.  
**Fix**: MySQL container starts with:
```
--sql-mode=ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
```
(removes the two zero-date flags while keeping other useful constraints).

#### 8. MySQL 8.0 authentication plugin

Old MySqlConnector (shipped in Helianz's DLLs) does not support MySQL 8.0's
default `caching_sha2_password` auth plugin.  
**Fix**: MySQL container starts with `--default-authentication-plugin=mysql_native_password`
and the user is created/altered to use `mysql_native_password`.

#### 9. Mono ResXFileRef lowercases paths

Mono's resource loader lowercases all path components in `.resx` file references.
`HelianzBusiness/Resources/ClaimForms/ClaimFormADA 2019.xml` becomes
`../resources/claimforms/claimformada 2019.xml`.  
**Fix**: At build time a fully-lowercase mirror of `Resources/` is created as
`resources/` so both casing variants resolve correctly.

#### 10. Case-sensitive config filename

The server code in `Userods.LoadDatabaseInfoFromFile()` looks for
`HelianzServerConfig.xml` (with "al"). Original deploy attempts used
`HelianzServerConfig.xml` (missing "al").  
**Fix**: All references use `HelianzServerConfig.xml`.

---

## Managing the Deployment

### View logs
```bash
docker compose -f docker-compose.yml logs -f helianz-server
docker compose -f docker-compose.yml logs -f mysql
```

### Restart server only (no rebuild)
```bash
docker compose -f docker-compose.yml restart helianz-server
```

### Rebuild after source code change
```bash
docker compose -f docker-compose.yml build helianz-server
docker compose -f docker-compose.yml up -d helianz-server
```

### Stop everything
```bash
docker compose -f docker-compose.yml down
```

### Wipe database and start fresh
```bash
docker compose -f docker-compose.yml down -v   # -v removes the named volume
```
Then re-import the database dump.

### Upgrade the database (new Helianz version)
1. Export the new dump with `dump-db.ps1`
2. Run `deploy.sh --db new-dump.sql.gz --rebuild`  
   Or manually: `docker compose down -v`, import new dump, `docker compose up -d`.

---

## Security Notes

- Change `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` before any public deployment.
- Port 9390 should be firewalled to known client IPs (Helianz uses HTTP, not HTTPS).
- `oduser` is granted `ALL PRIVILEGES` to allow Helianz to create backup databases
  (`helianzbackup_MM_DD_YYYY`) at startup. Scope this down in production if desired.
- The `grant_oduser.sql` file grants `*.* WITH GRANT OPTION` — sufficient for a
  dedicated dental-practice server. For a shared server, scope to the specific databases.
