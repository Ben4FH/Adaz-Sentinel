# Architecture

## Network architecture

1 subnet for workstations and 1 subnet for servers.

## Provisioning flow

Creation of resources is performed by Terraform. Once a VM is created in Azure, it is then provisioned with Ansible using the `local-exec` provisioner. For instance:

```hcl
# Provision base domain and DC
provisioner "local-exec" {
  working_dir = "${path.root}/../ansible"
  command     = "/bin/bash -c 'source venv/bin/activate && env no_proxy='*' ansible-playbook domain-controllers.yml --tags=common,base -v'"
}
```

In addition, a few tricks with `null_resources` are used to better parallelize provisioning.