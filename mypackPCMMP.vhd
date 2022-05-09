----------------------------------------------------------------------------------
-- Company:  queensu
-- Engineer: xiang zhang
-- 
-- Create Date: 2022/03/25 21:29:44
-- Design Name: 
-- Module Name: MPPCMControl - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package mypackPCMMP is
Constant CounterWidth: integer:=7;
Constant CounterUpLimit: integer:=127;                      --equal to (2^CounterWidth)-1
Constant VolCounterWidth: integer:=7;
Constant DACWidth: integer:=14;
Subtype CounterType is std_logic_vector(CounterWidth-1 downto 0);
Subtype VolCounterType is std_logic_vector(VolCounterWidth downto 0);
Subtype CurCounterType is std_logic_vector(VolCounterWidth downto 0);
Subtype DACType is std_logic_vector(DACWidth-1 downto 0);
Constant IntialTurnOnGT1: CounterType:=B"0000000";
Constant IntialTurnOnGT2: CounterType:=B"1000000";
Constant IntialTurnOffGT1: CounterType:=B"0001100";
Constant IntialTurnOffGT2: CounterType:=B"1001100";
Constant InitialVolMid: VolCounterType:=B"11010000";        --B"10110000";--
Constant MaxVolMid: VolCounterType:=B"11010000";            --B"10110000";--
Constant MinVolMid: VolCounterType:=B"01000100";            --B"00010100";--
Constant MaxPeakCur: CurCounterType:=B"11000000";           --B"11000000";--
Constant MinPeakCur: CurCounterType:=B"00110100";           --B"00100100";--
Constant InitialPeakCur: CurCounterType:=B"00110100";       --B"00100100";--
Constant AdjustStepSteady: CurCounterType:=B"00000001";
Constant AdjustStepTransUp: CurCounterType:=B"00000110";
Constant AdjustStepUpLink: CurCounterType:=B"00000010";
Constant AdjustStepTransDown: CurCounterType:=B"00000001";
Constant AdjustStepDownLink: CurCounterType:=B"00000110";
Constant LMT_TU: CurCounterType:=B"00011000";
Constant LMT_TD: CurCounterType:=B"00001010";
Constant LMT_TL: CurCounterType:=B"00011001";
end;
package body mypackPCMMP is
end mypackPCMMP;