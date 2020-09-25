
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
Função			:	BRI084
Autor			:	Alexandro da Silva
Data 			: 	21/02/17
Descrição		: 	Atualiza Demonstrativo de Resultado (Tabela ZA5)
/*/

User Function BRI084(_lSched)

If _lSched == NIL
	Private _lSched := .F.
Else
	Private _lSched := .T.
Endif

//Private _lSched := .T.   // RETIRAR
Private dPartir := dDtAte := Ctod("  /  /  ")

If !_lSched
	
	PRIVATE oDlg := NIL
	PRIVATE cTitulo    	:= "Copiar Registros"
	PRIVATE _dFirstD,_dLastD
	PRIVATE cPerg   	:= "BRI084"
	
	Private _cMsg01    	:= ''
	Private _lFim      	:= .F.
	Private _lAborta01 	:= .T.
	Private _lSchedule  := If(_lSched = Nil, .F.,.T.)
	
	ATUSX1()
	
	_nOpc := 0
	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
	
	@ 010,017 SAY "Esta rotina tem por objetivo gerar os Dados     " OF oDlg PIXEL Size 150,010
	@ 020,017 SAY "Para o DEMONSTRATIVO DE RESULTADO Conforme      " OF oDlg PIXEL Size 150,010
	@ 040,017 SAY "Visao Gerencial.                                " OF oDlg PIXEL Size 150,010
	
	@ 35,167 BUTTON "Parametros" SIZE 036,012 ACTION (Pergunte("BRI084",.T.)) 	OF oDlg PIXEL
	@ 50,167 BUTTON "OK" 		  SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
	@ 65,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 				OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If _nOpc = 1
		
		Private _bAcao01       := {|_lFim| BRI084A(@_lFim) }    /// CONFORME SZQ VISAO 001
		Private _cTitulo01 := 'Processando...'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
		
		Private _bAcao01       := {|_lFim| BRI084B(@_lFim) }    /// CONFORME CONTABILIDADE VISAO 002
		Private _cTitulo01 := 'Processando...'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
		
		Private _bAcao01       := {|_lFim| BRI084C(@_lFim) }    /// CONFORME SD2 E SD1 VISAO 003
		Private _cTitulo01 := 'Processando...'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	Endif
Else
	BRI84_01(_lSched)
Endif

Return(Nil)


Static Function BRI84_01(_lSched)

LOcal AX
Private dPartir   := dDtAte := Ctod("  /  /  ")
Private cRevisao  := Space(4)
Private cFonteZZD := ''
Private cDoc      := Space(06)
Private cSerie    := Space(03)
Private cCliente  := Space(06)
Private cLoja     := Space(02)

If Select("SX2") == 0
	RpcSetType(3)
	RpcSetEnv("01","01",,,"COM",GetEnvServer(),{"ZZD"})
EndIf

//_aEmpresa := {"02","04","09","13","16","50"} 
_aEmpresa := {"04","13","16","50"}
_aFiliais := {}

For AX:= 1 To Len(_aEmpresa)
	
	_cEmpresa := _aEmpresa[AX]
	
	SM0->(dbSetOrder(1))
	If SM0->(dbSeek(_cEmpresa))
		
		_cChavSM0 := SM0->M0_CODIGO
		
		While SM0->(!Eof()) .And. _cChavSM0 == SM0->M0_CODIGO
			
			AADD( _aFiliais,{_cEmpresa,SM0->M0_CODFIL})
			
			SM0->(dbSkip())
		EndDo
	Endif
Next AX

For AX:= 1 To Len(_aFiliais)
	
	_cCodEmp  := Left(_aFiliais[AX],2)
	_cCodFil  := Right(_aFiliais[AX],2)
	
	If Select('SM0')>0
		nRecno := SM0->(Recno())
		RpcClearEnv()
	Endif
	
	OpenSM0()
	
	If SM0->(dbSeek(_cCodEmp + _cCodFil , .F. ) )
		RpcSetType(3)
		RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL,'schedule','schedule','FAT',,{"SZB"})
	Else
		CONOUT("NAO ACHOU EMPRESA ...")
		SM0->(dbGotop())
		dbCloseAll()
		RpcClearEnv()
	Endif
	
	CONOUT("ATUALIZANDO MAPINHA DA EMPRESA "+_aFiliais[AX][1]+" Filial: "+_aFiliais[AX][2])
	
	BRI084A(_lSched,_aFiliais[AX][1],_aFiliais[AX][2])
	BRI084B(_lSched,_aFiliais[AX][1],_aFiliais[AX][2])
	BRI084C(_lSched,_aFiliais[AX][1],_aFiliais[AX][2])
	CONOUT("ATUALIZADO  MAPINHA DA EMPRESA "+_aFiliais[AX][1]+" Filial: "+_aFiliais[AX][2])
	
Next AX

If _cCodEmp != cEmpAnt .And. _cCodFil != cFilAnt
	If Select("SX2") > 0
		CONOUT("Fechando Ambiente")
		RpcClearEnv()
	Endif
Endif

Return


Static Function BRI084A(_lSched,_cEmpSched,_cFilSched)

Local nRegCT2   := CT2->(Recno())
Local nRegCTS   := CTS->(Recno())
Local aStru		:= CTS->(DbStruct()), nI
Local cQuery
Local Ax
If !_lSched
	Pergunte("BRI084",.F.)
	
	_cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-1),4)
	_cAnoAnt := _cAno1 + "01"
	_cAnoFim := _cAno1 + "12"
	
Else
	MV_PAR01 := dDataBase
	
	_cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-30),4)
	_cAnoAnt := _cAno1 + "01"
	_cAnoFim := _cAno1 + "12"
	
	CONOUT(MV_PAR01)
Endif

_cVis1 := Alltrim(GetMv("AST_VISAO1"))

_cVisao := "('"
For Ax:= 1 To Len(_cVis1)
	If Substr(_cVis1,AX,1) != "*"
		_cVisao += Substr(_cVis1,AX,1)
	Else
		_cVisao += "','"
	Endif
Next AX

_cVisao += "')"

_dFirstD  := FirstDay(MV_PAR01)
_dLastD   := LastDay(MV_PAR02)

_cQ := " DELETE "+RetSqlName("ZA5")+" WHERE ZA5_CODEMP = '"+cEmpAnt+"' "
_cQ += " AND ZA5_PERIOD BETWEEN  '"+_cAnoAnt+"' AND '"+_cAnoFim+"' AND ZA5_CODPLA IN "+_cVisao+" "
TCSQLEXEC(_cQ)

_cQ := " DELETE "+RetSqlName("ZA5")+" WHERE ZA5_CODEMP = '"+cEmpAnt+"' "
_cQ += " AND ZA5_PERIOD BETWEEN '"+LEFT(DTOS(_dFirstD),6)+"' AND '"+LEFT(DTOS(_dLastD),6)+"' AND ZA5_CODPLA IN "+_cVisao+" "
TCSQLEXEC(_cQ)

_cQ := " SELECT * FROM "+RetSqlName("SZQ")+" AS A INNER JOIN "+RetSqlName("CTS")+" AS CTS ON "
_cQ += " ZQ_CONTA        BETWEEN CTS_CT1INI     AND CTS.CTS_CT1FIM  "
_cQ += " AND ZQ_YCC  	 BETWEEN CTS_CTTINI     AND CTS.CTS_CTTFIM  "
_cQ += " AND ZQ_ITEMCTA  BETWEEN CTS.CTS_CTDINI AND CTS.CTS_CTDFIM  "
_cQ += " AND ZQ_CLVL     BETWEEN CTS.CTS_CTHINI AND CTS.CTS_CTHFIM  "
_cQ += " WHERE A.D_E_L_E_T_ = '' AND CTS.D_E_L_E_T_ = '' AND ZQ_DTDIGIT  BETWEEN '"+DTOS(_dFirstD)+"' AND '"+DTOS(_dLastD)+"' "
_cQ += " AND CTS_SLDENT <> '3' AND ZQ_CODEMP = '"+cEmpAnt+"' AND ZQ_CODVISA IN "+_cVisao+" "
_cQ += " ORDER BY ZQ_DTDIGIT "

TCQUERY _cq NEW ALIAS "TRB2"

Memowrite("C:\TEMP\BRI084.txt",_cq)

TRB2->(dbgoTop())

ProcRegua(TRB2->(U_CONTREG()))

While TRB2->(!EOF())
	
	IncProc()
	
	_cPeriodo := LEFT(TRB2->ZQ_DTDIGIT,6)
	
	If TRB2->CTS_IDENT == "2"
		//_nValor   := TRB2->ZQ_TOTAL * - 1
		_nValor   := TRB2->ZQ_CUSCTB * - 1
	Else
		_nValor   := TRB2->ZQ_CUSCTB
	Endif
	
	ZA5->(dbSetorder(2))
	If ZA5->(dbSeek(xFilial("ZA5" ) + TRB2->ZQ_CODEMP + TRB2->ZQ_CODFIL + TRB2->CTS_CODPLA + TRB2->CTS_LINHA + TRB2->CTS_CONTAG + _cPeriodo ))
		ZA5->(RecLock("ZA5",.F.))
		ZA5->ZA5_VALOR	 += _nValor
		ZA5->(MsUnLock())
	Else
		ZA5->(RecLock("ZA5",.T.))
		ZA5->ZA5_FILIAL	 := xFilial("ZA5")
		ZA5->ZA5_CODEMP  := TRB2->ZQ_CODEMP
		ZA5->ZA5_CODFIL  := TRB2->ZQ_CODFIL
		ZA5->ZA5_CODPLA	 := TRB2->CTS_CODPLA
		ZA5->ZA5_LINHA	 := TRB2->CTS_LINHA
		ZA5->ZA5_CONTAG	 := TRB2->CTS_CONTAG
		ZA5->ZA5_DESCCG	 := TRB2->CTS_DESCCG
		ZA5->ZA5_VALOR	 := _nValor
		ZA5->ZA5_PERIOD  := _cPeriodo
		ZA5->(MsUnLock())
	Endif
	
	TRB2->(dbskip())
EndDo

TRB2->(dbCloseArea())

Return


Static Function BRI084B(_lSched)

Local nRegCT2   := CT2->(Recno())
Local nRegCTS   := CTS->(Recno())
Local aStru		 := CTS->(DbStruct()), nI
Local cQuery
Local Ax

If !_lSched
	Pergunte("BRI084",.F.)
	
	_cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-1),4)
	_cAnoAnt := _cAno1 + "01"
	_cAnoFim := _cAno1 + "12"
Else
	MV_PAR01 := dDataBase
	
	_cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-30),4)
	_cAnoAnt := _cAno1 + "01"
	_cAnoFim := _cAno1 + "12"
	
	CONOUT(MV_PAR01)
Endif

_cVis1  := Alltrim(GetMv("AST_VISAO2"))
_cVisao := "('"

For Ax:= 1 To Len(_cVis1)
	If Substr(_cVis1,AX,1) != "*"
		_cVisao += Substr(_cVis1,AX,1)
	Else
		_cVisao += "','"
	Endif
Next AX

_cVisao += "')"

_dFirstD  := FirstDay(MV_PAR01)
_dLastD   := LastDay(MV_PAR02)

_cQ := " DELETE "+RetSqlName("ZA5")+" WHERE ZA5_CODEMP = '"+cEmpAnt+"' "
_cQ += " AND ZA5_PERIOD BETWEEN  '"+_cAnoAnt+"' AND '"+_cAnoFim+"' AND ZA5_CODPLA IN "+_cVisao+" "
TCSQLEXEC(_cQ)

_cQ := " DELETE "+RetSqlName("ZA5")+" WHERE ZA5_CODEMP = '"+cEmpAnt+"' "
_cQ += " AND ZA5_PERIOD BETWEEN '"+LEFT(DTOS(_dFirstD),6)+"' AND '"+LEFT(DTOS(_dLastD),6)+"' AND ZA5_CODPLA IN "+_cVisao+" "
TCSQLEXEC(_cQ)

_cQ := " SELECT LEFT(CT2_DATA,6) AS CT2_PERIOD,CT2_FILIAL,CTS_CODPLA,CTS_LINHA,  CTS_CONTAG, CTS_DESCCG,  "
_cQ += " SUM(CASE CTS_IDENT WHEN 2 then CT2_VALOR ELSE (-1 * CT2_VALOR) END) AS VALOR "
_cQ += " FROM "+RetSqlName("CT2")+" AS CT2 JOIN "+RetSqlName("CTS")+" AS CTS ON "
_cQ += " (CT2_DEBITO	     BETWEEN CTS_CT1INI     AND CTS_CT1FIM )"
_cQ += " AND (CT2_CCD  	     BETWEEN CTS_CTTINI     AND CTS.CTS_CTTFIM )   "
_cQ += " AND (CT2.CT2_ITEMD  BETWEEN CTS.CTS_CTDINI AND CTS.CTS_CTDFIM  ) "
_cQ += " AND (CT2.CT2_CLVLDB BETWEEN CTS.CTS_CTHINI AND CTS.CTS_CTHFIM  ) "
_cQ += " AND CT2.CT2_TPSALD = CTS_TPSALD "
_cQ += " WHERE CT2.D_E_L_E_T_ = '' AND CT2.CT2_DATA BETWEEN '"+DTOS(_dFirstD)+"' AND '"+DTOS(_dLastD)+"' "
_cQ += " AND CTS.CTS_CODPLA IN "+_cVisao+" AND CTS.CTS_CLASSE = 2 "
_cQ += " AND CTS.D_E_L_E_T_ = ''  AND CT2_DC  IN ('1','3') "
_cQ += " AND CTS_SLDENT <> '3' AND CT2_MOEDLC = '01' "
_cQ += " GROUP BY LEFT(CT2_DATA,6),CT2_FILIAL,CTS.CTS_CODPLA,CTS_LINHA, CTS.CTS_CONTAG, CTS.CTS_DESCCG "
_cQ += " UNION "
_cQ += " SELECT LEFT(CT2_DATA,6) AS CT2_PERIOD,CT2_FILIAL,CTS_CODPLA, CTS_LINHA, CTS_CONTAG, CTS_DESCCG, "
_cQ += " SUM(CASE CTS_IDENT WHEN 2 then (-1 * CT2_VALOR) ELSE CT2_VALOR END) AS VALOR "
_cQ += " FROM "+RetSqlName("CT2")+" AS CT2 JOIN "+RetSqlName("CTS")+" AS CTS ON "
_cQ += " (CT2_CREDIT         BETWEEN CTS_CT1INI     AND CTS.CTS_CT1FIM ) "
_cQ += " AND (CT2_CCC  	     BETWEEN CTS_CTTINI     AND CTS.CTS_CTTFIM ) "
_cQ += " AND (CT2.CT2_ITEMC  BETWEEN CTS.CTS_CTDINI AND CTS.CTS_CTDFIM ) "
_cQ += " AND (CT2.CT2_CLVLCR BETWEEN CTS.CTS_CTHINI AND CTS.CTS_CTHFIM ) "
_cQ += " AND CT2_TPSALD = CTS.CTS_TPSALD "
_cQ += " WHERE CT2.D_E_L_E_T_ = '' AND CT2.CT2_DATA BETWEEN '"+DTOS(_dFirstD)+"' AND '"+DTOS(_dLastD)+"' "
_cQ += " AND CTS.CTS_CODPLA IN "+_cVisao+" AND CTS.CTS_CLASSE = 2 "
_cQ += " AND CTS.D_E_L_E_T_ = '' AND CT2_DC   IN ('2','3') "
_cQ += " AND CTS_SLDENT <> '3' AND CT2_MOEDLC = '01' "
_cQ += " GROUP BY CT2_FILIAL,LEFT(CT2_DATA,6),CTS.CTS_CODPLA, CTS_LINHA,CTS_CONTAG, CTS_DESCCG "
_cQ += " ORDER BY CT2_FILIAL,CTS_CODPLA,CTS_CONTAG "

TCQUERY _cq NEW ALIAS "TRB2"

Memowrite("C:\TEMP\BRI084D.txt",_cq)

TRB2->(dbgoTop())

ProcRegua(TRB2->(U_CONTREG()))

While TRB2->(!EOF())
	
	IncProc()
	
	_cPeriodo := TRB2->CT2_PERIOD
	_nValor   := TRB2->VALOR
	
	ZA5->(dbSetorder(2))
	If ZA5->(dbSeek(xFilial("ZA5" ) + cEmpAnt + TRB2->CT2_FILIAL + TRB2->CTS_CODPLA + TRB2->CTS_LINHA + TRB2->CTS_CONTAG + _cPeriodo ))
		ZA5->(RecLock("ZA5",.F.))
		ZA5->ZA5_VALOR	 += _nValor
		ZA5->(MsUnLock())
	Else
		ZA5->(RecLock("ZA5",.T.))
		ZA5->ZA5_FILIAL	 := xFilial("ZA5")
		ZA5->ZA5_CODEMP  := cEmpAnt
		ZA5->ZA5_CODFIL  := TRB2->CT2_FILIAL
		ZA5->ZA5_CODPLA	 := TRB2->CTS_CODPLA
		ZA5->ZA5_LINHA	 := TRB2->CTS_LINHA
		ZA5->ZA5_CONTAG	 := TRB2->CTS_CONTAG
		ZA5->ZA5_DESCCG	 := TRB2->CTS_DESCCG
		ZA5->ZA5_VALOR	 := _nValor
		ZA5->ZA5_PERIOD  := _cPeriodo
		ZA5->(MsUnLock())
	Endif
	
	TRB2->(dbskip())
EndDo

TRB2->(dbCloseArea())

aCampos := {}

AADD(aCampos,{"FILIAL"	    ,"C" ,02,0	})
AADD(aCampos,{"CODEMP"	    ,"C" ,02,0	})
AADD(aCampos,{"CODFIL"	    ,"C" ,02,0	})
AADD(aCampos,{"VISAO"	    ,"C" ,03,0	})
AADD(aCampos,{"IDENT"		,"C" ,01,0	})
AADD(aCampos,{"LINHA"	    ,"C" ,03,0	})
AADD(aCampos,{"ENTID"	    ,"C" ,20,0	})
AADD(aCampos,{"DESCR"	    ,"C" ,40,0	})
AADD(aCampos,{"PERIO"	    ,"C" ,06,0	})
AADD(aCampos,{"VALOR"	    ,"N" ,17,2	})

cArqTemp	:=	CriaTrab(aCampos)

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

dbUseArea(.T.,,cArqTemp,"TRB",.F.,.F.)

IndRegua("TRB",cArqTemp,"CODEMP + CODFIL + VISAO + LINHA + ENTID + PERIO",,,"Indexando Dados")

cQuery := " SELECT * FROM "+RetSqlName("CTS")+" CTS "
cQuery += " WHERE CTS.D_E_L_E_T_ = '' AND CTS_CODPLA IN "+_cVisao+" "
cQuery += " AND CTS_CT1INI <> '' AND CTS_FILIAL = '"+xFilial("CTS")+"' "
cQuery += " AND CTS_SLDENT =  '3' "
cQuery += " ORDER BY CTS_CODPLA,CTS_LINHA "

TCQUERY cQuery NEW ALIAS "NEWCTS"

For nI := 1 TO LEN(aStru)
	If aStru[nI][2] != "C"
		TCSetField("NEWCTS", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
	EndIf
Next

cNomeArq := CriaTrab(Nil,.F.)
IndRegua("NEWCTS",cNomeArq,"CTS_FILIAL+CTS_CODPLA+CTS_LINHA",,,"Selecionando Registros...")

NEWCTS->(dbGoTop())

ProcRegua(NEWCTS->(LASTREC()))

_aAliSM0 := SM0->(GetArea())

While NEWCTS->(!Eof())
	
	IncProc()
	
	SM0->(dbSetOrder(1))
	If SM0->(dbSeek(cEmpAnt))
		
		_cChavSM0 := SM0->M0_CODIGO
		
		While SM0->(!Eof()) .And. _cChavSM0 == SM0->M0_CODIGO
			
			_nSaldo  := 0
			_cAno    := Left(DTOS(MV_PAR01),4)
			_nMesFim := Month(MV_PAR01)
			_cFilial := SM0->M0_CODFIL
			
			For AX:= 1 TO _nMesFim
				
				CT1->(dbSetOrder(1))
				CT1->(dbSeek(xFilial("CT1")+NEWCTS->CTS_CT1INI,.T.))
				
				If CT1->CT1_CONTA  <= NEWCTS->CTS_CT1FIM
					
					_nDebito := _nCredito := _nSaldo := 0
					_cMonth  := STRZERO(AX,2)
					_dDt     := LASTDAY(STOD(_cAno+StrZero(AX,2)+"01"))
					
					While CT1->(!Eof()) .And. CT1->CT1_CONTA  <= NEWCTS->CTS_CT1FIM
						
						_aSldCT7  := SaldoCT7(CT1->CT1_CONTA,_dDt ,"01"  ,NEWCTS->CTS_TPSALD,"CTBXFUN",.F.      ,       ,_cFilial )
						_nSaldo   += (_aSldCT7[1])
						
						CT1->(dbSkip())
					EndDo
					
					_cSeek  := cEmpAnt + _cFilial + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cAno +_cMonth
					
					If !TRB->(dbSeek(_cSeek))
						TRB->(RecLock("TRB",.T.))
						TRB->CODEMP := cEmpAnt
						TRB->FILIAL := _cFilial
						TRB->IDENT  := NEWCTS->CTS_IDENT
						TRB->VISAO	:= NEWCTS->CTS_CODPLA
						TRB->LINHA	:= NEWCTS->CTS_LINHA
						TRB->ENTID	:= NEWCTS->CTS_CONTAG
						TRB->DESCR	:= NEWCTS->CTS_DESCCG
						TRB->PERIO  := _cAno+_cMonth
						TRB->VALOR  := _nSaldo
						TRB->(Msunlock("TRB"))
					Else
						TRB->(RecLock("TRB",.F.))
						TRB->VALOR  += _nSaldo
						TRB->(Msunlock("TRB"))
					Endif
				Endif
			Next
			
			SM0->(dbSkip())
		EndDo
	Endif
	
	NEWCTS->(dbSKIP())
EndDo

TRB->(dbgoTop())

While TRB->(!EOF())
	
	_nValor := TRB->VALOR
	
	ZA5->(dbSetorder(2))
	If ZA5->(dbSeek(xFilial("ZA5") + TRB->CODEMP + TRB->CODFIL + TRB->VISAO + TRB->LINHA + TRB->ENTID + TRB->PERIO ))
		ZA5->(RecLock("ZA5",.F.))
		ZA5->ZA5_VALOR	 += _nValor
		ZA5->(MsUnLock())
	Else
		ZA5->(RecLock("ZA5",.T.))
		ZA5->ZA5_FILIAL	 := xFilial("ZA5" )
		ZA5->ZA5_CODEMP  := TRB->CODEMP
		ZA5->ZA5_CODFIL  := TRB->CODFIL
		ZA5->ZA5_CODPLA	 := TRB->VISAO
		ZA5->ZA5_LINHA	 := TRB->LINHA
		ZA5->ZA5_CONTAG	 := TRB->ENTID
		ZA5->ZA5_DESCCG	 := TRB->DESCR
		ZA5->ZA5_VALOR	 := _nValor
		ZA5->ZA5_PERIOD  := TRB->PERIO
		ZA5->(MsUnLock())
	Endif
	
	TRB->(dbskip())
EndDo

TRB->(dbCloseArea())

NEWCTS->(dbCloseArea())

If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif

Return



Static Function BRI084C(_lSched)

Local nRegCT2   := CT2->(Recno())
Local nRegCTS   := CTS->(Recno())
Local aStru		:= CTS->(DbStruct()), nI
Local cQuery
Local Ax

If !_lSched
	Pergunte("BRI084",.F.)
	
	_cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-1),4)
	_cAnoAnt := _cAno1 + "01"
	_cAnoFim := _cAno1 + "12"
Else
	MV_PAR01 := dDataBase
	
	_cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-30),4)
	_cAnoAnt := _cAno1 + "01"
	_cAnoFim := _cAno1 + "12"
	
	CONOUT(MV_PAR01)
Endif

_cVis1  := Alltrim(GetMv("AST_VISAO3"))
_cVisao := "('"

For Ax:= 1 To Len(_cVis1)
	If Substr(_cVis1,AX,1) != "*"
		_cVisao += Substr(_cVis1,AX,1)
	Else
		_cVisao += "','"
	Endif
Next AX

_cVisao += "')"

_dFirstD  := FirstDay(MV_PAR01)
_dLastD   := LastDay(MV_PAR02)

_cQ := " DELETE "+RetSqlName("ZA5")+" WHERE ZA5_CODEMP = '"+cEmpAnt+"' "
_cQ += " AND ZA5_PERIOD BETWEEN  '"+_cAnoAnt+"' AND '"+_cAnoFim+"' AND ZA5_CODPLA IN "+_cVisao+" "

TCSQLEXEC(_cQ)

_cQ := " DELETE "+RetSqlName("ZA5")+" WHERE ZA5_CODEMP = '"+cEmpAnt+"' "
_cQ += " AND ZA5_PERIOD BETWEEN '"+LEFT(DTOS(_dFirstD),6)+"' AND '"+LEFT(DTOS(_dLastD),6)+"' AND ZA5_CODPLA IN "+_cVisao+" "

TCSQLEXEC(_cQ)

aCampos := {}

AADD(aCampos,{"FILIAL"	    ,"C" ,02,0	})
AADD(aCampos,{"CODEMP"	    ,"C" ,02,0	})
AADD(aCampos,{"CODFIL"	    ,"C" ,02,0	})
AADD(aCampos,{"VISAO"	    ,"C" ,03,0	})
AADD(aCampos,{"IDENT"		,"C" ,01,0	})
AADD(aCampos,{"LINHA"	    ,"C" ,03,0	})
AADD(aCampos,{"ENTID"	    ,"C" ,20,0	})
AADD(aCampos,{"DESCR"	    ,"C" ,40,0	})
AADD(aCampos,{"PERIO"	    ,"C" ,06,0	})
AADD(aCampos,{"VALOR"	    ,"N" ,17,2	})

cArqTemp	:=	CriaTrab(aCampos)

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

dbUseArea(.T.,,cArqTemp,"TRB",.F.,.F.)

IndRegua("TRB",cArqTemp,"CODEMP + CODFIL + VISAO + LINHA + ENTID + PERIO",,,"Indexando Dados")

cQuery := " SELECT * FROM "+RetSqlName("CTS")+" CTS "
cQuery += " WHERE CTS.D_E_L_E_T_ = '' AND CTS_CODPLA IN "+_cVisao+" "
cQuery += " AND CTS_FILIAL = '"+xFilial("CTS")+"' "
cQuery += " ORDER BY CTS_CODPLA,CTS_LINHA "

TCQUERY cQuery NEW ALIAS "NEWCTS"

//Memowrite("C:\TEMP\BRI084C.txt",cQuery)

For nI := 1 TO LEN(aStru)
	If aStru[nI][2] != "C"
		TCSetField("NEWCTS", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
	EndIf
Next

_cEmp := Left(cFilAnt,3)

cNomeArq := CriaTrab(Nil,.F.)
IndRegua("NEWCTS",cNomeArq,"CTS_FILIAL+CTS_CODPLA+CTS_LINHA",,,"Selecionando Registros...")

_cQ := " SELECT D2_FILIAL,D2_COD,B1_TIPO AS TP,LEFT(D2_EMISSAO,6) AS ANOMES,F4_DUPLIC AS GERAFIN,D2_PICM AS ALQICM,SUM(D2_QUANT) AS QUANT, SUM(D2_TOTAL) AS VALTOT, SUM(D2_VALIMP6) AS VALPIS, "
_cQ += " SUM(D2_VALIMP5) AS VALCOF,SUM(D2_VALICM) AS VALICM,SUM(D2_QUANT * D2_YPRG ) AS VALGER FROM "+RetSqlName("SD2")+" A "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" B ON D2_TES=F4_CODIGO "
_cQ += " INNER JOIN "+RetSqlName("SB1")+" C ON D2_COD=B1_COD  "
_cQ += " INNER JOIN "+RetSqlName("SBM")+" D ON B1_GRUPO = BM_GRUPO "
_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND D.D_E_L_E_T_ = '' "
_cQ += " AND D2_TIPO = 'N' AND BM_TIPGRU = '11' "
_cQ += " AND D2_EMISSAO BETWEEN '"+DTOS(_dFirstD)+"' AND '"+DTOS(_dLastD)+"' "
_cQ += " GROUP BY D2_FILIAL,D2_COD,B1_TIPO,LEFT(D2_EMISSAO,6),F4_DUPLIC,D2_PICM "
_cQ += " ORDER BY D2_FILIAL,D2_COD,B1_TIPO,LEFT(D2_EMISSAO,6) "

TCQUERY _cQ NEW ALIAS "ZZD2"

Memowrite("C:\TEMP\BRI084C.txt",_cQ)

TCSETFIELD("ZZD2","QUANT" ,"N",17,2)
TCSETFIELD("ZZD2","VALTOT","N",17,2)
TCSETFIELD("ZZD2","VALPIS","N",17,2)
TCSETFIELD("ZZD2","VALCOF","N",17,2)
TCSETFIELD("ZZD2","VALICM","N",17,2)
TCSETFIELD("ZZD2","VALGER","N",17,2)

_NVALPIS   := 0
_NVALCOF   := 0
_NVALICM   := 0
_NVALTOT   := 0
_NQTDTOT   := 0
_NVALPA    := 0
_NQTDTOPA  := 0
_NQTDM3PA  := 0

ZZD2->(dbGotop())

_ADADOS := {}

While ZZD2->(!Eof())
	
	_CEMP      := cEmpAnt
	_CFILIAL   := ZZD2->D2_FILIAL
	
	_nICMGER   := 0    // 12
	_nPISGER   := 0    // 13
	_nCOFGER   := 0    // 14
	
	If ZZD2->VALGER > 0
		
		_nTxPIS	:= SuperGetMV("MV_TXPIS")
		_nTxCOF	:= SuperGetMV("MV_TXCOFIN")
		
		If ZZD2->ALQICM = 0
			
			_nPICM := 0
			
			SX6->(dbSetOrder(1))
			If SX6->(dbSeek(_CFILIAL + "MV_ICMPAD" ))
				_nPICM := Val(SX6->X6_CONTEUD)
			EndIf
			
			_nICMGER   := Round(ZZD2->VALGER  * (_nPICM / 100) ,2)  // 12
		Else
			_nICMGER   := Round(ZZD2->VALGER  * (ZZD2->ALQICM / 100) ,2)  // 12
		Endif
		
		_nPISGER   := Round(ZZD2->VALGER * (_nTxPIS / 100) ,2)    // 13
		_nCOFGER   := Round(ZZD2->VALGER * (_nTxPIS / 100) ,2)    // 14
	Else
		_nPISGER   := ZZD2->VALPIS     // 13
		_nCOFGER   := ZZD2->VALCOF     // 14		
		_nICMGER   := ZZD2->VALICM		
	Endif
	
	_CANOMES   := ZZD2->ANOMES
	_CTP       := ZZD2->TP
	_CFIN      := ZZD2->GERAFIN
	
	_nPos      := ASCAN( _aDADOS,{|x| x[1] + x[2] + x[3] + x[4] + x[5] == _CEMP + _CFILIAL +_CANOMES + _CTP + _CFIN })
	
	If _nPos == 0     //  1       2          3      4    5       6            7           8           9            10              11            12       13      14
		AADD( _aDADOS,{_CEMP , _CFILIAL ,_CANOMES,_CTP ,_CFIN, ZZD2->QUANT,ZZD2->VALTOT,ZZD2->VALICM,ZZD2->VALPIS,ZZD2->VALCOF, ZZD2->VALGER,_nICMGER,_nPISGER,_nCOFGER })
	Else
		_aDADOS[_nPos][06] += ZZD2->QUANT
		_aDADOS[_nPos][07] += ZZD2->VALTOT
		_aDADOS[_nPos][08] += ZZD2->VALICM
		_aDADOS[_nPos][09] += ZZD2->VALPIS
		_aDADOS[_nPos][10] += ZZD2->VALCOF
		_aDADOS[_nPos][11] += ZZD2->VALGER
		
		_aDADOS[_nPos][12] += _nICMGER
		_aDADOS[_nPos][13] += _nPISGER
		_aDADOS[_nPos][14] += _nCOFGER
		
	Endif
	
	ZZD2->(dbSkip())
EndDo

ZZD2->(dbCloseArea())

_cQ := " SELECT D1_FILIAL,LEFT(D1_DTDIGIT,6) AS ANOMES,D1_CC,SUM(D1_QUANT) AS QUANT, SUM(D1_TOTAL) AS VALTOT, SUM(D1_VALIMP5) AS VALPIS, "
_cQ += " SUM(D1_VALIMP6) AS VALCOF,SUM(D1_VALICM) AS VALICM FROM "+RetSqlName("SD1")+" A "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" B ON D1_TES=F4_CODIGO "
_cQ += " INNER JOIN "+RetSqlName("SB1")+" C ON D1_COD=B1_COD  "
_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' "
_cQ += " AND D1_DTDIGIT BETWEEN '"+DTOS(_dFirstD)+"' AND '"+DTOS(_dLastD)+"' "
_cQ += " GROUP BY D1_FILIAL,LEFT(D1_DTDIGIT,6),D1_CC "
_cQ += " ORDER BY D1_FILIAL,LEFT(D1_DTDIGIT,6),D1_CC "

TCQUERY _cQ NEW ALIAS "ZZD1"

Memowrite("C:\TEMP\BRI084SD1.txt",_cQ)

TCSETFIELD("ZZD1","QUANT" ,"N",17,2)
TCSETFIELD("ZZD1","VALTOT","N",17,2)
TCSETFIELD("ZZD1","VALPIS","N",17,2)
TCSETFIELD("ZZD1","VALCOF","N",17,2)
TCSETFIELD("ZZD1","VALICM","N",17,2)

_cQ := " SELECT E2_FILIAL,E2_EMIS1,E2_BAIXA,SUM(E2_VALOR) AS VALOR FROM "+RetSqlName("SE2")+" A "
_cQ += " WHERE A.D_E_L_E_T_ = '' "
_cQ += " AND E2_TIPO IN  ('NF','DP','FT') "
_cQ += " AND E2_EMIS1   BETWEEN '"+DTOS(_dFirstD)+"' AND '"+DTOS(_dLastD)+"' AND E2_BAIXA <> '' "
_cQ += " GROUP BY E2_FILIAL,E2_EMIS1,E2_BAIXA"
_cQ += " ORDER BY E2_EMIS1 "

TCQUERY _cQ NEW ALIAS "ZZE2"

TCSETFIELD("ZZE2","E2_EMIS1"  ,"D",08)
TCSETFIELD("ZZE2","E2_BAIXA"  ,"D",08)
TCSETFIELD("ZZE2","VALOR"     ,"N",17,2)

_cQ := " SELECT E1_FILIAL,E1_EMISSAO,E1_BAIXA,SUM(E1_VALOR) AS VALOR FROM "+RetSqlName("SE1")+" A "
_cQ += " WHERE A.D_E_L_E_T_ = '' "
_cQ += " AND E1_TIPO IN  ('NF','DP','FT') "
_cQ += " AND E1_EMISSAO BETWEEN '"+DTOS(_dFirstD)+"' AND '"+DTOS(_dLastD)+"' AND E1_BAIXA <> '' "
_cQ += " GROUP BY E1_FILIAL,E1_EMISSAO,E1_BAIXA"
_cQ += " ORDER BY E1_EMISSAO "

TCQUERY _cQ NEW ALIAS "ZZE1"

TCSETFIELD("ZZE1","E1_EMISSAO" ,"D",08)
TCSETFIELD("ZZE1","E1_BAIXA"   ,"D",08)
TCSETFIELD("ZZE1","VALOR"      ,"N",17,2)

NEWCTS->(dbGoTop())

ProcRegua(NEWCTS->(LASTREC()))

_cANOMES:= LEFT(DTOS(MV_PAR01),6)

While NEWCTS->(!Eof())
	
	IncProc()
	
	_nValor := 0
	
	//                    1       2          3      4    5       6            7           8           9            10              11            12       13      14
	//	AADD( _aDADOS,{_CEMP , _CFILIAL ,_CANOMES,_CTP ,_CFIN, ZZD2->QUANT,ZZD2->VALTOT,ZZD2->VALICM,ZZD2->VALPIS,ZZD2->VALCOF, ZZD2->VALGER,_nICMGER,_nPISGER,_nCOFGER })
	
	If Alltrim(NEWCTS->CTS_CONTAG) = "1.01"
		For AX:= 1 to Len(_aDADOS)
			_cEmp    := _aDADOS[AX][01]
			_cFil    := _aDADOS[AX][02]
			_cAnoMes := _aDADOS[AX][03]
			_cVenda  := _aDADOS[AX][05]
			
			If _cVenda <> "S"
				Loop
			Endif
			
			_nValor  := _aDADOS[AX][07]
			
			_cSeek  := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODEMP := _cEmp
				TRB->CODFIL := _cFil
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "1.02"
		For AX:= 1 to Len(_aDADOS)
			
			_cEmp    := _aDADOS[AX][1]
			_cFil    := _aDADOS[AX][2]
			_cAnoMes := _aDADOS[AX][3]
			_nValor  := _aDADOS[AX][11]
			
			_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODEMP := _cEmp
				TRB->CODFIL := _cFil
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "1.05" // VOLUME EM TONELADA
		For AX:= 1 to Len(_aDADOS)
			_cEmp    := _aDADOS[AX][1]
			_cFil    := _aDADOS[AX][2]
			_cAnoMes := _aDADOS[AX][3]
			_nValor  := _aDADOS[AX][6]
			
			_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODEMP := _cEmp
				TRB->CODFIL := _cFil
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "1.06" // VOLUME EM M3  -- QUANTIDADE DA NOTA FISCAL DE VENDA
		For AX:= 1 to Len(_aDADOS)
			_cEmp    := _aDADOS[AX][01]
			_cFil    := _aDADOS[AX][02]
			_cAnoMes := _aDADOS[AX][03]
			_nValor  := _aDADOS[AX][06]  / GETMV("AST_FATCON")
			
			_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODEMP := _cEmp
				TRB->CODFIL := _cFil
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "1.09"   // FATURAMENTO DE SUCATA, TIPO DO PRODUTO "SP" --> EMPRESA PRINCIPAL
		For AX:= 1 to Len(_aDADOS)
			If _aDADOS[AX][4] == "SP"
				
				_cEmp    := _aDADOS[AX][01]
				_cFil    := _aDADOS[AX][02]
				_cAnoMes := _aDADOS[AX][03]
				_nValor  := _aDADOS[AX][06]
				
				_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
				
				If !TRB->(dbSeek(_cSeek))
					TRB->(RecLock("TRB",.T.))
					TRB->FILIAL	:= NEWCTS->CTS_FILIAL
					TRB->CODFIL := _cFil
					TRB->CODEMP := _cEmp
					TRB->VISAO	:= NEWCTS->CTS_CODPLA
					TRB->LINHA	:= NEWCTS->CTS_LINHA
					TRB->ENTID	:= NEWCTS->CTS_CONTAG
					TRB->DESCR	:= NEWCTS->CTS_DESCCG
					TRB->PERIO  := _cAnoMes
					TRB->VALOR  := _nValor
					TRB->(MsUnLock())
				Else
					TRB->(RecLock("TRB",.F.))
					TRB->VALOR  += _nValor
					TRB->(MsUnLock())
				Endif
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "1.11"   // FATURAMENTO DE LOCACAO, TIPO DO PRODUTO "LC" --> EMPRESA PRINCIPAL
		For AX:= 1 to Len(_aDADOS)
			If _aDADOS[AX][4] == "LC"
				_cEmp    := _aDADOS[AX][1]
				_cFil    := _aDADOS[AX][2]
				_cAnoMes := _aDADOS[AX][3]
				_nValor  := _aDADOS[AX][6]
				
				_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
				
				If !TRB->(dbSeek(_cSeek))
					TRB->(RecLock("TRB",.T.))
					TRB->FILIAL	:= NEWCTS->CTS_FILIAL
					TRB->CODFIL := _cFil
					TRB->CODEMP := _cEmp
					TRB->VISAO	:= NEWCTS->CTS_CODPLA
					TRB->LINHA	:= NEWCTS->CTS_LINHA
					TRB->ENTID	:= NEWCTS->CTS_CONTAG
					TRB->DESCR	:= NEWCTS->CTS_DESCCG
					TRB->PERIO  := _cAnoMes
					TRB->VALOR  := _nValor
					TRB->(MsUnLock())
				Else
					TRB->(RecLock("TRB",.F.))
					TRB->VALOR  += _nValor
					TRB->(MsUnLock())
				Endif
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "1.12" // FATURAMENTO DE LOCACAO, TIPO DO PRODUTO "LC" --> EMPRESA 02
		For AX:= 1 to Len(_aDADOS)
			If _aDADOS[AX][4] == "LC"
				_cEmp    := _aDADOS[AX][1]
				_cFil    := _aDADOS[AX][2]
				_cAnoMes := _aDADOS[AX][3]
				_nValor  := _aDADOS[AX][6]
				
				_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
				
				If !TRB->(dbSeek(_cSeek))
					TRB->(RecLock("TRB",.T.))
					TRB->FILIAL	:= NEWCTS->CTS_FILIAL
					TRB->CODFIL := _cFil
					TRB->CODEMP := _cEmp
					TRB->VISAO	:= NEWCTS->CTS_CODPLA
					TRB->LINHA	:= NEWCTS->CTS_LINHA
					TRB->ENTID	:= NEWCTS->CTS_CONTAG
					TRB->DESCR	:= NEWCTS->CTS_DESCCG
					TRB->PERIO  := _cAnoMes
					TRB->VALOR  := _nValor
					TRB->(MsUnLock())
				Endif
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "2.01" // PMR
		
		ZZE1->(dbgotop())
		
		While ZZE1->(!Eof())
			
			_cFilSE1 := ZZE1->E1_FILIAL
			
			While ZZE1->(!Eof()) .And. _cFilSE1 == ZZE1->E1_FILIAL
				
				_cAnoMes := LEFT(DTOS(ZZE1->E1_EMISSAO),6)
				_nTotVal := _nTotMed := 0
				
				While ZZE1->(!Eof()) .And. _cFilSE1 == ZZE1->E1_FILIAL .And. _cAnoMes == LEFT(DTOS(ZZE1->E1_EMISSAO),6)
					
					_nMedio  := (ZZE1->E1_BAIXA - ZZE1->E1_EMISSAO ) * ZZE1->VALOR
					
					_nTotVal += ZZE1->VALOR
					_nTotMed += _nMedio
					
					ZZE1->(dbSkip())
				EndDo
				
				_nPMP   := Round(_nTotMed / _nTotVal,2)
				_nValor := _nPMP
				
				_cEmp   := cEmpAnt
				_cFil   := _cFilSE1
				
				_cSeek  := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
				
				If !TRB->(dbSeek(_cSeek))
					TRB->(RecLock("TRB",.T.))
					TRB->FILIAL	:= NEWCTS->CTS_FILIAL
					TRB->CODFIL := _cFil
					TRB->CODEMP := _cEmp
					TRB->VISAO	:= NEWCTS->CTS_CODPLA
					TRB->LINHA	:= NEWCTS->CTS_LINHA
					TRB->ENTID	:= NEWCTS->CTS_CONTAG
					TRB->DESCR	:= NEWCTS->CTS_DESCCG
					TRB->PERIO  := _cAnoMes
					TRB->VALOR  := _nValor
					TRB->(MsUnLock())
				Else
					TRB->(RecLock("TRB",.F.))
					TRB->VALOR  += _nValor
					TRB->(MsUnLock())
				Endif
			EndDo
		EndDo
		
		ZZE1->(dbCloseArea())
		
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "2.02" // PMP
		
		ZZE2->(dbgotop())
		
		While ZZE2->(!Eof())
			
			_cFilSE2 := ZZE2->E2_FILIAL
			
			While ZZE2->(!Eof()) .And. _cFilSE2 == ZZE2->E2_FILIAL
				
				_cAnoMes := LEFT(DTOS(ZZE2->E2_EMIS1),6)
				_nTotVal := _nTotMed := 0
				
				While ZZE2->(!Eof()) .And. _cFilSE2 == ZZE2->E2_FILIAL .And. _cAnoMes == LEFT(DTOS(ZZE2->E2_EMIS1),6)
					
					_nTotVal := _nTotMed := 0
					_nMedio  := (ZZE2->E2_BAIXA - ZZE2->E2_EMIS1 ) * ZZE2->VALOR
					
					_nTotVal += ZZE2->VALOR
					_nTotMed += _nMedio
					
					ZZE2->(dbSkip())
				EndDo
				
				_nPMP   := Round(_nTotMed / _nTotVal,2)
				_nValor := _nPMP
				
				_cEmp   := cEmpAnt
				_cFil   := _cFilSE2
				
				_cSeek  := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
				
				If !TRB->(dbSeek(_cSeek))
					TRB->(RecLock("TRB",.T.))
					TRB->FILIAL	:= NEWCTS->CTS_FILIAL
					TRB->CODFIL := _cFil
					TRB->CODEMP := _cEmp
					TRB->VISAO	:= NEWCTS->CTS_CODPLA
					TRB->LINHA	:= NEWCTS->CTS_LINHA
					TRB->ENTID	:= NEWCTS->CTS_CONTAG
					TRB->DESCR	:= NEWCTS->CTS_DESCCG
					TRB->PERIO  := _cAnoMes
					TRB->VALOR  := _nValor
					TRB->(MsUnLock())
				Else
					TRB->(RecLock("TRB",.F.))
					TRB->VALOR  += _nValor
					TRB->(MsUnLock())
				Endif
			EndDo
		EndDo
		
		ZZE2->(dbCloseArea())
		
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "2.03" // INTEGRANTES
		
		_cQ := " SELECT * FROM "+RetSqlName("SRA")+" A "
		_cQ += " WHERE A.D_E_L_E_T_ = '' AND RA_CATFUNC <> 'A' "
		_cQ += " ORDER BY RA_FILIAL, RA_MAT "
		
		TCQUERY _cq NEW ALIAS "ZRA"
		
		TCSETFIELD("ZRA","RA_DEMISSA" ,"D",08)
		
		ZRA->(dbGotop())
		
		_cAnoMes := LEFT(DTOS(MV_PAR01),6)
		_nCont   := 0
		
		While ZRA->(!Eof())
			
			_cFilSRA := ZRA->RA_FILIAL
			
			While ZRA->(!Eof()) .And. _cFilSRA == ZRA->RA_FILIAL
				If !Empty(ZRA->RA_DEMISSA ) .And. ZRA->RA_DEMISSA < _dFirstD
					ZRA->(dbSkip())
					Loop
				Endif
				
				_nCont++
				
				ZRA->(dbSkip())
			EndDo
			
			_cEmp   := cEmpAnt
			_cFil   := _cFilSRA
			_nValor := _nCont
			_cSeek  := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODFIL := _cFil
				TRB->CODEMP := _cEmp
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
		EndDo
		
		ZRA->(dbCloseArea())
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.01" // CREDITO ICMS
		
		ZZD1->(dbgotop())
		
		While ZZD1->(!Eof())
			
			_cAnoMes := ZZD1->ANOMES
			
			_cEmp   := cEmpAnt
			_cFil   := ZZD1->D1_FILIAL
			_nValor := ZZD1->VALICM
			
			_cSeek  := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODFIL := _cFil
				TRB->CODEMP := _cEmp
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
			
			ZZD1->(dbSkip())
		EndDo			
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.02" // CREDITO ICMS GERENCIAL
		_cMov:= "SEM MOVIMENTO"
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.03" // DEBITO ICMS NORMAL
		
		//                    1        2         3     4     5          6             7            8           9             10         11
		//	AADD( _aDADOS,{_CEMP + _CFILIAL +_CANOMES,_CTP , _CFIN ,ZZD2->QUANT,ZZD2->VALTOT,ZZD2->VALICM,ZZD2->VALPIS,ZZD2->VALCOF, ZZD2->VALGER })
		
		For AX:= 1 to Len(_aDADOS)
			_cEmp    := _aDADOS[AX][01]
			_cFil    := _aDADOS[AX][02]
			_cAnoMes := _aDADOS[AX][03]
			_nValor  := _aDADOS[AX][08]
			
			_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODEMP := _cEmp
				TRB->CODFIL := _cFil
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.04" // DEBITO ICMS GERENCIAL
		
		//                    1       2          3      4    5       6            7           8           9            10              11            12       13      14
		//	AADD( _aDADOS,{_CEMP , _CFILIAL ,_CANOMES,_CTP ,_CFIN, ZZD2->QUANT,ZZD2->VALTOT,ZZD2->VALICM,ZZD2->VALPIS,ZZD2->VALCOF, ZZD2->VALGER,_nICMGER,_nPISGER,_nCOFGER })
		
		For AX:= 1 to Len(_aDADOS)
			_cEmp    := _aDADOS[AX][01]
			_cFil    := _aDADOS[AX][02]
			_cAnoMes := _aDADOS[AX][03]
			_nValor  := _aDADOS[AX][12]
			
			_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODEMP := _cEmp
				TRB->CODFIL := _cFil
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.05" // CREDITO PIS NORMAL
		
		ZZD1->(dbgotop())
		
		While ZZD1->(!Eof())
			
			_cAnoMes := ZZD1->ANOMES
			
			_cEmp   := cEmpAnt
			_cFil   := ZZD1->D1_FILIAL
			_nValor := ZZD1->VALPIS
			
			_cSeek  := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODFIL := _cFil
				TRB->CODEMP := _cEmp
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
			
			ZZD1->(dbSkip())
		EndDo		
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.06" // CREDITO PIS GERENCIAL
		_cMov:= "SEM MOVIMENTO"
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.07" // DEBITO PIS NORMAL
		
		//                    1       2          3      4    5          6            7           8            9            10              11        12       13      14
		//	AADD( _aDADOS,{_CEMP , _CFILIAL ,_CANOMES,_CTP ,_CFIN, ZZD2->QUANT,ZZD2->VALTOT,ZZD2->VALICM,ZZD2->VALPIS,ZZD2->VALCOF, ZZD2->VALGER,_nICMGER,_nPISGER,_nCOFGER })
		
		For AX:= 1 to Len(_aDADOS)
			_cEmp    := _aDADOS[AX][01]
			_cFil    := _aDADOS[AX][02]
			_cAnoMes := _aDADOS[AX][03]
			_nValor  := _aDADOS[AX][09]
			
			_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODEMP := _cEmp
				TRB->CODFIL := _cFil
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.08" // DEBITO PIS GERENCIAL
		
		//                    1       2          3      4       5       6            7           8           9            10             11          12       13      14
		//	AADD( _aDADOS,{_CEMP , _CFILIAL ,_CANOMES,_CTP ,_CFIN, ZZD2->QUANT,ZZD2->VALTOT,ZZD2->VALICM,ZZD2->VALPIS,ZZD2->VALCOF, ZZD2->VALGER,_nICMGER,_nPISGER,_nCOFGER })
		
		For AX:= 1 to Len(_aDADOS)
			_cEmp    := _aDADOS[AX][01]
			_cFil    := _aDADOS[AX][02]
			_cAnoMes := _aDADOS[AX][03]
			_nValor  := _aDADOS[AX][13]
			
			_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODEMP := _cEmp
				TRB->CODFIL := _cFil
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.09" // CREDITO COFINS NORMAL
		
		ZZD1->(dbgotop())
		
		While ZZD1->(!Eof())
			
			_cAnoMes := ZZD1->ANOMES
			
			_cEmp   := cEmpAnt
			_cFil   := ZZD1->D1_FILIAL
			_nValor := ZZD1->VALCOF
			
			_cSeek  := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODFIL := _cFil
				TRB->CODEMP := _cEmp
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
			
			ZZD1->(dbSkip())
		EndDo				
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.10" // CREDITO COFINS GERENCIAL
		_cMov:= "SEM MOVIMENTO"
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.11" // DEBITO COFINS NORMAL
		
		//                    1       2          3      4    5       6               7           8           9            10              11            12       13      14
		//	AADD( _aDADOS,{_CEMP , _CFILIAL ,_CANOMES,_CTP ,_CFIN, ZZD2->QUANT,ZZD2->VALTOT,ZZD2->VALICM,ZZD2->VALPIS,ZZD2->VALCOF, ZZD2->VALGER,_nICMGER,_nPISGER,_nCOFGER })
		
		For AX:= 1 to Len(_aDADOS)
			_cEmp    := _aDADOS[AX][01]
			_cFil    := _aDADOS[AX][02]
			_cAnoMes := _aDADOS[AX][03]
			_nValor  := _aDADOS[AX][10]
			
			_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODEMP := _cEmp
				TRB->CODFIL := _cFil
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
		Next AX
	ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.12" // DEBITO COFINS GERENCIAL
		
		//                    1       2          3      4    5       6               7           8           9            10              11            12       13      14
		//	AADD( _aDADOS,{_CEMP , _CFILIAL ,_CANOMES,_CTP ,_CFIN, ZZD2->QUANT,ZZD2->VALTOT,ZZD2->VALICM,ZZD2->VALPIS,ZZD2->VALCOF, ZZD2->VALGER,_nICMGER,_nPISGER,_nCOFGER })
		
		For AX:= 1 to Len(_aDADOS)
			_cEmp    := _aDADOS[AX][01]
			_cFil    := _aDADOS[AX][02]
			_cAnoMes := _aDADOS[AX][03]
			_nValor  := _aDADOS[AX][14]
			
			_cSeek   := _cEmp + _cFil + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->CODEMP := _cEmp
				TRB->CODFIL := _cFil
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())
			Endif
		Next AX
	Endif
	
	NEWCTS->(dbSKIP())
EndDo

ZZD1->(dbCloseArea())

TRB->(dbgoTop())

While TRB->(!EOF())
	
	ZA5->(dbSetorder(2))
	If ZA5->(dbSeek(xFilial("ZA5" ) + TRB->CODEMP + TRB->CODFIL +TRB->VISAO + TRB->LINHA + TRB->ENTID + TRB->PERIO ))
		ZA5->(RecLock("ZA5",.F.))
		ZA5->ZA5_VALOR	 += TRB->VALOR
		ZA5->(MsUnLock())
	Else
		ZA5->(RecLock("ZA5",.T.))
		ZA5->ZA5_FILIAL	 := xFilial("ZA5")
		ZA5->ZA5_CODEMP  := TRB->CODEMP
		ZA5->ZA5_CODFIL  := TRB->CODFIL
		ZA5->ZA5_CODPLA	 := TRB->VISAO
		ZA5->ZA5_LINHA	 := TRB->LINHA
		ZA5->ZA5_CONTAG	 := TRB->ENTID
		ZA5->ZA5_DESCCG	 := TRB->DESCR
		ZA5->ZA5_VALOR	 := TRB->VALOR
		ZA5->ZA5_PERIOD  := TRB->PERIO
		ZA5->(MsUnLock())
	Endif
	
	TRB->(dbskip())
EndDo

TRB->(dbCloseArea())

NEWCTS->(dbCloseArea())

If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif

Return


Static Function BRI084D(_lFim)

Local nRegCT2   := CT2->(Recno())
Local nRegCTS   := CTS->(Recno())
Local aStru		 := CTS->(DbStruct()), nI
Local cQuery
Local Ax

Pergunte("BRI084",.F.)

_cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-1),4)
_cAnoAnt := _cAno1 + "01"
_cAnoFim := _cAno1 + "12"

_dFirstD  := FirstDay(MV_PAR01)
_dLastD   := LastDay(MV_PAR02)

_cQ := " DELETE "+RetSqlName("ZA5")+" WHERE ZA5_CODEMP = '"+cEmpAnt+"' "
_cQ += " AND ZA5_PERIOD BETWEEN  '"+_cAnoAnt+"' AND '"+_cAnoFim+"' AND ZA5_CODPLA = '005' "
TCSQLEXEC(_cQ)

_cQ := " DELETE "+RetSqlName("ZA5")+" WHERE ZA5_CODEMP = '"+cEmpAnt+"' "
_cQ += " AND ZA5_PERIOD BETWEEN '"+LEFT(DTOS(_dFirstD),6)+"' AND '"+LEFT(DTOS(_dLastD),6)+"' AND ZA5_CODPLA = '005' "
TCSQLEXEC(_cQ)

aCampos := {}

AADD(aCampos,{"FILIAL"	    ,"C" ,05,0	})
AADD(aCampos,{"VISAO"	    ,"C" ,03,0	})
AADD(aCampos,{"LINHA"	    ,"C" ,03,0	}) // LINHA CTS_LINHA
AADD(aCampos,{"ENTID"	    ,"C" ,20,0	})
AADD(aCampos,{"DESCR"	    ,"C" ,40,0	})
AADD(aCampos,{"PERIO"	    ,"C" ,06,0	})
AADD(aCampos,{"VALOR"	    ,"N" ,17,2	})
AADD(aCampos,{"DTMOV"	    ,"D" ,08,0	})

cArqTemp	:=	CriaTrab(aCampos)

dbUseArea(.T.,,cArqTemp,"TRB",.F.,.F.)

IndRegua("TRB",cArqTemp,"FILIAL+VISAO+LINHA+ENTID+PERIO",,,"Indexando Dados")

_cVisao   := "('005')"

_cProd    := Alltrim(GetMv("AST_PRDDRE"))  // PRODUTOS DO OURO
_cProduto := "('"

For Ax:= 1 To Len(_cProd)
	If Substr(_cProd,AX,1) != "*"
		_cProduto += Substr(_cProd,AX,1)
	Else
		_cProduto += "','"
	Endif
Next AX

_cProduto += "')"

_cANOMES:= LEFT(DTOS(MV_PAR01),6)

// Obtem os registros a serem processados

cQuery := " SELECT * FROM "+RetSqlName("CTS")+" CTS "
cQuery += " WHERE CTS.D_E_L_E_T_ = '' AND CTS_CODPLA IN "+_cVisao+" "
cQuery += " AND CTS_FILIAL = '"+xFilial("CTS")+"' "
cQuery += " ORDER BY CTS_CODPLA,CTS_LINHA "

TCQUERY cQuery NEW ALIAS "NEWCTS"

For nI := 1 TO LEN(aStru)
	If aStru[nI][2] != "C"
		TCSetField("NEWCTS", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
	EndIf
Next

cNomeArq := CriaTrab(Nil,.F.)
IndRegua("NEWCTS",cNomeArq,"CTS_FILIAL+CTS_CODPLA+CTS_LINHA",,,"Selecionando Registros...")

If cEmpAnt == "06"
	_cQ := " SELECT Z8_ANOMES AS ANOMES,Z8_AUACUM AS AUACUM, Z8_TOTTON AS TOTTON,Z8_DTMOV,Z8_PRODDIA, Z8_QTAUFIN FROM "+RetSqlName("SZ8")+" A "
	_cQ += " WHERE A.D_E_L_E_T_ = '' AND Z8_CODEMP = '"+cEmpAnt+"' "
	_cQ += " AND Z8_ANOMES = '"+_cANOMES+"' "
	_cQ += " ORDER BY Z8_ANOMES,Z8_ITEM,Z8_DTMOV "
	
	TCQUERY _cQ NEW ALIAS "ZZ"
	
	TCSETFIELD("ZZ","AUACUM"  ,"N",17,2)
	TCSETFIELD("ZZ","TOTTON"  ,"N",17,2)
	TCSETFIELD("ZZ","Z8_DTMOV","D",08)
	
	NEWCTS->(dbGoTop())
	
	ProcRegua(NEWCTS->(LASTREC()))
	
	_cANOMES  := LEFT(DTOS(MV_PAR01),6)
	_nQtAuFin := 0
	
	While NEWCTS->(!Eof())
		
		IncProc()
		
		_lAntZero := .F.
		
		If Alltrim(NEWCTS->CTS_CONTAG)     == "1.1"
			_nValor := ZZ->AUACUM
		Elseif Alltrim(NEWCTS->CTS_CONTAG) == "1.2"
			_nValor := ZZ->TOTTON
		Elseif Alltrim(NEWCTS->CTS_CONTAG) == "1.3"
			
			_cQ := " SELECT * FROM "+RetSqlName("SRA")+" A "
			_cQ += " WHERE A.D_E_L_E_T_ = '' AND RA_CODEMP = '"+cEmpAnt+"' AND RA_CATFUNC <> 'A' "
			_cQ += " ORDER BY RA_MAT "
			
			TCQUERY _cq NEW ALIAS "ZRA"
			
			TCSETFIELD("ZRA","RA_DEMISSA" ,"D",08)
			
			ZRA->(dbGotop())
			
			_nCont := 0
			
			While ZRA->(!Eof())
				
				If !Empty(ZRA->RA_DEMISSA ) .And. ZRA->RA_DEMISSA < _dFirstD  //> _dLastD
					ZRA->(dbSkip())
					Loop
				Endif
				
				_nCont++
				
				ZRA->(dbSkip())
			EndDo
			
			ZRA->(dbCloseArea())
			
			_nValor := _nCont
			
		ElseIf Alltrim(NEWCTS->CTS_CONTAG) == "1.4"
			ZZ->(dbGotop())
			
			_nDiaTrab := 0
			_nDiaUtil := 0
			_dDtAtual := CTOD("")
			_lAntZero := .F.
			
			While ZZ->(!Eof())
				
				_nDiaUtil ++
				_nQtAuFin += ZZ->Z8_QTAUFIN
				
				If ZZ->Z8_PRODDIA == 0
					_lAntZero := .T.
				ElseIf ZZ->Z8_PRODDIA > 0
					If _lAntZero
						_nDiaTrab ++
					Endif
					
					_dDtAtual := ZZ->Z8_DTMOV
					_nDiaTrab ++
					
					_lAntZero := .f.
				Endif
				
				ZZ->(dbSkip())
			EndDo
		Endif
		
		If Alltrim(NEWCTS->CTS_CONTAG)     == "1.4"
			_nValor := _nDiaTrab
		ElseIf Alltrim(NEWCTS->CTS_CONTAG) == "1.5"
			_nValor := _nDiaUtil
		ElseIf Alltrim(NEWCTS->CTS_CONTAG) == "1.6"
			_nValor := 0
		ElseIf Alltrim(NEWCTS->CTS_CONTAG) == "1.7"
			_nValor := _nQtAuFin
		Endif
		
		_cSeek  := NEWCTS->CTS_FILIAL+NEWCTS->CTS_CODPLA+NEWCTS->CTS_LINHA+NEWCTS->CTS_CONTAG + _cANOMES
		
		If !TRB->(dbSeek(_cSeek))
			TRB->(RecLock("TRB",.T.))
			TRB->FILIAL	:= NEWCTS->CTS_FILIAL
			TRB->VISAO	:= NEWCTS->CTS_CODPLA
			TRB->LINHA	:= NEWCTS->CTS_LINHA
			TRB->ENTID	:= NEWCTS->CTS_CONTAG
			TRB->DESCR	:= NEWCTS->CTS_DESCCG
			TRB->PERIO  := _cAnoMes
			TRB->VALOR  := _nValor
			If Alltrim(NEWCTS->CTS_CONTAG) == "1.6"
				TRB->DTMOV  := _dDtAtual
			Endif
			TRB->(MsUnlock())
		Endif
		
		NEWCTS->(dbSKIP())
	EndDo
	
	ZZ->(dbCloseArea())
Endif

TRB->(dbgoTop())

While TRB->(!EOF())
	
	ZA5->(dbSetorder(2))
	If ZA5->(dbSeek(xFilial("ZA5" ) + TRB->CODEMP + TRB->CODFIL + TRB->VISAO + TRB->LINHA + TRB->ENTID + TRB->PERIO ))
		ZA5->(RecLock("ZA5",.F.))
		ZA5->ZA5_VALOR	 += TRB->VALOR
		ZA5->(MsUnLock())
	Else
		ZA5->(RecLock("ZA5",.T.))
		ZA5->ZA5_FILIAL	 := xFilial("ZA5")
		ZA5->ZA5_CODEMP  := TRB->CODEMP
		ZA5->ZA5_CODFIL  := TRB->CODFIL
		ZA5->ZA5_CODPLA	 := TRB->VISAO
		ZA5->ZA5_LINHA	 := TRB->LINHA
		ZA5->ZA5_CONTAG	 := TRB->ENTID
		ZA5->ZA5_DESCCG	 := TRB->DESCR
		ZA5->ZA5_VALOR	 := TRB->VALOR
		ZA5->ZA5_PERIOD  := TRB->PERIO
		ZA5->ZA5_DATA    := TRB->DTMOV
		ZA5->(MsUnLock())
	Endif
	
	TRB->(dbskip())
EndDo

TRB->(dbCloseArea())

NEWCTS->(dbCloseArea())

If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif

Return



Static Function AtuSX1()

cPerg := "BRI084"
aRegs := {}

//    	   Grupo/Ordem/Pergunta      /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data De ?     ",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Data Ate ?    ",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
