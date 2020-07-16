#Include "Protheus.ch"
#include "topconn.ch"
#Include "RWMAKE.CH"
#Include "Xmlxfun.ch"
#include "tbiconn.ch"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
???Funcao    ? ECO001 ? Autor ?Alexandro da Silva     ? Data ? 27/04/17 ?????
?????????????????????????????????????????????????????????????????????????????
???Descricao ? EXPORTA CTB                                                ???
?????????????????????????????????????????????????????????????????????????????
??? Uso      ? Contabilidade                -                             ???
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function ECO001()

	ATUSX1()

	_nOpc := 0
	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Importa Mov.Contabil ")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Importacao do Movimento Contabil da Empresa         "     SIZE 160,7
	@ 18,18 SAY "                                                    "     SIZE 160,7
	@ 26,18 SAY "                                                    "     SIZE 160,7
	@ 34,18 SAY "                                                    "     SIZE 160,7

	@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("ECO001")
	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	Pergunte("ECO001",.F.)

	If _nOpc == 1

		Private _lFim      := .F.
		Private _cTitulo01 := 'Importando Saldo Inicial!!!'

		Processa( {|| ECO01_01() } , _cTitulo01, "Processando Saldos...",.T.)
	Endif

Return (Nil)


Static Function ECO01_01()

	local ni,_W, AX

	Pergunte("ECO001",.F.)

	_aEmp:= {{'A','0101','91'},{'A','0103','93'},{'B','0201','101'},{'B','0203','103'},{'B','0204','104'},{'C','0301','111'},{'C','0303','113'}}
	//_aEmp:= {{'B','0201','101'},{'B','0203','103'},{'B','0204','104'},{'C','0301','111'},{'C','0303','113'}}

	ProcRegua(Len(_aEmp))

	For AX:= 1 To Len(_aEmp)

		IncProc("Importando Saldos")

		_cEmp   := Left(_aEmp[AX][2],2)
		_cFil   := Right(_aEmp[AX][2],2)
		_cFilRM := _aEmp[AX][3]

		If MV_PAR03 == 1
			ECO01_01B(_cEmp,_cFil)
		ENDIF

		ECO01_01C(_cEmp,_cFil)

	Next AX

Return


