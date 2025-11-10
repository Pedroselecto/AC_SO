#!/bin/bash
trap "" INT

# --- CAMINHOS GLOBAIS (Mais seguro) ---
DIR_PROJETO="/opt/ACSO"
ARQUIVO_DISPONIVEIS="$DIR_PROJETO/disponiveis.txt"
ARQUIVO_MATRICULADAS="$DIR_PROJETO/matriculadas.txt"
ARQUIVO_BIBLIOTECA="$DIR_PROJETO/biblioteca.txt"
ARQUIVO_TEMP="$DIR_PROJETO/_temp_results.txt" # Para a busca na biblioteca

touch "$ARQUIVO_DISPONIVEIS"
touch "$ARQUIVO_MATRICULADAS"
touch "$ARQUIVO_BIBLIOTECA"
touch "$ARQUIVO_TEMP"

# Popula o 'disponiveis.txt' se estiver vazio
if [ ! -s "$ARQUIVO_DISPONIVEIS" ]; then 
    echo "IBM8940|Sistemas Operacionais|Luiz Fernando|Seg 13:30-17:40" > "$ARQUIVO_DISPONIVEIS"
    echo "IBM1234|Cálculo 1|Daniele|Ter/Qui 07:30-11:40" >> "$ARQUIVO_DISPONIVEIS"
    echo "IBM5678|Estrutura de dados|Rodrigo Luna|Sex 07:30-11:40" >> "$ARQUIVO_DISPONIVEIS"
    echo "IBM3321|Programação orientada a objetos|Thiago|Qui 13:30-17:40" >> "$ARQUIVO_DISPONIVEIS"
fi

# Popula o 'biblioteca.txt' se estiver vazio
if [ ! -s "$ARQUIVO_BIBLIOTECA" ]; then
	echo "Sist. Oper.|Sistemas Operacionais Modernos|Tanenbaum|DISPONÍVEL" > "$ARQUIVO_BIBLIOTECA"
	echo "Sist. Oper.|O Design do UNIX|Maurice Bach|EMPRESTADO" >> "$ARQUIVO_BIBLIOTECA"
    echo "Cálculo|Cálculo Volume 1|James Stewart|DISPONÍVEL" >> "$ARQUIVO_BIBLIOTECA"
    echo "Cálculo|Cálculo Volume 2|James Stewart|DISPONÍVEL" >> "$ARQUIVO_BIBLIOTECA"
    echo "Programação|Código Limpo|Robert C. Martin|DISPONÍVEL" >> "$ARQUIVO_BIBLIOTECA"
    echo "Programação|Algoritmos: Teoria e Prática|Cormen|EMPRESTADO" >> "$ARQUIVO_BIBLIOTECA"
fi


# --- FUNÇÃO DE CABEÇALHO ---
mostrar_cabecalho() {
	clear 
	ano=`date +%Y`
	mes=`date +%m`
	
	case $mes in 
	    01|02|03|04|05|06) semestre="1";;
	    07|08|09|10|11|12) semestre="2";;
	esac
	
	data=$(date +"%d de %B de %Y")
	hora=$(date +"%H Horas e %M Minutos")
	
	echo "###############################################################"
	echo "# IBMEC                           Semestre: $semestre de $ano #"
	echo "# Sistemas Operacionais                           Turma: 8001 #"
	echo "# Código: IBM8940                                             #"
	echo "# Professor: Luiz Fernando T. de Farias                       #"
	echo "#-------------------------------------------------------------#"
	echo "# Equipe Desenvolvedora:                                      #"
	echo "#   Aluno: João Pedro Borges Souza Santana                    #"
	echo "#   Aluno: Pedro Dos Santos Carlos da Silva                   #"
	echo "#-------------------------------------------------------------#"
	echo "# Rio de Janeiro, $data                                       #"
	echo "# Hora do Sistema: $hora                                      #"
	echo "###############################################################"
	echo "" 
}

