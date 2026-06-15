from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import speech_recognition as sr
from googletrans import Translator
import base64
import io
import os

app = Flask(__name__)
CORS(app)

recognizer = sr.Recognizer()
translator = Translator()

LANGUAGES = {
    "Hindi": "hi",
    "Spanish": "es",
    "French": "fr",
    "German": "de",
    "Japanese": "ja",
    "Chinese": "zh-cn",
    "Arabic": "ar",
    "Portuguese": "pt",
    "Russian": "ru",
    "Korean": "ko"
}

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/languages", methods=["GET"])
def get_languages():
    return jsonify({"languages": list(LANGUAGES.keys())})

@app.route("/translate", methods=["POST"])
def translate_audio():
    try:
        data = request.get_json()

        # Get audio data (base64 encoded WAV from frontend)
        audio_b64 = data.get("audio")
        target_lang_name = data.get("target_language", "Hindi")

        if not audio_b64:
            return jsonify({"error": "No audio data received"}), 400

        target_lang_code = LANGUAGES.get(target_lang_name, "hi")

        # Decode audio bytes
        audio_bytes = base64.b64decode(audio_b64)
        audio_file = io.BytesIO(audio_bytes)

        # Speech to text
        with sr.AudioFile(audio_file) as source:
            recognizer.adjust_for_ambient_noise(source, duration=0.2)
            audio_data = recognizer.record(source)

        original_text = recognizer.recognize_google(audio_data, language="en-US")

        # Translate
        translated = translator.translate(original_text, dest=target_lang_code)

        return jsonify({
            "original_text": original_text,
            "translated_text": translated.text,
            "target_language": target_lang_name,
            "target_code": target_lang_code
        })

    except sr.UnknownValueError:
        return jsonify({"error": "Could not understand the audio. Please speak clearly."}), 400
    except sr.RequestError as e:
        return jsonify({"error": f"Speech recognition service error: {str(e)}"}), 500
    except Exception as e:
        return jsonify({"error": f"Something went wrong: {str(e)}"}), 500

@app.route("/translate-text", methods=["POST"])
def translate_text():
    """Translate plain text (fallback if mic not available)"""
    try:
        data = request.get_json()
        text = data.get("text", "")
        target_lang_name = data.get("target_language", "Hindi")

        if not text.strip():
            return jsonify({"error": "No text provided"}), 400

        target_lang_code = LANGUAGES.get(target_lang_name, "hi")
        translated = translator.translate(text, dest=target_lang_code)

        return jsonify({
            "original_text": text,
            "translated_text": translated.text,
            "target_language": target_lang_name,
            "target_code": target_lang_code
        })

    except Exception as e:
        return jsonify({"error": f"Translation failed: {str(e)}"}), 500

if __name__ == "__main__":
    app.run(debug=True, port=5000)
