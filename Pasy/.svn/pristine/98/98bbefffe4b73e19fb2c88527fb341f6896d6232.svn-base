#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACESB7    º Autor ³ Fabiando da Silva º Data ³  16/01/08    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizaçao Lançamentos do Inventário                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACEETIQ()

Private _cProd1 := _cProd2 := ""
Private _cMass1 := _cMass2 := ""
Private _cMold1 := _cMold2 := ""
Private _cCav1  := _cCav2  := ""
Private _nCicl1 := _nCicl2 := 0
Private _cOP11  := _cOP12  := ""
Private _cOP21  := _cOP22  := ""
Private _cOP31  := _cOP32  := ""
Private _nPPH1  := _nPPH2  := 0
Private _nMaxD1 := _nMaxD2 := 0
Private _cClie1 := _cClie2 := ""
Private _cLoja1 := _cLoja2 := ""
Private _cPerg  := "PA0003"

_cPorta  := "LPT1"
_nOpc    := 0              

Pergunte(_cPerg,.F.)

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para gerar Etiqueta")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Gerar Etiquetas		                 "     SIZE 160,7
@ 18,18 SAY "                                                    "     SIZE 160,7
@ 26,18 SAY "Programa ACEETIQ                                    "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte(_cPerg,.T.)
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
//	Private _bAcao01   := {|_lFim| IMPET(@_lFim) }
	Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
	Private _cTitulo01 := 'Selecionando Registros !!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

Return


Static Function Proc1(_lFim)

_cArqTrb:= "ETIQUE.DBF"
_cArqInd:= "ETIQUE"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

_cInd := "PROD"
IndRegua("TRB",_cArqInd,_cInd,,,"Selecionando Arquivo Trabalho")

TRB->(dbGotop())

ProcRegua(TRB->(U_CONTREG()))

_nCont := 0
While TRB->(!Eof()) .And. !_lFim
	
	IncProc()
	
	If _lFim
		REturn
	Endif

	If TRB->PROD < MV_PAR01 .Or. TRB->PROD > MV_PAR02
		TRB->(dbSkip())
		Loop
	Endif
		
	_nCont++
	
	If _nCont = 1
		_cProd1 := TRB->PROD
		_cMass1 := TRB->MASSA
		_cMold1 := TRB->MOLDE
		_cCav1  := TRB->CAV
		_nCicl1 := TRB->TC
		_cOP11  := TRB->REC_01
		_cOP21  := TRB->REC_02
		_cOP31  := TRB->REC_03
		_nPPH1  := TRB->PPH
		_nMaxD1 := TRB->MAX_DIA
		_cClie1 := TRB->CLIENTE
		_cLoja1 := TRB->LOJA
	
	ElseIf _nCont == 2 
		_cProd2 := TRB->PROD
		_cMass2 := TRB->MASSA
		_cMold2 := TRB->MOLDE
		_cCav2  := TRB->CAV
		_nCicl2 := TRB->TC
		_cOP12  := TRB->REC_01
		_cOP22  := TRB->REC_02
		_cOP32  := TRB->REC_03
		_nPPH2  := TRB->PPH
		_nMaxD2 := TRB->MAX_DIA
		_cClie2 := TRB->CLIENTE
		_cLoja2 := TRB->LOJA
	
		ImpEt()
		_nCont := 0	
	Endif
	
	TRB->(dbSkip())
EndDo

TRB->(dbCloseArea())

Return()
         

Static Function ImpEt()

MSCBPRINTER("ARGOX",_cPorta,,,.f.)
MSCBCHKSTATUS(.f.)

MSCBLOADGRF("\SYSTEM\logPasy2.bmp")

MSCBBEGIN(1,6)

MSCBLINEV(49,02,70,2,"B")

//MSCBGRAFIC(19,65,"logPasy2")
//MSCBGRAFIC(66,65,"logPasy2")

// Dados da Empresa
MSCBSAY(05,61,"PRODUTO:"			  			, "N", "2", "1",.F.)
MSCBSAY(25,61,_cProd1				  		    , "N", "4", "1,1" ,.F.)
MSCBSAY(55,61,"PRODUTO:"			  			, "N", "2", "1",.F.)
MSCBSAY(75,61,_cProd2				  			, "N", "4", "1,1" ,.F.)

MSCBLINEH(05,59.5,045,1,"B")
MSCBLINEH(55,59.5,095,1,"B")

MSCBSAY(05,55.5,"MATERIAL:"    	              	, "N", "2", "1",.F.)
MSCBSAY(25,55.5,_cMass1    	              		, "N", "2", "1",.F.)
MSCBSAY(55,55.5,"MATERIAL:"    	              	, "N", "2", "1",.F.)
MSCBSAY(75,55.5,_cMass2    	              		, "N", "2", "1",.F.)

