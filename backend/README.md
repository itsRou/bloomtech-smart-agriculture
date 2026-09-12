# BloomTech Disease-Diagnosis Backend

**Status: unverified reference scaffold, not a trained/working classifier.** No Python/Flask source existed anywhere in the original project download. The Flutter app ([`lib/Pages/scan_page.dart`](../lib/Pages/scan_page.dart)) only contains a hardcoded HTTP call to a `/predict` endpoint - the server it was calling during development is not part of this repository. `app.py` here implements a server that satisfies that exact request/response contract so the app's scan feature has something real to run against, but it ships with **no trained model, no class list, and no treatment text**, since none of those existed in the provided materials.

## Why no model is included

The project's thesis documentation describes a custom CNN trained with TensorFlow/Keras and served via Flask. This repository's own prior README instead described a YOLOv5-based pipeline with weights hosted on Google Drive. These two descriptions conflict, and neither the training code, the dataset, nor the resulting weights were provided - so this scaffold cannot include real model accuracy, class names, or treatment advice without inventing them. It assumes the CNN/Keras architecture (the more specific of the two descriptions) so you have a concrete API to fill in; see the comment at the top of `app.py` if you want to adapt it to serve a YOLOv5 model instead.

## Setup

```bash
cd backend
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
```

Then supply your own:
1. `models/model.h5` - a Keras model you trained (input size configurable via `MODEL_INPUT_WIDTH`/`MODEL_INPUT_HEIGHT` env vars, default 224x224).
2. `class_names.json` - replace the placeholder list with your model's real output classes, in training order.
3. `treatments.json` - replace the placeholder entry with real `{class_name: treatment text}` pairs for the classes you actually trained on. Classes without an entry simply omit `cure` from the API response.

Run it:

```bash
python app.py
```

This starts the server on `0.0.0.0:5000` so a phone on the same Wi-Fi network can reach it - update the IP in [`lib/Pages/scan_page.dart`](../lib/Pages/scan_page.dart) to match the machine running this server (find it with `ipconfig`/`ifconfig`), since the currently hardcoded address is specific to the original developer's network.

## API

`POST /predict` - multipart form field `image` (a photo). Returns:

```json
{
  "status": "predicted class name",
  "cure": "treatment text, only if found in treatments.json",
  "image": "data:image/jpeg;base64,... (the uploaded image echoed back)"
}
```

`GET /health` - `{"model_loaded": true|false}`, useful for confirming the model file was found before testing from the app.

## Known limitations of this scaffold

- No image annotation/bounding boxes - the `image` field just echoes the original upload. Add drawing logic here if you implement detection (YOLO-style) rather than plain classification.
- No authentication, rate limiting, or HTTPS - this mirrors the original app's plain-HTTP LAN setup and is not suitable for a public-internet deployment as-is.
- No accuracy figures are claimed anywhere because no trained model or evaluation results were provided.
