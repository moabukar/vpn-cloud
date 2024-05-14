data "aws_route53_zone" "mo-vpc" {
  name         = "mo-vpc.com."
  private_zone = false
}
data "aws_eip" "ip" {
  public_ip = [aws_eip.ip.public_ip]  
}

locals {
  dns_name = "vpn-aws.${data.aws_route53_zone.mo-vpc.name}"
}

resource "aws_route53_record" "dns" {
  zone_id = data.aws_route53_zone.mo-vpc.zone_id
  name    = local.dns_name
  type    = "A"
  ttl     = 5

  records = [data.aws_eip.ip.public_ip]
}
