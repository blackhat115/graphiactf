
resource "aws_vpc" "graph_vpc" {
    cidr_block = var.cidr_block_vpc
    enable_dns_hostnames = true

    tags = {
      Name = "graph_vpc"
    }
}

resource "aws_subnet" "graph_subnet" {
    vpc_id = aws_vpc.graph_vpc.id
    cidr_block = var.cidr_block_subnet
    availability_zone = var.availability_zones

    tags = {
      Name = "graph_subnet"
    }
}

resource "aws_internet_gateway" "graph_igw" {
    vpc_id = aws_vpc.graph_vpc.id

    tags = {
      Name = "graph_igw"
    }
  
}

resource "aws_route_table" "graph_routetable" {
    vpc_id = aws_vpc.graph_vpc.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.graph_igw.id
    }

    tags = {
      Name = "graph_routetable"
    }
  
}

resource "aws_route_table_association" "graph_route_association" {
    subnet_id = aws_subnet.graph_subnet.id
    route_table_id = aws_route_table.graph_routetable.id

}
