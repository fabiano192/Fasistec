#INCLUDE "rwmake.ch"
#include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ MA020TOK ³ Autor ³ Alexandro da Silva    ³ Data ³ 27/01/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Ponto de Entrada - Validar Cadastro de Fornecedor          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIZU                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MA020TOK()

Local lRet		:= .T.

If M->A2_EST <> "EX" .And. (Empty(M->A2_CGC) .Or. Empty(M->A2_INSCR))
	MSGINFO("FAVOR DIGITAR O CNPJ / INSCRICAO ESTADUAL!!")
	Return(.F.)
Endif

If !INCLUI
	Return(lRet)
Endif

_aAliORI := GetArea()
_aAliSA2 := SA2->(GetArea())

SA2->(dbSetOrder(1))
If SA2->(dbSeek(xFilial("SA2")+M->A2_COD + M->A2_LOJA))
	
	_cq := " SELECT MAX(A2_COD) AS COD FROM "+RetSqlName("SA2")+" A "
	_cq += " WHERE A.D_E_L_E_T_ = '' AND SUBSTRING(A2_COD,1,1) = 'F' AND LEN(A2_COD) = 6 "
	
	TcQuery _cQ New Alias "ZZ"
	
	_cCod := Substr(ZZ->COD,2,5)
	
	M->A2_COD := "F"+ Soma1(_cCod)
	M->A2_LOJA:= "01"
	
	ZZ->(dbCloseArea())
Endif

If Substr(M->A2_COD,1,1) == "F" .AND. Len(Alltrim(M->A2_COD)) == TamSx3("A2_COD")[1]
	dbSelectArea("CTH")
	dbSetorder(1)
	If !dbSeek(xFILIAL("CTH")+M->A2_COD+M->A2_LOJA, .F.)
		RecLock("CTH",.T.)
		CTH->CTH_FILIAL := xFilial("CTH")
		CTH->CTH_CLVL   := M->A2_COD+M->A2_LOJA
		CTH->CTH_CLASSE := "2"
		CTH->CTH_BLOQ   := "2"
		CTH->CTH_DESC01 := M->A2_NOME
		CTH->CTH_NORMAL := "0"
		MsUnlock()
	ENDIF
EndIf

MSGINFO("Codigo do Novo Fornecedor: "+M->A2_COD+"-"+M->A2_LOJA)

RestArea(_aAliSA2)
RestArea(_aAliORI)

Return(lRet)



User Function MA030TOK()

Local lRet		:= .T.

_aAliOri := GetArea()
_aAliSF4 := SF4->(GetArea()) 
_aAliZA6 := ZA6->(GetArea())
/*
If INCLUI .Or. ALTERA

	ZA6->(dbSetorder(3))
	ZA6->(dbSeek(xFilial("ZA6")+ M->A1_COD + M->A1_LOJA+ "9999",.T.))
         
	ZA6->(dbSkip(-1)
	
	If ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA ==  M->A1_COD + M->A1_LOJA
		_cItem := ZA6->ZA6_ITEM - 1
	Else
		_cItem := "0001"
	Endif
	
	ZA6->(RecLock("ZA6",.T.))

	ZA6->ZA6_FILIAL := xFilial("ZA6")
	ZA6->ZA6_ITEM   := _cItem
	ZA6->ZA6_CLIENT := M->A1_COD
	ZA6->ZA6_LOJA   := M->A1_LOJA
	ZA6->ZA6_NOMCLI := M->A1_NOME
	ZA6->ZA6_DATA   := Date()
	ZA6->ZA6_VALOR  := M->A1_LC
	ZA6->ZA6_LIBER  := "B" 
	ZA6->ZA6_PRAZO  := M->A1_COND
			Endif
			ZA6->ZA6_SDOLIM := _nSdoLim
			ZA6->ZA6_SDOTIT := _nSdoTit
			ZA6->ZA6_DTVIG  := ACOLS[AX,_NPDTVIG]
			ZA6->ZA6_LIBER  := ACOLS[AX,_NPSTATUS]
			ZA6->ZA6_DTBLOQ := ACOLS[AX,_NPDTBLQ]
			ZA6->(MsUnlock())
			
			If Empty(ZA6->ZA6_LIBER) .Or. ZA6->ZA6_LIBER == "L"
				SA1->(dbSetOrder(1))
				If SA1->(dbSeek(xFilial("SA1")+ ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA))
					SA1->(RecLock("SA1",.F.))
					SA1->A1_COND := ZA6->ZA6_PRAZO
					SA1->A1_LC   := ZA6->ZA6_VALOR
					SA1->(MsUnlock())
				Endif
			Endif
			
			_lLibera  := .F.
	 
*/

