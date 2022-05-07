variable "aws_region" {
  type        = string
  description = "AWS Region"
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "isri"
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