# Common operations

This page provides some guidance around common operations you might wish to perform on your lab.

## Viewing public IPs of your instances

If you do not get any errors, you should see the public IPs of all machines on the output.  If you get an error at the end for a rule which failed to create, you will not get this output and so will have to check the machines in the Azure Portal.

## Destroying the lab

While `terraform destroy` is an option, I found that simply nuking the resource group works better. You'll also need to remove the Terraform state file to make sure Terraform understands it shouldn't manage it anymore. I have included a bash script 'destroy.sh' which can be used instead. The script will:
1. send a DELETE request to the Azure REST API so that the log analytics workspace is permanently destroyed. Azure keep them saved for longer otherwise and I have found this to cause issues.
2. Use the azure cli to forcibly delete the resource group
3. Delete the Terraform state file

## Adding users, groups, OUs after the lab has been instantiated

Change the configuration in `domain.yml` and run Ansible against your workstations and domain controller:

```bash
cd ansible
source venv/bin/activate

ansible-playbook domain-controllers.yml
ansible-playbook workstations.yml
```

Note that you cannot modify every setting this way. For instance, you cannot change the domain's FQDN or the number of workstations.

## Adding/removing workstations

Change the configuration in `domain.yml` and run a `terraform apply`. If, on the first instantiation, you specified non-defaults variables (e.g. the Azure region), don't forget to include them (e.g. `terraform apply -var 'region=East US'`) 

## Applying OS updates

When the lab is provisioned, the latest OS updates are not applied. To apply them, run the dedicated Ansible playbooks:

```bash
cd ansible
source venv/bin/activate

ansible-playbook workstations-os-updates.yml
ansible-playbook domain-controllers-os-updates.yml
```

This will apply critical updates, security updates and update rollups.