locals {
  instance_names = [
    "jenkins-server",
    "monitoring-server",
    "kubernetes-master-node",
    "kubernetes-worker-node"
  ]
}


resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ami.id
  instance_type               = var.ec2_instance_type[count.index]
  count                       = var.ec2-instance-count
  subnet_id                   = aws_subnet.public_subnet[count.index].id
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = var.ec2_volume_type
  }
  tags = {
    Name        = "${local.org}-${local.project}-${var.env}-${local.instance_names[count.index]}"
    environment = var.env
  }
}