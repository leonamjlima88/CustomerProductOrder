unit uMemTable.FireDAC;

interface

uses
  uMemTable.Interfaces,
  Data.DB,
  FireDAC.Comp.Client;

type
  TMemTableFireDAC = class(TInterfacedObject, IMemTable)
  private
    FMemTable: TFDMemTable;
    FActive: Boolean;
    constructor Create;
  public
    destructor Destroy; override;
    class function Make: IMemTable;

    function FromDataSet(ADataSet: TDataSet): IMemTable;
    function DataSet: TDataSet;
    function FieldDefs: TFieldDefs;
    function CreateDataSet: IMemTable;
    function Active: Boolean; overload;
    function Active(AValue: Boolean): IMemTable; overload;
  end;

implementation

uses
  System.SysUtils;

{ TMemTableFireDAC }

function TMemTableFireDAC.Active(AValue: Boolean): IMemTable;
begin
  Result := Self;
  FActive := AValue;
end;

function TMemTableFireDAC.Active: Boolean;
begin
  Result := FActive;
end;

constructor TMemTableFireDAC.Create;
begin
  inherited Create;
  FMemTable := TFDMemTable.Create(nil);
end;

function TMemTableFireDAC.CreateDataSet: IMemTable;
begin
  Result := Self;
  FMemTable.CreateDataSet;
end;

function TMemTableFireDAC.DataSet: TDataSet;
begin
  Result := TDataSet(FMemTable);
end;

destructor TMemTableFireDAC.Destroy;
begin
  if Assigned(FMemTable) then FreeAndNil(FMemTable);

  inherited;
end;

function TMemTableFireDAC.FieldDefs: TFieldDefs;
begin
  Result := FMemTable.FieldDefs;
end;

function TMemTableFireDAC.FromDataSet(ADataSet: TDataSet): IMemTable;
var
  lCloneSource: TFDMemTable;
  lI: Integer;
begin
  Result := Self;

  if not Assigned(FMemTable) then raise Exception.Create('FMemTable is null');
  if not Assigned(ADataSet) then raise Exception.Create('ADataSet is null');
  if not ADataSet.Active    then raise Exception.Create('ADataSet is not active');

  Try
    lCloneSource := TFDMemTable.Create(nil);
    lCloneSource.CloneCursor(TFDMemTable(ADataSet), true);

    FMemTable.DisableControls;
    lCloneSource.DisableControls;

    // Limpar dados de Target se existir
    if FMemTable.Active then
    Begin
      FMemTable.EmptyDataSet;
      FMemTable.Close;
    End;

    // Cópia dos dados para Target
    FMemTable.Data := lCloneSource.Data;

    // Nenhum campo é readonly
    for lI := 0 to Pred(ADataSet.Fields.Count) do
      ADataSet.Fields[lI].ReadOnly := False;
  Finally
    FMemTable.EnableControls;
    lCloneSource.EnableControls;
    if Assigned(lCloneSource) then
      FreeAndNil(lCloneSource);
  End;
end;

class function TMemTableFireDAC.Make: IMemTable;
begin
  Result := Self.Create;
end;

end.
