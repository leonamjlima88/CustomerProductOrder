unit uCustomer.Repository.Interfaces;

interface

uses
  uCustomer.Entity.Interfaces,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  ICustomerRepository = interface
    ['{320133BA-76DB-49A8-8E17-D54EA479524E}']

    function Delete(AId: Int64): Boolean;
    function Index: TList<ICustomerEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): ICustomerEntity;
    function Store(AEntity: ICustomerEntity): Int64;
    function Update(AEntity: ICustomerEntity; AId: Int64): Boolean;
  end;

implementation

end.
