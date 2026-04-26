import google.auth
import google.auth.transport.requests
import requests
import os

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'd:/EpiLinkBLR/keys/epilink-sa.json'

credentials, project = google.auth.default(scopes=['https://www.googleapis.com/auth/cloud-platform'])
request = google.auth.transport.requests.Request()
credentials.refresh(request)

rules_content = """rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
"""

url = "https://firebaserules.googleapis.com/v1/projects/epilink-blr/rulesets"
headers = {"Authorization": f"Bearer {credentials.token}"}
payload = {
    "source": {
        "files": [{"name": "firestore.rules", "content": rules_content}]
    }
}

res = requests.post(url, headers=headers, json=payload)
data = res.json()
print("Ruleset creation:", data)
ruleset_name = data.get('name')

if ruleset_name:
    release_url = "https://firebaserules.googleapis.com/v1/projects/epilink-blr/releases/cloud.firestore"
    patch_payload = {
        "release": {
            "name": "projects/epilink-blr/releases/cloud.firestore",
            "rulesetName": ruleset_name
        }
    }
    
    res = requests.patch(release_url, headers=headers, json=patch_payload)
    if res.status_code == 404:
        # If release doesn't exist yet, use POST to create
        post_url = "https://firebaserules.googleapis.com/v1/projects/epilink-blr/releases"
        res = requests.post(post_url, headers=headers, json={"name": "projects/epilink-blr/releases/cloud.firestore", "rulesetName": ruleset_name})
    print("Release update:", res.json())
