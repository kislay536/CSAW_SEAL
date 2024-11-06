SYSTEM_INST_DIR_SRC = ./sys_inst_src
SYSTEM_INST_DIR_VER = ./sys_inst_ver
SYSTEM_INST_DIR_MOD = ./sys_inst_mod
VERILOG_FILES = ./
SYSTEM_INST_FILES_SRC = $(wildcard $(SYSTEM_INST_DIR_SRC)/*.txt)
SYSTEM_INST_FILES_VER = $(wildcard $(SYSTEM_INST_DIR_VER)/*.txt)
SYSTEM_INST_FILES_MOD = $(wildcard $(SYSTEM_INST_DIR_MOD)/*.txt)

# Define the directories to clean
CLEAN_DIRS := error_state mod ver

.PHONY: run clean

run:
	# Initial run and verification for SRC and VER files
	@for file in $(SYSTEM_INST_FILES_SRC); do \
		echo "Starting tool with $$file"; \
		SYS_INST_FILE=$$file python3 tool.py & \
	done; \
	wait
	@for file in $(SYSTEM_INST_FILES_VER); do \
		echo "Starting verification with $$file"; \
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
				echo "Starting verification with $$file"; \
				SYS_INST_FILE=$$file python3 verification.py & \
			done; \
			wait; \
		else \
			echo "Starting resolving errors with $$file"; \
			SYS_INST_FILE=$$file python3 mod.py & \
		fi; \
	done; \
	wait

clean:
	rm -rf $(addsuffix /*, $(CLEAN_DIRS))
	echo "All files in error_state, mod, and ver directories have been deleted."
