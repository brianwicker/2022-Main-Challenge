function Set-FlawlessUser {
    <#
    .Synopsis
        Modifies a local user on a remote system
    .Description
        Uses New-PSSession to create / modify a user on a remote system
        SSH Is available as an option
    .PARAMETER user
        user to create.  Password will be prompted
    .PARAMETER computerName
        ComputerName(s) to create the user on.
    .PARAMETER connectionUserName
        User name to use for SSH Connection
    .PARAMETER connectionKeyPath
        Path to the key file.
    .EXAMPLE
        Set-CompanyUser -user Chris -computerName Computer1 -connectionUserName adminUser -connectionKeyPath c:\temp\keyfile
    #>
    [cmdletbinding(DefaultParameterSetName = "default")]
    param(
        [Parameter(Mandatory = $True)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $user,

        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [String[]]$computerName,

        [Parameter(Mandatory = $true)]
        [Switch]$connectionUserName,

        [Parameter(Mandatory = $true)]
        [ValidateScript({
            if (test-path $_) {
                $true
            } else {
                throw "$_ key file does not exist"
            }
        })]
        [System.IO.FileInfo]$connectionKeyPath,
    )
    Begin{}
    process {
        foreach ($computer in $computername) {
                # using SSH Connection
                $connection = @{
                    Hostname    = $computer
                    userName    = $connectionUsername
                    keyPath     = $connectionkeyPath
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
