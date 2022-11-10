unit uProduct.Controller.Interfaces;

interface

uses
  uProduct.Entity.Interfaces,
  uEither,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  IProductController = interface
    ['{8F98086A-F80B-4A6E-A826-FCCBA5D70BD5}']

    /// <summary> Apagar registro por ID </summary>
    /// <param name="AId"> [Int64] ID </param>
    /// <returns> [Boolean] Se apagou </returns>
    function Delete(AId: Int64): Boolean;

    /// <summary> Retorna Lista de pesquisa </summary>
    /// <returns> [TList<IProductEntity] Lista </returns>
    function Index: TList<IProductEntity>; overload;

    /// <summary> Retorna Lista de pesquisa </summary>
    /// <param name="APageFilter"> [IPageFilter] Filtro de dados </param>
    /// <returns> [IIndexResult] Resultado com metadados </returns>
    function Index(APageFilter: IPageFilter): IIndexResult; overload;

    /// <summary> Localizar registro por ID </summary>
    /// <param name="AId"> [Int64] ID </param>
    /// <returns> [TProductEntity/Nil] Registro encontrado/não encontrado </returns>
    function Show(AId: Int64): IProductEntity;

    /// <summary> Incluir um novo registro </summary>
    /// <param name="AEntity"> [TProductEntity] Dados para incluir </param>
    /// <returns> [Either<string, Int64>] String com erros/ID de registro salvo </returns>
    function Store(AEntity: IProductEntity): Either<string, Int64>;

    /// <summary> Atualizar registro por ID </summary>
    /// <param name="AEntity"> [TProductEntity] Dados para atualizar </param>
    /// <param name="AId"> [Int64] ID </param>
    /// <returns> [Either<string, Boolean>] String com erros/status de registro atualizado </returns>
    function Update(AEntity: IProductEntity; AId: Int64): Either<string,Boolean>;
  end;

implementation

end.
