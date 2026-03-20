---
name: terraform-dev
description: Terraform Development
---

# Terraform Development Skill

## Overview
This skill helps you write, debug, optimize, and maintain Terraform infrastructure as code (IaC). It provides best practices for idiomatic Terraform configuration, proper state management, module design, testing strategies, and effective use of Terraform's features across multiple cloud providers.

## When to Use This Skill
Use this skill when you need to:
- Write new Terraform configurations for infrastructure provisioning
- Debug Terraform plans, applies, or state issues
- Design reusable Terraform modules
- Manage Terraform state and workspaces
- Implement multi-environment infrastructure (dev, staging, prod)
- Work with multiple cloud providers (AWS, Azure, GCP, etc.)
- Optimize Terraform performance and reduce drift
- Implement CI/CD for infrastructure changes
- Troubleshoot provider-specific issues

## Terraform Philosophy & Principles

### Core Concepts
1. **Declarative** - Describe desired state, not steps to achieve it
2. **Immutable Infrastructure** - Replace rather than modify resources
3. **Resource Graph** - Terraform builds dependency graph automatically
4. **State Management** - Track real-world resource state
5. **Plan Before Apply** - Preview changes before execution
6. **Provider Agnostic** - Works across multiple cloud providers

### Key Mantras
- "Plan, review, apply" - Always preview changes
- "State is truth" - Terraform state represents reality
- "Modules for reusability" - DRY principle for infrastructure
- "Version everything" - Lock provider and module versions
- "Remote state for teams" - Never store state locally in production

## Project Structure

### Standard Terraform Project Layout
```
terraform-project/
├── environments/              # Environment-specific configs
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── staging/
│   │   └── ...
│   └── prod/
│       └── ...
├── modules/                   # Reusable modules
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── compute/
│   │   └── ...
│   └── database/
│       └── ...
├── global/                    # Global resources (IAM, DNS, etc.)
│   └── ...
├── .terraform/               # Terraform working directory (gitignored)
├── .terraform.lock.hcl       # Provider version lock file
├── .gitignore
└── README.md
```

### Alternative Flat Layout (for smaller projects)
```
simple-project/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── backend.tf
├── versions.tf
└── README.md
```

### File Conventions
- `main.tf` - Primary resource definitions
- `variables.tf` - Input variable declarations
- `outputs.tf` - Output value declarations
- `versions.tf` - Provider and Terraform version constraints
- `backend.tf` - Backend configuration (state storage)
- `terraform.tfvars` - Variable values (not committed if sensitive)
- `locals.tf` - Local values (computed/derived values)
- `data.tf` - Data sources (read-only resources)

## Basic Terraform Workflow
```bash
# Initialize Terraform (download providers, setup backend)
terraform init

# Validate syntax and configuration
terraform validate

# Format code to canonical style
terraform fmt -recursive

# Preview changes
terraform plan

# Apply changes
terraform apply

# Apply with auto-approval (use carefully!)
terraform apply -auto-approve

# Destroy all resources
terraform destroy

# Show current state
terraform show

# List resources in state
terraform state list

# Refresh state from real infrastructure
terraform refresh

# Output values
terraform output
terraform output -json
```

## Core Terraform Syntax

### 1. Resources
```hcl
# Basic resource syntax
resource "provider_type" "local_name" {
  argument1 = "value1"
  argument2 = "value2"
  
  nested_block {
    setting = "value"
  }
}

# AWS EC2 instance example
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  
  tags = {
    Name        = "web-server"
    Environment = "production"
  }
}

# Resource with count (multiple similar resources)
resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  
  tags = {
    Name = "web-server-${count.index}"
  }
}

# Resource with for_each (multiple resources from map/set)
resource "aws_instance" "servers" {
  for_each = {
    web  = "t3.micro"
    app  = "t3.small"
    db   = "t3.medium"
  }
  
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = each.value
  
  tags = {
    Name = each.key
  }
}
```

