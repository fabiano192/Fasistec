#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
Descrição: Modelo 2 (Romaneio Expedição e envio de ASN)
Autor: Fabiano da Silva
Data: 29/09/09
*/

User Function PA0191()

Private aRotina := {}
Private cCadastro := "Transações"

AAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
AAdd(aRotina, {"Visualizar", "U_PA191A", 0, 2})
AAdd(aRotina, {"Incluir"   , "U_PA191A", 0, 3})
AAdd(aRotina, {"Alterar"   , "U_PA191A", 0, 4})
AAdd(aRotina, {"Excluir"   , "U_PA191A", 0, 5})
AAdd(aRotina, {"Imprimir"  , "U_PA191A", 0, 6})

dbSelectArea("SZJ")
dbGoTop()

mBrowse(,,,,"SZJ")

Return (Nil)


User Function PA191A(cAlias, nReg, nOpc)

Local cChave := ""
Local nLin
Local i      := 0
Local lRet   := .F.

Private cT       := "Romaneio - Expedição"   // Titulo.
Private aC       := {}                       // Campos do Enchoice.
Private aR       := {}                       // Campos do Rodape.
Private aCGD     := {}                       // Coordenadas do objeto GetDados.
Private cLinOK   := ""                       // Funcao para validacao de uma linha da GetDados.
Private cAllOK   := "U_PA191B()"             // Funcao para validacao de tudo.
Private aGetsGD  := {}                       // Posição para edição dos itens (GetDados).
Private bF4      := {|| }                    // Bloco de Codigo para a tecla F4.
Private cIniCpos := "+ZJ_ITEM"               // String com o nome dos campos que devem inicializados
Private _lReturn := .T.

// ao pressionar a seta para baixo.
Private nMax     := 99                       // Nr. maximo de linhas na GetDados.
Private aHeader  := {}                       // Cabecalho das colunas da GetDados.
Private aCols    := {}                       // Colunas da GetDados.
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField)}
Private aAlt     := {}

dbSelectArea(cAlias)

For i := 1 To FCount()
	
	cCampo := FieldName(i)
	M->&(cCampo) := CriaVar(cCampo, .T.)
Next i

dbSelectArea("SX3")
dbSetOrder(1)

dbSeek(cAlias)

While SX3->X3_Arquivo == cAlias .And. !SX3->(EOF())
	
	If X3Uso(SX3->X3_Usado)    .And.;                            // O Campo é usado.
		cNivel >= SX3->X3_Nivel .And.;                            // Nivel do Usuario >= Nivel do Campo.
		Trim(SX3->X3_Campo) $ "ZJ_ITEM/ZJ_SERIE/ZJ_NF/ZJ_EMISSAO/ZJ_CLIENTE/ZJ_LOJACLI/ZJ_NOMECLI/ZJ_DESTINO/ZJ_PESOBR/ZJ_VOLUME/ZJ_QTDITEM/ZJ_VALORNF"  // Campos que ficarao na GetDados.	
		
		AAdd(aHeader, {SX3->X3_Titulo,;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_Arquivo     ,;
		SX3->X3_Context})
		
	EndIf
	
	SX3->(dbSkip())
	
EndDo

////////////////////////////////////////////////////////////////////////////////////////////////////
// Cria o vetor aCols: contem os dados dos campos da tabela.                                      //
// Cada linha de aCols é uma linha da GetDados e as colunas são as colunas da GetDados.           //
// Se a opcao for INCLUIR, cria o vetor aCols com as caracteristicas de cada campo.               //
// Caso contrario, atribui os dados ao vetor aCols.                                               //
////////////////////////////////////////////////////////////////////////////////////////////////////

If nOpc == 3            // A opcao selecionada é INCLUIR.
	
	AAdd(aCols, Array(Len(aHeader)+1))  // aCols[1] --> { Nil, Nil, Nil, Nil, Nil }
	
	For i := 1 To Len(aHeader)
		aCols[1][i] := CriaVar(aHeader[i][2])
	Next
	aCols[1][Len(aHeader)+1] := .F.
	
	aCols[1][AScan(aHeader, {|x|Trim(x[2])=="ZJ_ITEM"})] := "01"
	
Else                   // Opcao ALTERAR, EXCLUIR ou VISUALIZAR
	
	M->ZJ_NUMERO 	:= (cAlias)->ZJ_NUMERO
	M->ZJ_ITEM   	:= (cAlias)->ZJ_ITEM
	
	M->ZJ_DTSAIDA	:= (cAlias)->ZJ_DTSAIDA
	M->ZJ_HORASAI	:= (cAlias)->ZJ_HORASAI
	M->ZJ_CODRESP	:= (cAlias)->ZJ_CODRESP
	M->ZJ_NOMRESP	:= (cAlias)->ZJ_NOMRESP

	M->ZJ_TPTRANS	:= (cAlias)->ZJ_TPTRANS
	M->ZJ_CODTRAN	:= (cAlias)->ZJ_CODTRAN
	M->ZJ_NOMETRA	:= (cAlias)->ZJ_NOMETRA
	M->ZJ_MOTORIS	:= (cAlias)->ZJ_MOTORIS
	M->ZJ_VEICULO	:= (cAlias)->ZJ_VEICULO
	M->ZJ_PLACA		:= (cAlias)->ZJ_PLACA
	M->ZJ_CONDVEI	:= (cAlias)->ZJ_CONDVEI
	M->ZJ_ACONDIC	:= (cAlias)->ZJ_ACONDIC
	M->ZJ_QPROXNF	:= (cAlias)->ZJ_QPROXNF
	M->ZJ_QEMXFAT	:= (cAlias)->ZJ_QEMXFAT

	dbSelectArea(cAlias)
	dbsetOrder(4)
	dbSeek(xFilial(cAlias) + M->ZJ_NUMERO)
	
	While !EOF() .And. (cAlias)->(ZJ_Filial+ZJ_NUMERO) == xFilial(cAlias) + M->ZJ_NUMERO
		
		AAdd(aCols, Array(Len(aHeader)+1))
		
		nLin := Len(aCols)                  // Nr. da linha que foi criada.
		
		// Preenche a linha que foi criada com os dados contidos na tabela.
		For i := 1 To Len(aHeader)
			If aHeader[i][10] == "R"                                   // Campo é real.
				aCols[nLin][i] := FieldGet(FieldPos(aHeader[i][2]))     // Carrega o conteudo do campo.
			Else
				aCols[nLin][i] := CriaVar(aHeader[i][2], .T.)
			EndIf
		Next
		
		aCols[nLin][Len(aHeader)+1] := .F.
		
		AAdd(aAlt, Recno())
		
		dbSelectArea(cAlias)
		dbSkip()
		
	EndDo
	
EndIf

////////////////////////////////////////////////////////////////////////////////////////////////////
// Cria o vetor Enchoice:                                                                         //
//                                                                                                //
// aC[n][1] = Nome da variavel. Ex.: "Z2_Numero"                                                  //
// aC[n][2] = Array com as coordenadas do Get [x,y], em Pixel.                                    //
// aC[n][3] = Titulo do campo                                                                     //
// aC[n][4] = Picture                                                                             //
// aC[n][5] = Validacao                                                                           //
// aC[n][6] = F3                                                                                  //
// aC[n][7] = Se o campo é editavel, .T., senao .F.                                               //
////////////////////////////////////////////////////////////////////////////////////////////////////

AAdd(aC, { "M->ZJ_NUMERO"	, {15, 05 }, "Número"														, "@!"      	,                	,      , .F.       })
//AAdd(aC, { "M->ZJ_DTSAIDA" 	, {15, 60 }, "Data"  														, "99/99/99"	,                   ,      , (nOpc==3) })
AAdd(aC, { "M->ZJ_DTSAIDA" 	, {15, 60 }, "Data"  														, "99/99/99"	,                   ,      , 		   })
AAdd(aC, { "M->ZJ_HORASAI" 	, {15, 120}, "Hora"  														, "99:99"		,                   ,      ,  		   })
AAdd(aC, { "M->ZJ_CODRESP"  , {15, 160}, "Responsável"  												, "@!"      	, "U_PA191F()"      ,"SZK" , (nOpc==3) })
AAdd(aC, { "M->ZJ_NOMRESP"  , {15, 230}, "Nome"  														, "@!"      	,                   ,      , .F.	   })

