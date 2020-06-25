#include "rwmake.ch"
#INCLUDE 'COLORS.CH'
#XCommand ROLLBACK TRANSACTION => DisarmTransaction()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³  PXH055  ³ Autor ³ ALEXANDRO DA SILVA    ³ Data ³ 06.07.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Saida de caminhao carregado                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFAT - Menu Atualizacoes                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ALTERAÇÕES:
*/

User Function PXH055(p_cOrigem)

SetPrvt("_BALSAI,_SERIE,_TES,_NF,_PESO_ENT,_PESO_SAI")
SetPrvt("_PESO_LIQCALC,_PESO_LIQ,_PESO_LIQINF,_HORA,_DTSAIDA,_LACRE")
SetPrvt("_QTD_FAT,_ACHOU,_SAL_NF,_SENHA,_LODLG4,_MARGEM")
SetPrvt("_PESO_TOTAL,_PESO_MAXIMO,_PESO_MINIMO,_PESO_EXCED,_NUMSEQ,WALIQICM,_ESTADO")
SetPrvt("_PISS,_PICM,_VLFRE,_AEST,_GRPTRIB,_AMUN")
SetPrvt("_PRCVEN,_OPCAO,_PRFIM,_F4IPI,_IPI,_F4IPIFR")
SetPrvt("_BASEIPIF,_F4INCIDE,_F4ICM,_A1TIPO,_B1PICRET,_QTDE")
SetPrvt("AVETOR,_VALIPI,_VALICM,_BASEICM,_ICMSRET,_VALIPIF")
SetPrvt("_ICMFRET,_BICMFRE,_BASEIPI,_BRICMS,_BASEISS,_VALISS,_DtLib")
SetPrvt("_TOTAL,_VALTOT,_APARC,_APARCELA,_NPARCELA,_TAXA_PER")
SetPrvt("I,WVENCTO,_NUMNFAUX,_F4REDICM,_reg,cpref,cDoc,cSerie,cCliente,cLoja")
Private dta_lim,nvalf:=0,_picmest:=0,ypalt:="N"
Private nqtven := 0, cprven := space(1)
Private nabatep := 0,nqtpal:=0
Private Odlg1,Odlg2,odlg3,odlg4,odlg5,lret,oGetlacre,cGetlacre:=SPACE(45)
Private _prefixo := Space(3)
Private nsal2um := 0
Private wPedag := 0
Private _peso_sai := 0
private   nOpca
private lAltLacre,_lTicket := .f.
Private _aPedSZF := {}

private cOrigem:= iif(p_cOrigem==nil, '',p_cOrigem)

private lUsaNewOC :=  .T. //( cFilAnt $  getnewPar('MV_USNEWOC','01')  .and. cOrigem == 'MIZ999'	 )

private cColeta:= "A"

dta_lim := getmv("MV_DATAFIS")

If ddatabase <= dta_lim
	MsgBox("A data limite do faturamento nao permite faturar na database solicitada. Verifique com o Administrador do Sistema","Atencao","ALERT")
	Return
EndIf

_BalSai := alltrim(getmv("PXH_BALSAI"))

If  ! file(_BalSai)
	MsgBox("Arquivo de balanca nao foi encontrado!","Atencao","ALERT")
	Return
End

_serie   := StrTran(PadR(getmv("PXH_SERIE"),3," "),"*"," ")

//_prefixo := alltrim(getmv("MV_YPREF"))

/*
dbSelectArea("SX5")
dbSetOrder(1)
If dbSeek(xFilial("SX5")+"01"+_serie)
If  subs(SX5->X5_DESCRI,1,1) == "*"
help("Numero NF",1,"Y_MIZ001 Num NF")
Return
End
_nf := PADR(strzero(val(SX5->X5_DESCRI),6),9)
Else
help("",1,"Y_MIZ002 N")
Return
End
_serie   := IIF( cFilAnt $ GetMv("MV_YFILKEY"), LEFT(_serie,1), _serie )
*/
calias2 := Alias()
ntotsc  := 0

_aPedSZF:= {}

DbSelectArea("SZF")
DbSetOrder(8)
DbSeek(xFilial("SZF")+SZF->ZF_OC)
Do while .not. eof() .and. ZF_FILIAL == xFilial("SZF") .and. ZF_OC == SZF->ZF_OC
	If SZF->ZF_UNID $ "SC,SA"
		ntotsc+=SZF->ZF_QUANT
		AADD(_aPedSZF,{SZF->ZF_PRODUTO,SZF->ZF_QUANT})
	EndIf
	
	If Alltrim(SZF->ZF_PRODUTO)=="PALET"
		nqtpal+=SZF->ZF_QUANT
	EndIf
	
	DbSkip()
EndDo

DbSelectArea(calias2)
SZF->(DbSetOrder(8))
SZF->(DbSeek(xFilial("SZF")+SZF->ZF_OC))

_peso_ent     := SZF->ZF_PSENT
_peso_sai     := SZF->ZF_PSSAI

If !Empty (GetMV("PXH_COMSAI")) .and. !lUsaNewOC
	MsAguarde({||fPesoBal()},"Lendo Peso...")
Endif

lpesoOk:=.f.
While  !lpesoOK
	
	If  _peso_sai <= 0
		U_PXH05401(@_peso_sai,"SAIDA",@cColeta)
	Endif
	
	if !( lpesoOK:=( _peso_sai > 0 ) )
		lpesoOK:= MsgBox("Peso da Balança: "+TRANSFORM(_peso_sai,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
		if lpesoOk;exit;endif
		_peso_sai := 0
	endif
	
EndDo

if (_peso_sai==0)
	Alert('Nao e permitido prosseguir sem peso!')
	return
endif

If _peso_sai >= 88888
	
	Alert("Atencao, peso da balanca esta ERRADO. VERIFIQUE!")
	
EndIf

_peso_liqcalc := (_peso_sai - _peso_ent)

If  SZF->ZF_UNID = "TL"
	_peso_liqcalc := _peso_liqcalc / 1000
End

_peso_liq      := _peso_liqcalc
_peso_liqinf   := 0
_hora          := left(time(),5)
_DtSaida       := dDataBase
_lacre         := SZF->ZF_LACRE
_nomCli        := sZF->ZF_nomcli
_localcli      := sZF->ZF_local
_ufCli         := sZF->ZF_ufe

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))

If Alltrim(SB1->B1_TIPCAR) == "S"
	_nQtde   := (SZF->ZF_QUANT * SB1->B1_CONV) / 1000
	_nQtdeNf := (SZF->ZF_QTENF * SB1->B1_CONV) / 1000
Else
	_nQtde   := SZF->ZF_QUANT
	_nQtdenF := SZF->ZF_QTENF
Endif

nF2FRETE := 0
If _nQtdenF  > 0 .and. SB1->B1_YTRBIG==0 .and. SZF->ZF_UNID $ "SC"
	nF2FRETE  := Iif(SZ3->Z3_TIPO=="2",(SZF->ZF_FMOT * _nQtde) / (_nQtde + _nQtdenF),(SZF->ZF_FTRA * _nQtde)/(_nQtde + _nQtdenF))
Else
	nF2FRETE  := Iif(SZ3->Z3_TIPO=="2",SZF->ZF_FMOT,SZF->ZF_FTRA) //SZF->ZF_VLFRE
EndIf

If  SZF->ZF_UNID $ "SC,SA"
	_qtd_fat := ntotsc
End

U_PXH05501('PXH055')

Return(.T.)

Static Function val_nf(p_nf)

_achou := .T.
if p_nf <> nil
	_nf:= p_nf
endif
_Sal_NF := _nf

dbSelectArea("SF2")
dbSetOrder(1)
If (_achou:=dbSeek(xFilial("SF2") + _nf + _serie))
	_nf := PADR(strzero(val(SX5->X5_DESCRI),6),9)
	MsgBox("NF "+_Sal_NF + " ja existe. Sera utilizada a NF numero " + _nf + ".","Aten‡Æo","ALERT")
Endif

SF1->(dbOrderNickName("INDSF12"))
If SF1->(dbSeek(xFilial("SF1") + _nf + _serie +"S"))
	_lAchou := .T.
	_nf 	:= PADR(strzero(val(SX5->X5_DESCRI),6),9)
	MsgBox("NF "+_Sal_NF + " ja existe. Sera utilizada a NF numero " + _nf + ".","Aten‡Æo","ALERT")
Endif

Return .not. _achou


Static Function Altera_LACRE()

oGetlacre:enable()
if !laltlacre
	oGetlacre:setfocus()
endif
odlg1:refresh()
laltlacre:=.T.
RETURN





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ fajfrete                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Atualiza arquivos referentes a emissao da NF               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fajfrete()
Private nFreteFixo:=0

If SZF->ZF_UNID == "TL" .and. SZF->ZF_FRETE == "C"
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
	SZG->(DbSetOrder(1))
	SZG->(DbSeek(xFilial("SZG")+SZF->ZF_UFE+SZF->ZF_MUNE+SZF->ZF_FORNECE+SZF->ZF_LOJAF + "L"))
	
	If nvalf == 0
		nvalf := Iif(SA1->A1_YFGRA > 0,Round(_peso_liqinf * SA1->A1_YFGRA,2),Round(_peso_liqinf * SZG->ZG_VALOR,2))
	EndIf
	DEFINE MSDIALOG oDlgf TITLE "Ajusta valor do frete" FROM 40,50 TO 230,430 PIXEL
	@ 40,15 say "Valor do Frete:"
	@ 40,70 get nvalf Size 60,100   Pict "@e 999,999,999.99"
	@ 60,100 BmpButton Type 1 Action Close(oDlgf)
	Activate MsDialog oDlgf Centered
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+SZF->ZF_MOTOR))
	While !Reclock("SZF",.f.);EndDo
	If SZ3->Z3_TIPO == "2"
		SZF->ZF_FMOT := nvalf
	Else
		SZF->ZF_FTRA := nvalf
	EndIf
	MsUnlock()
Else
	MsgBox("Essa opcao e valida apenas para produtos com unidade de medida TL","Atencao","ALERT")
EndIf
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ Continua                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Atualiza arquivos referentes a emissao da NF               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Continua()

_margem      := 0

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+SZF->ZF_PRODUTO)
IF SZF->ZF_YPM == "P"
	_margem      := getmv("PXH_MARGEM")
ELSEIF SZF->ZF_YPM == "M"
	_margem      := getmv("PXH_MRGMAN")
ELSEIF SZF->ZF_YPM $  "BG"
	_margem      := 0
END

_nQtTot:= 0
_aConv := {}

If SZF->ZF_UNID $ 'SC*SA'
	
	For AX:= 1 To Len(_aPedSZF)
		_cProd := _aPedSZF[AX,1]
		
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+ _cProd))
		
		If  AScan(_aConv,SB1->B1_CONV) == 0
			AADD(_aConv,{SB1->B1_CONV})
		Endif
		
		_nQt    := _aPedSZF[AX,2] * SB1->B1_CONV
		_nQtTot += _nQt
		
	Next AX
	
	_peso_total := _nQtTot
	
Else
	_peso_total := _peso_liq * SB1->B1_CONV
Endif

_peso_maximo := _peso_total + (_peso_total * _margem / 100)
_peso_minimo := _peso_total - (_peso_total * _margem / 100)
_peso_exced  := _peso_liq   - _peso_total

_CargaVeiculo:= Posicione("DA3",3,xFilial('DA3')+SZF->ZF_PLACA,"DA3_CAPACM")