### 2. Variables
```hcl
# Variable declaration (in variables.tf)
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
  
  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# Complex types
variable "vpc_config" {
  description = "VPC configuration"
  type = object({
    cidr_block           = string
    enable_dns_hostnames = bool
    availability_zones   = list(string)
  })
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

variable "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Sensitive variables
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# Using variables
resource "aws_instance" "example" {
  instance_type = var.instance_type
  
  tags = merge(
    var.tags,
    {
      Name = "example-instance"
    }
  )
}
```

### 3. Variable Values (terraform.tfvars)
```hcl
# terraform.tfvars
instance_type  = "t3.small"
instance_count = 3
environment    = "prod"

vpc_config = {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

tags = {
  Project     = "MyApp"
  ManagedBy   = "Terraform"
  CostCenter  = "Engineering"
}
```

### 4. Outputs
```hcl
# Basic output
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

# Output from resource with count
output "instance_ids" {
  description = "IDs of all instances"
  value       = aws_instance.web[*].id
}

# Output from resource with for_each
output "server_ips" {
  description = "IP addresses of all servers"
  value = {
    for name, instance in aws_instance.servers :
    name => instance.private_ip
  }
}

# Sensitive output
output "db_password" {
  description = "Database password"
  value       = random_password.db.result
  sensitive   = true
}

# Complex output
output "vpc_info" {
  description = "VPC information"
  value = {
    vpc_id     = aws_vpc.main.id
    cidr_block = aws_vpc.main.cidr_block
    subnet_ids = aws_subnet.private[*].id
  }
}
```

### 5. Locals
```hcl
# Local values (computed/derived values)
locals {
  # Simple computation
  environment_tag = "${var.environment}-${var.region}"
  
  # Complex computation
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
  
  # Conditional logic
  instance_count = var.environment == "prod" ? 3 : 1
  
  # String manipulation
  bucket_name = lower("${var.project_name}-${var.environment}-data")
  
  # Map/list manipulation
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
  
  # Combining multiple values
  subnet_configs = [
    for i, cidr in var.subnet_cidrs : {
      cidr              = cidr
      availability_zone = local.availability_zones[i % length(local.availability_zones)]
    }
  ]
}

# Using locals
resource "aws_instance" "web" {
  count         = local.instance_count
  instance_type = "t3.micro"
  
  tags = merge(
    local.common_tags,
    {
      Name = "web-${count.index}"
    }
  )
}
```

### 6. Data Sources
```hcl
# Fetch existing resources (read-only)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "existing" {
  id = var.vpc_id
}

# Using data sources
resource "aws_instance" "example" {
  ami               = data.aws_ami.ubuntu.id
  availability_zone = data.aws_availability_zones.available.names[0]
}
```

## Advanced Terraform Patterns

### 1. Dynamic Blocks
```hcl
# ✅ Good - dynamic blocks for repeatable nested blocks
variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

resource "aws_security_group" "web" {
  name = "web-sg"
  
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

# Dynamic blocks with conditional creation
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"
  
  dynamic "versioning" {
    for_each = var.enable_versioning ? [1] : []
    content {
      enabled = true
    }
  }
}
```

### 2. Conditional Expressions
```hcl
# Ternary operator
resource "aws_instance" "web" {
  instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"
  
  tags = {
    Name = var.environment == "prod" ? "prod-web" : "dev-web"
  }
}

# Conditional resource creation with count
resource "aws_cloudwatch_alarm" "high_cpu" {
  count = var.enable_monitoring ? 1 : 0
  
  alarm_name          = "high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
}

# Multiple conditions
locals {
  instance_type = (
    var.environment == "prod" ? "t3.large" :
    var.environment == "staging" ? "t3.medium" :
    "t3.micro"
  )
}
```

