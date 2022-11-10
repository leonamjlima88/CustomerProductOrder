unit uConnection.Factory;

interface

uses
  uConnection.Interfaces,
  uConnection.Types;

type
  TConnectionFactory = class
  public
    class function Make(AConnType: TConnectionType = ctDefault): IConnection;
  end;

implementation

{ TConnectionFactory }

uses
  uSession.DTM,
  uConnection.FireDAC;

class function TConnectionFactory.Make(AConnType: TConnectionType): IConnection;
var
  lConnType: TConnectionType;
begin
  lConnType := AConnType;
  if (lConnType = ctDefault) then
    lConnType := SessionDTM.DefaultConnectionType;

  case lConnType of
    ctFireDAC: Result := TConnectionFireDAC.Make;
    ctZEOS: ;   // Exemplo: Result := TConnectionZEOS.Make;
    ctUnidac: ; // Exemplo: Result := TConnectionUnidac.Make;
    ctOthers: ; // Exemplo: ...;
  end;
end;

end.