# --- FUNÇÕES DE ALUNO (DISCIPLINAS) ---
mostrar_disciplinas_matriculadas() {
    mostrar_cabecalho
    echo "--- Minhas Disciplinas Matriculadas ---"
    echo ""
    
    if [ ! -s "$ARQUIVO_MATRICULADAS" ]; then
        echo "Nenhuma disciplina matriculada."
    else
        (
            echo "CÓDIGO|NOME|PROFESSOR|HORÁRIO"
            while read -r codigo; do
                grep -w "$codigo" "$ARQUIVO_DISPONIVEIS"
            done < "$ARQUIVO_MATRICULADAS"
        ) | column -t -s '|'
    fi
    echo ""
}

mostrar_lista_disponiveis() {
    echo "--- Disciplinas Disponíveis para Matrícula ---"
    echo ""
    (echo "CÓDIGO|NOME DA DISCIPLINA|PROFESSOR|HORÁRIO"; cat "$ARQUIVO_DISPONIVEIS") | column -t -s '|'
    echo ""
}

realizar_matricula() {
    mostrar_cabecalho
    mostrar_lista_disponiveis
    
    read -p "Digite o CÓDIGO da disciplina que deseja matricular (ou 'v' para voltar): " codigo_matricular
    
    if [ "$codigo_matricular" == "v" ]; then
        return
    fi
    
    if ! grep -q -w "$codigo_matricular" "$ARQUIVO_DISPONIVEIS"; then
        echo "ERRO: Código '$codigo_matricular' não encontrado ou inválido."
        sleep 2
        return
    fi
    
    if grep -q -w "$codigo_matricular" "$ARQUIVO_MATRICULADAS"; then
        echo "ERRO: Você já está matriculado na disciplina '$codigo_matricular'."
        sleep 2
        return
    fi
    
    echo "$codigo_matricular" >> "$ARQUIVO_MATRICULADAS"
    nome_disciplina=$(grep -w "$codigo_matricular" "$ARQUIVO_DISPONIVEIS" | cut -d'|' -f2)
    echo "SUCESSO: Matrícula em '$nome_disciplina' realizada!"
    sleep 2
}

realizar_trancamento() {
    mostrar_cabecalho
    echo "--- Trancamento de Matrícula ---"
    echo ""

    if [ ! -s "$ARQUIVO_MATRICULADAS" ]; then
        echo "Nenhuma disciplina matriculada para trancar."
        sleep 2
        return
    fi

    echo "Suas disciplinas matriculadas atualmente:"
    (
        echo "CÓDIGO|NOME|PROFESSOR|HORÁRIO"
        while read -r codigo; do
            grep -w "$codigo" "$ARQUIVO_DISPONIVEIS"
        done < "$ARQUIVO_MATRICULADAS"
    ) | column -t -s '|'
    echo ""

    read -p "Digite o CÓDIGO da disciplina que deseja trancar (ou 'v' para voltar): " codigo_trancar

    if [ "$codigo_trancar" == "v" ]; then
        return
    fi

    if ! grep -q -w "$codigo_trancar" "$ARQUIVO_MATRICULADAS"; then
        echo "ERRO: Você não está matriculado na disciplina '$codigo_trancar'."
        sleep 2
        return
    fi

    sed -i "/^$codigo_trancar$/d" "$ARQUIVO_MATRICULADAS"
    nome_disciplina=$(grep -w "$codigo_trancar" "$ARQUIVO_DISPONIVEIS" | cut -d'|' -f2)
    echo "SUCESSO: Trancamento da disciplina '$nome_disciplina' realizado."
    sleep 2
}

