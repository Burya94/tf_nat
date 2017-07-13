provider "aws" {
    region     = "${var.region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}

resource "aws_security_group" "nat_inst_sg" {
    count  = "${length(var.pub_sn_ids)}"
    name   = "${var.res_nameprefix}${var.env}${var.nat_inst_sg_namesuffix}${count.index}"
    vpc_id = "${var.vpc_id}"
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["${var.vpc_netprefix}.${var.priv_sn_netnumber}${count.index}.0/${var.priv_sn_netmask}"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["${var.vpc_netprefix}.${var.priv_sn_netnumber}${count.index}.0/${var.priv_sn_netmask}"]
    }

    tags {
        Name = "${var.res_nameprefix}${var.env}${var.nat_inst_sg_namesuffix}${count.index}"
    }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/${var.path_to_file}")}"

  vars {
    dns_name = "${var.puppetmaster_dns}"
    env      = "${var.env}"
    puppet_ip   = "${var.puppet_ip}"
  }
}

resource "aws_instance" "nat_instance" {
    count                       = "${length(var.pub_sn_ids)}"
    ami                         = "${var.nat_instance_ami}"
    instance_type               = "${var.nat_instance_type}"
    key_name                    = "${var.nat_instance_key_name}"
    availability_zone           = "${element(var.pub_sn_azs, count.index)}"
    subnet_id                   = "${element(var.pub_sn_ids, count.index)}"
    vpc_security_group_ids      = ["${element(aws_security_group.nat_inst_sg.*.id, count.index)}"]
    associate_public_ip_address = true
    private_ip                  = "${var.vpc_netprefix}.${var.pub_sn_netnumber}${count.index}.${var.nat_instance_addr}"
    vpc_security_group_ids      = ["${aws_security_group.nat_inst_sg.*.id[count.index]}"]
    user_data                   = "${data.template_file.userdata.rendered}"
    depends_on                  = ["aws_security_group.nat_inst_sg"]
    tags {
        Name = "${var.res_nameprefix}${var.env}${var.nat_instance_namesuffix}${count.index}"
    }
}

resource "aws_route_table" "priv_sn_rt" {
    count  = "${length(var.pub_sn_ids)}"
    vpc_id = "${var.vpc_id}"
    route {
        cidr_block     = "0.0.0.0/0"
        instance_id = "${aws_instance.nat_instance.*.id[count.index]}"
    }

    tags {
        Name = "${var.res_nameprefix}${var.env}${var.priv_sn_rt_namesuffix}${count.index}"
    }
}

resource "aws_subnet" "priv_sn" {
    count             = "${length(var.pub_sn_ids)}"
    vpc_id            = "${var.vpc_id}"
    availability_zone = "${element(var.pub_sn_azs, count.index)}"
    cidr_block        = "${var.vpc_netprefix}.${var.priv_sn_netnumber}${count.index}.0/${var.priv_sn_netmask}"
    depends_on        = ["aws_instance.nat_instance"]
    tags {
        Name = "${var.res_nameprefix}${var.env}${var.priv_sn_namesuffix}${count.index}"
    }
}

resource "aws_route_table_association" "rt_priv_sn_assoc" {
    count          = "${length(var.pub_sn_ids)}"
    subnet_id      = "${aws_subnet.priv_sn.*.id[count.index]}"
    route_table_id = "${aws_route_table.priv_sn_rt.*.id[count.index]}"
    depends_on     = ["aws_subnet.priv_sn","aws_route_table.priv_sn_rt"]
}
