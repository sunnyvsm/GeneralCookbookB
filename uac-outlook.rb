powershell_Script "UAC Test" do
code <<-EOH
sendmail()
{
$uac_st = $Args[0]
if ( $uac_st -eq 0 )
{
$msg_body = "UAC is disabled over node['hostname']"
}
else
{
$msg_body = "WArning: UAC is Enabled over node['hostname']"
}

$o = New-Object -com Outlook.Application
 
$mail = $o.CreateItem(0)

#2 = high importance email header
$mail.importance = 2

$mail.subject = "UAV status over machine node['hostnaame']"

$mail.body = $msg_body

#for multiple email, use semi-colon ; to separate
$mail.To = "Arpit.Kohale@barclayscorp.com"

$mail.Send()

# $o.Quit()
}

$uac = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")..EnableLUA
 sendmail $uac
EOH
end