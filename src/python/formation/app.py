from flask import Flask,jsonify,request
from grongier.pex import Director

import iris

from msg.Formation import FormationRequest
from msg.obj.Formation import Formation

app = Flask(__name__)

@app.route("/", methods=["GET"])
def getInfo():
    info = {'version':'1.0.6'}
    return jsonify(info)

@app.route("/formations",methods=["POST"])
def createFormation():

    dict = request.get_json()

    sql = "INSERT INTO iris.formation ( name, room) VALUES( ? , ? )"
    iris.sql.exec(sql,dict['nom'],dict['salle'])

    return jsonify({'status':'ok'})

@app.route("/formations/<int:id>",methods=["GET"])
def getFormation(id):

    dict = {}
    sql = "Select  name, room from iris.formation where id = ?"
    rs = iris.sql.exec(sql,id)
    for row in rs:
        dict = {'nom':row[0],'salle':row[1]}

    return jsonify(dict)

@app.route("/formations/<int:id>",methods=["PUT"])
def updateFormation(id):

    dict = request.get_json()
    sql = "update iris.formation set name = ?, room = ? where id = ?"
    iris.sql.exec(sql,dict['nom'],dict['salle'],id)


    return jsonify({})

@app.route("/formations/<int:id>",methods=["delete"])
def deleteFormation(id):

    sql = "delete from iris.formation where id = ?"
    iris.sql.exec(sql,id)


    return jsonify({})

