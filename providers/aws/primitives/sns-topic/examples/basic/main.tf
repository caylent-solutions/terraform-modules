module "sns_topic" {
  source = "../../"

  name = "example-topic"
  tags = {
    Environment = "dev"
    Project     = "sns-example"
  }
}
