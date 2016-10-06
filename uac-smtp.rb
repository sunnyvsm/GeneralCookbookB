powershell_Script "UAC Test" do
code <<-EOH
$Username = "username"
$Password = "password"
$pass1 = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass1

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

$From = "your mail id "
$To = "recipent mail id"
#$Cc = "YourBoss@YourDomain.com"
#$Attachment = "C:\temp\Some random file.txt"
$Subject = "UAV status over machine node['hostnaame']"
$Body = $msg_body
$SMTPServer = "smtp server name"
#$SMTPPort = "587"
Send-MailMessage -From $From -to $To -Subject $Subject `
-Body $Body -SmtpServer $SMTPServer -UseSsl `
-Credential $Cred
}

$uac = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")..EnableLUA
 sendmail $uac
EOH
end