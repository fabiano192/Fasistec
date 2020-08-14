#include "Totvs.ch"
#include "TopConn.ch"
#INCLUDE "TBICONN.CH"

/*/
Funçao    	³ 	CR0043
Data 		³ 	25.09.13
Descricao 	³ 	Importação das Programações de Entrega - Caterpillar Exportação(000017)
830 Planning Schedule with Release Capability
/*/

User Function CR0043()

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

	//LOCAL oDlg := NIL

	Conout('Inicio Programação Cat. Exportação - CR0043')

	PRIVATE cTitulo    	:= "Planning Schedule (830)"
	PRIVATE oPrn       	:= NIL
	PRIVATE _nData     	:= Space(3)
	Private _nQtPasy    := 0
	Private _nQtCate    := 0
	Private _cASN    	:= ''

	Private _cCATFold	:= GetMV("CR_CATFOLD")

	/*
	_nOpc := 0

	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
	@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL

	@ 010,017 SAY "Esta rotina tem por objetivo importar as Programações" 	OF oDlg PIXEL Size 150,010
	@ 020,017 SAY "de Entrega da Caterpillar - Exportação				"	OF oDlg PIXEL Size 150,010
	@ 050,017 SAY "Programa CR0043.PRW                           		" 	OF oDlg PIXEL Size 150,010

	@ 15,165 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
	@ 40,165 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc = 1
	*/
		Private cArq
		Private _cAnexo

		U_CR0041() 	//Aloca os arquivos nas pastas corretas.
		CR043A() 	//Processa os arquivos
		CR043C() 	//Integra os Pedidos
		CR043D() 	//Gera arquivo excel

		Conout('Fim Programação Cat. Exportação - CR0043')
		//Endif

		Return(Nil)



