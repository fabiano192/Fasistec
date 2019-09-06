#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'

/*
Programa	:	CR0069
Autor		:	Fabiano da Silva
Data		:	09.02.15
Descrição	:	Programação Automática Komatsu
*/

User Function CR0069()

	Local _nOpc    		:= 0			// Opcao selecionada pelo usuario na FormBatch
	Local _oDlg                 		// Nome do objeto referente a Dialog

	Private _cDir      	:= GetMv('CR_KOMDIR')
	Private _cProgr 	:= Space(100)
	Private _oProgr 	:= Nil
	Private _cFile  	:= ''
	Private _lRet		:= .T.
	Private ALogErro	:= {}
	Private _cCliente 	:= GetMv('CR_KOMCOD')

	_cDir	+= IIf( SubStr( _cDir, Len( _cDir ), 1 ) <> '\', '\', '' )

	_cTitulo := "Importação da Programacao de Entrega Komatsu"
	_cDesc1  := "Esta rotina tem como objetivo gerar os Pedidos de Entrega da Komatsu."
	_cDesc2  := "Programa CR0069"

	DEFINE MSDIALOG _oDlg TITLE _cTitulo From 0,0 to 200,400 of oMainWnd PIXEL

	@ 05,05 to 40,200 of _oDlg pixel

	@ 15,10  Say _cDesc1 of _oDlg pixel
	@ 25,10  Say _cDesc2 of _oDlg pixel

	@ 41,05 to 65,200 of _oDlg pixel

	DEFINE SBUTTON FROM 047,010 TYPE 4 ACTION GetFile()		 	ENABLE Of _oDlg

	@ 47,40 MsGet _oProgr VAR _cProgr When .F. Size 50, 10 of _oDlg pixel

	@ 66,05 to 95,200 of _oDlg pixel
	DEFINE SBUTTON FROM 070,060 TYPE 2 ACTION _oDlg:End() 		 	ENABLE Of _oDlg
	DEFINE SBUTTON FROM 070,100 TYPE 1 ACTION (_nOpc:=1,_oDlg:END()) ENABLE Of _oDlg

	ACTIVATE MSDIALOG _oDlg centered

	If _nOpc = 1

		If Empty(_cFile)

			ApMsgStop("Nenhum arquivo a ser importado.","Atenção")

		Else

			Processa({|| GeraSZ4()})

		EndIf

	EndIf

Return


Static Function GetFile()

	_aTxt := Directory(_cDir+'*.txt')

	For nX:=1 To Len(_aTxt)
		FErase(_cDir+_aTxt[nX][1])
	Next nX

	_cDirFile := cGetFile('Arquivo CSV|*.txt','Selecione arquivo',0,'C:\',.T.,GETF_NETWORKDRIVE+GETF_LOCALHARD,.F.)

	If !Empty(_cDirFile)

		_aName := StrTokArr( _cDirFile , "\" )
		_cFile := _aName[Len(_aName)]

		If !__CopyFile(_cDirFile, _cDir+_cFile )
			MsgInfo('Não foi possível copiar o arquivo: '+_cDirFile)
		Else

			_cProgr := _cDirFile
			_oProgr:Refresh()

		Endif
	Endif

Return


Static Function GeraSZ4() //Processa arquivos selecionados para importacao

	ProcRegua(Len(_cFile)+ 1 )

	IncProc()

	IncProc(AllTrim(_cFile))


	If UploadFile(	_cDir, _cFile	)

		Gera_PV()

		ApMsgInfo("Arquivo " + AllTrim(_cFile) + " importado com sucesso.","Atenção")

		_cData    := GravaData(dDataBase,.f.,8)
		_cHora    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

		__CopyFile( _cDir +AllTrim(_cFile), _cDir+"BKP\"+_cData+_cHora+"_"+AllTrim(_cFile) )
		FErase(_cDir +AllTrim(_cFile))

		If Len( aLogErro ) > 0

			// INCLUIR FUNCAO QUE EXECUTA O RELATÓRIO DE INCONSISTÊNCIA DO ARQUIVO
			A010PRTLOG(aLogErro)
		Endif


	EndIf

Return

/*
Desc.     	³Processa arquivos selecionados para importacao
Parametros	³ cDir   	 - Diretorio em que os arquivos sao gravados.
³ cFile     - Nome do arquivo.
³ lIns      - Insere .T., Altera .F.
³ ALogErro  - Log de erros
*/

Static Function UploadFile(	_cDir, _cFile)

	Local _cBuffer    	:= ""
	Local _aLin       	:= {}
	Local _nLin       	:= 0
	Local _aCabec		:= {}
	Local _aCampos 		:= {}

	If 	OpenFile( _cDir, _cFile )

		FT_FUSE( _cDir + _cFile )
		FT_FGOTOP()

		Begin Transaction

			Do While !FT_FEOF()

				_nLin++

				If _nLin <= 2
					FT_FSKIP()
					Loop
				Endif

				_cBuffer := FT_FREADLN()

				//Substituir vírgula(,) por ponto(.)
				_cBuffer := STRTRAN(_cBuffer,'9,','9.')
				_cBuffer := STRTRAN(_cBuffer,'8,','8.')
				_cBuffer := STRTRAN(_cBuffer,'7,','7.')
				_cBuffer := STRTRAN(_cBuffer,'6,','6.')
				_cBuffer := STRTRAN(_cBuffer,'5,','5.')
				_cBuffer := STRTRAN(_cBuffer,'4,','4.')
				_cBuffer := STRTRAN(_cBuffer,'3,','3.')
				_cBuffer := STRTRAN(_cBuffer,'2,','2.')
				_cBuffer := STRTRAN(_cBuffer,'1,','1.')
				_cBuffer := STRTRAN(_cBuffer,'0,','0.')

				_aLin := StrTokArr2( _cBuffer , "|", .T. )

				If Upper(Alltrim(_aLin[1])) == 'FOREC'
					AAdd(_aCabec,_aLin)
				ElseIf !Empty(_aLin[1]) //Dados do Item - Linha 1
					/*
					Linha	Coluna             		Descricao

					1		ForCast           		Numero do forcast
					2		Fornec            		Codigo do Fornecedor
					3		Item              		Codigo do Item Komatsu
					4		Descricao         		Descricao do Item
					5		Rev               		Revisao do Item na Engenharia da Komatsu
					6		Preco             		Preco de Compra do Item
					7		Vigencia          		Vigencia do Item (validade)
					8		UND               		Unidade de medida do Item
					9		IPI               		IPI	
					10		NF                		Ultima NF de Entrada do Fornecedor
					11		CLF               		Classificacao fiscal do Item
					12		Almox             		Almoxarifado do item Komatsu   
					13		Local Almox       		Local do Item Komatsu
					14		Ent Ac            		Entrada Acumulada
					15		De                		De Para -> alteraca de programacao
					16		Atras             		Qtd Atrasada do item
					17-26	Data de 3-3 a 7-7 		qtd para as Data com pedido FIRME
					27-37	Data de 8-18      		qtd com Previsao  
					38		4.sem (1)         		qtd em 4 semanas a frente do pedido firme
					39		4.sem (2)         		qtd em 4 semanas a frente da previsao
					40		Cod. Fornecedor   		Codigo do Fornecedor na Komatsu
					41		Rese              		Fornecedor participa do Rese
					42		Recof             		Fornecedor participa do Recof
					43		data 		  			data Ultima NF de Entrada do Fornecedor
					44  	serie  		           	serie Ultima NF de Entrada do Fornecedor
					*/

					_cProdCli := Alltrim(_aLin[3])
					_cRevisao := Alltrim(_aLin[5])
					_cNF	  := PADL(Alltrim(_aLin[10]),9,"0")
					_cPed     := Alltrim(_aLin[1])

				Else

					/*
					Linha	Coluna              	Descricao
					1-13    vazio
					14		Ent Ac            		Entrada Acumulada
					15		Par a             		De Para -> alteraca de programacao
					16		Atras             		Qtd Atrasada do item
					17-26	Data de 3-3 a 7-7 		qtd para Data com pedido FIRME
					27-37	Data de 8-18      		qtd com Previsao  
					38		4.sem (1)         		qtd em 4 semanas a frente do pedido firme
					39		4.sem (2)         		qtd em 4 semanas a frente da previsao
					40		vazio
					41		vazio
					42		vazio
					43		Local Geogr       		Local Geogafico para entrega do Item
					44		Cnpj cliente      		CNPJ Komatsu      
					45		Cnpj fornecedor   		CNPJ Magno 
					*/

					_cLoja    := ""

					If Alltrim(_aLin[43]) = "SUZ"
						_cLoja := "01"
					ElseIf Alltrim(_aLin[43]) = "ARU"
						_cLoja := "02"
					Endif

					If Empty(_cloja)
						aAdd(_aLogErro, {_nLin, _aLin[43],_cloja, "Loja não Cadastrada nesta linha"})
						_lRet := .F.
					Endif

					SZ2->(dbSetOrder(6))
					If SZ2->(MsSeek(xFilial("SZ2")+_cCliente + _cLoja + PADR(_cProdCli,15)+"1"))
						_cProduto := SZ2->Z2_PRODUTO
					Else
						aAdd(aLogErro, {_nLin, _cProdCli, _cLoja,"Produto não Cadastrado nesta linha"})
						_lRet := .F.
					Endif

					If _lRet

						For F := 16 To 37

							If Val(_aLin[F]) > 0
								If F = 16
									_dDtEnt := dDataBase - GetMv("CR_KOMATRA")
								Else
									_dDtEnt := cTod(_aCabec[1][F])
								Endif

								// Criamos um vetor com os dados para facilitar o manuseio dos dados
								_aCampos := {}
								aAdd( _aCampos, { 'Z4_CODCLI'	, _cCliente     	} )
								aAdd( _aCampos, { 'Z4_LOJA'  	, _cLoja			} )
								aAdd( _aCampos, { 'Z4_PRODPAS' 	, _cProduto			} )
								aAdd( _aCampos, { 'Z4_PRODCLI'  , _cProdCli    		} )
								aAdd( _aCampos, { 'Z4_DTMOV'  	, dDataBase     	} )
								aAdd( _aCampos, { 'Z4_DTATU'  	, dDataBase     	} )
								aAdd( _aCampos, { 'Z4_ULTNF'  	, _cNF          	} )
								aAdd( _aCampos, { 'Z4_DTENT'  	, _dDtEnt			} )
								aAdd( _aCampos, { 'Z4_QTENT'  	, Val(_aLin[F])		} )
								aAdd( _aCampos, { 'Z4_PEDIDO'  	, _cPed          	} )
								If F < 27
									aAdd( _aCampos, { 'Z4_TPPED'  	, 'N'          } )							
								Else
									aAdd( _aCampos, { 'Z4_TPPED'  	, 'Z'          } )
								Endif
								aAdd( _aCampos, { 'Z4_DTDIGIT'  , dDataBase		} )
								aAdd( _aCampos, { 'Z4_ALTTEC'  	, _cRevisao     } )

								//Grava na tabela SZ4
								If !U_CR0070( 'SZ4', _aCampos,'CR0068' )
									_lRet := .F.
								EndIf
							Endif

						Next F

					Endif
					_lRet := .T.
					_cLoja := _cProduto := _cProdCli := _cNF := _cRevisao := ''

				Endif

				FT_FSKIP()

			EndDo

		End Transaction

		FT_FUSE()

	Else

		ApMsgStop("Não foi possível a abrir o arquivo " + _cFile + ".","Atenção")
		_lRet := .F.

	EndIf

Return _lRet

/*
Desc:		Abre o arquivo para importacao.
Parametros 	cDir   	 - Diretorio em que os arquivos sao gravados.
cFile     - Nome do arquivo.
*/

Static Function OpenFile( _cDir, _cFile )

	Local _nHdl := -1
	Local _lRet := .T.

	_nHdl := fOpen( _cDir + _cFile, 0 )

	If _nHdl < 0
		_lRet := .F.
	Else
		fClose( _nHdl )
	EndIf

Return _lRet


Static Function A010PRTLOG(aLogErro) //Relatorio de Erro de Importação de Arquivo.

	Local cTitle	:=	"Relatório de Erros"

	MsgRun("Gerando relatório de erros, aguarde...",cTitle,{||  PrintRep(aLogErro, cTitle) })

Return Nil

/*
Desc.     	Impressao do relatorio.
Parametros 	ALogErro	- Array com log de erros.
cTitle	 	- Titulo do relatorio.
*/

Static Function PrintRep(aLogErro, cTitle)

	Local nLin		    := 535

	Private nPag   		:= 0
	Private nCol   		:= 30
	Private oPrint		:= NIL
	Private oFntCab		:= NIL
	Private oFntDet		:= NIL
	Private nMax		:= 3020

	DEFINE Font oFntCab		Name 'Tahoma'			Size 0, 11 Of oPrint
	DEFINE Font oFntDet		Name 'Tahoma'			Size 0, 10 Of oPrint

	oPrint := TMSPrinter():New( cTitle )

	If oPrint:Setup()	// Escolhe a impressora
		oPrint:SetPortrait()

		PrintCabec()

		PrintLogEr(nLin,aLogErro)

		Ms_Flush()
		oPrint:EndPage()
		oPrint:End()

		oPrint:Preview()
	EndIf

Return Nil



Static Function PrintCabec() //Impressao do cabecalho do relatorio.

	Local cPath	:= GetSrvProfString( 'STARTPATH', '' )

	If nPag > 0
		oPrint:EndPage() 		//Encerra a pagina atual
	EndIf

	oPrint:StartPage() 	   		//Inicia uma nova pagina
	nPag++

	//Cabeçalho - Dados Estáticos\\
	oPrint:Box(010,030,430,2375)

	oPrint:SayBitmap(020,1020, cPath + "lgrl01.bmp",350,250)
	oPrint:Say(080,1900,RptFolha + " " + TRANSFORM(nPag,'999999'),oFntCab )
	oPrint:Say(140,1900,RptDtRef + " " + Dtoc(Date()),oFntCab)
	oPrint:Say(350,0950,"Relatório de Erros Komatsu",oFntCab)

	//Monta o Box Cabeçalho Erro - Dados Estáticos\\
	oPrint:Box(450,030,3100,2375)

	//Monta o Cabeçalho Erro - Dados Estáticos\\
	oPrint:Say(465,130, "Linha")
	oPrint:Say(465,300, "Campo")
	oPrint:Say(465,600, "Loja")
	oPrint:Say(465,850, "Erro")

	//Monta a Linha do Dados Erro - Dados Estáticos\\
	oPrint:Line(520,030,520,2375)

Return Nil

/*
Desc.     ³Impressao do log de erro.
Parametros³ nLin	     - Linha de impressao.
³ ALogErro	 - Array com log de erros.
*/

Static Function PrintLogEr(nLin,aLogErro)

	Local nI := 1

	For nI := 1 To Len(aLogErro)
		If nLin > nMax
			PrintCabec()
			nLin := 535
		EndIf
		oPrint:Say(nLin,130,AllTrim(Transform(aLogErro[nI][1], '999999')),oFntDet) // NUMERO DA LINHA
		oPrint:Say(nLin,300,aLogErro[nI][2],oFntDet)    // CAMPO
		oPrint:Say(nLin,600,aLogErro[nI][3],oFntDet)    // LOJA
		oPrint:Say(nLin,850,aLogErro[nI][4],oFntDet)    // ERRO
		nLin += 55
	Next nI

Return Nil







Static Function Gera_PV()

	Private _nPula,_lPrim,_cItem,_cItemExp,_lAchou,_nPrcVen,_cNum,_lVerFat, _lIncSC6, _cPedido
	Private _lIncSC6 := .F.

	SZ4->(dbSetOrder(1))

	Private _lNAchou   := .F.
	_lFim      := .F.

	_lNAchou := .F.

	_cq  := "UPDATE "+RetSqlname("SD2")+" SET D2_PROGENT = 0 WHERE D2_CLIENTE = '"+_cCliente+"' AND D_E_L_E_T_ = '' "

	TCSQLEXEC(_cq)
	_cq1  := "UPDATE "+RetSqlname("SC6")+" SET C6_LA = '' WHERE C6_CLI = '"+_cCliente+"' AND D_E_L_E_T_ = '' "

	TCSQLEXEC(_cq1)

	_lEntr     := .F.
	_lPrim     := .F.
	_cItem     := "00"

	_cQuery := " SELECT * FROM "+RetSqlName("SZ4")+" Z4 "
	_cQuery += " WHERE Z4.D_E_L_E_T_ = '' AND Z4_CODCLI = '"+_cCliente+"' "
	_cQuery += " AND Z4_INTEGR = '' AND Z4_DTDIGIT = '"+DTOS(dDataBase)+"' "
	_cQuery += " ORDER BY Z4_DTDIGIT,Z4_PRODPAS,Z4_DTENT "

	TCQUERY _cQuery NEW ALIAS "ZZ4"

	TCSETFIELD("ZZ4","Z4_DTDIGIT","D")
	TCSETFIELD("ZZ4","Z4_DTATU","D")
	TCSETFIELD("ZZ4","Z4_DTULTNF","D")
	TCSETFIELD("ZZ4","Z4_DTENT","D")

	ZZ4->(dbGotop())

	While ZZ4->(!EOF())

		_cClieLoja := ZZ4->Z4_CODCLI + ZZ4->Z4_LOJA
		_cProdCli  := ZZ4->Z4_PRODCLI

		SZ2->(dbSetOrder(1))
		If SZ2->(!MsSeek(xFilial("SZ2")+ZZ4->Z4_CODCLI+ZZ4->Z4_LOJA+ZZ4->Z4_PRODPAS+ZZ4->Z4_PRODCLI+"1"))
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
		SB1->(MsSeek(xFilial("SB1")+ZZ4->Z4_PRODPAS))

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
		_cq3  := " UPDATE "+RetSqlname("SC6")+" SET C6_BLQ = 'R', C6_XDTELIM = '"+DTOS(dDataBase)+"', C6_LOCALIZ = 'CR0069' "
		_cq3  += " WHERE C6_LA <> 'OK' AND D_E_L_E_T_ = '' AND C6_PEDAMOS IN ('N','Z','I','M') AND C6_QTDENT < C6_QTDVEN "
		_cq3  += " AND C6_CLI = '"+_cCliente+"' "
		_cq3  += " AND C6_BLQ = '' AND C6_CPROCLI <> '' "
		_cq3  += " AND C6_LOJA <> '03' "
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
	If SF2->(MsSeek(xFilial("SF2")+ZZ4->Z4_ULTNF+"2  "))
		_cNF := ZZ4->Z4_ULTNF
		_lOk := .T.
	Endif

	If !_lOk
		SF2->(dbSetOrder(1))
		If SF2->(MsSeek(xFilial("SF2")+Substr(ZZ4->Z4_ULTNF,4,6)+"   "+"1  "))
			_cNF := Substr(ZZ4->Z4_ULTNF,4,6)+"   "
		Endif
	Endif

	If VAL(_cNF) > 0
		_cUltNf := _cNF + "01"
	Else
		_cUltNf := "000000001"
	Endif

	If ZZ4->Z4_PRODCLI = '0941502512'
		_lPare := .T.
	Endif

	SD2->(dbOrderNickName("INDSD23"))
	SD2->(MsSeek(xFilial("SD2")+ ZZ4->Z4_CODCLI + ZZ4->Z4_LOJA + ZZ4->Z4_PRODPAS + "2  " + _cUltNf,.T.))

	_cChav  := ZZ4->Z4_CODCLI + ZZ4->Z4_LOJA + ZZ4->Z4_PRODPAS

	While SD2->(!Eof()) .And. _cChav == SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD

		If SD2->D2_DOC <= _cNF
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
	If SC6->(MsSeek(xFilial("SC6")+ ZZ4->Z4_CODCLI + ZZ4->Z4_LOJA + ZZ4->Z4_PRODPAS + ZZ4->Z4_PRODCLI + ZZ4->Z4_PEDIDO + DTOS(ZZ4->Z4_DTENT)))

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

			If SC6->C6_LOCDEST != ZZ4->Z4_LOCDEST
				SC6->(dbSkip())
				Loop
			Endif

			SC6->(RecLock("SC6",.F.))
			SC6->C6_LA 		:= "OK"
			SC6->C6_IDENCAT := ZZ4->Z4_SEMATU
			If ZZ4->Z4_TPPED = "N"
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
		SA1->(MsSeek(xFilial("SA1")+ZZ4->Z4_CODCLI+ZZ4->Z4_LOJA))

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
		SF4->(MsSeek(xFilial("SF4")+SZ2->Z2_TES))

		SB1->(dbSetOrder(1))
		SB1->(MsSeek(xFilial("SB1")+ZZ4->Z4_PRODPAS))

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
		SC6->C6_PEDAMOS := ZZ4->Z4_TPPED
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
		If SA3->(MsSeek(xFilial("SA3")+SA1->A1_VEND))
			SC6->C6_COMIS1   := SA3->A3_COMIS
		Endif
		SC6->(MsUnlock())
	Endif

Return (Nil)


Static Function ZeraPed()

	_cChavSC6 := ZZ4->Z4_CODCLI + ZZ4->Z4_LOJA + ZZ4->Z4_PRODPAS + ZZ4->Z4_PRODCLI + ZZ4->Z4_PEDIDO

	_cq  := " UPDATE "+RetSqlname("SC6")+" SET C6_IDENCAT = '' WHERE '"+_cChavSC6+"' = C6_CLI + C6_LOJA + C6_PRODUTO + C6_CPROCLI "
	_cq  += " AND C6_QTDVEN > C6_QTDENT AND C6_BLQ = '' AND D_E_L_E_T_ = '' "

	TCSQLEXEC(_cq)

Return(Nil)
