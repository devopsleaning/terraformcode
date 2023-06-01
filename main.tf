provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_role" "custom_role" {
  name               = "custom_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "custom_ec2_attachment" {
  role       = aws_iam_role.custom_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "custom_s3_attachment" {
  role       = aws_iam_role.custom_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "custom_rds_attachment" {
  role       = aws_iam_role.custom_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_instance_profile" "custom_instance_profile" {
    name = "custom-instance-profile"
    role = aws_iam_role.custom_role.name
  
}

resource "aws_instance" "name" {
  ami                  = "ami-01107263728f3bef4"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.custom_instance_profile.name
}