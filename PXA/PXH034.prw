#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PXH034   ³ Autor ³ Alexandro da Silva    ³ Data ³ 21/10/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio Compras                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Relatorio de Compras                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH034()

ATUSX1()

_nOpc := 0
DEFINE MSDIALOG oDlg TITLE "Relatorio de Compras"  From 10,0 TO 250,400 of oMainWnd PIXEL

@ 0.5,0.5 TO 08.25,025

@ 02,02 SAY "Rotina para gerar o Relatorio dos Itens das Notas    "   SIZE 160,7
@ 03,02 SAY "Fiscais em excel, Conforme parametros informados     "     SIZE 160,7
@ 04,02 SAY "Pelo usuario.                                        "     SIZE 160,7
@ 05,02 SAY "                                                     "     SIZE 160,7

@ 100,100  BMPBUTTON TYPE 5 ACTION Pergunte("PXH034")
@ 100,130  BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 100,160  BMPBUTTON TYPE 2 ACTION oDlg:END()

Activate Dialog oDlg Centered

If _nOpc == 1
	
	_cDir:= "C:\TOTVS"
	
	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf
	
	Pergunte("PXH034",.F.)
	
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PX034_01(@_lFim) }
	Private _cTitulo01 := 'Gerando Movimentacao !!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
Endif

Return

Static Function PX034_01(_lFim)

_aAliSM0:= SM0->(GetArea())

_aPracaPg:={{"001","MTZ"},{"002","UND"},{"   ","???"}}

aCampos := {}

AADD(aCampos,{"EMPRESA"     ,"C" ,03,0	})
AADD(aCampos,{"FILIAL"      ,"C" ,02,0	})
AADD(aCampos,{"NOMFIL"      ,"C" ,20,0	})
AADD(aCampos,{"DTDIGIT"     ,"D" ,08,0	})
AADD(aCampos,{"EMISSAO"     ,"D" ,08,0	})
AADD(aCampos,{"PREFIXO"     ,"C" ,03,0	})
AADD(aCampos,{"NUMERO"      ,"C" ,09,0	})
AADD(aCampos,{"TOTAL"       ,"N" ,14,2	})
AADD(aCampos,{"FORNECE"     ,"C" ,06,0	})
AADD(aCampos,{"LOJA"        ,"C" ,02,0	})
AADD(aCampos,{"NOMFOR"      ,"C" ,50,0	})
AADD(aCampos,{"PRACA"       ,"C" ,03,0	})
AADD(aCampos,{"FORMA"       ,"C" ,03,0	})
AADD(aCampos,{"DADOS"       ,"C" ,20,0	})
AADD(aCampos,{"COND"        ,"C" ,03,0	})
AADD(aCampos,{"VENCTO"      ,"D" ,08,0	})

cArqTemp	:=	CriaTrab(aCampos)

dbUseArea(.T.,,cArqTemp,"TRB",.F.,.F.)

IndRegua("TRB",cArqTemp,"NUMERO+PREFIXO",,,"Indexando Dados")

_cQ := " SELECT D1_FILIAL,D1_DTDIGIT,D1_EMISSAO,D1_SERIE,D1_DOC,D1_FORNECE,D1_LOJA,D1_TIPO, "
_cQ += " A2_NOME FROM "+RetSqlName("SD1")+" A INNER JOIN "+RetSqlName("SA2")+ " B ON D1_FORNECE = A2_COD AND D1_LOJA=A2_LOJA "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" C ON D1_TES=F4_CODIGO "
_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND D1_TIPO NOT IN ('D','B') "
_cQ += " AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQ += " AND D1_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
_cQ += " AND D1_FORNECE BETWEEN '"+MV_PAR05+"'       AND '"+MV_PAR06+"' "
_cQ += " AND D1_LOJA    BETWEEN '"+MV_PAR07+"'       AND '"+MV_PAR08+"' "
_cQ += " AND D1_COD     BETWEEN '"+MV_PAR09+"'       AND '"+MV_PAR10+"' "
_cQ += " AND D1_FILIAL = '"+xFilial("SD1")+"' "
//_cQ += " AND D1_FILIAL  BETWEEN '"+MV_PAR11+"'       AND '"+MV_PAR12+"' "

If MV_PAR11 == 1 // GERA DUPLICATA
	_cQ += " AND F4_DUPLIC = 'S' "
ElseIf MV_PAR11 == 2 // NAO GERA DUPLICATA
	_cQ += " AND F4_DUPLIC = 'N' "
Endif

_cQ += " GROUP BY D1_FILIAL,D1_DTDIGIT,D1_EMISSAO,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,A2_NOME,D1_TIPO "
_cQ += " ORDER BY D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA "

TCQUERY _cq NEW ALIAS "ZZ"

TCSETFIELD("ZZ","D1_DTDIGIT","D")
TCSETFIELD("ZZ","D1_EMISSAO","D")

ZZ->(dbGoTop())

ProcRegua(ZZ->(U_CONTREG()))

