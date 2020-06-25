*--------------------------------------------------------------------------------------------------------------------------------

#include "protheus.ch"
#include "tbiconn.ch"

*--------------------------------------------------------------------------------------------------------------------------------

//Autor  : ALEXANDRO DA SILVA       
//Data   : 22/09/2012 10:49
//Objeto : Prover a manutenção dos campos CONTA, CENTRO DE CUSTO, ITEM CONTÁBIL E CLASSE DE VALOR
//Cliente: 04019 - Mizu
//Projeto: À VULSO

*--------------------------------------------------------------------------------------------------------------------------------
User Function PXH014()

	Private cNomAnt, cTipAnt, nValAnt
	Private cAlias    := "SZQ"
	Private aRotina   := {}
	Private lRefresh  := .T.
	Private cCadastro := "Resumo de Centro de Custos"

	//AAdd( aRotina, {"Alterar"   , "AxAltera"  , 0, 4} )
	AAdd( aRotina, {"Pesquisar" , "AxPesqui"  , 0, 1} )
	AAdd( aRotina, {"Visualizar", "AxVisual"  , 0, 2} )
	AAdd( aRotina, {"Incluir"   , "AxInclui"  , 0, 3} )
	AAdd( aRotina, {"Excluir"   , "AxExclui"  , 0, 5} )
	AAdd( aRotina, {"Manutenção", "u_M860Alt" , 0, 4} )

	dbSelectArea(cAlias)

	dbSetOrder(1)

	mBrowse(,,,,cAlias)

Return(Nil)


User Function M860Alt()

	Local _cFilter, _nIndex
	Local _aGetSzq := SZQ->(GetArea())
	Local cIndex:=CriaTrab(Nil,.F.)

	Private _cOrdem, _bFiltParam

	_nIndex     := RetIndex("SZQ")
	_cOldFilter := SZQ->( DbFilter() )

	If Pergunte("PXH014",.T.)

		_dDataDe   := MV_PAR01
		_dDataAte  := MV_PAR02
		_cTpMovDe  := MV_PAR03
		_cTpMovAte := MV_PAR04
		_cDocDe    := MV_PAR05
		_cDocAte   := MV_PAR06
		_cCtbDe    := MV_PAR07
		_cCtbAte   := MV_PAR08
		_cCCDe     := MV_PAR09
		_cCCAte    := MV_PAR10
		_cItemDe   := MV_PAR11
		_cItemAte  := MV_PAR12
		_cClasVDe  := MV_PAR13
		_cClasVAte := MV_PAR14
		_cFornDe   := MV_PAR15
		_cFornAte  := MV_PAR16
		_cLojaDe   := MV_PAR17
		_cLojaAte  := MV_PAR18
		_cTESDe    := MV_PAR19
		_cTESAte   := MV_PAR20

		_bFiltParam := " ZQ_FILIAL  == '"+xFilial("SZQ")    +"' .AND. "
		_bFiltParam += " ZQ_TIPO    >= '"+_cTpMovDe         +"' .AND. ZQ_TIPO    <= '"+  _cTpMovAte       +"' .AND. " + CHR(13)
		_bFiltParam += " ZQ_NUM     >= '"+_cDocDe           +"' .AND. ZQ_NUM     <= '"+  _cDocAte         +"' .AND. " + CHR(13)
		_bFiltParam += " ZQ_CONTA   >= '"+_cCtbDe           +"' .AND. ZQ_CONTA   <= '"+  _cCtbAte         +"' .AND. " + CHR(13)
		_bFiltParam += " ZQ_YCC     >= '"+_cCCDe            +"' .AND. ZQ_YCC     <= '"+  _cCCAte          +"' .AND. " + CHR(13)
		_bFiltParam += " ZQ_ITEMCTA >= '"+_cItemDe          +"' .AND. ZQ_ITEMCTA <= '"+  _cItemAte        +"' .AND. " + CHR(13)
		_bFiltParam += " ZQ_CLVL    >= '"+_cClasVDe         +"' .AND. ZQ_CLVL    <= '"+  _cClasVAte       +"' .AND. " + CHR(13)
		_bFiltParam += " ZQ_FORNECE >= '"+_cFornDe          +"' .AND. ZQ_FORNECE <= '"+  _cFornAte        +"' .AND. " + CHR(13)
		_bFiltParam += " ZQ_LOJA    >= '"+_cLojaDe          +"' .AND. ZQ_LOJA    <= '"+  _cLojaAte        +"' .AND. " + CHR(13)
		_bFiltParam += " ZQ_TES     >= '"+_cTESDe           +"' .AND. ZQ_TES     <= '"+  _cTESAte         +"' .AND. " + CHR(13)

		_bFiltParam += " ZQ_ORIG = 'SD1'  .AND. " + CHR(13)

		_bFiltParam += " DtoS(ZQ_DTDIGIT)>='"+DtoS(_dDataDe)+"' .AND. DtoS(ZQ_DTDIGIT)<='"+DtoS(_dDataAte)+"' "

		_cFilter    := AllTrim(SZQ->( DbFilter() ))
		_cFilter    += IIF( !Empty(_cFilter), " .AND. ( "+_bFiltParam + " ) ",_bFiltParam)
		_cOrdem     := SZQ->( IIF(  .NOT. Type("_cOrdem") $ "UI,UE" .AND. .NOT. Empty(_cOrdem), _cOrdem, IndexKey() ) )
	Else
		_cOrdem  := SZQ->( IndexKey() )
		_cFilter := SZQ->( DbFilter() )
	Endif

	If !Empty(_cFilter)
		IndRegua("SZQ",cIndex,_cOrdem,,_cFilter,"Selecionado registros...")
		SZQ->( DbSetOrder(_nIndex+1) )
		SZQ->( DbGoTop() )
	Endif

	If SZQ->( Eof() .and. Bof() )
		Help(" ",1,"RECNO")
	Else
		M860Manut()
	EndIf

	dbSelectArea("SZQ")
	RetIndex("SZQ")

	IF !Empty(_cFilter)
		Set Filter to &(_cOldFilter)
		FErase(cIndex+OrdBagExt())
		RestArea(_aGetSzq)
	ENDIF

