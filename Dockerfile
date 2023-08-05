FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 as runtime

# Set working directory and environment variables
WORKDIR /
ENV SHELL=/bin/bash \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Set up system
RUN apt-get update --yes && \
    apt-get upgrade --yes && \
    apt install --yes --no-install-recommends git wget curl bash libgl1 software-properties-common openssh-server nginx rsync && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3.10-dev python3.10-venv -y --no-install-recommends && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

# Set up Python and pip
RUN ln -s /usr/bin/python3.10 /usr/bin/python && \
    rm /usr/bin/python3 && \
    ln -s /usr/bin/python3.10 /usr/bin/python3 && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py

# Install necessary Python packages
RUN pip install --upgrade --no-cache-dir pip
RUN pip install --upgrade --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN pip install --upgrade --no-cache-dir jupyterlab ipywidgets jupyter-archive jupyter_contrib_nbextensions triton xformers==0.0.18 gdown

RUN pip install notebook
RUN jupyter contrib nbextension install --user && \
    jupyter nbextension enable --py widgetsnbextension

RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Create workspace directory
RUN mkdir /workspace

# Install ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI && \
    cd /workspace/ComfyUI && \
    pip install -r requirements.txt

# Install ComfyUI-Manager
RUN cd /workspace/ComfyUI/custom_nodes && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git

# Download the Stable Diffusion XL 1.0 base and refiner models
RUN wget https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors -O /workspace/ComfyUI/models/checkpoints/stable-diffusion-xl-base-1.0 && \
    wget https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors -O /workspace/ComfyUI/models/checkpoints/stable-diffusion-xl-refiner-1.0
# Start Scripts
COPY comfy.sh /comfy.sh
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD [ "/start.sh" ]