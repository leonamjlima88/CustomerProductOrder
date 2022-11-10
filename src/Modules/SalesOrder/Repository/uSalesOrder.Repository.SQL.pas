unit uSalesOrder.Repository.SQL;

interface

uses
  uSalesOrder.Repository.Interfaces,
  uSalesOrder.SQLBuilder.Interfaces,
  uSalesOrder.Entity.Interfaces,
  uConnection.Interfaces,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  TSalesOrderRepositorySQL = class(TInterfacedObject, ISalesOrderRepository)
  private
    FConn: IConnection;
    FSQLBuilder: ISalesOrderSQLBuilder;
    constructor Create(AConn: IConnection; ASQLBuilder: ISalesOrderSQLBuilder);
  public
    class function Make(AConn: IConnection; ASQLBuilder: ISalesOrderSQLBuilder): ISalesOrderRepository;
    destructor Destroy; override;

    function Delete(AId: Int64): Boolean;
    function Index: TList<ISalesOrderEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): ISalesOrderEntity;
    function Store(AEntity: ISalesOrderEntity): Int64;
    function Update(AEntity: ISalesOrderEntity; AId: Int64): Boolean;
 end;

implementation

uses
  uSelectWithFilter,
  uQry.Interfaces,
  System.SysUtils,
  System.Math,
  uSalesOrder.Entity,
  uSalesOrder.Mapper,
  Vcl.Forms,
  uSalesOrderProduct.Entity.Interfaces, Data.DB;

{ TSalesOrderRepositorySQL }

constructor TSalesOrderRepositorySQL.Create(AConn: IConnection; ASQLBuilder: ISalesOrderSQLBuilder);
begin
  inherited Create;
  FConn       := AConn;
  FSQLBuilder := ASQLBuilder;
end;

function TSalesOrderRepositorySQL.Delete(AId: Int64): Boolean;
begin
  FConn.MakeQry.ExecSQL(FSQLBuilder.DeleteById(AId));
  Result := True;
end;

destructor TSalesOrderRepositorySQL.Destroy;
begin
  inherited;
end;

function TSalesOrderRepositorySQL.Index(APageFilter: IPageFilter): IIndexResult;
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
    lSQLWithoutPaginate := StringReplace(lSQLWithoutPaginate, copy(lSQLWithoutPaginate, Pos('sales_order by', lSQLWithoutPaginate)), '', [rfReplaceAll]);
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

function TSalesOrderRepositorySQL.Index: TList<ISalesOrderEntity>;
var
  lEntity: ISalesOrderEntity;
begin
  Result := TList<ISalesOrderEntity>.Create;

  With FConn.MakeQry.Open(FSQLBuilder.SelectAll) do
  begin
    DataSet.First;
    while not DataSet.Eof do
    begin
      lEntity := TSalesOrderEntity.Create;
      TSalesOrderMapper.DataSetToEntity(DataSet, nil, lEntity);
      Result.Add(lEntity);

      DataSet.Next;
      Application.ProcessMessages;
    end;
  end;
end;

class function TSalesOrderRepositorySQL.Make(AConn: IConnection; ASQLBuilder: ISalesOrderSQLBuilder): ISalesOrderRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

function TSalesOrderRepositorySQL.Show(AId: Int64): ISalesOrderEntity;
var
  lDtsSalesOrder,
  lDtsSalesOrderProduct: TDataSet;
begin
  Result := nil;

  // SalesOrder
  lDtsSalesOrder := FConn.MakeQry.Open(
    FSQLBuilder.SelectById(AId)
  ).DataSet;
  if lDtsSalesOrder.IsEmpty then
    Exit;

  // SalesOrderProduct
  lDtsSalesOrderProduct := FConn.MakeQry.Open(
    FSQLBuilder.SalesOrderProduct.SelectBySalesOrderId(AId)
  ).DataSet;

  // Mapear DataSet Para Entity
  Result := TSalesOrderEntity.Create;
  TSalesOrderMapper.DataSetToEntity(lDtsSalesOrder, lDtsSalesOrderProduct, Result);
end;

function TSalesOrderRepositorySQL.Store(AEntity: ISalesOrderEntity): Int64;
var
  lQry: IQry;
  lItem: ISalesOrderProductEntity;
begin
  try
    FConn.StartTransaction;
    lQry := FConn.MakeQry;

    // SalesOrder
    Result := lQry
      .ExecSQL (FSQLBuilder.InsertInto(AEntity))
      .Open    (FSQLBuilder.LastInsertId)
      .DataSet.Fields[0].AsInteger;

    // SalesOrderProduct
    for lItem in AEntity.sales_order_product_list do
    begin
      lItem.sales_order_id := Result;
      lQry.ExecSQL(FSQLBuilder.SalesOrderProduct.InsertInto(lItem));
    end;

    FConn.CommitTransaction;
  except on E: Exception do
    Begin
      FConn.RollBackTransaction;
      raise;
    End;
  end;
end;

function TSalesOrderRepositorySQL.Update(AEntity: ISalesOrderEntity; AId: Int64): Boolean;
var
  lQry: IQry;
  lItem: ISalesOrderProductEntity;
begin
  try
    FConn.StartTransaction;
    lQry := FConn.MakeQry;

    // SalesOrder
    lQry.ExecSQL(FSQLBuilder.Update(AEntity, AId));

    // SalesOrderProduct
    lQry.ExecSQL(FSQLBuilder.SalesOrderProduct.DeleteBySalesOrderId(AId));
    for lItem in AEntity.sales_order_product_list do
    begin
      lItem.sales_order_id := AId;
      lQry.ExecSQL(FSQLBuilder.SalesOrderProduct.InsertInto(lItem));
    end;

    FConn.CommitTransaction;
  except on E: Exception do
    Begin
      FConn.RollBackTransaction;
      raise;
    End;
  end;

  Result := True;
end;

end.
