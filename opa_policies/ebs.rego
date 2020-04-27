package ebs
num_volumes = num {
    all := input.planned_values.root_module.resources
    vol := [res |  res:= all[_]; res.type == "aws_ebs_volume"]
    num := count(vol)
}

num_enc_volumes = num {
    all := input.planned_values.root_module.resources
    vol := [res |  res:= all[_]; res.type == "aws_ebs_volume"]
    enc_vol := [res | res:=vol[_]; res.values.encrypted == true ]
    num := count(enc_vol)
}


default allowed = false
allowed {
    num_enc_volumes == num_volumes
}
