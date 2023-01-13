$ProjectName = "cloudbridge"
$Environment = "dev"
$Location = "eastus"
$ResourceGroupName = "rg-${ProjectName}-${Environment}-${Location}-001"

az group create -n $ResourceGroupName -l $Location
az deployment group create `
    -g $ResourceGroupName `
    -n "${ProjectName}-deployment" `
    -f ./infra/main.bicep `
    -p projectName=$ProjectName `
    environment=$Environment `
    location=$Location `
    vpnFQDN="" `
    vpnKey="" `
    adminUsername="" `
    adminPassword=""