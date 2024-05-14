data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# local pub key
resource "aws_key_pair" "mo" {
  key_name = "mos-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCy7F/wBRAaqd0fqrFsnoBvavAZ5pIB3FbNvYibADEPlteyCri+sq0Gw1EyVwIyn9c7UKKdJElb32UM7DgG9Gkido8PQ8NAdr5KGDt5fClAhiBsLloYlXcwHIMGNB+jiJO4fpO4CsS8843GyRO0LeF8J5BXr5pohIwg4MMM0UBoFzF5i5WUZr7EQnAyCNYN7OrsJpO+gdjfQbGTiGkaddgC2nVRLUklAQtgngAtz8cWGQEquWuNBegO8VvTag3acI231BVXgQszH1ykVpo5VswtPWoZ5t3fpmFuzfbFaZd5HY0snDJqxDww91G7juiMgvz737G6AkkrTyJoH47GZR6BE7svjvCPlYcgPTUursZbQlFJPYmnFftArJlX/sbm9zdhLmqYmyfezrfOHaG/XF1ZfiOwpPaxz8saVWeFKBi3PXRYvamSJkEWHCsRJ6yJqwqctFPFDM6XBBPI53uUv1DsiT1S4do9HnUWBLHBUMeEpVUyNqtM/WaY9JeWIOUcgos= mohamedabukar@FVFFX3M3Q05P"
}

data "template_file" "init_script" {
  template = file("init-script.tpl")
  vars = {
    hostname = var.vm_name
    dns_name = local.dns_name
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.mo.key_name
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = data.template_file.init_script.rendered

  subnet_id = aws_subnet.this.id
}