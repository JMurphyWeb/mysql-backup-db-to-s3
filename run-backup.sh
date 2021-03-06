#!/bin/bash


#install aws-cli if it doesn't exist
if [ ! -d "/tmp/aws" ]; then
  curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o awscli-bundle.zip
  unzip awscli-bundle.zip
  chmod +x ./awscli-bundle/install
  ./awscli-bundle/install -i /tmp/aws
fi

# new backup file name
BACKUP_FILE_NAME="$(date +"%Y-%m-%d-%H-%M")-$APP-$DATABASE.sql"


# if directory '/tmp/db-backups' doesn't exist, create it
if [ ! -d "/tmp/db-backups" ]; then
  mkdir -p /tmp/db-backups/
fi

# dump the current DB into /tmp/db-backups/<new-file-name>
# ./bin/mysqldump -u $CLEARDB_USER_NAME -h $CLEARDB_SERVER_IP -p$CLEARDB_PASSWORD --databases $DATABASE | gzip -c > "/tmp/db-backups/$BACKUP_FILE_NAME.gz"
mysqldump -u $CLEARDB_USER_NAME -h $CLEARDB_SERVER_IP -p$CLEARDB_PASSWORD --databases $DATABASE | gzip -c > "/tmp/db-backups/$BACKUP_FILE_NAME.gz"

# using the aws cli, copy the new backup to our s3 bucket
/tmp/aws/bin/aws s3 cp /tmp/db-backups/$BACKUP_FILE_NAME.gz s3://$S3_BUCKET_PATH/$DATABASE/$BACKUP_FILE_NAME.gz --region $AWS_DEFAULT_REGION

echo "backup $BACKUP_FILE_NAME.gz complete"