Static Function CR043A(_lFim)

	Local B, F, nI

	Private _cPedido,_cRelease,_cProdCli2,_cControl,_cPOLine
	Private	_cCliente,_cLoja,_cDtCode,_cProdCli,_cRevisao
	Private _aFST := {}
	Private	_nQtAcumu := _nQTUlRec := 0
	Private _dDtAcumu := _dDtUlRec := _dDtMov := cTod("  /  /  ")
	Private _cCond

	aStru := {}
	AADD(aStru,{"INDICE"   , "C" , 01 , 0 })
	AADD(aStru,{"PRODCLI"  , "C" , 15 , 0 })
	AADD(aStru,{"CLIENTE"  , "C" , 06 , 0 })
	AADD(aStru,{"LOJA"     , "C" , 02 , 0 })
	AADD(aStru,{"DTCODE"   , "C" , 10 , 0 })
	AADD(aStru,{"ASN"  	   , "C" , 15 , 0 })
	AADD(aStru,{"PRODUTO"  , "C" , 15 , 0 })
	AADD(aStru,{"PEDCLI"   , "C" , 20 , 0 })
	AADD(aStru,{"REVISAO"  , "C" , 05 , 0 })

	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "INDICE+PRODUTO+PRODCLI+CLIENTE+LOJA+DTCODE"
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

	_cDir := _cCATFold+"Exportacao\Download\830\"

	aListFile	:= Directory( _cDir + '*.txt' )

	ProcRegua(Len( aListFile ))

	For nI:=1 To Len( aListFile )

		IncProc()

		Private cFile := AllTrim(aListFile[nI][1])
		Private _lBKP := .F.

		FT_FUSE( _cDir + cFile )
		FT_FGOTOP()

		Do While !FT_FEOF()

			cBuffer := FT_FREADLN()

			cBuffer := STRTRAN(cBuffer,'*',' *')

			aLin := StrTokArr( cBuffer , "*" )

			If Len(aLin) > 0

				If Alltrim(aLin[1]) == 'ISA'		//Interchange Control Header
					/*
					ISA02	:= Authorization Information Qualifier
					ISA03	:= Authorization Information
					ISA04	:= Security Information Qualifier
					ISA05	:= Security Information
					ISA06	:= Interchange ID Qualifier
					ISA07	:= Interchange Sender ID
					ISA08	:= Interchange ID Qualifier
					ISA09	:= Interchange Receiver Qualifier
					ISA10	:= Interchange Date
					ISA11	:= Interchange Time
					ISA12	:= Interchange Control Standarts Identifier
					ISA13	:= Interchange Control Version Number
					ISA14	:= Interchange Control Number
					ISA15	:= Acknowledgement Request
					ISA16	:= Test Indicator
					ISA17	:= Subelement Separator
					*/

					If Alltrim(aLin[17]) == 'T' //Se for Teste
						FT_FUSE() //Fecha o arquivo
						_lBKP := .F.
						Exit
					Endif

					_dDtMov := cTod(Right(Alltrim(aLin[10]),2)+'/'+Substr(Alltrim(aLin[10]),3,2)+'/'+Left(Alltrim(aLin[10]),2))

				ElseIf Alltrim(aLin[1]) == 'GS' 	//Functional Group Header
					/*
					GS02 := Functional Identifier Code
					GS03 := Application Sender's Code
					GS04 := Application Reciever's Code
					GS05 := Data Interchange Date
					GS06 := Data Interchange Time
					GS07 := Data Interchange Control Number
					GS08 := Responsible Agency Code
					GS09 := Version / Realease / Industry Identifier Code
					*/

				ElseIf Alltrim(aLin[1]) == 'ST'	//Transaction Set Header
					/*
					ST02 := Transaction Set Identifier Code
					ST03 := Transaction Set Control Number
					*/

					If Alltrim(aLin[2]) != '830' //Se não for Purchase Order
						FT_FUSE() //Fecha o arquivo
						_lBKP := .F.
						Exit
					Endif

				ElseIf Alltrim(aLin[1]) == 'BFR'	//Beginning Segment for Planning Schedule
					/*
					BFR02 := Transaction Set Purpose Code
					BFR03 := ?
					BFR04 := Release Number
					BFR05 := Schedule Type Qualifier
					BFR06 := Schedule Quantity Qualifier
					BFR07 := Date
					BFR08 := Date
					BFR09 := Date
					BFR10 := ?
					BFR11 := ?
					BFR12 := Purchase Order Number
					*/

					_cPedido    := Alltrim(aLin[12])
					_cControl   := Strzero(Val(Alltrim(aLin[4])),5)

					If Alltrim(_cPedido) = '5550003399' // .and. _cRelease = '5'
						_lstop := .T.
					Endif
				ElseIf Alltrim(aLin[1]) == 'N1'	//Name
					/*
					N102 := Entity Identifier Code
					PN	-	Party to receive shipping notice
					SF	-	Ship From
					ST	-	Ship To
					SU	-	Supplier/Manufacturer

					N103 := Name
					N104 := Identification Code Qualifier
					N105 := Identification Code
					*/

					If Alltrim(aLin[2]) == 'PN'
						_cASN := '005070479'+Alltrim(Alltrim(aLin[5]))
					Elseif Alltrim(aLin[2]) == 'ST'
						_cDtCode := Alltrim(aLin[5])
						SA1->(dbOrderNickname('INDSA13'))
						If SA1->(dbSeek(xFilial('SA1')+ _cDtCode))
							_cCliente := SA1->A1_COD
							_cLoja    := SA1->A1_LOJA
						Else
							_cCliente := Space(6)
							_cLoja    := Space(2)
						Endif

					Elseif Alltrim(aLin[2]) == 'SU'
					Endif

				ElseIf Alltrim(aLin[1]) == 'N2'	//Additional Name Information
				ElseIf Alltrim(aLin[1]) == 'N3'	//Address Information
				ElseIf Alltrim(aLin[1]) == 'N4'	//Geographic Infomation
				ElseIf Alltrim(aLin[1]) == 'PER'//Administrative Communications Contact
				ElseIf Alltrim(aLin[1]) == 'LIN'//Item Identification
					/*
					LIN02 := Assigned Identification
					LIN03 := Product/Service ID Qualifier
					BP	-	Buyer's Part Number
					DR	-	Drawing Revision Number
					EC	-	Engineering Change Level
					ON	-	Customer Order Number
					PD	-	Part Number Description
					RN	-	Release Number
					VP	-	Vendor's(Seller's) Part Number
					LIN04 := Product/Service ID
					*/
					_cPOLine := Alltrim(aLin[2])
					If Len(aLin) > 3
						For F := 3 To Len(aLin)
							If F%2 > 0 //ImPar
								If Alltrim(aLin[F]) == 'BP'
									_cProdCli2 := Alltrim(aLin[F+1])
									_cProdCli  := ''
									For B:= 1 To Len(_cProdCli2)
										If Substr(_cProdCli2,B,1) != "-"
											_cProdCli += Substr(_cProdCli2,B,1)
										Endif
									Next B
								Elseif Alltrim(aLin[F]) == 'DR'
								Elseif Alltrim(aLin[F]) == 'EC'
									_cRevisao := Alltrim(aLin[F+1])
								Elseif Alltrim(aLin[F]) == 'ON'
								Elseif Alltrim(aLin[F]) == 'PD'
								Elseif Alltrim(aLin[F]) == 'RN'
									_cRelease	:= Strzero(Val(Alltrim(aLin[F+1])),4)
								Elseif Alltrim(aLin[F]) == 'VP'
								Endif
							Endif
						Next F
					Endif
				ElseIf Alltrim(aLin[1]) == 'UIT'//Unit Detail
				ElseIf Alltrim(aLin[1]) == 'MEA'//Measurements
				ElseIf Alltrim(aLin[1]) == 'SDP'//Ship/Delivery Pattern
				ElseIf Alltrim(aLin[1]) == 'FST'//Forecast Schedule

					/*
					FST02 := Quantity
					FST03 := Forecast Qualifier
					C	-	Firm
					D	-	Planning
					FST04 := Forecast Timing Qualifier
					FST05 := Date
					FST06 := ?
					FST07 := ?
					FST08 := ?
					FST09 := Reference Number Qualifier
					FST10 := Reference Number
					*/

					_dDEnt	:= cTod(Right(Alltrim(aLin[5]),2)+'/'+Substr(Alltrim(aLin[5]),3,2)+'/'+Left(Alltrim(aLin[5]),2))
					AADD(_aFST,{Val(Alltrim(aLin[2])),Alltrim(aLin[3]),_dDEnt})

				ElseIf Alltrim(aLin[1]) == 'ATH'	//Resource Authorization
				ElseIf Alltrim(aLin[1]) == 'SHP'	//Shipped/Received Information

					/*
					SHP02 := Quantity Quyalifier
					01	-	Discrete Quantity
					02	-	Cumulative Quantity
					SHP03 := Quantity
					SHP04 := Date/Time Qualifier
					SHP05 := Date
					SHP06 := ?
					SHP07 := Date
					*/

					If Alltrim(aLin[2]) == '01'
						If Alltrim(aLin[4]) == '035'
							_nQTUlRec   := Val(Alltrim(aLin[3]))
							_dDtUlRec	:= cTod(Right(Alltrim(aLin[5]),2)+'/'+Substr(Alltrim(aLin[5]),3,2)+'/'+Left(Alltrim(aLin[5]),2))
						Endif
					Elseif Alltrim(aLin[2]) == '02'
						If Alltrim(aLin[4]) == '004'
							_nQtAcumu   := Val(Alltrim(aLin[3]))
							_dDtAcumu	:= cTod(Right(Alltrim(aLin[7]),2)+'/'+Substr(Alltrim(aLin[7]),3,2)+'/'+Left(Alltrim(aLin[7]),2))
						Endif
					Endif
				ElseIf Alltrim(aLin[1]) == 'NTE'	//Note/Special Instruction
				ElseIf Alltrim(aLin[1]) == 'CTT'	//Transactions Total
					_lBKP := .T.
					CR043B()
					If Empty(_cCliente)
						_lBKP := .F.
					Endif
					_cPedido  := _cRelease := _cCliente := _cLoja    := _cDtCode := _cProdCli := _cProdCli2 := _cRevisao := _cControl := _cPOLine := ''
					_aFST     := {}
					_nQtAcumu := _nQTUlRec := 0
					_dDtAcumu := _dDtUlRec := cTod("  /  /  ")

				ElseIf Alltrim(aLin[1]) == 'SE'	//Transaction Set Trailer
				ElseIf Alltrim(aLin[1]) == 'GE'	//Functional Group Trailer
				ElseIf Alltrim(aLin[1]) == 'IEA'	//Interchange Control Trailer
				Endif

			Endif

			FT_FSKIP()

		EndDo

		FT_FUSE()

		If _lBKP
			_cData    := GravaData(dDataBase,.f.,8)
			_cHora    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

			__CopyFile( _cDir +cFile, _cDir+"BKP\"+cFile )
			//			__CopyFile( _cDir +cFile, _cDir+"BKP\"+_cData+_cHora+"_"+cFile )
			FErase(_cDir +cFile)
		Endif

	Next NI

Return


Static Function CR043B()

	Local B
	//	_cq2  := " UPDATE "+RetSqlName("EE8")+" SET EE8_SLDATU = 0 "
	//	_cQ2  += " FROM "+RetSqlName("EE8")+" EE8 "
	//	_cQ2  += " INNER JOIN "+RetSqlName("SC6")+" C6 ON LEFT(EE8_PEDIDO,6) +EE8_FATIT = C6_NUM+C6_ITEM "
	//	_cQ2  += " WHERE C6_QTDENT = C6_QTDVEN AND C6_CLI = '000018' "
	//	_cQ2  += " AND C6.D_E_L_E_T_ = '' AND EE8.D_E_L_E_T_ = '' "
	//	_cQ2  += " AND EE8_SLDATU > 0 "
	//
	//	TCSQLEXEC(_cq2)

	If Alltrim(_cPedido) = '5550003399' //.and. _cRelease = '5'
		_lstop := .T.
	Endif

	SZ2->(dbSetOrder(8))
	If !SZ2->(dbSeek(xFilial("SZ2")+_cCliente + _cLOja + Left(_cProdCli+Space(15),15) + Left(_cPedido+Space(20),20) + "1"))

		If Empty(_cCliente)

			Begin Transaction

				TRB->(RecLock("TRB",.T.))
				TRB->INDICE  	:= '1' //Cliente não cadastrado
				TRB->DTCODE		:= _cDtCode
				TRB->ASN		:= _cASN
				TRB->(MsUnlock())
			End Transaction

			Begin Transaction
				TRB->(RecLock("TRB",.T.))
				TRB->INDICE  	:= '2' //Produto não Cadastrado
				TRB->CLIENTE 	:= _cCliente
				TRB->LOJA    	:= _cLoja
				TRB->DTCODE		:= _cDtCode
				TRB->PRODCLI 	:= _cProdCli
				TRB->PEDCLI  	:= _cPedido
				TRB->REVISAO  	:= _cRevisao
				TRB->(MsUnlock())
			End Transaction
		Else
			Begin Transaction

				TRB->(RecLock("TRB",.T.))
				TRB->INDICE  	:= '2' //Produto não Cadastrado
				TRB->CLIENTE 	:= _cCliente
				TRB->LOJA    	:= _cLoja
				TRB->DTCODE		:= _cDtCode
				TRB->PRODCLI 	:= _cProdCli
				TRB->PEDCLI  	:= _cPedido
				TRB->REVISAO  	:= _cRevisao
				TRB->(MsUnlock())
			End Transaction
		Endif

		_lBKP := .F.

	Else

		SZ2->(RecLock("SZ2",.F.))
		SZ2->Z2_POLINE := _cPOLine
		SZ2->(MsUnLock())

		If Alltrim(SZ2->Z2_REVISAO) == Alltrim(_cRevisao)

			_cProdPasy := SZ2->Z2_PRODUTO

			If !Empty(_cRelease)
				_cCond := 'Val(Alltrim(SZ2->Z2_RELEASE)) < Val(_cRelease)'
			Else
				_cCond := '.T.'
			Endif

			If &(_cCond)
				Begin Transaction
					SZ2->(RecLock("SZ2",.F.))
					SZ2->Z2_RELEASE  := _cRelease
					SZ2->Z2_PCCODE   := _cProdCli2
					SZ2->(MsUnLock())
				End Transaction

				For B:= 1 To Len(_aFST)
					Begin Transaction

						SZ4->(RecLock("SZ4",.T.))
						SZ4->Z4_FILIAL  := xFilial("SZ4")
						SZ4->Z4_CODCLI  := _cCliente
						SZ4->Z4_LOJA    := _cLoja
						SZ4->Z4_PRODPAS := _cProdPasy
						SZ4->Z4_PRODCLI := _cProdCli
						SZ4->Z4_CONTROL := _cControl
						SZ4->Z4_DTULTNF := _dDtUlRec
						SZ4->Z4_DTENT   := _aFST[B,3]
						SZ4->Z4_QTENT   := _aFST[B,1]
						SZ4->Z4_PEDIDO  := _cPedido
						SZ4->Z4_TPPED   := If(_aFST[B,2] = 'C', 'N', 'Z')
						SZ4->Z4_DTDIGIT := dDataBase
						SZ4->Z4_DTMOV   := _dDtMov
						SZ4->Z4_NOMARQ  := cFile
						SZ4->Z4_QTACUM  := _nQtAcumu
						SZ4->Z4_ALTTEC  := _cRelease
						SZ4->Z4_ALTENG  := _cRevisao
						SZ4->Z4_INTEGR  := "N"
						SZ4->Z4_POLINE  := _cPOLine
						SZ4->(MsUnlock())
					End Transaction
				Next B
			Endif
		Else
			Begin Transaction

				TRB->(RecLock("TRB",.T.))
				TRB->INDICE  	:= '3' //Revisão Não cadastrada
				TRB->CLIENTE 	:= _cCliente
				TRB->LOJA    	:= _cLoja
				TRB->DTCODE		:= _cDtCode
				TRB->PRODCLI 	:= _cProdCli
				TRB->PEDCLI  	:= _cPedido
				TRB->REVISAO  	:= _cRevisao
				TRB->(MsUnlock())
			End Transaction

			_lBKP := .F.

		Endif
	Endif

Return




Static Function CR043C(_lFim)

	Local i

	Private _nPula,_lPrim,_cItem,_cItemExp,_lAchou,_nPrcVen,_cNum,_lVerFat, _lIncSC6, _cPedido
	Private _lIncSC6  := .F.
	Private _nTotQt   := 0
	Private _lNAchou  := .F.
	Private _lFim     := .F.

	_cq  := " SELECT * FROM "+RetSqlName("SZ4")+" Z4 "
	_cq  += " WHERE Z4.D_E_L_E_T_= '' AND Z4_CODCLI = '000018' "
	_cq  += " AND Z4_INTEGR = 'N' AND Z4_DTDIGIT = '"+dTos(dDatabase)+"' "
	_cq  += " ORDER BY Z4_CODCLI,Z4_LOJA,Z4_PRODCLI,Z4_PEDIDO,Z4_ALTENG,Z4_ALTTEC,Z4_DTENT "

	TCQUERY _cq NEW ALIAS "TSZ4"

	TCSETFIELD("TSZ4","Z4_DTDIGIT","D")
	TCSETFIELD("TSZ4","Z4_DTENT","D")

	TSZ4->(dbGotop())

	While !TSZ4->(EOF())

		ProcRegua(RecCount())

		_lPrim     := .F.
		_nTotQt    := 0
		_cItem     := "00"
		_cItemExp  := 0
		_cClieLoja := TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA

		While TSZ4->(!Eof()) .And.	_cClieLoja == TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA

			IncProc()

			_cProdCli := TSZ4->Z4_PRODCLI
			_cOrdCom  := TSZ4->Z4_PEDIDO
			_lVerFat  := .t.
			_cChave   := TSZ4->Z4_PRODCLI + TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PEDIDO + TSZ4->Z4_ALTENG + TSZ4->Z4_ALTTEC

			If TSZ4->Z4_PEDIDO = '5550003464'// .And. Alltrim(TSZ4->Z4_ALTTEC) = '5'
				_lstop := .T.
			Endif

			_nQtPasy  := _nQtCate := 0
			QTPED()
			ELIMR()

			While TSZ4->(!Eof()) .And. _cChave == TSZ4->Z4_PRODCLI + TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PEDIDO + TSZ4->Z4_ALTENG + TSZ4->Z4_ALTTEC

				If _lFim
					Alert("Cancelado Pelo Usuario!!!!!!")
					Return
				Endif

				_cKey := TSZ4->Z4_CODCLI+TSZ4->Z4_LOJA+TSZ4->Z4_PRODPAS+TSZ4->Z4_PRODCLI+TSZ4->Z4_PEDIDO+TSZ4->Z4_CONTROL

				_cCtrl := Soma1(Alltrim(TSZ4->Z4_CONTROL))
				SZ4->(dbSetOrder(10))
				If !SZ4->(dbSeek(xFilial("SZ4")+TSZ4->Z4_CODCLI+TSZ4->Z4_LOJA+TSZ4->Z4_PRODPAS+TSZ4->Z4_PRODCLI+TSZ4->Z4_PEDIDO+_cCtrl))

					SZ2->(dbSetOrder(8))
					SZ2->(dbSeek(xFilial("SZ2")+TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PRODCLI + Left(TSZ4->Z4_PEDIDO+Space(20),20) + "1"))

					_lAchou := .F.

					dDataRef := SZ2->Z2_DTREF01
					nValor   := SZ2->Z2_PRECO01
					For i := 2 to 12
						If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
							dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
							nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
						Endif
					Next i

					_nPreco  := nValor

					_nPrcVen := Round(_nPreco,5)

					If _nPrcVen == 0
						Alert("Produto "+TSZ4->Z4_PRODPAS+ " Sem Preco Cadastrado, Cadastrar no Produto x Cliente e no Pedido Gerado!!")
					Endif


					INTSC6C()

					SZ4->(dbSetOrder(1))
					If SZ4->(dbSeek(xFilial("SZ4")+TSZ4->Z4_CONTROL+TSZ4->Z4_CODCLI+TSZ4->Z4_LOJA+TSZ4->Z4_PRODCLI+Dtos(TSZ4->Z4_DTENT)+TSZ4->Z4_PEDIDO+'N'))
						Begin Transaction

							SZ4->(RecLock("SZ4",.F.))
							SZ4->Z4_INTEGR := "S"
							SZ4->(MsUnlock())

						End Transaction
					Endif
				Else

					_cq  := " UPDATE "+RetSqlName("SZ4")+" "
					_cQ  += " SET Z4_INTEGR = 'Y' "
					_cQ  += " WHERE Z4_CODCLI+Z4_LOJA+Z4_PRODPAS+Z4_PRODCLI+Z4_PEDIDO+Z4_CONTROL = '"+_cKey+"' "

					TCSQLEXEC(_cq)

					/*

					SZ4->(dbSetOrder(1))
					If SZ4->(dbSeek(xFilial("SZ4")+TSZ4->Z4_CONTROL+TSZ4->Z4_CODCLI+TSZ4->Z4_LOJA+TSZ4->Z4_PRODCLI+Dtos(TSZ4->Z4_DTENT)+TSZ4->Z4_PEDIDO+'N'))

						Begin Transaction

					SZ4->(RecLock("SZ4",.F.))
					SZ4->Z4_INTEGR := "Y"
					SZ4->(MsUnlock())
						End Transaction

					Endif

					*/
				Endif


				TSZ4->(dbSkip())
			EndDo
		EndDo
	EndDo

	TSZ4->(dbCloseArea())

Return



Static Function ELIMR()

	_cKey := TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PRODPAS + TSZ4->Z4_PRODCLI + TSZ4->Z4_PEDIDO
	/*
	_cq  := " SELECT * FROM "+RetSqlName("SC6")+" C6 " + CRLF
	_cq  += " WHERE C6_CLI + C6_LOJA + C6_PRODUTO + C6_CPROCLI + C6_PEDCLI = '"+_cKey+"' " + CRLF
	_cq  += " AND C6_QTDVEN > C6_QTDENT AND C6_BLQ = '' "
	_cq  += " AND Rtrim(C6_REVPED) <= '"+Rtrim(TSZ4->Z4_ALTTEC)+"' " + CRLF
	_cq  += " AND C6_PEDAMOS IN ('N','Z') AND C6.D_E_L_E_T_= '' " + CRLF
	*/

	_cq  := " SELECT * FROM "+RetSqlName("SC6")+" C6 " + CRLF
	_cq  += " WHERE C6_CLI 		= '"+TSZ4->Z4_CODCLI+"' " + CRLF
	_cq  += " AND C6_LOJA  		= '"+TSZ4->Z4_LOJA+"' " + CRLF
	_cq  += " AND C6_PRODUTO  	= '"+TSZ4->Z4_PRODPAS+"' " + CRLF
	_cq  += " AND C6_CPROCLI  	= '"+TSZ4->Z4_PRODCLI+"' " + CRLF
	_cq  += " AND C6_PEDCLI 	= '"+TSZ4->Z4_PEDIDO+"' " + CRLF
	_cq  += " AND C6_QTDVEN > C6_QTDENT AND C6_BLQ = '' "
	_cq  += " AND Rtrim(C6_REVPED) <= '"+Rtrim(TSZ4->Z4_ALTTEC)+"' " + CRLF
	_cq  += " AND C6_PEDAMOS IN ('N','Z') AND C6.D_E_L_E_T_= '' " + CRLF
	If SC6->(FieldPos("C6_XRESIDU")) > 0
		_cq  += " AND C6_XRESIDU <> 'N' "
	Endif

	TCQUERY _cq NEW ALIAS "TSC6"

	//	MemoWrite("D:\CR0043.TXT",_cq)

	TSC6->(dbGotop())

	While !TSC6->(EOF())

		_cKey1 := TSC6->C6_NUM + TSC6->C6_ITEM

		SC6->(dbSetOrder(1))
		If SC6->(dbSeek(xFilial('SC6')+_cKey1))
			Begin Transaction
				SC6->(RecLock("SC6",.F.))
				SC6->(dbDelete())
				SC6->(MsUnlock())
			End Transaction
		Endif

		SC9->(dbSetOrder(1))
		If SC9->(dbSeek(xFilial("SC9")+_cKey1 ))
			Begin Transaction
				SC9->(RecLock("SC9",.F.))
				SC9->(dbDelete())
				SC9->(MsUnLock())
			End Transaction
		Endif

		_cPedExp := ''
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek(xFilial("SC5")+TSC6->C6_NUM))
			_cPedExp := SC5->C5_PEDEXP
			Begin Transaction
				SC5->(RecLock("SC5",.F.))
				SC5->C5_LIBEROK  := ""
				SC5->(MsUnlock())
			End Transaction
		Endif

		//		SC6->(dbSetOrder(1))
		//		If !SC6->(dbSeek(xFilial('SC6')+TSC6->C6_NUM))
		//			SC5->(dbSetOrder(1))
		//			If SC5->(dbSeek(xFilial("SC5")+TSC6->C6_NUM))
		//				Begin Transaction
		//					SC5->(RecLock("SC5",.F.))
		//					SC5->(dbDelete())
		//					SC5->(MsUnlock())
		//				End Transaction
		//			Endif
		//		Endif

		EE8->(dbOrderNickName("INDEE81"))
		If EE8->(dbSeek(xFilial("EE8")+_cPedExp+TSC6->C6_ITEM))
			Begin Transaction
				EE8->(RecLock("EE8",.F.))
				EE8->(dbDelete())
				EE8->(MsUnlock())
			End Transaction
		Endif

		//		EE8->(dbOrderNickName("INDEE81"))
		//		If !EE8->(dbSeek(xFilial("EE8")+_cPedExp))
		//			EE7->(dbSetOrder(1))
		//			If EE7->(dbSeek(xFilial("EE7")+TSC6->C6_NUM))
		//				Begin Transaction
		//					EE7->(RecLock("EE7",.F.))
		//					EE7->(dbDelete())
		//					EE7->(MsUnlock())
		//				End Transaction
		//			Endif
		//		Endif

		TSC6->(dbSkip())
	EndDo

	TSC6->(dbCloseArea())