If _peso_total > _CargaVeiculo
	If !MsgBox("Peso acima da capacidade maxima do veiculo. Liberar mesmo assim?  ","Escolha","YESNO")
		Return .F.
	Else
		If !u_FnSenhaPeso('SAIDA'); Return .F.; Endif
	Endif
Endif

_loDlg4 := .F.
If  SZF->ZF_UNID $ "SC,SA"
	If  _peso_liq > _peso_maximo .or. _peso_liq < _peso_minimo
		_loDlg4 := .T.
		DEFINE MSDIALOG oDlg4 TITLE "Saida de Caminhao carregado" FROM 0,0 TO 300,500 PIXEL
		@ 8,10 to 100,220
		
		_nLin := 20
		@ _nlin,15 say "Total de Sacos:"
		@ _nLin,70 say trans(_qtd_fat    ,"@E 999,999")
		
		_nLin+= 10
		
		For AZ:= 1 To Len(_aConv)
			@ _nLin,15 Say "Saco de "+Trans(_aConv[AZ],"@E 999")+" :"
			@ _nLin,70 Say Trans(_aConv[AZ],"@E 999,999,999.99")
			_nLin+= 10
		Next AZ
		
		@ _nLin,15 say "Peso Total:"
		@ _nLin,70 say trans(_peso_total ,"@E 999,999,999.99")
		
		_nLin+=20
		
		@ _nLin,15 say "Peso Liquido:"
		@ _nLin,70 say trans(_peso_liq   ,"@E 999,999,999.99")
		
		_nLin+= 10
		
		@ _nLin,15 say "Diferenca no peso:"
		@ _nLin,70 say trans(_peso_exced ,"@E 999,999,999.99")
		
		_nLin+= 10
		
		If Len(_aConv) == 1
			@ _nLin,15 say "DIFERENCA SACOS:"
			@ _nLin,70 say trans((_peso_liq /SB1->B1_CONV) - _qtd_fat ,"@E 999,999,999.99")
		Endif
		
		@ 110,140 BmpButton Type 1  Action Close(odlg4)
		@ 110,190 BmpButton Type 2  Action Close(odlg4)
		Activate MsDialog oDlg4 Centered
		
	EndIf
EndIf

aNotas:= {}

If Gera_NF()
	U_MzNfetransm('TODAS',_serie, aNotas[1], aNotas[len(aNotas)] )
Endif


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ Gera_NF                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Atualiza arquivos referentes a emissao da NF               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Gera_NF()

local lReturn:=.f.

Private npesoSZF:=0,cpedmaior:="",npedmaior :=0,_senha2:=Space(10),cpeconv:=0

If  _loDlg4
	
	DEFINE MSDIALOG oDlg5 TITLE "Senha" FROM 40,50 TO 100,300 PIXEL
	@ 08,10 say "Senha:"
	@ 08,35 get _senha2 PassWord
	@ 14,95 BmpButton Type 1 Action Close(oDlg5)
	
	Activate MsDialog oDlg5 Centered
	
	If  alltrim(_senha2) <> Alltrim(GetMV("PXH_SENPRO"))
		MsgBox("Atencao, senha errada","Atencao","ALERT")
		Return
	EndIf
	
EndIf

Begin Transaction

DbSelectArea("SZF")
DbSetOrder(8)
DbSeek(xFilial("SZF")+SZF->ZF_OC)

npedmaior := 0

while .not. SZF->(eof()) .and. ZF_FILIAL == xFilial("SZF") .and. SZF->ZF_OC == SZF->ZF_OC
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))
	
	
	If SZF->ZF_QUANT > npedmaior
		npedmaior := SZF->ZF_QUANT
		cpedmaior := SZF->ZF_NUM
		cpeconv   := SB1->B1_CONV
	EndIf
	If  SZF->ZF_UNID $ "SC,SA"
		_qtd_fat   := SZF->ZF_QUANT
	Else
		_qtd_fat   := _peso_liq
	End
	If SZF->ZF_UNID == "TL"
		npesoSZF += Round(_qtd_fat * 1000,2)
	ElseIf SZF->ZF_UNID $ "SC,SA"
		npesoSZF += Round(_qtd_fat * SB1->B1_CONV,2)
	Else
		MsgBox("Atencao, a unidade de medida do produto utilizado no pedido "+SZF->ZF_NUM+" nao esta preparado para conversao!","atencao","ALERT")
	EndIf
	SZF->(DbSkip())
EndDo

//wPedag := SZF->ZF_PEDAGIO / _peso_liq