MSCBLINEH(05,54,045,1,"B")
MSCBLINEH(55,54,095,1,"B")

MSCBSAY(05,50,"MOLDE"                           , "N", "2", "1",.F.)
MSCBSAY(25,50,_cMold1    	              		, "N", "2", "1",.F.)
MSCBSAY(55,50,"MOLDE"                           , "N", "2", "1",.F.)
MSCBSAY(75,50,_cMold2    	              		, "N", "2", "1",.F.)

MSCBSAY(05,46,"CAVIDADES:"                      , "N", "2", "1",.F.) 
MSCBSAY(25,46,_cCav1    	              		, "N", "2", "1",.F.)
MSCBSAY(55,46,"CAVIDADES:"                      , "N", "2", "1",.F.) 
MSCBSAY(75,46,_cCav2    	              		, "N", "2", "1",.F.)

MSCBSAY(05,42,"CICLO:"	                        , "N", "2", "1",.F.)
MSCBSAY(25,42,TRANSFORM(_nCicl1,"@E 999,99")    , "N", "2", "1",.F.)
MSCBSAY(55,42,"CICLO:"	                        , "N", "2", "1",.F.)
MSCBSAY(75,42,TRANSFORM(_nCicl2,"@E 999,99")    , "N", "2", "1",.F.)

MSCBLINEH(05,40.5,045,1,"B")
MSCBLINEH(55,40.5,095,1,"B")

MSCBSAY(05,36.5,"RECURSO PRODUCAO:"             , "N", "2", "1",.F.)
MSCBSAY(55,36.5,"RECURSO PRODUCAO:"             , "N", "2", "1",.F.)
MSCBSAY(05,32.5,"OP1"               			, "N", "2", "1",.F.)
MSCBSAY(25,32.5,_cOP11	   	              		, "N", "2", "1",.F.)
MSCBSAY(55,32.5,"OP1"               			, "N", "2", "1",.F.)
MSCBSAY(75,32.5,_cOP12	   	              		, "N", "2", "1",.F.)
MSCBSAY(05,28.5,"OP2"               			, "N", "2", "1",.F.)
MSCBSAY(25,28.5,_cOP21	   	              		, "N", "2", "1",.F.)
MSCBSAY(55,28.5,"OP2"               			, "N", "2", "1",.F.)
MSCBSAY(75,28.5,_cOP22	   	              		, "N", "2", "1",.F.)
MSCBSAY(05,24.5,"OP3"               			, "N", "2", "1",.F.)
MSCBSAY(25,24.5,_cOP31	   	              		, "N", "2", "1",.F.)
MSCBSAY(55,24.5,"OP3"               			, "N", "2", "1",.F.)
MSCBSAY(75,24.5,_cOP32	   	              		, "N", "2", "1",.F.)

MSCBLINEH(05,23,045,1,"B")
MSCBLINEH(55,23,095,1,"B")

MSCBSAY(05,19,"PPH:"               				, "N", "2", "1",.F.)
MSCBSAY(25,19,TRANSFORM(_nPPH1,"@E 9999")       , "N", "2", "1",.F.)
MSCBSAY(55,19,"PPH:"               				, "N", "2", "1",.F.)
MSCBSAY(75,19,TRANSFORM(_nPPH2,"@E 9999")       , "N", "2", "1",.F.)

MSCBSAY(05,15,"MAXIMO DIA:"  		            , "N", "2", "1",.F.)
MSCBSAY(25,15,TRANSFORM(_nMaxD1,"@E 9999")	   	, "N", "2", "1",.F.)
MSCBSAY(55,15,"MAXIMO DIA:"  		            , "N", "2", "1",.F.)
MSCBSAY(75,15,TRANSFORM(_nMaxD2,"@E 9999")	   	, "N", "2", "1",.F.)

MSCBLINEH(05,13.5,045,1,"B")
MSCBLINEH(55,13.5,095,1,"B")

MSCBSAY(05,10,"CLIENTE/LOJA:"  		        , "N", "2", "1",.F.)
MSCBSAY(25,10,_cClie1+"/"+_cLoja1          	, "N", "2", "1",.F.)
MSCBSAY(55,10,"CLIENTE/LOJA:"  		        , "N", "2", "1",.F.)
MSCBSAY(75,10,_cClie2+"/"+_cLoja2          	, "N", "2", "1",.F.)

MSCBLINEH(05,08.5,045,1,"B")
MSCBLINEH(55,08.5,095,1,"B")

MSCBSAY(05,03.5,"QUANTIDADE:"  		            , "N", "2", "1",.F.)
MSCBBOX(25,2.5, 45,7.5,1,"B")
MSCBSAY(55,03.5,"QUANTIDADE:"  		            , "N", "2", "1",.F.)
MSCBBOX(75,2.5,095,7.5,1,"B")

MSCBEND()

MSCBClosePrinter()

Return