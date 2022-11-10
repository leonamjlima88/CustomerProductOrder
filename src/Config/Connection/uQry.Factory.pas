unit uQry.Factory;

interface

uses
  uQry.Interfaces,
  uConnection.Types,
  System.Classes;

type
  TQryFactory = class
  public
    class function Make(AConnection: TComponent; AConnType: TConnectionType = ctDefault): IQry;
  end;

implementation

{ TQryFactory }

uses
  uQry.FireDAC,
  uSession.DTM,
  FireDAC.Comp.Client;

class function TQryFactory.Make(AConnection: TComponent; AConnType: TConnectionType): IQry;
var
  lConnType: TConnectionType;
begin
  lConnType := AConnType;
  if (lConnType = ctDefault) then
    lConnType := SessionDTM.DefaultConnectionType;

  case lConnType of
    ctFireDAC: Result := TQryFireDAC.Make(TFDConnection(AConnection));
    ctZEOS: ;   // Exemplo: Result := TQryZEOS.Make(TFDConnection(AConnection));
    ctUnidac: ; // Exemplo: Result := TQryUnidac.Make(TFDConnection(AConnection));
    ctOthers: ; // Exemplo: ...;
  end;
end;

end.