AAdd(aR, { "M->ZJ_TPTRANS"  , {30, 05}, "Transporte (1=Proprio;2=Transp)"					 			, "@!" 		,"U_PA191H()"		,      , 			})
AAdd(aR, { "M->ZJ_CODTRAN"	, {30,120}, "Cód. Transp."											 		, "@!" 		,"U_PA191G()"		, "SA4",   			})
AAdd(aR, { "M->ZJ_NOMETRA" 	, {30,210}, "Nome Transp."									 				, "@!" 		,                   ,      , .F.    	})
AAdd(aR, { "M->ZJ_MOTORIS"  , {45,005}, "Motorista"  			 										, "@!" 		,  					,      ,   			})
AAdd(aR, { "M->ZJ_VEICULO"  , {45,150}, "Veículo"  			 											, "@!" 		,  					,      ,   			})
AAdd(aR, { "M->ZJ_PLACA"  	, {45,300}, "Placa"  			 											, "@! AAA-9999",  				,      ,   			})
AAdd(aR, { "M->ZJ_CONDVEI"  , {60,005}, "Est. Veículo (1=Conforme; 2= Não Conforme)" 					, "@!" 		,"PERTENCE('12')"	,      ,   			})
AAdd(aR, { "M->ZJ_QPROXNF"  , {60,190}, "Cód. Prod. X Cód. Regist. NF (1=Conforme; 2= Não Conforme)"	, "@!" 		,"PERTENCE('12')"	,      ,   			})
AAdd(aR, { "M->ZJ_ACONDIC"  , {75,005}, "Acondicionamento (1=Conforme; 2= Não Conforme)" 				, "@!" 		,"PERTENCE('12')"	,      ,   			})
AAdd(aR, { "M->ZJ_QEMXFAT"  , {75,181}, "Qtde. Embarcada X Qtde. Fatur. (1=Conforme; 2= Não Conforme)" 	, "@!" 		,"PERTENCE('12')"	,      ,   			})

aCGD := {40,10,30,10}

// Validacao na mudanca de linha quando clicar no botao OK.
cLinOK := ".T."
                                       
cTitulo := "Romaneio - Expedição"

lRet := Modelo2(cTitulo, aC, aR, aCGD, nOpc, cLinOK, cAllOK, , , cIniCpos, nMax)

If lRet  // Confirmou (.T.)  Nao confirmou (.F.)
	
	If nOpc == 3    // Inclusao
		If MsgYesNo("Confirma a gravacao dos dados?", cTitulo)
			Processa({||PA191C(cAlias)}, cTitulo, "Gravando os dados, aguarde...")
		EndIf
	ElseIf nOpc == 4    // Alteracao
		If MsgYesNo("Confirma a alteracao dos dados?", cTitulo)
			Processa({||PA191D(cAlias)}, cTitulo, "Alterando os dados, aguarde...")
		EndIf
	ElseIf nOpc == 5    // Exclusao
		If MsgYesNo("Confirma a exclusao dos dados?", cTitulo)
			Processa({||PA191E(cAlias)}, cTitulo, "Excluindo os dados, aguarde...")
		EndIf
	EndIf

Else

	RollBackSX8()

EndIf

Return (Nil)


Static Function PA191C(cAlias)

Local i
Local y
Local nNrCampo

ProcRegua(Len(aCols))

dbSelectArea(cAlias)

For i := 1 To Len(aCols)
	
	IncProc()
	
	If !aCols[i][Len(aHeader)+1]  // A linha nao esta deletada, logo, deve ser gravada.	

		RecLock(cAlias, .T.)

		_cSerie := _cNF1 := ""		
		For y := 1 To Len(aHeader)
			nNrCampo := FieldPos(Trim(aHeader[y][2]))
			FieldPut(nNrCampo, aCols[i][y])

			If nNrCampo = 4
				_cSerie := aCols[i][y]
			ElseIf	nNrCampo = 5
				_cNF1   := aCols[i][y]
			Endif	
		Next
		
		_cNomeTra := ""
		If SA4->(dbseek(xFilial("SA4")+M->ZJ_CODTRAN))
			_cNomeTra := SA4->A4_NOME
		Endif	
		_cNomeRes := ""
		If SZK->(dbseek(xFilial("SZK")+M->ZJ_CODRESP))
			_cNomeRes := SZK->ZK_NOME
		Endif	
		    
		(cAlias)->ZJ_Filial := xFilial(cAlias)
		(cAlias)->ZJ_NUMERO := M->ZJ_NUMERO
		(cAlias)->ZJ_DTSAIDA:= M->ZJ_DTSAIDA
		(cAlias)->ZJ_HORASAI:= M->ZJ_HORASAI
		(cAlias)->ZJ_CODTRAN:= M->ZJ_CODTRAN
		(cAlias)->ZJ_NOMETRA:= _cNomeTra
		(cAlias)->ZJ_MOTORIS:= M->ZJ_MOTORIS
		(cAlias)->ZJ_VEICULO:= M->ZJ_VEICULO
		(cAlias)->ZJ_PLACA  := M->ZJ_PLACA
		(cAlias)->ZJ_TPTRANS:= M->ZJ_TPTRANS
		(cAlias)->ZJ_CONDVEI:= M->ZJ_CONDVEI
		(cAlias)->ZJ_ACONDIC:= M->ZJ_ACONDIC
		(cAlias)->ZJ_QPROXNF:= M->ZJ_QPROXNF
		(cAlias)->ZJ_QEMXFAT:= M->ZJ_QEMXFAT
		(cAlias)->ZJ_CODRESP:= M->ZJ_CODRESP
		(cAlias)->ZJ_NOMRESP:= _cNomeRes
						
		MSUnlock()

		If SF2->(dbSeek(xFilial("SF2")+_cNF1+_cSerie))
			RecLock("SF2", .F.)
			SF2->F2_DTENTR := M->ZJ_DTSAIDA
			MSUnlock()
		Endif
		
		ASN(_cNF1,_cSerie) // Envia ASN
		
	EndIf
	
Next i

ConfirmSX8()

Return Nil


Static Function PA191D(cAlias) // Alterando dados

Local i
Local y
Local nNrCampo

ProcRegua(Len(aCols))

dbSelectArea(cAlias)

