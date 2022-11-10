unit uConnection.Types;

interface

type
  TConnectionType = (ctDefault, ctFireDAC, ctZEOS, ctUnidac, ctOthers);
  TRepositoryType = (rtDefault, rtSQL, rtMemory, rtORMBr, rtDORM, rtAurelius, rtEntityDac, rtOthers);
  TDriverDB =       (ddMySql, ddFirebird, ddPG, ddMsql, ddOthers);
  TEntityState =    (esNone, esStore, esUpdate);

implementation

end.
