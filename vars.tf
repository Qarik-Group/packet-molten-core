variable "packet_api_key" {
  type = "string"
  description = "Your Packet API Key, grab one from the portal at https://app.packet.net/portal#/api-keys"
}

variable "packet_project_id" {
  type = "string"
  description = "Your Project ID, you can see it here https://app.packet.net/portal#/projects/list/table"
}

variable "packet_facility" {
  type = "string"
  default = "ams1"
  description = "The geographic location of the server datacenter full list: https://support.packet.com/kb/articles/data-centers"
}

variable "node_type"  {
  type = "string"
  default = "c1.small.x86"
  description = "The type of server to use, available types: https://www.packet.com/cloud/servers/"
}

variable "node_count" {
  type = "string"
  default = "3"
  description = "Number of nodes you want, best to use odd numbers when deploying cf or k8s to keep quorum"
}

variable "discovery_url_file" {
  type = "string"
  default = "discovery_url.tmp"
  description = "Etcd Discovery URL File location use to store generated etcd discovery url"
}
