Class Formation.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Formation.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Formation.BO.LocalBDD" Category="" ClassName="Formation.BO.LocalBDD" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="EnsLib.RecordMap.Service.FileService" Category="" ClassName="EnsLib.RecordMap.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RecordMap">Formation.RM.Csv</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Formation.BP.InsertLocalBDD</Setting>
    <Setting Target="Adapter" Name="FilePath">/tmp/iris/misc/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.csv</Setting>
  </Item>
  <Item Name="Formation.BP.InsertLocalBDD" Category="" ClassName="Formation.BP.InsertLocalBDD" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
