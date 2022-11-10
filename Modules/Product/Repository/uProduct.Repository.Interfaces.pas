unit uProduct.Repository.Interfaces;

interface

uses
  uProduct.Entity.Interfaces,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  IProductRepository = interface
    ['{A478AB27-C707-4BA5-9DE9-CCAD319CBC46}']

    function Delete(AId: Int64): Boolean;
    function Index: TList<IProductEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): IProductEntity;
    function Store(AEntity: IProductEntity): Int64;
    function Update(AEntity: IProductEntity; AId: Int64): Boolean;
  end;

implementation

end.
