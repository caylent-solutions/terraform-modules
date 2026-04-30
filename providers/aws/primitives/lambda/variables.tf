variable "function_name" {
  description = "Name of the Lambda function"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.function_name))
    error_message = "Function name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = null
}

variable "role" {
  description = "ARN of the IAM role for Lambda execution"
  type        = string
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version"
  type        = bool
  default     = false
}

variable "package_type" {
  description = "Lambda deployment package type (Zip or Image)"
  type        = string
  default     = "Zip"

  validation {
    condition     = contains(["Zip", "Image"], var.package_type)
    error_message = "Package type must be either 'Zip' or 'Image'."
  }
}

# Zip package type variables
variable "filename" {
  description = "Path to the function's deployment package (Zip only, local file)"
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket containing the function's deployment package (Zip only, S3 object)"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of the function's deployment package (Zip only, S3 object)"
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "S3 object version of the function's deployment package (Zip only, S3 object)"
  type        = string
  default     = null
}

variable "source_code_hash" {
  description = "Base64-encoded SHA256 hash of the package file (Zip only)"
  type        = string
  default     = null
}

variable "handler" {
  description = "Function entrypoint in your code (Zip only)"
  type        = string
  default     = null

  validation {
    condition     = var.handler == null || var.package_type == "Zip"
    error_message = "Handler is only valid for Zip package type."
  }
}

variable "runtime" {
  description = "Runtime environment for the Lambda function (Zip only)"
  type        = string
  default     = null

  validation {
    condition     = var.runtime == null || var.package_type == "Zip"
    error_message = "Runtime is only valid for Zip package type."
  }
}

variable "layers" {
  description = "List of Lambda Layer ARNs (Zip only)"
  type        = list(string)
  default     = null
}

# Image package type variables
variable "image_uri" {
  description = "ECR image URI containing the function's deployment package (Image only)"
  type        = string
  default     = null

  validation {
    condition     = var.image_uri == null || var.package_type == "Image"
    error_message = "Image URI is only valid for Image package type."
  }
}

variable "image_config" {
  description = "Container image configuration (Image only)"
  type = object({
    command           = optional(list(string))
    entry_point       = optional(list(string))
    working_directory = optional(string)
  })
  default = null
}

# Common function configuration
variable "architectures" {
  description = "Instruction set architecture for the Lambda function"
  type        = list(string)
  default     = ["x86_64"]

  validation {
    condition     = alltrue([for arch in var.architectures : contains(["x86_64", "arm64"], arch)])
    error_message = "Architectures must be either 'x86_64' or 'arm64'."
  }
}

variable "timeout" {
  description = "Amount of time Lambda function has to run in seconds"
  type        = number
  default     = 3

  validation {
    condition     = var.timeout >= 1 && var.timeout <= 900
    error_message = "Timeout must be between 1 and 900 seconds."
  }
}

variable "memory_size" {
  description = "Amount of memory in MB Lambda function has access to"
  type        = number
  default     = 128

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "Memory size must be between 128 and 10240 MB."
  }
}

variable "reserved_concurrent_executions" {
  description = "Amount of reserved concurrent executions for this Lambda function"
  type        = number
  default     = -1
}

variable "kms_key_arn" {
  description = "ARN of KMS key to encrypt environment variables"
  type        = string
  default     = null
}

variable "code_signing_config_arn" {
  description = "ARN of code signing configuration for code integrity"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment variables for the Lambda function"
  type = object({
    variables = map(string)
  })
  default = null
}

variable "environment_from_ssm" {
  description = "Map of environment variable names to SSM parameter names to fetch and inject"
  type        = map(string)
  default     = {}
}

variable "environment_from_secrets" {
  description = "Map of environment variable names to Secrets Manager secret ARNs to fetch and inject"
  type        = map(string)
  default     = {}
}

variable "enable_parameters_and_secrets_extension" {
  description = "Enable AWS Parameters and Secrets Lambda Extension for runtime SSM/Secrets access without env vars"
  type        = bool
  default     = false
}

variable "parameters_and_secrets_extension_config" {
  description = "Configuration for Parameters and Secrets Lambda Extension"
  type = object({
    http_port                   = optional(number, 2773)
    secrets_manager_timeout     = optional(number, 0)
    ssm_parameter_store_timeout = optional(number, 0)
    max_connections             = optional(number, 3)
    cache_enabled               = optional(string, "true")
    cache_size                  = optional(string, "1000")
  })
  default = {}
}

