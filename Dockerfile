FROM ubuntu:latest

RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash -

# Update and install necessary packages
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git \
    libpq-dev \
    cmake g++ clangd clang-format golang-go \
    protobuf-c-compiler libprotobuf-dev protobuf-compiler-grpc libgrpc++-dev \
    nodejs npm \
    curl software-properties-common \
    libgeos-dev libspatialindex-dev \
    htop nmap vim tmux curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js language server
RUN npm install -g typescript typescript-language-server \
    && npm cache clean --force

ENV PYENV_ROOT="/opt/pyenv"
RUN ( curl -fsSL https://code-server.dev/install.sh | bash ) && rm -rf /root/.cache
RUN ( curl -fsSL https://pyenv.run | bash ) && rm -rf /root/.cache
RUN bash -c ' \
    LATEST_3_12=$($PYENV_ROOT/bin/pyenv install --list | grep -E "^\s*3\.12\.[0-9]+$" | tail -1 | tr -d " ") \
    && echo "Installing Python $LATEST_3_12..." \
    && PYTHON_CONFIGURE_OPTS="--enable-shared --with-ensurepip=install" $PYENV_ROOT/bin/pyenv install $LATEST_3_12 \
    && $PYENV_ROOT/bin/pyenv global $LATEST_3_12 \
    && rm -rf /tmp/* $PYENV_ROOT/cache/* \
'
RUN bash -c ' \
    curl -fsSL https://cursor.com/install | bash \
    && mv /root/.local/share/cursor-agent /opt/cursor-agent \
    && ln -sf /opt/cursor-agent/versions/$(ls /opt/cursor-agent/versions | head -n 1)/cursor-agent /usr/bin/cursor-agent \
    && rm -rf /root/.local /root/.cache \
'


RUN useradd -m -s /bin/bash coder
USER coder

# Install VS Code extensions
RUN code-server --install-extension ms-python.python \
    && code-server --install-extension ms-pyright.pyright \
    && code-server --install-extension guyskk.language-cython \
    && code-server --install-extension ms-vscode.cmake-tools \
    && code-server --install-extension llvm-vs-code-extensions.vscode-clangd \
    && code-server --install-extension xaver.clang-format \
    && code-server --install-extension dbaeumer.vscode-eslint \
    && code-server --install-extension angular.ng-template \
    && code-server --install-extension google.geminicodeassist \
    && code-server --install-extension zxh404.vscode-proto3 \
    && code-server --install-extension ms-toolsai.jupyter

COPY --chown=coder:coder .vimrc .gitconfig .Xresources .bashrc .tmux.conf /home/coder/
COPY --chown=coder:coder vscode-config/settings.json vscode-config/keybindings.json /home/coder/.local/share/code-server/User/

# Set up workspace directory
RUN mkdir -p /home/coder/projects /home/coder/.ssh
WORKDIR /home/coder/projects

# Expose the VS Code Server port
EXPOSE 8080

ENV NO_OPEN_BROWSER=1
ENV PATH="$PYENV_ROOT/bin:/home/coder/.local/bin:$PATH"

# Start VS Code Server
CMD ["code-server", "--auth", "none", "--bind-addr", "0.0.0.0:8080", "."]
