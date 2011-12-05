declare Player Move in

%% Function for adding item into Bag

fun {AddToBag Bag Elem Nbr}
   GoToEndOfBag Add I in 
   fun {GoToEndOfBag Bag I}
      case Bag of nil then I
      [] H|L then  {GoToEndOfBag L I+1}
      end
   end

   fun {Add Bag Elem I}
      if I == 0 then Bag
      else {Add Elem|Bag I-1}  
   end
      I = {GoToEndOfBag Bag 0}
      if I >= nbr then {Add Bag Elem nbr}
      else then {Add Bag Elem I}
      end

end

%% Function for move player
fun {Move State Pos NewBrainState}
   local X Y in
      %% Security against cheating about Speed of move X
      if Pos.x >= 0 then X = 1
      else if Pos.x <= 0 then X = -1
	   else X = 0 end
      end
       %% Security against cheating about Speed of move Y
      if Pos.y >= 0 then Y = 1
      else if Pos.y <= 0 then Y = -1
	   else Y = 0 end
      end
       %% return New state of the player
      player(pid:State.pid x:State.x+X y:State.y+Y bag:State.bag weapon:State.weapon brainstate:NewBrainState action:move)
   end
end

%% Function for exploit resources
fun {Exploit State Env Elem NewBrainState}
   Bag in
   if Env.board.(State.y).(State.x) == Elem then
      Bag = {AddToBag State.bag Elem 1}
      player(pid:State.pid x:State.x y:State.y bag:Bag weapon:State.weapon brainstate:NewBrainState action:exploit)
   else
     State
   end
end
 %% Function for steal resources 

fun {Steal State Type NewBrainState Server}
   X Bag in
   {Send Server steal(State X)}
   Bag = {AddToBag State.bag Elem X}
   player(pid:State.pid x:State.x y:State.y bag:Bag weapon:State.weapon brainstate:NewBrainState action:steal)   
end
   
%% Build anything

fun {Build State Elem NewBrainState Server}
   case Elem of  
%% Main Player recursion   
fun {Player StaticEnv Init}
  
   fun {Pl Brain}
      fun {$ Msg}
	 BrainRep in
	 case Msg of getNewState(State NewState Env Server) then
	    
	    BrainRep = {Brain Env  State.brainstate}
	    
	    case BrainRep.1 of nonop then skip       
	    [] move(Pos)        then NewState = {Move State Pos BrainRep.2.1}
	    [] exploit(Elem)    then NewState = {Exploit State Env Elem BrainRep.2.1}
	    [] steal(Type)      then NewState = {Steal State Type BrainRep.2.1 Server}
	    [] build(Elem)      then NewState = {Build State Elem BrainRep.2.1 Server}
	    end
	    
      end
   end

   Br = {CreateBrain StaticEnv Init}
   {NewPortObject2 {Pl Brain}}
	    
end
