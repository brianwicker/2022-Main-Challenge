function Set-FlawlessUser {
    <#
    .Synopsis
        Modifies a local user on a remote system
    .Description
        Uses New-PSSession to create / modify a user on a remote system
        SSH Is available as an option
    .EXAMPLE
        Set-CompanyUser
    #>
    [cmdletbinding(DefaultParameterSetName = "default")]
    param(
        # Input value description
        [Parameter(Mandatory = $True)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $user,

        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]] $computerName,

        [Parameter(Mandatory = $true)]
        [Switch]$connectionUserName,

        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$keyPath,
    )
    Begin{}
    process {
        foreach ($computer in $computername) {
                # using SSH Connection
                $connection = @{
                    Hostname    = $computer
                    userName    = $credential.username
                    keyPath     = $keyPath
                }
            # test connection
            Try {
                $session = new-PSSession @connection -erroraction Stop
            } Catch {
                Write-Error "Unable to Connect to $computer"
                Write-Error $_
                continue
            }
            invoke-command -Session $session -ScriptBlock {
                $userSplat = @{
                    name = $user.username
                    password = $user.credential
                }
                Set-LocalUser @userSplat
            }



        }
    } #end of process
    End {

        }
}
