$ErrorActionPreference = "Stop"

$GCLOUD = "C:\Users\navya\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd"
$BQ = "C:\Users\navya\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\bq.cmd"

Write-Host "Starting GCP Setup..."

$PROJECT_ID = "epilink-blr"
$REGION = "asia-south1"

Write-Host "Creating GCP project $PROJECT_ID..."
try {
    & $GCLOUD projects create $PROJECT_ID
} catch {
    Write-Host "Project might already exist"
}
& $GCLOUD config set project $PROJECT_ID

Write-Host "Link billing account to the project:"
try {
    & $GCLOUD billing projects link $PROJECT_ID --billing-account=012DA4-AC4BAE-6F2AF5
} catch {
    Write-Host "Billing link might already exist or failed"
}

Write-Host "Enabling APIs..."
try {
    & $GCLOUD services enable bigquery.googleapis.com `
        bigqueryconnection.googleapis.com `
        cloudfunctions.googleapis.com `
        firestore.googleapis.com `
        firebase.googleapis.com `
        aiplatform.googleapis.com `
        maps-backend.googleapis.com `
        places-backend.googleapis.com `
        fcm.googleapis.com `
        run.googleapis.com
} catch {
    Write-Host "API enablement failed"
}

Write-Host "Creating BigQuery dataset..."
try {
    & $BQ mk --location=$REGION -d "$PROJECT_ID`:epilink_blr"
} catch {
    Write-Host "Dataset might already exist"
}

Write-Host "Creating Service Account..."
$SA_NAME = "epilink-sa"
try {
    & $GCLOUD iam service-accounts create $SA_NAME `
        --description="Service account for EpiLink BLR" `
        --display-name="EpiLink SA"
} catch {
    Write-Host "Service account might already exist"
}

$SA_EMAIL = "$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"

Write-Host "Adding roles to Service Account..."
$ROLES = @(
    "roles/bigquery.admin",
    "roles/datastore.user",
    "roles/cloudfunctions.developer",
    "roles/firebase.admin"
)

foreach ($ROLE in $ROLES) {
    try {
        & $GCLOUD projects add-iam-policy-binding $PROJECT_ID `
            --member="serviceAccount:$SA_EMAIL" `
            --role=$ROLE
    } catch {
        Write-Host "Role binding failed"
    }
}

Write-Host "Downloading Service Account key..."
New-Item -ItemType Directory -Force -Path "./keys" | Out-Null
try {
    & $GCLOUD iam service-accounts keys create ./keys/epilink-sa.json `
        --iam-account=$SA_EMAIL
} catch {
    Write-Host "Key already downloaded or error"
}

Write-Host "Creating Firestore Database..."
try {
    & $GCLOUD firestore databases create --location=$REGION --type=firestore-native
} catch {
    Write-Host "Firestore database might already exist or error"
}

Write-Host "GCP setup complete"
