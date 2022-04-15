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
  <Route Url="/import" Method="post" Call="import" />
  <Route Url="/get/:id" Method="get" Call="get" />
</Routes>
}

/// Get this spec
ClassMethod import() As %Status
{
  set tSc = $$$OK

  Try {

      set tBsName = "Formation.BS.RestInput"
      set tMsg = ##class(Formation.Msg.FormationRestActionRequest).%New()
      set tMsg.Verbe = "Post"

      set body = $zcvt(%request.Content.Read(),"I","UTF8")
      set dyna = {}.%FromJSON(body)

      set tFormation = ##class(Formation.Obj.Formation).%New()
      set tFormation.Nom = dyna.nom
      set tFormation.Salle = dyna.salle

      set tMsg.Formation = tFormation
      
      $$$ThrowOnError(##class(Ens.Director).CreateBusinessService(tBsName,.tService))
      
      $$$ThrowOnError(tService.ProcessInput(tMsg,.output))

      set dyna = {}
      set dyna.id = output.Id
      Set %response.ContentType = ..#CONTENTTYPEJSON
      w dyna.%ToJSON()

  } Catch ex {
      set tSc = ex.AsStatus()
  }

  Quit tSc
}

ClassMethod get(id)
{
  set tSc = $$$OK

  Try {

      set tBsName = "Formation.BS.RestInput"
      set tMsg = ##class(Formation.Msg.FormationRestActionRequest).%New()
      set tMsg.Id = id
      set tMsg.Verbe = "Get"

      $$$ThrowOnError(##class(Ens.Director).CreateBusinessService(tBsName,.tService))
      
      $$$ThrowOnError(tService.ProcessInput(tMsg,.output))

      set dyna = {}
      set dyna.Nom = output.formation.Nom
      set dyna.Salle = output.formation.Salle
      Set %response.ContentType = ..#CONTENTTYPEJSON
      write dyna.%ToJSON()

  } Catch ex {
      set tSc = ex.AsStatus()
  }

  Quit tSc
}

}
