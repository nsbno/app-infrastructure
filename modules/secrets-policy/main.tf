data "aws_caller_identity" "current" {}

data "template_file" "secret-arns" {
  template = "${file("${path.module}/templates/secret-arn.tpl")}"
  count = "${length(var.secret_ids)}"
  vars {
    account_id = "${data.aws_caller_identity.current.account_id}"
    region = "${var.aws_region}"
    secret_id = "${element(values(var.secret_ids[count.index]), 0)}"
  }
}

data "template_file" "get-secret-policy-template" {
    template = "${file("${path.module}/templates/get-secret-policy.tpl")}"
    vars {
        arns = "${join(",", data.template_file.secret-arns.*.rendered)}"
    }
}

module "get-secret-policy" {
    source = "git@github.com:nsbno/app-infrastructure.git//modules/iam_policy?ref=8347a3b"
    policy = "${data.template_file.get-secret-policy-template.rendered}"
    policy_name = "${var.env}-${var.appname}-get-secret-policy"
    policy_description = "Allow getting secret from Secrets Manager"
}

module "get-secret-policy-attachment" {
    source = "git@github.com:nsbno/app-infrastructure.git//modules/policy_attachment?ref=8347a3b"
    role = "${var.instance_profile}"
    policy_arn = "${module.get-secret-policy.arn}"
}
