terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

provider "proxmox" {
  # Configuration options
  pm_api_url    = var.proxmox_api_url
  pm_api_tok_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true

}

resource "proxmox_vm_qemu" "vm" {
    vmid    = 100
    name    = "demo-vm"
    target_node = "pve3"

    clone   = "ubuntu-jammy"
    full_clone  = true

    os_type = "cloud-init"
    cloudinit_cdrom_storage = "local-lvm"
    
    ciuser = var.ci_user
    cipassword = var.ci_password
    sshkeys = file(var.ci_ssh_public_key)

    cores = 1
    memory = 1024
    agent = 1

    bootdisk = "scsi0"
    scsihw = "virtio-scsi-pci"
    ipconfig0 = "ip=dhcp"

    disks {
      size = "10G"
      type = "scsi"
      storage = "local-lvm"
    }
    network {
      model = "virtio"
      bridge = "vmbr0"
    }
 lifecycle {
   ignore_changes = [ 
    network
    ]
 }
}

