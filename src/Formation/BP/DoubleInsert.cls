/// 
Class Formation.BP.DoubleInsert Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Formation.RM.Csv.Record' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='Msg' type='Formation.Msg.FormationInsertRequest' instantiate='0' />
<property name='Double' type='%Boolean' instantiate='0' />
</context>
<sequence xend='200' yend='800' >
<transform name='RmToMsg' class='Formation.DT.RmToMsg' source='request' target='context.Msg' xpos='200' ypos='250' />
<call name='Call BO' target='Formation.BO.LocalBDD' async='0' xpos='200' ypos='350' >
<request type='Formation.Msg.FormationInsertRequest' >
<assign property="callrequest" value="context.Msg" action="set" />
</request>
<response type='Formation.Msg.FormationInsertResponse' >
<assign property="context.Double" value="callresponse.Double" action="set" />
</response>
</call>
<if name='Double' condition='context.Double' xpos='200' ypos='450' xend='200' yend='700' >
<true>
<call name='Call Remote BO' target='Formation.BO.RemoteBDD' async='1' xpos='335' ypos='600' >
<request type='Formation.Msg.FormationInsertRequest' >
<assign property="callrequest" value="context.Msg" action="set" />
</request>
<response type='Ens.Response' />
</call>
</true>
</if>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
