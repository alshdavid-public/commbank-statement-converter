# The destination bucket
data "aws_s3_bucket" "web_static" {
  bucket = "alshdavid-web-com-davidalsh-static"
}

# Mapping mime types so the browser renders HTML/CSS correctly
locals {
  mime_types = {
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
  }
}

resource "aws_s3_object" "static_files" {
  for_each     = fileset("${path.module}/../dist", "**/*")

  bucket       = data.aws_s3_bucket.web_static.id 
  key          = "${var.project_name}/${each.value}"
  source       = "${path.module}/../dist/${each.value}"
  content_type = lookup(local.mime_types, element(split(".", each.value), length(split(".", each.value)) - 1), "application/octet-stream")
  source_hash  = filemd5("${path.module}/../dist/${each.value}")
}

resource "terraform_data" "cloudfront_invalidation" {
  triggers_replace = [
    for obj in aws_s3_object.static_files : obj.etag
  ]

  provisioner "local-exec" {
    command = <<EOT
      aws cloudfront create-invalidation \
        --distribution-id ${var.cloudfront_distribution_id} \
        --paths "/${var.project_name}/*"
    EOT
  }
}