output "endpoint" {
  value="${data.template_file.hostname.rendered}"
}

# output "replica_set_name" {
#   value="${vars.replica_set_name}"
# }