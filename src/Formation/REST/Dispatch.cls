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
  <Route Url="/formation" Method="post" Call="import" />
  <Route Url="/formation/:id" Method="get" Call="get" />
   <Route Url="/formation/:id" Method="put" Call="Update" />
 <Route Url="/formation/:id" Method="delete" Call="Delete" />
</Routes>
}

/// Description
ClassMethod Update(id As %Integer) As %Status
{
  Set sc = $$$OK
    set tBsName = "Formation.BS.RestInput"
    set tMsg = ##class(Formation.Msg.FormationUpdateByIdRequest).%New()
      set body = $zcvt(%request.Content.Read(),"I","UTF8")
      set dyna = {}.%FromJSON(body)

      set tMsg.ID = id
      set tMsg.Nom = dyna.nom
      set tMsg.Salle = dyna.salle

           $$$ThrowOnError(##class(Ens.Director).CreateBusinessService(tBsName,.tService))
      
          $$$ThrowOnError(tService.ProcessInput(tMsg,.output))

  Return sc
}

/// Description
ClassMethod Delete(id As %Integer) As %Status
{
  Set sc = $$$OK
   set tBsName = "Formation.BS.RestInput"
    set tMsg = ##class(Formation.Msg.FormationDeleteByIdRequest).%New()
    
      set tMsg.ID = id
    
           $$$ThrowOnError(##class(Ens.Director).CreateBusinessService(tBsName,.tService))
      
          $$$ThrowOnError(tService.ProcessInput(tMsg,.output))
  Return sc
}

/// Description
ClassMethod get(id As %Integer) As %Status
{
     set tSc = $$$OK
     set tBsName = "Formation.BS.RestInput"
      set tMsg = ##class(Formation.Msg.FormationSelectByIdRequest).%New()
      set tMsg.ID = id

          $$$ThrowOnError(##class(Ens.Director).CreateBusinessService(tBsName,.tService))
      
          $$$ThrowOnError(tService.ProcessInput(tMsg,.output))

          set dyna = {}
          //set dyna = ##class(%DynamicObject).%New()

          set dyna.Prenom = output.Formation.Nom
           set dyna.salle = output.Formation.Salle
           W dyna.%ToJSON()
           return tSc
}

/// Get this spec
ClassMethod import() As %Status
{
  set tSc = $$$OK

  Try {

        set tBsName = "Formation.BS.RestInput"
      set tMsg = ##class(Formation.Msg.FormationInsertRequest).%New()

      set body = $zcvt(%request.Content.Read(),"I","UTF8")
      set dyna = {}.%FromJSON(body)

      set tFormation = ##class(Formation.Obj.Formation).%New()
      set tFormation.Nom = dyna.nom
      set tFormation.Salle = dyna.salle

      set tMsg.Formation = tFormation
      
      $$$ThrowOnError(##class(Ens.Director).CreateBusinessService(tBsName,.tService))
      
      $$$ThrowOnError(tService.ProcessInput(tMsg,.output))
      set dyna = {}
      set dyna.ID = output.ID
      W dyna.%ToJSON()

  } Catch ex {
      set tSc = ex.AsStatus()
  }

  Quit tSc
}

}
