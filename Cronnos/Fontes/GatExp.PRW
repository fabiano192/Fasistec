#INCLUDE "Totvs.ch"

/*
Autor		:	Fabiano da Silva
Data		:	02/08/13
Descrição	:	Gatilhos do módulo Easy Export Control (SIGAEEC)

GEEC001()	:	Atualiza o preço de Venda conforme cadastro de produto X Cliente
GEEC002()	: 	Verifica se o Pedido pode ser alterado
GEEC002()	:	Atualiza o preço de Venda conforme cadastro de produto X Cliente (SZC)
*/

User Function GEXP001()
	
	Local _aListBox   := {}
	
	_aAliOri  := GetArea()
	_aAliEE8  := EE8->(GetArea())
	_aAliEE7  := EE7->(GetArea())
	_aAliSZ2  := SZ2->(GetArea())
	_aAliSF4  := SF4->(GetArea())
	
	_nPreco   := M->EE8_PRECO
	
	
	SZ2->(dbSetOrder(6))
	If SZ2->(dbSeek(xFilial("SZ2")+M->EE7_IMPORT + M->EE7_IMLOJA + M->EE8_CODCLI+"1" ))
		
		_nCont := 0
		
		_cChave := M->EE7_IMPORT + M->EE7_IMLOJA+M->EE8_CODCLI+"1"
		
		While !SZ2->(EOF()) .And. _cChave = SZ2->Z2_CLIENTE+SZ2->Z2_LOJA+SZ2->Z2_CODCLI+SZ2->Z2_ATIVO
	/*
	SZ2->(dbSetOrder(1))
	If SZ2->(dbSeek(xFilial("SZ2")+M->EE7_IMPORT + M->EE7_IMLOJA + M->EE8_COD_I + M->EE8_CODCLI+"1" ))
		
		_nCont := 0
		
		_cChave := M->EE7_IMPORT + M->EE7_IMLOJA + M->EE8_COD_I + M->EE8_CODCLI+"1"
		
		While !SZ2->(EOF()) .And. _cChave = SZ2->Z2_CLIENTE+SZ2->Z2_LOJA+SZ2->Z2_PRODUTO+SZ2->Z2_CODCLI+SZ2->Z2_ATIVO
		*/	
			_nCont ++
			
			SB1->(dbSetOrder(1))
			SB1->(msSeek(xFilial("SB1")+SZ2->Z2_PRODUTO))
			
			dDataRef := SZ2->Z2_DTREF01
			_nValor   := SZ2->Z2_PRECO01
			For i := 2 to 12
				If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
					dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
					_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
				Endif
			Next i
			
			SF4->(dbSetOrder(1))
			SF4->(msSeek(xFilial("SF4")+SZ2->Z2_TES))
			
			AADD(_aListBox,{If(_nCont = 1, .T.,.F.)		,; //01
			SZ2->Z2_PRODUTO								,; //02
			SZ2->Z2_REVISAO								,; //03
			SZ2->Z2_TES									,; //04
			SB1->B1_UM									,; //05
			_nValor										,; //06
			SZ2->Z2_DESCCLI								,; //07
			SZ2->Z2_PEDCLI								,; //08
			Left(SB1->B1_ORIGEM,1)+SB1->B1_CLASFIS		,; //09
			SF4->F4_CF									,; //10
			SZ2->Z2_CODCLI								,; //11
			SZ2->Z2_REVISAO								,; //12
			SZ2->Z2_RELEASE								,; //13
			SB1->B1_PESO								,; //14
			SB1->B1_POSIPI								}) //15
			
			SZ2->(dbSkip())
		EndDo
		
		If _nCont > 1
			_oOk   := LoadBitmap(GetResources(), "LBOK")
			_oNo   := LoadBitmap(GetResources(), "LBNO")
			
			_oDlg := _oListBox := Nil
			
			DEFINE DIALOG _oDlg TITLE "Produto X Cliente" FROM 0,0 TO 200,800	OF _oDlg PIXEL Style DS_MODALFRAME
			
			@ 005,005 TO 075,395 LABEL "" OF _oDlg PIXEL
			
			_oDlg:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"
			
			//			_oSay:= TSay():New(10,10,{||'Escolha abaixo qual o tipo de CTE que deseja Integrar:'},_oDlg1,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
			
			_oListbox := TWBrowse():New( 10,10,380,060,,{'','Produto','UM','Revisão','Pedido','Valor','TES','Descrição'},,_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
			
			_oListbox:SetArray(_aListBox)
			_oListbox:bLine := {||{If(_aListBox[_oListbox:nAt,1],_oOk,_oNo ),_aListBox[_oListbox:nAt,2],_aListBox[_oListbox:nAt,5],;
				_aListBox[_oListbox:nAt,3],_aListBox[_oListbox:nAt,8],_aListBox[_oListbox:nAt,6],_aListBox[_oListbox:nAt,4],;
				_aListBox[_oListbox:nAt,7] } }
			
			_oListbox:bLDblClick := {|| CheckBox(_aListBox,_oListbox)}
			
			_oTButOk	:= TButton():New( 080, 010, "OK"	,_oDlg,{||_oDlg:End()}	, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
			
			ACTIVATE MSDIALOG _oDlg CENTERED
			
		Endif
		
	Endif
	
	If !Empty(_aListBox)
		For F := 1 To Len(_aListBox)
			If _aListBox[F][1]
				
				_nPreco 		:= _aListBox[F][6]
				
				M->EE8_TES    	:= _aListBox[F][4]
				M->EE8_CF     	:= _aListBox[F][10]
				M->EE8_PART_N 	:= _aListBox[F][11]
				M->EE8_REFCLI 	:= _aListBox[F][8]
				M->EE8_VM_DES   := _aListBox[F][7]
				M->EE8_REVENG   := _aListBox[F][12]
				M->EE8_REVPED   := _aListBox[F][13]
				M->EE8_COD_I    := _aListBox[F][2]
				M->EE8_UNIDAD   := _aListBox[F][5]
				M->EE8_PSLQUN   := _aListBox[F][14]
				M->EE8_POSIPI   := _aListBox[F][15]
				M->EE8_QE   	:= 0
				M->EE8_QTDEM1  	:= 0
			Endif
		Next F
	Endif
	
	RestArea(_aAliSF4)
	RestArea(_aAliSZ2)
	RestArea(_aAliEE7)
	RestArea(_aAliEE8)
	RestArea(_aAliOri)
	
Return(_nPreco)


User Function GEXP002()
	
	_aAliOri := GetArea()
	_aAliSC6 := SC6->(GETAREA())
	_nSaldo  := 0
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+M->EE7_PEDFAT+M->EE8_FATIT+M->EE8_COD_I)
		_nSaldo := SC6->C6_QTDVEN - SC6->C6_QTDENT
	Endif
	
	If _nSaldo < EE8->EE8_SLDINI
		Alert("Pedido Nao Pode Ser Alterado Pois Ja Foi Faturado!!!!!!")
		_nRet := SC6->C6_QTDVEN
	Else
		_nRet := M->EE8_SLDINI
	Endif
	
	RestArea(_aAliSC6)
	RestArea(_aAliORI)
	
Return(_nRet)


User Function GEXP003()
	
	_aAliOri  := GetArea()
	_aAliSZ2  := SZ2->(GetArea())
	_aAliSZC  := SZC->(GetArea())
	
	_nPreco   := M->EE8_PRECO
	
	SZ2->(dbSetOrder(9))
	If SZ2->(msSeek(xFilial("SZ2")+M->EE7_IMPORT + M->EE7_IMLOJA + M->EE8_COD_I + M->EE8_CODCLI + M->EE8_REFCLI))
		
		If SZ2->Z2_ATIVO = "1"
			_lAchou := .F.
			dbSelectArea("SZC")
			dbSetOrder(1)
			If dbSeek(xFilial("SZC")+SZ2->Z2_CLIENTE + SZ2->Z2_LOJA + SZ2->Z2_PRODUTO + SZ2->Z2_CODCLI)
				_cChavSZC := SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI
				
				While !eof() .And. _cChavSZC == SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI .And. !_lAchou
					If M->EE8_SLDINI >= SZC->ZC_QTINIC  .And. M->EE8_SLDINI <= SZC->ZC_QTFINAL
						_nPreco := SZC->ZC_PRECO
						_lAchou := .T.
					Endif
					
					dbSelectArea("SZC")
					dbSkip()
				EndDo
			Endif
			/*
		Else
			dDataRef := SZ2->Z2_DTREF01
			_nValor   := SZ2->Z2_PRECO01
			For i := 2 to 12
				If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
					dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
					_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
				Endif
			Next i
			
			_nPreco  := _nValor
			*/
		Endif
	Endif
	
	RestArea(_aAliSZC)
	RestArea(_aAliSZ2)
	RestArea(_aAliOri)
	
Return(_nPreco)


Static Function CheckBox(_aListBox,_oListbox)
	
	_aListBox[_oListbox:nAt][1] := !_aListBox[_oListbox:nAt][1]
	
	For F:=1 To Len(_aListBox)
		                           
		If F <> _oListbox:nAt
			_aListBox[F][1] := .F.
		Endif
		
	Next F
	
	_oListbox:Refresh()
	
Return
