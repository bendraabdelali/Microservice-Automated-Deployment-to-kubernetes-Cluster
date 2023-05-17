# Azure resource group and virtual machine details
$resourceGroup="rancher-rg"
$vmName="rancherVM"
$location="eastus"
$adminUser="ysfesr"
$adminPassword="P@ssw0rd123/Admin"

# Create a resource group
try {
    az group create `
        --name $resourceGroup `
        --location $location
}
catch {
    Write-Error "Error creating resource group: $_"
    exit 1
}

Write-Host "VM creating ..."
# Create a virtual machine
try {
    az vm create `
        --name $vmName `
        --resource-group $resourceGroup `
        --location $location `
        --image UbuntuLTS `
        --admin-username $adminUser `
        --admin-password $adminPassword `
        --authentication-type all `
        --size Standard_DS2_v2 `
        --public-ip-sku Standard `
        --generate-ssh-keys
}
catch {
    Write-Error "Error creating virtual machine: $_"
    exit 1
}


# Install Docker
az vm run-command invoke `
    --name $vmName `
    --resource-group $resourceGroup `
    --command-id RunShellScript `
    --scripts 'sudo apt update && sudo apt install -y docker.io'

Write-Host "Docker installed successfully"

# Start Rancher
az vm run-command invoke `
--name $vmName `
--resource-group $resourceGroup `
--command-id RunShellScript `
--scripts 'sudo docker run -d -p 80:80 -p 443:443 -v /opt/rancher:/var/lib/rancher --privileged rancher/rancher:stable'

Write-Host "Rancher started successfully"

# Open HTTP and HTTPS ports
az vm open-port --resource-group $resourceGroup --name $vmName --port 80  --priority 201 
az vm open-port --resource-group $resourceGroup --name $vmName --port 443 --priority 202

Write-Host "HTTP and HTTPS ports opened successfully"

$publicIP = $(az vm show -d -g $resourceGroup -n $vmName --query publicIps -o tsv)

Write-Host "Public IP address: $publicIP"