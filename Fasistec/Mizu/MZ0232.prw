#include "rwmake.ch"
#include "PROTHEUS.CH"
#include "TCBROWSE.CH"
#INCLUDE 'TOPCONN.CH'

#define CBS_SIMPLE               1  // 0x0001
#define CBS_DROPDOWN             2  // 0x0002
#define CBS_DROPDOWNLIST         3  // 0x0003
#define CBS_OWNERDRAWFIXED      16  // 0x0010
#define CBS_AUTOHSCROLL         64  // 0x0040
#define CBS_OEMCONVERT         128  // 0x0080
#define CBS_SORT               256  // 0x0100
#define CBS_DISABLENOSCROLL   2048  // 0x0800

#define Altera := .t.


User Function MZ0232(p_lF80Prosseg,p_cOC,p_cOrigem) // SMFATF80

	local _cOrigem:= iIf( p_cOrigem==nil ,'', p_cOrigem )
	Local cMot:=""
	Local cJust:=""
	Local cApro:=""

	Private cEmpRastroOC := getNewPar('MZ_RASTEMP','0210')	//codigo da empresa que controla o rastro da OC

	Private aZONAS		:= {}
	Private aSETORES	:= {"Todos"}
	Private aPONTOPED	:= {"Todos"}
	Private cZonas
	Private oZonas
	Private cSetores
	Private oSetores
	Private aReg		:= {}

	Private nQtdReg		:= 0
	Private cPontoPed
	Private oPONTOPED
	Private oSearch
	Private cSearch
	Private aSearch		:= {"Nome Cliente","Pedido"}
	Private oDlg
	Private oMark
	Private lInverte	:= .F.
	Private cMarca
	Private oTxtSearc
	Private cTxtSearch	:= Space(100)
	Private cFiltro		:= ""
	Private oLABEL_REG
	Private cLABEL_REG	:= " "

	private lNoPatio
	private cOC			:= If(p_cOC==nil,'',p_cOC)
	private lAltPed		:= If(Empty(cOC),.F.,.T.)
	Private lPrdReensaque := .f. // Utilizado pelo GATFAT()

	private wAreaATU	:= GetArea()
	private wAreaSZ8	:= SZ8->(GetArea())
	private cCadastro

	//	Private cNomArq		:= STRTRAN(Time(),':','')+"_"
	Private cNomArq		:= Alltrim(RetCodUsr())
	//	Private cIndArqA	:= Subs(cNomArq,1,7)+"A"
	//	Private cIndArqB	:= Subs(cNomArq,1,7)+"B"
	Private cIndArqA	:= cNomArq+"A"
	Private cIndArqB	:= cNomArq+"B"
	Private cExtens		:= '.DTC'


	//Posiciona no registro
	If lAltPed
		DbSelectArea("SZ8")
		DbSetOrder(1)
		If MsSeek(xFilial("SZ8")+cOC)
			RegToMemory("SZ8",.F.)
		Else
			MsgAlert("Não foi possivel achar a OC, favor tentar novamente.")
		Endif
	Endif

	SZ1->(DBSetOrder(8))
	SZ1->(MsSeek(xFilial("SZ1")+SZ8->Z8_OC))

	If _cOrigem <> 'CENTRALTRAFEGO' .and. SZ1->(Found())

		MsgAlert("Pedido já vinculado a OC")

		RestArea(wAreaATU)
		RestArea(wAreaSZ8)

		Return
	Endif

	lNoPatio := iIf( SZ8->(fieldPos("Z8_PATIO"))>0 ,  iIf(m->z8_patio=='1' , .t. , .f. ) , .t. )

	M->Z8_PRODUTO := CriaVar("Z8_PRODUTO")
	M->Z8_QUANT   := CriaVar("Z8_QUANT")

	//VerIfica tabela DA5 - Cadastro de Zonas
	MZ232A()

	DEFINE MSDIALOG oDlg TITLE "Pedidos" FROM 0,0 TO 665,1200 PIXEL

	@ 003,001 TO 043,700 LABEL "Selecione : " PIXEL OF oDlg
	@ 047,002 TO 330,600 LABEL "Pedidos: " PIXEL OF oDlg

	@ 013,003 Say "Zona" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg

	//SETORES POR ZONA - DA6
	oZONAS:= TComboBox():New(013,030,{|u|If(PCount()>0,cZonas:=u,cZonas)},;
	aZONAS,072,10,oDlg,,{|| MZ232B(cZonas,@aSETORES ) },;
	,,,.T.,,,,,,,,,"cZonas")

	@ 013,109 Say "Setor" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg

	//Pontos por Zona e Setor - DA7
	oSETORES:= TComboBox():New(013,134,{|u|If(PCount()>0,cSetores:=u,cSetores)},;
	aSETORES,072,10,oDlg,,{|| MZ232C(cZonas,cSetores, @aPONTOPED )  },;
	,,,.T.,,,,,,,,,"cSetores")

	@ 013,213 Say "Ponto Setor" Size 034,008 COLOR CLR_BLACK PIXEL OF oDlg

	oPONTOPED:= TComboBox():New(013,246,{|u|If(PCount()>0,cPontoPed:=u,cPontoPed)},;
	aPONTOPED,150,10,oDlg,,{||  },;
	,,,.T.,,,,,,,,,"cPontoPed")

	@ 026,003 Say "Pesquisa " Size 022,008 COLOR CLR_BLACK PIXEL OF oDlg

	oSearch:= TComboBox():New(026,030,{|u|If(PCount()>0,cSearch:=u,cSearch)},;
	aSearch,072,10,oDlg,,{||   },;
	,,,.T.,,,,,,,,,"cSearch")

	oTxtSearch:= TGet():New(026,105, {|U|      ;
	If(PCount()>0,cTxtSearch := U,cTxtSearch)},;
	oDlg,102,09,,{||},,,,,,.T.,,,,,,,,,"","cTxtSearch")

	@ 026,247 Button "Pesquisar" Size 058,011 ACTION MZ232D(cSearch, cTxtSearch )  PIXEL OF oDlg
	@ 026,336 Button "Atualizar" Size 058,011 ACTION MZ232E(cZonas,cSetores,cPontoPed) PIXEL OF oDlg

	oLABEL_REG:= TSay():New(322,009,{|| cLABEL_REG },oDlg,,,,,,.T.,CLR_BLUE,CLR_WHITE,100,20)

	//Monta tela de Pedidos
	MZ232H()  //

	@ 013,450 Button "Confirmar" Size 058,011 ACTION (MZ232F(), close( oDlg )) PIXEL OF oDlg
	@ 026,450 Button "Limpar" Size 058,011 ACTION MZ232G() PIXEL OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	TSZ1->(dbCloseArea())

	If File( cNomArq + cExtens ) //Elimina o arquivo de trabalho
		Ferase( cNomArq + cExtens )
		Ferase( cIndArqA + OrdBagExt() )
		Ferase( cIndArqB + OrdBagExt() )
	Endif

	//	ChKFile("SZ1")

	//	dbSelectArea("SZ1")
	//	dbSetOrder(1)

Return



//Botão confirmar
Static Function MZ232F() // SMFATF81

	Local nmarcados := 0

	aPedMark := {}
	aPedDesMar:= {}

	TSZ1->(DbGotop())

	While TSZ1->(!EOF())

		If !Empty(TSZ1->Z1_DTCANC)
			TSZ1->(dbSkip())
			Loop
		Endif

		If !Empty(TSZ1->Z1_OK)
			If Marked("Z1_OK")
				If Empty(M->Z8_PRODUTO)
					M->Z8_PRODUTO := TSZ1->Z1_PRODUTO
				Endif
				M->Z8_QUANT  += TSZ1->Z1_QUANT
				nmarcados++

				aAdd(aPedMark,{TSZ1->Z1_NUM})
			Endif
		ElseIf Empty(TSZ1->Z1_OK) .and. TSZ1->Z1_OC == M->Z8_OC
			aAdd(aPedDesMar,{TSZ1->Z1_NUM})
		Endif

		TSZ1->(dbSkip())
	EndDo

	If cEmpAnt + cFilAnt $ '0210|0203|0101|0218'

		If Len(aPedMark) <> 0
			M->Z8_STATUS2  := 'P'  //Agenciado-Progrmado-Fora Patio
			If lnoPatio
				M->Z8_STATUS2  := '1'  //Agenciado
			Endif
		Else
			M->Z8_STATUS2  := ''  //Não-Agenciado
		Endif
	Else
		If Len(aPedMark) <> 0
			M->Z8_STATUS  := 'P'  //Agenciado-Progrmado-Fora Patio
			If lnoPatio
				M->Z8_STATUS  := '1'  //Agenciado
			Endif
		Else
			M->Z8_STATUS  := ''  //Não-Agenciado
		Endif
	Endif

	//AJUSTA O CAMPO DE INTENS DE ORD. CARREGAMENTO

	aZ8Itens:={}
	nPedagio := 0

	dbSelectArea('SZ1')
	dbsetorder(1)
	For j := 1 TO Len(aPedMark)
		If MSSeek(xFilial('SZ1')+aPedMark[j,1])

			_AreaSZ1 := SZ1->(GetArea())

			While !SZ1->(eof()) .and. SZ1->Z1_NUM  == aPedMark[j,1]

				npos:= ascan(  aZ8Itens, { |x| alltrim(x[1]) == alltrim(SZ1->Z1_PRODUTO)  } )
				If npos==0
					aadd( aZ8Itens, {SZ1->Z1_PRODUTO, SZ1->Z1_QUANT} )
				Else
					aZ8Itens[npos,2]+= SZ1->Z1_QUANT
				Endif

				SZ1->(dbskip())
			end

			RestArea(_AreaSZ1)

		Endif
	Next

	//montagem dos itens para envio ao sigex
	xItensOC:=''
	For j:=1 to len(aZ8Itens)
		xitensOC+=aZ8Itens[j,1]+'/'+left(posicione('SB1',1,xfilial('SB1')+aZ8Itens[j,1],'B1_YDESCRE'),25)+'/'+transform(aZ8Itens[j,2],"@E 9999999.99")+'#'
	next
	M->Z8_ITENSOC := xitensOC
	If M->Z8_PATIO =='1'
		M->Z8_HRAGENC := time()
	Endif
