[cmdletbinding()]
param(
    [Parameter(
        Mandatory
    )]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [String] $ConfigFilePath
)

function New-SSHSession {
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
        [String[]] $Computer
    )

    process {
        try {
            foreach ($computerName in $Computer) {
                Write-Verbose "Connecting to $computerName"

                New-PSSession -HostName $computerName -KeyFilePath $KeyFilePath -UserName $Username -ErrorAction Stop

            }
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

$configObject = Get-Content -Path $ConfigFilePath | ConvertFrom-Json

$configObject.Hosts |

    ForEach-Object -Process {
        New-SSHSession -KeyFilePath $configObject.KeyFilePath -Username $configObject.Username -Computer $_
    } |

    ForEach-Object -Process {
        Invoke-Command -Session $_ -ScriptBlock { ssh -V }
    }
