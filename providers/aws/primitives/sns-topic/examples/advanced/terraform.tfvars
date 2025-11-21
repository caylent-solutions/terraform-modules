name                        = "testing-terraform-monorepo.fifo"
fifo_topic                  = true
content_based_deduplication = true
kms_master_key_id           = "alias/aws/sns"
tags = {
  Environment     = "dev"
  Project         = "sns-fifo-example"
  "caylent:owner" = "lucas.valor@caylent.com"
}
