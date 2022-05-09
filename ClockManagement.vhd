----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/03/25 22:11:48
-- Design Name: 
-- Module Name: ClockManagement - Behavioral
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
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE work.mypackPCMMP.all;
ENTITY ClockManagement IS PORT (
        resetn:IN std_logic;
        CLK: IN std_logic;
        CLK_CTRL:OUT std_logic;
        SystemCount: OUT CounterType);
END ClockManagement;

architecture behavioral OF ClockManagement IS
    begin 
        process (clk,resetn)
            variable count: CounterType;
            begin
            if resetn='0'then
            count:=(others=>'0');
            SystemCount<=(others=>'0');
            CLK_CTRL<='0';
            else
            if rising_edge(clk) then
            if count<CounterUpLimit then
                count:=count+1;
            else
                count:=(others=>'0');
            end if;
            CLK_CTRL<=count(0);
            SystemCount<=count;
            end if;
            end if;
    END PROCESS;
END behavioral;

