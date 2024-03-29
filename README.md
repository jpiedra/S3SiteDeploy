# AWS S3 Bucket Static Site deployment

Series of commands and script(s) to automate creation, file upload and configuration of an S3 bucket for use as a static website.

# Assumptions
You should have the AWS CLI configured on the system you are running these commands from. 
More info on that here: https://docs.aws.amazon.com/cli/latest/userguide/tutorial-ec2-ubuntu.html#install-cli

# Directions
The file _deploy.sh_ contains all commands to be run manually. Run them individually, or all at once (Linux and Mac). 
Replace occurences of _acme.com_ with the name of the S3 bucket you're deploying to. 

Powershell Users: A script _New-S3Site.ps1_ is available for use, which handles creating a bucket (first checking if it's there), adding some assets from an example web project (handled by _Upload-S3Site.ps1_), and preparing the bucket for use as a website (applying a default policy, running 'website' command, etc.)

Example:
> .\New-S3Site.ps1 -Name acme.org -Path .\public

# To-Do
- Figure out a way to get the URL of the bucket after it is created, rather than having to check AWS console
