import grongier.pex
import csv

from msg.Formation import FormationRequest
from msg.obj.Formation import Formation

class FileService(grongier.pex.BusinessService):

    def getAdapterType():
        return "Ens.InboundAdapter"

    def OnInit(self):
        if not hasattr(self,'Target'):
            setattr(self,'Target','Python.RouterFormation')
        if not hasattr(self,'FilePath'):
            self.FilePath = '/irisdev/app/misc/formation.csv'
        return 

    def OnProcessInput(self, messageInput):

        with open(self.FilePath) as f:
            dict = csv.DictReader(f,delimiter=";")

            for item in dict:
                formation = Formation(item['nom'],item['salle'])
                msg = FormationRequest(formation)

                self.SendRequestSync(self.Target,msg)

        return


    