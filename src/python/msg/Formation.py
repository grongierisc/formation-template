from dataclasses import dataclass
import grongier.pex

from msg.obj.Formation import Formation
from msg.obj.FormationIris import FormationIris

@dataclass
class FormationRequest(grongier.pex.Message):

    formation:Formation = None

@dataclass
class FormationIrisRequest(grongier.pex.Message):

    formation:FormationIris = None