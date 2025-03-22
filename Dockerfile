FROM ubuntu:latest

RUN curl -fsSL https://deb.nodesource.com/setup.x | bash -

# Update and install necessary packages
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git \
    libpq-dev \
    g++ clangd \
    nodejs npm \
    curl software-properties-common \
    libgeos-dev libspatialindex-dev \
    htop \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js language server
RUN npm install -g typescript typescript-language-server \
    && npm cache clean --force

RUN ( curl -fsSL https://code-server.dev/install.sh | sh ) && rm -rf /root/.cache

RUN useradd -m -s /bin/bash coder
USER coder

RUN curl https://pyenv.run | bash
RUN PYTHON_CONFIGURE_OPTS="--enable-shared --with-ensurepip=install" $HOME/.pyenv/bin/pyenv install $($HOME/.pyenv/bin/pyenv install --list | grep -E "^\s*3\.12\.[0-9]+$" | tail -1)

# Install VS Code extensions
RUN code-server --install-extension ms-python.python \
    && code-server --install-extension ms-pyright.pyright \
    && code-server --install-extension guyskk.language-cython \
    && code-server --install-extension ms-vscode.cmake-tools \
    && code-server --install-extension llvm-vs-code-extensions.vscode-clangd \
    && code-server --install-extension xaver.clang-format \
    && code-server --install-extension dbaeumer.vscode-eslint \
    && code-server --install-extension angular.ng-template

COPY --chown=coder:coder .vimrc .gitconfig .Xresources .bashrc /home/coder/
COPY --chown=coder:coder vscode-config/settings.json vscode-config/keybindings.json /home/coder/.local/share/code-server/User/

# Set up workspace directory
RUN mkdir -p /home/coder/projects
WORKDIR /home/coder/projects

# Expose the VS Code Server port
EXPOSE 8080

# Start VS Code Server
CMD ["code-server", "--auth", "none", "--bind-addr", "0.0.0.0:8080", "."]