### 3. For Expressions
```hcl
# List transformation
locals {
  # Convert list to uppercase
  uppercase_names = [for name in var.names : upper(name)]
  
  # Filter list
  prod_servers = [for s in var.servers : s if s.environment == "prod"]
  
  # Transform to map
  server_map = {
    for s in var.servers :
    s.name => s.ip_address
  }
  
  # Nested for expressions
  all_subnet_ids = flatten([
    for vpc in var.vpcs : [
      for subnet in vpc.subnets : subnet.id
    ]
  ])
}

# Map transformation
locals {
  # Transform map values
  uppercase_tags = {
    for key, value in var.tags :
    key => upper(value)
  }
  
  # Filter map
  important_tags = {
    for key, value in var.tags :
    key => value
    if contains(["Environment", "Project"], key)
  }
}

# Using in resources
resource "aws_subnet" "private" {
  for_each = {
    for idx, config in local.subnet_configs :
    "subnet-${idx}" => config
  }
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone
  
  tags = {
    Name = each.key
  }
}
```

### 4. Splat Expressions
```hcl
# Get all IDs from resources created with count
resource "aws_instance" "web" {
  count = 3
  # ... configuration
}

output "all_instance_ids" {
  value = aws_instance.web[*].id
}

output "all_private_ips" {
  value = aws_instance.web[*].private_ip
}

# Nested splat
output "all_subnet_ids" {
  value = aws_vpc.main[*].subnet[*].id
}
```

### 5. Dependencies
```hcl
# Implicit dependencies (Terraform detects automatically)
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id  # Implicit dependency on data source
  subnet_id     = aws_subnet.public.id    # Implicit dependency on subnet
  instance_type = "t3.micro"
}

# Explicit dependencies (use when implicit detection fails)
resource "aws_iam_role_policy" "example" {
  name   = "example"
  role   = aws_iam_role.example.name
  policy = data.aws_iam_policy_document.example.json
  
  # Ensure role is created before policy attachment
  depends_on = [aws_iam_role.example]
}

# Module dependencies
module "vpc" {
  source = "./modules/vpc"
  # ... configuration
}

module "ec2" {
  source = "./modules/ec2"
  
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_ids[0]
  
  # Explicit dependency on entire module
  depends_on = [module.vpc]
}
```

## Modules

### 1. Module Structure
```
modules/vpc/
├── main.tf          # Main resource definitions
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── versions.tf      # Provider version constraints
├── README.md        # Documentation
└── examples/        # Example usage
    └── basic/
        └── main.tf
```

### 2. Creating a Module
```hcl
# modules/vpc/variables.tf
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# modules/vpc/main.tf
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = merge(
    var.tags,
    {
      Name = "main-vpc"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = merge(
    var.tags,
    {
      Name = "private-subnet-${count.index}"
      Type = "private"
    }
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  
  tags = merge(
    var.tags,
    {
      Name = "public-subnet-${count.index}"
      Type = "public"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(
    var.tags,
    {
      Name = "main-igw"
    }
  )
}

# modules/vpc/outputs.tf
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}
```

### 3. Using Modules
```hcl
# Local module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr               = "10.0.0.0/16"
  availability_zones     = ["us-east-1a", "us-east-1b"]
  private_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs    = ["10.0.101.0/24", "10.0.102.0/24"]
  
  tags = {
    Environment = "production"
    Project     = "myapp"
  }
}

# Remote module from Terraform Registry
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  
  enable_nat_gateway = true
  enable_vpn_gateway = false
}

# Using module outputs
resource "aws_instance" "web" {
  subnet_id = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.web.id]
  # ... other configuration
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
```

### 4. Module Versioning
```hcl
# Pin to specific version
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  # ... configuration
}

# Version constraints
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"  # >= 5.0.0, < 6.0.0
  # ... configuration
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 5.0.0, < 5.2.0"
  # ... configuration
}
```

## State Management

### 1. Local State (Development Only)
```hcl
# terraform.tfstate is created automatically
# ⚠️ Never use local state for production!
# ⚠️ Never commit terraform.tfstate to version control!
```

### 2. Remote State (S3 Backend)
```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    
    # Optional: versioning for state file
    # Configured on the S3 bucket itself
  }
}

# Create S3 bucket and DynamoDB table for state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"
  
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }
}
```

### 3. Remote State Data Source
```hcl
# Read state from another Terraform configuration
data "terraform_remote_state" "vpc" {
  backend = "s3"
  
  config = {
    bucket = "my-terraform-state-bucket"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# Use outputs from remote state
resource "aws_instance" "web" {
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
  # ... other configuration
}
```

