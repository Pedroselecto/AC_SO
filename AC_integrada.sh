#!/bin/bash

# --- CRIAÇÃO DOS "BANCOS DE DADOS" ---
# Cria os arquivos se eles não existirem.
touch disponiveis.txt
touch matriculadas.txt

# Popula o 'disponiveis.txt' se estiver vazio
if [ ! -s "disponiveis.txt" ]; then # Se o arquivo estiver vazio, os echos debaixos serão adicionados
    echo "IBM8940|Sistemas Operacionais|Luiz Fernando|Seg 13:30-17:40" > disponiveis.txt
    echo "IBM1234|Cálculo 1|Daniele|Ter/Qui 07:30-11:40" >> disponiveis.txt
    echo "IBM5678|Sistemas Embarcados|Rigel|Ter/Qui 18:40-22:30" >> disponiveis.txt
    echo "IBM3321|Programação orientada a objetos|Thiago|Seg/Qua 07:30-11:40" >> disponiveis.txt
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
	echo "# IBMEC                   Semestre: $semestre de $ano #"
	echo "# Sistemas Operacionais                   Turma: 8001 #"
	echo "# Código: IBM8940                                       #"
	echo "# Professor: Luiz Fernando T. de Farias                     #"
	echo "#-------------------------------------------------------------#"
	echo "# Equipe Desenvolvedora:                                      #"
	echo "#   Aluno: João Pedro Borges Souza Santana                  #"
	echo "#   Aluno: Pedro Dos Santos Carlos da Silva                 #"
	echo "#-------------------------------------------------------------#"
	echo "# Rio de Janeiro, $data       #"
	echo "# Hora do Sistema: $hora           #"
	echo "###############################################################"
	echo "" 
}

# --- FUNÇÃO (Opção 1.1) ---
mostrar_disciplinas_matriculadas() {
    mostrar_cabecalho
    echo "--- Minhas Disciplinas Matriculadas ---"
    echo ""

	# Caso o arquivo de matricula estiver vazio, aparecera a mensagem de "Nenhuma materia disponivel".
    if [ ! -s "matriculadas.txt" ]; then
        echo "Nenhuma disciplina matriculada."
    else # Caso o contrario, exibra as diciplinas matriculadas e que estejam no arquivo de disponiveis.
        (
            echo "CÓDIGO|NOME|PROFESSOR|HORÁRIO"
            while read -r codigo; do
                grep -w "$codigo" disponiveis.txt # Pega os arquivos disponiveis.
            done < "matriculadas.txt"
        ) | column -t -s '|' # Formata a saida dos resultados
    fi
    echo ""
}

# --- FUNÇÃO (Para Opção 1.2) ---
mostrar_lista_disponiveis() {
    echo "--- Disciplinas Disponíveis para Matrícula ---"
    echo ""
    
    (echo "CÓDIGO|NOME DA DISCIPLINA|PROFESSOR|HORÁRIO"; cat disponiveis.txt) | column -t -s '|' # Formata a saida dos resultados 
    echo ""
}

# --- FUNÇÃO (Opção 1.2) ---
realizar_matricula() {
    mostrar_cabecalho
    mostrar_lista_disponiveis
    
    read -p "Digite o CÓDIGO da disciplina que deseja matricular (ou 'v' para voltar): " codigo_matricular

	# Se digitar "v" aborta a operação
    if [ "$codigo_matricular" == "v" ]; then
        return
    fi

	# Se não for encontardo a materia desejada, então exibe a mensagem de erro
    if ! grep -q -w "$codigo_matricular" disponiveis.txt; then
        echo "ERRO: Código '$codigo_matricular' não encontrado ou inválido."
        sleep 2
        return
    fi

	# Se a materia a qual o usuario quer se matricular, o mesmo ja estiver matriculado, entçao exibe a mensagem de erro.
    if grep -q -w "$codigo_matricular" matriculadas.txt; then
        echo "ERRO: Você já está matriculado na disciplina '$codigo_matricular'."
        sleep 2
        return
    fi
    
    echo "$codigo_matricular" >> matriculadas.txt
    
    nome_disciplina=$(grep -w "$codigo_matricular" disponiveis.txt | cut -d'|' -f2) # Exibe o nome da diciplina matriculada
    
    echo "SUCESSO: Matrícula em '$nome_disciplina' realizada!"
    sleep 2
}

