[CmdletBinding()]
Param(
    # Name of the bucket being configured  
    [Parameter(Mandatory=$true,Position=1)]
    [String]
    $Name,

    # Name of the path on the local computer to copy files from, assume current working directory by default
    [String]
    $Path = $pwd.Path
)

# [https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html] :: upload boilerplate files
aws s3 cp $Path s3://$($Name) --exclude "*" --include "*.html" --recursive --metadata-directive REPLACE `
    --content-type text/html --cache-control public,max-age=604800

# Upload stylesheets
aws s3 cp $Path s3://$($Name) --exclude "*" --include "*.css" --recursive --metadata-directive REPLACE `
    --content-type text/css --cache-control public,max-age=604800

# Upload JavaScript files
aws s3 cp $Path s3://$($Name) --exclude "*" --include "*.js" --recursive --metadata-directive REPLACE `
    --content-type text/javascript --cache-control public,max-age=604800

# Upload PNG images
aws s3 cp $Path s3://$($Name) --exclude "*" --include "*.png" --recursive --metadata-directive REPLACE `
    --content-type image/png --cache-control public,max-age=604800

# Upload JPG images
aws s3 cp $Path s3://$($Name) --exclude "*" --include "*.jpg" --recursive --metadata-directive REPLACE `
    --content-type image/jpg --cache-control public,max-age=604800

# Set the website configuration for the bucket, setting the index and error pages.
aws s3 website s3://$($Name) --index-document index.html --error-document error.html