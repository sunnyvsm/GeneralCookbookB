# load the IIS-Commandlets
Import-Module WebAdministration 

# get the isapi filters currently loaded
Get-WebConfigurationProperty -Filter "/system.webServer/isapiFilters/filter" -name *