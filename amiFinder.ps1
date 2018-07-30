# Obtain parameters
param(
    [string]$os,
    [string]$hdd
)

if (!$os)
{
    $os = 'amzn-ami-hvm*'
}
if (!$hdd)
{
    $hdd = 'ebs'
}

# Obtain a list of regions
$regions = aws ec2 describe-regions --output text | ForEach-Object{ $_.split("`t")[2]; }

# Start the YAML output
write-host "Mappings:"
write-host "  AMIRegionMap:"

# Loop through the regions
foreach ($region in $regions)
{
    $ami = aws ec2 describe-images --region $region --filters "Name=name,Values=$os" "Name=root-device-type,Values=$hdd" --query 'sort_by(Images,&CreationDate)[-1].ImageId' --output text
    write-host "   "$region":"
    write-host "      AMI: ""$ami"""
}
