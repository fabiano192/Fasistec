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
	Local _lWhen	:= .F.
	Local _lDigPeso	:= .T.//u_ChkAcesso("DIGITAPESO",6,.F.)
	Local _nOptExp	:= 0

	Private _oDlg	:= Nil
	Private _oPBruto:= Nil
	Private _cPlaca	:= If(Type("M->LQ_PLACA")= 'U',Space(TamSX3("LQ_PLACA")[1]), M->LQ_PLACA)
	Private _oPlaca	:= Nil
	Private _cNomeMo:=''
	Private _oNomeMo:= Nil
	Private _nTara	:= 0
	Private _oTara	:= Nil
	Private _nPLiq	:= If(Type("M->LQ_PLIQUI")= 'U',0, M->LQ_PLIQUI)
	Private _oPLiq	:= Nil
	Private _nPBruto:= If(Type("M->LQ_PBRUTO")= 'U',0, M->LQ_PBRUTO)
	Private _nVlTot	:= 0
	Private _oVlTot	:= Nil
	Private _nPrUnit:= aCols[n][_nPosPrc]
	Private _oPrUnit:= Nil
	Private _cPictPs:= PesqPict("SZA","ZA_PBRUTO")

	Private _oTransp:= Nil
	Private _cTransp:= Space(6)

	If !Empty(_cPlaca)
		SZ1->(dbSetOrder(1))
		If SZ1->(MsSeek(xFilial("SZ1")+_cPlaca))
			_cNomeMo	:= SZ1->Z1_NOMEMOT
			_nTara		:= SZ1->Z1_PESO
			_cTransp	:= Alltrim(SZ1->Z1_CODTRAN) +' - '+SZ1->Z1_NOMETRA
		Endif
	Endif

	Define MsDialog _oDlg Title "Dados Adicionais" From 0,0 to 200,580 Of _oDlg Pixel

	_nLin := 5
	_nCol := 5

	_oGrupo1 := TGroup():New( _nLin,_nCol,_nLin+90,290,,_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	_nLin += 5
	_nCol += 5

	@ _nLin,_nCol say "Placa do veiculo: "	OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol + 60 MsGet _oPlaca VAR _cPlaca F3 "SZ1" Picture '@!' size 40,10 valid VldFld('PLACA') OF _oGrupo1 PIXEL Size 50,010

	@ _nLin,_nCol+115 SAY "Motorista: " OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+140 MsGet _oNomeMo VAR _cNomeMo When _lWhen OF _oGrupo1 PIXEL Size 130,010

	_nLin += 15

	@ _nLin,_nCol say "Transportadora: " OF _oGrupo1 PIXEL Size 60,010
	@ _nLin,_nCol+60 MsGet _oTransp Var _cTransp size 210,10 When .F. OF _oGrupo1 PIXEL Size 50,010
	//	@ _nLin,_nCol+60 MsGet _oTransp Var _cTransp size 210,10 When .F. OF _oGrupo1 PIXEL Size 50,010

	_nLin += 15

	@ _nLin,_nCol say "Peso bruto: " OF _oGrupo1 PIXEL Size 50,010
	//	@ _nLin,_nCol+60 MsGet _oPBruto VAR _nPBruto picture _cPictPs size 45,10 WHEN _lDigPeso VALID u_fVldPBruto()  OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+60 MsGet _oPBruto VAR _nPBruto picture _cPictPs size 45,10 WHEN _lDigPeso VALID VldFld('PESO')  OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+115 say "Tara: " OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+140 MsGet _oTara VAR _nTara when .f. size 45,10 picture _cPictPs OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+190 say "Peso liquido: " OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+225 MsGet _oPLiq VAR _nPLiq when .f. size 45,10 picture _cPictPs OF _oGrupo1 PIXEL Size 50,010

	_nLin += 15

	@ _nLin,_nCol say "Produto" OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+60 MsGet _cProduto size 040,10 when .f. OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+115 say "Vl Unit" OF _oGrupo1 PIXEL Size 50,010
	_cPictVal:="@er 9,999.99"
	@ _nLin,_nCol+140 MsGet _oPrUnit VAR _nPrUnit when .f. size 45,10 picture _cPictVal OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+190 say "Valor total:  " OF _oGrupo1 PIXEL Size 50,010
	@ _nLin,_nCol+225 MsGet _oVlTot VAR _nVlTot when .f. size 45,10 picture _cPictVal OF _oGrupo1 PIXEL Size 50,010

	_nLin += 20

	//	_oTBut1	:= TButton():New( _nLin,_nCol	 , "Capturar peso"		,_oDlg,{|| LoadPeso(@_nPBruto,@_nTara,@_nPLiq,@_nPrUnit,@_nVlTot) }	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )	
	_oTBut1	:= TButton():New( _nLin,_nCol	 , "Capturar peso"		,_oDlg,{|| u_BALS(@_nPBruto,@_nTara,@_nPLiq,@_nPrUnit,@_nVlTot) }	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )	
	_oTBut2	:= TButton():New( _nLin,_nCol+50 , "OK"					,_oDlg,{|| _nOptExp := 1,_oDlg:End()}	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut3	:= TButton():New( _nLin,_nCol+100, "Cancelar"			,_oDlg,{|| _nOptExp := 0,_oDlg:End()}	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOptExp  = 1
		_nQtde := _nPLiq
		M->LQ_VEICUL1:= _cPlaca
		M->LQ_PLACA  := _cPlaca
		M->LQ_PBRUTO := _nPBruto
		M->LQ_PLIQUI := _nPLiq
		M->LQ_TRANSP := Left(_cTransp,6)
	Else
		_nQtde := 0
	Endif

	aCols[n][_nPosQte] := _nQtde

Return(_nQtde)




Static Function VldFld(_cOpc)

	Local _lRet := .T.

	If _cOpc = 'PLACA'
		SZ1->(dbSetOrder(1))
		If !SZ1->(MsSeek(xFilial("SZ1")+_cPlaca))
			ExistCpo("SZ1",_cPlaca)
			_lRet := .F.
		Else
			_cNomeMo	:= SZ1->Z1_NOMEMOT
			_nTara		:= SZ1->Z1_PESO
			_nPLiq		:= _nPBruto - _nTara
			_cTransp	:= Alltrim(SZ1->Z1_CODTRAN) +' - '+SZ1->Z1_NOMETRA
			If _nPLiq < 0
				_nPLiq := 0
			Endif
		Endif
	ElseIf _cOpc = 'PESO'
		_nPLiq		:= _nPBruto - _nTara

		If _nPLiq < 0
			_nPLiq := 0
		Endif

	Endif

	_nVlTot		:= _nPrUnit * _nPLiq

	_oNomeMo:Refresh()
	_oTara:Refresh()
	_oPLiq:Refresh()
	_oTransp:Refresh()
	_oVlTot:Refresh()
	_oPlaca:Refresh()
	_oDLg:Refresh()

Return(_lRet)


/*
Static function LoadPeso(_nPBruto,_nTara,_nPLiq,_nPrUnit,_nVlTot)

	Local	nQtdBal		:= SuperGetMV("MV_YSMQTBL",,1)
	Local	aNomeBals	:= {}
	Local	aPtBals		:= {}
	Local 	oFont		:= TFont():New("Tahoma",,22,,.T.)

	Private cMsg		:= " "
	Private oDlg
	Private oGetBal

	For q:=1 to nQtdBal
		cQ := cValtoChar(q)
		AAdd(aNomeBals,SuperGetMV("MV_YSMNBL"+cQ,,"Balança "+cQ))
		AAdd(aPtBals  ,SuperGetMV("MV_YSMCBL"+cQ,,"COM"+cQ+":9600,N,8,1"))
	Next q

	aTam			:= MsAdvSize(.F.)

	oDlg			:= TDialog():New(aTam[7],0,(aTam[6]/4)+(((aTam[6]/5)/3)*nQtdBal),aTam[5]/3,"Captura Peso",,,,,,,,,.T.)

	aAreaT1			:= {aTam[1],aTam[2],aTam[3]/3,aTam[4]/7+(((aTam[4]/5)/3)*nQtdBal),5,3}
	nDivisoes1		:= nQtdBal+1
	aProp1			:= {}
	for q:=1 to nQtdBal
		AAdd(aProp1,{0,(85+nQtdBal)/nQtdBal})
	next q
	AAdd(aProp1,{0,15-nQtdBal})
	oArea1			:= redimensiona():New(aAreaT1,nDivisoes1,aProp1,.F.)
	aArea1			:= oArea1:RetArea()

	for q:=1 to nQtdBal
		cQ 					:= cValtoChar(q+1)
		&("aAreaT"+cQ)		:= {aArea1[q,2],aArea1[q,1],aArea1[q,4],aArea1[q,3],0,0}
		&("nDivisoes"+cQ)	:= 2
		&("aProp"+cQ)		:= {{70,0},{30,0}}
		&("oArea"+cQ)		:= redimensiona():New(&("aAreaT"+cQ),&("nDivisoes"+cQ),&("aProp"+cQ),.T.)
		&("aArea"+cQ)		:= &("oArea"+cQ):RetArea()

		&("bSay"+cQ)		:= "{|| '"+aNomeBals[q]+"' }"
		&("bBtn"+cQ)		:= "{|| _nPBruto := getPSer('"+aPtBals[q]+"'), _nPLiq := _nPBruto - _nTara, _nVlTot := _nPrUnit * _nPLiq }"

		oSayBal		:= TSay():New(&("aArea"+cQ)[1,1],&("aArea"+cQ)[1,2],&(&("bSay"+cQ)),oDlg,"@!",oFont,,,;
		,.T.,,,&("aArea"+cQ)[1,4]-&("aArea"+cQ)[1,2],&("aArea"+cQ)[1,3]-&("aArea"+cQ)[1,1])
		oBtBal		:= TButton():New(&("aArea"+cQ)[2,1],&("aArea"+cQ)[2,2],"Capturar Peso",oDlg,&(&("bBtn"+cQ));
		,&("aArea"+cQ)[2,4]-&("aArea"+cQ)[2,2],(&("aArea"+cQ)[2,3]-&("aArea"+cQ)[2,1])/2,,,,.T.)

		//TGroup():New(aArea1[q,1],aArea1[q,2],aArea1[q,3],aArea1[q,4],"tst"+cQ,oDlg,,,.T.)
	next q

	oGetBal			:= TGet():New(aArea1[q,1],aArea1[q,2],{|u| If(PCount() > 0 , cMsg := u, cMsg) },oDlg,;
	aArea1[q,4]-aArea1[q,2],aArea1[q,3]-aArea1[q,1],"@!",,0,,,.F.,,.T.,,.F.,;
	,.F.,.F.,,.F.,.F.,,cMsg,,,,)

	oDlg:Activate()

Return
*/