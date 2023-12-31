module "debian" {
  source = "../../terraform-module-proxmox_vm"

  name = "test-vm-2"

  target_node = "geekom"
  #vmid        = "7000"
  description = "TEST Server"

  agent   = 1
  clone   = "template-linux-debian-12"
  sockets = "1"
  cores   = 2
  memory  = 2048
  tags    = "aa;bb"

  # Cloud init specific
  sshkeys      = "ssh-ed25519 AAAAC3NzaC1lZxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  nameserver   = "1.1.1.1"
  searchdomain = "example.com"
  ipconfig0    = "ip=192.168.49.150/22,gw=192.168.48.1"

  scsihw = "virtio-scsi-pci"
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
