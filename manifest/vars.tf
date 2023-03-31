variable "manifest" {
    type        = any
    description = "A map of key-value pairs of Settings."
    default     = {}
}
variable "api_version" {
    type        = string
    description = "A map of key-value pairs of Settings."
    default     = null
}

variable "kind" {
    type        = string
    description = "A map of key-value pairs of Settings."
    default     = null
}

variable "metadata_name" {
    type        = string
    description = "A map of key-value pairs of Settings."
    default     = null
}

variable "spec_group" {
    type        = string
    description = "A map of key-value pairs of Settings."
    default     = null
}
variable "spec_scope" {
    type        = string
    description = "A map of key-value pairs of Settings."
    default     = null
}

variable "spec_kind" {
    type        = string
    description = "A map of key-value pairs of Settings."
    default     = null
}

variable "spec_plural" {
    type        = string
    description = "A map of key-value pairs of Settings."
    default     = null
}