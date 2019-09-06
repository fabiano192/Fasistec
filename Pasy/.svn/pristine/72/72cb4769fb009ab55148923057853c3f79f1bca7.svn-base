#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄsÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0152   ³ Autor ³ Fabiano da Silva      ³ Data ³ 17.01.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualizaçao tabela SZ4 ref. Programacao de Entrega         ³±±
±±             RND001 VERSÃO 8                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat AGCO 	                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0152()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private _nPula,_lPrim,_cItem,_lAchou,_nPrcVen,_cNum,_lVerFat, _lIncSC6, _cPedido
Private _lIncSC6 		:= .F.
Private _nTotQt  		:= 0
Private cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Private cDesc3         	:= "Programacao de Entrega AGCO Periodo:"
Private cPict          	:= ""
Private titulo         	:= "Programacao de Entrega AGCO Periodo:"
Private nLin           	:= 80
Private Cabec1         	:= ""
Private Cabec2         	:= ""
Private imprime        	:= .T.
Private aOrd           	:= {}
Private lEnd           	:= .F.
Private lAbortPrint    	:= .F.
Private CbTxt          	:= ""
Private limite         	:= 132
Private tamanho        	:= "M"
Private nomeprog       	:= "PA0152"
Private nTipo          	:= 18
Private aReturn        	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey       	:= 0
Private cPerg          	:= "PA0058"
Private cbtxt          	:= Space(10)
Private cbcont         	:= 00
Private CONTFL         	:= 01
Private m_pag          	:= 01
Private wnrel          	:= "PA0152"
Private cString 	   	:= "SZ4"
                       	
SZ4->(dbSetOrder(1))

pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

If aReturn[4]==1
	nTipo  := 15
	_nPula := 65
Else
	nTipo  := 18
	_nPula := 57
Endif

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA152A(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| PA152B(@_lFim) }
_cTitulo01 := 'Integrando os Pedidos...'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return


Static Function PA152A(_lFim)

Pergunte("PA0058",.F.)

aStru := {}
AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
AADD(aStru,{"CLIENTE"  , "C" , 06, 0 })
AADD(aStru,{"LOJA"     , "C" , 02, 0 })
cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PRODCLI"
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
_aPedido   := {}
_cDesenho  := ""

_cData2    := GravaData(dDataBase,.f.,8)
_cHora2    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
_dDt       := dDataBase - 20

ProcRegua(20)

For Z:= _dDt TO dDataBase
	
	IncProc()
	
 	_aArqTxt:=ARRAY(ADIR("\\SERVER2\ERP\EDI\SAWLUZ\AGCO\ENTRADA\DE_AGCO*.TXT"))
//	_aArqTxt:=ARRAY(ADIR("\\SERVER2\ERP\PROTHEUS10\MP_DATA\AGCO\ENTRADA\DE_AGCO*.TXT"))
	ADIR("\\SERVER2\ERP\EDI\SAWLUZ\AGCO\ENTRADA\DE_AGCO*.TXT",_aArqTxt)
//	ADIR("\\SERVER2\ERP\PROTHEUS10\MP_DATA\AGCO\ENTRADA\DE_AGCO*.TXT",_aArqTxt)
	
	For I:= 1 to Len(_aArqTxt)
		
		_lAchou    := .t.
		_lProx     := .F.
		_cArq2    := "\\SERVER2\ERP\EDI\SAWLUZ\AGCO\ENTRADA\BKP\BKP_EM"+_cData2+_cHora2+"_"+Alltrim(_aArqTxt[i])
//		_cArq2    := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\AGCO\ENTRADA\BKP\BKP_EM"+_cData2+_cHora2+"_"+Alltrim(_aArqTxt[i])
 		_cArq3    := "\\SERVER2\ERP\EDI\SAWLUZ\AGCO\ENTRADA\"+Alltrim(_aArqTxt[i])
