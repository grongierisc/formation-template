import grongier.pex

import iris

from msg.Formation import FormationIrisRequest

class IrisOperation(grongier.pex.BusinessOperation):

    def OnMessage(self, request=FormationIrisRequest):
        
        sql = """
        INSERT INTO iris.formation
        ( name, room)
        VALUES( ?, ?)
        """
        iris.sql.exec(sql,request.formation.name,request.formation.room)
        
        return 

if __name__ == "__main__":

    svc = IrisOperation()
    request = FormationIrisRequest()
    svc.OnMessage(request)