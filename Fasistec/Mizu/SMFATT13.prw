#Include "Protheus.ch"
#include "rwmake.ch"
#INCLUDE 'COLORS.CH'
#Include "TOPCONN.CH"
#INCLUDE "FWBROWSE.CH"
#include "totvs.ch"
#include "fwmvcdef.ch"

#DEFINE cEmpRastroOC getNewPar('MZ_RASTEMP','3001|0210')	//codigo da empresa que controla o rastro da OC

#XCommand ROLLBACK TRANSACTION => DisarmTransaction()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT13                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//     ATENCIAMENTO DE CARGAS
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SMFATT13()

	Local oBrw
	Local cAlias := "SZ8"
	Private cCadastro := "Agenciamento"
	Private aPedDesMar := {}
	Private aCores := {}
	Private aFixe	:= {}
	Private aAcho	:= {}
	Private aCpos	:= {}
	private lSenMot := ( cEmpAnt + cFilAnt $ getNewPar('MV_SENMOTO', '2001|0223' ) )
	private lUsaPager := .T.
	private lBlqFrete := .T.
	Private laltped := .f.
	Private lPrdReensaque := .f.

	if !u_SMGETACCESS(funname(),.f.); return; endif

	aadd(aAcho,"NOUSER") //Evita Exibição de outros campos de usuario.
	aadd(aAcho,"Z8_OC") //OK
	aadd(aAcho,"Z8_DATA") //OK
	aadd(aAcho,"Z8_HORA")  //OK
	aadd(aAcho,"Z8_HRAGENC")  //OK
	aadd(aAcho,"Z8_TPOPER")
	aadd(aAcho,"Z8_TPVEIC")    //OK - Semar-Juailson 25/11/14
	aadd(aAcho,"Z8_PLACA")    //OK
	aadd(aAcho,"Z8_PLCAR2")    //OK - Semar-Juailson 25/11/14
	aadd(aAcho,"Z8_MOTOR")   //OK
	aadd(aAcho,"Z8_NOMMOT")  //OK
	aadd(aAcho,"Z8_PLCAR")   //OK
	aadd(aAcho,"Z8_PRODUTO")
	aadd(aAcho,"Z8_QUANT")
	aadd(aAcho,"Z8_PALLET")
	aadd(aAcho,"Z8_PLTEN")
	aadd(aAcho,"Z8_PLTSA")
	aadd(aAcho,"Z8_PAGER")
	aadd(aAcho,"Z8_LACRE")
	aadd(aAcho,"Z8_TRANSP")   //OK
	aadd(aAcho,"Z8_LJTRANS")  //OK
	aadd(aAcho,"Z8_NMTRANS")   //OK
	aadd(aAcho,"Z8_SACGRA")
	aadd(aAcho,"Z8_VISTOR")    //OK
	aadd(aAcho,"Z8_DTVIST")    //OK
	aadd(aAcho,"Z8_MUNIC")     //OK
	aadd(aAcho,"Z8_ESTADO")    //OK
	aadd(aAcho,"Z8_OBS")
	aadd(aAcho,"Z8_USUARIO")
	aadd(aAcho,"Z8_FORNECE")  //OK
	aadd(aAcho,"Z8_LOJAFOR")  //OK
	aadd(aAcho,"Z8_NFCOMP")
	aadd(aAcho,"Z8_SERNF")
	aadd(aAcho,"Z8_NFPESEN")
	aadd(aAcho,"Z8_TICKENT")
	aadd(aAcho,"Z8_PATIO")
	aadd(aAcho,"Z8_CILINDR")  //OK
	aadd(aAcho,"Z8_CATEGMP")
	aadd(aAcho,"Z8_CBPAGER")
	aadd(aAcho,"Z8_LOCCARR")
	aadd(aAcho,"Z8_STATUS2")
	aadd(aAcho,"Z8_ITENSOC")

	//Instaciamento
	oBrw := FWMBrowse():New()

	oBrw:SetAlias( "SZ8" )

	//Realiza o filtro
	If cEmpAnt + cFilAnt $ cEmpRastroOC
		_cDtCort := DtoS(DaySub(DDATABASE,6))
		oBrw:SetFilterDefault("Z8_FILIAL = '"+cFilant+"' .and. (DtoS(Z8_DATA) >= '"+_cDtCort+"' .or. (Z8_TPOPER == 'D' .and. Z8_FATUR != 'S')) .and. !empty(Z8_TPOPER)") // Rodrigo (Semar) 03/05/17 - Ajuste para aparecer Descarregamentos. // Normando (Semar) 12/11/2015 Visualizar OC faturadas
	Else
		oBrw:SetFilterDefault("Z8_FILIAL = '"+cFilant+"' .and. Empty(Z8_FATUR) .and. !empty(Z8_TPOPER)")
	EndIf

	//Legenda
	oBrw:AddLegend( 'If(Z8_STATUS2==" ",Empty(If(Z8_TPOPER=="C",Posicione("SZ1",8,xFilial("SZ1")+Z8_OC,"Z1_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+Z8_OC,"C7_YOC"))),.F.)', "WHITE", "" )
	oBrw:AddLegend( 'If(SZ8->Z8_STATUS2=="P",!Empty(If(SZ8->Z8_TPOPER=="C",Posicione("SZ1",8,xFilial("SZ1")+SZ8->Z8_OC,"Z1_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+SZ8->Z8_OC,"C7_YOC"))),.F.)', "ORANGE", "" )
	oBrw:AddLegend( 'If(SZ8->Z8_STATUS2=="1",!Empty(If(SZ8->Z8_TPOPER=="C",Posicione("SZ1",8,xFilial("SZ1")+SZ8->Z8_OC,"Z1_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+SZ8->Z8_OC,"C7_YOC"))),.F.)', "YELLOW", "" )
	oBrw:AddLegend( 'Z8_STATUS2 == "2"' , "GREEN", "" )
	oBrw:AddLegend( 'Z8_STATUS2 == "3"' , "PINK" , "" )
	oBrw:AddLegend( 'Z8_STATUS2 == "4"' , "BLUE" , "" )
	oBrw:AddLegend( 'Z8_STATUS2 == "5"' , "BLACK" , "" )
	oBrw:AddLegend( 'Z8_STATUS2=="6" .AND. empty(Z8_FATUR)' , "RED" , "" )
	//oBrw:AddLegend( 'SZ8->Z8_STATUS2=="6" .AND. !empty(Z8_FATUR) .AND. Z8_PESOFIN>0' , "BROWN", "" )
	oBrw:AddLegend( '(SZ8->Z8_STATUS2=="6" .OR. SZ8->Z8_STATUS2=="D") .AND. !empty(SZ8->Z8_FATUR) .AND. SZ8->Z8_PESOFIN>0' , "BROWN", "" )// Normando (semar) 12/11/2015 Alterar para condição certa

	If cEmpAnt + cFilAnt $ cEmpRastroOC
		oBrw:AddLegend( 'Z8_STATUS2 == "C"' , "BR_CANCEL" , "" )
		oBrw:AddLegend( 'Z8_STATUS2 == "N"' , "NOTE_PQ" , "" )
	endif

	oBrw:SetMenuDef('SMFATT13')

	oBrw:SetDescription( "Agenciamento" )

	//ativa
	oBrw:Activate()

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF17                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Inclui				                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SMFATF17(cAlias, nReg, nOpc)

	Local nOpcao := 0
	Private aPedMark := {}

	nOpcao := AxInclui(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,"u_smSetOC()")

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF18                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Deleta				                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATF18(cAlias, nReg, nOpc)

	Local nOpcao := 0
	Local cOCOld := SZ8->Z8_OC

	If SZ8->Z8_STATUS2 == "1"
		ALERT("EXCLUSÃO NÃO PERMITIDA: A ordem ja possui pedidos associados. Verifique.")
		Return Nil
	EndIf

	If SZ8->Z8_STATUS2 >= "3"
		ALERT("EXCLUSÃO NÃO PERMITIDA: O veículo já iniciou o carregamento/descarregamento. Verifique.")
		Return Nil
	EndIf

	If SZ8->Z8_TPOPER == "D"
		dbSelectArea('SC7')
		dbsetorder(RetOrdem("SC7","C7_FILIAL+C7_YOC"))
		If sc7->(dbSeek(xFilial('SC7')+cOCOld))
			While SC7->C7_FILIAL == xFilial("SC7") .AND.;
			SC7->C7_YOC == cOCOld

				cSql := "SELECT D1_DOC, D1_SERIE FROM "+RetSqlName("SD1")+" SD1 "
				cSql += " WHERE SD1.D_E_L_E_T_ = ' '"
				cSql += " AND   SD1.D1_FILIAL  = '" +xFilial("SD1")+ "'"
				cSql += " AND   SD1.D1_PEDIDO  = '" + SC7->C7_NUM + "'"
				If Select("QrySC7") > 0
					dbSelectArea("QrySC7")
					QrySC7->(DbCloseArea())
				EndIf

				TcQuery cSql New Alias "QrySC7"

				If  QrySC7->(!Eof())
					ALERT("EXCLUSÃO NÃO PERMITIDA: Esta ordem de carregamento já foi relacionada a PRÉ-NOTA/NF "+Alltrim(QrySC7->D1_DOC)+"-"+Alltrim(QrySC7->D1_SERIE)+ ". Verifique.")
					QrySC7->(DbCloseArea())
					Return Nil
				EndIf

				sc7->(dbSeek(xFilial('SC7')+cOCOld)) //skip nao funcionou
				sc7->(dbskip())
			EndDo
		EndIf
	EndIf

	nOpcao := AxDeleta(cAlias,nReg,nOpc,aAcho,/*aCpos*/) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.

	If nOpcao = 2
		If SZ8->Z8_TPOPER == "C"
			dbSelectArea('SZ1')
			dbsetorder(RetOrdem("SZ1","Z1_FILIAL+Z1_OC"))
			If dbSeek(xFilial('SZ1')+cOCOld)
				//While SZ1->Z1_OC == cOCOld
				While SZ1->Z1_FILIAL == xFilial("SZ1") .AND. SZ1->Z1_OC == cOCOld	//Marcus Vinicius - 13/03/2018 - Incluído validação por filial

					While !RecLock("SZ1",.F.) ; End
					SZ1->Z1_OC = " "
					SZ1->(MsUnlock())

					dbSeek(xFilial('SZ1')+cOCOld)  //skip nao funcionou
				EndDo
			EndIf
		Else
			dbSelectArea('SC7')
			dbsetorder(RetOrdem("SC7","C7_FILIAL+C7_YOC"))
			If dbSeek(xFilial('SC7')+cOCOld)
				While SC7->C7_FILIAL == xFilial("SC7") .AND.;
				SC7->C7_YOC == cOCOld

					While !RecLock("SC7",.F.) ; End
					SC7->C7_YOC = " "
					SC7->(MsUnlock())

					dbSeek(xFilial('SC7')+cOCOld) //skip nao funcionou
				EndDo
			EndIf
		EndIf
	EndIf

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF19                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Inclui				                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SMFATF19(cAlias, nReg, nOpc)

	Local nOpcao := 0

	nOpcao := AxVisual(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF36                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function smSetOC(p_nOpc)

	Local lRes := .T.
	Local nOpc := if(p_nOpc==nil,0,p_nOpc)
	Local nDTreino 	:= getNewPar('MV_DDTREIN', 0 )
	Local lPGInclu	:= getNewPar('MV_SMPGINC', .T. )

	If M->Z8_TPOPER == "D"

		_cCampo := ''
		aCpDescarregamento := {}

		aadd(aCpDescarregamento,'Z8_PRODUTO')
		aadd(aCpDescarregamento,'Z8_SERNF'	)
		aadd(aCpDescarregamento,'Z8_NFCOMP'	)
		aadd(aCpDescarregamento,'Z8_NFPESEN')
		aadd(aCpDescarregamento,'Z8_TRANSP'	)
		aadd(aCpDescarregamento,'Z8_FORNECE')

		For i=1 To Len(aCpDescarregamento)
			If EMPTY(&('M->'+aCpDescarregamento[i]))
				SX3->( dbSetOrder(2) )
				If SX3-> ( MsSeek(aCpDescarregamento[i]) )
					_cCampo += UPPER(TRIM(X3Titulo()))+CRLF
				EndIF
			EndIf
		Next i

		If !EMPTY(_cCampo)
			Alert("Existem campos de preenchimento obrigatório em branco referente a operação DESCARREGAMENTO!"+CRLF+CRLF+"Favor preencher os campos abaixo:"+CRLF+CRLF+_cCampo)
			lRes  := .F.
		EndIf

	EndIf

	If M->Z8_SACGRA == "S"  .AND. M->Z8_PALLET == "G"
		Alert("A informação do campo PALLET/MANUAL(Granel) é incoerente com a informação do campo SACO/GRANEL(Saco). Verifique.")
		lRes := .F.
	EndIf

	If M->Z8_SACGRA == "G"  .AND. !(M->Z8_PALLET $ "D|G")
		Alert("A informação do campo PALLET/MANUAL é incoerente com a informação do campo SACO/GRANEL(Granel). Verifique.")
		lRes := .F.
	EndIf

	if nOpc == 3 .AND. lRes
		if lPGInclu
			lRes := U_SMFATF31(nOpc)
		elseif !EMPTY(M->Z8_PAGER)
			Alert("Não é possível prosseguir a inclusão com o campo PAGER preenchido. Preencha-o apenas no momento do agenciamento.")
			M->Z8_PAGER := SPACE(TAMSX3("Z8_PAGER")[1])
			lRes := .F.
		endif
	endif

	if !EMPTY(nDTreino) .AND. SZ3->(FieldPos("Z3_DTREINO")) > 0 .AND. lRes// Unidade utiliza a validação e o campo existe
		DbSelectArea("SX6")
		DbSetOrder(1)
		if SX6->(DbSeek(xFilial("SX6")+'MV_MSGDTRE'))
			cMsgTre := &(Alltrim(X6_CONTEUD)+Alltrim(X6_CONTSPA)+Alltrim(X6_CONTENG))
		else
			cMsgTre := "O Certificado de treinamento do motorista "+Alltrim(SZ3->Z3_NOME)+" está vencido! Verifique."
		endif
		if (SZ3->Z3_DTREINO + nDTreino < DATE()) .OR. EMPTY(SZ3->Z3_DTREINO)
			Alert(cMsgTre)
			lRes := .F.
		endif
	endif

	if cEmpAnt+cFilAnt $ '3001|0210' .AND. GetNewPar('MV_SMLIGVD', .F. ) .AND. lRes
		lRes := SMVALDIST()
	endif

	dbSelectArea("SZ8")
	dbSetOrder(1)
	While dbSeek(xFilial("SZ8")+M->Z8_OC)
		M->Z8_OC := u_smgetSeq("SZ8","Z8_OC")
	EndDo

	M->Z8_USUARIO := Subs(Alltrim(cusuario),7,15)
	m->z8_pswmoto := sz3->z3_senhmot

Return(lRes)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF20                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SMFATF20()

	//Variavel adicionada em 28-06-2018 por Rodrigo (Semar) - Define quais empresas devem utilizar a SX5 PM Exclusiva
	Local	cFilExcl :=	if(cEmpAnt+cFilAnt $ getNewPar('MV_SMEX5PM','0210|0218'),cFilAnt,xFilial('SX5'))

	_aAliOri := GetArea()
	Private lRes     := .T.
	Private _copcoes := "3"
	Private _eixCam  := _eixCar := nTotpedag := _Peso := 0
	Private _lGatilho:= .f.

	If type('paramIXB')<>'U'
		_lGatilho:= iif( paramIXB<> nil, iif(paramIXB==1,.t.,.f.), .f. )
	Endif

	Private _pent     := M->Z8_PLTEN
	Private _psai     := M->Z8_PLTSA
	Private _hora     := M->Z8_HORA
	Private _lacre    := M->Z8_LACRE
	Private _placa    := M->Z8_PLACA
	Private _plcar2   := M->Z8_PLCAR2
	Private _veic     := M->Z8_TPVEIC
	Private _motor    := M->Z8_MOTOR
	Private cctr      := ""
	Private cfornece  := M->Z8_TRANSP
	Private clojaf    := M->Z8_LJTRANS
	Private _numOC    := M->Z8_OC
	Private plcar 	  := M->Z8_PLCAR
	Private cpm		  := M->Z8_PALLET

	If !_lGatilho
		If (M->Z8_TPOPER <> SZ8->Z8_TPOPER) .AND. !Empty(SZ8->Z8_STATUS2)
			Alert("Não é permitido alterar o TIPO DE OPERAÇÃO.")
			RestArea(_aAliOri)
			Return(.F.)
		EndIf

		If !u_SMFATF31()
			RestArea(_aAliOri)
			Return(.F.)
		EndIf

		//if !(ALLTRIM(M->Z8_LOCCARR) $ posicione('SX5',1,XFILIAL('SX5')+'PM'+alltrim(M->Z8_PALLET),"X5_DESCENG"))
		if !(ALLTRIM(M->Z8_LOCCARR) $ posicione('SX5',1,cFilExcl+'PM'+alltrim(M->Z8_PALLET),"X5_DESCENG"))
			Alert("Local de carregamento incompativel com o campo: Pallet/Man. ")
			return(.f.)
		endif
	EndIf

	SMFATF33()

	If (Len(aPedMark) <> 0 .or. _lGatilho ) .AND. M->Z8_TPOPER == "C" //Se houve selecao de pedido.

		If M->Z8_SACGRA == "S"  .AND. M->Z8_PALLET == "G"
			Alert("A informação do campo PALLET/MANUAL(Granel) é incoerente com a informação do campo SACO/GRANEL(Saco). Verifique.")
			lRes := .F.
		EndIf

		If M->Z8_SACGRA == "G"  .AND. M->Z8_PALLET <> "G"
			Alert("A informação do campo PALLET/MANUAL é incoerente com a informação do campo SACO/GRANEL(Granel). Verifique.")
			lRes := .F.
		EndIf

		If !SMFATF21(_lGatilho)
			lRes := .F.
		EndIf

		If !_lGatilho .and. lRes
			if !SMFATF28()
				lRes := .F.
				RestArea(_aAliOri)
				Return(.F.)
			endif
		EndIf
	ElseIf Len(aPedMark) <> 0 .AND. M->Z8_TPOPER == "D" //Se houve selecao de pedido.
		If !fRegDesc()
			RestArea(_aAliOri)
			Return(.F.)
		EndIf
	EndIf

	M->Z8_USUARIO := Subs(Alltrim(cusuario),7,15)
	M->z8_pswmoto := sz3->z3_senhmot

	If !empty(m->z8_status2)
		if !Empty(	If(SZ8->Z8_TPOPER=="C",Posicione("SZ1",8,xFilial("SZ1")+SZ8->Z8_OC,"Z1_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+SZ8->Z8_OC,"C7_YOC")))
			m->z8_status2:= iif( m->z8_patio == '1', '1','P')
		endif
	Endif

	RestArea(_aAliOri)

Return(iif( _lGatilho, iif(lres,_placa,"") ,lRes ) )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF21                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Realiza as criticas/verificacoes iniciais                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF21(p_lGatilho)

	SetPrvt("_LCREDOK,_BALENT")
	SetPrvt("_LRET,_LCONTINUA,_WSALSE1,_WSALSZ1")
	SetPrvt("_WATRASO,_WDIAS,_WPOSSZ1,_WCLI,_WLOJ,_WRISCO,WTOLBAL")
	Private npedagio	:=0
	Private cProduto 	:= CriaVar("Z1_PRODUTO")
	Private nNum     	:= CriaVar("Z1_NUM")
	Private oGetlacre
	Private nPesoTotal	:=0 //usada

	_AreaSZ1 := SZ1->(GetArea())

	p_lGatilho := iif( p_lGatilho<>nil, p_lGatilho, .f. )

	If UPPER(Alltrim(cUserName)) == "ALE"
		_BalEnt := "E:\BALENT.TXT"
	Else
		_BalEnt := alltrim(getmv("MV_YBALENT"))
	Endif

	If  ! file(_BalEnt)
		MsgBox("Arquivo da Balanca nao existe!","Atencao","ALERT")
	Endif

	DbSelectArea("SB1")
	DbSetOrder(1)
	nPesoTotal:=0

	If !p_lGatilho //Se for peso

		If _copcoes $ "2"//Se for peso
			If SZ8->Z8_PSENT <> 0 .or. ;
			empty(SZ8->Z8_PLACA) .or. ;
			empty(SZ8->Z8_MOTOR)
				MsgAlert("Peso ja lancado para o pedido! ","Atencao","Alert")
				Return
			EndIf
		Else
			DbSelectArea("SZ1")
			//nordem := IndexOrd()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSetOrder(0)			//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbGotop()				//Marcus Vinicius - 13/03/2018 - Desabilitado
			//Do while .not. eof()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			DbSetOrder(1)
			DbSeek(xFilial("SZ1"))
			Do while .not. eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1")  //Marcus Vinicius - 13/03/2018 - Incluído validação por filial

				If !EMPTY(SZ1->Z1_NUMNF) .OR. !EMPTY(SZ1->Z1_SERIE) .OR. !EMPTY(SZ1->Z1_OC) .OR. !EMPTY(SZ1->Z1_DTCANC)	//Marcus Vinicius - 13/03/2018 - Incluído validações para utilizar apenas pedidos válidos
					DbSkip()
					Loop
				EndIf

				If Marked("Z1_OK")

					If _copcoes $ "1" //Se for entrada
						If ! empty(SZ1->Z1_PLACA) .or. ;
						! empty(SZ1->Z1_MOTOR)
							MsgAlert("Entrada ja lancada para o pedido "+SZ1->Z1_NUM,"Atencao","Alert")
							Return
						EndIf
					ElseIf _copcoes $ "3" //entrada+peso
						// Alterado por Rodrigo
						If SZ1->Z1_PSENT <> 0
							MsgAlert("Peso ja lancado para o pedido "+SZ1->Z1_NUM,"Atencao","Alert")
							Return
						Endif

						If SZ1->Z1_OC <> SZ8->Z8_OC .And. !Empty(SZ1->Z1_OC)
							MsgAlert("O pedido não consta na ordem de carregamento "+SZ8->Z8_OC,"Atencao","Alert")
							Return
						Endif

						If SZ1->Z1_FRETE == "F"
							If SZ1->Z1_PLACA <> SZ8->Z8_PLACA .Or. ;
							SZ1->Z1_MOTOR <> SZ8->Z8_MOTOR
								MsgAlert("A Placa ou Motorista do pedido não conferem com os da OC!","Atencao","Alert")
								Return
							Endif
						ElseIf ( SZ1->Z1_PSENT <> 0 .or. ;
						! empty(SZ1->Z1_PLACA) .or. ;
						! empty(SZ1->Z1_MOTOR) ) .and. sz8->z8_oc <> sz1->z1_oc
							MsgAlert("Entrada e peso ja lancada para o pedido "+SZ1->Z1_NUM,"Atencao","Alert")
							Return
						Endif
					Endif

					If _copcoes $ "1,3" //Se for entrada ou entrada+peso
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se o pedido esta bloqueado                                      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If  SZ1->Z1_LIBER == "B"
							MsgBox("Pedido Bloqueado!","Atencao","ALERT")
							Return
						End
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica limite de credito                                               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If  SZ1->Z1_LIBER <> "S"
							_lCredOk := .T.

							SMFATF26()

							If  ! _lCredOk
								MsgBox("Pedido Bloqueado por Credito!","Atencao","ALERT")
								Return
							End
						End
					EndIf

					if (sz1->z1_unid == 'TL' .and. m->z8_sacgra <> 'G') .or. (sz1->z1_unid $ 'UN/SC' .and. m->z8_sacgra == 'G')
						MsgBox("Tipo de carta diferente entre Pedido e Agenciamento ... ","Atencao","ALERT")
						return .F.
					endif

					If SB1->(DbSeek( xFilial('SB1')+SZ1->Z1_PRODUTO  )) .And. SB1->B1_UM $ 'SC*SA*TN*TL'
						If !Empty(SB1->B1_CONV)
							Do Case
								Case SB1->B1_TIPCONV=='M'
								nPesoTotal+= SZ1->Z1_QUANT * SB1->B1_CONV
								Case SB1->B1_TIPCONV=='D'
								nPesoTotal+= SZ1->Z1_QUANT / SB1->B1_CONV
								OtherWise
								nPesoTotal+= SZ1->Z1_QUANT
							EndCase
						Endif

					Endif

					SZ4->(dbSetOrder(1))
					If SZ4->(DbSeek(xFilial("SZ4")+U_getMunic()))
						nPedagio += SZ4->Z4_PEDAGIO
					EndIf
				EndIf

				DbSelectArea("SZ1")	//Marcus Vinicius - 13/03/2018 - Desabilitado
				DbSkip()
			EndDo

			//SZ1->(DbSetOrder(nordem))	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//SZ1->(DbGotop())			//Marcus Vinicius - 13/03/2018 - Desabilitado
		EndIf

	endif


				RestArea(_AreaSZ1)

	_peso  := 0

	If !SMFATF22(p_lGatilho)
		Return(.f.)
	EndIf
	If !SMFATF23()
		Return(.f.)
	EndIf
	If !SMFATF24(p_lGatilho)
		Return(.f.)
	EndIf
	If !SMFATF25()
		Return(.f.)
	EndIf

	nTotPedag := npedagio * (_eixCam+_eixCar)

	m->z8_pedagio:= nTotPedag

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF22                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Verifica se o caminhao esta bloqueado                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF22(p_lGatilho)

	Local ndias := 0
	Local lret := .T., lachou
	Local lUsaNT   := SuperGetMV("MV_SMUSANT",,.F.) // Utiliza nova tela para dif. de peso?
	Local aAreaAtu := GetArea()

	p_lGatilho := iif( p_lGatilho<>nil, p_lGatilho, .f. )

	SZ2->(DbSetOrder(1))
	lachou:=SZ2->(DbSeek(xFilial("SZ2")+_placa))
	If lachou==.F.
		MsgBox("Placa nao existe, redigite.","Atencao","ALERT")
		lret := .F.
	EndIf
	If SZ2->Z2_TRAFEGO == "I"
		MsgBox("Atencao, veiculo nao aprovado em vistoria visual para trafego","Atencao","ALERT")
		lret := .F.
	EndIf

	IF SZ2->Z2_PESOTRA = 0 .and. !lUsaNT
		MsgBox("Atencao, o veiculo nao possui peso de transporte!!","Atencao","ALERT")
		lret := .F.
	ElseIF SZ2->Z2_PESOTRA > 0 .And. 	nPesoTotal > SZ2->Z2_PESOTRA .and. !p_lGatilho .and. !(cEmpAnt + cFilAnt $ '3001|0210|0101|0218')
		MsgBox("Peso acima da capacidade maxima do veiculo, verifique o pedido utilizado ou o cadastro do caminhão. ","Peso excedido","STOP")
		lret := .F.
	elseif lUsaNT
		if !U_SMEXCPESO('Agenciamento',0)
			lRet := .F.
		endif
	EndIf

	If SZ2->Z2_BLOQ == "S"
		MsgBox("Atencao, veiculo bloqueado!!","Atencao","ALERT")
		lret := .F.
	EndIf
	If SZ2->Z2_TIPO == "1"
		ndias := GETMV("MV_YDCAM")
	Else
		ndias := GETMV("MV_YDCAME")
	EndIf

	If cEmpAnt + cFilAnt $ "2001|2004|0222|0223"		// EMPRESA 02
		_aAliOri  := GetArea()
		_aAliSZ8  := SZ8->(GetArea())
		_aAliZA9  := ZA9->(GetArea())

		ZA9->(dbSetOrder(2))
		If ZA9->(dbSeek(xFilial("ZA9") + _placa))
			_nDiaVist := GetMV("MZ_VENCVIS")

			If (ZA9->ZA9_DTVIST + _nDiaVist) < Date()
				MSGSTOP("VISTORIA DO CAMINHAO VENCIDA!!")
				lret := .F.
			Endif
		Else
			MSGSTOP("CONTROLE DE VISTORIA DO CAMINHAO NAO ENCONTRADA!!")
			lret := .F.
		Endif

		RestArea(_aAliZA9)
		RestArea(_aAliSZ8)
		RestArea(_aAliOri)
	Else
		If cEmpAnt + cFilAnt $ '0104|0222'
			_aAliOri  := GetArea()
			_aAliSZ8  := SZ8->(GetArea())
			_aAliZA9  := ZA9->(GetArea())

			ZA9->(dbSetOrder(2))
			If ZA9->(dbSeek(xFilial("ZA9") + _placa))
				_nDiaVist := GetMV("MZ_VENCVIS")

				If (ZA9->ZA9_DTVIST + _nDiaVist) < Date()
					MSGSTOP("VISTORIA DO CAMINHAO VENCIDA!!")
					lret := .F.
				Endif
			Else
				MSGSTOP("CONTROLE DE VISTORIA DO CAMINHAO NAO ENCONTRADA!!")
				lret := .F.
			Endif

			RestArea(_aAliZA9)
			RestArea(_aAliSZ8)
			RestArea(_aAliOri)
		Else
			If SZ2->Z2_ULTC < ddatabase
				MsgBox("Atencao, vistoria atrasada !!! ","Atencao","ALERT")

				If ddatabase-ndias  > SZ2->Z2_ULTC .and. lret == .T.
					MsgBox("Atencao,favor atualizar os dados cadastrais do Caminhao antes de continuar.!!","Atencao","ALERT")
					lret := .F.
				EndIf
			EndIf
		Endif
	Endif

	If 	!p_lGatilho .and. ( (_peso > SZ2->Z2_TARA + 500 ) .or. (_peso < SZ2->Z2_TARA - 500 ) ) .AND. !lUsaNT
		Alert("Atencao, existe diferenca do peso de entrada para a tara do caminhao")
	EndIf

	If SZ2->Z2_EIXOS == 0
		Alert("Atenção, Número de Eixos não cadastrado para este caminhão.Favor alterar o Cadatro de Caminhões")
	EndIf

	_eixCam := SZ2->Z2_EIXOS
	nTotPedag := npedagio * (_eixCam+_eixCar)

	_motor := iif( !empty( M->Z8_MOTOR ), m->z8_motor, sz2->z2_mot )

	if !p_lGatilho

		For ix := 1 TO Len(aPedMark)

			nNum	 := aPedMark[ix,1]
			cProduto := GetAdvfVal("SZ1","Z1_PRODUTO",xFilial("SZ1")+nNum,1)

			DbSelectArea("SZ1")
			If GetAdvfVal("SB1","B1_YVEND",xFilial("SB1")+cProduto,1) = "S"   // em 23-12-08. A pedido da Marciane. Nao bloquear pedidos nao vendavel
				If GetAdvfVal("SZ1","Z1_FRETE",xFilial("SZ1")+nNum,1) = "F"
					If GetAdvfVal("SZ3","Z3_TIPO",xFilial("SZ3")+_motor,1) <> "3"
						Alert("Este Pedido é FOB, mas foi digitado um Motorista que não é Fob. Favor Corrigir")
						lret := .F.
					EndIf
				EndIf
			EndIf

			If GetAdvfVal("SZ3","Z3_TIPO",xFilial("SZ3")+_motor,1) == "3"
				If GetAdvfVal("SZ1","Z1_FRETE",xFilial("SZ1")+nNum,1) == "C"
					Alert("Este Pedido é CIF, mas foi digitado um Motorista que não é CIF. Favor Corrigir")
					lret := .F.
				EndIf
			EndIf

			SZ1->(dbSetorder(1))
			If SZ1->(dbSeek(xFilial("SZ1")+nNum))
				If SZ1->Z1_FRETE = "C"
					SZG->(dbSetOrder(1))
					If SZG->(!dbSeek(xFilial("SZG")+U_getMunic() + SZ8->Z8_TRANSP + SZ8->Z8_LJTRANS +"L"))
						MSGALERT("FAVOR CADASTRAR TABELA DE PRECO REF. AO FRETE DO COD.FORNECEDOR")
						lRet := .F.
					Endif
				Endif
			Endif
		Next
	Endif

	RestArea(aAreaAtu)

Return(lret)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF23                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Registra entrada do caminhao para carregamento             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF23()

	Local aAreaAtu := GetArea()
	Local lret := .T.,calias:=Alias(), ultd:=Ctod(Space(8))
	Private ndias := GETMV("MV_YDMOT")

	If _copcoes $ "1,3" .and. Empty(_placa)
		MsgBox("Proibido dar entrada sem placa","Atencao","ALERT")
		Return
	EndIf
	DbSelectArea("SZ3")
	DbSetOrder(1)
	DbSeek(xFilial("SZ3")+_motor)
	If SZ3->Z3_MSBLQL == "1"
		MsgBox("Atencao, motorista bloqueado!!","Atencao","ALERT")
		lret := .F.
	EndIf
	If SZ3->Z3_MSBLQL $ " 2" .and. SZ3->Z3_ULTC < (ddatabase-ndias)
		MsgBox("Atencao, A ultima atualização do Motorista foi em: [ " +dtoc(SZ3->Z3_ULTC) + " ], Conferir cadastro antes de continuar.","Atencao","ALERT")
		lret := .F.
	EndIf

	if lSenMot
		If empty(SZ3->Z3_SENHMOT)
			MsgBox("Atencao, Motorista sem S E N H A cadastrada !","Atencao","ALERT")
		EndIf
	endif

	lret:= u_SMFATF31()

	DbSelectArea(calias)
	RestArea(aAreaAtu)

Return(lret)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF24                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Verifica se o caminhao esta bloqueado                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF24(p_lGatilho)
	Local aAreaAtu := GetArea()

	lret := .T.

	SZZ->(DbSetOrder(1))
	lachou:=SZZ->(DbSeek(xFilial("SZZ")+plcar))

	If !(cEmpAnt $ "3001|0210")
		If !lachou .and. !p_lGatilho
			MsgBox("Placa da carreta nao existe, redigite.","Atencao","ALERT")
			lret := .F.
		EndIf

		If SZZ->ZZ_EIXOS == 0 .AND. ! ( plcar $ "TRUCK  ,TOCO   ")
			Alert("Atenção, Número de Eixos não cadastrado para esta carreta.Favor alterar o Cadastro de Carretas")
		EndIf

		_eixCar := SZZ->ZZ_EIXOS
		nTotPedag := npedagio * (_eixCam+_eixCar)
	EndIf

	If !Empty(plcar)
		If cEmpAnt + cFilAnt $ "2001|2004|0104|0222|0223"		// EMPRESA 02
			_aAliOri  := GetArea()
			_aAliSZ8  := SZ8->(GetArea())
			_aAliZA9  := ZA9->(GetArea())

			ZA9->(dbSetOrder(2))
			If ZA9->(dbSeek(xFilial("ZA9") + plCar))
				_nDiaVist := GetMV("MZ_VENCVIS")

				If (ZA9->ZA9_DTVIST + _nDiaVist) < Date()
					MSGSTOP("VISTORIA DA CARRETA VENCIDA!!")
					lret := .F.
				Endif
			Else
				MSGSTOP("CONTROLE DE VISTORIA DA CARRETA NAO ENCONTRADA!!")
				lret := .F.
			Endif

			RestArea(_aAliZA9)
			RestArea(_aAliSZ8)
			RestArea(_aAliOri)
		Endif
	Endif

	RestArea(aAreaAtu)

Return(lret)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF25                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Registra entrada do caminhao para carregamento             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF25()

	Local aAreaAtu := GetArea()
	Local lret := .T.,calias:=Alias()

	DbSelectArea("SA2")
	DbSetOrder(1)
	If !Empty(cfornece)
		If Empty(cLojaf)
			cLojaf := ""
		Endif
		If DbSeek(xFilial("SA2")+cfornece+clojaf)
			If SA2->A2_YFORCTR <> "S"
				MsgBox("Fornecedor: "+cfornece+" não está cadastrado como Transportador"+Chr(13)+Chr(10)+"Favor atualizar o cadastro de fornecedores","Atencao","ALERT")
				lret := .F.
			EndIf
			clojaf := SA2->A2_LOJA
		Else
			MsgBox("Transportador nao existe","Atencao","ALERT")
			lret := .F.
		EndIf
	EndIf

	RestArea(aAreaAtu)

Return(lret)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT20                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATT20(wOpcao)

	Local _senha    := space(10)
	Local lRet:=.F.

	return .T.

	DEFINE MSDIALOG oDlg2 TITLE "SIGEX -  ( SENHA )" FROM 020, 000  TO 150, 300 COLORS 0, 16777215 PIXEL

	@ 02,03 say "Senha:"
	@ 02,10 get _senha PassWord
	@ 40,80 BmpButton Type 1 Action Close(oDlg2)
	Activate MsDialog oDlg2 Centered


	wPsw:=""
	Do Case
		Case wOpcao $ 'OC*SAIDA' // Ordem de Carregamento
		wPsw:= GetNewPar("MV_YSENCAR",GetMV("MV_YSENHA"))
	EndCase
	lRet:= (AllTrim(_senha) == AllTrim(wPsw))
	If !lRet
		help("",1,"Y_MIZ008")
		Return .F.
	End
Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF26                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Verifica credito do cliente	                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function SMFATF26()

	Local _AreaZ1 := SZ1->(GetArea())

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA)

	_lRet      := .T.
	_lContinua := .T.

	If  ddatabase > SA1->A1_VENCLC
		_lRet      := .F.
		_lContinua := .F.
	End

	If  _lContinua
		If  SA1->A1_RISCO == "E"
			_lRet      := .F.
			_lContinua := .F.
		End
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica demais riscos                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  _lContinua
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializa variaveis                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_wSalSE1 := 0
		_wSalSZ1 := 0
		_wAtraso := 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Determina saldo em aberto - SE1-Contas a Receber                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE1")
		dbSetOrder(2)
		dbSeek(xFilial("SE1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA)
		While !eof() .and. SE1->E1_FILIAL  == xFilial("SE1")  ;
		.and. SE1->E1_CLIENTE == SZ1->Z1_CLIENTE ;
		.and. SE1->E1_LOJA    == SZ1->Z1_LOJA
			If  SE1->E1_SALDO == 0
				dbSkip()
				Loop
			End
			If  subs(SE1->E1_TIPO,3,1) == "-"
				_wSalSE1 := _wSalSE1 - SE1->E1_SALDO
			Else
				_wSalSE1 := _wSalSE1 + SE1->E1_SALDO
			End
			If  dtos(SE1->E1_VENCTO) < dtos(ddatabase)
				_wDias := ddatabase - SE1->E1_VENCTO
				If  _wDias > _wAtraso
					_wAtraso := _wDias
				End
			End
			dbSkip()
		End
		If  funname() == "MIZ020" .or. funname() == "#MIZ020"
			dbSelectArea("SZ1")
			_wPosSZ1 := recno()
			_wCli    := SZ1->Z1_CLIENTE
			_wLoj    := SZ1->Z1_LOJA
			_wSalSZ1 := 0

			dbSelectArea("SZ1")
			dbSetOrder(2)
			dbSeek(xFilial("SZ1")+_wCli+_wLoj)
			While !eof() .and. SZ1->Z1_FILIAL  == xFilial("SZ1") ;
			.and. SZ1->Z1_CLIENTE == _wCli           ;
			.and. SZ1->Z1_LOJA    == _wLoj
				If  ! empty(SZ1->Z1_NUMNF)
					dbSkip()
					Loop
				End
				_wSalSZ1 := _wSalSZ1 + (SZ1->Z1_QUANT * SZ1->Z1_PCOREF)
				dbSkip()
			End
			dbSelectArea("SZ1")
			dbSetOrder(3)
		End

		_lAchou := .F.
		ZA6->(dbSetOrder(1))
		If ZA6->(dbSeek(xFilial("ZA6") + SA1->A1_COD + SA1->A1_LOJA + "L"))
			If  (_wSalSE1 + _wSalSZ1) > ZA6->ZA6_VALOR .And. !SA1->A1_RISCO $ "A/S"
				_lAchou    := .T.
				_lRet      := .F.
				_lContinua := .F.
			Endif
		ElseIf  (_wSalSE1 + _wSalSZ1) > SA1->A1_LC .and. !SA1->A1_RISCO $ "A/S"
			_lAchou    := .T.
			_lRet      := .F.
			_lContinua := .F.
		Endif

		If !_lAchou
			_wRisco := 0
			Do Case
				Case SA1->A1_RISCO $ "A/S"
				_wRisco := 0
				Case SA1->A1_RISCO == "B"
				_wRisco := getmv("MV_RISCOB")
				Case SA1->A1_RISCO == "C"
				_wRisco := getmv("MV_RISCOC")
				Case SA1->A1_RISCO == "D"
				_wRisco := getmv("MV_RISCOD")
			EndCase
			If  _wAtraso > _wRisco
				_lRet      := .F.
				_lContinua := .F.
			Endif
		Endif
	Endif

	_lCredOk := _lRet

	RestArea(_AreaZ1)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF27                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SMFATF27(p_cTipo,p_cPort, p_cColeta)

	private nHdll := 0
	private cText := ''
	private ComEnt := iif( p_cPort<>nil, p_cPort, GetMv("MV_YCOMENT") )
	private cColeta:= "S"


	If p_cTipo=="S" //saida
		_BalES := alltrim(getmv("MV_YBALSAI"))
		cText := 'SAIDA'
	Else
		_BalES := alltrim(getmv("MV_YBALENT"))
		cText := 'ENTRADA'
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acessa arquivo da balanca                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  ! file(_BalES)
		MsgBox("Arquivo de " + cText + " da Balanca nao existe!","Atencao","ALERT")
		Return ""
	End
	cText := ''


	nVezes:= 5

	procregua(5)

	lprosseguir:= MsOpenPort(nHdll,ComEnt)

	if !lprosseguir
		apmsgalert('CC - Falha da ABERTURA da COM !')
	else
		Inkey(0.9)

		lprosseguir:= MSRead(nHdll,@cText)
		if !lprosseguir
			apmsgalert('BB - falha na LEITURA da COM!')
		else

			nVez:=1
			while .t.
				nVez+=1

				incproc('AA - lendo... '+str(nvez,3)+' de '+str(nVezes,3))

				//			if SM0->M0_CODFIL == "21" .or. sm0->m0_codigo  $ '02/20'
				if SM0->M0_CODIGO+SM0->M0_CODFIL = "0121" .or. (SM0->M0_CODIGO  = '02' .And. !SM0->M0_CODFIL $ "01|15|18|20|21")
					_peso := VAL(alltrim(substr(cText ,at(" ",cText)+1,12)))/100 //PesoContinuo()
				else
					//	apmsgalert('lendo peso balança 3')
					_peso := VAL(alltrim(substr(cText ,at(" ",cText)+1,8)))/100  //PesoContinuo()

				endif

				cText := substr(cText ,at(" ",cText))
				if _peso > 0 .or. nVez > nVezes
					exit
				elseif Mod(10,5) == 0
					nHdll := 0
					cText := ''
					MsClosePort(nHdll)
					MSRead(nHdll,@cText)
				endif
			enddo
		endif

		If _peso >= 88888
			Alert("Atencao, peso da balanca esta ERRADO. VERIFIQUE!")
		EndIf
		MsClosePort(nHdll)
		MSRead(nHdll,@cText)
	endif

	if !lprosseguir .or. _peso ==0

		_peso     := iif( subs(memoread(_BalES),11,1)=='/','"'+ AllTrim( subs(memoread(_BalES),1,10) ) ,subs(memoread(_BalES),1,10))
		If !(Subs(_peso,1,1) $ '0123456789')
			_peso    := Subs(_peso,2,7)
			_peso     := val(_peso)
		Else
			_peso     := val(_peso) / 100
		EndIf
		If _peso >= 88888
			Alert("Atencao, peso da balanca esta ERRADO. VERIFIQUE!")
		EndIf
	EndIf

	p_cColeta:= iif( _peso==0,"","S")

Return _peso


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF28                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Registra entrada do caminhao para carregamento             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function SMFATF28()

	Private ccli:=Space(8);cprod:=Space(15)
	Private lregra := .F.
	Private cctr:=Space(6),npedagio:=0,aenvio:={},_numOC:="000000"
	_numOC := M->Z8_OC

	If  Empty(cpm)
		MsgBox("Escolher TIPO DE CARREGAMENTO ( Palet/Manual ) !","Atencao","ALERT")
		Return
	EndIf

	Begin transaction

		If _copcoes $ "2"
			Reclock ("SZ8",.F.)
			SZ8->Z8_PSENT    := _peso
			SZ8->Z8_HORPES   := left(time(),5)
			MsUnlock()
			DbSelectArea("SZ1")
			DbSetOrder(8)
			DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
			Do while .not. eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1") .and. SZ1->Z1_OC == SZ8->Z8_OC
				While !Reclock ("SZ1",.F.);EndDo
				SZ1->Z1_PSENT    := _peso
				MsUnlock()
				DbSkip()
			EndDo
		Else
			DbSelectArea("SZ1")
			//nordem := IndexOrd()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSetOrder(0)			//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbGotop()				//Marcus Vinicius - 13/03/2018 - Desabilitado
			//Do while .not. eof()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			DbSetOrder(1)
			DbSeek(xFilial("SZ1"))
			Do while .not. eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1")  //Marcus Vinicius - 13/03/2018 - Incluído validação por filial

				If !EMPTY(SZ1->Z1_NUMNF) .OR. !EMPTY(SZ1->Z1_SERIE) .OR. !EMPTY(SZ1->Z1_OC) .OR. !EMPTY(SZ1->Z1_DTCANC)	//Marcus Vinicius - 13/03/2018 - Incluído validações para utilizar apenas pedidos válidos
					DbSkip()
					Loop
				EndIf

				If Marked("Z1_OK")
					Reclock ("SZ1",.F.)
					If !Empty(SZ1->Z1_OC) .and. sz1->z1_oc <> sz8->z8_oc
						MsgBox("ATENÇÃO: O pedido " +ALLTRIM(SZ1->Z1_NUM)+ " está agenciado na OC: "+ALLTRIM(SZ1->Z1_OC)+". Selecione outro pedido.","Atencao","STOP")
						SZ1->(msUnlock())
						ROLLBACK TRANSACTION
						Return
					EndIf
					SZ1->Z1_YPM := cpm
					SZ1->Z1_OC	:= M->Z8_OC
					If _copcoes $ "3"
						SZ1->Z1_PSENT    := _peso
					EndIf
					If _copcoes $ "1,3"
						SZ1->Z1_MOTOR    := _motor
						SZ1->Z1_PLCAR    := plcar
						SZ1->Z1_PLCAR2   := _plcar2
						SZ1->Z1_HORENT   := _hora
						SZ1->Z1_PALENT   := _pent
						SZ1->Z1_PALSAI   := _psai
						SZ1->Z1_NMOT     := SZ3->Z3_NOME
						SZ1->Z1_FORNECE  := cfornece
						SZ1->Z1_LOJAF    := clojaf
						SZ1->Z1_LACRE    := _lacre
					EndIf
					msUnlock()
					dbCommit()
				EndIf
				DbSkip()
			EndDo
			//DbSelectArea("SZ1")	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSetOrder(nordem)	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbGotop()				//Marcus Vinicius - 13/03/2018 - Desabilitado

		EndIf

		If _copcoes $ "1,3"
			DbSelectArea("SZ1")
			//nordem := IndexOrd()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSetOrder(0)			//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbGotop()				//Marcus Vinicius - 13/03/2018 - Desabilitado
			//Do while .not. eof()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSetOrder(1)			//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSeek(xFilial("SZ1"))//Marcus Vinicius - 13/03/2018 - Desabilitado
			DbSetOrder(8)
			DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
			Do while .not. eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1") .AND. SZ1->Z1_OC == SZ8->Z8_OC  //Marcus Vinicius - 13/03/2018 - Incluído validação por filial

				If !EMPTY(SZ1->Z1_NUMNF) .OR. !EMPTY(SZ1->Z1_SERIE) .OR. EMPTY(SZ1->Z1_OC) .OR. !EMPTY(SZ1->Z1_DTCANC)	//Marcus Vinicius - 13/03/2018 - Incluído validações para utilizar apenas pedidos válidos
					DbSkip()
					Loop
				EndIf

				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
				If Marked("Z1_OK") .and. SA1->A1_YFRECLI == 0
					SZ3->(DbSetOrder(1))
					SZ3->(DbSeek(xFilial("SZ3")+_motor))

					If SZ1->Z1_UNID == "SC"

						If  SZ3->Z3_TIPO == "1" .and. Empty(cFornece)
							MsgBox("Voce esta lancando um transporte com CTR, Sem Transportadora","Atencao","STOP")
							ROLLBACK TRANSACTION
							Return
						ElseIf SZ3->Z3_TIPO == "2" .and. !Empty(cFornece)
							MsgBox("Voce esta lancando um transporte com Motorista RPA, usando CTR","Atencao","STOP")
							ROLLBACK TRANSACTION
							Return
						EndIf

						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))

						If Alltrim(SB1->B1_TIPCAR) == "S"
							_nQtde := (SZ1->Z1_QUANT * SB1->B1_CONV) / 1000
						Else
							_nQtde := SZ1->Z1_QUANT
						Endif

						IF SZ1->Z1_FRETE == "C"
							If  SZ3->Z3_TIPO == "1" /* CTR SZG */
								SZG->(DbSetOrder(1))
								SZG->(DbSeek(xFilial("SZG")+U_getMunic()+cFornece + cLojaf +"L"))
								While !Reclock("SZ1",.f.);EndDo
								if  SZ1->Z1_COMDESC == "S"
									SZ1->Z1_FTRA := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRTRD,SZG->ZG_FRETED) ,2)
								else
									SZ1->Z1_FTRA := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRTRA,SZG->ZG_FRETE) ,2)
								endif

								SZ1->Z1_FMOT := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRMOT,SZG->ZG_FMOT) ,2)

							Else
								SZ4->(DbSetOrder(1))
								SZ4->(DbSeek(xFilial("SZ4")+U_getMunic()))

								While !Reclock("SZ1",.f.);EndDo
								if cEmpAnt + cFilAnt $ '3001|0210'

									if  SZ1->Z1_COMDESC == "S"
										SZ1->Z1_FTRA := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRTRD,SZG->ZG_FRETED) ,2)
									else
										SZ1->Z1_FTRA := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRTRA,SZG->ZG_FRETE) ,2)
									endif

								else
									SZ1->Z1_FTRA := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRTRA,SZG->ZG_FRETE) ,2)
								endif

								SZ1->Z1_FMOT := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZ4->Z4_FAGRMOT,SZ4->Z4_FMOT) ,2)
							EndIf
						ENDIF

						SZ1->(MsUnlock())
					EndIf
				EndIf
				//DbSelectArea("SZ1")	//Marcus Vinicius - 13/03/2018 - Desabilitado
				DbSkip()
			EndDo
			//SZ1->(DbSetOrder(nordem))	//Marcus Vinicius - 13/03/2018 - Desabilitado
		EndIf

		If _copcoes $ "1,3"  .and. !lBlqFrete

			_aAliSB1 := SB1->(GetArea())

			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek(xFilial("SZ3")+_motor))

			nvalmotm := 0
			nvaltram := 0
			DbSelectArea("SZ1")
			//nordem := IndexOrd()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSetOrder(0)			//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbGotop()				//Marcus Vinicius - 13/03/2018 - Desabilitado
			//Do while .not. eof()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSetOrder(1)			//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSeek(xFilial("SZ1"))//Marcus Vinicius - 13/03/2018 - Desabilitado
			DbSetOrder(8)
			DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
			Do while .not. eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1") .AND. SZ1->Z1_OC == SZ8->Z8_OC  //Marcus Vinicius - 13/03/2018 - Incluído validação por filial

				If !EMPTY(SZ1->Z1_NUMNF) .OR. !EMPTY(SZ1->Z1_SERIE) .OR. EMPTY(SZ1->Z1_OC) .OR. !EMPTY(SZ1->Z1_DTCANC)	//Marcus Vinicius - 13/03/2018 - Incluído validações para utilizar apenas pedidos válidos
					DbSkip()
					Loop
				EndIf

				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))

				SB1->(dbSetOrder(1))								//// ALTERADO 11/01/12
				SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))		//// ALTERADO 11/01/12

				If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
					_nQtde := (SZ1->Z1_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
				Else												//// ALTERADO 11/01/12
					_nQtde := SZ1->Z1_QUANT 						//// ALTERADO 11/01/12
				Endif												//// ALTERADO 11/01/12

				If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
					If cEmpAnt + cFilAnt $ '0101|0218'
						If cfilant == "03" .or. ;
						(SZ3->Z3_AGREGA == "S" .and. SZ3->Z3_TIPO == "1" .and. Alltrim(Left( U_getmunic(),2))=="ES") .or. ;
						(SZ3->Z3_AGREGA == "N" .and. SZ3->Z3_TIPO == "1" .and. Alltrim(Left( U_getmunic(),2))$"RJ,MG,ES")
							If Round(SZ1->Z1_FMOT / _nQtde,4) > nvalmotm     //// ALTERADO 11/01/12
								nvalmotm  := Round(SZ1->Z1_FMOT / _nQtde,4)  //// ALTERADO 11/01/12
								nvaltram  := Round(SZ1->Z1_FTRA / _nQtde,4)  //// ALTERADO 11/01/12
							EndIf
						EndIf
					ElseIf cEmpAnt + cFilAnt $ "1101|0213"
						If Round(SZ1->Z1_FMOT / _nQtde,4) > nvalmotm		 //// ALTERADO 11/01/12
							nvalmotm  := Round(SZ1->Z1_FMOT / _nQtde,4)		 //// ALTERADO 11/01/12
							nvaltram  := Round(SZ1->Z1_FTRA / _nQtde,4)		 //// ALTERADO 11/01/12
						EndIf
					EndIf
				EndIf
				DbSkip()
				If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. Round(SZ1->Z1_FTRA / _nQtde,4) <> nvaltram .and. nvaltram > 0
					lregra := .F.
				EndIf
			EndDo

			//SZ1->(DbSetOrder(nordem))	//Marcus Vinicius - 13/03/2018 - Desabilitado
			DbSelectArea("SZ1")
			//nordem := IndexOrd()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSetOrder(0)			//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbGotop()				//Marcus Vinicius - 13/03/2018 - Desabilitado
			//Do while .not. eof()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSetOrder(1)			//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSeek(xFilial("SZ1"))//Marcus Vinicius - 13/03/2018 - Desabilitado
			DbSetOrder(8)
			DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
			Do while .not. eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1") .AND. SZ1->Z1_OC == SZ8->Z8_OC  //Marcus Vinicius - 13/03/2018 - Incluído validação por filial

				If !EMPTY(SZ1->Z1_NUMNF) .OR. !EMPTY(SZ1->Z1_SERIE) .OR. EMPTY(SZ1->Z1_OC) .OR. !EMPTY(SZ1->Z1_DTCANC)	//Marcus Vinicius - 13/03/2018 - Incluído validações para utilizar apenas pedidos válidos
					DbSkip()
					Loop
				EndIf

				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))

				SB1->(dbSetOrder(1))								//// ALTERADO 11/01/12
				SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))		//// ALTERADO 11/01/12

				If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
					_nQtde := (SZ1->Z1_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
				Else												//// ALTERADO 11/01/12
					_nQtde := SZ1->Z1_QUANT 						//// ALTERADO 11/01/12
				Endif												//// ALTERADO 11/01/12

				If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. nvalmotm > 0 .and. SA1->A1_YFRECLI == 0
					While !Reclock("SZ1",.f.);EndDo
					SZ1->Z1_FTRA := Round(nvaltram * _nQtde,2) 		//// ALTERADO 11/01/12
					SZ1->Z1_FMOT := Round(nvalmotm * _nQtde,2)		//// ALTERADO 11/01/12
					MsUnlock()
				EndIf
				DbSkip()
			EndDo

			RestArea(_aAliSB1)

			//SZ1->(DbSetOrder(nordem))	//Marcus Vinicius - 13/03/2018 - Desabilitado
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verificar varias entregas  para o mesmo municipio                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If _copcoes $ "1,3"  .and. !lBlqFrete //bloqueia alterações nos valores do frete
			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek(xFilial("SZ3")+_motor))

			If SZ3->Z3_AGREGA == "N"

				If !(cEmpAnt + cFilAnt $ "1001|0226")
					nacfre  := GetMV("MV_YACFRE")
					nmulfre := GetMV("MV_YMULFRE")
					ndivfre := GetMV("MV_YDIVFRE")
					cmun  := Space(15)
					cuf   := Space(2)
					ccli  := Space(8)
					cprod := Space(15)
					lprimeiro := .T.
					lacres := .F.
					DbSelectArea("SZ1")
					//nordem := IndexOrd()	//Marcus Vinicius - 13/03/2018 - Desabilitado
					//DbSetOrder(0)			//Marcus Vinicius - 13/03/2018 - Desabilitado
					//DbGotop()				//Marcus Vinicius - 13/03/2018 - Desabilitado
					//Do while .not. eof()	//Marcus Vinicius - 13/03/2018 - Desabilitado
					//DbSetOrder(1)			//Marcus Vinicius - 13/03/2018 - Desabilitado
					//DbSeek(xFilial("SZ1"))//Marcus Vinicius - 13/03/2018 - Desabilitado
					DbSetOrder(8)
					DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
					Do while .not. eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1") .AND. SZ1->Z1_OC == SZ8->Z8_OC  //Marcus Vinicius - 13/03/2018 - Incluído validação por filial

						If !EMPTY(SZ1->Z1_NUMNF) .OR. !EMPTY(SZ1->Z1_SERIE) .OR. EMPTY(SZ1->Z1_OC) .OR. !EMPTY(SZ1->Z1_DTCANC)	//Marcus Vinicius - 13/03/2018 - Incluído validações para utilizar apenas pedidos válidos
							DbSkip()
							Loop
						EndIf

						SA1->(DbSetOrder(1))
						SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
						If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
							If lprimeiro
								cuf   := Left( U_getmunic(),2)
								cmun  := Substr( U_getmunic(),3)
								ccli  := SZ1->Z1_CLIENTE+SZ1->Z1_LOJA
								cprod := SZ1->Z1_PRODUTO
								lprimeiro := .F.
							Else
								If Substr( U_getmunic(),3)  == cmun .and. Left( U_getmunic(),2) == cuf
									If SZ1->Z1_CLIENTE+SZ1->Z1_LOJA <> ccli
										lacres := .T.
										Exit
									EndIf
								EndIf
							EndIf
						EndIf
						DbSkip()
					EndDo
					If lacres .and. !Alltrim(Upper(Left( U_getmunic(),2))) $ "BA" .and. lregra == .F.
						lregra := .T.
						DbSelectArea("SZ1")
						//DbSetOrder(0)			//Marcus Vinicius - 13/03/2018 - Desabilitado
						//DbGotop()				//Marcus Vinicius - 13/03/2018 - Desabilitado
						//Do while .not. eof()	//Marcus Vinicius - 13/03/2018 - Desabilitado
						//DbSetOrder(1)			//Marcus Vinicius - 13/03/2018 - Desabilitado
						//DbSeek(xFilial("SZ1"))//Marcus Vinicius - 13/03/2018 - Desabilitado
						DbSetOrder(8)
						DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
						Do while .not. eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1") .AND. SZ1->Z1_OC == SZ8->Z8_OC  //Marcus Vinicius - 13/03/2018 - Incluído validação por filial

							If !EMPTY(SZ1->Z1_NUMNF) .OR. !EMPTY(SZ1->Z1_SERIE) .OR. !EMPTY(SZ1->Z1_OC) .OR. !EMPTY(SZ1->Z1_DTCANC)	//Marcus Vinicius - 13/03/2018 - Incluído validações para utilizar apenas pedidos válidos
								DbSkip()
								Loop
							EndIf

							SA1->(DbSetOrder(1))
							SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))

							SB1->(dbSetOrder(1))								//// ALTERADO 11/01/12
							SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))		//// ALTERADO 11/01/12

							If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
								_nQtde := (SZ1->Z1_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
							Else												//// ALTERADO 11/01/12
								_nQtde := SZ1->Z1_QUANT 						//// ALTERADO 11/01/12
							Endif												//// ALTERADO 11/01/12

							If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
								While !Reclock("SZ1",.f.);EndDo
								IF !(SZ2->Z2_PLACA $ GETMV("MIZ_PLACAS"))
									SZ1->Z1_FMOT := SZ1->Z1_FMOT+Round(_nQtde * nacfre,2)                              //// ALTERADO 11/01/12
									SZ1->Z1_FTRA := SZ1->Z1_FTRA+Round(_nQtde * (Round(nacfre * nmulfre/ndivfre,2)),2) //// ALTERADO 11/01/12
								ENDIF
								MsUnlock()
							EndIf
							DbSkip()
						EndDo
					EndIf
					//SZ1->(DbSetOrder(nordem))	//Marcus Vinicius - 13/03/2018 - Desabilitado
				EndIf
			EndIf
		EndIf

		If _copcoes $ "1,3"  .and. !lBlqFrete //bloqueia alterações nos valores do frete
			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek(xFilial("SZ3")+_motor))

			If SZ3->Z3_AGREGA == "N"
				If !(cEmpAnt + cFilAnt $ "1001|0226")
					nacfre  := GetMV("MV_YACFRE")
					nmulfre := GetMV("MV_YMULFRE")
					ndivfre := GetMV("MV_YDIVFRE")
					cmun    := Space(15)
					cuf     := Space(2)
					nvaltra := 0
					nvalmot := 0
					lprimeiro := .T.
					lacres := .F.
					DbSelectArea("SZ1")
					//nordem := IndexOrd()	//Marcus Vinicius - 13/03/2018 - Desabilitado
					//DbSetOrder(0)			//Marcus Vinicius - 13/03/2018 - Desabilitado
					//DbGotop()				//Marcus Vinicius - 13/03/2018 - Desabilitado
					//Do while .not. eof()	//Marcus Vinicius - 13/03/2018 - Desabilitado
					//DbSetOrder(1)			//Marcus Vinicius - 13/03/2018 - Desabilitado
					//DbSeek(xFilial("SZ1"))//Marcus Vinicius - 13/03/2018 - Desabilitado
					DbSetOrder(8)
					DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
					Do while .not. eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1") .AND. SZ1->Z1_OC == SZ8->Z8_OC  //Marcus Vinicius - 13/03/2018 - Incluído validação por filial

						If !EMPTY(SZ1->Z1_NUMNF) .OR. !EMPTY(SZ1->Z1_SERIE) .OR. EMPTY(SZ1->Z1_OC) .OR. !EMPTY(SZ1->Z1_DTCANC)	//Marcus Vinicius - 13/03/2018 - Incluído validações para utilizar apenas pedidos válidos
							DbSkip()
							Loop
						EndIf

						SA1->(DbSetOrder(1))
						SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))

						SB1->(dbSetOrder(1))								//// ALTERADO 11/01/12
						SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))		//// ALTERADO 11/01/12

						If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
							_nQtde := (SZ1->Z1_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
						Else												//// ALTERADO 11/01/12
							_nQtde := SZ1->Z1_QUANT 						//// ALTERADO 11/01/12
						Endif												//// ALTERADO 11/01/12

						If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
							nvaltra += Round(SZ1->Z1_FTRA / _nQtde,6)		//// ALTERADO 11/01/12
							nvalmot += Round(SZ1->Z1_FMOT / _nQtde,6)		//// ALTERADO 11/01/12

							If lprimeiro
								cuf   := Left( U_getmunic(),2)
								cmun  := Substr( U_getmunic(),3)
								lprimeiro := .F.
							Else
								If Substr( U_getmunic(),3) <> cmun .and. ;
								Round(SZ1->Z1_FTRA / _nQtde,6) == nvaltra .and. Round(SZ1->Z1_FMOT / _nQtde,6) == nvalmot //// ALTERADO 11/01/12
									lacres := .T.
								EndIf
								If Round(SZ1->Z1_FTRA / _nQtde,6) <> nvaltra .or. Round(SZ1->Z1_FMOT / _nQtde,6) <> nvalmot //// ALTERADO 11/01/12
									lacres := .F.
									exit
								EndIf
							EndIf
						EndIf
						DbSkip()
					EndDo
					If lacres .and. !Alltrim(Upper(Left( U_getmunic(),2))) $ "BA" .and. lregra == .F.
						lregra := .F.
						DbSelectArea("SZ1")
						//DbSetOrder(0)			//Marcus Vinicius - 13/03/2018 - Desabilitado
						//DbGotop()				//Marcus Vinicius - 13/03/2018 - Desabilitado
						//Do while .not. eof()	//Marcus Vinicius - 13/03/2018 - Desabilitado
						//DbSetOrder(1)			//Marcus Vinicius - 13/03/2018 - Desabilitado
						//DbSeek(xFilial("SZ1"))//Marcus Vinicius - 13/03/2018 - Desabilitado
						DbSetOrder(8)
						DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
						Do while .not. eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1") .AND. SZ1->Z1_OC == SZ8->Z8_OC  //Marcus Vinicius - 13/03/2018 - Incluído validação por filial

							If !EMPTY(SZ1->Z1_NUMNF) .OR. !EMPTY(SZ1->Z1_SERIE) .OR. EMPTY(SZ1->Z1_OC) .OR. !EMPTY(SZ1->Z1_DTCANC)	//Marcus Vinicius - 13/03/2018 - Incluído validações para utilizar apenas pedidos válidos
								DbSkip()
								Loop
							EndIf

							SA1->(DbSetOrder(1))
							SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))

							SB1->(dbSetOrder(1))								//// ALTERADO 11/01/12
							SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))		//// ALTERADO 11/01/12

							If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
								_nQtde := (SZ1->Z1_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
							Else												//// ALTERADO 11/01/12
								_nQtde := SZ1->Z1_QUANT 						//// ALTERADO 11/01/12
							Endif												//// ALTERADO 11/01/12

							If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
								While !Reclock("SZ1",.f.);EndDo
								IF !(SZ2->Z2_PLACA $ GETMV("MIZ_PLACAS"))
									SZ1->Z1_FMOT := SZ1->Z1_FMOT+Round(_nQtde * nacfre,2) //// ALTERADO 11/01/12
									SZ1->Z1_FTRA := SZ1->Z1_FTRA+Round(_nQtde * (Round(nacfre*nmulfre/ndivfre,2)),2) //// ALTERADO 11/01/12
								ENDIF
								MsUnlock()
							EndIf
							DbSkip()
						EndDo
					EndIf
					//SZ1->(DbSetOrder(nordem))	//Marcus Vinicius - 13/03/2018 - Desabilitado
				EndIf
			EndIf
		EndIf

		If _copcoes $ "1,3"
			Aadd(aenvio,_placa)
			Aadd(aenvio,_motor)
			Aadd(aenvio,_peso)
			Aadd(aenvio,cctr)
			Aadd(aenvio,nTotPedag)
			Aadd(aenvio,cfornece)
			Aadd(aenvio,_numOC)
			Aadd(aenvio,cpm)
			Aadd(aenvio,plcar)
			Aadd(aenvio,_plcar2)
			Aadd(aenvio,cLojaF)

			IF AllTrim(SuperGetMV("MV_OCUSAGR",.F.,"N")) == "S"
				ExecBlock("MIZ050GR",.F.,.F.,aenvio)  // Esse fonte grava os regs na SZ8 e NR.OC NA SZ1 e imprime a OC.
			ELSE
				ExecBlock("MIZ050",.F.,.F.,aenvio)	  // Esse fonte grava os regs na SZ8 e NR.OC NA SZ1 e imprime a OC.
			ENDIF

			// Abaixo as gravacoes nos novos campos da SZ8
			dbSelectArea("SZ8")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ8")+M->Z8_OC)
				While !Reclock("SZ8",.f.);EndDo
				SZ8->Z8_SACGRA      := M->Z8_SACGRA
				SZ8->Z8_LACRE		:= M->Z8_LACRE
				SZ8->Z8_TPOPER		:= M->Z8_TPOPER
				SZ8->Z8_PAGER		:= M->Z8_PAGER
				//SZ8->Z8_STATUS2		:= "1" //No pátio
				MsUnlock()
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualizar placa no final para resolver problema no filtro                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If _copcoes $ "1,3"
			DbSelectArea("SZ1")
			//nordem := IndexOrd()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSetOrder(0)			//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbGotop()				//Marcus Vinicius - 13/03/2018 - Desabilitado
			//Do while .not. eof()	//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSetOrder(1)			//Marcus Vinicius - 13/03/2018 - Desabilitado
			//DbSeek(xFilial("SZ1"))//Marcus Vinicius - 13/03/2018 - Desabilitado
			DbSetOrder(8)
			DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
			Do while .not. eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1") .AND. SZ1->Z1_OC == SZ8->Z8_OC  //Marcus Vinicius - 13/03/2018 - Incluído validação por filial

				If !EMPTY(SZ1->Z1_NUMNF) .OR. !EMPTY(SZ1->Z1_SERIE) .OR. EMPTY(SZ1->Z1_OC) .OR. !EMPTY(SZ1->Z1_DTCANC)	//Marcus Vinicius - 13/03/2018 - Incluído validações para utilizar apenas pedidos válidos
					DbSkip()
					Loop
				EndIf

				If Marked("Z1_OK")
					Reclock ("SZ1",.F.)
					SZ1->Z1_PLACA    := _placa
					MsUnlock()
				EndIf
				DbSkip()
			EndDo
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Encerra funcao                                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	End Transaction

Return(.T.)


/** BOTAO LEGENDA - MOSTRA AS CORES **/
/*
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

#define CLR_BLACK             0               // RGB(   0,   0,   0 )
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 )
#define CLR_GREEN         32768               // RGB(   0, 128,   0 )
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 )
#define CLR_RED             128               // RGB( 128,   0,   0 )
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 )
#define CLR_BROWN         32896               // RGB( 128, 128,   0 )
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 )
#define CLR_LIGHTGRAY
*/


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF29                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATF29


	Brwlegenda(cCadastro, "Legenda",{{"BR_BRANCO"  ,"Não Agenciado"},;
	{"BR_LARANJA" ,"Agenciado - Programado"},;
	{"BR_AMARELO" ,"Agenciado - No Patio"},;
	{"BR_VERDE"   ,"Chamado"},;
	{"BR_PINK"    ,"Pesado na Entrada"},;
	{"BR_AZUL"    ,"Início Carga/Descarga"},;
	{"BR_PRETO"   ,"Fim Carga/Descarga"},;
	{"BR_VERMELHO","Em Espera"},;
	{"BR_MARROM"  ,"F a t u r a d a"},;
	{"BR_CANCEL"  ,"Cancelada"},;
	{"NOTE_PQ"   ,"Em Alteração"}})  //Normando (Semar) 05/11/2015 - Incluir legenda
Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF30                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATF30(p_cComutadora)

	Local cComutadora := iif(p_cComutadora== NIL, '00', p_cComutadora)
	TerServ(cComutadora)
Return

Static Function fRegDesc()
	Local lres := .T.

	dbSelectArea('SC7')
	dbsetorder(1)
	For ixd := 1 TO Len(aPedMark)
		If dbSeek(xFilial('SC7')+aPedMark[ixd,1])
			While !RecLock("SC7",.F.) ; End

			If !Empty(SC7->C7_YOC)
				MsgBox("ATENÇÃO: O pedido " +ALLTRIM(aPedMark[ixd,1])+ " está agenciado na OC: "+ALLTRIM(SC7->C7_YOC)+". Selecione outro pedido.","Atencao","STOP")
			EndIf

			SC7->C7_YOC = M->Z8_OC
			SC7->(MsUnlock())
		EndIf
	Next

Return(lres)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF31                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


user Function SMFATF31(p_nOpc)

	local lcontinua	:= .T.
	local lRes 		:= .T.
	local nMaxPager	:= GETMV("MV_MAXPAGE")
	local aAreaAtu	:= GetArea()
	Local cCBAux
	Local cZZPag	:= Replicate("Z",TAMSX3("Z8_PAGER")[1])
	Local aPgs		:= u_SMFATF71()
	Local nOpc		:= if(p_nOpc==nil,0,p_nOpc)

	if !lusaPager; return lres ; endif

	//If Empty(M->Z8_STATUS2) ; return (lRes); endif
	//Adicionada nova condicional por Rodrigo (Semar) em 24/08/16 - para tratar quando for chamada pela tela de inclusão
	If Empty(M->Z8_STATUS2) .AND. EMPTY(nOpc) ; return (lRes); endif


	do case
		//case Empty(M->Z8_PAGER)
		case Empty(M->Z8_PAGER) .AND. EMPTY(nOpc) //Alterado por Rodrigo (Semar) - apenas reclamar de obrigatoriedade no momento de agenciamento
		ALERT("Informe o número do pager.")
		lcontinua:= .f.
		//Condição adicionada por Rodrigo (Semar) em 24/08/16 - tratar quando o pager for removido para OC sem pedido.
		case Empty(M->Z8_PAGER) .AND. !EMPTY(nOpc)
		lcontinua:= .t.
		//
		case val(M->Z8_PAGER)<=0 .and. M->Z8_PAGER<>cZZPag
		ALERT("O campo PAGER,  aceita apenas numeros !")
		lcontinua:= .f.
		case val(M->Z8_PAGER)<=0 .and. M->Z8_PAGER=cZZPag .and. (len(aPgs)>1 .Or. aPgs[1] != cZZPag)
		ALERT("O pager "+cZZPag+" só pode ser usado quando não tiver mais pagers disponiveis.")
		lcontinua:= .f.
		case val(M->Z8_PAGER) > nMaxPager
		ALERT("A numeração do pager deve ser menor ou igual a [ '"+strzero(nMaxPager,TAMSX3("Z8_PAGER")[1])+"' ]")
		lcontinua:= .f.
		otherwise


		cSql := "SELECT Z8_OC,Z8_PAGER FROM "+RetSqlName("SZ8")+" SZ8 "
		cSql += " WHERE SZ8.D_E_L_E_T_ = ' '"
		cSql += " AND   SZ8.Z8_FILIAL  = '" +xFilial("SZ8")+ "'"
		cSql += " AND   SZ8.Z8_PAGER   = '" + M->Z8_PAGER + "'"
		cSql += " AND   SZ8.Z8_OC   <> '" + M->Z8_OC + "'"

		If Select("QrySZ8") > 0
			dbSelectArea("QrySZ8")
			QrySZ8->(DbCloseArea())
		EndIf

		TcQuery cSql New Alias "QrySZ8"

		If  QrySZ8->(!Eof()) .AND. QrySZ8->Z8_PAGER <> cZZPag
			ALERT("Nº DE PAGER NÃO PERMITIDO: Este pager já está sendo usado na ORDEM DE CARREGAMENTO/DESCARREGAMENTO: "+Alltrim(QrySZ8->Z8_OC)+". Verifique.")
			QrySZ8->(DbCloseArea())
			RestArea(aAreaAtu)
			lRes := .F.
			lcontinua:=.f.
		EndIf

	endcase

	if !lcontinua
		sz8->(dbsetorder(1))
		sz8->(dbseek(xfilial('SZ8')+M->Z8_OC))
		cPgOld:= sz8->z8_pager
		M->Z8_PAGER := u_SMFATT27(cPgOld)
		M->Z8_CBPAGER := U_SMFATF95(M->Z8_PAGER) //cValtoChar(10000000 + val(M->Z8_PAGER) )
	EndIf //incluso por Richardson
	//Adicionado por Rodrigo (Semar) em 24/08/16 para tratar o tipo de retorno de acordo com a operação
	if nOpc == 3
		lRes := !empty(M->Z8_PAGER) .OR. lContinua
	else
		lRes := !empty(M->Z8_PAGER)
	endif
	RestArea(aAreaAtu)

Return(lRes)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT14                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATT14(p_cLacre)

	Local cRet:=""
	local cLacre := Space(6)
	local oFont1     := TFont():New( "Verdana",0,-12,,.T.,0,,700,.F.,.F.,,,,,, )
	local warea:= getArea()

	private oLacre
	private oBrw1

	//If cEmpAnt $ "01|11|30"	// Comentado por Rodrigo (Semar) - 21/06/16
	If cEmpAnt + cFilAnt $ "0101|0218|1101|0213|3001|0210"
		cLacre := Space(8)
	Endif

	nOpc1:=0

	ctpRefresh:= '0'

	aColsLacre:={}
	aAux:={}
	if p_clacre <> nil .and. !empty(p_clacre)
		aAux:= STRTOKARR(p_clacre,"/")
		for xi:=1 to len(aaux)
			AAdd(aColsLacre,{aaux[xi]})
		next
		ctpRefresh:= '3'
	endif


	DbSelectArea("SX3")
	DbSetOrder(2) // Nome Campo

	waHeader:={}
	waColSizes:={}
	dbSeek("Z8_LACRE");aAdd(waHeader, Trim(X3Titulo()) ) 			 ; aAdd(waColSizes,6)

	oDlg      := MSDialog():New( 69,33 ,440,355,"Digitação dos Nrs. dos Lacres",,,.F.,,,,,,.T.,,,.T. )

	@ 001.3,003 GET oLacre VAR cLacre SIZE 100, 10 OF oDlg //valid SMFATT15(cLacre)
	oLacre:bLostFocus:=  {|| SMFATT15('1', cLacre), oDlg:refresh() }

	oBrw1 := TCBrowse():New( 030,005,150,140,,waHeader,waColSizes,oDlg,,,,,{||},,oFont1,,,,,.F.,,.T.,,.F.,,.T.,.T.)

	SMFATT15(	ctpRefresh )


	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpc1 := 1, cRet:=SMFATF32(), oDlg:End()},{|| nOpc1 := 2,oDlg:End()}) CENTERED



	restArea(warea)
