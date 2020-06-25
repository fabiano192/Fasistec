#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VN0010   ³ Autor ³ Alexandro da Silva    ³ Data ³ 08/03/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza Cadastro de Fretes                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VN0010()
	
	Private CCADASTRO,AROTINA
	cCadastro := "Cadastro de Conhecimento de Frete"
	
	aRotina   := { {"Pesquisar"    ,"AxPesqui"  ,0,1,0,.F. },;
		{"Visualizar"   ,"U_VN10_01" ,0,2,0, Nil},;
		{"Incluir"      ,"U_VN10_01" ,0,3,0, Nil},;
		{"Excluir"      ,"U_VN10_01" ,0,4,0, Nil}}
	
	MBrowse(6,1,22,75,"SZM")
	
Return


User Function VN10_01(cAlias,nReg,_nOpcx)
	
	Private VISUAL := (_nOpcX == 2)
	Private INCLUI := (_nOpcX == 3)
	Private EXCLUI := (_nOpcX == 4)
	
	nOPCE  := _nOpcX
	nOPCG  := _nOpcX
	
	//Case wOpcao == "V" ; lVisualizar := .T. ; nOpcE := 2 ; nOpcG := 2 ; cOpcao := "VISUALIZAR"
	//Case wOpcao == "I" ; lIncluir    := .T. ; nOpcE := 3 ; nOpcG := 3 ; cOpcao := "INCLUIR"
	
	If EXCLUI
		If SZM->ZM_DTDIGIT <= GetMV("MV_DATAFIS")
			MsgBox("Atencao, o periodo ja foi fechado pelo Fiscal. Contactar Contabilidade","Atencao","ALERT")
			Return
		EndIf
	Endif
	
	RegToMemory("SZM",(_nOpcX == 3)) // SE INCLUIR
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZN")
	nUsado  := 0
	aHeader := {}
	
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SZN"
		
		If  Alltrim(SX3->X3_CAMPO) $ "ZN_NUM/ZN_FORNECE/ZN_LOJA/ZN_SERCTR/ZN_EMISSAO/ZN_DTDIGIT/ZN_ITEM"
			SX3->(dbSkip())
			Loop
		Endif
		
		If  X3USO(SX3->X3_USADO) .And. SX3->X3_NIVEL <= cNivel
			nUsado := nUsado + 1
			aadd(aHeader,{ trim(SX3->X3_TITULO),Alltrim(SX3->X3_CAMPO)   , ;
				SX3->X3_PICTURE     ,SX3->X3_TAMANHO , ;
				SX3->X3_DECIMAL     ,"AllwaysTrue()" , ;
				SX3->X3_USADO       ,SX3->X3_TIPO    , ;
				SX3->X3_ARQUIVO     ,SX3->X3_CONTEXT } )
		Endif
		
		SX3->(dbSkip())
	EndDo
	
	//Private _nPITEM    := aScan(aHeader,{|x|Alltrim(x[2]) == "ZN_ITEM"   })
	Private _nPSERIE   := aScan(aHeader,{|x|Alltrim(x[2]) == "ZN_SERIE"  })
	Private _nPNOTA    := aScan(aHeader,{|x|Alltrim(x[2]) == "ZN_NOTA"   })
	Private _nPQTDE    := aScan(aHeader,{|x|Alltrim(x[2]) == "ZN_QTE"    })
	Private _nPVALUNIT := aScan(aHeader,{|x|Alltrim(x[2]) == "ZN_VALUNIT"})
	Private _nPBASEICM := aScan(aHeader,{|x|Alltrim(x[2]) == "ZN_BASEICM"})
	Private _nPVALTOT  := aScan(aHeader,{|x|Alltrim(x[2]) == "ZN_VALTOT" })
	Private _nPDESCONT := aScan(aHeader,{|x|Alltrim(x[2]) == "ZN_DESCONT"})
	Private _nPEMISSAO := aScan(aHeader,{|x|Alltrim(x[2]) == "ZN_EMISSAO"})
	Private _nPTES     := aScan(aHeader,{|x|Alltrim(x[2]) == "ZN_TES"    })
	Private _nPEDAGIO  := aScan(aHeader,{|x|Alltrim(x[2]) == "ZN_PEDAGIO"})
	
	If INCLUI
		aCols             := {array(nUsado+1)}
		aCols[1,nUsado+1] := .F.
		For i := 1 to nUsado
			aCols[1,i] := CriaVar(aHeader[i,2])
		Next
	Else
		aCols:={}
		dbSelectArea("SZN")
		dbSetOrder(4)
		dbSeek(xFilial("SZN")+ M->ZM_NUM + M->ZM_SERIE + M->ZM_FORNECE + M->ZM_LOJA)
		While !eof() .and. SZN->ZN_FILIAL  == xFilial("SZN") ;
				.and. SZN->ZN_NUM     == M->ZM_NUM ;
				.and. SZN->ZN_SERCTR  == M->ZM_SERIE;
				.and. SZN->ZN_FORNECE == M->ZM_FORNECE ;
				.and. SZN->ZN_LOJA    == M->ZM_LOJA
			aadd(aCols,array(nUsado+1))
			For i := 1 to nUsado
				aCols[len(aCols),i]    := FieldGet(FieldPos(aHeader[i,2]))
			Next
			aCols[len(aCols),nUsado+1] := .F.
			dbSkip()
		End
	End
	
	cTitulo        := "Cadastro de Conhecimento de Fretes"
	cAliasEnchoice := "SZM"
	cAliasGetD     := "SZN"
	cLinOk         := 'U_VN10_02()'
	cTudOk         := 'U_VN10_03()'
	cFieldOk       := "AllwaysTrue()"
	
	aCpoEnchoice   := {"ZM_NUM","ZM_FORNECE","ZM_LOJA","ZM_SERIE"}
	
	lRet := Modelo3(cTitulo ,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk  ,cTudOk  ,nOpcE, nOpcG, cFieldOk)
	
	If  lRet
		fProcessa()
	Endif
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ fProcessa                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Processa confirmacao da tela                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fProcessa()
	
	_cProduto  := GetMv("VN_PRODFRE")
	
	If INCLUI
		
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xfilial("SA2") + M->ZM_FORNECE + M->ZM_LOJA))
		
		SF1->(dbSetOrder(1))
		If SF1->(dbSeek(xFilial("SF1")+ M->ZM_NUM + M->ZM_SERIE + M->ZM_FORNECE + M->ZM_LOJA + "N"))
			MsgBox("Nota Fiscal Ja Cadastrada Para Esse Fornecedor")
			Return
		EndIf
		
		dbSelectArea("SZN")
		lSZN   := .F.
		_nSoma := 0
		_nCont := 0
		_aItens:= {}
		aCab   := {}
		
		Begin Transaction
			
			For i := 1 to len(aCols)
				
				If  !aCols[i,nUsado+1]
					
					_nCont ++
					_cNfOri    := ACols[I,_nPnota]
					_cSerOri   := ACols[I,_nPSerie]
					
					SZN->(RecLock("SZN",.T.))
					SZN->ZN_FILIAL  := xFilial("SZN")
					SZN->ZN_ITEM    := StrZero(_nCont,4)
					SZN->ZN_NUM     := M->ZM_NUM
					SZN->ZN_SERCTR  := M->ZM_SERIE
					SZN->ZN_FORNECE := M->ZM_FORNECE
					SZN->ZN_LOJA    := M->ZM_LOJA
					SZN->ZN_NOTA    := ACols[I,_NPNOTA]
					SZN->ZN_SERIE   := aCols[I,_NPSERIE]
					SZN->ZN_QTE     := aCols[I,_NPQTDE]
					SZN->ZN_TES     := aCols[I,_NPTES]
					SZN->ZN_VALUNIT := aCols[I,_NPVALUNIT]
					SZN->ZN_DESCONT := aCols[I,_NPDESCONT]
					SZN->ZN_PEDAGIO := aCols[I,_NPEDAGIO]
					SZN->ZN_BASEICM := aCols[I,_nPBASEICM]
					SZN->ZN_VALTOT  := aCols[I,_NPVALTOT]
					SZN->ZN_EMISSAO := M->ZM_EMISSAO
					SZN->ZN_DTDIGIT := M->ZM_DTDIGIT
					
					SF2->(dbSetOrder(1))
					If SF2->(dbSeek(xFilial("SF2")+ _cNfOri + _cSerOri ))
						SF2->(RecLock("SF2",.F.))
						SF2->F2_YNUMCTR := M->ZM_NUM
						SF2->F2_YSERTRA := M->ZM_SERIE
						SF2->F2_YFORTRA := M->ZM_FORNECE
						SF2->F2_YLJTRAN := M->ZM_LOJA
						SF2->F2_YPEDAGI := aCols[I,_NPEDAGIO]
						SF2->(MsUnlock())
						
						SZN->ZN_TRANSP  := SF2->F2_TRANSP
					EndIf
					
					SZN->(MsUnlock())
					
					_nSoma += SZN->ZN_VALTOT
					
					aLinha   := {}
					
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1") + _cPRODUTO ))
					
					SF4->(dbSetOrder(1))
					SF4->(dbSeek(xFilial("SF4") + SZN->ZN_TES ))
					
					AAdd( aLinha, { "D1_COD"    , _cPRODUTO      , Nil } )
					AAdd( aLinha, { "D1_ITEM"   , SZN->ZN_ITEM   , Nil } )
					AAdd( aLinha, { "D1_QUANT"  , 1              , Nil } )
					AAdd( aLinha, { "D1_VUNIT"  , SZN->ZN_VALTOT , Nil } )
					AAdd( aLinha, { "D1_TOTAL"  , SZN->ZN_VALTOT , Nil } )
					AAdd( aLinha, { "D1_LOCAL"  , SB1->B1_LOCPAD , Nil } )
					AAdd( aLinha, { "D1_TES" 	, SZN->ZN_TES	 , Nil } )
					AAdd( aLinha, { "D1_CF"     , SF4->F4_CF	 , Nil } )
					AAdd( aLinha, { "D1_UM"     , SB1->B1_UM 	 , Nil } )
					AAdd( aLinha, { "D1_CC"     , SB1->B1_CC	 , Nil } )
					AAdd( aLinha, { "D1_CONTA"  , SB1->B1_CONTA  , NIL } )
					
					AAdd( _aItens, aLinha)
					
					lSZN := .T.
				Endif
			Next
			
			If  lSZN
				SZM->(RecLock("SZM",.T.))
				SZM->ZM_FILIAL  := xFilial("SZM")
				SZM->ZM_NUM     := M->ZM_NUM
				SZM->ZM_SERIE   := M->ZM_SERIE
				SZM->ZM_FORNECE := M->ZM_FORNECE
				SZM->ZM_LOJA    := M->ZM_LOJA
				SZM->ZM_NOME    := M->ZM_NOME
				SZM->ZM_ESPECIE := M->ZM_ESPECIE
				SZM->ZM_TOTAL   := _nSoma
				SZM->ZM_EMISSAO := M->ZM_EMISSAO
				SZM->ZM_DTDIGIT := M->ZM_DTDIGIT
				SZM->ZM_BICMS   := M->ZM_BICMS
				SZM->ZM_CHVCTR  := M->ZM_CHVCTR
				SZM->(MsUnLock())
				
				If SZM->ZM_ESPECIE == "1"
					_cEspec := "CTE"
				Else
					_cEspec := "CTR"
				Endif
				
				If Empty(SA2->A2_COND)
					_cCond := "001"
				Else
					_cCond := SA2->A2_COND
				Endif
				
				AAdd( aCab, { "F1_TIPO"   , "N"    		    } )	// Tipo da NF           : Obrigatorio
				AAdd( aCab, { "F1_FORMUL" , "N"             } )
				AAdd( aCab, { "F1_DOC"    , SZM->ZM_NUM	    } )	// Numero da NF         : Obrigatorio
				AAdd( aCab, { "F1_SERIE"  , SZM->ZM_SERIE   } )	// Serie da NF          : Obrigatorio
				AAdd( aCab, { "F1_EMISSAO", SZM->ZM_EMISSAO } )	// Emissao da NF        : Obrigatorio
				AAdd( aCab, { "F1_FORNECE", SZM->ZM_FORNECE	} )	// Codigo do Fornecedor : Obrigatorio
				AAdd( aCab, { "F1_LOJA"   , SZM->ZM_LOJA	} )	// Loja do Fornecedor   : Obrigatorio
				AAdd( aCab, { "F1_COND"   , SA2->A2_COND    } )
				AAdd( aCab, { "F1_ESPECIE", _cEspec         } ) // Especie
				AAdd( aCab, { "F1_CHVNFE" , SZM->ZM_CHVCTR	} ) // Chave CTE
				AAdd( aCab, { "F1_EST"    , SA2->A2_EST 	} ) // ESTADO
				AAdd( aCab, { "F1_COND"   , _cCond         	} )	// Condicao do Fornecedor
				
				lMSHelpAuto := .T.
				lMsErroAuto := .F.
				
				MSExecAuto({|x,y,z| MATA103(x,y,z)},aCab,_aItens,3)
				
				If lMsErroAuto
					MostraErro()
					DisarmTransaction()
				Endif
			Endif
			
			DbcommitAll()
		End Transaction
		
	ElseIf EXCLUI
		lMSHelpAuto := .F.
		lMsErroAuto := .F.
		_lInclui    := .F.
		aCab        := {}
		aItem       := {}
		
		AAdd( aCab,{"F1_DOC"     , SZM->ZM_NUM    })
		AAdd( aCab,{"F1_SERIE"   , SZM->ZM_SERIE  })
		AAdd( aCab,{"F1_FORNECE" , SZM->ZM_FORNECE})
		AAdd( aCab,{"F1_LOJA"    , SZM->ZM_LOJA   })
		
		aItem:= {{"D1_DOC"     , SZM->ZM_NUM    , NIL},;
			{"D1_SERIE"    , SZM->ZM_SERIE  , NIL},;
			{"D1_FORNECE"  , SZM->ZM_FORNECE, NIL},;
			{"D1_LOJA"     , SZM->ZM_LOJA   ,NIL}}
		
		MSExecAuto({|x,y,z| MATA103(x,y,z)},aCab,{aItem},5)
		
		If lMsErroAuto
			MostraErro()
		Else
			
			SZN->(dbSetOrder(4))
			If SZN->(dbSeek(xFilial("SZN") + SZM->ZM_NUM + SZM->ZM_SERIE + SZM->ZM_FORNECE + SZM->ZM_LOJA))
				_cChav := SZN->ZN_NUM + SZN->ZN_SERIE + SZN->ZN_FORNECE + SZN->ZN_LOJA
				
				While SZN->(!Eof()) .And. _cChav == SZN->ZN_NUM + SZN->ZN_SERIE + SZN->ZN_FORNECE + SZN->ZN_LOJA
					
					SF2->(dbSetOrder(1))
					If SF2->(dbSeek(xFilial("SF2")+SZN->ZN_NOTA + SZN->ZN_SERIE))
						SF2->(RecLock("SF2",.F.))
						SF2->F2_YNUMCTR := ""
						SF2->F2_YSERTRA := ""
						SF2->F2_YFORTRA := ""
						SF2->F2_YLJTRAN := ""
						SF2->F2_YPEDAGI := 0
						SF2->(MsUnlock())
					Endif
					
					SZN->(RecLock("SZN",.F.))
					SZN->(dbDelete())
					SZN->(MsUnlock())
					
					SZN->(dbSkip())
				Enddo
			Endif
			
			SZM->(RecLock("SZM",.F.))
			SZM->(dbDelete())
			SZM->(MsUnlock())
		EndIf
	Endif
	
