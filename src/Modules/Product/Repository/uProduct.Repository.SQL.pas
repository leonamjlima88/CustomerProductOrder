unit uProduct.Repository.SQL;

interface

uses
  uProduct.Repository.Interfaces,
  uProduct.SQLBuilder.Interfaces,
  uProduct.Entity.Interfaces,
  uConnection.Interfaces,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  TProductRepositorySQL = class(TInterfacedObject, IProductRepository)
  private
    FConn: IConnection;
    FSQLBuilder: IProductSQLBuilder;
    constructor Create(AConn: IConnection; ASQLBuilder: IProductSQLBuilder);
  public
    class function Make(AConn: IConnection; ASQLBuilder: IProductSQLBuilder): IProductRepository;
    destructor Destroy; override;

    function Delete(AId: Int64): Boolean;
    function Index: TList<IProductEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): IProductEntity;
    function Store(AEntity: IProductEntity): Int64;
    function Update(AEntity: IProductEntity; AId: Int64): Boolean;
 end;

implementation

uses
  uSelectWithFilter,
  uQry.Interfaces,
  System.SysUtils,
  System.Math,
  uProduct.Entity,
  uProduct.Mapper,
  Vcl.Forms;

{ TProductRepositorySQL }

constructor TProductRepositorySQL.Create(AConn: IConnection; ASQLBuilder: IProductSQLBuilder);
begin
  inherited Create;
  FConn       := AConn;
  FSQLBuilder := ASQLBuilder;
end;

function TProductRepositorySQL.Delete(AId: Int64): Boolean;
begin
  FConn.MakeQry.ExecSQL(FSQLBuilder.DeleteById(AId));
  Result := True;
end;

destructor TProductRepositorySQL.Destroy;
begin
  inherited;
end;

function TProductRepositorySQL.Index(APageFilter: IPageFilter): IIndexResult;
var
  lOutPut: TOutPutSelectAllFilter;
  lSQLPaginate, lSQLWithoutPaginate: String;
  lAllPagesRecordCount, lCurrentPageRecordCount, lLastPageNumber: Integer;
  lQry: IQry;
begin
  Result := TIndexResult.Make;
  lQry := FConn.MakeQry;

  // SQL com paginação e sem paginação
  lOutPut             := FSQLBuilder.SelectAllWithFilter(APageFilter);
  lSQLPaginate        := lOutPut.SQL;
  lSQLWithoutPaginate := lOutPut.SQLWithoutPaginate;

  // Executar sql com paginação
  lQry.Open(lSQLPaginate);
  Result.Data.FromDataSet(lQry.DataSet);
  lCurrentPageRecordCount := Result.Data.DataSet.RecordCount;

  if Assigned(APageFilter) then
  begin
    lSQLWithoutPaginate := 'select count(*) ' + copy(lSQLWithoutPaginate, Pos('from', lSQLWithoutPaginate));
    lSQLWithoutPaginate := StringReplace(lSQLWithoutPaginate, copy(lSQLWithoutPaginate, Pos('order by', lSQLWithoutPaginate)), '', [rfReplaceAll]);
    lQry.Open(lSQLWithoutPaginate);
    lAllPagesRecordCount := lQry.DataSet.Fields[0].AsInteger;
    lLastPageNumber := 1;
    if (APageFilter.LimitPerPage > 0) then
      lLastPageNumber := ceil(lAllPagesRecordCount/APageFilter.LimitPerPage);

    // Metadados
    Result.CurrentPage        (APageFilter.CurrentPage)
      .CurrentPageRecordCount (lCurrentPageRecordCount)
      .LastPageNumber         (lLastPageNumber)
      .AllPagesRecordCount    (lAllPagesRecordCount)
      .LimitPerPage           (APageFilter.LimitPerPage)
      .NavFirst               (APageFilter.CurrentPage > 1)
      .NavPrior               (APageFilter.CurrentPage > 1)
      .NavNext                (not (APageFilter.CurrentPage = lLastPageNumber))
      .NavLast                (not (APageFilter.CurrentPage = lLastPageNumber));
  end;
end;

function TProductRepositorySQL.Index: TList<IProductEntity>;
var
  lEntity: IProductEntity;
begin
  Result := TList<IProductEntity>.Create;

  With FConn.MakeQry.Open(FSQLBuilder.SelectAll) do
  begin
    DataSet.First;
    while not DataSet.Eof do
    begin
      lEntity := TProductEntity.Create;
      TProductMapper.DataSetToEntity(DataSet, lEntity);
      Result.Add(lEntity);

      DataSet.Next;
      Application.ProcessMessages;
    end;
  end;
end;

class function TProductRepositorySQL.Make(AConn: IConnection; ASQLBuilder: IProductSQLBuilder): IProductRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

function TProductRepositorySQL.Show(AId: Int64): IProductEntity;
begin
  Result := nil;
  With FConn.MakeQry.Open(FSQLBuilder.SelectById(AId)) do
  begin
    if DataSet.IsEmpty then Exit;
    Result := TProductEntity.Create;
    TProductMapper.DataSetToEntity(DataSet, Result);
  end;
end;

function TProductRepositorySQL.Store(AEntity: IProductEntity): Int64;
begin
  Result := FConn.MakeQry
    .ExecSQL (FSQLBuilder.InsertInto(AEntity))
    .Open    (FSQLBuilder.LastInsertId)
    .DataSet.Fields[0].AsLargeInt;
end;

function TProductRepositorySQL.Update(AEntity: IProductEntity; AId: Int64): Boolean;
begin
  FConn.MakeQry.ExecSQL(FSQLBuilder.Update(AEntity, AId));
  Result := True;
end;

end.