If !INCLUI
	Return(lRet)
Endif

_aAliORI := GetArea()
_aAliSA1 := SA1->(GetArea())

SA1->(dbSetOrder(1))
If SA1->(dbSeek(xFilial("SA1")+M->A1_COD + M->A1_LOJA))
	
	If Select("ZZ") > 0
		ZZ->(dbCloseArea())
	Endif
	
	_cq := " SELECT MAX(A1_COD) AS COD FROM "+RetSqlName("SA1")+" A "
	_cq += " WHERE A.D_E_L_E_T_ = '' AND SUBSTRING(A1_COD,1,1) = 'C' "
	
	TcQuery _cQ New Alias "ZZ"
	
	
	_cCod := Substr(ZZ->COD,2,5)
	
	M->A1_COD := "C"+ Soma1(_cCod)
	
	ZZ->(dbCloseArea())
Endif

If Substr(M->A1_COD,1,1) == "C" .AND. Len(Alltrim(M->A1_COD)) == TamSx3("A1_COD")[1]
	DBSELECTAREA("CTH")
	DBSETORDER(1)
	IF !DBSEEK(xFILIAL("CTH")+M->A1_COD+M->A1_LOJA, .F.)
		RecLock("CTH",.T.)
		CTH->CTH_FILIAL := xFILIAL("CTH")
		CTH->CTH_CLVL   := M->A1_COD+M->A1_LOJA
		CTH->CTH_CLASSE := "2"
		CTH->CTH_BLOQ   := "2"
		CTH->CTH_DESC01 := M->A1_NOME
		CTH->CTH_NORMAL := "0"
		MsUnlock()
	ENDIF
Else
	lRet := .F.
EndIf

MSGINFO("Codigo do Novo Cliente: "+M->A1_COD+"-"+M->A1_LOJA)

RestArea(_aAliSA1)
RestArea(_aAliZA6)
RestArea(_aAliORI)

Return(lRet)


User Function F240TIT()

U_ASI003(.T.)

Return(.T.)


/*
Ponto de Entrada	:	F070Dsc
Autor				:	Newton Macedo
Data				:	27/05/2015
Descrição			:	O ponto de entrada F070DSC somente deve ser utilizado para
permitir ou não a digitação do valor de desconto na baixa
de contas a receber. Seu retorno sera utilizado na ativação
ou nao do get do campo de desconto.
27/05/2015-AQUI UTLIZAREMOS A FUNÇÃO u_ChkAcesso() para validar os usuários que podem editar o campo desconto
*/



User Function F070DSC()

LOCAL lREturn:=.T.

lReturn:=u_PXH042("F070DSC",6,.F.)

Return(lReturn)



User Function F240BORD()

_aAliOri := GetArea()
_aALiSAL := SAL->(GetARea())
_aALiSCR := SCR->(GetARea())
_aALiSE2 := SE2->(GetARea())
_aALiSEA := SEA->(GetARea())
_aALiSY1 := SY1->(GetARea())

_cNumBor := SEA->EA_NUMBOR
_nVlBor  := 0


_cGrAprov:= GETMV("PXH_GRAPRO")

SAL->(dbSetOrder(2))
If SAL->(!dbSeek(xFilial() + _cGrAprov))
	MSGSTOP("Grupo Nao Cadastrado, Favor Contatar o Administrador do Sistema!")
	Return
EndIf

SEA->(dbSetOrder(2))
If SEA->(dbSeek(xFilial("SEA")+ _cNumBor + "P"))
	
	While SEA->(!Eof()) .And. _cNumBor == SEA->EA_NUMBOR
		
		SE2->(dbSetOrder(1))
		If SE2->(dbSeek(xFilial("SE2")+ SEA->EA_PREFIXO + SEA->EA_NUM + SEA->EA_PARCELA +SEA->EA_TIPO + SEA->EA_FORNECE + SEA->EA_LOJA))
			_nVlBor += SE2->E2_SALDO
		Endif
		
		SEA->(dbSkip())
	EndDo
