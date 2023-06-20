#!/bin/bash

# Fonction pour effectuer le test unitaire
run_test() {
  local test_name=$1
  local expected_result=$2
  local actual_result=$3

  if [[ "$expected_result" == "$actual_result" ]]; then
    echo "[PASS] $test_name"
  else
    echo "[FAIL] $test_name"
    echo "  - Expected: $expected_result"
    echo "  - Actual: $actual_result"
  fi
}

# Exécution des commandes pour créer le répertoire, ajouter la clé publique et définir les permissions
# Change "jho" and the public keys below...
mkdir -p /home/jho/.ssh
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10' >> /home/jho/.ssh/authorized_keys
chown -R jho: /home/jho/.ssh/
chmod 644 /home/jho/.ssh/authorized_keys
chmod 700 /home/jho/.ssh/

# Exécution des tests unitaires
run_test "Test 1: Vérification de la présence du répertoire" "Directory exists" "$(if [[ -d /home/jho/.ssh ]]; then echo "Directory exists"; else echo "Directory does not exist"; fi)"

run_test "Test 2: Vérification de la clé publique" "Key exists" "$(if grep -q 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10' /home/jho/.ssh/authorized_keys; then echo "Key exists"; else echo "Key does not exist"; fi)"

run_test "Test 3: Vérification des permissions du répertoire" "700" "$(stat -c "%a" /home/jho/.ssh)"

run_test "Test 4: Vérification des permissions du fichier" "644" "$(stat -c "%a" /home/jho/.ssh/authorized_keys)"
