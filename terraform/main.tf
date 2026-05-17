terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6" 
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "vm_storage" {
  name = "rhcsa_pool"
  type = "dir"
  path = "/var/lib/libvirt/images/rhcsa-lab"
}

# resource "libvirt_network" "lab_network" {
#   name        = "default"
#   mode        = "nat"
#   addresses   = ["192.168.124.0/24"]
#   autostart   = true
#
#   dns {
#     enabled = true
#   }
# }

resource "libvirt_volume" "base_image" {
  name   = "rhel-base.qcow2"
  pool   = libvirt_pool.vm_storage.name
  source = var.base_image
  format = "qcow2"
}

resource "libvirt_volume" "rhel_disk" {
  count  = var.vm_count
  name   = "${var.node_prefix}-${count.index + 1}.qcow2"
  pool   = libvirt_pool.vm_storage.name
  base_volume_id = libvirt_volume.base_image.id 
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
  meta_data = templatefile("${path.module}/cloud-init/meta-data", {
    instance_id = "${var.node_prefix}-${count.index + 1}"
    hostname    = "${var.node_prefix}-${count.index + 1}"
  })
}

resource "libvirt_domain" "rhel_node" {
  count  = var.vm_count
  name   = "${var.node_prefix}-${count.index + 1}"

  # machine = "q35"

  cpu {
    mode = "host-passthrough"
  }

  memory = var.vm_memory
  vcpu   = var.vm_cpu

  disk {
    volume_id = libvirt_volume.rhel_disk[count.index].id
    scsi      = false
  }

  network_interface {
    network_name     = "default"
    # wait_for_lease = true
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  cloudinit = libvirt_cloudinit_disk.cloud_init[count.index].id
} 
