#INCLUDE "PROTHEUS.CH"
//#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
Descrição: Modelo 2 (Romaneio Expedição e envio de ASN)
Data: 21/03/12
*/

User Function CR0014()

	Private aRotina := {}
	Private cCadastro := "Transações"
	Private _cCATFold	:= GetMV("CR_CATFOLD")
	Private _cIVEFold	:= GetMV("CR_IVEFOLD")

	AAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
	AAdd(aRotina, {"Visualizar", "U_CR014A", 0, 2})
	AAdd(aRotina, {"Incluir"   , "U_CR014A", 0, 3})
	AAdd(aRotina, {"Alterar"   , "U_CR014A", 0, 4})
	AAdd(aRotina, {"Excluir"   , "U_CR014A", 0, 5})
	AAdd(aRotina, {"Imprimir"  , "U_CR014A", 0, 6})

	dbSelectArea("SZJ")
	dbGoTop()

	mBrowse(,,,,"SZJ")

Return (Nil)


User Function CR014A(cAlias, nReg, nOpc)

	Local cChave := ""
	Local nLin
	Local i      := 0
	Local lRet   := .F.

	Private cT       := "Romaneio - Expedição"   // Titulo.
	Private aC       := {}                       // Campos do Enchoice.
	Private aR       := {}                       // Campos do Rodape.
	Private aCGD     := {}                       // Coordenadas do objeto GetDados.
	Private cLinOK   := ""                       // Funcao para validacao de uma linha da GetDados.
	Private cAllOK   := "U_CR014B()"             // Funcao para validacao de tudo.
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
	AAdd(aC, { "M->ZJ_DTSAIDA" 	, {15, 62 }, "Data"  														, "99/99/99"	,                   ,      , 		   })
	AAdd(aC, { "M->ZJ_HORASAI" 	, {15, 124}, "Hora"  														, "99:99"		,                   ,      ,  		   })
	AAdd(aC, { "M->ZJ_CODRESP"  , {15, 166}, "Responsável"  												, "@!"      	, "U_CR014F()"      ,"SZK" , (nOpc==3) })
	AAdd(aC, { "M->ZJ_NOMRESP"  , {15, 240}, "Nome"  														, "@!"      	,                   ,      , .F.	   })

	AAdd(aR, { "M->ZJ_TPTRANS"  , {30, 05}, "Transporte (1=Proprio;2=Transp)"					 			, "@!" 		,"U_CR014H()"		,      , 			})
	AAdd(aR, { "M->ZJ_CODTRAN"	, {30,120}, "Cód. Transp."											 		, "@!" 		,"U_CR014G()"		, "SA4",   			})
	AAdd(aR, { "M->ZJ_NOMETRA" 	, {30,210}, "Nome Transp."									 				, "@!" 		,                   ,      , .F.    	})
	AAdd(aR, { "M->ZJ_MOTORIS"  , {45,005}, "Motorista"  			 										, "@!" 		,  					,      ,   			})
	AAdd(aR, { "M->ZJ_VEICULO"  , {45,150}, "Veículo"  			 											, "@!" 		,  					,      ,   			})
	AAdd(aR, { "M->ZJ_PLACA"  	, {45,300}, "Placa"  			 											, "@! AAA-9999",  				,      ,   			})
	AAdd(aR, { "M->ZJ_CONDVEI"  , {60,005}, "Est. Veículo (1=Conforme; 2= Não Conforme)" 					, "@!" 		,"PERTENCE('12')"	,      ,   			})
	AAdd(aR, { "M->ZJ_QPROXNF"  , {60,190}, "Cód. Prod. X Cód. Regist. NF (1=Conforme; 2= Não Conforme)"	, "@!" 		,"PERTENCE('12')"	,      ,   			})
	AAdd(aR, { "M->ZJ_ACONDIC"  , {75,005}, "Acondicionamento (1=Conforme; 2= Não Conforme)" 				, "@!" 		,"PERTENCE('12')"	,      ,   			})
	AAdd(aR, { "M->ZJ_QEMXFAT"  , {75,181}, "Qtde. Embarcada X Qtde. Fatur. (1=Conforme; 2= Não Conforme)" 	, "@!" 		,"PERTENCE('12')"	,      ,   			})

	//	aCGD := {40,10,30,10}
	aCGD:={44,5,118,315} // aCGD:={10,04,15,73}
	_aPos := {0,0,500,1000}

	// Validacao na mudanca de linha quando clicar no botao OK.
	cLinOK := ".T."

	cTitulo := "Romaneio - Expedição"

	lRet := Modelo2(cTitulo, aC, aR, aCGD, nOpc, cLinOK, cAllOK, , , cIniCpos, nMax,_aPos,,.T.)

	If lRet  // Confirmou (.T.)  Nao confirmou (.F.)

		If nOpc == 3    // Inclusao
			If MsgYesNo("Confirma a gravacao dos dados?", cTitulo)
				Processa({||CR014C(cAlias)}, cTitulo, "Gravando os dados, aguarde...")
			EndIf
		ElseIf nOpc == 4    // Alteracao
			If MsgYesNo("Confirma a alteracao dos dados?", cTitulo)
				Processa({||CR014D(cAlias)}, cTitulo, "Alterando os dados, aguarde...")
			EndIf
		ElseIf nOpc == 5    // Exclusao
			If MsgYesNo("Confirma a exclusao dos dados?", cTitulo)
				Processa({||CR014E(cAlias)}, cTitulo, "Excluindo os dados, aguarde...")
			EndIf
		EndIf

	Else

		RollBackSX8()

	EndIf

