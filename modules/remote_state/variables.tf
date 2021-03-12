variable "region" {
  type    = string
  default = null

}

variable "versioning" {
  default     = true
  description = "enables versioning for objects in the S3 bucket"
  type        = bool
}


variable "force_destroy" {
  description = "Whether to allow a forceful destruction of this bucket"
  default     = true
  type        = bool
}

variable "create" {
  type    = bool
  default = true
}

variable "backend_output_path" {
  default     = "./backend.tf"
  description = "The default file to output backend configuration to"
}
variable "tags" {
  default = null
  type    = map(string)
}
