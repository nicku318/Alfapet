with Ada.Command_Line;    use Ada.Command_Line;
with Ada.Exceptions;      use Ada.Exceptions;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with TJa.Sockets;         use TJa.Sockets;

procedure Klient is
   
   
   type Brick_Type is 
      record
	 C : Character := ' ';
	 Points : Integer := 0;
	 Marked : Boolean := False;
	 Bonus : Integer := 1;
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
	    
   Socket : Socket_Type;
   
   subtype Command_Type is String(1..6);
   
   procedure Get( P : out Player_Type; ID : in Integer) is
      Name : String(1..30);
      NameL : Integer;
   begin
      Put("Välkommen till Alfapet, vad är ditt namn max 30 tecken? ");
      Get_Line(Name, NameL);
      P.ID := ID;
      P.Name := Name;
      P.NameL := NameL;
   end Get;
   
   procedure Send( C : in Character) is 
   begin
      Put_Line(Socket, C);
   end Send;
   
   procedure Send( I : in Integer) is
   begin
      Put_Line(Socket, I);
   end Send;
   
   procedure Receive (C : out Character) is
      T : String(1..100);
      X : Integer;
   begin
      Get_Line(Socket, T, X);
      C := T(1);
   end Receive;
   
   procedure Receive (I : out Integer) is
      T : String(1..100);
      X : Integer;
   begin
      Get_Line(Socket, T, X);
      I := Integer'Value(T(1..X));
   end Receive;
   
   procedure Receive (B : out Boolean) is
      T : String(1..100);
      X : Integer;
   begin
      Get_Line(Socket, T, X);
      if T(1..4) = "True" then
	 B := True;
      elsif T(1..5) = "False" then
	 B := False;
      end if;
   end Receive;
   
   procedure Send (B : in Boolean) is
   begin
      if B = True then
	 Put_Line(Socket, "True");
      elsif B = False then
	 Put_Line(Socket, "False");
      end if;
   end Send;
   
   procedure Receive (B : out Brick_Type) is
      C : Character;
      I : Integer;
      M : Boolean;
   begin
      
	 Receive(C);
	 B.C := C;
	 Receive(I);
	 B.Points := I;
	 Receive(M);
	 B.Marked := M;
	 Receive(I);
	 B.Bonus := I;
	 Receive(I);
	 B.X := I;
	 Receive(I);
	 B.Y := I;
      
   end Receive;
   
   procedure Send (B : in Brick_Type) is
   begin
      
      Send(B.C);
      Send(B.Points);
      Send(B.Marked);
      Send(B.Bonus);
      Send(B.X);
      Send(B.Y);
      
   end Send;
   
   procedure Receive (B : out Own_Board_Type) is
      X : Brick_Type;
   begin
      
      for Z in 1..7 loop
	 Receive(X);
	 B(Z) := X;
      end loop;
      
   end Receive;
   
   procedure Send (B : in Own_Board_Type) is
   begin
      
      for Z in 1..7 loop
	 Send(B(Z));
      end loop;
      
   end Send;
   
   procedure Receive (P : out Player_Type) is
      Name : String(1..30);
      NameL : Integer;
      Points : Integer := 0;
      Brick : Own_Board_Type;
      Id : Integer;
   begin
      Get_Line(Socket, Name, NameL);
      P.Name := Name;
      P.NameL := NameL;
      Receive(Points);
      P.Points := Points;
      Receive(Brick);
      P.Brick := Brick;
      Receive(Id);
      P.Id := Id;
   end Receive;
   
   procedure Send (P : in Player_Type) is
   begin
      Put_Line(Socket, P.Name(1..P.NameL));
      Send(P.Points);
      Send(P.Brick);
      Send(P.ID);
   end Send;
   
   
   procedure Receive (B : out Board_Type) is
      X : Brick_Type;
   begin
      for W in 1..15 loop
	 for Z in 1..15 loop
	    Receive(X);
	    B(W)(Z) := X;
	 end loop;
      end loop;
      
   end Receive;
   
   procedure Send (B : in Board_Type) is
   begin
      for W in 1..15 loop
	 for Z in 1..15 loop
	    Send(B(W)(Z));
	 end loop;
      end loop;
      
   end Send;
   
   
   procedure Receive_Command(Command : out Command_Type) is
      T : String(1..100);
      X : Integer;
   begin
      Get_Line(Socket, T, X);
      Command := T(1..6);
   end Receive_Command;
   
   -- Här kommer globala variabler pga många upprepningar förlättar det att endast köra programmet i nedanstående procedurer som pratar med varandra
   
   Player_ID : Integer;
   
   Player1, Player2, Player3, Player4 : Player_Type;
   Board : Board_Type;
   
   
   
   --procedure Get_Data is
      
   --begin
      
   --end Get_Data;
   
   Command : Command_Type;
   
   I : Integer;

begin
   if Argument_Count /= 2 then
      Raise_Exception(Constraint_Error'Identity,
                      "Usage: " & Command_Name & " remotehost remoteport");
   end if;

   Initiate(Socket);
   Connect(Socket, Argument(1), Positive'Value(Argument(2)));
   
   Receive(Player_ID);
   Receive(Player1.Brick);
   Get(Player1, Player_ID);
   Send(Player1);
   
   while Player_ID = 1 loop
      Put("Hur många spelare ska det vara?");
      Get(I);
      if I > 1 and I < 5 then
	 Send(I);
	 exit;
      end if;
   end loop;
   
   Put_Line("Väntar på spelare");
   
   
   loop
      
      Receive_Command(Command);
      
      
      
   end loop;
   
   Close(Socket);



end Klient;
