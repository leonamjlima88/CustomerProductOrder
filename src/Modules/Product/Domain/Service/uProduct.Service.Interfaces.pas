unit uProduct.Service.Interfaces;

interface

uses
  uProduct.Entity.Interfaces,
  System.Generics.Collections,
  uIndexResult,
  uPageFilter;

type
  IProductService = interface
    ['{AD26061A-1027-4591-8661-3E2049E807AF}']

    function Delete(AId: Int64): Boolean;
    function Index: TList<IProductEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): IProductEntity;
    function Store(AEntity: IProductEntity): Int64;
    function Update(AEntity: IProductEntity; AId: Int64): Boolean;
  end;

implementation

end.