For i := 1 To Len(aCols)
	
	If i <= Len(aAlt)
				
		dbSelectArea("SZJ")
		dbGoTo(aAlt[i])  // Posiciona no registro.
		
		If aCols[i][Len(aHeader)+1]     // A linha esta deletada.
			
			// Desatualiza
			If SF2->(dbSeek(xFilial("SF2")+SZJ->ZJ_NF+SZJ->ZJ_SERIE))
				RecLock("SF2", .F.)
				SF2->F2_DTENTR := CTOD("  /  /  ")
				MSUnlock()
			Endif
			
			// E depois deleta o registro correspondente.
			RecLock(cAlias, .F.)
			SZJ->(dbDelete())
			
		Else                            // A linha nao esta deletada.
						
			// Regrava os dados.

			_cNomeTra := ""
			If SA4->(dbseek(xFilial("SA4")+M->ZJ_CODTRAN))
				_cNomeTra := SA4->A4_NOME
			Endif

			RecLock("SZJ", .F.)
	
			_cSerie := _cNF1 := ""		
			For y := 1 To Len(aHeader)
				nNrCampo := FieldPos(Trim(aHeader[y][2]))
				FieldPut(nNrCampo, aCols[i][y])

				If nNrCampo = 4
					_cSerie := aCols[i][y]
				ElseIf	nNrCampo = 5
					_cNF1   := aCols[i][y]
				Endif	
			Next
			
			(cAlias)->ZJ_DTSAIDA:= M->ZJ_DTSAIDA
			(cAlias)->ZJ_HORASAI:= M->ZJ_HORASAI
			(cAlias)->ZJ_CODTRAN:= M->ZJ_CODTRAN
			(cAlias)->ZJ_NOMETRA:= _cNomeTra
			(cAlias)->ZJ_MOTORIS:= M->ZJ_MOTORIS
			(cAlias)->ZJ_VEICULO:= M->ZJ_VEICULO
			(cAlias)->ZJ_PLACA  := M->ZJ_PLACA
			(cAlias)->ZJ_TPTRANS:= M->ZJ_TPTRANS
			(cAlias)->ZJ_CONDVEI:= M->ZJ_CONDVEI
			(cAlias)->ZJ_ACONDIC:= M->ZJ_ACONDIC
			(cAlias)->ZJ_QPROXNF:= M->ZJ_QPROXNF
			(cAlias)->ZJ_QEMXFAT:= M->ZJ_QEMXFAT

			MSUnlock()
			
			_cNomeRes := ""
			If SZK->(dbseek(xFilial("SZK")+M->ZJ_CODRESP))
				_cNomeRes := SZK->ZK_NOME
			Endif
		    			
			// Atualiza
			If SF2->(dbSeek(xFilial("SF2")+_cNF1+_cSerie))
				RecLock("SF2", .F.)
				SF2->F2_DTENTR := M->ZJ_DTSAIDA
				MSUnlock()
			Endif	
			
		EndIf
		
	Else     // Foram incluidas mais linhas na GetDados (aCols), logo, precisam ser incluidas.
		
		If !aCols[i][Len(aHeader)+1]
			
			_cNomeTra := ""
			If SA4->(dbseek(xFilial("SA4")+M->ZJ_CODTRAN))
				_cNomeTra := SA4->A4_NOME
			Endif

			RecLock(cAlias, .T.)
			
			_cSerie := _cNF1 := ""		
			For y := 1 To Len(aHeader)
				nNrCampo := FieldPos(Trim(aHeader[y][2]))
				FieldPut(nNrCampo, aCols[i][y])

				If nNrCampo = 4
					_cSerie := aCols[i][y]
				ElseIf	nNrCampo = 5
					_cNF1   := aCols[i][y]
				Endif	
			Next

			(cAlias)->ZJ_Filial := xFilial(cAlias)
			(cAlias)->ZJ_NUMERO := M->ZJ_NUMERO
			(cAlias)->ZJ_DTSAIDA:= M->ZJ_DTSAIDA
			(cAlias)->ZJ_HORASAI:= M->ZJ_HORASAI
			(cAlias)->ZJ_CODTRAN:= M->ZJ_CODTRAN
			(cAlias)->ZJ_NOMETRA:= _cNomeTra
			(cAlias)->ZJ_MOTORIS:= M->ZJ_MOTORIS
			(cAlias)->ZJ_VEICULO:= M->ZJ_VEICULO
			(cAlias)->ZJ_PLACA  := M->ZJ_PLACA
			(cAlias)->ZJ_TPTRANS:= M->ZJ_TPTRANS
			(cAlias)->ZJ_CONDVEI:= M->ZJ_CONDVEI
			(cAlias)->ZJ_ACONDIC:= M->ZJ_ACONDIC
			(cAlias)->ZJ_QPROXNF:= M->ZJ_QPROXNF
			(cAlias)->ZJ_QEMXFAT:= M->ZJ_QEMXFAT
			(cAlias)->ZJ_CODRESP:= M->ZJ_CODRESP
			(cAlias)->ZJ_NOMRESP:= _cNomeRes
						
			SZJ->(MSUnlock())

			// Atualiza data
			If SF2->(dbSeek(xFilial("SF2")+_cNF1+_cSerie))			
				RecLock("SF2", .F.)
				SF2->F2_DTENTR := M->ZJ_DTSAIDA
				MSUnlock()
			Endif
			
			ASN(_cNF1,_cSerie) // Envia ASN
			
		EndIf
		
	EndIf
	
Next
  
Return (Nil)


Static Function PA191E(cAlias) //EXCLUIR

ProcRegua(Len(aCols))

dbSelectArea("SZJ")
dbSeek(xFilial(cAlias) + M->ZJ_NUMERO)

While !Eof() .And. (cAlias)->ZJ_Filial == xFilial(cAlias) .And. (cAlias)->ZJ_NUMERO == M->ZJ_NUMERO
	
	// Nao precisa testar o nome pois numero e' chave primária.
	
	IncProc()
	
	// Desatualiza
	If SF2->(dbSeek(xFilial("SF2")+SZJ->ZJ_NF+SZJ->ZJ_SERIE))
		RecLock("SF2", .F.)
		SF2->F2_DTENTR := CTOD("  /  /  ")
		MSUnlock()
	Endif
	
	RecLock(cAlias, .F.)
	dbDelete()
	MSUnlock()
	
	dbSelectArea("SZJ")
	dbSkip()
	
EndDo

Return Nil


User Function PA191B()

Local lRet := .T.
Local i    := 0
Local nDel := 0

For i := 1 To Len(aCols)
	If aCols[i][Len(aHeader)+1]
		nDel++
	EndIf
Next

If nDel == Len(aCols)
	MsgInfo("Para excluir todos os itens, utilize a opção EXCLUIR", cTitulo)
	lRet := .F.
EndIf

Return lRet


User Function PA191F()

_aAliOri := GetArea()
_aAliSZK := SZK->(GetArea())
_aAliSZJ := SZJ->(GetArea())

lRet := .T.
If SZK->(dbseek(xFilial("SZK")+M->ZJ_CODRESP))
	M->ZJ_CODRESP := SZK->ZK_CODIGO 
	M->ZJ_NOMRESP := SZK->ZK_NOME
	lRet := .T.
Else
	Alert("Responsável não cadastrado!")
	M->ZJ_NOMRESP := ""
	M->ZJ_CODRESP := ""
	lRet := .F.
Endif

RestArea(_aAliSZJ)
RestArea(_aAliSZK)
RestArea(_aAliOri)

Return lRet


User Function PA191G()

_aAliOri := GetArea()
_aAliSA4 := SA4->(GetArea())
_aAliSZJ := SZJ->(GetArea())

lRet := .T.

If M->ZJ_TPTRANS = '1'
	Alert("Não é necessário colocar Transportadora!")
	M->ZJ_CODTRAN := ""                         	
	M->ZJ_NOMETRA := ""
Else	
	If SA4->(dbseek(xFilial("SA4")+M->ZJ_CODTRAN))
		M->ZJ_NOMETRA := SA4->A4_NOME
		M->ZJ_MOTORIS := SA4->A4_MOTORIS		
		M->ZJ_VEICULO := SA4->A4_VEICULO		
		M->ZJ_PLACA   := SA4->A4_PLACA
		
	//	lRet := .T.
	Else
		Alert("Transportadora não cadastrada!")	
		M->ZJ_CODTRAN := ""                         	
		M->ZJ_NOMETRA := ""
	//	lRet := .F.
	Endif
Endif	

RestArea(_aAliSZJ)
RestArea(_aAliSA4)
RestArea(_aAliOri)

Return lRet
           

User Function PA191H()

_aAliOri := GetArea()
_aAliSZJ := SZJ->(GetArea())

lRet := .T.

If M->ZJ_TPTRANS = '1'
	M->ZJ_CODTRAN := ""                         	
	M->ZJ_NOMETRA := ""
ElseIf M->ZJ_TPTRANS = '2'
	M->ZJ_CODTERC := ""
	M->ZJ_MOTORIS := ""
	M->ZJ_VEICULO := ""
	M->ZJ_PLACA   := ""	
Endif	

RestArea(_aAliSZJ)
RestArea(_aAliOri)

Return lRet


User Function PA191I()

_aAliOri := GetArea()
_aAliSA4 := SA4->(GetArea())
_aAliSZJ := SZJ->(GetArea())

lRet := .T.

If M->ZJ_TPTRANS = '2'
	Alert("Não é necessário colocar Codigo Terceiro!")
	M->ZJ_CODTERC := ""
	M->ZJ_MOTORIS := ""
	M->ZJ_VEICULO := ""
	M->ZJ_PLACA   := ""	
