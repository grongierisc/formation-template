/// 
Class Formation.BP.Main Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Formation.RM.csv.Record' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='msg' type='Formation.Msg.FormationInsertRequest' instantiate='0' />
</context>
<sequence xend='200' yend='550' >
<call name='Insert bis' target='Formation.BO.RemoteBDD' async='0' xpos='200' ypos='250' >
<request type='Formation.Msg.FormationInsertRequest' >
<assign property="callrequest.Formation.Nom" value="&quot;static&quot;" action="set" />
<assign property="callrequest.Formation.Salle" value="&quot;static&quot;" action="set" />
</request>
<response type='Ens.Response' />
</call>
<transform name='RmToMsg' class='Formation.DT.RmToMsg' source='request' target='context.msg' xpos='200' ypos='350' />
<call name='Insert in Local BDD' target='Formation.BO.LocalBDD' async='0' xpos='200' ypos='450' >
<request type='Formation.Msg.FormationInsertRequest' >
<assign property="callrequest" value="context.msg" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}


}