//		_cArq3    := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\AGCO\ENTRADA\"+Alltrim(_aArqTxt[i])
		
		_cArqNovo := fCreate(Alltrim(_cArq2),0)
		_cArq     := FOpen(_cArq3,0)
		_cQtArq    := 1
		
		While .T.
			
			cLinha := fReadStr(_cArq,130)
			
			If Len(cLinha) == 0
				Exit
			Endif
			
			If Subs(cLinha,1,3) == "ITP"
				_cCont   := Subst(cLinha,9,5)
				_dDTMov  := Ctod(Subst(cLinha,18,2)+"/"+Subst(cLinha,16,2)+"/20"+Subst(cLinha,14,2))
				
				SA1->(dbSetOrder(3))
				If SA1->(dbSeek(xFilial("SA1")+Subst(cLinha,26,14)))
					_cCliente := SA1->A1_COD
					_cLoja    := SA1->A1_LOJA
				Endif
			ElseIf Subs(cLinha,1,3) == "PE1"
				_nQt       := 0
				_lProx     := .T.
				_cSemAtu   := Subs(cLinha,7,9)
				_cSemAtu2  := Subs(cLinha,7,9)
				_dDtAtu    := Ctod(Subst(cLinha,20,2)+"/"+Subst(cLinha,18,2)+"/20"+Subst(cLinha,16,2))
				_cSemAnt   := Subs(cLinha,22,9)
				_cProdCli  := Subs(cLinha,37,15)
