unit uProduct.SQLBuilder.Interfaces;

interface

uses
  uProduct.Entity.Interfaces,
  uPageFilter,
  uSelectWithFilter;

type
  IProductSQLBuilder = interface
    ['{D68CD24A-B927-4FCD-90E4-9895B7FDCB7F}']

    // Product
    function ScriptCreateTable: String;
    function ScriptSeedTable: String;
    function DeleteById(AId: Int64): String;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function InsertInto(AEntity: IProductEntity): String;
    function LastInsertId: String;
    function Update(AEntity: IProductEntity; AId: Int64): String;
    function SelectAllWithFilter(APageFilter: IPageFilter): TOutPutSelectAllFilter;
  end;

implementation

end.
