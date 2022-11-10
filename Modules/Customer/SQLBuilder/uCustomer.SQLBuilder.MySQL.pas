unit uCustomer.SQLBuilder.MySQL;

interface

uses
  uCustomer.SQLBuilder.Interfaces,
  uCustomer.Entity.Interfaces,
  uPageFilter,
  uSelectWithFilter;

type
  TCustomerSQLBuilderMySQL = class(TInterfacedObject, ICustomerSQLBuilder)
  public
    class function Make: ICustomerSQLBuilder;

    // Customer
    function ScriptCreateTable: String;
    function ScriptSeedTable: String;
    function DeleteById(AId: Int64): String;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function InsertInto(AEntity: ICustomerEntity): String;
    function LastInsertId: String;
    function Update(AEntity: ICustomerEntity; AId: Int64): String;
    function SelectAllWithFilter(APageFilter: IPageFilter): TOutPutSelectAllFilter;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  uConnection.Types;

{ TCustomerSQLBuilder }

function TCustomerSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result :=
    ' CREATE TABLE `customer` (                  '+
    '   `id` bigint(20) NOT NULL AUTO_INCREMENT, '+
    '   `name` varchar(100) NOT NULL,            '+
    '   `city` varchar(80),                      '+
    '   `state` char(2),                         '+
    '   `created_at` datetime NOT NULL,          '+
    '   `updated_at` datetime,                   '+
    '   PRIMARY KEY (`id`),                      '+
    '   KEY `customer_idx_city` (`city`),        '+
    '   KEY `customer_idx_state` (`state`)       '+
    ' )                                          ';
end;

function TCustomerSQLBuilderMySQL.ScriptSeedTable: String;
begin
  Result :=
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Leonam'',    ''Mogi Guaçu'',     ''SP'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''José'',      ''Mogi Guaçu'',     ''SP'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Lima'',      ''Mogi Guaçu'',     ''SP'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Roberta'',   ''Mogi Guaçu'',     ''SP'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Alexandre'', ''Mogi Mirim'',     ''SP'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Marcos'',    ''Mogi Mirim'',     ''SP'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Santos'',    ''Mogi Mirim'',     ''SP'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Amauri'',    ''Mogi Mirim'',     ''SP'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Diego'',     ''Campinas'',       ''SP'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Carla'',     ''Belo Horizonte'', ''MG'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Adriana'',   ''Belo Horizonte'', ''MG'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Roberto'',   ''Belo Horizonte'', ''MG'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Helena'',    ''Belo Horizonte'', ''MG'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Kuyru'',     ''Campinas'',       ''SP'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Miguel'',    ''Campinas'',       ''SP'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Arthur'',    ''Florianópolis'',  ''SC'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Gael'',      ''Florianópolis'',  ''SC'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Heitor'',    ''Blumenau'',       ''SC'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Theo'',      ''Blumenau'',       ''SC'', ''2022/11/09 17:46:00''); '+
    ' INSERT INTO customer (name, city, state, created_at) VALUES (''Davi'',      ''Chapecó'',        ''SC'', ''2022/11/09 17:46:00''); ';
end;

function TCustomerSQLBuilderMySQL.DeleteById(AId: Int64): String;
const
  LSQL = 'DELETE FROM customer WHERE customer.id = %s';
begin
  Result := Format(LSQL, [QuotedStr(AId.ToString)]);
end;

function TCustomerSQLBuilderMySQL.InsertInto(AEntity: ICustomerEntity): String;
const
  LSQL = ' INSERT INTO customer               '+
         '   (name, city, state, created_at)  '+
         ' VALUES                             '+
         '   ( %s, %s, %s, %s)                ';
begin
  Result := Format(LSQL, [
    QuotedStr(AEntity.name),
    QuotedStr(AEntity.city),
    QuotedStr(AEntity.state),
    QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', AEntity.created_at))
  ]);
end;

function TCustomerSQLBuilderMySQL.LastInsertId: String;
begin
  Result := 'SELECT last_insert_id()';
end;

class function TCustomerSQLBuilderMySQL.Make: ICustomerSQLBuilder;
begin
  Result := Self.Create;
end;

function TCustomerSQLBuilderMySQL.SelectAll: String;
begin
  Result := 'SELECT customer.* FROM customer WHERE customer.id IS NOT NULL ';
end;

function TCustomerSQLBuilderMySQL.SelectAllWithFilter(APageFilter: IPageFilter): TOutPutSelectAllFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(APageFilter, SelectAll, 'brand.id', ddMySql);
end;

function TCustomerSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' AND customer.id = ' + QuotedStr(AId.ToString);
end;

function TCustomerSQLBuilderMySQL.Update(AEntity: ICustomerEntity; AId: Int64): String;
const
  LSQL = ' UPDATE customer     '+
         '   SET               '+
         '     name = %s,      '+
         '     city = %s,      '+
         '     state = %s,     '+
         '     updated_at = %s '+
         '   WHERE             '+
         '     (id = %s)       ';
begin
  Result := Format(LSQL, [
    QuotedStr(AEntity.name),
    QuotedStr(AEntity.city),
    QuotedStr(AEntity.state),
    QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', AEntity.updated_at)),
    QuotedStr(AId.ToString)
  ]);
end;

end.

