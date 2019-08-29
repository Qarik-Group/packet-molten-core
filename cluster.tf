provider "packet" {
  auth_token = "${var.packet_api_key}"
}

provider "ct" {
  version = "0.4.0"
}

resource "tls_private_key" "ssh_key" {
  algorithm   = "RSA"
}

resource "packet_project_ssh_key" "ssh_key" {
  name       = "terraform"
  public_key = "${tls_private_key.ssh_key.public_key_openssh}"
  project_id = "${var.packet_project_id}"
}

resource "tls_private_key" "docker_key" {
  algorithm   = "RSA"
}

resource "tls_self_signed_cert" "docker_ca" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.docker_key.private_key_pem}"

  subject {
    common_name = "docker"
  }

  validity_period_hours = 43800
  is_ca_certificate = true

  allowed_uses = [
    "cert_signing",
  ]
}

resource "tls_cert_request" "docker_client_csr" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.docker_key.private_key_pem}"

  subject {
    common_name  = "client"
  }
}

resource "tls_locally_signed_cert" "docker_client_cert" {
  cert_request_pem   = "${tls_cert_request.docker_client_csr.cert_request_pem}"
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = "${tls_private_key.docker_key.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.docker_ca.cert_pem}"

  validity_period_hours = 43800

  allowed_uses = [
    "client_auth",
  ]
}

data "template_file" "container-linux-config" {
  template = file("${path.module}/templates/clc.yaml")
  count = "${var.node_count}"

  vars = {
    index = count.index
    flannel_cidr = cidrsubnet("10.1.0.0/16", 8, count.index)
    flannel_cidr_dashed = replace(cidrsubnet("10.1.0.0/16", 8, count.index), "/", "-")
    discovery_url = "${file(var.discovery_url_file)}"
    docker_ca = "${tls_self_signed_cert.docker_ca.cert_pem}"
    docker_key = "${tls_private_key.docker_key.private_key_pem}"
    docker_client_cert = "${tls_locally_signed_cert.docker_client_cert.cert_pem}"
  }

  depends_on = [template_file.etcd_discovery_url]
}

data "ct_config" "container-linux-config" {
  count = "${var.node_count}"
  content      = "${element(data.template_file.container-linux-config.*.rendered, count.index)}"
  platform     = "packet"
  pretty_print = false

  depends_on = [data.template_file.container-linux-config]
}

resource "template_file" "etcd_discovery_url" {
  template = "/dev/null"

  provisioner "local-exec" {
    command = "curl https://discovery.etcd.io/new?size=${(var.node_count)} > ${var.discovery_url_file}"
  }
}

resource "packet_device" "node" {
  hostname         = "${format("node-z%01d.bare-metal.cf", count.index)}"
  operating_system = "coreos_stable"
  plan             = "${var.node_type}"

  count            = "${var.node_count}"
  user_data        = "${element(data.ct_config.container-linux-config.*.rendered, count.index)}"
  facilities       = ["${var.packet_facility}"]
  project_id       = "${var.packet_project_id}"
  billing_cycle    = "hourly"
  project_ssh_key_ids = ["${packet_project_ssh_key.ssh_key.id}"]
}

output "nodes" {
  value = ["${packet_device.node.*.access_public_ipv4}"]
}

output "flannel_cidrs" {
  value = ["${data.template_file.container-linux-config.*.vars.flannel_cidr}"]
}

output "docker_client_cert" {
  value = "${tls_locally_signed_cert.docker_client_cert.cert_pem}"
}

output "docker_ca" {
  value = "${tls_self_signed_cert.docker_ca.cert_pem}"
}

output "docker_key" {
  value = "${tls_private_key.docker_key.private_key_pem}"
}


output "ssh_key" {
  value = "${tls_private_key.ssh_key.private_key_pem}"
}
