from grongier.pex import BusinessOperation
import iris
import os
import psycopg2

import random

from msg import TrainingIrisRequest,FormationRequest,TrainingIrisResponse

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

class PostgresOperation(BusinessOperation):

    def OnInit(self):
        if not hasattr(self,'FileName'):
            self.FileName = "/tmp/test.txt"

        self.conn = psycopg2.connect(
        host="db",
        database="DemoData",
        user="DemoData",
        password="DemoData",
        port="5432")
        self.conn.autocommit = True

        return 

    def OnTearDown(self):
        self.conn.close()

    def OnMessage(self,request):
        cursor = self.conn.cursor()
        if isinstance(request,FormationRequest):
            sql = "INSERT INTO public.formation ( id,nom,salle ) VALUES ( %s , %s , %s )"
            cursor.execute(sql,(request.formation.id,request.formation.nom,request.formation.salle))
        return 