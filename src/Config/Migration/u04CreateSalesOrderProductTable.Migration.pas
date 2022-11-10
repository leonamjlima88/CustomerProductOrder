unit u04CreateSalesOrderProductTable.Migration;

interface

uses
  uMigration.Base,
  uMigration.Interfaces,
  uConnection.Interfaces;

type
  T04CreateSalesOrderProductTable = class(TMigrationBase, IMigration)
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
  uSalesOrderProduct.SQLBuilder.MySQL,
  uSalesOrderProduct.SQLBuilder.Interfaces,
  System.Classes,
  uMigration.Helper;

{ T04CreateSalesOrderProductTable }

function T04CreateSalesOrderProductTable.RunMigrate: IMigration;
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
      .SQLScriptsAdd(TSalesOrderProductSQLBuilderMySQL.Make.ScriptCreateTable)
      .ValidateAll;
    if not lIsValid then
      raise Exception.Create('Error validation in migration. ' + Self.ClassName);
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

constructor T04CreateSalesOrderProductTable.Create(AConn: IConnection);
begin
  inherited Create(AConn);

  // Informações da Migration
  FInformation.CreatedAtByDev(StrToDateTime('08/11/2022 17:16:00'));
end;

function T04CreateSalesOrderProductTable.Execute: IMigration;
begin
  Result := Self;

  // Não executar migration se tabela já existir
  FQry.Open(TMigrationHelper.SQLLocateMigrationTable(
    FConn.DriverDB,
    FConn.DataBaseName,
    'sales_order_product'
  ));
  if not FQry.DataSet.IsEmpty then
  begin
    FInformation.Executed(True).Duration(-1);
    Exit;
  end;

  RunMigrate;
end;

class function T04CreateSalesOrderProductTable.Make(AConn: IConnection): IMigration;
begin
  Result := Self.Create(AConn);
end;

end.

