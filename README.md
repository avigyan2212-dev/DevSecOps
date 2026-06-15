# 🌐 VoiceLingo — Voice Language Translator

A real-world voice translation web app built with Python Flask + SpeechRecognition + Google Translate.

## 📁 Project Structure

```
translator/
│
├── app.py                  ← Flask backend (API + routes)
├── requirements.txt        ← Python dependencies
├── README.md               ← This file
│
└── templates/
    └── index.html          ← Frontend (HTML + CSS + JS)
```

---

## ⚙️ Setup & Run

### Step 1 — Install Dependencies

```bash
pip install -r requirements.txt
```

> If `pyaudio` fails on Windows:
> ```bash
> pip install pipwin
> pipwin install pyaudio
> ```

> If `pyaudio` fails on Mac:
> ```bash
> brew install portaudio
> pip install pyaudio
> ```

---

### Step 2 — Run the App

```bash
python app.py
```

---

### Step 3 — Open in Browser

```
http://127.0.0.1:5000
```

---

## 🎯 Features

- 🎙️ **Voice Input** — Record your voice in English
- ⌨️ **Text Input** — Type text as fallback
- 🌍 **10 Languages** — Hindi, Spanish, French, German, Japanese, Chinese, Arabic, Portuguese, Russian, Korean
- 🔊 **Text-to-Speech** — Hear the translated output
- 🎨 **Dark UI** — Clean, modern interface

---

## 🛠️ Tech Stack

| Layer     | Technology                  |
|-----------|-----------------------------|
| Backend   | Python, Flask               |
| Voice STT | SpeechRecognition (Google)  |
| Translation | googletrans (Google API)  |
| Frontend  | HTML, CSS, Vanilla JS        |

---

## 🚀 How to Demo in Interview

1. Run `python app.py`
2. Open browser → `http://127.0.0.1:5000`
3. Select a language (e.g. Hindi)
4. Click mic → say "Hello, how are you?"
5. App shows: "Hello, how are you?" → "नमस्ते, आप कैसे हैं?"
6. Click **Speak Translation** to hear it

---

## 💡 Interview Talking Points

- Used Flask REST API with JSON request/response
- Integrated two third-party APIs (SpeechRecognition + googletrans)
- Handled audio encoding (WebM → WAV conversion in browser)
- Built error handling for mic failures, unclear speech, network issues
- Solves real problem: language barrier for travelers and non-native speakers
