import grongier.pex

from msg.obj.Formation import Formation
from msg.Formation import FormationRequest

class RouterFormation(grongier.pex.BusinessProcess):

    def OnRequest(self, request):
        
        if isinstance(request,FormationRequest):
            msg=request
            msg.formation.nom = 'in isinstance'
        else:
            formation = Formation('toto','tata')
            msg = FormationRequest(formation)

        self.SendRequestSync('Python.FileOperation',msg)
        
        return