Return


//Botão Limpar
Static Function MZ232G()

	DbSelectArea("SZ1")
	Set filter to
	dbClearFilter()
	DbGotop()

	cLABEL_REG := "Registro(s) : " + StrZero(TSZ1->(RecCount()),6)
	oLABEL_REG:Refresh()

	cClientes := ""
	oMark:oBrowse:Refresh()

Return



//Boão Atualizar
Static Function MZ232E(cZonas,cSetores,cPontoPed)

	Local cClientes := ""
	Local cQuery := ""
	Local nRows := 0
	Local cZona := ""
	Local cSetor := ""
	If Empty(MZ232J(cZonas) ) .OR.  ;
	Empty(MZ232J(cSetores) )
		Return
	Endif

	//AT(cMascara,cString) > 0
	If AllTrim(cZonas) != 'Todos'
		cZona := SubStr(cZonas,1,  At("-",AllTrim(cZonas))-1 )
	Else
		cZona := cZonas
	Endif

	If AllTrim(cSetores) != 'Todos'
		cSetor := SubStr(cSetores,1,  At("-",AllTrim(cSetores))-1 )
	Else
		cSetor := cSetores
	Endif

	If AllTrim(cZona) == 'Todos' .And. !Empty(AllTrim(cZona))  // Selecionou uma Zona!
		cfiltro := " Z1_NUM !=  '" + Space(2) + "' .AND. "
	Else


		cAlias := GetNextAlias()

		If AllTrim(cSetor) <> 'Todos' .And. !Empty(AllTrim(cSetor))   // O Setor, foi selecionado, logo será listados todos os clientes da ZONA + SETOR selecionado
			cQuery := ChangeQuery("SELECT DA7_CLIENT AS DA7_CLIENT FROM " + RETSQLNAME("DA7") + " WHERE DA7_PERCUR = '" + cZona + "' AND DA7_ROTA = '" + cSetor + "' " )
		Else
			cQuery := ChangeQuery("SELECT DA7_CLIENT AS DA7_CLIENT FROM " + RETSQLNAME("DA7") + " WHERE DA7_PERCUR = '" + cZona + "'" )
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
		(cAlias)->(DbGoTop())

		If((cAlias)->(Eof()))

			MsgInfo("Não existem clientes para essa zona.","Pedidos")

			Return

		Else
			cClientes := "'"
			While !(cAlias)->(Eof())
				cClientes += AllTrim( (cAlias)->DA7_CLIENT )+'/'
				nRows += 1
				(cAlias)->(DbSkip())
			Enddo
			(cAlias)->(DbCloseArea())
		Endif

		cClientes := SubStr(AllTrim( cClientes ),1,Len(AllTrim( cClientes ))-1 )
		cClientes += "'"

		If !Empty(cClientes)
			cfiltro := "  Z1_CLIENTE $ " + AllTrim(cClientes)
		Endif

	Endif

	If Empty(MZ232J(cPontoPed) ) .OR. Empty(MZ232J(cPontoPed) )
		cfiltro := cfiltro
	Else

		If AllTrim(cPontoPed) <> 'Todos'
			cClientes := AllTrim(cPontoPed)
			cClientes := Left(cPontoPed,6)
			cClientes := "'"+cClientes+"'"

			cfiltro := "  Z1_CLIENTE $ " + AllTrim(cClientes)
		Else

			DbSelectArea("TSZ1")
			Set filter to
			TSZ1->(dbClearFilter())
			TSZ1->(DbGotop())

			cLABEL_REG := "Registro(s) : " + StrZero(TSZ1->(RecCount()),6)
			oLABEL_REG:Refresh()

			cClientes := ""
			oMark:oBrowse:Refresh()

		Endif
	Endif

	If !Empty(cFiltro)
		cFiltro += " .AND. "
	Endif
	cFiltro += " DTOS(Z1_DTENT) <= '"+DTOS(dDataBase)+"' "
	cFiltro += " .AND. Z1_LIBER = 'S'.And. Empty(DTOS(Z1_DTCANC)) "

	TSZ1->(DbSetOrder(1))
	Set Filter to &(cfiltro)
	TSZ1->(DbGotop())

	cLABEL_REG := "Registro(s) : " + StrZero(TSZ1->(RecCount()),6)
	oLABEL_REG:Refresh()

	cClientes := ""
	oMark:oBrowse:Refresh()

Return



//VerIfica tabela DA5 - Cadastro de Zonas
Static Function MZ232A()

	Local cAlias
	Local cQuery := ""

	cAlias := GetNextAlias()
	cQuery := ChangeQuery("SELECT * FROM " + RETSQLNAME("DA5") )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGoTop())

	AADD( aZONAS, "Todos")
	If((cAlias)->(Eof()))
		return
	Endif

	cZona := (cAlias)->DA5_COD

	While !(cAlias)->(Eof())
		AADD( aZONAS , (cAlias)->DA5_COD + ' - ' + (cAlias)->DA5_DESC )
		(cAlias)->(DbSkip())
	Enddo
	(cAlias)->(DbCloseArea())

Return



//SETORES POR ZONA
Static Function MZ232B(cZona,aSETORES)

	Local cAlias
	Local cQuery := ""

	cZona := SubStr(cZona,1,  At("-",AllTrim(cZona))-1 )

	cAlias := GetNextAlias()
	cQuery := ChangeQuery("SELECT * FROM " + RETSQLNAME("DA6") + " WHERE DA6_PERCUR = '" + cZona + "'" )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGoTop())

	If((cAlias)->(Eof()))

		aSETORES := {}
		AADD( aSETORES, "Todos")
		oSETORES:aItems:= aSETORES
		oSETORES:Refresh()
		oDlg:Refresh()

		return
	Endif

	aSETORES := {}

	AADD( aSETORES, "Todos")
	cSetor :=  (cAlias)->DA6_ROTA

	While !(cAlias)->(Eof())
		AADD( aSETORES , (cAlias)->DA6_ROTA + ' - ' + (cAlias)->DA6_REF )
		(cAlias)->(DbSkip())
	Enddo
	(cAlias)->(DbCloseArea())

	If oSETORES != NIL
		oSETORES:aItems:= aSETORES
		oSETORES:Refresh()
		oDlg:Refresh()
	Endif

Return



//Pontos por Zona e Setor - DA7
Static Function MZ232C(cZonas,cSetor,aPONTOPED)

	Local cAlias
	Local cQuery := ""
	Local cPontoPed := ""
	Local cZona := ""

	cPontoPed := SubStr(cSetor,1,  At("-",AllTrim(cSetor))-1 )
	cZona := SubStr(cZonas,1,  At("-",AllTrim(cZonas))-1 )

	cAlias := GetNextAlias()
	cQuery := ChangeQuery("SELECT * FROM " + RETSQLNAME("DA7") + " WHERE  DA7_PERCUR  = '" + cZona  + "' AND DA7_ROTA = '" + cPontoPed + "'" )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGoTop())

	If((cAlias)->(Eof()))

		aPONTOPED := {}
		AADD( aPONTOPED, "Todos")
		oPONTOPED:aItems:= aPONTOPED
		oPONTOPED:Refresh()
		oDlg:Refresh()

		return
	Endif

	aPONTOPED := {}
	AADD( aPONTOPED, "Todos")

	While !(cAlias)->(Eof())
		AADD(aPONTOPED, (cAlias)->DA7_CLIENT + ' - ' + Posicione("SA1",1,xFilial("SA1")+(cAlias)->DA7_CLIENT,"A1_NOME") )
		(cAlias)->(DbSkip())
	Enddo
	(cAlias)->(DbCloseArea())

	If oPONTOPED != NIL
		oPONTOPED:aItems:= aPONTOPED
		oPONTOPED:Refresh()
		oDlg:Refresh()
	Endif