Else	
	If SA4->(dbseek(xFilial("SA4")+M->ZJ_CODTRAN))
		M->ZJ_MOTORIS := SA4->A4_MOTORIS
		M->ZJ_VEICULO := SA4->A4_VEICULO
		M->ZJ_PLACA   := SA4->A4_PLACA
	Else
		Alert("Terceiro não cadastrado!")	
		M->ZJ_CODTERC := ""
		M->ZJ_MOTORIS := ""
		M->ZJ_VEICULO := ""
		M->ZJ_PLACA   := ""	
	Endif
Endif	

RestArea(_aAliSZJ)
RestArea(_aAliSA4)
RestArea(_aAliOri)

Return lRet
                      


Static Function ASN(cNF,cSerie) // Envia ASN

Private _cQtdItem
Private _cCfo
Private _lAGCO    := _lVALTRA := _lCNH  := .F.

SF2->(dbSetOrder(1))
If !SF2->(dbSeek(xFilial("SF2")+cNF+cSerie))
	Alert("Nota Fiscal Nao Encontrada!!!!!")
	Return
Endif

_cCgc2  := SM0->M0_CGC
_cData2 := GravaData(dDataBase,.f.,8)
_cHora2 := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
_lAGCO  := _lVALTRA := _lCNH  := .F.

If SF2->F2_CLIENTE == "000001"
	Private _cArqTxtV := "\\SERVER2\ERP\EDI\SAWLUZ\AGCO\Saida\AGCO_"+_cData2+"_"+_cHora2+"_00000.TXT"
//	Private _cArqTxtV := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\AGCO\Saida\AGCO_"+_cData2+"_"+_cHora2+"_00000.TXT"
	_lAGCO   := .T.
ElseIf SF2->F2_CLIENTE == "000053"
	Private _cArqTxtV := "\\SERVER2\ERP\EDI\SAWLUZ\VALTRA\SAIDA\VALTRA_"+_cData2+"_"+_cHora2+"_00000.TXT"
//	Private _cArqTxtV := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\VALTRA\SAIDA\VALTRA_"+_cData2+"_"+_cHora2+"_00000.TXT"
	_lVALTRA := .T.
ElseIf SF2->F2_CLIENTE == "000071"
	Private _cArqTxtV := "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\CNH\BRASIL\SAIDA\PASY_CNH_"+_cData2+"_"+_cHora2+"_00000.TXT"
	_lCNH    := .T.
Else
	Return
Endif

Private _nHdlV    := MSfCreate(_cArqTxtV)

If _nHdlV == -1
	MsgAlert("O arquivo de nome "+_cArqTxtV+" 1 nao pode ser executado!","Atencao!")
	fClose(_nHdlV)
	Return
Endif

// - Notas Fiscais de Retorno

_cCgc2  := SM0->M0_CGC
_cData2 := GravaData(dDataBase,.f.,8)
_cHora2 := Substr(Time(),1,2) + Substr(Time(),4,2) + strzero(Val(Substr(Time(),7,2))+1,2)

If SF2->F2_CLIENTE == "000001"
	Private _cArqTxtR  := "\\SERVER2\ERP\EDI\SAWLUZ\AGCO\Saida\AGCO_"+_cData2+"_"+_cHora2+"_00000.TXT"
//	Private _cArqTxtR  := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\AGCO\Saida\AGCO_"+_cData2+"_"+_cHora2+"_00000.TXT"
ElseIf 	 SF2->F2_CLIENTE == "000053"
	Private _cArqTxtR  := "\\SERVER2\ERP\EDI\SAWLUZ\VALTRA\SAIDA\VALTRA_"+_cData2+"_"+_cHora2+"_00000.TXT"
//	Private _cArqTxtR  := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\VALTRA\SAIDA\VALTRA_"+_cData2+"_"+_cHora2+"_00000.TXT"
ElseIf 	 SF2->F2_CLIENTE == "000071"
	Private _cArqTxtR  := "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\CNH\BRASIL\SAIDA\PASY_CNH_"+_cData2+"_"+_cHora2+"_00000.TXT"
Endif

Private _nHdlR     := MSfCreate(_cArqTxtR)
Private _lEncontV  := .t.
Private _lEncontR  := .t.

If _nHdlR == -1
	MsgAlert("O arquivo de nome "+_cArqTxtR+" 2 nao pode ser executado!","Atencao!")
	fClose(_nHdlR)
	Return
Endif

Private _cEOL    := "CHR(13)+CHR(10)"

If Empty(_cEOL)
	_cEOL := CHR(13)+CHR(10)
Else
	_cEOL := Trim(_cEOL)
	_cEOL := &_cEOL
Endif

_cLin    := Space(128) + _cEOL

Private _cLin, _cCpo, _cCGCPasy,_cCGCCli,_cUM, _cIdenti,_cTpForn,_cIdent,_lFerr
Private _cIdenti    := "000"
Private _cSeqv      := "00000"
Private _cSeqR      := "00000"
Private _dVencto    := "000000"
Private _cDescCFO   := space(15)
Private _cClasFis   := space(10)
Private _nTamLin    := 128
Private _nItem, _cDescCFO,_cRev,_nContLiV, _nContLiR, _nSomaTot
Private _cRev       := "0000"
Private _cItemOri   := space(3)
Private _cDtori     := space(6)
Private _cCodFab    := space(3)
Private _aDirLoc 	:= DIRECTORY( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\CNH\BRASIL\SAIDA\PASY_CNH_*.TXT",  )
Private _cServer 	:= "ftp.gmdlogistica.com.br"
Private _nPorta  	:= 21
Private _cUser   	:= "pasy"
Private _cPass   	:= "pasygmd"

_lAchouV  := .F.
_lAchouR  := .F.
_nContLiV := 0
_nContLiR := 0
_nSomaTot := 0

//dbSelectArea("SF2")
//RecLock("SF2",.F.)
//SF2->F2_FIMP := "S"
//MsUnlock()

_lFerr := .F.

dbSelectArea("SD2")
dbOrderNickName("INDSD24")
If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	_cChavSD2    := SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
	_nQtdItem    := 0
	_lRetorno    := .F.
	_lVenda      := .F.
	While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		
		_nQtdItem ++
		_cCfo     := SD2->D2_CF                           // Codigo de Operaçao           (5) M
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SD2->D2_COD)
			If SB1->B1_TIPO == "FR"
				_lFerr := .T.
			Endif
		Endif
		
		If SD2->D2_TIPO == "D"
			_lRetorno := .T.
			_lAchouR  := .T.
		Else
			dbSelectArea("SF4")
			dbSetOrder(1)
			If dbSeek(xFilial("SF4")+SD2->D2_TES)
				If SF4->F4_PODER3 == "D"
					_lRetorno := .T.
					_lAchouR  := .T.
				Else
					_lVenda  := .T.
					_lAchouV := .T.
				Endif
			Endif
		Endif
		_cCfo1 := SD2->D2_CF                           // Codigo de Operaçao           (4) M
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif
_cQtdItem    := strZero(_nQtdItem,3)                             // Qtde de itens a N.F.         (3) M

If !_lFerr
	If _lVenda
		GeraVenda2()
	Else
		GeraRet2()
	Endif
Endif

