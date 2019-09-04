#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BRI015   ³ Autor ³ Alexandro da Silva    ³ Data ³ 09/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio SYS                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Exportar para o Sistema SYS                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BRI015()

	ATUSX1()

	_nOpc := 0
	DEFINE MSDIALOG oDlg TITLE "Rotina Gerar Rel. Sys"  From 10,0 TO 250,400 of oMainWnd PIXEL

	@ 0.5,0.5 TO 08.25,025

	@ 02,02 SAY "Rotina para exportar a Movimentacao Bancaria para o  "   SIZE 160,7
	@ 03,02 SAY "Sistema SYS, conforme Layout Pre-Definido e Parame-  "     SIZE 160,7
	@ 04,02 SAY "tros Informados Pelo Usuario.                        "     SIZE 160,7
	@ 05,02 SAY "No Diretorio C:\RELSYS                               "     SIZE 160,7

	@ 100,100  BMPBUTTON TYPE 5 ACTION Pergunte("BRI015")
	@ 100,130  BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 100,160  BMPBUTTON TYPE 2 ACTION oDlg:END()

	Activate Dialog oDlg Centered

	If _nOpc == 1

		_cDir:= "C:\RELSYS"

		If !ExistDir( _cDir )
			If MakeDir( _cDir ) <> 0
				MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
				Return
			EndIf
		EndIf

		Pergunte("BRI015",.F.)

		Private _cMsg01    := ''
		Private _lFim      := .F.
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| BRI14_01(@_lFim) }
		Private _cTitulo01 := 'Gerando Movimentacao !!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	Endif

Return

