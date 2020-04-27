package iam
iam_policies = policies {
all := input.planned_values.root_module.resources
policies := [res |  res:= all[_]; contains(res.type,"aws_iam_user_policy") ]
#wild := [wild | wild := policies[_]; contains(wild.type,"aws_iam_user_policy")]
}

num_policies = num {
   #all := iam_policies
   #vol := [res |  res:= all[_]; res.type == "aws_ebs_volume"]
   #enc_vol := [res | res:=vol[_]; res.values.encrypted == true ]
   num := count(iam_policies)
}

policies := p{
p := [policy | policy := json.unmarshal(iam_policies[_].values.policy)]

#wild := [policy | policy := policies[_];  contains(policy.Statement[_].Effect,"Allow")]

#wild := [policy | policy := policies[_].change.after.policy;  contains(policy,"*")]
#wild_policy := wild.change.after.policy
}

unmarshaled_policies := p {
  all := policies
  p := [pol | pol:= all[_]]#; is_wildcard_policy(pol)]
  #a := [pol | pol:= all[_]; pol.Statement[_].Effect == "Allow" ]
  #b := [pol | pol:= all[_]; pol.Statement[_].Resource == "*"]
  #c := [pol | pol:= all[_]; contains(pol.Statement[_].Action[_],"*")]
 # p := [pol | pol:= all[_]; pol.Statement[_].Effect == "Allow" & pol.Statement[_].Resource == "*" & contains(pol.Statement[_].Action[_],"*")]
}

#p:=unmarshaled_policies[0]
#default is_wildcard_policy = false

wildcard_policies := p {
#all := input.planned_values.root_module.resources
p := [res |  res:= unmarshaled_policies[_]; is_wildcard_policy(res) ]
#wild := [wild | wild := policies[_]; contains(wild.type,"aws_iam_user_policy")]
}

num_wc_policies = num {
   #all := iam_policies
   #vol := [res |  res:= all[_]; res.type == "aws_ebs_volume"]
   #enc_vol := [res | res:=vol[_]; res.values.encrypted == true ]
   num := count(wildcard_policies)
}

default allowed = false
allowed {
    num_wc_policies == 0
}

is_wildcard_policy(p) {
  statements = as_array(p.Statement)
  statement = statements[_]

  statement.Effect == "Allow"

  resources = as_array(statement.Resource)
  resource = resources[_]
  resource == "*"

  actions = as_array(statement.Action)
  action = actions[_]
  contains(action,"*")
}

as_array(x) = [x] {not is_array(x)} else = x {true}
