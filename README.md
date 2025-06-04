# terraform-module
This is an terraform module repo maintain by Shubham Thaware
This repository defines reusable Terraform modules for different AWS resources. Each module has:
- main.tf → Defines resources.
- variables.tf → Contains input variables.
- outputs.tf → Exposes outputs for other modules.
📂 Folder Structur
terraform-module/
├── aws-vpc/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
├── aws-eks/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
├── aws-ec2/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
├── aws-security-groups/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
├── aws-ecr/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf


🔹 Example Terraform Code (terraform-module/aws-vpc/main.tf
```
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
}
```
- Defines the VPC and subnets as reusable Terraform modules.
- Modules are self-contained and can be called from another repository.
