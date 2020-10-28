Class Formation.Msg.FormationSelectResponse Extends Ens.Response
{

Property ListFormation As list Of Formation.Obj.Formation;

Storage Default
{
<Data name="FormationSelectResponseDefaultData">
<Subscript>"FormationSelectResponse"</Subscript>
<Value name="1">
<Value>ListFormation</Value>
</Value>
</Data>
<DefaultData>FormationSelectResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