Return



//Botão Pesquisar
Static Function MZ232D(cTpSearch,cSearch)

	//	Local _nElem := If(cTpSearch = "Nome Cliente",9,3)

	If Empty(MZ232J(cSearch) )
		MsgStop("Informe uma pesquisa válida.","Pedidos")
		oSearch:SetFocus()
		Return
	Endif

	//³Realiza a pesquisa³
	//	_cString := AllTrim(Upper(cSearch))
	//	_nPos	 := aScan(oMark:Array,{|x| _cString $ Upper(x[_nElem])})
	//	_lRet	 := (_nPos != 0)

	//³Se encontrou, posiciona o objeto ³
	//	If _lRet
	//		oMark:nAt := _nPos
	//		oMark:Refresh()
	//	EndIf


	dbSelectArea("TSZ1")

	If( AllTrim(cTpSearch) == "Nome Cliente")
		TSZ1->(DbSetOrder(1))
	Else
		TSZ1->(DbSetOrder(2))
	Endif

	TSZ1->(msSeek( xFilial('SZ1')+ rtrim(cSearch) ),.T.)

Return



//Monta tela de Pedidos
Static Function MZ232H()

	Local nmarcados 	:= 0
	Local lEmp			:= IIf(cEmpAnt + cFilAnt $ '3001|0210', .T., .F.)

	Local cDriver	:= __LocalDriver

	Local _stru			:={}

	AADD(_stru,{"Z1_FILIAL"	    ,TAMSX3("Z1_FILIAL")[3]	,TAMSX3("Z1_FILIAL")[1]	,TAMSX3("Z1_FILIAL")[2]		})
	AADD(_stru,{"Z1_OK"		    ,TAMSX3("Z1_OK")[3]		,TAMSX3("Z1_OK")[1]		,TAMSX3("Z1_OK")[2]		})
	AADD(_stru,{"Z1_EMISSAO"	,TAMSX3("Z1_EMISSAO")[3],TAMSX3("Z1_EMISSAO")[1],TAMSX3("Z1_EMISSAO")[2]})
	AADD(_stru,{"Z1_NUM"		,TAMSX3("Z1_NUM")[3]	,TAMSX3("Z1_NUM")[1]	,TAMSX3("Z1_NUM")[2]	})
	AADD(_stru,{"Z1_TIPO"		,TAMSX3("Z1_TIPO")[3]	,TAMSX3("Z1_TIPO")[1]	,TAMSX3("Z1_TIPO")[2]	})
	AADD(_stru,{"Z1_COND"		,TAMSX3("Z1_COND")[3]	,TAMSX3("Z1_COND")[1]	,TAMSX3("Z1_COND")[2]	})
	AADD(_stru,{"Z1_PRODUTO"	,TAMSX3("Z1_PRODUTO")[3],TAMSX3("Z1_PRODUTO")[1],TAMSX3("Z1_PRODUTO")[2]})
	AADD(_stru,{"Z1_QUANT"		,TAMSX3("Z1_QUANT")[3]	,TAMSX3("Z1_QUANT")[1]	,TAMSX3("Z1_QUANT")[2]	})
	AADD(_stru,{"Z1_DTENT"		,TAMSX3("Z1_DTENT")[3]	,TAMSX3("Z1_DTENT")[1]	,TAMSX3("Z1_DTENT")[2]	})
	AADD(_stru,{"Z1_NOMCLI"	    ,TAMSX3("Z1_NOMCLI")[3]	,TAMSX3("Z1_NOMCLI")[1]	,TAMSX3("Z1_NOMCLI")[2]	})
	AADD(_stru,{"Z1_LOJA"		,TAMSX3("Z1_LOJA")[3]	,TAMSX3("Z1_LOJA")[1]	,TAMSX3("Z1_LOJA")[2]	})
	AADD(_stru,{"Z1_LOCAL"		,TAMSX3("Z1_LOCAL")[3]	,TAMSX3("Z1_LOCAL")[1]	,TAMSX3("Z1_LOCAL")[2]	})
	AADD(_stru,{"Z1_OBSER"		,TAMSX3("Z1_OBSER")[3]	,TAMSX3("Z1_OBSER")[1]	,TAMSX3("Z1_OBSER")[2]	})
	AADD(_stru,{"Z1_FRETE"		,TAMSX3("Z1_FRETE")[3]	,TAMSX3("Z1_FRETE")[1]	,TAMSX3("Z1_FRETE")[2]	})
	AADD(_stru,{"Z1_FTRA"		,TAMSX3("Z1_FTRA")[3]	,TAMSX3("Z1_FTRA")[1]	,TAMSX3("Z1_FTRA")[2]	})
	AADD(_stru,{"Z1_FMOT"		,TAMSX3("Z1_FMOT")[3]	,TAMSX3("Z1_FMOT")[1]	,TAMSX3("Z1_FMOT")[2]	})
	AADD(_stru,{"Z1_HLIB"		,TAMSX3("Z1_HLIB")[3]	,TAMSX3("Z1_HLIB")[1]	,TAMSX3("Z1_HLIB")[2]	})
	AADD(_stru,{"Z1_NLIB"		,TAMSX3("Z1_NLIB")[3]	,TAMSX3("Z1_NLIB")[1]	,TAMSX3("Z1_NLIB")[2]	})
	AADD(_stru,{"R_E_C_N_O_"	,"N"	,10	,0	})
	AADD(_stru,{"Z1_OC"		    ,TAMSX3("Z1_OC")[3]	,TAMSX3("Z1_OC")[1]	,TAMSX3("Z1_OC")[2]	})
	AADD(_stru,{"Z1_LIBER"		,TAMSX3("Z1_LIBER")[3]	,TAMSX3("Z1_LIBER")[1]	,TAMSX3("Z1_LIBER")[2]	})
	AADD(_stru,{"Z1_DTCANC"		,TAMSX3("Z1_DTCANC")[3]	,TAMSX3("Z1_DTCANC")[1]	,TAMSX3("Z1_DTCANC")[2]	})
	AADD(_stru,{"Z1_HORENTG"	,TAMSX3("Z1_HORENTG")[3]	,TAMSX3("Z1_HORENTG")[1]	,TAMSX3("Z1_HORENTG")[2]	})
	AADD(_stru,{"Z1_NMOT"		,TAMSX3("Z1_NMOT")[3]	,TAMSX3("Z1_NMOT")[1]	,TAMSX3("Z1_NMOT")[2]	})
	AADD(_stru,{"Z1_PALLET"		,TAMSX3("Z1_PALLET")[3]	,TAMSX3("Z1_PALLET")[1]	,TAMSX3("Z1_PALLET")[2]	})
	AADD(_stru,{"Z1_PLACA"		,TAMSX3("Z1_PLACA")[3]	,TAMSX3("Z1_PLACA")[1]	,TAMSX3("Z1_PLACA")[2]	})
	AADD(_stru,{"Z1_YTIPO"		,TAMSX3("Z1_YTIPO")[3]	,TAMSX3("Z1_YTIPO")[1]	,TAMSX3("Z1_YTIPO")[2]	})

	_cQrySZ1 := " SELECT Z1.R_E_C_N_O_ AS Z1RECNO, * FROM "+RetSqlName("SZ1")+" Z1 " +CRLF
	_cQrySZ1 += " WHERE Z1.D_E_L_E_T_ = '' " +CRLF
	_cQrySZ1 += " AND Z1_FILIAL = '"+xFilial("SZ1")+"' " +CRLF
	_cQrySZ1 += " AND Z1_OC = ''" +CRLF   // Adicionado filtro para não relacionar pedidos já agenciados - Raphael Moura - Chamado 45255 em 09/08/2018
	_cQrySZ1 += " AND Z1_DTCANC = '' " +CRLF
	If lAltPed
		_cQrySZ1 += " AND Z1_OC = '"+cOC+"' " +CRLF
	Endif

	If Select("TSZ1") > 0
		TSZ1->(dbCloseArea())
	Endif

	If File( cNomArq + cExtens ) //Elimina o arquivo de trabalho
		Ferase( cNomArq + cExtens )
		Ferase( cIndArqA + OrdBagExt() )
		Ferase( cIndArqB + OrdBagExt() )
	Endif

	dbCreate( cNomArq, _stru, cDriver )
	dbUseArea( .T.,, cNomArq, 'TSZ1', .T., .F. )
	IndRegua( 'TSZ1', cIndArqA,'Z1_FILIAL+Z1_NOMCLI',,,"Selecionando Registros...")
	IndRegua( 'TSZ1', cIndArqB,'Z1_FILIAL+Z1_NUM',,,"Selecionando Registros...")

	dbClearIndex()

	dbSetIndex( cIndArqA + OrdBagExt() )
	dbSetIndex( cIndArqB + OrdBagExt() )

	SqlToTrb( _cQrySZ1, _stru, 'TSZ1' )

	Count To _nTSZ1

	TSZ1->(dbGoTop())

	lInverte := .F.
	cMarca   := GetMark()

	While TSZ1->(!EOF())

		//		SZ1->(dbGoTo(TSZ1->(Z1RECNO)))

		TSZ1->(RecLock("TSZ1",.F.))
		If aScan(apedmark,{|x| x[1] == TSZ1->Z1_NUM}) > 0 .OR. (TSZ1->Z1_OC == M->Z8_OC)
			TSZ1->Z1_OK		:= cmarca
		Endif

		nmarcados += 1

		/*
		TSZ1->OK 		:= cmarca
		TSZ1->EMISSAO	:= TZ1Q->Z1_EMISSAO
		TSZ1->NUM		:= TZ1Q->Z1_NUM
		TSZ1->TIPO		:= TZ1Q->Z1_TIPO
		TSZ1->COND		:= TZ1Q->Z1_COND
		TSZ1->PRODUTO	:= TZ1Q->Z1_PRODUTO
		TSZ1->QUANT		:= TZ1Q->Z1_QUANT
		TSZ1->DTENT		:= TZ1Q->Z1_DTENT
		TSZ1->NOMCLI	:= TZ1Q->Z1_NOMCLI
		TSZ1->LOJA		:= TZ1Q->Z1_LOJA
		TSZ1->LOCAL		:= TZ1Q->Z1_LOCAL
		TSZ1->FRETE		:= TZ1Q->Z1_FRETE
		TSZ1->FTRA		:= TZ1Q->Z1_FTRA
		TSZ1->FMOT		:= TZ1Q->Z1_FMOT
		TSZ1->HLIB		:= TZ1Q->Z1_HLIB
		TSZ1->NLIB		:= TZ1Q->Z1_NLIB
		TSZ1->RECNO		:= TZ1Q->(Z1RECNO)
		*/
		TSZ1->(MsUnLock())

		TSZ1->(dbskip())
	EndDo

	/*
	SZ1->(DbSetOrder(3))
	SZ1->(DbGotop())

	_cIndex	:= CriaTrab(nil,.f.)
	_cChave	:= IndexKey()

	_cCond  := " Z1_FILIAL=='"+xfilial('SZ1')+"' .AND. "
	_cCond  += If(lAltPed,  " Z1_OC=='"+cOC+"'",  '  Empty(DTOS(Z1_DTCANC))'   )

	IndRegua("SZ1",_cIndex,_cChave,,_cCond,"Selecionando Registros...")
	_nIndex := RetIndex("SZ1")
	dbSelectArea("SZ1")
	dbSetOrder(_nIndex+1)
	dbGoTop()

	lInverte := .F.
	cMarca   := GetMark()

	While SZ1->(!EOF()) .and. SZ1->Z1_FILIAL == xFilial("SZ1") .and. !lAltPed

	If !Empty(SZ1->Z1_DTCANC)
	SZ1->(dbSkip())
	Loop
	Endif

	If DBRLock(SZ1->(RECNO()))
	SZ1->Z1_OK := " "
	If aScan(apedmark,{|x| x[1] == SZ1->Z1_NUM}) > 0 .OR. (SZ1->Z1_OC == M->Z8_OC)
	SZ1->Z1_OK := cmarca
	Endif
	DBRUNLOCK(SZ1->(RECNO()))
	nmarcados += 1
	Endif
	SZ1->(dbSkip())
	EndDo
	*/

	aCampos  := {;
	{ "Z1_OK"		,, " "				,"@!"},;
	{ "Z1_EMISSAO"	,, "Emissao"		,"@!"},;
	{ "Z1_NUM"		,, "Pedido"			,"@!"},;
	{ "Z1_TIPO"		,, "Tipo"			,"@!"},;
	{ "Z1_COND"		,, "Cond Pagto"		,"@!"},;
	{ "Z1_PRODUTO"	,, "Produto"		,"@!"},;
	{ "Z1_QUANT"	,, "Quantidade"		,"@E 999,999,999.99"},;
	{ "Z1_DTENT"	,, "Dt.Entrega"		,"@!"},;
	{ "Z1_NOMCLI"	,, "Cliente"		,"@!"},;
	{ "Z1_LOJA"		,, "Loja"			,"@!"},;
	{ "Z1_LOCAL"	,, "Local Entrega"	,"@!"},;
	{ "Z1_OBSER"	,, "Observação"		,"@!"},;
	{ "Z1_FRETE"	,, "Frete"			,"@!"},;
	{ "Z1_FTRA"		,, "Frete Transp."	,"@E 999,999,999.99"},;
	{ "Z1_FMOT"		,, "Frete Motor."	,"@E 999,999,999.99"},;
	{ "Z1_HLIB"		,, "Hora Lib."		,"@!"},;
	{ "Z1_NLIB"		,, "Liberador"		,"@!"} }

	/*
	aCampos  := {;
	{ "OK"		,, " "				,"@!"},;
	{ "EMISSAO"	,, "Emissao"		,"@!"},;
	{ "NUM"		,, "Pedido"			,"@!"},;
	{ "TIPO"	,, "Tipo"			,"@!"},;
	{ "COND"	,, "Cond Pagto"		,"@!"},;
	{ "PRODUTO"	,, "Produto"		,"@!"},;
	{ "QUANT"	,, "Quantidade"		,"@E 999,999,999.99"},;
	{ "DTENT"	,, "Dt.Entrega"		,"@!"},;
	{ "NOMCLI"	,, "Cliente"		,"@!"},;
	{ "LOJA"	,, "Loja"			,"@!"},;
	{ "LOCAL"	,, "Local Entrega"	,"@!"},;
	{ "FRETE"	,, "Frete"			,"@!"},;
	{ "FTRA"	,, "Frete Transp."	,"@E 999,999,999.99"},;
	{ "FMOT"	,, "Frete Motor."	,"@E 999,999,999.99"},;
	{ "HLIB"	,, "Hora Lib."		,"@!"},;
	{ "NLIB"	,, "Liberador"		,"@!"} }
	*/

	TSZ1->(dbGoTop())

	oMark := MsSelect():New("TSZ1","Z1_OK","",aCampos,@lInverte,@cMarca,{055 , 02, 320, 597 })

	oMark:bMark := If(lAltPed,{|| AxAltera("SZ1",TSZ1->RECNO,4,,{"Z1_QUANT","Z1_OBSER"},,,'(U_UpdQtdZ8(),.T.)') },;
	{|| MZ132I(@cMarca,@lInverte) })

	cLABEL_REG := "Registro(s) : " + StrZero(nmarcados,6)
	oLABEL_REG:Refresh()

