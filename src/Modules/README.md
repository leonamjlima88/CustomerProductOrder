Os arquivos do sistema foram organizados em módulos.
Quase todo módulo deve conter a seguinte estrutura:

Controller: Responsável por fazer as chamadas, validações e retornos

Domain: Camada responsável pela regra de negócio do projeto, aqui nada deve conter acoplamento com nenhum framework. Tudo que entra e sai em domain devem ser classes puras em object pascal. Tudo deve ser injetado como interface (Inversão de dependência, princípio do solid)

Repository: Camada responsável pela persistência dos dados. Não contém acoplamento com FireDAC, Unidac, Aurelius, etc... Trabalha de forma totalmente abstrata, possibilitando até utilizar repositórios em memória estilo mockados para testes.

SQLBuilder: Geração dos comandos SQLs, também trabalha de forma desacoplada, é possível utilizar qualquer banco de dados sem alterar Repositório, Regra de negócio, View, etc... Você simplesmente cria a classe concreta que implementa a interface de SQLBuilder e configura na factory.

View: Interface gráfica para o usuário

ViewModel: Mediador entre View e Controller para Inserir, atualizar, listar dados.
