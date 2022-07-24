export DIGITALOCEAN_ACCESS_TOKEN=$(cat ~/.do/access_tokens/aliveornot)
export AWS_SECRET_ACCESS_KEY=$(cat ~/.do/spaces_secrets/aliveornot-terraform)
export AWS_ACCESS_KEY_ID="3JYOZXDAX6ZNB5ZTIR4V"
export PKR_VAR_api_key="${DIGITALOCEAN_ACCESS_TOKEN}"
export PKR_VAR_ssh_private_key_file="~/.ssh/do_packer"
export PKR_VAR_aws_key_id=$AWS_ACCESS_KEY_ID
export PKR_VAR_aws_secret=$AWS_SECRET_ACCESS_KEY

# Get ansible in the path
ANSIBLE_PATH="~/.pyenv/versions/venv-ansible/bin/"
export PATH="${ANSIBLE_PATH}:${PATH}"