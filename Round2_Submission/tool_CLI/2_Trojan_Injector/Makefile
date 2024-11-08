# Define directories and files
SYSTEM_INST_DIR_SRC1 = ./sys_inst_src1
SYSTEM_INST_DIR_VER1 = ./sys_inst_ver1
SYSTEM_INST_DIR_MOD1 = ./sys_inst_mod1
SYSTEM_INST_FILES_SRC1 = $(wildcard $(SYSTEM_INST_DIR_SRC1)/*.txt)
SYSTEM_INST_FILES_VER1 = $(wildcard $(SYSTEM_INST_DIR_VER1)/*.txt)
SYSTEM_INST_FILES_MOD1 = $(wildcard $(SYSTEM_INST_DIR_MOD1)/*.txt)

SYSTEM_INST_DIR_SRC = ./sys_inst_src
SYSTEM_INST_DIR_VER = ./sys_inst_ver
SYSTEM_INST_DIR_MOD = ./sys_inst_mod
VERILOG_FILES = ./
SYSTEM_INST_FILES_SRC = $(wildcard $(SYSTEM_INST_DIR_SRC)/*.txt)
SYSTEM_INST_FILES_VER = $(wildcard $(SYSTEM_INST_DIR_VER)/*.txt)
SYSTEM_INST_FILES_MOD = $(wildcard $(SYSTEM_INST_DIR_MOD)/*.txt)

export OPENAI_API_KEY="sk-QYIGtHskY4Hl0BehntZGvoehcl3GBhpXvfYJKoPyTJT3BlbkFJR-DvyV7eDCCs4Vc-F8O4TNZ3Cg0av_IBlvdIGguKYA"

# Define the directories to clean
CLEAN_DIRS := error_state mod ver

.PHONY: gemini clean install gpt

gemini:
	# Initial run and verification for SRC and VER files
	@for file in $(SYSTEM_INST_FILES_SRC); do \
		echo "Starting tool with $$file"; \
		SYS_INST_FILE=$$file python3 tool.py & \
	done; \
	wait
	@for file in $(SYSTEM_INST_FILES_VER); do \
		echo "Finding errors with $$file"; \
		SYS_INST_FILE=$$file python3 verification.py & \
	done; \
	wait
	
	# Check each MOD file and decide next steps based on its content
	@for file in $(SYSTEM_INST_FILES_MOD); do \
		content=$$(cat $$file); \
		if [ "$$content" = "0" ]; then \
			echo "Repeating run for SRC and VER files because $$file has some errors"; \
			for file in $(SYSTEM_INST_FILES_SRC); do \
				echo "Starting tool with $$file"; \
				SYS_INST_FILE=$$file python3 tool.py & \
			done; \
			wait; \
			for file in $(SYSTEM_INST_FILES_VER); do \
				echo "Finding errors with $$file"; \
				SYS_INST_FILE=$$file python3 verification.py & \
			done; \
			wait; \
		else \
			echo "Finding and resolving errors with $$file"; \
			SYS_INST_FILE=$$file python3 mod.py & \
		fi; \
	done; \
	wait
gpt:
	@# Initial run and verification for SRC and VER files
	@for file in $(SYSTEM_INST_FILES_SRC1); do \
		echo "Starting tool with $$file"; \
		SYS_INST_FILE=$$file OPENAI_API_KEY=$(OPENAI_API_KEY) python3 tool1.py & \
	done; \
	wait
	@for file in $(SYSTEM_INST_FILES_VER1); do \
		echo "Finding errors with $$file"; \
		SYS_INST_FILE=$$file OPENAI_API_KEY=$(OPENAI_API_KEY) python3 verification1.py & \
	done; \
	wait
	
	# Check each MOD file and decide next steps based on its content
	@for file in $(SYSTEM_INST_FILES_MOD1); do \
		content=$$(cat $$file); \
		if [ "$$content" = "0" ]; then \
			echo "Repeating run for SRC and VER files because $$file has some errors"; \
			for file in $(SYSTEM_INST_FILES_SRC1); do \
				echo "Starting tool with $$file"; \
				SYS_INST_FILE=$$file OPENAI_API_KEY=$(OPENAI_API_KEY) python3 tool1.py & \
			done; \
			wait; \
			for file in $(SYSTEM_INST_FILES_VER1); do \
				echo "Finding errors with $$file"; \
				SYS_INST_FILE=$$file OPENAI_API_KEY=$(OPENAI_API_KEY) python3 verification1.py & \
			done; \
			wait; \
		else \
			echo "Finding and resolving errors with $$file"; \
			SYS_INST_FILE=$$file OPENAI_API_KEY=$(OPENAI_API_KEY) python3 mod1.py & \
		fi; \
	done; \
	wait

clean:
	rm -rf $(addsuffix /*, $(CLEAN_DIRS))
	echo "All files in error_state, mod, and ver directories have been deleted."

# Install dependencies
install:
	@pip install openai==0.28