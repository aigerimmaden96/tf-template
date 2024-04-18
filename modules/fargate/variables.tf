variable "tags" {
  type        = map(string)
}

variable "namespace" {
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "fargate_profile_name" {
  description = "Name of the Fargate profile"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
}

variable "labels" {
  type        = map(string)
}
