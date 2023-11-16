# DevOps Project 1

### 1. What is this?

### 2. Prerequisites
* Install terraform
* Install aws cli
* configure aws cli

* Create a sonarqube account and create access token.
* Create a jfrog artifactory account and select maven as a package type and then Generate access key token.
* Create a github access token in the same github account where your application code is hosted in.

* You will use these access keys and corresponding passwords/usernames in the jenkins-node.sh file but make sure not to hardcode these credentials into the bash script but use a secrets manager like aws secrets manager to store and manage these secrets.

* In our case we used AWS Secrets manager


### 3. Getting started

1. Clone the repo via SSH or HTTPS  
```bash
   #SSH
   git clone git@github.com:thab310/devops-project-1.git

   #HTTPS
   git clone https://github.com/thab310/devops-project-1.git
```   
2. CD into `devops-project-1` and create `terraform.tfvars`    
```bash
   cd devops-project-1 && touch terraform.tfvars
```      

3. Update `terraform.tfvars`
```hcl
   profile = ""
   region  = ""
   owner   = ""
```   
4. Run `terraform init` and `terraform apply`
5. Updated

### 3. Steps
* login to http//:jenkins__master_ec2_IP:8080
* Enable Webhook
1. Install "multibranch scan webhook trigger" plugin from dashboard --> manage jenkins --> Available Plugins search for "Multibranch Scan webhook trigger" plugin and install it.

2. Go to multibranch pipeline job job--> configure --> Scan Multibranch Pipeline Triggers --> Scan Multibranch Pipeline Triggers --> Scan by webhook
Trigger token: <token_name>

3. Add webhook to Github repository Github repo --> settings --> webhooks --> Add webhook Payload URI: <jenkins_IP>:8080/multibranch-webhook-trigger/invoke?token=<token_name> content type: application/json
Which event would you like to trigger this webhook: just the push event
1. Create multi-branch pipeline in jenkins
2. Setup webhook in order to run jenkins pipeline automatically 
### 3. Diagram
### What can I do better?
1. Find a way to automate jenkin plugin installation
2. Find a way to dynamically add webhook payload url


