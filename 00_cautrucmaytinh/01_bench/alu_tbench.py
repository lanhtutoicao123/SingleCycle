import cocotb
from cocotb.triggers import Timer
import random


class AluTransaction:
    def __init__(self):
        self.i_operand_a = random.randint(0, 2**32 - 1)
        self.i_operand_b = random.randint(0, 2**32 - 1)
        self.i_alu_op = random.randint(0, 15)  # opcode [0, 15]
        self.expected_output = self.calculate_expected_output()
        

    def calculate_expected_output(self):
        a, b = self.i_operand_a, self.i_operand_b
        if self.i_alu_op == 0:  # OP_ADD
            return (a + b) & 0xFFFFFFFF
        elif self.i_alu_op == 1:  # OP_SUB
            return (a - b) & 0xFFFFFFFF
        elif self.i_alu_op == 2:  
            signed_a = a if a < 0x80000000 else a - 0x100000000
            signed_b = b if b < 0x80000000 else b - 0x100000000
            return 1 if signed_a < signed_b else 0
        elif self.i_alu_op == 3:  # OP_SLTU (unsigned comparison)
            return 1 if a < b else 0
        elif self.i_alu_op == 4:  # OP_XOR
            return a ^ b
        elif self.i_alu_op == 5:  # OP_OR
            return a | b
        elif self.i_alu_op == 6:  # OP_AND
            return a & b
        elif self.i_alu_op == 7:  # OP_SLL (shift left logical)
            return (a << (b & 0x1F)) & 0xFFFFFFFF
        elif self.i_alu_op == 8:  # OP_SRL (shift right logical)
            return (a >> (b & 0x1F)) & 0xFFFFFFFF
        elif self.i_alu_op == 9:  # OP_SRA (shift right arithmetic)
            shift_amount = b & 0x1F  
            if a & 0x80000000:  
                result = (a >> shift_amount) | (0xFFFFFFFF << (32 - shift_amount))
            else:
                result = a >> shift_amount
    
            return result & 0xFFFFFFFF

        elif self.i_alu_op == 10:  # OP_OUTPUT_B
            return b
        return 0

class AluDriver:
    def __init__(self, dut):
        self.dut = dut

    async def send(self, transaction):
        # Assign input values to DUT
        self.dut.i_operand_a.value = transaction.i_operand_a
        self.dut.i_operand_b.value = transaction.i_operand_b
        self.dut.i_alu_op.value = transaction.i_alu_op
        await Timer(10, units="ns")  # Wait for output to stabilize
        transaction.actual_output = int(self.dut.o_alu_data.value)

class AluScoreboard:
    def __init__(self):
        self.passed = True
        self.results = []  

    def check(self, transaction):
        """So sánh đầu ra với giá trị mong đợi và in kết quả"""
        result = {
            "inA": f"{transaction.i_operand_a:08x}",
            "inB": f"{transaction.i_operand_b:08x}",
            "sel": f"{transaction.i_alu_op:x}",
            "output": f"{transaction.actual_output:08x}",
            "expected_output": f"{transaction.expected_output:08x}",
            "status": "PASS" if transaction.actual_output == transaction.expected_output else "FAIL"
        }
        
        self.results.append(result)

        if result["status"] == "FAIL":
            self.passed = False
        
        if result["status"] == "FAIL":
            print(f"{result['inA']} {result['inB']} {result['sel']} {result['output']} {result['expected_output']}")
        else:
            print(f"{result['inA']} {result['inB']} {result['sel']} {result['output']} {result['expected_output']}")

    def generate_html_report(self):
        """Tạo báo cáo HTML từ kết quả kiểm tra"""
        html_content = """
        <html>
        <head>
            <style>
                table { width: 100%; border-collapse: collapse; }
                th, td { border: 1px solid black; padding: 8px; text-align: center; }
                th { background-color: #f2f2f2; }
                .pass { background-color: #d4edda; }
                .fail { background-color: #f8d7da; }
            </style>
        </head>
        <body>
            <h2>ALU Test Report</h2>
            <table>
                <tr>
                    <th>inA</th>
                    <th>inB</th>
                    <th>sel</th>
                    <th>output</th>
                    <th>expected output</th>
                    <th>status</th>
                </tr>
        """
        
        for result in self.results:
            result_class = "pass" if result["status"] == "PASS" else "fail"
            html_content += f"""
                <tr class="{result_class}">
                    <td>{result["inA"]}</td>
                    <td>{result["inB"]}</td>
                    <td>{result["sel"]}</td>
                    <td>{result["output"]}</td>
                    <td>{result["expected_output"]}</td>
                    <td>{result["status"]}</td>
                </tr>
            """
        
        html_content += """
            </table>
        </body>
        </html>
        """
        
        # Lưu nội dung HTML vào file
        with open("alu_test_report.html", "w") as file:
            file.write(html_content)
        print("Test report has been saved as alu_test_report.html.")

    def final_check(self):
        """Kiểm tra tổng thể và tạo báo cáo HTML"""
        if self.passed:
            print("\nAll tests passed!")
        else:
            print("\nSome tests failed.")
        self.generate_html_report()

@cocotb.test()
async def run_test(dut):
    driver = AluDriver(dut)
    scoreboard = AluScoreboard()

    num_transactions = 100

    for _ in range(num_transactions):
        transaction = AluTransaction()
        await driver.send(transaction)
        scoreboard.check(transaction)

    scoreboard.final_check()
    assert scoreboard.passed, "Some transactions failed"
    dut._log.info("All transactions passed")
