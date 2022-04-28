function Set-CompanyUser {
    <#
    .DESCRIPTION
        Modifies or sets a user account on a remote computer.
    .EXAMPLE
        Uses New-PSSession to set a user account on a remote computer.  SSH is available by using the hostname parameter instead of computerName
    #>
    [cmdletbinding(DefaultParameterSetName = "default")]
    param(
        # Input value description
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [String]$userName,


        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [String[]] $computerName,

        [Parameter(
            Mandatory,
            ParameterSetName = "ssh"
        )]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(
            Mandatory,
            parameterSetName = "ssh"
        )]
        [Switch]$ssh,

        [Parameter(
            Mandatory,
            parameterSetName = "ssh"
        )]
        [Switch]$connectionUserName,

        [Parameter(
            Mandatory,
            parameterSetName = "ssh"
        )]
        [System.IO.FileInfo]$keyPath,
    )
    Begin{

    }
    process {
        foreach ($computer in $computername) {
            if ($ssh) {
                # using SSH Connection
                $connection = @{
                    Hostname    = $computer
                    userName    = $credential.username

                }
            } else {
                $connection = @{
                    ComputerName = $computer
                }
            }
            if ($credential) {
                $connection['Credential'] = $credential
            }
            # test connection
            Try {
                $session = new-PSSession @connection -erroraction Stop
            } Catch {

            }
        }
    } #end of process
    End {

        }
}
