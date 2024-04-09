resource "aws_key_pair" "vprofile-keypair-terraform-project16" {
    key_name = "vprofile-keypair-terraform-project16"
    # this is the name on the AWS console
    public_key = file(var.PUB_KEY_PATH)
}