If _lAchouV
	_nContLiV++
	_cContLI  := StrZero(_nContLiV,9)                           // Numero de Controle             (9)  M
	_cSomaTot := StrZero(Int(_nSomaTot *100),17)                // Soma Total das N.Fiscais       (12) M
	_cCpo     := "FTP"+ _cSeqv + _cContLi + _cSomaTot + "D" + sPace(93)
	
	_cLin     := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	
	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FTP). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif

	fClose(_nHdlV)
	
	If _lCNH
		fClose(_nHdlR)
		_aDirLoc := DIRECTORY( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\CNH\BRASIL\SAIDA\PASY_CNH_*.TXT",  )
		_cServer := "ftp.gmdlogistica.com.br"
		_nPorta  := 21
		_cUser   := "pasy"
		_cPass   := "pasygmd"
		
		If FTPConnect( _cServer, _nPorta, _cUser, _cPass )
			For I:=1 to Len(_aDirLoc)
				_cArq   := "\CNH\BRASIL\SAIDA\"+_aDirLoc[I][1]
				_nHdl   := fOpen(_cArq,129)
				_nTamF  := fSeek(_nHdl,0,2)	
				If _nTamF > 0
					If FTPUpLoad( "\CNH\BRASIL\SAIDA\" + _aDirLoc[I][1], _aDirLoc[I][1] )
						Conout('UpLoad Ok! '+ _aDirLoc[I][1])
						_cArqNew := "\CNH\BRASIL\SAIDA\BACKUP\BACK_"+_aDirLoc[I][1]
						__CopyFile(_cArq,_cArqNew)
						fClose(_nHdl)
						FErase(_cArq)
					Else
						Conout('Falha UpLoad!'+aDirLoc[I][1])
						fClose(_nHdl)						
					EndIf
				Else
					fClose(_nHdl)
					FErase(_cArq)			
				Endif
			Next I
			
//			MsgInfo("Nota Fiscal Enviada!!!")
		Endif
	Endif
Else
	fClose(_nHdlV)
	FErase(_cArqTxtV)
Endif

If _lAchouR
	_nContLiR++
	_cContLI  := StrZero(_nContLiR,9)                           // Numero de Controle             (9)  M
	_cSomaTot := StrZero(Int(_nSomaTot *100),17)               // Soma Total das N.Fiscais        (12) M
	_cCpo     := "FTP"+ _cSeqR + _cContLi + _cSomaTot + "D" + sPace(93)
	
	_cLin     := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	
	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FTP). Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif
Else
	fClose(_nHdlR)
	FErase(_cArqTxtR)
Endif

Sleep(5000) // 5 segundos

Return




Static Function GeraVenda2()

If _lEncontV
	_lEncontV := .F.
	_cLin     := Space(128) + _cEOL
	
	If _lAGCO
		_cSeqv    := GetMv("MV_NUMAGCO")
	ElseIf _lVALTRA
		_cSeqv    := GetMv("MV_NUMVALT")
	ElseIf _lCNH
		_cSeqv    := GetMv("MV_NUMCNH")
	Endif
	
	dbSelectArea("SX6")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := SOMA1(_cSeqV)
	MsUnlock()
	
	_cData     := GravaData(dDataBase,.f.,4)
	_cHora     := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
	_cCgcPasy  := SM0->M0_CGC
	_cNomPasy  := Substr(SM0->M0_NOMECOM,1,25)
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
		_cCGCCli  := SA1->A1_CGC
		_cNomCli  := Substr(SA1->A1_NOME,1,25)
	Endif
	
	_cTpForn := "P"

	If _lCNH
		_cIdent    := "ITP00417"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		_cCodTra   := Space(8)             // Codigo Interno do Transmissor          08 - (54 a 61)
		If SA1->A1_LOJA = "13'
			_cTpForn := "R"
		Endif	
	Else
		_cIdent    := "ITP00421"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
//		_cIdent    := "ITP00415"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		_cCodTra   := "00013456"           // Codigo Interno do Transmissor          08 - (54 a 61)
		If (SA1->A1_COD = "000001" .AND. SA1->A1_LOJA = "04") .Or.;
			(SA1->A1_COD = "000053" .AND. SA1->A1_LOJA = "02")
			_cTpForn := "R"
		Endif
	Endif

	_cSeqv     := _cSeqv               // Numero de Controle da Transação        05 - (09 a 13)
	_cDtHora   := _cData + _cHora      // Identificacao da Geração do Movimento  12 - (14 a 25)
	_cCgcPasy  := _cCgcPasy            // Ident. Transmissor na Comunicação      14 - (26 a 39)
	_cCGCCli   := _cCGCCli             // Ident. Receptor na Comunicação         14 - (40 a 53)
	_cCodRec   := Space(8)             // Codigo Interno do Receptor             08 - (62 a 69)
	_cNomPasy  := _cNomPasy            // Nome do Transmissor                    25 - (70 a 94)
	_cNomCli   := _cNomCli             // Nome do Receptor                       25 - (95 a 119)
	_cEspaco   := Space(9)             // Espaço em branco                       09 - (120 a 128)
	
	_cCpo      := _cIdent + _cSeqv + _cDtHora + _cCgcPasy + _cCGCCli +_cCodTra + _cCodRec + _cNomPasy + _cNomCli + _cEspaco
	_cLin      := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiV++
	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif
Endif

_cLin     := Space(128)+_cEOL
_cNf      := STRZERO(VAL(SF2->F2_DOC),6)
_cSer     := SF2->F2_SERIE + SPACE(1)
_dDataNf  := GravaData(SF2->F2_EMISSAO,.f.,4)
_cVlTotal := StrZero(Int(SF2->F2_VALBRUT*100),17)
_nSomaTot += SF2->F2_VALBRUT
_cVlICMS  := StrZero(Int(SF2->F2_VALICM*100),17)

dbSelectArea("SE1")
dbSetOrder(1)
If dbSeek(xFilial("SE1")+ SF2->F2_SERIE + SF2->F2_DOC + "   NF ")
	_dVencto := GravaData(SE1->E1_VENCREA,.f.,4)
Endif

_cEspecie := "02"
_cVlIPI   := StrZero(Int(SF2->F2_VALIPI*100),17)

dbSelectArea("SX5")
dbSetOrder(1)
If dbSeek(xFilial("SX5")+"13"+ _cCFO + sPace(1))
	_cDescCFO := SUBSTR(SX5->X5_DESCRI,1,15)
Endif

_dDtEmb   := GravaData(SF2->F2_EMISSAO,.f.,4)
_cHora    := Substr(SF2->F2_HORA,1,2)+ Substr(SF2->F2_HORA,4,2)

_cTpReg   := "AE1"                  // Tipo de Registro          03 - (01 a 03)
_cNf      := _cNf                   // Numero da Nota Fiscal     06 - (04 a 09)
_cSer     := _cSer                  // Serie  da Nota Fiscal     03 - (10 a 13)
_cDataNf  := _dDataNf               // Data   da Nota Fiscal     06 - (14 a 19)
_cQtdItem := _cQtdItem              // Quantidade de Item da NF  03 - (20 a 22)
_cVlTotal := _cVlTotal              // Valor Total da N.Fiscal   17 - (23 a 39)
_cQtdCd   := "0"                    // Qtde Casas Decimais       01 - (40 a 40)
_cCfo     := StrZero(Val(_cCfo),5)  // Codigo Fiscal de Operacao 05 - (41 a 45)
_cVlICMS  := _cVlICMS               // Valor total ICMS Aplicado 17 - (46 a 62)
_cVencto  := _dVencto               // Data do Vencimento        06 - (63 a 68)
_cEspecie := _cEspecie              // Especie da Nota Fiscal    02 - (69 a 70)
_cVLIPI   := _cVlIPI                // Valor Total do IPI        17 - (71 a 87)
_cCodFab  := Space(3)               // Codigo da Fabrica         03 - (88 a 90)
_cDtPrev  := "000000"               // Data Previsao Entrega     06 - (91 a 96)
_cPerEnt  := space(4)               // Periodo da Entrega        04 - (97 a 100)
_cDescCfo := _cDescCfo              // Descricao da Nat.Operacao 15 - (101 a 115)
_cDtEmb   := _dDtEmb                // Data do Embarque          06 - (116 a 121)
_cHora    := _cHora                 // Hora do Embarque          04 - (122 a 125)
_cEspaco  := Space(3)               // Espaco em Branco          03 - (126 a 128)

_cCpo    := _cTpReg + _cNf + _cSer + _cDataNF + _cQtdItem + _cVlTotal + _cQtdCD + _cCfo + _cVlICMS + _cVencto + _cEspecie + _cVlIPI + ;
_cCodFab + _cDtPrev + _cPerEnt + _cDescCFO + _cDtEmb + _cHora + _cEspaco

_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
_nContLiV++

If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE1).  Continua?","Atencao!")
		fClose(_nHdlV)
		Return
	Endif
Endif

