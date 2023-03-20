resource "aws_instance" "dr_demo_env" {
    ami - "ami-0dfcb1ef8550277af"
    instance_type - "t2.micro"
# key_name - "test_keypair"
}

tags {
    Name = "dr_demo_env"
}