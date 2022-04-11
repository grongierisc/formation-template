import grongier.pex

from msg.Formation import FormationRequest, FormationIrisRequest
from msg.obj.FormationIris import FormationIris


class Router(grongier.pex.BusinessProcess):

    def OnRequest(self, request=FormationRequest):

        msg = FormationIrisRequest()
        msg.formation = FormationIris()
        msg.formation.name = request.formation.nom
        msg.formation.room = request.formation.salle
        self.SendRequestSync('Python.FileOperation',request)
        self.SendRequestSync('Python.IrisOperation',msg)

        return 