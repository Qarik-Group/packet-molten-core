provider "packet" {
  auth_token = "${var.packet_api_key}"
}

provider "ct" {
  version = "0.4.0"
}

resource "tls_private_key" "real_ssh_key" {
  algorithm   = "RSA"
}

resource "packet_project_ssh_key" "ssh_key" {
  name       = "terraform"
  public_key = "${tls_private_key.real_ssh_key.public_key_openssh}"
  project_id = "${var.packet_project_id}"
}

data "ct_config" "container-linux-config" {
  content      = data.template_file.container-linux-config.rendered
  platform     = "packet"
  pretty_print = false
}

data "template_file" "container-linux-config" {
  template = file("${path.module}/templates/clc.yaml")

  vars = {
    discovery_url = "${var.etcd_discovery_url}"
  }
}

resource "packet_device" "bucc" {
  hostname         = "${format("bucc-%02d.example.com", count.index + 1)}"
  operating_system = "coreos_stable"
  plan             = "${var.bucc_type}"

  count            = "1"
  user_data        = data.ct_config.container-linux-config.rendered
  facilities       = ["${var.packet_facility}"]
  project_id       = "${var.packet_project_id}"
  billing_cycle    = "hourly"
  project_ssh_key_ids = ["${packet_project_ssh_key.ssh_key.id}"]
}

resource "packet_device" "node" {
  hostname         = "${format("node-%02d.example.com", count.index + 1)}"
  operating_system = "coreos_stable"
  plan             = "${var.node_type}"

  count            = "${var.node_count}"
  user_data        = data.ct_config.container-linux-config.rendered
  facilities       = ["${var.packet_facility}"]
  project_id       = "${var.packet_project_id}"
  billing_cycle    = "hourly"
  project_ssh_key_ids = ["${packet_project_ssh_key.ssh_key.id}"]
}
