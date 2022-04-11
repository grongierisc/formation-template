import grongier.pex
import datetime
import os


class FileOperation(grongier.pex.BusinessOperation):

    def OnInit(self):
        if hasattr(self,'Path'):
            os.chdir(self.Path)

    def OnMessage(self, pRequest):
        
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