#!/bin/bash

# [https://docs.aws.amazon.com/cli/latest/reference/s3/mb.html] :: create the bucket 
aws s3 mb s3://acme.com --region us-east-1

# [https://docs.aws.amazon.com/cli/latest/reference/s3api/put-bucket-policy.html] :: configure the bucket's policy
# [https://docs.aws.amazon.com/AmazonS3/latest/dev/HostingWebsiteOnS3Setup.html#step2-add-bucket-policy-make-content-public] :: basic policy for a static website
aws s3api put-bucket-policy --bucket acme.com --policy file://static-site-policy.json

# [https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html] :: upload boilerplate files
aws s3 cp . s3://acme.com --exclude "*" --include "*.html" --recursive --metadata-directive REPLACE --content-type "text/html"
aws s3 cp . s3://acme.com --exclude "*" --include "*.css" --recursive --metadata-directive REPLACE --content-type "text/css"
aws s3 cp . s3://acme.com --exclude "*" --include "*.js" --recursive --metadata-directive REPLACE --content-type "text/javascript"

# [https://docs.aws.amazon.com/cli/latest/reference/s3/website.html] configure it as a website
aws s3 website s3://acme.com --index-document index.html --error-document error.html

