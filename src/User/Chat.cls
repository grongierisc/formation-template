/// Description une classe de chat en formation
Class User.Chat Extends User.Animal
{

/// Description
Property SurNom As %String;

/// Description
Property IDFamille As %Integer;

/// Description
/// Description
Method Toto() As %Status
{
    Set sc = $$$OK
     Write $THIS.Nom
    Return sc
}

/// Description
Method GetNom() As %Status
{
  return $THIS.Nom
}

/// Description
Method MonSurNom() As %Status
{
    Set sc = $$$OK
       Write $THIS.SurNom
    Return sc
}

/// Description
Method ChangerNom(pObjet, pNom) As %Status
{
    set pObjet.Nom = pNom
    Write pObjet.Nom
   
    Return $$$OK
}

Method Manger(pPoisson As %Persistent) As %Status
{
    if (pPoisson.%IsA("User.Poisson")){
        Write "Miamm"
        kill tPoisson
    }
    else{
        Write "Beark"
    }
    Return $$$OK
}

Storage Default
{
<Data name="ChatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nom</Value>
</Value>
<Value name="3">
<Value>SurNom</Value>
</Value>
<Value name="4">
<Value>IDFamille</Value>
</Value>
</Data>
<DataLocation>^User.ChatD</DataLocation>
<DefaultData>ChatDefaultData</DefaultData>
<IdLocation>^User.ChatD</IdLocation>
<IndexLocation>^User.ChatI</IndexLocation>
<StreamLocation>^User.ChatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