Return


Static Function QTPed()

	Local C

	_cKey := TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PRODPAS + TSZ4->Z4_PRODCLI + TSZ4->Z4_PEDIDO

	_nQtCate  := TSZ4->Z4_QTACUM

	SD2->(dbOrderNickName("INDSD25"))
	If SD2->(dbSeek(xFilial("SD2")+ TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PRODPAS + TSZ4->Z4_PRODCLI ))

		_cChav  := TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PRODPAS + TSZ4->Z4_PRODCLI

		While !SD2->(Eof()) .And. _cChav == SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD + SD2->D2_PROCLI

			_cPedido2  := ALLTRIM(SD2->D2_PEDCLI)
			_cPedido   := ""
			For C:= 1 To Len(Alltrim(_cPedido2))
				_cPedido  += Substr(_cPedido2,C,1)
			Next C

			If SD2->D2_QUANT == SD2->D2_QTDEDEV
				SD2->(dbSkip())
				Loop
			Endif

			_nQuanti := SD2->D2_QUANT - SD2->D2_QTDEDEV

			If ALLTRIM(TSZ4->Z4_PEDIDO) == ALLTRIM(_cPedido)
				_nQtPasy += _nQuanti
			Endif

			SD2->(dbSkip())
		EndDo
	Endif

	SZD->(dbSetOrder(2))
	If SZD->(dbSeek(xFilial("SZD")+_cKey))

		ProcRegua(LastRec())

		While !SZD->(Eof()) .And. _cKey == SZD->ZD_CLIENTE + SZD->ZD_LOJA + SZD->ZD_PRODUTO + SZD->ZD_CODCLI  + SZD->ZD_PEDCLI

			If SZD->ZD_TIPO == "1"
				_nQtPasy +=  SZD->ZD_QUANT
			Else
				_nQtPasy -=  SZD->ZD_QUANT
			Endif

			SZD->(dbSkip())
		EndDo
	Endif

