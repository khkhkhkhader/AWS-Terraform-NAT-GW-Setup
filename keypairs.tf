# Generate a private key using the TLS provider
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS key pair using the public key from the private key
resource "aws_key_pair" "my_keypair" {
  key_name   = "my_key_pair"
  public_key = tls_private_key.my_key.public_key_openssh
}

# Provisioner to save the private key to a file locally
resource "null_resource" "generate_key_file" {
  provisioner "local-exec" {
    command = <<EOT
      echo '${tls_private_key.my_key.private_key_pem}' > ~/.ssh/my_terraform_key.pem
      chmod 600 ~/.ssh/my_terraform_key.pem
    EOT
  }

  depends_on = [aws_key_pair.my_keypair]
}