### 4. State Commands
```bash
# List resources in state
terraform state list

# Show specific resource
terraform state show aws_instance.web

# Remove resource from state (doesn't destroy resource)
terraform state rm aws_instance.web

# Move resource within state
terraform state mv aws_instance.old aws_instance.new

# Pull remote state to local file
terraform state pull > terraform.tfstate

# Push local state to remote
terraform state push terraform.tfstate

# Replace provider address (after provider migration)
terraform state replace-provider \
  registry.terraform.io/hashicorp/aws \
  registry.terraform.io/hashicorp/aws

# Import existing resource into state
terraform import aws_instance.web i-1234567890abcdef0
```

### 5. Workspaces
```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new prod

# Switch workspace
terraform workspace select dev

# Show current workspace
terraform workspace show

# Delete workspace
terraform workspace delete old-workspace
```
```hcl
# Use workspace in configuration
resource "aws_instance" "web" {
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"
  
  tags = {
    Environment = terraform.workspace
    Name        = "web-${terraform.workspace}"
  }
}

# Different backend key per workspace
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "env/${terraform.workspace}/terraform.tfstate"
    region = "us-east-1"
  }
}
```

## Provider Configuration

### 1. Provider Versions
```hcl
# versions.tf
terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}
```

### 2. Provider Configuration
```hcl
# AWS provider
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}

# Multiple AWS providers (multi-region)
provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}

# Using aliased providers
resource "aws_instance" "east" {
  provider = aws.us_east
  # ... configuration
}

resource "aws_instance" "west" {
  provider = aws.us_west
  # ... configuration
}

# Azure provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# GCP provider
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
```

### 3. Provider Authentication
```hcl
# AWS - Environment variables (recommended)
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_REGION

# AWS - Shared credentials file
provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

# AWS - IAM role (when running on EC2/ECS)
provider "aws" {
  region = "us-east-1"
  # Automatically uses instance IAM role
}

# Azure - Service Principal
provider "azurerm" {
  features {}
  
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# GCP - Service Account Key
provider "google" {
  credentials = file("path/to/service-account-key.json")
  project     = var.project_id
  region      = var.region
}
```

## Best Practices

### 1. Code Organization
```hcl
# ✅ Good - Separate files by purpose
# main.tf - Primary resources
# variables.tf - Variable declarations
# outputs.tf - Output declarations
# locals.tf - Local values
# data.tf - Data sources
# versions.tf - Provider versions

# ✅ Good - Use consistent naming
resource "aws_instance" "web_server" {  # snake_case
  tags = {
    Name = "WebServer"  # PascalCase for display names
  }
}

# ✅ Good - Use descriptive names
resource "aws_security_group" "application_load_balancer" {
  # Better than "sg1" or "alb_sg"
}

# ❌ Bad - Everything in one file
# ❌ Bad - Inconsistent naming (webServer, web-server, WebServer)
```

### 2. Variable Management
```hcl
# ✅ Good - Provide descriptions and types
variable "instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
  default     = "t3.micro"
}

# ✅ Good - Use validation
variable "environment" {
  description = "Environment name"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# ✅ Good - Use sensitive flag for secrets
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# ❌ Bad - No description, type, or validation
variable "x" {
  default = "something"
}
```

### 3. Resource Naming and Tagging
```hcl
# ✅ Good - Consistent tagging strategy
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
    CostCenter  = var.cost_center
  }
}

resource "aws_instance" "web" {
  # ... configuration
  
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-web-${var.environment}"
      Role = "WebServer"
    }
  )
}

# ✅ Good - Use name_prefix for uniqueness
resource "aws_s3_bucket" "logs" {
  bucket_prefix = "${var.project_name}-logs-"
  # AWS will append random suffix
}

# ❌ Bad - No tags or inconsistent tagging
resource "aws_instance" "web" {
  tags = {
    Name = "server"  # Too generic
  }
}
```

