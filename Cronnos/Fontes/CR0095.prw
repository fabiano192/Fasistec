#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa	:	CR0095
Autor		:	Fabiano da Silva
Data		:	13.08.16
Descrição	:	Programação Automática CNH
*/

User Function CR0095()

	Local aSize    := MsAdvSize()	// Informacoes para montagem Dialog
	Local aInfo    := {}			// Informacoes para montagem Dialog
	Local aPosObj  := {}			// Informacoes para montagem Dialog
	Local aObjects := {}			// Informacoes para montagem Dialog
	Local aSay     := {}			// Array com linhas a serem exibidas na FormBatch
	Local aButton  := {}			// Array referente aos botoes da FormBatch
	Local cDesc1   := ""			// Descricao referente a FormBath ou Relatorio
	Local cDesc2   := ""			// Descricao referente a FormBath ou Relatorio
	Local cTitulo  := ""			// Titulo da FormBatch
	Local cList    := ""			// Variavel auxiliar para montagem da ListBox
	Local _nOpc    := 0				// Opcao selecionada pelo usuario na FormBatch
	Local lTodos   := .F. 			// Variavel auxiliar pata objeto CheckBox
	Local oTodos     				// Objeto CheckBox
	Local oOk     					// Objeto referente a marca da linha da ListBox quando marcada
	Local oNo     					// Objeto referente a marca da linha da ListBox quando desmarcada
	Local oDlg                 		// Nome do objeto referente a Dialog

	Private aListFile  := {}		 // Array utilizados pela ListBox com arquivos a serem importados
	Private oListArq		 		// Objeto referente a janela da ListBox
	Private cDir       := GetMv('CR_DIRCNH')
	Private _cLoja     := _cCliente := ""

	Private _nPula,_lPrim,_cItem,_lAchou,_nPrcVen,_cNum,_lVerFat, _lIncSC6, _cPedido
	Private _cProgr := Space(100)
	Private _oProgr := Nil
	Private _cFil1  := ''

	cDir	+= IIf( SubStr( cDir, Len( cDir ), 1 ) <> '\', '\', '' )

	oOk  := LoadBitmap(GetResources(), "LBOK")
	oNo  := LoadBitmap(GetResources(), "LBNO")

	cTitulo := "Importação da Programacao de Entrega CNH e IVECO"
	cDesc1  := "Esta rotina tem como objetivo gerar os Pedidos de Entrega da CNH e IVECO."
	cDesc2  := "Programa CR0095"

	_nOpc := 0
	DEFINE MSDIALOG oDlg TITLE cTitulo From 0,0 to 200,400 of oMainWnd PIXEL

	@ 05,05 to 40,200 of oDlg pixel

	@ 15,10  Say cDesc1 of oDlg pixel
	@ 25,10  Say cDesc2 of oDlg pixel

	@ 41,05 to 65,200 of oDlg pixel

	DEFINE SBUTTON FROM 050,010 TYPE 4 ACTION GetFile() 		 	ENABLE Of oDlg

	@ 50,40 MsGet _oProgr VAR _cProgr When .F. Size 50, 10 of oDlg pixel

	@ 66,05 to 95,200 of oDlg pixel
	DEFINE SBUTTON FROM 080,060 TYPE 2 ACTION oDlg:End() 		 	ENABLE Of oDlg
	DEFINE SBUTTON FROM 080,100 TYPE 1 ACTION (_nOpc:=1,oDlg:END()) ENABLE Of oDlg

	ACTIVATE MSDIALOG oDlg centered

	If _nOpc = 1

		If Empty(aListFile)

			ApMsgStop("Nenhum arquivo a ser importado.","Atenção")

		Else

			Processa({|| A010UpFile()})

		EndIf

	EndIf

Return


Static Function GetFile()

	_aCSV := Directory(cDir+'*.csv')

	For nX:=1 To Len(_aCSV)
		FErase(cDir+_aCSV[nX][1])
	Next nX

	_cFile := cGetFile('Arquivo CSV|*.csv','Selecione arquivo',0,'C:\',.T.,GETF_NETWORKDRIVE+GETF_LOCALHARD,.F.)

	If !Empty(_cFile)

		_aName := StrTokArr( _cFile , "\" )
		_cFil1 := _aName[Len(_aName)]

		If !__CopyFile(_cFile, cDir+_cFil1 )
			MsgInfo('Não foi possível copiar o arquivo: '+_cFile)
		Else

			Aadd( aListFile, {.T., _cFil1, "", .f.} )
			_cProgr := _cFile
			_oProgr:Refresh()

		Endif
	Endif

Return


Static Function A010UpFile() //Processa arquivos selecionados para importacao

	Local nFiles     := 0
	Local nI         := 0
//	Local aLogErro   := {}

	//³ Loop para contar quantos arquivos serao processados ³
	For nI:=1 To Len(aListFile)

		If aListFile[nI][1]
			nFiles ++
		EndIf

	Next nI

	If !Empty(nFiles)

		ProcRegua(Len( aListFile )+ 1 )

		//³ Loop para contar processar os arquivos selecionados ³
		IncProc()

		For nI:=1 To Len( aListFile )

			If aListFile[nI][1]

				//			IncProc("Arquivo: "+AllTrim(aListFile[nI][2]))
				IncProc(AllTrim(aListFile[nI][2]))

//				aLogErro := {}

//				If UploadFile(	cDir, AllTrim(aListFile[nI][2]), !aListFile[nI][4], @aLogErro	)
				If UploadFile(	cDir, AllTrim(aListFile[nI][2]), !aListFile[nI][4]	)
					CR095B(_cLoja,_cCliente)
					ApMsgInfo("Arquivo " + AllTrim(aListFile[nI][2]) + " importado com sucesso.","Atenção")

					_cData    := GravaData(dDataBase,.f.,8)
					_cHora    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

					__CopyFile( cDir +AllTrim(aListFile[nI][2]), cDir+"BKP\"+_cData+_cHora+"_"+AllTrim(aListFile[nI][2]) )
					FErase(cDir +AllTrim(aListFile[nI][2]))

					LjMsgRun("Gerando e-mail das inconsistências...","Programação CNH",{||CR095C()})

				EndIf

			EndIf

		Next nI

	Else

		ApMsgStop("Nenhum arquivo foi selecionado para importação.","Atenção")

	EndIf

Return

/*
Desc.     	³Processa arquivos selecionados para importacao
Parametros	³ cDir   	 - Diretorio em que os arquivos sao gravados.
³ cFile     - Nome do arquivo.
³ lIns      - Insere .T., Altera .F.
*/

Static Function UploadFile(	cDir, cFile, lIns)

	Local cBuffer    := ""
	Local aLin       := {}
	Local aPeso      := {}
	Local nLin       := 0
	Local nPeso      := 0
	Local nPesoTotal := 0
	Local nQtdCaixa  := 0
	Local _cFornece  := Space(6)
	Local lSeek      := .F.
	Local lRet       := .T.
	Local lAchou	 := .F.

	If 	OpenFile( cDir, cFile )

		aStru := {}
		AADD(aStru,{"INDICE"   , "C" , 01, 0 })
		AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
		AADD(aStru,{"CLIENTE"  , "C" , 06, 0 })
		AADD(aStru,{"LOJA"     , "C" , 02, 0 })
		AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
		AADD(aStru,{"PEDCLI"   , "C" , 20, 0 })

		cArqLOG := CriaTrab(aStru,.T.)
		cIndLOG := "INDICE+PRODUTO+PRODCLI"
		dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

		dbSelectArea("TRB")
		IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")


		FT_FUSE( cDir + cFile )
		FT_FGOTOP()

		Begin Transaction

			Do While !FT_FEOF()
				nLin++

				cBuffer := FT_FREADLN()

				//Substituir vírgula(,) por ponto(.)
				cBuffer := STRTRAN(cBuffer,'9,','9.')
				cBuffer := STRTRAN(cBuffer,'8,','8.')
				cBuffer := STRTRAN(cBuffer,'7,','7.')
				cBuffer := STRTRAN(cBuffer,'6,','6.')
				cBuffer := STRTRAN(cBuffer,'5,','5.')
				cBuffer := STRTRAN(cBuffer,'4,','4.')
				cBuffer := STRTRAN(cBuffer,'3,','3.')
				cBuffer := STRTRAN(cBuffer,'2,','2.')
				cBuffer := STRTRAN(cBuffer,'1,','1.')
				cBuffer := STRTRAN(cBuffer,'0,','0.')
				cBuffer := STRTRAN(cBuffer,' ,',' .')

				cBuffer := STRTRAN(cBuffer,',9','.9')
				cBuffer := STRTRAN(cBuffer,',8','.8')
				cBuffer := STRTRAN(cBuffer,',7','.7')
				cBuffer := STRTRAN(cBuffer,',6','.6')
				cBuffer := STRTRAN(cBuffer,',5','.5')
				cBuffer := STRTRAN(cBuffer,',4','.4')
				cBuffer := STRTRAN(cBuffer,',3','.3')
				cBuffer := STRTRAN(cBuffer,',2','.2')
				cBuffer := STRTRAN(cBuffer,',1','.1')
				cBuffer := STRTRAN(cBuffer,',0','.0')
				cBuffer := STRTRAN(cBuffer,', ','. ')

				cBuffer := STRTRAN(cBuffer,'A,','A.')
				cBuffer := STRTRAN(cBuffer,'B,','B.')
				cBuffer := STRTRAN(cBuffer,'C,','C.')
				cBuffer := STRTRAN(cBuffer,'D,','D.')
				cBuffer := STRTRAN(cBuffer,'E,','E.')
				cBuffer := STRTRAN(cBuffer,'F,','F.')
				cBuffer := STRTRAN(cBuffer,'G,','G.')
				cBuffer := STRTRAN(cBuffer,'H,','H.')
				cBuffer := STRTRAN(cBuffer,'I,','I.')
				cBuffer := STRTRAN(cBuffer,'J,','J.')
				cBuffer := STRTRAN(cBuffer,'K,','K.')
				cBuffer := STRTRAN(cBuffer,'L,','L.')
				cBuffer := STRTRAN(cBuffer,'M,','M.')
				cBuffer := STRTRAN(cBuffer,'N,','N.')
				cBuffer := STRTRAN(cBuffer,'O,','O.')
				cBuffer := STRTRAN(cBuffer,'P,','P.')
				cBuffer := STRTRAN(cBuffer,'Q,','Q.')
				cBuffer := STRTRAN(cBuffer,'R,','R.')
				cBuffer := STRTRAN(cBuffer,'S,','S.')
				cBuffer := STRTRAN(cBuffer,'T,','T.')
				cBuffer := STRTRAN(cBuffer,'U,','U.')
				cBuffer := STRTRAN(cBuffer,'V,','V.')
				cBuffer := STRTRAN(cBuffer,'W,','W.')
				cBuffer := STRTRAN(cBuffer,'X,','X.')
				cBuffer := STRTRAN(cBuffer,'Y,','Y.')
				cBuffer := STRTRAN(cBuffer,'Z,','Z.')

				aLin := StrTokArr( cBuffer , "," )

				For A:= 1 to Len(aLin)
					aLin[A] := STRTRAN(aLin[A],'"','')
				Next A

				If aLin[1] != "PARTNBR" //Se diferente de cabecalho
					/*
					aLin[1]  - PARTNBR
					aLin[2]  - REV
					aLin[3]  - REV NOTES
					aLin[4]  - DESCRIPTION
					aLin[5]  - SUPPLIER PARTNBR
					aLin[6]  - DATE TYPE
					aLin[7]  - DATE DUE
					aLin[8]  - QTY DUE
					aLin[9]  - QTY TYPE
					aLin[10] - CUM QTY
					aLin[11] - UOM
					aLin[12] - PLANT
					aLin[13] - PLANNER CODE
					aLin[14] - SUPPLIER
					aLin[15] - SUP NAME
					aLin[16] - REL
					aLin[17] - REL DATE
					aLin[18] - REL STATUS CODE
					aLin[19] - REL STATUS
					aLin[20] - BALANCE OUT
					aLin[21] - CONSIGNMENT STOCK
					aLin[22] - OVERSHIPPED
					aLin[23] - CUM START DATE
					aLin[24] - PO
					aLin[25] - PO Line
					aLin[26] - SHIP CODE
					aLin[27] - REL NOTE 1
					aLin[28] - REL NOTE 2
					aLin[29] - REL NOTE 3
					aLin[30] - REL NOTE 4
					aLin[31] - REL NOTE 5
					aLin[32] - REL NOTE 6
					aLin[33] - REL NOTE 7
					aLin[34] - REL NOTE 8
					aLin[35] - REL NOTE 9
					aLin[36] - REL NOTE 10
					aLin[37] - Ship to
					aLin[38] - Ship to address1
					aLin[39] - Ship to address2
					aLin[40] - Ship to address3
					aLin[41] - Ship to address4
					aLin[42] - LAST REC
					aLin[43] - LAST QTY
					aLin[44] - LAST CUM QTY
					aLin[45] - LAST PACK NBR
					aLin[46] - NEW REV CODE
					aLin[47] - NEW REV TEXT
					aLin[48] - NEW REV CUM LEVEL
					aLin[49] - NEW REV START DATE
					aLin[50] - AMENDED
					aLin[51] - Ship to code
					aLin[52] - SETUP FOR CONTAINER MANAGEMENT
					aLin[53] - CONTAINER TYPE
					aLin[54] - QUANTITY IN CONTAINER
					*/

					_cCliente  := ""
					_cLoja     := ""
					_cTes      := ""
					_lContinua := .T.
					_cPedCli   := PADR(aLin[24],20)
					If Alltrim(aLin[12]) = "BH"
						//						_cCliente := "000025"
						_cCliente := "000051"
						_cLoja := "01"
						_cTes  := "511"
					ElseIf	Alltrim(aLin[12]) = "CT"
						_cCliente := "000051"
						_cLoja := "02"
						_cTes  := "511"
					ElseIf	Alltrim(aLin[12]) = "PI"
						_cCliente := "000051"
						_cLoja := "03"
						_cTes  := "511"
					ElseIf	Alltrim(aLin[12]) = "SO"
						_cCliente := "000051"
						_cLoja := "04"
						_cTes  := "511"
					ElseIf	Alltrim(aLin[12]) = "BR"
						_cCliente := "000051"
						_cLoja := "05"
						_cTes  := "512"
						_lContinua := .F.
						_cPedCli   := PADR('0',20)
					ElseIf	Alltrim(aLin[12]) = "73"
						_cCliente := "000021"
						_cLoja := "01"
						_cTes  := "511"
					Endif

					If Empty(_cloja)
						lRet := .F.
					Endif

					_lGrava		:= .F.
					_cProdPasy	:= ""    
					SZ2->(dbSetOrder(8))
					If SZ2->(dbSeek(xFilial("SZ2")+_cCliente + _cLOja + PADR(aLin[1],15) + _cPedCli))
						If SZ2->Z2_ATIVO = '1'
							_cProdPasy := SZ2->Z2_PRODUTO
						Else
							If !Empty(SZ2->Z2_PRODUTO)
								_lGrava		:= .T.
							Endif
						Endif
					Else
						_lGrava		:= .T.
					Endif

					If _lGrava
					
						SZ2->(RecLock("SZ2",.T.))
						SZ2->Z2_FILIAL	:= xFilial('SZ2')
						SZ2->Z2_CLIENTE	:= _cCliente
						SZ2->Z2_LOJA	:= _cLoja
						//			SZ2->Z2_PRODUTO	:= 
						SZ2->Z2_CODCLI	:= PADR(aLin[1],15)
						SZ2->Z2_PEDCLI	:= _cPedCli
						SZ2->Z2_UM		:= Alltrim(aLin[11])
						SZ2->Z2_DESCCLI	:= Alltrim(aLin[4])
						SZ2->Z2_ATIVO	:= "2"
						SZ2->Z2_TES		:= _cTes
						SZ2->(MsUnlock())

						TRB->(RecLock("TRB",.T.))
						TRB->INDICE  := "1"
						TRB->PRODCLI := PADR(aLin[1],15)
						TRB->CLIENTE := _cCliente
						TRB->LOJA    := _cLoja
						TRB->PEDCLI  := _cPedCli
						TRB->(MsUnlock())

						lRet := .F.
					Endif

					If !_lContinua .And. lRet 
						lRet := .F.
					Endif

					If lRet
						SZ4->(RecLock("SZ4",.T.))
						SZ4->Z4_FILIAL  := xFilial("SZ4")
						SZ4->Z4_CODCLI  := _cCliente
						SZ4->Z4_LOJA    := _cLoja
						SZ4->Z4_PRODPAS := _cProdPasy
						SZ4->Z4_PRODCLI := Alltrim(aLin[1])
						_dDtMovi := Ctod(Subst(aLin[17],7,2)+"/"+Subst(aLin[17],5,2)+"/20"+Subst(aLin[17],3,2))
						SZ4->Z4_DTMOV   := _dDtMovi
						SZ4->Z4_DTATU   := _dDtMovi
						SZ4->Z4_LOCDEST := aLin[12]
						SZ4->Z4_ULTNF   := PadL(aLin[45],9,"0")
						_dDtUltNf := Ctod(Subst(aLin[42],7,2)+"/"+Subst(aLin[42],5,2)+"/20"+Subst(aLin[42],3,2))
						SZ4->Z4_DTULTNF := _dDtUltNf
						_dDtEnt   := Ctod(Subst(aLin[7],7,2)+"/"+Subst(aLin[7],5,2)+"/20"+Subst(aLin[7],3,2))
						SZ4->Z4_DTENT   := _dDtEnt

						_nPos1   := AT(".",aLin[8])
						_nQuant := Val(Substr(aLin[8],1,_nPos1)+","+Substr(aLin[8],_nPos1+1,3))

						SZ4->Z4_QTENT   := _nQuant
						SZ4->Z4_PEDIDO  := _cPedCli
						SZ4->Z4_POLINE  := aLin[25]

						_cTpPed := ""
						If aLin[9] == "Firm"
							_cTpPed := "1"
						ElseIf	aLin[9] == "Past Due"
							_cTpPed := "1"
						ElseIf	aLin[9] == "Planning"
							_cTpPed := "4"
						Endif

						SZ4->Z4_TPPED   := _cTpPed
						SZ4->Z4_DTDIGIT := dDatabase
						SZ4->Z4_NOMARQ  := cDir + cfile
						SZ4->Z4_ALTTEC  := aLin[2]
						SZ4->(MsUnlock())
					Endif
					lRet := .T.
				Endif

				FT_FSKIP()

			EndDo

			//	If !lRet
			//		DisarmTransaction()
			//	EndIf

		End Transaction

		FT_FUSE()

	Else
		ApMsgStop("Não foi possível a abrir o arquivo " + cFile + ".","Atenção")
		lRet := .F.

	EndIf

Return lRet

/*
Desc:		Abre o arquivo para importacao.
Parametros 	cDir   	 - Diretorio em que os arquivos sao gravados.
cFile     - Nome do arquivo.
*/

Static Function OpenFile( cDir, cFile )

	Local nHdl := -1
	Local lRet := .T.

	nHdl := fOpen( cDir + cFile, 0 )

	If nHdl < 0
		lRet := .F.
	Else
		fClose( nHdl )
	EndIf

Return lRet



Static Function CR095B(cLoja,_cCliente)

	Private _nPula,_lPrim,_cItem,_cItemExp,_lAchou,_nPrcVen,_cNum,_lVerFat, _lIncSC6, _cPedido
	Private _lIncSC6 := .F.

	SZ4->(dbSetOrder(1))

	Private _lNAchou   := .F.
	_lFim      := .F.

	_lNAchou := .F.

	_cq  := "UPDATE SD2010 SET D2_PROGENT = 0 WHERE D2_CLIENTE = '"+_cCliente+"' AND D2_LOJA = '"+cLoja+"' "

	TCSQLEXEC(_cq)
	_cq1  := "UPDATE SC6010 SET C6_LA = '' WHERE C6_CLI = '"+_cCliente+"' AND C6_LOJA = '"+cLoja+"' AND D_E_L_E_T_ = '' "

	TCSQLEXEC(_cq1)

	_lEntr     := .F.
	_lPrim     := .F.
	_cItem     := "00"

	_cQuery := " SELECT * FROM "+RetSqlName("SZ4")+" Z4 "
	_cQuery += " WHERE Z4.D_E_L_E_T_ = '' AND Z4_CODCLI = '"+_cCliente+"' AND Z4_LOJA = '"+cLoja+"'  "
	_cQuery += " AND Z4_INTEGR = '' AND Z4_DTDIGIT = '"+DTOS(dDataBase)+"' "
	_cQuery += " ORDER BY Z4_DTDIGIT,Z4_PRODPAS,Z4_DTENT "

	TCQUERY _cQuery NEW ALIAS "ZZ4"

	TCSETFIELD("ZZ4","Z4_DTDIGIT","D")
	TCSETFIELD("ZZ4","Z4_DTATU","D")
	TCSETFIELD("ZZ4","Z4_DTULTNF","D")
	TCSETFIELD("ZZ4","Z4_DTENT","D")

	ZZ4->(dbGotop())

	While ZZ4->(!EOF())

		//	ProcRegua(RecCount())

		_cClieLoja := ZZ4->Z4_CODCLI + ZZ4->Z4_LOJA
		_cProdCli  := ZZ4->Z4_PRODCLI

		SZ2->(dbSetOrder(8))
		If SZ2->(!dbSeek(xFilial("SZ2")+ZZ4->Z4_CODCLI + ZZ4->Z4_LOJA + ZZ4->Z4_PRODCLI + ZZ4->Z4_PEDIDO+"1"))
			//		SZ2->(dbSetOrder(1))
			//		If SZ2->(!dbSeek(xFilial("SZ2")+ZZ4->Z4_CODCLI+ZZ4->Z4_LOJA+ZZ4->Z4_PRODPAS+ZZ4->Z4_PRODCLI+"1"))
			ZZ4->(dbSkip())
			Loop
		Endif

		dDataRef := SZ2->Z2_DTREF01
		nValor   := SZ2->Z2_PRECO01
		For i := 2 to 12
			If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
				dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
				nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
			Endif
		Next i

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+ZZ4->Z4_PRODPAS))

		ZERAPED()

		_nPrcVen := nValor

		_lVerFat := .t.
		_aPedCli := {}

		While ZZ4->(!Eof()) .And. _cProdCli == ZZ4->Z4_PRODCLI

			If _lFim
				Alert("Cancelado Pelo Usuario!!!!!!")
				Return
			Endif

			INTSC6C()

			_cChav1 := ZZ4->Z4_CODCLI+ZZ4->Z4_LOJA+ZZ4->Z4_PRODPAS+ZZ4->Z4_PRODCLI

			_cq4  := " UPDATE "+RetSqlname("SZ4")+" SET Z4_INTEGR = 'S' "
			_cq4  += " WHERE D_E_L_E_T_ = '' AND Z4_CODCLI+Z4_LOJA+Z4_PRODPAS+Z4_PRODCLI = '"+_cChav1+"' "
			_cq4  += " AND Z4_DTDIGIT =  '"+DTOS(dDataBase)+"' "

			TCSQLEXEC(_cq4)

			_lEntr := .T.

			ZZ4->(dbSkip())
		EndDo
	EndDo

	ZZ4->(dbClosearea())

	//Inicio da Eliminação de Resíduo
	If _lEntr
		_cq3  := " UPDATE SC6010 SET C6_BLQ = 'R', C6_XDTELIM = '"+DTOS(dDataBase)+"', C6_LOCALIZ = 'CR0095' "
		_cq3  += " WHERE C6_LA <> 'OK' AND D_E_L_E_T_ = '' AND C6_PEDAMOS IN ('N','Z','I','M') AND C6_QTDENT < C6_QTDVEN "
		_cq3  += " AND C6_CLI = '"+_cCliente+"' AND C6_LOJA = '"+cLoja+"' "
		_cq3  += " AND C6_BLQ = '' AND C6_CPROCLI <> '' "
		If SC6->(FieldPos("C6_XRESIDU")) > 0
			_cq3  += " AND C6_XRESIDU <> 'N' "		
		Endif

		TCSQLEXEC(_cq3)
	Endif

Return (Nil)


Static Function IntSC6C()

	_nFatur  := 0
	_nQuanti := 0

	_cNF := ZZ4->Z4_ULTNF
	_lOk := .F.

	SF2->(dbSetOrder(1))
	If SF2->(dbSeek(xFilial("SF2")+ZZ4->Z4_ULTNF+"2  "))
		_cNF := ZZ4->Z4_ULTNF
		_lOk := .T.
	Endif

	If !_lOk
		SF2->(dbSetOrder(1))
		If SF2->(dbSeek(xFilial("SF2")+Substr(ZZ4->Z4_ULTNF,4,6)+Space(3)+"1  "))
			_cNF := Substr(ZZ4->Z4_ULTNF,4,6)+"   "
		Endif
	Endif

	If VAL(_cNF) > 0
		_cUltNf := _cNF + "01"
	Else
		_cUltNf := "000000001"
	Endif

	SD2->(dbOrderNickName("INDSD23"))
	SD2->(dbSeek(xFilial("SD2")+ ZZ4->Z4_CODCLI + ZZ4->Z4_LOJA + ZZ4->Z4_PRODPAS + "2  " + _cUltNf,.T.))

	_cChav  := ZZ4->Z4_CODCLI + ZZ4->Z4_LOJA + ZZ4->Z4_PRODPAS

	While SD2->(!Eof()) .And. _cChav == SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD

		If SD2->D2_DOC <= _cNF .And. SD2->D2_EMISSAO <= ZZ4->Z4_DTULTNF
			SD2->(dbSkip())
			Loop
		Endif

		If SD2->D2_EMISSAO < ZZ4->Z4_DTULTNF
			SD2->(dbSkip())
			Loop
		Endif

		If SD2->D2_PROCLI <> ZZ4->Z4_PRODCLI
			SD2->(dbSkip())
			Loop
		Endif

		If SD2->D2_QUANT == SD2->D2_PROGENT
			SD2->(dbSkip())
			Loop
		Endif

		If SD2->D2_QUANT == SD2->D2_QTDEDEV
			SD2->(dbSkip())
			Loop
		Endif		                      

		SC6->(dbSetOrder(1))
		If SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV))
			If Alltrim(SC6->C6_PEDCLI) != Alltrim(ZZ4->Z4_PEDIDO)
				SD2->(dbSkip())
				Loop
			Endif
		Endif

		_nQuanti := SD2->D2_QUANT - SD2->D2_QTDEDEV
		_nFatur2 := _nFatur
		_nFatur  += _nQuanti - SD2->D2_PROGENT

		If _nFatur >= ZZ4->Z4_QTENT
			_nDif  := ZZ4->Z4_QTENT - _nFatur2
		Else
			_nDif  := _nQuanti - SD2->D2_PROGENT
		Endif

		SD2->(RecLock("SD2",.F.))
		SD2->D2_PROGENT += _nDif
		SD2->(MsUnlock())

		If _nFatur >= ZZ4->Z4_QTENT
			Return
		Endif

		SD2->(dbSkip())
	EndDo

	_lAchou   := .F.

	SC6->(dbOrderNickName("INDSC61"))
	If SC6->(dbSeek(xFilial("SC6")+ ZZ4->Z4_CODCLI + ZZ4->Z4_LOJA + ZZ4->Z4_PRODPAS + ZZ4->Z4_PRODCLI + ZZ4->Z4_PEDIDO + DTOS(ZZ4->Z4_DTENT)))

		_cChavSC62 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI +DTOS(SC6->C6_ENTREG)

		While SC6->(!Eof()) .And. 	_cChavSC62 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI + DTOS(SC6->C6_ENTREG)

			If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. !Empty(SC6->C6_BLQ)
				SC6->(dbSkip())
				Loop
			Endif

			If (SC6->C6_QTDVEN - SC6->C6_QTDENT) != ZZ4->Z4_QTENT - _nFatur
				SC6->(dbSkip())
				Loop
			Endif

			If SC6->C6_PEDCLI = "999999999"
				SC6->(dbSkip())
				Loop
			Endif

			If SC6->C6_LOCDEST != ZZ4->Z4_LOCDEST
				SC6->(dbSkip())
				Loop
			Endif

			SC6->(RecLock("SC6",.F.))
			SC6->C6_LA 		:= "OK"
			SC6->C6_IDENCAT := ZZ4->Z4_SEMATU
			If ZZ4->Z4_TPPED = "1"
				SC6->C6_PEDAMOS := "N"
			Endif
			SC6->C6_PEDCLI  := ZZ4->Z4_PEDIDO
			SC6->C6_POLINE  := ZZ4->Z4_POLINE
			SC6->(MsUnlock())

			_lAchou := .T.

			SC6->(dbSkip())
		EndDo
	Endif

	If !_lAchou

		_lVerFat := .F.
		_cItem   := SomaIt(_cItem)
		_cDest1  := ZZ4->Z4_LOCDEST

		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+ZZ4->Z4_CODCLI+ZZ4->Z4_LOJA))

		If !_lPrim .Or. _cItem == "ZZ"

			_cItem  := "01"
			_cNum  := GETSXENUM("SC5","C5_NUM")
			CONFIRMSX8()
			_lPrim := .T.

			_cPedido := _cNum
			_lIncSC6 := .F.

			SC5->(RecLock("SC5",.T.))
			SC5->C5_FILIAL  := xFilial("SC5")
			SC5->C5_NUM     := _cNum
			SC5->C5_TIPO    := "N"
			SC5->C5_CLIENTE := ZZ4->Z4_CODCLI
			SC5->C5_CLIENT  := ZZ4->Z4_CODCLI
			SC5->C5_LOJAENT := ZZ4->Z4_LOJA
			SC5->C5_LOJACLI := ZZ4->Z4_LOJA
			SC5->C5_TRANSP  := SA1->A1_TRANSP
			SC5->C5_TIPOCLI := SA1->A1_TIPO
			SC5->C5_CONDPAG := SA1->A1_COND
			SC5->C5_TIPLIB  := "1"
			SC5->C5_VEND1   := SA1->A1_VEND
			SC5->C5_COMIS1  := SA1->A1_COMIS
			SC5->C5_EMISSAO := dDataBase
			SC5->C5_PESOL   := 1
			SC5->C5_MOEDA   := 1
			SC5->C5_TXMOEDA := 1
			SC5->C5_TPCARGA := "2"
			SC5->(MsUnlock())
		Endif

		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xFilial("SF4")+SZ2->Z2_TES))

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+ZZ4->Z4_PRODPAS))

		SC6->(RecLock("SC6",.T.))
		SC6->C6_FILIAL  := xFilial("SC6")
		SC6->C6_NUM     := _cNUm
		SC6->C6_ITEM    := _cItem
		SC6->C6_CPROCLI := ZZ4->Z4_PRODCLI
		SC6->C6_PRODUTO := ZZ4->Z4_PRODPAS
		SC6->C6_REVPED  := ZZ4->Z4_ALTTEC
		SC6->C6_QTDVEN  := ZZ4->Z4_QTENT - _nFatur
		SC6->C6_PRCVEN  := _nPrcVen
		SC6->C6_VALOR   := Round(( (ZZ4->Z4_QTENT - _nFatur) * _nPrcVen ),2)
		SC6->C6_ENTREG  := ZZ4->Z4_DTENT
		If ZZ4->Z4_TPPED == "1"
			SC6->C6_PEDAMOS := "N"
		ElseIf ZZ4->Z4_TPPED == "2"
			SC6->C6_PEDAMOS := "I"
		ElseIf ZZ4->Z4_TPPED == "3"
			SC6->C6_PEDAMOS := "M"
		ElseIf ZZ4->Z4_TPPED == "4"
			SC6->C6_PEDAMOS := "Z"
		Endif

		If ZZ4->Z4_TIPO == "A"
			SC6->C6_PEDAMOS := "A"
		Endif

		SC6->C6_TES     := SZ2->Z2_TES

		If SA1->A1_EST == "SP"
			_cCf        := "5"
		ElseIf SA1->A1_EST == "EX"
			_cCf        := "7"
		Else
			_cCF        := "6"
		Endif
		SC6->C6_CF      := _cCf + Substr(SF4->F4_CF,2,3)
		SC6->C6_UM      := SB1->B1_UM
		SC6->C6_PEDCLI  := ZZ4->Z4_PEDIDO
		SC6->C6_DESCRI  := SB1->B1_DESC
		SC6->C6_LOCAL   := SB1->B1_LOCPAD
		SC6->C6_CLI     := ZZ4->Z4_CODCLI
		SC6->C6_LOJA    := ZZ4->Z4_LOJA
		SC6->C6_PRUNIT  := _nPrcVen
		SC6->C6_TPOP    := "F"
		SC6->C6_IDENCAT := ZZ4->Z4_SEMATU
		SC6->C6_LA 		:= "OK"
		SC6->C6_CLASFIS := SUBSTR(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
		SC6->C6_LOCDEST := ZZ4->Z4_LOCDEST
		SC6->C6_POLINE  := ZZ4->Z4_POLINE
		SA3->(dbSetOrder(1))
		If SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND))
			SC6->C6_COMIS1   := SA3->A3_COMIS
		Endif
		SC6->(MsUnlock())
	Endif

