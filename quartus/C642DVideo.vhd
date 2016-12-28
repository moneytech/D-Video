library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity C642DVideo is	
	port (
		SWITCH: in STD_LOGIC_VECTOR(9 downto 0);
		BUTTON: in STD_LOGIC_VECTOR(3 downto 0);
					
		-- Output to DVideo interface -----
		DVID_CLK    : out std_logic;
		DVID_SYNC   : out std_logic;
		
		-- Output to DVideo interface -----
		DVID_RGB    : out STD_LOGIC_VECTOR(11 downto 0)
	);	
end entity;


architecture immediate of C642DVideo is
	
begin		

  process (C64_CLK, BUTTON) 
   type T_8bittable is array (0 to 255) of integer range 0 to 255;
	
   constant asintable0 : T_8bittable := (
      64,59,57,55,54,52,51,50,49,48,48,47,46,45,45,44,
      43,43,42,41,41,40,40,39,38,38,37,37,36,36,35,35,
      34,34,33,33,32,32,32,31,31,30,30,29,29,29,28,28,
      27,27,27,26,26,25,25,25,24,24,23,23,23,22,22,22,
      21,21,20,20,20,19,19,19,18,18,18,17,17,17,16,16,
      15,15,15,14,14,14,13,13,13,12,12,12,11,11,11,10,
      10,10,9,9,9,8,8,8,8,7,7,7,6,6,6,5,
      5,5,4,4,4,3,3,3,2,2,2,1,1,1,0,0,
      128,128,128,129,129,129,130,130,130,131,131,131,131,132,132,132,
      133,133,133,134,134,134,135,135,135,136,136,136,137,137,137,138,
      138,138,139,139,139,140,140,140,141,141,141,142,142,142,143,143,
      143,144,144,144,145,145,145,146,146,146,147,147,148,148,148,149,
      149,149,150,150,151,151,151,152,152,152,153,153,154,154,154,155,
      155,156,156,156,157,157,158,158,159,159,160,160,160,161,161,162,
      162,163,163,164,164,165,165,166,166,167,168,168,169,169,170,171,
      171,172,173,174,174,175,176,177,178,179,180,181,182,184,186,191
   );
   constant asintable1 : T_8bittable := (
      64,69,71,73,74,75,76,77,78,79,80,81,81,82,83,84,
      84,85,86,86,87,87,88,89,89,90,90,91,91,92,92,93,
      93,94,94,95,95,95,96,96,97,97,98,98,99,99,99,100,
      100,101,101,101,102,102,103,103,103,104,104,104,105,105,106,106,
      106,107,107,107,108,108,109,109,109,110,110,110,111,111,111,112,
      112,112,113,113,113,114,114,114,115,115,115,116,116,116,117,117,
      117,118,118,118,119,119,119,120,120,120,121,121,121,122,122,122,
      123,123,123,124,124,124,124,125,125,125,126,126,126,127,127,127,
      255,255,254,254,254,253,253,253,252,252,252,251,251,251,250,250,
      250,249,249,249,248,248,248,247,247,247,247,246,246,246,245,245,
      245,244,244,244,243,243,243,242,242,242,241,241,241,240,240,240,
      239,239,238,238,238,237,237,237,236,236,236,235,235,235,234,234,
      233,233,233,232,232,232,231,231,230,230,230,229,229,228,228,228,
      227,227,226,226,226,225,225,224,224,223,223,223,222,222,221,221,
      220,220,219,219,218,218,217,217,216,215,215,214,214,213,212,212,
      211,210,210,209,208,207,207,206,205,204,203,201,200,198,196,191
   );
   constant sintable : T_8bittable := (
      128,131,134,137,140,143,146,149,152,156,159,162,165,168,171,174,
      176,179,182,185,188,191,193,196,199,201,204,206,209,211,213,216,
      218,220,222,224,226,228,230,232,234,235,237,239,240,242,243,244,
      246,247,248,249,250,251,251,252,253,253,254,254,254,255,255,255,
      255,255,255,255,254,254,253,253,252,252,251,250,249,248,247,246,
      245,244,242,241,239,238,236,235,233,231,229,227,225,223,221,219,
      217,215,212,210,207,205,202,200,197,195,192,189,186,184,181,178,
      175,172,169,166,163,160,157,154,151,148,145,142,138,135,132,129,
      126,123,120,117,113,110,107,104,101,98,95,92,89,86,83,80,
      77,74,71,69,66,63,60,58,55,53,50,48,45,43,40,38,
      36,34,32,30,28,26,24,22,20,19,17,16,14,13,11,10,
      9,8,7,6,5,4,3,3,2,2,1,1,0,0,0,0,
      0,0,0,1,1,1,2,2,3,4,4,5,6,7,8,9,
      11,12,13,15,16,18,20,21,23,25,27,29,31,33,35,37,
      39,42,44,46,49,51,54,56,59,62,64,67,70,73,76,79,
      81,84,87,90,93,96,99,103,106,109,112,115,118,121,124,127
   );  
  
  
  variable in_lum  : unsigned(7 downto 0);  
  variable in_aes  : std_logic;  
  variable in_col1  : unsigned(7 downto 0);  
  variable in_col2  : unsigned(7 downto 0);  

  variable tmp_col : integer range 0 to 1023;
  variable norm_col1 : integer range 0 to 255;
  variable norm_col2 : integer range 0 to 255;
  
  variable tmp_phase1  : integer range 0 to 255;  
  variable tmp_phase2  : integer range 0 to 255;  
  variable tmp_error  : integer range 0 to 1023;  
  variable tmp_bestphase : integer range 0 to 255;
  variable tmp_besterror : integer range 0 to 1023;
  variable tmp_lum    : integer range 0 to 255;  
  
  variable out_clock : std_logic;
  variable out_sync  : std_logic;
  variable out_rgb   : unsigned(11 downto 0);  

  variable var_currentphase : integer range 0 to 255;
  variable var_syncduration : integer range 0 to 7;
  variable var_aescorr : integer range 0 to 63 := 0;
  
  type T_edges is array(0 to 6) of integer range 0 to 255;
  variable var_edges : T_edges := ( 48, 87, 106, 126, 141, 162, 195 );
  variable var_edgecursor : integer range 0 to 6 := 0; 

  
	function diff (a : integer range 0 to 255; b: integer range 0 to 255) return integer is
	begin
		if a<b then
			return b-a;
      else
         return a-b;
      end if;
	end diff;
  
  begin
		-- clock in the first values on falling edge (in middle of pixel)
		-- and compute outgoing values using the previous values 1 and 2
	   if falling_edge(C64_CLK) then

			norm_col1 := to_integer(in_col1);
			if norm_col1<64 then 
			   norm_col1 := 0;
			else
				tmp_col := norm_col1 - 64;
				tmp_col := (tmp_col*4)/3;
			   norm_col1 := tmp_col;
			end if;
			norm_col2 := to_integer(in_col2);
			if norm_col2<64 then 
			   norm_col2 := 0;
			else
				tmp_col := norm_col2 - 64;
				tmp_col := (tmp_col*4)/3;
			   norm_col2 := tmp_col;
			end if;

				tmp_phase2 := asintable0(norm_col2);
				tmp_phase1 := tmp_phase2 + 184;
			   tmp_besterror := diff(norm_col1, sintable(tmp_phase1)); 
				tmp_bestphase := tmp_phase2;
				
				tmp_phase2 := asintable1(norm_col2);
				tmp_phase1 := tmp_phase2 + 184;
			   tmp_error := diff(norm_col1, sintable(tmp_phase1)); 
				if tmp_error < tmp_besterror then
					tmp_besterror := tmp_error;
					tmp_bestphase := tmp_phase2;
				end if;
				
				tmp_phase1 := asintable0(norm_col1);
				tmp_phase2 := tmp_phase1 + 72;
			   tmp_error := 2*diff(norm_col2, sintable(tmp_phase2)); 
				if tmp_error < tmp_besterror then
					tmp_besterror := tmp_error;
					tmp_bestphase := tmp_phase2;
				end if;
				
				tmp_phase1 := asintable1(norm_col1);
				tmp_phase2 := tmp_phase1 + 72;
			   tmp_error := 2*diff(norm_col2, sintable(tmp_phase2)); 
				if tmp_error < tmp_besterror then
					tmp_besterror := tmp_error;
					tmp_bestphase := tmp_phase2;
				end if;
			
			
			   tmp_lum := to_integer(in_lum);
				if in_aes='1' then
				   if tmp_lum<255-var_aescorr then
					   tmp_lum := tmp_lum + var_aescorr;
					else
					   tmp_lum := 255;
					end if;
				end if;
				
			
			if SWITCH(1)='1' then
				out_rgb := to_unsigned(tmp_lum,8) & "0000";
		   elsif SWITCH(2)='1' then
				if tmp_lum < var_edges(0) then
				   tmp_lum := 0;
				elsif tmp_lum < var_edges(1) then
				   tmp_lum := 2;
				elsif tmp_lum < var_edges(2) then
				   tmp_lum := 4;
				elsif tmp_lum < var_edges(3) then
				   tmp_lum := 6;
				elsif tmp_lum < var_edges(4) then
				   tmp_lum := 8;
				elsif tmp_lum < var_edges(5) then
				   tmp_lum := 9;
				elsif tmp_lum < var_edges(6) then
				   tmp_lum := 11;
				elsif tmp_lum < 255 then
				   tmp_lum := 13;
				else
				   tmp_lum := 15;
				end if;
				out_rgb := to_unsigned(tmp_lum,4) & "00000000";	
				
			elsif SWITCH(3)='1' then
				out_rgb := to_unsigned(norm_col1,8) & "0000";
			elsif SWITCH(4)='1' then
			   out_rgb := to_unsigned(norm_col2,8) & "0000";
		   else   
