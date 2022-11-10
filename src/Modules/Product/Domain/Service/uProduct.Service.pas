unit uProduct.Service;

interface

uses
  uProduct.Service.Interfaces,
  uProduct.Entity.Interfaces,
  uProduct.Repository.Interfaces,
  System.Generics.Collections,
  uIndexResult,
  uPageFilter;

type
  TProductService = class(TInterfacedObject, IProductService)
  private
    FRepository: IProductRepository;
    constructor Create(ARepository: IProductRepository);
  public
    class function Make(ARepository: IProductRepository): IProductService;
    function Delete(AId: Int64): Boolean;
    function Index: TList<IProductEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): IProductEntity;
    function Store(AEntity: IProductEntity): Int64;
    function Update(AEntity: IProductEntity; AId: Int64): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TProductService }

constructor TProductService.Create(ARepository: IProductRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TProductService.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TProductService.Index(APageFilter: IPageFilter): IIndexResult;
begin
  Result := FRepository.Index(APageFilter);
end;

function TProductService.Index: TList<IProductEntity>;
begin
  Result := FRepository.Index;
end;

class function TProductService.Make(ARepository: IProductRepository): IProductService;
begin
  Result := Self.Create(ARepository);
end;

function TProductService.Show(AId: Int64): IProductEntity;
begin
  Result := FRepository.Show(AId);
end;

function TProductService.Store(AEntity: IProductEntity): Int64;
begin
  AEntity.created_at := now;
  Result := FRepository.Store(AEntity);
end;

function TProductService.Update(AEntity: IProductEntity; AId: Int64): Boolean;
begin
  AEntity.updated_at := now;
  Result := FRepository.Update(AEntity, AId);
end;

end.
