#region Enums
Enum LogEntryLevel {
    Verbose = 0
    Information = 1
    Warning = 2
    Error = 3
}

Enum Where {
    Default = 0
    First = 1
    Last = 2
    SkipUntil = 3
    Until = 4
    Split = 5
}

Enum LogEntryType {
    Message
    Data
}
#endregion

#region Attributes
[AttributeUsage(
    [AttributeTargets]::All, 
    AllowMultiple
)]
class LogFamilyAttribute : Attribute {
    [string] $Family = 
        "DefaultLogFamily"
    [string] $Path
}
#endregion

#region Classes
    #region Log Class
Class Log {
        #region Hidden Properties
    hidden [string] $Name
    hidden [string] $Path
    hidden [bool] $IsFamily
    hidden [int] $MaxMessageSize
        #endregion

        #region Constructor(s)
    hidden Log(
        [string] $N, 
        [string] $P, 
        [bool] $I, 
        [int] $M, 
        [bool] $Append
    ) {         
        $this.
            Name =
                (
                    $N = 
                        $N -replace 
                            '<|>', 
                            '_'
                )
        $JoinPath =
            @{
                Path =
                    $P
                ChildPath = 
                    "$N.log"
            }
        $this.
            Path =
                Join-Path @JoinPath
        $this.
            IsFamily =
                $I
        $this.
            MaxMessageSize = 
                $M
        if (
            -not 
                $Append
        ) { 
            $RemoveItem =
                @{
                    Path =
                        $this.
                            Path 
                    Force =
                        $true
                }
            Remove-Item @RemoveItem
        }
    }
        #endregion

        #region Hidden Methods    
    hidden [void] TestAndRollOver(        
    ) {
        $GetItem =
            @{
                Path =
                    $this.Path
            }
        if (
            (
                Get-Item @GetItem
            ).
                Length -ge 
                    [Logger]::RollOverSize
        ) {
            $GetDate =
                @{ 
                    Format =
                        'yyyyMMdd-HHmmss'
                }
            $RenameItem =
                @{
                    Path =
                        $this.
                            Path 
                    NewName =
                        (
                            $this.
                                Path -replace 
                                    '\.log', 
                                    "-$(
                                        Get-Date @GetDate
                                    ).log"
                        ) 
                    Force =
                        $true
                }
            Rename-Item @RenameItem
        }
    }
    
    hidden [string] Write(
        [string] $Message, 
        [object] $Data, 
        [LogEntryLevel] $EntryLevel
    ) { 
        $Return = 
            $this.
                Write(
                    $Message,
                    $Data,
                    $EntryLevel,
                    $this.
                        Name
                ) 
        [Logger]::ClearCalls(            
        )
        return $Return
    }

    hidden [string] Write(
        [string] $Message, 
        [object] $Data, 
        [LogEntryLevel] $EntryLevel, 
        [string] $Component
    ) {
        $this.
            TestAndRollOver(                
            )
        $Message = 
            $Message -replace 
                '"', 
                '`"'
        $AddContent =
            @{
                Path =
                    $this.
                        Path
                Value =
                    $this.
                        NewLogLine(
                            $Message,
                            [LogEntryType]::Message,
                            $EntryLevel,
                            $Component,
                            [Logger]::GetCall(                    
                            )
                        )
            } 
        Add-Content @AddContent
        if (
            $null -ne 
                $Data
        ) { 
            $ConvertToJson =
                @{
                    InputObject =
                        $Data
                }
            $AddContent =
                @{
                    Path =
                        $this.
                            Path
                    Value =
                        $this.
                            NewLogLine(
                                (
                                    ConvertTo-Json @ConvertToJson
                                ),
                                [LogEntryType]::Data,
                                $EntryLevel,
                                $Component,
                                [Logger]::GetCall(                    
                                )
                            )
                } 
            Add-Content @AddContent
        }
        if (
            !$this.
                IsFamily
        ) { 
            $ForEachObject =
                @{
                    InputObject =
                        [Logger]::Family(                            
                        )
                    Process =
                        {
                            $_.
                                Write(
                                    $Message,
                                    $Data,
                                    $EntryLevel,
                                    $this.
                                        Name
                                )
                        }
                }
            ForEach-Object @ForEachObject
        }
        return $Message
    }

    hidden [string] NewLogLine(
        [string] $Entry, 
        [LogEntryType] $EntryType, 
        [LogEntryLevel] $EntryLevel, 
        [string] $component, 
        [System.Management.Automation.CallStackFrame] $Caller 
    ) {
        $Now = 
            [DateTime]::Now
        $SB = 
            [System.Text.StringBuilder]::new(                
            )
        $Index = 
            -1
        while (
            (
                ++$Index
            ) * 
                $this.
                    MaxMessageSize -lt 
                        $Entry.
                            Length
        ) {
            $IndexTimesMaxMessageSize =
                $Index *
                    $this.
                        MaxMessageSize
            $SubEntry = 
                if (
                    $Entry.
                        Length - 
                            $IndexTimesMaxMessageSize -ge 
                                $this.
                                    MaxMessageSize
                ) {
                    $Entry.
                        Substring(
                            $IndexTimesMaxMessageSize,
                            $this.
                                MaxMessageSize
                        ).
                            PadRight(
                                $this.
                                    MaxMessageSize + 
                                        3, 
                                '.'
                            )
                }
                else {
                    $Entry.
                        Substring(
                            $IndexTimesMaxMessageSize,
                            $Entry.
                                Length - 
                                    $IndexTimesMaxMessageSize
                        )
                }
                $SB.
                    Append(
                        "<![LOG[[$(
                            $EntryLevel.
                                ToString(                                    
                                ).
                                    ToUpper(                                        
                                    )
                        )]:`t$EntryType->$SubEntry]LOG]!>"
                    ).
                    Append(
                        "<"
                    ).
                    Append(
                        "time=`"$(
                            $Now.
                                ToString(
                                    'hh:mm:ss.ffzz'
                                )
                        )`" "
                    ).
                    Append(
                        "date=`"$(
                            $Now.
                                ToString(
                                    'MM-dd-yyyy'
                                )
                        )`" "
                    ).
                    Append(
                        "component=`"$Component`" "
                    ).
                    Append(
                        "context=`"`" "
                    ).
                    Append(
                        "type=`"$(
                            [int]$EntryLevel
                        )`" "
                    ).
                    Append(
                        "thread=`"0`" "
                    ).
                    Append(
                        "file=`"$(
                            $Caller.
                                FunctionName
                        ): ($(
                            $Caller.
                                Position.
                                    StartLineNumber
                        ),$(
                            $Caller.
                                Position.
                                    StartColumnNumber
                        ))`""
                    ).
                    Append(
                        ">"
                    )
            if (
                $Entry.
                    Length - 
                        (
                            $Index * 
                                $this.
                                    MaxMessageSize
                        ) -ge 
                            $this.
                                MaxMessageSize
            ) { 
                $SB.
                    AppendLine(                        
                    ) 
            }
        }
        return $SB.
            ToString(                
            )
    }
        #endregion
}
    #endregion
    #region Logger Class
Class Logger {
        #region Static Public Properties
    static [string] $Path
    static [bool] $Append
    static [int] $RollOverSize
    static [int] $MaxMessageSize
        #endregion

        #region Static Hidden Properties
    hidden static [System.Management.Automation.CallStackFrame[]] $_CallStack
    hidden static [System.Collections.Generic.Dictionary[String,Log]] $_Logger
        #endregion

        #region Static Constructor(s)
    static Logger(        
    ) { 
        [Logger]::ClearCalls(            
        )
        [Logger]::_Logger = 
            [System.Collections.Generic.Dictionary[string,Log]]::new(                
            ) 
        [Logger]::Setup(            
        )
    }
        #endregion

        #region Static Public Methods
    static Setup(        
    ) { 
        [Logger]::Setup(
            "$env:TEMP\Logger"
        ) 
    }

    static Setup(
        [string] $Path
    ) { 
        [Logger]::Setup(
            $Path,
            $true
        ) 
    }

    static Setup(
        [string] $Path, 
        [bool] $Append
    ) { 
        [Logger]::Setup(
            $Path, 
            $Append, 
            2621476
        ) 
    }

    static Setup(
        [string] $Path, 
        [bool] $Append, 
        [int] $RollOverSize
    ) { 
        [Logger]::Setup(
            $Path, 
            $Append,
            $RollOverSize,
            5000
        ) 
    }

    static Setup(
        [string] $Path, 
        [bool] $Append, 
        [int] $RollOverSize, 
        [int] $MaxMessageSize
    ) {
        [Logger]::CreatePath(
            $Path
        )
        [Logger]::Path = 
            $Path
        [Logger]::Append = 
            $Append
        [Logger]::RollOverSize = 
            $RollOverSize
        [Logger]::MaxMessageSize = 
            $MaxMessageSize
    }

            #region Simple Writers 
    static [string] Information(
        [string] $Message
    ) { 
        return [Logger]::Information(
            $Message,
            $null
        ) 
    }

    static [string] Warning(
        [string] $Message
    ) { 
        return [Logger]::Warning(
            $Message,
            $null
        ) 
    }
            
    static [string] Error(
        [string] $Message
    ) { 
        return [Logger]::Error(
            $Message,
            $null
        ) 
    }
            
    static [string] Verbose(
        [string] $Message
    ) { 
        return [Logger]::Verbose(
            $Message,
            $null
        ) 
    }
            #endregion
            
            #region Data Writers
    static [string] Information(
        [string] $Message, 
        [object] $Data
    ) { 
        return [Logger]::Get(            
        ).
            Write(
                $Message,
                $Data,
                [LogEntryLevel]::Information
            ) 
    }
            
    static [string] Warning(
        [string] $Message, 
        [object] $Data
    ) { 
        return [Logger]::Get(            
        ).
            Write(
                $Message,
                $Data,
                [LogEntryLevel]::Warning
            ) 
    }
            
    static [string] Error(
        [string] $Message, 
        [object] $Data
    ) { 
        return [Logger]::Get(            
        ).
            Write(
                $Message,
                $Data,
                [LogEntryLevel]::Error
            ) 
    }
            
    static [string] Verbose(
        [string] $Message, 
        [object] $Data
    ) { 
        return [Logger]::Get(            
        ).
            Write(
                $Message,
                $Data,
                [LogEntryLevel]::Verbose
            ) 
    }
            #endregion
            
        #endregion

        #region Static Hidden Methods 
    hidden static [Log] Get(        
    ) { 
        return [Logger]::Get(
            $false
        ) 
    }

    hidden static [Log] Get(
        [bool] $Force
    ) { 
        return [Logger]::GetLog(
            [Logger]::GetCallName(                
            ), 
            [Logger]::Path, 
            [Logger]::Append, 
            $Force, 
            $false
        ) 
    }
    
    hidden static [void] ClearCalls(        
    ) { 
        [Logger]::_CallStack = 
            $null
    }

    hidden static [object[]] GetCalls(        
    ) { 
        if (
            ![Logger]::_CallStack
        ) { 
            $S =
                Get-PSCallStack
            $TopOfTheStackAKAThisFile =
                $S.
                    Where(
                        $null,
                        [Where]::First
                    ).
                        ScriptName
            [Logger]::_CallStack = 
                $S.
                    Where{ 
                            $_.
                                ScriptName -ne 
                                    $TopOfTheStackAKAThisFile
                        } 
        }
        return [Logger]::_CallStack
    }    

    hidden static [object] GetCall(        
    ) { 
        return [Logger]::GetCalls(            
        )[0] 
    }

    hidden static [string] GetCallName(        
    ) { 
        return (
            [Logger]::GetCall(                
            ).
                Location -split 
                    "\.ps(m|d)?1"
        )[0] 
    }

    hidden static [LogFamilyAttribute[]] GetFamilies(        
    ) {
        $Families = 
            [LogFamilyAttribute[]](
                [System.Collections.Stack]::new(
                    [Logger]::GetCalls(                        
                    ).
                        InvocationInfo.
                            MyCommand.
                                ScriptBlock.
                                    Attributes.
                                        Where{
                                            $_ -is 
                                                [LogFamilyAttribute]
                                        }
                )
            )
        $SelectObject =
            @{
                InputObject =
                    $Families.
                        Family
                Unique =
                    $true
            }
        return [LogFamilyAttribute[]](
            $(
                foreach (
                    $Family in 
                        (
                            Select-Object @SelectObject
                        )
                ) { 
                    $Families.
                        Where(
                            {
                                $_.
                                    Family -eq 
                                        $Family
                            },
                            [Where]::Last
                        ) 
                }
            )
        )
    }

    hidden static CreatePath(
        [string] $Path
    ) { 
        $NewItem =
            @{ 
                Path =
                    $Path 
                ItemType =
                    'Directory'
                Force =
                $true
            }
        New-Item @NewItem
    }
    
    hidden static [Log] GetLog(
        [string] $Name, 
        [string] $Path, 
        [bool] $Append, 
        [bool] $Force, 
        [bool] $IsFamily 
    ) {
        if (
            ![Logger]::_Logger[$Name] -or 
                $Force
        ) { 
            [Logger]::_Logger[$Name] = 
                [Log]::new(
                    $Name, 
                    $Path, 
                    $IsFamily,
                    [Logger]::MaxMessageSize, 
                    $Append
                ) 
        }
        [Logger]::CreatePath(
            $Path
        )
        return [Logger]::_Logger[$Name]
    }
    
    hidden static [string] GetFamilyPath(
        [string] $FamilyPath
    ) { 
        if (
            ![System.IO.Path]::IsPathRooted(
                $FamilyPath
            )
        ) { 
            $JoinPath =
                @{ 
                    Path =
                        [Logger]::Path
                    ChildPath =
                        $FamilyPath 
                }
            $FamilyPath =
                Join-Path @JoinPath
        } 
        return $FamilyPath
    }

    hidden static [Log[]] Family(        
    ) {
        $LogFamilies = 
            ,[LogFamilyAttribute]::new(                
            ) + 
                [Logger]::GetFamilies(                    
                ).
                    Where{
                        $null -ne 
                            $_
                    }
        $DefinedFamilyLogs =
            foreach (
                $_ in 
                    $LogFamilies
            ) { 
                [Logger]::GetLog(
                    $_.
                        Family, 
                    [Logger]::GetFamilyPath(
                        $_.
                            Path
                    ), 
                    $true, 
                    $false, 
                    $true 
                ) 
            }
        return $DefinedFamilyLogs.
            Where{
                $_.
                    IsFamily
            }
    }    
        #endregion
}
    #endregion
#endregion