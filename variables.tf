## GLOBAL VAR CONFIGURATION
variable "aws_region" {
  description = "Region for the VPC"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = []
  # default = [
  #   "777777777777",
  #   "888888888888",
  # ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = []
  # default = [
  #   {
  #     rolearn  = "arn:aws:iam::66666666666:role/role1"
  #     username = "role1"
  #     groups   = ["system:masters"]
  #   },
  # ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = []
  # default = [
  #   {
  #     userarn  = "arn:aws:iam::66666666666:user/user1"
  #     username = "user1"
  #     groups   = ["system:masters"]
  #   },
  #   {
  #     userarn  = "arn:aws:iam::66666666666:user/user2"
  #     username = "user2"
  #     groups   = ["system:masters"]
  #   },
  # ]
}

variable "eks_managed_node_groups" {
  description = "Override default 'single nodegroup, on a private subnet' with more advaned configuration archetypes"
  default     = null
  type        = any
  # type = list(object({
  #   name                   = string
  #   desired_capacity       = number
  #   max_capacity           = number
  #   min_capacity           = number
  #   instance_type          = string
  #   ami_type               = optional(string)
  #   key_name               = optional(string)
  #   public_ip              = optional(bool)
  #   create_launch_template = bool
  #   disk_size              = number
  #   disk_encrypted         = optional(bool)
  #   capacity_type          = optional(string)
  #   taints = optional(list(object({
  #     key            = string
  #     value          = string
  #     effect         = string
  #     affinity_label = bool
  #   })))
  #   subnet_selections = object({
  #     public  = bool
  #     private = bool
  #   })
  #   tags = optional(any)
  # }))
}

variable "cluster_root_domain" {
  description = "Domain root where all kubernetes systems are orchestrating control"
  type = object({
    create = optional(bool)
    name   = string
  })
}

variable "app_name" {
  description = "Application Name"
  default     = "eks"
}

variable "app_namespace" {
  description = "Tagged App Namespace"
}

variable "tfenv" {
  description = "Environment"
}

variable "cluster_name" {
  description = "Optional override for cluster name instead of standard {name}-{namespace}-{env}"
  default     = ""
}

variable "cluster_version" {
  description = "Kubernetes Cluster Version"
  default     = "1.21"
}

variable "instance_type" {
  # Standard Types (M | L | XL | XXL): m5.large | c5.xlarge | t3a.2xlarge | m5a.2xlarge
  description = "AWS Instance Type for provisioning"
  default     = "c5a.large"
}

variable "instance_desired_size" {
  description = "Count of instances to be spun up within the context of a kubernetes cluster. Minimum: 2"
  default     = 8
}

variable "instance_min_size" {
  description = "Count of instances to be spun up within the context of a kubernetes cluster. Minimum: 2"
  default     = 2
}

variable "instance_max_size" {
  description = "Count of instances to be spun up within the context of a kubernetes cluster. Minimum: 2"
  default     = 12
}

variable "billingcustomer" {
  description = "Which BILLINGCUSTOMER is setup in AWS"
}

variable "root_vol_size" {
  description = "Root Volume Size"
  default     = "50"
}

variable "node_key_name" {
  description = "EKS Node Key Name"
  default     = ""
}

variable "node_public_ip" {
  description = "assign public ip on the nodes"
  default     = false
}

variable "vpc_flow_logs" {
  description = "Manually enable or disable VPC flow logs; Please note, for production, these are enabled by default otherwise they will be disabled; setting a value for this object will override all defaults regardless of environment"
  ## TODO: BUG - Seems that defining optional variables messes up the "try" terraform function logic so it needs to be removed altogether to function correctly
  # type = object({
  #   enabled = optional(bool)
  # })
  default = {}
}

variable "nat_gateway_custom_configuration" {
  description = "Override the default NAT Gateway configuration, which configures a single NAT gateway for non-prod, while one per AZ on tfenv=prod"
  type = object({
    enabled                           = bool
    enable_nat_gateway                = bool
    enable_dns_hostnames              = bool
    single_nat_gateway                = bool
    one_nat_gateway_per_az            = bool
    enable_vpn_gateway                = bool
    propagate_public_route_tables_vgw = bool
  })
  default = {
    enable_dns_hostnames              = true
    enable_nat_gateway                = true
    enable_vpn_gateway                = false
    enabled                           = false
    one_nat_gateway_per_az            = true
    propagate_public_route_tables_vgw = false
    single_nat_gateway                = false
  }
}

variable "helm_installations" {
  type = object({
    dashboard     = bool
    gitlab_runner = bool
    vault_consul  = bool
    ingress       = bool
    elasticstack  = bool
    grafana       = bool
    argocd        = bool
  })
  default = {
    dashboard     = true
    gitlab_runner = false
    vault_consul  = true
    ingress       = true
    elasticstack  = false
    grafana       = true
    argocd        = false
  }
}

variable "helm_configurations" {
  type = object({
    dashboard     = optional(string)
    gitlab_runner = optional(string)
    vault_consul  = optional(string)
    ingress       = optional(string)
    elasticstack  = optional(string)
    grafana       = optional(string)
    argocd        = optional(string)
  })
  default = {
    dashboard     = null
    gitlab_runner = null
    vault_consul  = null
    ingress       = null
    elasticstack  = null
    grafana       = null
    argocd        = null
  }
}

variable "custom_namespaces" {
  description = "Adding namespaces to a default cluster provisioning process"
  type        = list(string)
  default     = []
}

variable "vpc_subnet_configuration" {
  type = object({
    base_cidr           = string
    subnet_bit_interval = number
    autogenerate        = optional(bool)
  })
  description = "Configure VPC CIDR and relative subnet intervals for generating a VPC. If not specified, default values will be generated."
  default = {
    base_cidr           = "172.%s.0.0/16"
    subnet_bit_interval = 4
    autogenerate        = true
  }
}

variable "enable_aws_vault_unseal" {
  description = "If Vault is enabled and deployed, by default, the unseal process is manual; Changing this to true allows for automatic unseal using AWS KMS"
  default     = false
}

variable "google_clientID" {
  description = "Used for Infrastructure OAuth: Google Auth Client ID"
}

variable "google_clientSecret" {
  description = "Used for Infrastructure OAuth: Google Auth Client Secret"
}

variable "google_authDomain" {
  description = "Used for Infrastructure OAuth: Google Auth Domain"
}

variable "create_launch_template" {
  description = "enable launch template on node group"
  default     = false
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "If the cluster endpoint is to be exposed to the public internet, specify CIDRs here that it should be restricted to"
  type        = list(string)
  default     = []
}

variable "vault_nodeselector" {
  default = ""
}

## TODO: Merge all the default node_group configurations together
variable "default_ami_type" {
  description = "Default AMI used for node provisioning"
  default     = "AL2_x86_64"
}

variable "default_capacity_type" {
  description = "Default capacity configuraiton used for node provisioning. Valid values: `ON_DEMAND, SPOT`"
  default     = "ON_DEMAND"
}