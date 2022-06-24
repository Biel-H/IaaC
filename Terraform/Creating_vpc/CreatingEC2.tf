# data "aws_ami"  "ubuntu-linux" {
#     most_recent     = true
#     owners             = ["613036180535"]

#     filter {
#         name        =   "name"
#         values       = ["ubuntu/images/hmv-ssd/ubuntu-focal-20.04-amd64-server-*"]
#     }

#     filter {
#         name        = "virtualization-type"
#         values       =   ["hvm"]
#     }
    
#     filter {
#         name        =   "architecture"
#         values       =   ["x86_64"]
#     }
# }

resource "aws_instance" "webserver" {
    ami                                              = "ami-02f3416038bdb17fb"
    instance_type                              = "t2.micro"
    subnet_id                                    = aws_subnet.subpublica1.id
    vpc_security_group_ids               = [aws_security_group.Terra_sg.id]
    key_name                                    = "sus-key"


    tags =  {
        Name    =   "EC2-Terraform"
    }
}
