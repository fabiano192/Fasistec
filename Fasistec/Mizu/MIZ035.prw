#include "rwmake.ch"
#INCLUDE 'COLORS.CH'
#XCommand ROLLBACK TRANSACTION => DisarmTransaction()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³  MIZ035  ³ Autor ³ NILTON CESAR          ³ Data ³ 06.07.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Saida de caminhao carregado                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFAT - Menu Atualizacoes                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteracao³ Luana Poltronieri de Souza  21.06.99                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteracao³ 23/08/02 - Nilton                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ALTERAÇÕES:
*/

User Function Miz035(p_cOrigem)

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
	Private _aPedSZ1 := {}

	Private _lZFM  := .F.
	private cOrigem:= iif(p_cOrigem==nil, '',p_cOrigem)

	private lUsaNewOC := ( cFilAnt $  getnewPar('MV_USNEWOC','01')  .and. cOrigem == 'MIZ999'	 )

	private cColeta:= "A"

	///// HORARIO DE VERAO

	Private _dDatBkp := dDataBase

	Private _cPedVen := _cNFVen := ""

	_dEmissao:= dDataBase
	_cHora   := Left(time(),5)
	_cMin    := Right(_cHora,2)

	If SM0->M0_ESTCOB $ "AC/AM/MT/MS/RO/RR"
		If _cHora   == "00"
			_dEmissao--
			If SM0->M0_ESTCOB $ "AC"
				_cHora    := "22:" + _cMin // MENOS 02 HORAS
			Else
				_cHora    := "23:" + _cMin // MENOS 01 HORAS
			Endif
		Else
			_cHora := Strzero(Val(_cHora)-1,2) + ":" + _cMin
		Endif
	Endif

	If GETMV("MV_HVERAO")  /// SE VERDADEIRO ENTAO TEM HORARIO DE VERÃO
		If SM0->M0_ESTCOB $ "DF/GO/ES/MT/MS/MG/PR/RJ/RS/SP/SC"
			If _cHora   == "00"
				_dEmissao--
				_cHora    := "23:" + _cMin
			Else
				_cHora := Strzero(Val(_cHora)-1,2) + ":" + _cMin
			Endif
		Endif
	Endif

	dDataBase := _dEmissao

	///// HORARIO DE VERAO

	dta_lim := getmv("MV_YDTAFAT")

	If ddatabase <= dta_lim
		MsgBox("A data limite do faturamento nao permite faturar na database solicitada. Verifique com o Administrador do Sistema","Atencao","ALERT")
		Return
	EndIf

	If UPPER(Alltrim(cUserName)) $ "ALE"
		_BalSai := "E:\BALSAI.TXT"
	ElseIf UPPER(Alltrim(cUserName)) $ "ALISON"
		_BalSai := "D:\BALSAI.TXT"
	Else
		_BalSai := alltrim(getmv("MV_YBALSAI"))
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acessa arquivo da balanca                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  ! file(_BalSai)
		MsgBox("Arquivo de balanca nao foi encontrado!","Atencao","ALERT")
		Return
	End

	If UPPER(Alltrim(cUserName)) $ "ALE|FABIANO|ALISON"
		_serie   := "ZZZ"
		_prefixo := "ZZZ"
	Else
		_serie   := StrTran(PadR(getmv("MV_YSERIE"),3," "),"*"," ")
		_prefixo := alltrim(getmv("MV_YPREF"))
	Endif

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
	_serie  := IIF( cFilAnt $ GetMv("MV_YFILKEY"), LEFT(_serie,1), _serie )
	calias2 := Alias()
	ntotsc  := 0
	_aPedSZ1:= {}

	DbSelectArea("SZ1")
	DbSetOrder(8)
	DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
	Do while .not. eof() .and. Z1_FILIAL == xFilial("SZ1") .and. Z1_OC == SZ8->Z8_OC
		If SZ1->Z1_UNID $ "SC,SA"
			ntotsc+=SZ1->Z1_QUANT
			AADD(_aPedSZ1,{SZ1->Z1_PRODUTO,SZ1->Z1_QUANT})
		EndIf
		DbSkip()
	EndDo
	DbSelectArea(calias2)
	SZ1->(DbSetOrder(8))
	SZ1->(DbSeek(xFilial("SZ1")+SZ8->Z8_OC))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa variaveis                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_peso_ent     := SZ8->Z8_PSENT
	_peso_sai     := SZ8->Z8_PSSAI

	If !Empty (GetMV("MV_YCOMSAI")) .and. !lUsaNewOC
		MsAguarde({||fPesoBal()},"Lendo Peso...")
	endif

	//If lUsaNewOC .and. cempant $ '01|10|11|12|20|30|40|50' .and. _peso_sai <= 0
	If lUsaNewOC .and. _peso_sai <= 0

		lpesoOk:=.f.
		While  !lpesoOK

			//if cEmpAnt $ "30/40"  // 17/10/14			Comentado por Alison  - 22/07/2016
			IF cEmpAnt + cFilAnt $ "0210|3001|4001|0203"	//Incluso empresa 0203 - 12/09/2016
				if  _peso_sai <= 0
					u_smFrmPeso(@_peso_sai,"SAIDA",@cColeta)
				endif
			else
				u_frmPesoBal(@_peso_sai,"SAIDA",@cColeta)
			endif

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
	else
		if _peso_sai == 0
			_peso_sai     := iif( subs(memoread(_BalSai),11,1)=='/','"'+ AllTrim( subs(memoread(_BalSai),1,10) ) ,subs(memoread(_BalSai),1,10))

			if !( Subs(_peso_sai,1,1) $ '0123456789' )
				_peso_sai     := Subs(_peso_sai,2,7)
				_peso_sai     := val(_peso_sai)
			Else
				_peso_sai     := val(_peso_sai) / 100
			EndIf

			cColeta:="S"  //serial

		ENDIF

	endif

	If _peso_sai >= 88888

		Alert("Atencao, peso da balanca esta ERRADO. VERIFIQUE!")

	EndIf

	_peso_liqcalc := (_peso_sai - _peso_ent)

	If  SZ1->Z1_UNID = "TL"
		_peso_liqcalc := _peso_liqcalc / 1000
	End
	_peso_liq      := _peso_liqcalc
	_peso_liqinf   := 0
	_hora          := left(time(),5)
	_DtSaida       := dDataBase
	_lacre         := Space(80)

	DbSelectArea("SZ1")
	DbSetOrder(8)
	DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
	Do while .not. eof() .and. Z1_FILIAL == xFilial("SZ1") .and. Z1_OC == SZ8->Z8_OC
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))

		If SB1->B1_YTRBIG == 20
			Do while .t.
				DEFINE MSDIALOG oDlgP TITLE "Quantidade de BigBag" FROM 10,40 TO 120,300 PIXEL
				@ 20,15 say "Quantidade:"
				@ 20,70 get nabatep Pict "@E 9,999,99"
				@ 35,90 BmpButton Type 1  Action Close(odlgp)
				Activate MsDialog oDlgp Centered
				If nabatep == 0
					Loop
				Else
					Exit
				EndIf
			EndDo
			nabatep := nabatep * GetMV("MV_YPBIG")
			Exit
		EndIf
		DbSkip()
	EndDo

	DbSelectArea("SZ1")
	DbSetOrder(8)
	DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
	Do while .not. eof() .and. Z1_FILIAL == xFilial("SZ1") .and. Z1_OC == SZ8->Z8_OC
		If Alltrim(SZ1->Z1_PRODUTO)=="PALET"
			nqtpal+=SZ1->Z1_QUANT
		EndIf
		DbSkip()
	EndDo

	DbSelectArea("SZ1")
	DbSetOrder(8)
	DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
	_lacre := SZ1->Z1_LACRE
	_nomCli:= sz1->z1_nomcli
	_localcli:= sz1->z1_local
	_ufCli:= sz1->z1_ufe

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))

	If Alltrim(SB1->B1_TIPCAR) == "S"
		_nQtde   := (SZ1->Z1_QUANT * SB1->B1_CONV) / 1000
		_nQtdeNf := (SZ1->Z1_QTENF * SB1->B1_CONV) / 1000
	Else
		_nQtde   := SZ1->Z1_QUANT
		_nQtdenF := SZ1->Z1_QTENF
	Endif

	nF2FRETE := 0
	If _nQtdenF  > 0 .and. SB1->B1_YTRBIG==0 .and. SZ1->Z1_UNID $ "SC"
		nF2FRETE  := Iif(SZ3->Z3_TIPO=="2",(SZ1->Z1_FMOT * _nQtde) / (_nQtde + _nQtdenF),(SZ1->Z1_FTRA * _nQtde)/(_nQtde + _nQtdenF))
	Else
		nF2FRETE  := Iif(SZ3->Z3_TIPO=="2",SZ1->Z1_FMOT,SZ1->Z1_FTRA) //SZ1->Z1_VLFRE
	EndIf

	If nabatep > 0 //BIGBAG
		_peso_sai 		:= _peso_sai - nabatep
		_peso_liqcalc   := _peso_liqcalc - (nabatep  / 1000)
		_peso_liq       := _peso_liqcalc
	EndIf

	If nqtpal > 0 //PALET
		nqtpal := nqtpal * GetMV("MV_YPPAL")
		_peso_sai 		:= _peso_sai - nqtpal
		_peso_liqcalc   := _peso_liqcalc - nqtpal
		_peso_liq       := _peso_liqcalc
	EndIf

	If  SZ1->Z1_UNID $ "SC,SA"
		_qtd_fat := ntotsc
	End

	If lUsaNewOC
		u_frmDadosNF('MIZ035')
	Else
		DEFINE MSDIALOG oDlg1 TITLE "Saida de Caminhao carregado" FROM 0,0 TO 300,500 PIXEL
		@ 8,10 to 105,220
		@ 20,15  say "Peso Entrada:"
		@ 30,15  say "Peso Saida:  "
		@ 40,15  say "Peso Liquido:"
		@ 50,15  say "Serie:       "
		@ 50,130 say "Prefixo:"
		@ 60,15  say "Nr. do lacre:"
		@ 70,15  say "Nota Fiscal: "
		@ 80,15  say "Data saida:  "
		@ 90,15  say "Hora saida:  "

		@ 20,70 say trans(_peso_ent    ,"@E 999,999,999.99")
		@ 30,70 say trans(_peso_sai    ,"@E 999,999,999.99")
		@ 40,70 say trans(_peso_liqcalc,"@E 999,999,999.99")
		If  SZ1->Z1_UNID $ "SC,SA"
			@ 40,170 say "Sacos: "+trans(_qtd_fat,"@E 999,999")
		End
		@ 50,70  say _serie
		@ 50,170 get _prefixo PICTURE "@!" when .f.
		@ 70,70  get _nf  PICT "999999" Valid val_nf() size 25,60
		oGetlacre      :=  TGet():New( 060,070,{|u| If(PCount()>0,_lacre:=u,_lacre)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_lacre",,)
		oGetlacre:disable()
		@ 60,140 BUTTON "Alt. Lacre" Size 30,09  ACTION Altera_LACRE()
		@ 80,70  get _DtSaida Size 50,100
		@ 90,70  say _hora    Pict "99:99"

		@ 90,130 say "Vr.Total Pedágio: " + Alltrim(Transform(SZ8->Z8_PEDAGIO,"@E 9,999.99"))
		nOpca:=0
		@ 110,100 BmpButton Type 1  Action (IIF(val_nf(),(nOpca:=1,Close(oDlg1)), nOpca:=2))
		//	@ 110,140 BmpButton Type 11 Action u_Altera_Peso()
		@ 110,140 BmpButton Type 11 Action u_Altera_Peso(,"S") // Normando (Semar) 23/11/2015 Identificar o tipo de peso pelo parametro.
		Activate MsDialog oDlg1 Centered

		IF nOpca == 1
			lret := MsgBox("Confirma faturamento","Escolha","YESNO")

			If lret
				Continua()
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Refresh no arquivo SZ8                                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !IsInCallStack("U_MIZ999")
					ExecBlock("MIZ027",.F.,.F.)
				EndIf
			EndIf
		ENDIF

	endif

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

	If SZ1->Z1_UNID == "TL" .and. SZ1->Z1_FRETE == "C"
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
		SZG->(DbSetOrder(1))
		SZG->(DbSeek(xFilial("SZG")+SZ1->Z1_UFE+SZ1->Z1_MUNE+SZ1->Z1_FORNECE+SZ1->Z1_LOJAF + "L"))

		If nvalf == 0
			nvalf := Iif(SA1->A1_YFGRA > 0,Round(_peso_liqinf * SA1->A1_YFGRA,2),Round(_peso_liqinf * SZG->ZG_VALOR,2))
		EndIf
		DEFINE MSDIALOG oDlgf TITLE "Ajusta valor do frete" FROM 40,50 TO 230,430 PIXEL
		@ 40,15 say "Valor do Frete:"
		@ 40,70 get nvalf Size 60,100   Pict "@e 999,999,999.99"
		@ 60,100 BmpButton Type 1 Action Close(oDlgf)
		Activate MsDialog oDlgf Centered
		SZ3->(DbSetOrder(1))
		SZ3->(DbSeek(xFilial("SZ3")+SZ1->Z1_MOTOR))
		While !Reclock("SZ1",.f.);EndDo
		If SZ3->Z3_TIPO == "2"
			SZ1->Z1_FMOT := nvalf
		Else
			SZ1->Z1_FTRA := nvalf
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

	Local lUsaNT   := SuperGetMV("MV_SMUSANT",,.F.) // Adicionado por Rodrigo (Semar) 19/12/16 - Tratar a origem do Peso bruto, (.T.) o peso se estiver zerado na SZ2 deve vim da ZZJ, (.F.) pesa da SZ2.
	_margem      := 0

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO)
	IF SZ1->Z1_YPM $ "P/E"
		_margem      := getmv("MV_YMARGEM")
	ELSEIF SZ1->Z1_YPM == "M"
		_margem      := getmv("MV_YMRGMAN")
	ELSEIF SZ1->Z1_YPM $  "BG"
		_margem      := 0
	END

	_nQtTot:= 0
	_aConv := {}


	//If SZ1->Z1_UNID $ 'SC*SA' .AND. !cEmpAnt $ "30            Comentado por Alison - 22/07/2016
	If SZ1->Z1_UNID $ 'SC*SA' .And. !cEmpAnt+cFilAnt $ "0210|3001"
		//_peso_total  := _qtd_fat  * SB1->B1_CONV ALTERADO POR ALEXANDRO EM  08/03/13

		For AX:= 1 To Len(_aPedSZ1)
			_cProd := _aPedSZ1[AX,1]

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+ _cProd))

			If  AScan(_aConv,SB1->B1_CONV) == 0
				AADD(_aConv,{SB1->B1_CONV})
			Endif

			_nQt    := _aPedSZ1[AX,2] * SB1->B1_CONV
			_nQtTot += _nQt

		Next AX

		_peso_total := _nQtTot

	Else
		_peso_total := _peso_liq * SB1->B1_CONV   // Granel
	Endif

	//If !cEmpAnt $ "30"			Comentado por Alison - 22/07/2016
	If !cEmpAnt + cFilAnt $ '0210|3001'
		_peso_maximo := _peso_total + (_peso_total * _margem / 100)
		_peso_minimo := _peso_total - (_peso_total * _margem / 100)

		_peso_exced  := _peso_liq - _peso_total

		_CargaVeiculo:=Posicione("SZ2",1,xFilial('SZ2')+SZ8->Z8_PLACA,"Z2_PESOTRA")

		//Adicionado por Rodrigo (Semar) em 19/12/16 - Tratar quando a unidade utilizar a nova tela de excessão e seu peso estiver vinculado ao tipo de veiculo (ZZJ) e não ao seu cadastro (SZ2).
		if _CargaVeiculo == 0 .AND. lUsaNT
			//Nesse caso a unidade utiliza e o campo Z2_PESOTRA está zerado, significa que o caminhão utiliza o peso de acordo com o tipo de veiculo (ZZJ / Tabela DNIT).
			_CargaVeiculo := Posicione("ZZJ",1,xFilial('ZZJ')+SZ8->Z8_TPVEIC,"ZZJ_LOTACA")
		endif

		If _peso_total > _CargaVeiculo
			//Marcus Vinicius - 15/06/2016 - Ajustado para impedir carregamento com seu peso de transporte acima do cadastrado na SZ2.
			MsgBox("Peso acima da capacidade maxima do veiculo, verifique o pedido utilizado ou o cadastro do caminhão. ","Peso excedido","STOP")
			Return .F.

		Endif
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula peso / tolerancia para cimento em Sacos                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	_loDlg4 := .F.
	//If  SZ1->Z1_UNID $ "SC,SA" .AND. !cEmpAnt $ "30"
	If  SZ1->Z1_UNID $ "SC,SA" .AND. !cEmpAnt + cFilAnt $ '0210|3001'
		If  _peso_liq > _peso_maximo .or. _peso_liq < _peso_minimo
			_loDlg4 := .T.
			DEFINE MSDIALOG oDlg4 TITLE "Saida de Caminhao carregado" FROM 0,0 TO 300,500 PIXEL
			@ 8,10 to 100,220
			//		@ 20,15 say "Sacos:"
			//		@ 30,15 say "Peso por Saco:"
			//		@ 40,15 say "Peso Total:"
			//		@ 60,15 say "Peso Liquido:"
			//		@ 70,15 say "Diferenca no peso:"
			//		@ 80,15 say "DIFERENCA SACOS:"
			//		@ 20,70 say trans(_qtd_fat    ,"@E 999,999")
			//		@ 30,70 say trans(SB1->B1_CONV,"@E 999,999,999.99")
			//		@ 40,70 say trans(_peso_total ,"@E 999,999,999.99")
			//		@ 60,70 say trans(_peso_liq   ,"@E 999,999,999.99")
			//		@ 70,70 say trans(_peso_exced ,"@E 999,999,999.99")

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
				@ _nLin,70 say trans((_peso_liq /SB1->B1_CONV) - _qtd_fat ,"@E 999,999,999.99")  // ALTERADO POR ALEXANDRO 08/03/13
			Else
				//	@ 80,70   Say Trans(_peso_liq - _nQtTot ,"@E 999,999,999.99")
			Endif

			@ 110,140 BmpButton Type 1  Action Close(odlg4)
			@ 110,190 BmpButton Type 2  Action Close(odlg4)
			Activate MsDialog oDlg4 Centered

		EndIf
	EndIf



	//Verifica se alterou o(s) LACRES - e atualiza o campo laltlacre e o campo Z8_LACRE  - Juailson - Semar 23/02/15
	// Quando alterar os Lacres - gravar na SZ8
	if alltrim(SZ8->Z8_LACRE) <> alltrim(_lacre)
		laltlacre := .T.

		Reclock("SZ8",.F.)
		SZ8->Z8_LACRE  :=  _lacre
		MsUnlock()

	endif

	aNotas   := {}
	_cTpPed  := SZ1->Z1_TIPO
	_cNumPed := SZ1->Z1_YPEDB

	If Gera_NF()
		//If cEmpAnt == "30" .And. _cTpPed == "T"
		If cEmpAnt + cFilAnt $ '0210|3001|0203' .And. _cTpPed == "T"
			If UPPER(Alltrim(cUserName)) $ "ALE|FABIANO|ALISON"
				_serie   := "ZZZ"
				_prefixo := "ZZZ"
			Else
				_serie   := StrTran(PadR(getmv("MV_YSERIE"),3," "),"*"," ")
				_prefixo := alltrim(getmv("MV_YPREF"))
			Endif

			SC5->(dbSetOrder(1))
			If SC5->(dbSeek(xFilial("SC5")+_cNumPed))

				//Inicio - Fabiano em 24/11/15
				SC5->(RecLock("SC5",.F.))
				SC5->C5_MENNOTA := "NF Venda: "+Alltrim(_cNFVen)+" emitida em "+dToc(dDatabase)
				SC5->(MsUnlock())
				//Fim - Fabiano em 24/11/15

				SC6->(dbSetOrder(1))
				If SC6->(dbSeek(xFilial("SC6")+_cNumPed))

					_cChavSC6:= SC6->C6_NUM
					lCredito:= lEstoque := .F.

					While SC6->(!Eof()) .And.  _cChavSC6 == SC6->C6_NUM

						SC9->(dbSetOrder(1))
						If !SC9->(msSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
							MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.)
						Endif

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

					MaPvlNfs(_aPv   , _serie, .F.      , .F.     , .F.      , .F.     , .F.     , 0      , 0          , .F., .F.)
				Endif
			Endif

			_aAliasSZ7 := SZ7->(GETAREA())

			SZ7->(dbSetOrder(1))
			If SZ7->(msSeek(xFilial("SZ7")+_cPedVen))

				SZ7->(RecLock("SZ7",.F.))
				SZ7->Z7_OBSER := "NF Remessa: "+Alltrim(SF2->F2_DOC)+" emitida em "+dToc(SF2->F2_EMISSAO)
				SZ7->Z7_OBSA  := SF2->F2_CLIENTE+SF2->F2_LOJA
				SZ7->(MsUnlock())
			Endif

			RestArea(_aAliasSZ7)



			_cNotaRem := SF2->F2_DOC
			aadd(aNotas, _cNotaRem )

			If lUsaNewOC
				U_MzNfetransm('TODAS',_serie, aNotas[1], aNotas[len(aNotas)] )
				//U_MzNfetransm('TODAS',_serie, _cNotaRem, _cNotaRem )
			Endif
		Else
			if lUsaNewOC
				If cEmpAnt+cFilAnt == "0203"   // ALEXANDRO
					U_TRANS_ASC('TODAS',_serie, aNotas[1], aNotas[len(aNotas)] )
				Else
					U_MzNfetransm('TODAS',_serie, aNotas[1], aNotas[len(aNotas)] )
				Endif
				If cEmpAnt+cFilAnt $ SuperGetMV("MV_YMDFE",,"") //Inserido por Fabiano em 09/12/16
					//			If cEmpAnt == '01'
					If SF2->F2_EST <> SM0->M0_ESTCOB .And. SF2->F2_YFRETE = 'F'
						U_MZ0197(_serie, aNotas[1],,SZ8->Z8_OC )
					Endif
				Endif
			Endif
		Endif
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
	//Local cStat	:= if(cEmpAnt $ '30|01|40',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40                      Comentado por Alison - 22/07/2016
	Local cStat	:= if(cEmpAnt + cFilAnt $ '0101|3001|0210|4001|0203',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40 | 	Incluso empresa 0203 - 12/09/2016

	Private npesoSZ1:=0,cpedmaior:="",npedmaior :=0,_senha2:=Space(10),cpeconv:=0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha janela com mensagem de peso excedente                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  _loDlg4

		DEFINE MSDIALOG oDlg5 TITLE "Senha" FROM 40,50 TO 100,300 PIXEL
		@ 08,10 say "Senha:"
		@ 08,35 get _senha2 PassWord
		@ 14,95 BmpButton Type 1 Action Close(oDlg5)
		Activate MsDialog oDlg5 Centered
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a senha ‚ valida                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  alltrim(_senha2) <> Alltrim(GetMV("MV_YSENPRO"))
			MsgBox("Atencao, senha errada","Atencao","ALERT")
			Return
		EndIf

	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fechar a tela para iniciar as impressoes                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Close(odlg1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio da transacao                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	Begin Transaction
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verificar todos os pedidos qual e o peso total                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		DbSelectArea("SZ1")
		DbSetOrder(8)
		DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
		npedmaior := 0
		Do while .not. SZ1->(eof()) .and. Z1_FILIAL == xFilial("SZ1") .and. SZ1->Z1_OC == SZ8->Z8_OC
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Bypasso se o produto nao e vendavel                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SB1->B1_YVEND == "N"
				SZ1->(DbSkip())
				Loop
			EndIf
			If SZ1->Z1_QUANT > npedmaior
				npedmaior := SZ1->Z1_QUANT
				cpedmaior := SZ1->Z1_NUM
				cpeconv   := SB1->B1_CONV
			EndIf
			If  SZ1->Z1_UNID $ "SC,SA"
				_qtd_fat   := SZ1->Z1_QUANT
			Else
				_qtd_fat   := _peso_liq
			End
			If SZ1->Z1_UNID == "TL"
				npesoSZ1 += Round(_qtd_fat * 1000,2)
			ElseIf SZ1->Z1_UNID $ "SC,SA"
				npesoSZ1 += Round(_qtd_fat * SB1->B1_CONV,2)
			Else
				MsgBox("Atencao, a unidade de medida do produto utilizado no pedido "+SZ1->Z1_NUM+" nao esta preparado para conversao!","atencao","ALERT")
			EndIf
			SZ1->(DbSkip())
		EndDo

		wPedag := SZ8->Z8_PEDAGIO / _peso_liq //Calculo Pedagio
		SZ2->(DbSetOrder(1))
		lachou:=SZ2->(DbSeek(xFilial("SZ2")+SZ8->Z8_PLACA))
		If lachou
			If npesoSZ1 > SZ2->Z2_PESOTRA
				MsgBox("Atencao, o pedido "+cpedmaior+" foi dividido em 2 notas fiscais devido ao excesso de peso da Ordem de Carregamento","Atencao","ALERT")
				DbSelectArea("SZ1")
				DbSetOrder(1)
				If DbSeek(xFilial("SZ1")+cpedmaior)
					While !Reclock("SZ1",.f.);EndDo
					If SZ1->Z1_UNID == "TL"
						SZ1->Z1_QTENF:= _peso_liq - (Round((npesoSZ1 - SZ2->Z2_PESOTRA)/1000,2))
					ElseIf SZ1->Z1_UNID $ "SC,SA"
						SZ1->Z1_QTENF:= SZ1->Z1_QUANT - Int((npesoSZ1 - SZ2->Z2_PESOTRA)/cpeconv)
					EndIf
					MsUnlock()
				EndIf
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravar o faturamento                                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ldivide := .F.
		DbSelectArea("SZ1")
		DbSetOrder(8)
		DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
		Do while .not. eof() .and. Z1_FILIAL == xFilial("SZ1") .and. SZ1->Z1_OC == SZ8->Z8_OC

			SA1->(DbSetOrder(1))
			IF !SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
				ALERT(' CLIENTE:  '+SZ1->(Z1_CLIENTE+LOJA) + ' - '+ SZ1->Z1_NOMCLI )
				SZ1->(DBSKIP())
				LOOP
			ENDIF


			If SZ1->Z1_QTENF > 0
				If ldivide == .f.
					While !Reclock("SZ1",.f.);EndDo
					If SZ1->Z1_UNID $ "SC,SA"
						SZ1->Z1_QUANT := SZ1->Z1_QUANT - SZ1->Z1_QTENF
					Else
						SZ1->Z1_QUANT := _peso_liq - SZ1->Z1_QTENF
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Fazer com que a 2a NF tenha pelo mais de uma tonelada - 15/10/02         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SZ1->Z1_QUANT < 1
							SZ1->Z1_QTENF :=  SZ1->Z1_QTENF - 1
							SZ1->Z1_QUANT :=  SZ1->Z1_QUANT + 1
						EndIf
					EndIf
					MsUnlock()
					_qtd_fat   := SZ1->Z1_QUANT
				ElseIf ldivide == .t.
					nqteant1 := SZ1->Z1_QUANT
					nqteant2 := SZ1->Z1_QTENF
					While !Reclock("SZ1",.f.);EndDo
					SZ1->Z1_QUANT := nqteant2
					SZ1->Z1_QTENF := nqteant1
					MsUnlock()
					_qtd_fat   := SZ1->Z1_QUANT
				EndIf
			Else
				If  SZ1->Z1_UNID $ "SC,UN,SA"
					_qtd_fat   := SZ1->Z1_QUANT
				Else
					_qtd_fat   := _peso_liq
					While !Reclock("SZ1",.f.);EndDo
					SZ1->Z1_QUANT := _peso_liq
					MsUnlock()
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz Ajuste no frete PARA UM = "TL"                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
			If SZ1->Z1_UNID == "TL" .and. nvalf == 0 .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
				SZG->(DbSetOrder(1))
				SZG->(DbSeek(xFilial("SZG")+SZ1->Z1_UFE+SZ1->Z1_MUNE+SZ1->Z1_FORNECE+SZ1->Z1_LOJAF + "L"))
				SZ3->(DbSetOrder(1))
				SZ3->(DbSeek(xFilial("SZ3")+SZ1->Z1_MOTOR))
				While !Reclock("SZ1",.f.);EndDo
				If SZ3->Z3_TIPO == "2"
					SZ1->Z1_FMOT := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZG->ZG_VALOR,2))
				Else
					SZ1->Z1_FTRA := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZG->ZG_VALOR,2))
				EndIf
				MsUnlock()
			EndIf

			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
			If SZ1->Z1_UNID == "SA" .and. SZ1->Z1_FRETE == "C"
				SZG->(DbSetOrder(1))
				SZG->(DbSeek(xFilial("SZG")+SZ1->Z1_UFE+SZ1->Z1_MUNE+SZ1->Z1_FORNECE+SZ1->Z1_LOJAF + "L"))
				nSal2UM := IF(SB1->B1_TIPCONV=="D",_qtd_fat/SB1->B1_CONV,_qtd_fat/SB1->B1_CONV)
				If Reclock("SZ1" ,.f.)
					SZ1->Z1_FTRA := Round(nSal2UM * SZG->ZG_VALOR,2)
					MsUnlock()
				EndIf

				If SZ3->Z3_TIPO == "2"
					SZ1->Z1_FMOT := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZ4->Z4_FMOT,2))
					SZ1->Z1_FTRA := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZ4->Z4_FRETE,2))
				Else
					SZ1->Z1_FMOT := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZG->ZG_FMOT,2))
					SZ1->Z1_FTRA := Iif(SA1->A1_YFGRA > 0,Round(_qtd_fat * SA1->A1_YFGRA,2),Round(_qtd_fat * SZG->ZG_FRETE,2))
				EndIf
			EndIf

			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))
			If SB1->B1_YTRBIG > 0 .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
				SZ3->(DbSetOrder(1))
				SZ3->(DbSeek(xFilial("SZ3")+SZ1->Z1_MOTOR))
				SZ4->(DbSetOrder(1))
				SZ4->(DbSeek(xFilial("SZ4")+SZ1->Z1_UFE+SZ1->Z1_MUNE))
				While !Reclock("SZ1",.f.);EndDo
				If SZ3->Z3_AGREGA == "S"
					SZ1->Z1_FTRA := Round(_qtd_fat * SZ4->Z4_FAGRTRA * SB1->B1_YTRBIG,2)
					SZ1->Z1_FMOT := Round(_qtd_fat * SZ4->Z4_FAGRMOT  * SB1->B1_YTRBIG,2)
				Else
					SZ1->Z1_FTRA := Round(_qtd_fat * SZ4->Z4_FRETE * SB1->B1_YTRBIG,2)
					SZ1->Z1_FMOT := Round(_qtd_fat * SZ4->Z4_FMOT  * SB1->B1_YTRBIG,2)
				EndIf
				MsUnlock()
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verificar EXCECAO de Frete                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SZJ->(DbSetOrder(1))
			lachou:=SZJ->(DbSeek(xFilial("SZJ")+SZ1->Z1_NUM))
			If lachou
				While !Reclock("SZ1",.f.);EndDo
				SZ1->Z1_FTRA := SZJ->ZJ_FTRA
				SZ1->Z1_FMOT := SZJ->ZJ_FMOT
				MsUnlock()
			EndIf
			_tes   := SZ1->Z1_TES
			_reg   := Recno()

			Val_nf()

			dbSelectArea("SZ1")
			Reclock ("SZ1",.F.)
			SZ1->Z1_PSSAI    := _peso_liqcalc

			If ldivide == .F.
				SZ1->Z1_NUMNF    := _nf
			Else
				SZ1->Z1_NUMNF2   := _nf
			EndIf
			_DtLib           := SZ1->Z1_YDTLIB
			SZ1->Z1_SERIE    := _serie
			SZ1->Z1_DTSAIDA  := _DtSaida
			SZ1->Z1_HORSAI   := _hora
			if laltlacre
				SZ1->Z1_LACRE    := _lacre
			endif
			SZ1->Z1_PREFIXO  := _prefixo
			msUnlock()

			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acessa SB2 - Saldos Fisico e Financeiro                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB2")
			dbSetOrder(1)
			dbSeek(xFilial("SB2")+SZ1->Z1_PRODUTO+SB1->B1_LOCPAD)
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
			dbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA)

			If SA1->A1_TIPO == "F" .And. SA1->A1_CONTRIB == "2" .And. SA1->A1_EST <> SM0->M0_ESTCOB // INCLUIDO POR ALEXANDRO EM 17/02/16 - PARA ATENDER EC 87/2015
				wAliqIcm := 0
			Else
				//If cEmpAnt == "40"
				SF7->(dbSetOrder(3))
				If SF7->(dbSeek(xFilial("SF7")+SB1->B1_GRTRIB + SA1->A1_GRPTRIB + SA1->A1_EST))
					wAliqIcm := SF7->F7_ALIQEXT
				Else
					wAliqIcm := 0
				Endif
				//Else
				//	dbSelectArea("SF7")
				//	dbSetOrder(2)
				//	If dbSeek(xFilial("SF7")+PADR(SA1->A1_GRPTRIB,6)+SA1->A1_EST,.F.)
				//		wAliqIcm := SF7->F7_ALIQEXT
				//	Else
				//		wAliqIcm := 0
				//	Endif
				//Endif	//desabilitado por Marcus Vinicius 15/07/16

				If !Empty(SZ1->Z1_GRTR)
					dbSelectArea("SF7")
					dbSetOrder(2)
					If dbSeek(xFilial("SF7")+PADR(SZ1->Z1_GRTR,6)+SA1->A1_EST,.F.)
						wAliqIcm := F7_ALIQEXT
					Else
						wAliqIcm := 0
					EndIf
				Endif
			Endif

			dbSelectArea("SZ2")
			dbSetOrder(1)
			dbSeek(xFilial()+SZ1->Z1_PLACA)

			/*
			_picm     := AliqIcms("N",;  // Tipo de Operacao
			"S",;  // Tipo de Nota ('E'ntrada/'S'aida)
			"C" ;  // Tipo do Cliente ou Fornecedor
			)
			*/
			_picm     := PICM("N",;  // Tipo de Operacao
			"S",;  // Tipo de Nota ('E'ntrada/'S'aida)
			"C" ;  // Tipo do Cliente ou Fornecedor
			)

			_estado   := alltrim(getmv("MV_ESTADO"))
			_piss     := getmv("MV_ALIQISS")

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))

			If Alltrim(SB1->B1_TIPCAR) == "S"
				_nQtde   := (SZ1->Z1_QUANT * SB1->B1_CONV) / 1000
				_nQtdeNf := (SZ1->Z1_QTENF * SB1->B1_CONV) / 1000
			Else
				_nQtde   := SZ1->Z1_QUANT
				_nQtdenF := SZ1->Z1_QTENF
			Endif

			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek(xFilial("SZ3")+SZ1->Z1_MOTOR))
			If _nQtdenF >0 .and. SB1->B1_YTRBIG==0 .and. SZ1->Z1_UNID $ "SC"
				_vlfre    := Iif(SZ3->Z3_TIPO=="2",(SZ1->Z1_FMOT * _nQtde)/(_nQtde + _nQtdenF),(SZ1->Z1_FTRA * _nQtde)/(_nQtde + _nQtdenF))
			Else
				_vlfre    := Iif(SZ3->Z3_TIPO=="2",SZ1->Z1_FMOT,SZ1->Z1_FTRA)
			EndIf
			_aest     := SA1->A1_EST
			_GrpTrib  := SA1->A1_GRPTRIB
			_amun     := alltrim(SA1->A1_MUN)

			SZM->(DbSetOrder(1))
			lachou := SZM->(DbSeek(xFilial("SZM")+SZ1->Z1_NUM))
			If lachou
				While !Reclock("SZ1",.F.)
					SZ1->Z1_PCOREF := SZM->ZM_VALOR
					MsUnlock()
				EndDo
			EndIf

			_prcven   := SZ1->Z1_PCOREF
			_opcao    := "2"
			_prfim    := SZ1->Z1_PCOREF

			_f4redicm := SF4->F4_BASEICM
			_f4ipi    := SF4->F4_IPI
			_ipi      := SB1->B1_IPI
			_f4ipifr  := SF4->F4_IPIFRET

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))

			If Alltrim(SB1->B1_TIPCAR) == "S"
				_nQtde   := (SZ1->Z1_QUANT * SB1->B1_CONV) / 1000
				_nQtdeNf := (SZ1->Z1_QTENF * SB1->B1_CONV) / 1000
			Else
				_nQtde   := SZ1->Z1_QUANT
				_nQtdenF := SZ1->Z1_QTENF
			Endif

			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek(xFilial("SZ3")+SZ1->Z1_MOTOR))
			If SB1->B1_YTRBIG==0 .and. SZ1->Z1_UNID $ "SC,SA"
				_baseipiF := Iif(SZ3->Z3_TIPO=="2",(SZ1->Z1_FMOT * _nQtde)/(_nQtde + _nQtdenF),(SZ1->Z1_FTRA * _nQtde)/(_nQtde + _nQtdenF))
			Else
				_baseipiF := Iif(SZ3->Z3_TIPO=="2",(SZ1->Z1_FMOT * _nQtde)/(_nQtde + _nQtdenF),(SZ1->Z1_FTRA * _nQtde)/(_nQtde + _nQtdenF))
			EndIf
			_f4incide := SF4->F4_INCIDE
			_f4icm    := SF4->F4_ICM
			_a1tipo   := SA1->A1_TIPO

			If SA1->A1_TIPO == "F" .And. SA1->A1_CONTRIB == "2" .And. SA1->A1_EST <> SM0->M0_ESTCOB // INCLUIDO POR ALEXANDRO EM 17/02/16 - PARA ATENDER EC 87/2015
				_b1PicRet := 0
			Else
				//If cEmpAnt == "30"
				If cEmpAnt + cFilAnt $ '0210|3001'
					If SA1->A1_EST <> SM0->M0_ESTCOB .And. SB1->B1_YMVAICM > 0
						//	_b1PicRet := SB1->B1_YMVAICM / 100   //0.2723 //

						// INCLUIDO NOVA REGRA EM 01/08/16

						SF7->(dbSetOrder(2))
						If SF7->(dbSeek(xFilial("SF7") + SB1->B1_GRTRIB + SA1->A1_EST))
							_b1PicRet := SF7->F7_MARGEM / 100
						Else
							_b1PicRet := 0.20
						Endif
						// INCLUIDO NOVA REGRA EM 01/08/16
					Else
						_b1PicRet := SB1->B1_PICMRET
					Endif
				Else
					_b1PicRet := SB1->B1_PICMRET
				Endif
			Endif

			_qtde     := _qtd_fat

			aVetor   := {_opcao,;
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
			SZ1->Z1_UNID,;
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

			//If cEmpAnt != "40"   Comentado por Alison - 12/09/2016
			If !(cEmpAnt + cFilAnt) $ '0203|4001'
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
				_total   := Round(_qtd_fat * _prcven,2)

			Else

				_valipi  := aVetor[2]
				_valicm  := aVetor[3]
				_picm    := aVetor[4]
				_prcUni  := aVetor[1]

				//If cEmpAnt + cFilAnt $ "0203|4001" .And. _lZFM
				If cEmpAnt + cFilAnt $ "0203|0210" .And. _lZFM
					_prcven  := ( (_qtd_fat * aVetor[1])- aVetor[3] ) / _qtd_fat
				Else
					_prcven  := aVetor[1]
				Endif
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
				_total   := _qtd_fat * _prcven
			Endif

			_cPedVen := SZ1->Z1_NUM
			_cNFVen  := _nf
			dbSelectArea("SD2")
			Reclock ("SD2",.T.)
			SD2->D2_FILIAL  := xFilial("SD2")
			SD2->D2_COD     := SZ1->Z1_PRODUTO
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
			SD2->D2_VALIPI  := _valipi + _valipiF

			If SF4->F4_ICM == "S"
				SZ3->(DbSetOrder(1))
				lachou := SZ3->(DbSeek(xFilial("SZ3")+SZ1->Z1_MOTOR))
				If lachou
					If (cfilant =="01".and.Upper(Alltrim(SZ1->Z1_MUNE))=="VITORIA".and.Upper(Alltrim(SZ1->Z1_UFE))=="ES") .or. ;
					(cfilant$"02" .and.Upper(Alltrim(SZ1->Z1_MUNE))=="ITABORAI".and.Upper(Alltrim(SZ1->Z1_UFE))=="RJ") .or. ;
					(cfilant=="03".and.Upper(Alltrim(SZ1->Z1_MUNE))=="GOVERNADOR VALADARES".and.Upper(Alltrim(SZ1->Z1_UFE))=="MG") .or. ;
					(cfilant=="04".and.Upper(Alltrim(SZ1->Z1_MUNE))=="SAO PEDRO DA ALDEIA".and.Upper(Alltrim(SZ1->Z1_UFE))=="RJ") .or. ;
					(cfilant=="05".and.Upper(Alltrim(SZ1->Z1_MUNE))=="CAMPOS".and.Upper(Alltrim(SZ1->Z1_UFE))=="RJ") .OR. ;
					(cfilant=="06".and.Upper(Alltrim(SZ1->Z1_MUNE))=="ITABUNA".and.Upper(Alltrim(SZ1->Z1_UFE))=="BA") .OR. ;
					(cfilant=="08".and.Upper(Alltrim(SZ1->Z1_MUNE))=="LINHARES".and.Upper(Alltrim(SZ1->Z1_UFE))=="ES") .OR. ;
					(cfilant=="21".and.Upper(Alltrim(SZ1->Z1_MUNE))=="RIO DE JANEIRO".and.Upper(Alltrim(SZ1->Z1_UFE))=="RJ") .or.;
					(cfilant=="01".and.Upper(Alltrim(SZ1->Z1_MUNE))=="RIO DE JANEIRO".and.Upper(Alltrim(SZ1->Z1_UFE))=="RJ")
						If SZ3->Z3_AGREGA=="S" .and. SZ3->Z3_TIPO=="2"
							_icmfret := 0
							_bicmfre := 0
						EndIf
					ElseIf Upper(Alltrim(SZ1->Z1_UFE)) == Upper(Alltrim(SM0->M0_ESTCOB)) .and. SZ3->Z3_AGREGA=="S" .and. SZ3->Z3_TIPO=="2"
						_icmfret := Round(_bicmfre * 12 /100,2)
						_bicmfre := 0
					EndIf
				EndIf

				//If (cEmpAnt + cFilAnt) $ "0203|4001"
				If (cEmpAnt + cFilAnt) $ "0203|0210"
					If _lZFM
						SD2->D2_DESCZFR := _valicm
						SD2->D2_VALICM  := 0
						SD2->D2_BASEICM := 0
					Else
						SD2->D2_VALICM  := _valicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03" .and. SA1->A1_YFICMS <> "S",_icmfret,0)
						SD2->D2_BASEICM := _baseicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03".and. SA1->A1_YFICMS <> "S",_bicmfre,0)
					Endif
				Else
					SD2->D2_VALICM  := _valicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03" .and. SA1->A1_YFICMS <> "S",_icmfret,0)
					SD2->D2_BASEICM := _baseicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03".and. SA1->A1_YFICMS <> "S",_bicmfre,0)
				Endif
			Else
				//If cEmpAnt + cFilAnt $ "0203|4001"
				If cEmpAnt + cFilAnt $ "0203|0210"
					If _lZFM
						SD2->D2_DESCZFR := _valicm
						SD2->D2_VALICM  := 0
						SD2->D2_BASEICM := 0
					Else
						SD2->D2_VALICM  := _valicm
						SD2->D2_BASEICM := _baseicm
					Endif
				Else
					SD2->D2_VALICM  := _valicm
					SD2->D2_BASEICM := _baseicm
				Endif
			EndIf

			If SZ3->Z3_TIPO == "2" .and. _icmsret > 0  .and. cfilant <> "03"
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
			SD2->D2_PEDIDO  := SZ1->Z1_NUM
			SD2->D2_ITEMPV  := "01"
			SD2->D2_CLIENTE := SZ1->Z1_CLIENTE
			SD2->D2_LOJA    := SZ1->Z1_LOJA
			SD2->D2_LOCAL   := SB1->B1_LOCPAD
			SD2->D2_DOC     := _nf
			SD2->D2_EMISSAO := ddatabase
			SD2->D2_DTDIGIT := ddatabase
			SD2->D2_GRUPO   := SB1->B1_GRUPO
			SD2->D2_TP      := SB1->B1_TIPO
			SD2->D2_SERIE   := _serie
			SD2->D2_CUSTO1  := _qtd_fat * SB2->B2_CM1

			//If cEmpAnt + cFilAnt $ "0203|4001"
			If cEmpAnt + cFilAnt $ "0203|0210"
				If _lZFM
					SD2->D2_PRUNIT  := _prcUni
				Else
					SD2->D2_PRUNIT  := _prcven
				Endif
			Else
				SD2->D2_PRUNIT  := _prcven
			Endif

			SD2->D2_QTSEGUM := _qtd_fat * SB1->B1_CONV
			SD2->D2_NUMSEQ  := ProxNum() //strzero(_numseq,6)
			SD2->D2_EST     := SA1->A1_EST
			SD2->D2_DESCON  := 0
			SD2->D2_TIPO    := "N"
			SD2->D2_ITEM    := "01"
			SD2->D2_COMIS1  := 0          // % DE COMISSAO DO VENDEDOR - DEFINIR REGRA

			If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
				_nQtde   := (SZ1->Z1_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
				_nQtdeNf := (SZ1->Z1_QTENF * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
			Else												  //// ALTERADO 11/01/12
				_nQtde   := SZ1->Z1_QUANT 						  //// ALTERADO 11/01/12
				_nQtdenF := SZ1->Z1_QTENF 						  //// ALTERADO 11/01/12
			Endif												  //// ALTERADO 11/01/12

			If _nQtdenF > 0 .and. SB1->B1_YTRBIG==0 .and. SZ1->Z1_UNID $ "SC"
				SD2->D2_VALFRE := Iif(SZ3->Z3_TIPO=="2",(SZ1->Z1_FMOT * _nQtde)/(_nQtde + _nQtdenF),(SZ1->Z1_FTRA * _nQtde)/(_nQtde + _nQtdenF))
			Else
				SD2->D2_VALFRE := Iif(SZ3->Z3_TIPO=="2",SZ1->Z1_FMOT,SZ1->Z1_FTRA)
			EndIf
			SD2->D2_BASEIPI := _baseipi + _baseipiF

			ZZA->(DbSetOrder(1))
			ZZA->(DbSeek(SD2->D2_LOJA+"11             "))
			SD2->D2_YCUSTRA := Val(ZZA->ZZA_CONTEU)

			ZZA->(DbSetOrder(1))
			ZZA->(DbSeek(xFilial("ZZA")+"10             "))
			SD2->D2_YCSTSAC := Val(ZZA->ZZA_CONTEU)

			If SA1->A1_TIPO == "F" .And. SA1->A1_CONTRIB == "2" .And. SA1->A1_EST <> SM0->M0_ESTCOB // INCLUIDO POR ALEXANDRO EM 17/02/16 - PARA ATENDER EC 87/2015
				_icmsret := 0
				_bricms	 := 0
			Else
				If _icmsret == 0 .and. SA1->A1_YDIFALI == "S" .and. Alltrim(SA1->A1_ATIVIDA) $ "36"
					_bricms  := (_baseicm + Iif(SZ3->Z3_TIPO=="2",0,0))//+SD2->D2_VALFRE ALTERADO EM 03/10/14
					_icmsret := Round(_bricms*(_picmest - (_picm/100)),2)
				EndIf
			Endif

			SD2->D2_BRICMS  := _bricms
			SD2->D2_ALIQSOL := _picmret        // Marcus Vinícius - 16/09/2016 - Alimenta o conteúdo da tag <PICMSST> no xml conforme solicitado no chamado 27390
			SD2->D2_ICMSRET := _icmsret

			_nPreco := 0
			ZA2->(dbSetOrder(3))
			If ZA2->(dbSeek(xFilial("ZA2")+SZ1->Z1_CLIENTE + SZ1->Z1_LOJA  + SZ1->Z1_OBRA + SZ1->Z1_PRODUTO+"L"))
				_nPreco := ZA2->ZA2_PRCGER
			Endif

			If _nPreco = 0
				dbSelectArea("SZI")
				SZI->(dbSetOrder(1))
				If SZI->(dbSeek(xFilial("SZI")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA+SZ1->Z1_PRODUTO+"L")) .AND. !EMPTY(SZI->ZI_PRCUNIT)
					_nPreco :=  SZI->ZI_PGER
				EndIf
			Endif

			SD2->D2_YPRG := _nPreco

			SB1->(DbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))
			SD2->D2_YCUSTO  := SB2->B2_YCUSTO
			SD2->D2_ROTINA  := AllTrim(Funname())
			SD2->D2_CLASFIS := SB1->B1_ORIGEM+SF4->F4_SITTRIB

			If SD2->D2_VALICM > 0
				If SA1->A1_TIPO == "F" .And. SA1->A1_CONTRIB == "2" .And. SA1->A1_EST <> SM0->M0_ESTCOB // INCLUIDO POR ALEXANDRO EM 17/02/16 - PARA ATENDER EC 87/2015

					_nAno           := YEAR(dDataBase)
					_aAlqDIFAL      := &(GETMV("MV_PPDIFAL"))
					_nAliqDes       := _aAlqDIFAL[ASCAN(_aAlqDIFAL,{|x| x[1] == _nAno})][2] // 40
					_nAliqOri       := _aAlqDIFAL[ASCAN(_aAlqDIFAL,{|x| x[1] == _nAno})][3] // 60

					_nFECP          := 0
					CFC->(dbSetorder(1))
					If CFC->(dbSeek(xFilial("CFC")+GETMV("MV_ESTADO") + SA1->A1_EST ))
						_nFECP := CFC->CFC_ALQFCP
					Endif

					SD2->D2_ALFCCMP := _nFECP
					SD2->D2_PDORI	:= _nAliqOri
					SD2->D2_PDDES   := _nAliqDes
					SD2->D2_BASEDES := SD2->D2_BASEICM

					If SA1->A1_EST == "RO"
						_nAliqInt   := Val(Subs(GETMV("MV_ESTICM"),AT(SA1->A1_EST,GETMV("MV_ESTICM"))+2,5))
					Else
						_nAliqInt   := Val(Subs(GETMV("MV_ESTICM"),AT(SA1->A1_EST,GETMV("MV_ESTICM"))+2,2))
					Endif

					_nDifAliq       := _nAliqInt - SD2->D2_PICM// - _nFECP

					_nIcmNovo       := SD2->D2_BASEDES * (_nDifAliq /100)

					SD2->D2_ALIQCMP := _nAliqInt              // ALTERADO EM 05/09/16
					//SD2->D2_ALIQCMP := _nAliqInt  - _nFECP  // ALTERADO EM 20/07/16
					SD2->D2_ICMSCOM := _nIcmNovo * (SD2->D2_PDORI / 100)
					SD2->D2_DIFAL   := _nIcmNovo * (SD2->D2_PDDES / 100)
					SD2->D2_VFCPDIF := SD2->D2_BASEDES * (_nFECP  / 100)
				Endif
			Endif

			msUnlock()
			dbCommit()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava SF2 - Cabecalho da NF Saida                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If _nQtdeNf >0 .and. SB1->B1_YTRBIG==0 .and. SZ1->Z1_UNID $ "SC,SA"
				_valtot := _total +  _icmsret + _valipi + _valipiF + Iif(SZ3->Z3_TIPO=="2",(SZ1->Z1_FMOT * _nQtde)/(_nQtde + _nQtdeNf),(SZ1->Z1_FTRA * _nQtde)/(_nQtde + _nQtdeNf))
			Else
				_valtot := _total +  _icmsret + _valipi + _valipiF + Iif(SZ3->Z3_TIPO=="2",SZ1->Z1_FMOT,SZ1->Z1_FTRA)
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
			SF2->F2_CLIENTE := SZ1->Z1_CLIENTE
			SF2->F2_LOJA    := SZ1->Z1_LOJA
			SF2->F2_CLIENT  := SZ1->Z1_CLIENTE
			SF2->F2_LOJENT  := SZ1->Z1_LOJA
			SF2->F2_MOEDA   := 1
			SF2->F2_COND    := SZ1->Z1_COND
			SF2->F2_DUPL    := _nf
			SF2->F2_EMISSAO := ddatabase
			SF2->F2_EST     := SA1->A1_EST
			cDoc            := SF2->F2_DOC
			cSerie          := SF2->F2_SERIE
			cCliente        := SF2->F2_CLIENTE
			cLoja           := SF2->F2_LOJA

			If _nQtdeNf > 0 .and. SB1->B1_YTRBIG==0 .and. SZ1->Z1_UNID $ "SC"
				SF2->F2_FRETE   := Iif(SZ3->Z3_TIPO=="2",(SZ1->Z1_FMOT * _nQtde)/(_nQtde + _nQtdeNf),(SZ1->Z1_FTRA * _nQtde)/(_nQtde + _nQtdeNf))
				SF2->F2_FRFIXO  := SF2->F2_FRETE
			Else
				SF2->F2_FRETE   := Iif(SZ3->Z3_TIPO=="2",SZ1->Z1_FMOT,SZ1->Z1_FTRA)
				SF2->F2_FRFIXO  := POSICIONE('SZG',1,xFilial("SZG")+SZ1->Z1_UFE+SZ1->Z1_MUNE+SZ1->Z1_FORNECE+SZ1->Z1_LOJAF,"ZG_FRFIXO")
				If Empty(SF2->F2_FRFIXO)
					SF2->F2_FRFIXO  := POSICIONE('SZG',1,xFilial("SZG")+SZ1->Z1_UFE+SZ1->Z1_MUNE+SZ1->Z1_FORNECE+SZ1->Z1_LOJAF,"ZG_VALOR")
				Endif
			EndIf
			SF2->F2_ICMFRET := _icmfret
			SF2->F2_TIPOCLI := SA1->A1_TIPO
			SF2->F2_VALBRUT := _valtot

			//If cEmpAnt + cFilAnt $ "0203|4001"
			If cEmpAnt + cFilAnt $ "0203|0210"
				If _lZFM
					SF2->F2_DESCZFR := _valicm
					SF2->F2_VALICM  := 0
					SF2->F2_BASEICM := 0
				Else
					SF2->F2_VALICM  := _valicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03".and. SA1->A1_YFICMS <> "S",_icmfret,0)
					SF2->F2_BASEICM := _baseicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03".and. SA1->A1_YFICMS <> "S",_bicmfre,0)
				Endif
			Else
				SF2->F2_VALICM  := _valicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03".and. SA1->A1_YFICMS <> "S",_icmfret,0)
				SF2->F2_BASEICM := _baseicm + Iif(SZ3->Z3_TIPO=="2" .and. cfilant <> "03".and. SA1->A1_YFICMS <> "S",_bicmfre,0)
			Endif

			SF2->F2_VALIPI  := _valipi + _valipiF
			SF2->F2_BASEIPI := _baseipi + _baseipiF
			SF2->F2_VALMERC := _total
			SF2->F2_TIPO    := "N"
			SF2->F2_ICMSRET := _icmsret
			SF2->F2_PLIQUI  := Iif(SB1->B1_UM $ "SC,SA",Round(_qtd_fat/(1000/SB1->B1_CONV),4),_qtd_fat)
			SF2->F2_PBRUTO  := SF2->F2_PLIQUI
			If ! Empty(SZ1->Z1_FORNECE)
				SF2->F2_TRANSP  := SZ1->Z1_FORNECE
			Else
				SF2->F2_TRANSP  := SZ2->Z2_TRAN
			EndIf
			SF2->F2_VEND1   := SZ1->Z1_VEND
			SF2->F2_BASEISS := _baseiss
			SF2->F2_VALISS  := _valiss
			SF2->F2_VALFAT  := _valtot
			SF2->F2_BRICMS  := _bricms
			SF2->F2_ESPECIE := A460Especie(_Serie)
			SF2->F2_YMOTOR  := SZ1->Z1_MOTOR
			SZ4->(DbSetOrder(1))
			SZ4->(DbSeek(xFilial("SZ4")+SZ1->Z1_UFE+SZ1->Z1_MUNE))
			SF2->F2_YDIST   := SZ4->Z4_DIST
			SF2->F2_YFRETE  := SZ1->Z1_FRETE
			SF2->F2_YOC     := SZ1->Z1_OC
			SF2->F2_YMUNE   := SZ1->Z1_MUNE
			SF2->F2_YUFE    := SZ1->Z1_UFE
			SF2->F2_YPLACA	:= SZ1->Z1_PLACA
			SF2->F2_YPLCAR  := SZ1->Z1_PLCAR
			SF2->F2_HORA    := _cHora
			SF2->F2_ROTINA  := AllTrim(Funname())
			SF2->F2_YOBRA   := SZ1->Z1_OBRA
			SF2->F2_VEICUL1 := SZ1->Z1_PLACA

			// Marcus Vinicius - 14/09/2016 - Preenchimento da tag QVOL no XML, solicitado através do chamado 27338
			If TRIM(SB1->B1_UM) $ "TL|TN"
				SF2->F2_ESPECI1 := "VOLUME"
				SF2->F2_VOLUME1 := 1
			ELSEIF TRIM(SB1->B1_UM) $ "SC|SA"
				SF2->F2_ESPECI1 := "SACOS"
				SF2->F2_VOLUME1 := SD2->D2_QUANT
			ELSE
				SF2->F2_ESPECI1 := ""
				SF2->F2_VOLUME1 := 0
			ENDIF
			// Até aqui

			//Sergio(Semar)  Gravaçao dos Campos de MesoRegiao
			If cEmpAnt $ "01|02|12"
				if sz1->(fieldpos('Z1_YMESCR'))>0 .and.  sf2->(fieldpos('F2_YMESCR'))>0
					SF2->F2_YREGIA := SZ1->Z1_YREGIA
					SF2->F2_YMICRE := SZ1->Z1_YMICRE
					SF2->F2_YMESCR := SZ1->Z1_YMESCR
				endif
			EndIF


			msUnlock()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualizar SZ8                                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SZ8")
			While !Reclock("SZ8",.f.);EndDo
			SZ8->Z8_PSSAI   := _peso_sai
			if SZ8->(FieldPos("Z8_DTPSAI")) > 0; SZ8->Z8_DTPSAI := DATE(); endif
			//If cEmpAnt $ "30/40"		Comentado por Alison - 22/07/2016
			If cEmpAnt + cFilAnt $ '0210|3001|0203|4001'
				if SZ8->Z8_STATUS2 = "8"
					SZ8->Z8_STATUS2 := "9"
				else
					SZ8->Z8_STATUS2 := "9"	//Comentado e corrigdo por Rodrigo (Semar) - 01/08/16
					//SZ8->Z8_FATUR := "S"  //Descomentado linha acima e comentado essa linha por Rodrigo (semar) - 12/08/16
				endif
			else
				SZ8->Z8_FATUR := "S"
			endif
			SZ8->Z8_DTSAIDA := ddatabase
			SZ8->Z8_YPALT   := ypalt
			SZ8->Z8_HSAIDA  := left(time(),5)
			SZ8->Z8_PRODUTO := cprven
			SZ8->Z8_QUANT   := nqtven
			SZ8->Z8_YDTLIB  := _DtLib

			//if cEmpAnt $ "30"         Comentado por Alison - 22/07/2016
			If cEmpAnt + cFilAnt $ '0210|3001'
				if SZ8->Z8_STATUS2 != "9"
					SZ8->Z8_PAGER   := if(SuperGetMV("MV_SMULIBS",,.F.),SZ8->Z8_PAGER,'')
				endif
			else
				SZ8->Z8_PAGER   := if(SuperGetMV("MV_SMULIBS",,.F.),SZ8->Z8_PAGER,'')
			endif
			SZ8->Z8_COLESAI := cColeta
			if laltlacre
				SZ8->Z8_LACRE    := _lacre
			endif

			SZ8->&(cStat) := if(SuperGetMV("MV_VALDANF",,.F.),"B", 	SZ8->&(cStat))

			MsUnlock()

			//nbasecof := SF2->F2_VALBRUT - SF2->F2_VALIPI - SF2->F2_ICMSRET

			If cEmpAnt == "02" .And. SD2->D2_EMISSAO >= CTOD("01/04/17") // BENEFICIOS PARA POLIMIX A PARTIR DE 01/04/17
				nbasecof := SD2->D2_TOTAL + SD2->D2_VALFRE - SD2->D2_VALICM
			Else
				nbasecof := SD2->D2_TOTAL + SD2->D2_VALFRE
			Endif

			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))
			SED->(DbSetOrder(1))
			SED->(DbSeek(xFilial("SED")+SA1->A1_NATUREZ))
			If Reclock("SD2",.f.)
				If cEmpAnt + cFilAnt $ "0203"
					SF7->(dbSetOrder(3))
					If SF7->(dbSeek(xFilial("SF7")+SB1->B1_GRTRIB + SA1->A1_GRPTRIB + SA1->A1_EST))
						_nTxPIS	:= SF7->F7_ALIQPIS
						_nTxCOF	:= SF7->F7_ALIQCOF
					Else
						_nTxPIS	:= 	If (SB1->B1_PPIS    <> 0,SB1->B1_PPIS    ,SuperGetMV("MV_TXPIS"))
						_nTxCOF	:=	If (SB1->B1_PCOFINS <> 0,SB1->B1_PCOFINS ,SuperGetMV("MV_TXCOFIN"))
					Endif
				Else
					_nTxPIS	:= 	If (SB1->B1_PPIS    <> 0,SB1->B1_PPIS    ,SuperGetMV("MV_TXPIS"))
					_nTxCOF	:=	If (SB1->B1_PCOFINS <> 0,SB1->B1_PCOFINS ,SuperGetMV("MV_TXCOFIN"))
				Endif

				If SF4->F4_PISCOF == "1"
					SD2->D2_VALIMP6 := Round(nbasecof * _nTxPIS/100,2)
					SD2->D2_BASIMP6 := nbasecof
					SD2->D2_ALQIMP6 := _nTxPIS
				ElseIf SF4->F4_PISCOF == "2"
					SD2->D2_VALIMP5 := Round(nbasecof * _nTxCOF/100,2)
					SD2->D2_BASIMP5 := nbasecof
					SD2->D2_ALQIMP5 := _nTxCOF
				ElseIf SF4->F4_PISCOF == "3"
					SD2->D2_VALIMP6 := Round(nbasecof * _nTxPIS/100,2)
					SD2->D2_BASIMP6 := nbasecof
					SD2->D2_ALQIMP6 := _nTxPIS
					SD2->D2_VALIMP5 := Round(nbasecof * _nTxCOF/100,2)
					SD2->D2_BASIMP5 := nbasecof
					SD2->D2_ALQIMP5 := _nTxCOF
				Endif

				If cEmpAnt + cFilAnt $ "0203|0210"
					If _lZFM
						If SF4->F4_PISCOF <> "3"
							SD2->D2_VALIMP5 := nbasecof
							SD2->D2_VALIMP6 := nbasecof
						Endif
					Endif
				Endif

				SD2->D2_VALBRUT := _valtot

				_nAlqLeiTr := 0

				If SA1->A1_TIPO == "F" // Legislação aplicada apenas para cliente consumidor final

					cMvFisCTrb := SuperGetMv("MV_FISCTRB",.F.,"1")
					cMvFisAlCT := SuperGetMv("MV_FISALCT",.F.,"3")
					lMvFisFRas := SuperGetMv("MV_FISFRAS",.F.,.F.)

					_nAlqLeiTr := AlqLei2741(SB1->B1_POSIPI,SB1->B1_EX_NCM,SB1->B1_CODISS,SA1->A1_EST,SA1->A1_COD_MUN,SD2->D2_COD,SD2->D2_ITEM,"","",cMvFisCTrb, cMvFisAlCT,lMvFisFRas)

					If SUBSTR(SD2->D2_CLASFIS,2) =  "60"
						nTotAlq := (_nAlqLeiTr * SD2->D2_QUANT)
					Else
						nTotAlq := (_nAlqLeiTr / 100) * (SD2->D2_VALBRUT + SD2->D2_DESCON)
					Endif

					SD2->D2_TOTIMP := nTotAlq
				EndIf
			EndIf
			msUnlock()
			dbCommit()

			dbSelectArea("SF2")
			Reclock("SF2",.F.)
			SF2->F2_YPEDAG	:= Round(wPedag * SF2->F2_PBRUTO,2)
			SF2->F2_TOTIMP  := SD2->D2_TOTIMP
			SF2->F2_TIPIMP  := "1"
			MsUnlock()

			CTIPO    := "SF2"
			cDoc     := SF2->F2_DOC
			cSerie   := SF2->F2_SERIE
			cCliente := SF2->F2_CLIENTE
			cLoja    := SF2->F2_LOJA

			U_MIZ1100(CDOC,CSERIE,CCLIENTE,CLOJA,CTIPO)

			DbSelectArea("SA1")
			aArea := GetArea()
			DbSetOrder(1)
			If DbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA)

			endif

			dbCommit()

			aAreaSP     := GetArea()
			aOtimizacao := {}
			cAliasSP    := "SF2"
			cCNAE       := ""
			MaFisIniNF(2,SF2->(RecNo()),@aOtimizacao,cAliasSP,((cAliasSP)->F2_FIMP<>"S"))
			MaFisWrite()
			MaFisAtuSF3(1,"S",SF2->(RecNo()),"","",cCNAE)
			RestArea(aAreaSP)
			dbSelectArea("SF2")

			If SF4->F4_DUPLIC == "S"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula parcelas pela condicao de pagamento                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_aParc    := Array(9,2)
				_aParc    := {"A","B","C","D","E","F","G","H","I"}
				_aParcela := Condicao(_valtot,SZ1->Z1_COND,0,ddatabase)
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
					SE1->E1_FILORIG := SZ1->Z1_FILIAL
					SE1->E1_PREFIXO := _prefixo
					SE1->E1_NUM     := _nf
					SE1->E1_PARCELA := _aParc[i]
					SE1->E1_TIPO    := "NF"
					SE1->E1_NATUREZ := SA1->A1_NATUREZ
					SE1->E1_CLIENTE := SA1->A1_COD
					SE1->E1_LOJA    := SA1->A1_LOJA
					SE1->E1_NOMCLI  := SA1->A1_NREDUZ
					SE1->E1_EMISSAO := ddatabase
					If SZ1->Z1_COND == "050"
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
					SE1->E1_VEND1   := SZ1->Z1_VEND
					SE1->E1_COMIS1  := 0
					SE1->E1_VENCORI := _aParcela[i,1]
					SE1->E1_VALJUR  := round(_aParcela[i,2] * (_Taxa_Per / 100),2)
					SE1->E1_PORCJUR := _Taxa_Per
					SE1->E1_MOEDA   := 1
					SE1->E1_BASCOM1 := 0
					SE1->E1_VALCOM1 := 0
					SE1->E1_OCORREN := "01"
					SE1->E1_PEDIDO  := SZ1->Z1_NUM
					SE1->E1_VLCRUZ  := _aParcela[i,2]
					SE1->E1_STATUS  := "A"
					SE1->E1_ORIGEM  := "MIZ035"
					SE1->E1_SITUACA := "0"
					SE1->E1_PORTADO := IIF(!EMPTY(SA1->A1_BCO1),SA1->A1_BCO1,GETMV("MV_YBCOPAD"))
					IF SE1->E1_VENCTO > dDataBase+1
						SE1->E1_NUMBCO:= u_NossoNumero( SE1->E1_PORTADO )
					ENDIF

					MsUnLock()

				Next
				dbCommit()
			Endif
			If SF4->F4_ESTOQUE == "S"

				dbSelectArea("SB2")
				dbSetOrder(1)
				If  dbSeek(xFilial("SB2") + SZ1->Z1_PRODUTO + SB1->B1_LOCPAD)
					While ! Reclock("SB2",.F.) ; End
					SB2->B2_QATU  := SB2->B2_QATU - _qtd_fat
					SB2->B2_VATU1 := SB2->B2_CM1  * SB2->B2_QATU
					msUnLock()
					dbCommit()
				End
			Endif

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

			dbSelectArea("SX5")
			dbSetOrder(1)

			If UPPER(Alltrim(cUserName)) $ "ALE|FABIANO|ALISON"
				If .NOT. dbSeek(xFilial("SX5")+"01"+"ZZZ")
					help("Numero NF",1,"Y_MIZ035/"+"01"+"ZZZ")
				ELSE
					_nf := PADR(StrZero(val(_nf)+1,6),9)
					Reclock("SX5",.F.)
					SX5->X5_DESCRI := PADR(StrZero(Val(_nf),6),9)
					SX5->(MsUnlock())
					SX5->(dbCommit())
				ENDIF
			Else
				If .NOT. dbSeek(xFilial("SX5")+"01"+StrTran(PadR(getmv("MV_YSERIE"),3," "),"*"," "))
					help("Numero NF",1,"Y_MIZ035/"+"01"+StrTran(PadR(getmv("MV_YSERIE"),3," "),"*"," "))
				ELSE
					_nf := PADR(StrZero(val(_nf)+1,6),9)
					Reclock("SX5",.F.)
					SX5->X5_DESCRI := PADR(StrZero(Val(_nf),6),9)
					SX5->(MsUnlock())
					SX5->(dbCommit())
				ENDIF
			Endif

			aVetor := {_amun,_nf,Alltrim(SA1->A1_EST)}

			If SZ1->Z1_TRGR == "S"
				execblock("MIZ115",.F.,.F.,aVetor)
			EndIf

			dbCommitAll()

			If ldivide == .F.
				_numnfaux := SZ1->Z1_NUMNF
			Else
				_numnfaux := SZ1->Z1_NUMNF2
			EndIf

			_serie    := SZ1->Z1_SERIE

			If !Empty(_numnfaux)
				dbSelectArea("SZ7")
				DbSetOrder(1)
				If DbSeek(xFilial("SZ7")+SZ1->Z1_NUM)
					RecLock("SZ7",.f.)
					SZ7->Z7_NUMNF2  := SZ1->Z1_NUMNF2
					SZ7->Z7_QUANT   := SZ1->Z1_QUANT + SZ1->Z1_QTENF
					SZ7->Z7_LGAUSER := CUSERNAME
					If SB1->B1_UM == "TL"
					EndIf
				Else
					RecLock("SZ7",.T.)
					SZ7->Z7_FILIAL  := SZ1->Z1_FILIAL
					SZ7->Z7_NUM     := SZ1->Z1_NUM
					SZ7->Z7_CLIENTE := SZ1->Z1_CLIENTE
					SZ7->Z7_NOMCLI  := SZ1->Z1_NOMCLI
					SZ7->Z7_LOJA    := SZ1->Z1_LOJA
					SZ7->Z7_PRODUTO := SZ1->Z1_PRODUTO
					SZ7->Z7_QUANT   := SZ1->Z1_QUANT
					SZ7->Z7_UNID    := SZ1->Z1_UNID
					SZ7->Z7_PUNIT   := SZ1->Z1_PUNIT
					SZ7->Z7_PCDESC  := SZ1->Z1_PCDESC
					SZ7->Z7_VLDES   := SZ1->Z1_VLDES
					SZ7->Z7_VLLISTA := SZ1->Z1_VLLISTA
					SZ7->Z7_TES     := SZ1->Z1_TES
					SZ7->Z7_DTENT   := SZ1->Z1_DTENT
					SZ7->Z7_HORENTG := SZ1->Z1_HORENTG
					SZ7->Z7_LOCAL   := SZ1->Z1_LOCAL
					SZ7->Z7_FRETE   := SZ1->Z1_FRETE
					SZ7->Z7_COND    := SZ1->Z1_COND
					SZ7->Z7_VEND    := SZ1->Z1_VEND
					SZ7->Z7_YTELVEN := SZ1->Z1_YTELVEN
					SZ7->Z7_VLFRE   := SZ1->Z1_VLFRE
					SZ7->Z7_PALENT  := SZ1->Z1_PALENT
					SZ7->Z7_PALSAI  := SZ1->Z1_PALSAI
					SZ7->Z7_OBSER   := SZ1->Z1_OBSER
					SZ7->Z7_PSENT   := SZ1->Z1_PSENT
					SZ7->Z7_PLACA   := SZ1->Z1_PLACA
					SZ7->Z7_MOTOR   := SZ1->Z1_MOTOR
					SZ7->Z7_PSSAI   := SZ1->Z1_PSSAI
					SZ7->Z7_NUMNF   := SZ1->Z1_NUMNF
					SZ7->Z7_SERIE   := SZ1->Z1_SERIE
					SZ7->Z7_HORENT  := SZ1->Z1_HORENT
					SZ7->Z7_HORSAI  := SZ1->Z1_HORSAI
					SZ7->Z7_LIBER   := SZ1->Z1_LIBER
					SZ7->Z7_LACRE   := SZ1->Z1_LACRE
					SZ7->Z7_NMOT    := SZ1->Z1_NMOT
					SZ7->Z7_EMISSAO := SZ1->Z1_EMISSAO
					SZ7->Z7_RPA     := SZ1->Z1_RPA
					SZ7->Z7_PCOREF  := SZ1->Z1_PCOREF
					SZ7->Z7_HORAPED := SZ1->Z1_HORAPED
					SZ7->Z7_TRGR    := SZ1->Z1_TRGR
					SZ7->Z7_DTSAIDA := SZ1->Z1_DTSAIDA
					SZ7->Z7_NLIB    := SZ1->Z1_NLIB
					SZ7->Z7_HLIB    := SZ1->Z1_HLIB
					SZ7->Z7_YDTLIB  := SZ1->Z1_YDTLIB
					SZ7->Z7_USUARIO := SZ1->Z1_USUARIO
					SZ7->Z7_GRTR    := SZ1->Z1_GRTR
					SZ7->Z7_FTRA    := Iif(SZ3->Z3_TIPO=="2",SZ1->Z1_FMOT,SZ1->Z1_FTRA)
					SZ7->Z7_FMOT    := SZ1->Z1_FMOT
					SZ7->Z7_FORNECE := SZ1->Z1_FORNECE

					If Empty(SZ1->Z1_FORNECE) .AND. cEmpAnt + cFilAnt $ '0210|3001'
						SZ7->Z7_FORNECE  := SZ2->Z2_TRAN
					EndIf

					SZ7->Z7_LOJAF   := SZ1->Z1_LOJAF
					SZ7->Z7_YPM     := SZ8->Z8_PALLET
					SZ7->Z7_MUNE    := SZ1->Z1_MUNE
					SZ7->Z7_UFE     := SZ1->Z1_UFE
					SZ7->Z7_OC      := SZ1->Z1_OC
					SZ7->Z7_FMOTX   := SZ1->Z1_FMOTX
					SZ7->Z7_FTRAX   := SZ1->Z1_FTRAX
					SZ7->Z7_TPF     := SZ1->Z1_TPF
					SZ7->Z7_QTENF   := SZ1->Z1_QTENF
					SZ7->Z7_MENS01  := SZ1->Z1_MENS01
					SZ7->Z7_MENS02  := SZ1->Z1_MENS02
					SZ7->Z7_MENS03  := SZ1->Z1_MENS03
					SZ7->Z7_YTIPF   := SZ1->Z1_YTIPF
					SZ7->Z7_OBSA    := SZ1->Z1_OBSA
					SZ7->Z7_YTIPO   := SZ1->Z1_YTIPO
					SZ7->Z7_YPEDB   := SZ1->Z1_YPEDB
					SZ7->Z7_PLCAR   := SZ1->Z1_PLCAR
					SZ7->Z7_PREFIXO := SZ1->Z1_PREFIXO
					SZ7->Z7_COMDESC := SZ1->Z1_COMDESC
					SZ7->Z7_PALLET  := SZ1->Z1_PALLET
					SZ7->Z7_LGIUSER := CuSERNAME
					SZ7->Z7_LOCCARR := SZ8->Z8_LOCCARR
					SZ7->Z7_YAGREGA := SZ3->Z3_AGREGA
					SZ7->Z7_MUNFRT  := SZ1->Z1_MUNFRT
					SZ7->Z7_UFFRT 	:= SZ1->Z1_UFFRT
					If SZ7->(FieldPos("Z7_YOBRA")) > 0
						SZ7->Z7_YOBRA 	:= SZ1->Z1_OBRA
					EndIf
					SZ7->Z7_YPEDCOM	:= SZ1->Z1_YPEDCOM
					SZ7->Z7_YITEMPC	:= SZ1->Z1_YITEMPC

					If cEmpAnt $ "01|02|12"
						if sz1->(fieldpos('Z1_YMESCR'))>0 .and.  sz7->(fieldpos('Z7_YMESCR'))>0
							SZ7->Z7_YREGIA := SZ1->Z1_YREGIA
							SZ7->Z7_YMICRE := SZ1->Z1_YMICRE
							SZ7->Z7_YMESCR := SZ1->Z1_YMESCR
						endif
					EndIf

					If SZ1->(Fieldpos("Z1_YCDPALM")) > 0 .And. SZ7->(Fieldpos("Z7_YCDPALM")) > 0
						SZ7->Z7_YCDPALM := SZ1->Z1_YCDPALM
						SZ7->Z7_YDTIMPR := SZ1->Z1_YDTIMPR
						SZ7->Z7_YITPPAL := SZ1->Z1_YITPPAL
						SZ7->Z7_YORIGPD := SZ1->Z1_YORIGPD
					Endif

				EndIf
				MsUnLock()
			EndIf

			DbSelectArea("SZ1")
			If  Recno() <> _reg
				Alert("O SZ1 FOI DISPOSICIONADO")
			EndIf
			If SZ1->Z1_QTENF > 0 .and. ldivide == .F.
				ldivide := .T.
				Loop
			EndIf
			DbSkip()
			ldivide := .F.
		EndDo

		DbSelectArea("SZ1")
		DbSetOrder(8)
		DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
		Do while .not. eof() .and. Z1_FILIAL==xFilial("SZ1") .and. SZ1->Z1_OC == SZ8->Z8_OC
			While !RecLock("SZ1",.f.);EndDo
			Delete
			MsUnLock()
			DbSkip()
		EndDo

		IF SE1->E1_VENCTO > SE1->E1_EMISSAO .AND. SZ7->Z7_COND<>'100'	  //MARCUS VINICIUS - 10/02/16
			DbSelectArea("SZ7")
			DbSetOrder(8)
			DbSeek(xFilial("SZ7")+SZ8->Z8_OC)
			Do while .not. eof() .and. Z7_FILIAL==xFilial("SZ7") .and. SZ7->Z7_OC == SZ8->Z8_OC
				Do Case
					Case ( sm0->m0_codigo == '01' .and. SM0->M0_CODFIL $ "01,04,06,08,09,21") .or. ( sm0->m0_codigo $  "02,10,11,12,20,30,40" ) // .and. SM0->M0_CODFIL $ "01")

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
		DbSeek(xFilial("SZ7")+SZ8->Z8_OC)
		Do while .not. eof() .and. Z7_FILIAL==xFilial("SZ7") .and. SZ7->Z7_OC == SZ8->Z8_OC
			dbSelectArea("SX1")
			dbSetOrder(1)
			If  dbSeek(PADR("MIZ100",10))
				While ! RecLock("SX1",.F.) ; End
				SX1->X1_CNT01 := SZ7->Z7_NUMNF
				msUnlock()
				dbCommit()
			EndIf

			If  cEmpAnt+cFilAnt $ "1101|0213"
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

	IF SZ1->Z1_FRETE == "C"

		DbSelectArea("SZ7")
		DbSetOrder(8)
		DbSeek(xFilial("SZ7")+SZ8->Z8_OC)
		ldivide := .F.
		aenvio :={}
		Do while .not. eof() .and. Z7_FILIAL==xFilial("SZ7") .and. SZ7->Z7_OC == SZ8->Z8_OC
			If SZ3->Z3_TIPO == "2"
				DbSelectArea("SX1")
				DbSetOrder(1)
				If  dbSeek("MIZ100")
					While ! RecLock("SX1",.F.) ; End
					If ldivide == .F.
						SX1->X1_CNT01 := SZ7->Z7_NUMNF
					Else
						SX1->X1_CNT01 := SZ7->Z7_NUMNF2
					EndIf
					msUnlock()
					dbCommit()
				EndIf
				Execblock("MIZ100",.F.,.F.,_amun)
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

	DbSelectArea("SZ7")
	DbSetOrder(8)
	DbSeek(xFilial("SZ7")+SZ8->Z8_OC)
	Do while .not. eof() .and. Z7_FILIAL==xFilial("SZ7") .and. SZ7->Z7_OC == SZ8->Z8_OC
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

	if IsInCallStack("U_MIZ999") .and. _lTicket
		warea:= getarea()
		U_RTICKET(SZ8->Z8_OC)
		restArea(warea)
	endif

	If !IsInCallStack("U_MIZ999")
		ExecBlock("MIZ027",.F.,.F.)
	EndIf

	dDataBase := _dDatBkp  // HORARIO DE VERAO

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
	*----------------------------------------------------------------------------------------------------------------------------
	*---------------------------------------------------------------------------------------------------------------------
