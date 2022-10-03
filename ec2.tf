locals {
  ingress_rules = [{
           port = 8080
           description = "subgraph"
       },

       {
           port = 22
           description = "ssh"
       },
       {
           port = 8000
           description = "graphql"
       },
       {
           port = 5432
           description = "postgresql"
       },
       {
           port = 8081
           description="subgraph1"
       },
       {
           port = 8020
           description="subgraph2"
       },
       {
           port = 5001
           description="ipfs"
       }] 
  
}

resource "aws_security_group" "allow_port" {
    name = "allow_port"
    description = "for ports"
    vpc_id = aws_vpc.graph_vpc.id

    dynamic "ingress" {
        for_each = local.ingress_rules
      
      content {
        description = ingress.value.description  
        from_port = ingress.value.port
        to_port = ingress.value.port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
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
   key_name = "tf_graph1"

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
resource "aws_key_pair" "deployer" {
    key_name = "tf_graph1"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmZ4ISvzXz/6OySSavaiP2NCt7CZ6QOoPK6cVGQF+czGzeV04Ldh3DfOYgWByqoKFrP/5txsVSr1lKTk06eBN2Opfyxr0aOzb2pqBez0QOvk1yT6Ue3MLqOFQVr4tduITXADpEuzsIYlwl7EzsogIuDBei8chg6vEqzaJq1w4WHRKcedoAp9vQcv6T3DbnuGPaUmzGKY1FLbCH7JrzoJABcve1j9N/H27FiQd0FMGnn9xf36Gz6B1nrDD9zKcC4YSdH0frKdF2EmKmg9E/ClycXLKH4zg90wLx9Y4usCsia5QvGkTYuExWdzC32ZBKs3yZThPBXrS4LaimNS+Dw68l sunny@DESKTOP-Q7C93QQ"
  
}

data "aws_instance" "myawsinstance" {
    filter {
      name = "tag:name"
      values = ["Ubuntu_graph_docker"]
    }

    depends_on = [
      aws_instance.Ubuntu_graph_docker
    ]
}

output "info" {
    value = data.aws_instance.myawsinstance.public_ip
}


 