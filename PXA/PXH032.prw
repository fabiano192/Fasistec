#INCLUDE "TOTVS.CH"

/*
Programa 	: PXH032
Autor 		: Fabiano da Silva
Data 		: 08/10/13
Descrição	: Controle de Paradas (Boletim diário - Resumo Gerencial)
*/


User Function PXH032()

	Private oDlgPrinc,oDlgSec,_oMes
	Private F := 0
	Private aCoors   := FWGetDialogSize( oMainWnd )
	Private oFont0, ofont3
	Private _cTemMec := _cTemEle := _cTemHid := _cTemFal := _cTemTra := _cTemTro := '00:00'
	Private _nParMec := _nParEle := _nParHid := _nParFal := _nParTra := _nParTro := 0
	Private _oTemMec := _oTemEle := _oTemHid := _oTemFal := _oTemTra := _oTemTro := nil
	Private _oParMec := _oParEle := _oParHid := _oParFal := _oParTra := _oParTro := nil
	Private oSay01 := oSay02 := oSay03 := oSay04 := oSay05 := oSay06 := oSay07 := oSay08 := oSay09 := oSay10 := oSay11 := oSay12 := oSay13 := nil
	Private oSay15 := oSay16 := oSay17 := oSay18 := oSay19 := oSay20 := oSay21 := oSay22 := oSay23 := oSay24 := oSay25 := nil
	Private oPanel2 := oPanel3 := _oDtRef := Nil
	Private _nCont  := 0
	Private _lEnt   := .F.
	Private _nOpt   := 0
	Private oPanel1, oPanel2
	
	For V := 1 to 21
		For T := 1 to 11
			_cRet1 := ('_cVal'+Strzero(V,2)+Strzero(T,2))
			_cRet2 := ('_cMot'+Strzero(V,2)+Strzero(T,2))
			_cRet3 := ('_oVal'+Strzero(V,2)+Strzero(T,2))
			_cRet4 := ('_oMot'+Strzero(V,2)+Strzero(T,2))

			Private &(_cRet1) := '00:00'
			Private &(_cRet2) := Space(1)
			Private &(_cRet3) := Nil
			Private &(_cRet4) := Nil

		Next T
		_cRet5 := '_cTag'+Strzero(V,2)
		Private &(_cRet5) := Strzero(V,2)
		
		_cRet6 := 'oSay14'+Strzero(V,2)
		Private &(_cRet6) := Nil

		_cRet7 := '_lWhen'+Strzero(V,2)
		Private &(_cRet7) := .T.
						
	Next V
	
	Private _dDtRef  := cTod('  /  /  ')
	Private _aMes := {'Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'}
	Private _cAno := Strzero(Year(dDatabase),4)
	Private _cMes := Left(Mesextenso(Month(dDatabase)),3)
	nOpc  := 0
	Private aRadio  	:= {}
	Private nRadio  	:= 1
	Private oRadio  	:= Nil
	 	
	Define MsDialog oDlgSec Title 'Parâmetros' From 0,0 To 150, 250 Pixel
	
	@ 10,10 SAY 'Selecione abaixo o Mês e o Ano de Referência:' of oDlgSec Pixel
	
	@ 25,010 SAY "Mês: " 	Size 50,010 OF oDlgSec PIXEL
	@ 25,060 MsCOMBOBOX _oMes 	VAR _cMes ITEMS _aMes Size 30,04  PIXEL OF oDlgSec
	
	@ 40,010 SAY "Ano: " 	Size 50,010 OF oDlgSec PIXEL
	@ 40,060 MsGet _cAno   	Size 30,04  PIXEL OF oDlgSec

	DEFINE SBUTTON FROM 60,010 TYPE 2 ACTION (nOpc := 2,oDlgSec:End()) ENABLE Of oDlgSec
	DEFINE SBUTTON FROM 60,040 TYPE 1 ACTION (nOpc := 1,oDlgSec:End()) ENABLE Of oDlgSec
	
	ACTIVATE MSDIALOG oDlgSec CENTERED
	
	If nOpc = 1
		
		SZA->(dbSetOrder(1))
		SZA->(dbGoBottom())
		
		_nqtdTg := Val(SZA->ZA_TAG)
		
		_n01  := 01
		_n20  := 20
		_lOk  := .T.
		For N := 1 to _nqtdTg
		
			If N - _n20 = 0
				AADD(aRadio,StrZero(&('_n01'),2)+' a '+StrZero(&('_n20'),2))
				
				_n20 += 20
				_n01 := N +1
				_lOk := .T.
			Else
				_lOk  := .F.
			Endif
		Next N
			
		If !_lOK
			AADD(aRadio,StrZero(&('_n01'),2)+' a '+StrZero(&('_nqtdTg'),2))
		Endif

		Private _nPosMes := aScan(_aMes,{|x| x == _cMes})
		
		_dInidia := ctod('01/'+strzero(_nPosMes,2)+'/'+_cAno)
		_dFimdia :=lastday(_dInidia)

		_atFolder:= {}
		
		For M := _dInidia To _dFimdia
			AAdd(_atFolder,Alltrim(Strzero(Day(M),2)))
		Next M
		
		Define MsDialog oDlgPrinc Title 'Apontamento de Parada' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

		DEFINE FONT oFont0 NAME "Arial" SIZE 0,14 OF oDlgPrinc
		DEFINE FONT oFont3 NAME "Arial" SIZE 0,18 OF oDlgPrinc

		_nCor1 := 12577262 //lemonchiffon 2
		_nCor2 := 25600   //DarkGreen
		
		oScroll1 := TScrollArea():New(oDlgPrinc,0,0,285,660,.T.,.T.,.T.)
		oScroll1:Align := CONTROL_ALIGN_TOP
		
		@ 000,000 MSPANEL oPanel1 OF oScroll1 SIZE 660,285
		oScroll1:SetFrame( oPanel1 )
		
		Private oTTabs := TTabs():New(15,1,_aTFolder,{||PXH32B('T')},oPanel1,,CLR_HRED,,.T.,,642,260,)

        // Insere um painel na TTab  
		Private oPanel01 := TPanel():New( 0,0,'',oTTabs,,,,,,645,250,,.T. )
						
		GeraFolder(oTTabs:nOption,oPanel01)
		
		bOK 		:= "{ || oDlgPrinc:End() }"
		bCancel 	:= "{ || oDlgPrinc:End() }"

		@ 02 ,02 BUTTON "Fechar" SIZE 054,012 ACTION (oDlgPrinc:End()) OF oPanel1 PIXEL

		
		ACTIVATE MSDIALOG oDlgPrinc CENTERED
	Endif

