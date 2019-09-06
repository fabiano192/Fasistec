#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ PA0133   ³ Autor ³ Fabiano da silva      ³ Data ³ 30.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio Referente aos Acrescimos/Decrescimos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0133()

Private titulo 	 := "Relatorio Financeiro"
Private cDesc1 	 := "Relatorio Financeiro por Natureza"
Private cDesc2 	 := ""
Private cDesc3 	 := ""
Private cabec1	 := ""
Private cabec2   := ""
Private tamanho	 := "M"
Private limite 	 := 132
Private cString	 := "SE1"
Private nOrdem 	 := 0
Private nTipo    := 18
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog := "PA0133"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg    := "PA0133"
Private lAbortPrint  := .F.

cbtxt    		 := SPACE(10)
cbcont   		 := 0
li       		 :=80
m_pag    		 :=1

pergunte("PA0133",.F.)

///////////////////////////////////////
///// MV_PAR01 : Tipo ?            ////
///// MV_PAR02 : Data De ?         ////
///// MV_PAR03 : Data Ate ?        ////
///// MV_PAR04 : Natureza ?        ////
///// MV_PAR05 : Titulo de ?       ////
///// MV_PAR06 : Titulo ate ?      ////
///// MV_PAR07 : Banco de ?        ////
///// MV_PAR08 : Banco ate ?       ////
///////////////////////////////////////

wnrel:="PA0133"
aOrd :={}

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.

If MV_PAR01 = 2 .Or. MV_PAR01 = 4
	If MV_PAR01 = 2
		Private _bAcao01   := {|_lFim| PREVI(@_lFim) }
		Private _cTitulo01 := 'Processando'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	Else
		Private _bAcao01   := {|_lFim| PROJE(@_lFim) }
		Private _cTitulo01 := 'Processando'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	Endif	

	dbSelectArea("SE1A")
	dbCloseArea()

	dbSelectArea("SE2A")
	dbCloseArea()

ElseIf MV_PAR01 = 1 .Or. MV_PAR01 = 3
	If MV_PAR01 = 1
		Private _bAcao01   := {|_lFim| APROP(@_lFim) }
		Private _cTitulo01 := 'Processando'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

		dbSelectArea("SE1A")
		dbCloseArea()

		dbSelectArea("SE2A")
		dbCloseArea()

		dbSelectArea("SE5A")
		dbCloseArea()

	Else	
		Private _bAcao01   := {|_lFim| REALI(@_lFim) }
		Private _cTitulo01 := 'Processando'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
		
		dbSelectArea("SE5Q")
		dbCloseArea()

	Endif	

Endif

_bAcao01   := {|_lFim| IMPRIME(@_lFim) }
_cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("TMP")
dbCloseArea()

Return


Static Function APROP(_lFim)

