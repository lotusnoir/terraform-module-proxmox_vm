resource "proxmox_vm_qemu" "vm_qemu" {
  name                        = var.name
  target_node                 = var.target_node
  target_nodes                = var.target_nodes
  vmid                        = var.vmid
  description                 = var.description
  define_connection_info      = var.define_connection_info
  bios                        = var.bios
  onboot                      = var.onboot
  startup                     = var.startup
  vm_state                    = var.vm_state
  protection                  = var.protection
  tablet                      = var.tablet
  boot                        = var.boot
  bootdisk                    = var.bootdisk
  agent                       = var.agent
  pxe                         = var.pxe
  clone                       = var.clone
  clone_id                    = var.clone_id
  full_clone                  = var.full_clone
  hastate                     = var.hastate
  hagroup                     = var.hagroup
  qemu_os                     = var.qemu_os
  memory                      = var.memory
  balloon                     = var.balloon
  hotplug                     = var.hotplug
  scsihw                      = var.scsihw
  pool                        = var.pool
  tags                        = var.tags
  force_create                = var.force_create
  os_type                     = var.os_type
  force_recreate_on_change_of = var.force_recreate_on_change_of
  os_network_config           = var.os_network_config
  ssh_forward_ip              = var.ssh_forward_ip
  ssh_user                    = var.ssh_user
  ssh_private_key             = var.ssh_private_key

  # for Cloud-init Settings.
  ci_wait                   = var.ci_wait
  ciuser                    = var.ciuser
  cipassword                = var.cipassword
  cicustom                  = var.cicustom
  ciupgrade                 = var.ciupgrade
  searchdomain              = var.searchdomain
  nameserver                = var.nameserver
  sshkeys                   = <<EOF
        ${var.sshkeys}
        EOF
  ipconfig0                 = var.ipconfig0
  ipconfig1                 = var.ipconfig1
  ipconfig2                 = var.ipconfig2
  ipconfig3                 = var.ipconfig3
  ipconfig4                 = var.ipconfig4
  automatic_reboot          = var.automatic_reboot
  automatic_reboot_severity = var.automatic_reboot_severity
  skip_ipv4                 = var.skip_ipv4
  skip_ipv6                 = var.skip_ipv6
  agent_timeout             = var.agent_timeout
  #current_node              = var.current_node

  dynamic "cpu" {
    for_each = var.cpu != null ? [var.cpu] : []
    content {
      affinity = cpu.value.affinity
      cores    = cpu.value.cores
      limit    = cpu.value.limit
      numa     = cpu.value.numa
      sockets  = cpu.value.sockets
      type     = cpu.value.type
      units    = cpu.value.units
      vcores   = cpu.value.vcores
      dynamic "flags" {
        for_each = var.cpu.flags != null ? [var.cpu.flags] : []
        content {
          md_clear    = flags.value.md_clear
          pcid        = flags.value.pcid
          spec_ctrl   = flags.value.spec_ctrl
          ssbd        = flags.value.ssbd
          ibpb        = flags.value.ibpb
          virt_ssbd   = flags.value.virt_ssbd
          amd_ssbd    = flags.value.amd_ssbd
          amd_no_ssb  = flags.value.amd_no_ssb
          pbpe1gb     = flags.value.pbpe1gb
          hv_tlbflush = flags.value.hv_tlbflush
          hv_evmcs    = flags.value.hv_evmcs
          aes         = flags.value.aes
        }
      }
    }
  }

  dynamic "vga" {
    for_each = var.vga != null ? [var.vga] : []
    content {
      type   = vga.value.type
      memory = vga.value.memory
    }
  }

  dynamic "network" {
    for_each = var.network != null ? [var.network] : []
    content {
      id        = network.value.id
      model     = network.value.model
      macaddr   = network.value.macaddr
      bridge    = network.value.bridge
      tag       = network.value.tag
      firewall  = network.value.firewall
      mtu       = network.value.mtu
      rate      = network.value.rate
      queues    = network.value.queues
      link_down = network.value.link_down
    }
  }


  #  disks {
  #    dynamic "ide" {
  #      for_each = var.disks.ide != null ? { var.disks.ide } : {}
  #      content {
  #        "${ide.key}" {
  #          dynamic "cdrom" {
  #            for_each = var.disks.ide != null ? { var.disks.ide } : {}
  #              iso = ide.value.iso
  #          }
  #        }
  #      }
  #    }
  #  }
  #}

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
    for_each = var.serial != null ? [var.serial] : []
    content {
      id   = serial.value.id
      type = serial.value.type
    }
  }

  dynamic "usb" {
    for_each = var.usb != null ? [var.usb] : []
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
