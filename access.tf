
resource "aws_s3_bucket" "s3_backup" {
  bucket        = "${local.prefix}-velero-eks-backup"
  force_destroy = true
  acl           = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning {
    enabled = true
  }
  tags = local.default_tags
}

resource "aws_s3_bucket_public_access_block" "s3_backup" {
  bucket                  = aws_s3_bucket.s3_backup.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_backup" {
  bucket = aws_s3_bucket.s3_backup.id
  policy = <<EOF
{
    "Statement" : [
      {
        "Action" : "s3:*",
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        },
        "Effect" : "Deny",
        "Principal" : "*",
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.s3_backup.id}",
          "arn:aws:s3:::${aws_s3_bucket.s3_backup.id}/*"
        ],
        "Sid" : "AllowSSLRequestsOnly"
      }
    ],
    "Version" : "2012-10-17"
}
EOF
}

#Role for s3
resource "aws_iam_role" "s3_backup" {
  name = "${local.prefix}-velero-eks-backup"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${module.eks.oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
         "${module.eks.oidc_provider}:sub": "system:serviceaccount:dev:dev"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3_backup" {
  name = "${local.prefix}-velero-eks-backup"
  role = aws_iam_role.s3_backup.id

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
    {
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.s3_backup.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.s3_backup.bucket}/*"
        ],
        "Action": [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject",
          "s3:ListBucket"
        ]
	  },
    {
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
          "ec2:DescribeVolumes",
          "ec2:DescribeSnapshots",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot"
        ]
    }
	]
}
EOF
}