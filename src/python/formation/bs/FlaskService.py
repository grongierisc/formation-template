import grongier.pex

class FlaskService(grongier.pex.BusinessService):

    def OnInit(self):

        if not hasattr(self,'Target'):
            setattr(self,'Target','Python.RouterFormation')
        return 

    def OnProcessInput(self, messageInput):

        self.SendRequestSync(self.Target,messageInput)

        return 

