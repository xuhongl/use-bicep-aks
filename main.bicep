@description('The name of the Managed Cluster resource.')
param clusterName string = 'aks101cluster'

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string

@minValue(0)
@maxValue(5)
@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
param osDiskSizeGB int = 0

@minValue(1)
@maxValue(50)
@description('The number of nodes for the cluster.')
param agentCount int = 3
@description('The size of the Virtual Machine.')
param agentVMSize string = 'Standard_D2s_v3'

@description('User name for the Linux Virtual Machines.')
param linuxAdminUsername string

@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAB...snip...UcyupgH azureuser@linuxvm\'')

@secure()
param sshRSAPublicKey string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD+L5l1abl9IjmmSLHU0cipd+14G5/7YRcr1J3/dzjhp9/2vKbLBFPKcp9fhrZsw0PnYOWVi4idXQP1QPq4mbkNDKNGhOca8MDbuqyLHtUgNMMRqR1GU+VxHOY5MacaaLnn1kuNtl864RhGuqlylxZNvlFhojiyO7rUkansofSBMoADTtAu9vYiv3N2TlfFb+3+xlXrz0yPbljCImRNCgNI8NyzScovkHEcVoySoYyl+JI5Ad9iHb66kF5PeSbY57DBIUHV20r0qhGPM2PSlb5f7aKkQiQQlvj2w3O/go1d9+oXdijUcC2K7gGN8okWgw5WFu0WgYPaE1bV/fql36fd'

resource clusterName_resource 'Microsoft.ContainerService/managedClusters@2020-09-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
  }
}
output controlPlaneFQDN string =clusterName_resource.properties.fqdn
