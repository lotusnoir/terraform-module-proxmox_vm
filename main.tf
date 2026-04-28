resource "proxmox_vm_qemu" "vm_qemu" {
  name                        = var.name
  target_node                 = var.target_node
  target_nodes                = var.target_nodes
  vmid                        = var.vmid
  description                 = var.description
  define_connection_info      = var.define_connection_info
  bios                        = var.bios
  start_at_node_boot          = var.start_at_node_boot
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

  disks {
    #############################
    # IDE
    #############################
    ide {
      dynamic "ide0" {
        for_each = try(var.disks.ide.cdrom, null) != null ? [var.disks.ide.cdrom] : []
        content {
          cdrom {
            iso         = ide0.value.iso
            passthrough = ide0.value.passthrough
          }
        }
      }
      dynamic "ide1" {
        for_each = try(var.disks.ide.cloudinit, null) != null ? [var.disks.ide.cloudinit] : []
        content {
          cloudinit {
            storage = ide1.value.storage
          }
        }
      }
    }

    #############################
    # SCSI (multi-disks)
    #############################
    scsi {
      dynamic "scsi0" {
        for_each = try(var.disks.scsi.scsi0, null) != null ? [var.disks.scsi.scsi0] : []
        content {
          dynamic "cdrom" {
            for_each = try(scsi0.value.cdrom, null) != null ? [scsi0.value.cdrom] : []
            content {
              iso         = cdrom.value.iso
              passthrough = cdrom.value.passthrough
            }
          }
          dynamic "cloudinit" {
            for_each = try(scsi0.value.cloudinit, null) != null ? [scsi0.value.cloudinit] : []
            content {
              storage = cloudinit.value.storage
            }
          }
          dynamic "passthrough" {
            for_each = try(scsi0.value.passthrough, null) != null ? [scsi0.value.passthrough] : []
            content {
              asyncio              = passthrough.value.asyncio
              backup               = passthrough.value.backup
              cache                = passthrough.value.cache
              discard              = passthrough.value.discard
              emulatessd           = passthrough.value.emulatessd
              file                 = passthrough.value.file
              iops_r_burst         = passthrough.value.iops_r_burst
              iops_r_burst_length  = passthrough.value.iops_r_burst_length
              iops_r_concurrent    = passthrough.value.iops_r_concurrent
              iops_wr_burst        = passthrough.value.iops_wr_burst
              iops_wr_burst_length = passthrough.value.iops_wr_burst_length
              iops_wr_concurrent   = passthrough.value.iops_wr_concurrent
              iothread             = passthrough.value.iothread
              mbps_r_burst         = passthrough.value.mbps_r_burst
              mbps_r_concurrent    = passthrough.value.mbps_r_concurrent
              mbps_wr_burst        = passthrough.value.mbps_wr_burst
            }
          }
          dynamic "disk" {
            for_each = try(scsi0.value.disk, null) != null ? [scsi0.value.disk] : []
            content {
              asyncio              = disk.value.asyncio
              backup               = disk.value.backup
              cache                = disk.value.cache
              discard              = disk.value.discard
              format               = disk.value.format
              id                   = disk.value.id
              iops_r_burst         = disk.value.iops_r_burst
              iops_r_burst_length  = disk.value.iops_r_burst_length
              iops_r_concurrent    = disk.value.iops_r_concurrent
              iops_wr_burst        = disk.value.iops_wr_burst
              iops_wr_burst_length = disk.value.iops_wr_burst_length
              iops_wr_concurrent   = disk.value.iops_wr_concurrent
              iothread             = disk.value.iothread
              linked_disk_id       = disk.value.linked_disk_id
              mbps_r_burst         = disk.value.mbps_r_burst
              mbps_r_concurrent    = disk.value.mbps_r_concurrent
              mbps_wr_burst        = disk.value.mbps_wr_burst
              mbps_wr_concurrent   = disk.value.mbps_wr_concurrent
              readonly             = disk.value.readonly
              replicate            = disk.value.replicate
              serial               = disk.value.serial
              size                 = disk.value.size
              storage              = disk.value.storage
            }
          }
        }
      }

      dynamic "scsi1" {
        for_each = try(var.disks.scsi.scsi1, null) != null ? [var.disks.scsi.scsi1] : []
        content {
          dynamic "cdrom" {
            for_each = try(scsi1.value.cdrom, null) != null ? [scsi1.value.cdrom] : []
            content {
              iso         = cdrom.value.iso
              passthrough = cdrom.value.passthrough
            }
          }
          dynamic "cloudinit" {
            for_each = try(scsi1.value.cloudinit, null) != null ? [scsi1.value.cloudinit] : []
            content {
              storage = cloudinit.value.storage
            }
          }
          dynamic "passthrough" {
            for_each = try(scsi1.value.passthrough, null) != null ? [scsi1.value.passthrough] : []
            content {
              asyncio              = passthrough.value.asyncio
              backup               = passthrough.value.backup
              cache                = passthrough.value.cache
              discard              = passthrough.value.discard
              emulatessd           = passthrough.value.emulatessd
              file                 = passthrough.value.file
              iops_r_burst         = passthrough.value.iops_r_burst
              iops_r_burst_length  = passthrough.value.iops_r_burst_length
              iops_r_concurrent    = passthrough.value.iops_r_concurrent
              iops_wr_burst        = passthrough.value.iops_wr_burst
              iops_wr_burst_length = passthrough.value.iops_wr_burst_length
              iops_wr_concurrent   = passthrough.value.iops_wr_concurrent
              iothread             = passthrough.value.iothread
              mbps_r_burst         = passthrough.value.mbps_r_burst
              mbps_r_concurrent    = passthrough.value.mbps_r_concurrent
              mbps_wr_burst        = passthrough.value.mbps_wr_burst
            }
          }
          dynamic "disk" {
            for_each = try(scsi1.value.disk, null) != null ? [scsi1.value.disk] : []
            content {
              asyncio              = disk.value.asyncio
              backup               = disk.value.backup
              cache                = disk.value.cache
              discard              = disk.value.discard
              format               = disk.value.format
              id                   = disk.value.id
              iops_r_burst         = disk.value.iops_r_burst
              iops_r_burst_length  = disk.value.iops_r_burst_length
              iops_r_concurrent    = disk.value.iops_r_concurrent
              iops_wr_burst        = disk.value.iops_wr_burst
              iops_wr_burst_length = disk.value.iops_wr_burst_length
              iops_wr_concurrent   = disk.value.iops_wr_concurrent
              iothread             = disk.value.iothread
              linked_disk_id       = disk.value.linked_disk_id
              mbps_r_burst         = disk.value.mbps_r_burst
              mbps_r_concurrent    = disk.value.mbps_r_concurrent
              mbps_wr_burst        = disk.value.mbps_wr_burst
              mbps_wr_concurrent   = disk.value.mbps_wr_concurrent
              readonly             = disk.value.readonly
              replicate            = disk.value.replicate
              serial               = disk.value.serial
              size                 = disk.value.size
              storage              = disk.value.storage
            }
          }
        }
      }
    }


    #############################
    # VIRTIO (multi-disks)
    #############################
    #virtio {
    #  dynamic "virtio0" {
    #    for_each = length(var.disks.virtio) > 0 ? [var.disks.virtio[0]] : []
    #    content {
    #      disk {
    #        asyncio              = virtio0.value.asyncio
    #        backup               = virtio0.value.backup
    #        cache                = virtio0.value.cache
    #        discard              = virtio0.value.discard
    #        format               = virtio0.value.format
    #        id                   = virtio0.value.id
    #        iops_r_burst         = virtio0.value.iops_r_burst
    #        iops_r_burst_length  = virtio0.value.iops_r_burst_length
    #        iops_r_concurrent    = virtio0.value.iops_r_concurrent
    #        iops_wr_burst        = virtio0.value.iops_wr_burst
    #        iops_wr_burst_length = virtio0.value.iops_wr_burst_length
    #        iops_wr_concurrent   = virtio0.value.iops_wr_concurrent
    #        iothread             = virtio0.value.iothread
    #        linked_disk_id       = virtio0.value.linked_disk_id
    #        mbps_r_burst         = virtio0.value.mbps_r_burst
    #        mbps_r_concurrent    = virtio0.value.mbps_r_concurrent
    #        mbps_wr_burst        = virtio0.value.mbps_wr_burst
    #        mbps_wr_concurrent   = virtio0.value.mbps_wr_concurrent
    #        readonly             = virtio0.value.readonly
    #        replicate            = virtio0.value.replicate
    #        serial               = virtio0.value.serial
    #        size                 = virtio0.value.size
    #        storage              = virtio0.value.storage
    #      }
    #    }
    #  }

    #  # virtio1
    #  dynamic "virtio1" {
    #    for_each = length(var.disks.virtio) > 1 ? [var.disks.virtio[1]] : []
    #    content {
    #      disk {
    #        asyncio              = virtio1.value.asyncio
    #        backup               = virtio1.value.backup
    #        cache                = virtio1.value.cache
    #        discard              = virtio1.value.discard
    #        format               = virtio1.value.format
    #        id                   = virtio1.value.id
    #        iops_r_burst         = virtio1.value.iops_r_burst
    #        iops_r_burst_length  = virtio1.value.iops_r_burst_length
    #        iops_r_concurrent    = virtio1.value.iops_r_concurrent
    #        iops_wr_burst        = virtio1.value.iops_wr_burst
    #        iops_wr_burst_length = virtio1.value.iops_wr_burst_length
    #        iops_wr_concurrent   = virtio1.value.iops_wr_concurrent
    #        iothread             = virtio1.value.iothread
    #        linked_disk_id       = virtio1.value.linked_disk_id
    #        mbps_r_burst         = virtio1.value.mbps_r_burst
    #        mbps_r_concurrent    = virtio1.value.mbps_r_concurrent
    #        mbps_wr_burst        = virtio1.value.mbps_wr_burst
    #        mbps_wr_concurrent   = virtio1.value.mbps_wr_concurrent
    #        readonly             = virtio1.value.readonly
    #        replicate            = virtio1.value.replicate
    #        serial               = virtio1.value.serial
    #        size                 = virtio1.value.size
    #        storage              = virtio1.value.storage
    #      }
    #    }
    #  }

    #  # virtio2
    #  dynamic "virtio2" {
    #    for_each = length(var.disks.virtio) > 2 ? [var.disks.virtio[2]] : []
    #    content {
    #      disk {
    #        asyncio              = virtio2.value.asyncio
    #        backup               = virtio2.value.backup
    #        cache                = virtio2.value.cache
    #        discard              = virtio2.value.discard
    #        format               = virtio2.value.format
    #        id                   = virtio2.value.id
    #        iops_r_burst         = virtio2.value.iops_r_burst
    #        iops_r_burst_length  = virtio2.value.iops_r_burst_length
    #        iops_r_concurrent    = virtio2.value.iops_r_concurrent
    #        iops_wr_burst        = virtio2.value.iops_wr_burst
    #        iops_wr_burst_length = virtio2.value.iops_wr_burst_length
    #        iops_wr_concurrent   = virtio2.value.iops_wr_concurrent
    #        iothread             = virtio2.value.iothread
    #        linked_disk_id       = virtio2.value.linked_disk_id
    #        mbps_r_burst         = virtio2.value.mbps_r_burst
    #        mbps_r_concurrent    = virtio2.value.mbps_r_concurrent
    #        mbps_wr_burst        = virtio2.value.mbps_wr_burst
    #        mbps_wr_concurrent   = virtio2.value.mbps_wr_concurrent
    #        readonly             = virtio2.value.readonly
    #        replicate            = virtio2.value.replicate
    #        serial               = virtio2.value.serial
    #        size                 = virtio2.value.size
    #        storage              = virtio2.value.storage
    #      }
    #    }
    #  }

    #}
  }

  dynamic "efidisk" {
    for_each = var.efidisk != null ? [var.efidisk] : []
    content {
      pre_enrolled_keys = efidisk.value.pre_enrolled_keys
      efitype           = efidisk.value.efitype
      storage           = efidisk.value.storage
    }
  }


  dynamic "serial" {
    for_each = var.serial != null ? [var.serial] : []
    content {
      id   = serial.value.id
      type = serial.value.type
    }
  }


  dynamic "tpm_state" {
    for_each = var.tpm_state != null ? [var.tpm_state] : []
    content {
      storage = tpm_state.value.storage
      version = tpm_state.value.version
    }
  }


  dynamic "usb" {
    for_each = var.usb != null ? [var.usb] : []
    content {
      id         = usb.value.id
      device_id  = usb.value.device_id
      mapping_id = usb.value.mapping_id
      port_id    = usb.value.port_id
      usb3       = usb.value.usb3
    }
  }

  dynamic "startup_shutdown" {
    for_each = var.startup_shutdown != null ? [var.startup_shutdown] : []
    content {
      order            = startup_shutdown.value.order
      shutdown_timeout = startup_shutdown.value.shutdown_timeout
      startup_delay    = startup_shutdown.value.startup_delay
    }
  }


  # these may need to be adjusted
  lifecycle {
    ignore_changes = [network, ciuser, tags, description]
    // ignore_changes  = [network,disk,ciuser]
    //create_before_destroy = false
    //prevent_destroy = false
  }
}
