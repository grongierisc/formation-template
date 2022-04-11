import grongier.pex

from dataclass_csv import DataclassReader

from msg.obj.Formation import Formation
from msg.Formation import FormationRequest

class ServiceCSV(grongier.pex.BusinessService):

    def getAdapterType():
        """
        Name of the registred adaptor
        """
        return "Ens.InboundAdapter"
    
    def OnInit(self):
        if hasattr(self,'Path'):
            self.Path = self.Path
        else:
            self.Path = '/irisdev/app/misc/'
        return

    def OnProcessInput(self,request):

        filename='formation.csv'
        with open(self.Path+filename) as formation_csv:
            reader = DataclassReader(formation_csv, Formation,delimiter=";")
            for row in reader:
                msg = FormationRequest()
                msg.formation = row
                self.SendRequestSync('Python.Router',msg)

        return

if __name__ == "__main__":

    svc = ServiceCSV()
    svc.OnInit()
    svc.OnProcessInput('')