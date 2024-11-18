BeforeAll {
	$ModuleRoot = "$PSScriptRoot\..\PSShamir\"

	Import-Module "$ModuleRoot\PSShamir.psm1"

    Get-ChildItem "$ModuleRoot\Private" | Foreach-Object { . $_.FullName}
}

Describe "Resolve-ShamirSecretShares" {
	It "should return the original secret" {
        $Secret = "Conisistency is key 🐻"
		$Shares = Get-ShamirSecretShares -Secret $Secret
        Resolve-ShamirSecretShares $Shares | Should -Be $Secret
	}

	It "should return the original secret from only the strings" {
        $Secret = "🦆"
		$Shares = Get-ShamirSecretShares -Secret $Secret
        Resolve-ShamirSecretShares $Shares.Share | Should -Be $Secret
	}

	It "should return a serialization error" {
		{ Resolve-ShamirSecretShares -Shares "I will peng 🐧"} | Should -Throw -ExpectedMessage "Could not unserialize share data"
	}

	It "should return that the secret could not be recovered" {
        $Shares = Get-ShamirSecretShares -Secret "Yo soy una tortuga 🐢" -MinimumShares 4
		{ Resolve-ShamirSecretShares -Shares $Shares[0..2]} | Should -Throw -ExpectedMessage "Could not resolve secret*"
	}

	It "should throw a missing property error" {
        {
            Resolve-ShamirSecretShares (@{Id=1; NotData=''} | ConvertTo-SerializedObject)
        } | Should -Throw -ExpectedMessage "Passed object does not contain required property Data"
	}

	It "should throw a missing property error" {
        {
            Resolve-ShamirSecretShares (@{Id=11; Data='ImNotTheDataYouExpected'} | ConvertTo-SerializedObject)
        } | Should -Throw -ExpectedMessage "Share 11 does not contain required property chunkindex*"
	}
}