Return



//Marcar o Pedido
Static Function MZ132I(cMarca,lInverte)

	Local cxMarca 	:= ThisMark()
	Local nX 		:= 0
	Local lxInvert 	:= ThisInv()
	Local lEmp		:= IIf(cEmpAnt + cFilAnt $ '3001|0210', .T., .F.)
	Local lUsaZG 	:= GetMv("MV_SMBLPZG",.F.,.F.)	//Bloqueio do produto de acordo com a programação do silo (Tabela ZG -SX5) Padrão: .F.
	Local lRetZG	:= .T.

	If !lEmp
		If TSZ1->Z1_YTIPO == "B"

			MsgAlert("Nao e permitido marcar o pedido bonIficacao")

			TSZ1->(RecLock("TSZ1",.F.))
			TSZ1->Z1_OK := ""
			TSZ1->(MsUnLock())

			SZ1->(dbGoto(TSZ1->Z1RECNO2))


			/*
			DbSelectarea("SZ1")
			DbSetOrder(1)
			If Reclock("SZ1",.f.)
			SZ1->Z1_OK := ""
			MsUnlock()
			Endif
			*/
		Endif
	Endif
	If cEmpAnt + cFilAnt $ '0210'
		If TSZ1->Z1_FRETE == "C"
			_nHoras := SubtHoras(Date(), SubStr(Time(),1,2)+":"+SubStr(Time(),4,2),  TSZ1->Z1_DTENT, TSZ1->Z1_HORENTG )

			If _nHoras > 24
				MsgBox("Agenciamento Nao Permitido Para Data de Entrega Futura (Mais que 24 Horas)! ","Atencao","ALERT")
				Return(.F.)
			Endif
		Else
			_nDias  := TSZ1->Z1_DTENT - Date()

			If _nDias  > GETMV("MZ_DIAAGEN")

				MsgBox("Agenciamento Nao Permitido Para Data de Entrega Futura!","Atencao","ALERT")

				_cZ1OK := ""
				ATUZ1OK(_cZ1OK)

				/*
				DbSelectarea("SZ1")
				DbSetOrder(1)
				If Reclock("SZ1",.f.)
				SZ1->Z1_OK := ""
				MsUnlock()
				Endif
				*/
			Endif
		Endif
	Endif

	If  GetMv("MV_YOBGPL",.F.,.F.) .and. TSZ1->Z1_FRETE == 'F'

		If TSZ1->Z1_PLACA <> M->Z8_PLACA

			MsgAlert("Placa do Agencimento não bate com a do Pedido !!"+CRLF+"Por favor selecionar outro pedido.")

			_cZ1OK := ""
			ATUZ1OK(_cZ1OK)

			/*
			DbSelectarea("SZ1")
			DbSetOrder(1)
			If Reclock("SZ1",.f.)
			SZ1->Z1_OK := ""
			MsUnlock()
			Endif
			*/
		Endif

		If TSZ1->Z1_NMOT <> M->Z8_NOMMOT

			MsgAlert("Nome do Motorista não bate com o Nome do Motorista do Pedido!!"+CRLF+"Por favor selecionar outro pedido.")

			_cZ1OK := ""
			ATUZ1OK(_cZ1OK)

			/*
			DbSelectarea("SZ1")
			DbSetOrder(1)
			If Reclock("SZ1",.f.)
			SZ1->Z1_OK := ""
			MsUnlock()
			Endif
			*/
		Endif

	Endif

	If TSZ1->Z1_PALLET <> M->Z8_PALLET .AND. (cEmpAnt + cFilAnt $ '0210')

		If (TSZ1->Z1_PALLET != "E" .AND. M->Z8_PALLET != "P") .Or. !MsgYesNo("Deseja alterar o tipo de carregamento do PEDIDO de Empurrador para Pallet")

			MsgAlert("O Campo [PALLET] no Pedido Venda está diferente do campo [PALLET] na ordem de carregamento.")

			_cZ1OK := ""
			ATUZ1OK(_cZ1OK)

			/*
			DbSelectarea("SZ1")
			DbSetOrder(1)
			If Reclock("SZ1",.f.)
			SZ1->Z1_OK := ""
			MsUnlock()
			Endif
			*/
		Else

			TSZ1->(RecLock("TSZ1",.F.))
			TSZ1->Z1_PALLET := "P"
			TSZ1->(MsUnLock())

			//SZ1->(dbgoTo(TSZ1->Z1RECNO2))

			SZ1->(dbSetOrder(1))
			SZ1->(dbSeek(xFilial("SZ1")+ TSZ1->Z1_NUM))

			If SZ1->(RecLock("SZ1",.F.))
				SZ1->Z1_PALLET := "P"
				SZ1->(MsUnlock())
			Endif
		Endif

	Endif

	//Adicionado por Rodrigo Feitosa ( SEMAR ) - 29/09/15
	// VerIfica quando a OC for do tipo GRANEL, se o produto do pedido consta na tabela de produtos do silo !
	If lUsaZG .AND. M->Z8_PALLET $ 'G' .AND. !EMPTY(M->Z8_LOCCARR)

		SX5->(dbSetOrder(1))
		If SX5->(MsSeek(xFilial("SX5")+"ZG"))
			While SX5->X5_TABELA == "ZG"
				If substr(SX5->X5_CHAVE,1,2) == M->Z8_LOCCARR
					lRetZG := Alltrim(TSZ1->Z1_PRODUTO) $ Alltrim(SX5->X5_DESCRI)
					If lRetZG; EXIT; Endif
				Endif
				SX5->(DbSkip())
			end
		Endif
		If !lRetZG
			Alert("O Produto ["+Alltrim(TSZ1->Z1_PRODUTO)+"] do Pedido ["+Alltrim(TSZ1->Z1_NUM)+"] não se encontra disponivel para carregar no ["+;
			Alltrim(M->Z8_LOCCARR)+"], favor verIficar a disponibilidade do produto! ")

			_cZ1OK := ""
			ATUZ1OK(_cZ1OK)

			/*
			DbSelectarea("SZ1")
			DbSetOrder(1)
			If Reclock("SZ1",.f.)
			SZ1->Z1_OK := ""
			MsUnlock()
			Endif
			*/
		Endif
	Endif



	If TSZ1->Z1_OK == cMarca
		If "S" $ SuperGetMv("MV_TELAG", .F. , "N")
			SelecBonIf()// Normando (Semar) 17/08/2015 - Tela para selecionar os pedidos bonIficados do cliente atual

			_cZ1OK := cMarca
			ATUZ1OK(_cZ1OK)

			lInverte := .T.
			nQtdReg ++

			/*
			If Reclock("SZ1",.F.)
			SZ1->Z1_OK := cMarca
			lInverte := .T.
			MsUnlock()
			nQtdReg ++
			Endif
			*/
			If Len(aReg) > 0
				For i:=1 To Len(aReg)

					TSZ1->(DbSetOrder(2))
					TSZ1->(MsSeek(xFilial("SZ1")+aReg[i]))

					_cZ1OK := cMarca
					ATUZ1OK(_cZ1OK)

					lInverte := .F.
					/*
					SZ1->(DbSetOrder(1))

					SZ1->(MsSeek(xFilial("SZ1")+aReg[i]))
					If SZ1->(Reclock("SZ1",.F.))
					SZ1->Z1_OK := cMarca
					SZ1->(MsUnlock())
					Endif
					*/
					nQtdReg ++
				Next i
				aReg := {}
			Endif
		Else

			_cZ1OK := cMarca
			ATUZ1OK(_cZ1OK)

			lInverte := .T.
			nQtdReg ++

			/*			If Reclock("SZ1",.F.)
			SZ1->Z1_OK := cMarca
			lInverte := .T.
			MsUnlock()
			nQtdReg ++
			Endif
			*/
		Endif
	Else
		If "S" $ SuperGetMv("MV_TELAG", .F. , "N")
			SelecBonIf()// Normando (Semar) 17/08/2015 - Tela para selecionar os pedidos bonIficados do cliente atual

			_cZ1OK := " "
			ATUZ1OK(_cZ1OK)

			lInverte := .F.
			nQtdReg --

			/*
			If Reclock("SZ1",.F.)
			SZ1->Z1_OK := " "
			lInverte := .F.
			MsUnlock()
			nQtdReg --
			Endif
			*/
			If Len(aReg) > 0
				For i:=1 To Len(aReg)

					TSZ1->(DbSetOrder(2))
					TSZ1->(MsSeek(xFilial("SZ1")+aReg[i]))

					_cZ1OK := " "
					ATUZ1OK(_cZ1OK)

					lInverte := .F.
					/*
					SZ1->(DbSetOrder(1))
					SZ1->(MsSeek(xFilial("SZ1")+aReg[i]))
					If SZ1->(Reclock("SZ1",.F.))
					SZ1->Z1_OK := " "

					SZ1->(MsUnlock())
					Endif
					*/
					nQtdReg --
				Next i
				aReg := {}

			Endif
		Else
			_cZ1OK := " "
			ATUZ1OK(_cZ1OK)

			lInverte := .F.
			nQtdReg --

			/*
			If Reclock("SZ1",.F.)
			SZ1->Z1_OK := " "
			lInverte := .F.
			MsUnlock()
			nQtdReg --
			Endif
			*/
		Endif
		nQtdReg := IIf(nQtdReg<0,0,nQtdReg)
	Endif

	If(AllTrim(cSearch) == "Nome Cliente")
		TSZ1->(DbSetOrder(1))
	Else
		TSZ1->(DbSetOrder(2))
	Endif

	cLABEL_REG := " Selecionado(s) - " + StrZero(nQtdReg,6) + " - Registro(s) "
	oLABEL_REG:Refresh()

