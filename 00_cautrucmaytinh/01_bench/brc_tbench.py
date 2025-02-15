import cocotb
from cocotb.triggers import Timer
import random


class BrcTransaction:
    def __init__(self):
        self.rs1_data = random.randint(0, 2**32 - 1)
        self.rs2_data = random.randint(0, 2**32 - 1)
        self.br_unsigned = random.choice([0, 1])
        self.expected_less, self.expected_equal = self.calculate_expected_outputs()
        
    def calculate_expected_outputs(self):
        rs1, rs2 = self.rs1_data, self.rs2_data
        if self.br_unsigned:
            less_than = 1 if rs1 < rs2 else 0
        else:
            signed_rs1 = rs1 if rs1 < 0x80000000 else rs1 - 0x100000000
            signed_rs2 = rs2 if rs2 < 0x80000000 else rs2 - 0x100000000
            less_than = 1 if signed_rs1 < signed_rs2 else 0
        equal = 1 if rs1 == rs2 else 0
        return less_than, equal

class BrcDriver:
    def __init__(self, dut):
        self.dut = dut

    async def send(self, transaction):
        self.dut.rs1_data.value = transaction.rs1_data
        self.dut.rs2_data.value = transaction.rs2_data
        self.dut.br_unsigned.value = transaction.br_unsigned
        await Timer(10, units="ns")  # Đợi đầu ra ổn định
        transaction.actual_less = int(self.dut.br_less.value)
        transaction.actual_equal = int(self.dut.br_equal.value)

class BrcScoreboard:
    def __init__(self):
        self.passed = True
        self.results = [] 

    def check(self, transaction):
        """So sánh đầu ra với giá trị mong đợi và in kết quả"""
        result = {
            "rs1_data": f"{transaction.rs1_data:08x}",
            "rs2_data": f"{transaction.rs2_data:08x}",
            "unsigned": transaction.br_unsigned,
            "br_less": transaction.actual_less,
            "expected_less": transaction.expected_less,
            "br_equal": transaction.actual_equal,
            "expected_equal": transaction.expected_equal,
            "status": "PASS" if (transaction.actual_less == transaction.expected_less and transaction.actual_equal == transaction.expected_equal) else "FAIL"
        }
        
        self.results.append(result)

        if result["status"] == "FAIL":
            self.passed = False

        # In kết quả ra màn hình
        print(f"{result['rs1_data']} {result['rs2_data']} {'U' if result['unsigned'] else 'S'} "
              f"LESS: {result['br_less']} EXPECTED: {result['expected_less']} "
              f"EQUAL: {result['br_equal']} EXPECTED: {result['expected_equal']} - {result['status']}")

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
            <h2>BRC Test Report</h2>
            <table>
                <tr>
                    <th>rs1_data</th>
                    <th>rs2_data</th>
                    <th>unsigned</th>
                    <th>br_less</th>
                    <th>expected_less</th>
                    <th>br_equal</th>
                    <th>expected_equal</th>
                    <th>status</th>
                </tr>
        """
        
        for result in self.results:
            result_class = "pass" if result["status"] == "PASS" else "fail"
            html_content += f"""
                <tr class="{result_class}">
                    <td>{result["rs1_data"]}</td>
                    <td>{result["rs2_data"]}</td>
                    <td>{'Unsigned' if result["unsigned"] else 'Signed'}</td>
                    <td>{result["br_less"]}</td>
                    <td>{result["expected_less"]}</td>
                    <td>{result["br_equal"]}</td>
                    <td>{result["expected_equal"]}</td>
                    <td>{result["status"]}</td>
                </tr>
            """
        
        html_content += """
            </table>
        </body>
        </html>
        """
        
        with open("brc_test_report.html", "w") as file:
            file.write(html_content)
        print("Test report has been saved as brc_test_report.html.")

    def final_check(self):
        if self.passed:
            print("\nAll BRC tests passed!")
        else:
            print("\nSome BRC tests failed.")
        self.generate_html_report()

@cocotb.test()
async def run_test(dut):
    driver = BrcDriver(dut)
    scoreboard = BrcScoreboard()

    num_transactions = 100

    for _ in range(num_transactions):
        transaction = BrcTransaction()
        await driver.send(transaction)
        scoreboard.check(transaction)

    scoreboard.final_check()
    assert scoreboard.passed, "Some BRC transactions failed"
    dut._log.info("All BRC transactions passed")