While ZZ->(!EOF())
	
	IncProc()
	
	_cCond  := ""
	_nValTot:= 0
	
	SF1->(dbSetOrder(1))
	If SF1->(dbSeek(xFilial("SF1")+ ZZ->D1_DOC + ZZ->D1_SERIE + ZZ->D1_FORNECE + ZZ->D1_LOJA + ZZ->D1_TIPO))
		_cCond   := SF1->F1_COND
		_nValTot := SF1->F1_VALBRUT
	Endif
	
	_cNomFor := ""
	_cPraca  := ""
	_cFormPg := ""
	_dVencto := CTOD("")
	
	SE2->(dbSetOrder(6))
	If SE2->(dbSeek(xFilial("SE2")+ ZZ->D1_FORNECE + ZZ->D1_LOJA  + ZZ->D1_SERIE+ ZZ->D1_DOC ))
		_cPraca  := TABELA("Z8",SE2->E2_YPRAPG,.F.)
		_cFormPg := TABELA("Z9",SE2->E2_YFORMPG,.F.)
		_dVencto := SE2->E2_VENCTO
	Endif
	
	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+ ZZ->D1_FORNECE + ZZ->D1_LOJA ))
		_cNomFor := SA2->A2_NOME
	Endif
	
	_cNomFil := ""
	SM0->(dbSetOrder(1))
	If SM0->(dbSeek(cEmpAnt+ ZZ->D1_FILIAL))
		_cNomFil := SM0->M0_FILIAL
	Endif
	
	TRB->(RecLock("TRB" ,.T.))
	TRB->EMPRESA  := Left(ZZ->D1_FILIAL,3)
	TRB->FILIAL	  := Substr(ZZ->D1_FILIAL,4,2)
	TRB->NOMFIL	  := _cNomFil
	TRB->DTDIGIT  := ZZ->D1_DTDIGIT
	TRB->EMISSAO  := ZZ->D1_EMISSAO
	TRB->PREFIXO  := ZZ->D1_SERIE
	TRB->NUMERO   := ZZ->D1_DOC
	TRB->TOTAL    := _nValTot
	TRB->FORNECE  := ZZ->D1_FORNECE
	TRB->LOJA     := ZZ->D1_LOJA
	TRB->NOMFOR   := _cNomFor	     	
	TRB->PRACA	  := _cPraca
	TRB->FORMA    := _cFormPg
	TRB->VENCTO   := _dVencto
	TRB->COND     := _cCond
	TRB->DADOS    := IIf(.NOT. _cFormPg $ 'BOL;???' .AND. .NOT.Empty(SA2->A2_CONTA).AND..NOT.Empty(SA2->A2_AGENCIA).AND..NOT.Empty(SA2->A2_BANCO),'OK','??')
	TRB->(MsUnlock())
	
	ZZ->(dbSkip())
EndDo

RestArea(_aAliSM0)

ZZ->(dbcloseArea())
                                         
_cData   := DTOS(dDataBase)
_cArqNew := "\SPOOL\"+_cData +".XLS"

dbSelectArea("TRB")
COPY ALL TO &_cArqNew

_cDir:= "C:\TOTVS\"

CpyS2T( "\SPOOL\"+_cData +".XLS", _cDir, .F. )

dbCloseArea("TRB")

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "C:\TOTVS\"+_cData +".XLS" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return


Static Function ATUSX1()

cPerg := "PXH034"

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02               /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data Digitacao De    	   ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"02","Data Digitacao Ate   	   ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"03","Data Emissao   De    	   ?",""       ,""      ,"mv_ch3","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR03","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"04","Data Emissao   Ate   	   ?",""       ,""      ,"mv_ch4","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR04","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"05","Fornecedor     De    	   ?",""       ,""      ,"mv_ch5","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR05","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"FOR")
U_CRIASX1(cPerg,"06","Fornecedor     Ate   	   ?",""       ,""      ,"mv_ch6","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR06","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"FOR")
U_CRIASX1(cPerg,"07","Loja           De    	   ?",""       ,""      ,"mv_ch7","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR07","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"08","Loja           Ate   	   ?",""       ,""      ,"mv_ch8","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR08","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"09","Produto        De    	   ?",""       ,""      ,"mv_ch9","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR09","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SB1")
U_CRIASX1(cPerg,"10","Produto        Ate   	   ?",""       ,""      ,"mv_cha","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR10","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SB1")
//U_CRIASX1(cPerg,"11","Filial         De    	   ?",""       ,""      ,"mv_chb","C" ,05     ,0      ,0     ,"G",""        ,"MV_PAR11","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"XM0")
//U_CRIASX1(cPerg,"12","Filial         Ate   	   ?",""       ,""      ,"mv_chc","C" ,05     ,0      ,0     ,"G",""        ,"MV_PAR12","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"XM0")
U_CRIASX1(cPerg,"11","Quanto ao Financeiro 	   ?",""       ,""      ,"mv_chd","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR13","Sim           ",""     ,""     ,""   ,""   ,"Nao              ",""     ,""     ,""   ,""   ,"Ambos",""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
Return