DA3->(dbSetOrder(3))
If DA3->(dbSeek(xFilial("DA3")+SZF->ZF_PLACA))
	If npesoSZF > DA3->DA3_CAPACM
		MsgBox("Atencao, o pedido "+cpedmaior+" foi dividido em 2 notas fiscais devido ao excesso de peso da Ordem de Carregamento","Atencao","ALERT")
		DbSelectArea("SZF")
		DbSetOrder(1)
		If DbSeek(xFilial("SZF")+cpedmaior)
			While !Reclock("SZF",.f.);EndDo
			If SZF->ZF_UNID == "TL"
				SZF->ZF_QTENF:= _peso_liq - (Round((npesoSZF - DA3->DA3_CAPACM)/1000,2))
			ElseIf SZF->ZF_UNID $ "SC,SA"
				SZF->ZF_QTENF:= SZF->ZF_QUANT - Int((npesoSZF - DA3->DA3_CAPACM)/cpeconv)
			EndIf
			MsUnlock()
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravar o faturamento                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ldivide := .F.
DbSelectArea("SZF")
DbSetOrder(8)
DbSeek(xFilial("SZF")+SZF->ZF_OC)
Do while .not. eof() .and. ZF_FILIAL == xFilial("SZF") .and. SZF->ZF_OC == SZF->ZF_OC
	
	SA1->(DbSetOrder(1))
	IF !SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
		ALERT(' CLIENTE:  '+SZF->(ZF_CLIENTE+LOJA) + ' - '+ SZF->ZF_NOMCLI )
		SZF->(DBSKIP())
		LOOP
	ENDIF
	
	
	If SZF->ZF_QTENF > 0
		If ldivide == .f.
			While !Reclock("SZF",.f.);EndDo
			If SZF->ZF_UNID $ "SC,SA"
				SZF->ZF_QUANT := SZF->ZF_QUANT - SZF->ZF_QTENF
			Else
				SZF->ZF_QUANT := _peso_liq - SZF->ZF_QTENF
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Fazer com que a 2a NF tenha pelo mais de uma tonelada - 15/10/02         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SZF->ZF_QUANT < 1
					SZF->ZF_QTENF :=  SZF->ZF_QTENF - 1
					SZF->ZF_QUANT :=  SZF->ZF_QUANT + 1
				EndIf
			EndIf
			MsUnlock()
			_qtd_fat   := SZF->ZF_QUANT
		ElseIf ldivide == .t.
			nqteant1 := SZF->ZF_QUANT
			nqteant2 := SZF->ZF_QTENF
			While !Reclock("SZF",.f.);EndDo
			SZF->ZF_QUANT := nqteant2
			SZF->ZF_QTENF := nqteant1
			MsUnlock()
			_qtd_fat   := SZF->ZF_QUANT
		EndIf
	Else
		If  SZF->ZF_UNID $ "SC,UN,SA"
			_qtd_fat   := SZF->ZF_QUANT
		Else
			_qtd_fat   := _peso_liq
			While !Reclock("SZF",.f.);EndDo
			SZF->ZF_QUANT := _peso_liq
			MsUnlock()
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz Ajuste no frete PARA UM = "TL"                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
	If SZF->ZF_UNID == "TL" .and. nvalf == 0 .and. SZF->ZF_FRETE == "C" .and. SA1->A1_YFRECLI == 0
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
		SZG->(DbSetOrder(1))
		SZG->(DbSeek(xFilial("SZG")+SZF->ZF_UFE+SZF->ZF_MUNE+SZF->ZF_FORNECE+SZF->ZF_LOJAF + "L"))
		SZ3->(DbSetOrder(1))
		SZ3->(DbSeek(xFilial("SZ3")+SZF->ZF_MOTOR))
		While !Reclock("SZF",.f.);EndDo
		If SZ3->Z3_TIPO == "2"
			SZF->ZF_FMOT := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZG->ZG_VALOR,2))
		Else
			SZF->ZF_FTRA := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZG->ZG_VALOR,2))
		EndIf
		MsUnlock()
	EndIf
	
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
	If SZF->ZF_UNID == "SA" .and. SZF->ZF_FRETE == "C"
		SZG->(DbSetOrder(1))
		SZG->(DbSeek(xFilial("SZG")+SZF->ZF_UFE+SZF->ZF_MUNE+SZF->ZF_FORNECE+SZF->ZF_LOJAF + "L"))
		nSal2UM := IF(SB1->B1_TIPCONV=="D",_qtd_fat/SB1->B1_CONV,_qtd_fat/SB1->B1_CONV)
		If Reclock("SZF" ,.f.)
			SZF->ZF_FTRA := Round(nSal2UM * SZG->ZG_VALOR,2)
			MsUnlock()
		EndIf
		
		If SZ3->Z3_TIPO == "2"
			SZF->ZF_FMOT := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZ4->Z4_FMOT,2))
			SZF->ZF_FTRA := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZ4->Z4_FRETE,2))
		Else
			SZF->ZF_FMOT := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZG->ZG_FMOT,2))
			SZF->ZF_FTRA := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZG->ZG_FRETE,2))
		EndIf
	EndIf
	
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))
	If SB1->B1_YTRBIG > 0 .and. SZF->ZF_FRETE == "C" .and. SA1->A1_YFRECLI == 0
		SZ3->(DbSetOrder(1))
		SZ3->(DbSeek(xFilial("SZ3")+SZF->ZF_MOTOR))
		SZ4->(DbSetOrder(1))
		SZ4->(DbSeek(xFilial("SZ4")+SZF->ZF_UFE+SZF->ZF_MUNE))
		While !Reclock("SZF",.f.);EndDo
		If SZ3->Z3_AGREGA == "S"
			SZF->ZF_FTRA := Round(_qtd_fat * SZ4->Z4_FAGRTRA * SB1->B1_YTRBIG,2)
			SZF->ZF_FMOT := Round(_qtd_fat * SZ4->Z4_FAGRMOT  * SB1->B1_YTRBIG,2)
		Else
			SZF->ZF_FTRA := Round(_qtd_fat * SZ4->Z4_FRETE * SB1->B1_YTRBIG,2)
			SZF->ZF_FMOT := Round(_qtd_fat * SZ4->Z4_FMOT  * SB1->B1_YTRBIG,2)
		EndIf
		MsUnlock()
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificar EXCECAO de Frete                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SZJ->(DbSetOrder(1))
	lachou:=SZJ->(DbSeek(xFilial("SZJ")+SZF->ZF_NUM))
	If lachou
		While !Reclock("SZF",.f.);EndDo
		SZF->ZF_FTRA := SZJ->ZJ_FTRA
		SZF->ZF_FMOT := SZJ->ZJ_FMOT
		MsUnlock()
	EndIf
	_tes   := SZF->ZF_TES
	_reg   := Recno()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza SZF - Pedidos                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	// <06>
	Val_nf()
	
	dbSelectArea("SZF")
	Reclock ("SZF",.F.)
	SZF->ZF_PSSAI    := _peso_liqcalc //_peso_liq - Solicitado por Marciane em 01/11/04
	
	If ldivide == .F.
		SZF->ZF_NUMNF    := _nf
	Else
		SZF->ZF_NUMNF2   := _nf
	EndIf
	_DtLib           := SZF->ZF_YDTLIB
	SZF->ZF_SERIE    := _serie
	SZF->ZF_DTSAIDA  := _DtSaida
	SZF->ZF_HORSAI   := _hora
	if laltlacre
		SZF->ZF_LACRE    := _lacre
	endif
	SZF->ZF_PREFIXO  := _prefixo
	msUnlock()
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SZF->ZF_PRODUTO)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acessa SB2 - Saldos Fisico e Financeiro                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial("SB2")+SZF->ZF_PRODUTO+SB1->B1_LOCPAD)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acessa SF4 - TES                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4")+_tes)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acessa SA1 - Cadastro de Clientes                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acessa SF7 - Excecoes Fiscais                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF7")
	dbSetOrder(2)
	If dbSeek(xFilial("SF7")+PADR(SA1->A1_GRPTRIB,6)+SA1->A1_EST,.F.)//dbSeek(xFilial("SF7")+SA1->A1_GRPTRIB+"00101",.F.)
		wAliqIcm := F7_ALIQEXT
	Else
		wAliqIcm := 0
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificar aliquota na excecao quando digitado no pedido - 24/07/01       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SZF->ZF_GRTR)
		dbSelectArea("SF7")
		dbSetOrder(2)
		If dbSeek(xFilial("SF7")+PADR(SZF->ZF_GRTR,6)+SA1->A1_EST,.F.)
			wAliqIcm := F7_ALIQEXT
		Else
			wAliqIcm := 0
		EndIf
	Endif
	
	DA3->(dbSetOrder(3))
	DA3->(dbSeek(xFilial("DA3")+SZF->ZF_PLACA))
	/*
	_picm     := AliqIcms("N",;  // Tipo de Operacao
	"S",;  // Tipo de Nota ('E'ntrada/'S'aida)
	"C" ;  // Tipo do Cliente ou Fornecedor
	)
	//<03>-FIM
	_estado   := alltrim(getmv("MV_ESTADO"))
	_piss     := getmv("MV_ALIQISS")
	*/
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))
	
	If Alltrim(SB1->B1_TIPCAR) == "S"
		_nQtde   := (SZF->ZF_QUANT * SB1->B1_CONV) / 1000
		_nQtdeNf := (SZF->ZF_QTENF * SB1->B1_CONV) / 1000
	Else
		_nQtde   := SZF->ZF_QUANT
		_nQtdenF := SZF->ZF_QTENF
	Endif
	/*
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+SZF->ZF_MOTOR))
	If _nQtdenF >0 .and. SB1->B1_YTRBIG==0 .and. SZF->ZF_UNID $ "SC"
	_vlfre    := Iif(SZ3->Z3_TIPO=="2",(SZF->ZF_FMOT * _nQtde)/(_nQtde + _nQtdenF),(SZF->ZF_FTRA * _nQtde)/(_nQtde + _nQtdenF))
	Else
	_vlfre    := Iif(SZ3->Z3_TIPO=="2",SZF->ZF_FMOT,SZF->ZF_FTRA)
	EndIf
	*/
	
	_aest     := SA1->A1_EST
	_GrpTrib  := SA1->A1_GRPTRIB
	_amun     := alltrim(SA1->A1_MUN)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Excecao de preco                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	SZM->(DbSetOrder(1))
	lachou := SZM->(DbSeek(xFilial("SZM")+SZF->ZF_NUM))
	If lachou
	While !Reclock("SZF",.F.)
	SZF->ZF_PCOREF := SZM->ZM_VALOR
	MsUnlock()
	EndDo
	EndIf
	*/
	_prcven := SZF->ZF_PCOREF
	_opcao  := "2"
	_prfim  := SZF->ZF_PCOREF
	
	_f4redicm := SF4->F4_BASEICM
	_f4ipi    := SF4->F4_IPI
	_ipi      := SB1->B1_IPI
	_f4ipifr  := SF4->F4_IPIFRET
	
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))
	
	//If Alltrim(SB1->B1_TIPCAR) == "S"
	//	_nQtde   := (SZF->ZF_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
	//	_nQtdeNf := (SZF->ZF_QTENF * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
	//Else												  //// ALTERADO 11/01/12
	_nQtde   := SZF->ZF_QUANT
	_nQtdenF := SZF->ZF_QTENF
	//Endif
	
	/*
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+SZF->ZF_MOTOR))
	If SB1->B1_YTRBIG==0 .and. SZF->ZF_UNID $ "SC,SA"
	_baseipiF := Iif(SZ3->Z3_TIPO=="2",(SZF->ZF_FMOT * _nQtde)/(_nQtde + _nQtdenF),(SZF->ZF_FTRA * _nQtde)/(_nQtde + _nQtdenF))
	Else
	_baseipiF := Iif(SZ3->Z3_TIPO=="2",(SZF->ZF_FMOT * _nQtde)/(_nQtde + _nQtdenF),(SZF->ZF_FTRA * _nQtde)/(_nQtde + _nQtdenF))
	EndIf
	_f4incide := SF4->F4_INCIDE
	_f4icm    := SF4->F4_ICM
	_a1tipo   := SA1->A1_TIPO
	
	
	
	If cEmpAnt == "30"
	If SA1->A1_EST <> SM0->M0_ESTCOB .And. SB1->B1_YMVAICM > 0
	_b1PicRet := SB1->B1_YMVAICM / 100   //0.2723 // ALTERADO POR ALEXANDRO
	Else
	_b1PicRet := SB1->B1_PICMRET
	Endif
	Else
	_b1PicRet := SB1->B1_PICMRET
	Endif
	
	_qtde     := _qtd_fat
	aVetor   := {_opcao      ,;
	_estado     ,;
	_piss       ,;
	_picm       ,;
	_vlfre      ,;
	_aest       ,;
	_amun       ,;
	_prcven     ,;
	_f4ipi      ,;
	_ipi        ,;
	_f4ipifr    ,;
	_baseipiF   ,;
	_f4incide   ,;
	_f4icm      ,;
	_a1tipo     ,;
	_b1PicRet   ,;
	_qtde       ,;
	_prfim      ,;
	SZF->ZF_UNID,;
	wAliqIcm    ,;
	_f4redicm    }
	
	aVetor   := U_MIZ300(aVetor)
	
	If  aVetor[1]  < 0 .or. aVetor[2]  < 0  .or. aVetor[3]  < 0  .or. aVetor[4]  < 0  .or.;
	aVetor[5]  < 0 .or. aVetor[6]  < 0  .or. aVetor[7]  < 0  .or. aVetor[8]  < 0  .or.;
	aVetor[9]  < 0 .or. aVetor[10] < 0  .or. aVetor[11] < 0  .or. aVetor[12] < 0
	
	MsgBox("Atencao, Nao é Permitido Faturar NF com algum dos valores Negativo. Favor Verificar.","Campo com Valor Negativo","STOP")
	ROLLBACK TRANSACTION
	Return
	Else
	dbCommit()
	EndIf
	
	_prcven  := aVetor[1]
	_valipi  := aVetor[2]
	_valicm  := aVetor[3]
	_picm    := aVetor[4]
	_baseicm := aVetor[5]
	_icmsret := IIf( aVetor[6] < 0, 0, aVetor[6] )
	_valipiF := aVetor[7]
	_icmfret := aVetor[8]
	_bicmfre := aVetor[9]
	_baseipi := aVetor[10]
	_baseipiF:= aVetor[11]
	_bricms  := aVetor[12]
	_baseiss := aVetor[13]
	_valiss  := aVetor[14]
	_picmret := aVetor[15]
	_picmest := aVetor[16]
	*/
	_total   := _qtd_fat * _prcven
	
	PXH05502()
	
	dbSelectArea("SD2")
	Reclock ("SD2",.T.)
	SD2->D2_FILIAL  := xFilial("SD2")
	SD2->D2_COD     := SZF->ZF_PRODUTO
	SD2->D2_UM      := SB1->B1_UM
	SD2->D2_SEGUM   := SB1->B1_SEGUM
	SD2->D2_QUANT   := _qtd_fat
	If SB1->B1_YVEND <> "N"
		nqtven += SD2->D2_QUANT
		cprven := SD2->D2_COD
	EndIf
	SD2->D2_PRCVEN  := _prcven
	SD2->D2_TOTAL   := _total
	SD2->D2_IPI     := _ipi
	SD2->D2_VALIPI  := _valipi + _valipiF    //Alterado em 10/11/00 por Nilton ->Se tirar o sistema nao soma o ipi do frete ao valor total do IPI
	
	If SF4->F4_ICM == "S"
		SZ3->(DbSetOrder(1))
		lachou := SZ3->(DbSeek(xFilial("SZ3")+SZF->ZF_MOTOR))
		If lachou
			If (cfilant =="01".and.Upper(Alltrim(SZF->ZF_MUNE))=="VITORIA".and.Upper(Alltrim(SZF->ZF_UFE))=="ES") .or. ;
				(cfilant$"02" .and.Upper(Alltrim(SZF->ZF_MUNE))=="ITABORAI".and.Upper(Alltrim(SZF->ZF_UFE))=="RJ") .or. ;
				(cfilant=="03".and.Upper(Alltrim(SZF->ZF_MUNE))=="GOVERNADOR VALADARES".and.Upper(Alltrim(SZF->ZF_UFE))=="MG") .or. ;
				(cfilant=="04".and.Upper(Alltrim(SZF->ZF_MUNE))=="SAO PEDRO DA ALDEIA".and.Upper(Alltrim(SZF->ZF_UFE))=="RJ") .or. ;
				(cfilant=="05".and.Upper(Alltrim(SZF->ZF_MUNE))=="CAMPOS".and.Upper(Alltrim(SZF->ZF_UFE))=="RJ") .OR. ;
				(cfilant=="06".and.Upper(Alltrim(SZF->ZF_MUNE))=="ITABUNA".and.Upper(Alltrim(SZF->ZF_UFE))=="BA") .OR. ;
				(cfilant=="08".and.Upper(Alltrim(SZF->ZF_MUNE))=="LINHARES".and.Upper(Alltrim(SZF->ZF_UFE))=="ES") .OR. ;
				(cfilant=="21".and.Upper(Alltrim(SZF->ZF_MUNE))=="RIO DE JANEIRO".and.Upper(Alltrim(SZF->ZF_UFE))=="RJ") .or.;
				(cfilant=="01".and.Upper(Alltrim(SZF->ZF_MUNE))=="RIO DE JANEIRO".and.Upper(Alltrim(SZF->ZF_UFE))=="RJ")
				If SZ3->Z3_AGREGA=="S" .and. SZ3->Z3_TIPO=="2"
					_icmfret := 0
					_bicmfre := 0
				EndIf
			ElseIf Upper(Alltrim(SZF->ZF_UFE)) == Upper(Alltrim(SM0->M0_ESTCOB)) .and. SZ3->Z3_AGREGA=="S" .and. SZ3->Z3_TIPO=="2"
				_icmfret := Round(_bicmfre * 12 /100,2)
				_bicmfre := 0
			EndIf
		EndIf
		SD2->D2_VALICM  := _valicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03" .and. SA1->A1_YFICMS <> "S",_icmfret,0)  //Alterado em 02/12/02 por Nilton - Solicitacao Marciane
		SD2->D2_BASEICM := _baseicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03".and. SA1->A1_YFICMS <> "S",_bicmfre,0) //Alterado em 02/21/02 por Nilton - Solicitacao Marciane
	Else
		SD2->D2_VALICM  := _valicm
		SD2->D2_BASEICM := _baseicm
	EndIf
	If SZ3->Z3_TIPO == "2" .and. _icmsret > 0  .and. cfilant <> "03" //Valor do ICMS do frete no calculo do ICMS Substituto
		_icmsret := round(_bricms * (_picmret/100),2) - _valicm - _icmfret
	EndIf
	SD2->D2_TES     := _tes
	If SA1->A1_EST == _estado
		If SF4->F4_CF = "6107"
			SD2->D2_CF  := "5101"
		ElseIf SF4->F4_CF = "6108"
			SD2->D2_CF  := "5102"
		Else
			SD2->D2_CF  := "5" + subs(SF4->F4_CF,2,3)
		Endif
	ElseIf  SA1->A1_EST == "EX"
		SD2->D2_CF  := "7" + subs(SF4->F4_CF,2,3)
	Else
		SD2->D2_CF  := "6" + subs(SF4->F4_CF,2,3)
	Endif
	
	SD2->D2_DESC    := 0
	SD2->D2_PICM    := _picm
	SD2->D2_PESO    := _peso_liq
	SD2->D2_CONTA   := SB1->B1_CONTA
	SD2->D2_OP      := space(1)
	SD2->D2_PEDIDO  := SZF->ZF_NUM
	SD2->D2_ITEMPV  := "01"
	SD2->D2_CLIENTE := SZF->ZF_CLIENTE
	SD2->D2_LOJA    := SZF->ZF_LOJA
	SD2->D2_LOCAL   := SB1->B1_LOCPAD
	SD2->D2_DOC     := _nf
	SD2->D2_EMISSAO := ddatabase
	SD2->D2_DTDIGIT := ddatabase
	SD2->D2_GRUPO   := SB1->B1_GRUPO
	SD2->D2_TP      := SB1->B1_TIPO
	SD2->D2_SERIE   := _serie
	SD2->D2_CUSTO1  := _qtd_fat * SB2->B2_CM1
	SD2->D2_PRUNIT  := _prcven
	SD2->D2_QTSEGUM := _qtd_fat * SB1->B1_CONV
	SD2->D2_NUMSEQ  := ProxNum() //strzero(_numseq,6)
	SD2->D2_EST     := SA1->A1_EST
	SD2->D2_DESCON  := 0
	SD2->D2_TIPO    := "N"
	SD2->D2_ITEM    := "01"
	SD2->D2_COMIS1  := 0          // % DE COMISSAO DO VENDEDOR - DEFINIR REGRA
	
	If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
		_nQtde   := (SZF->ZF_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
		_nQtdeNf := (SZF->ZF_QTENF * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
	Else												  //// ALTERADO 11/01/12
		_nQtde   := SZF->ZF_QUANT 						  //// ALTERADO 11/01/12
		_nQtdenF := SZF->ZF_QTENF 						  //// ALTERADO 11/01/12
	Endif												  //// ALTERADO 11/01/12
	
	If _nQtdenF > 0 .and. SB1->B1_YTRBIG==0 .and. SZF->ZF_UNID $ "SC"
		SD2->D2_VALFRE := Iif(SZ3->Z3_TIPO=="2",(SZF->ZF_FMOT * _nQtde)/(_nQtde + _nQtdenF),(SZF->ZF_FTRA * _nQtde)/(_nQtde + _nQtdenF))
	Else
		SD2->D2_VALFRE := Iif(SZ3->Z3_TIPO=="2",SZF->ZF_FMOT,SZF->ZF_FTRA)
	EndIf
	SD2->D2_BASEIPI := _baseipi + _baseipiF
	
	ZZA->(DbSetOrder(1))
	ZZA->(DbSeek(xFilial("ZZA")+"11             "))
	SD2->D2_YCUSTRA := Val(ZZA->ZZA_CONTEU)
	ZZA->(DbSetOrder(1))
	ZZA->(DbSeek(xFilial("ZZA")+"10             "))
	SD2->D2_YCSTSAC := Val(ZZA->ZZA_CONTEU)
	
	If _icmsret == 0 .and. SA1->A1_YDIFALI == "S" .and. Alltrim(SA1->A1_ATIVIDA) $ "36"
		_bricms  := (_baseicm + Iif(SZ3->Z3_TIPO=="2",0,0))+SD2->D2_VALFRE
		_icmsret := Round(_bricms*(_picmest - (_picm/100)),2)
	EndIf
	
	SD2->D2_ICMSRET := _icmsret
	SD2->D2_BRICMS  := _bricms
	
	_nPreco := 0
	ZA2->(dbSetOrder(3))
	If ZA2->(dbSeek(xFilial("ZA2")+SZF->ZF_CLIENTE + SZF->ZF_LOJA  + SZF->ZF_OBRA + SZF->ZF_PRODUTO+"L"))
		_nPreco := ZA2->ZA2_PRCGER
	Endif
	
	If _nPreco = 0
		dbSelectArea("SZI")
		SZI->(dbSetOrder(1))
		If SZI->(dbSeek(xFilial("SZI")+SZF->ZF_CLIENTE+SZF->ZF_LOJA+SZF->ZF_PRODUTO+"L")) .AND. !EMPTY(SZI->ZI_PRCUNIT)
			_nPreco :=  SZI->ZI_PGER
		EndIf
	Endif
	
	SD2->D2_YPRG := _nPreco
	
	SB1->(DbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))
	SD2->D2_YCUSTO  := SB2->B2_YCUSTO
	SD2->D2_ROTINA  := AllTrim(Funname())
	SD2->D2_CLASFIS := SB1->B1_ORIGEM+SF4->F4_SITTRIB
	msUnlock()
	dbCommit()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava SF2 - Cabecalho da NF Saida                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _nQtdeNf >0 .and. SB1->B1_YTRBIG==0 .and. SZF->ZF_UNID $ "SC,SA"
		_valtot := _total +  _icmsret + _valipi + _valipiF + Iif(SZ3->Z3_TIPO=="2",(SZF->ZF_FMOT * _nQtde)/(_nQtde + _nQtdeNf),(SZF->ZF_FTRA * _nQtde)/(_nQtde + _nQtdeNf))
	Else
		_valtot := _total +  _icmsret + _valipi + _valipiF + Iif(SZ3->Z3_TIPO=="2",SZF->ZF_FMOT,SZF->ZF_FTRA)
	EndIf
	If SF4->F4_ICM == "N"
		_icmfret   := 0
		_bicmfre   := 0
	EndIf
	
	dbSelectArea("SF2")
	
	Reclock("SF2",.T.)
	SF2->F2_FILIAL  := xFilial("SF2")
	SF2->F2_DOC     := _nf
	
	aadd(aNotas, _nf )
	
	SF2->F2_SERIE   := _serie
	SF2->F2_PREFIXO := _prefixo
	SF2->F2_CLIENTE := SZF->ZF_CLIENTE
	SF2->F2_LOJA    := SZF->ZF_LOJA
	SF2->F2_COND    := SZF->ZF_COND
	SF2->F2_DUPL    := _nf
	SF2->F2_EMISSAO := ddatabase
	SF2->F2_EST     := SA1->A1_EST
	cDoc            := SF2->F2_DOC
	cSerie          := SF2->F2_SERIE
	cCliente        := SF2->F2_CLIENTE
	cLoja           := SF2->F2_LOJA
	
	If _nQtdeNf > 0 .and. SB1->B1_YTRBIG==0 .and. SZF->ZF_UNID $ "SC"
		SF2->F2_FRETE   := Iif(SZ3->Z3_TIPO=="2",(SZF->ZF_FMOT * _nQtde)/(_nQtde + _nQtdeNf),(SZF->ZF_FTRA * _nQtde)/(_nQtde + _nQtdeNf))
		SF2->F2_FRFIXO  := SF2->F2_FRETE
	Else
		SF2->F2_FRETE   := Iif(SZ3->Z3_TIPO=="2",SZF->ZF_FMOT,SZF->ZF_FTRA)
		SF2->F2_FRFIXO  := POSICIONE('SZG',1,xFilial("SZG")+SZF->ZF_UFE+SZF->ZF_MUNE+SZF->ZF_FORNECE+SZF->ZF_LOJAF,"ZG_FRFIXO")
		If Empty(SF2->F2_FRFIXO)
			SF2->F2_FRFIXO  := POSICIONE('SZG',1,xFilial("SZG")+SZF->ZF_UFE+SZF->ZF_MUNE+SZF->ZF_FORNECE+SZF->ZF_LOJAF,"ZG_VALOR")
		Endif
	EndIf
	SF2->F2_ICMFRET := _icmfret
	SF2->F2_TIPOCLI := SA1->A1_TIPO
	SF2->F2_VALBRUT := _valtot
	SF2->F2_VALICM  := _valicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03".and. SA1->A1_YFICMS <> "S",_icmfret,0)
	SF2->F2_BASEICM := _baseicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03".and. SA1->A1_YFICMS <> "S",_bicmfre,0)
	SF2->F2_VALIPI  := _valipi + _valipiF
	SF2->F2_BASEIPI := _baseipi + _baseipiF
	SF2->F2_VALMERC := _total
	SF2->F2_TIPO    := "N"
	SF2->F2_ICMSRET := _icmsret
	SF2->F2_PLIQUI  := Iif(SB1->B1_UM $ "SC,SA",Round(_qtd_fat/(1000/SB1->B1_CONV),4),_qtd_fat)
	SF2->F2_PBRUTO  := SF2->F2_PLIQUI
	If ! Empty(SZF->ZF_FORNECE)
		SF2->F2_TRANSP  := SZF->ZF_FORNECE
	Else
		SF2->F2_TRANSP  := SZ2->Z2_TRAN
	EndIf
	SF2->F2_VEND1   := SZF->ZF_VEND
	SF2->F2_BASEISS := _baseiss
	SF2->F2_VALISS  := _valiss
	SF2->F2_VALFAT  := _valtot
	SF2->F2_BRICMS  := _bricms
	SF2->F2_ESPECIE := A460Especie(_Serie)
	SF2->F2_YMOTOR  := SZF->ZF_MOTOR
	SZ4->(DbSetOrder(1))
	SZ4->(DbSeek(xFilial("SZ4")+SZF->ZF_UFE+SZF->ZF_MUNE))
	SF2->F2_YDIST   := SZ4->Z4_DIST
	SF2->F2_YFRETE  := SZF->ZF_FRETE
	SF2->F2_YOC     := SZF->ZF_OC
	SF2->F2_YMUNE   := SZF->ZF_MUNE
	SF2->F2_YUFE    := SZF->ZF_UFE
	SF2->F2_YPLACA	:= SZF->ZF_PLACA
	SF2->F2_YPLCAR  := SZF->ZF_PLCAR
	SF2->F2_HORA    := left(time(),5)
	SF2->F2_ROTINA  := AllTrim(Funname())
	msUnlock()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizar SZF                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SZF")
	While !Reclock("SZF",.f.);EndDo
	SZF->ZF_PSSAI   := _peso_sai
	if cEmpAnt == "30"
		if SZF->ZF_STATUS2 = "8" // rodrigo
			SZF->ZF_STATUS2 := "9"
		else
			SZF->ZF_FATUR   := "S"
		endif
	else
		SZF->ZF_FATUR := "S"
	endif
	SZF->ZF_DTSAIDA := ddatabase
	SZF->ZF_YPALT   := ypalt
	SZF->ZF_HSAIDA  := left(time(),5)
	SZF->ZF_PRODUTO := cprven
	SZF->ZF_QUANT   := nqtven
	SZF->ZF_YDTLIB  := _DtLib
	SZF->ZF_PAGER   := ''
	SZF->ZF_COLESAI := cColeta
	if laltlacre
		SZF->ZF_LACRE    := _lacre
	endif
	
	MsUnlock()
	
	dbSelectArea("SF2")
	Reclock("SF2",.F.)
	SF2->F2_YPEDAG	:=  Round(wPedag * SF2->F2_PBRUTO,2) //Pedágio por Tonelada
	MsUnlock()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravar PIS/COFINS 17/06/04 no SD2                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nbasecof := SF2->F2_VALBRUT - SF2->F2_VALIPI - SF2->F2_ICMSRET
	SF4->(DbSetOrder(1))
	SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))
	SED->(DbSetOrder(1))
	SED->(DbSeek(xFilial("SED")+SA1->A1_NATUREZ))
	If Reclock("SD2",.f.)
		_nTxPIS	:= 	If (SB1->B1_PPIS    <> 0,SB1->B1_PPIS    ,SuperGetMV("MV_TXPIS"))
		_nTxCOF	:=	If (SB1->B1_PCOFINS <> 0,SB1->B1_PCOFINS ,SuperGetMV("MV_TXCOFIN"))
		If SF4->F4_PISCOF == "1"
			//SD2->D2_VALIMP6 := Round(nbasecof * SED->ED_PERCPIS/100,2)
			SD2->D2_VALIMP6 := Round(nbasecof * _nTxPIS/100,2)
		ElseIf SF4->F4_PISCOF == "2"
			//SD2->D2_VALIMP5 := Round(nbasecof * SED->ED_PERCCOF/100,2)
			SD2->D2_VALIMP5 := Round(nbasecof * _nTxCOF/100,2)
		ElseIf SF4->F4_PISCOF == "3"
			//SD2->D2_VALIMP6 := Round(nbasecof * SED->ED_PERCPIS/100,2)
			//SD2->D2_VALIMP5 := Round(nbasecof * SED->ED_PERCCOF/100,2)
			SD2->D2_VALIMP6 := Round(nbasecof * _nTxPIS/100,2)
			SD2->D2_VALIMP5 := Round(nbasecof * _nTxCOF/100,2)
		End
		
		//Gravar Valor Bruto do SD2 - fernando - 06/11/08
		SD2->D2_VALBRUT := _valtot
		
	EndIf
	msUnlock()
	dbCommit()
	
	dbSelectArea("SF2")
	
	//MSGINFO("NONA PARADA MIZ035 OK!!")
	CTIPO := "SF2"
	
	//alterado por sergio - antes, causava erro na funcao  fPesqSA1() - 18/12/12
	DbSelectArea("SA1")
	aArea := GetArea()
	DbSetOrder(1)
	If DbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA)
		
		// ALTERADO EM 07/01/13
		//U_MIZF100(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,CTIPO)
		// ALTERADO EM 07/01/13
	endif
	
	//MSGINFO("DECIMA PRIMEIRA PARADA MIZ035 OK !!")
	dbCommit()
	
	//GERA REGISTRO LIVRO FISCAL - SF3 - SFT e CD2  - Fernando Rocha - 15/07/08 - SPED
	aAreaSP := GetArea()
	aOtimizacao := {}
	cAliasSP := "SF2"
	cCNAE := ""
	MaFisIniNF(2,SF2->(RecNo()),@aOtimizacao,cAliasSP,((cAliasSP)->F2_FIMP<>"S"))
	MaFisWrite()
	MaFisAtuSF3(1,"S",SF2->(RecNo()),"","",cCNAE)
	RestArea(aAreaSP)
	dbSelectArea("SF2")
	//FIM GERAR LIVRO FISCAL
	
	//MSGINFO("DECIMA SEGUNDA PARADA MIZ035 OK !!")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza livro fiscal da filial Rio e GV para notas de transferencia     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Alltrim(SD2->D2_TES) $ GetMV('MV_TESTRAN') .And. ! Empty(SA1->A1_YFILMIZ) // Alteracao efetuada solicitacao Sr. Ernandes em 0208/05
		
		///######################################
		/// GERA O FISCAL NA FILIAL DESTINO
		///######################################
		
		
		/*		DbSelectArea("SF3")
		//		RecLock("SF3",.T.)
		//		SF3->F3_FILIAL	:= SA1->A1_YFILMIZ  //Iif(SF2->F2_CLIENTE == "001456","02","03")
		//		SF3->F3_REPROC	:= "N"
		//		SF3->F3_ENTRADA  := SF2->F2_EMISSAO + 1
		//		SF3->F3_NFISCAL	:= SF2->F2_DOC
		//		SF3->F3_SERIE 	:= SF2->F2_SERIE
		//		SF3->F3_CLIEFOR	:= SF2->F2_CLIENTE
		//		SF3->F3_LOJA		:= SF2->F2_LOJA
		//		SF3->F3_CFO		:= IIF(SD2->D2_TES=="621","2152","2152")
		//		SF3->F3_ESTADO	:= SF2->F2_EST
		//		SF3->F3_EMISSAO	:= SF2->F2_EMISSAO
		//		SF3->F3_ALIQICM	:= 12.00
		//		SF3->F3_VALCONT	:= SF2->F2_VALBRUT
		//		SF3->F3_BASEICM	:= SF2->F2_BASEICM
		//		SF3->F3_VALICM	:= SF2->F2_VALICM
		//		SF3->F3_ISENICM	:= IIF(SD2->D2_TES=="222",SF2->F2_VALBRUT,0)
		//		SF3->F3_OUTRICM	:= 0.00
		//		SF3->F3_BASEIPI	:= SF2->F2_BASEIPI
		//		SF3->F3_VALIPI	:= SF2->F2_VALIPI
		//		SF3->F3_ISENIPI	:= IIF(SD2->D2_TES=="222",SF2->F2_VALBRUT,0)
		//		SF3->F3_OUTRIPI  := 0.00
		//		SF3->F3_ESPECIE  := "NF"
		//		MsUnLock()
		*/
		
		//###############################################################################
		//GERA AS NOTAS DE TRANSFERENCIA PARA OS DEPOSITOS DE FORMA AUTOMATICA
		// bloqueado por sergio em 08.07.2010
		//Execblock("MIZF15",.F.,.F.,{'TRANSFILIAL','INCLUSAO'})
		//###############################  F I M ########################################
		//###############################  F I M ########################################
	Endif
	If SF4->F4_DUPLIC == "S"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula parcelas pela condicao de pagamento                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_aParc    := Array(9,2)
		_aParc    := {"A","B","C","D","E","F","G","H","I"}
		_aParcela := Condicao(_valtot,SZF->ZF_COND,0,ddatabase)
		_nParcela := len(_aParcela)
		_Taxa_Per := getmv("MV_TXPER")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava SE1 - Contas a Receber                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  _nParcela > 1
			_aParc[1] := "A"
		Else
			_aParc[1] := " "
		End
		dbSelectArea("SE1")
		For i := 1 to _nParcela
			Reclock("SE1",.T.)
			SE1->E1_FILIAL  := xFilial("SE1")
			SE1->E1_FILORIG := SZF->ZF_FILIAL
			SE1->E1_PREFIXO := _prefixo
			SE1->E1_NUM     := _nf
			SE1->E1_PARCELA := _aParc[i]
			SE1->E1_TIPO    := "NF"
			SE1->E1_NATUREZ := SA1->A1_NATUREZ
			SE1->E1_CLIENTE := SA1->A1_COD
			SE1->E1_LOJA    := SA1->A1_LOJA
			SE1->E1_NOMCLI  := SA1->A1_NREDUZ
			SE1->E1_EMISSAO := ddatabase
			If SZF->ZF_COND == "050"
				SE1->E1_VENCTO  := Iif(!Empty(SA1->A1_YVENC) .and. SA1->A1_YVENC > ddatabase,SA1->A1_YVENC,_aParcela[i,1])
				SE1->E1_VENCREA := DataValida(SE1->E1_VENCTO,.T.)
				wVencto         := SE1->E1_VENCREA
			Else
				SE1->E1_VENCTO  := _aParcela[i,1]
				SE1->E1_VENCREA := DataValida(_aParcela[i,1],.T.)
				wVencto         := SE1->E1_VENCREA
			EndIf
			SE1->E1_VALOR   := _aParcela[i,2]
			SE1->E1_EMIS1   := ddatabase
			SE1->E1_SALDO   := _aParcela[i,2]
			SE1->E1_VEND1   := SZF->ZF_VEND
			SE1->E1_COMIS1  := 0
			SE1->E1_VENCORI := _aParcela[i,1]
			SE1->E1_VALJUR  := round(_aParcela[i,2] * (_Taxa_Per / 100),2)
			SE1->E1_PORCJUR := _Taxa_Per
			SE1->E1_MOEDA   := 1
			SE1->E1_BASCOM1 := 0
			SE1->E1_VALCOM1 := 0
			SE1->E1_OCORREN := "01"
			SE1->E1_PEDIDO  := SZF->ZF_NUM
			SE1->E1_VLCRUZ  := _aParcela[i,2]
			SE1->E1_STATUS  := "A"
			SE1->E1_ORIGEM  := "MIZ035"
			SE1->E1_SITUACA := "0"
			SE1->E1_PORTADO := IIF(!EMPTY(SA1->A1_BCO1),SA1->A1_BCO1,GETMV("MV_YBCOPAD"))
			IF SE1->E1_VENCTO > dDataBase+1
				SE1->E1_NUMBCO:= u_NossoNumero( SE1->E1_PORTADO )
			ENDIF
			
			MsUnLock()
			
			//ZA6->(dbSetOrder(1))
			//If ZA6->(dbSeek(xFilial("ZA6") + SA1->A1_COD + SA1->A1_LOJA + "L"))
			//	ZA6->(RecLock("ZA6",.F.))
			//	ZA6->ZA6_SDOTIT += SE1->E1_VALOR
			//	ZA6->(MsUnlock())
			//Endif
		Next
		dbCommit()
	Endif
	If SF4->F4_ESTOQUE == "S"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza SB2 - Saldos Fisico e Financeiro                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB2")
		dbSetOrder(1)
		If  dbSeek(xFilial("SB2") + SZF->ZF_PRODUTO + SB1->B1_LOCPAD)
			While ! Reclock("SB2",.F.) ; End
			SB2->B2_QATU  := SB2->B2_QATU - _qtd_fat
			SB2->B2_VATU1 := SB2->B2_CM1  * SB2->B2_QATU
			msUnLock()
			dbCommit()
		End
	Endif
	
	//MSGINFO("DECIMA TERCEIRA PARADA MIZ035 !!")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza historico do Cliente                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA1")
	While ! RecLock("SA1",.F.) ; End
	SA1->A1_SALDUP := SA1->A1_SALDUP + _valtot
	If  _total > SA1->A1_MCOMPRA
		SA1->A1_MCOMPRA := _Total
	End
	If  _valtot > SA1->A1_MAIDUPL
		SA1->A1_MAIDUPL := _valtot
	End
	SA1->A1_NROCOM := SA1->A1_NROCOM + 1
	If  empty(SA1->A1_PRICOM)
		SA1->A1_PRICOM := ddatabase
	End
	SA1->A1_ULTCOM := ddatabase
	If  year(ddatabase) <> year(SA1->A1_ULTCOM)
		SA1->A1_VACUM := _total
	Else
		SA1->A1_VACUM := SA1->A1_VACUM + _total
	End
	msUnLock()
	dbCommit()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza SX5 - Arquivo de Tabelas - Ajusta o numero da Nota Fiscal       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	If .NOT. dbSeek(xFilial("SX5")+"01"+StrTran(PadR(getmv("MV_YSERIE"),3," "),"*"," "))
		help("Numero NF",1,"Y_MIZ035/"+"01"+StrTran(PadR(getmv("MV_YSERIE"),3," "),"*"," "))
	ELSE
		_nf := PADR(StrZero(val(_nf)+1,6),9)
		Reclock("SX5",.F.)
		SX5->X5_DESCRI := PADR(StrZero(Val(_nf),6),9)
		SX5->(MsUnlock())
		SX5->(dbCommit())
	ENDIF
	
	aVetor := {_amun,_nf,Alltrim(SA1->A1_EST)}
	
	If SZF->ZF_TRGR == "S"
		execblock("MIZF15",.F.,.F.,aVetor)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Libera todas as areas p/ gravacao em disco                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbCommitAll()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Arquivo de Pedidos Faturados - "SZ7"                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ldivide == .F.
		_numnfaux := SZF->ZF_NUMNF
	Else
		_numnfaux := SZF->ZF_NUMNF2
	EndIf
	_serie    := SZF->ZF_SERIE
	If !Empty(_numnfaux)
		dbSelectArea("SZ7")
		DbSetOrder(1)
		If DbSeek(xFilial("SZ7")+SZF->ZF_NUM)
			RecLock("SZ7",.f.)
			SZ7->Z7_NUMNF2  := SZF->ZF_NUMNF2
			SZ7->Z7_QUANT   := SZF->ZF_QUANT + SZF->ZF_QTENF
			//dIÓGENES DAUSTER LOG ALTERAÇÃO
			SZ7->Z7_LGAUSER:=CUSERNAME
			If SB1->B1_UM == "TL" //.and. SB1->B1_YTRBIG > 0
			EndIf
		Else
			RecLock("SZ7",.T.)
			SZ7->Z7_FILIAL  := SZF->ZF_FILIAL
			SZ7->Z7_NUM     := SZF->ZF_NUM
			SZ7->Z7_CLIENTE := SZF->ZF_CLIENTE
			SZ7->Z7_NOMCLI  := SZF->ZF_NOMCLI
			SZ7->Z7_LOJA    := SZF->ZF_LOJA
			SZ7->Z7_PRODUTO := SZF->ZF_PRODUTO
			SZ7->Z7_QUANT   := SZF->ZF_QUANT
			SZ7->Z7_UNID    := SZF->ZF_UNID
			SZ7->Z7_PUNIT   := SZF->ZF_PUNIT
			SZ7->Z7_PCDESC  := SZF->ZF_PCDESC
			SZ7->Z7_VLDES   := SZF->ZF_VLDES
			SZ7->Z7_VLLISTA := SZF->ZF_VLLISTA
			SZ7->Z7_TES     := SZF->ZF_TES
			SZ7->Z7_DTENT   := SZF->ZF_DTENT
			SZ7->Z7_HORENTG := SZF->ZF_HORENTG
			SZ7->Z7_LOCAL   := SZF->ZF_LOCAL
			SZ7->Z7_FRETE   := SZF->ZF_FRETE
			SZ7->Z7_COND    := SZF->ZF_COND
			SZ7->Z7_VEND    := SZF->ZF_VEND
			SZ7->Z7_YTELVEN := SZF->ZF_YTELVEN
			SZ7->Z7_VLFRE   := SZF->ZF_VLFRE
			SZ7->Z7_PALENT  := SZF->ZF_PALENT
			SZ7->Z7_PALSAI  := SZF->ZF_PALSAI
			SZ7->Z7_OBSER   := SZF->ZF_OBSER
			SZ7->Z7_PSENT   := SZF->ZF_PSENT
			SZ7->Z7_PLACA   := SZF->ZF_PLACA
			SZ7->Z7_MOTOR   := SZF->ZF_MOTOR
			SZ7->Z7_PSSAI   := SZF->ZF_PSSAI
			SZ7->Z7_NUMNF   := SZF->ZF_NUMNF
			SZ7->Z7_SERIE   := SZF->ZF_SERIE
			SZ7->Z7_HORENT  := SZF->ZF_HORENT
			SZ7->Z7_HORSAI  := SZF->ZF_HORSAI
			SZ7->Z7_LIBER   := SZF->ZF_LIBER
			SZ7->Z7_LACRE   := SZF->ZF_LACRE
			SZ7->Z7_NMOT    := SZF->ZF_NMOT
			SZ7->Z7_EMISSAO := SZF->ZF_EMISSAO
			SZ7->Z7_RPA     := SZF->ZF_RPA
			SZ7->Z7_PCOREF  := SZF->ZF_PCOREF
			SZ7->Z7_HORAPED := SZF->ZF_HORAPED
			SZ7->Z7_TRGR    := SZF->ZF_TRGR
			SZ7->Z7_DTSAIDA := SZF->ZF_DTSAIDA
			SZ7->Z7_NLIB    := SZF->ZF_NLIB
			SZ7->Z7_HLIB    := SZF->ZF_HLIB
			SZ7->Z7_YDTLIB  := SZF->ZF_YDTLIB
			SZ7->Z7_USUARIO := SZF->ZF_USUARIO
			SZ7->Z7_GRTR    := SZF->ZF_GRTR
			SZ7->Z7_FTRA    := Iif(SZ3->Z3_TIPO=="2",SZF->ZF_FMOT,SZF->ZF_FTRA)
			SZ7->Z7_FMOT    := SZF->ZF_FMOT
			SZ7->Z7_FORNECE := SZF->ZF_FORNECE
			SZ7->Z7_LOJAF   := SZF->ZF_LOJAF
			//SZ7->Z7_YPM     := SZF->ZF_YPM
			SZ7->Z7_YPM     := SZF->ZF_PALLET
			SZ7->Z7_MUNE    := SZF->ZF_MUNE
			SZ7->Z7_UFE     := SZF->ZF_UFE
			SZ7->Z7_OC      := SZF->ZF_OC
			SZ7->Z7_FMOTX   := SZF->ZF_FMOTX
			SZ7->Z7_FTRAX   := SZF->ZF_FTRAX
			SZ7->Z7_TPF     := SZF->ZF_TPF
			SZ7->Z7_QTENF   := SZF->ZF_QTENF
			SZ7->Z7_MENS01  := SZF->ZF_MENS01
			SZ7->Z7_MENS02  := SZF->ZF_MENS02
			SZ7->Z7_MENS03  := SZF->ZF_MENS03
			SZ7->Z7_YTIPF   := SZF->ZF_YTIPF
			SZ7->Z7_OBSA    := SZF->ZF_OBSA
			SZ7->Z7_YTIPO   := SZF->ZF_YTIPO
			SZ7->Z7_YPEDB   := SZF->ZF_YPEDB
			SZ7->Z7_PLCAR   := SZF->ZF_PLCAR
			SZ7->Z7_PREFIXO := SZF->ZF_PREFIXO
			// ** Diógenes Dauster modificação referente a inclusão do campos novos
			SZ7->Z7_COMDESC := SZF->ZF_COMDESC
			SZ7->Z7_PALLET  := SZF->ZF_PALLET
			SZ7->Z7_LGIUSER :=CuSERNAME
		EndIf
		MsUnLock()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Proximo registro do SZF                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SZF")
	If  Recno() <> _reg
		Alert("O SZF FOI DISPOSICIONADO")
	EndIf
	If SZF->ZF_QTENF > 0 .and. ldivide == .F.
		ldivide := .T.
		Loop
	EndIf
	DbSkip()
	ldivide := .F.
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclui Pedido Faturado do Arquivo de Pedidos em Aberto "SZF"             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SZF")
DbSetOrder(8)
DbSeek(xFilial("SZF")+SZF->ZF_OC)
Do while .not. eof() .and. ZF_FILIAL==xFilial("SZF") .and. SZF->ZF_OC == SZF->ZF_OC
	While !RecLock("SZF",.f.);EndDo
	Delete
	MsUnLock()
	DbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Boleto Bancario                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//IF SE1->E1_VENCTO > dDataBase+1
