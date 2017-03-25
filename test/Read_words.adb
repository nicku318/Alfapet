-- # Laddar in en ord i en array och använder binärsökning för att hitta ett ord med functionen binary_search
-- Skapare: Alexander Anserud.
-- Version 1.0.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with TJa.Lists.Unchecked.Double_Linked.General_List.Checked_Data;
with TJa.Misc; use TJa.Misc; 

procedure Read_words is 
   type Words_Array is 
     array(1..70460) of Unbounded_String;
   
   -- Läser in orden i en array
   procedure Read_File(Words: in out Words_array) is 
      File: File_Type;
      File_Name: String:= "ordlista.txt";
      S: String(1..100);
      U,Match: Unbounded_String;
      Len: Integer;
      Index: Integer:=1;
   begin
      Open(File => File,Mode => In_File, Name =>File_name);
      loop 
	 exit when End_Of_File(File);
	 Get_Line(File,S,Len);
	 U:= To_Unbounded_String(S(1..Len));
	 Words(Index):= U;
	 Index:= Index+1;
      end loop;
      Close(File);
   end Read_File;   
   
   -- Söker en array med ord med värsta falls komplexitet: O(log n)
   function Binary_Search(Words: in Words_Array; Lower, Upper: in Natural; Target: in Unbounded_String) return Boolean is
      Mid: Integer:= Integer(Float(Lower)+Float(Upper-Lower)/2.0);
   begin 
      if Upper < Lower then
	 return False;
      end if;
      if Words(Mid) > Target then 
	 return Binary_Search(Words,Lower ,Mid-1,Target);
      elsif Words(Mid) < Target then
	 return Binary_Search(Words,Mid+1, Upper, Target);
      else
	 -- Debug
	 --Put_Line("Found: " & To_String(Target) & " at location: " & Integer'Image(Mid)) ;
	 return True;
      end if;
   end Binary_Search;

   Words: Words_Array;
   Target: Unbounded_String:= To_Unbounded_String("bil");
begin
   
   Read_File(Words);
   if Binary_Search(Words,Words'first,Words'Length,Target) then 
      Put_Line("Found: " & To_String(Target));
   else
      Put_Line("Did not found: " & To_String(Target));
   end if;
   
end Read_Words;
