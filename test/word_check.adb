procedure Word_Check(Board : in Board_Type; Bricks : in Brick_Array; Words : out Word_Array_Type) is
   procedure Get_Word(Word : out String; Horisontal : in Boolean; Board : in Board_Type; Start : in Kordinate_Type) is
      Lenght : Natural := 1;
      Krock : Nautral := 0;
   begin
      if Horisontal then
	 while Borad(Start.Horisontal + Krock)(Start.Vertikal) /= "null" loop
	    Word(Lenght) := Board.Kordinates(Start.Vertikal, Start.Horisontal + Krock);
	    Krock := Krock + 1;
	    Lenght := Lenght + 1;
	 end loop;
	 
   end Get_Word;
   
----------------------------------- board_type is array	(horisontal)(veritkal) --------------------------------			   
   I, length : Natural := 1;
   Horisotal : Boolean;
   Start : Kordinate_Type;
					 
begin
   if Bricks(1).Kordinates.Horisontal = Bricks(2).Kordiantes.Horisontal + 1 then
      Horisontal := Ture;
   end if;
   Start := Brick(1).Kordinates;
   Get_Word(Words(I), Horisontal, Board, start);
   I := I + 1;
   for Q in 1..(Word(1).Lenght) loop
      if Horisontal then
	 if Brick(Q).Vertikal + 1 /= "null" or Bricka(Q).Vertikal - 1 /= "null" then 
	    while Board(Bricka.Vertikal + Length)(Horisontal) /= "null" loop
	       Lenght := Lenght + 1;
	    end loop;
	    Start := (Bricka(Q).Horisontal, Bricka(Q).Vertikal + Lenght);
	    Horisontal := False;
	    Get_Word(Word(I), Horisontal, Board, Start);
	 end if;
	 Horisontal := True;
      else
	 if Brick(Q).horisontal + 1 /= "null" or Bricka(Q).horisontal - 1 /= "null" then 
	    while Bricka.Horisontal + Length /= "null" loop
	       Lenght := Lenght + 1;
	    end loop;
	    Start := (Bricka(Q).Horisontal + lenght, Bricka(Q).Vertikal);
	    Horisontal := ture;
	    Get_Word(Word(I), Horisontal, Board, Start);
	 end if;
	 Horisontal := false;
      end if;
   end loop;
   
	 
	    
	    
	      
end Word_Check;