Return (Nil)


Static Function ZeraPed()

	_cChavSC6 := ZZ4->Z4_CODCLI + ZZ4->Z4_LOJA + ZZ4->Z4_PRODPAS + ZZ4->Z4_PRODCLI + ZZ4->Z4_PEDIDO

	_cq  := " UPDATE SC6010 C6 SET C6_IDENCAT = '' WHERE '"+_cChavSC6+"' = C6_CLI + C6_LOJA + C6_PRODUTO + C6_CPROCLI + C6_PEDCLI "
	_cq  += " AND C6_QTDVEN > C6_QTDENT AND C6_BLQ = '' AND C6.D_E_L_E_T_ = '' "
	If SC6->(FieldPos("C6_XRESIDU")) > 0
		_cq  += " AND C6_XRESIDU <> 'N' "		
	Endif
	
	TCSQLEXEC(_cq)

Return (Nil)



Static Function CR095C()
	
	Local oFwMsEx 		:= NIL
	Local cArq 			:= ""
	Local cWorkSheet	:= ""
	Local cTable 		:= ""
	Local _lEnt 		:= .F.
	
	oFwMsEx := FWMsExcel():New()
	
	TRB->(dbGotop())
	
	_lFirst := .T.
	_cLj    := TRB->LOJA 
	
	While !TRB->(Eof())
		
		If _lFirst
			_lEnt    := .T.
			
			cWorkSheet 	:= 	"Inconsistencia CNH"
			cTable 		:= 	"Inconsistencia CNH"
			
			oFwMsEx:AddWorkSheet( cWorkSheet )
			oFwMsEx:AddTable( cWorkSheet, cTable )
			
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto Cronnos"	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto Cliente"	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Pedido Cliente"   	, 1,1,.F.)
			
			_lFirst := .F.
		Endif
		
		oFwMsEx:AddRow( cWorkSheet, cTable,{;
			TRB->CLIENTE	,;
			TRB->LOJA    	,;
			TRB->PRODUTO   	,;
			TRB->PRODCLI    ,;
			TRB->PEDCLI    	})
		
		TRB->(dbSkip())
	EndDo
	
	TRB->(dbCloseArea())
	
	oFwMsEx:Activate()
	
	_cDat1    := GravaData(dDataBase,.f.,8)
	_cHor1    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
	
	cArq := 'INCONSISTENCIA_CNH'+_cDat1+'_'+_cHor1 + ".xls"
	_cAnexo := "\WORKFLOW\RELATORIOS\"+cArq
	
	oFwMsEx:GetXMLFile( _cAnexo )
	
	If _lEnt
		CR095D(_cLj)
	Endif
	
