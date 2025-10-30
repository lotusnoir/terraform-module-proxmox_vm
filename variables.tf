variable "name" {
  description = "Required - The name of the VM within Proxmox."
  type        = string
}

variable "target_node" {
  description = "The name of the Proxmox Node on which to place the VM."
  type        = string
  default     = null
}

variable "target_nodes" {
  description = "A list of PVE node names on which to place the VM."
  type        = set(string)
  default     = null
}

variable "vmid" {
  description = "The ID of the VM in Proxmox. The default value of 0 indicates it should use the next available ID in the sequence"
  type        = number
  default     = 0
}

variable "description" {
  description = "Description of the VM"
  type        = string
  default     = null
}

variable "define_connection_info" {
  description = "Whether to let terraform define the (SSH) connection parameters for preprovisioners. Defaults to true"
  type        = bool
  default     = true
}

variable "bios" {
  description = "The BIOS to use, options are seabios or ovmf for UEFI. Defaults to seabios"
  type        = string
  default     = "seabios"
}

variable "onboot" {
  description = "Whether to have the VM startup after the PVE node starts. Defaults to false"
  type        = bool
  default     = false
}

variable "startup" {
  description = "The startup and shutdown behaviour"
  type        = string
  default     = null
}

variable "vm_state" {
  description = "The desired state of the VM, options are running, stopped and started. Do note that started will only start the vm on creation and won't fully manage the power state unlike running and stopped do."
  type        = string
  default     = "running"
}

### Deprecated
#variable "oncreate" {
#  description = "Whether to have the VM startup after the VM is created (deprecated, use vm_state instead)"
#  type        = bool
#  default     = true
#}

variable "protection" {
  description = "Enable/disable the VM protection from being removed. The default value of false indicates the VM is removable."
  type        = bool
  default     = false
}

variable "tablet" {
  description = "Enable/disable the USB tablet device. This device is usually needed to allow absolute mouse positioning with VNC. Defaults to true"
  type        = bool
  default     = true
}

variable "boot" {
  description = "The boot order for the VM.  Options: floppy (a), hard disk (c), CD-ROM (d), or network (n). Defaults to cdn"
  type        = string
  default     = null
}

variable "bootdisk" {
  description = "Enable booting from specified disk."
  type        = string
  default     = null
}

variable "agent" {
  description = "Set to 1 to enable the QEMU Guest Agent. Note, you must run the qemu-guest-agent daemon in the guest for this to have any effect."
  type        = number
  default     = 0
}

variable "pxe" {
  description = "If set to true, enable PXE boot of the VM. Also requires a boot order be set with Network included (eg boot = 'order=scsi0;net0'). Note that pxe is mutually exclusive with clone modes."
  type        = bool
  default     = null
}

variable "clone" {
  description = "The base VM name from which to clone to create the new VM. Note that clone is mutually exclusive with clone_id and pxe modes."
  type        = string
  default     = null
  validation {
    condition     = (var.pxe == null && var.clone != null)
    error_message = "You cannot set both clone and pxe at the same time."
  }
}

variable "clone_id" {
  description = "The base VM id from which to clone to create the new VM. Note that clone_id is mutually exclusive with clone and pxe modes."
  type        = number
  default     = null
}

variable "full_clone" {
  description = "Set to true to create a full clone, or false to create a linked clone. Only applies when clone is set"
  type        = bool
  default     = true
}

variable "hastate" {
  description = "Requested HA state for the resource. One of started, stopped, enabled, disabled, or ignored"
  type        = string
  default     = null
}

variable "hagroup" {
  description = "The HA group identifier the resource belongs to (requires hastate to be set!)"
  type        = string
  default     = null
}

variable "qemu_os" {
  description = "The type of OS in the guest. Set properly to allow Proxmox to enable optimizations for the appropriate guest OS. Defaults to l26"
  type        = string
  default     = "other"
}

variable "memory" {
  description = "The amount of memory to allocate to the VM in Megabytes. Defaults to 512"
  type        = number
  default     = 512
}

variable "balloon" {
  description = "The minimum amount of memory to allocate to the VM in Megabytes, when Automatic Memory Allocation is desired. Defaults to 0"
  type        = number
  default     = 0
}

variable "hotplug" {
  description = "Comma delimited list of hotplug features to enable. Options: network, disk, cpu, memory, usb. Set to 0 to disable hotplug. Defaults to network,disk,usb"
  type        = string
  default     = "network,disk,usb"
}

variable "scsihw" {
  description = "The SCSI controller to emulate. Options: lsi, lsi53c810, megasas, pvscsi, virtio-scsi-pci, virtio-scsi-single. Defaults to lsi"
  type        = string
  default     = "lsi"
}

