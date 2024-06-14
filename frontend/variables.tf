#--------Frontend Variables--------#

variable "bucket_name" {
  description = "S3 bucket name for website"
  default     = "sevaghi-web-portfolio-terraform"
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

variable "objects" {
  type = map(object({
    path         = string
    content_type = string
  }))
  default = {
    "index.html" = {
      path         = "website/index.html"
      content_type = "text/html"
    }
    #"style.css" = {
    #  path         = "website/_astro/index.2uJtHFFC.css"
    #  content_type = "text/css"
    #}
    #"script.js" = {
    #  path         = "website/_astro/hoisted.ZJImjIEP.js"
    #  content_type = "application/javascript"
    #}
    "favicon.svg" = {
      path         = "website/favicon.svg"
      content_type = "image/x-icon"
    }
  }
}