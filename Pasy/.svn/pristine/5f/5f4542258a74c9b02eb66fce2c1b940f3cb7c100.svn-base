#include "Protheus.ch"
#include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0092   ³ Autor ³ Alexandro da Silva    ³ Data ³ 11.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualizaçao tabela SZ4 ref. Programacao de Entrega         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat Caterpillar                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0092()

Private _lIncon 		:= .F.
Private _lErro  		:= .F.
_cNum    				:= ""
_aAliOri 				:= GetArea()
_lAchou  				:= .F.
_nOpc    				:= 0
_nQtPasy 				:= _nQtCate := 0

Private titulo         := "Programacao de Entrega Periodo:"
Private nLin           := 80

Private Cabec1         := ""
Private Cabec2         := ""
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio  "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Programacao de Entrega CaterpiLlar Export. PA0092   "
Private imprime        := .T.
Private aOrd           := {}
Private lEnd           := .F.
Private lAbortPrint    := .F.
Private CbTxt          := ""
Private limite         := 132
Private tamanho        := "M"
Private nomeprog       := "PA0092"
Private nTipo          := 18
Private aReturn        := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey       := 0
Private cPerg          := "PA0092"
Private cbtxt          := Space(10)
Private cbcont         := 00
Private CONTFL         := 01
Private m_pag          := 01
Private wnrel          := "PA0092"+dTos(dDataBase)
Private cString 	   := "SZ4"

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := 15

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.

Private _bAcao01   := {|_lFim| PA92A(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| PA92B(@_lFim) }
_cTitulo01 := 'Integrando os Pedidos...'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cq3  := " UPDATE SC6010 SET C6_BLQ = 'R', C6_XDTELIM = '"+DTOS(dDataBase)+"', C6_LOCALIZ = 'PA0092' "
_cq3  += " WHERE D_E_L_E_T_ = '' AND C6_PEDAMOS IN ('Z','M','I') AND C6_QTDENT < C6_QTDVEN AND C6_CLI = '000171' "
_cq3  += " AND C6_BLQ = '' AND C6_ENTREG < '"+DTOS(dDataBase)+"' "

TCSQLEXEC(_cq3)

Return


Static Function PA92A(_lFim)

Pergunte("PA0092",.F.)

aStru := {}
AADD(aStru,{"INDICE"   , "C" , 01, 0 })
AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
AADD(aStru,{"CLIENTE"  , "C" , 06, 0 })
AADD(aStru,{"LOJA"     , "C" , 02, 0 })
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"PEDCLI"   , "C" , 20, 0 })
AADD(aStru,{"ACPASY"   , "N" , 12, 2 })
AADD(aStru,{"ACCATE"   , "N" , 12, 2 })
AADD(aStru,{"QTENT"    , "N" , 12, 2 })
AADD(aStru,{"DTENT"    , "D" , 08, 0 })
AADD(aStru,{"DTULREC"  , "D" , 08, 0 })
AADD(aStru,{"QTULREC"  , "N" , 12, 2 })

cArqLOG := CriaTrab(aStru,.T.)

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "INDICE+PRODUTO+PRODCLI"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

_cCont     := ""
_cUM       := ""
_dDtMov    := Ctod("")
_cCliente  := ""
_cLoja     := ""
_cSemAtu   := ""
_cSemAtu2  := ""
_dDtAtu    := Ctod("")
_cSemAnt   := ""
_cProdCli  := ""
_cProdPasy := ""
_cLocDest  := ""
_cContato  := ""
_cTipo     := ""
_cUltNf    := ""
_cSerNf    := ""
_dDtUltNf  := Ctod("")
_dDtEnt    := Ctod("")
_nQtEnt    := ""
_aDtEnt    := {}
_cPedido   := ""
_cPedCat   := ""
_aPedido   := {}
_cDesenho  := ""
_cOrdCom   := ""

_cData2 := GravaData(dDataBase,.f.,8)
_cHora2 := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

//_cDir   := "F:\AP7\AP_DATA\Caterpillar\Exportacao\Entrada\PAS*.LAN"
_cDir   := "\\SERVER2\ERP\EDI\SINTEL\CAT\ENTRADA\PAS*.LAN"

_aArqTxt := ARRAY(ADIR(_cDir))

//ADIR("F:\AP7\AP_DATA\Caterpillar\Exportacao\Entrada\PAS*.LAN",_aArqTxt)
ADIR("\\SERVER2\ERP\EDI\SINTEL\CAT\ENTRADA\PAS*.LAN",_aArqTxt)

_aArqTxt := aSort(_aArqTxt)

ProcRegua(Len(_aArqTxt))

For I:= 1 to Len(_aArqTxt)
	
	IncProc()
	_lAchou    := .t.
	_lProx     := .F.
	_cArq2     := "\\SERVER2\ERP\EDI\SINTEL\CAT\ENTRADA\BKP\BKP_"+Alltrim(_aArqTxt[I])
//	_cArq2     := "F:\AP7\AP_DATA\Caterpillar\Exportacao\Entrada\BKP\BKP_"+Alltrim(_aArqTxt[I])
	_cArq3     := "\\SERVER2\ERP\EDI\SINTEL\CAT\ENTRADA\"+Alltrim(_aArqTxt[i])
