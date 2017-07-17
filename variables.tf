variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "res_nameprefix" {}
variable "env" {
    default = "prod"
}
variable "region" {
    default = "us-east-1"
}
variable "vpc_netprefix" {
    default = "10.231"
}
variable "pub_sn_netnumber" {
    default = "23"
}
variable "pub_sn_netmask" {
    default = "24"
}
variable "vpc_id" {}
variable "pub_sn_azs" {
    type = "list"
}
variable "pub_sn_ids" {
    type = "list"
}
variable "nat_instance_ami"{
    default = "ami-dd3dd7cb"
}
variable "nat_instance_type"{
    default = "t2.micro"
}
variable "nat_instance_namesuffix" {
    default = "-nat-inst"
}
variable "nat_instance_addr" {
    default = "5"
}
variable "nat_instance_key_name" {}
variable "nat_inst_sg_namesuffix" {
    default = "-nat-inst-sg"
}
variable "priv_sn_namesuffix" {
    default = "-vpc-priv-sn"
}
variable "priv_sn_netnumber" {
    default = "24"
}
variable "priv_sn_netmask" {
    default = "24"
}
variable "priv_sn_rt_namesuffix" {
    default = "-priv-sn-rt"
}
variable "path_to_file" {
    default = "./puppetagent.sh"
}
variable "puppetmaster_dns" {}
variable "puppet_ip" {}
variable "priv_sn_ids" { type = "list "}
