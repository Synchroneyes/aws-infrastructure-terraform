### On va créer 3 subnets public, 3 car on dispose de 3 azs
resource "aws_subnet" "public" {

  for_each = var.vpc_azs

  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value*2+1)
  map_public_ip_on_launch = true

  availability_zone = "${var.aws_region}${each.key}"

  tags = {
    Name = "${var.vpc_name}-public-${var.aws_region}${each.key}"
    Terraform = "true"
  }
}

### On fait de même pour les subnets privés
resource "aws_subnet" "private" {

  for_each = var.vpc_azs

  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value*2)
  map_public_ip_on_launch = false

  availability_zone = "${var.aws_region}${each.key}"

  tags = {
    Name = "${var.vpc_name}-private-${var.aws_region}${each.key}"
    Terraform = "true"
  }
}


### On va créer une gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}