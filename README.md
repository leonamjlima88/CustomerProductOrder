# CustomerProductOrder
Cadastro simples utilizando boas práticas de desenvolvimento sem ORM

# Experimentar aplicativo compilado
1- Efetue o download da pasta exec

2- Instale o MySQL em seu computador, crie um banco de dados vazio. Apenas o nome mesmo, sem tabelas. A aplicação se encarregará de criar as tabelas e os seeds iniciais apenas para testes.

3- Abra o arquivo .env e faça as devidas configurações.

4- Apenas execute o .exe chamado WK.exe


# Considerações
Projeto simples, contém apenas crud de Clientes, Produtos e Pedido de Venda. Não foi utilizado ORM, apenas comandos SQL para a camada de persistência.

O sistema foi desenvolvido seguindo arquitetura Ports and Adapters para ter baixissimo acoplamento com frameworks.

Frameworks como de conexão, query, cache, script, entre outros, podem ser trocados no futuro sem que sua aplicação quebre. Nenhum framework é acoplado diretamente com a regra de negócio. Longetividade ao extremo ao projeto.

A estrutura das pastas foi adotado como modular.

Neste projeto será encontrado design patterns como Controller, Service, Repository, Factory, Either, Strategy. Muitos princípios do solid como Responsabilidade única, Inversão de dependências, princípio de aberto e fechado.

Também foi criado um centralizador de exceções.

Classe genérica para consulta de dados para qualquer tabela do sistema.

Repositório totalmente flexivel para troca de driver de banco de dados a qualquer momento.

Conexão com base de dados flexivel para uso de Threads, setando apenas uma flag na implementação do controller.

Uso de Threads na abertura e fechamento de cadastro de registros.

Versionamento de banco de dados e scripts em lote. Não foi criado método de rollback por lote de scripts, mas é bem possível fazer, está engatilhado.

E muito outros recursos em um projeto simples.

Poderia ser melhor? Lógico! Sempre! ;D

Faltou criar exceções personalizadas, testes unitários, repositório em memória estilo mock para testes sem acesso a dados. Muita coisa pode ser aprimorado. Este é apenas um projeto simples realizando algumas coisas bem interessantes.
