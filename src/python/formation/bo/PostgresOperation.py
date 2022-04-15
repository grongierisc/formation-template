
import grongier.pex
import psycopg2

from msg.Formation import FormationRequest, FormationResponse,GetFormationRequest
from msg.obj.Formation import Formation

class PostgresOperation(grongier.pex.BusinessOperation):

    def OnInit(self):
        self.conn = psycopg2.connect(
                database="DemoData", user='DemoData', password='DemoData', 
                host='db', port= '5432'
            )
        self.conn.autocommit = True

        return 

    """
        {
        "formation" : {
            "nom":"test",
            "salle":"test"
        }
    }
    """
    def OnMessage(self, request):

        if isinstance(request,FormationRequest):
            self.CreateFormation(request)
        if isinstance(request,GetFormationRequest):
            return self.GetFormation(request)
        return
    
    def CreateFormation(self,request):
        #Creating a cursor object using the cursor() method
        cursor = self.conn.cursor()

        #Executing an Postgres function using the execute() method

        sql = "INSERT INTO public.formation (id, nom, salle) VALUES(%s, %s, %s)"

        cursor.execute(sql,(1,request.formation.nom,request.formation.salle))

        return 

    def GetFormation(self,request):
        sql = "select * from public.formation"
        cursor = self.conn.cursor()
        cursor.execute(sql)
        rows = cursor.fetchall()

        msg = FormationResponse()
        msg.formations = list()

        for row in rows:
            formation = Formation(row[1],row[2])
            msg.formations.append(formation)

        return msg

    def OnTearDown(self):

        self.conn.close()

        return 

