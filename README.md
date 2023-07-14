# Altana Code Challenge

## Instructions

> Using Terraform Configuration Language, or one of the Terraform CDK languages, create a workspace for AWS with the following resources:
>
> - A **VPC** with a [**10.0.0.0/16**](http://10.0.0.0/16) CIDR, **DNS support**, an **Internet Gateway**, and **NAT Gateways** for 3 availability zones
> - 3 **/24** private **subnets** associated with the above **NAT Gateways**
> - A single **EKS cluster** in all subnets, with public endpoint access enabled
> - AWS Load Balancer controller with **Public-facing ALB**
>
> Additionally, we'll want to deploy an application to the EKS Cluster. Using Terraform, Helm, or another templating tool, please write a script that produces **Kubernetes manifests** to deploy the following:
>
> - A **Deployment** named **search-api** running a bare **nginx** container, a corresponding **Service** targeted to port 80, and a corresponding **Ingress** for host [**search.altana.ai**](http://search.altana.ai/)
> - A **Deployment** named **graph-api** running a bare **nginx** container, a corresponding **Service** targeted to port 80, and a corresponding **Ingress** for host [**graph.altana.ai**](http://graph.altana.ai/)



## First Attempt

**Thought Process**

I started with a terraform solution from scratch where I attempted to follow the instructions and code out the associated module in the HashiCorp AWS terraform provider documentation here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs



I was successful in creating my VPC with DNS support, an Internet Gateway, NAT Gateways for each availability zone, my subnets, and a single EKS Cluster with public endpoint access enabled. The part that was not working was adding the EKS Node Group. Worker nodes were being created in EC2, however, they were not actually joining the EKS Cluster with failure: *["Create failed": Instances failed to join the kubernetes cluster]*.



I was also a bit confused how to implement with the AWS Load Balancer. I decided instead to try another solution after some Google research (see [Second Attempt](#second-attempt)).



My terraform plan for resources associated with this attempt are shown below. 



**Terraform Plan**

> Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
> following symbols:
>
> - create
>   <= read (data resources)
>
> Terraform will perform the following actions:
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_eks_cluster.data.aws_iam_policy_document.assume_role will be read during apply
>
> # (depends on a resource or a module with changes pending)
>
>  <= data "aws_iam_policy_document" "assume_role" {
>
> ```
>   + id   = (known after apply)
>   + json = (known after apply)
>
>   + statement {
>       + actions = [
>           + "sts:AssumeRole",
>         ]
>       + effect  = "Allow"
>
>       + principals {
>           + identifiers = [
>               + "eks.amazonaws.com",
>             ]
>           + type        = "Service"
>         }
>     }
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_eks_cluster.aws_eks_cluster.selected will be created
>
> - resource "aws_eks_cluster" "selected" {
>   - arn                   = (known after apply)
>   - certificate_authority = (known after apply)
>   - cluster_id            = (known after apply)
>   - created_at            = (known after apply)
>   - endpoint              = (known after apply)
>   - id                    = (known after apply)
>   - identity              = (known after apply)
>   - name                  = "altana-codetest-eks_cluster"
>   - platform_version      = (known after apply)
>   - role_arn              = (known after apply)
>   - status                = (known after apply)
>   - tags                  = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-eks_cluster"
>     - "Terraform"   = "true"
>       }
>   - tags_all              = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-eks_cluster"
>     - "Terraform"   = "true"
>       }
>   - version               = "1.27"
>   - vpc_config {
>     - cluster_security_group_id = (known after apply)
>     - endpoint_private_access   = true
>     - endpoint_public_access    = true
>     - public_access_cidrs       = (known after apply)
>     - subnet_ids                = (known after apply)
>     - vpc_id                    = (known after apply)
>       }
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_eks_cluster.aws_iam_role.example will be created
>
> - resource "aws_iam_role" "example" {
>   - arn                   = (known after apply)
>   - assume_role_policy    = (known after apply)
>   - create_date           = (known after apply)
>   - force_detach_policies = false
>   - id                    = (known after apply)
>   - managed_policy_arns   = (known after apply)
>   - max_session_duration  = 3600
>   - name                  = "eks-cluster-example"
>   - name_prefix           = (known after apply)
>   - path                  = "/"
>   - role_last_used        = (known after apply)
>   - tags_all              = (known after apply)
>   - unique_id             = (known after apply)
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_eks_cluster.aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy will be created
>
> - resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
>   - role       = "eks-cluster-example"
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_eks_cluster.aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController will be created
>
> - resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
>   - role       = "eks-cluster-example"
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_eks_node_group.aws_eks_node_group.selected will be created
>
> - resource "aws_eks_node_group" "selected" {
>   - ami_type               = (known after apply)
>   - arn                    = (known after apply)
>   - capacity_type          = (known after apply)
>   - cluster_name           = "altana-codetest-eks_cluster"
>   - disk_size              = (known after apply)
>   - id                     = (known after apply)
>   - instance_types         = (known after apply)
>   - node_group_name        = "altana-codetest-eks_node_group"
>   - node_group_name_prefix = (known after apply)
>   - node_role_arn          = (known after apply)
>   - release_version        = (known after apply)
>   - resources              = (known after apply)
>   - status                 = (known after apply)
>   - subnet_ids             = (known after apply)
>   - tags_all               = (known after apply)
>   - version                = (known after apply)
>   - scaling_config {
>     - desired_size = 1
>     - max_size     = 2
>     - min_size     = 1
>       }
>   - update_config {
>     - max_unavailable = 1
>       }
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_eks_node_group.aws_iam_role.example will be created
>
> - resource "aws_iam_role" "example" {
>
>   - arn                   = (known after apply)
>
>   - assume_role_policy    = jsonencode(
>
>     ```
>     {
>       + Statement = [
>           + {
>               + Action    = "sts:AssumeRole"
>               + Effect    = "Allow"
>               + Principal = {
>                   + Service = "ec2.amazonaws.com"
>                 }
>             },
>         ]
>       + Version   = "2012-10-17"
>     }
>     ```
>
>     )
>
>   - create_date           = (known after apply)
>
>   - force_detach_policies = false
>
>   - id                    = (known after apply)
>
>   - managed_policy_arns   = (known after apply)
>
>   - max_session_duration  = 3600
>
>   - name                  = "eks-node-group-example"
>
>   - name_prefix           = (known after apply)
>
>   - path                  = "/"
>
>   - role_last_used        = (known after apply)
>
>   - tags_all              = (known after apply)
>
>   - unique_id             = (known after apply)
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_eks_node_group.aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly will be created
>
> - resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
>   - role       = "eks-node-group-example"
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_eks_node_group.aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy will be created
>
> - resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
>   - role       = "eks-node-group-example"
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_eks_node_group.aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy will be created
>
> - resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
>   - role       = "eks-node-group-example"
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_internet_gateway.aws_internet_gateway.selected will be created
>
> - resource "aws_internet_gateway" "selected" {
>   - arn      = (known after apply)
>   - id       = (known after apply)
>   - owner_id = (known after apply)
>   - tags     = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-internet_gateway"
>     - "Terraform"   = "true"
>       }
>   - tags_all = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-internet_gateway"
>     - "Terraform"   = "true"
>       }
>   - vpc_id   = (known after apply)
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_nat_gateway.aws_nat_gateway.selected[0] will be created
>
> - resource "aws_nat_gateway" "selected" {
>   - allocation_id        = (known after apply)
>   - association_id       = (known after apply)
>   - connectivity_type    = "public"
>   - id                   = (known after apply)
>   - network_interface_id = (known after apply)
>   - private_ip           = (known after apply)
>   - public_ip            = (known after apply)
>   - subnet_id            = (known after apply)
>   - tags                 = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-nat_gateway"
>     - "Terraform"   = "true"
>       }
>   - tags_all             = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-nat_gateway"
>     - "Terraform"   = "true"
>       }
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_nat_gateway.aws_nat_gateway.selected[1] will be created
>
> - resource "aws_nat_gateway" "selected" {
>   - allocation_id        = (known after apply)
>   - association_id       = (known after apply)
>   - connectivity_type    = "public"
>   - id                   = (known after apply)
>   - network_interface_id = (known after apply)
>   - private_ip           = (known after apply)
>   - public_ip            = (known after apply)
>   - subnet_id            = (known after apply)
>   - tags                 = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-nat_gateway"
>     - "Terraform"   = "true"
>       }
>   - tags_all             = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-nat_gateway"
>     - "Terraform"   = "true"
>       }
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_nat_gateway.aws_nat_gateway.selected[2] will be created
>
> - resource "aws_nat_gateway" "selected" {
>   - allocation_id        = (known after apply)
>   - association_id       = (known after apply)
>   - connectivity_type    = "public"
>   - id                   = (known after apply)
>   - network_interface_id = (known after apply)
>   - private_ip           = (known after apply)
>   - public_ip            = (known after apply)
>   - subnet_id            = (known after apply)
>   - tags                 = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-nat_gateway"
>     - "Terraform"   = "true"
>       }
>   - tags_all             = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-nat_gateway"
>     - "Terraform"   = "true"
>       }
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_vpc.aws_vpc.selected will be created
>
> - resource "aws_vpc" "selected" {
>   - arn                                  = (known after apply)
>   - cidr_block                           = "10.0.0.0/16"
>   - default_network_acl_id               = (known after apply)
>   - default_route_table_id               = (known after apply)
>   - default_security_group_id            = (known after apply)
>   - dhcp_options_id                      = (known after apply)
>   - enable_classiclink                   = (known after apply)
>   - enable_classiclink_dns_support       = (known after apply)
>   - enable_dns_hostnames                 = true
>   - enable_dns_support                   = true
>   - enable_network_address_usage_metrics = (known after apply)
>   - id                                   = (known after apply)
>   - instance_tenancy                     = "default"
>   - ipv6_association_id                  = (known after apply)
>   - ipv6_cidr_block                      = (known after apply)
>   - ipv6_cidr_block_network_border_group = (known after apply)
>   - main_route_table_id                  = (known after apply)
>   - owner_id                             = (known after apply)
>   - tags                                 = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-vpc"
>     - "Terraform"   = "true"
>       }
>   - tags_all                             = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-vpc"
>     - "Terraform"   = "true"
>       }
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_nat_gateway.module.eip[0].aws_eip.selected will be created
>
> - resource "aws_eip" "selected" {
>   - allocation_id        = (known after apply)
>   - association_id       = (known after apply)
>   - carrier_ip           = (known after apply)
>   - customer_owned_ip    = (known after apply)
>   - domain               = (known after apply)
>   - id                   = (known after apply)
>   - instance             = (known after apply)
>   - network_border_group = (known after apply)
>   - network_interface    = (known after apply)
>   - private_dns          = (known after apply)
>   - private_ip           = (known after apply)
>   - public_dns           = (known after apply)
>   - public_ip            = (known after apply)
>   - public_ipv4_pool     = (known after apply)
>   - tags                 = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-eip-ac1"
>     - "Terraform"   = "true"
>       }
>   - tags_all             = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-eip-ac1"
>     - "Terraform"   = "true"
>       }
>   - vpc                  = (known after apply)
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_nat_gateway.module.eip[1].aws_eip.selected will be created
>
> - resource "aws_eip" "selected" {
>   - allocation_id        = (known after apply)
>   - association_id       = (known after apply)
>   - carrier_ip           = (known after apply)
>   - customer_owned_ip    = (known after apply)
>   - domain               = (known after apply)
>   - id                   = (known after apply)
>   - instance             = (known after apply)
>   - network_border_group = (known after apply)
>   - network_interface    = (known after apply)
>   - private_dns          = (known after apply)
>   - private_ip           = (known after apply)
>   - public_dns           = (known after apply)
>   - public_ip            = (known after apply)
>   - public_ipv4_pool     = (known after apply)
>   - tags                 = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-eip-ac2"
>     - "Terraform"   = "true"
>       }
>   - tags_all             = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-eip-ac2"
>     - "Terraform"   = "true"
>       }
>   - vpc                  = (known after apply)
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_nat_gateway.module.eip[2].aws_eip.selected will be created
>
> - resource "aws_eip" "selected" {
>   - allocation_id        = (known after apply)
>   - association_id       = (known after apply)
>   - carrier_ip           = (known after apply)
>   - customer_owned_ip    = (known after apply)
>   - domain               = (known after apply)
>   - id                   = (known after apply)
>   - instance             = (known after apply)
>   - network_border_group = (known after apply)
>   - network_interface    = (known after apply)
>   - private_dns          = (known after apply)
>   - private_ip           = (known after apply)
>   - public_dns           = (known after apply)
>   - public_ip            = (known after apply)
>   - public_ipv4_pool     = (known after apply)
>   - tags                 = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-eip-ac3"
>     - "Terraform"   = "true"
>       }
>   - tags_all             = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-eip-ac3"
>     - "Terraform"   = "true"
>       }
>   - vpc                  = (known after apply)
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_nat_gateway.module.subnet[0].aws_subnet.selected will be created
>
> - resource "aws_subnet" "selected" {
>   - arn                                            = (known after apply)
>   - assign_ipv6_address_on_creation                = false
>   - availability_zone                              = "us-east-1a"
>   - availability_zone_id                           = (known after apply)
>   - cidr_block                                     = "10.0.1.0/24"
>   - enable_dns64                                   = false
>   - enable_resource_name_dns_a_record_on_launch    = false
>   - enable_resource_name_dns_aaaa_record_on_launch = false
>   - id                                             = (known after apply)
>   - ipv6_cidr_block_association_id                 = (known after apply)
>   - ipv6_native                                    = false
>   - map_public_ip_on_launch                        = false
>   - owner_id                                       = (known after apply)
>   - private_dns_hostname_type_on_launch            = (known after apply)
>   - tags                                           = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-subnet-ac1"
>     - "Terraform"   = "true"
>       }
>   - tags_all                                       = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-subnet-ac1"
>     - "Terraform"   = "true"
>       }
>   - vpc_id                                         = (known after apply)
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_nat_gateway.module.subnet[1].aws_subnet.selected will be created
>
> - resource "aws_subnet" "selected" {
>   - arn                                            = (known after apply)
>   - assign_ipv6_address_on_creation                = false
>   - availability_zone                              = "us-east-1b"
>   - availability_zone_id                           = (known after apply)
>   - cidr_block                                     = "10.0.2.0/24"
>   - enable_dns64                                   = false
>   - enable_resource_name_dns_a_record_on_launch    = false
>   - enable_resource_name_dns_aaaa_record_on_launch = false
>   - id                                             = (known after apply)
>   - ipv6_cidr_block_association_id                 = (known after apply)
>   - ipv6_native                                    = false
>   - map_public_ip_on_launch                        = false
>   - owner_id                                       = (known after apply)
>   - private_dns_hostname_type_on_launch            = (known after apply)
>   - tags                                           = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-subnet-ac2"
>     - "Terraform"   = "true"
>       }
>   - tags_all                                       = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-subnet-ac2"
>     - "Terraform"   = "true"
>       }
>   - vpc_id                                         = (known after apply)
>
> ```
> }
> ```
>
> # module.test_kubernetes_cluster_resources.module.kubernetes_nat_gateway.module.subnet[2].aws_subnet.selected will be created
>
> - resource "aws_subnet" "selected" {
>   - arn                                            = (known after apply)
>   - assign_ipv6_address_on_creation                = false
>   - availability_zone                              = "us-east-1c"
>   - availability_zone_id                           = (known after apply)
>   - cidr_block                                     = "10.0.3.0/24"
>   - enable_dns64                                   = false
>   - enable_resource_name_dns_a_record_on_launch    = false
>   - enable_resource_name_dns_aaaa_record_on_launch = false
>   - id                                             = (known after apply)
>   - ipv6_cidr_block_association_id                 = (known after apply)
>   - ipv6_native                                    = false
>   - map_public_ip_on_launch                        = false
>   - owner_id                                       = (known after apply)
>   - private_dns_hostname_type_on_launch            = (known after apply)
>   - tags                                           = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-subnet-ac3"
>     - "Terraform"   = "true"
>       }
>   - tags_all                                       = {
>     - "Application" = "altana-codetest"
>     - "Env"         = "dev"
>     - "Name"        = "altana-codetest-subnet-ac3"
>     - "Terraform"   = "true"
>       }
>   - vpc_id                                         = (known after apply)
>
> ```
> }
> ```
>
> Plan: 20 to add, 0 to change, 0 to destroy.
>
> ───────────────────────────────────────────────────────────────────



## Second Attempt

**Thought Process**

With this attempt, I found a pre-built module during my research here: https://github.com/hashicorp/learn-terraform-provision-eks-cluster that actually satisfied most of the requirements of the instructions. I modified some resource names and was able to apply this terraform configuration with a successful buildout. From there, I was able to use the AWS command-line utility to apply my application configurations.



I still wasn't sure about the AWS Load Balancer, but I had a thought to maybe apply the controller as an add-on to the cluster following this documentation guide: https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html, however, I didn't have time to actually test and document performing these steps. 



Clearly, there's a difference between the working attempt and the non-working attempt.. as there is a resource delta of 37 resources (20 in first attempt, 57 in second attempt). I guess my next steps would be to determine the difference between the implementations and attempt to implement the resources I missed if I were to continue down the path of creating my own custom module.



My terraform plan for resources associated with this attempt are shown below. 



**Terraform Plan**

> Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
> following symbols:
>
> - create
>   <= read (data resources)
>
> Terraform will perform the following actions:
>
> # aws_eks_addon.ebs-csi will be created
>
> - resource "aws_eks_addon" "ebs-csi" {
>   - addon_name               = "aws-ebs-csi-driver"
>   - addon_version            = "v1.20.0-eksbuild.1"
>   - arn                      = (known after apply)
>   - cluster_name             = "altana-codetest-eks"
>   - configuration_values     = (known after apply)
>   - created_at               = (known after apply)
>   - id                       = (known after apply)
>   - modified_at              = (known after apply)
>   - service_account_role_arn = (known after apply)
>   - tags                     = {
>     - "eks_addon" = "ebs-csi"
>     - "terraform" = "true"
>       }
>   - tags_all                 = {
>     - "eks_addon" = "ebs-csi"
>     - "terraform" = "true"
>       }
>
> ```
> }
> ```
>
> # module.eks.data.tls_certificate.this[0] will be read during apply
>
> # (config refers to values not yet known)
>
>  <= data "tls_certificate" "this" {
>
> ```
>   + certificates = (known after apply)
>   + id           = (known after apply)
>   + url          = (known after apply)
> }
> ```
>
> # module.eks.aws_cloudwatch_log_group.this[0] will be created
>
> - resource "aws_cloudwatch_log_group" "this" {
>   - arn               = (known after apply)
>   - id                = (known after apply)
>   - name              = "/aws/eks/altana-codetest-eks/cluster"
>   - name_prefix       = (known after apply)
>   - retention_in_days = 90
>   - skip_destroy      = false
>   - tags_all          = (known after apply)
>
> ```
> }
> ```
>
> # module.eks.aws_eks_cluster.this[0] will be created
>
> - resource "aws_eks_cluster" "this" {
>   - arn                       = (known after apply)
>   - certificate_authority     = (known after apply)
>   - cluster_id                = (known after apply)
>   - created_at                = (known after apply)
>   - enabled_cluster_log_types = [
>     - "api",
>     - "audit",
>     - "authenticator",
>       ]
>   - endpoint                  = (known after apply)
>   - id                        = (known after apply)
>   - identity                  = (known after apply)
>   - name                      = "altana-codetest-eks"
>   - platform_version          = (known after apply)
>   - role_arn                  = (known after apply)
>   - status                    = (known after apply)
>   - tags_all                  = (known after apply)
>   - version                   = "1.27"
>   - encryption_config {
>     - resources = [
>       - "secrets",
>         ]
>     - provider {
>       - key_arn = (known after apply)
>         }
>         }
>   - kubernetes_network_config {
>     - ip_family         = (known after apply)
>     - service_ipv4_cidr = (known after apply)
>     - service_ipv6_cidr = (known after apply)
>       }
>   - timeouts {}
>   - vpc_config {
>     - cluster_security_group_id = (known after apply)
>     - endpoint_private_access   = true
>     - endpoint_public_access    = true
>     - public_access_cidrs       = [
>       - "0.0.0.0/0",
>         ]
>     - security_group_ids        = (known after apply)
>     - subnet_ids                = (known after apply)
>     - vpc_id                    = (known after apply)
>       }
>
> ```
> }
> ```
>
> # module.eks.aws_iam_openid_connect_provider.oidc_provider[0] will be created
>
> - resource "aws_iam_openid_connect_provider" "oidc_provider" {
>   - arn             = (known after apply)
>   - client_id_list  = [
>     - "sts.amazonaws.com",
>       ]
>   - id              = (known after apply)
>   - tags            = {
>     - "Name" = "altana-codetest-eks-eks-irsa"
>       }
>   - tags_all        = {
>     - "Name" = "altana-codetest-eks-eks-irsa"
>       }
>   - thumbprint_list = (known after apply)
>   - url             = (known after apply)
>
> ```
> }
> ```
>
> # module.eks.aws_iam_policy.cluster_encryption[0] will be created
>
> - resource "aws_iam_policy" "cluster_encryption" {
>   - arn         = (known after apply)
>   - description = "Cluster encryption policy to allow cluster role to utilize CMK provided"
>   - id          = (known after apply)
>   - name        = (known after apply)
>   - name_prefix = "altana-codetest-eks-cluster-ClusterEncryption"
>   - path        = "/"
>   - policy      = (known after apply)
>   - policy_id   = (known after apply)
>   - tags_all    = (known after apply)
>
> ```
> }
> ```
>
> # module.eks.aws_iam_role.this[0] will be created
>
> - resource "aws_iam_role" "this" {
>
>   - arn                   = (known after apply)
>
>   - assume_role_policy    = jsonencode(
>
>     ```
>     {
>       + Statement = [
>           + {
>               + Action    = "sts:AssumeRole"
>               + Effect    = "Allow"
>               + Principal = {
>                   + Service = "eks.amazonaws.com"
>                 }
>               + Sid       = "EKSClusterAssumeRole"
>             },
>         ]
>       + Version   = "2012-10-17"
>     }
>     ```
>
>     )
>
>   - create_date           = (known after apply)
>
>   - force_detach_policies = true
>
>   - id                    = (known after apply)
>
>   - managed_policy_arns   = (known after apply)
>
>   - max_session_duration  = 3600
>
>   - name                  = (known after apply)
>
>   - name_prefix           = "altana-codetest-eks-cluster-"
>
>   - path                  = "/"
>
>   - tags_all              = (known after apply)
>
>   - unique_id             = (known after apply)
>
>   - inline_policy {
>
>     - name   = "altana-codetest-eks-cluster"
>
>     - policy = jsonencode(
>
>       ```
>       {
>         + Statement = [
>             + {
>                 + Action   = [
>                     + "logs:CreateLogGroup",
>                   ]
>                 + Effect   = "Deny"
>                 + Resource = "*"
>               },
>           ]
>         + Version   = "2012-10-17"
>       }
>       ```
>
>       )
>       }
>
> ```
> }
>
> ```
>
> # module.eks.aws_iam_role_policy_attachment.cluster_encryption[0] will be created
>
> - resource "aws_iam_role_policy_attachment" "cluster_encryption" {
>   - id         = (known after apply)
>   - policy_arn = (known after apply)
>   - role       = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.aws_iam_role_policy_attachment.this["AmazonEKSClusterPolicy"] will be created
>
> - resource "aws_iam_role_policy_attachment" "this" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
>   - role       = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.aws_iam_role_policy_attachment.this["AmazonEKSVPCResourceController"] will be created
>
> - resource "aws_iam_role_policy_attachment" "this" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
>   - role       = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group.cluster[0] will be created
>
> - resource "aws_security_group" "cluster" {
>   - arn                    = (known after apply)
>   - description            = "EKS cluster security group"
>   - egress                 = (known after apply)
>   - id                     = (known after apply)
>   - ingress                = (known after apply)
>   - name                   = (known after apply)
>   - name_prefix            = "altana-codetest-eks-cluster-"
>   - owner_id               = (known after apply)
>   - revoke_rules_on_delete = false
>   - tags                   = {
>     - "Name" = "altana-codetest-eks-cluster"
>       }
>   - tags_all               = {
>     - "Name" = "altana-codetest-eks-cluster"
>       }
>   - vpc_id                 = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group.node[0] will be created
>
> - resource "aws_security_group" "node" {
>   - arn                    = (known after apply)
>   - description            = "EKS node shared security group"
>   - egress                 = (known after apply)
>   - id                     = (known after apply)
>   - ingress                = (known after apply)
>   - name                   = (known after apply)
>   - name_prefix            = "altana-codetest-eks-node-"
>   - owner_id               = (known after apply)
>   - revoke_rules_on_delete = false
>   - tags                   = {
>     - "Name"                                      = "altana-codetest-eks-node"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "owned"
>       }
>   - tags_all               = {
>     - "Name"                                      = "altana-codetest-eks-node"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "owned"
>       }
>   - vpc_id                 = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group_rule.cluster["ingress_nodes_443"] will be created
>
> - resource "aws_security_group_rule" "cluster" {
>   - description              = "Node groups to cluster API"
>   - from_port                = 443
>   - id                       = (known after apply)
>   - protocol                 = "tcp"
>   - security_group_id        = (known after apply)
>   - security_group_rule_id   = (known after apply)
>   - self                     = false
>   - source_security_group_id = (known after apply)
>   - to_port                  = 443
>   - type                     = "ingress"
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group_rule.node["egress_all"] will be created
>
> - resource "aws_security_group_rule" "node" {
>   - cidr_blocks              = [
>     - "0.0.0.0/0",
>       ]
>   - description              = "Allow all egress"
>   - from_port                = 0
>   - id                       = (known after apply)
>   - prefix_list_ids          = []
>   - protocol                 = "-1"
>   - security_group_id        = (known after apply)
>   - security_group_rule_id   = (known after apply)
>   - self                     = false
>   - source_security_group_id = (known after apply)
>   - to_port                  = 0
>   - type                     = "egress"
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group_rule.node["ingress_cluster_443"] will be created
>
> - resource "aws_security_group_rule" "node" {
>   - description              = "Cluster API to node groups"
>   - from_port                = 443
>   - id                       = (known after apply)
>   - prefix_list_ids          = []
>   - protocol                 = "tcp"
>   - security_group_id        = (known after apply)
>   - security_group_rule_id   = (known after apply)
>   - self                     = false
>   - source_security_group_id = (known after apply)
>   - to_port                  = 443
>   - type                     = "ingress"
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group_rule.node["ingress_cluster_4443_webhook"] will be created
>
> - resource "aws_security_group_rule" "node" {
>   - description              = "Cluster API to node 4443/tcp webhook"
>   - from_port                = 4443
>   - id                       = (known after apply)
>   - prefix_list_ids          = []
>   - protocol                 = "tcp"
>   - security_group_id        = (known after apply)
>   - security_group_rule_id   = (known after apply)
>   - self                     = false
>   - source_security_group_id = (known after apply)
>   - to_port                  = 4443
>   - type                     = "ingress"
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group_rule.node["ingress_cluster_8443_webhook"] will be created
>
> - resource "aws_security_group_rule" "node" {
>   - description              = "Cluster API to node 8443/tcp webhook"
>   - from_port                = 8443
>   - id                       = (known after apply)
>   - prefix_list_ids          = []
>   - protocol                 = "tcp"
>   - security_group_id        = (known after apply)
>   - security_group_rule_id   = (known after apply)
>   - self                     = false
>   - source_security_group_id = (known after apply)
>   - to_port                  = 8443
>   - type                     = "ingress"
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group_rule.node["ingress_cluster_9443_webhook"] will be created
>
> - resource "aws_security_group_rule" "node" {
>   - description              = "Cluster API to node 9443/tcp webhook"
>   - from_port                = 9443
>   - id                       = (known after apply)
>   - prefix_list_ids          = []
>   - protocol                 = "tcp"
>   - security_group_id        = (known after apply)
>   - security_group_rule_id   = (known after apply)
>   - self                     = false
>   - source_security_group_id = (known after apply)
>   - to_port                  = 9443
>   - type                     = "ingress"
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group_rule.node["ingress_cluster_kubelet"] will be created
>
> - resource "aws_security_group_rule" "node" {
>   - description              = "Cluster API to node kubelets"
>   - from_port                = 10250
>   - id                       = (known after apply)
>   - prefix_list_ids          = []
>   - protocol                 = "tcp"
>   - security_group_id        = (known after apply)
>   - security_group_rule_id   = (known after apply)
>   - self                     = false
>   - source_security_group_id = (known after apply)
>   - to_port                  = 10250
>   - type                     = "ingress"
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group_rule.node["ingress_nodes_ephemeral"] will be created
>
> - resource "aws_security_group_rule" "node" {
>   - description              = "Node to node ingress on ephemeral ports"
>   - from_port                = 1025
>   - id                       = (known after apply)
>   - prefix_list_ids          = []
>   - protocol                 = "tcp"
>   - security_group_id        = (known after apply)
>   - security_group_rule_id   = (known after apply)
>   - self                     = true
>   - source_security_group_id = (known after apply)
>   - to_port                  = 65535
>   - type                     = "ingress"
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group_rule.node["ingress_self_coredns_tcp"] will be created
>
> - resource "aws_security_group_rule" "node" {
>   - description              = "Node to node CoreDNS"
>   - from_port                = 53
>   - id                       = (known after apply)
>   - prefix_list_ids          = []
>   - protocol                 = "tcp"
>   - security_group_id        = (known after apply)
>   - security_group_rule_id   = (known after apply)
>   - self                     = true
>   - source_security_group_id = (known after apply)
>   - to_port                  = 53
>   - type                     = "ingress"
>
> ```
> }
>
> ```
>
> # module.eks.aws_security_group_rule.node["ingress_self_coredns_udp"] will be created
>
> - resource "aws_security_group_rule" "node" {
>   - description              = "Node to node CoreDNS UDP"
>   - from_port                = 53
>   - id                       = (known after apply)
>   - prefix_list_ids          = []
>   - protocol                 = "udp"
>   - security_group_id        = (known after apply)
>   - security_group_rule_id   = (known after apply)
>   - self                     = true
>   - source_security_group_id = (known after apply)
>   - to_port                  = 53
>   - type                     = "ingress"
>
> ```
> }
>
> ```
>
> # module.irsa-ebs-csi.data.aws_iam_policy_document.assume_role_with_oidc[0] will be read during apply
>
> # (config refers to values not yet known)
>
>  <= data "aws_iam_policy_document" "assume_role_with_oidc" {
>
> ```
>   + id   = (known after apply)
>   + json = (known after apply)
> }
>
> ```
>
> # module.irsa-ebs-csi.aws_iam_role.this[0] will be created
>
> - resource "aws_iam_role" "this" {
>   - arn                   = (known after apply)
>   - assume_role_policy    = (known after apply)
>   - create_date           = (known after apply)
>   - force_detach_policies = false
>   - id                    = (known after apply)
>   - managed_policy_arns   = (known after apply)
>   - max_session_duration  = 3600
>   - name                  = "AmazonEKSTFEBSCSIRole-altana-codetest-eks"
>   - name_prefix           = (known after apply)
>   - path                  = "/"
>   - tags_all              = (known after apply)
>   - unique_id             = (known after apply)
>
> ```
> }
>
> ```
>
> # module.irsa-ebs-csi.aws_iam_role_policy_attachment.custom[0] will be created
>
> - resource "aws_iam_role_policy_attachment" "custom" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
>   - role       = "AmazonEKSTFEBSCSIRole-altana-codetest-eks"
>
> ```
> }
>
> ```
>
> # module.vpc.aws_eip.nat[0] will be created
>
> - resource "aws_eip" "nat" {
>   - allocation_id        = (known after apply)
>   - association_id       = (known after apply)
>   - carrier_ip           = (known after apply)
>   - customer_owned_ip    = (known after apply)
>   - domain               = (known after apply)
>   - id                   = (known after apply)
>   - instance             = (known after apply)
>   - network_border_group = (known after apply)
>   - network_interface    = (known after apply)
>   - private_dns          = (known after apply)
>   - private_ip           = (known after apply)
>   - public_dns           = (known after apply)
>   - public_ip            = (known after apply)
>   - public_ipv4_pool     = (known after apply)
>   - tags                 = {
>     - "Name" = "altana-codetest-vpc-us-east-1a"
>       }
>   - tags_all             = {
>     - "Name" = "altana-codetest-vpc-us-east-1a"
>       }
>   - vpc                  = true
>
> ```
> }
>
> ```
>
> # module.vpc.aws_internet_gateway.this[0] will be created
>
> - resource "aws_internet_gateway" "this" {
>   - arn      = (known after apply)
>   - id       = (known after apply)
>   - owner_id = (known after apply)
>   - tags     = {
>     - "Name" = "altana-codetest-vpc"
>       }
>   - tags_all = {
>     - "Name" = "altana-codetest-vpc"
>       }
>   - vpc_id   = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_nat_gateway.this[0] will be created
>
> - resource "aws_nat_gateway" "this" {
>   - allocation_id        = (known after apply)
>   - connectivity_type    = "public"
>   - id                   = (known after apply)
>   - network_interface_id = (known after apply)
>   - private_ip           = (known after apply)
>   - public_ip            = (known after apply)
>   - subnet_id            = (known after apply)
>   - tags                 = {
>     - "Name" = "altana-codetest-vpc-us-east-1a"
>       }
>   - tags_all             = {
>     - "Name" = "altana-codetest-vpc-us-east-1a"
>       }
>
> ```
> }
>
> ```
>
> # module.vpc.aws_route.private_nat_gateway[0] will be created
>
> - resource "aws_route" "private_nat_gateway" {
>   - destination_cidr_block = "0.0.0.0/0"
>   - id                     = (known after apply)
>   - instance_id            = (known after apply)
>   - instance_owner_id      = (known after apply)
>   - nat_gateway_id         = (known after apply)
>   - network_interface_id   = (known after apply)
>   - origin                 = (known after apply)
>   - route_table_id         = (known after apply)
>   - state                  = (known after apply)
>   - timeouts {
>     - create = "5m"
>       }
>
> ```
> }
>
> ```
>
> # module.vpc.aws_route.public_internet_gateway[0] will be created
>
> - resource "aws_route" "public_internet_gateway" {
>   - destination_cidr_block = "0.0.0.0/0"
>   - gateway_id             = (known after apply)
>   - id                     = (known after apply)
>   - instance_id            = (known after apply)
>   - instance_owner_id      = (known after apply)
>   - network_interface_id   = (known after apply)
>   - origin                 = (known after apply)
>   - route_table_id         = (known after apply)
>   - state                  = (known after apply)
>   - timeouts {
>     - create = "5m"
>       }
>
> ```
> }
>
> ```
>
> # module.vpc.aws_route_table.private[0] will be created
>
> - resource "aws_route_table" "private" {
>   - arn              = (known after apply)
>   - id               = (known after apply)
>   - owner_id         = (known after apply)
>   - propagating_vgws = (known after apply)
>   - route            = (known after apply)
>   - tags             = {
>     - "Name" = "altana-codetest-vpc-private"
>       }
>   - tags_all         = {
>     - "Name" = "altana-codetest-vpc-private"
>       }
>   - vpc_id           = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_route_table.public[0] will be created
>
> - resource "aws_route_table" "public" {
>   - arn              = (known after apply)
>   - id               = (known after apply)
>   - owner_id         = (known after apply)
>   - propagating_vgws = (known after apply)
>   - route            = (known after apply)
>   - tags             = {
>     - "Name" = "altana-codetest-vpc-public"
>       }
>   - tags_all         = {
>     - "Name" = "altana-codetest-vpc-public"
>       }
>   - vpc_id           = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_route_table_association.private[0] will be created
>
> - resource "aws_route_table_association" "private" {
>   - id             = (known after apply)
>   - route_table_id = (known after apply)
>   - subnet_id      = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_route_table_association.private[1] will be created
>
> - resource "aws_route_table_association" "private" {
>   - id             = (known after apply)
>   - route_table_id = (known after apply)
>   - subnet_id      = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_route_table_association.private[2] will be created
>
> - resource "aws_route_table_association" "private" {
>   - id             = (known after apply)
>   - route_table_id = (known after apply)
>   - subnet_id      = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_route_table_association.public[0] will be created
>
> - resource "aws_route_table_association" "public" {
>   - id             = (known after apply)
>   - route_table_id = (known after apply)
>   - subnet_id      = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_route_table_association.public[1] will be created
>
> - resource "aws_route_table_association" "public" {
>   - id             = (known after apply)
>   - route_table_id = (known after apply)
>   - subnet_id      = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_route_table_association.public[2] will be created
>
> - resource "aws_route_table_association" "public" {
>   - id             = (known after apply)
>   - route_table_id = (known after apply)
>   - subnet_id      = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_subnet.private[0] will be created
>
> - resource "aws_subnet" "private" {
>   - arn                                            = (known after apply)
>   - assign_ipv6_address_on_creation                = false
>   - availability_zone                              = "us-east-1a"
>   - availability_zone_id                           = (known after apply)
>   - cidr_block                                     = "10.0.1.0/24"
>   - enable_dns64                                   = false
>   - enable_resource_name_dns_a_record_on_launch    = false
>   - enable_resource_name_dns_aaaa_record_on_launch = false
>   - id                                             = (known after apply)
>   - ipv6_cidr_block_association_id                 = (known after apply)
>   - ipv6_native                                    = false
>   - map_public_ip_on_launch                        = false
>   - owner_id                                       = (known after apply)
>   - private_dns_hostname_type_on_launch            = (known after apply)
>   - tags                                           = {
>     - "Name"                                      = "altana-codetest-vpc-private-us-east-1a"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/internal-elb"           = "1"
>       }
>   - tags_all                                       = {
>     - "Name"                                      = "altana-codetest-vpc-private-us-east-1a"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/internal-elb"           = "1"
>       }
>   - vpc_id                                         = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_subnet.private[1] will be created
>
> - resource "aws_subnet" "private" {
>   - arn                                            = (known after apply)
>   - assign_ipv6_address_on_creation                = false
>   - availability_zone                              = "us-east-1b"
>   - availability_zone_id                           = (known after apply)
>   - cidr_block                                     = "10.0.2.0/24"
>   - enable_dns64                                   = false
>   - enable_resource_name_dns_a_record_on_launch    = false
>   - enable_resource_name_dns_aaaa_record_on_launch = false
>   - id                                             = (known after apply)
>   - ipv6_cidr_block_association_id                 = (known after apply)
>   - ipv6_native                                    = false
>   - map_public_ip_on_launch                        = false
>   - owner_id                                       = (known after apply)
>   - private_dns_hostname_type_on_launch            = (known after apply)
>   - tags                                           = {
>     - "Name"                                      = "altana-codetest-vpc-private-us-east-1b"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/internal-elb"           = "1"
>       }
>   - tags_all                                       = {
>     - "Name"                                      = "altana-codetest-vpc-private-us-east-1b"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/internal-elb"           = "1"
>       }
>   - vpc_id                                         = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_subnet.private[2] will be created
>
> - resource "aws_subnet" "private" {
>   - arn                                            = (known after apply)
>   - assign_ipv6_address_on_creation                = false
>   - availability_zone                              = "us-east-1c"
>   - availability_zone_id                           = (known after apply)
>   - cidr_block                                     = "10.0.3.0/24"
>   - enable_dns64                                   = false
>   - enable_resource_name_dns_a_record_on_launch    = false
>   - enable_resource_name_dns_aaaa_record_on_launch = false
>   - id                                             = (known after apply)
>   - ipv6_cidr_block_association_id                 = (known after apply)
>   - ipv6_native                                    = false
>   - map_public_ip_on_launch                        = false
>   - owner_id                                       = (known after apply)
>   - private_dns_hostname_type_on_launch            = (known after apply)
>   - tags                                           = {
>     - "Name"                                      = "altana-codetest-vpc-private-us-east-1c"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/internal-elb"           = "1"
>       }
>   - tags_all                                       = {
>     - "Name"                                      = "altana-codetest-vpc-private-us-east-1c"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/internal-elb"           = "1"
>       }
>   - vpc_id                                         = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_subnet.public[0] will be created
>
> - resource "aws_subnet" "public" {
>   - arn                                            = (known after apply)
>   - assign_ipv6_address_on_creation                = false
>   - availability_zone                              = "us-east-1a"
>   - availability_zone_id                           = (known after apply)
>   - cidr_block                                     = "10.0.4.0/24"
>   - enable_dns64                                   = false
>   - enable_resource_name_dns_a_record_on_launch    = false
>   - enable_resource_name_dns_aaaa_record_on_launch = false
>   - id                                             = (known after apply)
>   - ipv6_cidr_block_association_id                 = (known after apply)
>   - ipv6_native                                    = false
>   - map_public_ip_on_launch                        = true
>   - owner_id                                       = (known after apply)
>   - private_dns_hostname_type_on_launch            = (known after apply)
>   - tags                                           = {
>     - "Name"                                      = "altana-codetest-vpc-public-us-east-1a"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/elb"                    = "1"
>       }
>   - tags_all                                       = {
>     - "Name"                                      = "altana-codetest-vpc-public-us-east-1a"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/elb"                    = "1"
>       }
>   - vpc_id                                         = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_subnet.public[1] will be created
>
> - resource "aws_subnet" "public" {
>   - arn                                            = (known after apply)
>   - assign_ipv6_address_on_creation                = false
>   - availability_zone                              = "us-east-1b"
>   - availability_zone_id                           = (known after apply)
>   - cidr_block                                     = "10.0.5.0/24"
>   - enable_dns64                                   = false
>   - enable_resource_name_dns_a_record_on_launch    = false
>   - enable_resource_name_dns_aaaa_record_on_launch = false
>   - id                                             = (known after apply)
>   - ipv6_cidr_block_association_id                 = (known after apply)
>   - ipv6_native                                    = false
>   - map_public_ip_on_launch                        = true
>   - owner_id                                       = (known after apply)
>   - private_dns_hostname_type_on_launch            = (known after apply)
>   - tags                                           = {
>     - "Name"                                      = "altana-codetest-vpc-public-us-east-1b"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/elb"                    = "1"
>       }
>   - tags_all                                       = {
>     - "Name"                                      = "altana-codetest-vpc-public-us-east-1b"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/elb"                    = "1"
>       }
>   - vpc_id                                         = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_subnet.public[2] will be created
>
> - resource "aws_subnet" "public" {
>   - arn                                            = (known after apply)
>   - assign_ipv6_address_on_creation                = false
>   - availability_zone                              = "us-east-1c"
>   - availability_zone_id                           = (known after apply)
>   - cidr_block                                     = "10.0.6.0/24"
>   - enable_dns64                                   = false
>   - enable_resource_name_dns_a_record_on_launch    = false
>   - enable_resource_name_dns_aaaa_record_on_launch = false
>   - id                                             = (known after apply)
>   - ipv6_cidr_block_association_id                 = (known after apply)
>   - ipv6_native                                    = false
>   - map_public_ip_on_launch                        = true
>   - owner_id                                       = (known after apply)
>   - private_dns_hostname_type_on_launch            = (known after apply)
>   - tags                                           = {
>     - "Name"                                      = "altana-codetest-vpc-public-us-east-1c"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/elb"                    = "1"
>       }
>   - tags_all                                       = {
>     - "Name"                                      = "altana-codetest-vpc-public-us-east-1c"
>     - "kubernetes.io/cluster/altana-codetest-eks" = "shared"
>     - "kubernetes.io/role/elb"                    = "1"
>       }
>   - vpc_id                                         = (known after apply)
>
> ```
> }
>
> ```
>
> # module.vpc.aws_vpc.this[0] will be created
>
> - resource "aws_vpc" "this" {
>   - arn                                  = (known after apply)
>   - cidr_block                           = "10.0.0.0/16"
>   - default_network_acl_id               = (known after apply)
>   - default_route_table_id               = (known after apply)
>   - default_security_group_id            = (known after apply)
>   - dhcp_options_id                      = (known after apply)
>   - enable_classiclink                   = (known after apply)
>   - enable_classiclink_dns_support       = (known after apply)
>   - enable_dns_hostnames                 = true
>   - enable_dns_support                   = true
>   - enable_network_address_usage_metrics = (known after apply)
>   - id                                   = (known after apply)
>   - instance_tenancy                     = "default"
>   - ipv6_association_id                  = (known after apply)
>   - ipv6_cidr_block                      = (known after apply)
>   - ipv6_cidr_block_network_border_group = (known after apply)
>   - main_route_table_id                  = (known after apply)
>   - owner_id                             = (known after apply)
>   - tags                                 = {
>     - "Name" = "altana-codetest-vpc"
>       }
>   - tags_all                             = {
>     - "Name" = "altana-codetest-vpc"
>       }
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["one"].aws_eks_node_group.this[0] will be created
>
> - resource "aws_eks_node_group" "this" {
>   - ami_type               = "AL2_x86_64"
>   - arn                    = (known after apply)
>   - capacity_type          = (known after apply)
>   - cluster_name           = "altana-codetest-eks"
>   - disk_size              = (known after apply)
>   - id                     = (known after apply)
>   - instance_types         = [
>     - "t3.small",
>       ]
>   - node_group_name        = (known after apply)
>   - node_group_name_prefix = "node-group-1-"
>   - node_role_arn          = (known after apply)
>   - release_version        = (known after apply)
>   - resources              = (known after apply)
>   - status                 = (known after apply)
>   - subnet_ids             = (known after apply)
>   - tags                   = {
>     - "Name" = "node-group-1"
>       }
>   - tags_all               = {
>     - "Name" = "node-group-1"
>       }
>   - version                = "1.27"
>   - launch_template {
>     - id      = (known after apply)
>     - name    = (known after apply)
>     - version = (known after apply)
>       }
>   - scaling_config {
>     - desired_size = 2
>     - max_size     = 3
>     - min_size     = 1
>       }
>   - timeouts {}
>   - update_config {
>     - max_unavailable_percentage = 33
>       }
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["one"].aws_iam_role.this[0] will be created
>
> - resource "aws_iam_role" "this" {
>
>   - arn                   = (known after apply)
>
>   - assume_role_policy    = jsonencode(
>
>     ```
>     {
>       + Statement = [
>           + {
>               + Action    = "sts:AssumeRole"
>               + Effect    = "Allow"
>               + Principal = {
>                   + Service = "ec2.amazonaws.com"
>                 }
>               + Sid       = "EKSNodeAssumeRole"
>             },
>         ]
>       + Version   = "2012-10-17"
>     }
>
>     ```
>
>     )
>
>   - create_date           = (known after apply)
>
>   - description           = "EKS managed node group IAM role"
>
>   - force_detach_policies = true
>
>   - id                    = (known after apply)
>
>   - managed_policy_arns   = (known after apply)
>
>   - max_session_duration  = 3600
>
>   - name                  = (known after apply)
>
>   - name_prefix           = "node-group-1-eks-node-group-"
>
>   - path                  = "/"
>
>   - tags_all              = (known after apply)
>
>   - unique_id             = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["one"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"] will be created
>
> - resource "aws_iam_role_policy_attachment" "this" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
>   - role       = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["one"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"] will be created
>
> - resource "aws_iam_role_policy_attachment" "this" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
>   - role       = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["one"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"] will be created
>
> - resource "aws_iam_role_policy_attachment" "this" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
>   - role       = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["one"].aws_launch_template.this[0] will be created
>
> - resource "aws_launch_template" "this" {
>   - arn                    = (known after apply)
>   - default_version        = (known after apply)
>   - description            = "Custom launch template for node-group-1 EKS managed node group"
>   - id                     = (known after apply)
>   - latest_version         = (known after apply)
>   - name                   = (known after apply)
>   - name_prefix            = "one-"
>   - tags_all               = (known after apply)
>   - update_default_version = true
>   - vpc_security_group_ids = (known after apply)
>   - metadata_options {
>     - http_endpoint               = "enabled"
>     - http_protocol_ipv6          = "disabled"
>     - http_put_response_hop_limit = 2
>     - http_tokens                 = "required"
>     - instance_metadata_tags      = "disabled"
>       }
>   - monitoring {
>     - enabled = true
>       }
>   - tag_specifications {
>     - resource_type = "instance"
>     - tags          = {
>       - "Name" = "node-group-1"
>         }
>         }
>   - tag_specifications {
>     - resource_type = "network-interface"
>     - tags          = {
>       - "Name" = "node-group-1"
>         }
>         }
>   - tag_specifications {
>     - resource_type = "volume"
>     - tags          = {
>       - "Name" = "node-group-1"
>         }
>         }
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["two"].aws_eks_node_group.this[0] will be created
>
> - resource "aws_eks_node_group" "this" {
>   - ami_type               = "AL2_x86_64"
>   - arn                    = (known after apply)
>   - capacity_type          = (known after apply)
>   - cluster_name           = "altana-codetest-eks"
>   - disk_size              = (known after apply)
>   - id                     = (known after apply)
>   - instance_types         = [
>     - "t3.small",
>       ]
>   - node_group_name        = (known after apply)
>   - node_group_name_prefix = "node-group-2-"
>   - node_role_arn          = (known after apply)
>   - release_version        = (known after apply)
>   - resources              = (known after apply)
>   - status                 = (known after apply)
>   - subnet_ids             = (known after apply)
>   - tags                   = {
>     - "Name" = "node-group-2"
>       }
>   - tags_all               = {
>     - "Name" = "node-group-2"
>       }
>   - version                = "1.27"
>   - launch_template {
>     - id      = (known after apply)
>     - name    = (known after apply)
>     - version = (known after apply)
>       }
>   - scaling_config {
>     - desired_size = 1
>     - max_size     = 2
>     - min_size     = 1
>       }
>   - timeouts {}
>   - update_config {
>     - max_unavailable_percentage = 33
>       }
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["two"].aws_iam_role.this[0] will be created
>
> - resource "aws_iam_role" "this" {
>
>   - arn                   = (known after apply)
>
>   - assume_role_policy    = jsonencode(
>
>     ```
>     {
>       + Statement = [
>           + {
>               + Action    = "sts:AssumeRole"
>               + Effect    = "Allow"
>               + Principal = {
>                   + Service = "ec2.amazonaws.com"
>                 }
>               + Sid       = "EKSNodeAssumeRole"
>             },
>         ]
>       + Version   = "2012-10-17"
>     }
>
>     ```
>
>     )
>
>   - create_date           = (known after apply)
>
>   - description           = "EKS managed node group IAM role"
>
>   - force_detach_policies = true
>
>   - id                    = (known after apply)
>
>   - managed_policy_arns   = (known after apply)
>
>   - max_session_duration  = 3600
>
>   - name                  = (known after apply)
>
>   - name_prefix           = "node-group-2-eks-node-group-"
>
>   - path                  = "/"
>
>   - tags_all              = (known after apply)
>
>   - unique_id             = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["two"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"] will be created
>
> - resource "aws_iam_role_policy_attachment" "this" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
>   - role       = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["two"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"] will be created
>
> - resource "aws_iam_role_policy_attachment" "this" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
>   - role       = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["two"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"] will be created
>
> - resource "aws_iam_role_policy_attachment" "this" {
>   - id         = (known after apply)
>   - policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
>   - role       = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.module.eks_managed_node_group["two"].aws_launch_template.this[0] will be created
>
> - resource "aws_launch_template" "this" {
>   - arn                    = (known after apply)
>   - default_version        = (known after apply)
>   - description            = "Custom launch template for node-group-2 EKS managed node group"
>   - id                     = (known after apply)
>   - latest_version         = (known after apply)
>   - name                   = (known after apply)
>   - name_prefix            = "two-"
>   - tags_all               = (known after apply)
>   - update_default_version = true
>   - vpc_security_group_ids = (known after apply)
>   - metadata_options {
>     - http_endpoint               = "enabled"
>     - http_protocol_ipv6          = "disabled"
>     - http_put_response_hop_limit = 2
>     - http_tokens                 = "required"
>     - instance_metadata_tags      = "disabled"
>       }
>   - monitoring {
>     - enabled = true
>       }
>   - tag_specifications {
>     - resource_type = "instance"
>     - tags          = {
>       - "Name" = "node-group-2"
>         }
>         }
>   - tag_specifications {
>     - resource_type = "network-interface"
>     - tags          = {
>       - "Name" = "node-group-2"
>         }
>         }
>   - tag_specifications {
>     - resource_type = "volume"
>     - tags          = {
>       - "Name" = "node-group-2"
>         }
>         }
>
> ```
> }
>
> ```
>
> # module.eks.module.kms.data.aws_iam_policy_document.this[0] will be read during apply
>
> # (config refers to values not yet known)
>
>  <= data "aws_iam_policy_document" "this" {
>
> ```
>   + id                        = (known after apply)
>   + json                      = (known after apply)
>   + override_policy_documents = []
>   + source_policy_documents   = []
>
>   + statement {
>       + actions   = [
>           + "kms:CancelKeyDeletion",
>           + "kms:Create*",
>           + "kms:Delete*",
>           + "kms:Describe*",
>           + "kms:Disable*",
>           + "kms:Enable*",
>           + "kms:Get*",
>           + "kms:List*",
>           + "kms:Put*",
>           + "kms:Revoke*",
>           + "kms:ScheduleKeyDeletion",
>           + "kms:TagResource",
>           + "kms:UntagResource",
>           + "kms:Update*",
>         ]
>       + resources = [
>           + "*",
>         ]
>       + sid       = "KeyAdministration"
>
>       + principals {
>           + identifiers = [
>               + "arn:aws:iam::888642414045:user/bhenneberger-dev",
>             ]
>           + type        = "AWS"
>         }
>     }
>   + statement {
>       + actions   = [
>           + "kms:Decrypt",
>           + "kms:DescribeKey",
>           + "kms:Encrypt",
>           + "kms:GenerateDataKey*",
>           + "kms:ReEncrypt*",
>         ]
>       + resources = [
>           + "*",
>         ]
>       + sid       = "KeyUsage"
>
>       + principals {
>           + identifiers = [
>               + (known after apply),
>             ]
>           + type        = "AWS"
>         }
>     }
> }
>
> ```
>
> # module.eks.module.kms.aws_kms_alias.this["cluster"] will be created
>
> - resource "aws_kms_alias" "this" {
>   - arn            = (known after apply)
>   - id             = (known after apply)
>   - name           = "alias/eks/altana-codetest-eks"
>   - name_prefix    = (known after apply)
>   - target_key_arn = (known after apply)
>   - target_key_id  = (known after apply)
>
> ```
> }
>
> ```
>
> # module.eks.module.kms.aws_kms_key.this[0] will be created
>
> - resource "aws_kms_key" "this" {
>   - arn                                = (known after apply)
>   - bypass_policy_lockout_safety_check = false
>   - customer_master_key_spec           = "SYMMETRIC_DEFAULT"
>   - description                        = "altana-codetest-eks cluster encryption key"
>   - enable_key_rotation                = true
>   - id                                 = (known after apply)
>   - is_enabled                         = true
>   - key_id                             = (known after apply)
>   - key_usage                          = "ENCRYPT_DECRYPT"
>   - multi_region                       = false
>   - policy                             = (known after apply)
>   - tags_all                           = (known after apply)
>
> ```
> }
>
> ```
>
> Plan: 57 to add, 0 to change, 0 to destroy.
>
> Changes to Outputs:
>
> - cluster_endpoint          = (known after apply)
> - cluster_name              = "altana-codetest-eks"
> - cluster_security_group_id = (known after apply)
> - region                    = "us-east-1"
>
> ───────────────────────────────────────────────────────────────────