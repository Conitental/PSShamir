BeforeAll {
	$ModuleRoot = "$PSScriptRoot\..\PSShamir\"

	Import-Module "$ModuleRoot\PSShamir.psm1"
}

Describe "Get-ShamirSecretShares" {
	It "should return 7 shares by default" {
		Get-ShamirSecretShares -Secret "Testing allows for better resting 🦭" | Should -HaveCount 7
	}

	It "should return 11 shares" {
		Get-ShamirSecretShares -Secret "Iguana go now 🦎" -Shares 11 | Should -HaveCount 11
	}

	It "should return a validation error" {
		{ Get-ShamirSecretShares -Secret "It's ok to make errors 🐣" -Shares 3 -MinimumShares 5 } | Should -Throw -ExpectedMessage "*The secret would not be recoverable."
	}
}