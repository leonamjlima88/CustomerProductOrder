unit uScript.Factory;

interface

uses
  uScript.Interfaces,
  uConnection.Types,
  System.Classes;

type
  TScriptFactory = class
  public
    class function Make(AConnection: TComponent; AConnType: TConnectionType = ctDefault): IScript;
  end;

implementation

{ TScriptFactory }

uses
  uScript.FireDAC,
  uSession.DTM,
  FireDAC.Comp.Client;

class function TScriptFactory.Make(AConnection: TComponent; AConnType: TConnectionType): IScript;
var
  lConnType: TConnectionType;
begin
  lConnType := AConnType;
  if (lConnType = ctDefault) then
    lConnType := SessionDTM.DefaultConnectionType;

  case lConnType of
    ctFireDAC: Result := TScriptFireDAC.Make(TFDConnection(AConnection));
    ctZEOS: ;   // Exemplo: Result := TScriptZEOS.Make(TFDConnection(AConnection));
    ctUnidac: ; // Exemplo: Result := TScriptUnidac.Make(TFDConnection(AConnection));
    ctOthers: ; // Exemplo: ...;
  end;
end;

end.
