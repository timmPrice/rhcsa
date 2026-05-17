this is my collection of practice lab materials I used while studying for an RHCSA

lab environment is built and destroyed using [terraform↗](https://developer.hashicorp.com/terraform)

## Setup
place a guest-image ".qcow2" rhel image in a ./images directory
Installation version of Terraform will likely need to change based on system specs

verify enviornment is ready for VMs
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