IF SE1->E1_VENCTO > SE1->E1_EMISSAO+1 .AND. SZ7->Z7_COND<>'100' //ALTERDO POR GUSTAVO HAND STREY EM 19/06/12
	DbSelectArea("SZ7")
	DbSetOrder(8)
	DbSeek(xFilial("SZ7")+SZF->ZF_OC)
	Do while .not. eof() .and. Z7_FILIAL==xFilial("SZ7") .and. SZ7->Z7_OC == SZF->ZF_OC
		Do Case
			Case ( sm0->m0_codigo == '01' .and. SM0->M0_CODFIL $ "01,04,06,08,09,21") .or. ( sm0->m0_codigo $  "10,11,20,30" ) // .and. SM0->M0_CODFIL $ "01")
				//cPerg    := "MIZ065"
				//Parametros
				
				awParam:={  2,;					//Filtrar por         1=Bordero ou 2=Titulo Expecif
				"",;				//Bordero
				SZ7->Z7_PREFIXO,;	//Do Prefixo
				SZ7->Z7_PREFIXO,;	//Ate o Prefixo
				SZ7->Z7_NUMNF,;		//Do Numero
				Iif(Empty(SZ7->Z7_NUMNF2),SZ7->Z7_NUMNF,SZ7->Z7_NUMNF2),;	//Ate o Numero
				"" }				//Mensagem Adcional
				
				u_BOLCODBAR(awParam)
				
			OtherWise
				Execblock("MIZ060",.f.,.f.)
		EndCase
		
		DbSelectArea("SZ7")
		DbSkip()
	EndDo
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime NF saida                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SZ7")
DbSetOrder(8)
DbSeek(xFilial("SZ7")+SZF->ZF_OC)
Do while .not. eof() .and. Z7_FILIAL==xFilial("SZ7") .and. SZ7->Z7_OC == SZF->ZF_OC
	dbSelectArea("SX1")
	dbSetOrder(1)
	If  dbSeek(PADR("MIZF00",10))
		While ! RecLock("SX1",.F.) ; End
		SX1->X1_CNT01 := SZ7->Z7_NUMNF
		msUnlock()
		dbCommit()
	EndIf
	If  cempant == "11"
		Execblock("MIZ056",.F.,.F.)
	Elseif cOrigem <> 'MIZ999'
		Execblock("MIZ055",.F.,.F.)
	EndIf
	DbSelectArea("SZ7")
	DbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Final da transacao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbcommitAll()
