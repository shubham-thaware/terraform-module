
# 🌩️ Terraform AWS Modules

![Terraform](https://img.shields.io/badge/Terraform-Modules-623CE4?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

> **Author:** [Shubham Thaware](https://github.com/shubham-thaware)  
> **Purpose:** Reusable, scalable, and production-ready Terraform modules for AWS Infrastructure.

---

## 📁 Repository Structure

This repository contains a collection of production-grade Terraform modules that can be reused across AWS environments. These modules encapsulate common AWS infrastructure patterns and best practices, making your infrastructure code modular, DRY (Don’t Repeat Yourself), and easy to manage.

```
terraform-module/
├── aws-vpc/                  # Virtual Private Cloud module
├── aws-eks/                  # Amazon EKS (Kubernetes) module
├── aws-ec2/                  # EC2 Instances module
├── aws-security-groups/     # Security Groups module
├── aws-ecr/                  # Elastic Container Registry module
```

Each module contains:
- `main.tf` – Core resource definitions
- `variables.tf` – Input variables for customization
- `outputs.tf` – Output values to be used by other modules or root modules

---

## 🔧 Module Details

### ✅ aws-vpc

Creates a VPC with public and private subnets, Internet Gateway, and Route Tables.

```hcl
module "vpc" {
  source = "github.com/shubham-thaware/terraform-module//aws-vpc"
  
  vpc_cidr               = "10.0.0.0/16"
  private_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs    = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway     = true
}
```

### ✅ aws-eks

Creates a fully managed EKS cluster with worker nodes, node groups, IAM roles, and security.

### ✅ aws-ec2

Launch EC2 instances with customizable AMIs, key pairs, instance types, tags, and security group attachments.

### ✅ aws-security-groups

Define reusable and composable security groups with ingress/egress rules.

### ✅ aws-ecr

Provision private ECR repositories to store container images for your workloads.

---

## 🚀 How to Use

1. **Initialize Terraform**

```bash
terraform init
```

2. **Use a module in your root configuration**

```hcl
module "ec2_instance" {
  source        = "github.com/shubham-thaware/terraform-module//aws-ec2"
  instance_type = "t3.micro"
  ami_id        = "ami-0abcdef1234567890"
  key_name      = "my-key"
}
```

3. **Apply your configuration**

```bash
terraform apply
```

---

## 📌 Best Practices Followed

- ✅ Modular design for reusability and maintainability
- ✅ Follows [Terraform Registry Module Standards](https://www.terraform.io/language/modules/develop/structure)
- ✅ Uses version constraints and tagging for module versioning
- ✅ Supports input validation and outputs for composition
- ✅ Written with production-readiness in mind

---

## 📥 Contribution

We love contributions! Please follow these steps:

1. Fork this repo 🍴  
2. Create your feature branch (`git checkout -b feature/my-feature`)  
3. Commit your changes (`git commit -am 'Add new feature'`)  
4. Push to the branch (`git push origin feature/my-feature`)  
5. Open a Pull Request ✅

Or open an [issue](https://github.com/shubham-thaware/terraform-module/issues) for any bugs or feature requests.

---

## 📜 License

This project is licensed under the [MIT License](./LICENSE).  
Feel free to use it for commercial or personal projects.

---

## 🙌 Connect

If you find this repository useful or want to connect with me:

- 🌐 GitHub: [@shubham-thaware](https://github.com/shubham-thaware)

> 🚀 Empower your AWS infrastructure with clean, modular, and scalable Terraform code!
