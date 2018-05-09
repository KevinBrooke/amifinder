# The AMI name to filter on (default is Amazon Linux)
$nameFilter = "amzn-ami-hvm*"
$rootDeviceFilter = "ebs"

# Obtain a list of regions
$regions = aws ec2 describe-regions --output text | ForEach-Object{ $_.split("`t")[2]; }

# Start the YAML output
write-host "Mappings:"
write-host "  AMIRegionMap:"

# Loop through the regions
foreach ($region in $regions)
{
    $ami = aws ec2 describe-images --region $region --filters "Name=name,Values=$nameFilter" "Name=root-device-type,Values=$rootDeviceFilter" --query 'sort_by(Images,&CreationDate)[-1].ImageId' --output text
    write-host "    "$region":"
    write-host "      AMI: ""$ami"""
}