Endif

SCR->(dbSetOrder(1))
If SCR->(dbSeek(xFilial("SCR")+"06"+_cNumBor))
	
	_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
	
	While SCR->(!Eof())	.And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
		
		SCR->(RecLock("SCR",.F.))
		SCR->(dbDelete())
		SCR->(MsUnlock())
		
		SCR->(dbSkip())
	EndDo
Endif

lFirstNiv   := .T.
cAuxNivel   := ""
_lLibera    := .T.

SAL->(dbSetOrder(2))
If SAL->(dbSeek(xFilial() + _cGrAprov))
	
	While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD
		
		If lFirstNiv
			cAuxNivel := SAL->AL_NIVEL
			lFirstNiv := .F.
		EndIf
		
		SCR->(Reclock("SCR",.T.))
		SCR->CR_FILIAL	:= xFilial("SCR")
		SCR->CR_NUM		:= _cNumBor
		SCR->CR_TIPO	:= "06"
		SCR->CR_NIVEL	:= SAL->AL_NIVEL
		SCR->CR_USER	:= SAL->AL_USER
		SCR->CR_APROV	:= SAL->AL_APROV
		SCR->CR_STATUS	:= "02"
		SCR->CR_EMISSAO := dDataBase
		SCR->CR_MOEDA	:= 1
		SCR->CR_TXMOEDA := 1
		SCR->CR_OBS     := Alltrim(SM0->M0_NOME) +" - BORDERO DE PAGAMENTO "
		SCR->CR_TOTAL	:= _nVlBor
		SCR->(MsUnlock())
				
		SAL->(dbSkip())
	EndDo
EndIf

Return

RestArea(_aAliSAL)
RestArea(_aAliSCR)
RestArea(_aAliSE2)
RestArea(_aAliSEA)
RestArea(_aAliSYA)
RestArea(_aAliOri)

Return


User Function F240OK()

//If cEmpAnt != "16"
//	Return(.T.)
//Endif

_aAliOri := GetArea()
_aAliSCR := SCR->(GetArea())

SCR->(dbSetOrder(1))
If SCR->(dbSeek(xFilial("SCR")+"06" + SEA->EA_NUMBOR ))
	
	_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
	
	While SCR->(!Eof())	.And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
				
		SCR->(RecLock("SCR",.F.))
		SCR->(dbDelete())
		SCR->(MsUnlock())
		
		SCR->(dbSkip())
	EndDo
Endif

RestArea(_aAliSCR)
RestArea(_aAliOri)

Return(.T.)

User Function F420FIL

Local cFiltro := ''
Local warea:= getArea()
              
//If cEmpAnt != "16" 
//	cFiltro := xFilial("SE2")
//	Return
//Endif

pergunte("AFI420",.F.)

SEA->(dbselectArea('SEA'))
SEA->(dbsetOrder(1))

SEA->( dbseek( xFilial('SEA') + mv_par01 , .t. ) )

cBordNAO:=''
cBordSIM:=''  

While SEA->(!Eof()) .And. SEA->EA_NUMBOR <= MV_PAR02

	If Empty(SEA->EA_YLIB01) .Or. Empty(SEA->EA_YLIB02)
		cBordNAO+= iif( alltrim(sea->ea_numbor) $ cBordNAO,"","/"+alltrim(sea->ea_numbor) )
	Else
		cBordSIM+= iif( alltrim(sea->ea_numbor) $ cBordSIM,"","/"+alltrim(sea->ea_numbor) )
	Endif
	
	SEA->(dbskip())
	
EndDo

If !empty(cbordNAO)
	alert("Liberação incompleta para o Bordero ["+cbordNAO+"]")
Endif

cfiltro:= "E2_FILIAL=='XX'" //FORÇA O FILTRO VAZIO
if !empty(cBordSIM)
	cfiltro:= "E2_NUMBOR $ '"+Alltrim(cBordSIM)+"'" //FORÇA O FILTRO VAZIO
endif

Restarea(warea)

Return cFiltro