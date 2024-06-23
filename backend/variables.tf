variable "table_name" {
    default = "portfolio-web-counter-tf"
    description = "dynamodb table name"
}

variable "hash_key" {
  default = "record_id"
  description = "public key for dynamodb table"
}

variable "api_name" {
  default = "portfolio-web-api-tf"
}