unit uSalesOrder.Repository.Interfaces;

interface

uses
  uSalesOrder.Entity.Interfaces,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  ISalesOrderRepository = interface
    ['{763F9914-FBA0-40CF-8FF9-7F7D0CD41283}']

    function Delete(AId: Int64): Boolean;
    function Index: TList<ISalesOrderEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): ISalesOrderEntity;
    function Store(AEntity: ISalesOrderEntity): Int64;
    function Update(AEntity: ISalesOrderEntity; AId: Int64): Boolean;
  end;

implementation

end.