End Transaction

lReturn:=.t.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime RPA                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SZF->ZF_FRETE == "C"
	
	DbSelectArea("SZ7")
	DbSetOrder(8)
	DbSeek(xFilial("SZ7")+SZF->ZF_OC)
	ldivide := .F.
	aenvio :={}
	Do while .not. eof() .and. Z7_FILIAL==xFilial("SZ7") .and. SZ7->Z7_OC == SZF->ZF_OC
		If SZ3->Z3_TIPO == "2"
			DbSelectArea("SX1")
			DbSetOrder(1)
			If  dbSeek("MIZF00")
				While ! RecLock("SX1",.F.) ; End
				If ldivide == .F.
					SX1->X1_CNT01 := SZ7->Z7_NUMNF
				Else
					SX1->X1_CNT01 := SZ7->Z7_NUMNF2
				EndIf
				msUnlock()
				dbCommit()
			EndIf
			Execblock("MIZF00",.F.,.F.,_amun)
		EndIf
		If SZ7->Z7_QTENF > 0 .and. ldivide == .F.
			ldivide := .T.
			Loop
		EndIf
		DbSelectArea("SZ7")
		DbSkip()
		ldivide := .F.
	EndDo
ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprimir Ticket Balanca                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SZ7")
DbSetOrder(8)
DbSeek(xFilial("SZ7")+SZF->ZF_OC)
Do while .not. eof() .and. Z7_FILIAL==xFilial("SZ7") .and. SZ7->Z7_OC == SZF->ZF_OC
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SZ7->Z7_CLIENTE+SZ7->Z7_LOJA))
	If SA1->A1_YTICKET == "S"
		_lTicket:=.T.
		if !IsInCallStack("U_MIZ999")
			ExecBlock("MIZ790",.F.,.F.,{SZ7->Z7_NUMNF,SZ7->Z7_SERIE} )
		endif
	EndIf
	DbSelectArea("SZ7")
	DbSkip()
