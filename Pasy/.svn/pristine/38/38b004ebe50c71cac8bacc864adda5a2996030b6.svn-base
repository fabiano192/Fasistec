#INCLUDE "PROTHEUS.CH"

/*
Ponto de Entrada no cadastro de Transportadora
Descrição: Inserir um botão para inclusão de veículo / Motorista
Data : 24/11/09
*/

User Function MA050BUT()

_aButton := {}
AAdd(_aButton, {"CARGA",{|| VEIC()},"VEICULO"})

Return(_aButton)


Static Function VEIC()

If Inclui .Or. Altera
	
	_aAliOri := GetArea()
	_aAliSZL := SZL->(GetArea())
	
	Private oGetDad
	nOpcx:=3
	
	dbSelectArea("Sx3")
	dbSetOrder(1)
	dbSeek("SZL")
	
	nUsado:=0
	aHeader:={}
	While !Eof() .And. (x3_arquivo == "SZL")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.(Alltrim(x3_campo) $ "ZL_MOTORIS/ZL_VEICULO/ZL_PLACA  /ZL_ATIVO  ")
			nUsado:=nUsado+1
			//		If RTrim(X3_CAMPO) == "ZC_PRECO"
			//			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			//			x3_tamanho, x3_decimal, 'U_LINHA01()',;
			//			x3_usado, x3_tipo, x3_arquivo, x3_context } )
			//		Else
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
			//		Endif
		Endif
		dbSkip()
	End
	
	aCols:=Array(1,nUsado+1)
	dbSelectArea("Sx3")
	dbSeek("SZL")
	nUsado:=0
	While !Eof() .And. (x3_arquivo == "SZL")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.(Alltrim(x3_campo) $ "ZL_MOTORIS/ZL_VEICULO/ZL_PLACA  /ZL_ATIVO  ")
			nUsado:=nUsado+1
			IF nOpcx == 3
				IF x3_tipo == "C"
					aCOLS[1][nUsado] := SPACE(x3_tamanho)
				Elseif x3_tipo == "N"
					aCOLS[1][nUsado] := 0
				Elseif x3_tipo == "D"
					aCOLS[1][nUsado] := dDataBase
				Elseif x3_tipo == "M"
					aCOLS[1][nUsado] := ""
				Else
					aCOLS[1][nUsado] := .F.
				Endif
			Endif
		Endif
		dbSkip()
	End
	aCOLS[1][nUsado+1] := .F.
	
	_cCod   := M->A4_COD
	_cNome  := M->A4_NOME
	
	ACols:={}
	dbSelectArea("SZL")
	dbSetOrder(1)
	dbSeek(xFilial("SZL") + _cCod)
	
	_cChavSZL := _cCod
	
	While !eof() .And. _cChavSZL == SZL->ZL_CODIGO
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	EndDo
	
	nLinGetD:= 0
	cTitulo := "Cadastro Veiculo e Motorista"
	
	aC:={}
	AADD(aC,{"_cCod"     ,{15,10}    ,"Codigo:"   ,"@I","","SA4",.F.})
	AADD(aC,{"_cNome"    ,{15,150}   ,"Nome:"     ,"@I","","SA4",.F.})
	
	aR:={}
	
	aCGD  := {33,10,100,315}
	aCord := {120,150,350,815}
	
	/*
	1 -  Linha Superior
	2 -  Coluna Esquerda
	3 -  Linha Inferior
	4 -  Coluna Direita
	*/
	
	cLinhaOk  := "AllWaysTrue()"
	cTudoOk   := "AllWaysTrue()"
	
	lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,aCord)
	
	If lRetMod2
		VEIC1()
	Endif
	
	RestArea(_aAliSZL)
	RestArea(_aAliOri)
	
Else
	
	MsgInfo("Botão disponivel somente para inclusão ou alteração!")

Endif

_cRet := ""

Return(_cRet)


Static Function VEIC1()

Private  _nPMotor  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZL_MOTORIS"})
Private  _nPVeicu  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZL_VEICULO"})
Private  _nPPlaca  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZL_PLACA"})
Private  _nPAtivo  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZL_ATIVO"})

_lDel := .F.
For I:= 1 to Len(Acols)
	_cFim := (Len(aHeader)+1)
	
	_cMotoris := aCols[I,_nPMotor]
	If aCols[I,_cFim] // A linha está deletada
		I := I
		
		dbSelectArea("SZL")
		dbSetOrder(1)
		dbSeek(xFilial("SZL") + _cCod + _cMotoris)
		
		_cChavSZL := _cCod + _cMotoris
		
		While !eof() .And. _cChavSZL == SZL->ZL_CODIGO + SZL->ZL_MOTORIS
			dbSelectArea("SZL")
			RecLock("SZL",.F.)
			dbDelete()
			MsUnlock()
			dbSelectarea("SZL")
			dbSkip()
		EndDo
		
	Else
		If !_lDel
			_lDel := .T.
			dbSelectArea("SZL")
			dbSetOrder(1)
			dbSeek(xFilial("SZL") + _cCod + _cMotoris)
			
			_cChavSZL := _cCod + _cMotoris
			
			While !eof() .And. _cChavSZL == SZL->ZL_CODIGO + SZL->MOTORIS
				dbSelectArea("SZL")
				RecLock("SZL",.F.)
				dbDelete()
				MsUnlock()
				dbSelectarea("SZL")
				dbSkip()
			EndDo
		Endif
		
		If !Empty(aCols[I,_nPMotor])
			dbSelectArea("SZL")
			RecLock("SZL",.T.)
			
			SZL->ZL_FILIAL   := xFilial("SZL")
			SZL->ZL_CODIGO   := _cCod
			SZL->ZL_MOTORIS  := aCols[I,_nPMotor]
			SZL->ZL_VEICULO  := aCols[I,_nPVeicu]
			SZL->ZL_PLACA    := aCols[I,_nPPlaca]
			SZL->ZL_ATIVO    := aCols[I,_nPAtivo]
			MsUnlock()
		Endif
	Endif
	
Next I

Return
