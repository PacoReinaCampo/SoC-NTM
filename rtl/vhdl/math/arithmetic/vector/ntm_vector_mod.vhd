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

use work.ntm_pkg.all;

entity ntm_vector_mod is
  generic (
    X : integer := 64,

    DATA_SIZE : integer := 512
  );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic_vector(X-1 downto 0);

    -- DATA
    MODULO   : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
    DATA_IN  : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
    DATA_OUT : out std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_vector_mod_architecture of ntm_vector_mod is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type mod_ctrl_fsm_type is (
    STARTER_ST,  -- STEP 0
    ENDER_ST     -- STEP 1
  );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal mod_ctrl_fsm_st : mod_ctrl_fsm_type;

  -- Internal Signals
  signal arithmetic_int : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  for i in X-1 downto 0 generate

    ctrl_fsm : process(CLK, RST)
    begin
      if (RST = '0') then
        -- Data Outputs
        DATA_OUT(i) <= ZERO;

        -- Control Outputs
        READY(i) <= '0';

        -- Assignations
        arithmetic_int <= ZERO;

      elsif (rising_edge(CLK)) then

        case mod_ctrl_fsm_st is
          when STARTER_ST =>            -- STEP 0
            -- Control Outputs
            READY(i) <= '0';

            if (START = '1') then
              -- Assignations
              arithmetic_int <= DATA_IN(i);

              -- FSM Control
              mod_ctrl_fsm_st <= ENDER_ST;
            end if;

          when ENDER_ST =>              -- STEP 1

            if (unsigned(MODULO(i)) > unsigned(ZERO)) then
              if (unsigned(arithmetic_int) > unsigned(ZERO)) then
                if (unsigned(arithmetic_int) = unsigned(MODULO(i))) then
                  -- Data Outputs
                  DATA_OUT(i) <= ZERO;

                  -- Control Outputs
                  READY(i) <= '1';

                  -- FSM Control
                  mod_ctrl_fsm_st <= STARTER_ST;
                elsif (unsigned(arithmetic_int) < unsigned(MODULO(i))) then
                  -- Data Outputs
                  DATA_OUT(i) <= arithmetic_int;

                  -- Control Outputs
                  READY(i) <= '1';

                  -- FSM Control
                  mod_ctrl_fsm_st <= STARTER_ST;
                else
                  -- Assignations
                  arithmetic_int <= std_logic_vector(unsigned(arithmetic_int) - unsigned(MODULO(i)));
                end if;
              elsif (unsigned(arithmetic_int) = unsigned(ZERO)) then
                -- Data Outputs
                DATA_OUT(i) <= ZERO;

                -- Control Outputs
                READY(i) <= '1';

                -- FSM Control
                mod_ctrl_fsm_st <= STARTER_ST;
              end if;
            elsif (unsigned(MODULO(i)) = unsigned(ZERO)) then
              -- Data Outputs
              DATA_OUT(i) <= arithmetic_int;

              -- Control Outputs
              READY(i) <= '1';

              -- FSM Control
              mod_ctrl_fsm_st <= STARTER_ST;
            end if;

          when others =>
            -- FSM Control
            mod_ctrl_fsm_st <= STARTER_ST;
        end case;
      end if;
    end process;

  end generate;

end architecture;