aCampos := {}
AADD(aCampos,{ "TP"       ,"C", 01, 0 } )
AADD(aCampos,{ "CLIFOR"   ,"C", 06, 0 } )
AADD(aCampos,{ "LOJA"     ,"C", 02, 0 } )
AADD(aCampos,{ "TITUL"    ,"C", 09, 0 } )
AADD(aCampos,{ "EMISS"    ,"D", 08, 0 } )
AADD(aCampos,{ "DATAV"    ,"D", 08, 0 } )
AADD(aCampos,{ "BANCO"    ,"C", 03, 0 } )
AADD(aCampos,{ "NATORI"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRORI"   ,"N", 14, 2 } )
AADD(aCampos,{ "NATACR"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRACR"   ,"N", 14, 2 } )
AADD(aCampos,{ "NATDEC"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRDEC"   ,"N", 14, 2 } )

cArqLOG := CriaTrab(aCampos,.T.)
cIndLOG := "TP+DTOS(DATAV)"
dbUseArea(.T.,,cArqLOG,"TMP",.F.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",cArqLog,cIndLog,,,"Criando Trabalho...")


_dUltFech := GETMV("MV_PA0108")  // Data da Ultima Apuração do resultado
_dDtInic := _dUltFech + 1


_cQ := " SELECT * FROM "+RetSqlName("SE1")+" E1 "
_cQ += " INNER JOIN "+RetSqlName("SED")+" ED ON E1_NATUREZ = ED_CODIGO "
_cQ += " WHERE ED.D_E_L_E_T_ = '' AND E1.D_E_L_E_T_ = ''"
_cQ += " AND ED_CODIGO = '"+MV_PAR04+"'"
//_cQ += " AND E1_TIPO NOT IN 'AB-'"
_cQ += " ORDER BY E1_EMISSAO "

TCQUERY _cQ NEW ALIAS "SE1A"

TCSETFIELD("SE1A","E1_EMISSAO","D")
TCSETFIELD("SE1A","E1_VENCTO","D")

dbSelectArea("SE1A")

ProcRegua(U_CONTREG())
                                                   
While !Eof()
	
	IncProc("Processando Natureza: "+SE1A->ED_CODIGO)
	
	If !Empty(SE1A->E1_FATURA).And. SE1A->E1_FATURA != "NOTFAT"
		dbSelectArea("SE1A")
		dbSkip()
		Loop
	Endif
		
	If ALLTRIM(SE1A->ED_CODIGO) $ "1086/1087/2304" .And. SE1A->E1_EMISSAO < MV_PAR02
		dbSelectArea("SE1A")
		dbSkip()
		Loop
	Endif
		
	If SE1A->E1_EMISSAO < MV_PAR02
		_nValSE5 := 0
		_nMesSE5 := 0
		If 	!SUBSTR(SE1A->ED_GRGEREN,1,1) $ "3/4/5" .And. SE1A->ED_CONSBX != "N"
			dbSelectArea("SE5")
			dbSetOrder(7)
			If dbSeek(xFilial("SE5")+SE1A->E1_PREFIXO + SE1A->E1_NUM + SE1A->E1_PARCELA + SE1A->E1_TIPO + SE1A->E1_CLIENTE + SE1A->E1_LOJA)
					
				_cChavSE5 := SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
					
				While !Eof() .And. _cChavSE5 == SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
						
					If !Empty(SE5->E5_SITUACA )
						dbSelectArea("SE5")
						dbSkip()
						Loop
					Endif
						
					IF SE5->E5_TIPODOC $ "ES/MT/JR/DC/D2/J2/TL/M2/CM/C2/CH/CA/EC/E2/BD/RA/CB"
						dbSelectArea("SE5")
						dbSkip()
						Loop
					Endif
						
					If SE5->E5_DTDISPO >= MV_PAR02
						If SE5->E5_TIPODOC $ "ES"
							_nMesSE5 -= (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
						Else
							_nMesSE5 += (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
						Endif
					Endif
					
					dbSelectArea("SE5")
					dbSkip()
				EndDo
			Endif
		Endif
                                     
		If _nMesSE5 = 0
			dbSelectArea("SE1A")
			dbSkip()
            Loop
		Endif

		dbSelectArea("TMP")
		RecLock("TMP",.T.)              
		If SE1A->E1_TIPO $ "RA /NCC/AB-/VNR"
			TMP->TP   := "B"
		Else
			TMP->TP   := "A"
		Endif	
		TMP->CLIFOR   := SE1A->E1_CLIENTE
		TMP->LOJA     := SE1A->E1_LOJA
		TMP->TITUL    := SE1A->E1_NUM
		TMP->EMISS    := SE1A->E1_EMISSAO
		TMP->DATAV    := SE1A->E1_VENCTO     
		TMP->NATORI   := SE1A->E1_NATUREZ		
		TMP->VLRORI   := _nMesSe5
/*		If _lVaiO
			TMP->NATORI   := SE1A->E1_NATUREZ
			TMP->VLRORI   := _nVlrO
		Endif
		If _lVaiA
			TMP->NATACR   := SE1A->E1_NATOUT
			TMP->VLRACR   := _nVlrA
		Endif
		If _lVaiD
			TMP->NATDEC   := SE1A->E1_NATOUT2
			TMP->VLRDEC   := _nVlrD * -1
		Endif  */
		MsUnlock()
  
	Endif

	dbSelectArea("SE1A")
	dbSkip()
EndDo

_cQ := " SELECT * FROM "+RetSqlName("SE2")+" E2 "
_cQ += " INNER JOIN "+RetSqlName("SED")+" ED ON E2_NATUREZ = ED_CODIGO "
_cQ += " WHERE ED.D_E_L_E_T_ = '' AND E2.D_E_L_E_T_ = ''"
_cQ += " AND ED_CODIGO = '"+MV_PAR04+"'"
//_cQ += " AND E2_EMIS1 < '"+DTOS(MV_PAR03)+"'"
_cQ += " ORDER BY E2_EMIS1 "
                             
TCQUERY _cQ NEW ALIAS "SE2A"

TCSETFIELD("SE2A","E2_EMIS1","D")
TCSETFIELD("SE2A","E2_VENCTO","D")

dbSelectArea("SE2A")

ProcRegua(U_CONTREG())
                                                   
While !Eof()
	
	IncProc("Processando Natureza: "+SE2A->ED_CODIGO)

	If !Empty(SE2A->E2_FATURA) .And. SE2A->E2_FATURA != "NOTFAT"
		dbSelectArea("SE2A")
		dbSkip()
		Loop
	Endif
		
	If SED->ED_CODIGO $ "2304      " .And. SE2A->E2_EMIS1 < MV_PAR02
		dbSelectArea("SE2A")
		dbSkip()
		Loop
	Endif
				
	If SE2A->E2_EMIS1 < MV_PAR02
		_nMesSE5 := 0
			
		If !SUBSTR(SE2A->ED_GRGEREN,1,1) $ "3/4/5" .And. SE2A->ED_CONSBX != "N"
			dbSelectArea("SE5")
			dbSetOrder(7)
			If dbSeek(xFilial("SE5")+SE2A->E2_PREFIXO + SE2A->E2_NUM + SE2A->E2_PARCELA + SE2A->E2_TIPO + SE2A->E2_FORNECE + SE2A->E2_LOJA)
					
				_cChavSE5 := SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
				
				While !Eof() .And. _cChavSE5 == SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
						
					If !Empty(SE5->E5_SITUACA)
						dbSelectArea("SE5")
						dbSkip()
						Loop
					Endif
						
					IF SE5->E5_TIPODOC $ "ES/MT/JR/DC/D2/J2/TL/M2/CM/C2/CH/CA/EC/E2/BD/PA/CB"
						dbSelectArea("SE5")
						dbSkip()
						Loop
					Endif
						
					If SE5->E5_DTDISPO >= MV_PAR02
						IF SE5->E5_TIPODOC $ "ES"
							_nMesSE5 -= (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
						Else
							_nMesSE5 += (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
						Endif
					Endif
						
					dbSelectArea("SE5")
					dbSkip()
				EndDo
			Endif                    
			
			If _nMesSE5 != 0

				dbSelectArea("TMP")
				RecLock("TMP",.T.)                 
				If SE2A->E2_TIPO $ "NDF/AB-/VNP"		
					TMP->TP   := "B"
				Else
					TMP->TP   := "A"
				Endif	
				TMP->CLIFOR   := SE2A->E2_FORNECE
				TMP->LOJA     := SE2A->E2_LOJA
				TMP->TITUL    := SE2A->E2_NUM
				TMP->EMISS    := SE2A->E2_EMIS1
				TMP->DATAV    := SE2A->E2_VENCTO
				TMP->NATORI   := SE2A->E2_NATUREZ			
				TMP->VLRORI   := _nMesSE5
/*		If _lVaiO
			TMP->NATORI   := SE2A->E2_NATUREZ
			TMP->VLRORI   := _nVlrO
		Endif
		If _lVaiA
			TMP->NATACR   := SE2A->E2_NATOUT
			TMP->VLRACR   := _nVlrA
		Endif
		If _lVaiD
			TMP->NATDEC   := SE2A->E2_NATOUT2
			TMP->VLRDEC   := _nVlrD * -1
		Endif     */
				MsUnlock()
        	Endif
       Endif
	Else

		_nValSE5 := 0
		If 	!SUBSTR(SE2A->ED_GRGEREN,1,1) $ "3/4/5" .And. SE2A->ED_CONSBX != "N"
			dbSelectArea("SE5")
			dbSetOrder(7)
			If dbSeek(xFilial("SE5")+SE2A->E2_PREFIXO + SE2A->E2_NUM + SE2A->E2_PARCELA + SE2A->E2_TIPO + SE2A->E2_FORNECE + SE2A->E2_LOJA)
				
				_cChavSE5 := SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
				
				While !Eof() .And. _cChavSE5 == SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
						
					If !Empty(SE5->E5_SITUACA )
						dbSelectArea("SE5")
						dbSkip()
						Loop
					Endif
					
					IF SE5->E5_TIPODOC $ "ES/MT/JR/DC/D2/J2/TL/M2/CM/C2/CH/CA/EC/E2/BD/PA/CB"
						dbSelectArea("SE5")
						dbSkip()
						Loop
					Endif
						
					If SE5->E5_DTDISPO > MV_PAR03
						dbSelectArea("SE5")
						dbSkip()
						Loop
					Endif
						
					IF SE5->E5_TIPODOC $ "ES"
						_nValSE5 -= (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
					Else
						_nValSE5 += (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
					Endif
						
					dbSelectArea("SE5")
					dbSkip()
				EndDo
			Endif
		Endif
		                                 
		dbSelectArea("TMP")
		RecLock("TMP",.T.)                 
		If SE2A->E2_TIPO $ "NDF/AB-/VNP"		
			TMP->TP   := "B"
		Else
			TMP->TP   := "A"
		Endif	
		TMP->CLIFOR   := SE2A->E2_FORNECE
		TMP->LOJA     := SE2A->E2_LOJA
		TMP->TITUL    := SE2A->E2_NUM
		TMP->EMISS    := SE2A->E2_EMIS1
		TMP->DATAV    := SE2A->E2_VENCTO
		TMP->NATORI   := SE2A->E2_NATUREZ		
		TMP->VLRORI   := SE2A->E2_VALOR
	/*		If _lVaiO
			TMP->NATORI   := SE2A->E2_NATUREZ
			TMP->VLRORI   := _nVlrO
		Endif
			If _lVaiA
				TMP->NATACR   := SE2A->E2_NATOUT
				TMP->VLRACR   := _nVlrA
			Endif
			If _lVaiD
				TMP->NATDEC   := SE2A->E2_NATOUT2
				TMP->VLRDEC   := _nVlrD * -1
			Endif     */
		MsUnlock()
			
		If _nValSE5 != 0
			dbSelectArea("TMP")
			RecLock("TMP",.T.)                 
			If SE2A->E2_TIPO $ "NDF/AB-/VNP"		
				TMP->TP   := "B"
			Else
				TMP->TP   := "A"
			Endif	
			TMP->CLIFOR   := SE2A->E2_FORNECE
			TMP->LOJA     := SE2A->E2_LOJA
			TMP->TITUL    := SE2A->E2_NUM
			TMP->EMISS    := SE2A->E2_EMIS1
			TMP->DATAV    := SE2A->E2_VENCTO
			TMP->NATORI   := SE2A->E2_NATUREZ		
			TMP->VLRORI   := _nValSE5
/*		If _lVaiO
		TMP->NATORI   := SE2A->E2_NATUREZ
			TMP->VLRORI   := _nVlrO
		Endif
		If _lVaiA
			TMP->NATACR   := SE2A->E2_NATOUT
			TMP->VLRACR   := _nVlrA
		Endif
		If _lVaiD
			TMP->NATDEC   := SE2A->E2_NATOUT2
			TMP->VLRDEC   := _nVlrD * -1
		Endif     */
		MsUnlock()
		Endif						                        
	Endif
		
	dbSelectArea("SE2A")
	dbSkip()
EndDo

_cQ := " SELECT * FROM "+RetSqlName("SE5")+" E5 "
_cQ += " INNER JOIN "+RetSqlName("SA6")+" A6 ON E5_BANCO+E5_AGENCIA+E5_CONTA = A6_COD+A6_AGENCIA+A6_NUMCON "
_cQ += " WHERE E5.D_E_L_E_T_ = '' AND A6.D_E_L_E_T_ = ''"
_cQ += " AND E5_SITUACA = '' AND A6_FLUXCAI = 'S'"
_cQ += " AND E5_TIPODOC NOT IN ('ES','TL','M2','CM','C2','CH','EC','RA','PA','CP')"
_cQ += " AND E5_DTDISPO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"'"
_cQ += " ORDER BY E5_DTDISPO "
                                   
TCQUERY _cQ NEW ALIAS "SE5A"

TCSETFIELD("SE5A","E5_DTDISPO","D")

dbSelectArea("SE5A")

While !Eof() .And. !_lFim
		
	If SE5A->E5_NATUREZ $ "2304      " .And. SE5A->E5_DTDISPO  < MV_PAR02
		dbSelectArea("SE5A")
		dbSkip()
		Loop
	Endif
	
	If Alltrim(SE5A->E5_DOCUMEN) = "EX0305"
		_lPare := .T.
	Endif
		
	_lEntr    := .T.
	_cConta   := ""
	_lVaiA    := .F.
	_lVaiD    := .F.
	_lVaiO    := .F.
	_cRecPag  := ""
	_cCliFor  := SE5A->E5_CLIFOR
	_cLoja    := SE5A->E5_LOJA
	_cNumero  := SE5A->E5_NUMERO
	_dDtDispo := SE5A->E5_DTDISPO
	_dEmissao := SE5A->E5_DTDISPO
	_cBanco   := SE5A->A6_COD

	If SE5->E5_TIPODOC $ "VL/BA"
		dbSelectArea("SE1")
		dbSetOrder(1)
		If !dbSeek(xFilial("SE1")+SE5A->E5_PREFIXO + SE5A->E5_NUMERO + SE5A->E5_PARCELA + "AB-")
			dbSelectArea("SE5A")
			dbSkip()
			Loop
		Endif
		
		_cRecPag  := "B"
		_nValor   := SE1->E1_VALOR
		_cNaturez := SE1->E1_NATUREZ
		_lVaiO   := .T.
		Grava()		
	Else
		If SE5A->E5_RECPAG == "R" .And. !Empty(SE5A->E5_TIPO)
			If SE5A->E5_TIPO $ "PA /NDF"
				dbSelectArea("SE2")
				dbSetOrder(1)
				If dbSeek(xFilial("SE2")+SE5A->E5_PREFIXO + SE5A->E5_NUMERO + SE5A->E5_PARCELA + SE5A->E5_TIPO + SE5A->E5_CLIFOR + SE5A->E5_LOJA)
					If SE5A->E5_TIPODOC $ "DC/D2"
						_cConta := SE2->E2_NATOUT2
						_lVaiD  := .T.
					ElseIf SE5A->E5_TIPODOC $ "MT/JR/M2/J2"
						_cConta := SE2->E2_NATOUT
						_lVaiA  := .T.
					Endif
				Endif
			Else
				dbSelectArea("SE1")
				dbSetOrder(1)
				If dbSeek(xFilial("SE1")+SE5A->E5_PREFIXO + SE5A->E5_NUMERO + SE5A->E5_PARCELA + SE5A->E5_TIPO )
					If SE5A->E5_TIPODOC $ "DC/D2"
						_cConta := SE1->E1_NATOUT2
						_lVaiD  := .T.							
					ElseIf SE5A->E5_TIPODOC $ "MT/JR/M2/J2"
						_cConta := SE1->E1_NATOUT 
						_lVaiA  := .T.							
					Endif
				Endif					
			Endif
		ElseIf SE5A->E5_RECPAG == "P" .And. !Empty(SE5A->E5_TIPO)
			If !SE5A->E5_TIPO $ "RA /NCC"
				dbSelectArea("SE2")
				dbSetOrder(1)
				If dbSeek(xFilial("SE2")+SE5A->E5_PREFIXO + SE5A->E5_NUMERO + SE5A->E5_PARCELA + SE5A->E5_TIPO + SE5A->E5_CLIFOR + SE5A->E5_LOJA)
					If SE5A->E5_TIPODOC $ "DC/D2"
						_cConta := SE2->E2_NATOUT2
						_lVaiD  := .T.							
					ElseIf SE5A->E5_TIPODOC $ "MT/JR/M2/J2"
						_cConta := SE2->E2_NATOUT
						_lVaiA  := .T.							
					Endif
				Endif
			Else
				dbSelectArea("SE1")
				dbSetOrder(1)
				If dbSeek(xFilial("SE1")+SE5A->E5_PREFIXO + SE5A->E5_NUMERO + SE5A->E5_PARCELA + SE5A->E5_TIPO )
					If SE5A->E5_TIPODOC $ "DC/D2"
						_cConta := SE1->E1_NATOUT2
						_lVaiD  := .T.							
					ElseIf SE5A->E5_TIPODOC $ "MT/JR/M2/J2"
						_cConta := SE1->E1_NATOUT
						_lVaiA  := .T.							
					Endif
				Endif
			Endif
		Endif

		If !Empty(_cConta)
			If SE5->E5_RECPAG == "R"    
				_cRecPag := "R"
			Else
				_cRecPag := "P"
			Endif           
		Else	
			If SE5A->E5_TIPODOC $ "MT/M2/JR/J2"
				_lVaiA := .T.
				If SE5A->E5_RECPAG == "P"
					_cRecPag := "P"
					_cConta  := "4781"+Space(6)
				Else               
					_cRecPag := "R"					           
					_cConta := "3121"+Space(6)
				Endif
			ElseIf SE5A->E5_TIPODOC $ "DC/D2"
				_lVaiD := .T.
				If SE5A->E5_RECPAG == "P"
					_cRecPag := "R"
					_cConta := "3180"+Space(6)
				Else               
					_cRecPag := "P"					
					_cConta := "4780"+Space(6)
				Endif  
			ElseIf SE5A->E5_TIPODOC $ "V2"
				_lVaiO   := .T.
				_cRecPag := "P"
				_cConta  := "1085"+Space(6)
			Endif			
		Endif
                   
		_nValor := 0
		If _lVaiD
			_nValor   := SE5A->E5_VLDESCO
		ElseIf _lVaiA
			_nValor   := SE5A->E5_VLJUROS
		ElseIf _lVaiO
			_nValor	  := SE5A->E5_VALOR
		Endif
		
		Grava()	
		
	Endif

	dbSelectArea("SE5A")
	dbSkip()
Enddo

Return // Fim Apropriado
              

Static Function Grava() // Usado p/ Apropriado e Realizado

If _nValor != 0
	dbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->TP       := IIf(_cRecPag == "R","A","B")
	TMP->CLIFOR   := _cCliFor
	TMP->LOJA     := _cLoja
	TMP->TITUL    := _cNumero
	TMP->EMISS    := _dEmissao
	TMP->DATAV    := _dDtDispo
	TMP->BANCO    := _cBanco
	If _lVaiO
		TMP->NATORI   := _cConta
		TMP->VLRORI   := _nValor
	Endif
	If _lVaiA
		TMP->NATACR   := _cConta
		TMP->VLRACR   := _nValor
	Endif
	If _lVaiD
		TMP->NATDEC   := _cConta
		TMP->VLRDEC   := _nValor * -1
	Endif
	MsUnlock()
Endif	

Return
  

Static Function PREVI(_lFim)

aCampos := {}
AADD(aCampos,{ "TP"       ,"C", 01, 0 } )
AADD(aCampos,{ "CLIFOR"   ,"C", 06, 0 } )
AADD(aCampos,{ "LOJA"     ,"C", 02, 0 } )
AADD(aCampos,{ "TITUL"    ,"C", 09, 0 } )
AADD(aCampos,{ "EMISS"    ,"D", 08, 0 } )
AADD(aCampos,{ "DATAV"    ,"D", 08, 0 } )
AADD(aCampos,{ "NATORI"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRORI"   ,"N", 14, 2 } )
AADD(aCampos,{ "NATACR"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRACR"   ,"N", 14, 2 } )
AADD(aCampos,{ "NATDEC"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRDEC"   ,"N", 14, 2 } )

cArqLOG := CriaTrab(aCampos,.T.)
cIndLOG := "TP+DTOS(DATAV)"
dbUseArea(.T.,,cArqLOG,"TMP",.F.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",cArqLog,cIndLog,,,"Criando Trabalho...")


_cQ := " SELECT * FROM "+RetSqlName("SE1")+" E1 WHERE E1.D_E_L_E_T_ = '' "
_cQ += " AND E1_VENCTO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
_cQ += " AND E1_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQ += " AND E1_CLIENTE NOT IN ('ZRESUL','ZPROVI') "
_cQ += " ORDER BY E1_VENCTO "

TCQUERY _cQ NEW ALIAS "SE1A"

TCSETFIELD("SE1A","E1_EMISSAO","D")
TCSETFIELD("SE1A","E1_VENCTO" ,"D")
TCSETFIELD("SE1A","E1_BAIXA"  ,"D")

dbSelectArea("SE1A")

ProcRegua(U_CONTREG())
                                                   
_cAno      := Substr(StrZero(Year(MV_PAR02),4),3,2)
_dDtIni    := CTOD("01/01/"+_cAno)

While !Eof()
	
	IncProc()
	
	If 	SE1A->E1_NATUREZ = "1086      "
		_lPare := .T.
	Endif

	If !Empty(SE1A->E1_FATURA).And. SE1A->E1_FATURA != "NOTFAT"
		dbSelectArea("SE1A")
		dbSkip()
		Loop
	Endif
	
	IF !Empty(SE1A->E1_BAIXA) .and. SE1A->E1_BAIXA < _dDtIni .and. SE1A->E1_SALDO == 0
		dbSelectArea("SE1A")
		dbSkip()
		Loop
	EndIF
		
	_lVaiO := .T.
	_lVaiA := .T.
	_lVaiD := .T.
	If SE1A->E1_NATUREZ != MV_PAR04
		_lVaiO := .F.
	Endif
	
	If SE1A->E1_NATOUT != MV_PAR04
		_lVaiA := .F.
	Endif
	
	If SE1A->E1_NATOUT2 != MV_PAR04
		_lVaiD := .F.
	Endif
	
	If !_lVaiO .And. !_lVaiA .And. !_lVaiD
		dbSelectArea("SE1A")
		dbSkip()
		Loop
	Endif
	
	If SE1A->E1_TIPO $ ("NCC/AB-/RA ")
		_nVlrO := SE1A->E1_VALOR   * -1
		_nVlrA := SE1A->E1_ACRESC  * -1
		_nVlrD := SE1A->E1_DECRESC * -1
	Else
		_nVlrO := SE1A->E1_VALOR
		_nVlrA := SE1A->E1_ACRESC
		_nVlrD := SE1A->E1_DECRESC
	Endif
	
	dbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->TP       := "A"
	TMP->CLIFOR   := SE1A->E1_CLIENTE
	TMP->LOJA     := SE1A->E1_LOJA
	TMP->TITUL    := SE1A->E1_NUM
	TMP->EMISS    := SE1A->E1_EMISSAO
	TMP->DATAV    := SE1A->E1_VENCTO
	If _lVaiO
		TMP->NATORI   := SE1A->E1_NATUREZ
		TMP->VLRORI   := _nVlrO
	Endif
	If _lVaiA
		TMP->NATACR   := SE1A->E1_NATOUT
		TMP->VLRACR   := _nVlrA
	Endif
	If _lVaiD
		TMP->NATDEC   := SE1A->E1_NATOUT2
		TMP->VLRDEC   := _nVlrD * -1
	Endif
	MsUnlock()
	
	dbselectArea("SE1A")
	dbSkip()
EndDo

_cQ := " SELECT * FROM "+RetSqlName("SE2")+" E2 WHERE E2.D_E_L_E_T_ = '' "
_cQ += " AND E2_VENCTO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
_cQ += " AND E2_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQ += " AND E2_FORNECE NOT IN ('ZRESUL','ZPROVI') "
_cQ += " ORDER BY E2_VENCTO "

TCQUERY _cQ NEW ALIAS "SE2A"

TCSETFIELD("SE2A","E2_EMISSAO","D")
TCSETFIELD("SE2A","E2_VENCTO" ,"D")
TCSETFIELD("SE2A","E2_BAIXA"  ,"D")

dbSelectArea("SE2A")

ProcRegua(U_CONTREG())

While !Eof()
	
	IncProc()
	
	If !Empty(SE2A->E2_FATURA).And. SE2A->E2_FATURA != "NOTFAT"
		dbSelectArea("SE2A")
		dbSkip()
		Loop
	Endif
	
	IF !Empty(SE2A->E2_BAIXA) .and. SE2A->E2_BAIXA < MV_PAR02 .and. SE2A->E2_SALDO == 0
		dbSelectArea("SE2A")
		dbSkip()
		Loop
	EndIF
	
	_lVaiO := .T.
	_lVaiA := .T.
	_lVaiD := .T.
	If SE2A->E2_NATUREZ != MV_PAR04
		_lVaiO := .F.
	Endif
	
	If SE2A->E2_NATOUT != MV_PAR04
		_lVaiA := .F.
	Endif
	
	If SE2A->E2_NATOUT2 != MV_PAR04
		_lVaiD := .F.
	Endif
	
	If !_lVaiO .And. !_lVaiA .And. !_lVaiD
		dbSelectArea("SE2A")
		dbSkip()
		Loop
	Endif
	
	If SE2A->E2_TIPO $ ("NDF/PA ")
		_nVlrO := SE2A->E2_VALOR   * -1
		_nVlrA := SE2A->E2_ACRESC  * -1
		_nVlrD := SE2A->E2_DECRESC * -1
	Else
		_nVlrO := SE2A->E2_VALOR
		_nVlrA := SE2A->E2_ACRESC
		_nVlrD := SE2A->E2_DECRESC
	Endif
	
	dbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->TP       := "B"
	TMP->CLIFOR   := SE2A->E2_FORNECE
	TMP->LOJA     := SE2A->E2_LOJA
	TMP->TITUL    := SE2A->E2_NUM
	TMP->EMISS    := SE2A->E2_EMISSAO
	TMP->DATAV    := SE2A->E2_VENCTO
	If _lVaiO
		TMP->NATORI   := SE2A->E2_NATUREZ
		TMP->VLRORI   := _nVlrO
	Endif
	If _lVaiA
		TMP->NATACR   := SE2A->E2_NATOUT
		TMP->VLRACR   := _nVlrA
	Endif
	If _lVaiD
		TMP->NATDEC   := SE2A->E2_NATOUT2
		TMP->VLRDEC   := _nVlrD * -1
	Endif
	MsUnlock()
	
	dbselectArea("SE2A")
	dbSkip()
EndDo

Return


//INICIO REALIZADO
Static Function REALI(_lFim)

_nValor   := _nVlDesco := _nVlJuros := 0
_cChav    := _cNaturez := _cRecPag  := _cBanco := ""
_cCliFor  := _cLoja    := _cNumero  := ""
_dEmissao := _dDtDispo := ""

aCampos := {}
AADD(aCampos,{ "TP"       ,"C", 01, 0 } )
AADD(aCampos,{ "CLIFOR"   ,"C", 06, 0 } )
AADD(aCampos,{ "LOJA"     ,"C", 02, 0 } )
AADD(aCampos,{ "TITUL"    ,"C", 09, 0 } )
AADD(aCampos,{ "EMISS"    ,"D", 08, 0 } )
AADD(aCampos,{ "DATAV"    ,"D", 08, 0 } )
AADD(aCampos,{ "NATORI"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRORI"   ,"N", 14, 2 } )
AADD(aCampos,{ "NATACR"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRACR"   ,"N", 14, 2 } )
AADD(aCampos,{ "NATDEC"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRDEC"   ,"N", 14, 2 } )
AADD(aCampos,{ "BANCO"    ,"C", 03, 0 } )

cArqLOG := CriaTrab(aCampos,.T.)
//cIndLOG := "TP"
cIndLOG := "TP+DTOS(DATAV)"
dbUseArea(.T.,,cArqLOG,"TMP",.F.,.F.)


_cQuery := " SELECT * FROM "+RetSqlName("SE5")+" E5 "
_cQuery += " INNER JOIN "+RetSqlName("SA6")+" A6 ON E5_BANCO+E5_AGENCIA+E5_CONTA = A6_COD+A6_AGENCIA+A6_NUMCON "
_cQuery += " WHERE E5.D_E_L_E_T_ = '' AND A6.D_E_L_E_T_ = ''"
_cQuery += " AND E5_DTDISPO BETWEEN  '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"'"
_cQuery += " AND E5_BANCO <> '' AND E5_SITUACA <> 'C'"
_cQuery += " AND E5_TIPODOC NOT IN ('BA','CM','D2','J2','M2','C2','V2','CX','CP','TL','DC','JR','MT')"
_cQuery += " AND E5_BANCO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
_cQuery += " AND E5_NATUREZ IN ('"+MV_PAR04+"','2110')"
_cQuery += " AND E5_NUMERO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
_cQuery += " AND A6_FLUXCAI = 'S'"                                   
_cQuery += " AND E5_CLIFOR NOT IN ('ZRESUL','ZPROVI') "
_cQuery += " ORDER BY E5_DTDISPO,E5_NATUREZ,E5_BANCO "

TCQUERY _cQuery NEW ALIAS "SE5Q"

TCSETFIELD("SE5Q","E5_DTDISPO","D")
TCSETFIELD("SE5Q","E5_VENCREA","D")
TCSETFIELD("SE5Q","E5_VENCTO" ,"D")
TCSETFIELD("SE5Q","E5_DATA"   ,"D")
                              
dbSelectArea("SE5Q")

ProcRegua(U_CONTREG())

While !Eof()
		
	IncProc("Data : "+DTOC(SE5Q->E5_DTDISPO)+" Numero : "+SE5Q->E5_NUMERO)
		
	IF SE5Q->E5_MOEDA $ "C1/C2/C3/C4/C5" .and. SE5Q->E5_VENCTO > SE5Q->E5_DATA
		dbSelectArea("SE5Q")
		dbSkip()
		Loop
	Endif                                                
	
/*	If SE5Q->E5_NATUREZ <> MV_PAR04 .And. SE5Q->E5_NATUREZ <> "2110      "
		dbSelectArea("SE5Q")
		dbSkip()
		Loop
	Endif */
				
	_lPassou := .F.
	_lSair   := .F.
	_lDesc   := .F.
	_dData   := SE5Q->E5_DTDISPO
		
	If SE5Q->E5_TIPODOC $ "CH"
						
		_cCheque := SE5Q->E5_NUMCHEQ
		dbSelectArea("SE5")
		dbOrderNIckName("INDSE52")		
		dbSetOrder()
		If dbSeek(xFilial("SE5")+_cCheque)
			While !Eof() .And. _cCheque == SE5->E5_NUMCHEQ .And. !_lSair

				IF SE5->E5_SITUACA == "C"
					dbSelectArea("SE5")				
					dbSkip()
					Loop
				EndIF
				
				If Empty(SE5->E5_TIPO)
					dbSelectArea("SE5")
					dbSkip()
					Loop
				EndIF
					
				If SE5->E5_TIPODOC $ "EC"
					dbSelectArea("SE5")
					dbSkip()
					_lSair := .T.
					Loop
				Endif
					
				If SE5->E5_TIPODOC $ "CH"
					dbSelectArea("SE5")
					dbSkip()
					Loop
				Endif
					
				If SE5->E5_TIPODOC $ "DC/MT/JR" .Or. SE5->E5_MOTBX $ "CMP/DEV" .Or. SE5->E5_SITUACA == "C"
					dbSelectArea("SE5")
					dbSkip()
					Loop
				Endif
															
				_lJuros   := .F.
				_lDesc    := .F.
				_cChav    := SE5->E5_CLIFOR + SE5->E5_LOJA + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA+SE5->E5_TIPO
				_nValor   := SE5->E5_VALOR
				_cNaturez := SE5->E5_NATUREZ
				_cRecPag  := SE5->E5_RECPAG
				_nVlDesco := SE5->E5_VLDESCO
				_nVlJuros := SE5->E5_VLJUROS
				_cCliFor  := SE5->E5_CLIFOR
				_cLoja    := SE5->E5_LOJA
				_cNumero  := SE5->E5_NUMERO
				_dEmissao := SE5->E5_DATA
				_dDtDispo := SE5->E5_DTDISPO
//					_cBanco	  := SA6->A6_COD
				
				_lPassou  := .T.
					
				GravaTRB()
					
				dbSelectArea("SE5")
				dbSkip()
			EndDo
				
			If !_lPassou
				dbSelectArea("SE5Q")

				_nValor   := SE5Q->E5_VALOR
				_cChav    := SE5Q->E5_CLIFOR + SE5Q->E5_LOJA + SE5Q->E5_PREFIXO + SE5Q->E5_NUMERO + SE5Q->E5_PARCELA+SE5Q->E5_TIPO
				_cNaturez := SE5Q->E5_NATUREZ					
				_cRecPag  := SE5Q->E5_RECPAG
				_nVlDesco := SE5Q->E5_VLDESCO
				_nVlJuros := SE5Q->E5_VLJUROS
				_cCliFor  := SE5Q->E5_CLIFOR				
				_cLoja    := SE5Q->E5_LOJA
				_cNumero  := SE5Q->E5_NUMERO
				_dEmissao := SE5Q->E5_DATA
				_dDtDispo := SE5Q->E5_DTDISPO

				GravaTRB()
			Endif
				
		Endif
			
		dbSelectArea("SE5Q")
		dbSkip()
		Loop
	Endif
		
	_nValor   := SE5Q->E5_VALOR
	_cChav    := SE5Q->E5_CLIFOR + SE5Q->E5_LOJA + SE5Q->E5_PREFIXO + SE5Q->E5_NUMERO + SE5Q->E5_PARCELA+SE5Q->E5_TIPO
	_cNaturez := SE5Q->E5_NATUREZ
	_cRecPag  := SE5Q->E5_RECPAG
	_nVlDesco := SE5Q->E5_VLDESCO
	_nVlJuros := SE5Q->E5_VLJUROS            
	_cCliFor  := SE5Q->E5_CLIFOR	
	_cLoja    := SE5Q->E5_LOJA
	_cNumero  := SE5Q->E5_NUMERO
	_dEmissao := SE5Q->E5_DATA
	_dDtDispo := SE5Q->E5_DTDISPO

	If _nValor = 0
		dbSelectArea("SE5Q")
		dbSkip()
		Loop
	Endif
		
	GravaTRB()
		
	dbSelectArea("SE5Q")
	dbSkip()
EndDo

Return


Static Function GravaTRB()

_cConta   := _cNaturez
_lVaiA    := .F.
_lVaiD    := .F.
_lVaiO    := .T.

_lCont := .T.
If _cRecPag == "R"
		
	dbSelectArea("SE1")
	dbSetOrder(2)
	If dbSeek(xFilial("SE1")+_cChav)
		
		_cNatur1 := SE1->E1_NATOUT
		_cNatur2 := SE1->E1_NATOUT2
		
		If _nVlDesco <> 0  .And. _cNatur2 = MV_PAR04
			_cConta := _cNatur2
			_lVaiA  := .F.
			_lVaiD  := .T.
			_lVaiO  := .F.
		
			_nVal1    := _nValor
			_nValor   := _nVlDesco * -1
			Grava() 
			_nValor   := _nVal1
		Endif
			
		If _nVlJuros <> 0 .And. _cNatur1 = MV_PAR04
			_cConta := _cNatur1
			_lVaiA  := .T.
			_lVaiD  := .F.
			_lVaiO  := .F.

			_nVal2    := _nValor
			_nValor   := _nVlJuros
			Grava()
			_nValor   := _nVal2
		Endif                                                                       		
                         
		If _cNaturez = MV_PAR04
			_lVaiA  := .F.
			_lVaiD  := .F.
			_lVaiO  := .T.
			_nValor := _nValor - _nVlJuros + _nVlDesco 		
	  		_cConta := _cNaturez
  						
			If _cConta $ "3110      /3111      /3112      /3113      /3114      /3119      "
				If 	SE1->E1_SITUACA == "0"
					_cConta   := Alltrim(_cConta)+"0"+space(5)
					_nOrdem   := "1"
				ElseIf 	SE1->E1_SITUACA == "1"
					_cConta   := Alltrim(_cConta)+"1"+space(5)
					_nOrdem   := "2"	
				ElseIf 	SE1->E1_SITUACA == "2"
					_cConta   := Alltrim(_cConta)+"2"+space(5)
					_nOrdem   := "3"
				ElseIf 	SE1->E1_SITUACA == "3"
					_cConta   := Alltrim(_cConta)+"3"+space(5)
					_nOrdem   := "4"
				ElseIf 	SE1->E1_SITUACA == "4"
					_cConta   := Alltrim(_cConta)+"4"+space(5)
					_nOrdem   := "5"
				ElseIf 	SE1->E1_SITUACA == "5"
					_cConta   := Alltrim(_cConta)+"5"+space(5)
					_nOrdem   := "5"
				ElseIf 	SE1->E1_SITUACA == "6"
					_cConta   := Alltrim(_cConta)+"6"+space(5)
					_nOrdem   := "6"
				ElseIf 	SE1->E1_SITUACA == "7"
					_cConta   := Alltrim(_cConta)+"7"+space(5)
					_nOrdem   := "7"
				Endif
			Endif
		Else
			_lVaiO  := .F.
		Endif
    Endif
	If _lVaiO .And. _cConta == MV_PAR04
		Grava()
	Endif	

ElseIf _cRecPag == "P"
	
	dbSelectArea("SE2")
	dbSetOrder(6)
	If dbSeek(xFilial("SE2")+_cChav)
				
		_cNatur1 := SE2->E2_NATOUT
		_cNatur2 := SE2->E2_NATOUT2
		
		If _nVlDesco <> 0  .And. _cNatur2 = MV_PAR04
			_cConta := _cNatur2
			_lVaiA  := .F.
			_lVaiD  := .T.
			_lVaiO  := .F.
		
			_nVal1    := _nValor
			_nValor   := _nVlDesco * -1
			Grava() 
			_nValor   := _nVal1
		Endif
			
		If _nVlJuros <> 0 .And. _cNatur1 = MV_PAR04
			_cConta := _cNatur1
			_lVaiA  := .T.
			_lVaiD  := .F.
			_lVaiO  := .F.

			_nVal2    := _nValor
			_nValor   := _nVlJuros
			Grava()             
			_nValor   := _nVal2
		Endif                                                                       		

		If _cNaturez = MV_PAR04
			_lVaiA  := .F.
			_lVaiD  := .F.
			_lVaiO  := .T.

			_nValor := _nValor - _nVlJuros + _nVldesco
			_cConta   := Alltrim(_cNaturez)+Space(6)				
		Else
			_lVaiO  := .F.
		Endif    
	Endif	

	If _lVaiO .And. _cConta == MV_PAR04
		Grava()
	Endif
Endif                                                            
                
//FIM



Static Function PROJE(_lFim)

aCampos := {}
AADD(aCampos,{ "TP"       ,"C", 01, 0 } )
AADD(aCampos,{ "CLIFOR"   ,"C", 06, 0 } )
AADD(aCampos,{ "LOJA"     ,"C", 02, 0 } )
AADD(aCampos,{ "TITUL"    ,"C", 09, 0 } )
AADD(aCampos,{ "EMISS"    ,"D", 08, 0 } )
AADD(aCampos,{ "DATAV"    ,"D", 08, 0 } )
AADD(aCampos,{ "NATORI"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRORI"   ,"N", 14, 2 } )
AADD(aCampos,{ "NATACR"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRACR"   ,"N", 14, 2 } )
AADD(aCampos,{ "NATDEC"   ,"C", 10, 0 } )
AADD(aCampos,{ "VLRDEC"   ,"N", 14, 2 } )

cArqLOG := CriaTrab(aCampos,.T.)
cIndLOG := "TP+DTOS(DATAV)"
dbUseArea(.T.,,cArqLOG,"TMP",.F.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",cArqLog,cIndLog,,,"Criando Trabalho...")


_cQ := " SELECT * FROM "+RetSqlName("SE1")+" E1 WHERE E1.D_E_L_E_T_ = '' "
_cQ += " AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
_cQ += " AND E1_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQ += " AND E1_CLIENTE NOT IN ('ZRESUL','ZPROVI') "
_cQ += " ORDER BY E1_VENCREA "

TCQUERY _cQ NEW ALIAS "SE1A"

TCSETFIELD("SE1A","E1_EMISSAO","D")
TCSETFIELD("SE1A","E1_VENCREA" ,"D")
TCSETFIELD("SE1A","E1_BAIXA"  ,"D")

dbSelectArea("SE1A")

ProcRegua(U_CONTREG())

While !Eof()
	
	IncProc()
	
	If SE1A->E1_SALDO = 0
		dbSelectArea("SE1A")
		dbSkip()
		Loop
	Endif
	
	If !Empty(SE1A->E1_FATURA).And. SE1A->E1_FATURA != "NOTFAT"
		dbSelectArea("SE1A")
		dbSkip()
		Loop
	Endif
	
	IF !Empty(SE1A->E1_BAIXA) .and. SE1A->E1_BAIXA < MV_PAR02 .and. SE1A->E1_SALDO == 0
		dbSelectArea("SE1A")
		dbSkip()
		Loop
	EndIF
	
	_lVaiO := .T.
	_lVaiA := .T.
	_lVaiD := .T.
	If SE1A->E1_NATUREZ != MV_PAR04
		_lVaiO := .F.
	Endif
	
	If SE1A->E1_NATOUT != MV_PAR04
		_lVaiA := .F.
	Endif
	
	If SE1A->E1_NATOUT2 != MV_PAR04
		_lVaiD := .F.
	Endif
	
	If !_lVaiO .And. !_lVaiA .And. !_lVaiD
		dbSelectArea("SE1A")
		dbSkip()
		Loop
	Endif
	
	_nVlrO := _nVlrA :=_nVlrD := 0
	
	If SE1A->E1_TIPO $ ("NCC/AB-/RA ")
		_nVlrO := SE1A->E1_SALDO   * -1
		If SE1A->E1_SALDO = SE1A->E1_VALOR
			_nVlrA := SE1A->E1_ACRESC  * -1
			_nVlrD := SE1A->E1_DECRESC * -1
		Endif
	Else
		_nVlrO := SE1A->E1_SALDO
		If SE1A->E1_SALDO = SE1A->E1_VALOR
			_nVlrA := SE1A->E1_ACRESC
			_nVlrD := SE1A->E1_DECRESC
		Endif
	Endif
	
	dbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->TP       := "A"
	TMP->CLIFOR   := SE1A->E1_CLIENTE
	TMP->LOJA     := SE1A->E1_LOJA
	TMP->TITUL    := SE1A->E1_NUM
	TMP->EMISS    := SE1A->E1_EMISSAO
	TMP->DATAV    := SE1A->E1_VENCREA
	If _lVaiO
		TMP->NATORI   := SE1A->E1_NATUREZ
		TMP->VLRORI   := _nVlrO
	Endif
	If _lVaiA
		TMP->NATACR   := SE1A->E1_NATOUT
		TMP->VLRACR   := _nVlrA
	Endif
	If _lVaiD
		TMP->NATDEC   := SE1A->E1_NATOUT2
		TMP->VLRDEC   := _nVlrD * -1
	Endif
	MsUnlock()
	
	dbselectArea("SE1A")
	dbSkip()
EndDo

_cQ := " SELECT * FROM "+RetSqlName("SE2")+" E2 WHERE E2.D_E_L_E_T_ = '' "
_cQ += " AND E2_VENCREA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
_cQ += " AND E2_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQ += " AND E2_FORNECE NOT IN ('ZRESUL','ZPROVI') "
_cQ += " ORDER BY E2_VENCREA "

TCQUERY _cQ NEW ALIAS "SE2A"

TCSETFIELD("SE2A","E2_EMISSAO","D")
TCSETFIELD("SE2A","E2_VENCREA" ,"D")
TCSETFIELD("SE2A","E2_BAIXA"  ,"D")

dbSelectArea("SE2A")

ProcRegua(U_CONTREG())

While !Eof()
	
	IncProc()
	
	If SE2A->E2_SALDO = 0
		dbSelectArea("SE2A")
		dbSkip()
		Loop
	Endif
	
	If !Empty(SE2A->E2_FATURA).And. SE2A->E2_FATURA != "NOTFAT"
		dbSelectArea("SE2A")
		dbSkip()
		Loop
	Endif
	
	IF !Empty(SE2A->E2_BAIXA) .and. SE2A->E2_BAIXA < MV_PAR02 .and. SE2A->E2_SALDO == 0
		dbSelectArea("SE2A")
		dbSkip()
		Loop
	EndIF
	
	_lVaiO := .T.
	_lVaiA := .T.
	_lVaiD := .T.
	If SE2A->E2_NATUREZ != MV_PAR04
		_lVaiO := .F.
	Endif
	
	If SE2A->E2_NATOUT != MV_PAR04
		_lVaiA := .F.
	Endif
	
	If SE2A->E2_NATOUT2 != MV_PAR04
		_lVaiD := .F.
	Endif
	
	If !_lVaiO .And. !_lVaiA .And. !_lVaiD
		dbSelectArea("SE2A")
		dbSkip()
		Loop
	Endif
	
	_nVlrO := _nVlrA :=_nVlrD := 0
	
	If SE2A->E2_TIPO $ ("NDF/PA ")
		_nVlrO := SE2A->E2_VALOR   * -1
		If SE2A->E2_VALOR = SE2A->E2_SALDO
			_nVlrA := SE2A->E2_ACRESC  * -1
			_nVlrD := SE2A->E2_DECRESC * -1
		Endif
	Else
		_nVlrO := SE2A->E2_VALOR
		If SE2A->E2_VALOR = SE2A->E2_SALDO
			_nVlrA := SE2A->E2_ACRESC
			_nVlrD := SE2A->E2_DECRESC
		Endif
	Endif
	
	dbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->TP       := "B"
	TMP->CLIFOR   := SE2A->E2_FORNECE
	TMP->LOJA     := SE2A->E2_LOJA
	TMP->TITUL    := SE2A->E2_NUM
	TMP->EMISS    := SE2A->E2_EMISSAO
	TMP->DATAV    := SE2A->E2_VENCREA
	If _lVaiO
		TMP->NATORI   := SE2A->E2_NATUREZ
		TMP->VLRORI   := _nVlrO
	Endif
	If _lVaiA
		TMP->NATACR   := SE2A->E2_NATOUT
		TMP->VLRACR   := _nVlrA
	Endif
	If _lVaiD
		TMP->NATDEC   := SE2A->E2_NATOUT2
		TMP->VLRDEC   := _nVlrD * -1
	Endif
	MsUnlock()
	
	dbselectArea("SE2A")
	dbSkip()
EndDo

Return


Static Function Imprime()

nLin := 80

If MV_PAR01 == 1
	/*
	TP CLI-FOR/LJ  TITULO  EMISSAO   DISPONIVEL BCO  VLR.ORIGINAL  NAT. ORIG.    VLR.ACRESCIMO  NAT.ACRESC   VLR.DECRESCIMO  NAT.DECRES
	9  999999999   999999  99999999  99999999   999  999999999999  9999999999   99999999999999  9999999999   99999999999999  9999999999
	0  3           15      23        33         44   49            63           76              92           105             121
	*/
	cabec1 := "TP CLI-FOR/LJ  TITULO     EMISSAO  DISPONIV. BCO VLR.ORIGINAL  NAT. ORIG.    VLR.ACRESCIMO  NAT.ACRESC  VLR.DECRESCIMO  NAT.DECRES"
	cabec2 := ""
	titulo := Alltrim(titulo) +" - APROPRIADO"
	
ElseIf MV_PAR01 == 2
	/*
	TP CLI-FOR/LJ  TITULO  EMISSAO   DISPONIVEL      VLR.ORIGINAL  NAT. ORIG.    VLR.ACRESCIMO  NAT.ACRESC   VLR.DECRESCIMO  NAT.DECRES
	9  999999999   999999  99999999  99999999        999999999999  9999999999   99999999999999  9999999999   99999999999999  9999999999
	0  3           15      23        33              49            63           76              92           105             121
	*/
	cabec1 := "TP CLI-FOR/LJ  TITULO     EMISSAO  DISPONIVEL    VLR.ORIGINAL  NAT. ORIG.    VLR.ACRESCIMO  NAT.ACRESC  VLR.DECRESCIMO  NAT.DECRES"
	cabec2 := ""
	titulo := Alltrim(titulo) + " - PREVISTO"
	
ElseIf MV_PAR01 == 3
	/*
	TP CLI-FOR/LJ  TITULO  EMISSAO   DISPONIVEL BCO  VLR.ORIGINAL  NAT. ORIG.    VLR.ACRESCIMO  NAT.ACRESC   VLR.DECRESCIMO  NAT.DECRES
	9  999999999   999999  99999999  99999999   999  999999999999  9999999999   99999999999999  9999999999   99999999999999  9999999999
	0  3           15      23        33         44   49            63           76              92           105             121
	*/
	cabec1 := "TP CLI-FOR/LJ  TITULO     EMISSAO  DISPONIV. BCO VLR.ORIGINAL  NAT. ORIG.    VLR.ACRESCIMO  NAT.ACRESC  VLR.DECRESCIMO  NAT.DECRES"
	cabec2 := ""
	titulo := Alltrim(titulo) + " - REALIZADO"
	
ElseIf MV_PAR01 == 4
	/*
	TP CLI-FOR/LJ  TITULO  EMISSAO   DISPONIVEL      VLR.ORIGINAL  NAT. ORIG.    VLR.ACRESCIMO  NAT.ACRESC   VLR.DECRESCIMO  NAT.DECRES
	9  999999999   999999  99999999  99999999        999999999999  9999999999   99999999999999  9999999999   99999999999999  9999999999
	0  3           15      23        33              49            63           76              92           105             121
	*/
	cabec1 := "TP CLI-FOR/LJ  TITULO     EMISSAO  DISPONIVEL    VLR.ORIGINAL  NAT. ORIG.    VLR.ACRESCIMO  NAT.ACRESC  VLR.DECRESCIMO  NAT.DECRES"
	cabec2 := ""
	titulo := Alltrim(titulo) + " - PROJETADO"
	
Endif

dbSelectArea("TMP")
_cArqInd1   := CriaTrab(NIL,.F.)
_cChave1 := "TP"
IndRegua("TMP",_cArqInd1,_cChave1,,,"Indexando TMP...")

dbGoTop()

ProcRegua(LastRec())

_cNat    := ""
_lNat    := .F.
_nQtO    := _nQtA := _nQtD := 0
_nTotR   := _nTotP := 0
_lTotR   := .F.
_cRecPag := ""
_lPass   := .F.

While !EOF()
	
	IncProc()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	If TMP->TP = "B" .and. _lTotR
		nlin++
		@nLin,000 PSAY "TOTAL "+_cRecPag+_cNat+"    ---------->"
		@nLin,049 PSAY _nQtO      Picture TM(_nQtO,12,2)
		@nLin,076 PSAY _nQtA      Picture TM(_nQtA,14,2)
		@nLin,105 PSAY _nQtD      Picture TM(_nQtD,14,2)
		_nTotR := _nQtO + _nQtA + _nQtD
		_nQtO  := _nQtA := _nQtD := 0
		_lTotR := .F.
		nLin += 2
	Endif
	
	_cTp := ""
	If TMP->TP = "A"
		_cTp := "R"
		_cRecPag := "RECEBER "
		_lTotR   := .T.
	ElseIf TMP->TP = "B"
		_cTp := "P"
		_cRecPag := "PAGAR "
	Endif
	                           
//	Define Font oFont Name "ARIAL" Bold

	@nLin,000 PSAY _cTp //pixel color clr_blue //Font oFont
	@nLin,003 PSAY TMP->CLIFOR+"/"+TMP->LOJA
	@nLin,015 PSAY TMP->TITUL
	@nLin,026 PSAY TMP->EMISS
	@nLin,035 PSAY TMP->DATAV
	If MV_PAR01 == 3
		@nLin,044 PSAY TMP->BANCO
	Endif	
	@nLin,049 PSAY TMP->VLRORI		Picture TM(TMP->VLRORI,12,2)	
	@nLin,063 PSAY TMP->NATORI
	@nLin,076 PSAY TMP->VLRACR		Picture TM(TMP->VLRACR,14,2)
	@nLin,092 PSAY TMP->NATACR
	@nLin,105 PSAY TMP->VLRDEC		Picture TM(TMP->VLRDEC,14,2)
	@nLin,121 PSAY TMP->NATDEC
	
	_nQtO += TMP->VLRORI
	_nQtA += TMP->VLRACR
	_nQtD += TMP->VLRDEC
	
	nLin ++
	_lPass := .T.
	_cNat := MV_PAR04
	dbSelectArea("TMP")
	dbSkip()
	
EndDo

If _lPass
	nLin++
	
	@nLin,000 PSAY "TOTAL "+_cRecPag+_cNat+"    ---------->"
	@nLin,049 PSAY _nQtO      Picture TM(_nQtO,12,2)
	@nLin,076 PSAY _nQtA      Picture TM(_nQtA,14,2)
	@nLin,105 PSAY _nQtD      Picture TM(_nQtD,14,2)
	If _cRecPag == "RECEBER "
		_nTotR := _nQtO + _nQtA + _nQtD
	Else
		_nTotP := _nQtO + _nQtA + _nQtD
	Endif              
	
	If _nTotP <> 0 .And. _nTotR <> 0
		nLin += 1
	
		@nLin,000 PSAY Replicate("-",limite)
	
		nLin += 1
	
		@nLin,000 PSAY "TOTAL NATUREZA "+_cNat+"    ---------->"
		@nLin,049 PSAY _nTotR - _nTotP      Picture TM((_nTotR - _nTotP),14,2)
	Endif	
	
Endif

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return