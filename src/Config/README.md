Algumas classes para auxiliar o projeto.
Essa parte não foi muito bem organizada em pastas... Mas vamos lá.

Either: é um design patterns para evitar muitos disparos de exceções. Muito bom.
Env: É o arquivo que representa o inifile .env do .exe
HandleException: Centralizar exceções do sistema, possibilitando integrações com Bugsnag, envio de e-mails, etc..
Não foram criadas exceções personalizadas. Eu poderia ter criado, mas não criei :/.
Hlp: Arquivo de ajuda, nada demais.
IndexResult: Retorno dos métodos "index" dos controllers que traz informações do banco de dados de forma desconectada (cache) e metadados com paginação, etc...
PageFilter: Classe para criar filtros genéricos para qualquer tabela do sistema.
SelectWithFilter: classe responsável por paginação de dados de todas as tabelas.
Session.DTM: Gerenciamento de estado de toda a aplicação
