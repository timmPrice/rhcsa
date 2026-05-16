terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6" 
    }
  }
}

provider "libvirt" {
  uri = "qemu:///session"
}

resource "libvirt_pool" "vm_storage" {
  name = "rhcsa_pool"
  type = "dir"
  path = "/var/lib/libvirt/images/rhcsa-lab"
}

resource "libvirt_network" "lab_network" {
  name      = "rhcsa_network"
  mode      = "nat"
  addresses = ["192.168.100.0/24"]
  autostart = true
}

resource "libvirt_volume" "rhel_disk" {
  count  = var.vm_count
  name   = "${var.node_prefix}-${count.index + 1}.qcow2"
  pool   = libvirt_pool.vm_storage.name
  source = var.base_image
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloud_init" {
  count     = var.vm_count
  name      = "${var.node_prefix}-${count.index + 1}-cloud_init.iso"
  pool      = libvirt_pool.vm_storage.name
  user_data = templatefile("${path.module}/cloud-init/user-data", {
    hostname      = "${var.node_prefix}-${count.index + 1}"
    user_password = "redhat"
  })
}

resource "libvirt_domain" "rhel_node" {
  count  = var.vm_count
  name   = "${var.node_prefix}-${count.index + 1}"
  memory = var.vm_memory
  vcpu   = var.vm_cpu

  disk {
    volume_id = libvirt_volume.rhel_disk[count.index].id
  }

  network_interface {
    network_id     = libvirt_network.lab_network.id 
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.cloud_init[count.index].id
} 