### 4. Resource Lifecycle
```hcl
# Prevent accidental deletion
resource "aws_s3_bucket" "important_data" {
  bucket = "critical-data-bucket"
  
  lifecycle {
    prevent_destroy = true
  }
}

# Create before destroy (zero-downtime updates)
resource "aws_instance" "web" {
  # ... configuration
  
  lifecycle {
    create_before_destroy = true
  }
}

# Ignore changes to specific attributes
resource "aws_instance" "web" {
  # ... configuration
  
  lifecycle {
    ignore_changes = [
      tags["LastModified"],
      user_data  # Ignore changes to user_data after creation
    ]
  }
}

# Replace triggered by changes
resource "aws_instance" "web" {
  # ... configuration
  
  lifecycle {
    replace_triggered_by = [
      aws_security_group.web.id
    ]
  }
}
```

### 5. Error Handling and Validation
```hcl
# Preconditions (Terraform 1.2+)
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  lifecycle {
    precondition {
      condition     = data.aws_ami.ubuntu.architecture == "x86_64"
      error_message = "AMI must be x86_64 architecture"
    }
  }
}

# Postconditions
resource "aws_db_instance" "database" {
  # ... configuration
  
  lifecycle {
    postcondition {
      condition     = self.publicly_accessible == false
      error_message = "Database must not be publicly accessible"
    }
  }
}

# Check blocks (Terraform 1.5+)
check "health_check" {
  data "http" "app_health" {
    url = "https://${aws_instance.web.public_ip}/health"
  }
  
  assert {
    condition     = data.http.app_health.status_code == 200
    error_message = "Application health check failed"
  }
}
```

## AWS-Specific Patterns

### 1. VPC and Networking
```hcl
# Complete VPC setup
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "main-igw"
  }
}

resource "aws_eip" "nat" {
  count  = 2
  domain = "vpc"
  
  tags = {
    Name = "nat-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "main" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  tags = {
    Name = "nat-gateway-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  
  tags = {
    Name = "private-rt-${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
```

### 2. Security Groups
```hcl
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id
  
  # Ingress rules
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }
  
  # Egress rules
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "web-sg"
  }
}

# Separate security group rules (better for reusability)
resource "aws_security_group_rule" "web_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
  description       = "HTTP from anywhere"
}
```

### 3. EC2 Instances with User Data
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.deployer.key_name
  
  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    db_endpoint = aws_db_instance.main.endpoint
    app_version = var.app_version
  }))
  
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
  }
  
  metadata_options {
    http_tokens                 = "required"  # IMDSv2
    http_put_response_hop_limit = 1
  }
  
  tags = {
    Name = "web-server"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# user-data.sh
#!/bin/bash
apt-get update
apt-get install -y nginx

cat > /etc/nginx/conf.d/app.conf <<EOF
upstream backend {
  server ${db_endpoint};
}
EOF

systemctl enable nginx
systemctl start nginx
```

### 4. Load Balancer
```hcl
resource "aws_lb" "main" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id
  
  enable_deletion_protection = true
  
  tags = {
    Name = "main-alb"
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
  }
  
  tags = {
    Name = "web-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.main.arn
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group_attachment" "web" {
  count            = length(aws_instance.web)
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}
```

### 5. RDS Database
```hcl
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  
  tags = {
    Name = "main-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier     = "main-database"
  engine         = "postgres"
  engine_version = "15.3"
  instance_class = "db.t3.micro"
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true
  storage_type          = "gp3"
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password  # Use AWS Secrets Manager in production
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]
  
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:05:00"
  
  multi_az               = var.environment == "prod" ? true : false
  publicly_accessible    = false
  skip_final_snapshot    = var.environment != "prod"
  final_snapshot_identifier = var.environment == "prod" ? "${var.db_name}-final-${formatdate("YYYY-MM-DD-hhmm", timestamp())}" : null
  
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  
  tags = {
    Name = "main-database"
  }
}
```

### 6. S3 Bucket
```hcl
resource "aws_s3_bucket" "app_data" {
  bucket = "${var.project_name}-app-data-${var.environment}"
  
  tags = {
    Name = "Application Data"
  }
}

