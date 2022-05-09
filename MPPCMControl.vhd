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

-------------------------------------------
--- The Structure of Digital Controller ---
-------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_logic_unsigned.all;
USE work.mypackPCMMP.all;

entity MPPCMControl is Port(
--  Port ( );
    CLK:IN  std_logic;
    WRT: IN std_logic;
    resetn: IN std_logic;
    CompV : IN  std_logic;
    CompVqu : IN  std_logic;
    CompVqd : IN  std_logic;
    CompVq : IN  std_logic;
    CompI1: IN  std_logic;
    CompI2: IN  std_logic;
    CompI3: IN  std_logic;
    CompI4: IN  std_logic;
    PWM1: OUT std_logic:='0';
    PWM2: OUT std_logic:='0';
    PWM3: OUT std_logic:='0';
    PWM4: OUT std_logic:='0';
    EN: OUT std_logic:='0';
    DACV: OUT DACType;
    DACI: OUT DACType;
    TestLed: OUT std_logic;
    DataCatched: OUT CurCounterType;
    OverFlowUpLed: OUT std_logic;
    OverFlowDownLed: OUT std_logic;
    TUCatched: OUT CurCounterType;
    TDCatched: OUT CurCounterType;
    StartReleaseLed: OUT std_logic);

end MPPCMControl;

architecture Behavioral of MPPCMControl is
    Component ClockManagement
        Port (  resetn: in std_logic;
                CLK:IN std_logic;
                CLK_CTRL:OUT std_logic;
                SystemCount: OUT CounterType);
    end Component;

    Component DPWM
        Port (  resetn: IN std_logic;
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
                PWM1: OUT std_logic;
                PWM2: OUT std_logic;
                PWM3: OUT std_logic;
                PWM4: OUT std_logic;
                EN: OUT std_logic);
    End Component;

    Component TransientDetection
        Port (  resetn:IN std_logic;
                clk: IN std_logic;
                CompVqu : IN std_logic;
                CompVqd: IN std_logic;
                IsLinkMode: IN std_logic;
                SoftStart: IN std_logic;
                IstransientUp: Out std_logic;
                IstransientDown: Out std_logic;
                IsLinkUp:Out std_logic;
                IsLinkDown:Out std_logic);
    End Component;

    Component ControlUnit
        PORT (  resetn: IN std_logic;
                WRT: IN std_logic;
                CLK_CTRL: IN std_logic;
                CompV: IN std_logic;
                CompVq : IN std_logic;
                SWCLK: IN std_logic;
                IsTransientUp: IN std_logic;
                IsTransientDown: IN std_logic;
                IsLinkUp: IN std_logic;
                IsLinkDown: IN std_logic;
                IsLinkMode: OUT std_logic;
                SoftStart: OUT std_logic;
                StartRelease: OUT std_logic;
                DACV13: OUT std_logic;
                DACV12: OUT std_logic;
                DACV11: OUT std_logic;
                DACV10: OUT std_logic;
                DACV9: OUT std_logic;
                DACV8: OUT std_logic;
                DACV7: OUT std_logic;
                DACV6: OUT std_logic;
                DACV5: OUT std_logic;
                DACV4: OUT std_logic;
                DACV3: OUT std_logic;
                DACV2: OUT std_logic;
                DACV1: OUT std_logic;
                DACV0: OUT std_logic;
                DACI13: OUT std_logic;
                DACI12: OUT std_logic;
                DACI11: OUT std_logic;
                DACI10: OUT std_logic;
                DACI9: OUT std_logic;
                DACI8: OUT std_logic;
                DACI7: OUT std_logic;
                DACI6: OUT std_logic;
                DACI5: OUT std_logic;
                DACI4: OUT std_logic;
                DACI3: OUT std_logic;
                DACI2: OUT std_logic;
                DACI1: OUT std_logic;
                DACI0: OUT std_logic;
                TestLed: OUT std_logic;
                DataCatched: OUT CurCounterType;
                OverFlowUpLed: OUT std_logic;
                OverFlowDownLed: OUT std_logic;
                TUCatched: OUT CurCounterType;
                TDCatched: OUT CurCounterType;
                StartReleaseLed: OUT std_logic);
    END Component;

    Signal SGNSystemCount: CounterType;
    Signal CLK_CTRL,SWCLK,SGNStartRelease: std_logic;
    Signal SoftStart,IsTransientUp,IsTransientDown: std_logic;
    signal SGNIsLinkUp: std_logic;
    signal SGNIsLinkDown: std_logic;
    signal SGNIsLinkMode: std_logic;

begin
    U0: ClockManagement
    Port map (resetn,CLK,CLK_CTRL,SGNSystemCount);

    U1: DPWM Port map (
	resetn,CLK,SGNSystemCount,CompI1,CompI2,CompI3,CompI4,IsTransientUp,
    IsTransientDown,SoftStart,SGNStartRelease,SWCLK,PWM1,PWM2,PWM3, PWM4,EN);

    U2: TransientDetection Port map (
	resetn,clk,CompVqu,CompVqd,SGNIsLinkMode,SoftStart,IstransientUp,
    IstransientDown,SGNIsLinkUp,SGNIsLinkDown);

    U3: ControlUnit Port map (
	resetn, WRT, CLK, CompV, CompVq, SWCLK, IsTransientUp, IsTransientDown,
    SGNIsLinkUp, SGNIsLinkDown, SGNIsLinkMode,SoftStart,SGNStartRelease,
    DACV(13),DACV(12),DACV(11),DACV(10),DACV(9),DACV(8),DACV(7),
    DACV(6),DACV(5),DACV(4),DACV(3),DACV(2),DACV(1),DACV(0),
    DACI(13),DACI(12),DACI(11),DACI(10),DACI(9),DACI(8),DACI(7),
    DACI(6),DACI(5),DACI(4),DACI(3),DACI(2),DACI(1),DACI(0),TestLed,
    DataCatched,OverFlowUpLed,OverFlowDownLed,TUCatched,TDCatched,
    StartReleaseLed);

end Behavioral;