variable "pool" {
  description = "The resource pool to which the VM will be added. Optional"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags of the VM. This is only meta information. Optional"
  type        = string
  default     = ""
}

#variable "rng" {
#  description = "The RNG device to add to the VM, more info in RNG Block section"
#  type        = string
#  default     = ""
#}
#
#variable "tpm_state" {
#  description = "The TPM device to add to the VM, more info in TPM Block section"
#  type        = string
#  default     = ""
#}

variable "force_create" {
  description = "If false, and a vm of the same name, on the same node exists, terraform will attempt to reconfigure that VM with these settings. Set to true to always create a new VM. Defaults to true"
  type        = string
  default     = false
}

variable "os_type" {
  description = "Which provisioning method to use, based on the OS type. Possible values: ubuntu, centos, cloud-init."
  type        = string
  default     = null
}

# An example where this is useful is a cloudinit configuration (as the cicustom attribute points to a file not the content).
variable "force_recreate_on_change_of" {
  description = "If the value of this string changes, the VM will be recreated. Useful for allowing this resource to be recreated when arbitrary attributes change"
  type        = string
  default     = null
}

# os_network_config
variable "os_network_config" {
  description = "Only applies when define_connection_info is true."
  type        = string
  default     = null
}

variable "ssh_forward_ip" {
  description = "Only applies when define_connection_info is true. The IP (and optional colon separated port), to use to connect to the host for preprovisioning. If using cloud-init, this can be left blank"
  type        = string
  default     = null
}

variable "ssh_user" {
  description = "Only applies when define_connection_info is true. The user with which to connect to the guest for preprovisioning. Forces re-creation on change"
  type        = string
  default     = null
}

variable "ssh_private_key" {
  description = "Only applies when define_connection_info is true. The private key to use when connecting to the guest for preprovisioning. Sensitive"
  type        = string
  default     = null
}

################################
# Cloud Init Specific
################################
variable "ci_wait" {
  description = "How to long in seconds to wait for before provisioning. Defaults to 30"
  type        = number
  default     = 30
}

variable "ciuser" {
  description = "Override the default cloud-init user for provisioning"
  type        = string
  default     = null
}

variable "cipassword" {
  description = "Override the default cloud-init user's password. Sensitive"
  type        = string
  default     = null
}

variable "cicustom" {
  description = "Instead specifying ciuser, cipasword, etc... you can specify the path to a custom cloud-init config file here. Grants more flexibility in configuring cloud-init"
  type        = string
  default     = null
}

variable "ciupgrade" {
  description = "Whether to upgrade the packages on the guest during provisioning. Restarts the VM when set to true"
  type        = bool
  default     = false
}

variable "searchdomain" {
  description = "Sets default DNS search domain suffix."
  type        = string
  default     = null
}

variable "nameserver" {
  description = "Sets default DNS server for guest"
  type        = string
  default     = null
}

variable "sshkeys" {
  description = "Newline delimited list of SSH public keys to add to authorized keys file for the cloud-init user"
  type        = string
  default     = ""
}

variable "ipconfig0" {
  description = "The first IP address to assign to the guest. Format: [gw=<GatewayIPv4>] [,gw6=<GatewayIPv6>] [,ip=<IPv4Format/CIDR>] [,ip6=<IPv6Format/CIDR>]"
  type        = string
  default     = null
}
variable "ipconfig1" {
  description = "The second IP address to assign to the guest. Same format as ipconfig0"
  type        = string
  default     = null
}
variable "ipconfig2" {
  description = "The third IP address to assign to the guest. Same format as ipconfig0"
  type        = string
  default     = null
}
variable "ipconfig3" {
  description = "The fouth IP address to assign to the guest. Same format as ipconfig0"
  type        = string
  default     = null
}
variable "ipconfig4" {
  description = "The fifth IP address to assign to the guest. Same format as ipconfig0"
  type        = string
  default     = null
}

variable "automatic_reboot" {
  description = "Automatically reboot the VM when parameter changes require this. If disabled the provider will emit a warning when the VM needs to be rebooted."
  type        = bool
  default     = true
}

variable "automatic_reboot_severity" {
  description = "Sets the severity of the error/warning when automatic_reboot is false. Values can be error or warning."
  type        = string
  default     = "error"
}

variable "skip_ipv4" {
  description = "Tells proxmox that acquiring an IPv4 address from the qemu guest agent isn't required, it will still return an ipv4 address if it could obtain one. Useful for reducing retries in environments withou"
  type        = bool
  default     = null
}

variable "skip_ipv6" {
  description = "Tells proxmox that acquiring an IPv6 address from the qemu guest agent isn't required, it will still return an ipv6 address if it could obtain one. Useful for reducing retries in environments without ipv6."
  type        = bool
  default     = null
}