//	_cArq3     := "F:\AP7\AP_DATA\Caterpillar\Exportacao\Entrada\"+Alltrim(_aArqTxt[i])
	
	_cArqNovo  := fCreate(Alltrim(_cArq2),0)
	_cArq      := FOpen(_cArq3,0)
	_cQtArq    := 1
	
	While .T.
		
		cLinha := fReadStr(_cArq,130)
		
		If Len(cLinha) == 0
			Exit
		Endif
		
		If Subs(cLinha,1,3) == "ITP"
			_cCont   := Subst(cLinha,9,5)
			_dDTMov  := Ctod(Subst(cLinha,18,2)+"/"+Subst(cLinha,16,2)+"/20"+Subst(cLinha,14,2))
			
			dbSelectArea("SA1")
			dbOrderNickName("INDSA11")
			If dbSeek(xFilial("SA1")+Subst(cLinha,26,14))
				_cCliente := SA1->A1_COD
				_cLoja    := SA1->A1_LOJA
			Else      
				_lErro    := .T.
				Alert("CLIENTE "+Subst(cLinha,26,14)+ " NAO CADASTRADO FAVOR CADASTRAR!!!!!!")
				Exit
			Endif
		ElseIf Subs(cLinha,1,3) == "PE1"
			_nQt       := 0
			_lProx     := .T.
			_cSemAtu   := Subs(cLinha,7,9)
			_cSemAtu2  := Subs(cLinha,7,9)
			_dDtAtu    := Ctod(Subst(cLinha,20,2)+"/"+Subst(cLinha,18,2)+"/20"+Subst(cLinha,16,2))
			_cSemAnt   := Subs(cLinha,22,9)
			_cProdCli2 := Subs(cLinha,37,15)
			_cProdCli  := ""
			For B:= 1 To Len(_cProdCli2)
				If Substr(_cProdCli2,B,1) != "-"
					_cProdCli += Substr(_cProdCli2,B,1)
				Endif
			Next B
			_cProdcli  := PADR(_cProdCli,15)
			_cPedido2  := Subs(cLinha,97,12)
			_cPedCat   := ""

			For C:= 1 To Len(Alltrim(_cPedido2))
				_cPedCat  += Substr(_cPedido2,C,1)
			Next C

			_cProdPasy := ""
			_cUm       := Subs(cLinha,125,2)

			dbSelectArea("SZ2")
			dbSetOrder(6)
			If dbSeek(xFilial("SZ2")+_cCliente + _cLOja + _cProdCli+"1")
				_cProdPasy := SZ2->Z2_PRODUTO
				dbSelectArea("SZ2")
				RecLock("SZ2",.F.)
				SZ2->Z2_UM  := _cUm
				MsUnlock()
			Else
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->INDICE  := "1"
				TRB->PRODCLI := _cProdCli
				TRB->CLIENTE := _cCliente
				TRB->LOJA    := _cLoja
				MsUnlock()
			Endif
			
			_cLocDest := Subs(cLinha,109,5)
			_cContato := Subs(cLinha,114,11)
			_cTipo    := Subs(cLinha,128,1)
		ElseIf Subs(cLinha,1,3) == "PE2"
			_cUltNf   := Subs(cLinha,10,6)
			_cSerNf   := Subs(cLinha,16,4)
			_dDtUltNf := Ctod(Subst(cLinha,24,2)+"/"+Subst(cLinha,22,2)+"/20"+Subst(cLinha,20,2))
			_nQtAcumZ4:= (Val(Subs(cLinha,38,14)))/1000
		ElseIf Subs(cLinha,1,3) == "PE3"
			_nQt   := 12
			_nQtDt := 4
			
			_aQuant := {}
			_aDtEnt := {}
			For A:= 1 to 7
				_nQtEnt := Val(Subs(cLinha,_nQt,9))
				_dDtEnt := Ctod(Subst(cLinha,_nQtDt+4,2)+"/"+Subst(cLinha,_nQtDt+2,2)+"/20"+Subst(cLinha,_nQtDt,2))
				
				If !Empty(_nQtEnt) .or. !Empty(_dDtEnt)
					AADD(_aQuant,{_nQtEnt})
					_nQt   += 17
					AADD(_aDtEnt,{_dDtEnt})
					_nQtDt += 16
				Else
					A:= 7
				Endif
			Next A
		ElseIf Subs(cLinha,1,3) == "PE5"
			_aTpPed  := {}
			_nPed    := 10
			
			If !Empty(_cProdPasy)
				dbSelectArea("SZ4")
				dbSetOrder(4)
				If dbSeek(xFilial("SZ4")+Dtos(MV_PAR01)+ _cCliente + _cLoja + _cProdPasy)
					_cChavProg := Dtos(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS
					
					While !eof() .And. _cChavProg == DTOS(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS
						
						If _cSemAtu == _cSemAtu2 .And. UPPER(SZ4->Z4_NOMARQ)  != UPPER(Alltrim(_aArqTxt[i]))
							dbSelectArea("SZ4")
							RecLock("SZ4",.F.)
							dbDelete()
							MsUnlock()
						Endif
						
						dbSelectArea("SZ4")
						dbSkip()
					EndDo
				Else
					_lProx := .F.
				Endif
			Endif
			
			For B:= 1 To Len(_aQuant)
				
				If  _aQuant[B,1] > 0
					If !Empty(_cProdPasy)
						dbSelectArea("SZ4")
						dbSetOrder(4)
						If dbSeek(xFilial("SZ4")+Dtos(MV_PAR01)+ _cCliente + _cLoja + _cProdPasy +Dtos(_aDTEnt[B,1]) )
							_cChavProg := Dtos(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + DTOS(SZ4->Z4_DTENT)
							
							While !eof() .And. _cChavProg == DTOS(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + DTOS(SZ4->Z4_DTENT)
								
								If _cSemAtu == _cSemAtu2 .And. UPPER(SUBSTR(SZ4->Z4_NOMARQ,1,12))  != UPPER(SUBSTR(Alltrim(_aArqTxt[i]),1,12))
									dbSelectArea("SZ4")
									RecLock("SZ4",.F.)
									dbDelete()
									MsUnlock()
								Endif
								
								dbSelectArea("SZ4")
								dbSkip()
							EndDo
						Else
							_lProx := .F.
						Endif
					Endif
					
					_cTpPed    := Subs(cLinha,_nPed,1)
					
					_nPed += 16
					dbSelectArea("SZ4")
					RecLock("SZ4",.T.)
					SZ4->Z4_FILIAL  := xFilial("SZ4")
					SZ4->Z4_CODCLI  := _cCliente
					SZ4->Z4_LOJA    := _cLoja
					SZ4->Z4_PRODPAS := _cProdPasy
					SZ4->Z4_PRODCLI := _cProdCli
					SZ4->Z4_DTMOV   := _dDtMov
					SZ4->Z4_CONTROL := _cCont
					SZ4->Z4_SEMATU  := _cSemAtu
					SZ4->Z4_DTATU   := _dDtAtu
					SZ4->Z4_SEMANT  := _cSemAnt
					SZ4->Z4_LOCDEST := _cLocDest
					SZ4->Z4_TIPO    := _cTipo
					SZ4->Z4_ULTNF   := _cUltNf
					SZ4->Z4_DTULTNF := _dDtUltNf
					SZ4->Z4_DTENT   := _aDTEnt[B,1]
					SZ4->Z4_QTENT   := _aQuant[B,1]
					SZ4->Z4_PEDIDO  := _cPedCat
					SZ4->Z4_TPPED   := _cTpPed
					SZ4->Z4_CONTATO := _cContato
					SZ4->Z4_DTDIGIT := MV_PAR01
					SZ4->Z4_NOMARQ  := Alltrim(_aArqTxt[i])
					SZ4->Z4_QTACUM  := _nQtAcumZ4
					MsUnlock()
					
				Endif
			Next B
			
			_cSemAtu2 := ""
		ElseIf Subs(cLinha,1,3) == "TE1"

			If Subs(cLinha,12,10) == "Engenharia"						
				_cAltEng  := Subs(cLinha,24,4)
			Endif
			If Subs(cLinha,91,7) == "Release"			
				_cRevisao := Subs(cLinha,100,15)
			Endif
			If Subs(cLinha,4,27) == "Ultima Quantidade Recebida:"				
				_nUlQtNF  := Val(Subs(cLinha,32,8))
			Endif	
			
			dbSelectArea("SZ4")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ4") + _cCont + _cCliente + _cLoja + _cProdCli)
				_cChavSZ4 :=  SZ4->Z4_CONTROL + SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI
				While !Eof() .And.  _cChavSZ4 ==  SZ4->Z4_CONTROL + SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI
					dbSelectArea("SZ4")
					RecLock("SZ4",.F.)
					If Subs(cLinha,12,10) == "Engenharia"						
						SZ4->Z4_ALTENG  := _cAltEng
					Endif	
					If Subs(cLinha,91,7) == "Release"
						SZ4->Z4_ALTTEC  := _cRevisao					
					Endif
					If Subs(cLinha,4,27) == "Ultima Quantidade Recebida:"
						SZ4->Z4_ULQTENF := _nUlQtNF
                    Endif
					MsUnlock()
					dbSkip()
				EndDo
			Endif

		Endif
		
		FWrite(_cArqNovo,cLinha)
	EndDo
	
	fClose(_cArq2)
	fClose(_cArqNovo)
	
	If File(_cArq3)
		FClose(_cArq)
	    If !_lErro
			FErase(_cArq3)
		    _lErro := .F.
		Endif
	Endif
Next I

Return


Static Function PA92B()

Private _nPula,_lPrim,_cItem,_cItemExp,_lAchou,_nPrcVen,_cNum,_lVerFat, _lIncSC6, _cPedido
Private _lIncSC6 := .F.
Private _nTotQt  := 0

dbSelectArea("SZ4")
dbSetOrder(1)

Private _lNAchou   := .F.
Private _lFim      := .F.

_lNAchou := .F.

_cq  := "UPDATE SD2010 SET D2_PROGENT = 0 WHERE D2_CLIENTE = '000171'"

TCSQLEXEC(_cq)

/*
dbSelectArea("SD2")
dbSEtOrder(9)
If dbSeek(xFilial("SD2")+"000171",.F.)
	
	_cChavSD2 := SD2->D2_CLIENTE
	
	ProcRegua(LastRec())
	
	While !Eof() .And. _cChavSD2 == SD2->D2_CLIENTE
		
		IncProc()
		
		dbSelectArea("SD2")
		RecLock("SD2",.F.)
		SD2->D2_PROGENT := 0
		MsUnLock()
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif
  */
dbSelectArea("SZ4")
dbSetOrder(4)
If dbSeek(xFilial("SZ4")+DTOS(MV_PAR01),.F.)
	
	ProcRegua(RecCount())
	
	While SZ4->(!Eof()) .And. SZ4->Z4_DTDIGIT == MV_PAR01
		
		_lPrim     := .F.
		_nTotQt    := 0
		_cItem     := "00"
		_cItemExp  := 0
		_cClieLoja := SZ4->Z4_CODCLI + SZ4->Z4_LOJA
		
		dbSelectArea("SZ4")
		
		While SZ4->(!Eof()) .And.	_cClieLoja == SZ4->Z4_CODCLI + SZ4->Z4_LOJA
			
			If SZ4->Z4_CODCLI != "000171"
				dbSelectArea("SZ4")
				dbSkip()
				Loop
			Endif
			
			IF !Empty(SZ4->Z4_INTEGR)
				dbSelectArea("SZ4")
				dbSkip()
				Loop
			Endif
			
			IncProc()
			
			_cProdCli := SZ4->Z4_PRODCLI
			_cOrdCom  := SZ4->Z4_PEDIDO
			_nSubQt   := 0
  
/*
        ALTERADO EM 17/11/08   
					
			dbSelectArea("SZ2")
			dbSetOrder(6)
			If !dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI+"1")
				dbSelectArea("SZ4")
				dbSkip()
				Loop
			Endif                                   

			dbSelectArea("SZ2")		
			RecLock("SZ2",.F.)
			SZ2->Z2_ESPCLIE := SZ2->Z2_PEDCLI
			SZ2->Z2_PEDCLI  := SZ4->Z4_PEDIDO		
			MsUnlock()

            ALTERADO EM 17/11/08
*/
			SZ2->(dbSetOrder(8))
			If SZ2->(!dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI+SZ4->Z4_PEDIDO+"1"))
				TRB->(RecLock("TRB",.T.))
				TRB->INDICE  := "2"
				TRB->PRODCLI := _cProdCli     
				TRB->PRODUTO := SZ4->Z4_PRODPAS
				TRB->CLIENTE := SZ4->Z4_CODCLI
				TRB->LOJA    := SZ4->Z4_LOJA
				TRB->PEDCLI  := SZ4->Z4_PEDIDO				
				TRB->(MsUnlock())

				SZ4->(dbSkip())
				Loop
			Endif

			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS)
			
			_nQtPasy  := 0       
			
			ZERAPED()
			
			dbSelectArea("SZ4")
			_lVerFat := .t.
			
			While !Eof() .And. (_cProdCli == SZ4->Z4_PRODCLI) .And. (SZ4->Z4_DTDIGIT == MV_PAR01) .And.	(_cClieLoja == SZ4->Z4_CODCLI + SZ4->Z4_LOJA) .And. (_cOrdCom  == SZ4->Z4_PEDIDO)
				
				If _lFim
					Alert("Cancelado Pelo Usuario!!!!!!")
					Return
				Endif
				
				_lAchou := .F.
				dbSelectArea("SZC")
				dbSetOrder(1)
				If dbSeek(xFilial("SZC")+SZ2->Z2_CLIENTE + SZ2->Z2_LOJA + SZ2->Z2_PRODUTO + SZ2->Z2_CODCLI+SZ2->Z2_PEDCLI)
					_cChavSZC := SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI + SZC->ZC_PEDCLI
					
					_nPreco := SZC->ZC_PRECO
					While !eof() .And. _cChavSZC == SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI + SZC->ZC_PEDCLI .And. !_lAchou
						If SZ4->Z4_QTENT >= SZC->ZC_QTINIC  .And. SZ4->Z4_QTENT <= SZC->ZC_QTFINAL
							_nPreco := SZC->ZC_PRECO
							_lAchou := .T.
						Endif
						
						dbSelectArea("SZC")
						dbSkip()
					EndDo
				Else
					dDataRef := SZ2->Z2_DTREF01
					nValor   := SZ2->Z2_PRECO01
					For i := 2 to 12
						If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
							dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
							nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
						Endif
					Next i
					
					_nPreco  := nValor
				Endif
				
				_nPrcVen := Round(_nPreco,5)

				If _nPrcVen == 0
					Alert("Produto "+SZ4->Z4_PRODPAS+ " Sem Preco Cadastrado, Cadastrar no Produto x Cliente e no Pedido Gerado!!") 
				Endif
				
				INTSC6C()
				
				dbSelectArea("SZ4")
				RecLock("SZ4",.F.)
				SZ4->Z4_INTEGR := "S"
				SZ4->Z4_IMPRES := "S"
				MsUnlock()
								
				dbSelectArea("SZ4")
				_nRecSz4 := Recno()
				dbSkip()
			EndDo
			
			dbSelectArea("SZ4")
			dbGoto(_nRecSZ4)
			
			ELIMR()
			
			dbSelectArea("SZ4")
			dbSkip()
		EndDo
		dbSelectArea("SZ4")
	EndDo
Endif

cDesc1 	:= cDesc2 := cDesc3 := ""
nLin   	:= 80
_lFirst := .T.          
_cChav  := ""

dbSelectArea("TRB")
dbGotop()

If !Empty(TRB->PRODCLI)
	
	dbSelectArea("TRB")
	
	ProcRegua(RecCount())
	
	While !Eof()
		
		IncProc()
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		If TRB->INDICE  $ "1/2"
			If Empty(TRB->PEDCLI)
				@nLin,00  PSAY "PRODUTO CLIENTE NAO CADASTRADO "+TRB->PRODCLI+" "+TRB->CLIENTE+"-"+TRB->LOJA
			Else
				@nLin,00  PSAY "O.COMPRA DO CLIENTE NAO CAD."+TRB->PRODCLI+" "+TRB->CLIENTE+"-"+TRB->LOJA+" "+TRB->PEDCLI
		    Endif
		Else
			If _lFirst
				nLin := 61
				Cabec1 := "PROD.PASY PROD.CLI    CLIENTE/LJ PED.CLI            ACUM.PAS Y    ACUM.CAT    QTDE.PED. Entrega    Qte Aberto Ult Rec   Qtd Ult Rec"
				/*
				PROD.PASY PROD.CLI    CLIENTE/LJ PED.CLI            ACUM.PAS Y    ACUM.CAT    QTDE.PED. Entrega    Qte Aberto Ult Rec   Qtd Ult Rec
				999999999 99999999999 999999/99  999999999999999 999999999999 999999999999 999999999999 99999999 999999999999 99999999 999999999999
				0         10          22         33              49           62           75           88       97           110      119
 			 	*/
				If nLin > 60
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				Endif
				_lFirst := .F.
			Endif
			
			_cQuery := " SELECT C6_PRODUTO,SUM(C6_QTDVEN - C6_QTDENT) AS QUANT FROM "+RetSqlName("SC6")+" A (NOLOCK)"
			_cQuery += " WHERE A.D_E_L_E_T_ = '' AND C6_BLQ = '' AND C6_PEDAMOS = 'N' AND C6_QTDVEN > C6_QTDENT "
			_cQuery += " AND C6_PRODUTO + C6_CPROCLI+C6_CLI+C6_LOJA+C6_PEDCLI = '"+TRB->PRODUTO+TRB->PRODCLI+TRB->CLIENTE+TRB->LOJA+TRB->PEDCLI+"' "
			_cQuery += " GROUP BY C6_PRODUTO "
			
			TCQUERY _cQuery New ALIAS "ZZ"

			TCSETFIELD("ZZ","QUANT","N",12,2)
			
			dbSelectArea("ZZ")
			
			If (_cChav != TRB->PRODUTO+TRB->PRODCLI+TRB->CLIENTE+TRB->LOJA+TRB->PEDCLI)
				@nLin,000 PSAY Replicate("-",132)
				nLin++
				If nLin > 60
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				Endif
			Endif
			
			@nLin,000  PSAY Left(TRB->PRODUTO,9)
			@nLin,010  PSAY Left(TRB->PRODCLI,11)
			@nLin,022  PSAY TRB->CLIENTE+"/"+TRB->LOJA
			@nLin,033  PSAY Left(TRB->PEDCLI,15)
			@nLin,049  PSAY TRB->ACPASY 	PICTURE "@E 9,999,999.99"
			@nLin,062  PSAY TRB->ACCATE 	PICTURE "@E 9,999,999.99"
			@nLin,075  PSAY TRB->QTENT  	PICTURE "@E 9,999,999.99"
			@nLin,088  PSAY TRB->DTENT
			@nLin,097  PSAY ZZ->QUANT   	PICTURE "@E 9,999,999.99"
			@nLin,110  PSAY TRB->DTULREC
			@nLin,119  PSAY TRB->QTULREC	PICTURE "@E 9,999,999.99"
			
			_cChav := TRB->PRODUTO+TRB->PRODCLI+TRB->CLIENTE+TRB->LOJA+TRB->PEDCLI
									
			ZZ->(dbCloseArea())
			
		Endif

		nLin++

		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	SET DEVICE TO SCREEN
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
Endif

dbSelectArea("TRB")
dbCloseArea()

Return


Static Function IntSC6C()

_lAchou   := .F.

If (_nQtPasy != _nQtCate) .And. SZ4->Z4_TPPED = "1"
	TRB->(RecLock("TRB",.T.))
	TRB->INDICE  := "3"
	TRB->PRODCLI := SZ4->Z4_PRODCLI
	TRB->PRODUTO := SZ4->Z4_PRODPAS
	TRB->CLIENTE := SZ4->Z4_CODCLI
	TRB->LOJA    := SZ4->Z4_LOJA
	TRB->PEDCLI  := SZ4->Z4_PEDIDO				
	TRB->ACPASY  := _nQtPasy
	TRB->ACCATE  := _nQtCate
	TRB->QTENT   := SZ4->Z4_QTENT
	TRB->DTENT   := SZ4->Z4_DTENT
	TRB->DTULREC := SZ4->Z4_DTULTNF
	TRB->QTULREC := SZ4->Z4_ULQTENF

	TRB->(MsUnlock())
Endif


If _nQtPasy < _nQtCate
	_nQtPasy += SZ4->Z4_QTENT
	_nDif    := _nQtPasy  - _nQtCate
	If _nQtPasy > _nQtCate
		_nQtPasy := _nQtCate
	Endif
Else
	_nQtCate += SZ4->Z4_QTENT
	_nDif    := _nQtCate  - _nQtPasy 
	If _nQtCate > _nQtPasy
		_nQtCate := _nQtPasy
	Endif
Endif

If _nDif > 0
	If _nQtPasy > 0
		_nFatur  := _nDif
	Else
		_nFatur  := SZ4->Z4_QTENT
	Endif
Else
	_nFatur   := _nDif
	_lAchou   := .t.
Endif

If _nDif > 0 
	dbSelectArea("SC6")
	dbOrderNickName("INDSC61")
	If dbSeek(xFilial("SC6")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + SZ4->Z4_PEDIDO + DTOS(SZ4->Z4_DTENT))
	
		_cChavSC62 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI + DTOS(SC6->C6_ENTREG)
	
		While !Eof() .And. 	_cChavSC62 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI + DTOS(SC6->C6_ENTREG) .And. !_lAchou
		
			If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. !Empty(SC6->C6_BLQ)
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
			
			If (SC6->C6_QTDVEN - SC6->C6_QTDENT) != _nFatur
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif

			dbSelectArea("SC6")
			RecLock("SC6",.F.)
			SC6->C6_IDENCAT := DTOS(MV_PAR01)
			If SZ4->Z4_TPPED = "1"
				SC6->C6_PEDAMOS := "N"
			Endif
			SC6->C6_REVPED  := SZ4->Z4_ALTTEC
			MsUnlock()

			dbSelectArea("EE8")
			dbOrderNickName("INDEE81")
			If dbSeek(xFilial("EE8")+SC6->C6_NUM+Space(14)+SC6->C6_ITEM)
				RecLock("EE8",.f.)
				If SZ4->Z4_TPPED = "1"
					EE8->EE8_TIPPED := "N"
				Endif
				EE8->EE8_REVPED := SZ4->Z4_ALTTEC
				EE8->EE8_REVENG := SZ4->Z4_ALTENG
				MsUnlock()
			Endif

			_lAchou := .T.

			dbSelectArea("SC6")
			dbSkip()
		EndDo
	Endif
Endif

If !_lAchou
	
	_lVerFat  := .F.
	_cItem    := SomaIt(_cItem)
	_cItemExp ++       

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA)
	
//	If !_lPrim .Or. _cItem == "ZZ"
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
		
		dbSelectArea("SC5")
		RecLock("SC5",.T.)
		SC5->C5_FILIAL  := xFilial("SC5")
		SC5->C5_NUM     := _cNum
		SC5->C5_TIPO    := "N"
		SC5->C5_CLIENTE := SZ4->Z4_CODCLI
		SC5->C5_LOJAENT := SZ4->Z4_LOJA
		SC5->C5_LOJACLI := SZ4->Z4_LOJA
		SC5->C5_TRANSP  := SA1->A1_TRANSP
		SC5->C5_TIPOCLI := SA1->A1_TIPO
		SC5->C5_CONDPAG := SA1->A1_COND
		SC5->C5_TIPLIB  := "1"
		SC5->C5_VEND1   := SA1->A1_VEND
		SC5->C5_COMIS1  := SA1->A1_COMIS
		SC5->C5_EMISSAO := MV_PAR01
		SC5->C5_PESOL   := 1
		SC5->C5_MOEDA   := 1
		SC5->C5_TXMOEDA := 1
		SC5->C5_TPCARGA := "2"
		SC5->C5_PEDEXP  := _cNum
		MsUnlock()
		
		_cCondPgt :=""
		_cDisPa   :=0
		dbselectArea("SY6")
		dbSetOrder(1)
		If dbSeek(xFilial("SY6")+SA1->A1_CONDPAG)
			_cCondPgt := SY6->Y6_COD
			_cDisPa   := SY6->Y6_DIAS_PA
		Endif
		
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
		
		dbselectArea("SA2")
		dbSetOrder(1)
		If dbSeek(xFilial("SA2")+"000211")
			_cBairro  := Alltrim(SA2->A2_BAIRRO)
			_cMun     := Alltrim(SA2->A2_MUN)
			_cEst     := Alltrim(SA2->A2_EST)
			_cCep     := Alltrim(SA2->A2_CEP)
			_cEnd2    := SA2->A2_END
		Endif
		
		EE3->(dbsetOrder(1))
		EE3->(dbseek(xFilial("EE3")+"X"))
		
		dbSelectArea("EE7")
		RecLock("EE7",.T.)
		EE7->EE7_AMOSTR := "2"
		EE7->EE7_BELOJA := "01"
		EE7->EE7_BENEDE := "PASY IND. E COM. DE BORRACHA E"
		EE7->EE7_BENEF  := "000211"
		EE7->EE7_BRUEMB := "1"  // Peso da Embalagem
		EE7->EE7_CALCEM := "1"  // sempre "Volume"
		EE7->EE7_CONDPA := _cCondPgt
		EE7->EE7_DEST   := _cDestino
		EE7->EE7_DIASPA := _cDisPa
		EE7->EE7_DTPEDI := MV_PAR01
		EE7->EE7_DTPROC := MV_PAR01
		EE7->EE7_END2BE := _cBairro + " - " + _cMun + " - " + _cEst + " - Brazil - C.E.P " + _cCep
		EE7->EE7_END2IM := _cEnd1a
		EE7->EE7_ENDBEN := _cEnd2
		EE7->EE7_ENDIMP := _cEnd1
		EE7->EE7_EXLIMP := "2"
		EE7->EE7_FATURA := dDataBase
		EE7->EE7_FOLOJA := "01"
		EE7->EE7_FORN   := "000211"
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
//		EE7->EE7_REFIMP := SZ4->Z4_PEDIDO
		EE7->EE7_RESPON := EE3->EE3_NOME
//		EE7->EE7_RESPON := "TAVIS MASSAYUKI IWASAKI"
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
		_cCodMar        := GETIDMEMO()
		EE7->EE7_CODMAR := _cCodMar
		MsUnlock()
	Endif
	
	dbSelectArea("EE7")
	RecLock("EE7",.F.)
	EE7->EE7_TOTITE := _cItemExp
	EE7->EE7_TOTPED += Round(( (_nFatur) * _nPrcVen ),2)
	MsUnlock()
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4")+SZ2->Z2_TES)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS)
	
	dbSelectArea("SC6")
	RecLock("SC6",.T.)
	SC6->C6_FILIAL  := xFilial("SC6")
	SC6->C6_NUM     := _cNUm
	SC6->C6_ITEM    := _cItem
	SC6->C6_CPROCLI := SZ4->Z4_PRODCLI
	SC6->C6_PRODUTO := SZ4->Z4_PRODPAS
	SC6->C6_REVPED  := SZ4->Z4_ALTTEC
	SC6->C6_REVENG  := SZ4->Z4_ALTENG
	SC6->C6_QTDVEN  := _nFatur
	SC6->C6_PRCVEN  := _nPrcVen
	SC6->C6_VALOR   := Round(( (_nFatur) * _nPrcVen ),2)
	SC6->C6_ENTREG  := SZ4->Z4_DTENT

	If SZ4->Z4_TPPED == "1"
		SC6->C6_PEDAMOS := "N"
	ElseIf SZ4->Z4_TPPED == "2"
		SC6->C6_PEDAMOS := "I"
	ElseIf SZ4->Z4_TPPED == "3"
		SC6->C6_PEDAMOS := "M"
	ElseIf SZ4->Z4_TPPED == "4"
		SC6->C6_PEDAMOS := "Z"
	Endif
	
	If SZ4->Z4_TIPO == "A"
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
	SC6->C6_PEDCLI  := SZ4->Z4_PEDIDO
	SC6->C6_DESCRI  := SZ2->Z2_DESCCLI
	SC6->C6_LOCAL   := SB1->B1_LOCPAD
	SC6->C6_CLI     := SZ4->Z4_CODCLI
	SC6->C6_LOJA    := SZ4->Z4_LOJA
	SC6->C6_PRUNIT  := _nPrcVen
	SC6->C6_TPOP    := "F"
	SC6->C6_IDENCAT := DTOS(MV_PAR01)
	SC6->C6_CLASFIS := SUBSTR(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
	SA3->(dbSetOrder(1))
	If SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND))
		SC6->C6_COMIS1   := SA3->A3_COMIS
	Endif

	MsUnlock()
	
	_nPosIPI := ""
	_cUM     := ""
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek (xFilial("SB1")+SZ4->Z4_PRODPAS)
		_nPosIPI := SB1->B1_POSIPI
		_cUM     := SB1->B1_UM
	Endif
	
    _cTes    := ""
    _cDescZ2 := ""
	SZ2->(dbSetOrder(8))
	If SZ2->(dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI+SZ4->Z4_PEDIDO+"1"))
		_cTes    := SZ2->Z2_TES
	    _cDescZ2 := Alltrim(SZ2->Z2_DESCCLI)
	Endif
	
	dbSelectArea("EE8")
	RecLock("EE8",.T.)
	EE8->EE8_COD_I  := SZ4->Z4_PRODPAS
	_cCodDes        := GETIDMEMO()
	EE8->EE8_DESC   := _cCodDes
	If SZ4->Z4_TPPED == "1"
		EE8->EE8_TIPPED := "N"
	ElseIf SZ4->Z4_TPPED == "2"
		EE8->EE8_TIPPED := "I"
	ElseIf SZ4->Z4_TPPED == "3"
		EE8->EE8_TIPPED := "M"
	ElseIf SZ4->Z4_TPPED == "4"
		EE8->EE8_TIPPED := "Z"
	Endif
	EE8->EE8_DTENTR := SZ4->Z4_DTENT
