import grongier.pex
import iris

from msg.MyMessage import MyResponse,MyRequest

class MyOperation(grongier.pex.BusinessOperation):

    def OnInit(self):
        self.LOGINFO("OnInit")
        return 

    def OnMessage(self, request):
        self.LOGINFO('Hello2')
        msg = iris.cls('Ens.StringResponse')._New('Bonjour')
        msg = MyResponse('bonjour')

        sql = """
        INSERT INTO iris.formation
        ( name, room)
        VALUES( ?,? )
        """
        iris.sql.exec(sql,'toto','toto')
        return msg
    