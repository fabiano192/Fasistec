#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0022     º Autor ³ Alexandro da Silvaº Data ³  10/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Pedidos Eliminados X Pedidos Colocados        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CR0083()

	LOCAL _oDlg	:= NIL
	Local _nOpc	:= 0

	DEFINE MSDIALOG _oDlg FROM 264,182 TO 441,613 TITLE "CONFERENCIA DE PEDIDOS" OF _oDlg PIXEL

	@ 004,010 TO 082,157 LABEL "" OF _oDlg PIXEL

	@ 010,017 SAY "Conferencia de Pedidos Eliminados X Inseridos   " OF _oDlg PIXEL Size 150,010
	@ 020,017 SAY "Conforme parametros informados  				   " OF _oDlg PIXEL Size 150,010
	@ 070,017 SAY "Programa CR0083.PRW                             " OF _oDlg PIXEL Size 150,010

	@ 10,167 BUTTON "Parametros"	SIZE 036,012 ACTION ( Pergunte("CR0083"))		OF _oDlg PIXEL
	@ 35,167 BUTTON "OK" 			SIZE 036,012 ACTION ( _nOpc := 1,_oDlg:End())	OF _oDlg PIXEL
	@ 60,167 BUTTON "Sair"			SIZE 036,012 ACTION ( _nOpc := 0,_oDlg:End())	OF _oDlg PIXEL

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc = 1

		Pergunte("CR0083",.F.)

		FWMsgRun(, {|_oMsg| CR083B(_oMsg) }, "Conferência Pedidos", "Gerando dados, aguarde..." )

	Endif

Return


