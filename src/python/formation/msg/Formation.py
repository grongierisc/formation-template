from dataclasses import dataclass
from typing import List
import grongier.pex

from formation.msg.obj import Formation

@dataclass
class FormationRequest(grongier.pex.Message):

    formation:Formation = None

@dataclass
class FormationResponse(grongier.pex.Message):

    formations:List[Formation] = None

@dataclass
class GetFormationRequest(grongier.pex.Message):

    id:int = None
