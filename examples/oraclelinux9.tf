module "vm-ora9" {
  source = "../../terraform-module-proxmox_vm"

  name        = "vm-ora9-1"

  target_node = "geekom"
  #vmid        = "7000"
  description  = "TEST Server"
  agent      = 1
  clone       = "template-linux-oraclelinux-9"
  memory     = 2048
  sockets    = "1"
  cores      = 2
  tags = "aa;bb"

  # Cloud init specific
  sshkeys      = "ssh-ed25519 AAAAC3NzaC1lZxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  nameserver   = "1.1.1.1"
  searchdomain = "example.com"
  ipconfig0 = "ip=192.168.49.150/22,gw=192.168.49.1"

  scsihw     = "virtio-scsi-pci"
  vm_disk = [
    {
      type         = "virtio"
      storage      = "local-lvm"
      size         = "10G"
    }
  ]
  vm_network = [
     {
      model     = "virtio"
      bridge    = "vmbr0"
    },
  ]
}
