# Use RunPod's optimized base image but specify runtime version to reduce size
FROM runpod/pytorch:0.7.0-cu1241-torch241-ubuntu2204

# Environment variables
ENV PYTHONUNBUFFERED=True
ENV HF_HUB_ENABLE_HF_TRANSFER=1
ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV MODEL_PATH=/models/medgemma-27b

WORKDIR /app
COPY requirements.txt .

# Install packages with cache optimizations and cleanup
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip cache purge && \
    rm -rf /root/.cache/pip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

# Copy application code
COPY handler.py .

CMD ["python", "-u", "handler.py"]