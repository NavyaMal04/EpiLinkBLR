import os
import firebase_admin
from firebase_admin import credentials, firestore

def main():
    # Note: Firestore offline persistence is configured client-side in Flutter 
    # (e.g., FirebaseFirestore.instance.settings = Settings(persistenceEnabled=True))
    
    cred_path = "./keys/epilink-sa.json"
    if not os.path.exists(cred_path):
        print(f"Error: Credentials not found at {cred_path}")
        return
        
    try:
        cred = credentials.Certificate(cred_path)
        firebase_admin.initialize_app(cred, {'projectId': 'epilink-blr'})
    except Exception as e:
        print(f"Error initializing Firebase App: {e}")
        return
    
    db = firestore.client()
    collections = ["symptom_reports", "civic_hazards", "sync_queue"]
    
    try:
        # symptom_reports
        db.collection("symptom_reports").document("placeholder_doc").set({
            "_placeholder": True,
            "report_id": None, "ward_id": None, "ward_name": None,
            "timestamp": None, "symptoms": None, "test_result": None,
            "test_confidence": None, "disease_suspected": None,
            "lat": None, "lng": None, "location_source": None,
            "places_api_name": None, "chw_id": None, "synced_at": None
        })
        
        # civic_hazards
        db.collection("civic_hazards").document("placeholder_doc").set({
            "_placeholder": True,
            "hazard_id": None, "ward_id": None, "ward_name": None,
            "timestamp": None, "hazard_type": None,
            "lat": None, "lng": None, "photo_url": None,
            "reporter_type": None, "location_source": None,
            "places_api_name": None
        })
        
        # sync_queue
        db.collection("sync_queue").document("placeholder_doc").set({
            "status": "empty"
        })
        
        print("Created Firestore collections:")
        for col in collections:
            print(f"- {col}")
            
    except Exception as e:
        print(f"Error creating Firestore collections: {e}")

if __name__ == "__main__":
    main()
