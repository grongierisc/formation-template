 # 1. **Ensemble / Interoperability Formation**

 The goal of this formation is to learn InterSystems' interoperability framework using python, and particularly the use of: 
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
- [7. Business Operations](#7-business-operations)
  - [7.1. Creating our storage classes](#71-creating-our-storage-classes)
  - [7.2. Creating our message classes](#72-creating-our-message-classes)
  - [7.3. Creating our operations](#73-creating-our-operations)
  - [7.4. Adding the operations to the production](#74-adding-the-operations-to-the-production)
  - [7.5. Testing](#75-testing)
- [8. Business Processes](#8-business-processes)
  - [8.1. Simple BP](#81-simple-bp)
  - [8.2. Adding the process to the production](#82-adding-the-process-to-the-production)
  - [8.3. Testing](#83-testing)
- [9. Business Service](#9-business-service)
  - [9.1. Simple BS](#91-simple-bs)
  - [9.2. Adding the service to the production](#92-adding-the-service-to-the-production)
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
* [Postgre requisites](#101-prerequisites)
* [Flask requisites](#111-prerequisites)

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

![ExportProgress](https://user-images.githubusercontent.com/77791586/164473715-b08d0465-0c7b-42f5-9de4-f1a125ecce96.png)

We will have to save our Production this way. After that, when we close our docker container and compose it up again, we will still have all of our progress saved locally (it is, of course, to be done after every change through the portal). To make it accessible to IRIS again we need to compile the exported files (by saving them, InterSystems addons take care of the rest).

## 5.4. Register components

In order to register the components we are creating in python to the production it is needed to use the `RegisterComponent` function from the `Grongier.PEX.Utils` module.

WIP iris script ??
For this you can either add your components in the `./iris.script` file but you will need to rebuild everytime you add a component.<br>We advise you to use the build-in python console to add manually the component at first when you are working on the project and then add them in the `iris.script` if you want to come back later ( or you will have to do it every time you rebuild the container )

You will find those commands in the `misc/register.py` file.<br>To use them you need to firstly create the component then you can start a terminal in VSCode ( it will be automatically in the container if you followed step [5.2.](#52-management-portal-and-vscode)) and enter :
```
/usr/irissys/bin/irispython
```
To launch an IrisPython console.

Then enter :
```
import iris
```

Now you can register your component using :
```
iris.cls("Grongier.PEX.Utils").RegisterComponent("bo","FileOperation","/irisdev/app/src/python/",1,"Python.FileOperation")
```
This line will register the class `FileOperation` that is coded inside the file `bo`, file situated in `/irisdev/app/src/python/` (which is the right path if you follow this course) using the name `Python.FileOperation` in the management portal.

It is to be noted that if you don't change to name of the file or the class, if a component was registered you can modify it on VSCode without the need to register it again. Just don't forget to restart it in the management portal.

# 6. Productions 

A **production** is the base of all our work on Iris, it must be seen as the shell of our [framework](#2-framework) that will hold the **services**, **processes** and **operations**.<br>
Everything in the production is going to inherit functions ; Those are the `OnInit` function that resolve at the creation of an instance of this class and the `OnTearDown` function that resolve when the instance is killed.
This will be useful to set variables or close a used open file when writing.

We can now create our first production.<br>
For this, we will go through the [Interoperability] and [Configure] menus: 

![ProductionMenu](https://user-images.githubusercontent.com/77791586/164473827-ffa2b322-095a-46e3-8c8b-16d467a80485.png)

We then have to press [New], select the [Formation] package and chose a name for our production: 

![ProductionCreation](https://user-images.githubusercontent.com/77791586/164473884-5c7aec69-c45d-4062-bedc-2933e215da22.png)

Immediatly after creating our production, we will need to click on [Production Settings] just above the [Operations] section. In the right sidebar menu, we will have to activate [Testing Enabled] in the [Development and Debugging] part of the [Settings] tab (don't forget to press [Apply]).

![ProductionTesting](https://user-images.githubusercontent.com/77791586/164473965-47ab1ba4-85d5-46e3-9e15-64186b5a457e.png)

In this first production we will now add Business Operations.

# 7. Business Operations

A **Business Operation** (BO) is a specific operation that will enable us to send requests from IRIS to an external application / system. It can also be used to directly save in IRIS what we want.<br>
BO also have an `OnMessage` function that will be called everytime this instance receive a message from any source, this will allow us to (WIP)receive information and send it, as seen in the framework, to an external client.

We will create those operations in local in VSCode, that is, in the `python/bo.py` file.<br>Saving this file will compile them in IRIS. 

For our first operations we will save the content of a message in the local database and write the same information localy in a .txt file.

We need to have a way of storing this message first. 

## 7.1. Creating our storage classes

We will use `dataclass` to hold information in our [messages](#72-creating-our-message-classes).

In our `python/obj.py` file we have: 
```python
from dataclasses import dataclass

@dataclass
class Formation:

    id:int = None
    nom:str = None
    salle:str = None

@dataclass
class Training:

    name:str = None
    room:str = None
```

The Formation class will be used as a Python object to read a csv and write in a texte file later on, while the Training class will be used as a way to interact with the Iris database.

## 7.2. Creating our message classes

These messages will contain a `Formation` object or a `Training` object, located in the `obj.py` file created in [7.1](#71-creating-our-storage-classes)

Note that messages, requests and responses all inherit from the `grongier.pex.Message` class.

In the `python/msg.py` file we have: 
```python
from dataclasses import dataclass
import grongier.pex.Message

from obj import Formation,Training

@dataclass
class FormationRequest(Message):

    formation:Formation = None

@dataclass
class TrainingIrisRequest(Message):

    training:Training = None
```

Again, the `FormationRequest` class will be used as a message to read a csv and write in a texte file later on, while the `TrainingIrisRequest` class will be used as a message to interact with the Iris database.

## 7.3. Creating our operations

Now that we have all the elements we need, we can create our operations.<br>
Note that any Business Operation inherit from the `grongier.pex.BusinessOperation` class.

In the `python/bo.py` file we have: 
```python
from grongier.pex import BusinessOperation
import os
import iris

from msg import TrainingIrisRequest,FormationRequest

class FileOperation(BusinessOperation):

    def OnInit(self):
        if hasattr(self,'Path'):
            os.chdir(self.Path)
        else:
            os.chdir("/tmp")

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

class IrisOperation(BusinessOperation):

    def OnMessage(self, request):
        if isinstance(request,TrainingirisRequest):
            sql = """
            INSERT INTO iris.training
            ( name, room )
            VALUES( ?, ? )
            """
            iris.sql.exec(sql,request.training.name,request.training.room)
        
        return 
```

It is needed to use, if necessary to protect the code, multiple **if** conditions on the message type using for example `isinstance()` as seen in our `bo.py` file.<br>That way, if a message that was not foreseen arrive to our operation no code will be run.

As we can see, if the `FileOperation` receive a message of the type `msg.FormationRequest`, the information hold by the message will be written down on the `toto.csv` file.<br>Note that `Path` is already a parameter of the operation and you could make `filename` a variable with a base value of `toto.csv` that can be change directly onto the management portal by doing :
```python
    def OnInit(self):
        if hasattr(self,'Path'):
            os.chdir(self.Path)
        else:
            os.chdir("/tmp")
        if not hasattr(self,'Filename'):
          self.Filename = 'toto.csv'
```
Then, we would call `self.Filename` instead of coding it directly inside the operation.
<br><br><br>

As we can see, if the `IrisOperation` receive a message of the type `msg.TrainingIrisRequest`, the information hold by the message will be transformed into an SQL querry and executed by the `iris.sql.exec` IrisPython function. This method will save the message in the IRIS local database.

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

We now need to add these operations to the production. For this, we use the Management Portal. By pressing the [+] sign next to [Operations], we have access to the [Business Operation Wizard].<br>There, we chose the operation classes we just created in the scrolling menu. 

![OperationCreation](https://user-images.githubusercontent.com/77791586/164474068-49c7799c-c6a2-4e1e-8489-3788c50acb86.png)

## 7.5. Testing

Double clicking on the operation will enable us to activate it. After that, by selecting the operation and going in the [Actions] tabs in the right sidebar menu, we should be able to test the operation (if not see the production creation part to activate testings / you may need to start the production if stopped).

By doing so, we will send the operation a message of the type we declared earlier. If all goes well, showing the visual trace will enable us to see what happened between the processes, services and operations. <br>Here, we can see the message being sent to the operation by the process, and the operation sending back a response (that is just an empty string).
You should get a result like this :
![IrisOperation](https://user-images.githubusercontent.com/77791586/164474137-f21b78f1-fbe6-493f-8f50-f2729f81295d.png)

WIP talk about iris.script and autoimport<br>
For IrisOperation it is to be noted that the table was automatically created in the Iris DataBase when the building was done.

For FileOperation it is to be noted that you must fill the Path in the `%settings` available on the Management Portal as follow ( and you can add in the settings the `Filename` if you have followed the `Filename` note from [7.3.](#73-creating-our-operations) ) :
![Settings for FileOperation](https://user-images.githubusercontent.com/77791586/164474207-f31805ff-b36c-49be-972a-dc8d32ce495c.png)

You should get a result like this :
![FileOperation](https://user-images.githubusercontent.com/77791586/164474286-0eaa6f27-e56f-4a87-b12a-9dab57c21506.png)

WIP ajouter screenshot pour IrisOperation et FileOperation (avec le nom de la table créée et le fichier txt créé)
et comment accéder avec bash + cat toto.csv<br>
In order to see if our operations worked it is needed for us to acces the toto.csv file and the Iris DataBase to see the changes.<br>
To access the toto.csv you will need to open a terminal inside the container then type:
```
cd /tmp
```
```
cat toto.csv
```

To access the Iris DataBase you will need to access the management portal and seek [System Explorer] then [SQL] then [Go].
Now you can enter in the [Execute Query] :
```
SELECT * FROM WIP
```



# 8. Business Processes

**Business Processes** (BP) are the business logic of our production. They are used to process requests or relay those requests to other components of the production.<br>
BP also have an `OnRequest` function that will be called everytime this instance receive a request from any source, this will allow us to (WIP)receive information and process it in anyway and disptach it to the right BO.

We will create those process in local in VSCode, that is, in the `python/bp.py` file.<br>Saving this file will compile them in IRIS. 


## 8.1. Simple BP

We now have to create a **Business Process** to process the information coming from our future services and dispatch it accordingly. We are going to create a simple BP that will call our operations.

Since our BP will only redirect information we will call it `Router` and it will be in the file `python/bp.py` like this :
```python
from grongier.pex import BusinessProcess

from msg import FormationRequest, TrainingIrisRequest
from obj import Training


class Router(BusinessProcess):

    def OnRequest(self, request):
        if isinstance(request,FormationRequest):
            msg = TrainingIrisRequest()
            msg.training = Training()
            msg.training.name = request.formation.nom
            msg.training.room = request.formation.salle
            self.SendRequestSync('Python.FileOperation',request)
            self.SendRequestSync('Python.IrisOperation',msg)

        return 
```
As we can see, if the IrisOperation receive a message of the type `msg.FormationRequest`, the information hold by the message will be send directly to `Python.FileOperation` with the `SendRequestSync` function to be written down on our .txt. <br>We will also create a `msg.TrainingIrisRequest` in order to call `Python.IrisOperation` the same way.

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
![RouterTest](https://user-images.githubusercontent.com/77791586/164474368-838fd740-0548-44e6-9bc0-4c6c056f0cd7.png)

If all goes well, showing the visual trace will enable us to see what happened between the process, services and processes. <br>Here, we can see the messages being sent to the operations by the process, and the operations sending back a response.
![RouterResults](https://user-images.githubusercontent.com/77791586/164474411-efdae647-5b8b-4790-8828-5e926c597fd1.png)

# 9. Business Service

**Business Service** (BS) are the ins of our production. They are used to gather information and send them to our routers.
BS also have an `OnProcessInput` function that often gather information in our framework, it can be called by multiple ways such as a REST API or an other service, or by the service itself to execute his code again.
BS also have a `getAdapterType` function that allow us to allocate an adapter to the class, for example `Ens.InboundAdapter`that will make it so that the service will call his own `OnProcessInput`every 5 seconds.

We will create those services in local in VSCode, that is, in the `python/bs.py` file.<br>Saving this file will compile them in IRIS.

## 9.1. Simple BS

We now have to create a Business Service to read a CSV and send each line as a `msg.FormationRequest` to the router.

Since our BS will read a csv we will call it `ServiceCSV` and it will be in the file `python/bs.py` like this :
```python
from grongier.pex import BusinessService

from dataclass_csv import DataclassReader

from obj import Formation
from msg import FormationRequest

class ServiceCSV(BusinessService):

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
If all goes well, showing the visual trace will enable us to see what happened between the process, services and processes. Here, we can see the messages being sent to the process by the service, the messages to the operations by the process, and the operations sending back a response.
![ServiceCSVResults](https://user-images.githubusercontent.com/77791586/164474470-c77c4a06-0d8f-4ba9-972c-ce09b20fa54a.png)

# 10. Getting access to an extern database using JDBC

In this section, we will create an operation to save our objects in an extern database. We will be using the JDBC API, as well as the other docker container that we set up, with postgre on it. 

## 10.1. Prerequisites
In order to use postgre we will need to install psycopg2 which is a python module allowing us to connect to the postegre database with a simple command.<br>To do this you will need to be inside the docker container to install psycopg2 on iris python.<br>Once you are in the terminal enter :
```
pip3 install psycopg2-binary
```

## 10.2. Creating our new operation

Our new operation needs to be added after the two other one in the file `python/bo.py`.
Our new operation and the imports are as follows: 
````python
import psycopg2

class PostgresOperation(BusinessOperation):

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

As you can see here the connection is written directly into the code, to improve our code we could do as before for the other operations and make, `host`, `database` and the other connection information, variables with a base value of `db` and `DemoData` etc that can be change directly onto the management portal.<br>To do this we can change our `OnInit` function by :
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

Afterward, if you wish to change the connection, you can simply add in the %settings in [Python] in the [parameter] window of the operation the parameter you wish to change.
See the second image of [7.5. Testing](#75-testing) for more details.

## 10.4. Testing

When testing the visual trace should show a success: 


![JDBCTest](https://user-images.githubusercontent.com/77791586/164474520-8e355daf-77f0-4827-9c08-8b0c7ae4b18a.png)

We have successfully connected with an extern database. 

## 10.5. Exercise

As an exercise, it could be interesting to modify `bo.IrisOperation` so that it returns a boolean that will tell the `bp.Router` to call `bo.PostgresOperation` depending on the value of that boolean.

**Hint**: This can be done by changing the type of reponse bo.IrisOperation returns and by adding to that new type of message/response a new boolean property and using the `if` activity in our bp.Router.

## 10.6. Solution

First, we need to have a response from our bo.IrisOperation . We are going to create a new message after the other two, in the `python/msg.py`:
````python
@dataclass
class TrainingirisResponse(Message):

    bool:Boolean = None
````

Then, we change the response of bo.IrisOperation by that response, and set the value of its boolean randomly (or not).<br>In the `python/bo.py`you need to add two imports and change the IrisOperation class:
````python
import random
from msg import TrainingIrisResponse

class IrisOperation(BusinessOperation):

    def OnMessage(self, request):
        if isinstance(request,TrainingIrisRequest):
            resp = TrainingIrisResponse()
            resp.bool = (random.random() < 0.5)
            sql = """
            INSERT INTO iris.training
            ( name, room )
            VALUES( ?, ? )
            """
            iris.sql.exec(sql,request.training.name,request.training.room)
            return resp
        
        return
````

We will now change our process `bp.Router` in `python/bp.py` , where we will make it so that if the response from the IrisOperation has a boolean equal to True it will call the PostgesOperation.
Here is the new code :
```python
class Router(BusinessProcess):

    def OnRequest(self, request):
        if isinstance(request,FormationRequest):
            msg = TrainingIrisRequest()
            msg.training = Training()
            msg.training.name = request.formation.nom
            msg.training.room = request.formation.salle
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
class FlaskService(BusinessService):

    def OnInit(self):
        
        if not hasattr(self,'Target'):
            self.Target = "Python.Router"
        
        return

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

# GET all the formations
@app.route("/training/", methods=["GET"])
def getAlltraining():
    payload = {}
    return jsonify(payload)

# POST a formation
@app.route("/training/", methods=["POST"])
def postPerson():
    payload = {} 

    formation = Formation(request.get_json()['id'],request.get_json()['nom'],request.get_json()['salle'])
    msg = FormationRequest(formation=formation)

    tService = Director.CreateBusinessService("Python.FlaskService")
    response = tService.dispatchProcessInput(msg)


    return jsonify(payload)

# GET formation with id
@app.route("/training/<int:id>", methods=["GET"])
def getPerson(id):
    payload = {}
    return jsonify(payload)

# PUT to update formation with id
@app.route("/training/<int:id>", methods=["PUT"])
def updatePerson(id):

    payload = {
    }
    return jsonify(payload)

# DELETE formation with id
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

We made the POST formation functional in the code above, it is now your task, if you wish, to make the other functions in order to get/post the right information using all the things we have learned so far.

## 11.3. Testing

Finally, we can test our service with any kind of REST client after having reloaded the Router service:

WIP gif with the wrong http link.

![RESTTest](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/RESTTest.gif)

# Conclusion

Through this formation, we have created a fully fonctional production using only IrisPython that is able to read lines from a csv file and save the read data into a local txt, the IRIS database and an extern database using JDBC. <br>We also added a REST service in order to use the POST verb to save new objects.

We have discovered the main elements of InterSystems' interoperability Framework.

We have done so using docker, vscode and InterSystems' IRIS Management Portal.