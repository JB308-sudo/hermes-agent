FROM python:3.11-slim

RUN apt-get update && apt-get install -y git curl nodejs npm ripgrep && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:/root/.local/bin:$PATH"

WORKDIR /app
RUN git clone --recurse-submodules https://github.com/NousResearch/hermes-agent.git .

RUN uv venv venv --python 3.11
RUN . venv/bin/activate && uv pip install -e ".[all]"

RUN mkdir -p /root/.local/bin && ln -sf /app/venv/bin/hermes /root/.local/bin/hermes

RUN pip install flask

EXPOSE 10000

CMD flask run --host=0.0.0.0 --port=10000 & hermes gateway
