import os
import sys
from google.cloud import bigquery
import firebase_admin
from firebase_admin import credentials, firestore

def main():
    if "GOOGLE_APPLICATION_CREDENTIALS" not in os.environ:
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "./keys/epilink-sa.json"
        
    try:
        client = bigquery.Client(project="epilink-blr")
    except Exception as e:
        print(f"Could not initialize BigQuery client: {e}")
        sys.exit(1)
        
    tables = [
        "epilink-blr.epilink_blr.weather_daily",
        "epilink-blr.epilink_blr.symptom_reports",
        "epilink-blr.epilink_blr.civic_hazards",
        "epilink-blr.epilink_blr.ward_risk_scores"
    ]
    
    print("--- BigQuery Tables Check ---")
    all_passed = True
    for t in tables:
        try:
            query = f"SELECT COUNT(*) as count FROM `{t}`"
            df = client.query(query).to_dataframe()
            count = df['count'].iloc[0]
            if count > 0:
                print(f"PASS: {t} exists with {count} rows.")
            else:
                print(f"FAIL: {t} is empty.")
                all_passed = False
        except Exception as e:
            print(f"FAIL: Could not verify {t} - {e}")
            all_passed = False
            
    print("\n--- Outbreak Verification ---")
    query = """
    SELECT ward_name, score_date, risk_score
    FROM `epilink-blr.epilink_blr.ward_risk_scores`
    ORDER BY risk_score DESC
    LIMIT 1
    """
    try:
        df = client.query(query).to_dataframe()
        if not df.empty:
            ward = df['ward_name'].iloc[0]
            date = df['score_date'].iloc[0]
            score = df['risk_score'].iloc[0]
            print(f"Highest risk score: {ward} on {date} with score {score:.3f}")
            if ward not in ["Whitefield", "Bellandur"]:
                print("CRITICAL: Outbreak injection failed — check generate_synthetic_data.py")
                all_passed = False
        else:
            print("FAIL: ward_risk_scores is empty")
            all_passed = False
    except Exception as e:
        print(f"FAIL: Query failed - {e}")
        all_passed = False
        
    print("\n--- Firebase Check ---")
    try:
        cred_path = "./keys/epilink-sa.json"
        if not firebase_admin._apps:
            cred = credentials.Certificate(cred_path)
            firebase_admin.initialize_app(cred, {'projectId': 'epilink-blr'})
            
        db = firestore.client()
        collections = db.collections()
        col_names = [col.id for col in collections]
        expected = ["symptom_reports", "civic_hazards", "sync_queue"]
        
        for e in expected:
            if e in col_names:
                print(f"PASS: Firestore collection '{e}' exists.")
            else:
                print(f"FAIL: Firestore collection '{e}' missing.")
                all_passed = False
    except Exception as e:
        print(f"FAIL: Firestore check failed - {e}")
        all_passed = False
        
    if all_passed:
        print("\nPhase 2 complete — ready for Flutter build")
    else:
        print("\nPhase 2 verification failed.")
        sys.exit(1)

if __name__ == "__main__":
    main()
