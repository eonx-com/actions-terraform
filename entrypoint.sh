#!/bin/sh

# ----------------------------------------------------------------------------------------------------------------------------------
# Setup AWS credentials from the Github Actions values
# ----------------------------------------------------------------------------------------------------------------------------------

export AWS_ACCESS_KEY_ID="${INPUT_AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${INPUT_AWS_SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION="${INPUT_AWS_DEFAULT_REGION}"
export SUMOLOGIC_ACCESSID="${INPUT_SUMO_LOGIC_ACCESS_ID}"
export SUMOLOGIC_ACCESSKEY="${INPUT_SUMO_LOGIC_ACCESS_KEY}"
export SUMOLOGIC_ENVIRONMENT="${INPUT_SUMO_LOGIC_ENVIRONMENT}"
export INPUT_BUCKET="${INPUT_INPUT_BUCKET}"
export INPUT_FILE_PREFIX="${INPUT_INPUT_FILE_PREFIX}"
export TF_IN_AUTOMATION=1
export TF_VAR_sumologic_access_id="${INPUT_SUMO_LOGIC_ACCESS_ID}"
export TF_VAR_sumologic_access_key="${INPUT_SUMO_LOGIC_ACCESS_KEY}"
export TF_VAR_sumologic_environment="${INPUT_SUMO_LOGIC_ENVIRONMENT}"
export TF_VAR_opsgenie_api_key="${INPUT_OPSGENIE_API_KEY}"

# ----------------------------------------------------------------------------------------------------------------------------------
# Deploy Project Infrastructure
# ----------------------------------------------------------------------------------------------------------------------------------

# Change into the directory indicated in the Github Actions variable
cd "${GITHUB_WORKSPACE}" || exit 1
cd "${INPUT_PATH}" || exit 2

if [ ! -f "devops.tf" ]; then
  echo "ERROR: Could not locate expected Terraform backend definition file ('devops.tf') in the specified folder"
  exit 5
fi

echo
echo
cat devops.tf
echo
echo

echo "Running Terraform init"
terraform init || exit 3
echo
echo

echo "Downloading Plan"
aws s3 cp "s3://${INPUT_BUCKET}/${INPUT_FILE_PREFIX}/${GITHUB_SHA}.plan" input.plan

echo "Running Terraform plan"
terraform apply "input.plan" || exit 4
