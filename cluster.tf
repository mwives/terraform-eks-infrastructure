resource "aws_security_group" "fullcycle_sg" {
  name        = "${var.prefix}-sg"
  description = "Security group for ${var.prefix} cluster"
  vpc_id      = aws_vpc.new_vpc.id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.prefix}-sg"
  }
}

resource "aws_iam_role" "eks_role" {
  name = "${var.prefix}-${var.cluster_name}-role"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        }
      }
    ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_role.name
}


resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_cloudwatch_log_group" "eks_log_group" {
  name              = "/aws/eks/${var.prefix}-${var.cluster_name}/cluster"
  retention_in_days = var.retention_in_days
}

resource "aws_eks_cluster" "eks_cluster" {
  name                      = "${var.prefix}-${var.cluster_name}"
  role_arn                  = aws_iam_role.eks_role.arn
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    subnet_ids         = aws_subnet.subnets[*].id
    security_group_ids = [aws_security_group.fullcycle_sg.id]
  }

  depends_on = [
    aws_cloudwatch_log_group.eks_log_group,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSVPCResourceController
  ]

  tags = {
    Name = "${var.prefix}-${var.cluster_name}"
  }
}
