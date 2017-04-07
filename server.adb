with Ada.Command_Line;    use Ada.Command_Line;
with Ada.Exceptions;      use Ada.Exceptions;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with TJa.Sockets;         use TJa.Sockets;

procedure Server is
   
   type Brick_Type is 
      record
	 C : Character := ' ';
	 Points : Integer := 0;
	 Marked : Boolean := False;
	 Bonus : Integer := 0;
	 X : Integer;
	 Y : Integer;
      end record;
   
   type Board_Sub_Type is array(1..15) of Brick_Type;
   
   type Board_Type is array(1..15) of Board_Sub_Type;
   
   type Own_Board_Type is array(1..7) of Brick_Type;
   
   type Player_Type is
      record
	 Name : String(1..30);
	 NameL : Integer;
	 Points : Integer := 0;
	 Brick : Own_Board_Type;
	 Id : Integer;
      end record;
   
   Socket1 : Socket_Type;
   Socket2 : Socket_Type;
   Socket3 : Socket_Type;
   Socket4 : Socket_Type;
   
   subtype Command_Type is String(1..6);
   
   procedure Send( C : in Character; ID : in Integer) is 
   begin
      if ID = 1 then
	 Put_Line(Socket1, C);
      elsif ID = 2 then
	 Put_Line(Socket2, C);
      elsif ID = 3 then
	 Put_Line(Socket3, C);
      elsif ID = 4 then
	 Put_Line(Socket4, C);
      end if;
   end Send;
   
   procedure Send( I : in Integer; ID : in Integer) is
   begin
      if ID = 1 then
	 Put_Line(Socket1, I);
      elsif ID = 2 then
	 Put_Line(Socket2, I);
      elsif ID = 3 then
	 Put_Line(Socket3, I);
      elsif ID = 4 then
	 Put_Line(Socket4, I);
      end if;
   end Send;
   
   procedure Receive (C : out Character; ID : in Integer) is
      T : String(1..100);
      X : Integer;
   begin
      if ID = 1 then
	 Get_Line(Socket1, T, X);
      elsif ID = 2 then
	 Get_Line(Socket2, T, X);
      elsif ID = 3 then
	 Get_Line(Socket3, T, X);
      elsif ID = 4 then
	 Get_Line(Socket4, T, X);
      end if;
      C := T(1);
   end Receive;
   
   procedure Receive (I : out Integer; ID : in Integer) is
      T : String(1..100);
      X : Integer;
   begin
      if ID = 1 then
	 Get_Line(Socket1, T, X);
      elsif ID = 2 then
	 Get_Line(Socket2, T, X);
      elsif ID = 3 then
	 Get_Line(Socket3, T, X);
      elsif ID = 4 then
	 Get_Line(Socket4, T, X);
      end if;
      I := Integer'Value(T(1..X));
   end Receive;
   
   procedure Receive (B : out Boolean; ID : in Integer) is
      T : String(1..100);
      X : Integer;
   begin
      if ID = 1 then
	 Get_Line(Socket1, T, X);
      elsif ID = 2 then
	 Get_Line(Socket2, T, X);
      elsif ID = 3 then
	 Get_Line(Socket3, T, X);
      elsif ID = 4 then
	 Get_Line(Socket4, T, X);
      end if;
      if T(1..4) = "True" then
	 B := True;
      elsif T(1..5) = "False" then
	 B := False;
      end if;
   end Receive;
   
   procedure Send (B : in Boolean; ID : in Integer) is
   begin
      if B = True then
	 if ID = 1 then
	    Put_Line(Socket1, "True");
	 elsif ID = 2 then
	    Put_Line(Socket2, "True");
	 elsif ID = 3 then
	    Put_Line(Socket3, "True");
	 elsif ID = 4 then
	    Put_Line(Socket4, "True");
	 end if;
      elsif B = False then
	 if ID = 1 then
	    Put_Line(Socket1, "False");
	 elsif ID = 2 then
	    Put_Line(Socket2, "False");
	 elsif ID = 3 then
	    Put_Line(Socket3, "False");
	 elsif ID = 4 then
	    Put_Line(Socket4, "False");
	 end if;
      end if;
   end Send;
   
   procedure Receive (B : out Brick_Type; ID : in Integer) is
      C : Character;
      I : Integer;
      M : Boolean;
   begin
      
	 Receive(C, ID);
	 B.C := C;
	 Receive(I, ID);
	 B.Points := I;
	 Receive(M, ID);
	 B.Marked := M;
	 Receive(I, ID);
	 B.Bonus := I;
	 Receive(I, ID);
	 B.X := I;
	 Receive(I, ID);
	 B.Y := I;
      
   end Receive;
   
   procedure Send (B : in Brick_Type; ID : in Integer) is
   begin
      
      Send(B.C, ID);
      Send(B.Points, ID);
      Send(B.Marked, ID);
      Send(B.Bonus, ID);
      Send(B.X, ID);
      Send(B.Y, ID);
      
   end Send;
   
   procedure Receive (B : out Own_Board_Type; ID : in Integer) is
      X : Brick_Type;
   begin
      
      for Z in 1..7 loop
	 Receive(X, ID);
	 B(Z) := X;
      end loop;
      
   end Receive;
   
   procedure Send (B : in Own_Board_Type; ID : in Integer) is
   begin
      
      for Z in 1..7 loop
	 Send(B(Z), ID);
      end loop;
      
   end Send;
   
   procedure Receive (P : out Player_Type; ID : in Integer) is
      Name : String(1..30);
      NameL : Integer;
      Points : Integer := 0;
      Brick : Own_Board_Type;
      I : Integer;
   begin
      if ID = 1 then
	 Get_Line(Socket1, Name, NameL);
      elsif ID = 2 then
	 Get_Line(Socket2, Name, NameL);
      elsif ID = 3 then
	 Get_Line(Socket3, Name, NameL);
      elsif ID = 4 then
	 Get_Line(Socket4, Name, NameL);
      end if;
      P.Name := Name;
      P.NameL := NameL;
      Receive(Points, ID);
      P.Points := Points;
      Receive(Brick, ID);
      P.Brick := Brick;
      Receive(I, ID);
      P.Id := I;
   end Receive;
   
   procedure Send (P : in Player_Type; ID : in Integer) is
   begin
      if ID = 1 then
	 Put_Line(Socket1, P.Name(1..P.NameL));
      elsif ID = 2 then
	 Put_Line(Socket2, P.Name(1..P.NameL));
      elsif ID = 3 then
	 Put_Line(Socket3, P.Name(1..P.NameL));
      elsif ID = 4 then
	 Put_Line(Socket4, P.Name(1..P.NameL));
      end if;
      Send(P.Points, ID);
      Send(P.Brick, ID);
      Send(P.ID, ID);
   end Send;
   
   procedure Receive (B : out Board_Type; ID : in Integer) is
      X : Brick_Type;
   begin
      for W in 1..15 loop
	 for Z in 1..15 loop
	    Receive(X, ID);
	    B(W)(Z) := X;
	 end loop;
      end loop;
      
   end Receive;
   
   procedure Send (B : in Board_Type; ID : in Integer) is
   begin
      for W in 1..15 loop
	 for Z in 1..15 loop
	    Send(B(W)(Z), ID);
	 end loop;
      end loop;
      
   end Send;
   
   
   procedure Receive_Command(Command : out Command_Type; ID : in Integer) is
      T : String(1..100);
      X : Integer;
   begin
      if ID = 1 then
	 Get_Line(Socket1, T, X);
      elsif ID = 2 then
	 Get_Line(Socket2, T, X);
      elsif ID = 2 then
	 Get_Line(Socket3, T, X);
      elsif ID = 2 then
	 Get_Line(Socket4, T, X);
      end if;
      Command := T(1..6);
   end Receive_Command;
   
   
   ------------------ EJ RANDOM JUST NU PGA TEST ----------------
   function R_Brick return Brick_Type is
      B : Brick_Type;
   begin
      B.C := ' ';
      B.Points := 1;
      B.Marked := False;
      B.Bonus := 1;
      B.X := 4;
      B.Y := 5;
      return B;
   end R_Brick;
   
   function R_Player_Brick return Own_Board_Type is
      Arr : Own_Board_Type;
   begin
      for I in 1..7 loop
	 Arr(I) := R_Brick;
      end loop;
      return Arr;
   end R_Player_Brick;
   

   Lyssnare  : Listener_Type;
   
   Player1, Player2, Player3, Player4 : Player_Type;
   Board : Board_Type;
   
   I : Integer;
   
   EID : Integer;
   
   Command : Command_Type;
   
