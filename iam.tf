resource "aws_iam_role" "test_role_for_drs" {
  name = "test_role_for_drs"
  assume_role_policy = "${file("./templates/assume-role-policy.json")}"
}

resource "aws_iam_policy" "test_policy_for_drs" {
  name        = "test_policy_for_drs"
  description = "DRS Admin policy"
  policy      = "${file("./templates/policy.json")}"
}


resource "aws_iam_policy_attachment" "test_role_for_drs_attach" {
  name       = "test_role_for_drs_attach"
  roles      = ["${aws_iam_role.test_role_for_drs.name}"]
  policy_arn = "${aws_iam_policy.test_policy_for_drs.arn}"
}

# Adding a new Role for an EC2 to access s3 and rds
resource "aws_iam_instance_profile" "DRS_TEST_profile" {
  name = "DRS_TEST_profile"
  role = "${aws_iam_role.test_role_for_drs.name}"
}