import os
from google.cloud import bigquery

def main():
    if "GOOGLE_APPLICATION_CREDENTIALS" not in os.environ:
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "./keys/epilink-sa.json"
        
    try:
        client = bigquery.Client(project="epilink-blr")
    except Exception as e:
        print(f"Could not initialize BigQuery client: {e}")
        return
        
    dataset_id = "epilink-blr.epilink_blr"
    
    dataset = bigquery.Dataset(dataset_id)
    dataset.location = "asia-south1"
    try:
        dataset = client.create_dataset(dataset, timeout=30, exists_ok=True)
        print(f"Created dataset {dataset.project}.{dataset.dataset_id}")
    except Exception as e:
        print(f"Dataset already exists or error: {e}")
    
    tables = [
        {
            "name": "symptom_reports",
            "schema": [
                bigquery.SchemaField("report_id", "STRING"),
                bigquery.SchemaField("ward_id", "STRING"),
                bigquery.SchemaField("ward_name", "STRING"),
                bigquery.SchemaField("timestamp", "TIMESTAMP"),
                bigquery.SchemaField("symptoms", "STRING"),
                bigquery.SchemaField("test_result", "STRING"),
                bigquery.SchemaField("test_confidence", "FLOAT"),
                bigquery.SchemaField("disease_suspected", "STRING"),
                bigquery.SchemaField("lat", "FLOAT"),
                bigquery.SchemaField("lng", "FLOAT"),
                bigquery.SchemaField("location_source", "STRING"),
                bigquery.SchemaField("places_api_name", "STRING"),
                bigquery.SchemaField("chw_id", "STRING"),
                bigquery.SchemaField("synced_at", "TIMESTAMP"),
            ]
        },
        {
            "name": "civic_hazards",
            "schema": [
                bigquery.SchemaField("hazard_id", "STRING"),
                bigquery.SchemaField("ward_id", "STRING"),
                bigquery.SchemaField("ward_name", "STRING"),
                bigquery.SchemaField("timestamp", "TIMESTAMP"),
                bigquery.SchemaField("hazard_type", "STRING"),
                bigquery.SchemaField("lat", "FLOAT"),
                bigquery.SchemaField("lng", "FLOAT"),
                bigquery.SchemaField("photo_url", "STRING"),
                bigquery.SchemaField("reporter_type", "STRING"),
                bigquery.SchemaField("location_source", "STRING"),
                bigquery.SchemaField("places_api_name", "STRING"),
            ]
        },
        {
            "name": "weather_daily",
            "schema": [
                bigquery.SchemaField("ward_id", "STRING"),
                bigquery.SchemaField("ward_name", "STRING"),
                bigquery.SchemaField("date", "DATE"),
                bigquery.SchemaField("rainfall_mm", "FLOAT"),
                bigquery.SchemaField("temp_max_c", "FLOAT"),
                bigquery.SchemaField("humidity_pct", "FLOAT"),
            ]
        },
        {
            "name": "ward_risk_scores",
            "schema": [
                bigquery.SchemaField("ward_id", "STRING"),
                bigquery.SchemaField("ward_name", "STRING"),
                bigquery.SchemaField("score_date", "DATE"),
                bigquery.SchemaField("risk_score", "FLOAT"),
                bigquery.SchemaField("predicted_cases_14d", "INTEGER"),
                bigquery.SchemaField("risk_level", "STRING"),
                bigquery.SchemaField("contributing_factors", "STRING"),
                bigquery.SchemaField("model_version", "STRING"),
            ]
        }
    ]
    
    for t in tables:
        table_id = f"{dataset_id}.{t['name']}"
        table = bigquery.Table(table_id, schema=t['schema'])
        try:
            client.create_table(table, exists_ok=True)
            print(f"Table {table_id} created or already exists.")
        except Exception as e:
            print(f"Error creating table {table_id}: {e}")

if __name__ == "__main__":
    main()