Return




Static Function CR095D(_cLj)
	
	Private _lRet
	
	nOpcao := 0
	
	CONOUT("Enviando E-Mail de Inconsistencia - CNH")
	
	CONOUT('{'+ _cAnexo+'}')
	
	oProcess := TWFProcess():New( "Inconsistencia", "PO_CNH" )
	aCond    :={}
	_nTotal  := 0
	
	oProcess:NewTask( "INCONSISTENCIA_CNH", "\WORKFLOW\CR0095.HTM" )
	oProcess:bReturn  := ""
	oProcess:bTimeOut := ""
	
	oHTML := oProcess:oHTML
	
	oProcess:cSubject := "Inconsistencia Programação CNH - Loja "+_cLj+" - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)
	
	oProcess:fDesc := "Inconsistencia Programação CNH"
	
	Private _cTo := _cCC := ""
	
	SZG->(dbsetOrder(1))
	SZG->(dbGotop())
	
	While SZG->(!EOF())
		
		If 'R1' $ SZG->ZG_ROTINA
			_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		ElseIf 'R2' $ SZG->ZG_ROTINA
			_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		Endif
		
		SZG->(dbSkip())
	Enddo
	
	oProcess:AttachFile(_cAnexo)
	
	oProcess:cTo := _cTo
	oProcess:cCC := _cCC
	
	oProcess:Start()
	
	oProcess:Finish()
	
Return
