$input_array = @{'rms01' = 'server01|srv1:1:8080,srv2:5:808,srv3:6:808 server02|srv4:1:8080,srv2:5:808,srv3:6:808 server03|srv1:1:8080,srv2:5:808,srv3:6:808,srv56:45:9090'; 'rms02' = 'server04|srv4:1:8080,srv2:5:808,srv3:6:808'}

foreach ($key in $input_array.Keys) {
    $cluster = $key
	sqlcmd -E -Q "DECLARE @currdate DATETIME;
SET @currdate = GETDATE();
exec Resource.RegisteredClusterInsert_Gen @RegisteredClusterID=0,@RegisteredClusterName=N'$cluster',@IsHpcCluster=0,@IsDlmExpressCluster=0,@AdminRoleName=default,@UserRolePassword=default,@IsRoleBased=0,@CreateTime=@currdate,@UpdateTime=@currdate"
	$all_info = $input_array.$key
	$all_info1 = $all_info.split(" ")
	foreach ($x in $all_info1)
	{
		$server = $x.split("|")[0]
	sqlcmd -Q -E "exec Resource.CreateHost @hostName=N'$server',@totalCores=12,@totalMemory=0"
		$srv_prt = $x.split("|")[1]
		foreach($y in $srv_prt)
		{
			$module = $y.split(",")
			foreach ($z in $module)
			{
				$service_name = $z.split(":")[0]
				$number = $z.split(":")[1]
				$port = $z.split(":")[2]
				switch ($service_name) 
				{ 
					"GS" {#create Geocode services#
					sqlcmd -E -Q "exec Resource.CreateGeocodeServices @hostName=N'$server',@clusterName=N'$cluster',@numberOfGeocodeServices=$service_number,@portNumber=$port,@removeExisting=0"
					} 
					"HS" {#create Hydra services#
					sqlcmd -E -Q "exec Resource.CreateHazardServices @hostName=N'$server',@clusterName=N'$cluster',@numberOfHazardServices=$service_number,@portNumber=$port,@removeExisting=0"
					}
					"NEPDML" {#create non-epdlmservices#
					sqlcmd -E -Q "exec Resource.CreateNonEPDlmServices @hostName=N'$server',@clusterName=N'$cluster',@portNumber=$port,@removeExisting=0"
					}
					"EPDLM" {#create epdlmservices#
					sqlcmd -E -Q "exec Resource.CreateEPDlmServices @hostName=N'$server',@clusterName=N'$cluster',@numberOfEventProcessors=$service_number,@portNumber=$port,@removeExisting=0"
					}
					"RPS" {#create RP services#
					sqlcmd -E -Q "exec Resource.CreateRPServices @hostName=N'$server',@clusterName=N'$cluster',@portNumber=$port,@removeExisting=0"
					}
					"RDMDF" {
					#createRDM Datafile services#
sqlcmd -E -Q "exec Resource.CreateRdmDataFileServices @hostName=N'$server',@clusterName=N'$cluster',@portNumber=$port,@removeExisting=0"
							}
					 default {"Unable to determine Service Name"}
				}
			
			}
		
		
		}
	}
	echo " "
	
}