Acoplamento com frameworks "ZERO".
Único driver implementado foi o FireDAC.
As outras pastas são só exemplos do que é possível fazer no futuro sem alterar a regra de negócio.
Você simplesmente cria uma nova classe que implementa a interface, altera a factory e todo o sistema trabalha com outro framework.
Sendo possível trabalhar com frameworks diferentes ao mesmo tempo.
Longetividade ao extremo para o projeto.

IConnection: Conexão com o banco de dados

IMemTable: Tabela de dados em cache

IQry: Execuções de SQL

IScript: Execuções de Scripts
