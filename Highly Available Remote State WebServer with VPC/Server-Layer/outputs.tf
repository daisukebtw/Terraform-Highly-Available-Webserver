# Outputing details from Remote State
output "network_details" {
  value = data.terraform_remote_state.network
}

# Outputing Security Group ID
output "webserver_sg_id" {
  value = aws_security_group.for_webserver.id
}

# Outputing ELB DNS name
output "elb_dns_name" {
  value = aws_elb.main.dns_name
}