//				_cPedido   := Subs(cLinha,97,12)
				_cProdPasy := ""
				_cUm       := Subs(cLinha,125,2)
				
				SZ2->(dbSetOrder(6))
				If SZ2->(dbSeek(xFilial("SZ2")+_cCliente + _cLOja + _cProdCli+"1"))
					_cProdPasy := SZ2->Z2_PRODUTO
					SZ2->(RecLock("SZ2",.F.))
					SZ2->Z2_UM  := _cUm
					SZ2->(MsUnlock())
				Else
					TRB->(RecLock("TRB",.T.))
					TRB->PRODCLI := SZ4->Z4_PRODCLI
					TRB->CLIENTE := _cCliente
					TRB->LOJA    := _cLoja
					TRB->(MsUnlock())
				Endif
				
				_cLocDest := Subs(cLinha,109,5)
				_cContato := Subs(cLinha,114,11)
				_cTipo    := Subs(cLinha,128,1)
			ElseIf Subs(cLinha,1,3) == "PE2"
				_cUltNf   := Subs(cLinha,10,6)
				_cSerNf   := Subs(cLinha,16,4)
				_dDtUltNf := Ctod(Subst(cLinha,24,2)+"/"+Subst(cLinha,22,2)+"/20"+Subst(cLinha,20,2))
			ElseIf Subs(cLinha,1,3) == "PE3"
				_nQt   := 12
				
				_aQuant := {}
				
				For A:= 1 to 7
					_nQtEnt := Val(Subs(cLinha,_nQt,9))
					
					If !Empty(_nQtEnt)
						AADD(_aQuant,{_nQtEnt})
						_nQt   += 17
					Else
						A:= 7
					Endif
				Next A
			ElseIf Subs(cLinha,1,3) == "PE5"
				_nQtDt  := 4				                    
				_cPedido:= ""
				_aDtEnt := {}
				For A:= 1 to 7
					_dDtEnt  := Ctod(Subst(cLinha,_nQtDt+4,2)+"/"+Subst(cLinha,_nQtDt+2,2)+"/20"+Subst(cLinha,_nQtDt,2))
					_cPedido := Subs(cLinha,_nQtDt+7,9)
					If !Empty(_dDtEnt)
						AADD(_aDtEnt,{_dDtEnt,_cPedido})
						_nQtDt += 16
					Else
						A:= 7
					Endif
				Next A
				
				_aTpPed  := {}
				_nPed    := 10
				
				If !Empty(_cProdPasy)
					SZ4->(dbSetOrder(4))
					If SZ4->(dbSeek(xFilial("SZ4")+Dtos(MV_PAR01)+ _cCliente + _cLoja + _cProdPasy))
						_cChavProg := Dtos(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS
						
						While SZ4->(!Eof()) .And. _cChavProg == DTOS(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS
							
							If _cSemAtu == _cSemAtu2 .And. UPPER(SZ4->Z4_NOMARQ)  != DTOS(_dDt)+"\"+UPPER(Alltrim(_aArqTxt[i]))
								SZ4->(RecLock("SZ4",.F.))
								SZ4->(dbDelete())
								SZ4->(MsUnlock())
							Endif
							
							SZ4->(dbSkip())
						EndDo
					Else
						_lProx := .F.
					Endif
				Endif
				
				For B:= 1 To Len(_aDtEnt)
					
					If !Empty(_cProdPasy)
						SZ4->(dbSetOrder(4))
						If SZ4->(dbSeek(xFilial("SZ4")+Dtos(MV_PAR01)+ _cCliente + _cLoja + _cProdPasy +Dtos(_aDTEnt[B,1]) ))
							_cChavProg := Dtos(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + DTOS(SZ4->Z4_DTENT)
							
							While SZ4->(!Eof()) .And. _cChavProg == DTOS(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + DTOS(SZ4->Z4_DTENT)
								
								If _cSemAtu == _cSemAtu2 .And. UPPER(SZ4->Z4_NOMARQ)  != DTOS(_dDt)+"\"+UPPER(Alltrim(_aArqTxt[i]))
									SZ4->(RecLock("SZ4",.F.))
									SZ4->(dbDelete())
									SZ4->(MsUnlock())
								Endif
								
								SZ4->(dbSkip())
							EndDo
						Else
							_lProx := .F.
						Endif
					Endif
					
					_cTpPed    := Subs(cLinha,_nPed,1)
					
					_nPed += 16
					SZ4->(RecLock("SZ4",.T.))
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
					SZ4->Z4_ULTNF   := "000"+_cUltNf
					SZ4->Z4_SERIE   := Strzero(Val(_cSerNf),1)
					SZ4->Z4_DTULTNF := _dDtUltNf
					SZ4->Z4_DTENT   := _aDTEnt[B,1]
					SZ4->Z4_QTENT   := _aQuant[B,1]
					SZ4->Z4_PEDIDO  := _aDTEnt[B,2]
					SZ4->Z4_TPPED   := _cTpPed
					SZ4->Z4_CONTATO := _cContato
					SZ4->Z4_DTDIGIT := MV_PAR01
					SZ4->Z4_NOMARQ  := DTOS(_dDt)+"\"+UPPER(Alltrim(_aArqTxt[i]))
					SZ4->(MsUnlock())
				Next B
				
				_cSemAtu2 := ""
			ElseIf Subs(cLinha,1,3) == "PE6"
				_cDesenho := Subs(cLinha,14,4)
				If SZ4->(dbSeek(xFilial("SZ4") + _cCont + _cCliente + _cLoja + _cProdCli))
					_cChavSZ4 :=  SZ4->Z4_CONTROL + SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI
					While SZ4->(!Eof()) .And.  _cChavSZ4 ==  SZ4->Z4_CONTROL + SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI
						SZ4->(RecLock("SZ4",.F.))
						SZ4->Z4_ALTTEC  := _cDesenho
						SZ4->(MsUnlock())
						
						SZ4->(dbSkip())
					EndDo
				Endif
			Endif
			
			FWrite(_cArqNovo,cLinha)
		EndDo
		
		fClose(_cArq2)
		
		If File(_cArq3)
			FClose(_cArq)
			FErase(_cArq3)
		Endif
	Next I
	
	_dDt++
	
Next Z

Return (Nil)


Static Function PA152B(_lFim)

Private _nPula,_lPrim,_cItem,_cItemExp,_lAchou,_nPrcVen,_cNum,_lVerFat, _lIncSC6, _cPedido
Private _lIncSC6 := .F.
Private _nTotQt  := 0

SZ4->(dbSetOrder(1))

Private _lNAchou   := .F.
_lFim      := .F.

_lNAchou := .F.

_cq  := "UPDATE SD2010 SET D2_PROGENT = 0 WHERE D2_CLIENTE = '000001' "

TCSQLEXEC(_cq)
_cq1  := "UPDATE SC6010 SET C6_LA = '' WHERE C6_CLI = '000001' AND D_E_L_E_T_ = '' "

TCSQLEXEC(_cq1)

_lEntr := .F.
  
SZ4->(dbSetOrder(4))
If SZ4->(dbSeek(xFilial("SZ4")+DTOS(MV_PAR01),.F.))
	
	ProcRegua(RecCount())
	
	While SZ4->(!Eof()) .And. SZ4->Z4_DTDIGIT == MV_PAR01
		
		_lPrim     := .F.
		_nTotQt    := 0
		_cItem     := "00"
		_cClieLoja := SZ4->Z4_CODCLI + SZ4->Z4_LOJA
		
		While SZ4->(!Eof()) .And.	_cClieLoja == SZ4->Z4_CODCLI + SZ4->Z4_LOJA .And. SZ4->Z4_DTDIGIT == MV_PAR01
			
			If SZ4->Z4_CODCLI != "000001"
				SZ4->(dbSkip())
				Loop
			Endif
			
			IncProc()
			
			_cProdCli := SZ4->Z4_PRODCLI
			_nSubQt   := 0
			
			SZ2->(dbSetOrder(1))
			If SZ2->(!dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS+SZ4->Z4_PRODCLI+"1"))
				SZ4->(dbSkip())
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
			SB1->(dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS))
			
			ZERAPED()
						
			_nPrcVen := nValor
			
			_lVerFat := .t.
			_aPedCli := {}
			
			While SZ4->(!Eof()) .And. _cProdCli == SZ4->Z4_PRODCLI
				
				If _lFim
					Alert("Cancelado Pelo Usuario!!!!!!")
					Return
				Endif
				
				INTSC6C()
				
				SZ4->(RecLock("SZ4",.F.))
				SZ4->Z4_INTEGR := "S"
				SZ4->Z4_IMPRES := "S"
				SZ4->(MsUnlock())
				
				_lEntr := .T.

				_cPedCli := SZ4->Z4_PEDIDO
				_cIdCat  := SZ4->Z4_SEMATU
				
				AADD(_aPedCli,{_cPedCli,_cProdCli,_cIdCat})
				_nRecSz4 := SZ4->(Recno())
				SZ4->(dbSkip())
			EndDo
			
			SZ4->(dbGoto(_nRecSZ4))
			
			
			SZ4->(dbSkip())
		EndDo
	EndDo
Endif
//Inicio da Eliminação de Resíduo
If _lEntr
	_cq3  := " UPDATE SC6010 SET C6_BLQ = 'R', C6_XDTELIM = '"+DTOS(dDataBase)+"', C6_LOCALIZ = 'PA0152' "
	_cq3  += " WHERE C6_LA <> 'OK' AND D_E_L_E_T_ = '' AND C6_PEDAMOS IN ('N','M','I','Z') AND C6_QTDENT < C6_QTDVEN AND C6_CLI = '000001' "
	_cq3  += " AND C6_BLQ = '' AND C6_CPROCLI <> '' " //AND C6_LOJA NOT IN ('03','04') "

	TCSQLEXEC(_cq3)
Endif

// Fim da eliminação de resíduo

cDesc1 := cDesc2 := cDesc3 := ""
nLin   := 80

TRB->(dbGotop())

If !Empty(TRB->PRODCLI)
	
	ProcRegua(TRB->(RecCount()))
	
	While TRB->(Eof())
		
		IncProc()
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		@nLin,00  PSAY "PRODUTO CLIENTE NAO CADASTRADO "+TRB->PRODCLI+" "+TRB->CLIENTE+"-"+TRB->LOJA
		nLin++
		
		TRB->(dbSkip())
	EndDo
	
	SET DEVICE TO SCREEN
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
Endif

TRB->(dbCloseArea())

Return (Nil)


Static Function IntSC6C()

_nFatur  := 0
_nQuanti := 0
                             
_cNF := SZ4->Z4_ULTNF
_lOk := .F.
SF2->(dbSetOrder(1))
If SF2->(dbSeek(xFilial("SF2")+SZ4->Z4_ULTNF+SZ4->Z4_SERIE))
	_cNF := SZ4->Z4_ULTNF
	_lOk := .T.
Endif

If !_lOk 
	SF2->(dbSetOrder(1))
	If SF2->(dbSeek(xFilial("SF2")+Substr(SZ4->Z4_ULTNF,4,6)+"   "+SZ4->Z4_SERIE))
		_cNF := Substr(SZ4->Z4_ULTNF,4,6)+"   "
	Endif
Endif
		
If VAL(_cNF) > 0
	_cUltNf := _cNF + "01"
Else
	_cUltNf := "000000001"
Endif

//SD2->(dbOrderNickName("INDSD26"))
//SD2->(dbSeek(xFilial("SD2")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + _cUltNf,.T.))

SD2->(dbOrderNickName("INDSD23"))
SD2->(dbSeek(xFilial("SD2")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_SERIE + _cUltNf,.T.))

_cChav  := SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS

While SD2->(!Eof()) .And. _cChav == SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD
	
	If SD2->D2_DOC <= _cNF .And. SD2->D2_EMISSAO <= SZ4->Z4_DTULTNF
		SD2->(dbSkip())
		Loop
	Endif

	If SD2->D2_EMISSAO < SZ4->Z4_DTULTNF
		SD2->(dbSkip())
		Loop
	Endif
	
	If SD2->D2_QUANT == SD2->D2_PROGENT
		SD2->(dbSkip())
		Loop
	Endif
	
	SC6->(dbSetOrder(1))
	If SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV))
		If Alltrim(SC6->C6_PEDCLI) != Alltrim(SZ4->Z4_PEDIDO)
			SD2->(dbSkip())
			Loop
		Endif
	Endif
	
	If SD2->D2_QUANT == SD2->D2_QTDEDEV
		SD2->(dbSkip())
		Loop
	Endif		

	_nQuanti := SD2->D2_QUANT - SD2->D2_QTDEDEV	

	_nFatur2 := _nFatur
	_nFatur  += _nQuanti - SD2->D2_PROGENT
	
	If _nFatur >= SZ4->Z4_QTENT
		_nDif  := SZ4->Z4_QTENT - _nFatur2
	Else
		_nDif  := _nQuanti - SD2->D2_PROGENT
	Endif
	
	SD2->(RecLock("SD2",.F.))
	SD2->D2_PROGENT += _nDif
	SD2->(MsUnlock())
	
	If _nFatur >= SZ4->Z4_QTENT
		Return
	Endif
	
	SD2->(dbSkip())
