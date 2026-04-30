#!/usr/bin/env bash
# build-and-push.sh -- Build a minimal Lambda container image and push it to ECR.
#
# Usage: build-and-push.sh <region> <repository_url> <image_tag> <module_dir>
#
# Arguments:
#   region          AWS region (e.g. us-east-1)
#   repository_url  ECR repository URL (e.g. 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-repo)
#   image_tag       Docker image tag (e.g. latest)
#   module_dir      Path to the Terraform module directory (used as Docker build context)

set -euo pipefail

REGION="${1:?region argument is required}"
REPOSITORY_URL="${2:?repository_url argument is required}"
IMAGE_TAG="${3:?image_tag argument is required}"
MODULE_DIR="${4:?module_dir argument is required}"

DOCKERFILE="${MODULE_DIR}/Dockerfile"

cat > "${DOCKERFILE}" <<'DOCKERFILE'
FROM public.ecr.aws/lambda/python:3.12
CMD ["index.handler"]
DOCKERFILE

aws ecr get-login-password --region "${REGION}" \
  | docker login --username AWS --password-stdin "${REPOSITORY_URL}"

docker build -t "${REPOSITORY_URL}:${IMAGE_TAG}" "${MODULE_DIR}"
docker push "${REPOSITORY_URL}:${IMAGE_TAG}"

rm -f "${DOCKERFILE}"
