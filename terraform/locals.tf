locals {
  domain    = yamldecode(file(var.domain_config_file))
  public_ip = chomp(data.http.public_ip.response_body)
  converted_rules = fileset("${path.root}/files/sigma/converted/", "**.rule")
  custom_kql = fileset("${path.root}/files/custom_kql/", "**.kql")
}