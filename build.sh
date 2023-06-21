#!/bin/bash

tox
source .tox/py3-ansible/bin/activate

j2 http/preseed.cfg.j2 > http/preseed.cfg

packer init .
packer build -force -on-error=abort -var-file="variables.example.pkrvars.hcl" .

terraform init
terraform validate .

plan_output=$(terraform plan -var-file="variables.example.tfvars")
if [[ $plan_output == *"No changes."* ]]; then
    echo "Aucun changement détecté. Aucune action supplémentaire nécessaire."
else
    echo "Des changements ont été détectés. Exécution de 'terraform apply'."
    terraform apply -var-file="variables.example.tfvars" -auto-approve
fi

rm http/preseed.cfg

# Need to destroy it ?
# terraform apply -var-file="variables.jho.tfvars" -destroy -auto-approve