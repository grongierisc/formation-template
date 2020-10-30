# Formation Ensemble/Interopérabilité

# Prérequis :

* VSCode
	 * Installer VSCode : https://code.visualstudio.com/
	 * Installer la suite d’addon InterSystems : https://intersystems-community.github.io/vscode-objectscript/installation/
* Docker
	 * Intaller Docker : https://docs.docker.com/get-docker/

# Objectif :

L’objectif de cette formation est d’apprendre le framework d’interopérabilité d’InterSystems notamment
*	Les productions
*	Les messages
*	Les opérations
  *	Les adapters
*	Les buisness process
*	Les services
*	Les services REST
*	Les opérations REST


# Le framework :

![Framework](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/Framework.png)
 
L’ensemble de ces composants forme une production.
Les flèches entre les composants sont des **messages**.

## Les productions :

Créer notre première production :

![Production](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/Production.gif)


## Les opérations :

Maintenant que notre première production est créée nous aller passer aux opérations.
L’objectif de cette opération va être de sauvegarder dans IRIS le contenu d’un message.

1.	Créer la classe de stockage.
Les classes de stockage dans IRIS sont de type %Persistent

```objectscript
Class Formation.Table.Formation Extends %Persistent
{

Property Name As %String;

Property Salle As %String;

}
```
2.	Créer le message d’action sur l’opération
Le message contiendra un objet Formation :

```objectscript
Class Formation.Obj.Formation Extends (%SerialObject, %XML.Adaptor)
{

Property Nom As %String;

Property Salle As %String;

}
```
La classe Message qui contient l'objet formation :
```objectscript
Class Formation.Msg.FormationInsertRequest Extends Ens.Request
{

Property Formation As Formation.Obj.Formation;

}
```
3.	L’opération :

```objectscript
Class Formation.BO.LocalBDD Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method InsertLocalBDD(pRequest As Formation.Msg.FormationInsertRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tStatus = $$$OK
    
    try{
        set pResponse = ##class(Ens.Response).%New()
        set tFormation = ##class(Formation.Table.Formation).%New()
        set tFormation.Name = pRequest.Formation.Nom
        set tFormation.Salle = pRequest.Formation.Salle
        $$$ThrowOnError(tFormation.%Save())
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
        <Method>InsertLocalBDD</Method>
    </MapItem>
</MapItems>
}

}

```

Ajouter l'opération à la production :

![BO](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/InstanceOperation.gif)

Tester l'opération :

![Test](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/TestBO.gif)

## Les Business Process :

Les business process sont les règles métiers d’un flux.

Créer son premier business process :

![BP](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/BusinessProcess.gif)

Ajoutons maintenant l'appel au BO avec le message construit précédemment

![BuildBP](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/BuildBP.gif)

Ce BP peut etre instancié dans la production comme pour les BO et etre testé.

Ici, il s'agit d'un simple passe plat. Nous allons le complexifier afin qu'il puisse prendre en entrée un ligne d'un fichier CSV.

### Creer un recard map

Un record map est le mapping d'un fichier vers un object.

Creer un record map :

![RecordMapCsv](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/RecordMapCsv.gif)

Maintenant que le record map est créer nous allons creer une transformation entre le format des record maps et les messages d'insertion en BDD.

### Creer une data transformation

![CreateDT](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/CreateDT.gif)

La data transformation créée, nous pouvons mapper les champs :

![MapDT](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/MapDT.gif)

Revenons au Business Process pour y ajouter notre DT.

![AddDTtoBP](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/AddDTtoBP.gif)

Ici, la première action réalisée est de modifier l'entrée du BP pour qu'il puisse acceuillir le Recard Map, ensuite nous ajoutons la transforamtion.

Passons à la configuration de cette transforamtion :

Nous commencons par l'ajout du message à envoyer au BO dans le context du BP.

![AddMsgToContext](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/AddMsgToContext.gif)

Ensuite nous configurons la transformation :

![DTtoCallInBP](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/DTtoCallInBP.gif)

1. L'entrée de la DT est le message d'entré du business process (request)
2. La sortie de la DT est le message dans le context qui sera transmis à l'appel
3. Nous supprimons l'ancien mapping par l'appel contextuel

Le nouveau BP est pret, configurons le tout dans la production :

![AddBPandServiceProd](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/AddBPandServiceProd.gif)

1. Peu de configuration pour le BP
2. Pour le record map, nous utilisons un service générique qui est configurer pour utiliser le record map

![ConfigureRMinProd](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/ConfigureRMinProd.gif)

Test le flux de bout en bout :

![TestProdRMEndToEnd](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/TestProdRMEndToEnd.gif)

