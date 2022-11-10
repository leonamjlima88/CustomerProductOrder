unit uSalesOrder.Mapper;

interface

uses
  uSalesOrder.Entity.Interfaces,
  Data.DB;

type
  TSalesOrderMapper = class
  private
  public
    class procedure EntityToDataSet(const AEntity: ISalesOrderEntity; const ADtsSalesOrder, ADtsSalesOrderProduct: TDataSet);
    class procedure DataSetToEntity(const ADtsSalesOrder, ADtsSalesOrderProduct: TDataSet; const AEntity: ISalesOrderEntity);
  end;

implementation

uses
  Vcl.Forms,
  uSalesOrderProduct.Entity.Interfaces,
  uSalesOrderProduct.Entity;

{ TSalesOrderMapper }

class procedure TSalesOrderMapper.DataSetToEntity(const ADtsSalesOrder, ADtsSalesOrderProduct: TDataSet; const AEntity: ISalesOrderEntity);
var
  lSalesOrderProductEntity: ISalesOrderProductEntity;
begin
  // SalesOrder
  if Assigned(ADtsSalesOrder) then
  Begin
    AEntity.id                             := ADtsSalesOrder.FieldByName('id').AsLargeInt;
    AEntity.customer_id                    := ADtsSalesOrder.FieldByName('customer_id').AsLargeInt;
    AEntity.created_at                     := ADtsSalesOrder.FieldByName('created_at').AsDateTime;
    AEntity.updated_at                     := ADtsSalesOrder.FieldByName('updated_at').AsDateTime;
    AEntity.customer.id                    := ADtsSalesOrder.FieldByName('customer_id').AsLargeInt;
    AEntity.customer.name                  := ADtsSalesOrder.FieldByName('customer_name').AsString;
    AEntity.customer.city                  := ADtsSalesOrder.FieldByName('customer_city').AsString;
    AEntity.customer.state                 := ADtsSalesOrder.FieldByName('customer_state').AsString;
  end;

  // SalesOrderProduct
  if Assigned(ADtsSalesOrderProduct) then
  Begin
    ADtsSalesOrderProduct.First;
    while not ADtsSalesOrderProduct.Eof do
    begin
      lSalesOrderProductEntity                := TSalesOrderProductEntity.Create;
      lSalesOrderProductEntity.id             := ADtsSalesOrderProduct.FieldByName('id').AsLargeInt;
      lSalesOrderProductEntity.sales_order_id := ADtsSalesOrderProduct.FieldByName('sales_order_id').AsLargeInt;
      lSalesOrderProductEntity.product_id     := ADtsSalesOrderProduct.FieldByName('product_id').AsLargeInt;
      lSalesOrderProductEntity.quantity       := ADtsSalesOrderProduct.FieldByName('quantity').AsFloat;
      lSalesOrderProductEntity.unit_price     := ADtsSalesOrderProduct.FieldByName('unit_price').AsCurrency;
      lSalesOrderProductEntity.product.id     := ADtsSalesOrderProduct.FieldByName('product_id').AsLargeInt;
      lSalesOrderProductEntity.product.name   := ADtsSalesOrderProduct.FieldByName('product_name').AsString;
      lSalesOrderProductEntity.product.price  := ADtsSalesOrderProduct.FieldByName('product_price').AsCurrency;
      AEntity.sales_order_product_list.Add(lSalesOrderProductEntity);

      Application.ProcessMessages;
      ADtsSalesOrderProduct.Next;
    end;
  End;
end;

class procedure TSalesOrderMapper.EntityToDataSet(const AEntity: ISalesOrderEntity; const ADtsSalesOrder, ADtsSalesOrderProduct: TDataSet);
var
  lItem: ISalesOrderProductEntity;
begin
  // SalesOrder
  if Assigned(ADtsSalesOrder) then
  Begin
    if not (ADtsSalesOrder.State in [dsEdit]) then
      ADtsSalesOrder.Edit;

    ADtsSalesOrder.FieldByName('id').AsLargeInt                             := AEntity.id;
    ADtsSalesOrder.FieldByName('customer_id').AsLargeInt                    := AEntity.customer_id;
    ADtsSalesOrder.FieldByName('sum_sales_order_product_amount').AsCurrency := AEntity.sum_sales_order_product_amount;
    ADtsSalesOrder.FieldByName('created_at').AsDateTime                     := AEntity.created_at;
    ADtsSalesOrder.FieldByName('updated_at').AsDateTime                     := AEntity.updated_at;

    // Virtual
    ADtsSalesOrder.FieldByName('customer_name').AsString  := AEntity.customer.name;
    ADtsSalesOrder.FieldByName('customer_city').AsString  := AEntity.customer.city;
    ADtsSalesOrder.FieldByName('customer_state').AsString := AEntity.customer.state;

    if not (ADtsSalesOrder.State in [dsEdit, dsInsert]) then
      ADtsSalesOrder.Post;
  end;

  // SalesOrderProduct
  if Assigned(ADtsSalesOrderProduct) then
  Begin
    Try
      ADtsSalesOrderProduct.DisableControls;
      ADtsSalesOrderProduct.First;
      while not ADtsSalesOrderProduct.Eof do
        ADtsSalesOrderProduct.Delete;

      for lItem in AEntity.sales_order_product_list do
      begin
        ADtsSalesOrderProduct.Append;
        ADtsSalesOrderProduct.FieldByName('id').AsLargeInt             := lItem.id;
        ADtsSalesOrderProduct.FieldByName('sales_order_id').AsLargeInt := lItem.sales_order_id;
        ADtsSalesOrderProduct.FieldByName('product_id').AsLargeInt     := lItem.product_id;
        ADtsSalesOrderProduct.FieldByName('quantity').AsFloat          := lItem.quantity;
        ADtsSalesOrderProduct.FieldByName('unit_price').AsCurrency     := lItem.unit_price;
        ADtsSalesOrderProduct.FieldByName('amount').AsCurrency         := lItem.amount;
        ADtsSalesOrderProduct.FieldByName('product_id').AsLargeInt     := lItem.product.id;
        ADtsSalesOrderProduct.FieldByName('product_name').AsString     := lItem.product.name;
        ADtsSalesOrderProduct.FieldByName('product_price').AsCurrency  := lItem.product.price;
        ADtsSalesOrderProduct.Post;
      end;
    finally
      ADtsSalesOrderProduct.First;
      ADtsSalesOrderProduct.EnableControls;
    end;
  end;
end;

end.
