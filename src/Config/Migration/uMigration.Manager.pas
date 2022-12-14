unit uMigration.Manager;

interface

uses
  uMigration.Interfaces,
  System.Generics.Collections,
  uConnection.Interfaces,
  uQry.Interfaces;

type
  TMigrationManager = class(TInterfacedObject, IMigrationManager)
  private
    FConn: IConnection;
    FQry: IQry;
    FQryMigrationsPerformed: IQry;
    FMigrations: TList<IMigration>;

    function SetUp: IMigrationManager;
    function RunPendingMigrations: IMigrationManager;
    function RegiterMigrationInformation(AInformation: IMigrationInfo; ABatch: String): IMigrationManager;
    function CreateMigrationIfNotExists: IMigrationManager;
    function CreateUUID: string;
  public
    constructor Create(AConn: IConnection);
    destructor Destroy; override;
    class function Make(AConn: IConnection): IMigrationManager;

    function Execute: IMigrationManager;
    function Migrations: TList<IMigration>;
  end;

implementation

{ TMigrationManager }

uses
  System.SysUtils,
  Winapi.Windows,
  Winapi.ActiveX,
  System.DateUtils,
  uEnv,
  uMigration.Helper,
  u01CreateCustomerTable.Migration,
  u02CreateProductTable.Migration,
  u03CreateSalesOrderTable.Migration,
  u04CreateSalesOrderProductTable.Migration;

const
  MIGRATION_ORDER_BY_DESCRIPTION = 'select * from migration order by description';
  MIGRATION_SELECT_EMPTY = 'select * from migration where id is null';

function TMigrationManager.SetUp: IMigrationManager;
begin
  Result := Self;

  // Criar tabela de migration se n?o existir
  CreateMigrationIfNotExists;

  // Migra??es que j? foram executadas
  FQryMigrationsPerformed.Open(MIGRATION_ORDER_BY_DESCRIPTION);

  // Lista de Migra??es
  FMigrations.Clear;
  FMigrations.Add(T01CreateCustomerTable.Make(FConn));
  FMigrations.Add(T02CreateProductTable.Make(FConn));
  FMigrations.Add(T03CreateSalesOrderTable.Make(FConn));
  FMigrations.Add(T04CreateSalesOrderProductTable.Make(FConn));
end;

constructor TMigrationManager.Create(AConn: IConnection);
begin
  FConn                   := AConn;
  FQry                    := AConn.MakeQry;
  FQryMigrationsPerformed := AConn.MakeQry;

  FMigrations := TList<IMigration>.Create;
end;

function TMigrationManager.CreateMigrationIfNotExists: IMigrationManager;
var
  lSQL: String;
begin
  Result := Self;

  FQry.Open(TMigrationHelper.SQLLocateMigrationTable(
    FConn.DriverDB,
    FConn.DataBaseName,
    'migration'
  ));
  if not FQry.DataSet.IsEmpty then
    Exit;

  FQry.ExecSQL(TMigrationHelper.SQLCreateMigrationTable(FConn.DriverDB));
end;

function TMigrationManager.CreateUUID: string;
var
  lId: TGUID;
begin
  if (CoCreateGuid(lId) = S_OK) then
    Result := GUIDToString(lId);

  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
end;

destructor TMigrationManager.Destroy;
begin
  // Fechar transa??o se existir
  FConn.CommitTransaction;

  if Assigned(FMigrations) then FreeAndNil(FMigrations);
  if Assigned(FMigrations) then FreeAndNil(FMigrations);

  inherited;
end;

function TMigrationManager.Execute: IMigrationManager;
begin
  Result := Self;

  SetUp;
  RunPendingMigrations;
end;

class function TMigrationManager.Make(AConn: IConnection): IMigrationManager;
begin
  Result := Self.Create(AConn);
end;

function TMigrationManager.Migrations: TList<IMigration>;
begin
  Result := FMigrations;
end;

function TMigrationManager.RegiterMigrationInformation(AInformation: IMigrationInfo; ABatch: String): IMigrationManager;
const
  LSQL = ' INSERT INTO migration                                                '+
         '   (id, description, created_at_by_dev, duration, batch, executed_at) '+
         ' VALUES                                                               '+
         '   (%s, %s, %s, %s, %s, %s)                                           ';
begin
  Result := Self;

  // Registrar Migration
  FQry.ExecSQL(Format(LSQL, [
    QuotedStr(CreateUUID),
    QuotedStr(AInformation.Description),
    QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', AInformation.CreatedAtByDev)),
    QuotedStr(StringReplace(FormatFloat('0.0000', AInformation.duration), FormatSettings.DecimalSeparator, '.', [rfReplaceAll,rfIgnoreCase])),
    QuotedStr(ABatch),
    QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', now))
  ]));
end;

function TMigrationManager.RunPendingMigrations: IMigrationManager;
var
  lM: IMigration;
  lBatch: String;
begin
  Result := Self;

  // Executar Migra??es Pendentes
  // Batch ? para controle de lote de migrations, caso precise fazer um rollback
  lBatch := CreateUUID;
  for lM in FMigrations do
  begin
    if not FQryMigrationsPerformed.Locate('description', lM.Information.Description) then
    begin
      // Executar Migra??o
      if lM.Execute.Information.Executed then
        RegiterMigrationInformation(lM.Information, lBatch);
    end;
  end;
end;

end.
