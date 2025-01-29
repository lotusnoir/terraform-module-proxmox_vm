resource "proxmox_vm_qemu" "vm_qemu" {

  name                   = var.name
  target_node            = var.target_node
  vmid                   = var.vmid
  desc                   = var.description
  define_connection_info = var.define_connection_info

  bios     = var.bios
  onboot   = var.onboot
  vm_state = var.vm_state
  tablet   = var.tablet
  boot     = var.boot
  bootdisk = var.bootdisk

  agent      = var.agent
  pxe        = var.pxe
  clone      = var.clone
  full_clone = var.full_clone

  hastate = var.hastate
  hagroup = var.hagroup
  qemu_os = var.qemu_os

  memory  = var.memory
  balloon = var.balloon

  sockets = var.sockets
  cores   = var.cores
  vcpus   = var.vcpus
  cpu     = var.cpu_type

  numa    = var.numa
  kvm     = var.kvm
  hotplug = var.hotplug
  scsihw  = var.scsihw

  pool                        = var.pool
  tags                        = var.tags
  force_create                = var.force_create
  os_type                     = var.os_type
  force_recreate_on_change_of = var.force_recreate_on_change_of
  os_network_config           = var.os_network_config

  ssh_forward_ip  = var.ssh_forward_ip
  ssh_user        = var.ssh_user
  ssh_private_key = var.ssh_private_key

  # for Cloud-init Settings.
  ci_wait          = var.ci_wait
  ciuser           = var.ciuser
  cipassword       = var.cipassword
  cicustom         = var.cicustom
  searchdomain     = var.searchdomain
  nameserver       = var.nameserver
  sshkeys          = <<EOF
        ${var.sshkeys}
        EOF
  ipconfig0        = var.ipconfig0
  ipconfig1        = var.ipconfig1
  ipconfig2        = var.ipconfig2
  ipconfig3        = var.ipconfig3
  ipconfig4        = var.ipconfig4
  automatic_reboot = var.automatic_reboot


  dynamic "vga" {
    for_each = var.vga == null ? [] : list(var.vga)
    content {
      type   = vga.value.type
      memory = vga.value.memory
    }
  }

  dynamic "network" {
    for_each = local.vm_network
    content {
      id        = lookup(network.value, "id", local.vm_network_default_id)
      model     = lookup(network.value, "model", local.vm_network_default_model)
      macaddr   = lookup(network.value, "macaddr", local.vm_network_default_macaddr)
      bridge    = lookup(network.value, "bridge", local.vm_network_default_bridge)
      tag       = lookup(network.value, "tag", local.vm_network_default_tag)
      firewall  = lookup(network.value, "firewall", local.vm_network_default_firewall)
      rate      = lookup(network.value, "rate", local.vm_network_default_rate)
      queues    = lookup(network.value, "queues", local.vm_network_default_queues)
      link_down = lookup(network.value, "link_down", local.vm_network_default_link_down)
    }
  }

  disks {
    ide {
      ide0 {
        cdrom {
          iso = var.iso
        }
      }
      ide1 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = "local-lvm"
          size    = "10G"
        }
      }
    }
  }


  #dynamic "disks" {
  #  for_each = var.vm_disks
  #  content {

  #    dynamic "ide" {
  #      for_each = disks.value.disk == "virtio" ? disks.value : {}
  #      content {

  #      }
  #      }
  #    dynamic "virtio" {
  #      for_each = disks.value.disk == "virtio" ? disks.value : {}
  #      content {
  #        type         = d
  #        storage      =
  #        size         =
  #        format       =
  #        cache        =
  #        backup       =
  #        iothread     =
  #        replicate    =
  #        ssd          =
  #        discard      =
  #        mbps         =
  #        mbps_rd      =
  #        mbps_rd_max  =
  #        mbps_wr      =
  #        mbps_wr_max  =
  #        file         =
  #        media        =
  #        volume       =
  #        storage_type =
  #      }
  #    }
  #  }
  #}

  dynamic "serial" {
    for_each = var.serial == null ? [] : list(var.serial)
    content {
      id   = serial.value.id
      type = serial.value.type
    }
  }

  dynamic "usb" {
    for_each = var.usb == null ? [] : list(var.usb)
    content {
      id   = usb.value.id
      host = usb.value.host
      usb3 = usb.value.usb3
    }
  }

  # these may need to be adjusted
  lifecycle {
    ignore_changes = [network, ciuser, tags]
    // ignore_changes  = [network,disk,ciuser]
    //create_before_destroy = false
    //prevent_destroy = false
  }

}
