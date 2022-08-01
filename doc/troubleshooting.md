# Troubleshooting

## You get an error regarding the failed creation of 1 or more alert rules.
---

- If this happens, there are a few things you can do:

1. Read the error message to see if a certain column name is causing the issue
    - If the column name does not exist in the table which the rule uses, you may need to adjust the ala-new.yml file to map it to an existing column name. Please see the [sigmac docs](https://github.com/SigmaHQ/sigma/blob/master/tools/README.md) for more information about this. You can also raise an issue and I will take a look.

2. If there was no mention of a specific column then check the .rule file in the `converted` folder for this rule and see if there are any obvious issues with the KQL. It may be that the regex is invalid or a character needed to be escaped. If this is the case, please raise an issue and i will check.

3. If the sigma rule can be changed to fix the issue, please do so and move it to the `override` folder

4. If unable to fix the issue, add the rule filename (with no extension) to the `failed.csv` file
...

## Ansible fails to read from the inventory
---

- I noticed this once in testing, but haven't been able to replicate the issue. Destroying and rebuilding the lab fixed the issue for me.