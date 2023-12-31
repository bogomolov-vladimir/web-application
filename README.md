This project is built to host an application in AWS EC2 instance.
### Built With
* AWS resources
* Terraform
* Ansible
* Git

### Prerequisites
* Create a free tier AWS account.
* Create an IAM user with programmable access and make a note of the access and secret keys.

### Installation
1. git clone [https://github.com/bogomolov-vladimir/web-application.git](https://github.com/bogomolov-vladimir/web-application-aws-ec2-instance..git)
2. Install Terraform (https://www.terraform.io/downloads.html)
3. Install Ansible (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### Part 1: Standing up the Infrastructure
The infrastructure is setup in AWS using Terraform.
1. cd into the infrastructure folder in the cloned repository.
2. Run the following commands in order
    - terraform init
    - terraform plan
    - terraform apply
### Varaibles
    - var.access_key - Enter a value: "YOUR AWS ACCESS KEY"
    - var.ami - Enter a value: "YOUR AWS AMI ID"
    - var.key_name - Enter a value: "PUBLIC KEY NAME"
    - var.secret_key - Enter a value: "YOUR AWS SECRET KEY"
This will provision the required infrastructure and provides the EC2 instance public IP as the output.

### Part 2: Installing the application (This step is optional)
The next step is to install the required softwares in the EC2 instance and deploy the php application along with the MySQL database. This is done using ansible.
1. Open the inventory.yml file under ansible directory and replace 0.0.0.0 with the public IP copied at the end of part 1.
2. Replace the contents of the ./ansible/secrets/ssh.private with your private key. This is the private key corresponding to the public key used in Part 1 while provisioning the infrastructure using terraform.
3. Run the ansible playbook using the below command from the ansible folder.
    - ansible-playbook -i inventory.yml application.yml

### Part 3: Automated CI/CD With AWS CodePipeline Using CloudFormation
The next step is creating a simple Continuous Delivery pipeline allowing you to push changes from your GitHub repository to your EC2 Instances.
1. Enter the the directory 
    cd ../codedeployexample/deploy
2. Open stack.yml file and enter your aws ami into Mapping:AMI: ** manually
3. Return into codedeployexample directory 
    cd ..
4. Use the `./setup.sh` script to create a Continuous Delivery pipeline.
Note: The script will create a CloudFormation stack which launches an EC2 instance into the default VPC of your default region. 
The script will ask you for:
* GitHub repository
* GitHub owner (username of individual or organisation)
* GitHub [OAuth Token with access to Repo](https://github.com/settings/tokens).

It might take a few minutes until the CodePipeline job has finished and the EC2 Instance is able to answer your HTTP request.

### Part 4: Destroy the application
Run the below command to tear down the application.
    - terrafrom destroy