//	EE8->EE8_DTPREM := MV_PAR01
	EE8->EE8_DTPREM := SZ4->Z4_DTENT
	EE8->EE8_CODCLI := SZ4->Z4_PRODCLI
	EE8->EE8_EMBAL1 := SZ2->Z2_CODEMB
	EE8->EE8_FABR   := "000211"
	EE8->EE8_FALOJA := "01"
	EE8->EE8_FATIT  := _cItem
	EE8->EE8_FOLOJA := "01"
	EE8->EE8_FORN   := "000211"
	EE8->EE8_PART_N := SZ4->Z4_PRODCLI
	EE8->EE8_PEDIDO := _cNUm
	EE8->EE8_POSIPI := _nPosIPI
	EE8->EE8_PRCINC := Round(( (_nFatur) * _nPrcVen ),2)
	EE8->EE8_PRCTOT := Round(( (_nFatur) * _nPrcVen ),2)
	EE8->EE8_PRECO  := _nPrcVen
	EE8->EE8_PRECOI := _nPrcVen
	EE8->EE8_PSLQUN := SB1->B1_PESO
	EE8->EE8_QE	    := _nFatur
	EE8->EE8_QTDEM1 := 1
	EE8->EE8_REFCLI := SZ4->Z4_PEDIDO
	EE8->EE8_SEQUEN := Padl(Alltrim(Str(_cItemExp)),6)
	EE8->EE8_SLDATU := _nFatur
	EE8->EE8_SLDINI := _nFatur
	EE8->EE8_UNPRC  := _cUM
	EE8->EE8_UNPES  := "KG"
	EE8->EE8_UNIDAD := _cUM
	EE8->EE8_CF     := _cCf + Substr(SF4->F4_CF,2,3)
	EE8->EE8_TES    := _cTes
	EE8->EE8_REVPED := SZ4->Z4_ALTTEC
	EE8->EE8_REVENG := SZ4->Z4_ALTENG
	MSMM(EE8->EE8_DESC  ,,,Alltrim(SZ2->Z2_DESCCLI)       ,1,,,"EE8","EE8_DESC")
	MsUnlock()

