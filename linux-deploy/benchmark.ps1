<#
.SYNOPSIS
    Performance benchmark: Linux/Mono vs Windows/IIS HelianzServer

.DESCRIPTION
    Measures HTTP GET (WSDL) and SOAP ProcessRequest round-trip times for both
    the Linux/Mono and Windows/IIS deployments, then prints a side-by-side
    comparison with throughput and latency statistics.

.PARAMETER LinuxUrl
    Full URL to the Linux/Mono ServiceMain.asmx endpoint.
    Example: http://65.109.236.36:9390/ServiceMain.asmx

.PARAMETER WindowsUrl
    Full URL to the Windows/IIS ServiceMain.asmx endpoint.
    Example: http://localhost/HelianzServer/ServiceMain.asmx

.PARAMETER Iterations
    Number of requests per test (default 30).

.PARAMETER WarmupRuns
    Number of warm-up requests to discard before measuring (default 3).

.PARAMETER User
    Helianz username for the SOAP Login test (default "admin").

.PARAMETER Password
    Helianz password for the SOAP Login test (plain text, hashed before send).

.PARAMETER Computer
    Computer name sent in the SOAP credential header (default $env:COMPUTERNAME).

.PARAMETER SkipSoap
    If set, only runs Test 1 (WSDL GET).  Use this when one endpoint is down.

.EXAMPLE
    # HTTP-only test (both endpoints must answer GET)
    .\benchmark.ps1 -LinuxUrl http://65.109.236.36:9390/ServiceMain.asmx `
                    -WindowsUrl http://localhost/HelianzServer/ServiceMain.asmx `
                    -Iterations 20 -WarmupRuns 3 -SkipSoap

.EXAMPLE
    # Full test including SOAP login
    .\benchmark.ps1 -LinuxUrl http://65.109.236.36:9390/ServiceMain.asmx `
                    -WindowsUrl http://localhost/HelianzServer/ServiceMain.asmx `
                    -User admin -Password secret -Iterations 30
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$LinuxUrl,

    [Parameter(Mandatory=$true)]
    [string]$WindowsUrl,

    [int]$Iterations  = 30,
    [int]$WarmupRuns  = 3,
    [string]$User     = "admin",
    [string]$Password = "",
    [string]$Computer = $env:COMPUTERNAME,
    [switch]$SkipSoap
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

function Write-Header([string]$text) {
    Write-Host ""
    Write-Host ("  " + ("=" * 62)) -ForegroundColor Cyan
    Write-Host ("  " + $text) -ForegroundColor Cyan
    Write-Host ("  " + ("=" * 62)) -ForegroundColor Cyan
}

function Write-Info([string]$text) {
    Write-Host ("  " + $text) -NoNewline -ForegroundColor Yellow
}

function Write-OK([string]$text) {
    Write-Host $text -ForegroundColor Green
}

function Write-Warn([string]$text) {
    Write-Host $text -ForegroundColor Red
}

# ---------------------------------------------------------------------------
# HTTP client (reuse single instance)
# ---------------------------------------------------------------------------
Add-Type -AssemblyName System.Net.Http
$script:handler = New-Object System.Net.Http.HttpClientHandler
$script:handler.AllowAutoRedirect = $true
$script:client  = New-Object System.Net.Http.HttpClient($script:handler)
$script:client.Timeout = [System.TimeSpan]::FromSeconds(30)

# ---------------------------------------------------------------------------
# Build DTO XML helpers
# ---------------------------------------------------------------------------

function Get-PasswordHash([string]$plain) {
    # Helianz sends SHA-1 of the plain-text password
    $sha = [System.Security.Cryptography.SHA1]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($plain)
    $hash  = $sha.ComputeHash($bytes)
    return [System.BitConverter]::ToString($hash).Replace("-","").ToLower()
}

function Build-EmptyDto {
    # DtoGetString with no credentials -- server rejects but still parses fully
    $xml = @"
<?xml version="1.0" encoding="utf-8"?>
<DtoGetString>
  <Credentials>
    <Username>benchtest</Username>
    <Password></Password>
  </Credentials>
  <MethodName>Security.LogInWeb</MethodName>
  <ComputerName>BENCHMARK</ComputerName>
  <Params />
</DtoGetString>
"@
    return $xml.Trim()
}

function Build-LoginDto([string]$username, [string]$password, [string]$computer) {
    $hash = Get-PasswordHash $password
    $xml = @"
<?xml version="1.0" encoding="utf-8"?>
<DtoGetString>
  <Credentials>
    <Username>$username</Username>
    <Password>$hash</Password>
  </Credentials>
  <MethodName>Security.LogInWeb</MethodName>
  <ComputerName>$computer</ComputerName>
  <Params />
</DtoGetString>
"@
    return $xml.Trim()
}

