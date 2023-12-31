data "aws_vpcs" "default" {
}

resource "aws_security_group" "web_sg" {
  name        = var.sg_name
  description = "Security group for the web server"
  vpc_id      = data.aws_vpcs.default.ids[0]

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1235
    to_port     = 1235
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

