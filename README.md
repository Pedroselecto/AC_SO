# AC_SO
## Documentação do projeto de Linux 

**Titulo**
Ac de sistemas operacionais - Portal Acadêmico 

## Alunos

* João Pedro Borges Souza Santana
* Pedro Dos Santos Carlos da Silva 

## Descrição

Este sistema funciona como um portal acadêmico para alunos e professore (em algums casos), permitindo com que:

* O usuário aluno possa ver as disciplinas matriculadas.
* O usuário aluno possa trancar diciplinas matriculadas.
* O usuário aluno possa buscar por um livro e ver se esta disponível ou não.
* O usuário aluno consiga ver as informações financeiras pessoais (mensalidade e boletos).
* O usuário coordenador consegue adicionar novas disciplinas.
* O usuário aluno possa vizualizar as suas informações pessoais.

## Comandos Utilizados
Comandos utilizados para a realização do projeto, separados entre comandos do sistema e comandos internos do bash

### Comandos internos do bash
* grep --> Para buscar os livros e diciplinas nos arquivos que as armazenavam.
* column --> Formata melhor as listas com o contéudo delas.
* sed -i --> Para poder trancar as disciplinas.
* date --> Mostrar a hora e minutos exatos do sistema, também usados para ajudar na listagem das mensalidades e cacular o semestre atual.
* case --> Usados para identificar a opções ou subopções escolhidas pelo usuários e excuta-las.
* touch --> Usado para criar os arquivos com o contéudo das funções de biblioteca e disciplinas.
* echo --> Usando para imprimir as opções, subopções e cabeçalho do sistema
* read --> O comando lê a opção escolhida para executa-las, também usada na parte de biblioteca e disciplinas.
* cat --> Para listar o contéudo dos arquivos na opção de disciplina, especificamente as disciplinas disponiveis ou matriculadas.
* $USER --> Para poder saber qual usuário esta sendo usado no momento, ja que a opções que so podem ser usadas pelo professor ou pelo aluno.
* função() {} --> Organiza melhor as operações realizadas em cada opção.
  
### Comando do sistema
* sudo --> Executa um comando com privilégios de administrador (root). Usado para criar usuários e alterar permissões em pastas de sistema.
* adduser --> Foi usado para criar os usuários aluno e coordenador.
* mv --> Fizemos isso para fazer com que todos os usuários tivessem acesso ao script.
* chmod --> Altera as permissões de acesso de arquivos e pastas.
  * 777 (rwxrwxrwx): Permissão total. Usada na pasta /opt/ACCHO para permitir a criação de arquivos temporários pelo sed.
  * 666 (rw-rw-rw-): Leitura e escrita para todos. Usada nos arquivos .txt para permitir que ambos os perfis leiam e escrevam nos bancos de dados.
  * 755 (rwxr-xr-x): Permissão de execução para todos, mas escrita apenas para o dono (root). Usada no script ACSO por segurança.
* su - [usuário] --> Foi usado diversas vezes para alterar entre os usuários, entre coordenador e aluno.
* alias --> Foi utilizado para simplificar o comando “bash opt/ACSO/ACSO”.

