
############################################################################

# !/bin/bash
# Author        : Shubham Sihasane
# Date          : 1st June, 2021
# Description   : Write a bash scrip to install Apache2 web server on EC2 instance, if not already installed. Then start the service, if service is not already running. Whenever a script is invoked, it should generate a tar file from archival log files located in /var/log/Apache2 folder and uploads to S3 bucket using AWS CLI for periodic archival of Apache2 webserver log files and run this task on a daily basis by creating a cron job.

############################################################################

# Variable Declaration:
s3_bucket_name="upgrad-shubham"
myname=shubham
timestamp=$(date '+%d%m%Y-%H%M%S')
inv_file="/var/www/html/inventory.html"
cron_file="/etc/cron.d/automation"

# Update the packages:
echo "Updating Packages..."
sudo apt update -y

# Check if HTTP Apache2 server is already installed or not:
dpkg -s apache2

# Install Apache2 if not already installed:
if [ $? -eq 0 ]
then
    echo "Apache2 server is already installed."
else
    echo "Installing Apache2 Server..."
    sudo apt install apache2 -y
fi

# Check Apache2 service status:
sudo systemctl is-active --quiet apache2

if [ $? -eq 0 ]
then
    echo "Apache2 service is already running."
else
    echo "Apache2 service is not running. Starting Apache2 service..."
    sudo service apache2 start

    if [ $? -eq 0 ]
    then
        echo "Apache2 service started successfully."
        
        # Check Apache2 service is enabled on reboot or not:
        sudo systemctl is-enabled apache2
        
        if [ $? -eq 0 ]
        then
            echo "Apache2 service is already enabled."
        else
            echo "Enabling Apache2 service..."
            sudo service apache2 enable
        fi
    else
        echo "Failed to start Apache2 service."
    fi
fi


############################################################################


# Create tar file from the Apache2 server logs:
echo "Creating archive of Apache2 log files..."

filename="$myname-httpd-logs-$timestamp.tar.gz"

current_dir=$(pwd)
cd /var/log/apache2

sudo tar -czf $filename *.log

sudo mv $filename /tmp/
cd $current_dir


############################################################################


# Check if AWS-CLI is already installed or not, if not install it:
dpkg -s awscli
if [ $? -eq 0 ]
then 
    echo "AWS-CLI is already installed."
else 
    echo "Installing AWS-CLI..."
    sudo apt install awscli -y
fi


############################################################################


# Upload achieved file to AWS S3 bucket:
echo "Uploading $filename to S3 bucket $s3_bucket_name..."

aws s3 cp /tmp/$filename s3://$s3_bucket_name//$filename


##############################END OF THE SCRIPT##############################