unit uSalesOrder.Repository.Factory;

interface

uses
  uSalesOrder.Repository.Interfaces,
  uConnection.Types;

type
  TSalesOrderRepositoryFactory = class
    class function Make(APoolConn: Boolean = False; ARepoType: TRepositoryType = rtDefault; ADriverDB: TDriverDB = ddMySql): ISalesOrderRepository;
  end;

implementation

uses
  uSalesOrder.SQLBuilder.Interfaces,
  uSalesOrder.SQLBuilder.MySQL,
  uSession.DTM,
  uSalesOrder.Repository.SQL;

{ TSalesOrderRepositoryFactory }

class function TSalesOrderRepositoryFactory.Make(APoolConn: Boolean; ARepoType: TRepositoryType; ADriverDB: TDriverDB): ISalesOrderRepository;
var
  lRepoType: TRepositoryType;
  lSalesOrderSQLBuilder: ISalesOrderSQLBuilder;
begin
  case ADriverDB of
    ddMySql:    lSalesOrderSQLBuilder := TSalesOrderSQLBuilderMySQL.Make;
    ddFirebird: ; // Exemplo lSalesOrderSQLBuilder := TSalesOrderSQLBuilderFB.Make;
    ddPG:       ; // Exemplo lSalesOrderSQLBuilder := TSalesOrderSQLBuilderPG.Make;
  end;

  lRepoType := ARepoType;
  if (lRepoType = rtDefault) then
    lRepoType := SessionDTM.DefaultRepositoryType;

  case lRepoType of
    rtSQL:      Result := TSalesOrderRepositorySQL.Make(SessionDTM.GetConnection(APoolConn).Connect, lSalesOrderSQLBuilder);
    rtMemory: ; // Exemplo: Result := TSalesOrderRepositoryMemory.Make;
    rtORMBr: ;  // Exemplo: Result := TSalesOrderRepositoryORMBr.Make(AContext);
    rtDORM: ;   // Exemplo: Result := TSalesOrderRepositoryDORM.Make(xxx);
  end;
end;

end.
