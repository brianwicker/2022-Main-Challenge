<#
.DESCRIPTION
Testing the main script
#>

Describe "Main Script" {
    BeforeAll {

    }

    It "Returns a result" {
        $result = Get-ComputerStartupInfo -ComputerName localhost
        $result | Should -Not -BeNullOrEmpty
    }

    It "Returns the user who last shutdown or restarted" {
        $result = Get-ComputerStartupInfo -ComputerName localhost
        $result.LastShutdownUser | Should -Not -BeNullOrEmpty
    }


}
