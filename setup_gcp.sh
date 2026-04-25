#!/bin/bash
set -e

GCLOUD="C:/Users/navya/AppData/Local/Google/Cloud SDK/google-cloud-sdk/bin/gcloud.cmd"
BQ="C:/Users/navya/AppData/Local/Google/Cloud SDK/google-cloud-sdk/bin/bq.cmd"

echo "Starting GCP Setup..."

PROJECT_ID="epilink-blr"
REGION="asia-south1"

echo "Creating GCP project $PROJECT_ID..."
"$GCLOUD" projects create $PROJECT_ID || echo "Project might already exist"
"$GCLOUD" config set project $PROJECT_ID

# Link billing account to the project:
"$GCLOUD" billing projects link $PROJECT_ID --billing-account=012DA4-AC4BAE-6F2AF5

echo "Enabling APIs..."
"$GCLOUD" services enable bigquery.googleapis.com \
    bigqueryconnection.googleapis.com \
    cloudfunctions.googleapis.com \
    firestore.googleapis.com \
    firebase.googleapis.com \
    aiplatform.googleapis.com \
    maps-backend.googleapis.com \
    places-backend.googleapis.com \
    fcm.googleapis.com \
    run.googleapis.com || echo "API enablement might require active billing account."

echo "Creating BigQuery dataset..."
"$BQ" mk --location=$REGION -d $PROJECT_ID:epilink_blr || echo "Dataset might already exist"

echo "Creating Service Account..."
SA_NAME="epilink-sa"
"$GCLOUD" iam service-accounts create $SA_NAME \
    --description="Service account for EpiLink BLR" \
    --display-name="EpiLink SA" || echo "Service account might already exist"

SA_EMAIL="$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"

echo "Adding roles to Service Account..."
ROLES=(
    "roles/bigquery.admin"
    "roles/datastore.user"
    "roles/cloudfunctions.developer"
    "roles/firebase.admin"
)

for ROLE in "${ROLES[@]}"; do
    "$GCLOUD" projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SA_EMAIL" \
        --role="$ROLE" || echo "Role binding might fail if not permitted."
done

echo "Downloading Service Account key..."
mkdir -p ./keys
"$GCLOUD" iam service-accounts keys create ./keys/epilink-sa.json \
    --iam-account=$SA_EMAIL || echo "Key already downloaded or error"

echo "GCP setup complete"
