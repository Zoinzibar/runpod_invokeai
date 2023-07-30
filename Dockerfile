FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt-get install -y --no-install-recommends rsync curl python3.10 python3.10-venv  python3-opencv python3-pip build-essential libopencv-dev nginx lsof && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118
ENV INVOKEAI_ROOT=/workspace/invokeai

RUN python -m venv /workspace/invokeai/venv
ENV PATH="/workspace/invokeai/venv/bin:$PATH"

WORKDIR /workspace/invokeai

RUN pip install "InvokeAI[xformers]" --use-pep517 --extra-index-url https://download.pytorch.org/whl/cu118 && \
    pip install pypatchmatch jupyterlab jupyterlab_widgets ipykernel ipywidgets

RUN mv /workspace/invokeai /invokeai

# NGINX Proxy
COPY proxy/nginx.conf /etc/nginx/nginx.conf
COPY proxy/readme.html /usr/share/nginx/html/readme.html

# Copy the README.md
COPY README.md /usr/share/nginx/html/README.md

# Start Scripts
COPY pre_start.sh /pre_start.sh
COPY start.sh /
RUN chmod +x /start.sh && chmod +x /pre_start.sh

CMD [ "/start.sh" ]