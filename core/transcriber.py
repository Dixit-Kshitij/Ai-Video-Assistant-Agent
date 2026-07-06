import whisper
import os
from dotenv import load_dotenv
load_dotenv()

_model = None

def load_model():
    global _model

    if _model is None:
        print("Model is loading...")
        _model = whisper.load_model("base")
        print("whisper model loaded successfully")

    return _model


def transcribe_chunks(chunk_path: str, language: str = "english") -> str:
    """Transcribe a single audio chunk using Whisper.

    Args:
        chunk_path: Path to the WAV audio chunk file.
        language: Detected language string ("english", "hinglish", etc.).
                  If "hinglish" or any non-English, we use task="translate"
                  to get English output; otherwise task="transcribe".
    Returns:
        Transcribed text string, or empty string if chunk is invalid.
    """
    if not os.path.isfile(chunk_path):
        print(f"[WARNING] Chunk not found, skipping: {chunk_path}")
        return ""

    if os.path.getsize(chunk_path) == 0:
        print(f"[WARNING] Chunk is empty, skipping: {chunk_path}")
        return ""

    model = load_model()

    # Use "translate" for non-English to get English output from Whisper
    task = "translate" if language.lower() == "hinglish" else "transcribe"

    try:
        result = model.transcribe(chunk_path, task=task, fp16=False)
        return result.get("text", "").strip()
    except Exception as e:
        print(f"[ERROR] Transcription failed for {chunk_path}: {e}")
        return ""


def transcribe_all(chunks: list, language: str = "english") -> str:
    """Transcribe all audio chunks and join them.

    Args:
        chunks: List of paths to WAV audio chunk files.
        language: Language string passed from the UI ("english" / "hinglish").
    Returns:
        Full joined transcript string.
    """
    transcriptions = []

    for chunk in chunks:
        text = transcribe_chunks(chunk, language)
        if text:
            transcriptions.append(text)

    print("transcriptions completed")

    return " ".join(transcriptions)
