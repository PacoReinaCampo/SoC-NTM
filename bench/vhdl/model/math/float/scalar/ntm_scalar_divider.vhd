--------------------------------------------------------------------------------
--                                            __ _      _     _               --
--                                           / _(_)    | |   | |              --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
--                  | |                                                       --
--                  |_|                                                       --
--                                                                            --
--                                                                            --
--              Peripheral-NTM for MPSoC                                      --
--              Neural Turing Machine for MPSoC                               --
--                                                                            --
--------------------------------------------------------------------------------

-- Copyright (c) 2020-2021 by the author(s)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--------------------------------------------------------------------------------
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ntm_math_pkg.all;

entity ntm_scalar_divider is
  generic (
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    -- DATA
    MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_scalar_divider_architecture of ntm_scalar_divider is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type divider_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    ADAPTATION_STATE,                   -- STEP 1
    NORMALIZATION_STATE,                -- STEP 2
    ENDER_STATE                         -- STEP 3
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant EXPONENT_SIZE : integer := 15;
  constant MANTISSA_SIZE : integer := 112;

  constant ZERO_EXPONENT  : std_logic_vector(EXPONENT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, EXPONENT_SIZE));
  constant ONE_EXPONENT   : std_logic_vector(EXPONENT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, EXPONENT_SIZE));
  constant TWO_EXPONENT   : std_logic_vector(EXPONENT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, EXPONENT_SIZE));
  constant THREE_EXPONENT : std_logic_vector(EXPONENT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, EXPONENT_SIZE));

  constant ZERO_MANTISSA  : std_logic_vector(MANTISSA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, MANTISSA_SIZE));
  constant ONE_MANTISSA   : std_logic_vector(MANTISSA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, MANTISSA_SIZE));
  constant TWO_MANTISSA   : std_logic_vector(MANTISSA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, MANTISSA_SIZE));
  constant THREE_MANTISSA : std_logic_vector(MANTISSA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, MANTISSA_SIZE));

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant FULL_EXPONENT  : std_logic_vector(EXPONENT_SIZE-1 downto 0) := (others => '1');
  constant EMPTY_EXPONENT : std_logic_vector(EXPONENT_SIZE-1 downto 0) := (others => '0');

  constant FULL_MANTISSA  : std_logic_vector(MANTISSA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY_MANTISSA : std_logic_vector(MANTISSA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant BIAS : std_logic_vector(EXPONENT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2**(EXPONENT_SIZE-1)-1, EXPONENT_SIZE));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal divider_ctrl_fsm_int : divider_ctrl_fsm;

  -- Data Internal
  signal sign_int_scalar_divider : std_logic;

  signal exponent_int_scalar_divider : std_logic_vector(EXPONENT_SIZE downto 0);
  signal mantissa_int_scalar_divider : std_logic_vector(MANTISSA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN / DATA_B_IN = M_A_IN · M_B_IN · 2^(E_A_IN - E_B_IN)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Data Internal
      sign_int_scalar_divider <= '0';

      exponent_int_scalar_divider <= (others => '0');
      mantissa_int_scalar_divider <= (others => '0');

    elsif (rising_edge(CLK)) then

      case divider_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Data Internal
            sign_int_scalar_divider <= DATA_A_IN(DATA_SIZE-1) xor DATA_B_IN(DATA_SIZE-1);

            exponent_int_scalar_divider <= std_logic_vector(('0' & unsigned(DATA_A_IN(DATA_SIZE-2 downto MANTISSA_SIZE))) - ('0' & unsigned(DATA_B_IN(DATA_SIZE-2 downto MANTISSA_SIZE))));
            mantissa_int_scalar_divider <= std_logic_vector(unsigned(DATA_A_IN) / unsigned(DATA_B_IN));

            -- FSM Control
            divider_ctrl_fsm_int <= ADAPTATION_STATE;
          end if;

        when ADAPTATION_STATE =>  -- STEP 1

          if (exponent_int_scalar_divider(EXPONENT_SIZE) = '1') then
            -- Data Outputs
            exponent_int_scalar_divider <= std_logic_vector(unsigned(exponent_int_scalar_divider) - unsigned(ONE_EXPONENT));
            mantissa_int_scalar_divider <= std_logic_vector(unsigned(mantissa_int_scalar_divider) sll 1);
          end if;

        when NORMALIZATION_STATE =>  -- STEP 2

        when ENDER_STATE =>  -- STEP 3

          -- Control Outputs
          READY <= '1';

          -- Data Outputs
          DATA_OUT <= sign_int_scalar_divider & exponent_int_scalar_divider(EXPONENT_SIZE-1 downto 0) & mantissa_int_scalar_divider;

        when others =>
          -- FSM Control
          divider_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
