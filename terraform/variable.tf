variable "aws_region" {
    description = "AWS region to deploy resources"
    type        = string
    default     = "ap-south-1" 
}
variable "instance_type" {
    description = "Instance type for the EC2 instance"
    type        = string
    default     = "t3.micro"
}

variable "key_name" {
    description = "Name of the SSH key pair to use for EC2 instances"
    type        = string
}

variable "ports" {
  description = "List of ports to allow in the security group"
  type        = list(number)
  default     = [22,8080,80]
}

variable "volume_size" {
  description = "Size of the EBS volume in GB"
  type        = number
  default     = 70
}