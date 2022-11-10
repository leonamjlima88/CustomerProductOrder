unit uProduct.SQLBuilder.MySQL;

interface

uses
  uProduct.SQLBuilder.Interfaces,
  uProduct.Entity.Interfaces,
  uPageFilter,
  uSelectWithFilter;

type
  TProductSQLBuilderMySQL = class(TInterfacedObject, IProductSQLBuilder)
  public
    class function Make: IProductSQLBuilder;

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

uses
  System.Classes,
  System.SysUtils,
  uConnection.Types;

{ TProductSQLBuilder }

function TProductSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result :=
    ' CREATE TABLE `product` (                   '+
    '   `id` bigint(20) NOT NULL AUTO_INCREMENT, '+
    '   `name` varchar(100) NOT NULL,            '+
    '   `price` decimal(18,4),                   '+
    '   `created_at` datetime NOT NULL,          '+
    '   `updated_at` datetime,                   '+
    '   PRIMARY KEY (`id`),                      '+
    '   KEY `product_idx_name` (`name`)          '+
    ' )                                          ';
end;

function TProductSQLBuilderMySQL.ScriptSeedTable: String;
begin
  Result :=
    ' INSERT INTO product (name, price, created_at) VALUES (''Mouse Logitech'',             ''150'',     ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Teclado Microsoft'',          ''300.99'',  ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''SSD 240GB'',                  ''134.99'',  ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Headset HyperX'',             ''149.99'',  ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Cadeira Gamer'',              ''529.99'',  ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''SmartTV'',                    ''3699.99'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Fone de ouvido sem fio'',     ''299'',     ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Console Playstation 5'',      ''4227.40'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Processador Intel Core I9'',  ''2689.99'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Mousepad Gamer Razer'',       ''89.99'',   ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Memória Gamer Husky 8GB'',    ''129.99'',  ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Webcam Husky'',               ''99.99'',   ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Webcam Husky V2'',            ''99.99'',   ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Webcam Husky V3'',            ''99.99'',   ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Carregador de Tomada'',       ''44'',      ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Geforce RTX 3060'',           ''2799.99'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Controle Sem Fio XBOX'',      ''390.99'',  ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Purificador de Água'',        ''409.99'',  ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Flicks'',                     ''1550952.99'',  ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Nobreak UPS'',                ''1469.00'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Nobreak UPS V2'',             ''1469.00'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO product (name, price, created_at) VALUES (''Nobreak UPS V3'',             ''1469.00'', ''2022/11/09 17:46:00''); ';
end;

function TProductSQLBuilderMySQL.DeleteById(AId: Int64): String;
const
  LSQL = 'DELETE FROM product WHERE product.id = %s';
begin
  Result := Format(LSQL, [QuotedStr(AId.ToString)]);
end;

function TProductSQLBuilderMySQL.InsertInto(AEntity: IProductEntity): String;
const
  LSQL = ' INSERT INTO product         '+
         '   (name, price, created_at) '+
         ' VALUES                      '+
         '   ( %s, %s, %s)             ';
begin
  Result := Format(LSQL, [
    QuotedStr(AEntity.name),
    QuotedStr(StringReplace(FormatFloat('0.0000', AEntity.price), FormatSettings.DecimalSeparator, '.', [rfReplaceAll,rfIgnoreCase])),
    QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', AEntity.created_at))
  ]);
end;

function TProductSQLBuilderMySQL.LastInsertId: String;
begin
  Result := 'SELECT last_insert_id()';
end;

class function TProductSQLBuilderMySQL.Make: IProductSQLBuilder;
begin
  Result := Self.Create;
end;

function TProductSQLBuilderMySQL.SelectAll: String;
begin
  Result := 'SELECT product.* FROM product WHERE product.id IS NOT NULL ';
end;

function TProductSQLBuilderMySQL.SelectAllWithFilter(APageFilter: IPageFilter): TOutPutSelectAllFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(APageFilter, SelectAll, 'product.id', ddMySql);
end;

function TProductSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' and product.id = ' + QuotedStr(AId.ToString);
end;

function TProductSQLBuilderMySQL.Update(AEntity: IProductEntity; AId: Int64): String;
const
  LSQL = ' UPDATE product      '+
         '   SET               '+
         '     name = %s,      '+
         '     price = %s,     '+
         '     updated_at = %s '+
         '   WHERE             '+
         '     (id = %s)       ';
begin
  Result := Format(LSQL, [
    QuotedStr(AEntity.name),
    QuotedStr(StringReplace(FormatFloat('0.0000', AEntity.price), FormatSettings.DecimalSeparator, '.', [rfReplaceAll,rfIgnoreCase])),
    QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', AEntity.updated_at)),
    QuotedStr(AId.ToString)
  ]);
end;

end.

