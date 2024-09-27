locals {
  subnets = ["${aws_subnet.terraform-blue-green}"] 
}

resource "aws_instance" "terraform-blue-green" {
  count                  = 2
  ami                    = "ami-08d8ac128e0a1b91c"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.terraform-blue-green.*.id[0]
  vpc_security_group_ids = ["${aws_security_group.terraform-blue-green.id}"]
  key_name               = "bluegreendev"

  user_data = file("userdata.sh")

  tags = {
    Name                  = "Terraform Blue/Green ${count.index + 1} (v${var.infrastructure_version})"
    InfrastructureVersion = "${var.infrastructure_version}"
  }

}

output "instance_public_ips" {
  value = "${aws_instance.terraform-blue-green.*.public_ip}"
}
