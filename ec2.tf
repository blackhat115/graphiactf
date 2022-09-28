resource "aws_security_group" "allow_port" {
    name = "allow_port"
    description = "for ports"
    vpc_id = aws_vpc.graph_vpc.id

    ingress {
      description = "ssh"  
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

     ingress {
      description = "postgres"    
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "ipfs"   
      from_port = 5001
      to_port = 5001
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "ipfs1"   
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    

    ingress {
      description = "subgraph"   
      from_port = 8000
      to_port = 8000
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "subgraph1"   
      from_port = 8001
      to_port = 8001
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "subgraph2"   
      from_port = 8020
      to_port = 8020
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    

   
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
       name = "allow_ports"
    }
}

data "template_file" "graphnode" {
   template = file("graphnode.sh")

}

resource "aws_instance" "Ubuntu_graph_docker" {
   ami= var.ami
   instance_type = var.instance_type
  
   subnet_id = aws_subnet.graph_subnet.id
   associate_public_ip_address = true
   vpc_security_group_ids = [aws_security_group.allow_port.id]
   key_name = "tf_graph"

   root_block_device {
    volume_size           = "30"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  user_data = data.template_file.graphnode.rendered
  

   tags = {
     Name = "Ubuntu_graph_docker"
   }
   
}



 




