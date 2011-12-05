define Base in

   fun {Base Init Environment}
      fun {BaseAbstract Team}
	 proc {$ Msg}
	    ISteal in
	    case Msg of getResource(Resource,TSteal) then
	       
	       {Send Environment steal(Ressource,TSteal,Team)}
	     
	    [] drop(Ressource) then

	       {Send Environment drop(Ressource,Team)}

	    end
	    