Return(cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF32                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF32()

	Local cRet:=""
	Local wArea:=GetArea()

	cRet:=""
	For i:=1 to len(acolsLacre)
		if empty(acolsLacre[i,1]); loop; endif

		if !Empty(cRet)
			cRet+= "/"
		endif

		cRet+=alltrim(acolsLacre[i,1])

	Next

	RestArea(wArea)
Return(cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT15                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


static function SMFATT15(p_ctpRefresh, p_cGetLacre)
	local lret:= .t.
	local nMaxLacre:= 8

	if p_ctpRefresh=='1' .and. empty(p_cGetLacre); return .f. ; endif


	ncont:=0

	For i:=1 to len(acolsLacres)

		ncont++

		If alltrim(acolsLacres[i,1]) == alltrim(p_cGetlacre)
			alert('Lacre ja informado na posicao de nr. [ '+str(i,2)+' ]')
			aDel( acolsLacres, i )
			aSize( acolsLacres, Len(acolsLacres)-1 )
			lret:= .f.
			exit
		Endif
	Next

	if lret
		lret:= ( ncont<=nMaxLacre )
		if !lret
			Alert('Sao permitidos ate 8 lacres!')
		endif
	endif

	if lret .and. p_ctpRefresh $ '0|1'

		if p_ctpRefresh=='0'
			p_cGetLacre:=space(6)
		endif

		aListAux :={}

		aListAux :={ p_cGetLacre }

		aAdd(acolsLacre, aListAux)

	endif

	oBrw1:SetArray(acolsLacre)
	oBrw1:bLine := {|| { oBrw1:aArray[oBrw1:nAt,01] }}
	oBrw1:refresh()

	oLacre:setfocus()

return lret


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF33                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

static function SMFATF33()

	local warea:= getArea()

	If SZ8->Z8_TPOPER == "C" .AND. Len(aPedDesMar)<>0
		dbSelectArea('SZ1')
		dbsetorder(1)
		For ixd := 1 TO Len(aPedDesMar)
			If dbSeek(xFilial('SZ1')+aPedDesMar[ixd,1]) .and. sz1->z1_oc == sz8->z8_oc
				While !RecLock("SZ1",.F.) ; End
				SZ1->Z1_OC = " "
				SZ1->Z1_PLACA = SPACE(07)
				SZ1->Z1_MOTOR = " "
				SZ1->Z1_HORENT := Space(05)
				SZ1->Z1_NMOT   := Space(40)
				SZ1->(MsUnlock())
			EndIf
		Next
	ElseIf SZ8->Z8_TPOPER == "D" .AND. Len(aPedDesMar)<>0 .and. sz1->z1_oc == sz8->z8_oc
		dbSelectArea('SC7')
		dbsetorder(1)
		For ixd := 1 TO Len(aPedDesMar)
			If dbSeek(xFilial('SC7')+aPedDesMar[ixd,1])
				While !RecLock("SC7",.F.) ; End
				SC7->C7_YOC = " "
				SC7->(MsUnlock())
			EndIf
		Next
	EndIf

	restArea(warea)

return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT16                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Altera peso calculado, mediante senha                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SMFATT16(p_nPeso,p_cTitulo)

	Local cTitulo := " LIBERAÇÃO DO PESO MANUAL"   //Richardson Martins - Sema Sistema 11/06/14
	Local cOpcao  := ""
	Local cQdoSenha := getnewPar('MV_QDOSEN','UMAVEZDIA') // Quando Pede Senha:  'UMAVEZDIA'- Uma vez ao dia ----    'SEMPRE' - Sempre em todas as ocorrencias
	Local wcTitulo:= iif(p_cTitulo<>Nil, p_cTitulo+" [Manual]", 'Informar Peso Liquido <Manual>')

	_peso_liqinf:=0


	If  (SZ1->Z1_UNID $ "SC,SA")  .and. (p_nPeso==nil)
		alert('Nao permitida alteração de peso para as UNIDADES - SC/SA ')
		return ("")
	Endif


	//Normando (Semar) 26/11/2015 Corrigir inclusão do parametro
	if !SX6->(DbSeek(xFilial("SX6")+"MV_YDTSEN"))
		If sx6->(reclock('SX6',.T.))
			sx6->x6_fil     := xFilial("SX6")
			sx6->x6_var     := "MV_YDTSEN"
			sx6->x6_tipo    := "C"
			sx6->x6_descric := "Data de liberacao para usar o botao peso manual"
			sx6->x6_conteud := ""
			sx6->(MsUnlock())
		EndIf
	EndIf

	//Sergio (Semar) 02/02/2016 Nova senha
	//####################################
	If cQdoSenha=='SEMPRE' .OR. ( cQdoSenha=='UMAVEZDIA' .and. getMV('MV_YDTSEN') <> DTOS(DDATABASE) )  //entra  pra pedir a senha 1 vez por dia

		oDlgPsw	:= TDialog():New(0,0,100,480,"Liberação de peso manual",,,,,,,,,.T.)
		oSay3	:= TSay():New(010,020,{||'Favor solicitar autorização ao Sr.'+GETNEWPAR("MV_YRESEXP","")+', atraves de uma das opções abaixo:'},oDlgPsw,,,,,,.T.,CLR_RED,CLR_WHITE,200,20)
		oTBtn1 	:= TButton():New( 030, 100, "Email",oDlgPsw,{||cOpcao := "Email", oDlgPsw:End()},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTBtn2 	:= TButton():New( 030, 150, "SMS"  ,oDlgPsw,{||cOpcao := "SMS"  , oDlgPsw:End()},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oDlgPsw:Activate()

		if Empty(cOpcao); return (""); endif


		if !u_smvld2Psw('PESOMANUAL',cOpcao)
			help("",1,"Y_MIZ008")
			Return ("")
		endif


	Endif
	putMV('MV_YDTSEN',DTOS(DATE()))

	DEFINE MSDIALOG oDlgNewPeso TITLE wcTitulo FROM 40,50 TO 200,400 PIXEL
	@ 40,15 say "Peso Liquido: (TL)"
	@ 40,70 get _peso_liqinf  Size 60,100   Pict "999,999,999.99"
	@ 60,100 BmpButton Type 1 Action Close(oDlgNewPeso)
	Activate MsDialog oDlgNewPeso Centered
	If  !(SZ1->Z1_UNID $ "SC,SA")  .AND. (p_nPeso==nil)
		_peso_liq      := _peso_liqinf
		ypalt:="S"
		odlg1:refresh()
	EndIf

	If p_nPeso<> nil
		p_nPeso:=_peso_liqinf
	Endif



Return iif(_peso_liqinf>0 ,"M","" )   //Retorna o tipo de coleta:   M-Manual ou ""- Nao houve coleta


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF34                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Altera peso calculado, mediante senha                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF34(cAlias,nReg,nOpc,aPosicao)

	Local aCampos  := {"Z8_OC","Z8_DATA","Z8_HORA","Z8_HRAGENC","Z8_TPOPER","Z8_PRODUTO","Z8_QUANT","Z8_PALLET","Z8_PLTEN","Z8_PLTSA","Z8_PAGER","Z8_LACRE","Z8_SACGRA","Z8_OBS","Z8_USUARIO","Z8_NFCOMP","Z8_SERNF","Z8_NFPESEN","Z8_TICKENT","Z8_PATIO","Z8_CATEGMP","Z8_CBPAGER","Z8_LOCCARR","NOUSER"}
	Local aEdit    := {"Z8_OC","Z8_DATA","Z8_HORA","Z8_HRAGENC","Z8_TPOPER","Z8_PRODUTO","Z8_QUANT","Z8_PALLET","Z8_PLTEN","Z8_PLTSA","Z8_PAGER","Z8_LACRE","Z8_SACGRA","Z8_OBS","Z8_USUARIO","Z8_NFCOMP","Z8_SERNF","Z8_NFPESEN","Z8_TICKENT","Z8_PATIO","Z8_CATEGMP","Z8_CBPAGER","Z8_LOCCARR"}
	Static oEnchoice1

	oEnchoice1 := MsMGet():New(cAlias,nReg,nOpc,,,,aCampos,aPosicao,aEdit,,,,,oDlg,,,,,.F.)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ fEnchoice3                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function fEnchoice3(cAlias,nReg,nOpc,aPosicao)

	Local aCampos  := {"Z8_MOTOR","Z8_NOMMOT","Z8_NMTRANS","Z8_FORNECE","Z8_LOJAFOR","Z8_TRANSP","Z8_LJTRANS","NOUSER"}
	Local aEdit    := {"Z8_MOTOR","Z8_NOMMOT","Z8_NMTRANS","Z8_FORNECE","Z8_LOJAFOR","Z8_TRANSP","Z8_LJTRANS"}
	Static oEnchoice3

	oEnchoice3 := MsMGet():New(cAlias,nReg,nOpc,,,,aCampos,aPosicao,aEdit,,,,,oDlg,,,,,.F.)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ fEnchoice2                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function fEnchoice2(cAlias,nReg,nOpc,aPosicao)

	//Local aCampos  := {"Z8_PLACA","Z8_PLCAR","Z8_PLCAR2","Z8_TPVEIC","Z8_VISTOR","Z8_DTVIST","Z8_MUNIC","Z8_ESTADO","Z8_CILINDR","NOUSER"} //Semar - Juailson em 25/11/14
	Local aCampos  := {"Z8_TPVEIC","Z8_PLACA","Z8_PLCAR","Z8_PLCAR2","Z8_VISTOR","Z8_DTVIST","Z8_MUNIC","Z8_ESTADO","Z8_CILINDR","NOUSER"} //Normando (Semar) - 27/08/2015 Ordem do campos
	//Local aEdit    := {"Z8_PLACA","Z8_PLCAR","Z8_PLCAR2","Z8_TPVEIC","Z8_VISTOR","Z8_DTVIST","Z8_MUNIC","Z8_ESTADO","Z8_CILINDR"}          //Semar - Juailson em 25/11/14
	Local aEdit    := {"Z8_TPVEIC","Z8_PLACA","Z8_PLCAR","Z8_PLCAR2","Z8_VISTOR","Z8_DTVIST","Z8_MUNIC","Z8_ESTADO","Z8_CILINDR"}          //Normando (Semar) - 27/08/2015 Ordem do campos

	Static oEnchoice2

	oEnchoice2 := MsMGet():New(cAlias,nReg,nOpc,,,,aCampos,aPosicao,aEdit,,,,,oDlg,,,,,.F.)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT17                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Altera peso calculado, mediante senha                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATT17(cAlias,nReg,nOpc)

	Static oDlg
	Static oGroup1
	Static oGroup2
	Static oGroup3
	Local aSize	  := {}
	Local aInfo    := {}
	Local aObjects := {}
	Local nOpca    := 2
	Local cOCOld   := SZ8->Z8_OC
	local lF80Prosseg:=.t.
	Local aButtons := {}
	Private aPedMark   := {}
	Private aPedDesMar := {}

	If !u_ChkAcesso("SMFATT17",nOpc,.T.)          // Marcus Vinicius - 26/09/2017 - Controle de acesso para bloquear transportadora
		Return
	EndIf

	If nOpc == 3
		If (cEmpAnt + cFilAnt $ '0101|0218') .AND. cNivel < 5
			MsgBox ("Usuário sem permissão a essa rotina","Bloqueio de Acesso","STOP")
			Return
		Else
			cTitulo := "Inclusão"
		EndIf
	ElseIf nOpc == 4
		cTitulo := "Alteração"
	ElseIf nOpc == 2
		cTitulo := "Visualização"
	ElseIf nOpc == 5
		cTitulo := "Exclusão"
	Endif

	If nOpc == 5
		If SZ8->Z8_STATUS2 == "1"
			ALERT("EXCLUSÃO NÃO PERMITIDA: A ordem ja possui pedidos associados. Verifique.")
			Return Nil
		EndIf

		If SZ8->Z8_STATUS2 >= "3"
			ALERT("EXCLUSÃO NÃO PERMITIDA: O veículo já iniciou o carregamento/descarregamento. Verifique.")
			Return Nil
		EndIf

		If SZ8->Z8_TPOPER == "D"
			dbSelectArea('SC7')
			dbsetorder(RetOrdem("SC7","C7_FILIAL+C7_YOC"))
			If sc7->(dbSeek(xFilial('SC7')+cOCOld))
				While SC7->C7_FILIAL == xFilial("SC7") .AND.;
				SC7->C7_YOC == cOCOld

					cSql := "SELECT D1_DOC, D1_SERIE FROM "+RetSqlName("SD1")+" SD1 "
					cSql += " WHERE SD1.D_E_L_E_T_ = ' '"
					cSql += " AND   SD1.D1_FILIAL  = '" +xFilial("SD1")+ "'"
					cSql += " AND   SD1.D1_PEDIDO  = '" + SC7->C7_NUM + "'"
					If Select("QrySC7") > 0
						dbSelectArea("QrySC7")
						QrySC7->(DbCloseArea())
					EndIf
					//wSQL := ChangeQuery(wSQL)
					TcQuery cSql New Alias "QrySC7"

					If  QrySC7->(!Eof())
						ALERT("EXCLUSÃO NÃO PERMITIDA: Esta ordem de carregamento já foi relacionada a PRÉ-NOTA/NF "+Alltrim(QrySC7->D1_DOC)+"-"+Alltrim(QrySC7->D1_SERIE)+ ". Verifique.")
						QrySC7->(DbCloseArea())
						Return Nil
					EndIf

					sc7->(dbSeek(xFilial('SC7')+cOCOld)) //skip nao funcionou
					sc7->(dbskip())
				EndDo
			EndIf
		EndIf
	Endif

	If nOpc == 4
		If cEmpAnt+cFilAnt $ cEmpRastroOC
			If (SZ8->Z8_status2 == "C" )
				ALERT("AGENCIAMENTO NÃO PERMITIDO: OC Cancelada.")
				Return Nil
			ElseIf (SZ8->Z8_status2 $ "D,6" )
				ALERT("AGENCIAMENTO NÃO PERMITIDO: OC Faturada.")
				Return Nil
			ElseIf !( SZ8->Z8_status2 $ ' *P*1*N' )
				ALERT("AGENCIAMENTO NÃO PERMITIDO: O veículo já iniciou o carregamento/descarregamento. Verifique.")
				Return Nil
			EndIf
		Else
			if !( SZ8->Z8_status2 $ ' *P*1' )
				ALERT("ALTERAÇÃO NÃO PERMITIDA: O veículo já iniciou o carregamento/descarregamento. Verifique.")
				Return Nil
			EndIf
		endif

		AADD( aButtons, {"HISTORIC", {|| If(M->Z8_TPOPER='C',iif(cEmpAnt+cFilAnt $ '3001|0210|0101|0218',U_MZ0232(@lF80Prosseg),U_frmfiltpv()),ALERT('Somente para TIPO OPERAÇÃO carregamento.'))},"P.Venda"} )
		//AADD( aButtons, {"HISTORIC", {|| If(M->Z8_TPOPER='C',iif(cEmpAnt+cFilAnt $ '3001|0210|0101|0218',U_SMFATF80(@lF80Prosseg),U_frmfiltpv()),ALERT('Somente para TIPO OPERAÇÃO carregamento.'))},"P.Venda"} )
		AADD( aButtons, {"PEDIDO", {|| If(M->Z8_TPOPER='D',U_MIZ992(),ALERT('Somente para TIPO OPERAÇÃO descarregamento.'))},"P.Compra"} )

	Endif

	aSize := MsAdvSize(GetVersao(.F.) == "12")
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 6 }
	AAdd( aObjects, { 100, 33, .T., .T. } )
	AAdd( aObjects, { 100, 33, .T., .T. } )
	AAdd( aObjects, { 100, 34, .T., .T. } )

	aPosObj := MsObjSize( aInfo, aObjects,.T.)

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM aSize[7], 0  TO aSize[6], aSize[5] of oMainWnd PIXEL

	If GetVersao(.F.) == "11"
		_nMult := 2
	Else
		_nMult := 1
	Endif
	@ aPosObj[1,1]*_nMult,aPosObj[1,2]     		GROUP oGroup1 TO aPosObj[3,3], aPosObj[1,4]/1.8 	PROMPT "CARREGAMENTO/DESCARREGAMENTO" 	OF oDlg COLOR 0, 16777215 PIXEL
	@ aPosObj[1,1]*_nMult,aPosObj[1,4]/1.78 	GROUP oGroup2 TO aPosObj[3,3]/2, aPosObj[2,4] 		PROMPT "V E I C U L O" 					OF oDlg COLOR 0, 16777215 PIXEL
	@ aPosObj[3,3]/1.98,aPosObj[1,4]/1.78 		GROUP oGroup3 TO aPosObj[3,3], aPosObj[3,4] 		PROMPT "M O T O R I S T A" 				OF oDlg COLOR 0, 16777215 PIXEL

	RegToMemory("SZ8",IIF(nOpc==3,.T.,.F.), .F., .T.)

	SMFATF34(cAlias,nReg,nOpc,{(aPosObj[1,1]*_nMult)+7,aPosObj[1,2]+2,(aPosObj[3,3])-2,(aPosObj[1,4]/1.8)-2})
	fEnchoice2(cAlias,nReg,nOpc,{(aPosObj[1,1]*_nMult)+7,(aPosObj[1,4]/1.78)+2,(aPosObj[3,3]/2)-2,(aPosObj[2,4]-2)})
	fEnchoice3(cAlias,nReg,nOpc,{(aPosObj[3,3]/1.98)+7,(aPosObj[1,4]/1.78)+2,aPosObj[3,3]-2,aPosObj[3,4]-2})

	If nOpc == 4
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||nOpca := 1,IIF(  u_vldAgenc(lF80Prosseg) ,oDlg:End(),Nil)}, {||nOpca:=2,oDlg:End()},,aButtons)

	Elseif nOpc == 3
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||nOpca := 1,IIF(u_smSetOC(nOpc).And. smObrigatorio(),oDlg:End(),Nil)}, {||nOpca:=2,oDlg:End()},,aButtons)
	ElseIf nOpc == 2
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||oDlg:End()}, {||oDlg:End()},,aButtons)
	ElseIf nOpc == 5
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||nOpca := 1,oDlg:End()}, {||nOpca := 2,oDlg:End()},,aButtons)
	Endif

	If nOpca == 1 .And. nOpc <> 5
		if nOpc==3;  u_smSetOC() ; endif
		RecLock("SZ8",IIF(nOpc == 3,.T.,.F.))
		SZ8->Z8_FILIAL := xFilial("SZ8")
		if nOpc==4 .AND. SZ8->(FieldPos("Z8_DTAGEN")) > 0; SZ8->Z8_DTAGEN := DATE(); endif
		For l := 2 To Len(aAcho)
			If aAcho[l] == "Z8_STATUS2"
				If nOpc == 4 .AND. SZ8->&(aAcho[l]) == "N"
					LOOP
				endif
			endif
			FieldPut(FieldPos(aAcho[l]),&("M->"+aAcho[l]))
		Next
		MsUnlock()
		if nOpc == 3 // Se for incluir o agenciamento
			aCamposZ2 := {{"Z2_OC",SZ8->Z8_OC},;
			{"Z2_DATAOC",SZ8->Z8_DATA}}
		elseif nOpc == 4  //Se for agenciar
			_cStr := Posicione("SZ1",8,xFilial("SZ1")+SZ8->Z8_OC,"Z1_NUM")
			aCamposZ2 := {{"Z2_PEDIDO",Posicione("SZ1",8,xFilial("SZ1")+SZ8->Z8_OC,"Z1_NUM")},;
			{"Z2_MOTOR",SZ8->Z8_MOTOR}}
		endif
		U_SMSetSZ2(SZ8->Z8_PLACA,aCamposZ2)

		If nOpc == 4
			SMFATF33()
		Endif
	Endif

	If nOpc == 5

		If nOpca == 1
			cSql := "SELECT ZW_NUMCX, ZW_OC, ZW_LACRE FROM "+RetSqlName("SZW")+" SZW "
			cSql += " WHERE SZW.D_E_L_E_T_ = ' '"
			cSql += " AND   SZW.ZW_FILIAL  = '" +xFilial("SZW")+ "'"
			cSql += " AND   SZW.ZW_OC  = '" + SZ8->Z8_OC + "'"
			cSql += " AND   SZW.ZW_MOTIVO  = ' '"
			If Select("SMDelOC") > 0
				dbSelectArea("SMDelOC")
				SMDelOC->(DbCloseArea())
			EndIf
			//wSQL := ChangeQuery(wSQL)
			TcQuery cSql New Alias "SMDelOC"
			While SMDelOC->(!Eof()) .AND. SZ8->Z8_OC == SMDelOC->ZW_OC
				dbSelectArea('SZW')
				dbsetorder(2)
				IF  SZW->(dbSeek(xFilial("SZW")+ SZ8->Z8_OC + SMDelOC->ZW_NUMCX + SMDelOC->ZW_LACRE ))
					if empty(SZW->ZW_MOTIVO) // So os lacres que nao foram inutilizados
						RecLock("SZW",.F.)
						SZW->ZW_OC = " "
						SZW->ZW_JUSTIF = "Lacre foi liberado pois foi excluida a OC: " + SZ8->Z8_OC
						SZW->(MsUnlock())
					endif
				ELSE
					ALERT ("Nao encontrou a OC na SZW")
				ENDIF

				SMDelOC->(DbSkip())

			END
			SMDelOC->(DbCloseArea())

			RecLock("SZ8",.F.)
			DbDelete()
			MsUnlock()
		Endif

		If nOpca == 2
			If SZ8->Z8_TPOPER == "C"
				dbSelectArea('SZ1')
				dbsetorder(RetOrdem("SZ1","Z1_FILIAL+Z1_OC"))
				If dbSeek(xFilial('SZ1')+cOCOld)
					While SZ1->Z1_FILIAL == xFilial("SZ1") .AND.;
					SZ1->Z1_OC == cOCOld
						While !RecLock("SZ1",.F.) ; End
						SZ1->Z1_OC = " "
						SZ1->(MsUnlock())

						dbSeek(xFilial('SZ1')+cOCOld)  //skip nao funcionou
					EndDo
				EndIf
			Else
				dbSelectArea('SC7')
				dbsetorder(RetOrdem("SC7","C7_FILIAL+C7_YOC"))
				If dbSeek(xFilial('SC7')+cOCOld)
					While SC7->C7_FILIAL == xFilial("SC7") .AND.;
					SC7->C7_YOC == cOCOld

						While !RecLock("SC7",.F.) ; End
						SC7->C7_YOC = " "
						SC7->(MsUnlock())

						dbSeek(xFilial('SC7')+cOCOld) //skip nao funcionou
					EndDo
				EndIf
			EndIf
		EndIf
	Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF35                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function smObrigatorio()
	For s := 2 To Len(aAcho)
		If Empty(&("M->"+aAcho[s])) .And. X3Obrigat(aAcho[s])
			Help(" ",1,"OBRIGAT")
			Return .F.
		Endif
	Next
