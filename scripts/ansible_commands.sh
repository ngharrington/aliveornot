# just for safe keeping for a moment

# ansible-playbook -i inventory --private-key ~/.ssh/do_neal -u root  -e "@secrets.enc" --ask-vault-pass  playbook.yml 
# ansible-playbook -i inventory --private-key ~/.ssh/do_neal -u ansible  -e "@secrets.enc" --ask-vault-pass  playbook.yml -t policy

# ansible-playbook -i inventory --private-key ~/.ssh/do_neal -u ansible  -e "@secrets.enc" --ask-vault-pass  playbook.yml -t users --skip-tags base