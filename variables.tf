variable "region" {
   default = "us-west-2"  
}


variable "instance_type" {
    default = "t2.small"
  
}

variable "ami_id" {
    default = "ami-082b5a644766e0e6f"

    #Here we can also use data sources to fetch the ami id insted of this 
  
}

