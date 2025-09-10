# QBasic Network Visualizer Makefile
# Requires DOSBox and QBASIC.EXE in project root

.PHONY: run convert example clean help

# Default target
help:
	@echo "QBasic Network Visualizer"
	@echo "========================"
	@echo ""
	@echo "Available commands:"
	@echo "  make run           - Launch QBasic with network visualizer"
	@echo "  make convert FILE=network.gml - Convert GML file to CSV"
	@echo "  make example       - Convert and visualize football network (you need to download the GML file from https://websites.umich.edu/~mejn/netdata/ and store it in this folder)"
	@echo "  make clean         - Remove generated CSV files"
	@echo "  make help          - Show this help message"
	@echo ""
	@echo "Requirements:"
	@echo "  - DOSBox installed and in PATH"
	@echo "  - QBASIC.EXE in project root directory"
	@echo "  - Python with igraph library"

# Launch QBasic with the network visualizer
run:
	@echo "Launching QBasic Network Visualizer..."
	@if [ ! -f "QBASIC.EXE" ]; then \
		echo "ERROR: QBASIC.EXE not found in project root"; \
		echo "Please obtain QBasic 1.1 and place QBASIC.EXE here"; \
		exit 1; \
	fi
	@if ! command -v dosbox >/dev/null 2>&1; then \
		echo "ERROR: DOSBox not found in PATH"; \
		echo "Please install DOSBox"; \
		exit 1; \
	fi
	dosbox -c "mount c ." -c "c:" -c "QBASIC /RUN QBNETDRW.BAS" -c "exit"

# Convert GML file to CSV format
convert:
	@if [ -z "$(FILE)" ]; then \
		echo "ERROR: Please specify FILE parameter"; \
		echo "Usage: make convert FILE=network.gml"; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE)" ]; then \
		echo "ERROR: File $(FILE) not found"; \
		exit 1; \
	fi
	@echo "Converting $(FILE) to CSV format..."
	@mkdir -p output
	python gml2csv.py "$(FILE)" "output/network.csv"
	@echo "CSV file created: output/network.csv"

# Convert and visualize football example
example:
	@echo "Running football network example..."
	@mkdir -p output
	@if [ ! -f "football.gml" ]; then \
		echo "ERROR: football.gml not found"; \
		echo "Please provide example GML files in examples/ directory"; \
		exit 1; \
	fi
	python gml2csv.py football.gml CSV/FOOTBALL.CSV
	@echo "Football network converted to output/FOOTBALL.CSV"
	@echo "Note: Update QBNETDRW.BAS to open 'output/FOOTBALL.CSV' then run 'make run'"

# Clean generated files
clean:
	@echo "Cleaning generated CSV files..."
	@rm -rf CSV/*.csv
	@echo "Clean complete"

# Check dependencies
check:
	@echo "Checking dependencies..."
	@if command -v python >/dev/null 2>&1; then \
		echo "✓ Python found"; \
	else \
		echo "✗ Python not found"; \
	fi
	@if command -v dosbox >/dev/null 2>&1; then \
		echo "✓ DOSBox found"; \
	else \
		echo "✗ DOSBox not found"; \
	fi
	@if [ -f "QBASIC.EXE" ]; then \
		echo "✓ QBASIC.EXE found"; \
	else \
		echo "✗ QBASIC.EXE not found in project root"; \
	fi
	@python -c "import igraph" 2>/dev/null && echo "✓ igraph library found" || echo "✗ igraph library not found (pip install python-igraph)"