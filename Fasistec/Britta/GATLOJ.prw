#INCLUDE 'TOTVS.CH'


/*/{Protheus.doc} GLOJ001
//Gatillho do campo "Produto" da tabela SLR
@author Fabiano
@since 13/02/2019
/*/
User Function GLOJ001()

	Local _nPosPrd	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "LR_PRODUTO"})
	Local _nPosVlr	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "LR_VRUNIT"})
	Local _cProd	:= aCols[n][_nPosPrd]
	Local _nVlr		:= aCols[n][_nPosVlr]

	SZ2->(dbSetOrder(4))
	If SZ2->(MsSeek(xFilial("SZ2")+M->LQ_CLIENTE+M->LQ_LOJA+_cProd+"L"))
		_nVlr := SZ2->Z2_PRECO
	Endif

Return(_nVlr) 




/*/{Protheus.doc} GLOJ001
Gatillho do campo "Quantidade" da tabela SLR
@author Fabiano
@since 13/02/2019
/*/
User Function GLOJ002()

	Local _nPosPro	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "LR_PRODUTO"})
	Local _nPosQte	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "LR_QUANT"})
	Local _nPosPrc	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "LR_VRUNIT"})
	Local _cProduto	:= aCols[n][_nPosPro]
	Local _nQtde	:= aCols[n][_nPosQte]
	Local _nPrUnit	:= aCols[n][_nPosPrc]
	Local _lWhen	:= .F.
	Local _lDigPeso	:=u_ChkAcesso("DIGITAPESO",6,.F.)

	Private _oDlg	:= Nil
	Private _oPBruto:= Nil
	Private _cPlaca	:= Space(TamSX3("Z1_PLACA")[1])
	Private _cNomeMo:= ""
	Private _oNomeMo:= Nil
	Private _nTara	:= 0
	Private _oTara	:= Nil
	Private _nPLiq	:= 0
	Private _oPLiq	:= Nil
	Private _nPBruto:= 0
	Private _nVlTot	:= 0
	Private _oVlTot	:= Nil
	Private _cPictPs:= PesqPict("SZA","ZA_PBRUTO")

	Private _cEndEnt:=""
//	public _nPBruto  :=0

	bPeso:="iif(cEmpAnt=='01'.and.cFilant=='04',u_LeBjMro(),),iif(Type('_oPBruto')=='O',_oPBruto:Refresh(),'')"
	bTara:="u_BALS(@_nPBruto,@_nTara,@_nPLiq,@_nPrUnit,@_nVlTot)"

	//	setkey(123,{|| &bPeso} )
	//	setkey(122,{|| &bTara})
	//
	IF !_lDigPeso
		Eval({|| &bPeso })
	ENDIF

	Define MsDialog _oDlg Title "Dados Adicionais" From 0,0 to 200,580 Of _oDlg Pixel

	_nLin := 5
	_nCol := 5

	_oGrupo1 := TGroup():New( _nLin,_nCol,_nLin+90,290,,_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	_nLin += 5
	_nCol += 5


	@ _nLin,_nCol say "Placa do veiculo: "	OF _oGrupo1 PIXEL Size 50,010
	//	@ _nLin,_nCol + 60 MsGet _cPlaca F3 "SZ1" Picture '@!' size 40,10 valid VldPlaca('Placa').and._fFocus()) OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol + 60 MsGet _cPlaca F3 "SZ1" Picture '@!' size 40,10 valid VldPlaca('Placa') OF _oGrupo1 PIXEL Size 50,010

	@ _nLin,_nCol+115 SAY "Motorista: " OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+140 MsGet _oNomeMo VAR _cNomeMo When _lWhen OF _oGrupo1 PIXEL Size 130,010

	_nLin += 15

	@ _nLin,_nCol say "Endereco de entrega: " OF _oGrupo1 PIXEL Size 60,010
	@ _nLin,_nCol+60 MsGet _cEndent size 210,10 When .F. OF _oGrupo1 PIXEL Size 50,010

	_nLin += 15

	@ _nLin,_nCol say "Peso bruto: " OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+60 MsGet _oPBruto VAR _nPBruto picture _cPictPs size 45,10 WHEN _lDigPeso VALID u_fVldPBruto()  OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+115 say "Tara: " OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+140 MsGet _oTara VAR _nTara when .f. size 45,10 picture _cPictPs OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+190 say "Peso liquido: " OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+225 MsGet _oPLiq VAR _nPLiq when .f. size 45,10 picture _cPictPs OF _oGrupo1 PIXEL Size 50,010

	_nLin += 15

	@ _nLin,_nCol say "Produto" OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+60 MsGet _cProduto size 040,10 when .f. OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+115 say "Vl Unit" OF _oGrupo1 PIXEL Size 50,010
	_cPictVal:="@er 9,999.99"
	@ _nLin,_nCol+140 MsGet _nPrUnit when .f. size 45,10 picture _cPictVal OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+190 say "Valor total:  " OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+225 MsGet _oVlTot VAR _nVlTot when .f. size 45,10 picture _cPictVal OF _oGrupo1 PIXEL Size 50,010

	_nLin += 20

	//	_oTBut1	:= TButton():New( _nLin,_nCol	 , "Capturar peso"		,_oDlg, Eval({|| &bTara })	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )	
	_oTBut1	:= TButton():New( _nLin,_nCol	 , "Capturar peso"		,_oDlg,{|| u_LeBjBritta() }						, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )	
	_oTBut2	:= TButton():New( _nLin,_nCol+50 , "OK"					,_oDlg,{|| _nOptExp := 1,_oDlg:End()}	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut3	:= TButton():New( _nLin,_nCol+100, "Cancelar"			,_oDlg,{|| _nOptExp := 0,_oDlg:End()}	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG _oDlg CENTERED

Return(_nQtde)




Static Function VldPlaca()

	Local _lRet := .T.
	
	SZ1->(dbSetOrder(1))
	If !SZ1->(MsSeek(xFilial("SZ1")+_cPlaca))
		ExistCpo("SZ1",_cPlaca)
		_lRet := .F.
	Else
		_cNomeMo	:= SZ1->Z1_NOMEMOT
		_nTara		:= SZ1->Z1_PESO
		_nPLiq		:= _nTara - _nPBruto
	Endif
	
	_oNomeMo:Refresh()
	_oTara:Refresh()
	_oPLiq:Refresh()
	_oDLg:Refresh()

Return(_lRet)