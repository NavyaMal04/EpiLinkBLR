import os
import requests
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
        
    table_id = "epilink-blr.epilink_blr.weather_daily"
    url = "https://api.open-meteo.com/v1/forecast"
    
    params = {
        "latitude": 12.97,
        "longitude": 77.59,
        "start_date": "2023-09-01",
        "end_date": "2023-11-30",
        "daily": ["rain_sum", "temperature_2m_max", "relative_humidity_2m_max"],
        "timezone": "Asia/Kolkata"
    }
    
    try:
        response = requests.get(url, params=params)
        data = response.json()
        if "error" in data:
            url = "https://archive-api.open-meteo.com/v1/archive"
            response = requests.get(url, params=params)
            data = response.json()
            if "error" in data:
                # Fallback if humidity max isn't available
                params["daily"] = ["rain_sum", "temperature_2m_max"]
                response = requests.get(url, params=params)
                data = response.json()
    except Exception as e:
        print(f"Error fetching weather: {e}")
        return
        
    daily = data.get("daily", {})
    dates = daily.get("time", [])
    rain = daily.get("rain_sum", [])
    temp = daily.get("temperature_2m_max", [])
    humidity = daily.get("relative_humidity_2m_max", [])
    
    # If humidity is entirely missing due to fallback
    if not humidity:
        humidity = [60.0] * len(dates)
    
    wards = [
        ("ward_001", "Yelahanka"), ("ward_002", "KR Puram"),
        ("ward_003", "Whitefield"), ("ward_004", "Hebbal"),
        ("ward_005", "Bommanahalli"), ("ward_006", "Koramangala"),
        ("ward_007", "HSR Layout"), ("ward_008", "Bellandur"),
        ("ward_009", "Mahadevapura"), ("ward_010", "Rajajinagar")
    ]
    
    rows = []
    for date, r, t, h in zip(dates, rain, temp, humidity):
        r = r if r is not None else 0.0
        t = t if t is not None else 25.0
        h = h if h is not None else 60.0
        
        for w_id, w_name in wards:
            noise_r = r * np.random.uniform(-0.15, 0.15)
            noise_t = np.random.uniform(-1.0, 1.0)
            noise_h = h * np.random.uniform(-0.05, 0.05)
            
            ward_r = max(0.0, r + noise_r)
            ward_t = t + noise_t
            ward_h = max(0.0, min(100.0, h + noise_h))
            
            rows.append({
                "ward_id": w_id,
                "ward_name": w_name,
                "date": date,
                "rainfall_mm": float(ward_r),
                "temp_max_c": float(ward_t),
                "humidity_pct": float(ward_h)
            })
            
    df = pd.DataFrame(rows)
    df['date'] = pd.to_datetime(df['date']).dt.date
    
    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_TRUNCATE",
    )
    
    job = client.load_table_from_dataframe(df, table_id, job_config=job_config)
    job.result()
    
    print(f"Successfully loaded {job.output_rows} rows into {table_id}")

if __name__ == "__main__":
    main()
