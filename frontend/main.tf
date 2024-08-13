terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "svg-portfolio-tfstate"
    key    = "frontend.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}
provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

#--------S3 Bucket--------#
## Test Text ##
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid       = "Allow CloudFront to read from S3 bucket"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn,
      ]
    }
  }
  version = "2012-10-17"
}

resource "aws_s3_bucket_policy" "aws_s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

resource "aws_s3_bucket_website_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = var.bucket_name
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "my_objects" {
  for_each = var.objects

  bucket       = aws_s3_bucket.s3_bucket.id
  key          = each.key == "index.2uJtHFFC.css" || each.key == "hoisted.AIlr0rQB.js" ? "_astro/${each.key}" : each.key
  source       = "${path.module}/${each.value.path}"
  content_type = each.value.content_type
}

#--------ACM Certificate & Route 53--------#

data "aws_acm_certificate" "acm_cert" {
  provider = aws.use1
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "zone" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "a" {
  for_each = var.a_records

  zone_id = data.aws_route53_zone.zone.zone_id
  name    = each.value.name
  type    = each.value.type

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

#--------CloudFront--------#
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.domain_name}.s3.amazonaws.com"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  origin {
    domain_name = aws_s3_bucket.s3_bucket.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.s3_bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = var.cloudfront_aliases

  default_cache_behavior {
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Caching Optimized
    origin_request_policy_id   = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # CORS-S3Origin
    response_headers_policy_id = "60669652-455b-4ae9-85a4-c4c02393f86c" # SimpleCORS
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD", "OPTIONS"]

    target_origin_id = "S3-${var.bucket_name}"

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["ES", "PT", "US", "CA", "DE", "FR"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.acm_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 0
    response_page_path    = "/index.html"
  }

  wait_for_deployment = false

  depends_on = [
    aws_s3_bucket.s3_bucket,
  ]
}

resource "aws_cloudfront_cache_policy" "policy" {
  name        = "sevaghiga"
  min_ttl     = 120
  max_ttl     = 31536000
  default_ttl = 86400
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
      cookies {
        items = []
      }
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [
          "Access-Control-Allow-Origin",
          "Access-Control-Request-Headers",
          "Access-Control-Request-Method",
          "Origin"
        ]
      }
    }
    query_strings_config {
      query_string_behavior = "none"
      query_strings {
        items = []
      }
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "policy" {
  name = "sevaghiga"
  cookies_config {
    cookie_behavior = "none"
    cookies {
      items = []
    }
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = [
        "Access-Control-Allow-Origin",
        "Access-Control-Request-Headers",
        "Access-Control-Request-Method",
        "Origin"
      ]
    }
  }
  query_strings_config {
    query_string_behavior = "none"
    query_strings {
      items = []
    }
  }
}