resource "aws_key_pair" "my_key_pair" {
  key_name   = var.keyName
  public_key = file(var.publicKeyLocation)
}
