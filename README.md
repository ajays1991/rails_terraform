# Ruby on Rails deployment using Terraform, Docker, AWS Codepipeline

### Resources

  - [Terraform]([https://www.terraform.io](https://www.terraform.io/))
  - [Docker]([https://www.docker.com/](https://www.docker.com/))
  - [AWS Codepipeline]([https://aws.amazon.com/codepipeline/](https://aws.amazon.com/codepipeline/))

### System Installation

#### Install Terraform

Install terraform using the this link [https://learn.hashicorp.com/terraform/getting-started/install.html](https://learn.hashicorp.com/terraform/getting-started/install.html)

#### You don't need local installation of docker as docker build will be run on AWS codepipeline server using buildspec.

### Github access Token

Generate a new personal github token following the steps from [this link](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line#creating-a-token)

Paste the token genrated in modules/copepipeline/main.tf at the following line
Also add owner for the repository you want to deploy along with repository namd and branch.
AWS code build created using terraform will read the repository owner, name, brnach from the following to run AWS code build using this source.

```
configuration = {
        Owner      = "owner_of_repo"
        Repo       = "repo_name"
        Branch     = "branch_of_repo"
        OAuthToken = "***********token*********"
      }

```

### Deploying application to AWS

In production.tf set access_key and secret_key for AWS account.

```
provider "aws" {
  region = var.region
  access_key = "**********************"
  secret_key = "**********************"
  #profile = "duduribeiro"
}
```
In terraform.tfvars file set region, database_name, database username, database password, secret_key_base for rails application.
```
region                        = "your-selected-region"
domain                        = "your domain"

/* rds */
production_database_name      = "production database name"
production_database_username  = "username"
production_database_password  = "database-password"

/* secret key */
production_secret_key_base    = "secret-key-base"

```
After this setup run the following command in project root
`$ terraform init`

After successfully installing the terraform plugins run the following command

`$ terraform plan`

After successfully creating the plan run the following command

`$ terraform apply`

This will start creating your AWS infrastructure for the application and will success with providing url for the application loadbalancer using the following command

`$ terraform output alb_dns_name`