#!/bin/bash

vpcid=$(aws ec2 describe-vpcs --filters "Name=tag-value, Values=${1}_vpc" | jq '.Vpcs[0].VpcId' | sed s/\"//g)
private_subnets=$(aws ec2 describe-subnets --filters "Name=vpc-id, Values=${vpcid}, Name=tag-value, Values=${1}_private_subnet*" | jq '.Subnets[].SubnetId' | tr '\n' ',' | sed s/,$//)
public_subnets=$(aws ec2 describe-subnets --filters "Name=vpc-id, Values=${vpcid}, Name=tag-value, Values=${1}_public_subnet*" | jq '.Subnets[].SubnetId' | tr '\n' ',' | sed s/,$//)
bastion_security_group_id=$(aws ec2 describe-security-groups --filters "Name=vpc-id, Values=${vpcid}, Name=tag-value, Values=${1}_bastion_ssh_sg*" | jq '.SecurityGroups[0].GroupId')
mgmtserver_security_group_id=$(aws ec2 describe-security-groups --filters "Name=vpc-id, Values=${vpcid}, Name=tag-value, Values=${1}_mgmtserver_sg*" | jq '.SecurityGroups[0].GroupId')
nat_ip=$(aws ec2 describe-nat-gateways --filter "Name=vpc-id, Values=${vpcid}" | jq ".NatGateways[0].NatGatewayAddresses[0].PublicIp")
route53_hosted_zone_id=$(aws route53 list-hosted-zones-by-name --dns-name ${2} | jq '.HostedZones[0].Id' | sed 's/\/hostedzone\///g')
app_security_group_id=$(aws ec2 describe-security-groups --filters "Name=vpc-id, Values=${vpcid}, Name=tag-value, Values=nsbno-${1}" | jq '.SecurityGroups[0].GroupId')

echo "
variable \"vpc_id\" { default=\"$vpcid\" }
variable \"private_subnet_ids\" {
  default = [$private_subnets]
}
variable \"public_subnet_ids\" {
  default = [$public_subnets]
}
variable \"bastion_security_group_id\" { default = $bastion_security_group_id }
variable \"mgmtserver_security_group_id\" { default = $mgmtserver_security_group_id }
variable \"nat_ip\" { default = ${nat_ip} }
variable \"route53_hosted_zone_id\" { default = ${route53_hosted_zone_id} }
variable \"app_security_group_id\" { default = ${app_security_group_id} }
"
