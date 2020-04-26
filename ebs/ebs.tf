provider "aws" {
    region = "us-east-1"
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1"
  size              = 1
  encrypted        = "true"

  tags = {
    Name = "HelloWorld"
  }
}


resource "aws_ebs_volume" "example1" {
  availability_zone = "us-east-1"
  size              = 1

  tags = {
    Name = "Hello"
  }
}
