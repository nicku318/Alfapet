-- ## Testar grafik
-- Markören styrs med WASD-knapparna (Motsvar respektive riktning som väntat)
-- Man kan även röra sig snabbare med IJKL-Knapparna

with Ada.Command_Line;    use Ada.Command_Line;
with Ada.Exceptions;      use Ada.Exceptions;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with TJa.Window.Elementary;             use TJa.Window.Elementary;
with TJa.Keyboard;                      use TJa.Keyboard;
with TJa.Misc;                          use TJa.Misc;
with TJa.Window.Text;                   use TJa.Window.Text;
with TJa.Window.Graphic;                use TJa.Window.Graphic;


procedure Sand_Box is 
   Dim: constant Integer:= 15;
   Border_With: constant Integer:= 15;
   procedure Put_S(Amount: in Integer; S: string) is 
   begin
      for J in 1..Amount loop
	 Put(S);
      end loop;
   end Put_S;
   
   procedure Draw_Board is 
   begin
      Reset_Colours;
      Clear_Window;
      New_Line(5);
      Put_S(Border_With," ");
      Set_Background_Colour(Blue);
      Set_Foreground_Colour(White);
      Put_S(Dim,"----");Put("-"); 
      Set_Background_Colour(White);
      Set_Foreground_Colour(White);
      New_Line;
      for J in 1..Dim loop
	 Put_S(Border_With," ");
	 Set_Background_Colour(Blue);
	 Set_Foreground_Colour(White);
	 Put_S(Dim,"|   ");Put("|");
	 Set_Background_Colour(White);
	 Set_Foreground_Colour(White);
	 New_Line;
	 Put_S(Border_With," ");
	 Set_Background_Colour(Blue);
	 Set_Foreground_Colour(White);
	 Put_S(Dim,"----");Put("-");
	 Set_Background_Colour(White);
	 Set_Foreground_Colour(White);
	 New_Line;
	 
      end loop;

      Put_S(47," ");
      Set_Background_Colour(Blue);
      Set_Foreground_Colour(White);
      Put_S(7,"|   ");Put("|");
      New_Line;
      Set_Background_Colour(White);
      Set_Foreground_Colour(White);
      Put_S(47," ");
      Set_Background_Colour(Blue);
      Set_Foreground_Colour(White);
      Put_S(7,"    ");Put(" ");

      New_Line(5);
      Reset_Colours;
      Reset_Text_Modes;
   end Draw_Board;   
   
   procedure Test_Keyboard is

      Key  : Key_Type;
      X : Integer := 74;
      Y: Integer:= 37;
   begin

      Set_Buffer_Mode(Off);
      Set_Echo_Mode(Off);
      loop
	 Draw_Board;
	 Goto_XY(16, 3);
	 Put("Current position: (");
	 Put(X, Width => 2);
	 Put(", ");
	 Put(Y, Width => 2);
	 Put(")"); 

	 Goto_XY(X, Y);
	 Get_Immediate(Key);
	 
	 exit when Is_Esc(Key);
	 Put(To_Character(Key));

	 if Is_Character(Key) and then To_Character(Key) = ' ' then
	    Put('X');
	 elsif To_Character(Key) = 'w' then
	    Y := Integer'Max(7, Y - 2);
	 elsif To_Character(Key) = 's' then
	    Y := Integer'Min(37, Y + 2);
	 elsif To_Character(Key) = 'a' then
	    X := Integer'Max(18, X - 4);
	 elsif To_Character(Key) = 'd' then
	    X := Integer'Min(74, X + 4);
	 elsif To_Character(Key) = 'i' then
	    Y := Integer'Max(7, Y - 4);
	 elsif To_Character(Key) = 'k' then
	    Y := Integer'Min(37, Y + 4);
	 elsif To_Character(Key) = 'j' then
	    X := Integer'Max(18, X - 8);
	 elsif To_Character(Key) = 'l' then
	    X := Integer'Min(74, X + 8);	    
	 else
	    Beep;
	 end if;
      end loop;
      
      Set_Echo_Mode(On);
      Set_Buffer_Mode(On);
      
   end Test_Keyboard;
   
begin
   Test_Keyboard;
end Sand_Box;
