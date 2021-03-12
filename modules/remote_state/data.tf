#-------------------------------------------------------
# AUTOMATING REMOTE STATE
#-------------------------------------------------------
data "template_file" "remote_state" {
  template = file("${path.module}/templates/remote_state.tpl")
  vars = {
    bucket_name = aws_s3_bucket.this.id
    dynamodb_table = aws_dynamodb_table.this.id
    region = var.region


  }
}
