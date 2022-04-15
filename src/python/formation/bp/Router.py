import grongier.pex

from msg.MyMessage import MyRequest

class MyRouter(grongier.pex.BusinessProcess):

    def OnRequest(self, request):

        msg = MyRequest('hello')

        self.SendRequestSync('Python.MyOperation',msg)

        return

