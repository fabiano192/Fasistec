#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ PA0078   ³ Autor ³ Alexandro da Silva    ³ Data ³ 27.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de Projeto de Transportes                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                                

User Function Pa0078()

_aAliOri := GetArea()
_lAchou  := .F.
Private _nGanhProj := _nAnteProj := _nPerImp   := _nPerIrpj  := 0

_nOpc := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Faturamento x Transporte")
@ 02,10 TO 080,220
@ 10,18 SAY "Relatorio de Faturamento x Despesas com Transpor-"    SIZE 160,7
@ 18,18 SAY "tes no Periodo Informado.                        "    SIZE 160,7
@ 26,18 SAY "Uso Automatico.                                  "    SIZE 160,7
@ 34,18 SAY "Programa PA0078.PRW                              "    SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0078")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered
                                        
If _nOpc == 1
	Proces()
Endif

Return


Static Function Proces()
                 
_cMod   := cModulo
cModulo := "EEC"

_lRet := E_ARQCRW()

Pergunte("PA0078",.F.)


///////////////////////////////////
///// MV_PAR01 : Data De ?     ////
///// MV_PAR02 : Data Ate ?    ////
///////////////////////////////////

_nGanhProj := GETMV("MV_PA00781")    // Percentual de Objetivo do ganho do projeto
_nAnteProj := GETMV("MV_PA00782")    // Percentual de indicador medido antes da implantacao do projeto
_nPerImp   := GETMV("MV_PA00783")    // Taxa de Aliquota dos impostos PIS+COFINS+IRPJ+CONTR.SOCIAL
_nPerIrpj  := GETMV("MV_PA00784")    // Taxa de Aliquota dos impostos IRPJ+CONTE.SOCIAL das vendas para Exportacao

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNew := "\CRYSTAL\PA0078.DBF"
dbSelectArea("TRB")
COPY ALL TO &_cArqNew

dbSelectArea("TRB")
dbGotop()

dbSelectArea("TRB")
dbCloseArea()      

Private cSeqRel := ""
AVGCRW32("PA0078.RPT","CALCULO DOS GANHOS DO PROJETO 2")

cModulo := _cMod

Return


Static Function Proc1(_lFim)

aCampos := {}
AADD(aCampos,{ "REFEREN" ,"C", 30, 0 } )
AADD(aCampos,{ "TPCFOP"  ,"C", 05, 0 } )
AADD(aCampos,{ "PERIODO" ,"C", 06, 0 } )
AADD(aCampos,{ "VLVENDA" ,"N", 14, 2 } )
AADD(aCampos,{ "VLIPI"   ,"N", 14, 2 } )
AADD(aCampos,{ "VLICMS"  ,"N", 14, 2 } )
AADD(aCampos,{ "VLOUTROS","N", 14, 2 } )
AADD(aCampos,{ "VLTEXTO" ,"C", 50, 0 } )
AADD(aCampos,{ "VLFATUR" ,"N", 14, 2 } )
AADD(aCampos,{ "VLTRANS1","N", 14, 2 } )
AADD(aCampos,{ "VLTRANS2","N", 14, 2 } )
AADD(aCampos,{ "VLTRANS3","N", 14, 2 } )
AADD(aCampos,{ "VLTRANS4","N", 14, 2 } )
AADD(aCampos,{ "VLTRANS5","N", 14, 2 } )    
AADD(aCampos,{ "DESPTOT" ,"N", 14, 2 } )    
AADD(aCampos,{ "OBJGANHO","N", 14, 2 } )    
AADD(aCampos,{ "ANTGANHO","N", 14, 2 } )    

cArqLOG := CriaTrab(aCampos,.T.)
cIndLOG := "PERIODO+TPCFOP"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

_cPeriodo := Substr(DTOS(MV_PAR01),1,6)

dbSelectArea("SD2")
dbSetOrder(5)
dbSeek(xFilial("SD2")+Dtos(MV_PAR01),.T.)

ProcRegua(LastRec())

