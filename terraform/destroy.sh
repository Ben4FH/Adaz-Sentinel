RG_NAME="ad-hunting-lab" # Change if you have a different RG name

ACCESS_TOKEN=$(az account get-access-token --query 'accessToken' -o tsv)
AUTH_HEADER="Authorization: Bearer $ACCESS_TOKEN"
CONTENT_TYPE="Content-Type:application/json"
WORKSPACE_NAMES=$(az monitor log-analytics workspace list --query "[].name" -o tsv)
SUB_ID=$(az account show --query 'id' -o tsv)

echo "Calling REST API to permanently delete all log analytics data"
for WORKSPACE in $WORKSPACE_NAMES; do
    curl -X DELETE "https://management.azure.com/subscriptions/$SUB_ID/resourcegroups/$RG_NAME/providers/Microsoft.OperationalInsights/workspaces/$WORKSPACE?api-version=2021-12-01-preview&force=true" \
    -H "Authorization:Bearer $ACCESS_TOKEN" -H $CONTENT_TYPE -D -
done;

echo "Initiating deletion of the resource group: $RG_NAME"
az group delete --yes --no-wait -g $RG_NAME

while az group list --query '[].name' -o tsv | grep $RG_NAME > /dev/null;
do
    echo "Deletion still in progress..."
    sleep 10
done;

echo "The resource group has been deleted, you may want to confirm this yourself in the Azure Portal"

echo "Deleting the terraform state file"
rm terraform.tfstate