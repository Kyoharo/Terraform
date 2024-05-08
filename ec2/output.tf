output "dev_public_ip" {
  value = aws_instance.MyEC2Instance.public_ip
}