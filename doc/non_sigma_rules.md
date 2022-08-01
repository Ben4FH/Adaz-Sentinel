# Creating Sentinel rules from raw KQL queries

You can also deploy your own KQL queries instead of needing to use Sigma rules. 

These can be found in the following folder:
[/terraform/files/custom_kql/](../terraform/files/custom_kql/)

Inside this folder you will want to create 2 files for each KQL query you want to turn into a Sentinel rule:

1. `rule_name.kql`
    - This file will just contain the raw KQL query. Ensure that the extension is .kql
2. `rule_name.yml`
    - This will contain information about the rule to be created
    - Please see [`template.yml`](../terraform/files/custom_kql/template.yml) for an example of what you need to put in it.

When building with Terraform it will use these files to create the alert rule in Sentinel.