Return (Nil)


Static Function CR014C(cAlias)

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

				_lASN := .T.
				If SF2->F2_CLIENTE $ "000017|000021"
					If !Empty(SF2->F2_ASN)

						If MsgNoYes('ASN já enviada, deseja reenviar?')
							_lASN := .T.
						Else
							_lASN := .F.
						Endif

					Endif
				Endif

				If _lASN .And. SF2->F2_CLIENTE $ "000017|000021"

					RecLock("SF2", .F.)
					SF2->F2_ASN := Dtoc(DDataBase) + ' - ' + Time()
					MSUnlock()

					ASN(_cNF1,_cSerie) // Envia ASN
				Endif

			Endif

		EndIf

	Next i

	ConfirmSX8()

Return Nil


Static Function CR014D(cAlias) // Alterando dados

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

					_lASN := .T.
					If SF2->F2_CLIENTE $ "000017|000021"
						If !Empty(SF2->F2_ASN)

							If MsgNoYes('ASN já enviada, deseja reenviar?')
								_lASN := .T.
							Else
								_lASN := .F.
							Endif

						Endif
					Endif

					If _lASN .And. SF2->F2_CLIENTE $ "000017|000021"

						RecLock("SF2", .F.)
						SF2->F2_ASN := Dtoc(DDataBase) + ' - ' + Time()
						MSUnlock()

						ASN(_cNF1,_cSerie) // Envia ASN

					Endif

				Endif
			EndIf
		EndIf

	Next

Return (Nil)


Static Function CR014E(cAlias) //EXCLUIR

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
			//			SF2->F2_ASN    := CTOD("  /  /  ")
			MSUnlock()
		Endif

		RecLock(cAlias, .F.)
		dbDelete()
		MSUnlock()

		dbSelectArea("SZJ")
		dbSkip()

	EndDo

Return Nil


User Function CR014B()

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


User Function CR014F()

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


User Function CR014G()

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


User Function CR014H()

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


