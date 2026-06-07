cloud-init.yml
        #cloud-config
        users:
        - name: dvp
            groups: sudo
            shell: /bin/bash
            sudo: ["ALL=(ALL) NOPASSWD:ALL"]
            ssh_authorized_keys:
            - ssh-ed25519 AAAAC.... user@host - ssh key
            
terraform -chdir=./terraform apply -auto-approve

ansible-playbook -i ./ansible/inventory/hosts.ini ./ansible/playbook.yml