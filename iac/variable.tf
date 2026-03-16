variable "cf_edit_all_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_account_id" {
  type = string
}

variable "zone_id_hudater_dev" {
  description = "Zone ID for specific domains on cloudflare"
  type        = string
}
