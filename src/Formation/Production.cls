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
    <Setting Target="Host" Name="TargetConfigNames">Formation.BP.DoubleInsert</Setting>
    <Setting Target="Adapter" Name="FilePath">/tmp/iris/misc/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.csv</Setting>
  </Item>
  <Item Name="Formation.BP.Main" Category="" ClassName="Formation.BP.Main" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Formation.BO.RemoteBDD" Category="" ClassName="Formation.BO.RemoteBDD" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">jdbc:postgresql://db:5432/DemoData</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/tmp/iris/postgresql-42.2.14.jar</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">org.postgresql.Driver</Setting>
    <Setting Target="Adapter" Name="Credentials">Postgre</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
  </Item>
  <Item Name="EnsLib.JavaGateway.Service" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Formation.BS.RestInput" Category="" ClassName="Formation.BS.RestInput" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">Formation.BO.LocalBDD</Setting>
  </Item>
  <Item Name="Formation.BP.DoubleInsert" Category="" ClassName="Formation.BP.DoubleInsert" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
