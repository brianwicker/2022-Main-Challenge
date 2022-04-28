function Get-VersionInfo {
    [cmdletbinding()]
    param(
        # Input value description
        [Parameter(
            Mandatory
        )]
        [string] $KeyFilePath,

        [Parameter(
            Mandatory
        )]
        [string] $Username,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [String] $Computer,
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [Switch] $osVersion,
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [Switch] $SSHVersion,
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [Switch] $PSVersion
    )

    process {
        try {
            Write-Verbose "Connecting to $computerName"

            New-PSSession -HostName $computerName -KeyFilePath $KeyFilePath -UserName $Username -ErrorAction Stop
            New-SSHSession -KeyFilePath $KeyFilePath -Username $Username -Computer $Computer |

                ForEach-Object -Process {
                    Invoke-Command -Session $_ -ScriptBlock {
                        if ($SSHVersion) {
                            ssh -V
                        }
                        if ($OSVersion) {
                            $PSVersionTable.OS
                        }
                        if ($PSVersion) {
                            $PSVersionTable.PSVersion.ToString()
                        }
                    }
                }
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
