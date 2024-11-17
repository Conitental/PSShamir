# Module manifest docs: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_module_manifests

@{

  RootModule = 'PSShamir.psm1'
  ModuleVersion = '1.0.2'
  GUID = '7698fee8-d6db-40a2-8d1d-08aa2fc1339a'
  Author = 'Conitental'
  Description = 'PowerShell implementation of shamirs secret sharing algorythm'

  PrivateData = @{
    PSData = @{
      ProjectUri = 'https://github.com/Conitental/PSShamir'
    }
  }

  FunctionsToExport = @(
    'Get-ShamirSecretShares',
    'Resolve-ShamirSecretShares'
  )

}
