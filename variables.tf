variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "priv_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  }

  variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.0.0/24"
  }

variable "ami" {
  type        = string
  default     = "ami-08b5b3a93ed654d19"
  }

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  }


variable "Key_pair" {
  type        = string
  default     = "my_key_pair"
  }