EndDo

_lAchou   := .F.

SC6->(dbOrderNickName("INDSC61"))
If SC6->(dbSeek(xFilial("SC6")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + SZ4->Z4_PEDIDO + DTOS(SZ4->Z4_DTENT)))
	
	_cChavSC62 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI +DTOS(SC6->C6_ENTREG)
	
	While SC6->(!Eof()) .And. 	_cChavSC62 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI + DTOS(SC6->C6_ENTREG)
		
		If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. !Empty(SC6->C6_BLQ)
			SC6->(dbSkip())
			Loop
		Endif
		
		If (SC6->C6_QTDVEN - SC6->C6_QTDENT) != SZ4->Z4_QTENT - _nFatur
			SC6->(dbSkip())
			Loop
		Endif
		
		If SC6->C6_PEDCLI = "999999999"
			SC6->(dbSkip())
			Loop
		Endif

		SC6->(RecLock("SC6",.F.))
		SC6->C6_LA 		:= "OK"
		SC6->C6_IDENCAT := SZ4->Z4_SEMATU
		If SZ4->Z4_TPPED = "1"
			SC6->C6_PEDAMOS := "N"
		Endif
		SC6->C6_PEDCLI  := SZ4->Z4_PEDIDO
		SC6->(MsUnlock())
		
		_lAchou := .T.
		
		SC6->(dbSkip())
	EndDo
