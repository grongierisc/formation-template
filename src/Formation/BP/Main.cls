/// 
Class Formation.BP.Main Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='MsgRequest' type='Formation.Msg.FormationInsertRequest' instantiate='0' />
</context>
<sequence xend='200' yend='450' >
<transform name='RM To Msg' class='Formation.DT.FormationTransformation' source='request' target='context.MsgRequest' xpos='200' ypos='250' />
<call name='Insert' target='Formation.BO.LocalBDD' async='1' xpos='200' ypos='350' >
<request type='Formation.Msg.FormationInsertRequest' >
<assign property="callrequest" value="context.MsgRequest" action="set" />
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