Endif

dbSelectArea("SZ4")

Return


Static Function ELIMR()

_cIdenCat := StrZero(Val(SZ4->Z4_SEMATU)-1,9)

dbSelectArea("SC6")
dbOrderNickName("INDSC61")
If dbSeek(xFilial("SC6")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + SZ4->Z4_PEDIDO)//+DTOS(SZ4->Z4_DTENT))
	
	_cChavSC6 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI
	
	ProcRegua(LastRec())
	
	While !Eof() .And. _cChavSC6 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI
		
		If !Empty(SC6->C6_BLQ) .Or. SC6->C6_PEDAMOS == "D"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If SC6->C6_QTDVEN == SC6->C6_QTDENT
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If	Alltrim(SC6->C6_IDENCAT) == DTOS(MV_PAR01)//SZ4->Z4_SEMATU
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
		
		If SB1->B1_TIPO == "FR"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
				
		SC6->(RecLock("SC6",.F.))
		SC6->(dbDelete())
		SC6->(MsUnlock())
		                
		_cPedExp := ""
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial("SC5")+SC6->C6_NUM)
			_cPedExp := SC5->C5_PEDEXP
			SC5->(RecLock("SC5",.F.))
			SC5->C5_LIBEROK  := ""
    		SC5->(MsUnlock())
		Endif
		                     
		SC9->(dbSetOrder(1))
		If SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM + SC6->C6_ITEM ))
			SC9->(RecLock("SC9",.F.))
			SC9->(dbDelete())
			SC9->(MsUnLock())
		Endif 

		dbSelectarea("EE8")
		dbOrderNickName("INDEE81")
		If dbSeek(xFilial("EE8")+_cPedExp+SC6->C6_ITEM)
			RecLock("EE8",.F.)
			dbDelete()
			MsUnlock()			
		Endif
		
		dbSelectarea("EE8")
		dbSetOrder(1)
		If !dbSeek(xFilial("EE8")+SC6->C6_NUM)
			dbSelectArea("EE7")
			dbSetOrder(1)
			If dbSeek(xFilial("EE7")+_cPedExp)
				dbSelectArea("EE7")
				RecLock("EE7",.F.)
				dbDelete()
				MsUnlock()
			Endif
		Endif
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
Endif

