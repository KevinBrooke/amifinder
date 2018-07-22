while getopts "oh" opt; do
  case ${opt} in
    o ) os=$OPTARG;;
    h ) hdd=$OPTARG;;
    \? )
        echo -e "\nInvalid option: $OPTARG\n" 1>&2
        echo -e "Usage: script -o <operatingsystem> -h <hddtype>\n"
        exit 0
        ;;
  esac
done

if [[ -z "$os" ]]; then
    os='amzn-ami-hvm*'
fi
if [[ -z "$hdd" ]]; then
    hdd='ebs'
fi

# Start the YAML output
echo 'Mappings:'
echo '  AMIRegionMap:'

# Obtain a list of regions
for region in `aws ec2 describe-regions --output text | cut -f3`
do
    ami=`aws ec2 describe-images --region $region --filters "Name=name,Values=$os" "Name=root-device-type,Values=$hdd" --query 'sort_by(Images,&CreationDate)[-1].ImageId' --output text`
    echo '   '$region:''
    echo '      AMI: '$ami
done
