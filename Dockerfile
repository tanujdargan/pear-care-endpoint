FROM runpod/pytorch:2.3.0-py3.11-cuda12.1.1-devel-ubuntu22.04
ENV PYTHONUNBUFFERED=True
ENV HF_HUB_ENABLE_HF_TRANSFER=1
ENV PIP_BREAK_SYSTEM_PACKAGES=1
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt
COPY handler.py .
CMD ["python", "-u", "handler.py"]