# Simple Dockerfile following RunPod worker-basic pattern
# Reference: https://github.com/runpod-workers/worker-basic
FROM runpod/pytorch:0.7.0-cu1241-torch241-ubuntu2204

# Minimal env
ENV PYTHONUNBUFFERED=1 \
    MODEL_PATH=/models/medgemma-27b

# Use root as working dir (matches worker-basic)
WORKDIR /

# Install Python deps
COPY requirements.txt /requirements.txt
RUN python -m pip install --upgrade pip && \
    python -m pip install -r /requirements.txt --no-cache-dir && \
    rm /requirements.txt

# Copy handler
COPY handler.py /handler.py

# Start worker
CMD ["python", "-u", "/handler.py"]