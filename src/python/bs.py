import grongier.pex

from dataclass_csv import DataclassReader

from obj import Formation
from msg import FormationRequest

class ServiceCSV(grongier.pex.BusinessService):

    def getAdapterType():
        """
        Name of the registred adaptor
        """
        return "Ens.InboundAdapter"
    
    def OnInit(self):
        if not hasattr(self,'Path'):
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

class FlaskService(grongier.pex.BusinessService):

    def OnInit(self):
        
        if not hasattr(self,'Target'):
            self.Target = "Python.Router"
        
        self.LastPostName = ""
        
        return 1

    def OnProcessInput(self,request):

        return self.SendRequestSync(self.Target,request)

if __name__ == "__main__":

    svc = ServiceCSV()
    svc.OnInit()
    svc.OnProcessInput('')