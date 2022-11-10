unit u03CreateSalesOrderTable.Migration;

interface

uses
  uMigration.Base,
  uMigration.Interfaces,
  uConnection.Interfaces;

type
  T03CreateSalesOrderTable = class(TMigrationBase, IMigration)
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
  uSalesOrder.SQLBuilder.MySQL,
  uSalesOrder.SQLBuilder.Interfaces,
  System.Classes,
  uMigration.Helper;

{ T03CreateSalesOrderTable }

function T03CreateSalesOrderTable.RunMigrate: IMigration;
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
      .SQLScriptsAdd(TSalesOrderSQLBuilderMySQL.Make.ScriptCreateTable)
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
      .SQLScriptsAdd(TSalesOrderSQLBuilderMySQL.Make.ScriptSeedTable)
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

constructor T03CreateSalesOrderTable.Create(AConn: IConnection);
begin
  inherited Create(AConn);

  // Informa��es da Migration
  FInformation.CreatedAtByDev(StrToDateTime('08/11/2022 16:18:00'));
end;

function T03CreateSalesOrderTable.Execute: IMigration;
begin
  Result := Self;

  // N�o executar migration se tabela j� existir
  FQry.Open(TMigrationHelper.SQLLocateMigrationTable(
    FConn.DriverDB,
    FConn.DataBaseName,
    'sales_order'
  ));
  if not FQry.DataSet.IsEmpty then
  begin
    FInformation.Executed(True).Duration(-1);
    Exit;
  end;

  RunMigrate;
end;

class function T03CreateSalesOrderTable.Make(AConn: IConnection): IMigration;
begin
  Result := Self.Create(AConn);
end;

end.