// - NF2

_cTpReg   := "NF2"
_cDespAce := StrZero(Int(SF2->F2_DESPESA*100),12)
_cFrete   := StrZero(Int(SF2->F2_FRETE*100),12)
_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),12)
_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),12)
_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),12)
_cICMS    := StrZero(Int(SF2->F2_VALICM*100),12)

_cTpReg    := _cTpReg                         // Tipo de Registro           03 - (01 a 03)
_cDespAce  := _cDespAce                       // Valor Despesas Acessorias  12 - (04 a 15)
_cFrete    := _cFrete                         // Valor do Frete             12 - (16 a 27)
_cSeguro   := _cSeguro                        // Valor do Seguro            12 - (28 a 39)
_cDescon   := _cDescon                        // Valor do Desconto          12 - (40 a 51)
_cBaseICMS := _cBaseICMS                      // Base de Calculo do ICMS    12 - (52 a 63)
_cICMS     := _cICMS                          // Valor do ICMS              12 - (64 a 75)
_cZero     := "000000000000"                  // Numero,Data                06 - (76 a 87)
_cBranco   := Space(7)                        // Serie,Codigo da Fabrica    36 - (88 a 94)
_cCfo2     := StrZero(VaL(_cCFO),5)           // Codigo Fiscal Operacao     05 - (95 a 99)
_cBranco2  := Space(29)                       // Espaco em Branco           29 - (100 a 128)

_cCpo := _cTpReg+ _cDespAce + _cFrete + _cSeguro + _cDescon + _cBaseICMS + _cICMS + _cZero + _cBranco + _cCfo2 + _cBranco2

_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
_nContLiV++

If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
		fClose(_nHdlV)
		Return
	Endif
Endif

_cPedCli := space(12)
_cProdCli:= space(30)

dbSelectArea("SD2")
dbOrderNickName("INDSD24")
If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	_cChavSD2 :=SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
	
	While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		
		_cLin   := Space(128) + _cEOL                         // Tipo de Registro             (3)  M
		_cItem  := "0"+ SD2->D2_ITEM
		
		_cProdCli := SD2->D2_PROCLI + Space(15)
		If Empty(_cProdCli)
			_cProdCli := "S/CODIGO"+ Space(22)
		Endif
		
		_cDest   := Space(03)
		dbSelectArea("SC6")
		dbSetOrder(1)
		If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
			_cPedCli := Substr(SC6->C6_PEDCLI,1,12)
			_cDest   := SC6->C6_LOCDEST			
		Endif
		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+ SD2->D2_LOJA+ SD2->D2_COD + SD2->D2_PROCLI+"1")
			If Empty(_cPedcli)
				_cPedCli := Substr(SZ2->Z2_PEDCLI,1,12)
			Endif
			_cRev    := ALLTRIM(SZ2->Z2_REVISAO)
		Endif
		
		_cQtde    := StrZero(Int(SD2->D2_QUANT),9)
		
		dbSelectArea("SAH")
		dbSetOrder(1)
		If dbSeek(xFilial("SAH")+ SD2->D2_UM)
			_cUm := "PC"//SAH->AH_CODANFA
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SD2->D2_COD)
			_cClasFis := STRZERO(VAL(SB1->B1_POSIPI),10)
		Endif
		
		_cAliIPI := StrZero(Int(SD2->D2_IPI*100),4)
		_cVlItem := StrZero(Int(SD2->D2_PRCVEN*100000),12)
		
		If Len(_cRev) == 2
			_cRev := Space(2)+_cRev
		Else
			_cRev := Substr(_cRev,1,4)
		Endif
		
		_cTpReg    := "AE2"                               // Tipo de Registro           03 - (01 a 03)
		_cItem     := _cItem                              // NUmero do Item da N.Fiscal 03 - (04 a 06)
		_cPedCli   := _cPedCli                            // NUmero do Pedido de Compra 12 - (07 a 18)
		_cProdCli  := _cProdCli                           // Codigo do Item             30 - (19 a 48)
		_cQtde     := _cQtde                              // Qtde do Item na Nota Fiscal09 - (49 a 57)
		_cUM       := _cUm                                // Unidade Medida             02 - (58 a 59)
		_cClasFis  := _cClasFis                           // Classificacao Fiscal       10 - (60 a 69)
		_cAliIPI   := _cAliIPi                            // Aliq. do IPI               04 - (70 a 73)
		_cVlItem   := _cVlItem                            // Valor do Item              12 - (74 a 85)
		_cQtde     := _cQtde                              // Qtde do Item em Estoque    09 - (86 a 94)
		_cUM       := _cUm                                // Unidade Medida Estoque     02 - (95 a 96)
		_cQtde     := _cQtde                              // Qtde do Unidade de Compra  09 - (97 a 105)
		_cUM       := _cUm                                // Unidade Medida de Compra   02 - (106 a 107)
		_cTpForn   := _cTpForn                            // Tipo de Fornecimento       01 - (108 a 108)
//		_cTpForn   := "P"                                 // Tipo de Fornecimento       01 - (108 a 108)
		_cPerDesc  := StrZero(Int(SD2->D2_DESC*100),4)    // Percentual de Desconto     04 - (109 a 112)
		_cValDesc  := StrZero(Int(SD2->D2_DESCON*100),11) // Valor do Desconto          11 - (113 a 123)
		_cRev      := _cRev                               // Alteracao Tecnica do Item  04 - (124 a 127)
		_cBranco   := Space(1)                            // Espaco em branco           01 - (128 a 128)
		
		_cCpo := _cTpReg + _cItem + _cPedCli + _cProdCli + _cQtde + _cUM + _cClasFis + _cAliIPI + _cVlItem + _cQtde + _cUM + ;
		_cQtde + _cUM + _cTpForn + _cPerDesc + _cValDesc + _cRev + _cBranco
		
		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		_nContLiV++
		
		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE2). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif
		
		_cAliICMS  := StrZero(Int(SD2->D2_PICM   *100),4)           // Percentual ICMS                (4)  O
		_cBaseICMS := StrZero(Int(SD2->D2_BASEICM*100),17)          // Base ICMS                      (17) O
		_cVlICMS   := StrZero(Int(SD2->D2_VALICM *100),17)          // Valor do ICMS                  (17) O
		_cVlIPI    := StrZero(Int(SD2->D2_VALIPI *100),17)          // Valor do ICMS                  (17) O
		_cVlTotal  := StrZero(Int(SD2->D2_TOTAL  *100),12)          // Valor Total do Item            (12) M
		
		_cCpo := "AE4"+ _cAliICMS + _cBaseICMS + _cVlICMS + _cVlIPI + "00" + sPace(30) +"000000"+space(13)+ space(5) + "1" +_cVlTotal +sPace(1)
		
		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		_nContLiV++
		
		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE4). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif

_cZeros    := Repl('0',28)
_cLocEnt   := ""

If _lAGCO
	If SF2->F2_LOJA == "01"
		_cLocEnt := "CAN"
	ElseIf SF2->F2_LOJA == "02"
		_cLocEnt := "SRO"
	ElseIf SF2->F2_LOJA == "03"
		_cLocEnt := "SUM"
	Endif
ElseIf _lVALTRA // 000053
//	_cLocEnt := "MOG"
	_cLocEnt := _cDest
ElseIf _lCNH   // 000071
	_cLocEnt := _cCGCCli
Endif

_cLocEnt := _cLocEnt +Space(11)

_cCpo := "AE3"+ _cZeros + _cLocEnt + Space(83)

_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
_nContLiV++

If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE3). Continua?","Atencao!")
		fClose(_nHdlV)
		Return
	Endif
Endif

Return



Static Function GeraRet2()