Static Function BRI14_01(_lFim)

	Local _aRateio := {}
	Local _lPare   := .F.

	Private cArqTxt := "\RELSYS\"+DTOS(DDATABASE)+".CSV"
	Private nHdl    := fCreate(cArqTxt)

	Private cEOL    := "CHR(13)+CHR(10)"
	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parâmetros.","Atencao!")
		Return
	Endif

	Private nTamLin, cLin, cCpo

	_cQ := " SELECT * FROM "+RetSqlName("SE5")+" A "
	_cQ += " INNER JOIN "+RetSqlName("SZF")+ " B ON E5_FILIAL=ZF_FILIAL AND E5_BANCO=ZF_COD AND E5_AGENCIA=ZF_AGENCIA AND E5_CONTA=ZF_NUMCON "
	_cQ += " INNER JOIN "+RetSqlName("SED")+" C ON E5_NATUREZ=ED_CODIGO"
	_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND E5_NATUREZ <> '' AND E5_BANCO <> '' "
	_cQ += " AND E5_DTDISPO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND E5_SITUACA = '' AND E5_RECONC <> '' "
	_cQ += " AND E5_TIPODOC NOT IN ('JR','MT','DC') AND E5_MOTBX NOT IN ('CMP') "
	_cQ += " ORDER BY E5_FILIAL,E5_DTDISPO "

	TCQUERY _cq NEW ALIAS "ZZ"

	TCSETFIELD("ZZ","E5_DTDISPO","D")

	_lPrim := .T.
	_nCont := 0

	ZZ->(dbGoTop())

	ProcRegua(ZZ->(U_CONTREG()))

	While ZZ->(!EOF())

		IncProc()

		nTamLin := 204
		cLin    := Space(nTamLin)+cEOL
		_nCont  := 0

		_cChavZZ := ZZ->E5_DTDISPO

		While ZZ->(!Eof()) .And. 	_cChavZZ == ZZ->E5_DTDISPO

			If _lPrim
				_lPrim := .F.

				_cDoc		:= "Documento"
				_cCusto		:= "Custo"
				_cCaixa		:= "Caixa"
				_cOrigem	:= "Origem"
				_cData		:= "Data"
				_cTipo		:= "Tipo"
				_cClas		:= "Classificação"
				_cValor		:= "Valor"
				_cHist		:= "Histórico"
				_cDocBx		:= "Doc Baixa"
				_cTrCaixa	:= "Transf Caixa"
				_cTrCusto	:= "Transf Custo"
				_cTrOrigem	:= "Transf Origem"
				_cStat		:= "Status"
				_cGrav		:= "Gravação"
				_cFil		:= "Filial"

				_lPare := GeraLine(_cDoc,_cCusto,_cCaixa,_cOrigem,_cData,_cTipo,_cClas,_cValor,_cHist,_cDocBx,_cTrCaixa,_cTrCusto,_cTrOrigem,_cStat,_cGrav,_cFil)

				If _lPare
					Return(Nil)
				Endif

			Endif

			If ZZ->E5_MOEDA == "TB" .And. ZZ->E5_RECPAG == "R"
				ZZ->(dbSkip())
				Loop
			Endif

			_nCont++

			_cDoc     := Left(Dtos(ZZ->E5_DTDISPO),6)+StrZero(_nCont,5)
			_cCaixa   := Alltrim(ZZ->ZF_CTACAIX)
			_cCusto   := Alltrim(ZZ->ZF_CTABANC)
			_cOrigem  := Alltrim(ZZ->ED_YCOD)
			_cData    := DTOC(ZZ->E5_DTDISPO)
			_cTrCaixa := ""
			_cTrCusto := ""
			_cTrOrigem:= ""

			If ZZ->E5_MOEDA = "TB"
				_cTipo    := "TRF"
				_nValor   := ZZ->E5_VALOR * - 1

				SE5->(dbOrderNickName("INDSE51"))
				If SE5->(dbSeek(ZZ->E5_FILIAL+"TR"+"R"+DTOS(ZZ->E5_DTDISPO)+ZZ->E5_NUMCHEQ))
					SZF->(dbSetOrder(1))
					If SZF->(dbSeek(SE5->E5_FILIAL + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA))
						_cTrCaixa := Alltrim(SZF->ZF_CTACAIX)
						_cTrCusto := Alltrim(SZF->ZF_CTABANC)
					Endif

					SED->(dbSetorder(1))
					If SED->(dbSeek(xFilial("SED")+SE5->E5_NATUREZ))
						_cTrOrigem := Alltrim(SED->ED_YCOD)
					Endif
				Endif

			ElseIf ZZ->E5_RECPAG == "R"
				_cTipo  := "REC"
				_nValor := ZZ->E5_VALOR
			ElseIf ZZ->E5_RECPAG == "P"
				_cTipo  := "DES"
				_nValor := ZZ->E5_VALOR * - 1
			Endif

			_cClas  := "OF"
			_cValor := Str(_nValor,17,02)
			_cValor := StrTran(_cValor, ".",",")

			_cHist  := ""
			If Empty(ZZ->E5_PARCELA)
				_cParc := "-"
			Else
				_cParc := "-"+ZZ->E5_PARCELA+"-"
			Endif

			_lRateio := .F.
			If Empty(ZZ->E5_TIPO) .And. !Empty(ZZ->E5_MOEDA)
				_cHist  := Lower(Alltrim(ZZ->E5_HISTOR))
			ElseIf !Empty(ZZ->E5_CLIENTE)

				_aAliSX2 := SX2->(GetArea())

				SX2->(dbSetorder(1))
				If SX2->(dbseek("SA1"))
					If SX2->X2_MODO == "C"
						_cFilial:= Space(02)
					Else
						_cFilial:= ZZ->E5_FILIAL
					Endif
				Endif

				RestArea(_aAliSX2)

				SA1->(dbSetOrder(1))
				If SA1->(dbSeek(_cFilial + ZZ->E5_CLIENTE + ZZ->E5_LOJA))
					If ZZ->E5_TIPODOC = "ES"
						_cHist := Lower("CANCELAMENTO BAIXA-"+ALLTRIM(SA1->A1_NREDUZ))
					Else
						_cHist := Lower(ZZ->E5_PREFIXO+"-"+Alltrim(ZZ->E5_NUMERO)+_cParc+ALLTRIM(SA1->A1_NREDUZ))
					Endif
				Endif
			ElseIf !Empty(ZZ->E5_FORNECE)

				_aAliSX2 := SX2->(GetArea())

				SX2->(dbSetorder(1))
				If SX2->(dbseek("SA2"))
					If SX2->X2_MODO == "C"
						_cFilial:= Space(02)
					Else
						_cFilial:= ZZ->E5_FILIAL
					Endif
				Endif

				RestArea(_aAliSX2)

				SA2->(dbSetOrder(1))
				If SA2->(dbSeek(_cFilial + ZZ->E5_FORNECE + ZZ->E5_LOJA))
					If ZZ->E5_TIPODOC = "ES"
						_cHist := Lower("CANCELAMENTO BAIXA-"+ALLTRIM(SA2->A2_NREDUZ))
					Else
						_cHist := Lower(ZZ->E5_PREFIXO+"-"+Alltrim(ZZ->E5_NUMERO)+_cParc+ALLTRIM(SA2->A2_NREDUZ))
					Endif
					If SA2->(FieldPos("A2_YRATEIO")) > 0
						If SA2->A2_YRATEIO = 'S'
							_lRateio := .T.
						Endif
					Endif