Return .T.



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF35                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


user Function SMFATF37(p_cPager)
	local warea:= getArea()
	local cRet:=''
	local cPager:= iif(  p_cPager==nil, iif( ParamIxb==nil, '' , ParamIxb ) , ''  )

	cRet:= U_SMFATF95(cPager)
	restArea(wArea)
Return (cret)


User function smgetSeq(p_cAlias, p_cCampo)

	local warea:= getArea()
	local wCmpFilial:= iif( left(p_cAlias,1)=='S' ,left(p_cCampo,3),left(p_cCampo,4))+"FILIAL"
	local wRet:= '0'
	local wTam := tamSX3("Z8_OC")[1]

	cSql := "SELECT MAX( " +p_cCampo+ ") NUMSEQ FROM "+RetSqlName(p_cAlias)
	cSql += " WHERE D_E_L_E_T_ = ' '"
	cSql += " AND   "+wCmpFilial+"  = '" +xFilial(p_cAlias)+ "'"

	If Select("QryXEXF") > 0
		dbSelectArea("QryXEXF")
		QryXEXF->(DbCloseArea())
	EndIf

	TcQuery cSql New Alias "QryXEXF"

	wRet:= strzero( val( QryXEXF->NUMSEQ ) +1 , wTam)

	restArea(wArea)

