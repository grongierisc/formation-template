from dataclasses import dataclass
from xmlrpc.client import Boolean
import grongier.pex

from obj import Formation,FormationIris

@dataclass
class FormationRequest(grongier.pex.Message):

    formation:Formation = None

@dataclass
class FormationIrisRequest(grongier.pex.Message):

    formation:FormationIris = None

@dataclass
class FormationIrisResponse(grongier.pex.Message):

    bool:Boolean = None