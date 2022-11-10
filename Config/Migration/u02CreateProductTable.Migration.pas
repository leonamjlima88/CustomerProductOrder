unit u02CreateProductTable.Migration;

interface

uses
  uMigration.Base,
  uMigration.Interfaces,
  uConnection.Interfaces;

type
  T02CreateProductTable = class(TMigrationBase, IMigration)
  private
    function RunMigrate: IMigration;
    constructor Create(AConn: IConnection);
  public
    class function Make(AConn: IConnection): IMigration;

    function Execute: IMigration;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  uProduct.SQLBuilder.MySQL,
  uProduct.SQLBuilder.Interfaces,
  System.Classes,
  uMigration.Helper;

{ T02CreateProductTable }

function T02CreateProductTable.RunMigrate: IMigration;
var
  lStartTime: Cardinal;
  lDuration: Double;
  lIsValid: Boolean;
begin
  Result     := Self;
  lStartTime := GetTickCount;

  // Criar Tabela
  try
    FConn.StartTransaction;

    lIsValid := FScript
      .SQLScriptsClear
      .SQLScriptsAdd(TProductSQLBuilderMySQL.Make.ScriptCreateTable)
      .ValidateAll;
    if not lIsValid then
      raise Exception.Create('Error validation in migration. ' + Self.ClassName);
    FScript.ExecuteAll;

    // Commit
    FConn.CommitTransaction;
  Except
    FConn.RollBackTransaction;
  end;

  // Seeder
  try
    FConn.StartTransaction;

    lIsValid := FScript
      .SQLScriptsClear
      .SQLScriptsAdd(TProductSQLBuilderMySQL.Make.ScriptSeedTable)
      .ValidateAll;
    if not lIsValid then
      raise Exception.Create('Error seeder in migration. ' + Self.ClassName);
    FScript.ExecuteAll;

    // Commit
    FConn.CommitTransaction;
  Except
    FConn.RollBackTransaction;
  end;

  // Migration Executada
  lDuration := (GetTickCount - lStartTime)/1000;
  FInformation.Executed(True).Duration(lDuration);
end;

constructor T02CreateProductTable.Create(AConn: IConnection);
begin
  inherited Create(AConn);

  // Informações da Migration
  FInformation.CreatedAtByDev(StrToDateTime('08/11/2022 15:47:00'));
end;

function T02CreateProductTable.Execute: IMigration;
begin
  Result := Self;

  // Não executar migration se tabela já existir
  FQry.Open(TMigrationHelper.SQLLocateMigrationTable(
    FConn.DriverDB,
    FConn.DataBaseName,
    'product'
  ));
  if not FQry.DataSet.IsEmpty then
  begin
    FInformation.Executed(True).Duration(-1);
    Exit;
  end;

  RunMigrate;
end;

class function T02CreateProductTable.Make(AConn: IConnection): IMigration;
begin
  Result := Self.Create(AConn);
end;

end.

