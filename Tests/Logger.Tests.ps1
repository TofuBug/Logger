using module @{ 
    ModuleName = 
        'Logger' 
    RequiredVersion = 
        '4.0.1.2' 
}

$BeforeAll =
    @{
        Scriptblock =
            {
                $RemoveItem =
                    @{ 
                        Path =
                            @(
                                'C:\LogTemp'
                                'C:\Absolute'
                            )
                        Force =
                            $true
                        Recurse = 
                            $true
                        ErrorAction =
                            'SilentlyContinue'
                    }
                Remove-Item @RemoveItem
            }
    }
$Describe1 =
    @{ 
        Name =
            'Check Classes Exist'
        Fixture =
            {
                $BeforeAll =
                    @{
                        Scriptblock =
                            {
                                $LoadedTypes = 
                                    [AppDomain]::CurrentDomain.
                                        GetAssemblies(                                            
                                        ).
                                            Where{ 
                                                $_.
                                                    Location -eq 
                                                        '' -or 
                                                $_.
                                                    Location -eq 
                                                        $null 
                                            }.
                                                DefinedTypes
                            }
                    }
                $Context1 =
                    @{ 
                        Name =
                            'Attributes' 
                        Fixture =
                            {
                                $Context =
                                    @{
                                        Name =
                                            'LogFamily Attribute'
                                        Fixture =
                                            {
                                                $It =
                                                    @{ 
                                                        Name =
                                                            'Is Defined Type' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            $LoadedTypes.
                                                                                GUID
                                                                        Contain =
                                                                            $true
                                                                        ExpectedValue =
                                                                            [LogFamilyAttribute].
                                                                                GUID
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                It @It
                                            }
                                    }
                                Context @Context
                            }
                    }
                $Context2 =
                    @{
                        Name =
                            'Classes' 
                        Fixture =
                            {
                                $Context1 =
                                    @{
                                        Name =
                                            'Log Class' 
                                        Fixture =
                                            {
                                                $It =
                                                    @{
                                                        Name =
                                                            'Is Defined Type' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            $LoadedTypes.
                                                                                GUID
                                                                        Contain =
                                                                            $true
                                                                        ExpectedValue =
                                                                            [Log].
                                                                                GUID
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                It @It
                                            }
                                    }
                                $Context2 =
                                    @{ 
                                        Name =
                                            'Logger Class' 
                                        Fixture =
                                            {
                                                $It =
                                                    @{ 
                                                        Name =
                                                            'Is Defined Type' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            $LoadedTypes.
                                                                                GUID
                                                                        Contain =
                                                                            $true
                                                                        ExpectedValue =
                                                                            [Logger].
                                                                                GUID
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                It @It
                                            }
                                    }
                                Context @Context1
                                Context @Context2
                            }
                    }
                $Context3 =
                    @{ 
                        Name =
                            'Enumerations' 
                        Fixture =
                            {
                                $Context1 =
                                    @{ 
                                        Name =
                                            'LogEntryType' 
                                        Fixture =
                                            {
                                                $It =
                                                    @{
                                                        Name =
                                                            'Is Defined Type' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            $LoadedTypes.
                                                                                GUID
                                                                        Contain =
                                                                            $true
                                                                        ExpectedValue =
                                                                            [LogEntryType].
                                                                                GUID
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                It @It
                                            }
                                    }
                                $Context2 =
                                    @{ 
                                        Name =
                                            'LogEntryLevel' 
                                        Fixture =
                                            {
                                                $It =
                                                    @{
                                                        Name =
                                                            'Is Defined Type' 
                                                        Test =
                                                            {
                                                                $Should = 
                                                                    @{
                                                                        ActualValue =
                                                                            $LoadedTypes.
                                                                                GUID
                                                                        Contain =
                                                                            $true
                                                                        ExpectedValue =
                                                                            [LogEntryLevel].
                                                                                GUID
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                It @It
                                            }
                                    }
                                Context @Context1
                                Context @Context2
                            }
                    }
                BeforeAll @BeforeAll
                Context @Context1
                Context @Context2
                Context @Context3
            }
    }
$Describe2 =
    @{
        Name =
            "Logger" 
        Fixture =
            {
                $Context1 =
                    @{ 
                        Name =
                            'Defaults' 
                        Fixture =
                            {
                                $It1 =
                                    @{ 
                                        Name =
                                            'Path should be Logger in Users Local Temp' 
                                        Test =
                                            {
                                                $Should =
                                                    @{
                                                        ActualValue =
                                                            [Logger]::Path
                                                        Be =
                                                            $true
                                                        ExpectedValue =
                                                            "$env:TEMP\Logger"
                                                    }
                                                Should @Should
                                            }                                    
                                    }
                                $It2 =
                                    @{ 
                                        Name =
                                            'Roll over Size should be 2621476' 
                                        Test =
                                            {
                                                $Should =
                                                    @{
                                                        ActualValue =
                                                            [Logger]::RollOverSize
                                                        Be =
                                                            $true
                                                        ExpectedValue =
                                                            2621476
                                                    }
                                                Should @Should
                                            }
                                    }
                                $It3 =
                                    @{
                                        Name =
                                            'Append is True' 
                                        Test =
                                            {
                                                $Should =
                                                    @{
                                                        ActualValue =
                                                            [Logger]::Append
                                                        BeTrue =
                                                            $true
                                                    }
                                                Should @Should
                                            }
                                    }
                                $Context =
                                    @{ 
                                        Name =
                                            'Internal Dictionary' 
                                        Fixture =
                                            {
                                                $It1 =
                                                    @{
                                                        Name =
                                                            'Type is Dictionary[string,Log]' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            [Logger]::_Logger
                                                                        BeOfType =
                                                                            $true
                                                                        ExpectedType =
                                                                            [System.Collections.Generic.Dictionary[string,Log]]
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It2 =
                                                    @{
                                                        Name =
                                                            'Initializes to a zero count' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            [Logger]::_Logger.
                                                                                Keys.
                                                                                    Count
                                                                        Be = 
                                                                            $true
                                                                        ExpectedValue =
                                                                            0
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                It @It1
                                                It @It2
                                            } 
                                    }
                                It @It1
                                It @It2
                                It @It3
                                Context @Context
                            }
                    }
                $Context2 =
                    @{
                        Name =
                            'Customized Settings' 
                        Fixture =
                            {
                                $BeforeAll =
                                    @{
                                        Scriptblock =
                                            {
                                                $CustomPath = 
                                                    "$env:SystemDrive\LogTemp"
                                                $CustomAppend = 
                                                    $false
                                                $CustomRollOverSize = 
                                                    3000
                                                [Logger]::Setup(
                                                    $CustomPath, 
                                                    $CustomAppend, 
                                                    $CustomRollOverSize
                                                )
                                            }
                                    }
                                $It1 =
                                    @{
                                        Name =
                                            'Path should be <CustomPath>' 
                                        Test =
                                            {
                                                $Should = 
                                                    @{
                                                        ActualValue =
                                                            [Logger]::Path
                                                        Be =
                                                            $true
                                                        ExpectedValue =
                                                            $CustomPath
                                                    }
                                                Should @Should
                                            }
                                    }
                                $It2 =
                                    @{
                                        Name =
                                            'Roll over Size should be <CustomRollOverSize>' 
                                        Test =
                                            {
                                                $Should =
                                                    @{
                                                        ActualValue =
                                                            [Logger]::RollOverSize
                                                        Be =
                                                            $true
                                                        ExpectedValue =
                                                            $CustomRollOverSize
                                                    }
                                                Should @Should
                                            }
                                    }
                                $It3 =
                                    @{
                                        Name =
                                            'Append is <CustomAppend>' 
                                        Test =
                                            {
                                                $Should =
                                                    @{
                                                        ActualValue =
                                                            [Logger]::Append
                                                        Be = 
                                                            $true
                                                        ExpectedValue =
                                                            $CustomAppend
                                                    }
                                                Should @Should
                                            }
                                    }
                                $Context =
                                    @{
                                        Name =
                                            'Internal Dictionary' 
                                        Fixture =
                                            {
                                                $It1 =
                                                    @{
                                                        Name =
                                                            'Type is Dictionary[string,log]' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            [Logger]::_Logger
                                                                        BeOfType =
                                                                            $true
                                                                        ExpectedType =
                                                                            [System.Collections.Generic.Dictionary[string,Log]]
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It2 = 
                                                    @{
                                                        Name =
                                                            'Initializes to a zero count' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            [Logger]::_Logger.
                                                                                Keys.
                                                                                    Count
                                                                        Be =
                                                                            $true
                                                                        ExpectedValue =
                                                                            0
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                It @It1
                                                It @It2
                                            } 
                                    }
                                BeforeAll @BeforeAll
                                It @It1
                                It @It2
                                It @It3
                                Context @Context
                            }
                    }
                $Context3 =
                    @{
                        Name =
                            'Get' 
                        Fixture =
                            {
                                $BeforeAll =
                                    @{
                                        Scriptblock =
                                            {
                                                $Log = 
                                                    [Logger]::Get(                                                        
                                                    )
                                            }
                                    }
                                $It1 =
                                    @{
                                        Name =
                                            'Should Return [Log]' 
                                        Test =
                                            {
                                                $Should =
                                                    @{
                                                        ActualValue =
                                                            $Log
                                                        BeOfType =
                                                            $true
                                                        ExpectedType =
                                                            [Log]
                                                    }
                                                Should @Should
                                            }
                                    }
                                $It2 =
                                    @{
                                        Name =
                                            'Should be named ' 
                                        Test =
                                            {
                                                $Should =
                                                    @{
                                                        ActualValue =
                                                            $Log.
                                                                Name
                                                        Be =
                                                            $true
                                                        ExpectedValue =
                                                            'Logger.Tests'
                                                    }
                                                Should @Should
                                            }
                                    }
                                $Context1 =
                                    @{
                                        Name =
                                            'Write''s should not throw' 
                                        Fixture =
                                            {
                                                $It1 =
                                                    @{
                                                        Name =
                                                            'Warning' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Warning(
                                                                                    'Kind of bad'
                                                                                )
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should                                                    
                                                            }
                                                    }
                                                $It2 =
                                                    @{
                                                        Name =
                                                            'Error' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Error(
                                                                                    'Bad'
                                                                                )                                                                                
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It3 =
                                                    @{
                                                        Name =
                                                            'Information' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Information(
                                                                                    'Hey'
                                                                                )
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It4 =
                                                    @{
                                                        Name =
                                                            'Verbose' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Verbose(
                                                                                    'TMI'
                                                                                )                                                                                
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }            
                                                    }
                                                It @It1
                                                It @It2
                                                It @It3
                                                It @It4
                                            }
                                    }
                                $Context2 =
                                    @{
                                        Name =
                                            'Write''s with data should not throw' 
                                        Fixture =
                                            {
                                                $BeforeAll =
                                                    @{
                                                        Scriptblock =
                                                            {
                                                                $Data = @{
                                                                    Name   = 
                                                                        'Data'
                                                                    Value  = 
                                                                        'Test Data'
                                                                    Return = 
                                                                        0
                                                                }
                                                            }
                                                    }
                                                $It1 =
                                                    @{
                                                        Name =
                                                            'Warning' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Warning(
                                                                                    'Kind of bad',
                                                                                    $Data
                                                                                )
                                                                            }
                                                                        Not = 
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It2 =
                                                    @{
                                                        Name =
                                                            'Error' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            { 
                                                                                [Logger]::Error(
                                                                                    'Bad', 
                                                                                    $Data
                                                                                ) 
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It3 =
                                                    @{
                                                        Name =
                                                            'Information' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            { 
                                                                                [Logger]::Information(
                                                                                    'Hey', 
                                                                                    $Data
                                                                                ) 
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It4 =
                                                    @{
                                                        Name =
                                                            'Verbose' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Verbose(
                                                                                    'TMI', 
                                                                                    $Data
                                                                                )
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }  
                                                BeforeAll @BeforeAll
                                                It @It1
                                                It @It2
                                                It @It3
                                                It @It4          
                                            }
                                    }
                                BeforeAll @BeforeAll
                                It @It1
                                It @It2
                                Context @Context1
                                Context @Context2
                            }
                    }
                $Context4 =
                    @{
                        Name =
                            'RollOver' 
                        Fixture =
                            {
                                $BeforeAll =
                                    @{
                                        Scriptblock =
                                            {
                                                $RollOverSize = 
                                                    3000
                                                $LoggerPath = 
                                                    [Logger]::Path
                                                $LogName = 
                                                    [Logger]::Get(                                                        
                                                    ).
                                                        Name
                                                $LogPath = 
                                                    [Logger]::Get(                                                        
                                                    ).
                                                        Path
                                            }
                                    }
                                $BeforeEach =
                                    @{
                                        Scriptblock =
                                            {
                                                [Logger]::Information(
                                                    'Padding for rollover tests.'
                                                )
                                                $GetItem =
                                                    @{
                                                        Path =
                                                            $LogPath
                                                    }
                                                $CurrentLength = 
                                                    (
                                                        Get-Item @GetItem
                                                    ).
                                                        Length
                                            }
                                    }
                                $It1 =
                                    @{
                                        Name =
                                            'Should not roll over yet file size <CurrentLength> has not exceeded <RollOverSize> in size' 
                                        Test =
                                            {
                                                $Should =
                                                    @{
                                                        ActualValue =
                                                            $CurrentLength
                                                        Not =
                                                            $true
                                                        BeGreaterThan =
                                                            $true
                                                        ExpectedValue =
                                                            $RollOverSize
                                                    }
                                                Should @Should
                                            }
                                    }
                                $It2 =
                                    @{
                                        Name =
                                            'Should not roll over yet file size <CurrentLength> has not exceeded <RollOverSize> in size' 
                                        Test =
                                            {
                                                $Should =
                                                    @{
                                                        ActualValue =
                                                            $CurrentLength
                                                        Not =
                                                            $true
                                                        BeGreaterThan =
                                                            $true
                                                        ExpectedValue =
                                                            $RollOverSize
                                                    }
                                                Should @Should
                                            }
                                    }
                                $It3 =
                                    @{
                                        Name =
                                            'Should not roll over yet file size <CurrentLength> has not exceeded <RollOverSize> in size' 
                                        Test =
                                            {
                                                $Should =
                                                    @{
                                                        ActualValue =
                                                            $CurrentLength
                                                        Not =
                                                            $true
                                                        BeGreaterThan =
                                                            $true
                                                        ExpectedValue =
                                                            $RollOverSize
                                                    }
                                                Should @Should
                                            }
                                    }
                                $It4 =
                                    @{
                                        Name =
                                            'Should be ready to roll over yet file size <CurrentLength> has meet or exceeded <RollOverSize> in size' 
                                        Test =
                                            {
                                                $Should =
                                                    @{
                                                        ActualValue =
                                                            $CurrentLength
                                                        BeGreaterOrEqual =
                                                            $true
                                                        ExpectedValue =
                                                            $RollOverSize
                                                    }
                                                Should @Should
                                            }
                                    }
                                $It5 =
                                    @{
                                        Name =
                                            'Should have rolled over file size <CurrentLength> is now less than <RollOverSize> in size' 
                                        Test =
                                            {
                                                $Should1 =
                                                    @{
                                                        ActualValue =
                                                            $CurrentLength
                                                        Not =
                                                            $true
                                                        BeGreaterThan =
                                                            $true
                                                        ExpectedValue =
                                                            $RollOverSize
                                                    }
                                                $GetChildItem =
                                                    @{
                                                        Path =
                                                            'C:\LogTemp'
                                                        File =
                                                            $true
                                                    }
                                                $Should2 =
                                                    @{
                                                        ActualValue =
                                                            (
                                                                (
                                                                    Get-ChildItem @GetChildItem
                                                                ) -match
                                                                    "$LogName-\d{8}-\d{6}.log"
                                                            ).
                                                                Count
                                                        BeGreaterThan =
                                                            $true
                                                        ExpectedValue =
                                                            0
                                                    }
                                                Should @Should1
                                                Should @Should2
                                            }
                                    }
                                BeforeAll @BeforeAll
                                BeforeEach @BeforeEach
                                It @It1
                                It @It2
                                It @It3
                                It @It4
                                It @It5
                            }
                    }
                $Context5 =
                    @{
                        Name =
                            'Max Message Size' 
                        Fixture =
                            {
                                $Context1 = 
                                    @{
                                        Name =
                                            'Write''s longer than max message size should not throw' 
                                        Fixture =
                                            {
                                                $BeforeAll =
                                                    @{
                                                        Scriptblock =
                                                            {
                                                                $Message = 
                                                                    ''.
                                                                        PadRight(
                                                                            4999,
                                                                            'A'
                                                                        ).
                                                                        PadRight(
                                                                            9999,
                                                                            'B'
                                                                        ).
                                                                        PadRight(
                                                                            14999,
                                                                            'C'
                                                                        )
                                                            }
                                                    }
                                                $It1 =
                                                    @{
                                                        Name =
                                                            'Warning' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Warning(
                                                                                    $Message
                                                                                )
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It2 = 
                                                    @{
                                                        Name =
                                                            'Error' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Error(
                                                                                    $Message
                                                                                )
                                                                            }
                                                                        Not = 
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It3 =
                                                    @{
                                                        Name =
                                                            'Information' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Information(
                                                                                    $Message
                                                                                )
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It4 =
                                                    @{
                                                        Name =
                                                            'Verbose' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Verbose(
                                                                                    $Message
                                                                                )
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }            
                                                    }
                                                BeforeAll @BeforeAll
                                                It @It1
                                                It @It2
                                                It @It3
                                                It @It4
                                            }
                                    }
                                $Context2 =
                                    @{
                                        Name =
                                            'Write''s with data longer than max message size should not throw' 
                                        Fixture =
                                            {
                                                $BeforeAll =
                                                    @{
                                                        Scriptblock =
                                                            {
                                                                $Data = 
                                                                    @{
                                                                        As = 
                                                                            ''.
                                                                                PadRight(
                                                                                    4999,
                                                                                    'A'
                                                                                )
                                                                        Bs = 
                                                                            ''.
                                                                                PadRight(
                                                                                    4999,
                                                                                    'B'
                                                                                )
                                                                        Cs = 
                                                                            ''.
                                                                                PadRight(
                                                                                    4999,
                                                                                    'C'
                                                                                )
                                                                    }
                                                            }
                                                    }
                                                $It1 = 
                                                    @{
                                                        Name =
                                                            'Warning' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Warning(
                                                                                    'Kind of bad',
                                                                                    $Data
                                                                                )
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It2 =
                                                    @{
                                                        Name =
                                                            'Error' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Error(
                                                                                    'Bad',
                                                                                    $Data
                                                                                )
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It3 =
                                                    @{
                                                        Name =
                                                            'Information'
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Information(
                                                                                    'Hey',
                                                                                    $Data
                                                                                )
                                                                            }
                                                                        Not = 
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                $It4 =
                                                    @{
                                                        Name =
                                                            'Verbose' 
                                                        Test =
                                                            {
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            {
                                                                                [Logger]::Verbose(
                                                                                    'TMI',
                                                                                    $Data
                                                                                )
                                                                            }
                                                                        Not =
                                                                            $true
                                                                        Throw =
                                                                            $true
                                                                    }
                                                                Should @Should
                                                            }            
                                                    }
                                                BeforeAll @BeforeAll
                                                It @It1
                                                It @It2
                                                It @It3
                                                It @It4
                                            }
                                    }
                                Context @Context1
                                Context @Context2
                            }
                    }
                $Context6 =
                    @{
                        Name =
                            'LogFamily Attribute(s)' 
                        Fixture =
                            {
                                $Context1 = 
                                    @{
                                        Name =
                                            'Single Attribute' 
                                        Fixture =
                                            {
                                                $Context1 =
                                                    @{
                                                        Name =
                                                            'No Path' 
                                                        Fixture =
                                                            {
                                                                $BeforeAll =
                                                                    @{
                                                                        Scriptblock =
                                                                            {
                                                                                $LoggerPath = 
                                                                                    [Logger]::Path
                                                                                $LogFamilyName = 
                                                                                    'No Path'
                                                                                function Test-AttributeNoPath {
                                                                                    [LogFamilyAttribute(
                                                                                        Family = 
                                                                                            'No Path'
                                                                                    )]
                                                                                    param(                                                                                        
                                                                                    )                                                                    
                                                                        
                                                                                    [Logger]::Information(
                                                                                        "Testing Attribute with no path"
                                                                                    )
                                                                                }
                                                                                Test-AttributeNoPath
                                                                            }
                                                                    }
                                                                $It =
                                                                    @{
                                                                        Name =
                                                                            'Should Create <LogFamilyName>.log' 
                                                                        Test =
                                                                            {
                                                                                $GetChildItem =
                                                                                    @{
                                                                                        Path =
                                                                                            $LoggerPath
                                                                                    }
                                                                                $Should =
                                                                                    @{
                                                                                        ActualValue =
                                                                                            (
                                                                                                (
                                                                                                    Get-ChildItem @GetChildItem
                                                                                                ) -match
                                                                                                    "$LogFamilyName.log"
                                                                                            ).
                                                                                                Count
                                                                                        Be =
                                                                                            $true
                                                                                        ExpectedValue =
                                                                                            1
                                                                                    }
                                                                                Should @Should
                                                                            }
                                                                    }
                                                                BeforeAll @BeforeAll
                                                                It @It
                                                            }
                                                    }
                                                $Context2 =
                                                    @{
                                                        Name =
                                                            'Relative Path' 
                                                        Fixture =
                                                            {
                                                                $BeforeAll =
                                                                    @{
                                                                        Scriptblock =
                                                                            {
                                                                                $LoggerPath = 
                                                                                    [Logger]::Path
                                                                                $LogPathPart = 
                                                                                    'Relative'
                                                                                $LogFamilyName = 
                                                                                    'Relative Path'
                                                                                function Test-AttributeRelativePath {
                                                                                    [LogFamilyAttribute(
                                                                                        Family = 
                                                                                            'Relative Path', 
                                                                                        Path = 
                                                                                            'Relative'
                                                                                    )]
                                                                                    param(                                                                                        
                                                                                    )
                                                                                
                                                                                    [Logger]::Information(
                                                                                        "Testing Attribute with relative path"
                                                                                    )
                                                                                }
                                                                                Test-AttributeRelativePath
                                                                            }
                                                                    }
                                                                $It =
                                                                    @{
                                                                        Name =
                                                                            'Should Create <LogFamilyName>.log' 
                                                                        Test =
                                                                            {
                                                                                $GetChildItem =
                                                                                    @{
                                                                                        Path =
                                                                                            "$LoggerPath\$LogPathPart"
                                                                                    }
                                                                                $Should =
                                                                                    @{
                                                                                        ActualValue =
                                                                                            (
                                                                                                (
                                                                                                    Get-ChildItem @GetChildItem
                                                                                                ) -match
                                                                                                    "$LogFamilyName.log"
                                                                                            ).
                                                                                                Count
                                                                                        Be =
                                                                                            $true
                                                                                        ExpectedValue =
                                                                                            1
                                                                                    }
                                                                                Should @Should
                                                                            }
                                                                    }
                                                                BeforeAll @BeforeAll
                                                                It @It
                                                            }
                                                    }
                                                $Context3 =
                                                    @{
                                                        Name =
                                                            'Absolute Path' 
                                                        Fixture =
                                                            {
                                                                $BeforeAll =
                                                                    @{
                                                                        Scriptblock =
                                                                            {
                                                                                $LoggerPath = 
                                                                                    [Logger]::Path
                                                                                $LogPath = 
                                                                                    'C:\Absolute'
                                                                                $LogFamilyName = 
                                                                                    'Absolute Path'
                                                                                function Test-AttributeAbsolutePath {
                                                                                    [LogFamilyAttribute(
                                                                                        Family = 
                                                                                            'Absolute Path', 
                                                                                        Path = 
                                                                                            'C:\Absolute'
                                                                                    )]
                                                                                    param(                                                                                        
                                                                                    )
                                                                    
                                                                                    [Logger]::Information(
                                                                                        "Testing Attribute with absolute path"
                                                                                    )
                                                                                }
                                                                                Test-AttributeAbsolutePath
                                                                            }
                                                                    }
                                                                $It =
                                                                    @{
                                                                        Name =
                                                                            'Should Create <LogFamilyName>.log' 
                                                                        Test =
                                                                            {
                                                                                $GetChildItem =
                                                                                    @{
                                                                                        Path =
                                                                                            $LogPath
                                                                                    }
                                                                                $Should =
                                                                                    @{
                                                                                        ActualValue =
                                                                                            (
                                                                                                (
                                                                                                    Get-ChildItem @GetChildItem
                                                                                                ) -match
                                                                                                    "$LogFamilyName.log"
                                                                                            ).
                                                                                                Count
                                                                                        Be =
                                                                                            $true
                                                                                        ExpectedValue =
                                                                                            1
                                                                                    }
                                                                                Should @Should
                                                                            }
                                                                    }
                                                                BeforeAll @BeforeAll
                                                                It @It
                                                            }
                                                    }
                                                Context @Context1
                                                Context @Context2
                                                Context @Context3
                                            }
                                    }
                                $Context2 =
                                    @{
                                        Name =
                                            'Multiple Attributes' 
                                        Fixture =
                                            {
                                                $BeforeAll =
                                                    @{
                                                        Scriptblock =
                                                            {
                                                                $LoggerPath = 
                                                                    [Logger]::Path
                                                                $LogFamilyName1 = 
                                                                    'One'
                                                                $LogFamilyName2 = 
                                                                    'Two'
                                                                function Test-Attributes {
                                                                    [LogFamilyAttribute(
                                                                        Family = 
                                                                            'One'
                                                                    )]
                                                                    [LogFamilyAttribute(
                                                                        Family = 
                                                                            'Two'
                                                                    )]
                                                                    
                                                                    param(                                                                        
                                                                    )
                                                    
                                                                    [Logger]::Information(
                                                                        "Testing Attributes"
                                                                    )
                                                                }
                                                
                                                                Test-Attributes
                                                            }
                                                    }
                                                $It =
                                                    @{
                                                        Name =
                                                            'Should Create <LogFamilyName1>.log and <LogFamilyName2>.log' 
                                                        Test =
                                                            {
                                                                $GetChildItem =
                                                                    @{
                                                                        Path =
                                                                            $LoggerPath
                                                                    }
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            (
                                                                                (
                                                                                    Get-ChildItem @GetChildItem
                                                                                ) -match
                                                                                    "($LogFamilyName1|$LogFamilyName2).log"
                                                                            ).
                                                                                Count
                                                                        Be =
                                                                            $true
                                                                        ExpectedValue =
                                                                            2
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                BeforeAll @BeforeAll
                                                It @It
                                            }
                                    }
                                $Context3 =
                                    @{ 
                                        Name =
                                            'Parent Attribute' 
                                        Fixture =
                                            {
                                                $BeforeAll =
                                                    @{
                                                        Scriptblock =
                                                            {
                                                                $LoggerPath = 
                                                                    [Logger]::Path
                                                                $LogFamilyName = 
                                                                    'Parent'
                                                                function Test-AttributeParent {
                                                                    [LogFamilyAttribute(
                                                                        Family = 
                                                                            'Parent'
                                                                    )]
                                                                    param(                                                                        
                                                                    )
                                                                
                                                                    Test-AttributeChild    
                                                                }
                                                            
                                                                function Test-AttributeChild {
                                                                    param(                                                                        
                                                                    )
                                                                
                                                                    [Logger]::Information(
                                                                        "Testing Attribute with inherited attribute"
                                                                    )
                                                                }
                                                            
                                                                Test-AttributeParent
                                                            }
                                                    }
                                                $It =
                                                    @{
                                                        Name =
                                                            'Should Create still <LogFamilyName>.log even though log call was from child call' 
                                                        Test =
                                                            {
                                                                $GetChildItem =
                                                                    @{
                                                                        Path =
                                                                            $LoggerPath
                                                                    }
                                                                $Should =
                                                                    @{
                                                                        ActualValue =
                                                                            (
                                                                                (
                                                                                    Get-ChildItem @GetChildItem
                                                                                ) -match
                                                                                    "$LogFamilyName.log"
                                                                            ).
                                                                                Count
                                                                        Be =
                                                                            $true
                                                                        ExpectedValue =
                                                                            1
                                                                    }
                                                                Should @Should
                                                            }
                                                    }
                                                BeforeAll @BeforeAll
                                                It @It
                                            }
                                    }
                                Context @Context1
                                Context @Context2
                                Context @Context3
                            }
                    }
                Context @Context1
                Context @Context2
                Context @Context3
                Context @Context4
                Context @Context5
                Context @Context6
            }
    }
BeforeAll @BeforeAll
Describe @Describe1
Describe @Describe2