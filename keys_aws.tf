resource "aws_key_pair" "vprofile-keypair-terraform-project16" {
  key_name = "vprofile-keypair-terraform-project16"
  # this is the name on the AWS console
  public_key = file(var.PUB_KEY_PATH)
}

# resource "aws_secretsmanager_secret" "my_private_key" {
#   name = "my-private-key"
#   description = "My SSH private key"
#   secret_string = "-----BEGIN RSA PRIVATE KEY-----\n...YOUR_PRIVATE_KEY...\n-----END RSA PRIVATE KEY-----"
# }
# Access the secret in your Terraform resource

# resource "aws_instance" "my_server" {

#   # ...

#   # Use the aws_secretsmanager_secret_version data source to get the decrypted value

#   associate_public_ip_address = true

#   key_name = aws_secretsmanager_secret_version.my_private_key.arn

# }