#!/bin/bash

# Variables
RG_NAME="rg-no-public-ip"
LOCATION="australiaeast"

VNET_NAME="vnet-private"
SUBNET_NAME="subnet-private"
ADDRESS_PREFIX="10.0.0.0/16"
SUBNET_PREFIX="10.0.1.0/24"

VM1_NAME="vm-private-01"
VM2_NAME="vm-private-02"

ADMIN_USER="azureuser"
ADMIN_PASSWORD="P@ssw0rd123456!"  # Must meet Azure password policy

# Create resource group
az group create \
  --name $RG_NAME \
  --location $LOCATION

# Create virtual network and subnet
az network vnet create \
  --resource-group $RG_NAME \
  --name $VNET_NAME \
  --address-prefix $ADDRESS_PREFIX \
  --subnet-name $SUBNET_NAME \
  --subnet-prefix $SUBNET_PREFIX

# Create NICs without public IP
az network nic create \
  --resource-group $RG_NAME \
  --name nic-$VM1_NAME \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME

az network nic create \
  --resource-group $RG_NAME \
  --name nic-$VM2_NAME \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME

# Create VM1
az vm create \
  --resource-group $RG_NAME \
  --name $VM1_NAME \
  --nics nic-$VM1_NAME \
  --image Win2022Datacenter \
  --admin-username $ADMIN_USER \
  --admin-password $ADMIN_PASSWORD \
  --authentication-type password \
  --public-ip-address "" \
  --license-type Windows_Server

# Create VM2
az vm create \
  --resource-group $RG_NAME \
  --name $VM2_NAME \
  --nics nic-$VM2_NAME \
  --image Win2022Datacenter \
  --admin-username $ADMIN_USER \
  --admin-password $ADMIN_PASSWORD \
  --authentication-type password \
  --public-ip-address "" \
  --license-type Windows_Server
