TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)

SIM ?= verilator

EXTRA_ARGS += --trace --trace-structs
WARNING_ARGS += -Wno-TIMESCALEMOD -Wno-WIDTH -Wno-UNOPT

export PYTHONPATH := $(PWD)/../01_bench:$(PYTHONPATH)

ifeq ($(TOPLEVEL_LANG),verilog)
    VERILOG_SOURCES_ALU = $(PWD)/../00_src/alu.sv
    VERILOG_SOURCES_BRC = $(PWD)/../00_src/brc.sv
else ifeq ($(TOPLEVEL_LANG),vhdl)
    VHDL_SOURCES_ALU = $(PWD)/../00_src/alu.vhdl
    VHDL_SOURCES_BRC = $(PWD)/../00_src/brc.vhdl
else
    $(error A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

.PHONY: run run_alu run_brc clean clean_all

run: run_alu run_brc


run_alu:
	@echo "Running ALU testbench..."
	$(MAKE) SIM=$(SIM) TOPLEVEL=alu MODULE=alu_tbench VERILOG_SOURCES=$(VERILOG_SOURCES_ALU)

run_brc:
	@echo "Running BRC testbench..."
	$(MAKE) SIM=$(SIM) TOPLEVEL=brc MODULE=brc_tbench VERILOG_SOURCES=$(VERILOG_SOURCES_BRC)

clean_all: clean
	rm -rf results.xml alu_test_report.html brc_test_report.html
