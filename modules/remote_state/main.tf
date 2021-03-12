resource "random_id" "this" {
  byte_length = "5"
}

#---------------------
# S3 BUCKET
#---------------------
resource "aws_s3_bucket" "this" {
  #count         = var.create ? 0 : 1
  bucket        = "${var.region}-terraform-state-${random_id.this.hex}"
  acl           = "private"
  force_destroy = var.force_destroy
  tags          = var.tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning {
    enabled = var.versioning
  }
}

#---------------------
# DYNAMODB
#---------------------
resource "aws_dynamodb_table" "this" {
  #count         = var.create ? 0 : 1
  name         = "${var.region}-dynamodb_locking-${random_id.this.hex}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  tags         = var.tags
  attribute {
    name = "LockID"
    type = "S"
  }
}


resource "null_resource" "remote_state_locks" {
  provisioner "local-exec" {
    command = "sleep 20;cat > ${var.backend_output_path}<<EOL\n${data.template_file.remote_state.rendered}"
  }
  depends_on = [data.template_file.remote_state, aws_dynamodb_table.this, aws_s3_bucket.this]
}
