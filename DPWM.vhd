----------------------------------------------------------------------------------
-- Company:  queensu
-- Engineer: xiang zhang
-- 
-- Create Date: 2022/03/25 22:14:38
-- Design Name: 
-- Module Name: DPWM - Behavioral
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



Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
USE work.mypackPCMMP.all;
ENTITY DPWM IS PORT (
resetn: IN std_logic;
CLK: IN std_logic;
SystemCount: IN CounterType;
CompI1: IN std_logic;
CompI2: IN std_logic;
CompI3: IN std_logic;
CompI4: IN std_logic;
IsTransientUp: IN std_logic;
IsTransientDown: IN std_logic;
SoftStart: IN std_logic;
StartRelease: IN std_logic;
SWCLK: OUT std_logic;
PWM1: OUT std_logic:='0';
PWM2: OUT std_logic:='0';
PWM3: OUT std_logic:='0';
PWM4: OUT std_logic:='0';
EN: OUT std_logic
);
END DPWM;
ARCHITECTURE behavioral OF DPWM IS
Signal SGNPWM3,SGNPWM4: std_logic;
BEGIN
	Process (clk,resetn,CompI3,CompI4,IsTransientUp,IsTransientDown)
		Variable VarPWM1,VarPWM2,VarLT: std_logic;
		Variable VarAction1,VarAction2: std_logic;
	begin
		if resetn='0' then
			VarPWM1:='0';
			VarPWM2:='0';
			EN<='0';
			PWM1<='0';
			PWM2<='0';
			PWM3<='0';
			PWM4<='0';
			SWCLK<='0';
			SGNPWM3<='0';
			SGNPWM4<='0';
		else
			if rising_edge(clk) then
				VarAction1:='0';
				VarAction2:='0';
				if IntialTurnOnGT1=systemCount then
					VarPWM1:='1';
					VarAction1:='1';
				end if;
				if IntialTurnOnGT2=systemCount then
					VarPWM2:='1';
					VarAction2:='1';
				end if;
				if softstart='1' then
					if IntialTurnOffGT1=systemCount then
						VarPWM1:='0';
						VarAction1:='1';
					end if;
					if IntialTurnOffGT2=systemCount then
						VarPWM2:='0';
						VarAction2:='1';
					end if;
				end if;
			end if;
		
			if VarAction1='1' then
				PWM3<= VarPWM1;
				SWCLK<= not VarPWM1;--'0'
				SGNPWM3<= VarPWM1;
			end if;
		
			if VarAction2='1' then
				PWM4<=VarPWM2;
				SGNPWM4<=VarPWM2;
			end if;
		
			If IsTransientUp='1' then
			PWM3<='1';
			PWM4<='1';
			else
				if CompI3='1' then
					PWM3<='0';
					SGNPWM3<='0';
					SWCLK<='1';
				end if;
				if CompI4='1'then
					PWM4<='0';
					SGNPWM4<='0';
				end if;
			end if;
			
			if Istransientdown='1' then
				PWM3<='0';
				PWM4<='0';
				SGNPWM3<='0';
				SGNPWM4<='0';
			end if;
			PWM1<=IsTransientUp;
			PWM2<=IsTransientDown;
		end if;
	end process;
 END behavioral;