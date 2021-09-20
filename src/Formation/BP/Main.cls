/// 
Class Formation.BP.Main Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Formation.RM.Csv.Record' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='Msg' type='Formation.Msg.FormationInsertRequest' instantiate='0' />
</context>
<sequence xend='200' yend='450' >
<transform name='RmToMsg' class='Formation.DT.RmToMsg' source='request' target='context.Msg' xpos='200' ypos='250' />
<call name='Insert Local BDD' target='Formation.BO.LocalBDD' async='1' xpos='200' ypos='350' >
<request type='Formation.Msg.FormationInsertRequest' >
<assign property="callrequest" value="context.Msg" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}


}
