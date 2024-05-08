data "aws_ami" "example" {
  most_recent = true
  owners      = ["137112412989"]  

  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.20240429.0-kernel-6.1-x86_64"]
  }
}



resource "aws_instance" "MyEC2Instance" {
  ami                    = data.aws_ami.example.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.id
  vpc_security_group_ids = [aws_security_group.allow_sgs.id]
  subnet_id              = aws_subnet.main.id
  user_data              = file("${path.module}/userdata.tpl")

  root_block_device {
      volume_size = 10
      }

  tags = {
    Name = "dev-node"
  }
}