Return

User Function VN10_02()
	
	_aAliOri := GetArea()
	
	lOk := .T.
	
	_aVerDup  := {}
	lOk       := .T.
	
	_nValTot  := 0
	
	For AX := 1 to Len(aCols)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			_cNfOri  := aCols[N,_nPNOTA]
			_cSerOri := aCols[N,_nPSERIE]
			
			_nValTot += aCols[N,_nPVALTOT]
			
			If ASCAN( _aVerDup,{|x| x[1]  == _cNfOri .And. x[2]  == _cSerOri }) == 0
				AADD( _aVerDup,{_cNfOri, _cSerOri})
			Else
				MSGSTOP(" Dados Ja lançado!!!")
				lOK := .F.
			Endif
		Endif
	Next
	
	M->ZM_TOTAL := _nValtot
	
	GetdRefresh()
	
	RestArea(_aAliOri)
	
Return(lOk)


User Function VN10_03()
	
	LOCAL _lRet := .T.
	LOCAL dDtFis:=Ctod("")
	
	_aAliOri := GetArea()
	
	If Val(M->ZM_NUM) = 0
		Return(.F.)
	Endif
	
	If M->ZM_EMISSAO > M->ZM_DTDIGIT
		MsgBox("Data de Emissao Maior que a Data de Entrada","Atencao","ALERT")
		_lRet := .F.
	EndIf
	
	dDtFis  := GetMv("MV_DATAFIS")
	dDtDigit:= M->ZM_DTDIGIT //dDataBase
	
	//If (dDtDigit <= DDATABASE .AND. DDATABASE <= dDtFis ) .OR.  dDtDigit <= dDtFis
	If dDtDigit <= dDtFis
		MsgBox("Atencao, o periodo ja foi fechado pelo Fiscal. Contactar Contabilidade","Atencao ("+Dtoc(dDtFis)+")","ALERT")
		_lRet := .F.
	EndIf
	
	If INCLUI .And. !EXCLUI
		SF1->(dbSetOrder(1))
		If SF1->(dbSeek(xFilial("SF1")+ M->ZM_NUM + M->ZM_SERIE + M->ZM_FORNECE + M->ZM_LOJA + "N"))
			MsgBox("CTR ja Cadastrado no Compras!!!","Atencao","STOP")
			_lRet := .F.
		EndIf
		
		If Alltrim(M->ZM_ESPECIE) == "1"
			If Empty(M->ZM_CHVCTR)
				MsgBox("Para a Especie Selecionada, favor informar a Chave Eletronica do CTE!!!","Atencao","STOP")
				_lRet := .F.
			Endif
		EndIf
		
	Endif
	
	RestArea(_aAliOri)
	