function Escape-Xml([string]$text) {
    return $text `
        -replace "&",  "&amp;"  `
        -replace "<",  "&lt;"   `
        -replace ">",  "&gt;"   `
        -replace '"',  "&quot;" `
        -replace "'",  "&apos;"
}

function Build-SoapEnvelope([string]$dtoXml) {
    $escaped = Escape-Xml $dtoXml
    return @"
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <ProcessRequest xmlns="http://www.open-img.com/">
      <dtoString>$escaped</dtoString>
    </ProcessRequest>
  </soap:Body>
</soap:Envelope>
"@
}

# ---------------------------------------------------------------------------
# Benchmark runners
# ---------------------------------------------------------------------------

function Invoke-HttpGetBenchmark([string]$url, [int]$count, [int]$warmup) {
    $times = [System.Collections.Generic.List[double]]::new()
    $errors = 0

    for ($i = -$warmup; $i -lt $count; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        try {
            $task     = $script:client.GetAsync($url)
            $response = $task.GetAwaiter().GetResult()
            $null     = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
            $sw.Stop()
            if ($i -ge 0) {
                if ($response.IsSuccessStatusCode) {
                    $times.Add($sw.Elapsed.TotalMilliseconds)
                } else {
                    $errors++
                    $times.Add($sw.Elapsed.TotalMilliseconds)
                }
            }
        } catch {
            $sw.Stop()
            $errors++
            if ($i -ge 0) { $times.Add(30000.0) }
        }
    }
    return Summarize-Times $times $errors
}

function Invoke-SoapBenchmark([string]$url, [string]$dtoXml, [string]$label, [int]$count, [int]$warmup) {
    $envelope = Build-SoapEnvelope $dtoXml
    $times    = [System.Collections.Generic.List[double]]::new()
    $errors   = 0

    for ($i = -$warmup; $i -lt $count; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        try {
            $content  = New-Object System.Net.Http.StringContent($envelope, [System.Text.Encoding]::UTF8, "text/xml")
            $content.Headers.Add("SOAPAction", '"http://www.open-img.com/ProcessRequest"')
            $task     = $script:client.PostAsync($url, $content)
            $response = $task.GetAwaiter().GetResult()
            $null     = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
            $sw.Stop()
            if ($i -ge 0) { $times.Add($sw.Elapsed.TotalMilliseconds) }
        } catch {
            $sw.Stop()
            $errors++
            if ($i -ge 0) { $times.Add(30000.0) }
        }
    }
    return Summarize-Times $times $errors
}

function Summarize-Times([System.Collections.Generic.List[double]]$times, [int]$errors) {
    if ($times.Count -eq 0) {
        return [pscustomobject]@{ Avg=0; Min=0; Max=0; P95=0; RPS=0; Errors=$errors }
    }
    $sorted = $times | Sort-Object
    $avg    = ($times | Measure-Object -Average).Average
    $min    = $sorted[0]
    $max    = $sorted[-1]
    $p95idx = [int][Math]::Ceiling(0.95 * $sorted.Count) - 1
    $p95    = $sorted[$p95idx]
    $rps    = if ($avg -gt 0) { [Math]::Round(1000.0 / $avg, 1) } else { 0 }
    return [pscustomobject]@{
        Avg    = [Math]::Round($avg, 1)
        Min    = [Math]::Round($min, 1)
        Max    = [Math]::Round($max, 1)
        P95    = [Math]::Round($p95, 1)
        RPS    = $rps
        Errors = $errors
    }
}

# ---------------------------------------------------------------------------
# Print one comparison row
# ---------------------------------------------------------------------------

function Print-Comparison([string]$label, $linux, $windows) {
    $linuxMs   = $linux.Avg
    $windowsMs = $windows.Avg
    if ($linuxMs -gt 0 -and $windowsMs -gt 0) {
        $ratio = [Math]::Round($linuxMs / $windowsMs, 2)
        if ($ratio -le 1.1) {
            $diffText = "Linux ~same"
        } elseif ($ratio -le 2.0) {
            $diffText = ("Linux {0}x slower" -f $ratio)
        } else {
            $diffText = ("Linux {0}x SLOWER" -f $ratio)
        }
    } else {
        $diffText = "n/a"
    }

    Write-Host ""
    Write-Host ("  --- " + $label + " ---") -ForegroundColor White
    Write-Host ("    Linux/Mono  : avg={0,7}ms  min={1,6}ms  max={2,6}ms  p95={3,6}ms  rps={4,5}  err={5}" -f `
        $linux.Avg, $linux.Min, $linux.Max, $linux.P95, $linux.RPS, $linux.Errors)
    Write-Host ("    Windows/IIS : avg={0,7}ms  min={1,6}ms  max={2,6}ms  p95={3,6}ms  rps={4,5}  err={5}" -f `
        $windows.Avg, $windows.Min, $windows.Max, $windows.P95, $windows.RPS, $windows.Errors)
    Write-Host ("    Comparison  : " + $diffText) -ForegroundColor $(if ($ratio -le 1.1) { "Green" } else { "Yellow" })
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

$n = $Iterations

Write-Host ""
Write-Host ("  " + ("=" * 62)) -ForegroundColor Cyan
Write-Host "  HelianzServer -- Middleware Performance Benchmark" -ForegroundColor Cyan
Write-Host ("  " + ("=" * 62)) -ForegroundColor Cyan
Write-Host ("  Linux/Mono : " + $LinuxUrl) -ForegroundColor Cyan
Write-Host ("  Windows/IIS: " + $WindowsUrl) -ForegroundColor Cyan
Write-Host ("  Iterations : $n (+ $WarmupRuns warmup)") -ForegroundColor Cyan
Write-Host ("  " + ("=" * 62)) -ForegroundColor Cyan

# -- Test 1: WSDL / HTTP GET --------------------------------------------------
Write-Header "Test 1 / 3  -  WSDL fetch  (GET ?wsdl, no auth)"
Write-Host "  Measures: network + web-server + ASP.NET stack overhead"
Write-Info "  Linux   - $n requests: "
$linuxWsdl   = Invoke-HttpGetBenchmark "$LinuxUrl`?wsdl"   $Iterations $WarmupRuns
Write-OK "done"
Write-Info "  Windows - $n requests: "
$windowsWsdl = Invoke-HttpGetBenchmark "$WindowsUrl`?wsdl" $Iterations $WarmupRuns
Write-OK "done"
Print-Comparison "WSDL fetch (GET ?wsdl)" $linuxWsdl $windowsWsdl

if (-not $SkipSoap) {
    # -- Test 2: SOAP -- lightweight (no-auth fast path) ----------------------
    Write-Header "Test 2 / 3  -  SOAP ProcessRequest  (no-auth fast path)"
    Write-Host "  Measures: SOAP parse + DTO deserialize + version check + serialize"
    Write-Host "  (Server rejects with bad-credentials but fully processes the request)"
    $emptyDto = Build-EmptyDto
    Write-Info "  Linux   - $n requests: "
    $linuxSoap   = Invoke-SoapBenchmark $LinuxUrl   $emptyDto "empty-dto" $Iterations $WarmupRuns
    Write-OK "done"
    Write-Info "  Windows - $n requests: "
    $windowsSoap = Invoke-SoapBenchmark $WindowsUrl $emptyDto "empty-dto" $Iterations $WarmupRuns
    Write-OK "done"
    Print-Comparison "SOAP ProcessRequest (no auth)" $linuxSoap $windowsSoap

    # -- Test 3: SOAP -- Login (full DB path) ---------------------------------
    Write-Header "Test 3 / 3  -  SOAP Login  (full path: auth + DB query)"
    Write-Host "  Measures: full round-trip including MySQL query for user verification"
    $loginDto = Build-LoginDto $User $Password $Computer
    Write-Info "  Linux   - $n requests: "
    $linuxLogin   = Invoke-SoapBenchmark $LinuxUrl   $loginDto "login" $Iterations $WarmupRuns
    Write-OK "done"
    Write-Info "  Windows - $n requests: "
    $windowsLogin = Invoke-SoapBenchmark $WindowsUrl $loginDto "login" $Iterations $WarmupRuns
    Write-OK "done"
    Print-Comparison "SOAP Login (DB query included)" $linuxLogin $windowsLogin
}

# -- Summary ------------------------------------------------------------------
Write-Header "Summary"
$rows = [System.Collections.Generic.List[pscustomobject]]::new()
$rows.Add([pscustomobject]@{ Test="WSDL fetch"; Linux=$linuxWsdl.Avg; Windows=$windowsWsdl.Avg })
if (-not $SkipSoap) {
    $rows.Add([pscustomobject]@{ Test="SOAP no-auth";  Linux=$linuxSoap.Avg;   Windows=$windowsSoap.Avg  })
    $rows.Add([pscustomobject]@{ Test="SOAP login";    Linux=$linuxLogin.Avg;  Windows=$windowsLogin.Avg })
}

$hdr = "  {0,-30} {1,16} {2,16} {3,14}"
$sep = "  {0,-30} {1,16} {2,16} {3,14}"
Write-Host ""
Write-Host ($hdr -f "Test", "Linux/Mono avg", "Windows/IIS avg", "Ratio") -ForegroundColor White
Write-Host ($sep -f ("-" * 30), ("-" * 16), ("-" * 16), ("-" * 14)) -ForegroundColor DarkGray

foreach ($row in $rows) {
    if ($row.Windows -gt 0 -and $row.Linux -gt 0) {
        $r = [Math]::Round($row.Linux / $row.Windows, 2)
        $rStr = ("{0}x" -f $r)
        $color = if ($r -le 1.1) { "Green" } elseif ($r -le 2.0) { "Yellow" } else { "Red" }
    } else {
        $rStr = "n/a"
        $color = "Gray"
    }
    Write-Host ($hdr -f $row.Test, ("{0} ms" -f $row.Linux), ("{0} ms" -f $row.Windows), $rStr) -ForegroundColor $color
}

Write-Host ""
Write-Host "  NOTE: ratio = Linux avg / Windows avg.  1.0x = same speed." -ForegroundColor DarkGray
Write-Host "        Network latency to VPS is included in Linux numbers." -ForegroundColor DarkGray
Write-Host ""