--				out_rgb := to_unsigned(tmp_lum,4)
--					       &to_unsigned(tmp_lum,4)
--					       &to_unsigned(tmp_lum,4);
				out_rgb := to_unsigned(tmp_bestphase-var_currentphase,8) & "0000";
			end if;

			if in_lum="00000000" then
			   if var_syncduration=7 then
				   out_sync := '0';
					var_currentphase := 0;
				else 
				   out_sync := '1';
					var_syncduration:=var_syncduration+1;
					var_currentphase := var_currentphase + 7*16;
				end if;
			else
			   out_sync := '1';
				var_syncduration := 0;
				var_currentphase := var_currentphase + 7*16;
			end if;

      end if;
		
		-- on rising edge transfer second values (at end of pixel)
		-- also trigger the clock, so the previouly computed
		-- values can be taken by 
		if rising_edge(C64_CLK) then
         in_lum  := unsigned(C64_LUM);
         in_col2  := unsigned(C64_COL);			
			in_aes  := C64_AES;
			
		   if out_clock='1' then
			    out_clock := '0';
		   else
			    out_clock := '1';
			end if;
		end if;
		
		if falling_edge(BUTTON(0)) then
		    if BUTTON(1)='0' then
   		    if var_aescorr >0 then
			   	var_aescorr:=var_aescorr-1;
			     end if;
			else 
		    if var_aescorr <31 then
				var_aescorr:=var_aescorr+1;
			 end if;
         end if;			
      end if;			 

		if falling_edge(BUTTON(3)) then
		    var_edgecursor := var_edgecursor+1;
      end if;			 

		if falling_edge(BUTTON(2)) then
		    if BUTTON(1)='0' then
   		    if var_edges(var_edgecursor)>0 then
			   	var_edges(var_edgecursor):=var_edges(var_edgecursor)-1;
			     end if;
			else 
   		    if var_edges(var_edgecursor)<255 then
			   	var_edges(var_edgecursor):=var_edges(var_edgecursor)+1;
			     end if;
         end if;			
      end if;			 
		
		
      DVID_CLK <= out_clock;
		DVID_SYNC <= out_sync;
		DVID_RGB <= std_logic_vector(out_rgb);
  end process; 

end immediate;
