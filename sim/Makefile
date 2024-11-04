# Define the names of the Verilog files and output files
DESIGN_FILE = design.v
TESTBENCH_FILE = testbench.v
SIM_OUTPUT = simulation.vvp
WAVEFORM_FILE = test.vcd

# The default target that will be executed when running 'make'
all: simulate view

# Compile the Verilog code
compile:
	iverilog -o $(SIM_OUTPUT) $(DESIGN_FILE) $(TESTBENCH_FILE)

# Run the simulation
simulate: compile
	vvp $(SIM_OUTPUT)

# Open the waveform in GTKWave
view: $(WAVEFORM_FILE)
	gtkwave $(WAVEFORM_FILE)

# Clean up generated files
clean:
	rm -f $(SIM_OUTPUT) $(WAVEFORM_FILE)