Return(_lRet)


User Function VN10_04(_cOpc)
	
	_aAliOri := GetArea()
	_aAliSA1 := SA1->(GetArea())
	_aAliSD2 := SD2->(GetArea())
	_aAliSF2 := SF2->(GetArea())
	_aAliSZL := SZL->(GetArea())
	
	_cNfOri  := aCols[N,_nPNOTA]
	_cSerori := Alltrim(aCols[N,_nPSERIE])
	
	SF2->(dbSetOrder(1))
	If SF2->(!dbSeek(xFilial("SF2") + _cNFORI + _cSERORI ))
		MsgAlert("Nota Fiscal Nao Cadastrada!!")
		aCols[N,_nPNOTA]  := Space(09)
		aCols[N,_nPSERIE] := Space(03)
		_cNfOri  := Space(09)
	Else
		If !Empty(SF2->F2_YNUMCTR)
			MsgAlert("Nota Fiscal Já Possui CTR Lancado!! "+ SF2->F2_YNUMCTR)
			aCols[N,_nPNOTA]  := Space(09)
			aCols[N,_nPSERIE] := Space(03)
			_cNfOri  := Space(09)
		ElseIf Empty(SF2->F2_TRANSP)
			MsgAlert("Nota Fiscal Original sem Transportadora!! ")
			aCols[N,_nPNOTA]  := Space(09)
			aCols[N,_nPSERIE] := Space(03)
			_cNfOri  := Space(09)
		Else
			SD2->(dbSetOrder(3))
			If SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ))
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE + SF2->F2_LOJA))
				
				_cEst    := SA1->A1_EST
				_cCodMun := SA1->A1_COD_MUN
				
				If !Empty(SA1->A1_YUFENT) .And. !Empty(SA1->A1_YMUNENT)
					_cEst    := SA1->A1_YUFENT
					_cCodMun := SA1->A1_YMUNENT
				Endif
				
				SZL->(dbSetorder(1))
				If SZL->(dbSeek(xFilial("SZL")+	_cEst + _cCodMun + SF2->F2_YTPCAR + SF2->F2_TRANSP + Left(SD2->D2_COD,4)))
					//			If SZL->(dbSeek(xFilial("SZL")+	SA1->A1_UF + SA1->A1_COD_MUN + SF2->F2_TRANSP + SD2->D2_COD))
					aCols[N,_nPTES]     := SZL->ZL_TES
					aCols[N,_nPVALUNIT] := SZL->ZL_VALFRET
					aCols[N,_nPEDAGIO]  := SZL->ZL_PEDAGIO
					aCols[N,_nPVALTOT]  := SZL->ZL_VALFRET + SZL->ZL_PEDAGIO
				Else
					SZL->(dbSetorder(1))
					If SZL->(dbSeek(xFilial("SZL")+	_cEst + _cCodMun + SF2->F2_YTPCAR + SF2->F2_TRANSP ))
						//					If SZL->(dbSeek(xFilial("SZL")+	SA1->A1_UF + SA1->A1_COD_MUN + SF2->F2_TRANSP ))
						aCols[N,_nPTES]     := SZL->ZL_TES
						aCols[N,_nPVALUNIT] := SZL->ZL_VALFRET
						aCols[N,_nPEDAGIO]  := SZL->ZL_PEDAGIO
						aCols[N,_nPVALTOT]  := SZL->ZL_VALFRET + SZL->ZL_PEDAGIO
					Endif
				Endif
				
			Endif
		Endif
	Endif
	
	_nValtot := 0
	
	For AX := 1 to Len(aCols)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			_cNfOri  := aCols[AX,_nPNOTA]
			_cSerOri := aCols[AX,_nPSERIE]
			
			_nValTot += aCols[AX,_nPVALTOT]
		Endif
	Next
	
	M->ZM_TOTAL := _nValtot
	
	_cRet := _cNfOri
	If _cOpc = 'S'
		_cRet := _cSerori
	Endif
	
	GetdRefresh()
	
	RestArea(_aAliSA1)
	RestArea(_aAliSD2)
	RestArea(_aAliSF2)
	RestArea(_aAliSZL)
	RestArea(_aAliOri)
	