Return


Static Function IntSC6C()

	If _nQtPasy < _nQtCate
		_nQtPasy += TSZ4->Z4_QTENT
		_nDif    := _nQtPasy  - _nQtCate
		If _nQtPasy > _nQtCate
			_nQtPasy := _nQtCate
		Endif
	Else
		_nQtCate += TSZ4->Z4_QTENT
		_nDif    := _nQtCate  - _nQtPasy
		If _nQtCate > _nQtPasy
			_nQtCate := _nQtPasy
		Endif
	Endif

	If _nDif > 0
		If _nQtPasy > 0
			_nFatur  := _nDif
		Else
			_nFatur  := TSZ4->Z4_QTENT
		Endif
	Else
		_nFatur   := _nDif
	Endif

	If _nFatur > 0
		_lVerFat  := .F.
		_cItem    := SomaIt(_cItem)
		_cItemExp ++

		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+TSZ4->Z4_CODCLI+TSZ4->Z4_LOJA))

		_cCodCli  := SA1->A1_COD
		_cLoja    := SA1->A1_LOJA
		_cNome    := SA1->A1_NOME

		If !_lPrim .Or. _cItem == "Z1"
			_cItem    := "01"
			_cItemExp := 1
			_cNum     := GETSXENUM("SC5","C5_NUM")
			CONFIRMSX8()
			_lPrim := .T.

			_cPedido := _cNum
			_lIncSC6 := .F.
			_cEnd1    := SA1->A1_END
			_cLoja    := SA1->A1_LOJA
			_cNome    := SA1->A1_NOME
			_cCodCli  := SA1->A1_COD
			_cEnd1a   := EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,,2)

			Begin Transaction
				dbSelectArea("SC5")
				RecLock("SC5",.T.)
				SC5->C5_FILIAL  := xFilial("SC5")
				SC5->C5_NUM     := _cNum
				SC5->C5_TIPO    := "N"
				SC5->C5_CLIENTE := TSZ4->Z4_CODCLI
				SC5->C5_LOJAENT := TSZ4->Z4_LOJA
				SC5->C5_LOJACLI := TSZ4->Z4_LOJA
				SC5->C5_TRANSP  := SA1->A1_TRANSP
				SC5->C5_TIPOCLI := SA1->A1_TIPO
				SC5->C5_CONDPAG := SA1->A1_COND
				SC5->C5_TIPLIB  := "1"
				SC5->C5_VEND1   := SA1->A1_VEND
				SC5->C5_COMIS1  := SA1->A1_COMIS
				SC5->C5_EMISSAO := dDataBase
				SC5->C5_PESOL   := 1
				SC5->C5_MOEDA   := 2
				SC5->C5_TXMOEDA := 1
				SC5->C5_TPCARGA := "2"
				SC5->C5_PEDEXP  := _cNum
				SC5->(MsUnlock())
			End Transaction

			_cVia     := ""
			_cDestino := ""
			_cOrigem  := ""
			dbselectArea("SYR")
			dbSetOrder(1)
			If dbSeek(xFilial("SYR")+SA1->A1_DEST_1)
				_cVia     := SYR->YR_VIA
				_cDestino := SYR->YR_DESTINO
				_cOrigem  := SYR->YR_ORIGEM
			Endif

			_cCondPgt := ''
			_cDisPa   := 0
			_cDescPA  := ''
			SY6->(dbSetOrder(1))
			If SY6->(dbSeek(xFilial("SY6")+SA1->A1_CONDPAG))
				_cCondPgt := SY6->Y6_COD
				_cDisPa   := SY6->Y6_DIAS_PA

				SYP->(dbSetOrder(1))
				If SYP->(dbSeek(xFilial("SYP")+SZ9->Z9_CODMEMO))
					_cDescPA := Alltrim(SYP->YP_TEXTO)
				Endif
			Endif

			SA2->(dbSetOrder(1))
			If SA2->(dbSeek(xFilial("SA2")+"000000"))
				_cBairro  := Alltrim(SA2->A2_BAIRRO)
				_cMun     := Alltrim(SA2->A2_MUN)
				_cEst     := Alltrim(SA2->A2_EST)
				_cCep     := Alltrim(SA2->A2_CEP)
				_cEnd2    := SA2->A2_END
				_cName    := Alltrim(SA2->A2_NOME)
			Endif

			EE3->(dbsetOrder(1))
			EE3->(dbseek(xFilial("EE3")+"X"))

			Begin Transaction
				EE7->(RecLock("EE7",.T.))
				EE7->EE7_AMOSTR := "2"
				EE7->EE7_BELOJA := "01"
				EE7->EE7_BENEDE := _cName
				EE7->EE7_BENEF  := "000000"
				EE7->EE7_BRUEMB := "1"  // Peso da Embalagem
				EE7->EE7_CALCEM := "1"  // sempre "Volume"
				EE7->EE7_CONDPA := _cCondPgt
				EE7->EE7_DEST   := _cDestino
				EE7->EE7_DIASPA := _cDisPa
				EE7->EE7_DTPEDI := dDataBase
				EE7->EE7_DTPROC := dDataBase
				EE7->EE7_END2BE := _cBairro + " - " + _cMun + " - " + _cEst + " - Brazil - C.E.P " + _cCep
				EE7->EE7_END2IM := _cEnd1a
				EE7->EE7_ENDBEN := _cEnd2
				EE7->EE7_ENDIMP := _cEnd1
				EE7->EE7_EXLIMP := "2"
				EE7->EE7_FATURA := dDataBase
				EE7->EE7_FOLOJA := "01"
				EE7->EE7_FORN   := "000000"
				EE7->EE7_FRPPCC := "CC"
				EE7->EE7_IDIOMA := "INGLES-INGLES"
				EE7->EE7_IMLOJA := _cLoja
				EE7->EE7_IMPODE := _cNome
				EE7->EE7_IMPORT := _cCodCli
				EE7->EE7_CLIENT := _cCodCli
				EE7->EE7_CLLOJA := _cLoja
				EE7->EE7_INCOTE := "EXW"
				EE7->EE7_INCO2  := "EXW"
				EE7->EE7_MOEDA  := "US$"
				EE7->EE7_MPGEXP := "003"
				EE7->EE7_ORIGEM := _cOrigem
				EE7->EE7_PEDFAT := _cNum
				EE7->EE7_PEDIDO := _cNum
				EE7->EE7_PGTANT := "2"
				EE7->EE7_PRECOA := "1"
				EE7->EE7_RESPON := EE3->EE3_NOME
				EE7->EE7_RESPON := "PAULO R. T. FREITAS"
				EE7->EE7_STATUS := "B"
				EE7->EE7_STTDES := "Aguardando Faturamento"
				EE7->EE7_TIPCOM := "2"
				EE7->EE7_TIPCVL := "1"
				EE7->EE7_TIPTRA := "3"
				EE7->EE7_VIA    := _cVia
				EE7->EE7_DECQTD := 2
				EE7->EE7_DECPRC := 4
				EE7->EE7_DECPES := 3
				EE7->EE7_INTERM := "2"
				EE7->EE7_COND2  := _cCondPgt
				EE7->EE7_DIAS2  :=  _cDisPa
				EE7->EE7_GPV    := "S"
				//			_cCodMar        := GETIDMEMO()
				//			EE7->EE7_CODMAR := _cCodMar
				EE7_DESCPA 		:= _cDescPA
				EE7->(MsUnlock())
			End Transaction
		Endif

		Begin Transaction
			EE7->(RecLock("EE7",.F.))
			EE7->EE7_TOTITE := _cItemExp
			EE7->EE7_TOTPED += Round(( (_nFatur) * _nPrcVen ),2)
			EE7->(MsUnlock())
		End Transaction

		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xFilial("SF4")+SZ2->Z2_TES))

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+TSZ4->Z4_PRODPAS))

		Begin Transaction

			_cNumSC6 := _cIteSC6 := ""
			_lSC6    := .T.
			SC6->(dbOrderNickName('INDSC61'))
			If SC6->(MsSeek(xFilial('SC6')+TSZ4->Z4_CODCLI+TSZ4->Z4_LOJA+TSZ4->Z4_PRODPAS+TSZ4->Z4_PRODCLI+TSZ4->Z4_PEDIDO+dTos(TSZ4->Z4_DTENT)))
				If SC6->C6_QTDENT = 0 .And. SC6->C6_BLQ = ''
					_cNumSC6 := SC6->C6_NUM
					_cIteSC6 := SC6->C6_ITEM
					SC6->(RecLock("SC6",.F.))
					SC6->C6_PEDAMOS := TSZ4->Z4_TPPED
					SC6->C6_REVPED  := TSZ4->Z4_ALTTEC
					SC6->C6_REVENG  := TSZ4->Z4_ALTENG
					SC6->C6_QTDVEN  := _nFatur
					SC6->C6_PRCVEN  := _nPrcVen
					SC6->C6_VALOR   := Round(( (_nFatur) * _nPrcVen ),2)
					SC6->(MsUnlock())
					_lSC6    := .F.
				Endif
			Endif

			If _lSC6
				SC6->(RecLock("SC6",.T.))
				SC6->C6_FILIAL  := xFilial("SC6")
				SC6->C6_NUM     := _cNUm
				SC6->C6_ITEM    := _cItem
				SC6->C6_CPROCLI := TSZ4->Z4_PRODCLI
				SC6->C6_PRODUTO := TSZ4->Z4_PRODPAS
				SC6->C6_REVPED  := TSZ4->Z4_ALTTEC
				SC6->C6_REVENG  := TSZ4->Z4_ALTENG
				SC6->C6_QTDVEN  := _nFatur
				SC6->C6_PRCVEN  := _nPrcVen
				SC6->C6_VALOR   := Round(( (_nFatur) * _nPrcVen ),2)
				SC6->C6_ENTREG  := TSZ4->Z4_DTENT
				SC6->C6_PEDAMOS := TSZ4->Z4_TPPED
				SC6->C6_TES     := SZ2->Z2_TES
				_cCf        	:= "7"
				SC6->C6_CF      := _cCf + Substr(SF4->F4_CF,2,3)
				SC6->C6_UM      := SB1->B1_UM
				SC6->C6_PEDCLI  := TSZ4->Z4_PEDIDO
				SC6->C6_DESCRI  := SZ2->Z2_DESCCLI
				SC6->C6_LOCAL   := SB1->B1_LOCPAD
				SC6->C6_CLI     := TSZ4->Z4_CODCLI
				SC6->C6_LOJA    := TSZ4->Z4_LOJA
				SC6->C6_PRUNIT  := _nPrcVen
				SC6->C6_TPOP    := "F"
				SC6->C6_IDENCAT := DTOS(dDataBase)
				SC6->C6_CLASFIS := SUBSTR(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
				SA3->(dbSetOrder(1))
				If SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND))
					SC6->C6_COMIS1   := SA3->A3_COMIS
				Endif
				SC6->C6_POLINE := TSZ4->Z4_POLINE
				SC6->(MsUnlock())
			Endif
		End Transaction

		_nPosIPI := SB1->B1_POSIPI
		_cUM     := SB1->B1_UM

		_cTes    := ""
		_cDescZ2 := ""
		SZ2->(dbSetOrder(8))
		If SZ2->(dbSeek(xFilial("SZ2")+TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PRODCLI+TSZ4->Z4_PEDIDO+"1"))
			_cTes    := SZ2->Z2_TES
			_cDescZ2 := Alltrim(SZ2->Z2_DESCCLI)
		Endif

		Begin Transaction

			EE8->(dbOrderNickName('INDEE81'))
			If EE8->(MsSeek(xFilial('EE8')+_cNumSC6+Space(14)+_cIteSC6))
				EE8->(RecLock("EE8",.F.))
				EE8->EE8_TIPPED := TSZ4->Z4_TPPED
				EE8->EE8_REVPED := TSZ4->Z4_ALTTEC
				EE8->EE8_REVENG := TSZ4->Z4_ALTENG
				EE8->EE8_QE	    := _nFatur
				EE8->EE8_SLDATU := _nFatur
				EE8->EE8_SLDINI := _nFatur
				EE8->EE8_PRECO  := _nPrcVen
				EE8->EE8_PRECOI := _nPrcVen
				EE8->EE8_PRCINC := Round(( (_nFatur) * _nPrcVen ),2)
				EE8->EE8_PRCTOT := Round(( (_nFatur) * _nPrcVen ),2)
				EE8->EE8_POLINE := TSZ4->Z4_POLINE
				EE8->(MsUnlock())

			Else
				EE8->(RecLock("EE8",.T.))
				EE8->EE8_COD_I  := TSZ4->Z4_PRODPAS
				_cCodDes        := GETIDMEMO()
				EE8->EE8_DESC   := _cCodDes
				EE8->EE8_TIPPED := TSZ4->Z4_TPPED
				EE8->EE8_DTENTR := TSZ4->Z4_DTENT
				EE8->EE8_DTPREM := TSZ4->Z4_DTENT
				EE8->EE8_CODCLI := TSZ4->Z4_PRODCLI
				EE8->EE8_EMBAL1 := SZ2->Z2_CODEMB
				EE8->EE8_FABR   := "000000"
				EE8->EE8_FALOJA := "01"
				EE8->EE8_FATIT  := _cItem
				EE8->EE8_FOLOJA := "01"
				EE8->EE8_FORN   := "000000"
				EE8->EE8_PART_N := TSZ4->Z4_PRODCLI
				EE8->EE8_PEDIDO := _cNUm
				EE8->EE8_POSIPI := _nPosIPI
				EE8->EE8_PRCINC := Round(( (_nFatur) * _nPrcVen ),2)
				EE8->EE8_PRCTOT := Round(( (_nFatur) * _nPrcVen ),2)
				EE8->EE8_PRECO  := _nPrcVen
				EE8->EE8_PRECOI := _nPrcVen
				EE8->EE8_PSLQUN := SB1->B1_PESO
				EE8->EE8_QE	    := _nFatur
				EE8->EE8_QTDEM1 := 1
				EE8->EE8_REFCLI := TSZ4->Z4_PEDIDO
				EE8->EE8_SEQUEN := Padl(Alltrim(Str(_cItemExp)),6)
				EE8->EE8_SLDATU := _nFatur
				EE8->EE8_SLDINI := _nFatur
				EE8->EE8_UNPRC  := _cUM
				EE8->EE8_UNPES  := "KG"
				EE8->EE8_UNIDAD := _cUM
				EE8->EE8_CF     := _cCf + Substr(SF4->F4_CF,2,3)
				EE8->EE8_TES    := _cTes
				EE8->EE8_REVPED := TSZ4->Z4_ALTTEC
				EE8->EE8_REVENG := TSZ4->Z4_ALTENG
				EE8->EE8_POLINE := TSZ4->Z4_POLINE
				MSMM(EE8->EE8_DESC  ,,,Alltrim(SZ2->Z2_DESCCLI)       ,1,,,"EE8","EE8_DESC")
				EE8->(MsUnlock())
			Endif
		End Transaction

	Endif

	//	dbSelectArea("TSZ4")

