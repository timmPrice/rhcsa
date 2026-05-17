this is my collection of practice lab materials I used while studying for an RHCSA

lab environment is built and destroyed using [terraform↗](https://developer.hashicorp.com/terraform)

## Setup
You will need to provide a guest-image for rhel 10
- place a guest-image ".qcow2" rhel image in a ./images directory
- after cloning this repo > `mkdir ./images` > `cp ~/path/to/a_rhel.qcow ./images` 
- An installation version of Terraform will likely need to change based on system specs and available versions

verify enviornment is ready for VMs.. note this needs to be modified based on machine and OS types
```
./setup
```
initialize and apply terraform
```
cd ./terraform
terraform init
terraform apply
```
check the status of the created kvm machines
```
sudo virsh list --all
sudo virsh net-dhcp-leases default
# -- and/or --
sudo virt-manager
```