Return (wret)


User function SMFATT27(p_cPager)

	local cPager	:= iif(p_cPager==nil,'',p_cPager)
	local nAct		:= 0
	local oBitmap1
	local lAtivo 	:= .T.
	local nList
	local aItens 	:= u_SMFATF71()
	local cCombo 	:= aItens[1]
	Local cZZPag	:= Replicate("Z",TAMSX3("Z8_PAGER")[1])

	if cCombo = cZZPag ; return cCombo ; endif

	DEFINE MSDIALOG oDlg27 TITLE "PAGERS DISPONIVEIS" FROM 000, 000  TO 60, 200 COLORS 0, 16777215 PIXEL

	oFont := TFont():New("Arial",,22,,.T.,,,,,.F.,.F.)
	oCombo := TComboBox():New(10,10,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItens,40,40,oDlg27,,{||},,,,.T.,oFont,,,,,,,,'cCombo')
	oTButton1 := TButton():New( 05, 60, "OK",oDlg27,{||oDlg27:end(), nAct:= 1},30,20,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG oDlg27 CENTERED

Return iif( nAct == 1, cCombo, cPager )

User function SMFATF71()

	local warea		:= getArea()
	local cContem 	:= ""
	local nmaxpager	:= GETMV("MV_MAXPAGE")
	Local cZZPag	:= Replicate("Z",TAMSX3("Z8_PAGER")[1])
	public aNDisp 	:= {}

	cSQL := "SELECT Z8_PAGER FROM "+RetSqlName("SZ8")+" SZ8"
	cSQL += " WHERE SZ8.D_E_L_E_T_= ' ' AND Z8_FILIAL = '" + xFilial("SZ8") + "'"
	cSQL += " AND Z8_FATUR != 'S' AND Z8_PAGER != '"+cZZPag+"'"
	cSQL += " AND Z8_PAGER != '"+SPACE(TAMSX3("Z8_PAGER")[1])+"' ORDER BY Z8_PAGER"

	TCQUERY cSQL New Alias "BNP" // BUSCA NUMERACAO DO PAGER
	dbSelectArea('BNP')
	BNP->(DbGoTop())
	while BNP->(!eof())
		cContem += BNP->Z8_PAGER+"\"
		BNP->(DbSkip())
	end
	BNP->(DbCloseArea())
	RestArea(warea)

	for i:=1 to nmaxpager
		if cValtoChar(STRZERO(i,3)) $ cContem
		else
			AAdd(aNDisp,STRZERO(i,3))
		endif
	next

	if LEN(aNDisp)=0; AAdd(aNDisp,cZZPag); endif

return aNDisp


User function SMFATF72()

	local warea:= getArea()
	local cOC := SZ8->Z8_OC
	Local cMot
	Local cJust
	Local cApro
	Local awLogs:={}
	Local cStatus := SZ8->Z8_STATUS2

	If (SZ8->Z8_STATUS2 >= "3" .OR. SZ8->Z8_PSENT > 0) .and. SZ8->Z8_TPOPER == "C"
		If !u_ChkAcesso("SMFATF72",5,.T.)          // Marcus Vinicius - 26/09/2017 - Controle de acesso para bloquear transportadora
			Return
		EndIf
	EndIf

	If cEmpAnt+cFilAnt $ cEmpRastroOC
		If (SZ8->Z8_STATUS2 == "C" .OR. SZ8->Z8_STATUS2=="6" .OR. SZ8->Z8_STATUS2=="D") .OR. !empty(SZ8->Z8_FATUR)
			Alert("Não é possivel cancelar essa OC")
		Else
			If U_SMJUS(@cMot, @cJust, @cApro)

				SZ1->(DBSelectArea("SZ1"))
				SZ1->(DBSetorder(8))

				Begin Transaction

					MsgRun("Atualizando os Pedidos da OC [ "+cOC +" ]... Aguarde!","Cancelando OC")
					While SZ1->(DBSeek(xFilial("SZ1")+cOC))

						//LOG-MOTIVO/JUSTIFI.
						//Sergio - Semar| fev/2016
						aAdd(awLogs, {/*Entidade1*/'SZ8',;
						/*Tipo Docto*/'OC',;
						/*Recno Doc1*/sz8->(recno()),;
						/*Tipo Log*/'CAN',;
						/*Tipo Log*/'Cancelamento de OC',;
						/*Entidade2*/'SZ1',;
						/*Recno Doc2*/sz1->(recno()),;
						/*Recno Bpk1*/0,;
						/*Motivo*/cMot,;
						/*Justificat.*/cJust,;
						/*Usuario*/cUserName,;
						/*Rotina Orig*/'SMFATT13',;
						/*Liberador1*/cApro} )



						If RecLock("SZ1", .F.)
							SZ1->Z1_OC    := " "
							SZ1->Z1_PSENT := 0
							if !GetMv("MV_YOBGPL",.F.,.F.) .or. SZ1->Z1_FRETE <> 'F'
								SZ1->Z1_PLACA	:= " "
								SZ1->Z1_MOTOR	:= " "
								SZ1->Z1_NMOT	:= " "
								SZ1->Z1_PLCAR	:= " "
								SZ1->Z1_PLCAR2	:= " "
								SZ1->Z1_FORNECE	:= " "
								SZ1->Z1_LOJAF	:= " "
								SZ1->Z1_HORENT	:= " "
							endif
							//SZ1->(MsUnlock())
						EndIf
						SZ1->(DBSkip())
					EndDo
					RestArea(warea)

					If RecLock("SZ8", .F.)
						MsgRun("Atualiando dados da OC [ "+cOC +" ]... Aguarde!","Cancelando OC")

						//LOG-MOTIVO/JUSTIFI.
						//Sergio - Semar| fev/2016
						if len(awLogs)==0 // nao passou em pedidos
							aAdd(awLogs, {/*Entidade1*/'SZ8',;
							/*Tipo Docto*/'OC',;
							/*Recno Doc1*/sz8->(recno()),;
							/*Tipo Log*/'CAN',;
							/*DES Log*/'Cancelamento de OC',;
							/*Entidade2*/'SZ1',;
							/*Recno Doc2*/sz1->(recno()),;
							/*Recno Bpk1*/0,;
							/*Motivo*/cMot,;
							/*Justificat.*/cJust,;
							/*Usuario*/cUserName,;
							/*Rotina Orig*/'SMFATT13',;
							/*Liberador1*/cApro} )
						endif

						SZ8->Z8_PAGER   := " "
						SZ8->Z8_CBPAGER := " "
						SZ8->Z8_STATUS2 := "C"
						SZ8->Z8_ITENSOC	:= " "
						SZ8->(MsUnlock())
						//MsgInfo("OC Cancelada!")
					EndIf

					MsgRun("Gerando LOG da OC [ "+cOC +" ]... Aguarde!","Log de Cancelamento de OC")
					u_SMGRVLG(awLogs)


				End Transaction
			Endif
		EndIf
	Else
		If cEmpAnt+cFilAnt $ "0101|0218"
			If !(SZ8->Z8_STATUS2 $ "C|6|D|P") .OR. !empty(SZ8->Z8_FATUR)	//Marcus Vinicius - 13/03/2018 - Incluído Status P para permitir o cancelamento do agenciamento.
				Alert("Não é permitido cancelar agenciamentos com status diferente de 1|P.")
				return
			EndIf
		Else
			If !(SZ8->Z8_STATUS $ "1|P")	//Marcus Vinicius - 13/03/2018 - Incluído Status P para permitir o cancelamento do agenciamento.
				Alert("Não é permitido cancelar agenciamentos com status diferente de 1|P.")
				return
			EndIf
		EndiF

		If !MsgBox("Deseja cancelar o agenciamento?  ","Escolha","YESNO")
			return
		endif


		dbSelectArea('SZ1')
		dbSetorder(8)
		while dbSeek(xFilial('SZ1')+cOC)
			RecLock("SZ1",.f.)
			SZ1->Z1_OC := " "
			SZ1->Z1_PLACA	:= " "
			SZ1->Z1_MOTOR	:= " "
			SZ1->Z1_NMOT	:= " "
			SZ1->Z1_PLCAR	:= " "	//Marcus Vinicius - 13/03/2018 - Incluído campo para limpar o conteudo nele contido
			SZ1->Z1_PLCAR2	:= " "	//Marcus Vinicius - 13/03/2018 - Incluído campo para limpar o conteudo nele contido
			SZ1->Z1_FORNECE	:= " "	//Marcus Vinicius - 13/03/2018 - Incluído campo para limpar o conteudo nele contido
			SZ1->Z1_LOJAF	:= " "	//Marcus Vinicius - 13/03/2018 - Incluído campo para limpar o conteudo nele contido
			SZ1->Z1_HORENT	:= " "	//Marcus Vinicius - 13/03/2018 - Incluído campo para limpar o conteudo nele contido
			SZ1->(MsUnlock())
		end
		SZ1->(DbCloseArea())
		RestArea(warea)

		RecLock("SZ8",.f.)
		SZ8->Z8_PAGER   := " "
		SZ8->Z8_CBPAGER := " "
		SZ8->Z8_PRODUTO	:= " "	//Marcus Vinicius - 13/03/2018 - Incluído campo para limpar o conteudo nele contido
		SZ8->Z8_QUANT	:= 0	//Marcus Vinicius - 13/03/2018 - Incluído campo para limpar o conteudo nele contido
		SZ8->Z8_STATUS 	:= " "	//Marcus Vinicius - 13/03/2018 - Incluído campo para limpar o conteudo nele contido
		SZ8->Z8_STATUS2 := " "
		SZ8->Z8_ITENSOC	:= " "
		SZ8->(MsUnlock())
	Endif

return


User function SMFATF95(p_cPager)

	Local cCBAux
	Local cCB		:= ''
	Local cPager	:= if(p_cPager==nil,'00',p_cPager)

	do case
		case cEmpAnt + cFilAnt $ '3001|0210' //BA - 1000
		cCBAux:='1000'
		case cEmpAnt + cFilAnt $ '1101|0213' //PA - 2000
		cCBAux:='2000'
		case cEmpAnt + cFilAnt $ '0101|0218' //VI - 3000
		if cPager $ ('004|022|013|041|032|050')
			cCBAux:='3002'
		else
			cCBAux:='3000'
		endif
		case cEmpAnt + cFilAnt $ "2001|2004|0222|0223"		// EMPRESA 02
		cCBAux:='4000'
		case cEmpAnt + cFilAnt $ '1001|0226' //MO - 5000
		cCBAux:='5000'
		otherwise
		cCBAux:='9000'
	endcase

	cCB := cCBAux + strzero(val(cPager),4)

return cCB

User function SMFATF97(p_cParam, p_cOC )

	Local cLocCarr	:= SZ8->Z8_LOCCARR
	Local cPallet	:= SZ8->Z8_PALLET
	Local cOC		:= SZ8->Z8_OC
	Local aDisp		:= {}
	Local nAct		:= 0
	Local cPAGER    :=  SPACE(TAMSX3("Z8_PAGER")[1])
	Local cFilExcl 	:=	if(cEmpAnt+cFilAnt $ getNewPar('MV_SMEX5ZC','0210|0218'),cFilAnt,xFilial('SX5'))

	Local wAreaAtu	:= GetArea()
	If cEmpAnt + cFilAnt $ "3001|0210"
		If (SZ8->Z8_STATUS2 == "C" .OR. SZ8->Z8_STATUS2=="6" .OR. SZ8->Z8_STATUS2=="D" ) .OR. !empty(SZ8->Z8_FATUR)
			Alert("Não é possivel alterar local da OC")
			Return
		EndIf
	EndIf

	if p_cParam == "TRAF" .and. (cEmpAnt + cFilAnt $ "3001|0210")

		dbSelectArea("SZ8")
		dbsetorder(1)
		dbSeek(xFilial("SZ8") + p_cOC)
		cLocCarr	:= SZ8->Z8_LOCCARR
		cPallet	    := SZ8->Z8_PALLET
		cOC		    := SZ8->Z8_OC
	endif

	cPallet := if(cPallet$"P/E/M","P/E/M",cPallet)

	DbSelectArea("SX5")
	DbSetOrder(1)
	//if SX5->(MsSeek(xFilial("SX5")+"ZC"))
	if SX5->(MsSeek(cFilExcl+"ZC"))
		While SX5->X5_TABELA == "ZC"
			if left(SX5->X5_CHAVE,1) $ cPallet .AND. LEN(ALLTRIM(SX5->X5_CHAVE)) <= 3
				AAdd(aDisp,ALLTRIM(SX5->X5_CHAVE)+" - "+ALLTRIM(SX5->X5_DESCRI))
			endif
			SX5->(DbSkip())
		end
	endif

	DEFINE MSDIALOG oDlg97 TITLE "LOCAIS DISPONIVEIS" FROM 000, 000  TO 120, 270 COLORS 0, 16777215 PIXEL

	oFont := TFont():New("Arial",,18,,.T.,,,,,.F.,.F.)

	oSay1     := TSay():New( 10,10,{||"OC: " + alltrim(cOC) }, ,,oFont ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,40)

	if p_cParam == "TRAF" .and. (cEmpAnt + cFilAnt $ "3001|0210")
		oSay2     := TSay():New( 20,10,{||"Codigo do Pager:"},,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
		// .T. trava o campo
		oGet2      := TGet():New( 20,80,{|u| If(PCount()>0,cPAGER:=u,cPAGER)},,020,008,'',,CLR_BLACK,CLR_WHITE,oFont,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPAGER",,)
	endif
	oFont := TFont():New("Arial",,22,,.T.,,,,,.F.,.F.)

	oCombo := TComboBox():New(040, 010,{|u|if(PCount()>0,cLocCarr:=u,cLocCarr)},aDisp,80,40,oDlg97,,{||},,,,.T.,oFont,,,,,,,,'cLocCarr')
	oTButton1 := TButton():New( 35, 90, "OK",oDlg97,{||oDlg97:end(), nAct:= 1},30,20,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG oDlg97 CENTERED

	if p_cParam == "TRAF" .and. nAct == 1 .and. (alltrim(cPAGER) <> SZ8->Z8_PAGER) .and. (cEmpAnt + cFilAnt $ "3001|0210")

		Alert("Atenção:Digite o codigo do Pager igual ao da OC, para confirmar a alteração.")
		nAct := 0
	endif

	DbSelectArea("SZ8")
	if SZ8->Z8_OC == cOC .AND. nAct == 1 .AND. left(cLocCarr,2) != SZ8->Z8_LOCCARR
		RecLock("SZ8",.F.)
		SZ8->Z8_LOCCARR := cLocCarr
		SZ8->(MsUnlock())
	endif

	RestArea(wAreaAtu)

return


Static Function MenuDef()

	PRIVATE aRotina	:= {}

	If cEmpAnt + cFilAnt $ cEmpRastroOC
		aAdd(aRotina, { "Pesquisar"  			,"AxPesqui('SZ8',0,1)"		, 0 , 1, 0, nil} )
		aAdd(aRotina, { "Visualizar" 			,"U_SMFATT17('SZ8',0,2)"	, 0 , 2, 0, nil} )
		aAdd(aRotina, { "Incluir"  	 			,"U_SMFATT17('SZ8',0,3)"	, 0 , 3, 0, nil} )
		aAdd(aRotina, { "Agenciar"   			,"U_SMFATT17('SZ8',0,4)"	, 0 , 4, 0, nil} )
		aAdd(aRotina, { "Legenda"    			,"U_SMFATF29()"				, 0 , 2, 0, .F.} )
		aAdd(aRotina, { "Cancelar"   			,"U_SMFATF72()"				, 0 , 4, 0, .F.} )    // novo - em subistituiçao ao 'excluir'
		aAdd(aRotina, { "Alt. Local Carreg"  	,"U_SMFATF97('AGEN', ' ')"	, 0 , 4, 0, .F.} )
		aAdd(aRotina, { "Copiar OC"  			,"U_SMCPSZ8()"				, 0 , 4, 0, .F.} ) // novo
		aAdd(aRotina, { "Restaurar OC"  		,"U_SMRESTP(SZ8->Z8_OC)"	, 0 , 4, 0, .F.} ) //novo
	Else
		aAdd(aRotina, { "Pesquisar"  			,"AxPesqui('SZ8',0,1)"		, 0 , 1, 0, nil} )
		aAdd(aRotina, { "Visualizar" 			,"U_SMFATT17('SZ8',0,2)"	, 0 , 2, 0, nil} )
		aAdd(aRotina, { "Incluir"  	 			,"U_SMFATT17('SZ8',0,3)"	, 0 , 3, 0, nil} )
		aAdd(aRotina, { "Agenciar"   			,"U_SMFATT17('SZ8',0,4)"	, 0 , 4, 0, nil} )
		aAdd(aRotina, {"Cancelar OC"			,"U_SMFATF72()"				, 0 , 4, 0, .F.} )
		aAdd(aRotina, { "Excluir"   			,"U_SMFATT17('SZ8',0,5)"	, 0 , 5, 0, nil} )
		aAdd(aRotina, { "Legenda"    			,"U_SMFATF29()"				, 0 , 2, 0, .F.} )
		aAdd(aRotina, { "Cancelar"   			,"U_SMFATF72()"				, 0 , 4, 0, .F.} )
		aAdd(aRotina, { "Alt. Local Carreg"  	,"U_SMFATF97('AGEN', ' ')"	, 0 , 4, 0, .F.} )
	EndIf

Return(aRotina)


User Function vldAgenc(p_lProsseg)

	local _lProsseg:= iif(p_lProsseg==nil,.t.,p_lProsseg)

	lret:= ( u_SMFATF20() .And. smObrigatorio() .and. _lProsseg)

return lret

//
Static function SMVALDIST()

	Local wAreaSZ8	:= SZ8->(GetArea())
	Local wAreaSZ3	:= SZ3->(GetArea())
	Local wAreaATU	:= GetArea()
	Local lRet
	Local cVelMed		:= GetNewPar('MV_SMVLMED', '80' )
	Local nDiasLim	:= GetNewPar('MV_SMDLIMT', 30 )
	Local cMsgAl	:= GetNewPar('MV_SMMSGVD', 'Agenciamento não permitido, tempo inferior ao limite da viagem.' )
	Local cAliasQry	:= 'QRYVALD'

	DbSelectArea("SZ3")
	DbSetOrder(1)
	If SZ3->(MsSeek(xFilial("SZ3")+M->Z8_MOTOR))
		if SZ3->Z3_AGREGA == "S"
			return .T.
		endif
	endif

	cQuery := "SELECT TOP 1 Z8_DTSAIDA,Z8_HSAIDA,MAX((Z4_DIST*2/"+cVelMed+")*60) AS DISTANCIA, "
	cQuery += "DATEDIFF(minute,(CAST(Z8_DTSAIDA AS DATETIME)+CAST(Z8_HSAIDA AS DATETIME)),"
	cQuery += "(CAST('"+DTOS(DATE())+"' AS DATETIME)+CAST('"+TIME()+"' AS DATETIME))) AS DECORRIDO "
	cQuery += "FROM "+RetSqlName("SZ8")+" SZ8 INNER JOIN "+RetSqlName("SZ7")+" SZ7 ON "
	cQuery += "Z8_FILIAL = Z7_FILIAL AND Z8_OC = Z7_OC "
	cQuery += "INNER JOIN "+RetSqlName("SZ4")+" SZ4 ON "
	cQuery += Iif( SZ1->Z1_MUNE != SZ1->Z1_MUNFRT, "Z7_FILIAL = Z4_FILIAL AND Z7_UFFRT = Z4_EST AND Z7_MUNFRT = Z4_MUN ", "Z7_FILIAL = Z4_FILIAL AND Z7_UFE = Z4_EST AND Z7_MUNE = Z4_MUN ")
	cQuery += "WHERE "
	cQuery += "Z8_FILIAL = '"+xFilial("SZ8")+"' AND (Z8_PLACA = '"+M->Z8_PLACA+"' "
	cQuery += "OR Z8_MOTOR = '"+M->Z8_MOTOR+"') AND Z8_DTAGEN >= '"+DTOS(DATE()-nDiasLim)+"' "
	cQuery += "AND SZ8.D_E_L_E_T_ = ' ' AND SZ7.D_E_L_E_T_ = ' ' AND SZ4.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY Z8_DTSAIDA,Z8_HSAIDA "
	cQuery += "ORDER BY 1 DESC,2 DESC"

	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasQry, .T., .F.)
	TCSetField(cAliasQry,"Z8_DTAGEN","D")

	if (cAliasQry)->(!EOF())
		do case
			case (cAliasQry)->DECORRIDO >= (cAliasQry)->DISTANCIA
			lRet := .T.

			otherwise
			if MsgYesNo(cMsgAl+" Deseja liberar através de senha?","Atenção")
				lRet := u_smvld2Psw('Agenciamento','Email',M->Z8_OC)
			else
				lRet := .F.
			endif
		endcase
	else
		lRet := .T.
	endif

	(cAliasQry)->(DbCloseArea())
	RestArea(wAreaSZ8)
	RestArea(wAreaSZ3)
	RestArea(wAreaATU)

return lRet



User Function SmVldMot()

	Local cCodMot := SPACE(TAMSX3("Z8_MOTOR")[1])
	Local aAreaAtu := GetArea()

	Local dDtIniFunc := getNewPar('MV_SMDTIF', ctod('01/01/2070') ) // GETMV("MV_SMDTIF") // Data inicio do funcionamento

	Local lVldEmpFil  :=  ( ( cEmpAnt+cFilAnt $ alltrim(getNewPar('MV_SMVEF', '01**|0201|0215|0218|0220|0221' ))  ) .or.  ( cEmpAnt+'**' $ alltrim(getNewPar('MV_SMVEF', '01**|' ))  ) ) // Valida empresa / filial entao habilitada a usar.

	Local lEFNewBalanca := ( ( cEmpAnt+cFilAnt $ alltrim(getNewPar('MV_EFNEWBA','01**|0201|0215|0218|0220|0221'))    ) .or.  ( cEmpAnt+'**' $ alltrim(getNewPar('MV_EFNEWBA','01**|'))   ) )
	Local cCpoTpDoc:= 'Z3'+alltrim(getNewPar('MV_SMACPTD','_YTPDOC'))   //campo utilizado para armazenar o tipo de documento que deverá ser anexado

	Private ndias := GETMV("MV_YDMOT")  // Dias para calcular data mostra a mensagem (data - 90 dias)


	DbSelectArea("SZ3")
	DbSetOrder(1)
	DbSeek(xFilial("SZ3") + M->Z8_MOTOR)
	cCodMot := M->Z8_MOTOR

	If SZ3->Z3_MSBLQL == "1" // SZ3->Z3_BLOQ == "S"   - Semar - Juailson em 13/01/2015 para usar  Z3_MSBLQL (Campo padrao bloqueio)
		MsgBox("Atencao, motorista(codigo: "+M->Z8_MOTOR+") bloqueado!!","Atencao","ALERT")
		return ('')
	EndIf

	If lVldEmpFil .and. SZ3->Z3_MSBLQL $ " 2" .and. SZ3->Z3_ULTC <= (ddatabase-ndias) // SZ3->Z3_BLOQ $ " N"  - Semar - Juailson em 13/01/15 para usar  Z3_MSBLQL (Campo padrao bloqueio)
		//MsgBox("Atencao,favor atualizar os dados cadastrais do Motorista antes de continuar.!!","Atencao","ALERT")
		MsgBox("Atencao, A ultima atualização do Motorista(codigo: "+M->Z8_MOTOR+") foi em: [ " +dtoc(SZ3->Z3_ULTC) + " ], data limite " + dtoc(ddatabase-ndias)+ ", Conferir cadastro antes de continuar.","Atencao","ALERT")
		return ('')
	EndIf

	/*if lEFNewBalanca .and. empty(SZ3->&(cCpoTpDoc))
	MsgBox("Atencao, motorista(codigo: "+M->Z8_MOTOR+"),  nao tem os documentos obrigatorios anexados em seu cadastro!!!","Atencao","ALERT")
	return ('')
	EndIf*/ // Marcus Vinicius - 04/07/2018 - Desabilitado validação provisoriamente para não impedir o agenciamento até que seja criado o X2_UNICO desta tabela

	RestArea(aAreaAtu)


Return(	cCodMot )



User Function getMunic()

	local wArea:= getArea()
	local cRet

	If IsInCallStack('U_GFAT005') .OR. IsInCallStack('U_GFAT006') .OR. IsInCallStack('U_GFAT008')
		cRet:= Iif( M->Z1_MUNE != M->Z1_MUNFRT, M->Z1_UFFRT+M->Z1_MUNFRT, M->Z1_UFE+M->Z1_MUNE)
	Else
		cRet:= Iif( SZ1->Z1_MUNE != SZ1->Z1_MUNFRT, SZ1->Z1_UFFRT+SZ1->Z1_MUNFRT, SZ1->Z1_UFE+SZ1->Z1_MUNE)
	EndIf

	restArea(wArea)
return ( cRet )


User function SMTPVEICCAD()

	Local lUsaNT   	:= SuperGetMV("MV_SMUSANT",,.F.)
	Local cRet		:= ''

	if lUsaNT

		if U_CHKACESSO("U_MIZ010",4,.T.)
			AxAltera('SZ2',SZ2->(RECNO()),4,,{'Z2_TPVEIC'},,,/*cTudoOK*/)
			cRet := SZ2->Z2_TPVEIC
		endif

	endif

Return cRet