#!/bin/bash

#install aws-cli
curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o awscli-bundle.zip
unzip awscli-bundle.zip
chmod +x ./awscli-bundle/install
./awscli-bundle/install -i /tmp/aws

# mysqldump -u root -pcorrect --databases s3_backup_spike | gzip -c > "./tmp/2017-03-20-09-24.sql.gz"

/tmp/aws/bin/aws s3 cp ./2017-03-20-11-24.sql.gz s3://s3-backup-spike/spike/2017-03-20-11-24.sql.gz --region eu-west-1

echo "backup 2017-03-20-11-24.sql.gz complete"
