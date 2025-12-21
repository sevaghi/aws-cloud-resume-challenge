#--------Frontend Variables--------#

variable "bucket_name" {
  description = "S3 bucket name for website"
  default     = "sevaghiga-web-portfolio-ct4q35wer"
}

variable "domain_name" {
  type    = string
  default = "sevaghiga.com"
}

variable "acm_certificate_domain" {
  default     = "sevaghiga.com"
  description = "ACM certificate domain name"
}


variable "cloudfront_aliases" {
  description = "List of CloudFront aliases (CNAMEs)"
  default     = ["sevaghiga.com", "www.sevaghiga.com"]
}


variable "a_records" {
  type = map(object({
    type = string
    name = string
  }))
  default = {
    a1 = {
      type = "A"
      name = "sevaghiga.com"
    }
    a2 = {
      type = "A"
      name = "www.sevaghiga.com"
    }
  }
}
