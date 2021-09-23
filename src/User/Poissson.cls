/// Description
Class User.Poisson Extends User.Animal
{

/// Description
Property Nom As %String;

/// Description
Method Nager() As %Status
{
        Set sc = $$$OK
        // do something
        Return sc
}

/// Description
Method Parler(pMot As %String = "") As %Status
{
       if (pMot = ""){
           Write "Bonjour"
       } 
       else {
           Write "Bonjour"_pMot
       } 

        Return $$$OK
}

/// Description
Storage Default
{
<Data name="PoissonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nom</Value>
</Value>
</Data>
<DataLocation>^User.PoissonD</DataLocation>
<DefaultData>PoissonDefaultData</DefaultData>
<Description>
<![CDATA[Description]]></Description>
<IdLocation>^User.PoissonD</IdLocation>
<IndexLocation>^User.PoissonI</IndexLocation>
<StreamLocation>^User.PoissonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
