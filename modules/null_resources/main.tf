
resource "null_resource" "install_nginx_ingress" {
  depends_on = [var.depends-on]

  provisioner "local-exec" {
    command = var.command
  }
}
