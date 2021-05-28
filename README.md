# Ensemble / Interoperability Formation

# Prerequisite :

 For this formation, you'll need :
* VSCode : https://code.visualstudio.com/
* The InterSystems addons suite for vscode : https://intersystems-community.github.io/vscode-objectscript/installation/
* Docker : https://docs.docker.com/get-docker/

# Goal : 

The goal of this formation is to learn InterSystems' interoperability framework, and particularly : 
* Productions
* Messages
* Operations
* Adapters
* Business Processes
* Services
* REST Services and Operations
# The framework : 

This is the framework we will be working with :
![Framework](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/FrameworkFull.png)

All of these components form a production. The arrows between them are **messages**. 
In the first place, we will build a production, with its operations, services and processes that will enable us to read data from a CSV file and save it in the iris database.
After building and composing our containers with the docker-compose.yml and Dockerfil files givent, we can open a Management Portal that will give us access to an HUD where we will bve able to create our productions. 
The portal shall be at the url : http://localhost:52775/csp/sys/UtilHome.csp?$NAMESPACE=IRISAPP. 
# Productions : 
We can now create our first production. For this, we will go through the Interoperability and Configure menus : 

![Production](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/ProductionMenu.png)

We then have to press "New", select the "Formation" package and chose a name for ou production : 

![Production](https://raw.githubusercontent.com/thewophile-beep/formation-template/master/misc/img/ProductionCreation.png)
