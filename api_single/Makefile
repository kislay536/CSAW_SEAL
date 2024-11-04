# Makefile to run Streamlit app with different system instruction files

SYSTEM_INST_DIR = ./sys_inst
VERILOG_FILES = ./biriscv/src/core
SYSTEM_INST_FILES = $(wildcard $(SYSTEM_INST_DIR)/*.txt)

run:
	@for file in $(SYSTEM_INST_FILES); do \
		echo "Starting Streamlit with $$file"; \
		SYS_INST_FILE=$$file streamlit run tool.py & \
	done
	