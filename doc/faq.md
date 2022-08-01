# Frequently Asked Questions

- [How much does it cost?](#how-much-does-it-cost)
- [Who can access my lab?](#who-can-access-my-lab)
- [Why not use packer?](#why-not-use-packer)
- [X is insecure!](#x-is-insecure)
- [How to change the name of the resource group in which resources are created?](#how-to-change-the-name-of-the-resource-group-in-which-resources-are-created)

## How much does it cost?

TBC...

The cost is not negligible if you leave the lab run continuously. It is mostly induced by the virtual machines, so you can reduce it by spinning up only 1 workstation. You cannot play on the storage costs because they are enforced by the VM type and the base image.

## Who can access my lab?

By default, only your public outgoing IP (as returned by canihazip.com) is allowed to access your lab. This is configured on the Network Security Groups attached to VM interfaces.

Make sure your IP didn't change compared to when you last ran `terraform apply`. If it did change, just run `terraform apply` and the whitelisted IP will be automatically updated for you.

## X is insecure!

Some of the components of this lab are not optimally secure: WinRM over HTTP, all machines have a public IP (although restricted to your outgoing IP), a local administrator account with the same password is created on every workstations, etc. The lab isn't hardened because it is, well, *a lab*.

If you stumble across something which looks *too* insecure, feel free to open an issue.

## How to change the name of the resource group in which resources are created?

The Azure dynamic inventory plugin for Ansible unfortunately [does not support](https://github.com/ansible/ansible/issues/69949) setting the name of the resource group to use dynamically at runtime. Consequently, for now, you need to change the name in 2 or 3 places:

- [`terraform/vars.tf`](terraform/vars.tf): The variable is named `resource_group` - change its default value or pass it to `terraform apply`.
- [`ansible/inventory_azure_rm.yml`](ansible/inventory_azure_rm.yml), under the `include_vm_resource_groups` key.
- [`terraform/destroy.sh`](terraform/destroy.sh): The variable is named RG_NAME

For tracking of this matter, see #11 and https://github.com/ansible/ansible/issues/69949.
