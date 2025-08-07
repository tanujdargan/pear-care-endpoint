```python
import os
from transformers import AutoTokenizer, AutoModelForCausalLM

model_name = "google/medgemma-27b"
cache_dir = "/models/medgemma-27b" # local path to the model for later use
hf_token = "HF TOKEN HERE"

# Create directory if it doesn't exist
os.makedirs(cache_dir, exist_ok=True)

print("Downloading tokenizer...")
AutoTokenizer.from_pretrained(model_name, token=hf_token).save_pretrained(cache_dir)

print("Downloading model...")
AutoModelForCausalLM.from_pretrained(model_name, token=hf_token).save_pretrained(cache_dir)

print(f"Model and tokenizer downloaded to {cache_dir}")
```