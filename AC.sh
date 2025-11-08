#!/bin/bash

# --- CRIAÇÃO DOS "BANCOS DE DADOS" ---
# Cria os arquivos se eles não existirem.
touch disponiveis.txt
touch matriculadas.txt

# Popula o 'disponiveis.txt' se estiver vazio
if [ ! -s "disponiveis.txt" ]; then # Se o arquivo estiver vazio
    echo "IBM8940|Sistemas Operacionais|Luiz Fernando|Seg 19:00-22:30" > disponiveis.txt
    echo "IBM1234|Cálculo 1|Maria Silva|Ter/Qui 09:00-11:00" >> disponiveis.txt
    echo "IBM5678|Banco de Dados|Carlos Souza|Qua/Sex 14:00-16:00" >> disponiveis.txt
    echo "IBM3321|Redes de Computadores|Ana Braga|Seg/Qua 16:00-18:00" >> disponiveis.txt
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
    
    if [ ! -s "matriculadas.txt" ]; then # -s verifica se o arquivo NÃO está vazio
        echo "Nenhuma disciplina matriculada."
    else
        # Agrupamos ( ... ) o cabeçalho (echo) e os dados (while/grep)
        # e enviamos tudo para o 'column' formatar.
        (
            echo "CÓDIGO|NOME|PROFESSOR|HORÁRIO"
            while read -r codigo; do
                grep -w "$codigo" disponiveis.txt
            done < "matriculadas.txt"
        ) | column -t -s '|'
    fi
    echo ""
}

# --- FUNÇÃO (Para Opção 1.2) ---
mostrar_lista_disponiveis() {
    echo "--- Disciplinas Disponíveis para Matrícula ---"
    echo ""
    
    (echo "CÓDIGO|NOME DA DISCIPLINA|PROFESSOR|HORÁRIO"; cat disponiveis.txt) | column -t -s '|'
    echo ""
}

# --- FUNÇÃO (Opção 1.2) ---
realizar_matricula() {
    mostrar_cabecalho
    mostrar_lista_disponiveis # Mostra a lista de opções
    
    read -p "Digite o CÓDIGO da disciplina que deseja matricular (ou 'v' para voltar): " codigo_matricular
    
    if [ "$codigo_matricular" == "v" ]; then
        return
    fi
    
    if ! grep -q -w "$codigo_matricular" disponiveis.txt; then
        echo "ERRO: Código '$codigo_matricular' não encontrado ou inválido."
        sleep 2
        return
    fi
    
    if grep -q -w "$codigo_matricular" matriculadas.txt; then
        echo "ERRO: Você já está matriculado na disciplina '$codigo_matricular'."
        sleep 2
        return
    fi
    
    echo "$codigo_matricular" >> matriculadas.txt
    
    nome_disciplina=$(grep -w "$codigo_matricular" disponiveis.txt | cut -d'|' -f2)
    
    echo "SUCESSO: Matrícula em '$nome_disciplina' realizada!"
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
					;;
				2)
					realizar_matricula
					;;
				3)
					mostrar_cabecalho 
					echo "Mostrando disciplinas matriculadas para realizar trancamento";;
				4)
					continue;; 
			esac;;
	
		2)
			mostrar_cabecalho
			echo "Mostrando grade de disciplinas";;
		3)
			mostrar_cabecalho
			
			echo "--- Menu Informações Financeiras ---"
			echo "1) Mostrar histórico de transações"
			echo "2) Mostrar boletos"
			read -p "Selecione uma opção: " subopcao3
			
			case $subopcao3 in
				1)
					mostrar_cabecalho 
					echo "Mostrando histórico de transações";;
				2)
					mostrar_cabecalho 
					echo "Mostrando lista de boletos";;
			esac;;
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

	if [ "$opcao" != "5" ] && [ "$opcao" != "1" ]; then
		read -p "Pressione Enter para continuar..."
	fi

done 
}

# --- EXECUÇÃO DO SCRIPT ---
menuprincipal
