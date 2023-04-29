$SplitPath =
    @{
        Parent =
            $true
    }

$ModuleRootPath = 
    $PSScriptRoot | 
        Split-Path @SplitPath
$Config = 
    New-PesterConfiguration

# Run
$Run = 
    @{ 
        Path = 
            "$ModuleRootPath\Tests"
        ExcludePath = 
            @(
                'Run-PesterTests.ps1'
            ) 
        PassThru = 
            $true 
    }

$CodeCoverage = 
    @{ 
        Enabled = 
            $true
        path = 
            @(
                "$ModuleRootPath\Logger.psm1"
            ) 
        OutputPath = 
            "$ModuleRootPath\Tests\CodeCoverage.xml" 
    }

$TestResult = 
    @{ 
        Enabled = 
            $true 
        OutputPath =
            "$ModuleRootPath\Tests\TestResults.xml"
    }

$Output = 
    @{ 
        Verbosity = 
            'Detailed' 
    }

$Config.
    Run = 
        $Run
$Config.
    CodeCoverage = 
        $CodeCoverage
$Config.
    TestResult = 
        $TestResult
$Config.
    Output = 
        $Output

$InvokePester =
    @{
        Configuration =
            $Config
    }
$Results = 
    Invoke-Pester @InvokePester

if (
    $Results.
        CodeCoverage.
            CoveragePercent -eq 
                100 -and 
    $Results.
        Result -eq 
            'Passed'
) {
}