# --- FUNÇÕES DE ALUNO (BIBLIOTECA E INFO) ---
buscar_biblioteca() {
    mostrar_cabecalho
    echo "--- Biblioteca Virtual ---"
    echo ""
    
    if [ ! -f "$ARQUIVO_BIBLIOTECA" ]; then
        echo "ERRO: Arquivo 'biblioteca.txt' não encontrado."
        sleep 2
        return
    fi
    
    read -p "Digite o termo de busca (título, autor ou área): " termo_busca

    if [ -z "$termo_busca" ]; then
        echo "Busca cancelada."
        sleep 1
        return
    fi
    
    echo ""
    echo "Buscando por '$termo_busca'..."
    
    grep -i "$termo_busca" "$ARQUIVO_BIBLIOTECA" > "$ARQUIVO_TEMP"

    if [ -s "$ARQUIVO_TEMP" ]; then
        echo ""
        (
            echo "ÁREA|TÍTULO|AUTOR|STATUS"
            cat "$ARQUIVO_TEMP"
        ) | column -t -s '|'
    else
        echo "Nenhum livro encontrado com o termo '$termo_busca'."
    fi
    
    rm "$ARQUIVO_TEMP" # Limpa o arquivo temporário
    echo ""
}

mostrar_informacoes_aluno() {
	mostrar_cabecalho
	echo "--- Informações Pessoais do Aluno ---"
	echo ""
	echo "-------------------------------------------------"
	echo "ALUNO:           John Da Silva Oliveira"
	echo "-------------------------------------------------"
	echo "Matrícula:       202301001"
	echo "Curso:           Engenharia de Computação"
	echo "Período:         5º Período"
	echo "Situação:        REGULAR"
	echo "CR Acumulado:    8.9"
	echo "Email:           jhon.silva@aluno.ibmec.edu.br"
	echo ""	
}

# --- FUNÇÕES DE COORDENADOR ---
criar_disciplina() {
    mostrar_cabecalho
    echo "--- Criação de Nova Disciplina ---"
    echo ""
    
    read -p "Digite o Código (ex: IBM0001): " novo_codigo
    
    if [ -z "$novo_codigo" ]; then
        echo "ERRO: O código não pode ser vazio."
        sleep 2
        return
    fi

    if grep -q -w "$novo_codigo" "$ARQUIVO_DISPONIVEIS"; then
        echo "ERRO: O código '$novo_codigo' já existe!"
        sleep 2
        return
    fi
    
    read -p "Digite o Nome da Disciplina: " novo_nome
    read -p "Digite o Nome do Professor: " novo_prof
    read -p "Digite o Horário (ex: Seg 19:00-22:30): " novo_horario
    
    echo "$novo_codigo|$novo_nome|$novo_prof|$novo_horario" >> "$ARQUIVO_DISPONIVEIS"
    
    echo "SUCESSO: Disciplina '$novo_nome' criada."
    sleep 2
}

# --- MENU DO COORDENADOR ---
menu_coordenador() {
    while true; do
        mostrar_cabecalho
        echo "--- Portal do Coordenador ---"
        echo "1) Criar nova disciplina"
        echo "2) Listar todas as disciplinas"
        echo "3) Sair"
        echo ""
        read -p "Selecione uma opção: " opcao
        
        case $opcao in
            1)
                criar_disciplina
                ;;
            2)
                mostrar_cabecalho
                echo "--- Todas as Disciplinas no Catálogo ---"
                (echo "CÓDIGO|NOME|PROFESSOR|HORÁRIO"; cat "$ARQUIVO_DISPONIVEIS") | column -t -s '|'
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            3)
                break 
                ;;
            *)
                echo "Opção inválida."
                sleep 1
                ;;
        esac
    done
}