Return


Static Function CR043D()

	Local oFwMsEx 		:= NIL
	Local cDir 			:= GetSrvProfString("Startpath","")
	Local cWorkSheet	:= ""
	Local cTable 		:= ""
	Local cDrive, cDirec, cNomeDir, cExt
	Local _cIndice

	/*
	Indice		Descrição
	1			Cliente não Cadastrado
	2			Produto Não cadastrado
	3			PO não cadastrado
	4			Revisão Não Cadastrado
	*/

	_lEnt   := .F.
	TRB->(dbGotop())

	While !TRB->(Eof())

		If !_lEnt
			oFwMsEx := FWMsExcel():New()
			_lEnt    := .T.
		Endif

		_cIndice := TRB->INDICE

		If _cIndice = "1"

			cWorkSheet 	:= 	"Cliente Não Cadastrado"
			cTable 		:= 	"Cliente não Cadastrado"

			oFwMsEx:AddWorkSheet( cWorkSheet )
			oFwMsEx:AddTable( cWorkSheet, cTable )

			oFwMsEx:AddColumn( cWorkSheet, cTable , "DTCODE"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "End.ASN"  			, 1,1,.F.)

		Else

			If _cIndice = "2"
				cWorkSheet 	:= 	"Produto não Cadastrado"
				cTable 		:= 	"Produto não Cadastrado"
			ElseIf _cIndice = "4"
				cWorkSheet 	:= 	"Revisão não Cadastrada"
				cTable 		:= 	"Revisão não Cadastrada"
			Endif

			oFwMsEx:AddWorkSheet( cWorkSheet )
			oFwMsEx:AddTable( cWorkSheet, cTable )

			oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "DTCODE"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto Cliente"	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Pedido Cliente"    , 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Revisão"   		, 1,1,.F.)

		Endif

		_cDTCode := ''

		While !TRB->(Eof()) .And. _cIndice == TRB->INDICE

			If _cIndice = "1"

				If _cDTCode = TRB->DTCODE
					TRB->(dbSkip())
					Loop
				Endif

				_cDTCode = TRB->DTCODE

				oFwMsEx:AddRow( cWorkSheet, cTable,{;
					TRB->DTCODE   	,;
					TRB->ASN		})

			Else

				oFwMsEx:AddRow( cWorkSheet, cTable,{;
					TRB->CLIENTE	,;
					TRB->LOJA    	,;
					TRB->DTCODE   	,;
					TRB->PRODCLI    ,;
					TRB->PEDCLI    	,;
					TRB->REVISAO    })
			Endif

			TRB->(dbSkip())
		EndDo
	EndDo

	TRB->(dbCloseArea())

	If _lEnt

		oFwMsEx:Activate()

		_cDat1    := GravaData(dDataBase,.f.,8)
		_cHor1    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

		cArq := _cDat1+'_'+_cHor1 + ".xls"

		_cAnexo := "\WORKFLOW\RELATORIOS\"+cArq

		oFwMsEx:GetXMLFile( _cAnexo )

		CR043E() 	//Envia e-mail

	Endif

Return



Static Function CR043E()

	Private _lRet

	nOpcao := 0

	CONOUT("Enviando E-Mail de Inconsitencia - CAT")

	CONOUT('{'+ _cAnexo+'}')

	oProcess := TWFProcess():New( "INCONS", "CAT - EXP" )
	aCond    :={}
	_nTotal  := 0

	oProcess:NewTask( "Inconsistencia", "\WORKFLOW\CR0043.HTM" )
	oProcess:bReturn  := ""
	oProcess:bTimeOut := ""

	oHTML := oProcess:oHTML

	oProcess:cSubject := "Relatório de Inconsistências - CAT - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

	oProcess:fDesc := "Relatório de Inconsistências - CAT"

	Private _cTo := _cCC := ""

	SZG->(dbsetOrder(1))
	SZG->(dbGotop())

	While SZG->(!EOF())

		If 'C1' $ SZG->ZG_ROTINA
			_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		ElseIf 'C2' $ SZG->ZG_ROTINA
			_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		Endif

		SZG->(dbSkip())
	Enddo

	oProcess:AttachFile(_cAnexo)

	oProcess:cTo := _cTo
	oProcess:cCC := _cCC

	oProcess:Start()

	oProcess:Finish()

	//	FErase(_cAnexo)

Return

