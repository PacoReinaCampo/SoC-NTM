import random

from ntm_scalar_adder import ntm_scalar_adder

import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def adder_basic_test(dut):
  """Test for 5 + 10"""

  A = 5
  B = 10

  dut.A.value = A
  dut.B.value = B

  await Timer(2, units="ns")

  assert dut.X.value == ntm_scalar_adder(A, B), f"Adder result is incorrect: {dut.X.value} != 15"

@cocotb.test()
async def adder_randomised_test(dut):
  """Test for adding 2 random numbers multiple times"""

  for i in range(10):

    A = random.randint(0, 15)
    B = random.randint(0, 15)

    dut.A.value = A
    dut.B.value = B

    await Timer(2, units="ns")

    assert dut.X.value == ntm_scalar_adder(A, B), "Randomised test failed with: {A} + {B} = {X}".format(A=dut.A.value, B=dut.B.value, X=dut.X.value)
