
User function PXH052(p_cFunction,p_lAutom)

local lautom    := iif( p_lAutom==nil, .f., p_lAutom )
local lAcesso   := .t.
private aAcesso := {{"SMFATT01","3001"},;  //Tela do Pager
					{"SMFATT03","3001"},;  //Tela da IHM
					{"SMFATT11","3001"},;  //Tela do Carregamento
					{"SMFATT26","3001"},;  //Tela Paletizado
					{"SMFATT12","3001"},;  //Agenciamento
					{"SMFATT18","3001"},;  //Tela SMS
					{"SMFATF65","3001"},;  //Conexão com o leitor de codigo de barras pela porta serial
					{"SMFATT24","3001"},;  //Controle de Tráfego de Carga e Descarga
					{"SMFATA02","3001"},;  //Inclusão/Alteração/Exclusão de Disparos de Emails (Workflow)
					{"SMFATA05","3001"},;  //Configuração do E-mail de Expedição de Mercadoria (Workflow)
					{"SMFATA06","3001"},;  //Configuração dos E-mails de Atrasos (Workflow)
					{"SMFATR01","3001"}}   //Relatorio de Carregamento

for i := 1 to LEN(aAcesso)
	if aAcesso[i][1] = p_cFunction
		for a := 2 to LEN(aAcesso[i])
			if aAcesso[i][a] == cEmpAnt+cFilAnt
				lAcesso := .T.
				return lAcesso
			endif
		next a
		lAcesso := .F.
		cmens:="Rotina [ "+p_cFunction+" ], ainda nao liberada para uso desta empresa/filial! "
		if lautom
			Conout( cMens )
		else
			alert( cMens )
		endif
		
	endif
Next i

Return lAcesso