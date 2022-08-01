# Using an existing venv which already has the yaml module
source ../../../ansible/venv/bin/activate

# Colour codes
ORANGE='\033[0;33m'
GREEN='\033[1;32m'
NC='\033[0m'

echo "Cloning the Sigma repository..."
git clone https://github.com/SigmaHQ/sigma.git 2>/dev/null

echo "Replacing backend python script..."
cp ./ala-new.py sigma/tools/sigma/backends/ala.py

echo "Creating list of High level Windows rules..."
grep -Elir 'Level: High|Level: Critical' sigma/rules/windows/ | sed 's,//,/,g' > rules.txt

echo "Reading list of rules to ignore..."
ignore_list=""
{
    read
    while IFS=, read -r -a myArray
    do
        ignore_list+="${myArray[0]}.yml\r\n"
    done
} < failed.csv

echo "Looking for new rules to convert to KQL..."
mkdir -p converted
for rule_path in `cat rules.txt; printf "\n"`; do

    name_yaml="$(echo $rule_path | rev | cut -d '/' -f1 | rev)"
    skip=false
    
    if  [ -f "./override/$name_yaml" ] && [ ! -f "./converted/$name_yaml" ] ; then
        echo "Found custom version of $name_yaml - using that instead..."
        rule_path="./override/$name_yaml"
    elif [[ ${ignore_list[*]} =~ $name_yaml ]]; then
        printf "${ORANGE}Skipping rule: $rule_path${NC}\n"
        skip=true
    elif [ -f "./converted/$name_yaml" ]; then
        skip=true
    fi

    if [ "$skip" = false ] ; then
        cp ./$rule_path ./converted;
        ./sigma/tools/sigmac --target ala --config ./ala-new.yml $rule_path -o "./converted/";
        if ! grep -q "override" <<< "$rule_path"; then
            printf "${GREEN}Added new rule: $rule_path${NC}\n"
        fi
    fi
done

echo "Cleanup..."
rm rules.txt
rm -rf sigma/