User Function CR014I()

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

	_aAliori := GetArea()
	_aAliSD2 := SD2->(GetArea())
	_aAliSF4 := SF4->(GetArea())
	_aAliSX6 := SX6->(GetArea())
	_aAliSA1 := SA1->(GetArea())
	_aAliSE1 := SE1->(GetArea())
	_aAliSX5 := SX5->(GetArea())
	_aAliSZ2 := SZ2->(GetArea())
	_aAliSAH := SAH->(GetArea())
	_aAliSC6 := SC6->(GetArea())
	_aAliSB1 := SB1->(GetArea())

	Private _cEOL    := "CHR(13)+CHR(10)"

	If Empty(_cEOL)
		_cEOL := CHR(13)+CHR(10)
	Else
		_cEOL := Trim(_cEOL)
		_cEOL := &_cEOL
	Endif

	_cLin    := Space(128) + _cEOL

	Private _cLin, _cCpo, _cCGCCron,_cCGCCli,_cUM, _cIdenti,_cTpForn,_cIdent
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
	Private _cPO        := Space(4)

	_lAchouV   := .F.
	_lAchouR   := .F.
	_nContLiV  := 0
	_nContLiR  := 0
	_nSomaTot  := 0

	_lEncontV  := .t.
	_lEncontR  := .t.

	dbSelectArea("SD2")
	dbOrderNickName("INDSD24")
	If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

		_cChavSD2    := SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		_nQtdItem    := _nQtdRetI := 0
		_lRetorno    := .F.
		_lVenda      := .F.
		While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

			_cCfo  := SD2->D2_CF                           // Codigo de Operaçao           (5) M

			If SD2->D2_TIPO == "D"
				_lRetorno := .T.
				_lAchouR  := .T.
				_nQtdRetI ++
			Else
				_cPO   := SD2->D2_PEDCLI                        // PO           (4) M

				dbSelectArea("SF4")
				dbSetOrder(1)
				If dbSeek(xFilial("SF4")+SD2->D2_TES)
					If SF4->F4_PODER3 == "D"
						_lRetorno := .T.
						_lAchouR  := .T.
						_nQtdRetI ++
					Else
						_lVenda  := .T.
						_lAchouV := .T.
						_nQtdItem ++
					Endif
				Endif
			Endif

			dbSelectArea("SD2")
			dbSkip()
		EndDo
	Endif
	If _nQtdItem > 0
		_cQtdItem    := strZero(_nQtdItem,3)                             // Qtde de itens a N.F.         (3) M
	ElseIf _nQtdRetI > 0
		_cQtdItem    := strZero(_nQtdRetI,3)                             // Qtde de itens a N.F.         (3) M
	Endif

	If _lVenda
		// Notas Fiscais de Venda

		Private _cCgc2    := SM0->M0_CGC
		Private _cData2   := GravaData(dDataBase,.f.,8)

		_NN:= 0
		For ZZ:= 1 to 100
			_NN++
		Next ZZ

		Private _cHora2   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

		If SF2->F2_CLIENTE == '000017'
			Private _cArqTxtV := _cCATFold+"Brasil\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
		ElseIf SF2->F2_CLIENTE == '000021'
			Private _cArqTxtV := _cIVEFold+"SAIDA\EMBARQUE\RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
		Endif

		Private _nHdlV    := MSFCreate(_cArqTxtV)

		If _nHdlV == -1
			MsgAlert("O arquivo de nome "+_cArqTxtV+" nao pode ser executado!","Atencao!")
			fClose(_nHdlV)
			Return
		Endif

		GeraVenda()

		If _lAchouV
			_nContLiV++
			_cContLI  := StrZero(_nContLiV,9)                           // Numero de Controle             (9)  M
			_cSomaTot := StrZero(Int(_nSomaTot *100),17)               // Soma Total das N.Fiscais       (12) M
			_cCpo := "FTP"+ _cSeqv + _cContLi + _cSomaTot + "D" + sPace(93)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FTP). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
		Endif

		fClose(_nHdlV)

		_cFile := ''
		If SF2->F2_CLIENTE == '000017'
			__CopyFile(_cCATFold+"BRASIL\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT", _cCATFold+"Brasil\SAIDA\BKP\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT")
			_cFile := "61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
		ElseIf SF2->F2_CLIENTE == '000021'
			__CopyFile(_cIVEFold+"SAIDA\EMBARQUE\RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT", _cIVEFold+"SAIDA\EMBARQUE\BKP\RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT")
			_cFile := "RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
		Endif



		SZ0->(dbsetOrder(1))
		If !SZ0->(msSeek(xFilial("SZ0")+SF2->F2_DOC+SF2->F2_SERIE))
			_cSeq := "001"
		Else
			_cKey := xFilial("SZ0")+SF2->F2_DOC+SF2->F2_SERIE

			While !SZ0->(EOF()) .And. _cKey == SZ0->Z0_FILIAL+SZ0->Z0_DOC+SZ0->Z0_SERIE

				_cSeq := Soma1(SZ0->Z0_SEQUENC)

				SZ0->(dbSkip())
			EndDo
		Endif

		_aCampos := {}
		aAdd( _aCampos, { 'Z0_DOC'		, SF2->F2_DOC     	} )
		aAdd( _aCampos, { 'Z0_SERIE'  	, SF2->F2_SERIE		} )
		aAdd( _aCampos, { 'Z0_SEQUENC' 	, _cSeq				} )
		aAdd( _aCampos, { 'Z0_DATA'  	, dDataBase	 		} )
		aAdd( _aCampos, { 'Z0_TIPO'  	, '004'       	   	} )
		aAdd( _aCampos, { 'Z0_TIPO2'  	, 'U'				} )
		aAdd( _aCampos, { 'Z0_CLIENTE'  , SF2->F2_CLIENTE   } )
		aAdd( _aCampos, { 'Z0_LOJA'  	, SF2->F2_LOJA     	} )
		aAdd( _aCampos, { 'Z0_FILE'  	, _cFile     		} )

		//Grava na tabela SZ0
		U_CR0070( 'SZ0', _aCampos,'CR0096' )

	Else
		// - Notas Fiscais de Retorno

		Private _cCgc2    := SM0->M0_CGC
		Private _cData2   := GravaData(dDataBase,.f.,8)
		Private _cHora2   := Substr(Time(),1,2) + Substr(Time(),4,2) + strzero(Val(Substr(Time(),7,2))+1,2)

		If SF2->F2_CLIENTE == '000017'
			Private _cArqTxtR := _cCATFold+"BRASIL\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
		ElseIf SF2->F2_CLIENTE == '000021'
			Private _cArqTxtR := _cIVEFold+"SAIDA\EMBARQUE\RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
		Endif

		Private _nHdlR    := MSfCreate(_cArqTxtR)

		If _nHdlR == -1
			MsgAlert("O arquivo de nome "+_cArqTxtR+" 2 nao pode ser executado!","Atencao!")
			fClose(_nHdlR)
			Return
		Endif

		GeraRet()

		If _lAchouR
			_nContLiR++
			_cContLI  := StrZero(_nContLiR,9)                           // Numero de Controle             (9)  M
			_cSomaTot := StrZero(Int(_nSomaTot *100),17)               // Soma Total das N.Fiscais       (12) M
			_cCpo := "FTP"+ _cSeqR + _cContLi + _cSomaTot + "D" + sPace(93)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

			If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FTP). Continua?","Atencao!")
					fClose(_nHdlR)
					Return
				Endif
			Endif
		Endif

		fClose(_nHdlR)
	Endif

	RestArea(_aAliSD2)
	RestArea(_aAliSF4)
	RestArea(_aAliSX6)
	RestArea(_aAliSA1)
	RestArea(_aAliSE1)
	RestArea(_aAliSX5)
	RestArea(_aAliSZ2)
	RestArea(_aAliSAH)
	RestArea(_aAliSB1)
	RestArea(_aAliSC6)
	RestArea(_aAliori)

