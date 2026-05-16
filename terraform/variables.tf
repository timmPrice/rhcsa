variable "vm_count" {
  description= "number of VMs to be created for RHCSA lab"
  type       = number
  default    = 2
}

variable "vm_memory" {
  description= "amount of ram assigned to each VM in megabytes"
  type       = number
  default    = 2048 
}

variable "vm_cpu" {
  description= "number of vCPUs assigned to each VM"
  type       = number
  default    = 2 
}

variable "base_image" {
  description= "path to rhel guest image"
  type       = string
  default    = "../images/rhel-10.1-x86_64-kvm.qcow2"
}

variable "node_prefix" {
  description= "name of each VM node e.g. rhel-node-1, rhel-node-2 etc."
  type       = string
  default    = "rhel-node" 
}
