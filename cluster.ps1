$input_array = @{'Cluster1' = 'server01|srv1:1:8080,srv2:5:808,srv3:6:808 server02|srv4:1:8080,srv2:5:808,srv3:6:808 server03|srv1:1:8080,srv2:5:808,srv3:6:808,srv56:45:9090'; 'Cluster2' = 'server04|srv4:1:8080,srv2:5:808,srv3:6:808'}

foreach ($key in $input_array.Keys) {
    $cluster = $key
	echo "Command to create cluster $cluster"
	$all_info = $input_array.$key
	$all_info1 = $all_info.split(" ")
	foreach ($x in $all_info1)
	{
		$server = $x.split("|")[0]
		echo "command to create server $server"
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
					"srv1" {echo "
					Cluster $cluster
					SERVER $server
					SERVICE $service_name
					NUMBER $number
					PORT $PORT"} 
					"srv2" {echo "
					Cluster $cluster
					SERVER $server
					SERVICE $service_name
					NUMBER $number
					PORT $PORT"}
					"srv3" {echo "
					Cluster $cluster
					SERVER $server
					SERVICE $service_name
					NUMBER $number
					PORT $PORT"}
					"srv4" {echo "
					Cluster $cluster
					SERVER $server
					SERVICE $service_name
					NUMBER $number
					PORT $PORT"}
					 default {"Unable to determine Service Name"}
				}
			
			}
		
		
		}
	}
	echo " "
	
}