Return


Static Function GeraVenda()

	If _lEncontV
		_lEncontV := .F.
		_cLin    := Space(128) + _cEOL
		If SF2->F2_CLIENTE = '000017'
			_cSeqv    := GetMv("MV_NUMCAT")
			_cVerItp  := "ITP00418"
			_cCodInt  := "Q3820C0 "
		ElseIf SF2->F2_CLIENTE = '000021'
			_cSeqv    := GetMv("CR_NUMIVE")
			_cVerItp  := "ITP00415"
			_cCodInt  := "28546   "
		Endif

		dbSelectArea("SX6")
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := StrZero((Val(_cSeqv)+1),5)
		MsUnlock()

		_dData := GravaData(dDataBase,.f.,4)
		_cHora := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
		_cCgcCron  := SM0->M0_CGC
		_cNomCron  := Substr(SM0->M0_NOMECOM,1,25)

		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
			_cCGCCli  := SA1->A1_CGC
			_cNomCli  := Substr(SA1->A1_NOME,1,25)
		Endif

		_cCodCli := Space(8) //SF2->F2_CLIENTE+SF2->F2_LOJA
		//                              (5)     (6)      (6)      (14)        (14)         (8)         (8)         (25)        (25)
		_cCpo    := _cVerItp + _cSeqv + _dData + _cHora + _cCgcCron + _cCGCCli + _cCodInt  + _cCodCli + _cNomCron + _cNomCli + space(9)
		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		_nContLiV++
		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif
	Endif

	_cLin     := Space(128)+_cEOL
	_cNf      := STRZERO(val(SF2->F2_DOC),6)                            // Numero da nota Fiscal        (6) M
	_cSer     := SF2->F2_SERIE + SPACE(1)                            	// Serie da Nota Fiscal         (4) M
	_dDataNf  := GravaData(SF2->F2_EMISSAO,.f.,4)                   	// Data De Emissao da N.F.      (6) M
	_cVlTotal := StrZero(Int(SF2->F2_VALBRUT*100),17)                	// Valor Total                  (17)M
	_nQtdCD   := If(SF2->F2_CLIENTE == '000021',"3","0")             	// Quantidade de Casas Decimais (1) M
	//	_nQtdCD   := "0"                                                 	// Quantidade de Casas Decimais (1) M
	_nSomaTot += SF2->F2_VALBRUT
	_cVlICMS  := StrZero(Int(SF2->F2_VALICM*100),17)                 	// Valor Total do ICMS          (17)M

	SE1->(dbSetOrder(1))
	If SE1->(dbSeek(xFilial("SE1")+ SF2->F2_SERIE + SF2->F2_DOC + Space(3)+"NF "))
		_dVencto := GravaData(SE1->E1_VENCREA,.f.,4)                 	// Data do Vencimento           (6) M
	Endif

	_cEspecie := "02" //Substr(SF2->F2_ESPECIE,1,2)                 	// Especie                      (2) M
	_cVlIPI   := StrZero(Int(SF2->F2_VALIPI*100),17)                 	// Valor Total do IPI           (17)M

	If Left(_cPO,4) = 'QAPC'
		_cCodFab  := "010"                                          		// Codigo da Fabrica Destino    (3) O
	ElseIf Left(_cPO,4) = 'QEST'
		_cCodFab  := "081"                                          		// Codigo da Fabrica Destino    (3) O
	ElseIf Left(_cPO,4) = 'HETZ'
		_cCodFab  := "081"                                          		// Codigo da Fabrica Destino    (3) O
	Else
		_cCodFab  := "028"                                          		// Codigo da Fabrica Destino    (3) O
	Endif

	If SF2->F2_LOJA = '03'
		_cCodFab  := "050"                                          		// Codigo da Fabrica Destino    (3) O
	Endif

	If SF2->F2_CLIENTE = '000021'
		_cCodFab := "1  "
	Endif

	_cPerEnt  := space(4)                                            	// Periodo da Entrega           (4) O

	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+"13"+ _cCFO + sPace(1))
		_cDescCFO := SUBSTR(SX5->X5_DESCRI,1,15)                      	// Descricao do CFOP            (15)O
	Endif

	_dDtPrev  := GravaData(dDataBase,.f.,4)
	//	_dDtPrev  := GravaData(SF2->F2_EMISSAO,.f.,4)                   	// Data Do Embarque             (6) M
	_cHora    := Substr(SF2->F2_HORA,1,2)+ Substr(SF2->F2_HORA,4,2)  	// Hora / Minuto do Embarque    (4) M

	_cCpo    := "AE1" + _cNf + _cSer + _dDataNF + _cQtdItem + _cVlTotal + _nQtdCD + STRZERO(VAL(_cCFO),5) + _cVlICMS + _dVencto + _cEspecie + _cVlIPI + ;
	_cCodFab + _dDtPrev + _cPerEnt + _cDescCFO + _dDtPrev + _cHora + SPACE(3)

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

	_nContLiV++

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE1).  Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif

	// - NF2

	_cDespAce := StrZero(Int(SF2->F2_DESPESA*100),12)             // Valor das Despesas Acessoriais  (12)  O
	_cFrete   := StrZero(Int(SF2->F2_FRETE*100),12)               // Valor do Frete                  (12)  O
	_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),12)              // Valor do Seguro                 (12)  O
	_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),12)             // Valor do Desconto da N.F.       (12)  O
	_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),12)             // Valor do Desconto da N.F.       (12)  O
	_cICMS    := StrZero(Int(SF2->F2_VALICM*100),12)              // Valor do Desconto da N.F.       (12)  O
	_cNumero  := "000000" //SF2->F2_DOC                           // NUmero da N.Fiscal de Venda     (6)   O
	_cDtEmis  := "000000" //GravaData(SF2->F2_EMISSAO,.f.,4)      // Data de Emissao                 (6)   O
	_cSerie   := space(4) //SF2->F2_SERIE+" "                     // Serie da N.Fiscal               (4)   O
	_cCodFab  := space(3)

	_cCpo := "NF2"+ _cDespAce + _cFrete + _cSeguro + _cDescon + _cBaseICMS + _cICMS + _cNumero + _cDtEmis + _cSerie + _cCodFab + STRZERO(VAL(_cCFO),5) + space(29)

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiV++

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif


	// - NF5

	_cAliIRRF:= Repl("0",4)                                       // Aliquota do IRRF                (17)  O
	_cBaseIRRF:= Repl("0",17)                                     // Valor Base IRRF                 (17)  O
	_cIRRF    := Repl("0",17)                                     // Valor Base IRRF                 (17)  O
	_cAliISS  := Repl("0",4)                                      // Aliquota Do ISS                 (17)  O
	_cBaseISS := StrZero(Int(SF2->F2_BASEISS*100),17)             // Valor Base ISS                  (17)  O
	_cISS     := StrZero(Int(SF2->F2_VALISS*100),17)              // Valor ISS                       (17)  O
	_cBaseINSS:= StrZero(Int(SF2->F2_BASEINS*100),17)             // Valor Base INSS                  (17)  O
	_cINSS    := StrZero(Int(SF2->F2_VALINSS*100),17)             // Valor INSS                       (17)  O

	_cFrete   := StrZero(Int(SF2->F2_FRETE*100),17)               // Valor do Frete                  (17)  O
	_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),17)              // Valor do Seguro                 (17)  O
	_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),17)             // Valor do Desconto da N.F.       (17)  O
	_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),17)             // Valor do Desconto da N.F.       (17)  O
	_cNumero  := SF2->F2_DOC                                      // NUmero da N.Fiscal de Venda     (6)   O
	_dDtEmis  := GravaData(SF2->F2_EMISSAO,.f.,4)                 // Data de Emissao                 (6)   O
	_cSerie   := SF2->F2_SERIE+" "                                // Serie da N.Fiscal               (4)   O
	_cCodFab  := space(3)

	_cCpo     := "NF5"+ STRZERO(VAL(_cCFO),5) + Space(5) + _cAliIRRF + _cBaseIRRF + _cIRRF + _cAliISS + _cBaseISS  + _cISS + _cBaseINSS + _cINSS + space(5)

	_cLin     := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
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

		While !SD2->(Eof()) .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

			If Left(SD2->D2_COD,2) = 'MD'
				SD2->(dbSkip())
				Loop
			Endif

			_cLin   := Space(128) + _cEOL                         // Tipo de Registro             (3)  M
			_cItem  := "0"+ SD2->D2_ITEM                          // Numero do Item               (3)  M

			_cPedCli  := Space(12)
			_cDest   := space(03)
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD)
				_cPedCli := Substr(SC6->C6_PEDCLI,1,12)           // Pedido de Compra do Cliente  (12) M
				_cDest   := SC6->C6_LOCDEST
			Endif

			dbSelectArea("SZ2")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+ SD2->D2_LOJA+ SD2->D2_COD + SD2->D2_PROCLI+"1")
				If Empty(_cPedCli)
					_cPedCli := Substr(SZ2->Z2_PEDCLI,1,12)           // Pedido de Compra do Cliente  (12) M
				Endif
				_cRev    := ALLTRIM(SZ2->Z2_REVISAO)
				_cUm     := SZ2->Z2_UM
			Endif

			_cProdCli := SD2->D2_PROCLI + Space(15)               // Codigo do Produto do Cliente (30) M
			If Empty(_cProdCli)
				_cProdCli := "S/CODIGO"+ Space(22)
			Endif

			_cQtde    := StrZero(Int(SD2->D2_QUANT),9)            // Qtde do Item                 (9)  M

			If Empty(_cUm)
				dbSelectArea("SAH")
				dbSetOrder(1)
				If dbSeek(xFilial("SAH")+ SD2->D2_UM)
					_cUm := SAH->AH_CODANFA                           // Unidade de medida Anfavea    (2)  M
				Endif
			Endif

			_cUm := If(SF2->F2_CLIENTE == '000021',SD2->D2_UM,_cUm)             	// Quantidade de Casas Decimais (1) M

			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SD2->D2_COD)
				_cClasFis := STRZERO(VAL(SB1->B1_POSIPI),10)      // Classificacao Fiscal  Produto (10) M
			Endif

			_cAliIPI  := StrZero(Int(SD2->D2_IPI*100),4)           // Aliquota do IPI                (4)  M
			_cVlItem  := StrZero(Int(SD2->D2_PRCVEN*100000),12)    // Valor do Item                  (12) M

			//			_cTpForn  := "P"

			If Left(_cPedCli,4) = "HETZ"
				_cTpForn  := "R"
			Else
				_cTpForn  := "P"
			Endif

			_cPerDesc := StrZero(Int(SD2->D2_DESC*100),4)         // Percentual de Desconto         (4)  O
			_cValDesc := StrZero(Int(SD2->D2_DESCON*100),11)      // Valor do Desconto              (13) O

			If Len(_cRev) == 2                                    // Alteraçao Técnica do Item      (4)
				_cRev := Space(2)+_cRev
			Else
				_cRev := Substr(_cRev,1,4)
			Endif
			//                                                                                                          86       95
			_cCpo := "AE2"+ _cItem + _cPedCli + _cProdCli + _cQtde + _cUM + _cClasFis + _cAliIPI + _cVlItem + _cQtde + _cUM + ;
			_cQtde + _cUM + _cTpForn + _cPerDesc + _cValDesc + _cRev + space(1)


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

			_cCpo := "AE4"+ _cAliICMS + _cBaseICMS + _cVlICMS + _cVlIPI + "00" + sPace(30) +"000000"+space(13)+ space(6) + _cVlTotal +sPace(1)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++

			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE4). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif

			SD2->(dbSkip())
		EndDo
	Endif

