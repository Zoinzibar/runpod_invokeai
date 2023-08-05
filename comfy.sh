#!/bin/bash

PYTHONUNBUFFERED=1
source /venv/bin/activate
cd /workspace/ComfyUI
python main.py --listen --port 3000 &