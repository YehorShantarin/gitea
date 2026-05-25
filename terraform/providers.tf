provider "aws" {
  region  = "us-east-1"
  profile = "k8s-test"

  default_tags {
    tags = {
      Project   = "gitea-platform"
      ManagedBy = "terraform"
    }
  }
}
