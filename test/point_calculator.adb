
procedure Point_Calculator (Player : in out Player_Type; Words : in Array_Of_Words; Old_bricks, New_bricks : in Array_Of_Bricks ) is
   
   type Point_Type is array(Words'Range) of Integer;
   Round_Points: Point_type;
   Total_Points : Integer := 0;
begin
   Round_Points := (others => 0);
   
   -----------lägger alla olika ordens grund poäng i var sitt fack i arrayn för att sedan kunna muliplicera den med sin rätta multiplier
   for I in 1..(Words'Length) loop
      for Q in 1..(Word(I).Lenght) loop
	 if Word(I).Lenght > 1 then
	    Round_Points(I) := Round_Points(I) + Words(I)(Q).Points;
	 else 
	    Round_Points(I) := 0;
	 end if;
      end loop;
   end loop;
   Multiplier := 1;
   for E in Old_Bricks'Range loop
      if Old_Bricks(E).Bonus = 12 then
	 Multiplier := Multiplier + 1;
      elsif Old_Bricks(E).Bonus = 13 then
	 Multiplier := Multiplier + 2;
      end if;
   end loop;
   Round_Points(1) := Round_Points(1) * Multiplier;
   
   -------------------- multiplicerar alla ord med sina word muliplier----
   for R in 2..(Words'Length) loop
      if Old_Bricks(R-1).Bonus = 12 then
	 Round_Points(R) := Round_Points(R) * 2;
      elsif Old_Bricks(R-1).Bonus = 12 then
	  Round_Points(R) := Round_Points(R) * 3;
      end if;
   end loop;
   ---------- lägger ihop alla tidigare poäng
   for W in Round_Points'Range loop
      Total_Points := Total_Points + Round_Points(W);
   end loop;
   
   --------- lägger till enstaka bokstavs multipliern
   for U in Old_Bricks'Range loop
      if Old_Bricks(U).Bonus = 2 then
	 Total_Points := Total_Points + New_Bricks(U).Points;
	 elsif Old_Bricks(U).Bonus = 3 then
	    Total_Points := Total_Points + New_Bricks(U).Points*2;
      end if;
   end loop;
   
   Player.Points := Player.Points + Total_Points;
end Point_Calculator;

