# Terraform configuration to demonstrate Check Point security Infrastructure as code
You can find the latest Terraform executable at: https://www.terraform.io/downloads.html

**Run the following command on your windows host to download the terraform configuration files.
A directory called Terraform_Demo_policy will be created in the location you execute the below command. The Terraform configuration files will be stored in this directory.
```
curl -kLs https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/Terraform/Terraform_Demo_policy/download_terraform_demo.bat | cmd
```

After download customize the main.tf file to point to your management server and the correct credentials.

Execute terraform with:
```
terraform init
terraform plan
terraform apply
```
```
remove everything with: 
terraform destroy
```
The terraform demo will create hosts, networks, services, a policy package and populate that policy package with rules.