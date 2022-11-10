unit uProduct.Mapper;

interface

uses
  uProduct.Entity.Interfaces,
  Data.DB;

type
  TProductMapper = class
  private
  public
    class procedure EntityToDataSet(const AEntity: IProductEntity; const ADataSet: TDataSet);
    class procedure DataSetToEntity(const ADataSet: TDataSet; const AEntity: IProductEntity);
  end;

implementation

{ TProductMapper }

class procedure TProductMapper.DataSetToEntity(const ADataSet: TDataSet; const AEntity: IProductEntity);
begin
  AEntity.id         := ADataSet.FieldByName('id').AsLargeInt;
  AEntity.name       := ADataSet.FieldByName('name').AsString;
  AEntity.price      := ADataSet.FieldByName('price').AsCurrency;
  AEntity.created_at := ADataSet.FieldByName('created_at').AsDateTime;
  AEntity.updated_at := ADataSet.FieldByName('updated_at').AsDateTime;
end;

class procedure TProductMapper.EntityToDataSet(const AEntity: IProductEntity; const ADataSet: TDataSet);
begin
  if not (ADataSet.State in [dsEdit]) then
    ADataSet.Edit;

  ADataSet.FieldByName('id').AsLargeInt         := AEntity.id;
  ADataSet.FieldByName('name').AsString         := AEntity.name;
  ADataSet.FieldByName('price').AsCurrency      := AEntity.price;
  ADataSet.FieldByName('created_at').AsDateTime := AEntity.created_at;
  ADataSet.FieldByName('updated_at').AsDateTime := AEntity.updated_at;

  if (ADataSet.State in [dsEdit, dsInsert]) then
    ADataSet.Post;
end;

end.
