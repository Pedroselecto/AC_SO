# AC_SO
## Documentação do projeto de Linux 

**Titulo**
Ac de sistemas operacionais - Portal Acadêmico 

## Alunos

* João Pedro Borges Souza Santana
* Pedro Dos Santos Carlos da Silva 

## Descrição

Este sistema funciona como um portal acadêmico para alunos e coordenadores, permitindo com que:

* O usuário aluno possa ver as disciplinas matriculadas;
* Os usuários aluno e coordenador possam ver a lista de disciplinas disponíveis;
* O usuário aluno possa se matricular em disciplinas;
* O usuário aluno possa trancar diciplinas matriculadas;
* O usuário aluno possa buscar por um livro e ver se esta disponível ou não.
* O usuário aluno possa ver as suas informações financeiras (mensalidade e boletos).
* O usuário coordenador possa adicionar novas disciplinas.
* O usuário aluno possa vizualizar as suas informações institucionais.

## Comandos Utilizados
Comandos utilizados para a realização do projeto, separados entre comandos do sistema e comandos internos do bash

### Comandos internos do bash
* grep --> Para buscar os livros e diciplinas nos arquivos que as armazenavam
  * -w: Busca pela "palavra inteira" (ex: IBM1 não confunde com IBM123);
  * -q: Não mostra a saída, apenas retorna um status de sucesso (0) ou falha (1). Usado em if para realizar verificações sem que nada seja mostrado na tela. 
* column --> Usado para formatar e separar texto
  * -t --> Usado para criar uma tabela;
  * -s '|' --> Usado para definir | como caractere divisor de colunas.
* sed --> Comando usado para manipular texto
  * -i --> edita o arquivo diretamente;
  * /padrão/d: Encontra uma linha que bate com o "padrão" e a deleta (d). Usado para o trancamento de matrícula.
* date --> Mostrar a hora e minutos exatos do sistema, também usados para ajudar na listagem das mensalidades e cacular o semestre atual;
* case --> Usados para identificar a opções ou subopções escolhidas pelo usuários e excuta-las;
* touch --> Usado para criar os arquivos com o contéudo das funções de biblioteca e disciplinas;
* echo --> Usando para imprimir textos;
* read --> Lê a entrada do usuário e a armazena numa variável. Usado para selecionar as opções dos menus e nas pesquisas por nome/código;
* cat --> Usado para listar o contéudo dos arquivos na opção de disciplina, especificamente as disciplinas disponiveis ou matriculadas;
* $USER --> Usado para identificar qual usuário está logado, tendo em vista que o script só pode ser utilizado pelos usuários Aluno e Coordenador, e ele é diferente para cada um destes;
* função() {} --> Cria blocos de código que podem ser executados apenas ao chamar o nome da função, facilitando a repetição de blocos. As funções criadas são:
  * Funções principais:
    * menuprincipal() --> É a função principal do Aluno. Exibe o menu principal do aluno (Disciplinas, Biblioteca, Financeiro, etc.) e, usando um case, direciona o usuário para as funções apropriadas com base em sua escolha. Ela roda em um loop (while true) até que o usuário escolha a opção "5) Finalizar o programa";
    * menu_coordenador() --> É a função principal do Coordenador. Exibe o menu administrativo (Criar disciplina, Listar disciplinas) e direciona para as funções de coordenador. Também roda em loop até que o usuário escolha "3) Sair";
    * mostrar_cabecalho() --> Limpa a tela (clear) e exibe o cabeçalho padronizado do sistema, contendo o nome da instituição, semestre/ano, equipe e a data/hora atuais.
  * Funções de Aluno:
    * mostrar_disciplinas_matriculadas() --> Chamada pela Opção 1.1 do menu principal. Lê o arquivo matriculadas.txt. Para cada código de disciplina encontrado, busca os detalhes completos no disponiveis.txt e exibe a lista formatada em colunas;
    * realizar_matricula() --> Chamada pela Opção 1.2 do menu principal. Mostra as disciplinas disponíveis (chamando mostrar_lista_disponiveis()), pede um código ao aluno, valida se o código existe e se o aluno já não está matriculado na disciplina respectiva. Se tudo estiver correto, adiciona (>>) o código ao matriculadas.txt;
    * realizar_trancamento() --> Chamada pela Opção 1.3 do menu principal. Mostra as disciplinas em que o aluno está matriculado (chamando mostrar_disciplinas_matriculadas()), pede um código e valida se o aluno realmente está cursando aquela matéria. Se sim, usa sed -i para apagar a linha correspondente do matriculadas.txt;
    * mostrar_lista_disponiveis() --> Função auxiliar chamada por realizar_matricula(). Lê o arquivo disponiveis.txt e o formata em uma tabela (column -t -s '|') para que o aluno possa ver quais disciplinas estão disponíveis para escolha;
    * buscar_biblioteca() --> Chamada pela Opção 2 do menu principal. Pede ao aluno um termo de busca (título, autor, etc.). Em seguida, usa grep -i para filtrar o biblioteca.txt por esse termo e exibe os resultados formatados em colunas;
    * mostrar_informacoes_aluno() --> Chamada pela Opção 4 do menuprincipal. Exibe na tela as informações cadastrais do aluno (nome, matrícula, curso, etc).
  * Funções do coordenador
    * criar_disciplina() --> Chamada pela Opção 1 do menu_coordenador. Pede ao coordenador os detalhes de uma nova disciplina (código, nome, professor, horário), valida se o código já não existe no disponiveis.txt e, se não existir, adiciona (>>) a nova disciplina ao final do arquivo.
  
### Comando do sistema
* sudo --> Executa um comando com privilégios de administrador (root). Usado para criar usuários e alterar permissões em pastas de sistema.
* adduser --> Foi usado para criar os usuários aluno e coordenador.
* mv --> Fizemos isso para fazer com que todos os usuários tivessem acesso ao script.
* chmod --> Altera as permissões de acesso de arquivos e pastas.
  * 777 (rwxrwxrwx): Permissão total. Usada na pasta /opt/ACSO para permitir a criação de arquivos temporários pelo sed.
  * 666 (rw-rw-rw-): Leitura e escrita para todos. Usada nos arquivos .txt para permitir que ambos os perfis leiam e escrevam nos bancos de dados.
  * 755 (rwxr-xr-x): Permissão de execução para todos, mas escrita apenas para o dono (root). Usada no script ACSO por segurança.
* su - [usuário] --> Foi usado diversas vezes para alterar entre os usuários, entre coordenador e aluno.
* alias --> Foi utilizado para simplificar o comando “bash opt/ACSO/ACSO”.

