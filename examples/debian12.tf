module "debian" {
  source = "../../terraform-module-proxmox_vm"

  name = "test-vm-2"

  target_node = "geekom"
  #vmid        = "7000"
  description = "TEST Server"
  agent       = 1
  clone       = "template-linux-debian-12"
  memory      = 2048
  sockets     = "1"
  cores       = 2
  tags        = "aa;bb"
  scsihw      = "virtio-scsi-pci"
  vm_disk = [
    {
      type    = "virtio"
      storage = "local-lvm"
      size    = "10G"
    }
    #{
    #  type         = "virtio"
    #  storage      = "local-lvm"
    #  size         = "15G"
    #}
  ]
  vm_network = [
    {
      model  = "virtio"
      bridge = "vmbr0"
    },
  ]
}
