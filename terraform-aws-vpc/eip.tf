### On crée des EIP pour les instances
resource "aws_eip" "eip_public" {
  for_each    = var.vpc_azs
  instance = aws_instance.ec2_public[each.key].id
  vpc      = true

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip_association" "eip_assoc" {
  for_each    = aws_instance.ec2_public
  instance_id   = aws_instance.ec2_public[each.key].id
  allocation_id = aws_eip.eip_public[each.key].id
}
