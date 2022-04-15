import grongier.pex

from formation.msg import FormationRequest
from formation.msg.obj import Formation

class FileOperation(grongier.pex.BusinessOperation):

    def OnMessage(self, request:FormationRequest):

        line = f'nom : {request.formation.nom}, salle : {request.formation.salle}'

        self.PutLine('/tmp/formation.txt',line)

        return

    @staticmethod
    def PutLine(filename,string):

        with open(filename, "a",encoding="utf-8") as outfile:
            outfile.write(string+'\n')


if __name__ == "__main__":
    
    op = FileOperation()
    msg = FormationRequest(Formation.Formation('titi','tata'))
    op.OnMessage(msg)

