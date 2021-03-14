# ---------------------------------------------------------------------
# Terraform backend config
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# VMWare environment mappings
# ---------------------------------------------------------------------

#variable vsphere_datacenter_corp_prod {
#  name = "vcenter.mydomain.com"
#}
#
#variable "vsphere_lab" {
#  datacenter = "vcenter.mydomain.com"
#  clusters = ["SACLAB200"]
#  vlans = ["vlan240", "vlan241", "vlan245"]
#  datastores = ["SACL200"]
#}

variable "vsphere_user" {
  default = "" 
}

variable "vsphere_password" {
  default = ""
}

variable "vsphere_server" {
  default = ""
}

variable "vsphere_datacenter" {
  description = "The vSphere datacenter"
  default     = "SAC"
}

#variable "vsphere_datastore_cluster" {
#  description = "vSphere storage cluster"
#  default = "SACL200"
#}

variable "vsphere_datastore" {
  description = "vSphere storage cluster"
  default     = "PURE6200253"
}

variable "vsphere_resource_pool" {
  description = "vSphere compute cluster"
  default     = "SACLAB200"
}

variable "vsphere_vlan" {
  description = "The network to use"
  default     = "network-12325"
}

# ---------------------------------------------------------------------
# The VM guest
# ---------------------------------------------------------------------
variable "vm_template" {
  description = "The template for the build"
  default     = "RHEL8" 
} 

variable "vm_hostname" {
  description = "A machine name"
  default     = "myserver"
}

variable "vm_env" {
  description = "The machine environment"
  default     = "lab"
}

variable "vm_domain" {
  description = "The domain to join"
  default     = "local.domain.com"
}

variable "vm_ip_addr" {
  description = "Location of our test server"
  default     = "10.6.240.82"
}

variable "vm_ip_v4_gateway" {
  description = "IPv4 gateway"
  default     = "10.6.240.1"
}

variable "vm_dns_servers" {
  description = "DNS servers"
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "vm_dns_suffixes" {
  description = "Resolvers"
  default     = ["local1.domain.com", "local2.domain.com"]
}

# ---------------------------------------------------------------------
# Provisioning variables
# ---------------------------------------------------------------------
variable "artifactory" {
  description = "Artifactory repo"
  default = "https://jfrogbuild.mydomain.com"
}

variable "ssh_port" {
  description = "Port for SSH requests"
  default = 22
}

variable "ssh_user" {
  description = "SSH user name"
  default = "root"
}

variable "ssh_pass" {
  description = "SSH password"
  default = ""
}

variable "privkey" {
  description = "Private SSH key"
  default = ""
}

variable "cots" {
  default = "yum install --enablerepo=rhel* -y dd-ansible-role-cots && ansible-playbook -i /etc/ansible/hosts /opt/ansible/cache/local/run_role.yml -e run_role=dd-ansible-role-cots"
}
