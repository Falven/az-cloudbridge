$ProjectName = "cloudbridge"
$Environment = "dev"
$Location = "eastus"
$ResourceGroupName = "rg-${ProjectName}-${Environment}-${Location}-001"
$RegistryName = "cr${ProjectName}${Environment}${Location}001"
$ACRLogin = "${RegistryName}.azurecr.io"
$HomebridgeImage = "oznu/homebridge:latest"
$ACRHomebridgeImage = "${ACRLogin}/${HomebridgeImage}"

az group create -n $ResourceGroupName -l $Location
az acr create -g $ResourceGroupName -n $RegistryName --sku Basic --admin-enabled true
az acr login -n $RegistryName
docker pull $HomebridgeImage
docker tag $HomebridgeImage $ACRHomebridgeImage
docker push $ACRHomebridgeImage
az provider register --namespace Microsoft.App --wait
az provider register --namespace Microsoft.ContainerService --wait
az deployment group create `
    -g $ResourceGroupName `
    -n "${ProjectName}-deployment" `
    -f ./infra/main.bicep `
    -p projectName=$ProjectName `
    environment=$Environment `
    location=$Location `
    registryName=$RegistryName `
    containerImage=$ACRHomebridgeImage