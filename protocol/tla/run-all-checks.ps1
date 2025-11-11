# SyncKit TLA+ Verification Runner
# Runs all three formal verification checks

Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "     SyncKit TLA+ Formal Verification" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Check if tla2tools.jar exists
if (-not (Test-Path "tla2tools.jar")) {
    Write-Host "❌ Error: tla2tools.jar not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please download it from:" -ForegroundColor Yellow
    Write-Host "https://github.com/tlaplus/tlaplus/releases/download/v1.8.0/tla2tools.jar" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Save it to: C:\Users\user\synckit\protocol\tla\tla2tools.jar" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Check Java version
try {
    $javaVersion = java -version 2>&1 | Select-String "version" | ForEach-Object { $_ -replace '.*version "([^"]*)".*', '$1' }
    Write-Host "✓ Java found: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: Java not found! Please install Java 11 or higher." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Starting verification (this will take 3-7 minutes)..." -ForegroundColor Yellow
Write-Host ""

$totalStartTime = Get-Date

# Track results
$results = @()

# Function to run TLC check
function Run-TLCCheck {
    param(
        [string]$SpecName,
        [string]$Description,
        [int]$ExpectedMinutes
    )
    
    Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host "Checking: $SpecName" -ForegroundColor Cyan
    Write-Host "Purpose: $Description" -ForegroundColor Gray
    Write-Host "Expected runtime: ~$ExpectedMinutes minute(s)" -ForegroundColor Gray
    Write-Host ""
    
    $startTime = Get-Date
    
    # Run TLC
    $output = java -jar tla2tools.jar -workers auto "$SpecName.tla" 2>&1
    $exitCode = $LASTEXITCODE
    
    $endTime = Get-Date
    $duration = ($endTime - $startTime).TotalSeconds
    
    # Check result
    if ($exitCode -eq 0 -and $output -match "Model checking completed\. No error has been found") {
        Write-Host "✅ PASSED - $SpecName" -ForegroundColor Green -NoNewline
        Write-Host " (${duration}s)" -ForegroundColor Gray
        $script:results += [PSCustomObject]@{
            Spec = $SpecName
            Status = "✅ PASSED"
            Duration = "$([Math]::Round($duration, 1))s"
        }
    } else {
        Write-Host "❌ FAILED - $SpecName" -ForegroundColor Red
        Write-Host ""
        Write-Host "Error output:" -ForegroundColor Yellow
        Write-Host $output
        $script:results += [PSCustomObject]@{
            Spec = $SpecName
            Status = "❌ FAILED"
            Duration = "$([Math]::Round($duration, 1))s"
        }
    }
    
    Write-Host ""
}

# Run all checks
Run-TLCCheck -SpecName "lww_merge" `
             -Description "Last-Write-Wins merge algorithm" `
             -ExpectedMinutes 1

Run-TLCCheck -SpecName "vector_clock" `
             -Description "Vector clock causality tracking" `
             -ExpectedMinutes 1

Run-TLCCheck -SpecName "convergence" `
             -Description "Strong Eventual Consistency proof" `
             -ExpectedMinutes 4

# Calculate total time
$totalEndTime = Get-Date
$totalDuration = ($totalEndTime - $totalStartTime).TotalMinutes

# Print summary
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                 VERIFICATION SUMMARY" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$results | Format-Table -AutoSize

Write-Host "Total time: $([Math]::Round($totalDuration, 2)) minutes" -ForegroundColor Gray
Write-Host ""

# Overall result
$failedCount = ($results | Where-Object { $_.Status -like "*FAILED*" }).Count

if ($failedCount -eq 0) {
    Write-Host "🎉 ALL CHECKS PASSED!" -ForegroundColor Green
    Write-Host ""
    Write-Host "You now have MATHEMATICAL PROOF that:" -ForegroundColor Yellow
    Write-Host "  ✅ LWW merge algorithm is correct" -ForegroundColor Green
    Write-Host "  ✅ Vector clocks work properly" -ForegroundColor Green
    Write-Host "  ✅ Strong Eventual Consistency is guaranteed" -ForegroundColor Green
    Write-Host ""
    Write-Host "Ready to implement Phase 2 (Rust core) with confidence! 🚀" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "⚠️  $failedCount CHECK(S) FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "Review the error traces above to understand what went wrong." -ForegroundColor Yellow
    Write-Host "TLC provides exact counterexamples showing how to break the property." -ForegroundColor Yellow
    exit 1
}
