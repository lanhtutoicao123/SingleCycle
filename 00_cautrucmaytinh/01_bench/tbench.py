import cocotb
from alu_tbench import run_test as alu_test
from brc_tbench import run_test as brc_test
#from regfile_tbench import run_test as regfile_test

@cocotb.test()
async def main_testbench(dut):
    await alu_test(dut)

    await brc_test(dut)

    #await regfile_test(dut)