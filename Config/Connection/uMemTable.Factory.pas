unit uMemTable.Factory;

interface

uses
  uMemTable.Interfaces,
  uConnection.Types,
  System.Classes;

type
  TMemTableFactory = class
  public
    class function Make(AConnType: TConnectionType = ctDefault): IMemTable;
  end;

implementation

{ TMemTableFactory }

uses
  uMemTable.FireDAC,
  uSession.DTM;

class function TMemTableFactory.Make(AConnType: TConnectionType): IMemTable;
var
  lConnType: TConnectionType;
begin
  lConnType := AConnType;
  if (lConnType = ctDefault) then
    lConnType := SessionDTM.DefaultConnectionType;

  case lConnType of
    ctFireDAC: Result := TMemTableFireDAC.Make;
    // ctClientDataSet: ; // Exemplo: ...;
  end;
end;

end.
