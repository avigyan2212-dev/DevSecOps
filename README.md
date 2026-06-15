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
