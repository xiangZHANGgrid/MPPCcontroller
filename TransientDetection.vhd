----------------------------------------------------------------------------------
-- Company:  queensu
-- Engineer: xiang zhang
-- 
-- Create Date: 2022/03/25 22:15:51
-- Design Name: 
-- Module Name: TransientDetection - Behavioral
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
ENTITY TransientDetection IS PORT (
    resetn:IN std_logic;
    clk:IN std_logic;
    CompVqu : IN std_logic;
    CompVqd: IN std_logic;
    IsLinkMode: IN std_logic;
    SoftStart: IN std_logic;
    IsTransientUp: Out std_logic;
    IsTransientDown: Out std_logic;
    IsLinkUp:Out std_logic;
    IsLinkDown:Out std_logic);
END TransientDetection;

ARCHITECTURE behavioral OF TransientDetection IS
BEGIN
    PROCESS(clk,resetn,IsLinkMode,CompVqu,CompVqd)
    Variable VarIstransientUp,VarIstransientDown:std_logic;
    Variable LastTransientDown,LastTransientUp,VarLinkUp,VarLinkDown:Std_logic;
    BEGIN
        if resetn='0'then
            IsTransientUp<='0';
            IsTransientDown<='0';
            IsLinkUp<='0';
            IsLinkDown<='0';
            VarLinkUp:='0';
            VarLinkDown:='0';
            VarIstransientUp:='0';
            VarIstransientDown:='0';
        else
			if rising_edge(clk) then
				if SoftStart='1' then
				VarIstransientDown:='0';
				VarIsTransientup:='0';
				else
					if CompVqu='1' then
						VarIstransientDown:='1';
					else
						LastTransientDown:=VarIsTransientDown;
						VarIsTransientDown:='0';
						if IsLinkMode='1' then
							VarLinkDown:='0';
						end if;
						if LastTransientDown='1' then
						VarLinkDown:='1';
						end if;
					end if;
									
					if CompVqd='1' then
						VarIsTransientup:='1';
					else
						LastTransientUp:=VarIsTransientUp;
						VarIsTransientUp:='0';
						if IsLinkMode='1' then
							VarLinkUp:='0';
						end if;
						if LastTransientUp='1' then
							VarLinkUp:='1';
						end if;
				end if;
			end if;

			IsTransientUp<=VarIsTransientup;
			IsTransientDown<=VarIsTransientdown;
			IsLinkUp<=VarLinkup;
			IsLinkDown<=VarLinkdown;
			end if;
		end if;
	END PROCESS;
END behavioral;