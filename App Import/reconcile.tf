resource "null_resource" "reconcile" {
  provisioner "local-exec" {
    command = "pwsh ./4-reconcile.ps1"
    working_dir = "${path.module}" # ensures it runs in repo root
  }

  triggers = {
    always_run = timestamp()
  }
}