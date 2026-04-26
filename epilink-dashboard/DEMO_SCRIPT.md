# EpiLink BLR Command Center — Hackathon Demo Script

This script provides a 4-minute walkthrough of the EpiLink Command Center to showcase the full end-to-end integration of TFLite, BigQuery, and Gemini AI.

---

### Step 1: Baseline Stabilization (The Calm)
- **Action**: Load the dashboard. If the **Date Slider** isn't at the start, click **Reset** or slide to **Sept 01**.
- **Talking Point**: "Welcome to the EpiLink Command Center. It's early September in Bengaluru. Our surveillance system is monitoring 10 key wards. As you can see on the map, all wards are currently green—risk scores are below 20%."

### Step 2: Temporal Evolution (The Spike)
- **Action**: Click the **Play** button on the Date Slider.
- **Talking Point**: "As we move into October, we start seeing a rise in stagnant water reports and symptom logs from our CHW app. Watch the map—Whitefield and Bellandur are shifting from yellow to orange. Our predictive models are sensing an impending spike."

### Step 3: Outbreak Peak (Oct 20)
- **Action**: Pause the slider at **October 20, 2023** (or let it reach there).
- **Talking Point**: "On October 20th, the system hits a critical threshold. Whitefield and Bellandur have turned deep red. Risk scores have surged to 94%. We now have 2 Critical Alerts in our feed."

### Step 4: Drill-down Analysis
- **Action**: Click the **Whitefield** rectangle on the map.
- **Talking Point**: "By clicking Whitefield, we can see the data behind the color. Our TFLite mRDT scans have confirmed 47 positive cases. The timeline below clearly shows the sharp upward trajectory of the outbreak compared to the city baseline."

### Step 5: AI-Driven Intervention
- **Action**: Click the suggested prompt in the Gemini Panel: **"Which wards need intervention this week?"**
- **Talking Point**: "We don't just show data; we provide action. I'll ask EpiLink AI for a recommendation. Using live BigQuery data, Gemini identifies that Whitefield needs immediate fogging units due to the high stagnant water reports. This allows health officials to deploy resources where they'll save the most lives."

### Step 6: Closing
- **Talking Point**: "EpiLink BLR turns raw surveillance data into life-saving interventions in real-time. Thank you."
