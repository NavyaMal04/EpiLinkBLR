# EpiLink BLR — Flutter Setup Notes 📱

Follow these steps to finalize the mobile application setup.

## 1. Firebase Integration
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Select your project `epilink-blr`.
3. Add an Android App (Package name: `com.navyam.epilink_blr`).
4. Download `google-services.json`.
5. Place it at: `android/app/google-services.json`.

## 2. Google Maps Setup
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Ensure **Maps SDK for Android** and **Places API** are enabled.
3. Create an API Key in **APIs & Services > Credentials**.
4. Replace `REPLACE_WITH_YOUR_MAPS_API_KEY` in these files:
   - `android/app/src/main/AndroidManifest.xml`
   - `lib/widgets/location_picker_widget.dart`

## 3. Generate Database Code
The app uses **Drift** for local SQLite storage. You must generate the code for the database:

```bash
cd epilink_blr
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 4. Run the App
```bash
flutter run
```

## Troubleshooting
- **TFLite Error:** Ensure `assets/models/mrdt_classifier.tflite` is present.
- **Location Error:** Ensure GPS is enabled on the device/emulator.
- **Sync Error:** Ensure you have linked your billing account in GCP as Firestore/BigQuery require it for some features.