Static Function ECO01_01B(_cEmp,_cFil)

	Local _cAlias    := ''
	Local _cModo
	Local _aArea     := GetArea()
	Local _aAreaCT2  := CT2->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _lOutEmp   := .F.

	_cQry := " SELECT CODCOLIGADA,CODFILIAL,DEBITO AS CONTA,SUM(VALOR) AS VALORD,0 AS VALORC "
	_cQry += " FROM [10.140.1.5].[CorporeRM].dbo.CPARTIDA A WHERE DATA < '2020' AND DEBITO <> '' "
	_cQry += " AND RTRIM(A.CODCOLIGADA)+RTRIM(CODFILIAL) IN ('"+_cFilRM+"') "
	_cQry += " GROUP BY CODCOLIGADA,CODFILIAL,DEBITO "
	_cQry += " UNION "
	_cQry += " SELECT CODCOLIGADA,CODFILIAL,CREDITO AS CONTA,0 AS VALORD,SUM(VALOR) AS VALORC "
	_cQry += " FROM [10.140.1.5].[CorporeRM].dbo.CPARTIDA A WHERE DATA < '2020' AND CREDITO <> '' "
	_cQry += " AND RTRIM(A.CODCOLIGADA)+RTRIM(CODFILIAL) IN ('91','93') "
	_cQry += " GROUP BY CODCOLIGADA,CODFILIAL,CREDITO "
	_cQry += " ORDER BY CODFILIAL,CONTA "

	Memowrite("C:\01\ECO001.txt",_cQry)

	TCQUERY _cQry New Alias "TRB"

	_cTabela:=  "CT2"+_cEmp+"0"
	If Alltrim(cEmpAnt) = _cEmp
		_cAlias := "CT2"

	Else
		If EmpOpenFile("TCT2","CT2",1,.T., _cEmp,@_cModo)
			_cAlias  := "TCT2"
			_lOutEmp := .T.
		Endif
	Endif

	aCampos := {}

	AADD(aCampos,{"EMPRESA" ,"C" ,02 ,0	})
	AADD(aCampos,{"FILIAL"	,"C" ,02 ,0	})
	AADD(aCampos,{"CONTA"   ,"C" ,20 ,0	})
	AADD(aCampos,{"SALDO"	,"N" ,17 ,2	})

	cArqTemp	:=	CriaTrab(aCampos)

	dbUseArea(.T.,,cArqTemp,"TRB2",.F.,.F.)

	IndRegua("TRB2",cArqTemp,"FILIAL + CONTA",,,"Indexando Dados")

	_cQ := "SELECT CONTADE,CLASSE,DESCRICAO,CTAPARA,ITEMPARA FROM CT1DPECO"

	TCQUERY _cQ NEW ALIAS "TMP"

	_cArq := CriaTrab(NIL,.F.)
	Copy To &_cArq

	dbCloseArea()

	dbUseArea(.T.,,_cArq,"TMP",.T.)
	_cInd := "CONTADE"
	IndRegua("TMP",_cArq,_cInd,,,"Selecionando Arquivo Trabalho")

	//TRB->(ProcRegua(U_CONTREG()))

	TRB->(dbGoTop())

	WHILE TRB->(!EOF())

		//IncProc("Importando Saldos")

		_cChave01 := Alltrim(cValToChar(TRB->CODFILIAL))

		WHILE TRB->(!EOF()) .And. _cChave01 == Alltrim(cValToChar(TRB->CODFILIAL))

			_cConta  := STRTRAN(TRB->CONTA,".","")
			_cCta    := TRB->CONTA
			_cChave02:= _cChave01 + _cCta
			_nSoma   := 0

			WHILE TRB->(!EOF()) .And. _cChave02 == _cChave01 + TRB->CONTA

				_nSoma += TRB->VALORD - TRB->VALORC

				TRB->(dbSkip())
			ENDDO


			If _nSoma <> 0
				TRB2->(RecLock("TRB2",.T.))
				TRB2->FILIAL  := _cChave01
				TRB2->CONTA   := _cConta
				TRB2->SALDO   := _nSoma
				TRB2->(MsUnLock())
			Endif
		ENDDO
	ENDDO

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTabela+ " FROM "+_cTabela+" WHERE CT2_FILIAL = '"+_cFil+"' AND CT2_DATA <= '20191231' "

		Memowrite("C:\01\ECODEL.txt",_cUpd)

		TCSQLEXEC(_cUpd )

		TRB2->(dbGoTop())
		_cLinha := "000"

		While TRB2->(!EOF())

			_cLinha := Soma1(_cLinha)

			_cConta := ""
			_cItem  := ""
			If TMP->(MsSeek(TRB2->CONTA))
				_cConta  := TMP->CTAPARA
				_cItem   := TMP->ITEMPARA
			ELSE
				_cConta  := "SEM CONTA"
			ENDIF

			(_cAlias)->(RecLock(_cAlias,.T.))
			(_cAlias)->CT2_FILIAL := _cFil
			(_cAlias)->CT2_DATA   := CTOD("31/12/19")
			(_cAlias)->CT2_LOTE   := "311219"
			(_cAlias)->CT2_SBLOTE := "001"
			(_cAlias)->CT2_DOC    := "000001"
			(_cAlias)->CT2_LINHA  := _cLinha

			If TRB2->SALDO > 0
				_nSoma                := TRB2->SALDO
				(_cAlias)->CT2_DC     := "1"
				(_cAlias)->CT2_DEBITO := _cConta
				(_cAlias)->CT2_ITEMD  := _cItem
				(_cAlias)->CT2_DEBBKP := TRB2->CONTA
			else
				_nSoma                 := TRB2->SALDO * -1
				(_cAlias)->CT2_DC 	   := "2"
				(_cAlias)->CT2_CREDITO := _cConta
				(_cAlias)->CT2_ITEMC   := _cItem
				(_cAlias)->CT2_CREBKP  := TRB2->CONTA
			Endif

			(_cAlias)->CT2_VALOR  := _nSoma
			(_cAlias)->CT2_MOEDLC := "01"
			(_cAlias)->CT2_HIST   := "SALDO INICIAL"
			(_cAlias)->CT2_MANUAL := "1"
			(_cAlias)->CT2_TPSALD := "1"
			(_cAlias)->CT2_AGLUT  := "2"
			(_cAlias)->CT2_ROTINA := "ECO001"
			(_cAlias)->CT2_SEQHIS := "001"
			(_cAlias)->(MsUnlock())

			TRB2->(dbSkip())
		EndDo
	ENDIF

	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt

	RestArea( _aAreaCT2 )
	RestArea( _aArea )

	If _lOutEmp
		TCT2->(dbCloseArea())
	ENDIF
	TRB->(dbCloseArea())
	TRB2->(dbCloseArea())
	TMP->(dbCloseArea())

Return()


