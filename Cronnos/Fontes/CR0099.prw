#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.ch"

/*/
Função		: CR0099
Autor		: Fabiano da Silva
Data		: 31.10.16
Descricao	: Lançamento das Ocorrencias
/*/

User Function CR0099()
	
	Local _oDlg			:= Nil
	Local _oTBar		:= Nil
	Local _oTBtBmp1		:= Nil
	Local _oTBtBmp2		:= Nil
	Local _aCampos		:= {}
	Local _nFor			:= 0
	
	If Empty(SD3->D3_COD) .Or. Empty(SD3->D3_OP) .Or. Empty(SD3->D3_DOC) .Or. Empty(D3_LOCAL) .Or. Empty(D3_EMISSAO)
		MsgAlert('Algum dos campos abaixo não estão preenchidos:'+CRLF+;
			'Produto'+CRLF+;
			'Ord Produção'+CRLF+;
			'Documento'+CRLF+;
			'Local'+CRLF+;
			'Emissão' )
		Return(Nil)
	Endif
	
	If Empty(SD3->D3_YTURNO) .And. Empty(SD3->D3_YHREXIN) .And. Empty(SD3->D3_YHREXFI)
		MsgAlert('Turno ou Hora Extra não preenchido!')
		Return(Nil)
	Endif
	
	Private _oGetDad	:= Nil
	Private _aHeader	:= {}
	Private _aCols		:= {}
	Private _nUsado		:= 0
	
	_aCampos := {'ZE_ITEM','ZE_YOCORR','ZE_DESOCOR','ZE_YHORINI','ZE_YHORFIN'}
	
	For _nFor := 1 To Len(_aCampos)
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aCampos[_nFor]))
			_nUsado++
			
			aAdd(_aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
		Endif
	Next _nFor
	
	Private _nPosIte  := aScan(_aHeader,{|x| AllTrim(x[2])== "ZE_ITEM"    })
	Private _nPosOco  := aScan(_aHeader,{|x| AllTrim(x[2])== "ZE_YOCORR"  })
	Private _nPosDOc  := aScan(_aHeader,{|x| AllTrim(x[2])== "ZE_DESOCOR" })
	Private _nPosHIn  := aScan(_aHeader,{|x| AllTrim(x[2])== "ZE_YHORINI" })
	Private _nPosHFi  := aScan(_aHeader,{|x| AllTrim(x[2])== "ZE_YHORFIN" })
	
	_cQuery := " SELECT * FROM "+RETSQLNAME("SZE")+" ZE "
	_cQuery += " WHERE ZE.D_E_L_E_T_ = '' "
	_cQuery += " AND ZE_COD  	= '"+SD3->D3_COD+"'  "
	_cQuery += " AND ZE_LOCAL  	= '"+SD3->D3_LOCAL+"' "
	_cQuery += " AND ZE_OP    	= '"+SD3->D3_OP+"' "
	_cQuery += " AND ZE_EMISSAO = '"+DTOS(SD3->D3_EMISSAO)+"' "
	_cQuery += " AND ZE_LOTECTL	= '"+SD3->D3_LOTECTL+"' "
	_cQuery += " ORDER BY ZE_ITEM,ZE_YOCORR"
	
	TCQUERY _cQuery NEW ALIAS "TRB"
	
	TCSETFIELD("TRB","ZE_EMISSAO","D")
	
	TRB->(dbGotop())
	
	_aCols := {}
	While TRB->(!EOF())
		
		AADD(_aCols,Array(_nUsado+1))
		
		_aCols[Len(_aCols),_nPosIte] := TRB->ZE_ITEM
		_aCols[Len(_aCols),_nPosOco] := TRB->ZE_YOCORR
		_aCols[Len(_aCols),_nPosDOc] := Posicione("SX5",1,xFilial("SX5")+'Z4'+TRB->ZE_YOCORR,"X5_DESCRI")
		_aCols[Len(_aCols),_nPosHIn] := TRB->ZE_YHORINI
		_aCols[Len(_aCols),_nPosHFi] := TRB->ZE_YHORFIN
		
		_aCols[Len(_aCols),_nUsado+1]:=.F.
		
		TRB->(dbSkip())
	EndDO
	
	TRB->(dbCloseArea())
	
	If Empty(_aCols)
		
		AADD(_aCols,Array(_nUsado+1))
		
		For _ni:=1 to _nUsado
			_aCols[Len(_aCols),_ni] := CriaVar(_aHeader[_ni,2])
		Next
		
		_aCols[Len(_aCols),_nPosIte]  := "01"
		_aCols[Len(_aCols),_nUsado+1] := .F.
		
	Endif
	
	Private _cTotOc	:= U_SetHora(0)
	Private _oTotOc	:= Nil
	Private _cQtHor := U_SetHora(0)
	Private _nHorIn := 0
	Private _nHorFi := 0
	Private _nHorRI := 0
	Private _nHorRF := 0
	Private _nHorCC := 0
	Private _cHExtr
	
	_cCod	:= SD3->D3_COD
	_cOP	:= SD3->D3_OP
	_cDoc	:= SD3->D3_DOC
	_dEmis	:= SD3->D3_EMISSAO
	_cTurno	:= Alltrim(SD3->D3_YTURNO)
	_cLocal := SD3->D3_LOCAL
	
	If !Empty(_cTurno)
		_cHExtr	:= 'Não'
		dbSelectArea("SZA")
		SZA->(dbSetOrder(1))
		If SZA->(msSeek(xFilial("SZA")+SD3->D3_YTURNO))
			_cTurno += ' - '+Alltrim(SZA->ZA_DESTURN)
			_nHorIn := SZA->ZA_HRINI
			_nHorFi := SZA->ZA_HRFIM
			_nHorRI := SZA->ZA_HRINIRE
			_nHorRF := SZA->ZA_HRFIMRE
			_nHorCC := SZA->ZA_CAFECON
		Endif
	Else
		_cHExtr	:= 'Sim'
		_nHorIn := SD3->D3_YHREXIN
		_nHorFi := SD3->D3_YHREXFI
		_nHorCC := SD3->D3_YHREXDES
	Endif
	
	_cHorIn := U_SetHora(_nHorIn,'S')
	_cHorFi := U_SetHora(_nHorFi,'S')
	_cHorRI := U_SetHora(_nHorRI,'S')
	_cHorRF := U_SetHora(_nHorRF,'S')
	_cHorCC := U_SetHora(_nHorCC,'S')
	_cHorDe := SomaHoras(SubHoras(_cHorRF, _cHorRI), _cHorCC)
	_cQtHor := U_SetHora(SubHoras(SubHoras(_cHorFi,_cHorIn),_cHorDe),'S')
	
	DEFINE DIALOG _oDlg TITLE "Ocorrências" FROM 0,0 TO 410,1050 PIXEL
	
	_oTBar := TBar():New( _oDlg,25,32,.T.,,,,.F. )
	
	_oTBtBmp1 := TBtnBmp2():New( 00, 00, 35, 25, 'OK'	,,,,{||SaveSZE(),_oDlg:End()}	, _oTBar, 'Confirmar'	,,.F.,.F.)
	_oTBtBmp2 := TBtnBmp2():New( 00, 00, 35, 25, 'FINAL',,,,{||_oDlg:End()}	, _oTBar, 'Fechar'	,,.F.,.F.)
	
	@ 015, 005 to 048,510  OF _oDlg PIXEL
	
	@ 018, 010 SAY "Produto" 							SIZE 040, 007 OF _oDlg PIXEL
	@ 018, 050 MSGET _cCod			When .F.			SIZE 060, 010 OF _oDlg PIXEL
	
	@ 018, 150 SAY "Ordem Produção"						SIZE 040, 007 OF _oDlg PIXEL
	@ 018, 190 MSGET _cOP	 		When .F.			SIZE 060, 010 OF _oDlg PIXEL
	
	@ 018, 270 SAY "Documento" 							SIZE 040, 007 OF _oDlg PIXEL
	@ 018, 310 MSGET _cDoc	 		When .F.			SIZE 060, 010 OF _oDlg PIXEL
	
	@ 018, 400 SAY "Emissão"	 						SIZE 040, 007 OF _oDlg PIXEL
	@ 018, 440 MSGET dToc(_dEmis) 	When .F.			SIZE 060, 010 OF _oDlg PIXEL
	
	@ 033, 010 SAY "Turno"								SIZE 040, 007 OF _oDlg PIXEL
	@ 033, 050 MSGET _cTurno		When .F.			SIZE 200, 010 OF _oDlg PIXEL
	
	@ 033, 270 SAY "Horas Turno"	 					SIZE 040, 007 OF _oDlg PIXEL
	@ 033, 310 MSGET _cQtHor	 	When .F.			SIZE 060, 010 OF _oDlg PIXEL
	
	@ 033, 400 SAY "Total Ocor"							SIZE 080, 007 OF _oDlg PIXEL
	@ 033, 440 MSGET _oTotOc VAR _cTotOc	When .F.	SIZE 060, 010 OF _oDlg PIXEL
	
	_oGetDad := MsNewGetDados():New(052,005,200,510, GD_INSERT+GD_UPDATE+GD_DELETE,"U_CR99Line()", "AllwaysTrue()","+ZE_ITEM",,,,,,,_oDlg,_aHeader,_aCols)
	
	CalcHeader(_aCols,_aHeader)
	
	ACTIVATE DIALOG _oDlg CENTERED
	
Return(Nil)



User Function SetHora(_nValor,_cHex)
	
	Local _cHora		:= ""
	Local _cMinutos		:= ""
	Local _cSepar		:= ":"
	
	Default _cHex := 'N'
	
	_cHora := Alltrim(Transform(_nValor, "@E 99.99"))
	
	_cHora := Padl(_cHora,5,"0")
	
	//Fazendo tratamento para minutos
	_cMinutos := SubStr(_cHora, At(',', _cHora)+1, 2)
	If _cHex = 'N'
		_cMinutos := StrZero((Val(_cMinutos)*60)/100, 2)
	Endif
	
	//Atualiza a hora com os novos minutos
	_cHora := SubStr(_cHora, 1, At(',', _cHora))+_cMinutos
	
	//Atualizando o separador
	_cHora := StrTran(_cHora, ',', _cSepar)
	
Return(_cHora)




User Function CR99GAT(_cOpc)
	
	Local _aAreaOri	:= GetArea()
	Local _aAreaSZE	:= SZE->(GetArea())
	Local _cValor	:= ''
	
	If _cOpc = 'I'
		_cRet   := "aCols[n][_nPosHIn]"
		_nRet   := aCols[n][_nPosHIn]
	ElseIf _cOpc = 'F'
		_cRet   := "aCols[n][_nPosHFi]"
		_nRet := aCols[n][_nPosHFi]
	Endif
	
	If _nRet < _nHorIn .Or. _nRet > _nHorFi
		MsgAlert('Hora Digitada menor/maior que a hora inicial/final do Turno!')
		_nRet := 0
		&(_cRet) := 0
	Endif
	
	If _nRet < 0
		MsgAlert('Hora Digitada incorretamente!')
		_nRet    := 0
		&(_cRet) := 0
	ElseIf _nRet > 0
		
		_cValor := Alltrim(Transform(_nRet, "@E 99.99"))
		_cValor := Padl(_cValor,5,"0")
		
		_nHoras := Val(Left(_cValor, 2))
		_nMinut := Val(Right(_cValor,2))
		
		If _nHoras > 23 .Or. _nMinut > 59
			MsgAlert('Hora Digitada incorretamente!')
			_nRet := 0
			&(_cRet) := 0
		Endif
		
		If aCols[n][_nPosHFi] > 0 .And. (aCols[n][_nPosHFi] < aCols[n][_nPosHIn])
			MsgAlert('Hora Final não pode ser menor que a Hora Inicial!')
			_nRet := 0
			&(_cRet) := 0
		Endif
	Endif
	
	CalcHeader(aCols,aHeader)
	
	RestArea(_aAreaSZE)
	RestArea(_aAreaOri)
	
Return(_nRet)



Static Function CalcHeader(_aCols1,_aHeader1)
	
	_nTot   := 0
	_cTotOc := '00:00'
	For _nPosAcol := 1 To Len(_aCols1)
		
		If _aCols1[_nPosAcol][_nPosHIn] > 0 .And. _aCols1[_nPosAcol][_nPosHFi] > 0
			_nHora := SubHoras(U_SetHora(_aCols1[_nPosAcol][_nPosHFi],"S"), U_SetHora(_aCols1[_nPosAcol][_nPosHIn],"S"))
			
			_nTot := SomaHoras(_nTot,_nHora)
		Endif
		
	Next _nPosAcol
	
	_cTotOc	:= U_SetHora(_nTot,"S")
	_oTotOc:Refresh()
	
Return(Nil)


User Function CR99Line()
	
	_nRet := .T.
	
	If aCols[n][_nPosHFi] < aCols[n][_nPosHIn]
		MsgAlert('Hora Final não pode ser menor que a Hora Inicial!')
		_nRet := .F.
	Endif
	
	If Empty(aCols[n][_nPosOco]) .Or. Empty(aCols[n][_nPosHIn]) .Or. Empty(aCols[n][_nPosHFi])
		MsgAlert('Um ou mais campos não estão preenchidos no item '+aCols[n][_nPosIte]+'!')
		_nRet := .F.
	Endif
	
Return(_nRet)



Static Function SaveSZE()
	
	Local _nCol := 0
	
	SZE->(dbSetOrder(1))
	If SZE->(msSeek(xFilial("SZE")+_cCod+_cOP+_cLocal+_cDoc+Dtos(_dEmis)))
		
		_cChave := _cCod+_cOP+_cLocal+_cDoc+Dtos(_dEmis)
		
		While SZE->(!EOF()) .And. _cChave == SZE->ZE_COD+SZE->ZE_OP+SZE->ZE_LOCAL+SZE->ZE_DOC+DTOS(SZE->ZE_EMISSAO)
			
			SZE->(Reclock("SZE",.F.))
			SZE->(dbDelete())
			SZE->(msUnLock())
			
			SZE->(dbskip())
			
		EndDo
	Endif
	
	For _nCol := 1 To Len(_oGetDad:aCols)
		
		If !_oGetDad:aCols[_nCol][_nUsado+1]
			
			SZE->(Reclock("SZE",.T.))
			SZE->ZE_FILIAL	:= xFilial("SZE")
			SZE->ZE_COD		:= SD3->D3_COD
			SZE->ZE_OP		:= SD3->D3_OP
			SZE->ZE_DOC		:= SD3->D3_DOC
			SZE->ZE_LOCAL	:= SD3->D3_LOCAL
			SZE->ZE_EMISSAO	:= SD3->D3_EMISSAO
			SZE->ZE_LOTECTL	:= SD3->D3_LOTECTL
			SZE->ZE_YOCORR	:= _oGetDad:aCols[_nCol][_nPosOco]
			SZE->ZE_YTURNO	:= SD3->D3_YTURNO
			SZE->ZE_YHORINI	:= _oGetDad:aCols[_nCol][_nPosHIn]
			SZE->ZE_YHORFIN	:= _oGetDad:aCols[_nCol][_nPosHFi]
			SZE->ZE_HEXTRA	:= Left(_cHExtr,1) 
			SZE->ZE_ITEM	:= _oGetDad:aCols[_nCol][_nPosIte]
			SZE->(msUnLock())
			
		Endif
		
	Next _nCol
	
Return(Nil)