Return


Static Function GeraFolder(_nDia,oPanel01)
	
	oScroll2 		:= TScrollArea():New(oPanel01,0,0,36,641,.T.,.T.,.T.)
	oScroll2:Align 	:= CONTROL_ALIGN_ALLCLIENT

	@ 000,000 MSPANEL oPanel2 OF oScroll2 SIZE 641,36

	oScroll2:SetFrame( oPanel2 )
	
	_dDtRef := cTod(strzero(_nDia)+'/'+strzero(_nPosMes,2)+'/'+_cAno)
						
	@ 01, 58  TO 035,118 LABEL '' OF oPanel2 PIXEL
	oSay01:= TSay():New(003,061 ,{||' Data'}	,oPanel2,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay01:lTransparent := .F.
	@ 13, 61  MsGet _oDtRef VAR _dDtRef	When .f. Size 55,09 Pixel Of oPanel2 FONT oFont0
 
	@ 01,119  TO 035,289 LABEL '' OF oPanel2 PIXEL
	oSay02:= TSay():New(003,120 ,{||' Motivo'}	,oPanel2,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay02:lTransparent := .F.
	@ 13,120  MsGet 'Mecânica'		When .F. Size 55,09 Pixel Of oPanel2 FONT oFont0
	@ 23,120  MsGet 'Elétrica/art.'	When .F. Size 55,09 Pixel Of oPanel2 FONT oFont0
	oSay03:= TSay():New(003,176 ,{||' Tempo'}		,oPanel2,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay03:lTransparent := .F.
	@ 13,176  MsGet _oTemMec VAR _cTemMec When .F. Picture("@R 99:99") Size 55,09 Pixel Of oPanel2 FONT oFont0
	@ 23,176  MsGet _oTemEle VAR _cTemEle When .F. Picture("@R 99:99") Size 55,09 Pixel Of oPanel2 FONT oFont0
	oSay04:= TSay():New(003,232 ,{||' Paradas'}	,oPanel2,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay04:lTransparent := .F.
	@ 13,232  MsGet _oParMec VAR _nParMec When .F. Picture("@e 9,999") Size 55,09 Pixel Of oPanel2 FONT oFont0
	@ 23,232  MsGet _oParEle VAR _nParEle When .F. Picture("@e 9,999") Size 55,09 Pixel Of oPanel2 FONT oFont0

	@ 01, 290 TO 035,460 LABEL '' OF oPanel2 PIXEL
	oSay05:= TSay():New(003,291 ,{||' Motivo'}	,oPanel2,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay05:lTransparent := .F.
	@ 13,291  MsGet 'Hidráulica'		When .F. Size 55,09 Pixel Of oPanel2 FONT oFont0
	@ 23,291  MsGet 'Falta de mat.'		When .F. Size 55,09 Pixel Of oPanel2 FONT oFont0
	oSay06:= TSay():New(003,347 ,{||' Tempo'}		,oPanel2,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay06:lTransparent := .F.
	@ 13,347  MsGet _oTemHid VAR _cTemHid When .F. Picture("@R 99:99") Size 55,09 Pixel Of oPanel2 FONT oFont0
	@ 23,347  MsGet _oTemFal VAR _cTemFal When .F. Picture("@R 99:99") Size 55,09 Pixel Of oPanel2 FONT oFont0
	oSay07:= TSay():New(003,403 ,{||' Paradas'}	,oPanel2,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay07:lTransparent := .F.
	@ 13,403  MsGet _oParHid VAR _nParHid When .F. Picture("@e 9,999") Size 55,09 Pixel Of oPanel2 FONT oFont0
	@ 23,403  MsGet _oParFal VAR _nParFal When .F. Picture("@e 9,999") Size 55,09 Pixel Of oPanel2 FONT oFont0

	@ 01, 461  TO 035,631 LABEL '' OF oPanel2 PIXEL
	oSay08:= TSay():New(003,462 ,{||' Motivo'}	,oPanel2,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay08:lTransparent := .F.
	@ 13,462  MsGet 'Transporte'		When .F. Size 55,09 Pixel Of oPanel2 FONT oFont0
	@ 23,462  MsGet 'Troca de Martelos'	When .F. Size 55,09 Pixel Of oPanel2 FONT oFont0
	oSay09:= TSay():New(003,518 ,{||' Tempo'}		,oPanel2,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay09:lTransparent := .F.
	@ 13,518  MsGet _oTemTra VAR _cTemTra When .F. Picture("@R 99:99") Size 55,09 Pixel Of oPanel2 FONT oFont0
	@ 23,518  MsGet _oTemTro VAR _cTemTro When .F. Picture("@R 99:99") Size 55,09 Pixel Of oPanel2 FONT oFont0
	oSay10:= TSay():New(003,574 ,{||' Paradas'}	,oPanel2,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay10:lTransparent := .F.
	@ 13,574  MsGet _oParTra VAR _nParTra When .F. Picture("@e 9,999") Size 55,09 Pixel Of oPanel2 FONT oFont0
	@ 23,574  MsGet _oParTro VAR _nParTro When .F. Picture("@e 9,999") Size 55,09 Pixel Of oPanel2 FONT oFont0
 
	oScroll3 	:= TScrollArea():New(oPanel01,37,0,212,641,.T.,.T.,.T.)

	@ 00,00 MSPANEL oPanel3 OF oScroll3 SIZE 641,707 //Largura, Altura

	oScroll3:SetFrame( oPanel3 )

	_nLi := 01
	For F:=1 to 20
			
		GetShow(F,_nLi,oPanel3)
	
		_nLi += 35
		
	Next F

	@ 01,001  TO 035,057 LABEL '' OF oPanel2 PIXEL
	                             
	oRadio := TRadMenu():New (02,04,aRadio,{|u|Iif (PCount()==0,nRadio,nRadio:=u)},oPanel2,,{||PXH32B('R')},,,,,,36,10,,,,.T.)
	
	oRadio:SetOption( 1 )

Return



Static Function GetShow(F,_nLi,oPanel3)

	Local _cTg := Alltrim(Strzero(F,2))
	
	@ _nLi, 01  TO _nLi+34,631 LABEL '' OF oPanel3 PIXEL
	
	oSay11:= TSay():New(_nLi+12,04 ,{||' Tempo'}				,oPanel3,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,27,09,,,,,.T.)
	oSay11:lTransparent := .F.
	oSay12:= TSay():New(_nLi+22,04 ,{||' Motivo'}				,oPanel3,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,27,09,,,,,.T.)
	oSay12:lTransparent := .F.

	oSay13:= TSay():New(_nLi+2,32 ,{||' TAG'}					,oPanel3,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,28,09,,,,,.T.)
	oSay13:lTransparent := .F.
	&('oSay14'+_cTg):= TSay():New(_nLi+12,32 ,{||'.    '+&('_cTag'+_cTg)}			,oPanel3,,oFont3,,,	,.T.,CLR_BLACK,_nCor1,28,19,,,,,.T.)
	&('oSay14'+_cTg):lTransparent := .F.

	oSay15:= TSay():New(_nLi+2,61 ,{||' 1ª Parada'}				,oPanel3,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay15:lTransparent := .F.
	@ _nLi+12,61  MsGet &('_oVal'+_cTg+'01') VAR &('_cVal'+_cTg+'01')			When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'01','V') 	Picture("@E 99:99") 	Size 55,08 Pixel Of oPanel3 FONT oFont0
	@ _nLi+22,61  MsGet &('_oMot'+_cTg+'01') VAR &('_cMot'+_cTg+'01')	F3 'ZB'	When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'01','M') 							Size 55,08 Pixel Of oPanel3 FONT oFont0
	oSay16:= TSay():New(_nLi+2,118,{||' 2ª Parada'}				,oPanel3,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay16:lTransparent := .F.
	@ _nLi+12,118 MsGet &('_oVal'+_cTg+'02') VAR &('_cVal'+_cTg+'02')			When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'02','V') 	Picture("@E 99:99") 	Size 55,08 Pixel Of oPanel3 FONT oFont0
	@ _nLi+22,118 MsGet &('_oMot'+_cTg+'02') VAR &('_cMot'+_cTg+'02')	F3 'ZB' When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'02','M') 							Size 55,08 Pixel Of oPanel3 FONT oFont0
	oSay17:= TSay():New(_nLi+2,175,{||' 3ª Parada'}				,oPanel3,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay17:lTransparent := .F.
	@ _nLi+12,175 MsGet &('_oVal'+_cTg+'03') VAR &('_cVal'+_cTg+'03')			When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'03','V')	Picture("@E 99:99") 	Size 55,08 Pixel Of oPanel3 FONT oFont0
	@ _nLi+22,175 MsGet &('_oMot'+_cTg+'03') VAR &('_cMot'+_cTg+'03')	F3 'ZB' When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'03','M')	Size 55,08 Pixel Of oPanel3 FONT oFont0
	oSay18:= TSay():New(_nLi+2,232,{||' 4ª Parada'}				,oPanel3,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay18:lTransparent := .F.
	@ _nLi+12,232 MsGet &('_oVal'+_cTg+'04') VAR &('_cVal'+_cTg+'04')			When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'04','V') 	Picture("@E 99:99") Size 55,08 Pixel Of oPanel3 FONT oFont0
	@ _nLi+22,232 MsGet &('_oMot'+_cTg+'04') VAR &('_cMot'+_cTg+'04')	F3 'ZB' When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'04','M')	Size 55,08 Pixel Of oPanel3 FONT oFont0
	oSay19:= TSay():New(_nLi+2,289,{||' 5ª Parada'}				,oPanel3,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay19:lTransparent := .F.
	@ _nLi+12,289 MsGet &('_oVal'+_cTg+'05') VAR &('_cVal'+_cTg+'05')			When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'05','V')	Picture("@E 99:99") Size 55,08 Pixel Of oPanel3 FONT oFont0
	@ _nLi+22,289 MsGet &('_oMot'+_cTg+'05') VAR &('_cMot'+_cTg+'05')	F3 'ZB' When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'05','M')	Size 55,08 Pixel Of oPanel3 FONT oFont0
	oSay20:= TSay():New(_nLi+2,346,{||' 6ª Parada'}				,oPanel3,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay20:lTransparent := .F.
	@ _nLi+12,346 MsGet &('_oVal'+_cTg+'06') VAR &('_cVal'+_cTg+'06')			When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'06','V')	Picture("@E 99:99") Size 55,08 Pixel Of oPanel3 FONT oFont0
	@ _nLi+22,346 MsGet &('_oMot'+_cTg+'06') VAR &('_cMot'+_cTg+'06')	F3 'ZB' When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'06','M')	Size 55,08 Pixel Of oPanel3 FONT oFont0
	oSay21:= TSay():New(_nLi+2,403,{||' 7ª Parada'}				,oPanel3,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay21:lTransparent := .F.
	@ _nLi+12,403 MsGet &('_oVal'+_cTg+'07') VAR &('_cVal'+_cTg+'07')			When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'07','V') 	Picture("@E 99:99") Size 55,08 Pixel Of oPanel3 FONT oFont0
	@ _nLi+22,403 MsGet &('_oMot'+_cTg+'07') VAR &('_cMot'+_cTg+'07')	F3 'ZB' When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'07','M')	Size 55,08 Pixel Of oPanel3 FONT oFont0
	oSay22:= TSay():New(_nLi+2,460,{||' 8ª Parada'}				,oPanel3,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay22:lTransparent := .F.
	@ _nLi+12,460 MsGet &('_oVal'+_cTg+'08') VAR &('_cVal'+_cTg+'08')			When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'08','V')	Picture("@E 99:99") Size 55,08 Pixel Of oPanel3 FONT oFont0
	@ _nLi+22,460 MsGet &('_oMot'+_cTg+'08') VAR &('_cMot'+_cTg+'08')	F3 'ZB'	When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'08','M')	Size 55,08 Pixel Of oPanel3 FONT oFont0
	oSay23:= TSay():New(_nLi+2,517,{||' 9ª Parada'}				,oPanel3,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay23:lTransparent := .F.
	@ _nLi+12,517 MsGet &('_oVal'+_cTg+'09') VAR &('_cVal'+_cTg+'09')			When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'09','V')	Picture("@E 99:99") Size 55,08 Pixel Of oPanel3 FONT oFont0
	@ _nLi+22,517 MsGet &('_oMot'+_cTg+'09') VAR &('_cMot'+_cTg+'09')	F3 'ZB' When &('_lWhen'+_cTg) VALID RESUM0(_cTg,'09','M')	Size 55,08 Pixel Of oPanel3 FONT oFont0
	oSay24:= TSay():New(_nLi+2,574,{||' Totais'}					,oPanel3,,oFont3,,,	,.T.,CLR_WHITE,_nCor2,55,09,,,,,.T.)
	oSay24:lTransparent := .F.
	@ _nLi+12,574 MsGet &('_oVal'+_cTg+'10') VAR &('_cVal'+_cTg+'10')	When .F.  Picture("@E 99:99") Size 55,08 Pixel Of oPanel3 FONT oFont0

Return



Static Function RESUM0(_cTg,_cPar,_cTp)

	_cMotivo := &('_cMot'+_cTg+_cPar)
	_lSegue  := .T.
	
	_cVal := &('_cVal'+_cTg+_cPar)

	If Empty(Substr(_cVal,4,2))
		_cVal := Substr(_cVal,1,2)+':00'
	ElseIf Empty(Substr(_cVal,5,1))
		_cVal := Substr(_cVal,1,4)+'0'
	ElseIf Empty(Substr(_cVal,4,1))
		_cVal := Substr(_cVal,1,3)+'0'+Substr(_cVal,5,1)
	Endif

	If Empty(Substr(_cVal,1,2))
		_cVal := '00:'+Substr(_cVal,4,2)
	ElseIf Empty(Substr(_cVal,1,1))
		_cVal := '0'+Substr(_cVal,2,4)
	ElseIf Empty(Substr(_cVal,2,1))
		_cVal := '0'+Substr(_cVal,1,1)+Substr(_cVal,3,3)
	Endif
	
	&('_cVal'+_cTg+_cPar) := _cVal

	_cVal 	 := &('_cVal'+_cTg+_cPar)
	_nVal    := Val(STRTRAN(_cVal,':',','))

	If !Empty(Alltrim(_cMotivo))
		
		SX5->(dbsetOrder(1))
		If !SX5->(msseek(xFilial('SX5')+'ZB'+_cMotivo))
			MsgAlert('Motivo de Parada não encontrado!')
			_lSegue := .F.
		Endif

		If _nVal = 0
			&('_cMot'+_cTg+_cPar) := Space(1)
			&('_oMot'+_cTg+_cPar+':Refresh()')
		Endif
	Else
	
		If _nVal > 0 .and. _cTp = 'M'
			MsgAlert('Motivo de Parada não informado!')
			_lSegue := .F.
		Endif
	Endif
	
	If _lSegue
		
		If Val(Substr(_cVal,1,2)) > 23
			MsgInfo('Quantidade de horas maior que 23:59!')
			_cVal := '00:00'
		Endif
	
		If _nVal = 0
			&('_cMot'+_cTg+_cPar) := Space(1)
		Endif
		_cMotivo := &('_cMot'+_cTg+_cPar)

		If (!Empty(_cMotivo) .And. _nVal > 0) .Or. (Empty(_cMotivo) .And. _nVal = 0)

			_cRet1 := ('_cVal'+_cTg+_cPar)
			_cRet2 := ('_cMot'+_cTg+_cPar)

			SZB->(dbSetOrder(1))
			If SZB->(msSeek(xFilial('SZB')+&('_cTag'+_cTg)+DTOS(_dDtRef)))

				SZB->(RecLock('SZB',.F.))
					
				_cTempo   := ('SZB->ZB_T'+_cPar)
				_cParad   := ('SZB->ZB_M'+_cPar)

				&_cTempo  := &(_cRet1)
				&_cParad  := &(_cRet2)
					
				SZB->(MsUnlock())
	
			Else

				If _nVal > 0
					SZB->(RecLock('SZB',.T.))
					SZB->ZB_FILIAL		:= xFilial('SZB')
					SZB->ZB_TAG 		:= &('_cTag'+_cTg)
					SZB->ZB_DIA 		:= _dDtRef
					_cTempo   := ('SZB->ZB_T'+_cPar)
					_cParad   := ('SZB->ZB_M'+_cPar)

					&_cTempo  := &(_cRet1)
					&_cParad  := &(_cRet2)
					SZB->(MsUnlock())

				Endif
			Endif
		Endif

		_nTot := 0

		For Par := 1 To 9
			cPar 	 := Strzero(Par,2)
			_cVal 	 := &('_cVal'+_cTg+cPar)
			_nVal    := Val(STRTRAN(_cVal,':',','))
			_cMotivo := &('_cMot'+_cTg+cPar)
			If !Empty(_cMotivo) .And. _nVal > 0
				_nTot += _nVal
			Endif
	
			&('_oVal'+_cTg+cPar+':Refresh()')
			&('_oMot'+_cTg+cPar+':Refresh()')
			&('_cVal'+_cTg+'10') := STRTRAN(STRZERO(_nTot,5,2),'.',':')
			&('_oVal'+_cTg+'10:Refresh()')

		Next Par

		PXH32D()// Total

	Endif

	
Return (_lSegue)

			

//Carrega as variáveis		
Static Function PXH32B(_cOpt)
	
	_nOpt := oTTabs:nOption

	_dDtRef := cTod(strzero(_nOpt)+'/'+strzero(_nPosMes,2)+'/'+_cAno)
	_oDtRef:Refresh()
	
		//Inicia as variáveis
	_cTemMec := _cTemEle := _cTemHid := _cTemFal := _cTemTra := _cTemTro := '00:00'
	_nParMec := _nParEle := _nParHid := _nParFal := _nParTra := _nParTro := 0
		
	_nIni := Val(Left(aRadio[nRadio],2))
	_nFim := Val(Right(aRadio[nRadio],2))
	_nTag := 0
		
	For K := _nIni to _nFim
		_nTag ++
		_cTag := Strzero(_nTag,2)
		_cTg   := Strzero(K,2)
			
		SZA->(dbSetOrder(1))
		If SZA->(msSeek(xFilial('SZA')+_cTg))
			If SZA->ZA_STATUS = 'A'
				&('_lWhen'+_cTag) := .T.
			Else
				&('_lWhen'+_cTag) := .F.
			Endif
			
			_cRet0 := ('_cTag'+_cTag)
			&(_cRet0) := _cTg
			&('oSay14'+_cTag+':Refresh()')
			_nTot := 0
			
			For L := 1 to 9

				_cPr  := Strzero(L,2)
				
				_cRet1 := ('_cVal'+_cTag+_cPr)
				_cRet2 := ('_cMot'+_cTag+_cPr)

				SZB->(dbsetOrder(1))
				If SZB->(msSeek(xFilial('SZB')+_cTg+DTOS(_dDtRef)))
					&(_cRet1) := If(Empty(alltrim(&('SZB->ZB_T'+_cPr))),'00:00',&('SZB->ZB_T'+_cPr))
					&(_cRet2) := &('SZB->ZB_M'+_cPr)
				Else
					&(_cRet1) := '00:00'
					&(_cRet2) := Space(1)
				Endif

				_cMotivo := &('_cMot'+_cTag+_cPr)
				_cVal 	 := &('_cVal'+_cTag+_cPr)
				_nVal    := Val(STRTRAN(_cVal,':',','))
	
				If !Empty(_cMotivo) .And. _nVal > 0
					_nTot += _nVal
				Endif

				&('_oVal'+_cTag+_cPr+':Refresh()')
				&('_oMot'+_cTag+_cPr+':Refresh()')
				
			Next L
			
			&('_cVal'+_cTag+'10') := STRTRAN(STRZERO(_nTot,5,2),'.',':')
			&('_oVal'+_cTag+'10:Refresh()')
			
		Else
			&('_lWhen'+_cTag) := .F.
		Endif

	Next K

	_nTgDif := 20 - (_nFim - (Int(_nFim / 20) * 20))
	If _nTgDif < 20
			
		_nTgIni := (_nFim - (Int(_nFim / 20) * 20))+1
		For K := _nTgIni to 20
			_cTg := Strzero(K,2)
				
			&('_lWhen'+_cTg) := .F.
				
			_cRet0 := ('_cTag'+_cTg)
			&(_cRet0) := '--'
			&('oSay14'+_cTg+':Refresh()')
						
			For L := 1 to 9

				_cPr  := Strzero(L,2)
					
				_cRet1 := ('_cVal'+_cTg+_cPr)
				_cRet2 := ('_cMot'+_cTg+_cPr)
				
				&(_cRet1) := '00:00'
				&(_cRet2) := Space(1)
				
				&('_oVal'+_cTg+_cPr+':Refresh()')
				If L < 9
					&('_oMot'+_cTg+_cPr+':Refresh()')
				Endif
					
			Next L

		Next K
	Endif
		
	PXH32D()
	
	_oVal0101:SetFocus()
							
Return



Static Function	PXH32D() //Total

	_cTemMec := _cTemEle := _cTemHid := _cTemFal := _cTemTra := _cTemTro := '00:00'
	_nParMec := _nParEle := _nParHid := _nParFal := _nParTra := _nParTro := 0

	SZB->(dbSetOrder(2))
	If SZB->(MsSeek(xFilial('SZB')+Dtos(_dDtRef)))
		_ckey := SZB->ZB_DIA
		_nTg := 0
		
		While !SZB->(EOF()) .And. _ckey == SZB->ZB_DIA
			
			_nTg  ++
			cTag  := SZB->ZB_TAG
//			_nTot := 0
			For Par := 1 to 9
				cPar := Strzero(Par,2)
			
				_cMotivo := &('SZB->ZB_M'+cPar)
				_cVal 	 := &('SZB->ZB_T'+cPar)
				_nVal    := Val(STRTRAN(_cVal,':',','))
	
				If !Empty(_cMotivo) .And. _nVal > 0
	//				_nTot += _nVal

					If _cMotivo = '1' //Mecânica
						_nVlTem  := Val(STRTRAN(_cTemMec,':',',')) + _nVal
						_cTemMec := STRTRAN(STRZERO(_nVlTem,5,2),'.',':')
						_nParMec ++
					ElseIf _cMotivo = '2' //Elétrica/autom
						_nVlTem  := Val(STRTRAN(_cTemEle,':',',')) + _nVal
						_cTemEle := STRTRAN(STRZERO(_nVlTem,5,2),'.',':')
						_nParEle ++
					ElseIf _cMotivo = '3' //Hidráulica
						_nVlTem  := Val(STRTRAN(_cTemHid,':',',')) + _nVal
						_cTemHid := STRTRAN(STRZERO(_nVlTem,5,2),'.',':')
						_nParHid ++
					ElseIf _cMotivo = '4' //Falta Material
						_nVlTem  := Val(STRTRAN(_cTemFal,':',',')) + _nVal
						_cTemFal := STRTRAN(STRZERO(_nVlTem,5,2),'.',':')
						_nParFal ++
					ElseIf _cMotivo = '5' //Transporte
						_nVlTem  := Val(STRTRAN(_cTemTra,':',',')) + _nVal
						_cTemTra := STRTRAN(STRZERO(_nVlTem,5,2),'.',':')
						_nParTra ++
					ElseIf _cMotivo = '6' //Troca Martelos
						_nVlTem  := Val(STRTRAN(_cTemTro,':',',')) + _nVal
						_cTemTro := STRTRAN(STRZERO(_nVlTem,5,2),'.',':')
						_nParTro ++
					Endif
				Endif
				
//				If _nTg > 20
//					_nTg := 1
//				Endif 
//
//				&('_oVal'+strzero(_nTg,2)+cPar+':Refresh()')
//				&('_oMot'+strzero(_nTg,2)+cPar+':Refresh()')
//				&('_cVal'+strzero(_nTg,2)+'10') := STRTRAN(STRZERO(_nTot,5,2),'.',':')
//				&('_oVal'+strzero(_nTg,2)+'10:Refresh()')
			
			Next Par
			
			SZB->(dbSkip())
		EndDo
	Endif
	
	_oTemMec:Refresh()
	_oTemEle:Refresh()
	_oTemHid:Refresh()
	_oTemFal:Refresh()
	_oTemTra:Refresh()
	_oTemTro:Refresh()
	_oParMec:Refresh()
	_oParEle:Refresh()
	_oParHid:Refresh()
	_oParFal:Refresh()
	_oParTra:Refresh()
	_oParTro:Refresh()

Return
