from dataclasses import dataclass

@dataclass
class Formation:

    id:int = None
    nom:str = None
    salle:str = None

@dataclass
class Training:

    name:str = None
    room:str = None

@dataclass
class Patient:
    name:str = None
    avg:int = None
    infos:List(str,str) = None