resource "aws_s3_bucket_versioning" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  
  rule {
    id     = "archive-old-versions"
    status = "Enabled"
    
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }
    
    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }
    
    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }
}
```

## Testing and Validation

### 1. Terraform Validate and Format
```bash
# Validate syntax
terraform validate

# Format code
terraform fmt -recursive

# Check formatting without changing files
terraform fmt -check -recursive

# Show diff of formatting changes
terraform fmt -diff
```

### 2. Terraform Plan Analysis
```bash
# Generate plan
terraform plan -out=tfplan

# Show plan in JSON
terraform show -json tfplan | jq

# Save plan to file for review
terraform plan -out=tfplan > plan.txt

# Plan with specific target
terraform plan -target=aws_instance.web

# Plan with variable file
terraform plan -var-file=prod.tfvars
```

### 3. Testing with Terratest
```go
// test/terraform_aws_example_test.go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestTerraformAwsExample(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: "../examples/basic",
        Vars: map[string]interface{}{
            "instance_type": "t3.micro",
            "environment":   "test",
        },
    }
    
    defer terraform.Destroy(t, terraformOptions)
    
    terraform.InitAndApply(t, terraformOptions)
    
    instanceID := terraform.Output(t, terraformOptions, "instance_id")
    assert.NotEmpty(t, instanceID)
    
    vpcID := terraform.Output(t, terraformOptions, "vpc_id")
    assert.NotEmpty(t, vpcID)
}
```

### 4. Policy as Code with Sentinel/OPA
```hcl
# Sentinel policy example
import "tfplan/v2" as tfplan

# Ensure all S3 buckets have encryption enabled
main = rule {
    all tfplan.resource_changes as _, rc {
        rc.type is "aws_s3_bucket" and
        rc.change.after.server_side_encryption_configuration is not null
    }
}
```

## Debugging and Troubleshooting

### 1. Enable Debug Logging
```bash
# Enable debug logging
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log

# Different log levels
export TF_LOG=TRACE  # Most verbose
export TF_LOG=DEBUG
export TF_LOG=INFO
export TF_LOG=WARN
export TF_LOG=ERROR

# Provider-specific logging
export TF_LOG_PROVIDER=DEBUG
```

### 2. Common Issues and Solutions
```hcl
# Issue: Cycle dependency error
# Solution: Use depends_on or refactor resources

# Issue: Resource already exists
# Solution: Import existing resource
terraform import aws_instance.web i-1234567890abcdef0

# Issue: State lock error
# Solution: Force unlock (use carefully!)
terraform force-unlock <lock-id>

# Issue: Drift between state and reality
# Solution: Refresh state
terraform refresh

# Or import changes
terraform plan -refresh-only
terraform apply -refresh-only
```

### 3. Targeted Operations
```bash
# Apply only specific resources
terraform apply -target=aws_instance.web
terraform apply -target=module.vpc

# Destroy specific resources
terraform destroy -target=aws_instance.web

# Replace specific resource
terraform apply -replace=aws_instance.web
```

## CI/CD Integration

### 1. GitHub Actions
```yaml
# .github/workflows/terraform.yml
name: Terraform

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.0
      
      - name: Terraform Format
        run: terraform fmt -check -recursive
      
      - name: Terraform Init
        run: terraform init
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      
      - name: Terraform Validate
        run: terraform validate
      
      - name: Terraform Plan
        run: terraform plan -no-color
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        run: terraform apply -auto-approve
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

### 2. GitLab CI
```yaml
# .gitlab-ci.yml
image:
  name: hashicorp/terraform:1.5.0
  entrypoint: [""]

stages:
  - validate
  - plan
  - apply

before_script:
  - terraform init

validate:
  stage: validate
  script:
    - terraform fmt -check -recursive
    - terraform validate

plan:
  stage: plan
  script:
    - terraform plan -out=tfplan
  artifacts:
    paths:
      - tfplan

apply:
  stage: apply
  script:
    - terraform apply -auto-approve tfplan
  only:
    - main
  when: manual
```

