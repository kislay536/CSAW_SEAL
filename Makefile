# Variables
PYTHON_VERSION := python3.9
VENV_DIR := my_env
REQUIREMENTS := requirements.txt

# Targets
.PHONY: install env start

# Target for installing Python 3.9 (OS-dependent, assuming Debian/Ubuntu-based system)
install_python:
	@echo "Checking for Python 3.9 installation..."
	@if ! command -v $(PYTHON_VERSION) > /dev/null; then \
		echo "Python 3.9 not found. Adding PPA and installing..."; \
		if ! grep -q "^deb .*deadsnakes/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then \
			sudo add-apt-repository -y ppa:deadsnakes/ppa; \
		fi; \
		sudo apt update -y && \
		sudo apt install -y python3.9 python3.9-venv python3.9-dev; \
	else \
		echo "Python 3.9 is already installed."; \
	fi

# Target for setting up the virtual environment
env: install_python
	@echo "Creating virtual environment in $(VENV_DIR)..."
	@if [ ! -d "$(VENV_DIR)" ]; then \
		$(PYTHON_VERSION) -m venv $(VENV_DIR); \
		echo "Virtual environment created in $(VENV_DIR)."; \
	else \
		echo "Virtual environment already exists in $(VENV_DIR)."; \
	fi

# Target to install Python packages and system packages (iverilog and gtkwave)
install: 
	@echo "Installing Python packages..."
	@pip install --upgrade pip && \
	pip install pillow streamlit google-generativeai
	@echo "Installing system packages (iverilog and gtkwave)..."
	@sudo sed -i '/dl.bintray.com\/sbt/d' /etc/apt/sources.list /etc/apt/sources.list.d/*.list || true
	@sudo apt update -y && sudo apt install -y iverilog gtkwave
	@echo "Installation complete."
