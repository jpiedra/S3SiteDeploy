[CmdletBinding()]
Param(
    # Name of the bucket being configured  
    [Parameter(Mandatory=$true,Position=1)]
    [String]
    $Name,

    # The region the bucket should reside in
    [Parameter(Mandatory=$false)]
    [String]
    $Region="us-east-1"
)

# make sure the bucket doesn't already exist, checking for resulting string "NoSuchBucket"
# redirects stderr to stdout, which in turn is stored in a variable, for checking below:
$results = aws s3 ls s3://$($Name) 2>&1
if ($results | Select-String -Pattern "NoSuchBucket") {
    # if the bucket doesn't already exist, create it and prepare accordingly...
    Write-Host "Creating new bucket s3://$($Name)"
    $bucket = aws s3 mb s3://$($Name) --region $($Region) 2>&1
    
    # if your bucket was created successfully, proceed to configure/upload defaults
    if ($bucket | Select-String -Pattern "make_bucket") {
        # configure default minimal viable policy, you MUST use Set-Content to preserve JSON integrity...
        (Get-Content .\static-site-policy.json).replace('BUCKET_NAME', $Name) | Set-Content .\policy.json
        if (Test-Path -Path "policy.json") {
            # upload your site contents
            write-host (Get-Content "policy.json")
            aws s3api put-bucket-policy --bucket $Name --policy file://policy.json
            .\Upload-S3Site.ps1 -Name $Name
        }
    }    
} else {
    # if the bucket already exists, don't do anything and exit noisily!
    Write-Host "The specified bucket $Name already exists. Exiting to avoid overwriting accidentally."
    Exit
}

