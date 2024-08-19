# Main VPC
resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = {
        Name = var.vpc_name
    }
}

# Private Subnets
resource "aws_subnet" "private_zone1" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_cidrs[0]
    availability_zone = var.az_private_1

    tags = {
        Name = var.private_zone_names[0]
    }
}

resource "aws_subnet" "private_zone2" {
    count             = var.create_private_zone2 ? 1 : 0
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_cidrs[1]
    availability_zone = var.az_private_2

    tags = {
        Name = var.private_zone_names[1]
    }
}

resource "aws_subnet" "private_zone3" {
    count             = var.create_private_zone3 ? 1 : 0
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_cidrs[2]
    availability_zone = var.az_private_3

    tags = {
        Name = var.private_zone_names[2]
    }
}

# Public Subnets
resource "aws_subnet" "public_zone1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_cidrs[0]
    availability_zone       = var.az_public_1
    map_public_ip_on_launch = true

    tags = {
        Name = var.public_zone_names[0]
    }
}

resource "aws_subnet" "public_zone2" {
    count                   = var.create_public_zone2 ? 1 : 0
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_cidrs[1]
    availability_zone       = var.az_public_2
    map_public_ip_on_launch = true

    tags = {
        Name = var.public_zone_names[1]
    }
}

resource "aws_subnet" "public_zone3" {
    count                   = var.create_public_zone3 ? 1 : 0
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_cidrs[2]
    availability_zone       = var.az_public_3
    map_public_ip_on_launch = true

    tags = {
        Name = var.public_zone_names[2]
    }
}

# internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gateway_name
  }
}

# NAT gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = var.nat_gateway_name
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone1.id

  tags = {
    Name = var.nat_gateway_name
  }

  depends_on = [aws_internet_gateway.igw]
}

# Route Tables

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public_zone1" {
  subnet_id      = aws_subnet.public_zone1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone2" {
  count           = var.create_public_zone2 ? 1 : 0
  subnet_id      = aws_subnet.public_zone2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone3" {
  count           = var.create_public_zone3 ? 1 : 0
  subnet_id      = aws_subnet.public_zone3.id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private_zone1" {
  subnet_id      = aws_subnet.private_zone1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_zone2" {
  count           = var.create_private_zone2 ? 1 : 0
  subnet_id      = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_zone3" {
  count           = var.create_private_zone3 ? 1 : 0
  subnet_id      = aws_subnet.private_zone3.id
  route_table_id = aws_route_table.private.id
}