Return



Static Function GeraRet()

	If _lEncontR
		_lEncontR := .F.
		_cLin    := Space(128) + _cEOL

		If SF2->F2_CLIENTE = '000017'
			_cSeqv    := GetMv("MV_NUMCAT")
			_cVerItp  := "ITP00418"
			_cCodInt  := "Q3820C0 "
		ElseIf SF2->F2_CLIENTE = '000021'
			_cSeqv    := GetMv("CR_NUMIVE")
			_cVerItp  := "ITP00415"
			_cCodInt  := "28546   "
		Endif

		dbSelectArea("SX6")
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := StrZero((Val(_cSeqR)+1),5)
		MsUnlock()

		_dData := GravaData(dDataBase,.f.,4)
		_cHora := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
		_cCgcCron  := SM0->M0_CGC
		_cNomCron  := Substr(SM0->M0_NOMECOM,1,25)

		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
			_cCGCCli  := SA1->A1_CGC
			_cNomCli  := Substr(SA1->A1_NOME,1,25)
		Endif

		_cCodCli := Space(8) //SF2->F2_CLIENTE+SF2->F2_LOJA
		//                              (5)     (6)      (6)      (14)        (14)         (8)         (8)         (25)        (25)
		_cCpo    := _cVerItp + _cSeqv + _dData + _cHora + _cCgcCron + _cCGCCli + _cCodInt  + _cCodCli + _cNomCron + _cNomCli + space(9)
		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		_nContLiR++
		If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlR)
				Return
			Endif
		Endif
	Endif

	_cLin     := Space(128)+_cEOL
	_cNf      := STRZERO(val(SF2->F2_DOC),6)                                   // Numero da nota Fiscal        (6) M
	_cSer     := SF2->F2_SERIE + SPACE(1)                            // Serie da Nota Fiscal         (4) M
	_dDataNf  := GravaData(SF2->F2_EMISSAO,.f.,4)                   // Data De Emissao da N.F.      (6) M
	_cVlTotal := StrZero(Int(SF2->F2_VALBRUT*100),17)                // Valor Total                  (17)M
	_nQtdCD   := If(SF2->F2_CLIENTE == '000021',"3","0")             	// Quantidade de Casas Decimais (1) M
	//	_nQtdCD   := "0"                                                 // Quantidade de Casas Decimais (1) M
	_nSomaTot += SF2->F2_VALBRUT
	_cVlICMS  := StrZero(Int(SF2->F2_VALICM*100),17)                 // Valor Total do ICMS          (17)M

	SE1->(dbSetOrder(1))
	If SE1->(dbSeek(xFilial("SE1")+ SF2->F2_SERIE + SF2->F2_DOC + Space(3)+"NF "))
		_dVencto := GravaData(SE1->E1_VENCREA,.f.,4)                 // Data do Vencimento           (6) M
	Endif

	_cEspecie := "01" //Substr(SF2->F2_ESPECIE,1,2)                         // Especie                      (2) M
	_cVlIPI   := StrZero(Int(SF2->F2_VALIPI*100),17)                 // Valor Total do IPI           (17)M

	_cCodFab  := "028"                                          		// Codigo da Fabrica Destino    (3) O

	If SF2->F2_CLIENTE = '000021'
		_cCodFab := "1  "
	Endif

	_dDtPrev  := GravaData(SF2->F2_EMISSAO,.f.,4)                   // Data De Previsao de Entrega  (6) O
	_cPerEnt  := space(4)                                            // Periodo da Entrega           (4) O

	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+"13"+ _cCFO + sPace(1))
		_cDescCFO := SUBSTR(SX5->X5_DESCRI,1,15)                      // Descricao do CFOP            (15)O
	Endif

	_dDtPrev  := GravaData(SF2->F2_EMISSAO,.f.,4)                   // Data Do Embarque             (6) M
	_cHora    := Substr(SF2->F2_HORA,1,2)+ Substr(SF2->F2_HORA,4,2)  // Hora / Minuto do Embarque    (4) M

	_cCpo    := "AE1" + _cNf + _cSer + _dDataNF + _cQtdItem + _cVlTotal + _nQtdCD + STRZERO(VAL(_cCFO),5) + _cVlICMS + _dVencto + _cEspecie + _cVlIPI + ;
	_cCodFab +  _dDtPrev + _cPerEnt + _cDescCFO + _dDtPrev + _cHora + SPACE(3)
	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiR++

	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE1).  Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif

	// - NF2

	_cDespAce := StrZero(Int(SF2->F2_DESPESA*100),12)             // Valor das Despesas Acessoriais  (12)  O
	_cFrete   := StrZero(Int(SF2->F2_FRETE*100),12)               // Valor do Frete                  (12)  O
	_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),12)              // Valor do Seguro                 (12)  O
	_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),12)             // Valor do Desconto da N.F.       (12)  O
	_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),12)             // Valor do Desconto da N.F.       (12)  O
	_cICMS    := StrZero(Int(SF2->F2_VALICM*100),12)             // Valor do Desconto da N.F.       (12)  O
	_cNumero  := "000000" //SF2->F2_DOC                                      // NUmero da N.Fiscal de Venda     (6)   O
	_cDtEmis  := "000000" //GravaData(SF2->F2_EMISSAO,.f.,4)                 // Data de Emissao                 (6)   O
	_cSerie   := space(4) //SF2->F2_SERIE+" "                                // Serie da N.Fiscal               (4)   O
	_cCodFab  := space(3)

	_cCpo := "NF2"+ _cDespAce + _cFrete + _cSeguro + _cDescon + _cBaseICMS + _cICMS + _cNumero + _cDtEmis + _cSerie + _cCodFab + STRZERO(VAL(_cCFO),5) + space(29)

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiR++

	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif

	// - NF5

	_cAliIRRF:= Repl("0",4)                                     // Aliquota do IRRF                (17)  O
	_cBaseIRRF:= Repl("0",17)                                     // Valor Base IRRF                 (17)  O
	_cIRRF    := Repl("0",17)                                     // Valor Base IRRF                 (17)  O
	_cAliISS  := Repl("0",4)                                     // Aliquota Do ISS                 (17)  O
	_cBaseISS := StrZero(Int(SF2->F2_BASEISS*100),17)             // Valor Base ISS                  (17)  O
	_cISS     := StrZero(Int(SF2->F2_VALISS*100),17)              // Valor ISS                       (17)  O
	_cBaseINSS:= StrZero(Int(SF2->F2_BASEINS*100),17)             // Valor Base INSS                  (17)  O
	_cINSS    := StrZero(Int(SF2->F2_VALINSS*100),17)              // Valor INSS                       (17)  O

	_cFrete   := StrZero(Int(SF2->F2_FRETE*100),17)               // Valor do Frete                  (17)  O
	_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),17)              // Valor do Seguro                 (17)  O
	_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),17)             // Valor do Desconto da N.F.       (17)  O
	_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),17)             // Valor do Desconto da N.F.       (17)  O
	_cNumero  := SF2->F2_DOC                                      // NUmero da N.Fiscal de Venda     (6)   O
	_dDtEmis  := GravaData(SF2->F2_EMISSAO,.f.,4)                 // Data de Emissao                 (6)   O
	_cSerie   := SF2->F2_SERIE+" "                                // Serie da N.Fiscal               (4)   O
	_cCodFab  := space(3)

	_cCpo := "NF5"+ STRZERO(VAL(_cCFO),5) + Space(5) + _cAliIRRF + _cBaseIRRF + _cIRRF + _cAliISS + _cBaseISS  + _cISS + _cBaseINSS + _cINSS + space(5)

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiR++

	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif

	_cPedCli := Space(12)

	dbSelectArea("SD2")
	dbOrderNickName("INDSD24")
	If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		_cChavSD2 :=SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

		While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

			_cLin    := Space(128) + _cEOL                         // Tipo de Registro             (3)  M
			_cItem   := "0"+ SD2->D2_ITEM                     // Numero do Item               (3)  M
			_cPedCli := Space(12)
			_cDest   := space(03)
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD)
				_cPedCli := Substr(SC6->C6_PEDCLI,1,12)           // Pedido de Compra do Cliente  (12) M
				_cDest   := SC6->C6_LOCDEST
			Endif

			_cUm :=  Space(2)

			dbSelectArea("SZ2")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+ SD2->D2_LOJA+ SD2->D2_COD + SD2->D2_PROCLI+"1")
				If Empty(_cPedcli)
					_cPedCli := Substr(SZ2->Z2_PEDCLI,1,12)               // Pedido de Compra do Cliente  (12) M
				Endif
				_cRev    := Substr(SZ2->Z2_REVISAO,1,4)
				_cUm     := SZ2->Z2_UM
			Endif

			_cProdCli := SD2->D2_PROCLI + Space(15)                  // Codigo do Produto do Cliente (30) M
			_cQtde    := StrZero(Int(SD2->D2_QUANT),9)               // Qtde do Item                 (9)  M

			If Empty(_cProdCli)
				_cProdCli := "S/CODIGO"+ Space(22)
			Endif

			If Empty(_cUm)
				dbSelectArea("SAH")
				dbSetOrder(1)
				If dbSeek(xFilial("SAH")+ SD2->D2_UM)
					_cUm := SAH->AH_CODANFA                                // Unidade de medida Anfavea    (2)  M
				Endif
			Endif

			_cUm := If(SF2->F2_CLIENTE == '000021',SD2->D2_UM,_cUm)             	// Quantidade de Casas Decimais (1) M

			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SD2->D2_COD)
				_cClasFis := STRZERO(VAL(SB1->B1_POSIPI),10)           // Classificacao Fiscal  Produto (10) M
			Endif

			_cAliIPI  := StrZero(Int(SD2->D2_IPI*100),4)               // Aliquota do IPI                (4)  M
			_cVlItem  := StrZero(Int(SD2->D2_PRCVEN*100000),12)        // Valor do Item                  (12) M
			If Left(_cPedCli,4) = "HETZ"
				_cTpForn  := "R"
			Else
				_cTpForn  := "P"
			Endif

			_cPerDesc := StrZero(Int(SD2->D2_DESC*100),4)             // Percentual de Desconto         (4)  O
			_cValDesc := StrZero(Int(SD2->D2_DESCON*100),11)          // Valor do Desconto              (13) O

			If Len(Alltrim(_cRev)) == 2                                        // Alteraçao Técnica do Item      (4)
				_cRev := Space(2)+Alltrim(_cRev)
			Else
				_cRev := Substr(_cRev,1,4)
			Endif
			//                                                                                                          86       95
			_cCpo := "AE2"+ _cItem + _cPedCli + _cProdCli + _cQtde + _cUM + _cClasFis + _cAliIPI + _cVlItem + _cQtde + _cUM + ;
			_cQtde + _cUM + _cTpForn + _cPerDesc + _cValDesc + _cRev + space(1)
			//                 97      106      (1)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
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

			_cCpo := "AE4"+ _cAliICMS + _cBaseICMS + _cVlICMS + _cVlIPI + "00" + sPace(30) +"000000"+space(13)+ space(6) + _cVlTotal +sPace(1)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiR++

			If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE4). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif

			_cPO       := SD2->D2_PEDCLI                        // PO           (4) M
			_cVlICMS   := StrZero(Int(SD2->D2_VALICM *100),12)          // Valor do ICMS                   (17) O
			_cCfo      := SD2->D2_CF                        // Codigo de Operaçao              (3)  M
			_cVlBaTrib := Repl("0",17)                                  // Valor Base do ICMS Tributario   (17) M
			_cVlICMTri := Repl("0",17)                                  // Valor do ICMS Tributario        (17) M
			_cQtdeEmb  := Repl("0",14)                                   // Quantidade Entregue             (9)  O
			_cCpo := "AE7"+ _cVlICMS + STRZERO(VAL(_cCFO),5) + _cVlBaTrib + _cVlICMTRI + _cQtdeEmb + Space(60)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
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

Return