If _lEncontR
	_lEncontR := .F.
	_cLin     := Space(128) + _cEOL
	
	If _lAGCO
		_cSeqR := GetMv("MV_NUMAGCO")
	ElseIf _lVALTRA == "000053"
		_cSeqR := GetMv("MV_NUMVALT")
	ElseIf _lCNH    == "000071"
		_cSeqR := GetMv("MV_NUMCNH")
	Endif
	
	dbSelectArea("SX6")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := StrZero((Val(_cSeqR)+1),5)
	MsUnlock()
	
	_cData     := GravaData(dDataBase,.f.,4)
	_cHora     := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
	_cCgcPasy  := SM0->M0_CGC
	_cNomPasy  := Substr(SM0->M0_NOMECOM,1,25)
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
		_cCGCCli := SA1->A1_CGC
		_cNomCli := Substr(SA1->A1_NOME,1,25)
	Endif
	
	_cCodCli := SF2->F2_CLIENTE+SF2->F2_LOJA
	
	_cTpForn := "P"

	If _lCNH
		_cIdent := "ITP00417"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		If SA1->A1_LOJA = "13'
			_cTpForn := "R"
		Endif	

	Else
//		_cIdent := "ITP00415"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		_cIdent := "ITP00421"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		If (SA1->A1_COD = "000001" .AND. SA1->A1_LOJA = "04") .Or.;
			(SA1->A1_COD = "000053" .AND. SA1->A1_LOJA = "02")
			_cTpForn := "R"
		Endif
	Endif
	
	_cSeqv     := _cSeqv               // Numero de Controle da Transação        05 - (09 a 13)
	_cDtHora   := _cData + _cHora      // Identificacao da Geração do Movimento  12 - (14 a 25)
	_cCgcPasy  := _cCgcPasy            // Ident. Transmissor na Comunicação      14 - (26 a 39)
	_cCGCCli   := _cCGCCli             // Ident. Receptor na Comunicação         14 - (40 a 53)
	If _lCNH
		_cCodTra   := "00000000"           // Codigo Interno do Transmissor          08 - (54 a 61)
	Else
		_cCodTra   := "00013456"           // Codigo Interno do Transmissor          08 - (54 a 61)
	Endif
	_cCodRec   := Space(8)             // Codigo Interno do Receptor             08 - (62 a 69)
	_cNomPasy  := _cNomPasy            // Nome do Transmissor                    25 - (70 a 94)
	_cNomCli   := _cNomCli             // Nome do Receptor                       25 - (95 a 119)
	_cEspaco   := Space(9)             // Espaço em branco                       09 - (120 a 128)
	
	_cCpo      := _cIdent + _cSeqv + _cDtHora + _cCgcPasy + _cCGCCli +_cCodTra + _cCodRec + _cNomPasy + _cNomCli + _cEspaco
	_cLin      := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiR++
	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif
Endif

_cLin     := Space(128)+_cEOL
_cNf      := STRZERO(val(SF2->F2_DOC),6)
_cSer     := SF2->F2_SERIE + SPACE(1)
_dDataNf  := GravaData(SF2->F2_EMISSAO,.f.,4)
_cVlTotal := StrZero(Int(SF2->F2_VALBRUT*100),17)
_nQtdCD   := "0"
_nSomaTot += SF2->F2_VALBRUT
_cVlICMS  := StrZero(Int(SF2->F2_VALICM*100),17)

dbSelectArea("SE1")
dbSetOrder(1)
If dbSeek(xFilial("SE1")+ SF2->F2_SERIE + SF2->F2_DOC + "NF ")
	_dVencto := GravaData(SE1->E1_VENCREA,.f.,4)
Endif

_cVlIPI   := StrZero(Int(SF2->F2_VALIPI*100),17)

dbSelectArea("SX5")
dbSetOrder(1)
If dbSeek(xFilial("SX5")+"13"+ _cCFO + sPace(1))
	_cDescCFO := SUBSTR(SX5->X5_DESCRI,1,15)
Endif

_dDtEmb   := GravaData(SF2->F2_EMISSAO,.f.,4)
_cHora    := Substr(SF2->F2_HORA,1,2)+ Substr(SF2->F2_HORA,4,2)

_cTpReg   := "AE1"                  // Tipo de Registro          03 - (01 a 03)
_cNf      := _cNf                   // Numero da Nota Fiscal     06 - (04 a 09)
_cSer     := _cSer                  // Serie  da Nota Fiscal     03 - (10 a 13)
_cDataNf  := _dDataNf               // Data   da Nota Fiscal     06 - (14 a 19)
_cQtdItem := _cQtdItem              // Quantidade de Item da NF  03 - (20 a 22)
_cVlTotal := _cVlTotal              // Valor Total da N.Fiscal   17 - (23 a 39)
_cQtdCd   := "0"                    // Qtde Casas Decimais       01 - (40 a 40)
_cCfo     := StrZero(Val(_cCfo),5)  // Codigo Fiscal de Operacao 05 - (41 a 45)
_cVlICMS  := _cVlICMS               // Valor total ICMS Aplicado 17 - (46 a 62)
_cVencto  := _dVencto               // Data do Vencimento        06 - (63 a 68)
_cEspecie := "01"                   // Especie da Nota Fiscal    02 - (69 a 70)
_cVLIPI   := _cVlIPI                // Valor Total do IPI        17 - (71 a 87)
_cCodFab  := Space(3)               // Codigo da Fabrica         03 - (88 a 90)
_cDtPrev  := "000000"               // Data Previsao Entrega     06 - (91 a 96)
_cPerEnt  := space(4)               // Periodo da Entrega        04 - (97 a 100)
_cDescCfo := _cDescCfo              // Descricao da Nat.Operacao 15 - (101 a 115)
_cDtEmb   := _dDtEmb                // Data do Embarque          06 - (116 a 121)
_cHora    := _cHora                 // Hora do Embarque          04 - (122 a 125)
_cEspaco  := Space(3)               // Espaco em Branco          03 - (126 a 128)

_cCpo    := _cTpReg + _cNf + _cSer + _cDataNF + _cQtdItem + _cVlTotal + _cQtdCD + _cCfo + _cVlICMS + _cVencto + _cEspecie + _cVlIPI + ;
_cCodFab + _cDtPrev + _cPerEnt + _cDescCFO + _cDtEmb + _cHora + _cEspaco

_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
_nContLiR++

If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE1).  Continua?","Atencao!")
		fClose(_nHdlR)
		Return
	Endif
Endif

// - NF2

_cTpReg   := "NF2"
_cDespAce := StrZero(Int(SF2->F2_DESPESA*100),12)
_cFrete   := StrZero(Int(SF2->F2_FRETE*100),12)
_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),12)
_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),12)
_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),12)
_cICMS    := StrZero(Int(SF2->F2_VALICM*100),12)

_cTpReg    := _cTpReg                         // Tipo de Registro           03 - (01 a 03)
_cDespAce  := _cDespAce                       // Valor Despesas Acessorias  12 - (04 a 15)
_cFrete    := _cFrete                         // Valor do Frete             12 - (16 a 27)
_cSeguro   := _cSeguro                        // Valor do Seguro            12 - (28 a 39)
_cDescon   := _cDescon                        // Valor do Desconto          12 - (40 a 51)
_cBaseICMS := _cBaseICMS                      // Base de Calculo do ICMS    12 - (52 a 63)
_cICMS     := _cICMS                          // Valor do ICMS              12 - (64 a 75)
_cZero     := "000000000000"                  // Numero,Data                06 - (76 a 87)
_cBranco   := Space(7)                        // Serie,Codigo da Fabrica    36 - (88 a 94)
_cCfo2     := StrZero(VaL(_cCFO),5)           // Codigo Fiscal Operacao     05 - (95 a 99)
_cBranco2  := Space(29)                       // Espaco em Branco           29 - (100 a 128)

_cCpo := _cTpReg+ _cDespAce + _cFrete + _cSeguro + _cDescon + _cBaseICMS + _cICMS + _cZero + _cBranco + _cCfo2 + _cBranco2

_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
_nContLiR++

If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
		fClose(_nHdlR)
		Return
	Endif
Endif

