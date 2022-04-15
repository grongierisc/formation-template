Class Formation.BO.File Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

Property Adapter As EnsLib.File.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method WriteLine(pRequest As Formation.Msg.FormationInsertRequest, Output pResponse As Ens.Response) As %Status
{

    set tSc = $$$OK

    set line = "nom : "_pRequest.Formation.Nom_",salle : "_pRequest.Formation.Salle

    set ..Adapter.FilePath = "/tmp/"

    $$$ThrowOnError($this.Adapter.PutLine("myfile.txt",line))

    return tSc
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Formation.Msg.FormationInsertRequest"> 
		<Method>WriteLine</Method>
	</MapItem>
</MapItems>
}

}
