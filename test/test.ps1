$resourceGroupName = "your-resource-group-name"
$vmName = "your-vm-name"
# $vmNameList = @("vmnam1", "vmname2", "vmname3")


# Get the VM
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName

# Update the tag
$vm.Tags["appName"] = "your value"
$vm.Tags["patchContact"] = "your-value"

# Save the changes
Set-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Tag $vm.Tags

