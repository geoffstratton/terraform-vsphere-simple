# ---------------------------------------------------------------------------------------------------------------------
# VMWare Environment
# ---------------------------------------------------------------------------------------------------------------------

provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_user
  password             = var.vsphere_password
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "SAC"
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

#data "vsphere_network" "network" {
#  name          = var.vsphere_vlan
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

# ---------------------------------------------------------------------------------------------------------------------
# Virtual Machine Setup
# ---------------------------------------------------------------------------------------------------------------------

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  //count 	   = "2"
  //name             = "tftest-${count.index + 1}"
  name		   = var.vm_hostname
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2 
  memory   = 4096 
  guest_id = "rhel7_64Guest" 

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = var.vsphere_vlan
    adapter_type = "vmxnet3"
  }

  disk {
    label             = "${var.vm_hostname}.vmdk" 
    size              = data.vsphere_virtual_machine.template.disks.0.size
    #thin_provisioned = true
    #eagerly_scrub    = false
    eagerly_scrub     = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned  = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    #unit_number      = 0
  }

  // If you need another disk, be sure to assign a unit_number
  #disk {
  #  unit_number      = 1
  #  label            = "${var.vm_hostname}1.vmdk"
  #  size             = data.vsphere_virtual_machine.template.disks.1.size
  #  eagerly_scrub    = data.vsphere_virtual_machine.template.disks.1.eagerly_scrub
  #  thin_provisioned = data.vsphere_virtual_machine.template.disks.1.thin_provisioned
  #}

  clone {

    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      network_interface {
        ipv4_address = var.vm_ip_addr 
        ipv4_netmask = 24
      }
       
      linux_options {
        host_name = var.vm_hostname 
        //host_name = "server.domain.com""
        domain    = var.vm_domain
      }

      ipv4_gateway    = var.vm_ip_v4_gateway 
      dns_server_list = var.vm_dns_servers
      dns_suffix_list = var.vm_dns_suffixes 
    }
  }
  
  //
  // Establish an SSH connection
  // 
  connection {
    type        = "ssh"
    host        = var.vm_ip_addr 
    user        = var.ssh_user
    //private_key = file("${path.module}/keys/id_rsa")
    password   = var.ssh_pass
    port        = var.ssh_port
    script_path = "/root/provision.sh"
  }

  //
  // Do our bootstrapping
  //  
  # Use the file provisioner if you need a configurator script
  #provisioner "file" {
  #  source      = "bootstrap.sh"
  #  destination = "/home/root/dd_bootstrap.sh"
  #}

  provisioner "remote-exec" {
    inline = [
      #"yum install -y yum-utils realmd",
      #"yum remove -y katello*",
      #"chmod +x /home/terraform/creator.sh",
      #"/bin/sh -e /home/terraform/creator.sh",
      #"echo \"${var.vm_hostname}:${var.vm_env}:TERRAFORM:Terraform POC (INT):version 0.1:x:Unix Infrastructure::LAB:Infrastructure Team\" > /.designator",
      #"wget --no-check-certificate ${var.artifactory}artifactory/delta-sysadmin/scripts/dd_bootstrap.sh",
      #"chmod +x dd_bootstrap.sh",
      #"./dd_bootstrap.sh > /var/log/bootstrapped.log"
      #"./dd_bootstrap.sh",
      #"${var.cots}"
    ]
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# DNS Registration
# ---------------------------------------------------------------------------------------------------------------------

#provider "dns" {
#  update {
#    server        = "domain.com"
#    key_name      = ""
#    key_algorithm = ""
#    key_secret    = ""
#  }

#  resource "dns_a_record_set" "dns-forward" {
#    zone      = "local.domain.com"
#    name      = var.vm_name
#    addresses = [ "${vsphere_virtual_machine.vm.default_ip_address}" ]
#    ttl       = 3600
#  }

#  locals {
#    octets = "${split(".", vsphere_virtual_machine.vm.default_ip_address)}"
#  }

#  resource "dns_ptr_record" "dns-reverse" {
#    zone = "${local.octets[2]}.${local.octets[1]}.${local.octets[0]}.in-addr.arpa."
#    name = "${local.octets[3]}"
#    ptr  = "${var.vm_name}"
#    ttl  = 3600
#  }
#}