variable "vpc_config" {
  description = "VPC configuration for the Lambda function"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "dead_letter_config" {
  description = "Dead letter queue configuration for failed invocations"
  type = object({
    target_arn = string
  })
  default = null
}

variable "file_system_config" {
  description = "EFS file system configuration"
  type = object({
    arn              = string
    local_mount_path = string
  })
  default = null
}

variable "ephemeral_storage_size" {
  description = "Size of ephemeral storage (/tmp) in MB (512-10240)"
  type        = number
  default     = null

  validation {
    condition     = var.ephemeral_storage_size == null || (var.ephemeral_storage_size >= 512 && var.ephemeral_storage_size <= 10240)
    error_message = "Ephemeral storage size must be between 512 and 10240 MB."
  }
}

variable "logging_config" {
  description = "CloudWatch Logs configuration"
  type = object({
    log_format            = string
    log_group             = optional(string)
    system_log_level      = optional(string)
    application_log_level = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to the Lambda function"
  type        = map(string)
  default     = {}
}

variable "tracing_mode" {
  description = "X-Ray tracing mode for the Lambda function"
  type        = string
  default     = "Active"

  validation {
    condition     = contains(["Active", "PassThrough"], var.tracing_mode)
    error_message = "Tracing mode must be either 'Active' or 'PassThrough'."
  }
}

variable "default_batch_size" {
  description = "Default batch size for event source mappings"
  type        = number
  default     = 10
}

variable "default_enabled" {
  description = "Default enabled state for event source mappings"
  type        = bool
  default     = true
}

# Event source mapping variables
variable "event_source_mappings" {
  description = "Map of event source mappings to create"
  type = map(object({
    event_source_arn                   = string
    batch_size                         = optional(number)
    enabled                            = optional(bool)
    starting_position                  = optional(string)
    maximum_batching_window_in_seconds = optional(number)
    filter_criteria = optional(object({
      filters = list(object({
        pattern = optional(string)
      }))
    }))
    scaling_config = optional(object({
      maximum_concurrency = number
    }))
  }))
  default = {}
}

# Lambda permission variables
variable "permissions" {
  description = "Map of Lambda permissions to create"
  type = map(object({
    statement_id       = string
    action             = string
    principal          = string
    source_arn         = optional(string)
    source_account     = optional(string)
    event_source_token = optional(string)
  }))
  default = {}
}

# Provisioned concurrency variables
variable "provisioned_concurrent_executions" {
  description = "Map of provisioned concurrency configurations"
  type = map(object({
    provisioned_concurrent_executions = number
    qualifier                         = string
  }))
  default = {}
}

# Function URL variables
variable "function_urls" {
  description = "Map of function URL configurations"
  type = map(object({
    authorization_type = string
    qualifier          = optional(string)
    cors = optional(object({
      allow_credentials = optional(bool)
      allow_headers     = optional(list(string))
      allow_methods     = optional(list(string))
      allow_origins     = optional(list(string))
      expose_headers    = optional(list(string))
      max_age           = optional(number)
    }))
  }))
  default = {}
}

# Alias variables
variable "aliases" {
  description = "Map of Lambda aliases"
  type = map(object({
    function_version = string
    description      = optional(string)
    routing_config = optional(object({
      additional_version_weights = map(number)
    }))
  }))
  default = {}
}

# Event invoke config variables
variable "event_invoke_configs" {
  description = "Map of event invoke configurations"
  type = map(object({
    qualifier                    = optional(string)
    maximum_event_age_in_seconds = optional(number)
    maximum_retry_attempts       = optional(number)
    destination_config = optional(object({
      on_failure = optional(object({
        destination = string
      }))
      on_success = optional(object({
        destination = string
      }))
    }))
  }))
  default = {}
}

# Layer version variables
variable "layer_versions" {
  description = "Map of Lambda layer versions to create"
  type = map(object({
    filename            = optional(string)
    s3_bucket           = optional(string)
    s3_key              = optional(string)
    s3_object_version   = optional(string)
    compatible_runtimes = optional(list(string))
    description         = optional(string)
    license_info        = optional(string)
  }))
  default = {}
}
