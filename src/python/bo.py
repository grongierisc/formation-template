from grongier.pex import BusinessOperation
import iris
import os
import psycopg2

import random


from msg import TrainingIrisRequest,FormationRequest,TrainingIrisResponse,PatientRequest

class FileOperation(BusinessOperation):

    def OnInit(self):
        if hasattr(self,'Path'):
            os.chdir(self.Path)
        else:
            os.chdir("/tmp")

    def WriteFormation(self, pRequest:FormationRequest):
        id = salle = nom = ""

        if (pRequest.formation is not None):
            id = str(pRequest.formation.id)
            salle = pRequest.formation.salle
            nom = pRequest.formation.nom

        line = id+" : "+salle+" : "+nom+"\n"

        filename = 'toto.csv'

        self.PutLine(filename, line)

        return 

    def WritePatient(self, pRequest:PatientRequest):
        name = ""
        avg = 0

        if (pRequest.patient is not None):
            name = pRequest.patient.name
            avg = pRequest.patient.avg

        line = name + " avg nb steps : " + str(avg) +"\n"

        filename = 'Patients.csv'

        self.PutLine(filename, line)
        return 
        
    def OnMessage(self, request):
        return 


    @staticmethod
    def PutLine(filename,string):
        try:
            with open(filename, "a",encoding="utf-8",newline="") as outfile:
                outfile.write(string)
        except Exception as e:
            raise e

class IrisOperation(BusinessOperation):

    def InsertTraining(self, request:TrainingIrisRequest):
        resp = TrainingIrisResponse()
        resp.bool = (random.random() < 0.5)
        sql = """
        INSERT INTO iris.training
        ( name, room )
        VALUES( ?, ? )
        """
        iris.sql.exec(sql,request.training.name,request.training.room)
        return resp
        
    def OnMessage(self, request):
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

    def InsertTraining(self,request:FormationRequest):
        cursor = self.conn.cursor()
        sql = "INSERT INTO public.formation ( id,nom,salle ) VALUES ( %s , %s , %s )"
        cursor.execute(sql,(request.formation.id,request.formation.nom,request.formation.salle))
        return 
    
    def OnMessage(self,request):
        return