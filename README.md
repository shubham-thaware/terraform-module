```markdown
# Terraform AWS Modules

This repository, maintained by Shubham, defines reusable Terraform modules for various AWS resources. These modules are self-contained and can be called from other repositories, making resource management in AWS simpler and more efficient.

## Folder Structure

```plaintext
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
```

## Modules Overview

Each module contains:
- **`main.tf`**: Defines the resources.
- **`variables.tf`**: Contains input variables for configuration.
- **`outputs.tf`**: Exposes outputs that can be used by other modules.

### Example: AWS VPC Module

Here's a snippet of how the AWS VPC module is structured:

**File: `terraform-module/aws-vpc/main.tf`**

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
}
```

In this example, the VPC and its private subnets are defined as reusable Terraform resources.

## Usage

To use these modules, you can reference them in your Terraform configuration files. Make sure to pass the required input variables as defined in `variables.tf`.

## Contribution

If you have suggestions or improvements, feel free to submit a pull request or open an issue. Contributions are always welcome!

## License

This project is licensed under the MIT License.
```


