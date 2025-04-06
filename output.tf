output "public_apache_public_ip" {
  description = "Public IP of the Public Apache EC2 instance."
  value       = aws_instance.Pub_EC2.public_ip
}

output "private_apache_private_ip" {
  description = "Private IP of the private Apache EC2 instance."
  value       = aws_instance.Priv_Ec2.private_ip
}

output "Private_key_path" {
  description = "Private Key path"
  value       = "~/.ssh/my_terraform_key.pem"
}