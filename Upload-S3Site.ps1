[CmdletBinding()]
Param(
    # Name of the bucket being configured  
    [Parameter(Mandatory=$true,Position=1)]
    [String]
    $Name
)

# [https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html] :: upload boilerplate files
aws s3 cp . s3://$($Name) --exclude "*" --include "*.html" --recursive --metadata-directive REPLACE --content-type "text/html"
aws s3 cp . s3://$($Name) --exclude "*" --include "*.css" --recursive --metadata-directive REPLACE --content-type "text/css"
aws s3 cp . s3://$($Name) --exclude "*" --include "*.js" --recursive --metadata-directive REPLACE --content-type "text/javascript"

aws s3 website s3://$($Name) --index-document index.html --error-document error.html