## File Creation Workflow

When creating Terraform files:

1. **Create in `/home/claude` first** for development
2. **Use proper structure**:
```
   /home/claude/terraform-project/
   ├── main.tf
   ├── variables.tf
   ├── outputs.tf
   ├── versions.tf
   ├── backend.tf
   └── terraform.tfvars.example
```
3. **Initialize and validate**
4. **Format code with `terraform fmt`**
5. **Validate with `terraform validate`**
6. **Copy to `/mnt/user-data/outputs/`** for delivery

Example workflow:
```bash
# Create project structure
mkdir -p /home/claude/terraform-aws-vpc

# Create files
create_file /home/claude/terraform-aws-vpc/main.tf
create_file /home/claude/terraform-aws-vpc/variables.tf
create_file /home/claude/terraform-aws-vpc/outputs.tf
create_file /home/claude/terraform-aws-vpc/versions.tf

# Initialize
cd /home/claude/terraform-aws-vpc
terraform init

# Format
terraform fmt -recursive

# Validate
terraform validate

# Copy to outputs
cp -r /home/claude/terraform-aws-vpc /mnt/user-data/outputs/
```

## Common Terraform Commands Reference
```bash
# Initialization
terraform init                    # Initialize working directory
terraform init -upgrade           # Upgrade providers to latest version
terraform init -reconfigure       # Reconfigure backend

# Planning
terraform plan                    # Preview changes
terraform plan -out=tfplan        # Save plan to file
terraform plan -destroy           # Plan destruction
terraform plan -target=resource   # Plan for specific resource

# Applying
terraform apply                   # Apply changes
terraform apply tfplan            # Apply saved plan
terraform apply -auto-approve     # Skip confirmation
terraform apply -var="key=value"  # Pass variable

# Destroying
terraform destroy                 # Destroy all resources
terraform destroy -auto-approve   # Skip confirmation
terraform destroy -target=resource # Destroy specific resource

# State management
terraform state list              # List resources in state
terraform state show resource     # Show resource details
terraform state mv src dest       # Move resource in state
terraform state rm resource       # Remove resource from state
terraform state pull              # Pull remote state
terraform state push              # Push local state

# Workspace
terraform workspace list          # List workspaces
terraform workspace new name      # Create workspace
terraform workspace select name   # Switch workspace
terraform workspace delete name   # Delete workspace

# Import
terraform import resource id      # Import existing resource

# Output
terraform output                  # Show all outputs
terraform output name             # Show specific output
terraform output -json            # JSON format

# Misc
terraform fmt                     # Format code
terraform fmt -check              # Check formatting
terraform validate                # Validate configuration
terraform show                    # Show current state
terraform version                 # Show version
terraform providers               # Show required providers
terraform graph                   # Generate dependency graph
```

## Security Best Practices
```hcl
# ✅ Always encrypt sensitive data
resource "aws_db_instance" "main" {
  storage_encrypted = true
  # ... other config
}

# ✅ Use secrets management
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}

resource "aws_db_instance" "main" {
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
  # ... other config
}

# ✅ Enable MFA delete for important buckets
resource "aws_s3_bucket" "important" {
  # Enable in AWS Console: MFA delete can only be enabled by root account
}

# ✅ Use least privilege IAM policies
resource "aws_iam_role_policy" "lambda" {
  name = "lambda-policy"
  role = aws_iam_role.lambda.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# ❌ Never commit sensitive data
# ❌ Never use default passwords
# ❌ Never make resources publicly accessible unless required
```

## Resources

- Official Documentation: https://www.terraform.io/docs
- Terraform Registry: https://registry.terraform.io
- AWS Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- Best Practices Guide: https://www.terraform-best-practices.com
- HashiCorp Learn: https://learn.hashicorp.com/terraform

---

**Remember:** Terraform is about declarative infrastructure - describe what you want, not how to get there. Always plan before applying, version your modules, use remote state for teams, and treat infrastructure as code with proper version control and testing practices.