Static Function fPesoBal()
	local lRet:= .f.
	private nHdll := 0
	private cText := ''
	private ComEnt := GetMv("MV_YCOMSAI")

	if MsOpenPort(nHdll,ComEnt)
		//if MsOpenPort(nHdll,+'"'+GetMv("MV_YCOMENT")+'"')
		//If MsOpenPort(nHdll,"COM1:4800,E,8,2")
		//apmsgalert('lendo peso balança')
		Inkey(0.4)
		IF	MSRead(nHdll,@cText)
			nVez:=1
			while .t.
				nVez+=1
				if SM0->M0_CODFIL == "21" .or. ( sm0->m0_codigo $ '02/20' .and. sm0->m0_codfil $ '01/22')
					_peso_sai := VAL(alltrim(substr(cText ,at(" ",cText)+1,12)))/100  //PesoContinuo()
				else
					_peso_sai := VAL(alltrim(substr(cText ,at(" ",cText)+1,8)))/100  //PesoContinuo()
				endif
				cText := substr(cText ,at(" ",cText))
				if _peso_sai > 0 .or. nVez > 10
					exit
				elseif Mod(10,5) == 0
					nHdll := 0
					cText := ''
					MsClosePort(nHdll)
					MSRead(nHdll,@cText)
				endif
			enddo
		else
			apmsgalert('não foi possível ler a COM')
			lret:=.f.
		ENDIF

		MsClosePort(nHdll)
	else
		apmsgalert('não foi possível abrir a COM')
		lret:=.f.
	endif

