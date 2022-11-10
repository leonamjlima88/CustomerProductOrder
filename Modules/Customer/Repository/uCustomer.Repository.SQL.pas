unit uCustomer.Repository.SQL;

interface

uses
  uCustomer.Repository.Interfaces,
  uCustomer.SQLBuilder.Interfaces,
  uCustomer.Entity.Interfaces,
  uConnection.Interfaces,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  TCustomerRepositorySQL = class(TInterfacedObject, ICustomerRepository)
  private
    FConn: IConnection;
    FSQLBuilder: ICustomerSQLBuilder;
    constructor Create(AConn: IConnection; ASQLBuilder: ICustomerSQLBuilder);
  public
    class function Make(AConn: IConnection; ASQLBuilder: ICustomerSQLBuilder): ICustomerRepository;
    destructor Destroy; override;

    function Delete(AId: Int64): Boolean;
    function Index: TList<ICustomerEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): ICustomerEntity;
    function Store(AEntity: ICustomerEntity): Int64;
    function Update(AEntity: ICustomerEntity; AId: Int64): Boolean;
 end;

implementation

uses
  uSelectWithFilter,
  uQry.Interfaces,
  System.SysUtils,
  System.Math,
  uCustomer.Entity,
  uCustomer.Mapper,
  Vcl.Forms;

{ TCustomerRepositorySQL }

constructor TCustomerRepositorySQL.Create(AConn: IConnection; ASQLBuilder: ICustomerSQLBuilder);
begin
  inherited Create;
  FConn       := AConn;
  FSQLBuilder := ASQLBuilder;
end;

function TCustomerRepositorySQL.Delete(AId: Int64): Boolean;
begin
  FConn.MakeQry.ExecSQL(FSQLBuilder.DeleteById(AId));
  Result := True;
end;

destructor TCustomerRepositorySQL.Destroy;
begin
  inherited;
end;

function TCustomerRepositorySQL.Index(APageFilter: IPageFilter): IIndexResult;
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

  // Contar registros sem paginação
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
  lQry.Close;
end;

function TCustomerRepositorySQL.Index: TList<ICustomerEntity>;
var
  lEntity: ICustomerEntity;
begin
  Result := TList<ICustomerEntity>.Create;

  With FConn.MakeQry.Open(FSQLBuilder.SelectAll) do
  begin
    DataSet.First;
    while not DataSet.Eof do
    begin
      lEntity := TCustomerEntity.Create;
      TCustomerMapper.DataSetToEntity(DataSet, lEntity);
      Result.Add(lEntity);

      DataSet.Next;
      Application.ProcessMessages;
    end;
  end;
end;

class function TCustomerRepositorySQL.Make(AConn: IConnection; ASQLBuilder: ICustomerSQLBuilder): ICustomerRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

function TCustomerRepositorySQL.Show(AId: Int64): ICustomerEntity;
begin
  Result := nil;
  With FConn.MakeQry.Open(FSQLBuilder.SelectById(AId)) do
  begin
    if DataSet.IsEmpty then Exit;
    Result := TCustomerEntity.Create;
    TCustomerMapper.DataSetToEntity(DataSet, Result);
  end;
end;

function TCustomerRepositorySQL.Store(AEntity: ICustomerEntity): Int64;
begin
  Result := FConn.MakeQry
    .ExecSQL (FSQLBuilder.InsertInto(AEntity))
    .Open    (FSQLBuilder.LastInsertId)
    .DataSet.Fields[0].AsLargeInt;
end;

function TCustomerRepositorySQL.Update(AEntity: ICustomerEntity; AId: Int64): Boolean;
begin
  FConn.MakeQry.ExecSQL(FSQLBuilder.Update(AEntity, AId));
  Result := True;
end;

end.
