/// 
Class Formation.BP.Rest Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Formation.Msg.FormationRestActionRequest' response='Formation.Msg.FromationRestActionResponse' height='2000' width='2000' >
<sequence xend='200' yend='600' >
<if name='if Post' condition='request.Verbe = "Post"' xpos='200' ypos='250' xend='200' yend='500' >
<true>
<call name='Post' target='Formation.BO.LocalBDD' async='0' xpos='470' ypos='400' >
<request type='Formation.Msg.FormationInsertRequest' >
<assign property="callrequest.Formation.Nom" value="request.Formation.Nom" action="set" />
<assign property="callrequest.Formation.Salle" value="request.Formation.Salle" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</true>
<false>
<call name='Get' target='Formation.BO.LocalBDD' async='0' xpos='200' ypos='400' >
<request type='Formation.Msg.FormationGetByIdRequest' >
<assign property="callrequest.Id" value="request.Id" action="set" />
</request>
<response type='Formation.Msg.FormationGetByIdResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</false>
</if>
</sequence>
</process>
}


}
