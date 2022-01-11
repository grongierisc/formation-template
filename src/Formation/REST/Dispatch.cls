Class Formation.REST.Dispatch Extends %CSP.REST
{

/// Ignore any writes done directly by the REST method.
Parameter IgnoreWrites = 0;

/// By default convert the input stream to Unicode
Parameter CONVERTINPUTSTREAM = 1;

/// The default response charset is utf-8
Parameter CHARSET = "utf-8";

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <!-- Get this spec -->
  <Route Url="/" Method="post" Call="import" />
  <Route Url="/:id" Method="get" Call="get" />
  <Route Url="/:id" Method="put" Call="update" />
</Routes>
}

/// Description
ClassMethod update(id As %String) As %Status
{
  Set sc = $$$OK
  
  if ##class(Formation.Table.Formation).%ExistsId(id) {
    set dyna = {}.%FromJSON(%request.Content)
    set tFormation = ##class(Formation.Table.Formation).%OpenId(id)
    set tFormation.Name = dyna.name
    set tFormation.Salle = dyna.salle
    do tFormation.%Save()
  }

  Return sc
}

/// Description
ClassMethod toto(pTiti As %String, Output autre, Output ref) As %Status
{
  Set sc = $$$OK
  set ref = ##class(Formation.Msg.FormationSelectByIdResponse).%New()
  set ref.Formation.Salle = "toto"

  Return sc
}

/// Description
ClassMethod get(id As %String) As %Status
{
  Set sc = $$$OK

  set tMsg = ##class(Formation.Msg.FormationSelectByIdRequest).%New()
  set tMsg.ForamtionID = id

  $$$ThrowOnError(##class(Ens.Director).CreateBusinessService("Formation.BS.RestService",.tService))
  
  $$$ThrowOnError(tService.SendToBo(tMsg,.output))

  set outputDyna = {}
  set outputDyna.salle = output.Formation.Salle
  set outputDyna.name = output.Formation.Nom

  w outputDyna.%ToJSON()

  Return sc
}

/// Get this spec
ClassMethod import() As %Status
{
  set tSc = $$$OK

  Try {

      set dyna = {}.%FromJSON(%request.Content)

      set tMsg = ##class(Formation.RM.Csv.Record).%New()

      set tMsg.nom = dyna.name
      set tMsg.salle = dyna.salle
      set tMsg.check = dyna.check

      $$$ThrowOnError(##class(Ens.Director).CreateBusinessService("Formation.BS.RestService",.tService))
      
      $$$ThrowOnError(tService.SendToBP(tMsg,.output))

      set outputDyna = {}
      set outputDyna.result = output.StringValue

      w outputDyna.%ToJSON()

  } Catch ex {
      set tSc = ex.AsStatus()
  }

  Quit tSc
}

}
