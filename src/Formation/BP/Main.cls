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
<sequence xend='696' yend='479' >
<transform name='RmToMsg' class='Formation.DT.RmToMsg' source='request' target='context.Msg' xpos='727' ypos='239' />
<call name='Insert Local BDD' target='Formation.BO.LocalBDD' async='1' xpos='704' ypos='361' >
<request type='Formation.Msg.FormationInsertRequest' >
<assign property="callrequest" value="context.Msg" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
