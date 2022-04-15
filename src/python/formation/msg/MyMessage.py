from dataclasses import dataclass
import grongier.pex

@dataclass
class MyResponse(grongier.pex.Message):
    myValue:str = None

@dataclass
class MyRequest(grongier.pex.Message):
    myValue:str = None