//					If ZZ->E5_FORNECE  = '003360'
//						_lRateio := .T.
//					Endif

				Endif
			Endif

			_aRateio	:= {}

			If _lRateio .And. ZZ->E5_RECPAG = 'P' .And. ZZ->E5_TIPO = 'NF'

				SD1->(dbSetOrder(1))
				If SD1->(msSeek(ZZ->E5_FILIAL+ZZ->E5_NUMERO+ZZ->E5_PREFIXO+ZZ->E5_FORNECE+ZZ->E5_LOJA))

					_cKey := ZZ->E5_FILIAL+ZZ->E5_NUMERO+ZZ->E5_PREFIXO+ZZ->E5_FORNECE+ZZ->E5_LOJA
					_nTot := 0

					While SD1->(!EOF()) .And. _cKey == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

						_cFilCC:= ZZ->E5_FILIAL

						If CTT->(FieldPos("CTT_YEMFIL")) > 0
							CTT->(dbsetOrder(1))
							If CTT->(msSeek(xFilial("CTT")+SD1->D1_CC))
								_cFilCC := Alltrim(CTT->CTT_YEMFIL)
							Endif
						Endif
//						If SD1->D1_CC = '0104'
//							_cFilCC := '01'
//						ElseIf SD1->D1_CC = '0110'
//							_cFilCC := '02'
//						ElseIf SD1->D1_CC = '0111'
//							_cFilCC := '03'
//						ElseIf SD1->D1_CC = '0112'
//							_cFilCC := '04'
//						ElseIf SD1->D1_CC = '0113'
//							_cFilCC := '05'
//						ElseIf SD1->D1_CC = '0114'
//							_cFilCC := '06'
//						ElseIf SD1->D1_CC = '0115'
//							_cFilCC := '07'
//						ElseIf SD1->D1_CC = '0117'
//							_cFilCC := '08'
//						ElseIf SD1->D1_CC = '0118'
//							_cFilCC := '09'
//						ElseIf SD1->D1_CC = '0120'
//							_cFilCC := '10'
//						ElseIf SD1->D1_CC = '0122'
//							_cFilCC := '10'
//						ElseIf SD1->D1_CC = '0123'
//							_cFilCC := '12'
//						ElseIf SD1->D1_CC = '0128'
//							_cFilCC := '13'
//						Endif

						_nTot += SD1->D1_TOTAL

						_nPos := aScan(_aRateio,{|x| x[1] = _cFilCC})
						If _nPos = 0
							AADD(_aRateio,{_cFilCC,SD1->D1_TOTAL})
						Else
							_aRateio[_nPos][2] += SD1->D1_TOTAL
						Endif

						SD1->(dbSkip())
					EndDo

				Endif

			Endif

			_cDocBx:= Space(09)
			_cStat := Space(06)
			_cGrav := DTOC(dDataBase)
			_cFil  := ZZ->E5_FILIAL

			If !Empty(_aRateio)

				ASORT(_aRateio, , , { | x,y | y[1] > x[1] })

				_lPare := .F.
				For _nRat := 1 to Len(_aRateio)

					_nPerc := _aRateio[_nRat][2] / _nTot

					_cValor := Str(_nValor*_nPerc,17,02)
					_cValor := StrTran(_cValor, ".",",")

					_lPare := GeraLine(_cDoc,_cCusto,_cCaixa,_cOrigem,_cData,_cTipo,_cClas,_cValor,_cHist,_cDocBx,_cTrCaixa,_cTrCusto,_cTrOrigem,_cStat,_cGrav,Right(_aRateio[_nRat][1],2))
					If _lPare
						Exit //Sair do For...Next
					Endif

				Next _nRat

			Else

				_lPare := GeraLine(_cDoc,_cCusto,_cCaixa,_cOrigem,_cData,_cTipo,_cClas,_cValor,_cHist,_cDocBx,_cTrCaixa,_cTrCusto,_cTrOrigem,_cStat,_cGrav,_cFil)

			Endif

			If _lPare
				Return(Nil)
			Endif

			ZZ->(dbSkip())
		EndDo
	EndDo

	ZZ->(dbcloseArea())

	fClose(nHdl)

	_cData   := DTOS(dDataBase)
	_cNomArq := "\RELSYS\"+_cData +".CSV"

	If !__CopyFile(_cNomArq, "C:\RELSYS\"+_cData +".CSV" )
		MSGAlert("O arquivo não foi copiado!", "AQUIVO NÃO COPIADO!")
	Endif

	If ! ApOleClient( 'MsExcel' )
		MsgStop('MsExcel nao instalado')

	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( "C:\RELSYS\"+_cData +".CSV" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	Endif

Return(Nil)


Static Function ATUSX1()

	cPerg := "BRI015"

	//    	   Grupo/Ordem/Pergunta   /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02               /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Data De     ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
	U_CRIASX1(cPerg,"02","Data Ate    ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

Return


Static Function GeraLine(_xDoc,_xCusto,_xCaixa,_xOrigem,_xData,_xTipo,_xClass,_xValor,_xHist,_xDocBx,_xTrfCx,_xTrfCu,_xTrfOr,_xStatus,_xGrava,_xFili)

	Local _lExit := .F.

	cCpo := PADR(_xDoc,11)+";"
	cLin := Stuff(cLin,01,12,cCpo)

	cCpo := PADR(_xCusto,07)+";"
	cLin := Stuff(cLin,13,08,cCpo)

	cCpo := PADR(_xCaixa,05)+";"
	cLin := Stuff(cLin,21,06,cCpo)

	cCpo := PADR(_xOrigem,10)+";"
	cLin := Stuff(cLin,27,11,cCpo)

	cCpo := PADR(_xData,10)+";"
	cLin := Stuff(cLin,38,11,cCpo)

	cCpo := PADR(_xTipo,04)+";"
	cLin := Stuff(cLin,49,05,cCpo)

	cCpo := PADR(_xClass,13)+";"
	cLin := Stuff(cLin,54,14,cCpo)

	cCpo := PADR(_xValor,17)+";"
	cLin := Stuff(cLin,68,18,cCpo)

	cCpo := PADR(_xHist,40)+";"
	cLin := Stuff(cLin,86,41,cCpo)

	cCpo := PADR(_xDocBx,09)+";"
	cLin := Stuff(cLin,127,10,cCpo)

	cCpo := PADR(_xTrfCx,12)+";"
	cLin := Stuff(cLin,137,13,cCpo)

	cCpo := PADR(_xTrfCu,12)+";"
	cLin := Stuff(cLin,150,13,cCpo)

	cCpo := PADR(_xTrfOr,13)+";"
	cLin := Stuff(cLin,163,14,cCpo)

	cCpo := PADR(_xStatus,06)+";"
	cLin := Stuff(cLin,177,07,cCpo)

	cCpo := PADR(_xGrava,10)+";"
	cLin := Stuff(cLin,184,11,cCpo)

	cCpo := PADR(_xFili,10)+";"
	cLin := Stuff(cLin,195,11,cCpo)

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgYesNo("Ocorreu um erro na gravacao do arquivo. Continua?")
			_lExit:= .T.
		Endif
	Endif

Return(_lExit)