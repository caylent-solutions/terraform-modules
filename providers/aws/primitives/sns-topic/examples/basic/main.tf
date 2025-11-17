module "sns_topic" {
  source = "../../"

  name = var.name
  tags = var.tags
}
