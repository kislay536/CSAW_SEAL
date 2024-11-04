# Variables
PYTHON_VERSION := python3.9
VENV_DIR := .venv
REQUIREMENTS := requirements.txt

# Targets
.PHONY: install env start

# Target for installing Python 3.9 (OS-dependent, assuming Debian/Ubuntu-based system)
install_python:
	@echo "Checking for Python 3.9 installation..."
	@if ! command -v $(PYTHON_VERSION) &>/dev/null; then \
		echo "Python 3.9 not found. Installing..."; \
		sudo apt update && sudo apt install -y $(PYTHON_VERSION); \
	else \
		echo "Python 3.9 is already installed."; \
	fi

# Target for setting up the virtual environment
env: install_python
	@echo "Creating virtual environment in $(VENV_DIR)..."
	@$(PYTHON_VERSION) -m venv $(VENV_DIR)
	@echo "Virtual environment created in $(VENV_DIR)."

# Target to install Python packages and system packages (iverilog and gtkwave)
install: env
	@echo "Activating virtual environment and installing packages..."
	@source $(VENV_DIR)/bin/activate && pip install --upgrade pip && \
	pip install pillow streamlit google-generativeai
	@echo "Installing system packages (iverilog and gtkwave)..."
	@sudo apt update && sudo apt install -y iverilog gtkwave
	@echo "Installation complete."

# Target for activating the virtual environment
start:
	@echo "Activating virtual environment..."
	@source $(VENV_DIR)/bin/activate && echo "Virtual environment activated."
