# JH packer/terraform/ansible k3s homelab

EN COURS D'ETUDE ET CONSTRUCTION

## Pourquoi faire ?

Créer un cluster k3s headless dans Proxmox 8, pour y auto-héberger mes services actuellement en docker compose. Le cluster est pédagogique, pour toucher plusieurs technos et repousser les limites de l'automatisation.

1. Générer une image Debian 12 avec Packer
2. Utiliser Terraform pour initier 3 VM (1 master, 2 workers)
3. Ansible pour tout configurer

## Outils

Packer, Terraform, Ansible, Proxmox VE, Debian 12, k3s, UFW, Wireguard

## Todo

Tellement de choses...

## system

- s'assurer que l'host est réellement unique (ssh host key)
- wireguard et ufw
- crowdsec
- personnalisations pour rendre le système plus agréable pour l'utilisateur (bashrc avec alias)

## ansible

- éviter l'utilisation du stricthostkeychecking=no
- linting et amélioration globale du playbook
- molecule
- testinfra
- refactoring des rôles/tâches

### k3s

- Cilium
- Déploiement d'apps (k8s dashboard, traefik...)

## Utilisation des commandes

```bash
# tout faire en un seul jet
source build.sh

# pour forcer un nouveau build packer
packer build -force

# pour détruire les VM
terraform destroy

# ansible pour la base OS
ansible-playbook --inventory=production site.yaml -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" --tags ntp,sshd,system --check --diff
# ansible pour détruire le cluster k3s
ansible-playbook --inventory=production site.yaml -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" --tags k3s-destroy --check --diff
# ansible pour monter le cluster k3s
ansible-playbook --inventory=production site.yaml -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" --tags k3s-check,k3s-master,k3s-workers --check --diff
# ansible pour le hardening
ansible-playbook --inventory=production site.yaml -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" --tags hardening --check --diff
```

## Timing

~ 5 minutes pour build packer
~ 3 minutes pour terraform 3 VM
~ 2 minutes pour ansible (tous les tags)

10 minutes pour le cluster complet o_o

## Inspirations

- <https://github.com/N7KnightOne/packer-template-debian-11/tree/main>
- ...