variable "agent_timeout" {
  description = "Timeout in seconds to keep trying to obtain an IP address from the guest agent one we have a connection."
  type        = number
  default     = 90
}

### Computed
#variable "current_node" {
#  description = "Computed The current node of the Qemu guest is on."
#  type        = string
#  default     = null
#}

######################################
variable "cpu" {
  description = "The cpu block is used to configure the cpu."
  type = object({
    affinity = optional(string)
    cores    = number
    limit    = number
    numa     = bool
    sockets  = number
    type     = string
    units    = number
    vcores   = number
    flags = optional(object({
      md_clear    = optional(string)
      pcid        = optional(string)
      spec_ctrl   = optional(string)
      ssbd        = optional(string)
      ibpb        = optional(string)
      virt_ssbd   = optional(string)
      amd_ssbd    = optional(string)
      amd_no_ssb  = optional(string)
      pbpe1gb     = optional(string)
      hv_tlbflush = optional(string)
      hv_evmcs    = optional(string)
      aes         = optional(string)
    }))
  })
  default = {
    cores   = 1
    limit   = 0
    numa    = false
    sockets = 1
    type    = "host"
    units   = 0
    vcores  = 0
  }
}

variable "vga" {
  description = "The vga block is used to configure the display device."
  type = object({
    type   = optional(string)
    memory = optional(number)
  })
  default = null
}

variable "network" {
  description = "The network block is used to configure the network."
  type = object({
    id        = optional(number)
    model     = optional(string)
    macaddr   = optional(string)
    bridge    = optional(string)
    tag       = optional(number)
    firewall  = optional(bool)
    mtu       = optional(number)
    rate      = optional(number)
    queues    = optional(number)
    link_down = optional(bool)
  })
  default = null
}

### temporary
variable "iso" {
  description = "The name of the ISO image to mount to the VM. Either clone or iso needs to be set"
  type        = string
  default     = null
}

#variable "disks" {
#  description = "Disk configuration for the VM"
#  type = object({
#    ide = map(optional(object({
#        cdrom = optional(object({
#          iso = string
#	   passthrough = bool
#        }))
#      })))
#    sata = map(optional(object({
#        cdrom = optional(object({
#          iso = string
#	   passthrough = bool
#        }))
#      })))
#    scsi = map(optional(object({
#        cdrom = optional(object({
#          iso = string
#        }))
#      })))
#    virtio = map(optional(object({
#        disk = optional(object({
#          storage = string
#          size    = string
#        }))
#      })))
#    })
#  }

#variable "disk" {
#  description = "The disk block is used to configure the disk devices. It may be specified multiple times. This block does not diff as pretty as the disks block, but it is more flexible for modules. Putting the disks in alphanumeric order based on the value of slot is recommended for readability."
#  type = map(object({
#
#    asyncio              = optional(string)
#    backup               = optional(bool)
#    cache                = optional(string)
#    discard              = optional(bool)
#    disk_file            = optional(string)
#    emulatessd           = optional(bool)
#    format               = optional(string)
#    id                   = optional(number)
#    iops_r_burst         = optional(number)
#    iops_r_burst_length  = optional(number)
#    iops_r_concurrent    = optional(number)
#    iops_wr_burst        = optional(number)
#    iops_wr_burst_length = optional(number)
#    iops_wr_concurrent   = optional(number)
#    iothread             = optional(bool)
#    iso                  = optional(string)
#    linked_disk_id       = optional(number)
#    mbps_r_burst         = optional(number)
#    mbps_r_concurrent    = optional(number)
#    mbps_wr_burst        = optional(number)
#    mbps_wr_concurrent   = optional(number)
#    passthrough          = optional(bool)
#    readonly             = optional(bool)
#    replicate            = optional(bool)
#    serial               = optional(string)
#    size                 = optional(string)
#    slot                 = optional(string)
#    storage              = optional(string)
#    type                 = optional(string)
#    wwn                  = optional(string)
#  })
#  default = null
#}

variable "serial" {
  description = "Create a serial device inside the VM (up to a maximum of 4 can be specified)"
  type = object({
    id   = string
    type = string
  })
  default = null
}

variable "usb" {
  description = "The usb block is used to configure USB devices."
  type = object({
    host = string
    usb3 = bool
  })
  default = null
}


# lifecycle variables - currently not in use
// variable "ignore_changes" {
//   description = "When Enabled creates a new VM before destroying. Defaults to false"
//   type        = list(any)
//   default     = []
// }

// variable "create_before_destroy" {
//   description = "When Enabled creates a new VM before destroying. Defaults to false"
//   type        = bool
//   default     = false
// }

// variable "prevent_destroy" {
//   description = "When Enabled prevents destroying the VM. Defaults to false"
//   type        = bool
//   default     = false
// }
