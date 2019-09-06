#include "Rwmake.ch"
#include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PA0164   บAutor  ณ Alexandro da Silva บ Data ณ  06/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para ajustar o SB2, SBF, SB8                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Estoque                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PA0164()

ATUSX1()
/*
_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Acerto EstoqueXLoteXEndere็o - PA0164 ")
@ 02,10 TO 080,220

@ 10,18 SAY "O objetivo desta rotina  exibir detalhadamente todas as diferenas" SIZE 160,7
@ 18,18 SAY "de Saldo entre os arquivos SB2 x SB8 x SBF."                         SIZE 160,7
@ 26,18 SAY "Conforme Parametros Informados.                                    " SIZE 160,7
@ 34,18 SAY "Programa PA0164.PRW                                                " SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0164")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
Private _cMsg01    := ''
Private _lFim      := .F.
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PROC1(@_lFim) }
Private _cTitulo01 := 'Selecionando.......'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

Return

*/

If !Pergunte("PA0164",.T.)
	Return
Endif

Private _cMsg01    := ''
Private _lFim      := .F.
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PROC1(@_lFim) }
Private _cTitulo01 := 'Selecionando.......'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

ZZ->(dbCloseArea())


Return


Static Function PROC1(_lFim)


_acampos := {}
AADD(_aCampos,{ "CODIGO"   ,"C",15,0 } )
AADD(_aCampos,{ "LOC"      ,"C",02,0 } )
AADD(_aCampos,{ "DESCRI"   ,"C",30,0 } )
AADD(_aCampos,{ "QTd_SB2"  ,"N",15,2 } )
AADD(_aCampos,{ "QTd_SB8"  ,"N",15,2 } )
AADD(_aCampos,{ "DIF_B2B8" ,"N",15,2 } )
AADD(_aCampos,{ "QTd_SBF"  ,"N",15,2 } )

cNomArq := CriaTrab(_aCampos)
dbUseArea( .T.,, cNomArq, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq,"CODIGO+LOC",,,OemToAnsi("Selecionando Registros..."))

SBF->(DbSetOrder(2))
SB8->(DbSetOrder(1))

_cq := " SELECT * FROM "+RetSqlName("SB2")+" A INNER JOIN "+RetSqlName("SB1")+" B ON B2_COD=B1_COD "
_cQ += " WHERE A.D_E_L_E_T_  = '' AND B.D_E_L_E_T_ = '' AND B2_COD BETWEEN '"+MV_PAR01+" ' AND '"+MV_PAR02+" ' "
_cQ += " AND B2_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND B1_TIPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQ += " AND B2_QATU >= 0 "
_cQ += " ORDER BY B2_COD "

TCQUERY _cQ New Alias "ZZ"

ProcRegua(ZZ->(U_CONTREG()))

While ZZ->(!Eof()) .And. !_lFim
	
	IncProc()
	
	_lRastro    := .f.
	_nsaldo_B8  := 0
	
	IF ZZ->B1_RASTRO $ "SL"
		Dbselectarea("SB8")
		DBSEEK(XFILIAL("SB8")+ZZ->B2_COD+ZZ->B2_LOCAL,.T.)
		
		WHILE ZZ->B2_COD + ZZ->B2_LOCAL == SB8->B8_PRODUTO+SB8->B8_LOCAL .AND. SB8->(!EOF())
			_nSaldo_B8 += SB8->B8_SALDO
			SB8->(DbSkip())
		EndDo
		If ZZ->B2_QATU # _nSaldo_B8 .Or. mv_par07 = 2
			_lRastro := .t.
		Endif
	ENDIF
	
	_lLocaliz := .f.
	_nSaldo_Bf := 0
	
	IF SB1->B1_LOCALIZ = "S"
		
		DbSelectArea("SBF")
		SBF->(DbSetOrder(2))
		dbseek(xfilial("SBF")+ZZ->B2_COD + ZZ->B2_LOCAL)
		
		While ZZ->B2_COD + ZZ->B2_LOCAL == BF_PRODUTO+BF_LOCAL .and. SBF->(!Eof())
			_nSaldo_Bf +=  SBF->BF_QUANT
			SBF->(dbskip())
		Enddo
		
		Dbselectarea("SDA")
		dbSetOrder(1)
		DBSEEK(XFILIAL("SDA")+ZZ->B2_COD + ZZ->B2_LOCAL,.T.)
		
		WHILE ZZ->B2_COD + ZZ->B2_LOCAL == DA_PRODUTO+DA_LOCAL .AND. SDA->(!EOF())
			_nSaldo_Bf += SDA->DA_SALDO
			SDA->(dbSkip())
		EndDo
		
		If ZZ->B2_QATU # _nSaldo_Bf .or. mv_par07 = 2
			_lLocaliz := .t.
		Endif
		
	Endif
	
	If 	_lLocaliz .or. _lRastro
		dbselectarea("TRB")
		RECLOCK("TRB",.T.)
		CODIGO   := ZZ->B2_COD
		LOC  	 := ZZ->B2_LOCAL
		DESCRI   := ZZ->B1_DESC
		QTd_SB2  := ZZ->B2_QATU
		QTd_SB8  := _nSaldo_B8
		DIF_B2B8 := ZZ->B2_QATU - _nSaldo_B8
		QTd_SBF  := _nSaldo_Bf
		MSUNLOCK()
	Endif
	
	ZZ->(dbSkip())
