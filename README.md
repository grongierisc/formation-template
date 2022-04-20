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
  - [5.2. Management Portal and VSCode](#52-management-portal-and-vscode)
  - [5.3. Saving progress](#53-saving-progress)
  - [5.4. Register components](#54-register-components)
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
  - [10.1. Prerequisites](#101-prerequisites)
  - [10.2. Creating our new operation](#102-creating-our-new-operation)
  - [10.3. Configuring the production](#103-configuring-the-production)
  - [10.4. Testing](#104-testing)
  - [10.5. Exercise](#105-exercise)
  - [10.6. Solution](#106-solution)
- [11. REST service](#11-rest-service)
  - [11.1. Prerequisites](#111-prerequisites)
  - [11.2. Creating the service](#112-creating-the-service)
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

WIP changer l'image pour coller à la formation
![FrameworkAdapted](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/FrameworkAdapted.png)


# 4. Prerequisites

For this formation, you'll need:
* VSCode: https://code.visualstudio.com/
* The InterSystems addons suite for vscode: https://intersystems-community.github.io/vscode-objectscript/installation/
* Docker: https://docs.docker.com/get-docker/
* The docker addon for VSCode.
* [postgre requisites](#101-prerequisites)
# 5. Setting up 


## 5.1. Docker containers


In order to have access to the InterSystems images, we need to go to the following url: http://container.intersystems.com. After connecting with our InterSystems credentials, we will get our password to connect to the registry. In the docker VScode addon, in the image tab, by pressing connect registry and entering the same url as before (http://container.intersystems.com) as a generic registry, we will be asked to give our credentials. The login is the usual one but the password is the one we got from the website.

From there, we should be able to build and compose our containers (with the `docker-compose.yml` and `Dockerfile` files given).

## 5.2. Management Portal and VSCode

This repository is ready for [VS Code](https://code.visualstudio.com/).

Open the locally-cloned `formation-template` folder in VS Code.

If prompted (bottom right corner), install the recommended extensions.

When prompted, reopen the folder inside the container so you will be able to use the python components within it. The first time you do this it may take several minutes while the container is readied.

By opening the folder remote you enable VS Code and any terminals you open within it to use the python components within the container. Configure these to use `/usr/irissys/bin/irispython`

<img width="1614" alt="PythonInterpreter" src="https://user-images.githubusercontent.com/47849411/145864423-2de24aaa-036c-4beb-bda0-3a73fe15ccbd.png">

## 5.3. Saving progress

A part of the things we will be doing will be saved locally, but productions are saved in the docker container. In order to persist all of our progress, we need to export every class that is created through the Management Portal with the InterSystems addon `ObjectScript`:

![ExportProgress](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/ExportProgress.png)

We will have to save our Production this way. After that, when we close our docker container and compose it up again, we will still have all of our progress saved locally (it is, of course, to be done after every change through the portal). To make it accessible to IRIS again we need to compile the exported files (by saving them, InterSystems addons take care of the rest).

## 5.4. Register components

In order to register the components we are creating in python to the production it is needed to use the `RegisterComponent` function from the `Grongier.PEX.Utils` module.

For this you can either add your components in the `./iris.script` file but you will need to rebuild everytime you add a component.<br>We advise you to use the build-in python console to add manually the component at first when you are working on the project and then add them in the `iris.script` if you want to come back later ( or you will have to do it every time you rebuild the container )

You will find those commands in the `misc/register.py` file.<br>To use them you nedd to firstly create the component then you can start a terminal in VSCode ( it will be automatically in the container if you followed step [5.2.](#52-management-portal-and-vscode)) and enter :
'''
/usr/irissys/bin/irispython
'''
To launch an IrisPython console.

Then enter :
```
import iris
```

Now you can register your component using :
```
iris.cls("Grongier.PEX.Utils").RegisterComponent("bo","FileOperation","/irisdev/app/src/python/",1,"Python.FileOperation")
```
This line will register the class `FileOperation` inside the file `bo` at `/irisdev/app/src/python/` (which is the right path if you follow this course) using the name `Python.FileOperation`in the management portal.

It is to be noted that if you don't change to name of the file or the class, if a component was registered you can modify it on VSCode without the need to register it again. Just don't forget to restart it in the management portal.

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

We will create those operations in local, that is, in the `python/bo.py` file. Saving the files will compile them in IRIS. 

For our first operation we will save the content of a message in the local database.

We need to have a way of storing this message first. 

## 7.1. Creating our storage classes
WIP AVEC IRIS.SQL
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

As we can see, if the `FileOperation` receive a message of the type `msg.FormationRequest`, the information hold by the message will be written down on the `toto.csv` file.<br>Note that you could make `filename` a variable with a base value of `toto.csv` that can be change directly onto the management portal by doing :
```python
    def OnInit(self):
        if hasattr(self,'Path'):
            os.chdir(self.Path)
        if not hasattr(self,'Filename'):
          self.Filename = 'toto.csv'
```

As we can see, if the `IrisOperation` receive a message of the type `msg.FormationIrisRequest`, the information hold by the message will be transformed into an SQL querry and executed by the `iris.sql.exec` IrisPython function. This method will save the message in the IRIS local database.

Don't forget to register your component :
Following [5.4.](#54-register-components) and using:
```
iris.cls("Grongier.PEX.Utils").RegisterComponent("bo","FileOperation","/irisdev/app/src/python/",1,"Python.FileOperation")
```
And:
```
iris.cls("Grongier.PEX.Utils").RegisterComponent("bo","IrisOperation","/irisdev/app/src/python/",1,"Python.IrisOperation")
```

## 7.4. Adding the operations to the production

We now need to add these operations to the production. For this, we use the Management Portal. By pressing the [+] sign next to [Operations], we have access to the [Business Operation Wizard]. There, we chose the operation classes we just created in the scrolling menu. 

![OperationCreation](https://github.com/LucasEnard/formation-template/blob/python/misc/img/PythonOperationCreation.png)

## 7.5. Testing

Double clicking on the operation will enable us to activate it. After that, by selecting the operation and going in the [Actions] tabs in the right sidebar menu, we should be able to test the operation (if not see the production creation part to activate testings / you may need to start the production if stopped).

By doing so, we will send the operation a message of the type we declared earlier. If all goes well, showing the visual trace will enable us to see what happened between the processes, services and operations. <br>Here, we can see the message being sent to the operation by the process, and the operation sending back a response (that is just an empty string).
You should get a result like this :
![IrisOperation](https://github.com/LucasEnard/formation-template/blob/python/misc/img/PythonIrisOperationTest.png)

WIP talk about iris.script and autoimport<br>
For IrisOperation you must first access Iris database system and copy/paste `misc/init.iris.sql` to create the table we will be using.

For FileOperation it is to be noted that you must fill the %settings available on the Management Portal as follow ( and you can add in the settings the `filename` if you have followed the `filename` note from [7.3.](#73-creating-our-operations) ) :
![Settings for FileOperation](https://github.com/LucasEnard/formation-template/blob/python/misc/img/SettingsFileOperation.png)

You should get a result like this :
![FileOperation](https://github.com/LucasEnard/formation-template/blob/python/misc/img/ResultsFileOperation.png)

WIP ajouter screenshot pour IrisOperation et FileOperation (avec le nom de la table créée et le fichier txt créé)
et comment accéder avec bash + cat toto.csv


# 8. Business Processes

Business Processes (BP) are the business logic of our production. They are used to process requests or relay those requests to other components of the production.

Business Processes are created in VSCode.

## 8.1. Simple BP

We now have to create a Business Process to process the information coming from our future services and dispatch it accordingly. We are going to create a simple BP that will call our operations.

Since our BP will only redirect information we will call it `Router` and it will be in the file `python/bp.py` like this :
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

Don't forget to register your component :
Following [5.4.](#54-register-components) and using:
```
iris.cls("Grongier.PEX.Utils").RegisterComponent("bp","Router","/irisdev/app/src/python/",1,"Python.Router")
```

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

Since our BS will read a csv we will call it `ServiceCSV` and it will be in the file `python/bs.py` like this :
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

Don't forget to register your component :
Following [5.4.](#54-register-components) and using:
```
iris.cls("Grongier.PEX.Utils").RegisterComponent("bs","ServiceCSV","/irisdev/app/src/python/",1,"Python.ServiceCSV")
```

## 9.2. Adding the service to the production

We now need to add the service to the production. For this, we use the Management Portal. By pressing the [+] sign next to [Services], we have access to the [Business service Wizard]. There, we chose the service class we just created in the scrolling menu. 

## 9.3. Testing

Double clicking on the process will enable us to activate it. As explained before, nothing more has to be done here since the service will start on his own every 5 seconds.
If all goes well, showing the visual trace will enable us to see what happened between the process, services and processes. here, we can see the messages being sent to the process by the service, the messages to the operations by the process, and the operations sending back a response.
![ServiceCSVResults](https://github.com/LucasEnard/formation-template/blob/python/misc/img/PythonServiceCSVResults.png)

# 10. Getting access to an extern database using JDBC

In this section, we will create an operation to save our objects in an extern database. We will be using the JDBC API, as well as the other docker container that we set up, with postgre on it. 

## 10.1. Prerequisites
In order to use postgre we will need to install psycopg2 which is a python module allowing us to connect to the postegre database with a simple command.<br>To do this you will need to be inside the docker container to install psycopg2 on iris python.<br>Once you are in the terminal enter :
```
pip3 install psycopg2-binary
```

WIP talk about docker script ?? install auto ??

## 10.2. Creating our new operation

Our new operation needs to be added after the two other one in the file `python/bo.py`.
Our new operation and the imports are as follows: 

````python
import psycopg2

class PostgresOperation(grongier.pex.BusinessOperation):

    def OnInit(self):
        self.conn = psycopg2.connect(
        host="db",
        database="DemoData",
        user="DemoData",
        password="DemoData",
        port="5432")
        self.conn.autocommit = True

        return 1

    def OnTearDown(self):
        self.conn.close()

    def OnMessage(self,request):
        cursor = self.conn.cursor()
        if isinstance(request,FormationRequest):
            sql = "INSERT INTO public.formation ( id,nom,salle ) VALUES ( %s , %s , %s )"
            cursor.execute(sql,(request.formation.id,request.formation.nom,request.formation.salle))
        return 
````
It is to be noted that it is better if you put the `import psycopg2` at the beginning of the file with the other imports for clarity.
This operation is similar to the first one we created. When it will receive a message of the type `msg.FormationRequest`, it will use the psycopg module to execute SQL requests. Those requests will be sent to our postgre database.

As you can see here the connection is written directly into the code, to improve our code we could do as before for the other operations and make, `host`, `database` and the other connection information, variables with a base value of `db`and `DemoData` etc that can be change directly onto the management portal.<br>To do this we can change our `OnInit` function by :
```python
    def OnInit(self):
        if hasattr(self,'Path'):
            os.chdir(self.Path)
        if not hasattr(self,'Host'):
          self.Host = 'db'
        if not hasattr(self,'Database'):
          self.Database = 'DemoData'
        if not hasattr(self,'User'):
          self.User = 'DemoData'
        if not hasattr(self,'Password'):
          self.Password = 'DemoData'
        if not hasattr(self,'Port'):
          self.Port = '5432'

        self.conn = psycopg2.connect(
        host=self.Host,
        database=self.Database,
        user=self.User,
        password=self.Password,
        port=self.Port)

        self.conn.autocommit = True

        return 1
```

Don't forget to register your component :
Following [5.4.](#54-register-components) and using:
```
iris.cls("Grongier.PEX.Utils").RegisterComponent("bo","PostgresOperation","/irisdev/app/src/python/",1,"Python.PostgresOperation")
```

## 10.3. Configuring the production

We now need to add the operation to the production. For this, we use the Management Portal. By pressing the [+] sign next to [Operations], we have access to the [Business Operation Wizard]. There, we chose the operation class we just created in the scrolling menu. 

Afterward, if you wish to change the connection, you can simply add in the %settings in -Python in the parameter window of the operation the parameter you wish to change.
See the second image of [7.5. Testing](#75-testing) for more details.

## 10.4. Testing

When testing the visual trace should show a success: 


![JDBCTest](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/JDBCTest.png)

We have successfully connected with an extern database. 

## 10.5. Exercise

As an exercise, it could be interesting to modify bo.IrisOperation so that it returns a boolean that will tell the bp.Router to call bo.PostgresOperation depending on the value of that boolean.

**Hint**: This can be done by changing the type of reponse bo.IrisOperation returns and by adding to that new type of message/response a new boolean property and using the `if` activity in our bp.Router.

## 10.6. Solution

First, we need to have a response from our bo.IrisOperation . We are going to create a new message after the other two, in the `python/msg.py`:
````python
@dataclass
class FormationIrisResponse(grongier.pex.Message):

    bool:Boolean = None
````

Then, we change the response of bo.IrisOperation by that response, and set the value of its boolean randomly (or not).<br>In the `python/bo.py`you need to add two imports and change the IrisOperation class:
````python
import random
from msg import FormationIrisResponse

class IrisOperation(grongier.pex.BusinessOperation):

    def OnMessage(self, request):
        if isinstance(request,FormationIrisRequest):
            resp = FormationIrisResponse()
            resp.bool = (random.random() < 0.5)
            sql = """
            INSERT INTO iris.formation
            ( name, room )
            VALUES( ?, ? )
            """
            iris.sql.exec(sql,request.formation.name,request.formation.room)
            return resp
        
        return 
````

We will now change our process `bp.Router` in `python/bp.py` , where we will make it so that if the response from the IrisOperation has a boolean equal to True it will call the PostgesOperation.
Here is the new code :
```python
class Router(grongier.pex.BusinessProcess):

    def OnRequest(self, request):
        if isinstance(request,FormationRequest):
            msg = FormationIrisRequest()
            msg.formation = FormationIris()
            msg.formation.name = request.formation.nom
            msg.formation.room = request.formation.salle
            self.SendRequestSync('Python.FileOperation',request)
            formIrisResp = self.SendRequestSync('Python.IrisOperation',msg)

            if formIrisResp.bool:
                self.SendRequestSync('Python.PostgresOperation',request)

        return 
```

VERY IMPORTANT : we need to make sure we use **SendRequestSync** and not **SendRequestAsync** in the call of our operations, or else the activity will set off before receiving the boolean response.

In the visual trace, after testing, we should have approximately half of objects read in the csv saved also in the remote database.<br>
Note that to test you can just start the `bs.ServiceCSV` and it will automatically send request to the router that will then dispatch properly the requests.<br>
Also note that you must double click on a service and press reload or restart if you want your saved changes on VSCode to apply.

# 11. REST service

In this part, we will create and use a REST Service.

## 11.1. Prerequisites
In order to use Flask we will need to install flask which is a python module allowing us to easily create a REST service.
To do this you will need to be inside the docker container to install flask on iris python.
Once you are in the terminal enter :
```
pip3 install flask
```

## 11.2. Creating the service

To create a REST service, we will need a service that will link our API to our porduction, for this we create a new simple service in `python/bs.py` just after the `ServiceCSV` class.
WIP
```python
class FlaskService(grongier.pex.BusinessService):

    def OnInit(self):
        
        if not hasattr(self,'Target'):
            self.Target = "Python.Router"
        
        return 1

    def OnProcessInput(self,request):

        return self.SendRequestSync(self.Target,request)
```
OnProcessInput this service will simply tranfer the request to the Router.

Don't forget to register your component :
Following [5.4.](#54-register-components) and using:
```
iris.cls("Grongier.PEX.Utils").RegisterComponent("bs","FlaskService","/irisdev/app/src/python/",1,"Python.FlaskService")
```

To create a REST service, we will need Flask to create an API that will manage the `get` and `post` function:
We need to create a new file as `python/app.py`:
WIP
```python
from flask import Flask, jsonify, request, make_response
from grongier.pex import Director
import iris

from obj import Formation
from msg import FormationRequest


app = Flask(__name__)

# ----------------------------------------------------------------
### CRUD FOR Person
# ----------------------------------------------------------------

# GET Infos
@app.route("/", methods=["GET"])
def getInfo():
    info = {'version':'1.0.6'}
    return jsonify(info)

@app.route("/training/", methods=["GET"])
def getAlltraining():
    payload = {}
    return jsonify(payload)

@app.route("/training/", methods=["POST"])
def postPerson():
    payload = {} 

    formation = Formation(request.get_json()['id'],request.get_json()['nom'],request.get_json()['salle'])
    msg = FormationRequest(formation=formation)

    tService = Director.CreateBusinessService("Python.FlaskService")
    response = tService.dispatchProcessInput(msg)


    return jsonify(payload)

# GET person with id
@app.route("/training/<int:id>", methods=["GET"])
def getPerson(id):
    payload = {}
    return jsonify(payload)

# PUT to update person with id
@app.route("/training/<int:id>", methods=["PUT"])
def updatePerson(id):

    payload = {
    }
    return jsonify(payload)

# DELETE person with id
@app.route("/training/<int:id>", methods=["DELETE"])
def deletePerson(id):
    payload = {}  
    return jsonify(payload)


# ----------------------------------------------------------------
### MAIN PROGRAM
# ----------------------------------------------------------------

if __name__ == '__main__':
    app.run('0.0.0.0', port = "8081")
```

WIP Note that the Flask API will use a Director to create an instance of our FlaskService from earlier and then send the right request.

## 11.3. Testing

Finally, we can test our service with any kind of REST client after having reloaded the Router service:

WIP gif with the wrong http link.

![RESTTest](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/RESTTest.gif)

# Conclusion

Through this formation, we have created a production that is able to read lines from a csv file and save the read data into a local txt, the IRIS database and an extern database using JDBC. We also added a REST service in order to use the POST verb to save new objects.

We have discovered the main elements of InterSystems' interoperability Framework.

We have done so using docker, vscode and InterSystems' IRIS Management Portal.