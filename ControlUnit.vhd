--------------------------
----- ControlUnit --------
--------------------------
Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
USE ieee.std_logic_misc.and_reduce;
USE ieee.std_logic_misc.or_reduce;
USE work.mypackPCMMP.all;
ENTITY ControlUnit IS PORT (
	resetn: IN std_logic;
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
END ControlUnit;

ARCHITECTURE behavioral OF ControlUnit IS
Type StateType is (S0,S1);
	Signal CurState,CurStateM: StateType;
	Signal SGNVolMid: VolCounterType;
	Signal SGNPeakCur,CounterTU,CounterTD: CurCounterType;
	Signal SGNCompV,SGNCompVq,IsOverFlowUp,IsOverFlowDown,SGNStartUp: std_logic;
	BEGIN
	process(CLK_CTRL,resetn)
	Variable VarDACI,VarPeakCur,AdjAmount,startupCounter: CurCounterType;
	Variable VarDACV,VarVolMid: VolCounterType;
	Variable NextState: StateType;
	Variable VarIsTransientUp,VarIsTransientDown,LastTransientUp,LastTransientDown, SoftRelease:std_logic;
	Variable VarSmoothTransient,VarOverTransientUp: std_logic;
	Variable VarLinkUp,VarLinkDown,VarCompV,VarLinkMode: std_logic;
begin
if resetn='0' then
	VarVolMid:=InitialVolMid;
	VarPeakCur:=InitialPeakCur;
	VarDACV:=InitialVolMid;
	VarDACI:=InitialPeakCur;
	SGNVolMid<=InitialVolMid;
	SGNPeakCur<=InitialPeakCur;
	DACV13<='1';
	DACV12<='1';
	DACV11<=VarDACV(7);
	DACV10<=VarDACV(6);
	DACV9<=VarDACV(5);
	DACV8<=VarDACV(4);
	DACV7<=VarDACV(3);
	DACV6<=VarDACV(2);
	DACV5<=VarDACV(1);
	DACV4<=VarDACV(0);
	DACV3<='1';
	DACV2<='1';
	DACV1<='1';
	DACV0<='1';
	DACI13<=VarDACI(7);
	DACI12<=VarDACI(6);
	DACI11<=VarDACI(5);
	DACI10<=VarDACI(4);
	DACI9<=VarDACI(3);
	DACI8<=VarDACI(2);
	DACI7<=VarDACI(1);
	DACI6<=VarDACI(0);
	DACI5<='0';
	DACI4<='0';
	DACI3<='0';
	DACI2<='0';
	DACI1<='0';
	DACI0<='0';
	AdjAmount:=AdjustStepSteady;
	SoftStart<='1';
	SoftRelease:='1';
	SGNStartUp<='1';
	IsOverFlowUp<='0';
	IsOverFlowDown<='0';
	OverFlowUpLed<='0';
	OverFlowDownLed<='0';
	NextState:=S0;
	CurStateM<=S0;
	SGNCompV<='0';
	SGNCompVq<='0';
	CounterTU<=(others=>'0');
	CounterTD<=(others=>'0');
	VarSmoothTransient:='0';
	IsLinkMode<='0';
	VarLinkUp:='0';
	VarLinkDown:='0';
	VarCompV:='0';
	VarLinkMode:='0';
	StartReleaseLed<='0';
else
	if rising_edge(CLK_CTRL) then
		Case CurStateM is
				--- S0 state operation ---
			when S0 => 	if CompV='1'then SGNCompV<='1';
									else SGNCompV<='0';
						end if;
						
						if CompVq='1' then SGNCompVq<='1';
						else SGNCompVq<='0';
						end if;
						
						if (SGNPeakCur > MaxPeakCur)then IsOverFlowUp<='1'; OverFlowUpLed<='1';
													else IsOverFlowUp<='0'; OverFlowUpLed<='0';
						end if;
						
						if (SGNPeakCur < MinPeakCur)then IsOverFlowDown<='1'; OverFlowDownLed<='1';
													else IsOverFlowDown<='0'; OverFlowDownLed<='0';
						end if;
						
						if IsTransientDown='1'or IsTransientUp='1' then
							IsLinkMode<='0';
							if IsTransientUp='1'then
								AdjAmount:=AdjustStepTransUp;
							end if;
							if IsTransientDown='1' then
								AdjAmount:=AdjustStepTransDown;
							end if;
						else
							if IsLinkUp='1' or IsLinkDown='1' or VarLinkUp='1' or VarLinkDown='1' then
								IsLinkMode<='1';
								VarLinkMode:='1';
								if IsLinkUp='1' or VarLinkUp='1' then
									AdjAmount:=AdjustStepUpLink;
									VarLinkUp:='1';
								end if;
								if IsLinkDown='1' or VarLinkDown='1' then
									AdjAmount:=AdjustStepDownLink;
									VarLinkDown:='1';
								end if;
							else
								if VarSmoothTransient='1' then
									AdjAmount:='0' & AdjAmount(VolCounterWidth downto 1);
								else
									AdjAmount:=AdjustStepSteady;
								end if;
								IsLinkMode<='0';
								VarLinkMode:='0';
							end if;
						end if;
						NextState:=S1;
			
				--- S1 state operation ---
			when S1 =>	if SGNCompV='0' then
							VarLinkUp:='0';
						else
							VarLinkDown:='0';
						end if;
						
						if AdjAmount>AdjustStepSteady then
							VarSmoothTransient:='1';
						else
							VarSmoothTransient:='0';
						end if;
						
						if VarLinkMode='0' then
							VarCompV:=SGNCompV;
						else
							VarCompV:=SGNCompVq;
						end if;
						
						case VarCompV is
							when '0' => if IsOverFlowUp='1' then
											VarVolMid:=MinVolMid;
											VarPeakCur:=MaxPeakCur;
										else
											VarVolMid:=VarVolMid-AdjAmount;
											VarPeakCur:=VarPeakCur+AdjAmount;
										end if;
							when '1' => if IsOverFlowDown='1' then
											VarVolMid:=MaxVolMid;
											VarPeakCur:=MinPeakCur;
										else
											VarVolMid:=VarVolMid+AdjAmount;
											VarPeakCur:=VarPeakCur-AdjAmount;
										end if;
										SoftStart<='0';
										SoftRelease:='0';
										SGNStartUp<='0';
										StartReleaseLed<='1';
							when others => null;
						end case;
						SGNVolMid<=VarVolMid;
						SGNPeakCur<=VarPeakCur;
						VarDACV:=VarVolMid;
						VarDACI:=VarPeakCur;
						DACV11<=VarDACV(7);
						DACV10<=VarDACV(6);
						DACV9<=VarDACV(5);
						DACV8<=VarDACV(4);
						DACV7<=VarDACV(3);
						DACV6<=VarDACV(2);
						DACV5<=VarDACV(1);
						DACV4<=VarDACV(0);
						DACI13<=VarDACI(7);
						DACI12<=VarDACI(6);
						DACI11<=VarDACI(5);
						DACI10<=VarDACI(4);
						DACI9<=VarDACI(3);
						DACI8<=VarDACI(2);
						DACI7<=VarDACI(1);
						DACI6<=VarDACI(0);
						NextState:=S0;
						
			when others => null;
			end case;
			CurStateM<=NextState;
	end if;
end if;
end process;

process(CLK_CTRL,resetn)
	Variable VarTU,VarTD: CurCounterType;
begin
	if resetn='0' then
		TUCatched<=(others=>'0');
		TDCatched<=(others=>'0');
		VarTU:=(others=>'0');
		VarTD:=(others=>'0');
	else
		if rising_edge(CLK_CTRL) then
			if SGNStartUp='0' then
				if CounterTU>VarTU then
					TUCatched<=CounterTU;
					VarTU:=CounterTU;
				end if;
				if CounterTD>VarTD then
					TDCatched<=CounterTD;
					VarTD:=CounterTD;
				end if;
			end if;
		end if;
	end if;
end process;
			
process(SWCLK,resetn)
begin
	if resetn='0' then
		DataCatched<=(others=>'0');
	else
		if rising_edge(SWCLK) then
			DataCatched<=SGNPeakCur;
		end if;
	end if;
end process;
End behavioral;