Endif

If !_lAchou
	
	_lVerFat := .F.
	_cItem   := SomaIt(_cItem)

	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA))		
	
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
		SC5->C5_CLIENTE := SZ4->Z4_CODCLI
		SC5->C5_CLIENT  := SZ4->Z4_CODCLI
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
		SC5->(MsUnlock())
	Endif
	
	SF4->(dbSetOrder(1))
	SF4->(dbSeek(xFilial("SF4")+SZ2->Z2_TES))
	
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS))
	
	SC6->(RecLock("SC6",.T.))
	SC6->C6_FILIAL  := xFilial("SC6")
	SC6->C6_NUM     := _cNUm
	SC6->C6_ITEM    := _cItem
	SC6->C6_CPROCLI := SZ4->Z4_PRODCLI
	SC6->C6_PRODUTO := SZ4->Z4_PRODPAS
	SC6->C6_REVPED  := SZ4->Z4_ALTTEC
	SC6->C6_QTDVEN  := SZ4->Z4_QTENT - _nFatur
	SC6->C6_PRCVEN  := _nPrcVen
	SC6->C6_VALOR   := Round(( (SZ4->Z4_QTENT - _nFatur) * _nPrcVen ),2)
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
	SC6->C6_DESCRI  := SB1->B1_DESC
	SC6->C6_LOCAL   := SB1->B1_LOCPAD
	SC6->C6_CLI     := SZ4->Z4_CODCLI
	SC6->C6_LOJA    := SZ4->Z4_LOJA
	SC6->C6_PRUNIT  := _nPrcVen
	SC6->C6_TPOP    := "F"
	SC6->C6_IDENCAT := SZ4->Z4_SEMATU
	SC6->C6_LA 		:= "OK"
	SC6->C6_CLASFIS := SUBSTR(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB	
	SA3->(dbSetOrder(1))
	If SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND))
		SC6->C6_COMIS1   := SA3->A3_COMIS
	Endif
	SC6->(MsUnlock())
Endif

Return (Nil)


Static Function ZeraPed()

_cChavSC6 := SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + SZ4->Z4_PEDIDO

_cq  := " UPDATE SC6010 C6 SET C6_IDENCAT = '' WHERE '"+_cChavSC6+"' = C6_CLI + C6_LOJA + C6_PRODUTO + C6_CPROCLI"
_cq  += " AND C6_QTDVEN > C6_QTDENT AND C6_BLQ = '' AND C6.D_E_L_E_T_ = '' "

TCSQLEXEC(_cq)

Return (Nil)