EndDo

Private cCadastro := "Cadastro de Divergencias de Estoques"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta um aRotina proprio                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private aRotina  := { 	{"Alterar"      ,"u__act_est",0,4} }
Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString  := "TRB"

dbSelectArea("TRB")
_aCampos	:= 		{{"Codigo"	      	    , 	"CODIGO"	, 	'C',15,00, "@!"	},;
{"local" 	  			, 	"LOC"		, 	'C',02,00, "@!"},;
{"Descricao do Produto", 	"Descri"	, 	'C',35,00, "@!"},;
{"Saldo em estoque"	, 	"qtd_sb2"	, 	'N',15,02, "@e 999,999,999.99"},;
{"Saldo em Lotes" 		, 	"qtd_sb8"	, 	'N',15,02, "@e 999,999,999.99"},;
{"Dif.Estoque x Lote"  , 	"DIF_B2B8"	, 	'N',15,02, "@e 999,999,999.99"},;
{"Saldo em Enderecos"	, 	"qtd_sbf"	, 	'N',15,02, "@e 999,999,999.99"}}

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,_aCampos )


dbSelectArea("TRB")
dbCloseArea("TRB")

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_check_endบAutor  ณEveraldo Gallo      บ Data ณ  06/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _act_est

_aTab_B8 := {}

dbselectarea("SB1")
DBSEEK(XFILIAL("SB1")+TRB->CODIGO)

IF SB1->B1_RASTRO $ "SL"
	
	Dbselectarea("SB8")
	DBSEEK(XFILIAL("SB8")+TRB->CODIGO+TRB->LOC,.T.)
	
	DO WHILE TRB->CODIGO+TRB->LOC == B8_PRODUTO+B8_LOCAL .AND. !EOF()
		aadd(_aTab_B8,{B8_DTVALID,B8_LOTECTL,B8_NUMLOTE,B8_SALDO,B8_QTDORI,DTOS(B8_DATA),B8_SALDO,recno()})
		DbSkip()
		
	EndDo
	aadd(_aTab_B8,{,"TOTAL",,trb->qtd_Sb8,,,})
	
else
	
	aadd(_aTab_B8,{,"-----",,,,,})
	
Endif

_aTab_Bf := {}

_naEnder := 0

IF SB1->B1_LOCALIZ = "S"
	
	Dbselectarea("SBF")
	DBSEEK(XFILIAL("SBF")+TRB->CODIGO+TRB->LOC,.T.)
	
	DO WHILE TRB->CODIGO+TRB->LOC == BF_PRODUTO+BF_LOCAL .AND. !EOF()
		aadd(_aTab_Bf,{bf_localiz,BF_LOTECTL,BF_NUMLOTE,BF_QUANT,BF_QUANT,recno()})
		DbSkip()
	EndDo
	
	aadd(_aTab_Bf,{"TOTAL",,,trb->qtd_Sbf,,,})
	
	Dbselectarea("SDA")
	dbSetOrder(1)
	DBSEEK(XFILIAL("SDA")+TRB->CODIGO+TRB->LOC,.T.)
	
	DO WHILE TRB->CODIGO+TRB->LOC == DA_PRODUTO+DA_LOCAL .AND. !EOF()
		_naEnder += da_saldo
		DbSkip()
	EndDo
Else
	aadd(_aTab_Bf,{"-----",,,})
Endif


_nTot_Lots := trb->qtd_Sb8
_nTot_Ends := trb->qtd_Sbf

DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
DEFINE MSDIALOG oDlg FROM 000,000  TO 450,800 TITLE OemToAnsi("Posicao de Estoque") Of oMainWnd PIXEL