EndDo

//impressao do tickte de balança
if IsInCallStack("U_MIZ999") .and. _lTicket
	warea:= getarea()
	U_RTICKET(SZF->ZF_OC)
	restArea(warea)
endif

If !IsInCallStack("U_MIZ999")
	ExecBlock("MIZ027",.F.,.F.)
EndIf


Return lreturn



*----------------------------------------------------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------------------------------
User Function NossoNumero(_cBcoBoleto)

Local   _cAgBoleto

_cBcoBoleto := IIF( _cBcoBoleto==Nil,"237",_cBcoBoleto)

_cSeqBol  	:= GetMv("MV_BOL"+_cBcoBoleto)
_cAgenBol 	:= GetMv("MV_YAGB"+_cBcoBoleto)

wNumero  := ""
wTipo    := 2

IF _cBcoBoleto == "237" //ENTRA SE O BANCO PADRÃO PARA GERAÇÃO DESTE BOLETO FOR O BANCO BRADESCO
	wNumero := _cSeqBol
	wNumero := IIF( Val(wNumero) > 0, wNumero, PadL("",08,"0") )
	wNumero := Soma1(wNumero)
	PutMv("MV_BOL"+_cBcoBoleto,wNumero) //GRAVA A SEQUENCIA DO BOLETO
	//	wNumero := _cAgenBol+cfilant+wNumero
	wNumero := "3" + cfilant + wNumero
	wNumero := u_Digito_BR() //DIGITO DO BANCO BRADESCO
