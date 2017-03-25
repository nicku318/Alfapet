-- # Laddar in en textfil i ett speldata obejekt som kan användas över hela spelet.
-- Skapare: Alexander Anserud.
-- Version 1.0.
-- Befintligt problem: Kan inte skriva ut ÅÄÖ

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with TJa.Lists.Unchecked.Double_Linked.General_List.Checked_Data;
with TJa.Misc; use TJa.Misc; 

procedure Load_Game_Data is 
   
   type Brick_Record is 
      record 
	 Title: Character;
	 Points: Integer;
	 Amount: Integer;
      end record;
   
   type Bonus_Record is 
      record 
	 Title: Unbounded_String;
	 Multiplier: Integer;
	 On_sentence: Integer;
	 On_Brick: Integer;
      end record;   
   
   package Bricks_list is 
	 new TJa.Lists.Unchecked.Double_Linked.General_List.Checked_Data(Brick_record);
   use Bricks_list;
   
   package Bonuses_List is 
	 new TJa.Lists.Unchecked.Double_Linked.General_List.Checked_Data(Bonus_record);
   use Bonuses_list;   
   
   
   type Game_Data_record is 
      record
	 Total_Players: Integer;
	 Board_Dimensions: Integer;
	 Bricks: Bricks_list.List_Type;
	 Bonuses: Bonuses_List.List_Type;
      end record;
   
   -- Läser in speldata
   procedure Read_File(A: in out Game_Data_record) is 
      
      -- Extraherar ut ett segment ur en sträng baserat på följande syntax:
      -- attribut="data"
      -- Där datan som extraheras är mellan "..." 
      procedure Extract(U: in out Unbounded_String; Match: out Unbounded_String) is
	 First,Last: Integer:=0;  
      begin 
      	 First:= Index(U,"""");
	 Last:= Index(To_Unbounded_String(Slice(U,First+1,Length(U))),"""")+First;
	 Match:= To_Unbounded_String(Slice(U,First+1,Last-1));
	 U:= To_Unbounded_String(Slice(U,Last+1,Length(U)));
      end Extract;
      
      File: File_Type;
      S: String(1..100);
      U,Match: Unbounded_String;
      Len: Integer;
      Brick: Brick_record;
      Bonus: Bonus_Record;
   begin
      Open(File => File,Mode => In_File, Name => "game.txt");
      loop 
	 exit when End_Of_File(File);
	 Get_Line(File,S,Len);
	 U:= To_Unbounded_String(S(1..Len));
	 -- Läser speldata
	 if S(1..10) = "<game_data" then 
	    Extract(U,Match);
	    A.total_players  :=To_integer(Match); 
	    Extract(U,Match);
	    A.Board_Dimensions:=To_Integer(Match);
	 end if;
	 -- Läser brickor
	 if S(1..7) = "<brick " then 
	    Extract(U,Match);
	    Brick.Title  :=To_String(Match)(1); 
	    Extract(U,Match);
	    Brick.Points:= To_integer(Match); 
	    Extract(U,Match);
	    Brick.Amount:= To_integer(Match); 
	    Insert(A.Bricks,Brick);
	 end if;   
	 -- Läser bonus
	 if S(1..7) = "<bonus " then 
	    Extract(U,Match);
	    Bonus.Title  := Match; 
	    Extract(U,Match);
	    Bonus.Multiplier:= To_integer(Match); 
	    Extract(U,Match);
	    Bonus.On_sentence:= To_integer(Match); 
	    Extract(U,Match);
	    Bonus.On_Brick:= To_integer(Match); 	 
	    Insert(A.Bonuses,Bonus);
	 end if;
      end loop;
      Close(File);
   end Read_File;
   
   Brick: Brick_record;
   Bonus: Bonus_Record;
   Game_data: Game_Data_record;
   S: Unbounded_String;
begin
   
   Read_File(Game_data);
   
   -- Exempel utskrift 
   New_Line;
   Put_Line(">>>>>> Game data");
   Put("Total players: "); Put(Game_Data.Total_Players,0);New_Line;
   Put("Board dimensions: "); Put(Game_Data.Board_Dimensions,0);
   New_Line;
   
   Put_Line(">>>>>>> Bricks");
   for I in 1..Length(Game_data.Bricks) loop
      Brick:= Element(Game_data.Bricks,I);
      Put("###");New_Line;
      Put("Title :");Put(Brick.Title);New_Line;
      Put("Points:");Put(Brick.Points,0);New_Line;
      Put("Amount:");Put(Brick.Amount,0); New_Line;
   end loop;
   
   Put_Line(">>>>>>> Bonuses");
   for I in 1..Length(Game_data.Bonuses) loop
      Bonus:= Element(Game_data.Bonuses,I);
      Put("###");
      Put("Title :");Put(To_String(Bonus.Title));New_Line;
      Put("Multiplier:");Put(Bonus.Multiplier,0);New_Line;
      Put("On_sentence:");Put(Bonus.On_sentence,0); New_Line;
      Put("On_brick::");Put(Bonus.On_sentence,0); New_Line;
   end loop;
   
   -- Free data
   Delete(Game_Data.Bricks);
   Delete(Game_Data.Bonuses);

end Load_Game_Data;