While !Eof() .And. SD2->D2_EMISSAO <= MV_PAR02
	
	IncProc()
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4")+SD2->D2_TES)
		If SF4->F4_DUPLIC != "S"
			If SD2->D2_CF $ "5101 /6101 /7101 "
				Alert("Nota Fiscal "+SD2->D2_DOC)
			Endif
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
	Endif
	
	If SD2->D2_TIPO $ "D/B"
		dbSelectArea("SD2")
		dbSkip()
		Loop
	Endif
	
	If SD2->D2_TIPO != "P"     
	     _nVlFatur      := SD2->D2_TOTAL + SD2->D2_VALIPI
	Else
		 _nVlFatur     := SD2->D2_TOTAL
	Endif	
		
	If Substr(SD2->D2_CF,1,1) == "5"         
		_cTp := "5"
		_nOutImp := (_nVlFatur - SD2->D2_VALIPI) * (_nPerImp/100)
		_cTexto := "PIS+COFINS+IRPJ+C.SOCIAL = 5,93%"
	ElseIf Substr(SD2->D2_CF,1,1) == "6"
		_cTp := "6"
		_nOutImp := (_nVlFatur - SD2->D2_VALIPI) * (_nPerImp/100)
		_cTexto := "PIS+COFINS+IRPJ+C.SOCIAL = 5,93%"		
	Else
		_cTp := "7"   
		_nOutImp := (_nVlFatur - SD2->D2_VALIPI) * (_nPerIRPJ/100)
		_cTexto := "IRPJ+CONTR.SOCIAL        = 2,28%"
	Endif
	
	dbSelectArea("TRB")
	If !dbSeek(_cPeriodo + _cTp)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->REFEREN   := DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02)
		TRB->TPCFOP    := _cTp
		TRB->PERIODO   := _cPeriodo
		TRB->VLVENDA   := _nVlFatur
		TRB->VLIPI     := SD2->D2_VALIPI
		TRB->VLICMS    := SD2->D2_VALICM
		TRB->VLOUTROS  := _nOutImp
		TRB->VLTEXTO   := _cTexto          
		TRB->VLFATUR   := _nVlFatur - SD2->D2_VALICM - SD2->D2_VALIPI - _nOutImp
		MsUnlock()
	Else
		dbSelectArea("TRB")
		RecLock("TRB",.F.)
		If SD2->D2_TIPO != "P"     
		    _nVlFatur   := SD2->D2_TOTAL + SD2->D2_VALIPI
		Else
			 _nVlFatur  := SD2->D2_TOTAL
		Endif	
		TRB->VLVENDA   += _nVlFatur
		TRB->VLIPI     += SD2->D2_VALIPI
		TRB->VLICMS    += SD2->D2_VALICM
		TRB->VLOUTROS  += _nOutImp                 
		TRB->VLTEXTO   += _cTexto                                                        
		TRB->VLFATUR   += _nVlFatur - SD2->D2_VALICM - SD2->D2_VALIPI - _nOutImp
		MsUnlock()
	Endif
	
	dbSelectArea("SD2")
	dbSkip()
EndDo

dbSelectArea("SE2")
dbSetOrder(7)
dbSeek(xFilial("SE2")+DTOS(MV_PAR01),.T.)

ProcRegua(LastRec())

_dDtInic := FirstDay(MV_PAR01)
_lPrim   := .F.
_nSemana := 1

While !Eof() .And. SE2->E2_EMIS1 <= MV_PAR02
	
	IncProc()
	
	_nDia := Dow(SE2->E2_EMIS1)
	
	If _nDia == 2 .And. _lPrim
		_nSemana ++
	Else
		_lPrim  := .T.
	Endif
	                              
	_dEmiss := SE2->E2_EMIS1
	
	While !EOF() .AND. _dEmiss == SE2->E2_EMIS1
	
		If !ALLTRIM(SE2->E2_NATUREZ) $ "4540/4550"
			dbSelectArea("SE2")
			dbSkip()
			Loop
		Endif

		If SE2->E2_TIPO == "PA "
			dbSelectArea("SE2")
			dbSkip()
			Loop
		Endif
				
		dbSelectArea("TRB")
		If !dbSeek(_cPeriodo + "9")
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->REFEREN   := DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02)
			TRB->TPCFOP    := "9"
			TRB->PERIODO   := _cPeriodo
			If _nSemana == 1
				TRB->VLTRANS1  := SE2->E2_VALOR
			ElseIf _nSemana == 2
				TRB->VLTRANS2  := SE2->E2_VALOR
			ElseIf _nSemana == 3
				TRB->VLTRANS3  := SE2->E2_VALOR
			ElseIf _nSemana == 4
			TRB->VLTRANS4  := SE2->E2_VALOR
			ElseIf _nSemana == 5
				TRB->VLTRANS5  := SE2->E2_VALOR
			Endif                                          
			TRB->DESPTOT  := SE2->E2_VALOR
			TRB->OBJGANHO := _nGanhProj
			TRB->ANTGANHO := _nAnteProj
			MsUnlock()
		Else	
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			If _nSemana == 1
				TRB->VLTRANS1  += SE2->E2_VALOR
			ElseIf _nSemana == 2
				TRB->VLTRANS2  += SE2->E2_VALOR
			ElseIf _nSemana == 3
				TRB->VLTRANS3  += SE2->E2_VALOR
			ElseIf _nSemana == 4
				TRB->VLTRANS4  += SE2->E2_VALOR
			ElseIf _nSemana == 5
				TRB->VLTRANS5  += SE2->E2_VALOR
			Endif                         
			TRB->DESPTOT  += SE2->E2_VALOR		
			TRB->OBJGANHO := _nGanhProj
			TRB->ANTGANHO := _nAnteProj			
			MsUnlock()
		Endif
	
		dbSelectArea("SE2")
		dbSkip()
	EndDo	
EndDo

Return