import os
import torch
import runpod
from transformers import AutoTokenizer, AutoModelForCausalLM, BitsAndBytesConfig

# --- Model Initialization ---
# Global variables to hold the model and tokenizer
model = None
tokenizer = None

def initialize_model():
    """
    Initializes the model and tokenizer and loads them into memory.
    This function is called once when the worker starts.
    """
    global model, tokenizer

    # Use network storage path for the pre-downloaded model
    # This avoids downloading the model on every cold start
    model_name_or_path = os.environ.get("MODEL_PATH", "/models/medgemma-27b")
    hf_token = os.environ.get("HF_TOKEN")

    if not hf_token:
        raise ValueError("Hugging Face token not found in environment variables.")

    print(f"Initializing model: {model_name_or_path}")

    # Configuration for 4-bit quantization
    quantization_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.bfloat16,
        bnb_4bit_use_double_quant=True,
    )

    # Load the tokenizer
    tokenizer = AutoTokenizer.from_pretrained(
        model_name_or_path,
        token=hf_token
    )

    # Load the model with quantization
    model = AutoModelForCausalLM.from_pretrained(
        model_name_or_path,
        quantization_config=quantization_config,
        device_map="auto",  # Automatically distribute the model across available GPUs
        torch_dtype=torch.bfloat16,
        token=hf_token
    )
    
    print("Model initialized successfully.")


# --- Inference Handler ---
def handler(job):
    """
    Handles a single inference job.
    'job' is a dictionary containing the input data.
    """
    global model, tokenizer

    # Initialize model on the first run
    if model is None:
        initialize_model()

    # Get input from the job
    job_input = job.get('input', {})
    prompt_text = job_input.get('prompt')

    if not prompt_text:
        return {"error": "No prompt provided in the input."}

    # Get generation parameters or use defaults
    max_new_tokens = job_input.get('max_new_tokens', 256)
    temperature = job_input.get('temperature', 0.7)

    try:
        # Create the prompt using the model's chat template
        messages = [
            {"role": "user", "content": prompt_text},
        ]
        input_ids = tokenizer.apply_chat_template(
            messages,
            add_generation_prompt=True,
            return_tensors="pt"
        ).to(model.device)
        
        # Generate the output
        outputs = model.generate(
            input_ids,
            max_new_tokens=max_new_tokens,
            temperature=temperature,
            do_sample=True,
            pad_token_id=tokenizer.eos_token_id
        )
        
        # Decode the generated text
        response_text = tokenizer.decode(outputs[0][input_ids.shape[-1]:], skip_special_tokens=True)

        return {"response": response_text}

    except Exception as e:
        print(f"Error during inference: {e}")
        return {"error": str(e)}


# Start the RunPod serverless worker
if __name__ == "__main__":
    runpod.serverless.start({"handler": handler})