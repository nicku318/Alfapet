procedure Get_Words(New_Board, Old_Board : in Board_Type; Words : out Word_Array_Type; Old_Bricks, New_bricks : out Brick_Array_type ) is
   type Kordinate_Type is 
      record 
	 R, K : Integer;
      end record;
   --------R = Rad, K = kolumn ----
   
   subtype Direction_type is Integer range 1..3;
   --------- 1 = horisontal, 2 = vertikal, 3 = singel------
	 
   procedure Find_First (New_Board : in Board_Type; Start: out Kordinate_Type; Direction : out Direction_Type) is
      
   begin
      for R in 1..15 loop
	 for K in 1..15 loop
	    if New_Board(R,K).Marked then
	       Start.R := R;
	       Start.K := K;
	       if New_Borad(R,K+1).Marked then
		  Direction := 1;
	       elsif New_Board(R+1,K.Marked then
		  Direction := 2;
	       else 
		  Direction := 3;
	       end if;
	       exit;
	    end if;
	 end loop;
      end loop;
   end Find_First;
   
   function Word_Start (Board: in Board_Type; Direction : in Direction_Type; Start : in Kordinate_Type) return Kordinate_Type is
   begin
      If Direction = 1 then
	 Start_Others := Start;
	 while Board(Start_Main.R, Start_Others.K - 1).Titel /= ' ' and Start_Others.K /= 1 loop
	    Start_Others.K := Start_Others.K - 1;
	 end loop;
	 if Start_Others = Start and Board(Start.R, Start.K + 1).Titel = ' ' then
	    Start_Others.K := 0;
	    Start_Others.R := 0;
	 end if;
	 
      else Direction = 2 then
	Start_Others := Start;
	while Board(Start_Others.R - 1, Start_Main.K).Titel /= ' ' and Start_Others.R /= 1 loop
	   Start_Others.R := Start_Others.R - 1;
	end loop;
	if Start_Others = Start and Board(Start.R + 1, Start.K).Titel = ' ' then
	    Start_Others.K := 0;
	    Start_Others.R := 0;
	 end if;
      end if;
      
      return Start_Others;
   end Word_Start;
   
   --------------------------get_word hämtar ett ord utifrån en start position och en rikting som den ska röra sig i och spottar ut en array med alla brickorna i ordet i.
   procedure Get_Word(Word : out Array_Of_bricks; Direction : in Direction_type; Board : in Board_Type; Start : in Kordinate_Type) is
      Lenght : Natural := 1;
      Krock : Nautral;
   begin
      if Horisontal then
	 Krock := Start.K;
	 while Board(Start.R, Krock).Titel /= ' ' loop
	    Word(Lenght) := Board(Start.R,  Krock);
	    Krock := Krock + 1;
	    Lenght := Lenght + 1;
	 end loop;
      else
	 Krock := Start.R;
	 while Borad(Krock, Start.K) /= ' ' loop
	    Word(Lenght) := Board.Kordinates(Start.Horisontal, Start.Vertikal + Krock);
	    Krock := Krock + 1;
	    Lenght := Lenght + 1;
	 end loop;
      end if;
      
   end Get_Word;
   
   ------------------------- Get_Bonus hämtar alla brickor som på den gamla brädan låg på de platserna som nu har nya brickor på sig och lägger dem i en array alternativt lista-----------------------
   procedure Get_Bonus (New_Board, Old_Board : in Board_Type; Old_Bricks, New_bricks : out Array_Of_Bricks) is
      I : Natuarl := 1;
   begin
      for R in 1..15 loop
	 for K in 1..15 loop
	    if New_Board(R,K).Marked then
	       Old_Bricks(I) := Old_Board(R,K);
	       New_Bricks(I) := New_Board(R,K);
	       I := I + 1;
	    end if;
      
	 end loop;
      end loop;
      
   end Get_Bonus;
   
  
   I, Length,  : Natural := 1;
   Diection_Maine, Direction_others : Direction_type;
   Start_Main, Start_others : Kordinate_Type;
   
					 
begin
   Find_First(New_Board, Start_Main, Direction_Main);

   if Direction_Main = 3 then
	if New_Board(Start_Main.R - 1, Start_Main.K) /= ' ' or New_Board(Start_Main.R + 1, Start_Main.K) /= ' ' then
	   Direction_main := 2;
	else
	   Direction_Main := 1;
	end if;
   end if;
   
   
   Start_Others := Word_Start(New_Board, Direction_Main, Start_Main);
   Get_Word(Words(Lenght), Direction_Main, New_Board, Start_Others);
   
   if Direction_main = 1 then
      Direction_Others := 2;
      While New_Board(Start_Main.R, Start_Main.K + Lenght - 1).Marked loop
	 Lenght := Lenght + 1;
	 Start_Others := Word_Start(New_Board, Direction_Others, Start_Main + Lenght - 1);
	 if Start_Others.K /= 0 then
	    Get_Word(Words(Lenght), Direction_Others, New_Board, Start_Others);
	 else
	    --------- om det inte kan bildas ett ord så sätts första brickan i arrayn till en null bricka men man kommer alltid att ha en antalet brickor + 1 ord i arrayn -----------	    Words(Lenght)(1).Titel := ' ';
	 end if;
      end loop;
	
   else
      Direction_Others := 1;
       While New_Board(Start_Main.R + Lenght - 1, Start_Main.K ).Marked loop
	 Lenght := Lenght + 1;
	 Start_Others := Word_Start(New_Board, Direction_Others, Start_Main + Lenght - 1);
	 if Start_Others.K /= 0 then
	    Get_Word(Words(Lenght), Direction_Others, New_Board, Start_Others);
	 else
	    Words(Lenght)(1).Titel := ' ';
	 end if;
       end loop;
       
   end if;  
   
   Get_Bonus(New_Board, Old_Board, Old_Bricks, New_Bricks);
	      
end Get_Words;