@ 004,002 SAY Alltrim(SB1->B1_COD)+ " - "+SB1->B1_DESC +  "   QT.EM ESTOQUE " + TRANSFORM(TRB->QTD_SB2,"@E 999,999,999.99")  Of oDlg PIXEL SIZE 245,009 FONT oBold
@ 013,004 To 13,397 Label "" of oDlg PIXEL

/// ***** BOX DE LOTES (SUPERIOR) *****

_atit_cab1:= 	{"Dt.Validade","Lote","Sub-lote","Saldo","Qtd.Original","Dt.Cr.Lote","Qtd apos o Acerto","Controle"}
_atam_cab1:= 	{45,45,45,45,45,45,45}
@ 017,002 SAY OemToAnsi("Lotes") of oDlg PIXEL COLOR CLR_HBLUE
oListBox2 := TWBrowse():New( 025,2,397,69,,_atit_cab1,_atam_cab1,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox2:SetArray(_aTab_B8)
oListBox2:bLine := { || _aTab_B8[oListBox2:nAT]}
oListBox2:blDblClick := {|| Alin_qtd(1,oListBox2:nAT,7),oListBox2:refresh() }

/// ***** BOX DE ENDERECOS (INFERIOR) *****

_atit_cab2:= 	{"Endereco","Lote","Sub-Lote","Quantidade","Qtd apos o Acerto","Controle"}
_atam_cab2:= 	{55,55,55,55,55}
@ 117,002 SAY OemToAnsi("Enderecos") of oDlg PIXEL COLOR CLR_HBLUE
oListBox3 := TWBrowse():New( 125,2,397,69,,_atit_cab2,_atam_cab2, oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox3:SetArray(_aTab_Bf)
oListBox3:bLine := { || _aTab_Bf[oListBox3:nAT]}
oListBox3:blDblClick := {|| Alin_qtd(2,oListBox3:nAT,5),oListBox3:refresh() }
@ 196,200 SAY "TOTAL A ENDERECAR "+TRANSFORM( _naEnder,"@E 999,999,999.99") of oDlg PIXEL FONT oBold COLOR CLR_HRED

@ 008,250 BUTTON OemToAnsi("Novo Endereco") SIZE 045,015  FONT oDlg:oFont ACTION {|| _Cr_NewEnd(),oDlg:refresh() }  OF oDlg PIXEL
@ 008,300 BUTTON OemToAnsi("Ajustar") SIZE 045,015  FONT oDlg:oFont ACTION {|| AJUSTA_ARQ(),oDlg:End() }  OF oDlg PIXEL
@ 008,350 BUTTON OemToAnsi("Sair")    SIZE 045,015  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED
DBSELECTAREA("SB1")

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTEL_B2B8BFบAutor  ณMicrosiga           บ Data ณ  07/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static function Alin_qtd(_ntab,_nlin,_ncol)

if _ntab == 1
	if _aTab_B8[_nlin,2] = "TOTAL" .OR. _aTab_B8[_nlin,2] = "-----"
		RETURN()
	ENDIF
	_nNewQtd := _aTab_B8[_nlin,_ncol]
else
	if _aTab_BF[_nlin,1] = "TOTAL" .OR. _aTab_BF[_nlin,1] = "-----"
		RETURN()
	ENDIF
	_nNewQtd := _aTab_Bf[_nlin,_ncol]
endif

DEFINE MSDIALOG oDlg1 FROM 000,000  TO 150,250 TITLE OemToAnsi("Informe a nova Quantidade") Of oMainWnd PIXEL
@ 1,1 Say "Nova Quantidade"   of odlg1
@ 2,1 get  _nNewQtd PICTURE "@E 999,999,999.99" SIZE 50,4 of odlg1
@ 5,15 BUTTON "Ok" SIZE 50,15 ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTER

if _ntab == 1
	_aTab_B8[_nlin,_ncol]:= _nNewQtd
	_nTot_Lots := 0
	FOR _X:=1 TO LEN(_aTab_B8)-1
		_nTot_Lots += _aTab_B8[_X,_ncol]
	NEXT _X
	_aTab_B8[LEN(_aTab_B8),4]:= _nTot_Lots
else
	_aTab_Bf[_nlin,_ncol]:= _nNewQtd
	_nTot_Ends := 0
	FOR _X:=1 TO LEN(_aTab_BF)-1
		_nTot_Ends += _aTab_Bf[_X,_ncol]
	NEXT _X
	_aTab_BF[LEN(_aTab_BF),4]:= _nTot_Ends
endif

odlg:refresh()

return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTA_ARQบAutor  ณMicrosiga           บ Data ณ  07/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AJUSTA_ARQ

_llimpa :=.f.

IF SB1->B1_RASTRO $ "SL"
	if 	_aTab_B8[len(_aTab_B8),4] # TRB->QTD_SB2
		msgstop("Saldo Dos lotes nao Batem !!!!! Verifique")
		_llimpa :=.f.
	else
		_llimpa :=.t.
		FOR A:=1 TO LEN(_aTab_B8)-1
			IF _aTab_B8[a,7] # _aTab_B8[a,4]
				DBSELECTAREA("SD5")
				RECLOCK("SD5",.T.)
				replace D5_FILIAL   WITH  XFILIAL('SD5')
				replace D5_PRODUTO  WITH  TRB->CODIGO
				replace D5_LOCAL    WITH  TRB->LOC
				replace D5_DATA     WITH  DDATABASE
				replace D5_DTVALID  WITH  _aTab_B8[a,1]
				replace D5_LOTECTL  WITH  _aTab_B8[a,2]
				replace D5_NUMLOTE  WITH  _aTab_B8[a,3]
				replace D5_DOC      WITH  "AC"+SUBSTR(DTOS(DDATABASE),5,4)
				if _aTab_B8[a,7] < _aTab_B8[a,4]
					replace D5_QUANT    WITH  _aTab_B8[a,4]-_aTab_B8[a,7]
					replace D5_ORIGLAN  WITH '999'
				else
					replace D5_QUANT    WITH  _aTab_B8[a,7]-_aTab_B8[a,4]
					replace D5_ORIGLAN  WITH '499'
				endif
				SD5->(MSUNLOCK())
				
				DBSELECTAREA("SB8")
				GOTO _aTab_B8[a,8]
				RECLOCK("SB8",.F.)
				B8_SALDO := _aTab_B8[a,7]
				SB8->(MsUnlock())
			ENDIF
			
		NEXT A
	endif
Endif


IF SB1->B1_LOCALIZ = "S"
	
	if 	_aTab_Bf[len(_aTab_Bf),4] # TRB->QTD_SB2
		msgstop("Saldo Dos Enderecos nao Batem !!!!! Verifique")
		_llimpa :=.f.
	else
		_llimpa :=.t.
		FOR A:=1 TO LEN(_aTab_Bf)-1
			IF _aTab_Bf[a,5] # _aTab_Bf[a,4]
				_cProxNum	:= SDB->(ProxNum())
				DBSELECTAREA("SDB")
				RecLock("SDB",.t.)
				DB_FILIAL 	:=	xFilial("SDB")
				DB_ITEM		:= "0001"
				DB_PRODUTO	:= TRB->CODIGO
				DB_LOCAL	:= TRB->LOC
				DB_LOCALIZ	:= _aTab_Bf[a,1]
				DB_DOC		:= "AC"+SUBSTR(DTOS(DDATABASE),5,4)
				DB_ORIGEM	:= "SD3"
				DB_DATA		:= dDataBase
				DB_LOTECTL	:= _aTab_Bf[a,2]
				DB_NUMLOTE	:= _aTab_Bf[a,3]
				DB_NUMSEQ	:= _cProxNum
				DB_TIPO		:= "D"
				DB_ATIVID	:= "ZZZ"
				DB_ANOMAL   := "N"
				if _aTab_Bf[a,5] < _aTab_Bf[a,4]
					DB_TM		:= "999"
					DB_SERVIC	:= "999"
					DB_QUANT	:= _aTab_Bf[a,4] - _aTab_Bf[a,5]
				else
					DB_TM		:= "499"
					DB_SERVIC	:= "499"
					DB_QUANT	:= _aTab_Bf[a,5] - _aTab_Bf[a,4]
				endif
				SDB->(MsUnLock())
				
				if _aTab_BF[a,6] # 0
					DBSELECTAREA("SBF")
					GOTO _aTab_BF[a,6]
					RecLock("SBF",.f.)
					SBF->BF_QUANT := _aTab_Bf[a,5]
					SBF->(MsUnLock())
				else
					RecLock("SBF",.t.)
					SBF->BF_FILIAL  := xFilial("SBF")
					SBF->BF_PRODUTO := TRB->CODIGO
					SBF->BF_LOCAL	 := TRB->LOC
					SBF->BF_LOTECTL	 := _aTab_Bf[a,2]
					SBF->BF_NUMLOTE	 := "       "
					SBF->BF_LOCALIZ	 := _aTab_Bf[a,1]
					SBF->BF_PRIOR	 := "   "
					SBF->BF_QUANT    := _aTab_Bf[a,5]
					SBF->(MsUnLock())
				endif
				
			endif
			
		next a
		
	endif
	
Endif


if _llimpa
	dbselectarea("TRB")
	RecLock("TRB",.f.)
	DELETE
	SBF->(MsUnLock())
ENDIF



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_Cr_NewEndบAutor  ณMicrosiga           บ Data ณ  08/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function _Cr_NewEnd


DEFINE MSDIALOG oDlg1 FROM 000,000  TO 250,350 TITLE OemToAnsi("Informe a nova Quantidade") Of oMainWnd PIXEL

_lcria :=.f.
_cNewLocal := space(2)
_cNewLote  := space(10)
_cNewEnder := space(15)

/*
@ 1,1 Say "Novo Endereco"  	of odlg1
@ 2,1 get  _cNewEnder PICTURE "@!" SIZE 70,4 of odlg1

@ 4,1 Say "Lote"     		of odlg1
@ 5,1 get  _cNewLote  PICTURE "@!"  SIZE 70,4 of odlg1

@ 8 ,32 BUTTON "Cancela" SIZE 30,15 ACTION {|| oDlg1:End()}
@ 10,32 BUTTON "Ok"      SIZE 30,15 ACTION {|| _cria_loc() , oDlg1:End()}
*/
ACTIVATE DIALOG oDlg1 CENTER

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_cria_loc บAutor  ณMicrosiga           บ Data ณ  16/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _cria_loc

dbselectarea("SBE")
dbsetorder(1)
dbseek(xfilial("SBE")+mv_par03+_cNewEnder)

If eof()
	
	msgstop("Locallizacao nao existe no armazem "+ mv_par03 +" !!!   Verifoque !!!")
	
else
	
	_npos := Ascan(_aTab_B8, {|x| Trim(x[2]) ==  Trim(_cNewLote)	})
	
	if _npos == 0
		
		msgstop("Lote nao exite para este produto !!!   Verifoque !!!")
		
	else
		
		_aTab_Bf[len(_aTab_Bf),1] := _cNewEnder
		_aTab_Bf[len(_aTab_Bf),2] := _cNewLote
		_aTab_Bf[len(_aTab_Bf),4] := 0
		_aTab_Bf[len(_aTab_Bf),5] := 0
		_aTab_Bf[len(_aTab_Bf),6] := 0
		_nTot_Ends :=0
		
		FOR _X:=1 TO LEN(_aTab_BF)
			_nTot_Ends += _aTab_Bf[_X,5]
		NEXT _X
		
		aadd(_aTab_Bf,{"TOTAL",,,_nTot_Ends,,,})
	endif
endif


Static Function AtuSX1()

cPerg := "PA0164"
aRegs :={}

///////////////////////////////////////////////
///////////////////////////////////////////////
/////  Grupo de Pergunta PA0149          //////
/////  MV_PAR01 : Cliente      De ?      //////
/////  MV_PAR02 : Cliente     Ate ?      //////
/////  MV_PAR03 : Loja Ate     De ?      //////
/////  MV_PAR04 : Loja Ate    Ate ?      //////
/////  MV_PAR05 : Produto      De ?      //////
/////  MV_PAR06 : Produto     Ate ?      //////
/////  MV_PAR07 : Emissao      De ?      //////
/////  MV_PAR08 : Emissao     Ate ?      //////
/////  MV_PAR09 : Grupo        De ?      //////
/////  MV_PAR10 : Grupo       Ate ?      //////
///////////////////////////////////////////////
///////////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02  /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Produto De            ?",""       ,""      ,"mv_ch1","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR01",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"02","Produto Ate           ?",""       ,""      ,"mv_ch2","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR02",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"03","Almoxarifado De       ?",""       ,""      ,"mv_ch3","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR03",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"04","Almoxarifado Ate      ?",""       ,""      ,"mv_ch4","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR04",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"05","Tipo De               ?",""       ,""      ,"mv_ch5","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR05",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"02")
U_CRIASX1(cPerg,"06","Tipo Ate              ?",""       ,""      ,"mv_ch6","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR06",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"02")
U_CRIASX1(cPerg,"07","So c/ Diferenca       ?",""       ,""      ,"mv_ch7","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR07","Sim"        ,""     ,""     ,""   ,""   ,"Nao"  ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return