Return(_cRet)
//Return(_cNFORI)

User Function VN10_05()
	
	_aAliOri := GetArea()
	_aAliSA1 := SA1->(GetArea())
	_aAliSD2 := SD2->(GetArea())
	_aAliSF2 := SF2->(GetArea())
	_aAliSZL := SZL->(GetArea())
	
	_cNfOri  := aCols[N,_nPNOTA]
	_cSerori := Alltrim(aCols[N,_nPSERIE])
	
	_nDescont := aCols[N,_nPDESCONT]
	_nFrete   := 0
	
	SF2->(dbSetOrder(1))
	If SF2->(dbSeek(xFilial("SF2") + _cNFORI + _cSERORI ))
		SD2->(dbSetOrder(1))
		If SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ))
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE + SF2->F2_LOJA))
			
			_cEst    := SA1->A1_EST
			_cCodMun := SA1->A1_COD_MUN
			
			If !Empty(SA1->A1_YUFENT) .And. !Empty(SA1->A1_YMUNENT)
				_cEst    := SA1->A1_YUFENT
				_cCodMun := SA1->A1_YMUNENT
			Endif
			
			SZL->(dbSetorder(1))
			If SZL->(dbSeek(xFilial("SZL")+_cEst + _cCodMun + SF2->F2_TRANSP + Left(SD2->D2_COD,4)))
				//		If SZL->(dbSeek(xFilial("SZL")+	SA1->A1_UF + SA1->A1_COD_MUN + SF2->F2_TRANSP + SD2->D2_COD))
				_nFrete := SZL->ZL_VALFRET + SZL->ZL_PEDAGIO
			Else
				SZL->(dbSetorder(1))
				If SZL->(dbSeek(xFilial("SZL")+_cEst + _cCodMun + SF2->F2_TRANSP ))
					_nFrete := SZL->ZL_VALFRET + SZL->ZL_PEDAGIO
				Endif
			Endif
		Endif
	Endif
	
	aCols[N,_nPVALTOT] := _nFrete - _nDescont
	
	_nValtot := 0
	
	For AX := 1 to Len(aCols)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			_cNfOri  := aCols[AX,_nPNOTA]
			_cSerOri := aCols[AX,_nPSERIE]
			
			_nValTot += aCols[AX,_nPVALTOT]
		Endif
	Next
	
	M->ZM_TOTAL := _nValtot
	
	GetdRefresh()
	
	RestArea(_aAliSA1)
	RestArea(_aAliSD2)
	RestArea(_aAliSF2)
	RestArea(_aAliSZL)
	RestArea(_aAliOri)
	
Return(_nDescont)
