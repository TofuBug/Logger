Use:

- Provides a shared Session Logging utility that tracks and separates logs from different script files and functions while also allowing for grouping of logs into Families and Family Log Inheritence.

How to:

- Setup

    - Minimum Requirements for use

        - using module Logger

            - Line must be FIRST in the main script (assuming other scripts are dot (.) sourced they do not need the using module line)

    - Advanced 

        - `[Logger]` has 4 versions of a Setup method

            - User provides a custom logging folder path, enables/disables appended logs, and sets file Roll Over size

            - User provides a custom logging folder path, enables/disables appended logs

                - Previous Setup method is called passing along parameters setting Roll Over size to default 2621476

            - User provides a custom logging folder path

                - previous setup method is called passing along parameter, setting Appended logs to true

            - User Provides no parameters

                - Previous setup method is called setting custom logging folder path to a default %temp%\Logger path under each user's profile

                - while this method CAN be called it is unnecessary as it is called automatically when any of `[Logger]`'s "Write" methods is first called

        - **Warning** Setup should only be run ONCE at the beginning of a script or not at all if the default %temp%\Logger location is sufficient. Calling setup does NOT affect existing in memory Log instances only newly created ones. 

- Writing to Log

    - `[Logger]` Writes ALL log lines regardless of the method call below using the MEMCM style log format which leverages the CMTrace.exe advanced log viewing capabilities. It populates the following.

        - Time

        - Date

        - Component - Calling Log name (for Family Log)
                
        - Type - Verbose, Information, Warning, Error
        
        - File - Caller Function Name (row,column)

    - `[Logger]` exposes 8 (4 pair) static methods for writing to a log

        - `::Verbose([string])`

            - Writes a simple non color highlighted string to the log

        - `::Verbose([string],[object])`

            - Writes a simple non color highlighted string and data object (output as JSON) to the log

        - `::Information([string])`

            - Writes a simple non color highlighted string to the log

        - `::Information([string],[object])`

            - Writes a simple non color highlighted string and data object (output as JSON) to the log

        - `::Warning([string])`

            - Writes a yellow color highlighted string to the log

                - Color is based on setting Type number NOT on parsed keywords

        - `::Warning([string],[object])`

            - Writes a yellow color highlighted string and data object (output as JSON) to the log

                - Color is based on setting Type number NOT on parsed keywords

        - `::Error([string])`

            - Writes a red color highlighted string to the log

                - Color is based on setting Type number NOT on parsed keywords

        - `::Error([string],[object])`

            - Writes a red color highlighted string and data object (output as JSON) to the log

                - Color is based on setting Type number NOT on parsed keywords

    - Examples

        - `[Logger]::Information('This is a note')`

        - `[Logger]::Error('Could not install App',$AppDetails)`

        - `[Logger]::Warning('Cannot connect wil reattempt')`

        - |_ Main.ps1 _|
            ```
            using module Logger

            . .\Child1.ps1
            . .\Child2.ps1

            function main {
                [LogFamily(Family='Main')]
                param()

                Call-Child1
                Call-Child2
                [Logger]::Information('Ran Main')
            }

            main
            ```
          |_ Child1.ps1 _|
            ```
            function Call-Child1 {
               [LogFamily(Family='Other Childrem',Path='Children')]
               param()

               [Logger]::Information('Run Child1')
            }
            ```
          |_ Child2.ps1 _|
            ```
            function Call-Child2 {
               [LogFamily(Family='Kids',Path='C:\Children')]
               param()

               [Logger]::Information('Run Child2')
            }
            ```
            - Logs to:

                - Main.Log (in main logging folder)

                    - Run Child1

                    - Run Child2

                    - Ran Main

                - Children\Other Children.log (in main logging folder)

                    - Run Child1

                - C:\Children\Kids.log

                    - Run Child2

                - Child1.log (in main logging folder)

                    - Run Child1

                - Child2.log (in main logging folder)

                    - Run Child2

- Using Family Logs

    - Family Logs group in call order logs writting to individual logs capturing log source as well

    - Family Logs are applied via `[LogFamily()]` attributes placed above ANY ScriptBlock's param keyword (much like `[CmdletBinding()]`)

    - Multiple `[LogFamily()]` attributes can be applied to a single param()

    - All `[LogFamily()]` attributes are called within the Call Stack in Ancestors to Dependents order

        - All child function calls with calls to logger even in other files will automatically group around its ancestor's `[LogFamily()]` attribute(s) regardless of having a `[LogFamily()]` attribute declared

        - Parent Attribute beats out children's attributes if Family is named the same

    - Parameters

        - A `[LogFamily()]` attribute has two named parameters

            - Family 

                - This is a string that is the name of the Log Family, it will become the name of the log file. spaces and any other valid Windows file name characters are allowed

            - Path

                - This is a string that represets the path to the folder where the Family log will be written to.

                - There are 3 ways to provide this a value

                    - Do not provide the parameter at all

                        - Family Log is createtd in the same root Logger folder as the other logs

                    - Provide a relative path (no server or drive letters)

                        - Family Log is created in the Path provided relative to the root Logger folder

                    - Provide an absolute path

                        - Family Log is created in the Path provided
    - Examples

        - ```
          [LogFamily(Family='The Family')]
          param()
          ```

        - ```
          [LogFamily(Family='The Family', Path='Family')]
          param()
          ```

        - ```
          [LogFamily(Family='The Family', Path = 'C:\Family')]
          param()
          ```

        - |_ Main.ps1 _|
            ```
            using module Logger

            . .\Child1.ps1
            . .\Child2.ps1

            function main {
                [LogFamily(Family='Main')]
                param()

                Call-Child1
                Call-Child2
                [Logger]::Information('Ran Main')
            }

            main
            ```
          |_ Child1.ps1 _|
             ```
             function Call-Child1 {
                [LogFamily(Family='Other Childrem',Path='Children')]
                param()

                [Logger]::Information('Run Child1')
             }
             ```
          |_ Child2.ps1 _|
             ```
             function Call-Child2 {
                [LogFamily(Family='Kids',Path='C:\Children')]
                param()

                [Logger]::Information('Run Child2')
             }
            ```
            - Logs to:

                - Main.Log (in main logging folder)

                    - Run Child1

                    - Run Child2

                    - Ran Main

                - Children\Other Children.log (in main logging folder)

                    - Run Child1

                - C:\Children\Kids.log

                    - Run Child2

                - Child1.log (in main logging folder)

                    - Run Child1

                - Child2.log (in main logging folder)

                    - Run Child2
        - 

Changes:

- Code Cleanup

    - Updated Tests and Module code to match Coding style and standards. 

        - No Additional functionality or bug fixes.