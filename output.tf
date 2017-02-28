output "vpc_id" {
    value = "${var.vpc_id}"
}
output "priv_sn_ids" {
    value = ["${aws_subnet.priv_sn.*.id}"]
}
output "priv_sn_azs" {
    value = ["${aws_subnet.priv_sn.*.availability_zone}"]
}
output "nat_inst_sg_ids" {
    value = ["${aws_security_group.nat_inst_sg.*.id}"]
}
output "nat_inst_sg_names" {
    value = ["${aws_security_group.nat_inst_sg.*.name}"]
}
output "nat_instance_ids" {
    value = ["${aws_instance.nat_instance.*.id}"]
}
output "nat_instance_public_ips" {
    value = ["${aws_instance.nat_instance.*.public_ip}"]
}
output "nat_instance_public_dns" {
    value = ["${aws_instance.nat_instance.*.public_dns}"]
}
output "priv_sn_rt_ids" {
    value = ["${aws_route_table.priv_sn_rt.*.id}"]
}
output "res_nameprefix" {
    value = "${var.res_nameprefix}"
}
output "env" {
    value = "${var.env}"
}
output "region" {
    value = "${var.region}"
}
output "vpc_netprefix" {
    value = "${var.vpc_netprefix}"
}
output "pub_sn_netnumber" {
    value = "${var.pub_sn_netnumber}"
}
output "pub_sn_netmask" {
    value = "${var.pub_sn_netmask}"
}
output "priv_sn_netnumber" {
    value = "${var.priv_sn_netnumber}"
}
output "priv_sn_netmask" {
    value = "${var.priv_sn_netmask}"
}
