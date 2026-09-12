"""
BloomTech disease-diagnosis Flask server
=========================================

STATUS: unverified reference scaffold. No Flask/Python source existed
anywhere in the original project download - the Flutter app only contains
a hardcoded HTTP call to a "/predict" endpoint
(lib/Pages/scan_page.dart), with no server-side code included. This file
implements a server that satisfies that exact contract so the app's scan
feature has something real to talk to, but it ships with NO trained model,
NO class list, and NO treatment data, because none of those were present
in the provided materials and inventing them would misrepresent the
project's actual (unverified) accuracy and content.

Request contract (matches lib/Pages/scan_page.dart exactly):
  POST /predict
  multipart/form-data, field name "image" -> the photographed leaf.

Response contract (matches lib/Pages/scan_page.dart exactly):
  {
    "status": "<human-readable diagnosis string>",
    "cure": "<optional treatment suggestion>",
    "image": "<optional 'data:image/...;base64,<...>' annotated image>"
  }

To make this runnable, you must supply:
  1. models/model.h5 - a Keras/TensorFlow classifier you trained yourself
     (the thesis describes a CNN; this scaffold assumes that architecture
     since it's the more specific of the two conflicting descriptions -
     see the repository README's "Documentation vs. Implementation Notes").
     If you instead want to serve a YOLOv5 model (as the project's prior
     README described), swap the inference code in `predict_image` below
     for a `torch.hub.load(...)` call - that's a different enough API that
     this scaffold does not attempt to support both.
  2. class_names.json - an ordered list of class labels matching your
     model's output layer, in the same order used during training.
  3. treatments.json - a {class_name: treatment text} map for the "cure"
     field. Classes not present in this file simply omit "cure" from the
     response rather than inventing generic advice.
"""

import base64
import io
import json
import os

from flask import Flask, jsonify, request
from PIL import Image

MODEL_PATH = os.environ.get("MODEL_PATH", "models/model.h5")
CLASS_NAMES_PATH = os.environ.get("CLASS_NAMES_PATH", "class_names.json")
TREATMENTS_PATH = os.environ.get("TREATMENTS_PATH", "treatments.json")
INPUT_SIZE = (
    int(os.environ.get("MODEL_INPUT_WIDTH", 224)),
    int(os.environ.get("MODEL_INPUT_HEIGHT", 224)),
)

app = Flask(__name__)

_model = None
_class_names = []
_treatments = {}


def _load_resources():
    global _model, _class_names, _treatments

    if os.path.exists(CLASS_NAMES_PATH):
        with open(CLASS_NAMES_PATH, "r", encoding="utf-8") as f:
            _class_names = json.load(f)

    if os.path.exists(TREATMENTS_PATH):
        with open(TREATMENTS_PATH, "r", encoding="utf-8") as f:
            _treatments = json.load(f)

    if os.path.exists(MODEL_PATH):
        # Imported lazily so the server can still start (and report a clear
        # error on /predict) even if tensorflow isn't installed yet or no
        # model file has been supplied.
        import tensorflow as tf

        _model = tf.keras.models.load_model(MODEL_PATH)
    else:
        app.logger.warning(
            "No model found at %s - /predict will return an error until "
            "you supply a trained model.",
            MODEL_PATH,
        )


def predict_image(image: Image.Image):
    """Run the classifier on a single PIL image.

    Returns (status, cure_or_none). Raises RuntimeError if no model is
    loaded.
    """
    if _model is None:
        raise RuntimeError(
            f"No model loaded from {MODEL_PATH}. See backend/README.md."
        )

    import numpy as np

    resized = image.convert("RGB").resize(INPUT_SIZE)
    array = np.asarray(resized, dtype="float32") / 255.0
    batch = np.expand_dims(array, axis=0)

    predictions = _model.predict(batch)
    class_index = int(np.argmax(predictions[0]))

    if 0 <= class_index < len(_class_names):
        label = _class_names[class_index]
    else:
        label = f"class_{class_index}"

    cure = _treatments.get(label)
    return label, cure


@app.route("/predict", methods=["POST"])
def predict():
    if "image" not in request.files:
        return jsonify({"error": "No 'image' file field in request."}), 400

    file = request.files["image"]
    try:
        image = Image.open(file.stream)
    except Exception:
        return jsonify({"error": "Could not read uploaded image."}), 400

    try:
        status, cure = predict_image(image)
    except RuntimeError:
        # No model configured (e.g. this is the Vercel demo stub, which
        # ships without TensorFlow/a model file - see README "Deploying a
        # demo stub to Vercel"). Respond with a valid "status" field rather
        # than a bare error, since that's the field the Flutter app reads.
        return jsonify({
            "status": "Diagnosis unavailable - no trained model is "
                      "configured on this deployment yet.",
        })

    response = {"status": status}
    if cure:
        response["cure"] = cure

    # Echo the original image back as a data URI so the app's optional
    # "image" field has something valid to decode. Replace this with an
    # annotated image (e.g. bounding boxes) if you add detection.
    buffer = io.BytesIO()
    image.convert("RGB").save(buffer, format="JPEG")
    encoded = base64.b64encode(buffer.getvalue()).decode("ascii")
    response["image"] = f"data:image/jpeg;base64,{encoded}"

    return jsonify(response)


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"model_loaded": _model is not None})


_load_resources()

if __name__ == "__main__":
    # Host 0.0.0.0 so a phone on the same LAN can reach it, matching the
    # app's hardcoded LAN-IP setup described in the README.
    app.run(host="0.0.0.0", port=5000, debug=True)
