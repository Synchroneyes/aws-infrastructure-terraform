resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_route_table" "private_route_table" {
  
  for_each = var.vpc_azs
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-private-1${each.key}"
  }
}

resource "aws_route" "private_routes" {
  
  for_each = var.vpc_azs

  route_table_id            = aws_route_table.private_route_table[each.key].id
  destination_cidr_block    = var.vpc_cidr_all
  instance_id               = aws_instance.ec2_public[each.key].id
}

resource "aws_route" "public_routes" {
  
  for_each = var.vpc_azs

  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = var.vpc_cidr_all
  gateway_id                = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "private_route" {
  for_each        = var.vpc_azs
  subnet_id       = aws_subnet.private[each.key].id
  route_table_id  = aws_route_table.private_route_table[each.key].id
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each        = var.vpc_azs
  subnet_id       = aws_subnet.public[each.key].id
  route_table_id  = aws_route_table.public_route_table.id
}