Return

Static Function ZeraPed()

dbSelectArea("SC6")
dbOrderNickName("INDSC61")
If dbSeek(xFilial("SC6")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + SZ4->Z4_PEDIDO)
	
	_cChavSC6 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI
	While !Eof() .And. 	_cChavSC6 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI
		
		If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. !Empty(SC6->C6_BLQ)
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_IDENCAT := ""
		MsUnlock()
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
Endif

//_nQtPasy  := 0       
_nQtCate  := SZ4->Z4_QTACUM
                                  
dbSelectArea("SD2")
dbOrderNickName("INDSD25")
If dbSeek(xFilial("SD2")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI )//+ ALLTRIM(SZ4->Z4_PEDIDO))

	_cChav  := SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI //+ ALLTRIM(SZ4->Z4_PEDIDO)

	While !Eof () .And. _cChav == SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD + SD2->D2_PROCLI //+ ALLTRIM(SD2->D2_PEDCLI)

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
		 
		If ALLTRIM(SZ4->Z4_PEDIDO) == ALLTRIM(_cPedido)
			_nQtPasy += _nQuanti
    	Endif
    	
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif
            
dbSelectArea("SZD")
dbSetOrder(2)
If dbSeek(xFilial("SZD")+SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + ALLTRIM(SZ4->Z4_PEDIDO))
                            
	_cChavSZ4 := SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + ALLTRIM(SZ4->Z4_PEDIDO)	

	ProcRegua(LastRec())
	
	While !Eof() .And. _cChavSZ4 == SZD->ZD_CLIENTE + SZD->ZD_LOJA + SZD->ZD_PRODUTO + SZD->ZD_CODCLI  + ALLTRIM(SZD->ZD_PEDCLI)
				
		If SZD->ZD_TIPO == "1"
			_nQtPasy +=  SZD->ZD_QUANT
		Else
			_nQtPasy -=  SZD->ZD_QUANT
		Endif			
			
		dbSelectArea("SZD")
		dbSkip()
	EndDo	
Endif

Return