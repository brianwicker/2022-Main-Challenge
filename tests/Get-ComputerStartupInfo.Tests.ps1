<#
.DESCRIPTION
Testing the main script
#>

Describe "Main Script" {
    BeforeAll {
        $script:credential = Get-Secret -Name CimCredential -ErrorAction Ignore
    }

    It "Returns a result" {
        $result = Get-ComputerStartupInfo -ComputerName localhost
        $result | Should -Not -BeNullOrEmpty
    }

    It "Returns the user who last shutdown or restarted" {
        $result = Get-ComputerStartupInfo -ComputerName localhost
        $result.LastShutdownUser | Should -Not -BeNullOrEmpty
    }

    It "Returns one result per computer" {
        $result = Get-ComputerStartupInfo -ComputerName localhost, localhost
        $result.Count | Should -Be 2
    }

    It "Can use alternate credential" -Skip ($script:credential) {
        $result = Get-ComputerStartupInfo -ComputerName localhost -Credential $script:credential
        $result | Should -Not -BeNullOrEmpty
    }
}