Return

Static Function M860Manut()

	Private cMarca       := GetMark()
	Private M->ZQ_RECNO  :=0
	Private aCpoBro      := {}
	Private _aArea			:= Array(5)
	Private _cEmpresa		:= SM0->M0_CODIGO
	Private _oZQ_CONTA,_oZQ_YCC,_oZQ_ITEMCTA,_oZQ_CLVL,_oDlgReg, oMark


	SX3->(dbSetOrder(2))
	SX3->(dbSeek("ZQ_MARCA"))
	SX3->(aAdd(aCpoBro,{RTRIM(X3_CAMPO),,RTRIM(X3_TITULO),RTRIM(X3_PICTURE)}))
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("SZQ"))
	SX3->(dbEval({||aAdd(aCpoBro,{RTRIM(X3_CAMPO),,RTRIM(X3_TITULO),RTRIM(X3_PICTURE)})},;
	{||X3Uso(X3_USADO) .and. X3_NIVEL <= cNivel},;
	{||.NOT. EOF() .AND. X3_ARQUIVO=="SZQ"} ))

	nOpca := 0
	nOpc  := 0

	DbSelectArea("SZQ")
	DbGoTop()

	aSize := MSADVSIZE()

	RegToMemory("SZQ",.T.)

	DEFINE MSDIALOG oDlgSzq TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

	oDlgSzq:lMaximized := .F.
	oPanel:= TPanel():New(0,0,'',oDlgSzq,, .T., .T.,, ,40,40,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP

	@ 003, 005 SAY "Empresa: " SIZE 30,10 PIXEL Of oPanel
	@ 003, 050 MSGET _oEmpresa VAR _cEmpresa SIZE 20,10 WHEN .F. PIXEL Of oPanel

	@ 013, 005 SAY "Conta Contábil" SIZE 50,10 PIXEL Of oPanel
	@ 013, 050 MSGET _oZQ_CONTA VAR M->ZQ_CONTA PICTURE PesqPict("SZQ","ZQ_CONTA") F3 "CT1" SIZE 50,8 PIXEL Of oPanel HASBUTTON

	@ 023, 005 SAY "Centro de Custo" SIZE 50,10 PIXEL Of oPanel
	@ 023, 050 MSGET _oZQ_YCC VAR M->ZQ_YCC PICTURE PesqPict("SZQ","ZQ_YCC") F3 "CTT" SIZE 50,8 PIXEL Of oPanel HASBUTTON

	@ 003, 120 SAY "Item Contábil" SIZE 50,10 PIXEL Of oPanel
	@ 003, 170 MSGET _oZQ_ITEMCTA VAR M->ZQ_ITEMCTA PICTURE PesqPict("SZQ","ZQ_ITEMCTA") F3 "CTD" SIZE 40,8 PIXEL Of oPanel HASBUTTON

	@ 013, 120 SAY "Classe de Valor" SIZE 50,10 PIXEL Of oPanel
	@ 013, 170 MSGET _oZQ_CLVL VAR M->ZQ_CLVL PICTURE PesqPict("SZQ","ZQ_CLVL") F3 "CTH" SIZE 20,8 PIXEL Of oPanel HASBUTTON

	@ 023, 120 SAY "Registros Marcados" SIZE 100,10 PIXEL Of oPanel
	@ 023, 170 MSGET _oDlgReg VAR M->ZQ_RECNO  PICTURE "@9" SIZE 30,8 PIXEL Of oPanel READONLY

	oMark 		 := MsSelect():New("SZQ","ZQ_MARCA",,aCpoBro,.F.,@cMarca,{50,oDlgSzq:nLeft,oDlgSzq:nBottom,oDlgSzq:nRight})
	oMark:bMark  := {|| M860Marck(.F.), oDlgSzq:Refresh() }
	oMark:bAval	 := {|| M860bAval(.F.), oDlgSzq:Refresh() }
	oMark:oBrowse:lhasMark     := .t.
	oMark:oBrowse:lCanAllmark  := .t.
	oMark:oBrowse:bAllMark     := { || setMarck() }
	oMark:oBrowse:Align 			:= CONTROL_ALIGN_ALLCLIENT

	ACTIVATE MSDIALOG oDlgSzq ON INIT EnchoiceBar(oDlgSzq,{|| nOpc:=1, oDlgSzq:End()},{||nOpc:=0, oDlgSzq:End()},.F.)

	IF nOpc == 1

		Processa( {||M860Replace()} )

	ENDIF

Return( Nil )

Static Function M860TotReg()

	If SZQ->ZQ_MARCA == cMarca
		M->ZQ_RECNO -= 1
	Else
		M->ZQ_RECNO -= 1
	EndIf

	M->ZQ_RECNO:= Iif (M->ZQ_RECNO < 0, 0 ,M->ZQ_RECNO )

Return

Static Function M860bAval(lTodos)

	Local lRet 		:= .T.
	Local _aGetSzq := SZQ->(GetArea())
	Default lTodos := .F.

	M860Marck( IIF( lTodos, .T., .F. ) )


	oMark:oBrowse:Refresh()
	RestArea(_aGetSzq)

Return(lRet)

Static Function M860Marck(lTodos)

	Local lRet := .T.
	Local _aRecno

	_aRecno := SZQ->( dbRLockList() )

	If ( _nPos := aScan( _aRecno, SZQ->( Recno() ) ) ) > 0 .OR. SZQ->( MsRLock() )
		IF lTodos
			IF ( SZQ->ZQ_MARCA <> cMarca )
				SZQ->ZQ_MARCA := cMarca
				M860TotReg()
			ENDIF
		ELSE
			SZQ->ZQ_MARCA := IIF(( SZQ->ZQ_MARCA <> cMarca ), cMarca, CriaVar("ZQ_MARCA",.F.) )
			M860TotReg()
		ENDIF
	ElseIf _nPos == 0
		IW_MsgBox("Este registro está sendo utilizado por outro terminal, não pode ser utilizado.","Atenção","STOP")
		lRet := .F.
	Endif

	SZQ->( dbRUnLock() )


Return(lRet)

Static Function M860Replace()

	Local _aRecno
	Local _aGAreaOld	:= GetArea()
	Local _aEmp 		:= {}
	Local _aReg			:= {}

	_aArea  := M860Area() //Mizu select area QUANDO A ORIGEM DO DOCUMENTO FOR DIFERENTE DA EMPRESA ATUAL
	_aRecno := SZQ->( dbRLockList() )

	SZQ->( dbGoTop() )
	ProcRegua(1)

	WHILE SZQ->( !EOF() )

		IF SZQ->ZQ_MARCA == cMarca

			SZQ->( aAdd( _aReg, { Left(ZQ_CODEMP,2), Recno() } ) )

			IF !EMPTY(Left(SZQ->ZQ_CODEMP,2)) .AND. aScan( _aEmp, Left(SZQ->ZQ_CODEMP,2) ) == 0
				aAdd( _aEmp, Left(SZQ->ZQ_CODEMP,2) )
			ENDIF

		ENDIF

		SZQ->(dbSkip())

	ENDDO

	aSort( _aReg,,,{|x,y| x[1] < y[1] } )

	IF LEN( _aEmp ) > 0

		IF _aEmp[1] == SM0->M0_CODIGO
			u_M860Save(.F., _aEmp[1], _aReg, _aArea, "01", cMarca )
		ELSE
			FOR _nI:=1 TO LEN(_aEmp)
				STARTJOB("u_M860Save", GetEnvServer(), .T., .T., _aEmp[1], _aReg, _aArea, "01", cMarca )
			NEXT
		ENDIF

	ENDIF

	RestArea( _aGAreaOld )

	Return( Nil )
	*-----------------------------------------------------------------------------------------------------------------------------------------------------
User Function M860Save( _lEmpDif, _cEmp, _aReg, _aParam, _cFil, _cMarca )

	Local _nI:= 0
	Local aRecnoSd1 := {}

	PRIVATE ZQ_YCC, ZQ_ITEMCTA, ZQ_CONTA, ZQ_CLVL, aRecnoOk := {}

	IF _lEmpDif
		PREPARE ENVIRONMENT EMPRESA ( _cEmp ) FILIAL ( _cFil )
		//dbUseArea(.T.,'TOPCONN',_aParam[1]+'0',_aParam[1],.T.,.F.)
		dbSelectArea(_aParam[1])
	ENDIF

	IF _lEmpDif
		Conout('Iniciando processo de gravacao ....')
	ENDIF

	dbSelectArea("SZQ")

	_nInicio:= aScan( _aReg, {|x| x[1] == _cEmp} )

	Eval(&(_aParam[5])) //Inicializa variáveis de memória "{||"+"M->ZQ_YCC:="+ValToSql(M->ZQ_YCC)+", M->ZQ_ITEMCTA:="+ValToSql(M->ZQ_ITEMCTA)", M->ZQ_CONTA:="+ValToSql(M->ZQ_CONTA)+", M->ZQ_CLVL:="+ValToSql(M->ZQ_CLVL)+"}"

	IF _nInicio > 0

		Begin Transaction

			For _nI:=_nInicio TO Len(_aReg)

				IF	_aReg[_nI][1] <> _cEmp
					EXIT
				ENDIF

				SZQ->( dbGoTo( _aReg[_nI][2] ) )
				_cKeyFind := &(_aParam[3])

				IF _lEmpDif
					Conout("Alaterando documento:[ " +_cEmp+_cFil+_cKeyFind+ " ]" )
				ENDIF

				dbSelectArea(_aParam[1])
				dbSetOrder  (_aParam[2])

				aRecnoSzq := fRecnoSzq()

				IF "SD1" $ _aParam[1]

					aRecnoSd1 := fRecnoSd1() //SELECIONA OS REGISTROS QUE SERÃO ALTERADOS NO SD1

//					IF Len(aRecnoSzq) <> Len(aRecnoSd1)
//						Conout("O filtro utilizado no SZQ não trouxe a mesma quantidade de registros existente no SD1 (itens da NF de entrada) "+SZQ->(ZQ_NUM)+". A alteração não será realizada.")
//						Loop
//					ENDIF

					For _nY:=1 TO Len(aRecnoSd1)

						IF aRecnoSzq[_nY][1] == _cMarca //verifica se o item do documento foi marcado

							(_aParam[1])->( dbGoTo(aRecnoSd1[_nY]) ) //posiciona sd1

							RecLock(_aParam[1],.F.)

							IF _lEmpDif
								Conout("Registro:[ " +STR(RECNO())+ " ]" )
							ENDIF

							IF _lEmpDif
								Conout("TABELA:[ " +_aParam[1]+ " ]" )
								Conout("D1_CONTA:[ " +SD1->D1_CONTA+ " ]" )
								Conout("ZQ_CONTA:[ " +M->ZQ_CONTA+ " ]" )
							ENDIF

							(_aParam[1])->D1_CC 		 := IIF("LIMPAR" $ UPPER(M->ZQ_YCC)		, CriaVar("ZQ_YCC",.F.)		,IIF(!Empty(M->ZQ_YCC),		M->ZQ_YCC,		(_aParam[1])->D1_CC ) )
							(_aParam[1])->D1_ITEMCTA := IIF("LIMPAR" $ UPPER(M->ZQ_ITEMCTA), CriaVar("ZQ_ITEMCTA",.F.),IIF(!Empty(M->ZQ_ITEMCTA),M->ZQ_ITEMCTA,	(_aParam[1])->D1_ITEMCTA ) )
							(_aParam[1])->D1_CONTA   := IIF("LIMPAR" $ UPPER(M->ZQ_CONTA)	, CriaVar("ZQ_CONTA",.F.)	,IIF(!Empty(M->ZQ_CONTA),	M->ZQ_CONTA,	(_aParam[1])->D1_CONTA ) )
							(_aParam[1])->D1_CLVL    := IIF("LIMPAR" $ UPPER(M->ZQ_CLVL)	, CriaVar("ZQ_CLVL",.F.)	,IIF(!Empty(M->ZQ_CLVL),	M->ZQ_CLVL,		(_aParam[1])->D1_CLVL ) )

							(_aParam[1])->( MsUnLock() )

							dbGoTo(aRecnoSzq[_nY][2]) //posiciona szq
							fSaveSzq() //salva szq

						ENDIF

					Next

				ELSEIF _aParam[1] == "SD3"

					aRecnoSd3 := fRecnoSd3() //SELECIONA OS REGISTROS QUE SERÃO ALTERADOS NO SD3

					IF Len(aRecnoSzq) <> Len(aRecnoSd3)
						Conout("O filtro utilizado no SZQ não trouxe a mesma quantidade de registros existente no SD3 (movimento interno)"+SZQ->(ZQ_NUM)+". A alteração não será realizada.")
						Loop
					ENDIF

					For _nY:=1 TO Len(aRecnoSd3)

						IF aRecnoSzq[_nY][1] == _cMarca //verifica se o item do documento foi marcado

							(_aParam[1])->( dbGoTo(aRecnoSd3[_nY]) ) //posiciona sd3

							IF _lEmpDif
								Conout("Registro:[ " +STR(RECNO())+ " ]" )
							ENDIF

							IF _lEmpDif
								Conout("TABELA:[ " +_aParam[1]+ " ]" )
								Conout("D1_CONTA:[ " +SD1->D1_CONTA+ " ]" )
								Conout("ZQ_CONTA:[ " +M->ZQ_CONTA+ " ]" )
							ENDIF

							RecLock(_aParam[1],.F.)
							(_aParam[1])->D3_CC 		 := IIF("LIMPAR" $ UPPER(M->ZQ_YCC)		, CriaVar("ZQ_YCC",.F.)		,IIF(!Empty(M->ZQ_YCC),		M->ZQ_YCC,		(_aParam[1])->D3_CC ) )
							(_aParam[1])->D3_ITEMCTA := IIF("LIMPAR" $ UPPER(M->ZQ_ITEMCTA), CriaVar("ZQ_ITEMCTA",.F.),IIF(!Empty(M->ZQ_ITEMCTA),M->ZQ_ITEMCTA,	(_aParam[1])->D3_ITEMCTA ) )
							(_aParam[1])->D3_CONTA   := IIF("LIMPAR" $ UPPER(M->ZQ_CONTA)	, CriaVar("ZQ_CONTA",.F.)	,IIF(!Empty(M->ZQ_CONTA),	M->ZQ_CONTA,	(_aParam[1])->D3_CONTA ) )
							(_aParam[1])->D3_CLVL    := IIF("LIMPAR" $ UPPER(M->ZQ_CLVL)	, CriaVar("ZQ_CLVL",.F.)	,IIF(!Empty(M->ZQ_CLVL),	M->ZQ_CLVL,	(_aParam[1])->D3_CLVL ) )
							(_aParam[1])->( MsUnLock() )

							dbGoTo(aRecnoSzq[_nY][2]) //posiciona szq
							fSaveSzq() //salva szq

						ENDIF

					Next

				ENDIF

			Next

		End Transaction

		IF _lEmpDif
			Conout( "Processamento concluido" )
		ENDIF

	ENDIF

	IF _lEmpDif
		//RESET ENVIRONMENT
		(_aParam[1])->(dbCloseArea())
	ENDIF

	Return
	*-----------------------------------------------------------------------------------------------------------------------------------------------------
Static Function fSaveSzq()
	RECLOCK("SZQ",.F.)
	SZQ->ZQ_MARCA   := CriaVar("ZQ_MARCA",.F.)
	SZQ->ZQ_CONTA   := IIF("LIMPAR" $ UPPER(M->ZQ_CONTA)	, CriaVar("ZQ_CONTA",.F.)	,IIF(!Empty(M->ZQ_CONTA)	,	M->ZQ_CONTA		,	SZQ->ZQ_CONTA ) )
	SZQ->ZQ_YCC     := IIF("LIMPAR" $ UPPER(M->ZQ_YCC)		, CriaVar("ZQ_YCC",.F.)		,IIF(!Empty(M->ZQ_YCC)		,	M->ZQ_YCC		,	SZQ->ZQ_YCC ) )
	SZQ->ZQ_ITEMCTA := IIF("LIMPAR" $ UPPER(M->ZQ_ITEMCTA), CriaVar("ZQ_ITEMCTA",.F.),IIF(!Empty(M->ZQ_ITEMCTA)	,	M->ZQ_ITEMCTA	,	SZQ->ZQ_ITEMCTA ) )
	SZQ->ZQ_CLVL    := IIF("LIMPAR" $ UPPER(M->ZQ_CLVL)	, CriaVar("ZQ_CLVL",.F.)	,IIF(!Empty(M->ZQ_CLVL)		,	M->ZQ_CLVL		,	SZQ->ZQ_CLVL ) )
	SZQ->(MsUnLock())
	Return
	*-----------------------------------------------------------------------------------------------------------------------------------------------------
Static Function fRecnoSzq()

	Local aRecnoSzq := {}
	Local cQry
	Local aOldArea := GetArea()

	cQry := " SELECT ZQ_MARCA, R_E_C_N_O_ "
	cQry += "   FROM " + RetSqlName("SZQ")
	cQry += "  WHERE D_E_L_E_T_ = '' "
	cQry += "    AND ZQ_FILIAL   = "+ValToSql( xFilial("SZQ")  )
	cQry += "    AND ZQ_CODEMP  >= "+ValToSql( SZQ->ZQ_CODEMP  ) +" AND ZQ_CODEMP  <= "+  ValToSql(SZQ->ZQ_CODEMP)
	cQry += "    AND ZQ_CODFIL  >= "+ValToSql( SZQ->ZQ_CODFIL  ) +" AND ZQ_CODFIL  <= "+  ValToSql(SZQ->ZQ_CODFIL )
	IF SZQ->ZQ_ORIG <> "SD3"
		cQry += "    AND ZQ_TIPO    >= "+ValToSql( SZQ->ZQ_TIPO    ) +" AND ZQ_TIPO    <= "+  ValToSql(SZQ->ZQ_TIPO   )
	ENDIF
	cQry += "    AND ZQ_NUM     >= "+ValToSql( SZQ->ZQ_NUM     ) +" AND ZQ_NUM     <= "+  ValToSql(SZQ->ZQ_NUM    )
	IF SZQ->ZQ_ORIG <> "SD3"
		cQry += "    AND ZQ_FORNECE >= "+ValToSql( SZQ->ZQ_FORNECE ) +" AND ZQ_FORNECE <= "+  ValToSql(SZQ->ZQ_FORNECE)
	ENDIF
	cQry += "    AND ZQ_LOJA    >= "+ValToSql( SZQ->ZQ_LOJA    ) +" AND ZQ_LOJA    <= "+  ValToSql(SZQ->ZQ_LOJA   )
	cQry += "    AND ZQ_ORIG     = "+ValToSql( SZQ->ZQ_ORIG    )
	cQry += " Order by R_E_C_N_O_ "


	cQry := ChangeQuery(cQry)

	MemoWrit("RecnoSd1.SQL",cQry)

	if select('TRB')>0
		trb->(dbCloseArea())
	endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TRB",.T.,.T.)
	dbSelectArea("TRB")
	dbGoTop()

	dbEval( { || aAdd( aRecnoSzq, {TRB->ZQ_MARCA, TRB->R_E_C_N_O_} ) } )

	TRB->(dbCloseArea())

	RestArea( aOldArea )
	Return(aRecnoSzq)
	*-----------------------------------------------------------------------------------------------------------------------------------------------------
Static Function fRecnoSd1()

	Local nQtdREg 	 := 0
	Local aRecnoSd1 := {}
	Local cQry
	Local aOldArea := GetArea()

	cQry := " SELECT R_E_C_N_O_ "
	cQry += "   FROM " + "SD1"+Left(SZQ->ZQ_CODEMP,2)+"0"
	cQry += "  WHERE D_E_L_E_T_ = ''"
	cQry += "    AND D1_FILIAL  = " + ValToSql(RIGHT(SZQ->ZQ_CODEMP,3)+SZQ->ZQ_CODFIL)
	cQry += "    AND D1_DOC     = " + ValToSql(SZQ->ZQ_NUM     )
	cQry += "    AND D1_SERIE   = " + ValToSql(SZQ->ZQ_PREFIXO )
	cQry += "    AND D1_FORNECE = " + ValToSql(SZQ->ZQ_FORNECE )
	cQry += "    AND D1_LOJA    = " + ValToSql(SZQ->ZQ_LOJA    )
	cQry += " Order by R_E_C_N_O_ "

	cQry := ChangeQuery(cQry)

	MemoWrit("RecnoSd1.SQL",cQry)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TRB",.T.,.T.)

	dbSelectArea("TRB")
	dbGoTop()
	dbEval({|| aAdd( aRecnoSd1, R_E_C_N_O_ ) } )

	TRB->(dbCloseArea())
	RestArea(aOldArea)

	Return(aRecnoSd1)
	*-----------------------------------------------------------------------------------------------------------------------------------------------------
Static Function fRecnoSd3()

	Local nQtdREg 	 := 0
	Local aRecnoSd3 := {}
	Local cQry
	Local aOldArea := GetArea()

	cQry := " SELECT R_E_C_N_O_ "
	cQry += "   FROM " + "SD3"+Left(SZQ->ZQ_CODEMP,2)+"0"
	cQry += "  WHERE D_E_L_E_T_ = ''"
	cQry += "    AND D3_FILIAL  = " + ValToSql(Right(SZQ->ZQ_CODEMP,3)+SZQ->ZQ_CODFIL)
	cQry += "    AND D3_DOC     = " + ValToSql(SZQ->ZQ_NUM)
	cQry += " Order by R_E_C_N_O_ "

	cQry := ChangeQuery(cQry)

	MemoWrit("RecnoSd3.SQL",cQry)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TRB",.T.,.T.)

	dbSelectArea("TRB")
	dbGoTop()
	dbEval({|| aAdd( aRecnoSd3, R_E_C_N_O_ ) } )

	TRB->(dbCloseArea())
	RestArea(aOldArea)

Return(aRecnoSd3)

Static Function M860Area()

	Local _cEmp := IIF(Left(SZQ->ZQ_CODEMP,2)<>SM0->M0_CODIGO,Left(SZQ->ZQ_CODEMP,2)+"0","")

	IF SZQ->ZQ_ORIG == "SD1"
		_aArea[1] := "SD1"
		_aArea[2] := 1
		_aArea[3] := "SZQ->(ZQ_CODFIL+PADR(ZQ_NUM,9)+ZQ_PREFIXO+ZQ_FORNECE+ZQ_LOJA+ZQ_PRODUTO)"
		_aArea[4] := _aArea[1]+"->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD)"
		_aArea[5] := "{||"+"M->ZQ_YCC:="+ValToSql(M->ZQ_YCC)+", M->ZQ_ITEMCTA:="+ValToSql(M->ZQ_ITEMCTA)+", M->ZQ_CONTA:="+ValToSql(M->ZQ_CONTA)+", M->ZQ_CLVL:="+ValToSql(M->ZQ_CLVL)+"}"
	ELSEIF SZQ->ZQ_ORIG == "SD3"
		_aArea[1] := "SD3"
		_aArea[2] := 2
		_aArea[3] := "SZQ->(ZQ_CODFIL+PADR(ZQ_NUM,9)+ZQ_PRODUTO)"
		_aArea[4] := _aArea[1]+"->(D3_FILIAL+D3_DOC+D3_COD)"
		_aArea[5] := "{||"+"M->ZQ_YCC:="+ValToSql(M->ZQ_YCC)+", M->ZQ_ITEMCTA:="+ValToSql(M->ZQ_ITEMCTA)+", M->ZQ_CONTA:="+ValToSql(M->ZQ_CONTA)+", M->ZQ_CLVL:="+ValToSql(M->ZQ_CLVL)+"}"
	ENDIF

Return(_aArea)


Static function setMarck()

	While !szq->(eof())
		M860bAval( .T. )
		szq->(dbskip())
	EndDo

	szq->(dbgotop())
	oDlgSzq:Refresh()

Return