# load the IIS-Commandlets
Import-Module WebAdministration 

# get the isapi filters currently loaded
Get-WebConfigurationProperty -Filter "/system.webServer/isapiFilters/filter" -name *


clear-content c:\status.html
$output = ''
$table_format = "<!DOCTYPE html>
<html>
<head>
<style>
table { 
color: #333;
font-family: Helvetica, Arial, sans-serif;
width: 800px; 
border-collapse: 
collapse; border-spacing: 0; 
}

td, th { 
border: 1px solid transparent; /* No more visible border */
height: 30px; 
transition: all 0.3s;  /* Simple transition for hover effect */
}

th {
background: #DFDFDF;  /* Darken header a bit */
font-weight: bold;
align: middle;
}

td {
background: #FAFAFA;
text-align: Left;
}

/* Cells in even rows (2,4,6...) are one color */ 
tr:nth-child(even) td { background: #F1F1F1; }   

/* Cells in odd rows (1,3,5...) are another (excludes header cells)  */ 
tr:nth-child(odd) td { background: #FEFEFE; }  

tr td:hover { background: #666; color: #FFF; } /* Hover cell effect! */

#circle_disable {
      width: 26px;
      height: 26px;
      -webkit-border-radius: 13px;
      -moz-border-radius: 13px;
      border-radius: 13px;
      background: red;
    }

#circle_enable {
      width: 26px;
      height: 26px;
      -webkit-border-radius: 13px;
      -moz-border-radius: 13px;
      border-radius: 13px;
      background: green;
    }
</style>
</head>
<body>


<table id=t01>
  <tr>
    <th>Description</th>
    <th>Components</th>		
    <th>Status</th>
  </tr>
  <tr>"

function dotnet_verify()
{

if ($args[0] -eq "v4" )
{
$ver_path = "v4\Full"
$value = "Component"
}
else
{
$ver_path = $args[0]
$value = "Feature"
}
$ndpDirectory = 'hklm:\SOFTWARE\Microsoft\NET Framework Setup\NDP\'
if (Test-Path "$ndpDirectory\$ver_path")
{
Get-ItemProperty "$ndpDirectory\$ver_path" -name Version, Release -EA 0 | select PSChildName, Version  | foreach {
if ($_.PSChildName)
{
$val=$_.Version
$output += "<td>\Microsoft\NET Framework Setup\NDP\$val</td>"
$output += "<td>Component</td>"
$output += "<td><div id=circle_enable></div></td>
</tr>
<tr>"
return $output
}
}
}
else
{
$output += "<td>'\Microsoft\NET Framework Setup\NDP\$ver_path'</td><td style='text-align:center;vertical-align:middle'>$value</td><td style='text-align:center;vertical-align:middle'><div id=circle_disable></div></td></tr><tr>"
return $output
}
}

$registration_iis = "ASP.Net_2.0.50727-64", "ASP.Net_2.0.50727.0", "ASP.Net_2.0_for_V1.1", "ASP.Net_4.0_64bit", "ASP.Net_4.0_32bit"
$output1 = " "
Import-Module WebAdministration 
$versions1 = Get-WebConfigurationProperty -Filter "/system.webServer/isapiFilters/filter" -name *
foreach ($reg_iis in $registration_iis)
{
$fnd1 = echo $versions1 | findstr $reg_iis
if ($fnd1)
{
$output1 += "<td>$reg_iis ===> IIS integration</td><td style='text-align:center;vertical-align:middle'>Features</td><td style='text-align:center;vertical-align:middle'><div id=circle_enable></div></td></tr><tr>"
}
else
{
$output1 += "<td>$reg_iis ===> IIS integration</td><td style='text-align:center;vertical-align:middle'>Features</td><td style='text-align:center;vertical-align:middle' ><div id=circle_disable></div></td></tr><tr>"
}
}

$iis_features = "IIS-WebServerRole", "IIS-HttpRedirect", "IIS-URLAuthorization", "IIS-NetFxExtensibility", "IIS-LoggingLibraries", "IIS-HttpTracing", "IIS-IPSecurity", "IIS-HttpCompressionDynamic", "IIS-ManagementScriptingTools", "IIS-ISAPIExtensions", "IIS-ISAPIFilter", "IIS-ASPNET", "IIS-ASP", "IIS-BasicAuthentication", "IIS-ManagementService", "IIS-WindowsAuthentication", "IIS-DigestAuthentication", "IIS-ClientCertificateMappingAuthentication", "IIS-IISCertificateMappingAuthentication", "WCF-HTTP-Activation", "WCF-NonHTTP-Activation"

$output2=''
$iis_ftrlist = Dism /online /Get-Features /format:table | findstr Enabled
foreach($iis in $iis_features)
{
$res = echo $iis_ftrlist | findstr $iis
if ($res)
{
$output2 += "<td>$iis</td><td style='text-align:center;vertical-align:middle'>Features</td><td style='text-align:center;vertical-align:middle' ><div id=circle_enable></div></td></tr><tr>"
}
else
{
$output2 += "<td>$iis</td><td style='text-align:center;vertical-align:middle'>Features</td><td style='text-align:center;vertical-align:middle' ><div id=circle_disable></div></td></tr><tr>" 
}
}


$output3 =  " "
$app_server_fetr_list = "ApplicationAS-Web-Support", "AS-Ent-Services", "AS-TCP-Port-Sharing", "AS-MSMQ-Activation"
$app_server_enbl_fetr_list =  Get-WindowsFeature | Where-Object { $_.Installed -eq $true }
$app_server = echo $app_server_enbl_fetr_list | findstr "Application server"
if ($app_server)
	{
	$output3 += "<td>Application Server</td><td style='text-align:center;vertical-align:middle'>Feature</td><td style='text-align:center;vertical-align:middle'><div id=circle_enable></div></td></tr><tr>"
	foreach ($app in $app_server_fetr_list)
		{
		$res1 = echo $app_server_enbl_fetr_list | findstr $app
			if ($res1)
			{
			$output3 +="<td>$app</td><td style='text-align:center;vertical-align:middle'>Feature</td><td style='text-align:center;vertical-align:middle'><div id=circle_enable></div></td></tr><tr>" 
			}
			else
			{
			$output3 +="<td>$app</td><td style='text-align:center;vertical-align:middle'>Feature</td><td style='text-align:center;vertical-align:middle'><div id=circle_disable></div></td></tr><tr>" 
			}
		}
	}
else
{	
$output3 += "<td style='text-align:center;vertical-align:middle'>Application Server</td><td>Feature</td><td style='text-align:center;vertical-align:middle'><div id=circle_disable></div></td></tr><tr>"
}

$output4 =" "
$enterprise_lib = "Enterprise Library\ 3.1\ \-\ May\ 2007", "Enterprise\ Library\ 4.1\ -\ October\ 2008", "Microsoft\ Enterprise\ Library\ 5.0"
$entrprs_lib_inst = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\\* | Select-Object DisplayName

–AutoSize
foreach($lib in $enterprise_lib)
{
$res2 = echo $entrprs_lib_ins | findstr $lib
if($res2)
{
$output4 += "<td style='text-align:center;vertical-align:middle'>$lib</td><td>Component</td><td style='text-align:center;vertical-align:middle'><div id=circle_enable></div></td></tr><tr>"
}
else
{
$output4 += "<td style='text-align:center;vertical-align:middle'>$lib</td><td>Component</td><td style='text-align:center;vertical-align:middle'><div id=circle_enable></div></td></tr><tr>"
}
}

$var1 = dotnet_verify v2.0.50727
$var1 += dotnet_verify v3.0
$var1 += dotnet_verify v3.5 
$var1 += dotnet_verify v4\Full

$var1 += $output1
$var1 += $output2
$var1 += $output3
$var1 += $output4
$table_format += $var1

$table_format | out-file -filepath c:\status.html 
Invoke-Expression  c:\status.html



