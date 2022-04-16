variable "base_dir" {
  type    = string
  default = "/opt/data/packer"
}

variable "centos_release" {
  type    = string
  default = "2009"
}

variable "centos_version" {
  type    = string
  default = "7.9"
}

variable "esxi_datastore" {
  type    = string
  default = "${env("ESXI_DATASTORE")}"
}

variable "esxi_host_ip" {
  type    = string
  default = "${env("ESXI_HOST")}"
}

variable "esxi_host_password" {
  type    = string
  default = "${env("ESXI_PASSWORD")}"
}

variable "esxi_host_username" {
  type    = string
  default = "${env("ESXI_USERNAME")}"
}

variable "esxi_network" {
  type    = string
  default = "VM Network"
}

variable "full_release" {
  type    = string
  default = "${env("RELEASE_VERSION")}"
}

variable "output_dir" {
  type    = string
  default = "OUTPUT_DIR"
}

variable "ssh_password" {
  type    = string
  default = "nutanix/4u"
}

variable "ssh_timeout" {
  type    = string
  default = "10m"
}

variable "ssh_username" {
  type    = string
  default = "centos"
}

variable "vmware_tools_file" {
  type    = string
  default = "VMwareTools-10.3.22-15902021.tar.gz"
}

source "vmware-iso" "centos-vmware-iso" {
  boot_command     = ["<esc>", "<wait>", "linux inst.ks=http://10.46.8.152/Users/saratkumar.k/Packer/anaconda-ks.cfg biosdevname=0 net.ifnames=0", "<enter>"]
  boot_wait        = "7s"
  communicator     = "ssh"
  disk_size        = 51200
  disk_type_id     = "thin"
  format           = "ova"
  guest_os_type    = "rhel7-64"
  headless         = false
  iso_checksum     = "07b94e6b1a0b0260b94c83d6bb76b26bf7a310dc78d7a9c7432809fb9bc6194a"
  iso_url          = "http://centos.excellmedia.net/7.9.2009/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso"
  output_directory = "${var.base_dir}/${var.output_dir}/CentOS-7-x86_64-${var.full_release}"
  ovftool_options  = [ "--shaAlgorithm=SHA256" ]
  remote_datastore = "${var.esxi_datastore}"
  remote_host      = "${var.esxi_host_ip}"
  remote_password  = "${var.esxi_host_password}"
  remote_type      = "esx5"
  remote_username  = "${var.esxi_host_username}"
  shutdown_command = "sudo -S /usr/sbin/shutdown -h now"
  ssh_password     = "${var.ssh_password}"
  ssh_pty          = "true"
  ssh_username     = "${var.ssh_username}"
  ssh_wait_timeout = "60m"
  vm_name          = "CentOS-7-x86_64-${var.full_release}"
  vmdk_name        = "CentOS-7-x86_64-${var.full_release}"
  vmx_data = {
    "ethernet0.addressType"            = "generated"
    "ethernet0.generatedAddressOffset" = "0"
    "ethernet0.networkName"            = "${var.esxi_network}"
    "ethernet0.present"                = "TRUE"
    "ethernet0.startConnected"         = "TRUE"
    "ethernet0.virtualDev"             = "e1000"
    "ethernet0.wakeOnPcktRcv"          = "FALSE"
    memsize                            = "2048"
    numvcpus                           = "2"
  }
  vmx_data_post = {
    "ethernet0.virtualDev"  = "vmxnet3"
    "ide1:0.clientDevice"   = "TRUE"
    "ide1:0.fileName"       = "emptyBackingString"
    "ide1:0.startConnected" = "FALSE"
  }
  vmx_remove_ethernet_interfaces = true
  vnc_disable_password           = true
  vnc_port_max                   = 6000
  vnc_port_min                   = 5987
}

build {
  sources = ["source.vmware-iso.centos-vmware-iso"]

  provisioner "file" {
    destination = "/tmp/${var.vmware_tools_file}"
    source      = "/opt/data/iso/${var.vmware_tools_file}"
  }

  provisioner "shell" {
    scripts = ["scripts/centos-${var.centos_version}/repo.sh", "scripts/centos-7-vmware-tools_install.sh", "scripts/common/sshd.sh", "scripts/centos/locale.sh", "scripts/centos-${var.centos_version}/cleanup.sh", "scripts/common/minimize.sh"]
  }

}

