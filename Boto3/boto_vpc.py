from re import sub
import boto3

# use a different profile rather than default for aws configure
boto3.setup_default_session(profile_name='default')

# use ec2 resource
ec2 = boto3.resource('ec2')
# create VPC
vpc = ec2.create_vpc(CidrBlock='10.0.0.0/16')
# we can assign a name to vpc, or any resource, by using tag
vpc.create_tags(Tags=[{"Key": "Name", "Value": "PRD-ECS"}])
vpc.create_tags(Tags=[{"Key": "Enviroment", "Value": "PRD"}])
vpc.wait_until_available()
print(vpc.id)

# create then attach internet gateway
ig = ec2.create_internet_gateway()
vpc.attach_internet_gateway(InternetGatewayId=ig.id)
ig.create_tags(Tags=[{"Key": "Name", "Value": "ECS-GW"}])
print(ig.id)
# create a route table and a public route
route_table = vpc.create_route_table()
route = route_table.create_route(
    DestinationCidrBlock='0.0.0.0/0',
    GatewayId=ig.id
)
tag = route_table.create_tags(Tags=[{"Key": "Name", "Value": "RT-Public"}])
tag = route_table.create_tags(Tags=[{"Key": "Enviroment", "Value": "PRD"}])
print(route_table.id)

# create subnets
subnet = ec2.create_subnet(CidrBlock='10.0.1.0/24', VpcId=vpc.id, AvailabilityZone = 'us-east-2a')
route_table.associate_with_subnet(SubnetId=subnet.id)
subnet.create_tags(Tags=[{"Key": "Name", "Value": "Public-sub-1"}])
subnet.create_tags(Tags=[{"Key": "Enviroment", "Value": "PRD"}])
print(subnet.id)
subnet = ec2.create_subnet(CidrBlock='10.0.2.0/24', VpcId=vpc.id, AvailabilityZone = 'us-east-2b')
route_table.associate_with_subnet(SubnetId=subnet.id)
subnet.create_tags(Tags=[{"Key": "Name", "Value": "Public-sub-2"}])
subnet.create_tags(Tags=[{"Key": "Enviroment", "Value": "PRD"}])
print(subnet.id)
subnet = ec2.create_subnet(CidrBlock='10.0.3.0/24', VpcId=vpc.id, AvailabilityZone = 'us-east-2c')
route_table.associate_with_subnet(SubnetId=subnet.id)
subnet.create_tags(Tags=[{"Key": "Name", "Value": "Public-sub-3"}])
subnet.create_tags(Tags=[{"Key": "Enviroment", "Value": "PRD"}])
print(subnet.id)
subnet = ec2.create_subnet(CidrBlock='10.0.4.0/24', VpcId=vpc.id, AvailabilityZone = 'us-east-2b')
subnet.create_tags(Tags=[{"Key": "Name", "Value": "Private-sub-1"}])
subnet.create_tags(Tags=[{"Key": "Enviroment", "Value": "PRD"}])
print(subnet.id)
subnet = ec2.create_subnet(CidrBlock='10.0.5.0/24', VpcId=vpc.id, AvailabilityZone = 'us-east-2a')
subnet.create_tags(Tags=[{"Key": "Name", "Value": "Private-sub-2"}])
subnet.create_tags(Tags=[{"Key": "Enviroment", "Value": "PRD"}])
print(subnet.id)


#Create NACL entry
nacl = ec2.NetworkAcl('id')
nacl = ec2.create_network_acl(VpcId=vpc.id, TagSpecifications=[{'ResourceType': 'network-acl', 'Tags':[{'Key':'Name', 'Value': 'NACl-subnets'}]}])
tag = nacl.create_tags(Tags=[{'Key': 'Enviroment', 'Value': 'PRD'}])
print(nacl.id)
response = nacl.create_entry(CidrBlock='0.0.0.0/0', Egress=False, NetworkAclId=nacl.id, PortRange={'From': 22, 'To': 22}, Protocol='6', RuleAction='allow',RuleNumber=100)
