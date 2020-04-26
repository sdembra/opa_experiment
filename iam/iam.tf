resource "aws_iam_user" "test-user" {
  name = "test-user-delete"

  tags = {
    tag-key = "delete"
  }
}

resource "aws_iam_access_key" "test-user" {
  user = "${aws_iam_user.test-user.name}"
}

resource "aws_iam_user_policy" "test-user-policy" {
  name = "test-user-policy"
  user = "${aws_iam_user.test-user.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy" "test-user-policy1" {
  name = "test-user-policy1"
  user = "${aws_iam_user.test-user.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
