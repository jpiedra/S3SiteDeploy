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

$bucketName = "s3://$($Name)"

# make sure the bucket doesn't already exist, checking for an ErrorRecord
try {
    $result = aws s3 ls $bucketName 2>&1
    if ($result[0].GetType().Name -ne "ErrorRecord") {
        throw [System.Exception]::new("The specified bucket $bucketName already exists.");
    }
} catch {
    # if the bucket already exists, don't do anything and exit noisily!
    Write-Error $PSItem.Exception.Message
    Exit
} 

$bucket = aws s3 mb $bucketName --region $($Region) 2>&1

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
