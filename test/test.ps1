$resourceGroupName = "your-resource-group-name"
$vmName = "your-vm-name"
# $vmNameList = @("vmnam1", "vmname2", "vmname3")


# Get the VM
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName

# Update the tag
$tags = @{"appName"="yourval"; "patchContact"="yourval"}
# Save the changes
New-AzTag -ResourceId $vm.id -Tag $tags