# --- MENU DO ALUNO ---
menuprincipal(){

while true; do

	mostrar_cabecalho
	
	echo "Menu de Escolhas:"
	echo "1) Disciplinas"
	echo "2) Buscar livros na biblioteca"
	echo "3) Informações financeiras"
	echo "4) Informações do aluno"
	echo "5) Finalizar o programa"
	echo ""
	read -p "Selecione uma opção: " opcao
	
	case $opcao in
		1)
			mostrar_cabecalho
			
			echo "--- Menu Disciplinas ---"
			echo "1) Mostrar disciplinas matriculadas"
			echo "2) Realizar matricula em disciplina"
			echo "3) Realizar trancamento de disciplina"
			echo "4) Retornar ao menu principal"
			read -p "Selecione uma opção: " subopcao1
			
			case $subopcao1 in
				1) 
					mostrar_disciplinas_matriculadas
					read -p "Pressione Enter para continuar..."
					;;
				2)
					realizar_matricula
					;;
				3)
					realizar_trancamento
					;;
				4)
					continue;; 
			esac;;
	
		2)
			buscar_biblioteca
			;;
			
		3)
			mostrar_cabecalho
			
			echo "--- Menu Informações Financeiras ---"
			echo "1) Status da mensalidade"
			echo "2) Mostrar boletos"
			read -p "Selecione uma opção: " subopcao3
			
			case $subopcao3 in
				1)
					mostrar_cabecalho
					echo "Status de pagamento da mensalidade"
					echo ""
					
					export LC_TIME=pt_BR.UTF-8
					
					mes_atual=$(date +"%B" | sed 's/./\u&/')
					mes_proximo=$(date -d "+1 month" +"%B" | sed 's/./\u&/')
					ano_proximo=$(date -d "+1 month" +"%Y")
					mes_proximo_num=$(date -d "+1 month" +"%m")
					valor_mensalidade="R$ 2.500,00"
					
					echo "Resumo dos seus pagamentos:"
					echo ""
					
					(
						echo "Mês|Status|Valor (Vencimento)"
						echo "----------------|------|---------------------------------------"
						echo "$mes_atual|PAGA|$valor_mensalidade (-)"
						echo "$mes_proximo|PENDENTE|$valor_mensalidade (10/$mes_proximo_num/$ano_proximo)"
					) | column -t -s '|'
					echo ""
					read -p "Pressione Enter para continuar..."
					;;
				2)
					mostrar_cabecalho
					echo "Mostrar boletos"
					echo ""
					
					export LC_TIME=pt_BR.UTF-8
					
					valor_mensalidade="R$ 2.500,00"
					
					mes_proximo=$(date -d "+1 month" +"%B" | sed 's/./\u&/')
					ano_proximo=$(date -d "+1 month" +"%Y")
					mes_proximo_num=$(date -d "+1 month" +"%m")
					
					mes_atual=$(date +"%B" | sed 's/./\u&/')
					ano_atual=$(date +"%Y")
					mes_atual_num=$(date +"%m")
					
					mes_passado=$(date -d "-1 month" +"%B" | sed 's/./\u&/')
					ano_passado=$(date -d "-1 month" +"%Y")
					mes_passado_num=$(date -d "-1 month" +"%m")
					
					(
						echo "Competência|Vencimento|Status|Valor"
						echo "--------------------------|------------|--------|-----------"
						echo "$mes_proximo/$ano_proximo|10/$mes_proximo_num/$ano_proximo|PENDENTE|$valor_mensalidade"
						echo "$mes_atual/$ano_atual|10/$mes_atual_num/$ano_atual|PAGO|$valor_mensalidade"
						echo "$mes_passado/$ano_passado|10/$mes_passado_num/$ano_passado|PAGO|$valor_mensalidade"
					) | column -t -s '|'
					echo ""
					echo "Para gerar a 2ª via do boleto PENDENTE, acesse o portal financeiro."
					echo ""
					read -p "Pressione Enter para continuar..."
					;;
			esac;;
			
		4)
			mostrar_informacoes_aluno
			;;
		5)
			echo "Finalizando programa..."
			exit 0;; 
		*)
			echo "Opção inválida! Tente novamente."
			sleep 2 
			;;
	esac

	if [ "$opcao" != "5" ] && [ "$opcao" != "1" ] && [ "$opcao" != "3" ]; then
		read -p "Pressione Enter para continuar..."
	fi

done 
}

# --- VERIFICAÇÃO DE USUÁRIO ---

if [ "$USER" == "aluno" ]; then
    menuprincipal

elif [ "$USER" == "coordenador" ]; then 
    menu_coordenador

else
    echo "ERRO: Permissão negada."
    echo "Este script deve ser executado pelo usuário 'aluno' ou 'coordenador'."
    echo "(Usuário atual: $USER)"
    sleep 3
fi
