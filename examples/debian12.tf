module "debian" {
  source = "../../terraform-module-proxmox_vm"

  name        = "test-vm-2"

  target_node = "geekom"
  #vmid        = "7000"
  description  = "TEST Server"
  agent      = 1
  clone       = "template-linux-debian-12"
  os_type = "l26"
  memory     = 2048
  sockets    = "1"
  cores      = 2
  tags = "aa;bb"
  bootdisk  = "virtio0"
  scsihw     = "virtio-scsi-pci"
  vm_disk = [
    {
      type         = "scsi"
      storage      = "local-lvm"
      size         = "10G"
      format       = "raw"
    }
    #{
    #  type         = "virtio0"
    #  storage      = "local-lvm"
    #  size         = "15G"
    #  format       = "raw"
    #}
  ]
  vm_network = [
     {
      id        = 0
      model     = "virtio"
      bridge    = "vmbr0"
    },
  ]
}
