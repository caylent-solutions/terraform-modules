#!/usr/bin/env bash
set -euo pipefail

# build-and-push.sh: build a minimal Lambda container image and push to ECR.
#
# Positional arguments:
#   $1 AWS_REGION    AWS region for ECR login (e.g. us-east-1)
#   $2 REPO_URL      ECR repository URL (e.g. 123.dkr.ecr.us-east-1.amazonaws.com/my-fn)
#   $3 IMAGE_TAG     Image tag to build and push (e.g. latest)
#   $4 BUILD_DIR     Directory to use as Docker build context

if [[ $# -ne 4 ]]; then
  echo "usage: build-and-push.sh AWS_REGION REPO_URL IMAGE_TAG BUILD_DIR" >&2
  exit 64
fi

AWS_REGION="$1"
REPO_URL="$2"
IMAGE_TAG="$3"
BUILD_DIR="$4"

DOCKERFILE_PATH="${BUILD_DIR}/Dockerfile"

cleanup() {
  rm -f "${DOCKERFILE_PATH}"
}
trap cleanup EXIT

cat > "${DOCKERFILE_PATH}" <<'EOF'
FROM public.ecr.aws/lambda/python:3.12
CMD ["index.handler"]
EOF

aws ecr get-login-password --region "${AWS_REGION}" \
  | docker login --username AWS --password-stdin "${REPO_URL}"

# AWS Lambda only accepts Docker v2 image manifests, not OCI manifests.
# Force the legacy non-BuildKit builder so the resulting image push uses
# application/vnd.docker.distribution.manifest.v2+json instead of
# application/vnd.oci.image.manifest.v1+json (which Lambda rejects with
# "The image manifest, config or layer media type ... is not supported").
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 -t "${REPO_URL}:${IMAGE_TAG}" "${BUILD_DIR}"
docker push "${REPO_URL}:${IMAGE_TAG}"