ELSEIF _cBcoBoleto == "001" //ENTRA SE O BANCO PADRÃO PARA GERAÇÃO DESTE BOLETO FOR O BANCO BRASIL
	wNumero := _cSeqBol
	wNumero := IIF( Val(wNumero) > 0, wNumero, PadL("",5,"0") )
	wNumero := Soma1(wNumero)
	PutMv("MV_BOL"+_cBcoBoleto,wNumero)//GRAVA A SEQUENCIA DO BOLETO
	wNumero := GetMV("MV_YNUMCON")+PadL(wNumero,5,"0") //NR DO CONTRATO NO BCO BRASIL + O NR SEQUENCIAL
	wNumero := u_Digito_BB() //DIGITO DO BANCO DO BRASIL
ElseIf _cBcoBoleto == "004"
	wNumero := _cSeqBol
	wNumero := IIF( Val(wNumero) > 0, wNumero, PadL("",7,"0") )
	wNumero := Soma1(wNumero)
	PutMv("MV_BOL"+_cBcoBoleto,wNumero)
	wNumero := U_DIGITO_BB()
Endif



Return( wNumero )


Static Function fPesoBal()

local lRet     := .f.
private nHdll  := 0
private cText  := ''
private ComEnt := GetMv("PXH_COMSAI")

If MsOpenPort(nHdll,ComEnt)
	
	Inkey(0.4)
	IF	MSRead(nHdll,@cText)
		nVez:=1
		while .t.
			nVez+=1
			_peso_sai := VAL(alltrim(substr(cText ,at(" ",cText)+1,8)))/100  //PesoContinuo()
			cText     := substr(cText ,at(" ",cText))
			
			if _peso_sai > 0 .or. nVez > 10
				exit
			elseif Mod(10,5) == 0
				nHdll := 0
				cText := ''
				MsClosePort(nHdll)
				MSRead(nHdll,@cText)
			endif
		enddo
	Else
		apmsgalert('não foi possível ler a COM')
		lret:=.f.
	Endif
	
	MsClosePort(nHdll)
Else
	apmsgalert('não foi possível abrir a COM')
	lret:=.f.
Endif

Return(_peso_Sai)



User Function PXH05501(p_cOrigem,p_cOC)

if p_cOrigem=='PXH055'
	Private cendCli    := space(1)
	Private cestCli    := space(1)
	Private cGet_dtsai := _DtSaida
	Private cGet_endCl := _localcli
	Private cGet_estCl := _ufCli
	Private cGet_hrsai := _hora
	Private cGet_nomCl := _nomCli
	Private cGet_nota  := _nf
	Private cGet_nrLac := _lacre
	Private cGet_prefi := _prefixo
	Private cGet_psent := trans(_peso_ent    ,"@E 999,999,999.99")
	Private cGet_pssai := trans(_peso_sai    ,"@E 999,999,999.99")
	Private cGet_pliqu := trans(_peso_liq,"@E 999,999,999.99")
	Private cGet_sacos := trans(_qtd_fat,"@E 999,999")
	Private cGet_serie := _serie
	Private cGet_vlrpe := Transform(SZF->ZF_PEDAGIO,"@E 9,999.99")
	Private cGet_frete := trans( nF2FRETE ,"@E 9,999,999.99")
	
Elseif p_cOrigem=='SMGRAFICO'
	
	SZF->(dbsetorder(1))
	SZF->(dbSeek(xFilial("SZF")+p_cOc))
	
	lcarreg:= ( sZF->ZF_tpoper=="C" )
	
	_peso_liqcalc := (sZF->ZF_pssai - sZF->ZF_psent)
	_peso_liqcalc := iif( sZF->ZF_tpoper=="D", _peso_liqcalc *-1, _peso_liqcalc )
	
	if lcarreg
		sz7->(DbSetOrder(8))
		sz7->(DbSeek(xFilial("SZ7")+p_cOC))
		
		If  sZ7->Z7_unid = "TL"
			_peso_liqcalc := _peso_liqcalc / 1000
		End
	else
		sa2->(dbsetOrder(1))
		sa2->(dbseek( xfilial('SA2')+sZF->(ZF_fornece+ZF_lojafor)   ))
		
	endif
	
	_peso_liq      := _peso_liqcalc
	
	Private cendCli    := space(1)
	Private cestCli    := space(1)
	Private cGet_dtsai := sZF->ZF_dtsaida
	Private cGet_endCl := iif(lcarreg, sZ7->Z7_local, sa2->a2_end )
	Private cGet_estCl := iif(lcarreg, sZ7->Z7_ufe, sa2->a2_est )
	Private cGet_hrsai := sZF->ZF_hsaida
	Private cGet_nomCl := iif(lcarreg, sZ7->Z7_nomcli, sa2->a2_nome )
	Private cGet_nota  := iif(lcarreg, sZ7->Z7_numnf ,  sZF->ZF_NFCOMP )
	Private cGet_nrLac := sZF->ZF_lacre
	Private _lacre	   := sZF->ZF_lacre
	Private cGet_prefi := iif(lcarreg, sZ7->Z7_prefixo, '' )
	Private cGet_psent := trans(sZF->ZF_psent   ,"@E 999,999,999.99")
	Private cGet_pssai := trans(sZF->ZF_pssai    ,"@E 999,999,999.99")
	Private cGet_pliqu := trans( _peso_liq,"@E 999,999,999.99")
	Private cGet_sacos := trans(sZF->ZF_quant ,"@E 999,999")
	Private cGet_serie := iif(lcarreg, sZ7->Z7_serie  , sZF->ZF_SERNF )
	Private cGet_vlrpe := Transform(SZF->ZF_PEDAGIO,"@E 9,999.99")
	Private cGet_frete := trans( 0  ,"@E 9,999,999.99")
endif

SetPrvt("oDlg1","oGrp1","onomCli","oendCli","oestCli","oGet_nomCli","oGet_endCli","oGet_estCli","oGrp2")
SetPrvt("oSay7","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13", "oGet_nrLacre","oGet_psent","oGet_pssai","oGet_pliquido")
SetPrvt("oBtn_lacre","oGrp3","oSay1","oSay2","oSay3","oSay4","oSay5","oGet_serie","oGet_nota","oGet_prefixo")
SetPrvt("oGet_hrsaida")

