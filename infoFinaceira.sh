#!/bin/bash
mostrarcabecalho(){
clear

ano=`date +%Y`
mes=`date +%m`

case $mes in 
    01|02|03|04|05|06)
        semestre="1";;
    07|08|09|10|11|12)
        semestre="2";;
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

menuprincipal(){
	while true; do
	
		mostrarcabecalho
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
		mostrarcabecalho
		echo "1) Mostrar disciplinas matriculadas"
		echo "2) Realizar matricula em disciplina"
		echo "3) Realizar trancamento de disciplina"
		echo "4) Retornar ao menu principal"
		read -p "Selecione uma opção: " subopcao1
		case $subopcao1 in
			1) 
				mostrarcabecalho
				echo "Mostrando disciplina matriculadas";;
			2)
				mostrarcabecalho
				echo "Mostrando disciplinas disponiveis para matricula";;
			3)
				mostrarcabecalho
				echo "Mostrando disciplinas matriculadas para realizar trancamento";;
			4)
				continue;;
			esac;;
	2)
		mostrarcabecalho
		echo "Mostrando grade de disciplinas";;
	3)
		mostrarcabecalho
		echo "1) Status da mensalidade"
		echo "2) Mostrar boletos"
		read -p "Selecione uma opção" subopcao3
		case $subopcao3 in
			1)
				mostrarcabecalho
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
				printf "%-15s | %-10s | %s\n" "Mês" "Status" "Valor"
				echo "------------------------------------------------"
				printf "%-15s | %-10s | %s\n" "$mes_atual" "PAGA" "$valor_mensalidade"
				printf "%-15s | %-10s | %s (Venc. 10/%s/%s)\n" "$mes_proximo" "PENDENTE" "$valor_mensalidade" "$mes_proximo_num" "$ano_proximo"
				echo ""
				;;
			2)
				mostrarcabecalho
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
				
				printf "%-18s | %-12s | %-10s | %s\n" "Competência" "Vencimento" "Status" "Valor"
				echo "----------------------------------------------------------------------"
				printf "%-18s | %-12s | %-10s | %s\n" "$mes_proximo/$ano_proximo" "10/$mes_proximo_num/$ano_proximo" "PENDENTE" "$valor_mensalidade"
				printf "%-18s | %-12s | %-10s | %s\n" "$mes_atual/$ano_atual" "10/$mes_atual_num/$ano_atual" "PAGO" "$valor_mensalidade"
				printf "%-18s | %-12s | %-10s | %s\n" "$mes_passado/$ano_passado" "10/$mes_passado_num/$ano_passado" "PAGO" "$valor_mensalidade"
				echo ""
				echo "Para gerar a 2ª via do boleto PENDENTE, acesse o portal financeiro."
				echo ""
				;;
			esac;;
	4)
		mostrarcabecalho
		echo "Mostrando informações pessoais";;
	5)
		echo "Finalizando programa"
		clear
		exit 0;;
	*)
		echo "opção inválida!"
		sleep 1;;
	esac
	read -p "Pressione Enter para continuar..."
done
}
menuprincipal
