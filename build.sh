#!/bin/bash

export bridge="vmbr1"
export disk_format="raw"
export iso_storage_pool="local"
export nb_core=1
export nb_cpu=1
export nb_ram=1024
export network_ip="192.168.1.0/24"
export node1="node1"
export node2="node2"
export node_password="password"
export node1_url="https://192.168.1.10:8006/api2/json" # you can define a server name (e.q. https://host1:8006/api2/json)
export node2_url="https://192.168.1.11:8006/api2/json"
export node_username="builder@pve"
export ssh_username="jho"
export ssh_password="pouetpouet" # needed for preseed file. Change it with your user
export ssh_pubkey="CHANGEME"
export storage_pool="crucial"
export sudo_password="pouetpouet"
export type_cpy="host"
export vm_id=9999
export vm_name="deb12-pkr"
export vm_size="32G"

tox
source .tox/py3-ansible/bin/activate

j2 variables.j2 > variables.auto.pkrvars.hcl
j2 variables.j2 > variables.auto.tfvars
j2 http/preseed.cfg.j2 > http/preseed.cfg

packer init .
packer validate .
packer build -on-error=ask .

terraform init
terraform validate .
# Need to destroy it ?
# terraform -destroy

plan_output=$(terraform plan -var-file="variables.auto.tfvars" -out tfplan)
if [[ $plan_output == *"No changes."* ]]; then
    echo "Aucun changement détecté. Aucune action supplémentaire nécessaire."
else
    echo "Des changements ont été détectés. Exécution de 'terraform apply'."
    terraform apply -auto-approve tfplan
fi

cd ansible
ansible-galaxy collection install -r requirements.yaml
ansible-playbook --inventory=production site.yaml -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
cd ../
deactivate