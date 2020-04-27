package ssh_all

sgs = sgs {
all := input.planned_values.root_module.resources
sgs := [res |  res:= all[_]; contains(res.type,"aws_security_group") ]
}

zero_cidr_sgs_for_port_22 := z {
z := [res |  res:= sgs[_]; ingress_zero_cidr_to_port(res.values.ingress[_],22) ]
}

ingress_zero_cidr(ib) {
  zero_cidr(ib.cidr_blocks[_])
}

zero_cidr(cidr) {cidr == "0.0.0.0/0"} {cidr == "::/0"}

# Does a security group only allow traffic to itself?  This is a common
# exception to rules.
#ingress_self_only(ib) {
#  ib.self == true
#  ib.cidr_blocks == []
#  ib.ipv6_cidr_blocks == []
#}

# Does an ingress block allow a given port?
ingress_includes_port(ib, port) {
  ib.from_port == port
  ib.to_port == port
} {
  ib.from_port == 0
  ib.to_port == 0
}

# Does an ingress block allow access from the zero CIDR to a given port?
ingress_zero_cidr_to_port(ib, port) {
  ingress_zero_cidr(ib)
  ingress_includes_port(ib, port)
  #not ingress_self_only(ib)
}

default deny = true
deny {
num_zero_cidr_for_22 := count(zero_cidr_sgs_for_port_22)
num_zero_cidr_for_22 != 0
}