_cPedCli := ""
dbSelectArea("SD2")
dbOrderNickName("INDSD24")
If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	_cChavSD2 :=SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
	
	While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		
		_cLin    := Space(128) + _cEOL                         // Tipo de Registro             (3)  M
		_cItem   := "0"+ SD2->D2_ITEM                     // Numero do Item               (3)  M
		_cPedCli := Space(12)
		_cDest   :=	Space(03)
		dbSelectArea("SC6")
		dbSetOrder(1)
		If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
			_cPedCli := Substr(SC6->C6_PEDCLI,1,12)
			_cDest   := SC6->C6_LOCDEST
		Endif
		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+ SD2->D2_LOJA+ SD2->D2_COD + SD2->D2_PROCLI+"1")
			If Empty(_cPedCli)
				_cPedCli := Substr(SZ2->Z2_PEDCLI,1,12)               // Pedido de Compra do Cliente  (12) M
			Endif
			_cRev    := Substr(SZ2->Z2_REVISAO,1,4)
		Endif
		
		_cProdCli := SD2->D2_PROCLI + Space(15)                  // Codigo do Produto do Cliente (30) M
		_cQtde    := StrZero(Int(SD2->D2_QUANT),9)               // Qtde do Item                 (9)  M
		
		If Empty(_cProdCli)
			_cProdCli := "S/CODIGO"+ Space(22)
		Endif
		
		dbSelectArea("SAH")
		dbSetOrder(1)
		If dbSeek(xFilial("SAH")+ SD2->D2_UM)
			_cUm := "PC" //SAH->AH_CODANFA                                // Unidade de medida Anfavea    (2)  M
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SD2->D2_COD)
			_cClasFis := STRZERO(VAL(SB1->B1_POSIPI),10)           // Classificacao Fiscal  Produto (10) M
		Endif
		
		_cAliIPI := StrZero(Int(SD2->D2_IPI*100),4)               // Aliquota do IPI                (4)  M
		_cVlItem := StrZero(Int(SD2->D2_PRCVEN*100000),12)        // Valor do Item                  (12) M
		
		If Len(Alltrim(_cRev)) == 2
			_cRev := Space(2)+Alltrim(_cRev)
		Else
			_cRev := Substr(_cRev,1,4)
		Endif
		
		_cTpReg    := "AE2"                               // Tipo de Registro           03 - (01 a 03)
		_cItem     := _cItem                              // NUmero do Item da N.Fiscal 03 - (04 a 06)
		_cPedCli   := _cPedCli                            // NUmero do Pedido de Compra 12 - (07 a 18)
		_cProdCli  := _cProdCli                           // Codigo do Item             30 - (19 a 48)
		_cQtde     := _cQtde                              // Qtde do Item na Nota Fiscal09 - (49 a 57)
		_cUM       := _cUm                                // Unidade Medida             02 - (58 a 59)
		_cClasFis  := _cClasFis                           // Classificacao Fiscal       10 - (60 a 69)
		_cAliIPI   := _cAliIPi                            // Aliq. do IPI               04 - (70 a 73)
		_cVlItem   := _cVlItem                            // Valor do Item              12 - (74 a 85)
		_cQtde     := _cQtde                              // Qtde do Item em Estoque    09 - (86 a 94)
		_cUM       := _cUm                                // Unidade Medida Estoque     02 - (95 a 96)
		_cQtde     := _cQtde                              // Qtde do Unidade de Compra  09 - (97 a 105)
		_cUM       := _cUm                                // Unidade Medida de Compra   02 - (106 a 107)
		_cTpForn   := _cTpForn                            // Tipo de Fornecimento       01 - (108 a 108)
//		_cTpForn   := "P"                                 // Tipo de Fornecimento       01 - (108 a 108)
		_cPerDesc  := StrZero(Int(SD2->D2_DESC*100),4)    // Percentual de Desconto     04 - (109 a 112)
		_cValDesc  := StrZero(Int(SD2->D2_DESCON*100),11) // Valor do Desconto          11 - (113 a 123)
		_cRev      := _cRev                               // Alteracao Tecnica do Item  04 - (124 a 127)
		_cBranco   := Space(1)                            // Espaco em branco           01 - (128 a 128)
		
		_cCpo      := _cTpReg + _cItem + _cPedCli + _cProdCli + _cQtde + _cUM + _cClasFis + _cAliIPI + _cVlItem + _cQtde + _cUM + ;
		_cQtde     + _cUM + _cTpForn + _cPerDesc + _cValDesc + _cRev + _cBranco
		_cLin      := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		
		_nContLiR++
		
		If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE2). Continua?","Atencao!")
				fClose(_nHdlR)
				Return
			Endif
		Endif
		
		_cAliICMS  := StrZero(Int(SD2->D2_PICM   *100),4)           // Percentual ICMS                (4)  O
		_cBaseICMS := StrZero(Int(SD2->D2_BASEICM*100),17)          // Base ICMS                      (17) O
		_cVlICMS   := StrZero(Int(SD2->D2_VALICM *100),17)          // Valor do ICMS                  (17) O
		_cVlIPI    := StrZero(Int(SD2->D2_VALIPI *100),17)          // Valor do ICMS                  (17) O
		_cVlTotal  := StrZero(Int(SD2->D2_TOTAL  *100),12)          // Valor Total do Item            (12) M
		
		_cCpo      := "AE4"+ _cAliICMS + _cBaseICMS + _cVlICMS + _cVlIPI + "00" + sPace(30) +"000000"+space(13)+ space(6) + _cVlTotal +sPace(1)
		_cLin      := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		
		_nContLiR++
		
		If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE4). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif
		
		_cVlICMS   := StrZero(Int(SD2->D2_VALICM *100),12)          // Valor do ICMS                   (17) O
		_cCfo      := SD2->D2_CF                        // Codigo de Operaçao              (3)  M
		_cVlBaTrib := Repl("0",17)                                  // Valor Base do ICMS Tributario   (17) M
		_cVlICMTri := Repl("0",17)                                  // Valor do ICMS Tributario        (17) M
		_cQtdeEmb  := Repl("0",14)                                   // Quantidade Entregue             (9)  O
		_cCpo      := "AE7"+ _cVlICMS + STRZERO(VAL(_cCFO),5) + _cVlBaTrib + _cVlICMTRI + _cQtdeEmb + Space(60)
		_cLin      := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		
		_nContLiR++
		
		If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE7). Continua?","Atencao!")
				fClose(_nHdlR)
				Return
			Endif
		Endif
		
		_cNfOri    := STRZERO(val(SD2->D2_NFORI),6)                 // Nota Fiscal Original            (6)  M
		_cSerOri   := SD2->D2_SERIORI + space(1)                     // Serie Nota Fiscal Original      (4)  M
		
		dbSelectArea("SD1")
		dbSetOrder(4)
		If dbSeek(xFilial("SD2")+SD2->D2_IDENTB6)
			_cItemOri := STRZERO(val(SD1->D1_ITEM),3)                // Numero do Item Nota Fiscal Original (3)  M
			_cDtOri   := GravaData(SD1->D1_EMISSAO,.f.,4)            // Data Original                       (6)  M
		Endif
		
		_cCorrida := sPace(16)
		_cChassi  := Space(17)
		_cAutor   := Space(10)
		_cCpo     := "AE8" + _cNfOri + _cSerOri + _cDtOri + _cItemOri + _cCorrida + _cChassi + _cAutor + space(63)
		_cLin     := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		
		_nContLiR++
		
		If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE8). Continua?","Atencao!")
				fClose(_nHdlR)
				Return
			Endif
		Endif
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif

_cZeros    := Repl('0',28)
_cLocEnt   := ""

If _lAGCO
	If SF2->F2_LOJA == "01"
		_cLocEnt := "CAN"
	ElseIf SF2->F2_LOJA == "02"
		_cLocEnt := "SRO"
	ElseIf SF2->F2_LOJA == "03"
		_cLocEnt := "SUM"
	Endif
ElseIf _lVALTRA
	_cLocEnt := _cDest
//	_cLocEnt := "MOG"
ElseIf _lCNH
	_cLocEnt := _cCGCCli
Endif

_cLocEnt := _cLocEnt +Space(11)
_cCpo    := "AE3"+ _cZeros + _cLocEnt + Space(83)
_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

_nContLiV++

If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE3). Continua?","Atencao!")
		fClose(_nHdlV)
		Return
	Endif
Endif

Return
