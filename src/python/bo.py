import grongier.pex
import datetime
import iris
import os
import psycopg2

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

            #filename = '/tmp/toto.csv'
            filename = '/tmp/toto.csv'

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

class PostgresOperation(grongier.pex.BusinessOperation):

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
        return 1

    def OnTearDown(self):
        self.conn.close()

    def OnMessage(self,request):
        cur = self.conn.cursor()
        if isinstance(request,FormationRequest):
            sql = "INSERT INTO public.formation ( id,nom,salle ) VALUES ( %s , %s , %s )"
            cur.execute(sql,(request.formation.id,request.formation.nom,request.formation.salle))
        return 