Static Function ECO01_01C(_cEmp,_cFil)  // MOVIMENTOS CONT?BEIS

	Local _cAlias    := ''
	Local _cModo
	Local _aArea     := GetArea()
	Local _aAreaCT2  := CT2->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _lOutEmp   := .F.

	_cQry := " SELECT A.IDPARTIDA,A.IDLANCAMENTO,A.LCTREF,A.CODLOTEORIGEM,A.CODCOLIGADA,CODFILIAL,A.CODLOTEORIGEM,DOCUMENTO,DATA,DEBITO,CREDITO,PARTIDA,A.CODCCUSTO,A.CODHISTP,B.DESCRICAO,COMPLEMENTO,VALOR " +CRLF
	_cQry += " FROM [10.140.1.5].[CorporeRM].dbo.CPARTIDA A " +CRLF
	_cQry += " LEFT JOIN [10.140.1.5].[CorporeRM].dbo.CHISTP B ON A.CODCOLIGADA = B.CODCOLIGADA AND A.CODHISTP = B.CODHISTP " +CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.CLANCAMENTO C ON A.CODCOLIGADA = C.CODCOLIGADA AND A.CODLOTE = C.CODLOTE AND A.IDLANCAMENTO = C.IDLANCAMENTO " +CRLF
	_cQry += " AND LEFT(CONVERT(char(15), DATA, 23),4) + SUBSTRING(CONVERT(char(15), DATA, 23),6,2) + SUBSTRING(CONVERT(char(15), DATA, 23),9,2) BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "+CRLF
	_cQry += " AND RTRIM(A.CODCOLIGADA)+RTRIM(CODFILIAL) IN ('"+_cFilRM+"') " +CRLF
	_cQry += " ORDER BY CODCOLIGADA, CODFILIAL,DATA,IDLANCAMENTO " +CRLF

	Memowrite("C:\01\ECO003.txt",_cQry)

	TcQuery _cQry New Alias "TRB"

	_cTabela:=  "CT2"+_cEmp+"0"
	If Alltrim(cEmpAnt) = _cEmp
		_cAlias := "CT2"
	Else
		If EmpOpenFile("TCT2","CT2",1,.T., _cEmp,@_cModo)
			_cAlias  := "TCT2"
			_lOutEmp := .T.
		Endif
	Endif

	_cQ := "SELECT CONTADE,CLASSE,DESCRICAO,CTAPARA,ITEMPARA FROM CT1DPECO"

	TCQUERY _cQ NEW ALIAS "TMP"

	_cArq := CriaTrab(NIL,.F.)
	Copy To &_cArq

	dbCloseArea()

	dbUseArea(.T.,,_cArq,"TMP",.T.)
	_cInd := "CONTADE"
	IndRegua("TMP",_cArq,_cInd,,,"Selecionando Arquivo Trabalho")

	_cUpd := " DELETE "+_cTabela+ " FROM "+_cTabela+" WHERE CT2_FILIAL = '"+_cFil+"' "
	_cUpd += " AND CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

	Memowrite("C:\01\ECODELMOV.txt",_cUpd)

	TCSQLEXEC(_cUpd )

	TRB->(dbGoTop())

	While TRB->(!EOF())

		_cKey1 := Alltrim(cValToChar(TRB->CODCOLIGADA))

		While TRB->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TRB->CODCOLIGADA))

			_cKey2 := _cKey1 + dtos(TRB->DATA)

			While TRB->(!EOF()) .And. _cKey2 == Alltrim(cValToChar(TRB->CODCOLIGADA)) + DTOS(TRB->DATA)

				_cKey3 := _cKey2 + Alltrim(cValtoChar(TRB->IDLANCAMENTO))
				_cLinha:= "000"

				While TRB->(!EOF()) .And. _cKey3 == Alltrim(cValToChar(TRB->CODCOLIGADA)) + DTOS(TRB->DATA) + Alltrim(cValtoChar(TRB->IDLANCAMENTO))

					_cHist   := ALLTRIM(UPPER(TRB->DESCRICAO)) + ' - '+ALLTRIM(UPPER(TRB->COMPLEMENTO))
					_nCount  := 1
					_nQtdCar := TamSX3("CT2_HIST")[1]
					_nQtLine := MlCount(alltrim(_cHist),_nQtdCar)
					
					For _nH := 1 to _nQtLine

						_cHistor := MemoLine(Alltrim(_cHist),_nQtdCar,_nH)
						_cLinha  := Soma1(_cLinha)
						_cCRD    := ""
						_cCRC    := ""
						_cDocLan := PADR(Alltrim(cValtoChar(TRB->IDLANCAMENTO)),9,"0")

						If _nH = 1

							If !Empty(TRB->DEBITO) .And. Empty(TRB->CREDITO)
								_cDC  := "1"
								_cCRD := ""
							ElseIf Empty(TRB->DEBITO) .And. !Empty(TRB->CREDITO)
								_cDC  := "2"
								_cCRC := ""
							Else
								_cDC  := "3"
								_cCRD := ""
								_cCRC := ""
							Endif

							_cDebito   := ""
							_cCredito  := ""
							_cCtaDebRM := STRTRAN(TRB->DEBITO,".","")
							_cCtaCreRM := STRTRAN(TRB->CREDITO,".","")
							_cItemD    := ""
							_cItemC    := ""

							If !Empty(_cCtaDebRM)
								If TMP->(MsSeek(_cCtaDebRM))
									_cDebito  := TMP->CTAPARA
									_cItemD   := TMP->ITEMPARA
								ELSE
									_cDebito  := "SEM CONTA"
								ENDIF
							ENDIF

							If !Empty(_cCtaCreRM)
								If TMP->(MsSeek(_cCtaCreRM))
									_cCredito := TMP->CTAPARA
									_cItemC   := TMP->ITEMPARA
								else
									_cCredito := "SEM CONTA"
								ENDIF
							ENDIF

							(_cAlias)->(RecLock(_cAlias,.T.))
							//(_cAlias)->CT2_YID    := TRB->IDPARTIDA
							(_cAlias)->CT2_FILIAL := PadL(Alltrim(cValtoChar(TRB->CODFILIAL)),2,"0")
							(_cAlias)->CT2_DATA   := TRB->DATA
							(_cAlias)->CT2_LOTE   := RIGHT(DTOS(TRB->DATA),6)
							(_cAlias)->CT2_DOC    := Left(_cDocLan,6)
							(_cAlias)->CT2_SBLOTE := Right(_cDocLan,3)
							(_cAlias)->CT2_LINHA  := _cLinha
							(_cAlias)->CT2_MOEDLC := "01"
							(_cAlias)->CT2_DC     := _cDC
							(_cAlias)->CT2_DEBITO := _cDebito
							(_cAlias)->CT2_CREDIT := _cCredito
							(_cAlias)->CT2_DCD    := ""
							(_cAlias)->CT2_DCC    := ""
							(_cAlias)->CT2_ITEMD  := _cItemD
							(_cAlias)->CT2_ITEMC  := _cItemC
							(_cAlias)->CT2_VALOR  := TRB->VALOR
							(_cAlias)->CT2_HIST   := U_RM_NoAcento(_cHistor)
							(_cAlias)->CT2_EMPORI := _cEmp
							(_cAlias)->CT2_FILORI := _cFil
							(_cAlias)->CT2_TPSALD := "1"
							(_cAlias)->CT2_MANUAL := "1"
							(_cAlias)->CT2_ROTINA := "IMPORT"
							(_cAlias)->CT2_AGLUT  := "2"
							(_cAlias)->CT2_SEQHIS := "001"
							(_cAlias)->CT2_CRCONV := "1"
							(_cAlias)->CT2_DTCV3  := dDataBase
							(_cAlias)->CT2_DEBBKP := _cCtaDebRM
							(_cAlias)->CT2_CREBKP := _cCtaCreRM
							(_cAlias)->(MsUnlock())
						Else
							(_cAlias)->(RecLock(_cAlias,.T.))
							(_cAlias)->CT2_FILIAL := PadL(Alltrim(cValtoChar(TRB->CODFILIAL)),2,"0")
							(_cAlias)->CT2_DATA   := TRB->DATA
							(_cAlias)->CT2_LOTE   := PADL(Alltrim(cValtoChar(TRB->IDLANCAMENTO)),6,"0")
							(_cAlias)->CT2_DOC    := Left(_cDocLan,6)
							(_cAlias)->CT2_SBLOTE := Right(_cDocLan,3)
							(_cAlias)->CT2_LINHA  := _cLinha
							(_cAlias)->CT2_MOEDLC := "01"
							(_cAlias)->CT2_DC     := "4"
							(_cAlias)->CT2_HIST   := U_RM_NoAcento(_cHistor)
							(_cAlias)->CT2_TPSALD := "1"
							(_cAlias)->CT2_MANUAL := "1"
							(_cAlias)->CT2_AGLUT  := "2"
							(_cAlias)->CT2_SEQHIS := PADL(ALLTRIM(CVALTOCHAR(_nH)),3,"0")
							(_cAlias)->(MsUnLock())
						Endif
					Next _nH

					TRB->(dbSkip())
				EndDo
			EndDo
		EndDo
	EndDo

	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt

	RestArea( _aAreaCT2 )
	RestArea( _aArea )

	If _lOutEmp
		TCT2->(dbCloseArea())
	ENDIF
	TRB->(dbCloseArea())
	//TRB2->(dbCloseArea())
	TMP->(dbCloseArea())

Return()



Static Function ATUSX1()

	cPerg := "ECO001"
	aRegs := {}

//    	   Grupo/Ordem/Pergunta                /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01    /Def01            /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Data De?                ",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","Data Ate ?              ",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"03","Importa Saldo Inicial?  ",""       ,""      ,"mv_ch3","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR03","Sim"            ,""     ,""     ,""   ,""   ,"Nao"            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)