#  disks {
#    ide {
#      ide0 {
#        cdrom {
#          iso = var.iso
#        }
#      }
#      ide1 {
#        cloudinit {
#          storage = "local-lvm"
#        }
#      }
#    }
#    virtio {
#      virtio0 {
#        disk {
#          storage = "local-lvm"
#          size    = "10G"
#        }
#      }
#    }
#  }
#
#
#variable "vm_disks" {
#  type = map(object({
#    ide = optional(list(string))
#      index = number
#      type = string
