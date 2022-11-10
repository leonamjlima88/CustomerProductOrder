unit uCustomer.Service.Interfaces;

interface

uses
  uCustomer.Entity.Interfaces,
  System.Generics.Collections,
  uIndexResult,
  uPageFilter;

type
  ICustomerService = interface
    ['{00AC3E1B-F497-4D99-89BC-A212C7EA18F2}']

    function Delete(AId: Int64): Boolean;
    function Index: TList<ICustomerEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): ICustomerEntity;
    function Store(AEntity: ICustomerEntity): Int64;
    function Update(AEntity: ICustomerEntity; AId: Int64): Boolean;
  end;

implementation

end.
