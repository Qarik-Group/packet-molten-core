provider "packet" {
  auth_token = "${var.packet_api_key}"
}

resource "tls_private_key" "ssh_key" {
  algorithm   = "RSA"
}

resource "packet_project_ssh_key" "ssh_key" {
  name       = "terraform"
  public_key = "${tls_private_key.ssh_key.public_key_openssh}"
  project_id = "${var.packet_project_id}"
}

data "template_file" "ignition-config" {
  template = file("${path.module}/templates/config.ign")

  vars = {
    discovery_url = "${file(var.discovery_url_file)}"
  }

  depends_on = [template_file.etcd_discovery_url]
}

resource "template_file" "etcd_discovery_url" {
  template = "/dev/null"

  provisioner "local-exec" {
    command = "curl https://discovery.etcd.io/new?size=${(var.node_count)} > ${var.discovery_url_file}"
  }
}

resource "packet_device" "node" {
  hostname         = "${format("node-z%01d.molten-core", count.index)}"
  operating_system = "coreos_stable"
  plan             = "${var.node_type}"

  count            = "${var.node_count}"
  user_data        = "${data.template_file.ignition-config.rendered}"
  facilities       = ["${var.packet_facility}"]
  project_id       = "${var.packet_project_id}"
  billing_cycle    = "hourly"
  project_ssh_key_ids = ["${packet_project_ssh_key.ssh_key.id}"]
}

output "nodes" {
  value = ["${packet_device.node.*.access_public_ipv4}"]
}

output "ssh_key" {
  value = "${tls_private_key.ssh_key.private_key_pem}"
}
