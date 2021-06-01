# Automation_Project
DevOps | UpGrad | DevOps Essentials | Assignments | Task 2 & Task 3

**Author:** Shubham Sihasane

**Problem Statement:** Write a bash scrip to install Apache2 web server on EC2 instance, if not already installed. Then start the service, if service is not already running. Whenever a script is invoked, it should generate a tar file from archival log files located in /var/log/Apache2 folder and uploads to S3 bucket using AWS CLI for periodic archival of Apache2 webserver log files and run this task on a daily basis by creating a cron job.