Return



/*
Static Function SMFATF90(cMarca)
If IsMark( 'Z1_OK', cMarca )
RecLock( 'SZ1', .F. )
Replace Z1_OK With Space(2)
MsUnLock()
Else
RecLock( 'SZ1', .F. )
Replace Z1_OK With cMarca
MsUnLock()
Endif
return
*/



Static Function MZ232J(cTexto)

	cTexto := StrTran(cTexto,"Ã","a")
	cTexto := StrTran(cTexto,"ã","a")
	cTexto := StrTran(cTexto,"Á","a")
	cTexto := StrTran(cTexto,"á","a")
	cTexto := StrTran(cTexto,"Â","a")
	cTexto := StrTran(cTexto,"â","a")
	cTexto := StrTran(cTexto,"À","a")
	cTexto := StrTran(cTexto,"à","a")
	cTexto := StrTran(cTexto,"Ô","o")
	cTexto := StrTran(cTexto,"ô","o")
	cTexto := StrTran(cTexto,"Ó","o")
	cTexto := StrTran(cTexto,"ó","o")
	cTexto := StrTran(cTexto,"Õ","o")
	cTexto := StrTran(cTexto,"õ","o")
	cTexto := StrTran(cTexto,"Ú","u")
	cTexto := StrTran(cTexto,"ú","u")
	cTexto := StrTran(cTexto,"Ü","u")
	cTexto := StrTran(cTexto,"ü","u")
	cTexto := StrTran(cTexto,"Í","i")
	cTexto := StrTran(cTexto,"í","i")
	cTexto := StrTran(cTexto,"Ç","c")
	cTexto := StrTran(cTexto,"ç","c")
	cTexto := StrTran(cTexto,"É","e")
	cTexto := StrTran(cTexto,"é","e")
	cTexto := StrTran(cTexto,"Ê","e")
	cTexto := StrTran(cTexto,"ê","e")
	cTexto := StrTran(cTexto,","," ")
	cTexto := StrTran(cTexto,"."," ")
	cTexto := StrTran(cTexto,"?"," ")
	cTexto := StrTran(cTexto,"!"," ")
	cTexto := StrTran(cTexto,"º"," ")
	cTexto := StrTran(cTexto,"ª"," ")
	cTexto := StrTran(cTexto,"*"," ")
	cTexto := StrTran(cTexto,"/"," ")
	cTexto := StrTran(cTexto,"\"," ")
	cTexto := StrTran(cTexto,"'"," ")
	cTexto := StrTran(cTexto,'"'," ")

Return cTexto




Static Function Versenha()

	_lRet := .t.

	If Alltrim(_cSenha) <> alltrim(getmv("MZ_SENPREV"))
		MsgBox("Atenção, "+Alltrim(cUsername)+" Senha Digitada inválida","SENHA","STOP")
		_lRet := .F.
	Endif

	If _lRet
		Close(oDlg)
	Endif

Return(_lRet)

//incluido em 02/12/14



/*
//Funcao para testar peso maximo permitido -   Utilizada na SMFATT99()
user function testePMP(p_cOC, p_nPesoBalanca)
local lRet         := .T.
local cOC          := p_cOC
local nPesoBalanca := p_nPesoBalanca
LOCAL nPMP         := 0   // PESO MAXIMO PERMITDO
LOCAL wTotKg       := 0
LOCAL nPesoMaxPèrm := 0
LOCAL cMensagem    := ""
Local cTipo		   := SuperGetMv("MV_YTPBLQA",,"LOT") // "PBT" - parametro define qual tipo de validação vai valer, por lotação ou peso bruto.
Local aAreaTESTE   := GetArea()
Local cAviso1      := ''

DbSelectArea("SZ1")
do case
case cTipo == "LOTAGC" // So realizar esse calculo se for a validação na hora do agenciamento 07/04/16
DbSetOrder(1)
for nP := 1 to LEN(aPedMark)
If DbSeek(xFilial("SZ1")+aPedMark[nP][1])
If !Empty(SZ1->Z1_DTCANC)
//Alert("Pedido: "+SZ1->Z1_NUM+" Cancelado." )
Loop
Endif
wTotKg+= u_smgetQtdkg(SZ1->Z1_PRODUTO , SZ1->Z1_QUANT)
Endif
next nP

otherwise
DbSetOrder(8)
DbSeek(xFilial("SZ1")+cOC)
Do while .not. eof() .and. Z1_FILIAL == xFilial("SZ1") .and. Z1_OC == cOC
If !Empty(SZ1->Z1_DTCANC)
//Alert("Pedido: "+SZ1->Z1_NUM+" Cancelado." )
SZ1->(dbSkip())
Loop
Endif
//calcula a quantidade em kg, conforme fator de conversao no cadastro de produto Semar - Juailson 28/11/14
wTotKg+= u_smgetQtdkg(SZ1->Z1_PRODUTO , SZ1->Z1_QUANT)
DbSkip()
EndDo

endcase



//
// SEMAR - JUAILSON - 24/11/14
// Comparara Peso pedido de venda com Peso PESO MAXIMO PERMITIDO

// Funcao PARA PEGAR:    PESO MAXIMO PERMITIDO
//nPesoaux  <--- peso pego da balanca
nPesoMaxPèrm := u_smPMP(nPesoBalanca,cOC,cTipo)

If wTotKg > nPesoMaxPèrm

If  (nPesoMaxPèrm < 0)
cMensagem := "ATENCAO: A tara do caminhao ultrapassou o peso maximo permitido por lei, favor verIficar, pmp negativo. "
Endif

cAviso1 := If(cTipo=="LOT",' LOTAÇÃO: ',' PESO MAXIMO PERMITIDO(PMP): ')

alert('Peso dos pedidos é superior ao maximo permitido para este veiculo, ' + CRLF + CRLF + ;
' TOTAL PESO PEDIDO: ' + alltrim(str(wTotKg)) + CRLF + cAviso1 + alltrim(str(nPesoMaxPèrm)) ;
+ CRLF + ' DIfERENCA: ' + alltrim(str(wTotKg - nPesoMaxPèrm)  ) + CRLF + CRLF + alltrim(cMensagem) )
lRet := .f.
Endif



RestArea(aAreaTESTE)

Return lRet


// Semar - Juailson 24/11/2014
USER function smPMP(p_Pesobalanca, p_cOC, p_cTipo)

local nPesoBalanca := p_Pesobalanca
local cOC       := p_cOC
Local cTipo		:= p_cTipo
Local aAreaTARA := GetArea()
Local nRetorno := 0
//local nTARA := 0
local nPBT  := 0 // Peso bruto total ou lotação
local nCalc := 0 // PESOBRUTO - TARA

//nTARA := POSICIONE("SZ2",1,xFilial("SZ2")+M->Z8_PLACA,"Z2_TARA") // Semar - Juailson 28/11/14 passou a pegar o peso na pesagem
dbSelectArea("SZ8")
dbsetorder(1)
If	dbSeek(xFilial("SZ8")+ cOC ) //Posiciona na OC
If empty(SZ8->Z8_TPVEIC)
alert("Atencao: Não foi escolhido tipo de veiculo no Agenciamento, favor verIficar")
Else
nPBT := POSICIONE("ZZJ",1,xFilial("ZZJ")+SZ8->Z8_TPVEIC,If(substr(cTipo,1,3)=="LOT","ZZJ_LOTACA","ZZJ_PEBRTO"))
Endif
Else
Alert("OC nao encontrada(PMP), " + cOC )
Endif
//nCalc := (nPBT * 1000)  - nTARA   //ATENCAO o peso bruto total é em Toneladas t, por isso que esta sendo convertido para KG
//nCalc := (nPBT * 1000)  - nPesoBalanca   //ATENCAO o peso bruto total é em Toneladas t, por isso que esta sendo convertido para KG // Comentado por Alison 28/07/2016
//nPesoBalanca
nCalc := (nPBT * 1000)		// Ajustado a validação de pesagem de entrada para comparar total pedido x  lotação - Alison 28/07/2016
//	If !empty(nTARA)
//	MsgBox("TARA     Z2_TARA: " + str(nTARA)+ "            Peso Bruto: " + str(nPBT) +"  PESO MAXIMO PERMITIDO: " + str(nCalc))
//	Endif

RestArea(aAreaTARA)
//Retorna o PESO MAXIMO PERMITIDO

nRetorno := nCalc

return  nRetorno



// SOMA O PESO PRA VALIDAÇÃO DA CAPACIADADE DO CAMINHAO SEMAR - JUAILSON EM 29/11/14
USER function smgetQtdkg(p_cProduto, p_nQuant)
local wArea:= getArea()
local nTotalKg:=0

dbSelectArea('SB1')
dbsetorder(1)
If SB1->(DbSeek( xFilial('SB1')+p_cProduto  )) .And. SB1->B1_UM $ 'SC*SA'
If !Empty(SB1->B1_CONV)
Do Case
Case SB1->B1_TIPCONV=='M'
nTotalKg+= p_nQuant * SB1->B1_CONV
Case SB1->B1_TIPCONV=='D'
nTotalKg+= p_nQuant / SB1->B1_CONV
OtherWise
nTotalKg+= p_nQuant
EndCase
Endif
Else
nTotalKg+= p_nQuant * 1000  // para unidade de medida igaual a TL
Endif

RestArea(wArea)

return( nTotalKg )

//

/*

FORAM CRIADOS GATILHOS
Z8_PLCAR   - executao a funcao u_SmRetTpVeic() - para preencher o tipo de veiculo
Z8_PLCAR2

CRIAR GATILHOS COMO EXECBLOCK PARA DISPARAR NOS CAMPOS DAS PLACAS(Z8_PLACA, Z8_PLCAR E Z8_PLCAR2)

CHAVE 2 NOVA

JUAILSON - SEMAR EM 01/12/2014 -

*/
/*
user function SmRetTpVeic(p_placa,p_plcar,p_plcar2)
local lRet := .T.
local cTpVeic := ""
local wareaZ8:= getArea()

//	LER POR SELECT QUERY


cSql := "SELECT Z8_DATA, Z8_PLACA, Z8_PLCAR, Z8_PLCAR2, Z8_TPVEIC FROM "+RetSqlName("SZ8")+" SZ8 "
cSql += " WHERE SZ8.D_E_L_E_T_ = ' '"
cSql += " AND   SZ8.Z8_FILIAL  = '" +xFilial("SZ8")+ "'"

If   !empty(M->Z8_PLACA)
cSql += " AND   SZ8.Z8_PLACA  = '" + M->Z8_PLACA + "'"
Endif
//
If   !empty(M->Z8_PLCAR)
cSql += " AND   SZ8.Z8_PLCAR  = '" + M->Z8_PLCAR + "'"
Endif
//
If   !empty(M->Z8_PLCAR2)
cSql += " AND   SZ8.Z8_PLCAR2  = '" + M->Z8_PLCAR2 + "'"
Endif

cSql += " AND   SZ8.Z8_TPVEIC  <> ' ' "

//
cSql += " ORDER BY SZ8.Z8_DATA DESC "


If Select("QSMSZ8") > 0
dbSelectArea("QSMSZ8")
QSMSZ8->(DbCloseArea())
Endif
//wSQL := ChangeQuery(wSQL)
TcQuery cSql New Alias "QSMSZ8"

If !empty(QSMSZ8->Z8_TPVEIC)
cTpVeic := QSMSZ8->Z8_TPVEIC
//   Else
//      alert("Nao Encontrou TPVEIC")
Endif

QSMSZ8->(DbCloseArea())


RestArea(wareaZ8)

return ( cTpVeic )
*/


// Normando (Semar) 17/08/2015 - Tela para selecionar os pedidos bonIficados do cliente atual
Static Function SelecBonIf()

	Local 	aArea 		:= TSZ1->(GetArea())
	Local	aPerg		:= {}
	Local 	cAlias   	:= GetNextAlias()
	Local 	_aStruTrb 	:= {} //estrutura do temporario
	Local 	_aBrowse 	:= {} //array do browse para demonstracao das empresas
	Private cCadastro 	:= "Pedidos" //Requisito para MarkBrow
	Private aRotina		:= {} //Requisito para MarkBrow
	Private bFiltraBrw
	Private bMark    	:= {|| ValMark()} //Chamada de Função com Eval
	Private bMarkAll    := {|| MarkAll()} //Chamada de Função com Eval

	aAdd(aRotina,{"Confirmar" ,"CloseBrowse()" ,0,4})
	//³ Define campos do TRB ³
	//			   {Nome	 	,Tipo					  	,Tamanho  				 ,Decimais}
	aAdd(_aStruTrb,{"OK" 	 	, TamSX3("Z1_OK")[3]		, TamSX3("Z1_OK")[1]	  ,TamSX3("Z1_OK")[2]	 	})
	aAdd(_aStruTrb,{"EMISSAO"   , TamSX3("Z1_EMISSAO")[3]	, TamSX3("Z1_EMISSAO")[1] ,TamSX3("Z1_EMISSAO")[2]	})
	aAdd(_aStruTrb,{"NUM" 		, TamSX3("Z1_NUM")[3]	 	, TamSX3("Z1_NUM")[1]	  ,TamSX3("Z1_NUM")[2]		})
	aAdd(_aStruTrb,{"TIPO"		, TamSX3("Z1_TIPO")[3]		, TamSX3("Z1_TIPO")[1]    ,TamSX3("Z1_TIPO")[2]	})
	aAdd(_aStruTrb,{"PRODUTO"  	, TamSX3("Z1_PRODUTO")[3]	, TamSX3("Z1_PRODUTO")[1] ,TamSX3("Z1_PRODUTO")[2]	})
	aAdd(_aStruTrb,{"QUANT"		, TamSX3("Z1_QUANT")[3]	 	, TamSX3("Z1_QUANT")[1]	 ,TamSX3("Z1_QUANT")[2]		})
	aAdd(_aStruTrb,{"DTENT" 	, TamSX3("Z1_DTENT")[3]	 	, TamSX3("Z1_DTENT")[1]	 ,TamSX3("Z1_DTENT")[2]		})
	aAdd(_aStruTrb,{"NOMCLI" 	, TamSX3("Z1_NOMCLI")[3]	, TamSX3("Z1_NOMCLI")[1] ,TamSX3("Z1_NOMCLI")[2]	})
	aAdd(_aStruTrb,{"LOJA" 	 	, TamSX3("Z1_LOJA")[3]		, TamSX3("Z1_LOJA")[1]	 ,TamSX3("Z1_LOJA")[2]	})
	aAdd(_aStruTrb,{"LOCAL" 	, TamSX3("Z1_LOCAL")[3]		, TamSX3("Z1_LOCAL")[1]	 ,TamSX3("Z1_LOCAL")[2]	})
	aAdd(_aStruTrb,{"FRETE" 	, TamSX3("Z1_FRETE")[3]		, TamSX3("Z1_FRETE")[1]	 ,TamSX3("Z1_FRETE")[2]	})
	aAdd(_aStruTrb,{"FTRA" 	 	, TamSX3("Z1_FTRA")[3]		, TamSX3("Z1_FTRA")[1]	 ,TamSX3("Z1_FTRA")[2]	})
	aAdd(_aStruTrb,{"FMOT" 	 	, TamSX3("Z1_FMOT")[3]		, TamSX3("Z1_FMOT")[1]	 ,TamSX3("Z1_FMOT")[2]	})
	aAdd(_aStruTrb,{"HLIB"  	, TamSX3("Z1_HLIB")[3]		, TamSX3("Z1_HLIB")[1]	 ,TamSX3("Z1_HLIB")[2]	})
	aAdd(_aStruTrb,{"NLIB" 	    , TamSX3("Z1_NLIB")[3]		, TamSX3("Z1_NLIB")[1]	 ,TamSX3("Z1_NLIB")[2]	})



	//³ Define campos do MarkBrow referente ao campos do Alias³
	//			  {Nome	 	 ,Tipo	 ,Nome		  			,Pic}
	aAdd(_aBrowse,{"OK" 	 ,Nil	,""						, 							 	})
	aAdd(_aBrowse,{"EMISSAO" ,Nil	,RetTitle("Z1_EMISSAO")	, PESQPICT("SZ1","Z1_EMISSAO")	})
	aAdd(_aBrowse,{"NUM" 	 ,Nil	,RetTitle("Z1_NUM")		, PESQPICT("SZ1","Z1_NUM")	 	})
	aAdd(_aBrowse,{"TIPO"	 ,Nil	,RetTitle("Z1_TIPO")	, PESQPICT("SZ1","Z1_TIPO")	})
	aAdd(_aBrowse,{"PRODUTO" ,Nil	,RetTitle("Z1_PRODUTO")	, PESQPICT("SZ1","Z1_PRODUTO") 	})
	aAdd(_aBrowse,{"QUANT"	 ,Nil	,RetTitle("Z1_QUANT")	, PESQPICT("SZ1","Z1_QUANT")	})
	aAdd(_aBrowse,{"DTENT"   ,Nil	,RetTitle("Z1_DTENT")	, PESQPICT("SZ1","Z1_DTENT")	})
	aAdd(_aBrowse,{"NOMCLI"  ,Nil	,RetTitle("Z1_NOMCLI")	, PESQPICT("SZ1","Z1_NOMCLI")	})
	aAdd(_aBrowse,{"LOJA" 	 ,Nil	,RetTitle("Z1_LOJA")	, PESQPICT("SZ1","Z1_LOJA")		})
	aAdd(_aBrowse,{"LOCAL"   ,Nil	,RetTitle("Z1_LOCAL")	, PESQPICT("SZ1","Z1_LOCAL")	})
	aAdd(_aBrowse,{"FRETE"   ,Nil	,RetTitle("Z1_FRETE")	, PESQPICT("SZ1","Z1_FRETE")	})
	aAdd(_aBrowse,{"FTRA" 	 ,Nil	,RetTitle("Z1_FTRA")	, PESQPICT("SZ1","Z1_FTRA")		})
	aAdd(_aBrowse,{"FMOT" 	 ,Nil	,RetTitle("Z1_FMOT")	, PESQPICT("SZ1","Z1_FMOT")		})
	aAdd(_aBrowse,{"HLIB" 	 ,Nil	,RetTitle("Z1_HLIB")	, PESQPICT("SZ1","Z1_HLIB")		})
	aAdd(_aBrowse,{"NLIB"	 ,Nil	,RetTitle("Z1_NLIB")	, PESQPICT("SZ1","Z1_NLIB")		})

	If Select("TRB") > 0  //Se este alias já estiver em uso
		TRB->(DbCloseArea())
	Endif

	_cArqEmp:= CriaTrab(_aStruTrb)
	dbUseArea(.T.,__LocalDriver,_cArqEmp,"TRB",.T.,.F.)
	//Criando Indice Temporario
	_cIndex := Criatrab(Nil,.F.)
	TRB->(IndRegua("TRB",_cIndex,"NUM+DToS(EMISSAO)",,,"Indexando Registros..."))
	TRB->(DbSelectArea("TRB"))
	#IfNDEF TOP
	TRB->(DbSetIndex(_cIndex+OrdBagExt()))
	#Endif

	cQuery := " Select Z1_OK ,Z1_EMISSAO ,Z1_NUM ,Z1_TIPO ,Z1_PRODUTO ,Z1_QUANT ,Z1_DTENT ,Z1_NOMCLI ,Z1_LOJA ,Z1_LOCAL ,Z1_FRETE ,Z1_FTRA ,Z1_FMOT ,Z1_HLIB ,Z1_NLIB "
	cQuery += " From "+RetSQLName("SZ1")+"  "
	cQuery += " Where Z1_FILIAL = '"+xFilial("SZ1")+"' "
	cQuery += " and Z1_CLIENTE   = '"+SZ1->Z1_CLIENTE+"' "
	cQuery += " and Z1_TIPO     != 'N' "
	cQuery += " and Z1_NUM      != '"+SZ1->Z1_NUM+"' "
	cQuery += " and "+RetSQLName("SZ1")+".D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery(cQuery)

	DBUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),(cAlias), .F., .T.)
	(cAlias)->(DBSelectArea(cAlias))
	(cAlias)->(DBGotop())
	If (cAlias)->(!Eof())
		MsgInfo("Operador, existem mais pedidos para o cliente: "+chr(13)+CHR(10)+Z1_NOMCLI)

		While (cAlias)->(!Eof())
			TRB->(RecLock("TRB",.T.))
			TRB->OK 	 := (cAlias)->Z1_OK
			TRB->EMISSAO := StoD((cAlias)->Z1_EMISSAO)
			TRB->NUM 	 := (cAlias)->Z1_NUM
			TRB->TIPO 	 := (cAlias)->Z1_TIPO
			TRB->PRODUTO := (cAlias)->Z1_PRODUTO
			TRB->QUANT	:= (cAlias)->Z1_QUANT
			TRB->DTENT 	:= StoD((cAlias)->Z1_DTENT)
			TRB->NOMCLI := (cAlias)->Z1_NOMCLI
			TRB->LOJA 	:= (cAlias)->Z1_LOJA
			TRB->LOCAL 	:= (cAlias)->Z1_LOCAL
			TRB->FRETE 	:= (cAlias)->Z1_FRETE
			TRB->FTRA 	:= (cAlias)->Z1_FTRA
			TRB->FMOT 	:= (cAlias)->Z1_FMOT
			TRB->HLIB 	:= (cAlias)->Z1_HLIB
			TRB->NLIB 	:= (cAlias)->Z1_NLIB
			TRB->(MsUnlock())
			(cAlias)->(DbSkip())
		Enddo
		(cAlias)->(DbCloseArea())

		bFiltraBrw := {|| FilBrowse("TRB",nil,nil) }
		Eval(bFiltraBrw) //Executa filtro

		cMark	:= GetMark(,"TRB","OK")
		MarkBrow("TRB","OK",,_aBrowse,,cMark,"Eval(bMarkAll)",,,,"Eval(bMark)",,,,)

	Endif
	//Excluir arquivo de index pelo indregua()
	If File(_cIndex+OrdBagExt())
		FErase(_cIndex+OrdBagExt())
	Endif

	RestArea(aArea)