Return( _peso_sai )


user Function frmDadosNF(p_cOrigem,p_cOC)

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de cVariable dos componentes                                 ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	if p_cOrigem=='MIZ035'
		Private cendCli    := space(1)
		Private cestCli    := space(1)
		Private cGet_dtsai := _DtSaida
		Private cGet_endCl := _localcli
		Private cGet_estCl := _ufCli
		Private cGet_hrsai := _hora
		Private cGet_nomCl := _nomCli
		Private cGet_nota  := _nf
		//Private cGet_nrLac := _lacre
		Private cGet_nrLac := sz8->z8_lacre
		Private _lacre	   := sz8->z8_lacre
		Private cGet_prefi := _prefixo
		Private cGet_psent := trans(_peso_ent    ,"@E 999,999,999.99")
		Private cGet_pssai := trans(_peso_sai    ,"@E 999,999,999.99")
		Private cGet_pliqu := trans(_peso_liq,"@E 999,999,999.99")
		Private cGet_sacos := trans(_qtd_fat,"@E 999,999")
		Private cGet_serie := _serie
		Private cGet_vlrpe := Transform(SZ8->Z8_PEDAGIO,"@E 9,999.99")
		Private cGet_frete := trans( nF2FRETE ,"@E 9,999,999.99")
	elseif p_cOrigem=='SMGRAFICO'

		sz8->(dbsetorder(1))
		sz8->(dbSeek(xFilial("SZ8")+p_cOc))

		lcarreg:= ( sz8->z8_tpoper=="C" )

		_peso_liqcalc := (sz8->z8_pssai - sz8->z8_psent)
		_peso_liqcalc := iif( sz8->z8_tpoper=="D", _peso_liqcalc *-1, _peso_liqcalc )

		if lcarreg
			sz7->(DbSetOrder(8))
			sz7->(DbSeek(xFilial("SZ7")+p_cOC))

			If  sZ7->Z7_unid = "TL"
				_peso_liqcalc := _peso_liqcalc / 1000
			End
		else
			sa2->(dbsetOrder(1))
			sa2->(dbseek( xfilial('SA2')+sz8->(z8_fornece+z8_lojafor)   ))

		endif

		_peso_liq      := _peso_liqcalc

		Private cendCli    := space(1)
		Private cestCli    := space(1)
		Private cGet_dtsai := sz8->z8_dtsaida
		Private cGet_endCl := iif(lcarreg, sZ7->Z7_local, sa2->a2_end )
		Private cGet_estCl := iif(lcarreg, sZ7->Z7_ufe, sa2->a2_est )
		Private cGet_hrsai := sz8->z8_hsaida
		Private cGet_nomCl := iif(lcarreg, sZ7->Z7_nomcli, sa2->a2_nome )
		Private cGet_nota  := iif(lcarreg, sZ7->Z7_numnf ,  sz8->Z8_NFCOMP )
		Private cGet_nrLac := sz8->z8_lacre
		Private _lacre	   := sz8->z8_lacre
		Private cGet_prefi := iif(lcarreg, sZ7->Z7_prefixo, '' )
		Private cGet_psent := trans(sz8->z8_psent   ,"@E 999,999,999.99")
		Private cGet_pssai := trans(sz8->z8_pssai    ,"@E 999,999,999.99")
		Private cGet_pliqu := trans( _peso_liq,"@E 999,999,999.99")
		Private cGet_sacos := trans(sz8->z8_quant ,"@E 999,999")
		Private cGet_serie := iif(lcarreg, sZ7->Z7_serie  , sz8->Z8_SERNF )
		Private cGet_vlrpe := Transform(SZ8->Z8_PEDAGIO,"@E 9,999.99")
		Private cGet_frete := trans( 0  ,"@E 9,999,999.99")
	endif

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg1","oGrp1","onomCli","oendCli","oestCli","oGet_nomCli","oGet_endCli","oGet_estCli","oGrp2")
	SetPrvt("oSay7","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13", "oGet_nrLacre","oGet_psent","oGet_pssai","oGet_pliquido")
	SetPrvt("oBtn_lacre","oGrp3","oSay1","oSay2","oSay3","oSay4","oSay5","oGet_serie","oGet_nota","oGet_prefixo")
	SetPrvt("oGet_hrsaida")

	oFont1     := TFont():New( "Verdana",0,-17,,.T.,0,,700,.F.,.F.,,,,,, )
	oFont2     := TFont():New( "Verdana",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	oFont3     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
	oFont14     := TFont():New( "Verdana",0,14,,.F.,0,,400,.F.,.F.,,,,,, )

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

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
	ccoleent:= iif( empty(sz8->z8_coleent),'',  iif( sz8->z8_coleent=='A',' AUTOM.', ' MANUAL' ) )
	ccolesai:='AUTOM.'
	ccolesai:= iif( empty(sz8->z8_colesai),'',  iif( sz8->z8_colesai=='A',' AUTOM.', ' MANUAL' ) )

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

	//original ---    oGet_nrLac := TGet():New( 079,180,{|u| If(PCount()>0,_lacre:=u,_lacre)},oGrp2,128,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_lacre",,)
	oGet_nrLac := TGet():New( 079,180,{|u| If(PCount()>0,_lacre:=u,_lacre)},oGrp2,128,008,'',/*valid*/{|| _lacre:=u_frmLacres(Nil,sz8->z8_oc)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_lacre",,)



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

	oSBtn1     := SButton():New( 096,122,11,{|| u_altera_peso(), cGet_pliqu := trans(_peso_liq,"@E 999,999,999.99"), oDlg1:refresh() },oGrp2,,"", )

	//oSBtn2     := SButton():New( 077,310,11,{|| getLacre() } ,oGrp2,,"", )
	oSBtn2     := SButton():New( 077,310,11,{|| /*getLacre()*/_lacre:=u_frmLacres(Nil,sz8->z8_oc) } ,oGrp2,,"", )

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
	oUsr      := TSay():New( 175,080,{||  sz8->z8_usuario  },oGrp3,,oFont14,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)

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

	RETURN


	Static Function PICM(	cTpOper,; 	// Tipo de Operacao
	cTpNf,;		// Tipo de Nota ('E'ntrada/'S'aida)
	cTpCliFor,;	// Tipo do Cliente ou Fornecedor
	cTipoAliq,;	// Tipo da Aliquota ("S"olidario/"I"cms)
	nRecOri,;	// Numero do Registro caso seja devolucao
	lCupFis)	// Se eh cupom fiscal

	Local nAliquota:=0
	Local cEstCliFor:='',cInscr:=''
	Local nMV_ICMPAD:=GetMv('MV_ICMPAD')
	Local cGpTrib:=Iif(cModulo=="FRT", Padr(SBI->BI_GRTRIB, TamSX3("B1_GRTRIB")[1]), RetFldProd(SB1->B1_COD,"B1_GRTRIB","SB1"))
	Local nPerIcm:=Iif(cModulo=="FRT", SBI->BI_PICM, RetFldProd(SB1->B1_COD,"B1_PICM","SB1"))
	Local nMargemLucro:=0
	Local aExcecao:={},cGrpCli
	Local lCalcIss:= .F.
	Local nNfOri		:= 0		// Posicao da Nf Original
	Local nSerOri		:= 0		// Posicao da Serie Original
	Local nItemOri		:= 0		// Posicao do Item Original
	Local nProdOri		:= 0		// Posicao do Produto Original
	Local nAliqFECP		:= 0		// Alíquota FECP
	Local lNaoContrib	:= .T.      // Nao-Contribuinte ICMS?
	Local nFECPLoja		:= 0
	Local lFECOPRN  	:= .F. 		// Verifica se a Aliquota ira ter calculo FECOP para o Estado do RN

	Private cMV_NORTE:=GetMv('MV_NORTE'),cMV_ESTADO:=GetMv('MV_ESTADO')
	nRecOri		:= 0		// Define o valor do registro
	lCupFis		:= .F.		// Se eh cupom fiscal

	// Verifica se a Aliquota ira ter calculo FECOP para o Estado do RN
	If cModulo == "LOJ"
		lFECOPRN := Iif(cMV_ESTADO=="RN" .And. SB1->(FieldPos("B1_ALFECRN")) > 0 .And. SB1->B1_ALFECRN > 0, .T., .F.)
	ElseIf cModulo == "FRT"
		lFECOPRN := Iif(cMV_ESTADO=="RN" .And. SBI->(FieldPos("BI_ALFECRN")) > 0 .And. SBI->BI_ALFECRN > 0, .T., .F.)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca dados do Cliente ou Fornecedor                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cTpNf=='S' .and. !(cTpOper$'DB')) .or.;
	(cTpNf=='E' .and. (cTpOper$'DB'))
		cEstCliFor	:=SA1->A1_EST
		cInscr		:=SA1->A1_INSCR
		cTpCliFor  :=IIf(Empty(cTpCliFor),SA1->A1_TIPO,cTpCliFor)
		cGrpCli		:=SA1->A1_GRPTRIB
		lNaoContrib	:= IIf(Empty(SA1->A1_INSCR).Or."ISENT"$SA1->A1_INSCR.Or."RG"$SA1->A1_INSCR.Or.(SA1->(FieldPos("A1_CONTRIB")) > 0 .And. SA1->A1_CONTRIB == "2"),.T.,.F.)
	Else
		cEstCliFor	:=SA2->A2_EST
		cInscr		:=SA2->A2_INSCR
		cTpCliFor  :=IIf(Empty(cTpCliFor),SA2->A2_TIPO,cTpCliFor)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo da Margem de Lucro para Icms Retido                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cModulo$'FAT/DIS'
		nMargemLucro:=IIF(SC6->C6_PICMRET==0,SB1->B1_PICMRET,SC6->C6_PICMRET)
	Else
		If cTpNF=='S'
			If cModulo=="FRT"
				nMargemLucro:=SBI->BI_PICMRET
			Else
				nMargemLucro:=RetFldProd(SB1->B1_COD,"B1_PICMRET","SB1")
			Endif
		Else
			nMargemLucro:=0
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Excessoes Fiscais (Somente no SIGAFAT/SIGALOJA/SIGATMK/SIGAFRT.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTpNf=='S' .and. cModulo $ 'FAT/DIS/LOJ/TMK/FRT'
		aExcecao:=ExcecFis(cGpTrib,cGrpCli)
		If aExcecao[7]=="S"
			nMargemLucro:=aExcecao[3]
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca da aliquota de ICMS                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se for NF de Devolucao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  cTpOper=='D' .And. nRecOri <> 0

		Do Case

			Case cTpNf == 'S'

			SD1->(MsGoto(nRecOri))
			nAliquota	:= SD1->D1_PICM

			Case cTpNf == 'E'

			SD2->(MsGoto(nRecOri))
			nAliquota	:= SD2->D2_PICM

		EndCase
	Else
		While .t.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Para Servicos         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ((!Empty(IIF(cModulo <> "FRT",RetFldProd(SB1->B1_COD,"B1_CODISS","SB1"),'')) .or. (!Empty(SBI->BI_CODISS) .And. cModulo=="FRT")) .Or. (cModulo$"FAT/DIS" .And. !Empty(SC6->C6_CODISS))) .and. SF4->F4_ISS=='S'
				lCalcIss := .T.
				nAliquota:=If(MaSBCampo("ALIQISS")==0,GetMv("MV_ALIQISS"),MaSBCampo("ALIQISS"))
				If (Len(aExcecao) >= 9 .And. !aExcecao[9]=="S") .Or. Len(aExcecao) == 0 //ISS
					Exit
				EndIf
				If aExcecao[7]=="S"
					If cMV_ESTADO==cEstCliFor
						nAliquota:=aExcecao[1]  //Aliq. de ICMS Interna
					Else
						nAliquota:=IIf(aExcecao[8]>0,aExcecao[8],AliqDest(aExcecao,cEstCliFor))  //Aliq. de ICMS Destino
					Endif
				Else
					If cMV_ESTADO<>cEstCliFor
						If ( cTpOper$"DB" )
							nAliquota:=AliqDest(aExcecao,cMV_ESTADO)
						Else
							nAliquota:=AliqDest(aExcecao,cEstCliFor)
						EndIf
					Endif
				Endif
				Exit
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nas Exportacoes,verifica se h  exce‡„o fiscal, se houver, respeita-a, caso³
			//³ contr rio atribui 13% como valor default                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (cTpCliFor == "X") .And. (((cTpNF == "S") .And. (cTpOper # "D")) .Or. ((cTpNF == "E") .And. (cTpOper == "D")))
				if len(aExcecao) >=7
					nAliquota := If( aExcecao[7] == "S",aExcecao[1],13) //Aliq. de ICMS Interna
					Exit
				Else
					nAliquota := 13
					Exit
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nas Importacoes       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (cTpCliFor == "X") .And. (((cTpNF == "E") .And. (cTpOper # "D")) .Or. ((cTpNF == "S") .And. (cTpOper == "D")))
				nAliquota := If( Empty( nPerICM ),nMV_ICMPAD,nPerICM )
				Exit
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Excessao Fiscal                          ³
			//³ Utilizado pelo SIGAFAT e SIGALOJA.       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cTpNf=="S" .and. cModulo $ "FAT/DIS/LOJ/FRT" .and. nMargemLucro>0.and.cTpCliFor=="S".and.cTipoAliq=="S"
				If aExcecao[7]=="S"
					If cMV_ESTADO==cEstCliFor
						nAliquota:=aExcecao[1]  //Aliq. de ICMS Interna
					Else
						nAliquota:=IIf(aExcecao[8]>0,aExcecao[8],AliqDest(aExcecao,cEstCliFor))  //Aliq. de ICMS Destino
					Endif
				Else
					If ( cTpOper$"DB" )
						nAliquota:=AliqDest(aExcecao,cMV_ESTADO)
					Else
						nAliquota:=AliqDest(aExcecao,cEstCliFor)
					EndIf
					If cMV_ESTADO==cEstCliFor.and.nPerIcm>0
						nAliquota:=nPerIcm
					Endif
				Endif
				Exit
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Pessoa Fisica         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nota de Saida sem inscr. Estadual ou isento				   ³
			//³ Nota de Devolucao de Saida e cliente Pessoa Fisica 		   ³
			//³ Nota de Devolucao de Entrada sem inscr. Estadual ou Isenta ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lCalcIss
				If (cTpNf=='S' .and. (Empty(cInscr).Or."ISENT"$Upper(cInscr))) .or. ;
				(cTpNf=='S' .and. cTpOper=='D'  .and. cTpCliFor =='F') .Or. ;
				(cTpNf=='E' .and. cTpOper=='D'  .and. (Empty(cInscr).Or."ISENT"$Upper(cInscr)))
					If (Empty(cInscr).Or."ISENT"$Upper(cInscr))
						If cTpNF=='S'
							If cModulo $ "LOJ/FRT"
								If ( (cTpNf=='S' .and. !(cTpOper$'DB')) .Or. (cTpNf=='E' .and. (cTpOper$'DB')) ) .And. ;
								cMV_ESTADO != cEstCliFor .And. ( !Empty(SA1->A1_INSCR) .And. !("ISENT" $ SA1->A1_INSCR) )
									If cMV_ESTADO $ cMV_NORTE
										nAliquota:=12
									Else
										nAliquota:=IIf( cEstCliFor $ cMV_NORTE , 7 , 12 )
									Endif
								Else
									If (SF4->(FieldPos("F4_ISEFECP")) > 0 .AND. SF4->F4_ISEFECP == "2") .OR. (SF4->(FieldPos("F4_ISEFERN")) > 0 .AND. SF4->F4_ISEFERN == "2")
										If cModulo == "LOJ"
											nAliqFECP := Iif(cMV_ESTADO $"RJ|BA|RN",Iif(SB1->(FieldPos("B1_FECP")) > 0 .And.SB1->B1_FECP > 0 .Or. lFECOPRN,;
											Iif ( !lFECOPRN, SB1->B1_FECP, SB1->B1_ALFECRN ),;
											Iif ( cMV_ESTADO == 'BA' .Or. ( cMV_ESTADO <> 'BA' .And. cMV_ESTADO <> 'RJ' .And. cTpNf == "S" .And. cEstCliFor == "BA" )  , 0 , 1 ) ) , 0 )
										Else
											nAliqFECP := Iif(cMV_ESTADO $"RJ|BA|RN",Iif(SB1->(FieldPos("BI_FECP")) > 0 .And.SBI->BI_FECP > 0 .Or. lFECOPRN,;
											Iif ( !lFECOPRN, SBI->BI_FECP, SBI->BI_ALFECRN ),;
											Iif ( cMV_ESTADO == 'BA' .Or. ( cMV_ESTADO <> 'BA' .And. cMV_ESTADO <> 'RJ' .And. cTpNf == "S" .And. cEstCliFor == "BA" )  , 0 , 2 ) ) , 0 )
											//Iif ( cMV_ESTADO == 'BA' .Or. ( cMV_ESTADO <> 'BA' .And. cMV_ESTADO <> 'RJ' .And. cTpNf == "S" .And. cEstCliFor == "BA" )  , 0 , 1 ) ) , 0 )
										EndIf
									EndIf

									nAliquota:=IIf(nPerIcm>0,nPerIcm,nMV_ICMPAD) + nAliqFECP
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Se for NF de Devolucao³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If (cTpNf=='S' .and. cTpOper=='D'  .and. cTpCliFor =='F')
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Verifica o item na NF para pegar a mesma aliquota de ICMS nas devolucoes³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									nNfOri		:= aScan(aHeader,{|x| AllTrim(x[2])=="D2_NFORI"})
									nSerOri		:= aScan(aHeader,{|x| AllTrim(x[2])=="D2_SERIORI"})
									nItemOri	:= aScan(aHeader,{|x| AllTrim(x[2])=="D2_ITEMORI"})
									nProdOri	:= aScan(aHeader,{|x| AllTrim(x[2])=="D2_COD"})
									If !Empty(aCols[n][nNfOri])
										SD1->(DbSetOrder(1))
										If SD1->(DbSeek(xFilial("SD1")+aCols[n][nNfOri]+aCols[n][nSerOri]+SA2->A2_COD+SA2->A2_LOJA+aCols[n][nProdOri]+aCols[n][nItemOri]))
											nAliquota	:= SD1->D1_PICM
										Endif
									Endif
								EndIf
							EndIf
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Quando for devolucao de vendas a aliquota da entrada deve  ³
							//³ ser igual a aliquota da Sa¡da.                     			³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If cTpNf=='E' .and. cTpOper=='D'
								nAliquota := nMV_ICMPAD
							Else
								nAliquota:=If(nPerIcm>0,nPerIcm,AliqDest(aExcecao,cEstCliFor))
							EndIf
						Endif
					Else
						If cTpNf=='E' .and. cTpOper=='D'
							nAliquota := nMV_ICMPAD
						Else
							If cModulo=="FRT"
								nAliqFECP := Iif(cMV_ESTADO $"RJ|BA",Iif(SBI->(FieldPos("BI_FECP")) > 0 .And.SBI->BI_FECP > 0,SBI->BI_FECP,;
								Iif ( cMV_ESTADO == 'BA' .Or. ( cMV_ESTADO <> 'BA' .And. cMV_ESTADO <> 'RJ' .And. cTpNf == "S" .And. cEstCliFor == "BA" )  , 0 , 1 ) ) , 0 )
							Else
								nAliqFECP := Iif(cMV_ESTADO $"RJ|BA|RN",Iif(SB1->(FieldPos("B1_FECP")) > 0 .And.SB1->B1_FECP > 0 .Or. lFECOPRN,;
								Iif ( !lFECOPRN, SB1->B1_FECP, SB1->B1_ALFECRN ),;
								Iif ( cMV_ESTADO == 'BA' .Or. ( cMV_ESTADO <> 'BA' .And. cMV_ESTADO <> 'RJ' .And. cTpNf == "S" .And. cEstCliFor == "BA" )  , 0 , 2 ) ) , 0 )
								//Iif ( cMV_ESTADO == 'BA' .Or. ( cMV_ESTADO <> 'BA' .And. cMV_ESTADO <> 'RJ' .And. cTpNf == "S" .And. cEstCliFor == "BA" )  , 0 , 1 ) ) , 0 )
							Endif
							nAliquota:=IIf(nPerIcm>0,nPerIcm,nMV_ICMPAD) + nAliqFECP
						EndIf
					Endif

					If cModulo $ "LOJ/FRT"
						nFECPLoja := nAliqFECP
					Else
						nFECPLoja := 0
					EndIf

					If cEstCLiFor == cMV_ESTADO
						If ( Len(aExcecao) >= 1 )
							If ( aExcecao[1] ) != 0
								nAliquota := aExcecao[1]+nFECPLoja  //Aliq. de ICMS Interna
							EndIf
						EndIf
					Else
						If ( Len(aExcecao) >= 2 ).And.!(Empty(cInscr).Or."ISENT"$Upper(cInscr))
							If (aExcecao[2]) != 0
								nAliquota := aExcecao[2]+nFECPLoja //Aliq. de ICMS Externa
							EndIf
						Else
							if Len(aExcecao) >0
								If (aExcecao[1]) != 0
									nAliquota := aExcecao[1]+nFECPLoja  //Aliq. de ICMS Interna
								EndIf
							endif
						EndIf
					EndIf
					Exit
				Endif
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nas Operacoes         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF cModulo $ "FAT/DIS/LOJ/FRT"
				IF cEstCLiFor == cMV_ESTADO
					If Len(aExcecao) >=1
						IF !Empty(aExcecao[1])
							nAliquota := aExcecao[1]  //Aliq. de ICMS Interna
							Exit
						Endif
					Endif
				Else
					If Len(aExcecao) >= 2
						IF !Empty(aExcecao[2])
							nAliquota := aExcecao[2] //Aliq. de ICMS Externa
							Exit
						Endif
					Endif
				Endif
			Endif
			If cEstCliFor==cMV_ESTADO.or.cTipoAliq=='S' .OR. ( cModulo $ 'LOJ/FRT' .AND. lNaoContrib ) .OR. lCupFis
				If cModulo=="FRT"
					nAliqFECP := Iif(cMV_ESTADO $"RJ|BA",Iif(SBI->(FieldPos("BI_FECP")) > 0 .And.SBI->BI_FECP > 0,SBI->BI_FECP,;
					Iif ( cMV_ESTADO == 'BA' .Or. ( cMV_ESTADO <> 'BA' .And. cMV_ESTADO <> 'RJ' .And. cTpNf == "S" .And. cEstCliFor == "BA" )  , 0 , 1 ) ) , 0 )
				Else
					nAliqFECP := Iif(cMV_ESTADO $"RJ|BA|RN",Iif(SB1->(FieldPos("B1_FECP")) > 0 .And.SB1->B1_FECP > 0 .Or. lFECOPRN,;
					Iif ( !lFECOPRN, SB1->B1_FECP, SB1->B1_ALFECRN ),;
					Iif ( cMV_ESTADO == 'BA' .Or. ( cMV_ESTADO <> 'BA' .And. cMV_ESTADO <> 'RJ' .And. cTpNf == "S" .And. cEstCliFor == "BA" )  , 0 , Iif ( cMV_ESTADO = 'RJ', 2 , 0 ) ) ) , 0 ) // MARCUS VINICIUS 27/03/15 AJUSTADO ALÍQUOTA REFERENTE AO FECP DO RJ
					//				Iif ( cMV_ESTADO == 'BA' .Or. ( cMV_ESTADO <> 'BA' .And. cMV_ESTADO <> 'RJ' .And. cTpNf == "S" .And. cEstCliFor == "BA" )  , 0 , 1 ) ) , 0 )
				Endif

				nAliquota := IIf( nPerIcm > 0 , nPerIcm , nMV_ICMPAD ) + nAliqFECP
			Else
				If (cTpNF=='S' .and. !(cTpOper$'DB')) .or.;
				(cTpNF=='E' .and. cTpOper$'DB')
					If cMV_ESTADO $ cMV_NORTE
						nAliquota:=12
					Else
						nAliquota:=IIf( cEstCliFor $ cMV_NORTE , 7 , 12 )
					Endif
				Else
					If cMV_ESTADO $ cMV_NORTE
						nAliquota:=IIf( cEstCliFor $ cMV_NORTE , 12 , 7)
					Else
						nAliquota:=12
					Endif
				Endif
			Endif
			Exit
		End
	Endif

	If SF4->F4_ICM == "S"      // Calcula ICMS
		If nAliquota == 0
			If cMV_ESTADO $ "RJ"
				nAliquota:=IIf(nPerIcm>0,nPerIcm,nMV_ICMPAD) + 2	// Aliquota FECP
			Else
				nAliquota:=IIf(nPerIcm>0,nPerIcm,nMV_ICMPAD)
			Endif
		Endif
	Endif

Return (nAliquota)

Static Function ExcecFis(cGrupo,cGrpCli,aExcecao)

	LOCAL cAlia1:=Alias()
	Local cFilBk:=""

	aExcecao:=IIf(Empty(aExcecao),{0,0,0," "," "," ","N",0,If(SF7->(FieldPos("F7_ISS"))>0,SF7->F7_ISS,'N')},aExcecao)

	// Estrutura do Array aExcecao
	//	[01] - Aliq. de ICMS Interna
	//	[02] - Aliq. de ICMS Externa
	//	[03] - Margem de Lucro Presumida
	//	[04] - Grupo de Tributacao
	//	[05] - Tipo de Cliente
	//	[06] - Estado Destino
	//	[07] - "S"
	//	[08] - Aliq. de ICMS Destino
	//	[09] - Refere-se ao ISS "S/N"

	If Empty(cGrupo).or.cGrpCli==NIL
		Return (aExcecao)
	Endif

	If cGrupo == aExcecao[4] .And. SA1->A1_TIPO == aExcecao[5] .And.   SA1->A1_EST == aExcecao[6]
		aExcecao[7]:="S"
		Return(aExcecao)
	Endif

	dbSelectArea("SF7")
	dbSetOrder(1)
	If dbSeek(xFilial("SF7")+ cGrupo + cGrpCli)

		While !Eof() .And. SF7->F7_GRTRIB + SF7->F7_GRPCLI == cGrupo+cGrpCli
			If (SA1->A1_EST == SF7->F7_EST .Or. SF7->F7_EST == "**") .AND. (SA1->A1_TIPO == SF7->F7_TIPOCLI .Or. SF7->F7_TIPOCLI == "*")
				aExcecao[1]:= SF7->F7_ALIQINT
				aExcecao[2]:= SF7->F7_ALIQEXT
				aExcecao[3]:= SF7->F7_MARGEM
				aExcecao[4]:= SF7->F7_GRTRIB
				aExcecao[5]:= SA1->A1_TIPO
				aExcecao[6]:= SA1->A1_EST
				aExcecao[7]:= "S"
				aExcecao[8]:= SF7->F7_ALIQDST
				aExcecao[9]:= If(FieldPos("F7_ISS")>0,F7_ISS,'N')
				Exit
			Endif
			SF7->(dbSkip())
		EndDo
	Endif

	DbSelectArea(cAlia1)

Return(aExcecao)


Static Function AlqLei2741(cNCM          ,cExNCM        ,cCodISS       ,cUF        ,cCodMun        ,cCodProd   ,nItem       ,cNumLote,cLoteCtl,cMvFisCTrb,cMvFisAlCT,lMvFisFRas)

	Local nPercentual	:= 0
	Local cOper			:= "N"
	Local lAchouSB1		:= .F.
	Local lAchouSBI		:= .F.
	Local lAchouSBZ		:= .F.
	Local uRet			:= 0

	// cNCM		:= ""
	//DEFAULT cExNCM		:= ""
	//DEFAULT cCodISS		:= ""
	//DEFAULT cUF			:= "**"
	//DEFAULT cCodMun		:= ""
	//DEFAULT cCodProd	:= ""
	//DEFAULT cNumLote	:= ""
	//DEFAULT cLoteCtl	:= ""
	//DEFAULT cMvFisCTrb	:= "1"
	//DEFAULT cMvFisAlCT	:= "3"
	//DEFAULT lMvFisFRas	:= .F.

	IF cMvFisCTrb == "1" //lEGADO
		lAchouSB1:=SB1->(DbSeek(xFilial("SB1") + cCodProd))
		lAchouSBI:=SBI->(DbSeek(xFilial("SBI") + cCodProd))
		lAchouSBZ:=SBZ->(DbSeek(xFilial("SBZ") + cCodProd))

		If lAchouSB1 .or. lAchouSBZ
			uRet := AlqLeiTran("SB1","SBZ" )

			If ValType(uRet) <> "N"
				nPercentual:=uRet[1]
			Else
				nPercentual := uRet
			EndIf
		EndIF

	ElseIF cMvFisCTrb == "2"
		Do Case
			Case cMvFisAlCT	==	"1"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Irá considerar as alíquotas do documentos fiscal mais o percentual da tabela CGA³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPercentual:=TotAlqNF(nItem,cCodProd, lMvFisFRas,cNumLote,cLoteCtl)
			nPercentual+=TotCGACGB(cNCM , cExNCM, cCodISS , cUF , cCodMun , cCodProd,cOper)

			Case cMvFisAlCT	==	"2"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Sistema irá considerar somente percentual informado na tabela CGA e CGB³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPercentual:=TotCGACGB(cNCM , cExNCM, cCodISS , cUF , cCodMun , cCodProd,cOper)

			Case cMvFisAlCT	==	"3"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Irá considerar somente as alíquotas do documentos fiscal. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPercentual:=TotAlqNF(nItem,cCodProd, lMvFisFRas,cNumLote,cLoteCtl)
		EndCase

	EndIF

Return nPercentual