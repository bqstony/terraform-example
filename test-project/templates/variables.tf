variable "environment" {
  type        = string
  default     = "dev"
  description = "The environment stage"
  nullable    = false

  validation {
    condition     =contains(["dev", "test", "prod"], var.environment)
    error_message = "Valid values for var: environment are [dev, test, prod]."
  }
}

variable "resource_location" {
  type        = string
  default     = "westeurope"
  description = "The Resource Location"
  nullable    = false
}