Return Nil


Static function ValMark

	If IsMark("OK",cMark)
		_nPos := Ascan(aReg, TRB->NUM) //Procura posição no Array
		ADel(aReg,_nPos) // Deleta posição no Array
		ASize(aReg,Len(aReg)-1) // Diminiu o tamanho do array retirando a sua ultima posiçã

		TRB->(RecLock("TRB",.F.))
		TRB->OK := Space(2)
		TRB->(MsUnlock())
	Else
		Aadd(aReg, TRB->NUM)
		TRB->(RecLock("TRB",.F.))
		TRB->OK := cMark
		TRB->(MsUnlock())
	Endif

Return Nil

Static Function MarkAll
	TRB->(DbGoTop())
	While TRB->(!EOF())
		ValMark()
		TRB->(DbSkip())
	EndDo

Return Nil





User function UpdQtdZ8()

	Local nQtdOrig	:= TSZ1->Z1_QUANT 						//Qtd antiga do pedido
	Local nQtdAtu	:= M->Z1_QUANT							//Qtd alterada do pedido
	Local cProduto	:= TSZ1->Z1_PRODUTO						//Necessário
	Local aItensOC	:= StrToKArr(SZ8->Z8_ITENSOC,"#")		//Converte o campo de itens da OC em array
	Local nPos		:= aScan(aItensOC,{|x| cProduto $ x})	//Pega a posição do produto corrente
	Local aInfo		:= If(nPos>0,StrToKArr(aItensOC[nPos],"/"),{})
	Local cStrAtu	:= ""

	Local cMot
	local cJust
	local cApro

	Private awLogs:={}


	//****************
	//>>>  CONTROLE DE RASTREABILIDADE DE OC
	//================
	//Sergio - Semar| maio/2016
	//****************

	//If cEmpAnt $ cEmpRastroOC		// Comentado por Rodrigo (Semar) - 21/06/16
	If cEmpAnt + cFilAnt $ cEmpRastroOC
		//LOG-MOTIVO/JUSTIfI.
		If !U_SMJUS(@cMot, @cJust, @cApro)
			Alert("Não foi possivel gravar a justIficativa para Alteraçao da Quantidade do Pedido.  A operaçao com esta OC, será abortada!")
			RestArea(wAreaATU)
			RestArea(wAreaSZ8)
			Return
		Endif

		//>>>>  AQUI *** CHAMAR FUNCAO DE GERAR REGISTRO DE BKP DO REGISTRO A SER ALTERADO
		nrecnoBkp:=0
		nrecnoBkp:=u_smBkpTbLog('SZ1')

		//LOG
		aAdd(awLogs, {/*Entidade1*/'SZ1',;
		/*Tipo Docto*/'PV',;
		/*Recno Doc1*/sz1->(recno()),;
		/*Tipo Log*/'ALT',;
		/*Des Log*/'PV-Alter.QTDD P/ CENTRAL',;
		/*Entidade2*/'',;
		/*Recno Doc2*/0,;
		/*Recno Bpk1*/nrecnoBkp,;
		/*Motivo*/cMot,;
		/*JustIficat.*/cJust,;
		/*Usuario*/cUserName,;
		/*Rotina Orig*/'SMFATF80',;
		/*Liberador1*/cApro} )

		//>>>>  AQUI *** CHAMAR FUNCAO DE GERAR REGISTRO DE BKP DO REGISTRO A SER ALTERADO
		nrecnoBkp:=0
		nrecnoBkp:=u_smBkpTbLog('SZ8')

		SZ8->(dbseek( xfilial('SZ8')+cOc ))
		//LOG
		aAdd(awLogs, {/*Entidade1*/'SZ8',;
		/*Tipo Docto*/'OC',;
		/*Recno Doc1*/SZ8->(recno()),;
		/*Tipo Log*/'ALT',;
		/*Des Log*/'OC-Alter.QTDD P/ CENTRAL',;
		/*Entidade2*/'',;
		/*Recno Doc2*/0,;
		/*Recno Bpk1*/nrecnoBkp,;
		/*Motivo*/cMot,;
		/*JustIficat.*/cJust,;
		/*Usuario*/cUserName,;
		/*Rotina Orig*/'SMFATF80',;
		/*Liberador1*/cApro} )

		MsgRun("Gerando LOG da Alteraçao PV Aguarde!","Log de Alteraçao de PV")
		u_SMGRVLG(awLogs)

	Endif

	If Len(aInfo) > 0
		//If val(aInfo[3]) == nQtdOrig
		aInfo[3]		:= transform((val(aInfo[3]) - nQtdOrig)+nQtdAtu,'@e 99999999.99')
		aItensOC[nPos] 	:= aInfo[1]+"/"+aInfo[2]+"/"+aInfo[3]
		//Endif
	Endif

	for nQ:=1 to LEN(aItensOC)
		If !EMPTY(aItensOC[nQ])
			cStrAtu += aItensOC[nQ]+"#"
		Endif
	next nQ

	If SZ8->Z8_OC == cOC //Garantir que esteja posicionado na mesma OC que chamou a tela de alteração
		RecLock("SZ8",.F.)
		SZ8->Z8_QUANT 	:= (SZ8->Z8_QUANT - nQtdOrig) + nQtdAtu
		SZ8->Z8_ITENSOC	:= If(!EMPTY(cStrAtu),cStrAtu,SZ8->Z8_ITENSOC)
		SZ8->(MsUnlock())
	Endif

return




//Atualiza campo Z1_OK
Static Function ATUZ1OK(_cZ1OK)

	TSZ1->(RecLock("TSZ1",.F.))
	TSZ1->Z1_OK := _cZ1OK
	TSZ1->(MsUnLock())

	SZ1->(dbGoto(TSZ1->R_E_C_N_O_))

	SZ1->(RecLock("SZ1",.F.))
	SZ1->Z1_OK := _cZ1OK
	SZ1->(MsUnLock())

Return(Nil)
