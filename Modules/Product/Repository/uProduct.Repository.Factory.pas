unit uProduct.Repository.Factory;

interface

uses
  uProduct.Repository.Interfaces,
  uConnection.Types;

type
  TProductRepositoryFactory = class
    class function Make(APoolConn: Boolean = False; ARepoType: TRepositoryType = rtDefault; ADriverDB: TDriverDB = ddMySql): IProductRepository;
  end;

implementation

uses
  uProduct.SQLBuilder.Interfaces,
  uProduct.SQLBuilder.MySQL,
  uSession.DTM,
  uProduct.Repository.SQL;

{ TProductRepositoryFactory }

class function TProductRepositoryFactory.Make(APoolConn: Boolean; ARepoType: TRepositoryType; ADriverDB: TDriverDB): IProductRepository;
var
  lRepoType: TRepositoryType;
  lProductSQLBuilder: IProductSQLBuilder;
begin
  case ADriverDB of
    ddMySql:    lProductSQLBuilder := TProductSQLBuilderMySQL.Make;
    ddFirebird: ; // Exemplo lProductSQLBuilder := TProductSQLBuilderFB.Make;
    ddPG:       ; // Exemplo lProductSQLBuilder := TProductSQLBuilderPG.Make;
  end;

  lRepoType := ARepoType;
  if (lRepoType = rtDefault) then
    lRepoType := SessionDTM.DefaultRepositoryType;

  case lRepoType of
    rtSQL:      Result := TProductRepositorySQL.Make(SessionDTM.GetConnection(APoolConn).Connect, lProductSQLBuilder);
    rtMemory: ; // Exemplo: Result := TProductRepositoryMemory.Make;
    rtORMBr: ;  // Exemplo: Result := TProductRepositoryORMBr.Make(AContext);
    rtDORM: ;   // Exemplo: Result := TProductRepositoryDORM.Make(xxx);
  end;
end;

end.
