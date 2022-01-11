/// 
Class Formation.BP.InsertLocalBDD Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Formation.RM.Csv.Record' response='Ens.StringResponse' height='2000' width='2000' >
<context>
<property name='toto' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='Formation' type='Formation.Msg.FormationInsertRequest' instantiate='0' />
</context>
<sequence xend='200' yend='450' >
<transform name='Rm To Msg' class='Formation.DT.RmToMsg' source='request' target='context.Formation' xpos='275' ypos='219' />
<call name='Call Local' target='Formation.BO.LocalBDD' async='0' xpos='200' ypos='350' >
<request type='Formation.Msg.FormationInsertRequest' >
<assign property="callrequest" value="context.Formation" action="set" />
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