Static Function CR083B(_oMsg)

	Local oFwMsEx 		:= NIL
	Local cArq 			:= ""
	Local cWorkSheet	:= ""
	Local cTable 		:= ""
	Local _lEnt 		:= .F.
	Local _cArq	

	Private _dDtElim := Ctod("")

	aStru := {}
	AADD(aStru,{"CLIENTE"  , "C" , 06, 0 })
	AADD(aStru,{"LOJA"     , "C" , 02, 0 })
	AADD(aStru,{"PRODUTO" , "C" , 15, 0 })
	AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
	AADD(aStru,{"DESCRIC"  , "C" , 30, 0 })
	AADD(aStru,{"PEDVE_ER" , "C" ,  6, 0 })
	AADD(aStru,{"ITEM_ER"  , "C" ,  2, 0 })
	AADD(aStru,{"EMISS_ER" , "D" ,  8, 0 })
	AADD(aStru,{"DTENT_ER" , "D" ,  8, 0 })
	AADD(aStru,{"QTDE_ER"  , "N" , 14, 2 })
	AADD(aStru,{"DTELIM"   , "D" ,  8, 0 })
	AADD(aStru,{"PEDVE_AT" , "C" ,  6, 0 })
	AADD(aStru,{"ITEM_AT"  , "C" ,  2, 0 })
	AADD(aStru,{"EMISS_AT" , "D" ,  8, 0 })
	AADD(aStru,{"DTENT_AT" , "D" ,  8, 0 })
	AADD(aStru,{"QTDE_AT"  , "N" , 14, 2 })
	AADD(aStru,{"QT_DIFER" , "N" , 14, 2 })
	AADD(aStru,{"CONTADOR" , "C" , 01, 0 })

	_cArqTRB := CriaTrab(aStru,.T.)
	_cIndTRB := "CLIENTE + LOJA + PRODUTO + PRODCLI + DTOS(DTENT_ER) + CONTADOR"

	dbUseArea(.T.,,_cArqTRB,"TRB",.F.,.F.)
	dbSelectArea("TRB")

	IndRegua("TRB",_cArqTRB,_cIndTRB,,,"Criando Trabalho...")

	_Query := " SELECT C6_PRODUTO,C6_BLQ,C6_XDTELIM,C6_NUM,C6_ITEM,C6_CPROCLI,C6_DESCRI,C5_EMISSAO,C5_CLIENTE,C5_LOJACLI,C6_ENTREG,C6_QTDVEN,C6_QTDENT "
	_Query += " FROM "+RetSqlName("SC5")+" C5 "
	_Query += " INNER JOIN "+RetSqlName("SC6")+" C6 ON C5_NUM = C6_NUM "
	_Query += " WHERE C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = ''"
	_Query += " AND C5_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_Query += " AND C5_LOJACLI BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_Query += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' "
	_Query += " AND C6_PRODUTO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	_Query += " AND C6_ENTREG BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' "
	_Query += " AND C6_QTDVEN > C6_QTDENT "
	_Query += " AND C6_PEDAMOS = 'N' "
	_Query += " AND (C6_BLQ = '' OR C6_XDTELIM = '"+DTOS(MV_PAR11)+"') "
	_Query += " ORDER BY C5_CLIENTE+C5_LOJACLI+C6_PRODUTO+C6_ENTREG+C6_BLQ DESC"

	TCQUERY _Query New ALIAS "ZC6"

	TcSetField("ZC6","C6_ENTREG" ,"D",8)
	TcSetField("ZC6","C5_EMISSAO","D",8)
	TcSetField("ZC6","C6_XDTELIM","D",8)

	Count to _nZC6 

	If _nZC6 > 0

		_oMsg:cCaption := 'Gerando dados...'
		ProcessMessages()

		ZC6->(dbGotop())

		While ZC6->(!Eof())

			If EMPTY(ZC6->C6_XDTELIM)
				_cPedElim := ""
				_cItemEL  := ""
				_dDtEmER  := CTOD("")
				_nQtElim  := 0
				_dDtElim  := CTOD("")
				_dDtAntig := CTOD("")

				_cPedNovo := ZC6->C6_NUM
				_cItemAt  := ZC6->C6_ITEM
				_dDtEmAt  := ZC6->C5_EMISSAO
				_dDtAtual := ZC6->C6_ENTREG
				_nQtNovo  := ZC6->C6_QTDVEN
			Else
				_cPedElim := ZC6->C6_NUM
				_cItemEL  := ZC6->C6_ITEM
				_dDtEmER  := ZC6->C5_EMISSAO
				_nQtElim  := ZC6->C6_QTDVEN - ZC6->C6_QTDENT
				_dDtElim  := ZC6->C6_XDTELIM
				_dDtAntig := ZC6->C6_ENTREG

				_cPedNovo := ""
				_cItemAt  := ""
				_dDtEmAt  := CTOD("")
				_dDtAtual := CTOD("")
				_nQtNovo  := 0

			Endif

			If !TRB->(dbSeek(ZC6->C5_CLIENTE+ZC6->C5_LOJACLI+ZC6->C6_PRODUTO+ZC6->C6_CPROCLI+DTOS(ZC6->C6_ENTREG)+"1"))
				TRB->(RecLock("TRB",.T.))
				TRB->CLIENTE  := ZC6->C5_CLIENTE
				TRB->LOJA     := ZC6->C5_LOJACLI
				TRB->PRODUTO  := ZC6->C6_PRODUTO
				TRB->PRODCLI  := ZC6->C6_CPROCLI
				TRB->DESCRIC  := ZC6->C6_DESCRI
				TRB->PEDVE_ER := _cPedElim
				TRB->ITEM_ER  := _cItemEL
				TRB->EMISS_ER := _dDtEmER
				TRB->DTENT_ER := _dDtAntig
				TRB->QTDE_ER  := _nQtElim
				TRB->DTELIM   := _dDtElim
				TRB->PEDVE_AT := _cPedNovo
				TRB->ITEM_AT  := _cItemAt
				TRB->EMISS_AT := _dDtEmAt
				TRB->DTENT_AT := _dDtAtual
				TRB->QTDE_AT  := _nQtNovo
				TRB->QT_DIFER := _nQtNovo - _nQtElim
				TRB->CONTADOR := "1"
				TRB->(MsUnlock())
			Else
				TRB->(RecLock("TRB",.F.))
				If Empty(TRB->PEDVE_ER)
					TRB->PEDVE_ER := _cPedElim
					TRB->ITEM_ER  := _cItemEL
					TRB->EMISS_ER := _dDtEmER
					TRB->DTENT_ER := _dDtAntig
					TRB->QTDE_ER  := _nQtElim
					TRB->DTELIM   := _dDtElim
				Else
					TRB->PEDVE_AT := _cPedNovo
					TRB->ITEM_AT  := _cItemAt
					TRB->EMISS_AT := _dDtEmAt
					TRB->DTENT_AT := _dDtAtual
					TRB->QTDE_AT  := _nQtNovo
				Endif
				TRB->QT_DIFER := TRB->QTDE_AT - TRB->QTDE_ER
				TRB->CONTADOR := "2"
				TRB->(MsUnlock())
			Endif

			ZC6->(dbSkip())
		EndDo

		_oFwMsEx := FWMsExcel():New()

		_cWorkSheet 	:= 	"Pedidos"
		_cTable 		:= 	"Conferência de Pedidos - "+dToc(dDatabase)

		_oFwMsEx:AddWorkSheet( _cWorkSheet )
		_oFwMsEx:AddTable( _cWorkSheet, _cTable )

		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Cliente"				, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Loja"					, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Produto Cronnos"		, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Produto Cliente"		, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Descrição"				, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Pedido (ER)"			, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Item PV (ER)"			, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Emissão (ER)"			, 1,4,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Dt Entrega (ER)"		, 1,4,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Quantidade (ER)"		, 3,2,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Dt Resíduo Eliminado"	, 1,4,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Pedido (Novo)"			, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Item PV (Novo)"			, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Emissão (Novo)"			, 1,4,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Dt Entrega (Novo)"		, 1,4,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Quantidade (Novo)"		, 3,2,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Qtde Diferença"			, 3,2,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Contador"				, 3,2,.F.)

		TRB->(dbGoTop())

		_oMsg:cCaption := 'Gerando Arquivo...'
		ProcessMessages()

		While TRB->(!EOF())

			_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
			TRB->CLIENTE	,;
			TRB->LOJA		,;
			TRB->PRODUTO	,;
			TRB->PRODCLI	,;
			TRB->DESCRIC	,;
			TRB->PEDVE_ER	,;
			TRB->ITEM_ER	,;
			TRB->EMISS_ER	,;
			TRB->DTENT_ER	,;
			TRB->QTDE_ER	,;
			TRB->DTELIM		,;
			TRB->PEDVE_AT	,;
			TRB->ITEM_AT	,;
			TRB->EMISS_AT	,;
			TRB->DTENT_AT	,;
			TRB->QTDE_AT	,;
			TRB->QT_DIFER	,;
			TRB->CONTADOR	})

			TRB->(dbSkip())
		EndDo

		_oFwMsEx:Activate()

		_cArq := CriaTrab( NIL, .F. ) + ".xls"

		_oFwMsEx:GetXMLFile( _cArq )

		_oMsg:cCaption := 'Abrindo Arquivo...'
		ProcessMessages()

		_cDirTmp 	:= GetTempPath()
		
		If __CopyFile( _cArq, _cDirTmp + _cArq )
			_oExcelApp := MsExcel():New()
			_oExcelApp:WorkBooks:Open( _cDirTmp + _cArq )
			_oExcelApp:SetVisible(.T.)
		Else
			MsgAlert( "Não foi possível a cópia do Arquivo para a pasta temporária do usuário." )
		Endif

		FErase(_cArqTrb+OrdBagExt())

	Else
		MsgAlert("Não foram encontrados dados para os parâmetros informados!")
	Endif

	ZC6->(dbCloseArea())
	TRB->(dbCloseArea())

Return