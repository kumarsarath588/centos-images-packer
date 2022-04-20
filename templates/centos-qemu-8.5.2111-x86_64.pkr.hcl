variable "base_dir" {
  type    = string
  default = "/opt/data/packer"
}

variable "centos_release" {
  type    = string
  default = "2111"
}

variable "centos_version" {
  type    = string
  default = "8.5"
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

variable "ssh_username" {
  type    = string
  default = "centos"
}

source "qemu" "centos-qemu" {
  accelerator      = "kvm"
  boot_command     = ["<tab> text ks=http://10.46.8.152/Users/saratkumar.k/Packer/centos8-ks-kvm.cfg<enter><wait>"]
  boot_wait        = "10s"
  disk_interface   = "virtio"
  disk_size        = "51200"
  format           = "qcow2"
  headless         = true
  iso_checksum     = "sha256:3b795863001461d4f670b0dedd02d25296b6d64683faceb8f2b60c53ac5ebb3e"
  iso_url          = "https://vault.centos.org/8.5.2111/isos/x86_64/CentOS-8.5.2111-x86_64-dvd1.iso"
  net_device       = "virtio-net"
  output_directory = "${var.base_dir}/${var.output_dir}/CentOS-8-x86_64-${var.full_release}"
  qemuargs         = [["-m", "2048M"], ["-smp", "cpus=1,maxcpus=16,cores=4"]]
  shutdown_command = "sudo -S /usr/sbin/shutdown -h now"
  ssh_password     = "${var.ssh_password}"
  ssh_timeout      = "20m"
  ssh_username     = "${var.ssh_username}"
  vm_name          = "CentOS-8-x86_64-${var.full_release}"
  vnc_bind_address = "0.0.0.0"
}

build {
  sources = ["source.qemu.centos-qemu"]

  provisioner "shell" {
    scripts = ["scripts/centos-${var.centos_version}/repo.sh", "scripts/common/sshd.sh", "scripts/centos/locale.sh", "scripts/centos-${var.centos_version}/cleanup.sh", "scripts/common/minimize.sh"]
  }

}
