variable "keyName" {
      type = string
      default = "myterraformkey"
}

variable "publicKeyLocation" {
      type = string
      default = "../myterraformkey.pub"
}

variable "privateKeyLocation" {
      type = string
      default = "../myterraformkey"
}

variable "instanceType" {
      type = string
      default = "t2.micro"
}

variable "instanceTagName" {
      type = string
      default = "MyContainerOS"
}

variable "sg_name" {
      type = string
      default = "my_sg"
}

