variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr"{
  type        = string
  default     = "172.28.0.0/16"
  description = "CIDR Block pour nos VPC"
}

variable "vpc_cidr_all"{
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR public Block pour nos VPC"
}

variable "vpc_name"{
  type        = string
  default     = "isri"
  description = "Nom par défaut des VPC"
}

variable "vpc_azs" {
  type        = map(any)
  default     = {
    "a" = 0,
    "b" = 1,
    "c" = 2
  }

  description = "Liste de zone de disponibilité"
}
