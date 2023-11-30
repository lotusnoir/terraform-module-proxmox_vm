## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.0.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement_proxmox)       | 2.9.14   |

## Providers

No providers.

## Modules

| Name                                                     | Source                            | Version |
| -------------------------------------------------------- | --------------------------------- | ------- |
| <a name="module_debian"></a> [debian](#module_debian)    | ../../terraform-module-proxmox_vm | n/a     |
| <a name="module_vm-ora9"></a> [vm-ora9](#module_vm-ora9) | ../../terraform-module-proxmox_vm | n/a     |

## Resources

No resources.

## Inputs

| Name                                                               | Description | Type     | Default                                 | Required |
| ------------------------------------------------------------------ | ----------- | -------- | --------------------------------------- | :------: |
| <a name="input_pm_api_url"></a> [pm_api_url](#input_pm_api_url)    | n/a         | `string` | `"https://192.168.51.1:8006/api2/json"` |    no    |
| <a name="input_pm_password"></a> [pm_password](#input_pm_password) | n/a         | `string` | `"packer"`                              |    no    |
| <a name="input_pm_user"></a> [pm_user](#input_pm_user)             | n/a         | `string` | `"packer@pve"`                          |    no    |

## Outputs

No outputs.