oFont1     := TFont():New( "Verdana",0,-17,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Verdana",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
oFont14    := TFont():New( "Verdana",0,14,,.F.,0,,400,.F.,.F.,,,,,, )

oDlg1      := MSDialog():New( 101,258,508,1006,"Consulta Dados da  Fatura",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,012,052,356,"Dados do Cliente",oDlg1,CLR_HRED,CLR_WHITE,.T.,.F. )
onomCli    := TSay():New( 018,020,{||"Nome"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oendCli    := TSay():New( 036,020,{||"Endereço"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oestCli    := TSay():New( 036,288,{||"Estado"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet_nomCl := TGet():New( 016,060,{|u| If(PCount()>0,cGet_nomCli:=u,cGet_nomCli)},oGrp1,184,008,'',,CLR_BLACK,CLR_WHITE,/*fonte*/,,,.t.,"",,,.F.,.F.,,.F.,.F.,"","cGet_nomCli",,)
oGet_endCl := TGet():New( 033,060,{|u| If(PCount()>0,cGet_endCli:=u,cGet_endCli)},oGrp1,184,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_endCli",,)
oGet_estCl := TGet():New( 033,308,{|u| If(PCount()>0,cGet_estCli:=u,cGet_estCli)},oGrp1,032,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_estCli",,)

oGet_nomCl:disable()
oGet_endCl:disable()
oGet_estCl:disable()

ccoleent:='AUTOM.'
ccoleent:= iif( empty(sZF->ZF_coleent),'',  iif( sZF->ZF_coleent=='A',' AUTOM.', ' MANUAL' ) )
ccolesai:='AUTOM.'
ccolesai:= iif( empty(sZF->ZF_colesai),'',  iif( sZF->ZF_colesai=='A',' AUTOM.', ' MANUAL' ) )

oGrp2      := TGroup():New( 056,012,112,356,"Dados do Transporte",oDlg1,CLR_HRED,CLR_WHITE,.T.,.F. )
oSay6      := TSay():New( 068,020,{||"Peso Entrada"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6E     := TSay():New( 068,122,{|| ccoleent },oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)

oSay7      := TSay():New( 080,020,{||"Peso Saida"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6S     := TSay():New( 080,122,{|| ccolesai },oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)

oSay8      := TSay():New( 068,152,{||"Qtd.Sacos"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 098,020,{||"Peso liquido"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 080,152,{||"Nr.Lacre"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay11     := TSay():New( 088,056,{||"___________________________________"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oSay12     := TSay():New( 098,180,{||"R$ Pedagio"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 098,272,{||"R$ Frete"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,027,008)

oGet_nrLac := TGet():New( 079,180,{|u| If(PCount()>0,_lacre:=u,_lacre)},oGrp2,128,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_lacre",,)
oGet_psent := TGet():New( 068,060,{|u| If(PCount()>0,cGet_psent:=u,cGet_psent)},oGrp2,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_psent",,)
oGet_pssai := TGet():New( 080,060,{|u| If(PCount()>0,cGet_pssai:=u,cGet_pssai)},oGrp2,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_pssai",,)
oGet_pliqu := TGet():New( 097,060,{|u| If(PCount()>0,cGet_pliquido:=u,cGet_pliquido)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_pliquido",,)
oGet_sacos := TGet():New( 066,180,{|u| If(PCount()>0,cGet_sacos:=u,cGet_sacos)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_sacos",,)
oGet_vlrpe := TGet():New( 097,212,{|u| If(PCount()>0,cGet_vlrpedagio:=u,cGet_vlrpedagio)},oGrp2,039,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_vlrpedagio",,)
oGet_frete := TGet():New( 097,303,{|u| If(PCount()>0,cGet_frete:=u,cGet_frete)},oGrp2,039,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_frete",,)

oGet_nrLac:disable()
oGet_psent:disable()
oGet_pssai:disable()
oGet_pliqu:disable()
oGet_sacos:disable()
oGet_vlrpe:disable()
oGet_frete:disable()

oSBtn1     := SButton():New( 096,122,11,{|| U_PXH04501(), cGet_pliqu := trans(_peso_liq,"@E 999,999,999.99"), oDlg1:refresh() },oGrp2,,"", )
oSBtn2     := SButton():New( 077,310,11,{|| getLacre() } ,oGrp2,,"", )

oGrp3      := TGroup():New( 116,012,168,356,"Dados da Nota",oDlg1,CLR_HRED,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 128,116,{||"Serie"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSay2      := TSay():New( 128,172,{||"Prefixo"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 128,020,{||"Data de Saida"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay4      := TSay():New( 144,020,{||"Hora de Saida"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,039,008)
oSay5      := TSay():New( 128,240,{||"Número"},oGrp3,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,032,008)
oGet_serie := TGet():New( 128,136,{|u| If(PCount()>0,cGet_serie:=u,cGet_serie)},oGrp3,025,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_serie",,)
oGet_nota  := TGet():New( 128,276,{|u| If(PCount()>0,cGet_nota:=u,cGet_nota)},oGrp3,060,008,'',{||  val_nf(cGet_nota), cGet_nota:=_nf },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_nota",,)
oGet_prefi := TGet():New( 128,204,{|u| If(PCount()>0,cGet_prefixo:=u,cGet_prefixo)},oGrp3,025,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_prefixo",,)
oGet_dtsai := TGet():New( 128,060,{|u| If(PCount()>0,cGet_dtsaida:=u,cGet_dtsaida)},oGrp3,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_dtsaida",,)
oGet_hrsai := TGet():New( 141,060,{|u| If(PCount()>0,cGet_hrsaida:=u,cGet_hrsaida)},oGrp3,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_hrsaida",,)

oUsr      := TSay():New( 175,020,{||"Operador: "},oGrp3,,oFont14,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,032,008)
oUsr      := TSay():New( 175,080,{||  SZF->ZF_USUARIO  },oGrp3,,oFont14,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)

oGet_serie:disable()
oGet_nota:disable()
oGet_prefi:disable()
oGet_dtsai:disable()
oGet_hrsai:disable()

oBtn1      := TButton():New( 176,296,"Confirma",oDlg1, {||  continua()  , oDlg1:end() } ,056,012,,,,.T.,,"",,,,.F. )

if p_cOrigem=='SMGRAFICO'
	oSBtn1:disable()
	oSBtn2:disable()
	oBtn1:disable()
endif

oDlg1:Activate(,,,.T.)

Return

Static Function getLacre()

oGet_nrLac:enable()
if !laltlacre
	oGet_nrLac:setfocus()
endif
odlg1:refresh()
laltlacre:=.T.

Return


Static Function PXH05502()

_aAliOri := GetArea()

lMsHelpAuto := .T.
lMsErroAuto := .F.
_cNumPed     := GetSxeNum("SC5", "C5_NUM")
_aCab        := {}
_aItems      := {}

RollBackSXE()

aAdd(_aCab,{"C5_NUM"    , _cNumPed													,Nil})	// 01 - Numero do pedido
aAdd(_aCab,{"C5_TIPO"   , "N"													    ,Nil})	// 02 - Tipo de pedido
aAdd(_aCab,{"C5_CLIENTE", SA1->A1_COD												,Nil})	// 03 - Codigo do cliente
aAdd(_aCab,{"C5_LOJACLI", SA1->A1_LOJA												,Nil})	// 04 - Loja do cliente
aAdd(_aCab,{"C5_CONDPAG", "901"     												,Nil})	// 05 - Codigo da condicao de pagamanto
aAdd(_aCab,{"C5_PARC1"  , 100		 											    ,Nil})	// 06 - Percentual do vencimento
aAdd(_aCab,{"C5_DATA1"  , TRB->VENCTO 												,Nil})	// 07 - Vencimento do titulo
aAdd(_aCab,{"C5_CODBKP" , "MZ0123"   												,Nil})	// 07 - Vencimento do titulo

_cItem    := "01"
dDataBase := TRB->EMISSAO
_cNFIBEC  := TRB->NOTA
_cSERIBEC := TRB->SERIE
_lInt     := .T.

While TRB->(!Eof()) .And. _cChav == TRB->NOTA + TRB->SERIE
	
	IncProc()
	
	_lInt     := .T.
	/*
	If !Empty(TRB->INTEGR)
	TRB->(dbSkip())
	_lInt  := .f.
	Loop
	Endif
	*/
	SB1->(dbSetorder(1))
	If SB1->(!dbSeek(xFilial("SB1")+TRB->PRODUTO))
		MSGINFO("Condicao de Pagamento Nao Cadastrado!!! "+TRB->COND)
		TRB->(dbCloseArea())
		Return
	Endif
	
	SF4->(dbSetorder(1))
	If SF4->(!dbSeek(xFilial("SF4")+TRB->TES))
		MSGINFO("TES Nao Cadastrado!!! "+TRB->TES)
		TRB->(dbCloseArea())
		Return
	Endif
	
	If Round((TRB->QUANT * TRB->PRUNIT),2) <> TRB->TOTAL
		_nPr := ROUND(TRB->TOTAL / TRB->QUANT,6)
	Else
		_nPr := TRB->PRUNIT
	Endif
	
	_aItem := {}
	aAdd(_aItem,{"C6_ITEM"   , _cItem						, Nil}) 	// 02 - Numero do Item no Pedido
	aAdd(_aItem,{"C6_PRODUTO", TRB->PRODUTO					, Nil}) 	// 02 - Codigo do Produto
	aAdd(_aItem,{"C6_DESCRI",  SB1->B1_DESC   				, Nil}) 	// 03 - Codigo do Produto
	aAdd(_aItem,{"C6_LOCAL" ,  SB1->B1_LOCPAD 				, Nil}) 	// 04 - Codigo do Produto
	aAdd(_aItem,{"C6_UM"     , SB1->B1_UM   				, Nil}) 	// 05 - Unidade de Medida
	aAdd(_aItem,{"C6_QTDVEN" , TRB->QUANT					, Nil}) 	// 06 - Quantidade Vendida
	aAdd(_aItem,{"C6_PRCVEN" , _nPr        					, Nil}) 	// 07 - Preco Unitario
	aAdd(_aItem,{"C6_PRUNIT" , _nPr        					, Nil}) 	// 08 - Preco Unitario
	aAdd(_aItem,{"C6_VALOR"  , TRB->TOTAL					, Nil}) 	// 09 - Valor Total do Item
	aAdd(_aItem,{"C6_TES"    , TRB->TES						, Nil}) 	// 10 - Tipo de Saida do Item
	aAdd(_aItem,{"C6_CF"     , SF4->F4_CF  					, Nil}) 	// 11 - Tipo de Saida do Item
	aAdd(_aItem,{"C6_CLI"    , SA1->A1_COD 					, Nil}) 	// 12 - Tipo de Saida do Item
	aAdd(_aItem,{"C6_LOJA"   , SA1->A1_LOJA					, Nil}) 	// 13 - Tipo de Saida do Item
	aAdd(_aItem,{"C6_CODBKP" , "MZ0123"   					, Nil}) 	// 13 - Tipo de Saida do Item
	
	aAdd(_aItems, aClone(_aItem))
	
	_cItem := Soma1(_cItem)
	
	TRB->(RecLock("TRB",.F.))
	TRB->INTEGR := "S"
	TRB->(MsUnLock())
	
	TRB->(dbSkip())
EndDo

//Begin Transaction

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclusao do pedido de venda pelo execauto do MATA410   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If _lInt
	MsExecAuto({|x,y,z| mata410(x,y,z)}, _aCab, _aItems, 3)
	
	If lMsErroAuto
		RollBackSXE()
		DisarmTransaction()
		MostraErro()
	Else
		//End Transaction
		//MsgInfo("Pedido Atualizado Com Sucesso!!")
		//Return
		
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek(xFilial("SC5")+_cNumPed))
			SC6->(dbSetOrder(1))
			If SC6->(dbSeek(xFilial("SC6")+_cNumPed))
				
				_cChavSC6:= SC6->C6_NUM
				lCredito:= lEstoque := .F.
				
				While SC6->(!Eof()) .And.  _cChavSC6 == SC6->C6_NUM
					
					MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.)
					//MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,@lCredito,@lEstoque,.T.,.T.,.F.,.F.,NIL,NIL,NIL,NIL,NIL,NIL,SC6->C6_UNSVEN)
					
					SC6->(dbSkip())
					
				EndDo
			Endif
			
			MaLiberOk({ SC5->C5_NUM },.T.)
			
			SC9->(dbSetOrder(1))
			If SC9->(dbSeek(xFilial("SC9")+SC5->C5_NUM))
				
				_cChavSC9 := SC9->C9_PEDIDO
				_aPv := {}
				
				While SC9->(!Eof()) .And. _cChavSC9 == SC9->C9_PEDIDO
					
					SC9->(RecLock("SC9",.F.))
					SC9->C9_BLEST := ""
					SC9->C9_BLCRED:= ""
					SC9->(MsUnlock())
					
					If Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
						
						SC6->(dbSetOrder(1))
						SC6->(dbseek(xFilial("SC6")+ SC9->C9_PEDIDO + SC9->C9_ITEM))
						
						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
						
						SB2->(dbSetOrder(1))
						SB2->(dbSeek(xFilial("SB2")+SB1->B1_COD + SB1->B1_LOCPAD))
						
						SF4->(dbSetOrder(1))
						SF4->(dbSeek(xFilial("SF4")+SC6->C6_TES))
						
						Aadd(_aPv,{SC9->C9_PEDIDO,SC9->C9_ITEM,SC9->C9_SEQUEN,SC9->C9_QTDLIB,SC9->C9_PRCVEN,SC9->C9_PRODUTO,.F.,;
						SC9->(RecNo()),SC5->(RecNo()),SC6->(RecNo()), SE4->(RecNo()), SB1->(RecNo()),SB2->(RecNo()), SF4->(RecNo())})
						
					Endif
					
					SC9->(dbSkip())
					
				EndDo
				
				MSGiNFO(" PEDIDO --> "+SC9->C9_PEDIDO)
				
				MaPvlNfs(_aPv   , _cSerie, .F.      , .F.     , .F.      , .F.     , .F.     , 0      , 0          , .F., .F.)
			Endif
		Endif
		
	Endif
Endif
RestArea(_aAliOri)

Return