with Ada.Text_IO;                       use Ada.Text_IO;
with Ada.Integer_text_IO;                       use Ada.Integer_Text_IO;
with TJa.Window.Elementary;             use TJa.Window.Elementary;
with TJa.Window.Text;                   use TJa.Window.Text;
with TJa.Window.Graphic;                use TJa.Window.Graphic;
with TJa.Keyboard;                      use TJa.Keyboard;
with TJa.Misc;                          use TJa.Misc;

--- ## Kompileras med TJa-paketen genom: (Går endast att kompileras på IDA-datorer, dvs även genom thin-link
--- gnatmake $(~TDDD11/TJa-lib/bin/tja_config) test_graphics.adb

procedure Test_graphics is
   
   -- /// GRAFIK \\\ ---
   
   procedure Draw_Board is 
      X_Start : constant Integer := 20;
      Y_Start : constant Integer := 5;
      Board_Dim: Integer:=15;
      Board: array(0..Board_Dim) of integer:= (others=>0);
      Border_Width: constant Integer:= Board_Dim*4;
      Border_Heigth: constant Integer:=  Board_Dim*2;
   begin 
      Reset_Colours; 
      -- Standard colours is supposed to be black on white ...
      Clear_Window;
      Set_Buffer_Mode(Off);
      Set_Echo_Mode(Off);
      -- Draw a rectangle on screen ...
      Set_Graphical_Mode(On);
      
      -- Toppen
      Goto_XY(X_Start, Y_Start);
      Put(Upper_Left_Corner);
      for I in 1.. Border_Heigth*2-1 loop
	 if I mod 4 = 0 then 
	    Put(Horisontal_down);
	 else 
	    Put(Horisontal_Line);
	 end if;
      end loop;
      Put(Upper_Right_Corner);
      
      -- Sidorna och mitten
      for I in 1.. Border_Heigth loop
	 -- Vänster sida
	 Goto_XY(X_Start, Y_Start + I);
	 if I mod 2 = 0 then 
	    Put(Vertical_Right);
	 else 
	    Put(Vertical_Line);
	 end if;
	 -- Horisontella linjer
	 if I mod 2 = 0 then 
	    Put(Horisontal_Line, Times => Border_Width);
	 end if;
	 -- Linjer i mitten 
	 for J in 1.. Board_Dim-1 loop
	    Goto_XY(X_Start+J*4, Y_Start + I);
	    if i mod 2 = 0 then
	       Put(Cross);
	    else
	       Put(Vertical_Line);
	    end if;
	 end loop;
	 -- Höger sida
	 Goto_XY(X_Start+15*4, Y_Start + I);
	 if I mod 2 = 0 then 
	    Put(Vertical_Left);
	 else 
	    Put(Vertical_Line);
	 end if;
      end loop;
      
      -- Botten
      Goto_XY(X_Start, Y_Start + 15*2);
      Put(Lower_Left_Corner);
      for I in 1..Border_Heigth*2-1 loop
	 if I mod 4 = 0 then 
	    Put(Horisontal_Up);
	 else 
	    Put(Horisontal_Line);
	 end if;
      end loop;
      Put(Lower_Right_Corner);

      -- Slutligen skriver ut i fälten
      for I in 0.. Board_Dim-1 loop
	 for J in 0.. Board_Dim-1 loop
	    if I mod 2=0 then
	       Set_Background_Colour(Blue);
	    end if;
	    
	       Goto_XY(X_Start+J*4+2, Y_Start + I*2+1);
	       Put("A");
	   Set_Background_Colour(White);
	 end loop;
      end loop;
      
      Reset_Colours;
      Reset_Text_Modes;  -- Resets boold mode ...

      Goto_XY(1, Y_Start + 4);
      Set_Graphical_Mode(Off);
      Set_Buffer_Mode(On);
      Set_Echo_Mode(On);
      
   end Draw_Board;
   
   
   procedure Draw_Instructions is 
   begin
      Goto_XY(90,6);
      Put("Använd WASD-knapparna för att röra dig.");
      Goto_XY(90,7);
      Put("Använd C-knappen för att gå till brädan.");
      Goto_XY(90,8);
      Put("Använd V-knappen för att gå till dina brickor.");      
   end Draw_Instructions;
   
 
   procedure Draw_Brick_Holder is
      X_Start : constant Integer := 36;
      Y_Start : constant Integer := 37;   
      Width: constant Integer:= 7*4; -- 7 rutor * 4 steg
   begin
      --Set_Graphical_Mode(On);
      -- Skriver ut vänster sida
      Goto_XY(X_Start, Y_Start);
      Put(Upper_Left_Corner);
      Put(Horisontal_Line, Times =>  Width-1);
      Put(Upper_Right_Corner);

      Goto_XY(X_Start, Y_Start + 1);
      Put(Vertical_Line);
      Goto_XY(X_Start +  Width, Y_Start + 1);
      Put(Vertical_Line);

      Goto_XY(X_Start, Y_Start + 2);
      Put(Lower_Left_Corner);
      Put(Horisontal_Line, Times =>  Width-1);
      Put(Lower_Right_Corner);
      
      -- Vänster sida
      for I in 0.. 7 loop
	 Goto_XY(X_Start+I*4, Y_Start+1);
	 Put(Vertical_Line);
      end loop;
   
      Set_Graphical_Mode(Off);
      Reset_Colours;

   end Draw_Brick_Holder;
   
   procedure Draw_Debug_Info(X,Y,Location: in Integer) is
   begin
      -- Skriver ut 
      Goto_XY(16, 3);
      Put("Current position: (");
      Put(X, Width => 2);
      Put(", ");
      Put(Y, Width => 2);
      Put(")"); Put(" Location: ");
      if Location = 2 then Put("Brädan"); else Put("Brickor"); end if;
   end Draw_Debug_Info;
   
   -- /// SLUT GRAFIK \\\ ---
   
   -- /// Början på loopen för tangetbord \\\ -- 
   procedure Keyboard is
      
      X : Integer := 22;
      Y: Integer:= 6;

      procedure On_Board(Key: in Key_type) is  	
 	 Max_Left: constant Integer:= 22;
	 Max_Top: constant Integer:= 6;
	 Max_Right: constant Integer:= 78;
	 Max_Down: constant Integer:= 34;
      begin 
	 if Is_Character(Key) and then To_Character(Key) = ' ' then
	    Put('X');
	 elsif To_Character(Key) = 'w' then
	    Y := Integer'Max(Max_top, Y - 2);
	 elsif To_Character(Key) = 's' then
	    Y := Integer'Min(Max_down, Y + 2);
	 elsif To_Character(Key) = 'a' then
	    X := Integer'Max(Max_left, X - 4);
	 elsif To_Character(Key) = 'd' then
	    X := Integer'Min(Max_right, X + 4);
	 else
	    Beep;
	 end if;	 
      end On_Board;
      
      procedure On_Brick_holder(Key: in Key_type) is 
	 Max_Left: constant Integer:= 38;
	 Max_Top: constant Integer:= 38;
	 Max_Right: constant Integer:= 62;
	 Max_Down: constant Integer:= 38; 
      begin 
	 if Is_Character(Key) and then To_Character(Key) = ' ' then
	    Put('X');
	 elsif To_Character(Key) = 'w' then
	    Y := Integer'Max(Max_top, Y - 2);
	 elsif To_Character(Key) = 's' then
	    Y := Integer'Min(Max_down, Y + 2);
	 elsif To_Character(Key) = 'a' then
	    X := Integer'Max(Max_left, X - 4);
	 elsif To_Character(Key) = 'd' then
	    X := Integer'Min(Max_right, X + 4);
	 else
	    Beep;
	 end if;	 
      end On_Brick_holder;      
      
      procedure Move_To(I: in Integer; X,Y: in out integer) is
      begin
	 if I = 1 then 
	    X:= 38;
	    Y:= 38;
	 elsif I=2 then
	    X:= 22;
	    Y:= 6;
	 end if;
	 Goto_XY(X, Y);
      end Move_To;

      Location: Integer:= 2;
      Key  : Key_Type;
   begin
      Set_Buffer_Mode(Off);
      Set_Echo_Mode(Off);
      loop
	 -- Skriver ut grafiken
	 Draw_Board;
	 Draw_Brick_Holder;
	 Draw_Instructions;
	 Draw_Debug_Info(X,Y,Location);
	   
	 -- Går till positionen och väntar på kommando  
	 Goto_XY(X, Y);
	 Get_Immediate(Key);
	 Put(To_Character(Key));
	 exit when Is_Esc(Key);
	 Put(To_Character(Key));
	 
	 -- Användaren byter från bräda eller brickorna
	 if To_Character(Key) = 'c' then
	    Move_To(1,X,Y);
	    Location:= 1;
	 elsif To_Character(Key) = 'v' then
	    Move_To(2,X,Y);
	    Location:= 2;
	 end if;
	 
	 -- Begränsade steg för brickan och brädan
	 if Location = 1 then
	    On_brick_holder(key);
	 elsif Location = 2 then
	    On_Board(Key);
	 end if;
	 
      end loop;
      Set_Echo_Mode(On);
      Set_Buffer_Mode(On);
   end Keyboard;
   
begin
   Keyboard;
end Test_graphics;
