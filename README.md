<div align="center">

# PSShamir

PSShamir is a PowerShell implementation of [*Shamir's secret sharing*](https://en.wikipedia.org/wiki/Shamir's_secret_sharing) algorithm for distributing information among multiple parties while requiring a set amount of them to be able to recover the original information.

</div>

## Purpose
Probably none aside from curiosity and a little desire to educate myself in some topics. Years back i found this algorithm by chance through some answer on a [StackExchange thread about storing private keys](https://security.stackexchange.com/a/115167) and wanted to try some implementation of it later on.

## Installation
*PSShamir* is available on the PowerShell Gallery. Use the following command to install it:

```powershell
Install-Module -Name PSShamir -Scope CurrentUser
```

## Usage

Call `Get-ShamirSecretShares` and specify the information you want to split:
```powershell
$SecretShares = Get-ShamirSecretShares -Secret "Secret Value 🔐"
```

This will by default generate 7 shares as Base64 encoded strings, of which you will need at least three to recover the secret:
```powershell
Resolve-ShamirSecretShares -Shares $SecretShares[0], $SecretShares[4], $SecretShares[2]
```

The amount of generated shares and required shares to resolve the secret can be modified:
```powershell
Get-ShamirSecretShares -Secret "Sharing is caring 🦙" -MininumShares 5 -Shares 7
```

Which in turn means you will need to have at least 5 of the generated shares to recover the original message:
```powershell
Resolve-ShamirSecretShares -Shares $SecretShares[0..4]
```

## Examples

Generate shares and write them to files for distribution:
```powershell
Get-ShamirSecretShares -Secret 'XRidnHBM@*WU!4|CAQvJEk0O' | % {
  Set-Content -Path ".\SecretShare_$($_.Id).txt" -Value $_.Share
}
```

Load saved shares again to recover the secret:
```powershell
$SecretShares = Get-Content .\SecretShare_*
Resolve-ShamirSecretShares $SecretShares
```


