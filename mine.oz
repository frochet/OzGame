declare NewPortObject2 Mine TM1 TM2 TM3 TP in

%% Using book function NewPortObject2
fun {NewPortObject2 Proc}
   Sin in
   thread for Msg in Sin do {Proc Msg} end end
   {NewPort Sin}
end


fun {Mine Init}
  AbstractMine SpMine Min in
   fun {AbstractMine Type}
      %% Curying function (see ref book at page n°194)
      proc {$ Msg}
	 case Msg of getResource(Client) then
	    {Send Client Type(1)}
	 end
      end
   end
   %% Initialize NewPortObject With configurated Mine
   {NewPortObject2 {AbstractMine Init}}
end

TM1 = {Mine food}
TM2 = {Mine steel}
TM3 = {Mine wood}

TP = {NewPortObject2 Browse}

{Send TM1 getResource(TP)}
{Send TM2 getResource(TP)}
{Send TM3 getResource(TP)}


      