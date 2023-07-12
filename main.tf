##### Terraform Resource Block To Create a GCS Bucket #####
resource "google_storage_bucket" "bucket" {
  count                       = var.no_of_buckets
  name                        = var.name_of_buckets[count.index]
  force_destroy               = var.force_destroy
  location                    = var.location
  project                     = var.project_id
  storage_class               = var.storage_class
  labels                      = var.labels
  uniform_bucket_level_access = var.uniform_bucket_level_access
  lifecycle {
    ignore_changes = [
      labels
    ]
  }
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                        = lookup(lifecycle_rule.value.condition, "age", null)
        created_before             = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state                 = lookup(lifecycle_rule.value.condition, "with_state", lookup(lifecycle_rule.value.condition, "is_live", false) ? "LIVE" : null)
        matches_storage_class      = lookup(lifecycle_rule.value.condition, "matches_storage_class", null)
        num_newer_versions         = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
        custom_time_before         = lookup(lifecycle_rule.value.condition, "custom_time_before", null)
        days_since_custom_time     = lookup(lifecycle_rule.value.condition, "days_since_custom_time", null)
        days_since_noncurrent_time = lookup(lifecycle_rule.value.condition, "days_since_noncurrent_time", null)
        noncurrent_time_before     = lookup(lifecycle_rule.value.condition, "noncurrent_time_before", null)
      }
    }
  }
  versioning {
    enabled = var.bucket_object_versioning
  }

  dynamic "cors" {
    for_each = var.cors == null ? [] : var.cors
    content {
      origin          = lookup(cors.value, "origin", null)
      method          = lookup(cors.value, "method", null)
      response_header = lookup(cors.value, "response_header", null)
      max_age_seconds = lookup(cors.value, "max_age_seconds", null)
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy == null ? [] : [var.retention_policy]
    content {
      is_locked        = var.retention_policy.is_locked
      retention_period = var.retention_policy.retention_period
    }
  }

  dynamic "logging" {
    for_each = var.log_object_bucket == null ? [] : [var.log_object_bucket]
    content {
      log_bucket        = var.log_object_bucket
      log_object_prefix = var.log_object_prefix
    }
  }
  dynamic "encryption" {
    for_each = var.encryption == null ? [] : [var.encryption]
    content {
      default_kms_key_name = var.encryption.kms_key_name
    }
  }
}

