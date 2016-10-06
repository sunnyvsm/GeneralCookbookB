# Description: Identify the number of physical processors, logical processors and hyperthreading on the server.
# name: hyperactive.ps1

$vComputerName = "."
$vLogicalCPUs = 0
$vPhysicalCPUs = 0
$vCPUCores = 0
$vSocketDesignation = 0
$vIsHyperThreaded = -1

# Get the Processor information from the WMI object
$vProcessors = [object[]]$(get-WMIObject Win32_Processor -ComputerName $vComputerName)

# To account for older machines
if ($vProcessors[0].NumberOfCores -eq $null)

{
$vSocketDesignation = new-object hashtable
$vProcessors |%{$vSocketDesignation[$_.SocketDesignation] = 1}
$vPhysicalCPUs = $vSocketDesignation.count
$vLogicalCPUs = $vProcessors.count
}

# If the necessary hotfixes are installed as mentioned below, then the NumberOfCores and NumberOfLogicalProcessors can be fetched correctly. For Windows Server 2003, KB932370
else
{
$vCores = $vProcessors.count
$vLogicalCPUs = $($vProcessors|measure-object NumberOfLogicalProcessors -sum).Sum
$vPhysicalCPUs = $($vProcessors|measure-object NumberOfCores -sum).Sum
}

"Logical CPUs: {0}; Physical CPUs: {1}; Number of Cores: {2}" -f $vLogicalCPUs,$vPhysicalCPUs,$vCores
if ($vLogicalCPUs -gt $vPhysicalCPUs)
{
echo "Hyperthreading: Active"
}
else
{
echo "Hyperthreading: Inactive"
}