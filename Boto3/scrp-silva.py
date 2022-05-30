import boto3

# use a different profile rather than default for aws configure
boto3.setup_default_session(profile_name='default')

# use ec2 resource
ec2 = boto3.resource('ec2')

# create VPC
vpc = ec2.create_vpc(CidrBlock='172.16.0.0/16')

# assign a name to our VPC

vpc_name = vpc.create_tags(Tags=[{"Key": "Name", "Value": "boto3_vpc"}])

vpc.wait_until_available()