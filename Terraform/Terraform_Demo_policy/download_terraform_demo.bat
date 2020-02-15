@echo off
mkdir Terraform_Demo_policy
cd Terraform_Demo_policy
curl -kLs https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/Terraform/Terraform_Demo_policy/hosts.tf > hosts.tf
curl -kLs https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/Terraform/Terraform_Demo_policy/main.tf > main.tf
curl -kLs https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/Terraform/Terraform_Demo_policy/networks.tf > networks.tf
curl -kLs https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/Terraform/Terraform_Demo_policy/policy.tf > policy.tf.orig
curl -kLs https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/Terraform/Terraform_Demo_policy/publish.bat > publish.bat
curl -kLs https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/Terraform/Terraform_Demo_policy/publish.py > publish.py
curl -kLs https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/Terraform/Terraform_Demo_policy/rules.tf > rules.tf.orig
curl -kLs https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/Terraform/Terraform_Demo_policy/services.tf > services.tf
echo "Files stored in Terraform_Demo_policy directory"
echo "All done"