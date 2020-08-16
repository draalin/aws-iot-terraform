# Create Iam Key Pair
resource "aws_key_pair" "initialize" {
  key_name   = var.key_name
  public_key = file(var.id_rsa_pub)
}

# EC2 Instance
resource "aws_instance" "iot" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.iot.id]
  user_data                   = data.template_file.iot.rendered

  provisioner "file" {
    source      = "app"
    destination = "/home/ubuntu"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.iot.public_dns
    private_key = file(var.id_rsa)
  }

  tags = {
    Name = var.project_name
  }
}

resource "aws_security_group" "iot" {
  name        = var.project_name
  description = var.project_name

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.project_name
  }
}


# IoT
resource "aws_iot_thing" "iot" {
  name = var.project_name
}

resource "aws_iot_certificate" "iot" {
  active = true
}

resource "aws_iot_thing_principal_attachment" "iot" {
  principal = aws_iot_certificate.iot.arn
  thing     = aws_iot_thing.iot.name
}

resource "aws_iot_policy" "iot" {
  name = var.project_name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iot:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iot_policy_attachment" "iot" {
  policy = aws_iot_policy.iot.name
  target = aws_iot_certificate.iot.arn
}

resource "aws_iot_thing_principal_attachment" "iot2" {
  principal = aws_cognito_identity_pool.iot.id
  thing     = aws_iot_thing.iot.name
}

# Cognito User Pool
resource "aws_cognito_user_pool" "iot" {
  name = var.project_name
}

resource "aws_cognito_user_pool_client" "iot" {
  name = var.project_name

  user_pool_id = aws_cognito_user_pool.iot.id
}

# Cognito Identity Pool
resource "aws_cognito_identity_pool" "iot" {
  identity_pool_name               = var.project_name
  allow_unauthenticated_identities = true

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.iot.id
    provider_name           = aws_cognito_user_pool.iot.endpoint
    server_side_token_check = false
  }

}

resource "aws_iam_role" "iot" {
  name = var.project_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.iot.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "unauthenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iot" {
  name = var.project_name
  role = "${aws_iam_role.iot.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents",
        "cognito-sync:*",
        "cognito-identity:*"
      ],
      "Resource": [
        "*"
      ]
    },
        {
            "Effect": "Allow",
            "Action": [
                "iot:*"
            ],
            "Resource": [
                "*"
            ]
        }
  ]
}
EOF
}

resource "aws_cognito_identity_pool_roles_attachment" "iot" {
  identity_pool_id = aws_cognito_identity_pool.iot.id

  roles = {
    "authenticated"   = aws_iam_role.iot.arn,
    "unauthenticated" = aws_iam_role.iot.arn
  }
}