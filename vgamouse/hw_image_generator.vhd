--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY hw_image_generator IS
	GENERIC(
		pixels_y :	INTEGER := 400;    --row that first color will persist until
		pixels_x	:	INTEGER := 400);   --column that first color will persist until
	PORT(
		disp_ena		:	IN		STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
		row			:	IN		INTEGER;		--row pixel coordinate
		column		:	IN		INTEGER;		--column pixel coordinate
		red			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
		green			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
		blue			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
		mouse_data		:	IN		STD_LOGIC_VECTOR(23 DOWNTO 0)); --blue magnitude output to DAC
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS
signal x	:INTEGER := 100 ;	
  signal y	: 	INTEGER := 100;
  signal tamano :	INTEGER :=20;
  SIGNAL reloj			:	INTEGER:= 0;
  signal inc2 : INTEGER range 0 to 2000:=0;
   signal r : INTEGER range 0 to 1900:=0;
signal c : INTEGER range 0 to 1080:=0;
BEGIN
	PROCESS(disp_ena, row, column)
	BEGIN

		IF(disp_ena = '1') THEN		--display time
				inc2<=(tamano)/10;
				      
		
			IF(  row > x and row< x + tamano and column > y and column < y + tamano and ((row - x)+(column - y )< tamano)) THEN
				
			
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
				
			ELSE
			   r<=row-x;
						c<=column-y;
			   if(row > x and row< x + tamano and column > y and column < y + tamano  and (r-c=0 or (r-c<= inc2 and r-c >= -inc2 )) )then
						
								red <= (OTHERS => '1');
							green	<= (OTHERS => '0');
							blue <= (OTHERS => '0');
				else
						red <= (OTHERS => '1');
						green	<= (OTHERS => '1');
						blue <= (OTHERS => '1');
				end if;
			END IF;
		ELSE								--blanking time
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;
	
	END PROCESS;
	PROCESS(disp_ena)
	begin
	  IF(disp_ena = '0' and disp_ena'event ) THEN		--display time
	    reloj <= reloj+1;
		 --if(mouse_data(3 downto 2) ="11") then
		 if(reloj>1200) then
		 reloj <= 0;
			if(mouse_data="000110001111111100000000")then--
				x <= x-5;
				
			elsif (mouse_data="001010000000000011111111") then--
				y <= y + 5;
				
			elsif (mouse_data="000010000000000100000000") then--
				x <=x + 5;
					
	      elsif (mouse_data(23 downto 16)="00001010") then
		    tamano <=tamano+10;
		    reloj <= 0;
			elsif (mouse_data="000010000000000000000001" ) then--
			  y <= y - 5 ;
			 
	      elsif (mouse_data(23 downto 16)="00001001") then--
				 if(tamano>10)then 
					tamano <=tamano-10;
				 end if;
			end if;	
		--end if;
		end if;	
	END IF;
	
	END PROCESS;
	
END behavior;