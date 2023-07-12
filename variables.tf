##### Variables for GCS bucket #####
variable "no_of_buckets" {
  description = "the number of the new buckets that will be created"
  type        = number
}
variable "name_of_buckets" {
  type = list(string)
}


variable "force_destroy" {
  description = "option to delete all objects in a bucket while deleting a bucket"
  type        = bool
  default     = false
}

variable "location" {
  description = "the location of the bucket"
  type        = string
}

variable "project_id" {
  description = "the ID of the project where the bucket will be created"
  type        = string
}

variable "storage_class" {
  description = "the Storage Class of the new bucket"
  type        = string
  default     = null
}

variable "labels" {
  description = "a map of key/value label pairs to assign to the bucket"
  type        = map(string)
  default     = null
}

variable "uniform_bucket_level_access" {
  description = "enables uniform bucket level access to a bucket"
  type        = bool
  default     = true
}

variable "lifecycle_rule" {
  description = "lifecycle rule for a gcs bucket"
  type = list(object({
    action    = any
    condition = any
  }))
  default = []
}

variable "bucket_object_versioning" {
  description = "enabling versioning can help retain a noncurrent object version"
  type        = bool
  default     = true
}

variable "cors" {
  description = "cors configuration for the bucket"
  type        = any
  default     = []
}

variable "retention_policy" {
  description = "configuration of the bucket's data retention policy for how long objects in the bucket should be retained"
  type = object({
    is_locked        = bool
    retention_period = number
  })
  default = null
}

variable "log_object_bucket" {
  description = "a gcs bucket that can receive log objects"
  type        = string
  default     = null
}

variable "log_object_prefix" {
  description = "the object prefix for log objects which defaults to gcs bucket name"
  type        = string
  default     = null
}

variable "encryption" {
  description = "a cloud KMS key that will be used to encrypt objects inserted into this bucket"
  type = object({
    kms_key_name = string
  })
  default = null
}