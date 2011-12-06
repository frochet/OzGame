functor
import
   Application % Allows to terminate the application
   System 
   QTk at 'x-oz://system/wp/QTk.ozf'
   OS
define

   %% Default values
   HEIGHT   = 14
   WIDTH    = 12
   
   %% Posible arguments
   Args = {Application.getArgs
	   record(
	      height(single char:&h type:int default:HEIGHT)
	      width(single char:&w type:int default:WIDTH)
	      )}
   
   fun {NewActive Class Init}
      Obj = {New Class Init}
      P
   in
      thread S in
	 {NewPort S P}
	 for M in S do {Obj M} end
      end
	 proc {$ M} {Send P M} end
   end

   fun {GetInt L Acc}
      case L of nil then Acc
      [] H|T then {GetInt T Acc*10 + H-48} 
      end
   end
   % X et Y des listes de coordonnées
   proc {DrawImg X Y Img}
      case [H]#[H2] of X#Y then
	 {@grid configure(label(image:Img) row:H column:H2)}
      [] H|T#H2|T2 then
	 {@grid configure(label(image:Img) row:H column:H2)}
	 {DrawImg T T2 Img}
      []nil#nil then skip
      end
   end
      
   end
   class Gui
      attr grid
	 food steel wood stone
	 foodImg steelImg woodImg stoneImg playerImg homeImg bg 
      meth init(H W)
	 CD = {OS.getCWD}
	 Grid Food Steel Stone Wood H2 W2 StaticEnv
      in
	 {ConfigureGui gerboardsize(H2 W2)}
	 {{QTk.build td(
		grid(handle:Grid bg:white)
			lr(label(text:"Food :") label(text:"0" handle: Food)
			   label(text:"Wood :") label(text:"0" handle: Wood)
			   label(text:"Steel :") label(text:"0" handle: Steel)
			   label(text:"Stone :") label(text:"0" handle: Stone)
			   button(text:"Quit" action:proc {$} {Application.exit 0} end)
			  )
			)} show}
	 for I in 1..H-1 do
	    {Grid configure(lrline column:1 columnspan:W+W-1 row:I*2 sticky:we)}
	 end
	 for I in 1..W-1 do
	    {Grid configure(tdline  row:1 rowspan:H+H-1 column:I*2 sticky:ns)}
	 end
	 for I in 1..W do
	    {Grid columnconfigure(I+I-1 minsize:43)}
	 end
	 for I in 1..H do
	    {Grid rowconfigure(I+I-1 minsize:43)}
	 end
	 grid := Grid
	 food := Food
	 steel := Steel
	 wood := Wood
	 stone := Stone
	 foodImg := {QTk.newImage photo(file:CD#'/food.gif')}
	 steelImg := {QTk.newImage photo(file:CD#'/steel.gif')}
	 woodImg := {QTk.newImage photo(file:CD#'/wood.gif')}
	 stoneImg := {QTk.newImage photo(file:CD#'/stone.gif')}
	 homeImg := {QTk.newImage photo(file:CD#'/home.gif')}
	 bg := {QTk.newImage photo(file:CD#'/white.gif')}
       % Envoyer message a l'environement pour demander information sur le jeu
	 {Send GuiToEnviCommunication getconfiguration(StaticEnv)}
       % Parcourir l'environnement et dessiner la carte.
	 for I in 1..{Record.width StaticEnv.board}
	    for J in 1..{Record.width StaticEnv.board.1}
	       if StaticEnv.board.I.J == field then
		  {@grid configure(label(image: @foodImg) row: I column: J)}
	       elseif StaticEnv.board.I.J == forest then
		  {@grid configure(label(image: @woodImg) row: I column: J)}
	       elseif StaticEnv.board.I.J == quarry then
		  {@grid configure(label(image: @stoneImg) row: I column: J)}
	       elseif StaticEnv.board.I.J == mine then
		  {@grid configure(label(image: @steelImg) row: I column: J)}
	       elseif StaticEnv.board.I.J == home then
		  {@grid configure(label(image: @homeImg) row: I column: J)}
		  %dessiner ici mes villageois de depart.
	       end
	    end
	 end
      end
      meth changeFood(X)
	 S in
	 S = @food
	 if W < 0 then W in
	    W = 0
	    {S set(""#W)}
	 else
	    {S set(""#W)}
	 end
      end
      meth changeStone(W)
	 S in
	 S = @stone
	 if W < 0 then W in
	    W = 0
	    {S set(""#W)}
	 else
	    {S set(""#W)}
	 end
      end
      meth changeSteel(W)
	 S in
	 S = @steel
	 if W < 0 then W in
	    W = 0
	    {S set(""#W)}
	 else
	    {S set(""#W)}
	 end
      end
      meth changeWood(X)
	 S in
	 S = @wood
	 if W < 0 then W in
	    W = 0
	    {S set(""#W)}
	 else
	    {S set(""#W)}
	 end
      end
   end

   %% create the GUI object
   G = {NewActive Gui init(Args.height Args.width)}
   %{G score(a 4)}
  
   {G changeStone(1)}
   {G changeSteel(10)}
   {Delay 1000}
   {G changeSteel(24)}
end



   