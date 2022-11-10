unit uCustomer.Repository.Factory;

interface

uses
  uCustomer.Repository.Interfaces,
  uConnection.Types;

type
  TCustomerRepositoryFactory = class
    class function Make(APoolConn: Boolean = False; ARepoType: TRepositoryType = rtDefault; ADriverDB: TDriverDB = ddMySql): ICustomerRepository;
  end;

implementation

uses
  uCustomer.SQLBuilder.Interfaces,
  uCustomer.SQLBuilder.MySQL,
  uSession.DTM,
  uCustomer.Repository.SQL;

{ TCustomerRepositoryFactory }

class function TCustomerRepositoryFactory.Make(APoolConn: Boolean; ARepoType: TRepositoryType; ADriverDB: TDriverDB): ICustomerRepository;
var
  lRepoType: TRepositoryType;
  lCustomerSQLBuilder: ICustomerSQLBuilder;
begin
  case ADriverDB of
    ddMySql:    lCustomerSQLBuilder := TCustomerSQLBuilderMySQL.Make;
    ddFirebird: ; // Exemplo lCustomerSQLBuilder := TCustomerSQLBuilderFB.Make;
    ddPG:       ; // Exemplo lCustomerSQLBuilder := TCustomerSQLBuilderPG.Make;
  end;

  lRepoType := ARepoType;
  if (lRepoType = rtDefault) then
    lRepoType := SessionDTM.DefaultRepositoryType;

  case lRepoType of
    rtSQL:      Result := TCustomerRepositorySQL.Make(SessionDTM.GetConnection(APoolConn).Connect, lCustomerSQLBuilder);
    rtMemory: ; // Exemplo: Result := TCustomerRepositoryMemory.Make;
    rtORMBr: ;  // Exemplo: Result := TCustomerRepositoryORMBr.Make(AContext);
    rtDORM: ;   // Exemplo: Result := TCustomerRepositoryDORM.Make(xxx);
  end;
end;

end.
