 # 1. **Ensemble / Interoperability Formation**

 The goal of this formation is to learn InterSystems' interoperability framework, and particularly the use of: 
* Productions
* Messages
* Business Operations
* Adapters
* Business Processes
* Business Services
* REST Services and Operations


**TABLE OF CONTENTS:**

- [1. **Ensemble / Interoperability Formation**](#1-ensemble--interoperability-formation)
- [2. Framework](#2-framework)
- [3. Adapting the framework](#3-adapting-the-framework)
- [4. Prerequisites](#4-prerequisites)
- [5. Setting up](#5-setting-up)
  - [5.1. Docker containers](#51-docker-containers)
  - [5.2. Management Portal](#52-management-portal)
  - [5.3. Saving progress](#53-saving-progress)
  - [5.4. Exporting progress](#54-Part-about-vscode-inside-container-and-irisscript)
- [6. Productions](#6-productions)
- [7. Operations](#7-operations)
  - [7.1. Creating our storage classes](#71-creating-our-storage-classes)
  - [7.2. Creating our message classes](#72-creating-our-message-classes)
  - [7.3. Creating our operations](#73-creating-our-operations)
  - [7.4. Adding the operations to the production](#74-adding-the-operations-to-the-production)
  - [7.5. Testing](#75-testing)
- [8. Business Processes](#8-business-processes)
  - [8.1. Simple BP](#81-simple-bp)
  - [8.2. Adding the process to the production](#82-Adding-the-process-to-the-production)
  - [8.3. Testing](#83-testing)
- [9. Business Service](#9-business-service)
  - [9.1. Simple BS](#91-simple-bs)
  - [9.2. Adding the service to the production](#92-Adding-the-service-to-the-production)
  - [9.3. Testing](#93-testing)
- [10. Getting access to an extern database using JDBC](#10-getting-access-to-an-extern-database-using-jdbc)
  - [10.1. Creating our new operation](#101-creating-our-new-operation)
  - [10.2. Configuring the production](#102-configuring-the-production)
  - [10.3. Testing](#103-testing)
  - [10.4. Exercise](#104-exercise)
  - [10.5. Solution](#105-solution)
- [11. REST service](#11-rest-service)
  - [11.1. Creating the service](#111-creating-the-service)
  - [11.2. Adding our BS](#1112-adding-our-bs)
  - [11.3. Testing](#113-testing)
- [Conclusion](#conclusion)

# 2. Framework

This is the IRIS Framework.

![FrameworkFull](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/FrameworkFull.png)

The components inside of IRIS represent a production. Inbound adapters and outbound adapters enable us to use different kind of format as input and output for our databse. The composite applications will give us access to the production through external applications like REST services.

The arrows between them all of this components are **messages**. They can be requests or responses.

# 3. Adapting the framework

In our case, we will read lines in a csv file and save it into the IRIS database. 

We will then add an operation that will enable us to save objects in an extern database too, using JDBC. This database will be located in a docker container, using postgre.

Finally, we will see how to use composite applications to insert new objects in our database or to consult this database (in our case, through a REST service).

The framework adapted to our purpose gives us:

![FrameworkAdapted](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/FrameworkAdapted.png)


# 4. Prerequisites

For this formation, you'll need:
* VSCode: https://code.visualstudio.com/
* The InterSystems addons suite for vscode: https://intersystems-community.github.io/vscode-objectscript/installation/
* The PostGre addon for VSCode.
* Docker: https://docs.docker.com/get-docker/
* The docker addon for VSCode.
# 5. Setting up 


## 5.1. Docker containers


In order to have access to the InterSystems images, we need to go to the following url: http://container.intersystems.com. After connecting with our InterSystems credentials, we will get our password to connect to the registry. In the docker VScode addon, in the image tab, by pressing connect registry and entering the same url as before (http://container.intersystems.com) as a generic registry, we will be asked to give our credentials. The login is the usual one but the password is the one we got from the website.

From there, we should be able to build and compose our containers (with the `docker-compose.yml` and `Dockerfile` files given).

## 5.2. Management Portal

We will open a Management Portal. It will give us access to an webpage where we will be able to create our production. The portal should be located at the url: http://localhost:52775/csp/sys/UtilHome.csp?$NAMESPACE=IRISAPP. You will need the following credentials: 

>LOGIN: SuperUser
>
>PASSWORD: SYS

## 5.3. Saving progress

A part of the things we will be doing will be saved locally, but productions are saved in the docker container. In order to persist all of our progress, we need to export every class that is created through the Management Portal with the InterSystems addon `ObjectScript`:

![ExportProgress](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/ExportProgress.png)

We will have to save our Production(,Record Map, Business Processes and Data Transfromation) this way. After that, when we close our docker container and compose it up again, we will still have all of our progress saved locally (it is, of course, to be done after every change through the portal). To make it accessible to IRIS again we need to compile the exported files (by saving them, InterSystems addons take care of the rest).

## 5.4. Part about vscode inside container and iris.script


# 6. Productions 
We can now create our first production. For this, we will go through the [Interoperability] and [Configure] menus: 

![ProductionMenu](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/ProductionMenu.png)

We then have to press [New], select the [Formation] package and chose a name for our production: 

![ProductionCreation](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/ProductionCreation.png)

Immediatly after creating our production, we will need to click on [Production Settings] just above the [Operations] section. In the right sidebar menu, we will have to activate [Testing Enabled] in the [Development and Debugging] part of the [Settings] tab (don't forget to press [Apply]).

![ProductionTesting](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/ProductionTesting.png)

In this first production we will now add Business Operations.

# 7. Operations

A Business Operation (BO) is a specific operation that will enable us to send requests from IRIS to an external application / system. It can also be used to directly save in IRIS what we want.

We will create those operations in local, that is, in the `python/bo/` file. Saving the files will compile them in IRIS. 

For our first operation we will save the content of a message in the local database.

We need to have a way of storing this message first. 

## 7.1. Creating our storage classes

Storage classes are `dataclass`. We will need to use `misc/init.iris.sql` and `misc/init.sql` in order to create in IRIS the Table `iris.Formation`

In our `python/obj.py` file we have: 
```python
from dataclasses import dataclass

@dataclass
class Formation:

    id:int = None
    nom:str = None
    salle:str = None

@dataclass
class FormationIris:

    name:str = None
    room:str = None
```

The Formation class will be used as a Python object to read a csv and write in a texte file later on, while the FormationIris class will be used as a way to interact with the Iris database.

## 7.2. Creating our message classes

These messages will contain a `Formation` object or a `FormationIris` object, located in the `obj.py` file created in [7.1](#71-creating-our-storage-classes)

Note that messages, requests and responses all inherit from the `grongier.pex.Message` class.

In our `python/msg.py` file we have: 
```python
from dataclasses import dataclass
import grongier.pex

from obj import Formation,FormationIris

@dataclass
class FormationRequest(grongier.pex.Message):

    formation:Formation = None

@dataclass
class FormationIrisRequest(grongier.pex.Message):

    formation:FormationIris = None
```

Again, the FormationRequest class will be used as a message to read a csv and write in a texte file later on, while the FormationIrisRequest class will be used as a message to interact with the Iris database.

## 7.3. Creating our operations

Now that we have all the elements we need, we can create our operations.
Note that any Business Operation inherit from the `grongier.pex.BusinessOperation` class.
In the `python/bo.py` file we have: 
```python
import grongier.pex
import datetime
import os

from msg import FormationIrisRequest
from msg import FormationRequest

class FileOperation(grongier.pex.BusinessOperation):

    def OnInit(self):
        if hasattr(self,'Path'):
            os.chdir(self.Path)

    def OnMessage(self, pRequest):
        if isinstance(pRequest,FormationRequest):
            id = salle = nom = ""

            if (pRequest.formation is not None):
                id = str(pRequest.formation.id)
                salle = pRequest.formation.salle
                nom = pRequest.formation.nom

            line = id+" : "+salle+" : "+nom+" : "

            filename = 'toto.csv'

            self.PutLine(filename, line)
            self.PutLine(filename, " * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *")

        return 


    @staticmethod
    def PutLine(filename,string):
        try:
            with open(filename, "a",encoding="utf-8") as outfile:
                outfile.write(string)
        except Exception as e:
            raise e

class IrisOperation(grongier.pex.BusinessOperation):

    def OnMessage(self, request):
        if isinstance(request,FormationIrisRequest):
            sql = """
            INSERT INTO iris.formation
            ( name, room )
            VALUES( ?, ? )
            """
            iris.sql.exec(sql,request.formation.name,request.formation.room)
        
        return 
```

There is for now no MessageMap method to launch depending on the type of the request (the message sent to the operation) therefore it is needed to use, if necessary to protect the code, multiple if conditions on the message type using for example `isinstance()` as seen in our `bo.py` file.

As we can see, if the FileOperation receive a message of the type `msg.FormationRequest`, the information hold by the message will be written down on the `toto.csv` file.
Note that you could make `filename` a variable with a base value of `toto.csv` that can be change directly onto the management portal by doing :
```python
    def OnInit(self):
        if hasattr(self,'Path'):
            os.chdir(self.Path)
        if not hasattr(self,'Filename'):
          self.Filename = 'toto.csv'
```

As we can see, if the IrisOperation receive a message of the type `msg.FormationIrisRequest`, the information hold by the message will be transformed into an SQL querry and executed by the `iris.sql.exec` IrisPython function. This method will save the message in the IRIS local database.

## 7.4. Adding the operations to the production

We now need to add these operations to the production. For this, we use the Management Portal. By pressing the [+] sign next to [Operations], we have access to the [Business Operation Wizard]. There, we chose the operation classes we just created in the scrolling menu. 

![OperationCreation](https://github.com/LucasEnard/formation-template/blob/python/misc/img/PythonOperationCreation.png)

## 7.5. Testing

Double clicking on the operation will enable us to activate it. After that, by selecting the operation and going in the [Actions] tabs in the right sidebar menu, we should be able to test the operation (if not see the production creation part to activate testings / you may need to start the production if stopped).

By doing so, we will send the operation a message of the type we declared earlier. If all goes well, showing the visual trace will enable us to see what happened between the processes, services and operations. here, we can see the message being sent to the operation by the process, and the operation sending back a response (that is just an empty string).

For IrisOperation you must first access Iris database system and copy/paste `misc/init.iris.sql` to create the table we will be using.
You should get a result like this :
![IrisOperation](https://github.com/LucasEnard/formation-template/blob/python/misc/img/PythonIrisOperationTest.png)

For FileOperation it is to be noted that you must fill the %settings available on the Management Portal as follow ( and you can add in the settings the `filename` if you have followed the `filename` note from [7.3.](#73-creating-our-operations) ) :
![Settings for FileOperation](https://github.com/LucasEnard/formation-template/blob/python/misc/img/SettingsFileOperation.png)

You should get a result like this :
![FileOperation](https://github.com/LucasEnard/formation-template/blob/python/misc/img/ResultsFileOperation.png)



# 8. Business Processes

Business Processes (BP) are the business logic of our production. They are used to process requests or relay those requests to other components of the production.

Business Processes are created in VSCode.

## 8.1. Simple BP

We now have to create a Business Process to process the information coming from our future services and dispatch it accordingly. We are going to create a simple BP that will call our operations.

Since our BP will only redirect information we will call it `bp/Router` and it will be like this :
```python
import grongier.pex

from msg import FormationRequest, FormationIrisRequest
from obj import FormationIris


class Router(grongier.pex.BusinessProcess):

    def OnRequest(self, request):
        if isinstance(request,FormationRequest):
            msg = FormationIrisRequest()
            msg.formation = FormationIris()
            msg.formation.name = request.formation.nom
            msg.formation.room = request.formation.salle
            self.SendRequestSync('Python.FileOperation',request)
            self.SendRequestSync('Python.IrisOperation',msg)

        return 
```
As we can see, if the IrisOperation receive a message of the type `msg.FormationRequest`, the information hold by the message will be send directly to `Python.FileOperation` with the `SendRequestSync` function to be written down on our .txt. We will also create a `msg.FormationIrisRequest` in order to call `Python.IrisOperation` the same way.


## 8.2. Adding the process to the production

We now need to add the process to the production. For this, we use the Management Portal. By pressing the [+] sign next to [Processes], we have access to the [Business Process Wizard]. There, we chose the process class we just created in the scrolling menu. 

## 8.3. Testing

Double clicking on the process will enable us to activate it. After that, by selecting the process and going in the [Actions] tabs in the right sidebar menu, we should be able to test the process (if not see the production creation part to activate testings / you may need to start the production if stopped).

By doing so, we will send the process a message of the type `msg.FormationRequest`.
![RouterTest](https://github.com/LucasEnard/formation-template/blob/python/misc/img/PythonRouterTest.png)

If all goes well, showing the visual trace will enable us to see what happened between the process, services and processes. here, we can see the messages being sent to the operations by the process, and the operations sending back a response.
![RouterResults](https://github.com/LucasEnard/formation-template/blob/python/misc/img/PythonRouterResults.png)

# 9. Business Service

Business Service (BS) are the ins of our production. They are used to gather information and send them to our routers.

## 9.1. Simple BS

We now have to create a Business Service to read a CSV and send each line as a `msg.FormationRequest` to the router.

Since our BS will read a csv we will call it `bs/ServiceCSV` and it will be like this :
```python
import grongier.pex

from dataclass_csv import DataclassReader

from obj import Formation
from msg import FormationRequest

class ServiceCSV(grongier.pex.BusinessService):

    def getAdapterType():
        """
        Name of the registred adaptor
        """
        return "Ens.InboundAdapter"
    
    def OnInit(self):
        if hasattr(self,'Path'):
            self.Path = self.Path
        else:
            self.Path = '/irisdev/app/misc/'
        return

    def OnProcessInput(self,request):

        filename='formation.csv'
        with open(self.Path+filename) as formation_csv:
            reader = DataclassReader(formation_csv, Formation,delimiter=";")
            for row in reader:
                msg = FormationRequest()
                msg.formation = row
                self.SendRequestSync('Python.Router',msg)

        return
```
As we can see, the ServiceCSV gets an InboundAdapter that will allow it to function on it's own and to call OnProcessInput every 5 seconds ( parameter that can be changed in the basic settings of the settings of the service on the Management Portal)

Every 5 seconds, the service will open the `formation.csv` to read each line and create a `msg.FormationRequest` that will be send to the `Python.Router`.


## 9.2. Adding the service to the production

We now need to add the service to the production. For this, we use the Management Portal. By pressing the [+] sign next to [Services], we have access to the [Business service Wizard]. There, we chose the service class we just created in the scrolling menu. 

## 9.3. Testing

Double clicking on the process will enable us to activate it. As explained before, nothing more has to be done here since the service will start on his own every 5 seconds.
If all goes well, showing the visual trace will enable us to see what happened between the process, services and processes. here, we can see the messages being sent to the process by the service, the messages to the operations by the process, and the operations sending back a response.
![RouterResults](https://github.com/LucasEnard/formation-template/blob/python/misc/img/PythonServiceCSVResults.png)

# 10. Getting access to an extern database using JDBC

In this section, we will create an operation to save our objects in an extern database. We will be using the JDBC API, as well as the other docker container that we set up, with postgre on it. 

## 10.1. Creating our new operation

Our new operation, in the file `Formation/BO/RemoteBDD.cls` is as follows: 

````objectscript
Include EnsSQLTypes

Class Formation.BO.RemoteBDD Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InsertRemoteBDD(pRequest As Formation.Msg.FormationInsertRequest, Output pResponse As Ens.StringResponse) As %Status
{
	set tStatus = $$$OK
	
	try{
		set pResponse = ##class(Ens.Response).%New()
		set ^inc = $I(^inc)
		set tInsertSql = "INSERT INTO public.formation (id, nom, salle) VALUES(?, ?, ?)"
		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,tInsertSql,^inc,pRequest.Formation.Nom, pRequest.Formation.Salle ))
	}
	catch exp
	{
		Set tStatus = exp.AsStatus()
	}

	Quit tStatus
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Formation.Msg.FormationInsertRequest"> 
		<Method>InsertRemoteBDD</Method>
	</MapItem>
</MapItems>
}

}
````

This operation is similar to the first one we created. When it will receive a message of the type `Formation.Msg.FormationInsertRequest`, it will use an adapter to execute SQL requests. Those requests will be sent to our postgre database.

## 10.2. Configuring the production

Now, through the Management Portal, we will instantiate that operation (by adding it with the [+] sign in the production).

We will also need to add the JavaGateway for the JDBC driver in the services. The full name of this service is `EnsLib.JavaGateway.Service`.

![JDBCProduction](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/JDBCProduction.png)

We now need to configure our operation. Since we have set up a postgre container, and connected its port `5432`, the value we need in the following parameters are:

>DSN: `jdbc:postgresql://db:5432/DemoData`
>
>JDBC Driver: `org.postgresql.Driver`
>
>JDBC Classpath: `/tmp/iris/postgresql-42.2.14.jar`

![JDBCParam](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/JDBCParam.png)

Finally, we need to configure the credentials to have access to the remote database. For that, we need to open the Credential Viewer: 

![JDBCCredentialMenu](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/JDBCCredentialMenu.png)

The login and password are both `DemoData`, as we set up in the `docker-compose.yml` file.

![JDBCCredentialCreation](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/JDBCCredentialCreation.gif)

Back to the production, we can add `"Postgre"` in the [Credential] field in the settings of our operation (it should be in the scrolling menu). Before being able to test it, we need to add the JGService to the operation. In the [Settings] tab, in the [Additional Settings]: 

![JDBCService](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/JDBCService.png)

## 10.3. Testing

When testing the visual trace should show a success: 


![JDBCTest](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/JDBCTest.png)

We have successfully connected with an extern database. 

## 10.4. Exercise

As an exercise, it could be interesting to modify BO.LocalBDD so that it returns a boolean that will tell the BP to call BO.RemoteBDD depending on the value of that boolean.

**Hint**: This can be done by changing the type of reponse LocalBDD returns and by adding a new property to the context and using the `if` activity in our BP.

## 10.5. Solution

First, we need to have a response from our LocalBDD operation. We are going to create a new message, in the `Formation/Msg/FormationInsertResponse.cls`:
````objectscript
Class Formation.Msg.FormationInsertResponse Extends Ens.Response
{

Property Double As %Boolean;

}
````

Then, we change the response of LocalBDD by that response, and set the value of its boolean randomly (or not): 
````objectscript
Method InsertLocalBDD(pRequest As Formation.Msg.FormationInsertRequest, Output pResponse As Formation.Msg.FormationInsertResponse) As %Status
{
    set tStatus = $$$OK
    
    try{
        set pResponse = ##class(Formation.Msg.FormationInsertResponse).%New()
        if $RANDOM(10) < 5 {
            set pResponse.Double = 1
        } 
        else {
            set pResponse.Double = 0
        }
...
````

We will now create a new process (copied from the one we made), where we will add a new context property, of type `%Boolean`:

![ExerciseContext](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/ExerciseContext.png)

This property will be filled with the value of the callresponse.Double of our operation call (we need to set the [Response Message Class] to our new message class):

![ExerciseBinding](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/ExerciseBinding.png)

We then add an `if` activity, with the `context.Double` property as condition:

![ExerciseIf](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/ExerciseIf.png)

VERY IMPORTANT : we need to uncheck **Asynchronous** in the settings of our LocallBDD Call, or the if activity will set off before receiving the boolean response.

Finally we set up our call activity with as a target the RemoteBDD BO:

![ExerciseRemoteCall](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/ExerciseRemoteCall.png)

To complete the if activity, we need to drag another connector from the output of the `if` to the `join` triangle below. As we won't do anything if the boolean is false, we will leave this connector empty. 
After compiling and instantiating, we should be able to test our new process. For that, we need to change the `Target Config Name` of our File Service.

In the trace, we should have approximately half of objects read in the csv saved also in the remote database. 

# 11. REST service

In this part, we will create and use a REST Service.

## 11.1. Creating the service

To create a REST service, we need a cless that extends %CSP.REST, in `Formation/REST/Dispatch.cls` we have:

````objectscript
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
  <Route Url="/import" Method="post" Call="import" />
</Routes>
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

  } Catch ex {
      set tSc = ex.AsStatus()
  }

  Quit tSc
}

}
````

This class contains a route to import an object, bound to the POST verb: 

````xml
<Routes>
  <!-- Get this spec -->
  <Route Url="/import" Method="post" Call="import" />
</Routes>
````
The import method will create a message that will be sent to a Business Service.

## 11.2. Adding our BS

We are going to create a generic class that will route all of its sollicitations towards `TargetConfigNames`. This target will be configured when we will instantiate this service. In the `Formation/BS/RestInput.cls` file we have:

```objectscript
Class Formation.BS.RestInput Extends Ens.BusinessService
{

Property TargetConfigNames As %String(MAXLEN = 1000) [ InitialExpression = "BuisnessProcess" ];

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method OnProcessInput(pDocIn As %RegisteredObject, Output pDocOut As %RegisteredObject) As %Status
{
    set status = $$$OK

    try {

        for iTarget=1:1:$L(..TargetConfigNames, ",") {
		    set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
		    $$$ThrowOnError(..SendRequestSync(tOneTarget,pDocIn,.pDocOut))
	    }
    } catch ex {
        set status = ex.AsStatus()
    }

    Quit status
}

}
```

Back to the production configuration, we add the service the usual way. In the [Target Config Names], we put our BO LocalBDD: 

![RESTServiceSetup](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/RESTServiceSetup.png)

To use this service, we need to publish it. For that, we use the [Edit Web Application] menu:

![RESTServicePublish](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/RESTServicePublish.gif)

## 11.3. Testing

Finally, we can test our service with any kind of REST client:

![RESTTest](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/RESTTest.gif)

# Conclusion

Through this formation, we have created a production that is able to read lines from a csv file and save the read data into both the IRIS database and an extern database using JDBC. We also added a REST service in order to use the POST verb to save new objects.

We have discovered the main elements of InterSystems' interoperability Framework.

We have done so using docker, vscode and InterSystems' IRIS Management Portal.