import os
import uuid
import pandas as pd
import numpy as np
from google.cloud import bigquery

def main():
    if "GOOGLE_APPLICATION_CREDENTIALS" not in os.environ:
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "./keys/epilink-sa.json"
        
    try:
        client = bigquery.Client(project="epilink-blr")
    except Exception as e:
        print(f"Could not initialize BigQuery client: {e}")
        return
    
    query = "SELECT * FROM `epilink-blr.epilink_blr.weather_daily` ORDER BY date"
    weather_df = client.query(query).to_dataframe()
    
    if weather_df.empty:
        print("Weather data is empty!")
        return
        
    weather_df['date'] = pd.to_datetime(weather_df['date'])
    
    symptom_reports = []
    civic_hazards = []
    ward_risk_scores = []
    
    wards = weather_df['ward_id'].unique()
    ward_names = {w: weather_df[weather_df['ward_id'] == w]['ward_name'].iloc[0] for w in wards}
    
    np.random.seed(42)
    ward_multipliers = {w: np.random.uniform(0.8, 1.5) for w in wards}
    
    outbreak_start = pd.to_datetime("2023-10-15")
    outbreak_end = pd.to_datetime("2023-11-05")
    
    for w_id in wards:
        ward_data = weather_df[weather_df['ward_id'] == w_id].sort_values('date').reset_index(drop=True)
        w_name = ward_names[w_id]
        
        ward_data['lagged_rain'] = ward_data['rainfall_mm'].shift(12).fillna(0)
        ward_data['recent_rain'] = ward_data['rainfall_mm'].rolling(window=3).sum().shift(2).fillna(0)
        
        for idx, row in ward_data.iterrows():
            date = row['date']
            rain = row['rainfall_mm']
            lagged_rain = row['lagged_rain']
            recent_rain = row['recent_rain']
            
            num_stagnant = int(recent_rain * 0.5 * np.random.uniform(0.8, 1.2))
            for _ in range(num_stagnant):
                civic_hazards.append({
                    "hazard_id": str(uuid.uuid4()),
                    "ward_id": w_id,
                    "ward_name": w_name,
                    "timestamp": date + pd.Timedelta(hours=np.random.randint(6, 18)),
                    "hazard_type": "stagnant_water",
                    "lat": 12.97 + np.random.uniform(-0.05, 0.05),
                    "lng": 77.59 + np.random.uniform(-0.05, 0.05),
                    "photo_url": f"https://example.com/photo_{uuid.uuid4().hex[:6]}.jpg",
                    "reporter_type": "citizen",
                    "location_source": "gps",
                    "places_api_name": ""
                })
            
            baseline_cases = int(lagged_rain * 0.8 * ward_multipliers[w_id] + num_stagnant * 0.5)
            
            if w_id in ["ward_003", "ward_008"] and outbreak_start <= date <= outbreak_end:
                case_count = baseline_cases * 3 + np.random.randint(5, 15)
            else:
                case_count = baseline_cases + np.random.randint(0, 3)
                
            for _ in range(case_count):
                symptom_reports.append({
                    "report_id": str(uuid.uuid4()),
                    "ward_id": w_id,
                    "ward_name": w_name,
                    "timestamp": date + pd.Timedelta(hours=np.random.randint(8, 20)),
                    "symptoms": "fever, headache",
                    "test_result": np.random.choice(["positive", "negative"], p=[0.3, 0.7]),
                    "test_confidence": np.random.uniform(0.5, 0.99),
                    "disease_suspected": "dengue",
                    "lat": 12.97 + np.random.uniform(-0.05, 0.05),
                    "lng": 77.59 + np.random.uniform(-0.05, 0.05),
                    "location_source": "manual",
                    "places_api_name": "",
                    "chw_id": f"CHW_{np.random.randint(100, 999)}",
                    "synced_at": date + pd.Timedelta(hours=23)
                })
                
            # Refined risk score: more weight on case_count and capped for non-outbreak wards
            risk_score = 0.2 * (lagged_rain / 60.0) + 0.3 * (num_stagnant / 15.0) + 0.5 * (case_count / 30.0)
            
            # Cap non-outbreak wards to ensure they don't overshadow the injection
            if w_id not in ["ward_003", "ward_008"]:
                risk_score = min(0.75, risk_score)
            else:
                risk_score = min(1.0, risk_score)
            
            if risk_score < 0.3:
                risk_level = "low"
            elif risk_score <= 0.6:
                risk_level = "medium"
            elif risk_score <= 0.8:
                risk_level = "high"
            else:
                risk_level = "critical"
                
            ward_risk_scores.append({
                "ward_id": w_id,
                "ward_name": w_name,
                "score_date": date.date(),
                "risk_score": float(risk_score),
                "predicted_cases_14d": int(case_count * 1.2),
                "risk_level": risk_level,
                "contributing_factors": "rainfall, stagnant water",
                "model_version": "v1.0"
            })
            
    symptom_df = pd.DataFrame(symptom_reports)
    hazards_df = pd.DataFrame(civic_hazards)
    scores_df = pd.DataFrame(ward_risk_scores)
    
    if not symptom_df.empty:
        client.load_table_from_dataframe(symptom_df, "epilink-blr.epilink_blr.symptom_reports", job_config=bigquery.LoadJobConfig(write_disposition="WRITE_TRUNCATE")).result()
    if not hazards_df.empty:
        client.load_table_from_dataframe(hazards_df, "epilink-blr.epilink_blr.civic_hazards", job_config=bigquery.LoadJobConfig(write_disposition="WRITE_TRUNCATE")).result()
    if not scores_df.empty:
        client.load_table_from_dataframe(scores_df, "epilink-blr.epilink_blr.ward_risk_scores", job_config=bigquery.LoadJobConfig(write_disposition="WRITE_TRUNCATE")).result()
    
    print("Synthetic data generated and loaded into BigQuery.")
    
    peak_scores = scores_df.loc[scores_df.groupby('ward_id')['risk_score'].idxmax()]
    print("\nPeak Risk Scores per Ward:")
    for _, row in peak_scores.iterrows():
        print(f"{row['ward_name']} ({row['ward_id']}): {row['risk_score']:.3f} on {row['score_date']}")

if __name__ == "__main__":
    main()