# --- FUNÇÃO (Opção 1.3) ---
realizar_trancamento() {
    mostrar_cabecalho
    echo "--- Trancamento de Matrícula ---"
    echo ""

	# Se a disciplina a qual o usuario que não for encontarda, então ira exibir a mensagem de erro
    if [ ! -s "matriculadas.txt" ]; then
        echo "Nenhuma disciplina matriculada para trancar."
        sleep 2
        return
    fi

	# Mostra as diciplinas matriculadas pelo aluno (usuario), que estejam no arquivo de matricula.txt e disponiveis.txt
    echo "Suas disciplinas matriculadas atualmente:"
    (
        echo "CÓDIGO|NOME|PROFESSOR|HORÁRIO"
        while read -r codigo; do
            grep -w "$codigo" disponiveis.txt
        done < "matriculadas.txt"
    ) | column -t -s '|'
    echo ""

    read -p "Digite o CÓDIGO da disciplina que deseja trancar (ou 'v' para voltar): " codigo_trancar

	# Se digitar "v" aborta a operação
    if [ "$codigo_trancar" == "v" ]; then
        return
    fi

	# Exibira a mensagem de erro caso o aluno não esteja matriculado na materia
    if ! grep -q -w "$codigo_trancar" matriculadas.txt; then
        echo "ERRO: Você não está matriculado na disciplina '$codigo_trancar'."
        sleep 2
        return
    fi

    sed -i "/^$codigo_trancar$/d" matriculadas.txt # Deleta a disciplina 

    nome_disciplina=$(grep -w "$codigo_trancar" disponiveis.txt | cut -d'|' -f2)
    echo "SUCESSO: Trancamento da disciplina '$nome_disciplina' realizado."
    sleep 2
}


# --- FUNÇÃO DO MENU PRINCIPAL ---
menuprincipal(){

while true; do

	mostrar_cabecalho
	
	echo "Menu de Escolhas:"
	echo "1) Disciplinas"
	echo "2) Grade de disciplinas"
	echo "3) Informações financeiras"
	echo "4) Informações do aluno"
	echo "5) Finalizar o programa"
	echo ""
	read -p "Selecione uma opção: " opcao
	
	case $opcao in
		1)
			# --- SEU CÓDIGO AVANÇADO DE DISCIPLINAS (MANTIDO) ---
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
			mostrar_cabecalho
			echo "Mostrando grade de disciplinas";;
			
		3)
			# --- CÓDIGO DO SEU AMIGO (FINANCEIRO) INTEGRADO E CORRIGIDO ---
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
					
					mes_atual=$(date +"%B" | sed 's/./\u&/') # Define o mes atual
					mes_proximo=$(date -d "+1 month" +"%B" | sed 's/./\u&/') # Define o proximo mes com o "+1"
					ano_proximo=$(date -d "+1 month" +"%Y")# Define o proximo ano com o "+1"
					mes_proximo_num=$(date -d "+1 month" +"%m") # Define o proximo mes como numero 
					
					valor_mensalidade="R$ 2.500,00"
					
					echo "Resumo dos seus pagamentos:"
					echo ""
					
					# Mostra os destalhes das mensalidade
					(
						echo "Mês|Status|Valor (Vencimento)"
						echo "----------------|------|---------------------------------------"
						echo "$mes_atual|PAGA|$valor_mensalidade (-)"
						echo "$mes_proximo|PENDENTE|$valor_mensalidade (10/$mes_proximo_num/$ano_proximo)"
					) | column -t -s '|'
					echo ""
					;;
				2)
					mostrar_cabecalho
					echo "Mostrar boletos"
					echo ""
					
					export LC_TIME=pt_BR.UTF-8
					
					valor_mensalidade="R$ 2.500,00"
					
					# Proximo mês
					mes_proximo=$(date -d "+1 month" +"%B" | sed 's/./\u&/')
					ano_proximo=$(date -d "+1 month" +"%Y")
					mes_proximo_num=$(date -d "+1 month" +"%m")
					
					# Mês atual
					mes_atual=$(date +"%B" | sed 's/./\u&/')
					ano_atual=$(date +"%Y")
					mes_atual_num=$(date +"%m")
					
					# Mês passado
					mes_passado=$(date -d "-1 month" +"%B" | sed 's/./\u&/')
					ano_passado=$(date -d "-1 month" +"%Y")
					mes_passado_num=$(date -d "-1 month" +"%m")
					
					# Convertido de 'printf' para 'column'
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
					;;
			esac;;
			# --- FIM DA SEÇÃO MESCLADA ---
			
		4)
			mostrar_cabecalho
			echo "Mostrando informações pessoais";;
		5)
			echo "Finalizando programa..."
			exit 0;; 
		*)
			echo "Opção inválida! Tente novamente."
			sleep 2 
			;;
	esac

	# Sua lógica de pausa (MANTIDA, pois é melhor que a do seu amigo)
	if [ "$opcao" != "5" ] && [ "$opcao" != "1" ]; then
		read -p "Pressione Enter para continuar..."
	fi

done 
}

# --- EXECUÇÃO DO SCRIPT ---
menuprincipal