begin
   if Argument_Count /= 1 then
      Raise_Exception(Constraint_Error'Identity,
                      "Usage: " & Command_Name & " port");
   end if;

   Put_Line("Väntar på spelare 1 ska ansluta");
   Initiate(Lyssnare, Natural'Value(Argument(1)), Localhost => False);
   Wait_For_Connection(Lyssnare, Socket1);
   Put_Line("Klient ansluten...");
   Send(1, 1);
   Send(R_Player_Brick, 1);
   Receive(Player1, 1);
      
   Receive(I, 1);
   
   Put_Line("Väntar på spelare 2 ska ansluta");
   Wait_For_Connection(Lyssnare, Socket2);
   Put_Line("Klient ansluten...");
   Send(2, 2);
   Send(R_Player_Brick, 2);
   Receive(Player2, 2);
   
   if I > 2 then
      Put_Line("Väntar på spelare 3 ska ansluta");
      Wait_For_Connection(Lyssnare, Socket3);
      Put_Line("Klient ansluten...");
      Send(3, 3);
      Send(R_Player_Brick, 3);
      Receive(Player3, 3);
   end if;
   
   if I = 4 then
      Put_Line("Väntar på spelare 4 ska ansluta");
      Wait_For_Connection(Lyssnare, Socket4);
      Put_Line("Klient ansluten...");
      Send(4, 4);
      Send(R_Player_Brick, 4);
      Receive(Player4, 4);
   end if;
   
   
   loop
      
      Receive_Command(Command, EID);
      
   end loop;
   
   Close(Socket1);
   Close(Socket2);
   Close(Socket3);
   Close(Socket4);
   
exception
   --| Lite felhantering       
   when Constraint_Error =>
      Put_Line("Du matade inte in en parameter innehÃ¥llande portnummer");
      
   when others => --| kanske end_error eller socket_error, det betyder att
		  --| klienten stÃ¤ngt sin socket. DÃ¥ skall den stÃ¤ngas Ã¤ven
		  --| hÃ¤r.
      Put_Line("Nu dog klienten");
      Close(Socket1);
end Server;
