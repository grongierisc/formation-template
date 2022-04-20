from grongier.pex import BusinessProcess

from msg import FormationRequest, TrainingIrisRequest
from obj import Training


class Router(BusinessProcess):

    def OnRequest(self, request):
        if isinstance(request,FormationRequest):
            msg = TrainingIrisRequest()
            msg.training = Training()
            msg.training.name = request.formation.nom
            msg.training.room = request.formation.salle
            self.SendRequestSync('Python.FileOperation',request)
            formIrisResp = self.SendRequestSync('Python.IrisOperation',msg)
            if formIrisResp.bool:
                self.SendRequestSync('Python.PostgresOperation',request)

        return 