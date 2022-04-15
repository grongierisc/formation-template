import grongier.pex

from msg.Formation import FormationRequest
from msg.obj.Formation import Formation

class FileOperation(grongier.pex.BusinessOperation):

    def getAdapterType():
        """
        Name of the registred adaptor
        """
        return "EnsLib.File.OutboundAdapter"


    def OnMessage(self, request:FormationRequest):

        line = f'nom : {request.formation.nom}, salle : {request.formation.salle}'

        self.Adapter.PutLine('formation.txt',line)

        return

