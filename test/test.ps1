Remove-AzVMExtension -ResourceGroupName "resourcegroupname" -Name "extensionname" -VMName "vmname"

$resourceGroupName = "your-resource-group-name"
$vmName = "your-vm-name"
# $vmNameList = @("vmnam1", "vmname2", "vmname3")


# Get the VM
# $vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
$rg = Get-AzResourceGroup -Name $resourceGroupName
# Update the tag
$tags = @{"appName"="yourval"}
# Save the changes
New-AzTag -ResourceId $rg.ResourceId -Tag $tags

