#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ MIZ826   ³ Autor ³ Nilton Cesar          ³ Data ³ 12.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Itens da tabela de preco                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RDMAKE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MIZ826()

SetPrvt("WOPCAO,LVISUALIZAR,LINCLUIR,LALTERAR,LEXCLUIR,NOPCE")
SetPrvt("NOPCG,COPCAO,NUSADO,AHEADER,ACOLS,I")
SetPrvt("WFILIAL,CTITULO,CALIASENCHOICE,CALIASGETD")
SetPrvt("CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE,LRET")

Private _cGrAprov:= ""
Private aHeader
Private	_aPrAnt := {}
Private n_LIBERACAO := 3

_cGrAprov:= GETMV("MZ_GRAPROV")

SAL->(dbSetOrder(2))
If SAL->(!dbSeek(xFilial() + _cGrAprov))
	MSGSTOP("Grupo Nao Cadastrado, Favor Contatar o Administrador do Sistema!")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Determina funcao selecionada                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wOpcao      := paramixb
lVisualizar := .F.
lIncluir    := .F.
lAlterar    := .F.
lExcluir    := .F.
_lReajust   := .F.
Do Case
	Case wOpcao == "V" ; lVisualizar := .T. ; nOpcE := 2 ; nOpcG := 2 ; cOpcao := "VISUALIZAR"
	Case wOpcao == "I" ; lIncluir    := .T. ; nOpcE := 3 ; nOpcG := 3 ; cOpcao := "INCLUIR"
	Case wOpcao == "A" ; lAlterar    := .T. ; nOpcE := 3 ; nOpcG := 3 ; cOpcao := "ALTERAR"
	Case wOpcao == "E" ; lExcluir    := .T. ; nOpcE := 3 ; nOpcG := 3 ; cOpcao := "EXCLUIR"
	Case wOpcao == "R" ; _lReajust   := .T. ; nOpcE := 3 ; nOpcG := 3 ; cOpcao := "REAJUSTAR"
EndCase


//Pergunte - Filtro (Registro bloqueados/liberados ou ambos)  - Juailson - Semar 06/03/15

//if lAlterar  .and. cEmpAnt $ "30"     	Comentado por Alison - 22/07/2016
If lAlterar  .and. cEmpAnt + cFilAnt $ '0210|3001'

	If Pergunte("MIZ826F",.T.)
	   n_LIBERACAO := MV_PAR01  // 1 = Bloqueado 2 = Liberado e 3 = Ambos
    endif

endif

//

If _lReajust
	ATUSX1()
	If Pergunte("MIZ826",.T.)
		_lAcresc := MV_PAR13 == 2    // Descrescimo
		_lPerc   := MV_PAR14 == 1    // Percentual
		//Adicionado por Rodrigo Feitosa (Semar) - 01/10/13
		_lAlinha := MV_PAR13 == 3	  // Alinhamento

		_cQ:= " DELETE "+RetSqlName("SZI")+" FROM "+RetSqlName("SZI")+" A INNER JOIN "+RetSqlName("SA1")+" B ON ZI_CLIENTE=A1_COD AND ZI_LOJA=A1_LOJA "
		_cQ+= " WHERE A.D_E_L_E_T_ = '' AND ZI_LIBER = '' AND B.D_E_L_E_T_ = '' "
		_cQ+= " AND ZI_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+" ' "
		_cQ+= " AND ZI_LOJA    BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+" ' "
		_cQ+= " AND A1_EST     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+" ' "
		_cQ+= " AND A1_MUN     BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+" ' "
		_cQ+= " AND ZI_PRODUTO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+" ' "
		_cQ+= " AND ZI_FILIAL  BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+" ' "

		TCSQLEXEC(_cQ)

		_cQ:= " DELETE "+RetSqlName("SCR")+" FROM "+RetSqlName("SCR")+"  A INNER JOIN "+RetSqlName("SA1")+" B ON CR_YCLIENT=A1_COD AND CR_YLOJA=A1_LOJA "
		_cQ+= " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND CR_TIPO = '02' AND CR_DATALIB = '' "
		_cQ+= " AND CR_YCLIENT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+" ' "
		_cQ+= " AND CR_YLOJA   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+" ' "
		_cQ+= " AND A1_EST     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+" ' "
		_cQ+= " AND A1_MUN     BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+" ' "
		_cQ+= " AND CR_YPRODUT BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+" ' "
		_cQ+= " AND CR_MSFIL   BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+" ' "

		TCSQLEXEC(_cQ)

		_cQ:= " DELETE "+RetSqlName("ZAH")+" FROM "+RetSqlName("ZAH")+"  A INNER JOIN "+RetSqlName("SA1")+" B ON ZAH_YCLIEN=A1_COD AND ZAH_YLOJA=A1_LOJA "
		_cQ+= " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND ZAH_TIPO = '02' AND ZAH_DATALI = '' "
		_cQ+= " AND ZAH_YCLIEN BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+" ' "
		_cQ+= " AND ZAH_YLOJA  BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+" ' "
		_cQ+= " AND A1_EST     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+" ' "
		_cQ+= " AND A1_MUN     BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+" ' "
		_cQ+= " AND ZAH_YPRODU BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+" ' "
		_cQ+= " AND ZAH_MSFIL  BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+" ' "

		TCSQLEXEC(_cQ)

		_cQ:= " SELECT * FROM "+RetSqlName("SZI")+" A INNER JOIN "+RetSqlName("SA1")+" B ON ZI_CLIENTE=A1_COD AND ZI_LOJA=A1_LOJA "
		_cQ+= " WHERE A.D_E_L_E_T_ = '' AND ZI_LIBER = 'L' AND B.D_E_L_E_T_ = '' "
		_cQ+= " AND ZI_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+" ' "
		_cQ+= " AND ZI_LOJA    BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+" ' "
		_cQ+= " AND A1_EST     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+" ' "
		_cQ+= " AND A1_MUN     BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+" ' "
		_cQ+= " AND ZI_PRODUTO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+" ' "
		_cQ+= " AND ZI_FILIAL  BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+" ' "
		_cQ+= " ORDER BY ZI_CLIENTE,ZI_LOJA,ZI_PRODUTO "

		TCQUERY _cQ NEW ALIAS "ZZ"

		TCSETFIELD("ZZ","ZI_DTBLOQ","D")

		ZZ->(dbGotop())

		While ZZ->(!Eof())

			_nPerc   := 0
			_nValCIF := 0
			_nValFOB := 0
			_nValCID := 0 // Juailson-Semar - Preco Cif Descarga 22/01/15
			_nValGER := 0
			_nValPrU := 0

			If MV_PAR13 == 1          // Descrescimo
				If MV_PAR14   == 1    // Percentual
					_nPerc   := MV_PAR15
					//MIZ826C(_lAcresc,_lPerc)
					//Adicionado por Rodrigo Feitosa (Semar) - 27/09/13
					aRet := MIZ826C(_lAcresc,_lPerc,_lAlinha)
					MIZ826D(aRet[1],aRet[2])
					//
				ElseIf MV_PAR14 == 2  // Valor
					_nValCIF := MV_PAR16
					_nValFOB := MV_PAR17
					_nValGER := MV_PAR18
					_nValPrU := MV_PAR19
					_nValCID := MV_PAR20  // Incluido por Juailson-Semar Preco Cif Recarga - em 22/01/15
					_nValPrU := MV_PAR
					//MIZ826C(_lAcresc,_lPerc)
					//Adicionado por Rodrigo Feitosa (Semar) - 27/09/13
					aRet := MIZ826C(_lAcresc,_lPerc,_lAlinha)
					MIZ826D(aRet[1],aRet[2])
					//
				Endif
			ElseIf MV_PAR13 == 2        // Acrescimo
				If MV_PAR14   == 1    // Percentual
					_nPerc   := MV_PAR15
					//MIZ826C(_lAcresc,_lPerc)
					//Adicionado por Rodrigo Feitosa (Semar) - 27/09/13
					aRet := MIZ826C(_lAcresc,_lPerc,_lAlinha)
					MIZ826D(aRet[1],aRet[2])
					//
				ElseIf MV_PAR14 == 2  // Valor
					_nValCIF := MV_PAR16
					_nValFOB := MV_PAR17
					_nValGER := MV_PAR18
					_nValPrU := MV_PAR19
					_nValCID := MV_PAR20  // Incluido por Juailson-Semar Preco Cif Recarga - em 22/01/15
					//MIZ826C(_lAcresc,_lPerc)
					//Adicionado por Rodrigo Feitosa (Semar) - 27/09/13
					aRet := MIZ826C(_lAcresc,_lPerc,_lAlinha)
					MIZ826D(aRet[1],aRet[2])
					//
				Endif
				//Adicionado por Rodrigo Feitosa (Semar) - 01/10/13
			ElseIf MV_PAR13 == 3			// Alinhamento
				_nValCIF := MV_PAR16
				_nValFOB := MV_PAR17
				_nValGER := MV_PAR18
				_nValPrU := MV_PAR19
			    _nValCID := MV_PAR20  // Incluido por Juailson-Semar Preco Cif Recarga - em 22/01/15
				aRet := MIZ826C(_lAcresc,_lPerc,_lAlinha)
				MIZ826D(aRet[1],aRet[2])
			Endif

			ZZ->(dbSkip())
		EndDo

		ZZ->(dbcloseArea())

		MSGINFO("Atualizado Com Sucesso!!")
	Endif

	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory("SZH",(cOpcao=="INCLUIR"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZI")
nUsado  := 0
c_PICTURE := "" // mascara
aHeader := {}
//Inclusao do campo ZI_PRECOD(Preço CIF Descarga) - Semar Juailson 20/01/2015 - retirei o campo ZI_DESCCID pedido de Renato.
// Normando (Semar) 06/10/2015 - Alteração do usuario
If SZI->(FieldPos("ZI_USRALT")) > 0
	_aCampos := {"ZI_LIBER","ZI_DTBLOQ","ZI_YGRPPRC","ZI_PRODUTO","ZI_DESC","ZI_DESCON","ZI_PRECO",/*"ZI_DESCCID",*/"ZI_PRECOD","ZI_DESCONF","ZI_PRECOF","ZI_DTREAJ","ZI_PGER","ZI_PRCUNIT","ZI_DTVIGEN","ZI_USRALT","ZI_USRINC","ZI_ITEM"}
Else
	_aCampos := {"ZI_LIBER","ZI_DTBLOQ","ZI_YGRPPRC","ZI_PRODUTO","ZI_DESC","ZI_DESCON","ZI_PRECO",/*"ZI_DESCCID",*/"ZI_PRECOD","ZI_DESCONF","ZI_PRECOF","ZI_DTREAJ","ZI_PGER","ZI_PRCUNIT","ZI_DTVIGEN","ZI_USRINC","ZI_ITEM"}
EndIf

FOR AZ:= 1 TO Len(_aCampos)

	dbSelectArea("Sx3")
	dbSetOrder(2)
	If dbSeek(_aCampos[AZ])

		If  X3USO(SX3->X3_USADO) .and. SX3->X3_NIVEL <= cNivel
			nUsado := nUsado + 1


			aadd(aHeader,{ trim(SX3->X3_TITULO),SX3->X3_CAMPO   , ;
		  	SX3->X3_PICTURE       ,SX3->X3_TAMANHO , ;
			SX3->X3_DECIMAL     ,"AllwaysTrue()" , ;
			SX3->X3_USADO       ,SX3->X3_TIPO    , ;
			SX3->X3_ARQUIVO     ,SX3->X3_CONTEXT } )



		Endif
	Endif
Next AZ

Private _nPITEM   := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_ITEM"})
Private _nPGRP    := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_YGRPPRC"})
Private _nPROD    := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_PRODUTO"})
Private _nDESC    := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_DESC"})
Private _nPRECO   := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_PRECO"})
Private _nDESCON  := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_DESCON"})
Private _nPRECOF  := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_PRECOF"})
Private _nDESCONF := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_DESCONF"})
Private _nPRECOD  := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_PRECOD"}) //Incluido Semar Juailson - 20/01/15 Preco Cif Descarga
//Private _nDESCDESC := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_DESCCID"}) //Incluido Semar Juailson - 20/01/15 Desconto Cif Descarga
Private _nPGER    := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_PGER"})
Private _nPUNIT   := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_PRCUNIT"})
Private _nPDtVig  := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_DTVIGEN"})
Private _nPStatus := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_LIBER"})
Private _nPDtBloq := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_DTBLOQ"})
Private _nPUSRALT := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_USRALT"}) // Normando (Semar) 06/10/2015 - Alteração do usuario
Private _nPUSRINC := aScan(aHeader,{|x| Alltrim(x[2]) == "ZI_USRINC"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aCols                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  lIncluir
	aCols             := {array(nUsado+1)}
	aCols[1,nUsado+1] := .F.
	For i := 1 to nUsado
		aCols[1,i] := CriaVar(aHeader[i,2])
		If aHeader[I,2] = "ZI_ITEM"
			aCols[1,I]:= "001"
		Else
			aCols[1,I]:= CriaVar(aHeader[I,2])
		Endif
	Next

	_cCodigo    := GetSxeNum("SZI","ZI_CODIGO")
	ConfirmSX8()
	//RollBAckSx8()

Else
	aCols:={}
	dbSelectArea("SZI")
	dbSetOrder(1)
	If !dbSeek(xFilial("SZI")+M->ZH_CLIENTE+M->ZH_LOJA)
		While !Reclock("SZI",.t.);EndDo
		SZI->ZI_FILIAL    := xFilial("SZI")
		SZI->ZI_CLIENTE   := M->ZH_CLIENTE
		SZI->ZI_LOJA      := M->ZH_LOJA
		MsUnlock()
	EndIf

	If Empty(SZI->ZI_CODIGO)
		_cCodigo    := GetSxeNum("SZI","ZI_CODIGO")
		//RollBAckSx8()
		ConfirmSX8()
	Else
		_cCodigo    := SZI->ZI_CODIGO
	Endif

	_cIt := "000"

	While !eof() .and. SZI->ZI_FILIAL   == xFilial("SZI") ;
		.and. SZI->ZI_CLIENTE   == M->ZH_CLIENTE ;
		.and. SZI->ZI_LOJA      == M->ZH_LOJA

        //Filtrar pelo tipo de Liberacao   - Juailson -  Semar 06/03/15
        if n_LIBERACAO == 1

	        if SZI->ZI_LIBER <> "B"

	           		dbSkip()
	           		loop
	        endif

        elseif n_LIBERACAO == 2

	        if SZI->ZI_LIBER <> "L"

	           		dbSkip()
	           		loop
	        endif


        endif
        //



		aadd(aCols,array(nUsado+1))

		If Empty(SZI->ZI_ITEM)
			_cIt := Soma1(_cit)
		Else
			_cIt := SZI->ZI_ITEM
		Endif

		For i := 1 to nUsado
			If Empty(SZI->ZI_ITEM)
				If aHeader[I,2] = "ZI_ITEM"
					aCols[len(aCols),i] := _cIt
				Else
					aCols[len(aCols),i]    := FieldGet(FieldPos(aHeader[i,2]))
				Endif
			Else
				aCols[len(aCols),i]    := FieldGet(FieldPos(aHeader[i,2]))
			Endif
		Next

		aCols[len(aCols),nUsado+1] := .F.
		dbSkip()
	EndDo
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTitulo        := "Cadastro da Tabela de Precos"
cAliasEnchoice := "SZH"
cAliasGetD     := "SZI"
cLinOk         := 'Execblock("MIZ826L",.F.,.F.,)'
cTudOk         := 'execblock("MIZ826T",.F.,.F.,)'
cFieldOk       := "AllwaysTrue()"
aCpoEnchoice   := {"ZH_CLIENTE","ZH_LOJA","ZH_NOME"}

lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,1000000)

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

_lParar := .T.

Do Case
	Case lIncluir
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava SZI - ITENS TABELA DE PRECO                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SZI")
		lSZI  := .F.
		_lBloq:= .F.
		For i := 1 to len(aCols)

			If  ! aCols[i,nUsado+1]
				DbSelectArea("SZI")
				RecLock("SZI",.T.)
				SZI->ZI_FILIAL  := xFilial("SZI")
				SZI->ZI_CODIGO  := _cCodigo
				SZI->ZI_ITEM    := aCols[i,_nPITEM]
				SZI->ZI_CLIENTE := M->ZH_CLIENTE
				SZI->ZI_LOJA    := M->ZH_LOJA
				SZI->ZI_YGRPPRC := aCols[i,_nPGRP]
				SZI->ZI_PRODUTO := aCols[i,_nPROD]
				SZI->ZI_DESC    := aCols[i,_nDESC]
				SZI->ZI_PRECO   := aCols[i,_nPRECO]
//				SZI->ZI_DESCCID := aCols[i,_nDESCDESC] //Juailson-Semar 22/01/15 - DESCONTO DESCARGA
				SZI->ZI_PRECOD  := aCols[i,_nPRECOD] //Juailson-Semar 22/01/15
				SZI->ZI_DESCON  := aCols[i,_nDESCON]
				SZI->ZI_PRECOF  := aCols[i,_nPRECOF]
				SZI->ZI_DESCONF := aCols[i,_nDESCONF]
				SZI->ZI_PGER    := aCols[i,_nPGER]
				SZI->ZI_PRCUNIT := aCols[i,_nPUNIT]
				SZI->ZI_DTVIGEN := Date()
				SZI->ZI_USRINC  := cUsername
				If SZI->(FieldPos("ZI_USRALT")) > 0			// Normando (Semar) 06/10/2015 - Alteração do usuario
					SZI->ZI_USRALT  := " "
				EndIf
				MsUnLock()
				DbSelectArea("SZI")
				lSZI := .T.

				_lLibera := .F.

				_cAtivid := ""
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+M->ZH_CLIENTE + M->ZH_LOJA))

				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+aCols[i,_nPROD]))

				_cProduto := aCols[i,_nPROD]
				_lEncont  := .F.

				If Empty(aCols[I,_nPStatus]) .And.  !Alltrim(SB1->B1_TIPCAR) $ "CDC"
					ZA4->(dbSetOrder(2))
					If ZA4->(!dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA + SA1->A1_MUN))
						If ZA4->(!dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA ))
							If ZA4->(dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD ))
								_lEncont :=.T.
							Endif
						Endif
					Else
						_lEncont :=.T.
					Endif

					_lVerPrCif := .F.
					_lVerPrFob := .F.
					_lVerPrCDe := .F. // Preço Cif Descarga -  Semar Juailson 20/01/15

					If SZI->ZI_PRECO > 0
						If !_lEncont
							_lVerPrCif := .T.
						ElseIf SZI->ZI_PRECO < ZA4->ZA4_VLMCIF .And. SZI->ZI_PRECO > 0
							_lVerPrCif := .T.
						ElseIf GETMV("MZ_LIBPRC")  // PARAMETRO PARA QUE FORÇA O BLOQUEIO DOS PREÇOS
							_lVerPrCif := .T.
						Endif
					Endif


					If SZI->ZI_PRECOF > 0
						If !_lEncont
							_lVerPrFob := .T.
						ElseIf SZI->ZI_PRECOF < ZA4->ZA4_VLMFOB .And. SZI->ZI_PRECOF > 0
							_lVerPrFob := .T.
						ElseIf GETMV("MZ_LIBPRC")  // PARAMETRO PARA QUE FORÇA O BLOQUEIO DOS PREÇOS
							_lVerPrCif := .T.
						Endif
					Endif

					If SZI->ZI_PRECOD > 0  // Preço Cif Descarga -  Semar Juailson 20/01/15
						If !_lEncont
					    	_lVerPrCDe := .T.
						ElseIf SZI->ZI_PRECOD < ZA4->ZA4_VLMCID .And. SZI->ZI_PRECOD > 0
							_lVerPrCDe := .T.
						ElseIf GETMV("MZ_LIBPRC")  // PARAMETRO PARA QUE FORÇA O BLOQUEIO DOS PREÇOS
							_lVerPrCDe := .T.
						Endif
					Endif

					If _lVerPrCIF .Or. _lVerPrFob .Or. _lVerPrCDe

						SCR->(dbOrderNickName("INDSCR5"))
						//If SCR->(dbSeek(xFilial("SCR")+"02"+ SZI->ZI_CODIGO  + SZI->ZI_ITEM + Space(41) + Space(08) ))
						If SCR->(dbSeek(xFilial("SCR")+"02"+ SZI->ZI_CLIENTE + SZI->ZI_LOJA + SZI->ZI_CODIGO  + SZI->ZI_ITEM + Space(33) + Space(08) ))

							_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM + DTOS(SCR->CR_DATALIB)

							ZAH->(dbSetOrder(7))
							If ZAH->(dbSeek(xFilial("ZAH")+ _cChavSCR  ))
								_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
								_cCrTipo  := SCR->CR_TIPO
								_cDocSCR  := SCR->CR_NUM
								_cYCli    := SCR->CR_YCLIENT
								_cYLoja   := SCR->CR_YLOJA
								_cYObra   := SCR->CR_YOBRA
								_cYProd   := SCR->CR_YPRODUT
								_dYDataLib:= SCR->CR_DATALIB

								_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE    ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
								_cCq += " AND ZAH_YCLIEN = '"+_cYCli +"' AND ZAH_YLOJA   = '"+_cYLoja+"' AND ZAH_YOBRA = '"+_cYObra+"' "
								_cCq += " AND ZAH_YPRODU = '"+_cYProd+"' AND ZAH_DATALI  = '"+DTOS(_dYDataLib)+ "' "
								TcSqlExec(_cCq)
							Endif

							While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM + DTOS(SCR->CR_DATALIB)

								SCR->(RecLock("SCR",.F.))
								SCR->(dbDelete())
								SCR->(MsUnlock())

								SCR->(dbSkip())

							EndDo
						Endif

						//_cNum       := SZI->ZI_CODIGO  + SZI->ZI_ITEM
						_cNum       := SZI->ZI_CLIENTE + SZI->ZI_LOJA + SZI->ZI_CODIGO  + SZI->ZI_ITEM

						//ZZ->(dbCloseArea())

						//_cGrAprov	:= SY1->Y1_GRAPROV
						lFirstNiv   := .T.
						cAuxNivel   := ""
						_lLibera    := .T.

						SAL->(dbSetOrder(2))
						If SAL->(dbSeek(xFilial()+_cGrAprov))

							While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD

								If lFirstNiv
									cAuxNivel := SAL->AL_NIVEL
									lFirstNiv := .F.
								EndIf

								SCR->(Reclock("SCR",.T.))
								SCR->CR_FILIAL	:= xFilial("SCR")
								SCR->CR_NUM		:= _cNum
								SCR->CR_TIPO	:= "02"
								SCR->CR_NIVEL	:= SAL->AL_NIVEL
								SCR->CR_USER	:= SAL->AL_USER
								SCR->CR_APROV	:= SAL->AL_APROV
								SCR->CR_STATUS	:= "02"//IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
								SCR->CR_EMISSAO := dDataBase
								SCR->CR_MOEDA	:= 1
								SCR->CR_TXMOEDA := 1
								SCR->CR_OBS     := Alltrim(SM0->M0_NOME) + " - TABELA DE PRECO VENDAS"

								If _lVerPrCif
									If SZI->ZI_PRECO < ZA4->ZA4_VLMCIF .Or. !_lEncont
										SCR->CR_YREFCIF := ZA4->ZA4_VLMCIF
										SCR->CR_YPRCCIF := SZI->ZI_PRECO
										SCR->CR_TOTAL	:= SZI->ZI_PRECO
									Endif
								Endif

								If _lVerPrFob
									If SZI->ZI_PRECOF < ZA4->ZA4_VLMFOB .Or. !_lEncont
										SCR->CR_YREFFOB := ZA4->ZA4_VLMFOB
										SCR->CR_YPRCFOB := SZI->ZI_PRECOF
										SCR->CR_TOTAL	:= SZI->ZI_PRECOF
									Endif
								Endif

								If _lVerPrCDe   //Juailson-Semar -Preco Cif Descarga - 22/01/15
									If SZI->ZI_PRECOD < ZA4->ZA4_VLMCID .Or. !_lEncont
										SCR->CR_YREFCID := ZA4->ZA4_VLMCID
										SCR->CR_YPRCCID := SZI->ZI_PRECOD
										SCR->CR_TOTAL	:= SZI->ZI_PRECOD
									Endif
								Endif

								If SZI->ZI_PGER   < ZA4->ZA4_VLMGER
									SCR->CR_YREFGER := ZA4->ZA4_VLMGER
									SCR->CR_YPRCGER := SZI->ZI_PGER
									SCR->CR_TOTAL	:= SZI->ZI_PGER
								Endif

								SCR->CR_YCLIENT := SZI->ZI_CLIENTE
								SCR->CR_YLOJA   := SZI->ZI_LOJA
								SCR->CR_YPRODUT := SZI->ZI_PRODUTO
								SCR->(MsUnlock())

								ZAH->(RecLock("ZAH",.T.))
								ZAH->ZAH_FILIAL:= SCR->CR_FILIAL
								ZAH->ZAH_NUM   := SCR->CR_NUM
								ZAH->ZAH_TIPO  := SCR->CR_TIPO
								ZAH->ZAH_NIVEL := SCR->CR_NIVEL
								ZAH->ZAH_USER  := SCR->CR_USER
								ZAH->ZAH_APROV := SCR->CR_APROV
								ZAH->ZAH_STATUS:= SCR->CR_STATUS
								ZAH->ZAH_TOTAL := SCR->CR_TOTAL
								ZAH->ZAH_EMISSA:= SCR->CR_EMISSAO
								ZAH->ZAH_MOEDA := SCR->CR_MOEDA
								ZAH->ZAH_TXMOED:= SCR->CR_TXMOEDA
								ZAH->ZAH_OBS   := SCR->CR_OBS
								ZAH->ZAH_YREFCI:= SCR->CR_YREFCIF
								ZAH->ZAH_YPRCCI:= SCR->CR_YPRCCIF
							    ZAH->ZAH_YREFCD := SCR->CR_YREFCID //Ref Cif Descarga - Juailson Semar 06/02/15
                                ZAH->ZAH_YPRCCD := SCR->CR_YPRCCID // Preco Cif Descarga -  Juailson Semar 06/02/15
								ZAH->ZAH_TOTAL := SCR->CR_TOTAL
								ZAH->ZAH_YREFFO:= SCR->CR_YREFFOB
								ZAH->ZAH_YPRCFO:= SCR->CR_YPRCFOB
								ZAH->ZAH_YREFGE:= SCR->CR_YREFGER
								ZAH->ZAH_YPRCGE:= SCR->CR_YPRCGER
								ZAH->ZAH_YCLIEN:= SCR->CR_YCLIENT
								ZAH->ZAH_YLOJA := SCR->CR_YLOJA
								ZAH->ZAH_YPRODU:= SCR->CR_YPRODUT
								ZAH->ZAH_YOBRA := SCR->CR_YOBRA
								ZAH->ZAH_YCODTA:= SCR->CR_YCODTAB
								ZAH->ZAH_YFORNE:= SCR->CR_YFORNEC
								ZAH->ZAH_YLOJFO:= SCR->CR_YLOJFOR
								ZAH->(MsUnlock())

								SAL->(dbSkip())
							EndDo

							SZI->(RecLock("SZI",.F.))
							SZI->ZI_CODBKP := _cNum
							SZI->(MsUnlock())

						EndIf

					Endif
				Endif

				_aAliSZI := SZI->(GetArea())
				SZI->(dbSetOrder(1))
				If SZI->(dbSeek(xFilial("SZI")+ M->ZH_CLIENTE + M->ZH_LOJA + _cProduto + "L"))
					SZI->(RecLock("SZI",.F.))
					SZI->ZI_LIBER := "B"
					SZI->ZI_DTBLOQ := Date()
					SZI->(MsUnLock())
				Endif
				RestArea(_aAliSZI)

				If !_lLibera .Or. Alltrim(SB1->B1_TIPCAR) $ "CDC"
					SZI->(RecLock("SZI",.F.))
					SZI->ZI_LIBER   := "L"
					SZI->ZI_DTVIGEN := Date()
					SZI->ZI_DTBLOQ  := CTOD("")
					SZI->(MsUnLock())
				Else
					_lBloq := .T.
				Endif
			Endif
		Next

		If _lBloq
			MSGINFO("PRECO BLOQUEADO, FAVOR SOLICITAR LIBERACAO!!!")
		Else
			MSGINFO("PRECO LIBERADO!!!")
		Endif

		If  lSZI
			dbSelectArea("SZH")
			RecLock("SZH",.T.)
			SZH->ZH_FILIAL   := xFilial("SZH")
			SZH->ZH_CLIENTE  := M->ZH_CLIENTE
			SZH->ZH_LOJA     := M->ZH_LOJA
			SZH->ZH_NOME     := M->ZH_NOME
			msUnLock()
		End
	Case lAlterar
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui SZI - Itens tabela de preco                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		_aPrAnt := {}
		dbSelectArea("SZI")
		dbSetOrder(1)
		dbSeek(xFilial("SZI")+M->ZH_CLIENTE+M->ZH_LOJA)
		While !eof() .and. SZI->ZI_FILIAL == xFilial("SZI") ;
			.and. SZI->ZI_CLIENTE == M->ZH_CLIENTE ;
			.and. SZI->ZI_LOJA    == M->ZH_LOJA

			If SZI->ZI_LIBER == "L"
				If ASCAN( _aPrAnt,{|x| x[1] == SZI->ZI_PRODUTO .And. X[2] == SZI->ZI_LIBER }) == 0
					AADD( _aPrAnt,{SZI->ZI_PRODUTO,SZI->ZI_LIBER,SZI->ZI_PRECO,SZI->ZI_PRECOF,SZI->ZI_PRECOD})
				Endif
			Endif

			While ! RecLock("SZI",.F.) ; End
			DbSelectArea("SZI")
			delete
			msUnLock()
			dbSkip()
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava SZI - Itens tabela de precos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SZI")
		lSZI   := .F.
		_lBloq := .F.
		For i := 1 to len(aCols)

			If  ! aCols[i,nUsado+1]
				DbSelectArea("SZI")
				RecLock("SZI",.T.)
				SZI->ZI_FILIAL  := xFilial("SZI")
				SZI->ZI_CODIGO  := _cCodigo
				SZI->ZI_ITEM    := aCols[i,_nPITEM]
				SZI->ZI_CLIENTE := M->ZH_CLIENTE
				SZI->ZI_LOJA    := M->ZH_LOJA
				SZI->ZI_YGRPPRC := aCols[i,_nPGRP]
				SZI->ZI_PRODUTO := aCols[i,_nPROD]
				SZI->ZI_DESC    := aCols[i,_nDESC]
				SZI->ZI_PRECO   := aCols[i,_nPRECO]
				SZI->ZI_DESCON  := aCols[i,_nDESCON]
				SZI->ZI_PRECOF  := aCols[i,_nPRECOF]
				SZI->ZI_DESCONF := aCols[i,_nDESCONF]

				SZI->ZI_PRECOD   := aCols[i,_nPRECOD] // Semar - Juailon 22/01/15 - Preco Cif Descarga.
//				SZI->ZI_DESCCID  := aCols[i,_nDESCDESC] // Semar - Juailon 22/01/15 - Desconto Cif Descarga.

 				SZI->ZI_PGER    := aCols[i,_nPGER]
				SZI->ZI_PRCUNIT := aCols[i,_nPUNIT]
				SZI->ZI_DTBLOQ  := aCols[i,_nPDtBloq]
				SZI->ZI_DTVIGEN := aCols[i,_nPDtVig]
				SZI->ZI_LIBER   := aCols[i,_nPStatus]
				SZI->ZI_USRINC  := aCols[i,_nPUSRINC]
				If SZI->(FieldPos("ZI_USRALT")) > 0			// Normando (Semar) 06/10/2015 - Alteração do usuario
					SZI->ZI_USRALT  := cUserName
				EndIf
				SZI->(MsUnLock())

				If aCols[I,_nPStatus] == "B"
					Loop
				Endif

				lSZI     := .T.
				_cAtivid := ""
				_lLibera := .F.

				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+M->ZH_CLIENTE + M->ZH_LOJA))

				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+aCols[i,_nPROD]))

				_cProduto := aCols[i,_nPROD]
				_lEncont  := .F.

				If Empty(aCols[i,_nPSTATUS]) .And. !Alltrim(SB1->B1_TIPCAR) $ "CDC"

					ZA4->(dbSetOrder(2))
					If ZA4->(!dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA + SA1->A1_MUN))
						If ZA4->(!dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA ))
							If ZA4->(dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD ))
								_lEncont :=.T.
							Endif
						Endif
					Else
						_lEncont :=.T.
					Endif

					_nPos := ASCAN( _aPrAnt,{|x| x[1] == SZI->ZI_PRODUTO .And. X[2] == "L" })

					_lVerPrCif := .F.
					_lVerPrFob := .F.
					_lVerPrCDe := .F.  //Juailson-Semar - Preco Cif Descarga.

					If SZI->ZI_PRECO > 0
						If _nPos > 0
							If SZI->ZI_PRECO < _aPrAnt[_nPos,3]
								_lVerPrCif := .T.
								_lEncont   := .F.
							ElseIf SZI->ZI_PRECO >= _aPrAnt[_nPos,3]
								_lVerPrCif := .F.
								_lEncont   := .F.
							Endif
						ElseIf SZI->ZI_PRECO < ZA4->ZA4_VLMCIF .And. SZI->ZI_PRECO > 0
							_lVerPrCif := .T.
						Endif
					Endif

					If SZI->ZI_PRECOF > 0
						If _nPos > 0
							If SZI->ZI_PRECOF < _aPrAnt[_nPos,4]
								_lVerPrFob := .T.
								_lEncont   := .F.
							ElseIf SZI->ZI_PRECOF >= _aPrAnt[_nPos,4]
								_lVerPrFob := .F.
								_lEncont   := .F.
							Endif
						ElseIf SZI->ZI_PRECOF < ZA4->ZA4_VLMFOB .And. SZI->ZI_PRECOF > 0
							_lVerPrFob := .T.
						Endif
					Endif

					If SZI->ZI_PRECOD > 0     //Juailson Semar - Preco Cif Descarga - 22/01/15
						If _nPos > 0
							If SZI->ZI_PRECOD < _aPrAnt[_nPos,5]
								_lVerPrCDe := .T.
								_lEncont   := .F.
							ElseIf SZI->ZI_PRECOD >= _aPrAnt[_nPos,5]
								_lVerPrCDe := .F.
								_lEncont   := .F.
							Endif
						ElseIf SZI->ZI_PRECOD < ZA4->ZA4_VLMCID .And. SZI->ZI_PRECOD > 0
							_lVerPrCDe := .T.
						Endif
					Endif



					If _lVerPrCIF .Or. _lVerPrFob  .or. _lVerPrCDe
						SCR->(dbOrderNickName("INDSCR5"))
						//If SCR->(dbSeek(xFilial("SCR")+"02"+ SZI->ZI_CODIGO  + SZI->ZI_ITEM + Space(41) + Space(08) ))
						If SCR->(dbSeek(xFilial("SCR")+"02"+ SZI->ZI_CLIENTE + SZI->ZI_LOJA + SZI->ZI_CODIGO  + SZI->ZI_ITEM + Space(33) + Space(08) ))
							_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM + DTOS(SCR->CR_DATALIB)

							ZAH->(dbSetOrder(7))
							If ZAH->(dbSeek(xFilial("ZAH")+ _cChavSCR  ))
								_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
								_cCrTipo  := SCR->CR_TIPO
								_cDocSCR  := SCR->CR_NUM

								_cYCli    := SCR->CR_YCLIENT
								_cYLoja   := SCR->CR_YLOJA
								_cYObra   := SCR->CR_YOBRA
								_cYProd   := SCR->CR_YPRODUT
								_dYDataLib:= SCR->CR_DATALIB

								_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE    ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
								_cCq += " AND ZAH_YCLIEN = '"+_cYCli +"' AND ZAH_YLOJA   = '"+_cYLoja+"' AND ZAH_YOBRA = '"+_cYObra+"' "
								_cCq += " AND ZAH_YPRODU = '"+_cYProd+"' AND ZAH_DATALI  = '"+DTOS(_dYDataLib)+ "' "
								TcSqlExec(_cCq)
							Endif

							While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM + DTOS(SCR->CR_DATALIB)

								SCR->(RecLock("SCR",.F.))
								SCR->(dbDelete())
								SCR->(MsUnlock())

								SCR->(dbSkip())
							EndDo
						Endif

						//_cNum := SZI->ZI_CODIGO  + SZI->ZI_ITEM
						_cNum       := SZI->ZI_CLIENTE + SZI->ZI_LOJA + SZI->ZI_CODIGO  + SZI->ZI_ITEM

						lFirstNiv   := .T.
						cAuxNivel   := ""
						_lLibera    := .T.

						SAL->(dbSetOrder(2))
						If SAL->(dbSeek(xFilial()+_cGrAprov))

							While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD

								If lFirstNiv
									cAuxNivel := SAL->AL_NIVEL
									lFirstNiv := .F.
								EndIf

								SCR->(Reclock("SCR",.T.))
								SCR->CR_FILIAL	:= xFilial("SCR")
								SCR->CR_NUM		:= _cNum
								SCR->CR_TIPO	:= "02"
								SCR->CR_NIVEL	:= SAL->AL_NIVEL
								SCR->CR_USER	:= SAL->AL_USER
								SCR->CR_APROV	:= SAL->AL_APROV
								SCR->CR_STATUS	:= "02"
								SCR->CR_EMISSAO := dDataBase
								SCR->CR_MOEDA	:= 1
								SCR->CR_TXMOEDA := 1
								SCR->CR_OBS     := Alltrim(SM0->M0_NOME) + " - TABELA DE PRECO VENDAS"

								If _lVerPrCIF
									If SZI->ZI_PRECO < ZA4->ZA4_VLMCIF .Or. !_lEncont
										SCR->CR_YREFCIF := ZA4->ZA4_VLMCIF
										SCR->CR_YPRCCIF := SZI->ZI_PRECO
										SCR->CR_TOTAL	:= SZI->ZI_PRECO
									Endif
								Endif

								If _lVerPrFob
									If SZI->ZI_PRECOF < ZA4->ZA4_VLMFOB .Or. !_lEncont
										SCR->CR_YREFFOB := ZA4->ZA4_VLMFOB
										SCR->CR_YPRCFOB := SZI->ZI_PRECOF
										SCR->CR_TOTAL	:= SZI->ZI_PRECOF
									Endif
								Endif

								If _lVerPrCDe  // Juailson-Semar - Preco Cif Descarga - 22/01/15
									If SZI->ZI_PRECOD < ZA4->ZA4_VLMCID .Or. !_lEncont
										SCR->CR_YREFCID := ZA4->ZA4_VLMCID
										SCR->CR_YPRCCID := SZI->ZI_PRECOD
										SCR->CR_TOTAL	:= SZI->ZI_PRECOD
									Endif
								Endif

								If SZI->ZI_PGER   < ZA4->ZA4_VLMGER
									SCR->CR_YREFFOB := ZA4->ZA4_VLMGER
									SCR->CR_YPRCFOB := SZI->ZI_PGER
									SCR->CR_TOTAL	:= SZI->ZI_PGER
								Endif
								SCR->CR_YCLIENT := SZI->ZI_CLIENTE
								SCR->CR_YLOJA   := SZI->ZI_LOJA
								SCR->CR_YPRODUT := SZI->ZI_PRODUTO
								SCR->(MsUnlock())

								ZAH->(RecLock("ZAH",.T.))
								ZAH->ZAH_FILIAL:= SCR->CR_FILIAL
								ZAH->ZAH_NUM   := SCR->CR_NUM
								ZAH->ZAH_TIPO  := SCR->CR_TIPO
								ZAH->ZAH_NIVEL := SCR->CR_NIVEL
								ZAH->ZAH_USER  := SCR->CR_USER
								ZAH->ZAH_APROV := SCR->CR_APROV
								ZAH->ZAH_STATUS:= SCR->CR_STATUS
								ZAH->ZAH_TOTAL := SCR->CR_TOTAL
								ZAH->ZAH_EMISSA:= SCR->CR_EMISSAO
								ZAH->ZAH_MOEDA := SCR->CR_MOEDA
								ZAH->ZAH_TXMOED:= SCR->CR_TXMOEDA
								ZAH->ZAH_OBS   := SCR->CR_OBS
								ZAH->ZAH_YREFCI:= SCR->CR_YREFCIF
								ZAH->ZAH_YPRCCI:= SCR->CR_YPRCCIF
							    ZAH->ZAH_YREFCD := SCR->CR_YREFCID //Ref Cif Descarga - Juailson Semar 06/02/15
                                ZAH->ZAH_YPRCCD := SCR->CR_YPRCCID // Preco Cif Descarga -  Juailson Semar 06/02/15
								ZAH->ZAH_TOTAL := SCR->CR_TOTAL
								ZAH->ZAH_YREFFO:= SCR->CR_YREFFOB
								ZAH->ZAH_YPRCFO:= SCR->CR_YPRCFOB
								ZAH->ZAH_YREFGE:= SCR->CR_YREFGER
								ZAH->ZAH_YPRCGE:= SCR->CR_YPRCGER
								ZAH->ZAH_YCLIEN:= SCR->CR_YCLIENT
								ZAH->ZAH_YLOJA := SCR->CR_YLOJA
								ZAH->ZAH_YPRODU:= SCR->CR_YPRODUT
								ZAH->ZAH_YOBRA := SCR->CR_YOBRA
								ZAH->ZAH_YCODTA:= SCR->CR_YCODTAB
								ZAH->ZAH_YFORNE:= SCR->CR_YFORNEC
								ZAH->ZAH_YLOJFO:= SCR->CR_YLOJFOR
								ZAH->(MsUnlock())

								SAL->(dbSkip())
							EndDo

							SZI->(RecLock("SZI",.F.))
							SZI->ZI_CODBKP := _cNum
							SZI->(MsUnlock())

						EndIf
					Else
						SCR->(dbOrderNickName("INDSCR5"))
						//If SCR->(dbSeek(xFilial("SCR")+"02"+ SZI->ZI_CODIGO  + SZI->ZI_ITEM + Space(41) + Space(08) ))
						If SCR->(dbSeek(xFilial("SCR")+"02"+ SZI->ZI_CLIENTE + SZI->ZI_LOJA + SZI->ZI_CODIGO  + SZI->ZI_ITEM + Space(33) + Space(08) ))
							_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM + DTOS(SCR->CR_DATALIB)

							ZAH->(dbSetOrder(7))
							If ZAH->(dbSeek(xFilial("ZAH")+ _cChavSCR  ))
								_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
								_cCrTipo  := SCR->CR_TIPO
								_cDocSCR  := SCR->CR_NUM

								_cYCli    := SCR->CR_YCLIENT
								_cYLoja   := SCR->CR_YLOJA
								_cYObra   := SCR->CR_YOBRA
								_cYProd   := SCR->CR_YPRODUT
								_dYDataLib:= SCR->CR_DATALIB

								_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE    ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
								_cCq += " AND ZAH_YCLIEN = '"+_cYCli +"' AND ZAH_YLOJA   = '"+_cYLoja+"' AND ZAH_YOBRA = '"+_cYObra+"' "
								_cCq += " AND ZAH_YPRODU = '"+_cYProd+"' AND ZAH_DATALI  = '"+DTOS(_dYDataLib)+ "' "

								TcSqlExec(_cCq)
							Endif

							//While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_YCLIENT + SCR->CR_YLOJA + SCR->CR_YPRODUT + SCR->CR_YOBRA + DTOS(SCR->CR_DATALIB)
							While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM + DTOS(SCR->CR_DATALIB)

								SCR->(RecLock("SCR",.F.))
								SCR->(dbDelete())
								SCR->(MsUnlock())

								SCR->(dbSkip())

							EndDo
						Endif
					Endif
				Endif

				_aAliSZI := SZI->(GetArea())
				SZI->(dbSetOrder(1))
				If SZI->(dbSeek(xFilial("SZI")+ M->ZH_CLIENTE + M->ZH_LOJA + _cProduto + "L"))
					SZI->(RecLock("SZI",.F.))
					SZI->ZI_LIBER := "B"
					SZI->ZI_DTBLOQ := Date()
					SZI->(MsUnLock())
				Endif
				RestArea(_aAliSZI)

				If !_lLibera .Or. Alltrim(SB1->B1_TIPCAR) $ "CDC"
					SZI->(RecLock("SZI",.F.))
					SZI->ZI_LIBER   := "L"
					SZI->ZI_DTVIGEN := Date()
					SZI->ZI_DTBLOQ  := CTOD("")
					SZI->(MsUnLock())
				Else
					_lBloq := .T.
				Endif
			Endif
		Next

		If _lBloq
			MSGINFO("PRECO BLOQUEADO, FAVOR SOLICITAR LIBERACAO!!!")
		Else
			MSGINFO("PRECO LIBERADO!!!")
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava SZH - CAB. TABELA DE PRECOS                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SZH")
		While ! RecLock("SZH",.F.) ; End
		SZH->ZH_FILIAL  := xFilial("SZH")
		SZH->ZH_CLIENTE := M->ZH_CLIENTE
		SZH->ZH_LOJA    := M->ZH_LOJA
		SZH->ZH_NOME    := M->ZH_NOME
		msUnLock()
	Case lExcluir
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui SZI - Itens da tabela de precos                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SZI")
		dbSetOrder(1)
		dbSeek(xFilial("SZI")+M->ZH_CLIENTE+M->ZH_LOJA)
		While !eof() .and. SZI->ZI_FILIAL    == xFilial("SZI") ;
			.and.  SZI->ZI_CLIENTE   == M->ZH_CLIENTE ;
			.and.  SZI->ZI_LOJA      == M->ZH_LOJA
			While ! RecLock("SZI",.F.) ; End
			DbSelectArea("SZI")
			delete
			msUnLock()
			dbSkip()
		End
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui SZH - Cabecalho tabela de precos                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SZH")
		While ! RecLock("SZH",.F.) ; End
		delete
		msUnLock()
EndCase
//dbCommitAll()

Return

User Function MIZ826L()

SetPrvt("LOK,WPRODUTO,WI,")

lOk := .T.

_nPProd   := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_PRODUTO"} )
_nPSTAT   := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_LIBER"})

_aVerDup  := {}

For AX := 1 to Len(aCols)

	_cProduto := Acols[AX,_nPPROD]
	_cStatus  := Acols[AX,_nPSTAT]

	_cFim := (Len(aHeader)+1)
	If aCols[AX,_cFim]
		If !Empty(_cProduto)
			MSGSTOP("LINHA NAO PODE SER DELETADA!!")
			lOK := .F.
		Endif
	Else
		If _cStatus $ "B/L"
			Loop
		Endif

		If ASCAN( _aVerDup,{|x| x[1] == _cProduto .And. X[2] = _cStatus }) == 0
			AADD( _aVerDup,{_cProduto,_cStatus})
		Else
			AX  := AX
			MSGSTOP(" Produto Ja lançado!!!")
			lOK := .F.
		Endif
	Endif
Next

Return(lOk)


User Function MIZ826T()


Return(.T.)


User Function MIZ826A()

Local _cIt   := "000"
Local _cItem := "000"

_aALiOri  := GetArea()
_aALiSB1  := SB1->(GetArea())

_cProduto := Acols[N,_NPROD]

SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+M->ZH_CLIENTE + M->ZH_LOJA))

SB1->(dbSetOrder(1))
If SB1->(dbSeek(xFilial("SB1") + _cProduto))
	If Alltrim(SB1->B1_TIPCAR) $ "CDC" .And. SA1->A1_RISCO != "S"
		_cProduto       := Space(15)
		Acols[N,_nDESC] := Space(40)
	Else
		Acols[N,_nDESC] := SB1->B1_DESC
	Endif
Endif

_cIt := "000"
For AX := 1 to Len(aCols)

	_cItem    := Acols[AX,_nPITEM]

	_cFim := (Len(aHeader)+1)
	If !aCols[AX,_cFim]
		If _cItem > _cIt
			_cIt  := Acols[AX,_nPITEM]
		Endif

		If Empty(_cItem)
			Acols[AX,_nPITEM] := Soma1(_cIt)
		Endif
	Endif

Next AX
RestArea(_aAliSB1)
RestArea(_aAliOri)

Return(_cProduto)



User Function MIZ826B()

Local cTitulo:=""
Local MvPar
Local MvParDef:=""

Private aSit:={}

MvPar:=&(Alltrim(ReadVar()))
mvRet:=Alltrim(ReadVar())

Aadd(aSit,"1" + " - " + "Consumidor final")
Aadd(aSit,"2" + " - " + "Solidario")

MvParDef:= "12"

IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,.F.)
	&MvRet := mvpar
EndIF

Return(.T.)


Static Function MIZ826C(_lAcres,_lPerc,_lAlinha)

_cQ:= " SELECT MAX(ZI_ITEM) AS ITEM FROM "+RetSqlName("SZI")+" A WHERE A.D_E_L_E_T_ = '' AND ZI_CLIENTE = '"+ZZ->ZI_CLIENTE+"' AND ZI_LOJA = '"+ZZ->ZI_LOJA+" '"
_cQ+= " ZI_PRODUTO = '"+ZZ->ZI_PRODUTO+"' AND ZI_FILIAL = '"+ZZ->ZI_FILIAL+" ' "

TCQUERY cQ NEW ALIAS "ZZ2"

_cItem2:= Soma1(ZZ2->ITEM)

ZZ2->(dbCloseArea())

SZI->(RecLock("SZI",.T.))
SZI->ZI_FILIAL  := ZZ->ZI_FILIAL
SZI->ZI_CLIENTE := ZZ->ZI_CLIENTE
SZI->ZI_LOJA    := ZZ->ZI_LOJA
SZI->ZI_PRODUTO := ZZ->ZI_PRODUTO
SZI->ZI_DESC    := ZZ->ZI_DESC
If _lAcres
	If _lPerc
		SZI->ZI_PRECO   := ZZ->ZI_PRECO   + (ZZ->ZI_PRECO   * (_nPerc/100) )
		SZI->ZI_PRECOF  := ZZ->ZI_PRECOF  + (ZZ->ZI_PRECOF  * (_nPerc/100) )
		SZI->ZI_PRECOD  := ZZ->ZI_PRECOD  + (ZZ->ZI_PRECOD  * (_nPerc/100) ) // Juailson-Semar - Preco Cif Descarga 22/01/15
		SZI->ZI_PGER    := ZZ->ZI_PGER    + (ZZ->ZI_PGER    * (_nPerc/100) )
		SZI->ZI_PRCUNIT := ZZ->ZI_PRCUNIT + (ZZ->ZI_PRCUNIT * (_nPerc/100) )
	Else
		SZI->ZI_PRECO   := ZZ->ZI_PRECO   + _nValCIF
		SZI->ZI_PRECOF  := ZZ->ZI_PRECOF  + _nValFOB
		SZI->ZI_PRECOD  := ZZ->ZI_PRECOD  + _nValCID  // Juailson-Semar - Preco Cif Descarga 22/01/15
		SZI->ZI_PGER    := ZZ->ZI_PGER    + _nValGer
		SZI->ZI_PRCUNIT := ZZ->ZI_PRCUNIT + _nValPru
	Endif
ElseIf !_lAcres .and. !_lAlinha
	If _lPerc
		If ZZ->ZI_PRECO > 0
			SZI->ZI_PRECO   := ZZ->ZI_PRECO   - (ZZ->ZI_PRECO   * (_nPerc/100) )
		Endif
		If ZZ->ZI_PRECOF > 0
			SZI->ZI_PRECOF  := ZZ->ZI_PRECOF  - (ZZ->ZI_PRECOF  * (_nPerc/100) )

		If ZZ->ZI_PRECOD > 0 // Juailson-Semar - Preco Cif Descarga 22/01/15
			SZI->ZI_PRECOD   := ZZ->ZI_PRECOD   - (ZZ->ZI_PRECOD   * (_nPerc/100) )
		Endif

		Endif
		If ZZ->ZI_PGER > 0
			SZI->ZI_PGER    := ZZ->ZI_PGER    - (ZZ->ZI_PGER    * (_nPerc/100) )
		Endif
		If SZI->ZI_PRCUNIT > 0
			SZI->ZI_PRCUNIT := ZZ->ZI_PRCUNIT - (ZZ->ZI_PRCUNIT * (_nPerc/100) )
		Endif
	Else
		If ZZ->ZI_PRECO > 0
			SZI->ZI_PRECO   := ZZ->ZI_PRECO   - _nValCIF
		Endif

		If ZZ->ZI_PRECOF > 0
			SZI->ZI_PRECOF  := ZZ->ZI_PRECOF  - _nValFOB
		Endif

		If ZZ->ZI_PRECOD > 0 // Juailson-Semar - Preco Cif Descarga 22/01/15
			SZI->ZI_PRECOD   := ZZ->ZI_PRECOD   - _nValCID
		Endif

		If ZZ->ZI_PGER > 0
			SZI->ZI_PGER    := ZZ->ZI_PGER    - _nValGer
		Endif

		If SZI->ZI_PRCUNIT > 0
			SZI->ZI_PRCUNIT := ZZ->ZI_PRCUNIT - _nValPru
		Endif
	Endif
	//Adicionado por Rodrigo Feitosa (Semar) - 01/10/13
ElseIf _lAlinha
	SZI->ZI_PRECO		:= if(_nValCIF > 0, _nValCIF, ZZ->ZI_PRCUNIT)
	SZI->ZI_PRECOF		:= if(_nValFOB > 0, _nValFOB, ZZ->ZI_PRECOF)
	SZI->ZI_PRECOD		:= if(_nValCID > 0, _nValCID, ZZ->ZI_PRCUNIT) // Juailson-Semar - Preco Cif Descarga 22/01/15 -??? Porque não usou ZI_PRECO em vez de ZI_PRCUNIT
	SZI->ZI_PGER		:= if(_nValGER > 0, _nValGER, ZZ->ZI_PGER)
	SZI->ZI_PRCUNIT	:= if(_nValPrU > 0, _nValPrU, ZZ->ZI_PRCUNIT)
Endif

SZI->ZI_DESCON  := ZZ->ZI_DESCON
SZI->ZI_DESCONF := ZZ->ZI_DESCONF
SZI->ZI_DTVIGEN := Date()
SZI->ZI_USRINC  := cUsername
SZI->ZI_USRALT  := " " // Normando (Semar) 06/10/2015 - Alteração do usuario
SZI->ZI_ITEM    := _cItem2
SZI->(MsUnLock())

SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+ SZI->ZI_CLIENTE + SZI->ZI_LOJA))

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+ SZI->ZI_PRODUTO))

_cProduto := SZI->ZI_PRODUTO
_lEncont  := .F.

If !Alltrim(SB1->B1_TIPCAR) $ "CDC"

	ZA4->(dbSetOrder(2))
	If ZA4->(!dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA + SA1->A1_MUN))
		If ZA4->(!dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA ))
			If ZA4->(dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD ))
				_lEncont :=.T.
			Endif
		Endif
	Else
		_lEncont :=.T.
	Endif

	_lVerPrCif := .F.
	_lVerPrFob := .F.
	_lVerPrCDe := .F.

	If SZI->ZI_PRECO < ZA4->ZA4_VLMCIF .And. SZI->ZI_PRECO > 0
		_lVerPrCif := .T.
	Endif

	If SZI->ZI_PRECOF < ZA4->ZA4_VLMFOB .And. SZI->ZI_PRECOF > 0
		_lVerPrFob := .T.
	Endif

	If SZI->ZI_PRECOD < ZA4->ZA4_VLMCID .And. SZI->ZI_PRECOD > 0 // Juailson-Semar - Preco Cif Descarga 22/01/15
		_lVerPrCDe := .T.
	Endif


	If _lVerPrCIF .Or. _lVerPrFob .Or. _lVerPrCDe
	   /*
		_cQ := " SELECT MAX(CR_NUM) AS CR_NUM FROM "+RetSqlName("SCR")+" WHERE D_E_L_E_T_ = '' "
		_cQ += " AND CR_FILIAL = '"+xFilial("SCR")+"' AND CR_TIPO = '02' "

		TCQUERY _cQ NEW ALIAS "ZZ2"

		If Empty(ZZ2->CR_NUM)
			_cNum := "000001"
		Else
			//_cNum := StrZero(Val(ZZ2->CR_NUM)+1,6)
			//Adicionado por Rodrigo Feitosa (Semar) - 27/09/13
			_cNum := GETSXENUM("SCR","CR_NUM")
			ConfirmSX8()
			//
		Endif

		ZZ2->(dbCloseArea())
		*/
		If Empty(SZI->ZI_CODIGO)
			_cCodigo    := GetSxeNum("SZI","ZI_CODIGO")
			ConfirmSX8()
		Else
			_cCodigo    := SZI->ZI_CODIGO
		Endif

		//_cNum       := SZI->ZI_CODIGO  + SZI->ZI_ITEM

		_cNum       := SZI->ZI_CLIENTE + SZI->ZI_LOJA + SZI->ZI_CODIGO  + SZI->ZI_ITEM
		lFirstNiv   := .T.
		cAuxNivel   := ""
		_lLibera    := .T.

		SAL->(dbSetOrder(2))
		If SAL->(dbSeek(xFilial()+_cGrAprov))

			While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD

				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf

				SCR->(Reclock("SCR",.T.))
				SCR->CR_FILIAL	:= xFilial("SCR")
				SCR->CR_NUM		:= _cNum
				SCR->CR_TIPO	:= "02"
				SCR->CR_NIVEL	:= SAL->AL_NIVEL
				SCR->CR_USER	:= SAL->AL_USER
				SCR->CR_APROV	:= SAL->AL_APROV
				SCR->CR_STATUS	:= "02"
				SCR->CR_EMISSAO := dDataBase
				SCR->CR_MOEDA	:= 1
				SCR->CR_TXMOEDA := 1
				SCR->CR_OBS     := Alltrim(SM0->M0_NOME) + " - TABELA DE PRECO VENDAS"

				If _lVerPrCIF
					If SZI->ZI_PRECO < ZA4->ZA4_VLMCIF .Or. !_lEncont
						SCR->CR_YREFCIF := ZA4->ZA4_VLMCIF
						SCR->CR_YPRCCIF := SZI->ZI_PRECO
						SCR->CR_TOTAL	:= SZI->ZI_PRECO
					Endif
				Endif

				If _lVerPrFob
					If SZI->ZI_PRECOF < ZA4->ZA4_VLMFOB .Or. !_lEncont
						SCR->CR_YREFFOB := ZA4->ZA4_VLMFOB
						SCR->CR_YPRCFOB := SZI->ZI_PRECOF
						SCR->CR_TOTAL	:= SZI->ZI_PRECOF
					Endif
				Endif


				If _lVerPrCID // Juailson-Semar - Preco Cif Descarga 22/01/15
					If SZI->ZI_PRECOD < ZA4->ZA4_VLMCID .Or. !_lEncont
						SCR->CR_YREFCID := ZA4->ZA4_VLMCID
						SCR->CR_YPRCCID := SZI->ZI_PRECOD
						SCR->CR_TOTAL	:= SZI->ZI_PRECOD
					Endif
				Endif

				If SZI->ZI_PGER   < ZA4->ZA4_VLMGER
					SCR->CR_YREFFOB := ZA4->ZA4_VLMGER
					SCR->CR_YPRCFOB := SZI->ZI_PGER
					SCR->CR_TOTAL	:= SZI->ZI_PGER
				Endif

				SCR->CR_YCLIENT := SZI->ZI_CLIENTE
				SCR->CR_YLOJA   := SZI->ZI_LOJA
				SCR->CR_YPRODUT := SZI->ZI_PRODUTO
				SCR->(MsUnlock())

				ZAH->(RecLock("ZAH",.T.))
				ZAH->ZAH_FILIAL:= SCR->CR_FILIAL
				ZAH->ZAH_NUM   := SCR->CR_NUM
				ZAH->ZAH_TIPO  := SCR->CR_TIPO
				ZAH->ZAH_NIVEL := SCR->CR_NIVEL
				ZAH->ZAH_USER  := SCR->CR_USER
				ZAH->ZAH_APROV := SCR->CR_APROV
				ZAH->ZAH_STATUS:= SCR->CR_STATUS
				ZAH->ZAH_TOTAL := SCR->CR_TOTAL
				ZAH->ZAH_EMISSA:= SCR->CR_EMISSAO
				ZAH->ZAH_MOEDA := SCR->CR_MOEDA
				ZAH->ZAH_TXMOED:= SCR->CR_TXMOEDA
				ZAH->ZAH_OBS   := SCR->CR_OBS

				ZAH->ZAH_YREFCI:= SCR->CR_YREFCIF
				ZAH->ZAH_YPRCCI:= SCR->CR_YPRCCIF

				ZAH->ZAH_TOTAL := SCR->CR_TOTAL
				ZAH->ZAH_YREFFO:= SCR->CR_YREFFOB
				ZAH->ZAH_YPRCFO:= SCR->CR_YPRCFOB
				ZAH->ZAH_YREFCD:= SCR->CR_YREFCID  //Juailson-Semar -  ref Preco Cif Descarga 22/01/15
				ZAH->ZAH_YPRCCD:= SCR->CR_YPRCCID  //Juailson-Semar -  prc Preco Cif Descarga

				ZAH->ZAH_YREFGE:= SCR->CR_YREFGER
				ZAH->ZAH_YPRCGE:= SCR->CR_YPRCGER
				ZAH->ZAH_YCLIEN:= SCR->CR_YCLIENT
				ZAH->ZAH_YLOJA := SCR->CR_YLOJA
				ZAH->ZAH_YPRODU:= SCR->CR_YPRODUT
				ZAH->ZAH_YOBRA := SCR->CR_YOBRA
				ZAH->ZAH_YCODTA:= SCR->CR_YCODTAB
				ZAH->ZAH_YFORNE:= SCR->CR_YFORNEC
				ZAH->ZAH_YLOJFO:= SCR->CR_YLOJFOR
				ZAH->(MsUnlock())

				SAL->(dbSkip())
			EndDo
		EndIf
	Endif
Endif

Return {SZI->(Recno()),_lVerPrCIF .Or. _lVerPrFob}


Static Function ATUSX1()

cPerg := "MIZ826"

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid       /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02      /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Cliente De           	?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""          ,"MV_PAR01","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"CLI")
U_CRIASX1(cPerg,"02","Cliente Ate          	?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""          ,"MV_PAR02","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"CLI")
U_CRIASX1(cPerg,"03","Loja    De           	?",""       ,""      ,"mv_ch3","C" ,02     ,0      ,0     ,"G",""          ,"MV_PAR03","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"04","Loja    Ate          	?",""       ,""      ,"mv_ch4","C" ,02     ,0      ,0     ,"G",""          ,"MV_PAR04","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"05","Estado  De           	?",""       ,""      ,"mv_ch5","C" ,02     ,0      ,0     ,"G",""          ,"MV_PAR05","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"12")
U_CRIASX1(cPerg,"06","Estado  Ate          	?",""       ,""      ,"mv_ch6","C" ,02     ,0      ,0     ,"G",""          ,"MV_PAR06","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"12")
U_CRIASX1(cPerg,"07","Municipio De         	?",""       ,""      ,"mv_ch7","C" ,35     ,0      ,0     ,"G",""          ,"MV_PAR07","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"CC2SX1")
U_CRIASX1(cPerg,"08","Municipio Ate        	?",""       ,""      ,"mv_ch8","C" ,35     ,0      ,0     ,"G",""          ,"MV_PAR08","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"CC2SX1")
U_CRIASX1(cPerg,"09","Produto   De         	?",""       ,""      ,"mv_ch9","C" ,15     ,0      ,0     ,"G",""          ,"MV_PAR09","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SB1")
U_CRIASX1(cPerg,"10","Produto   Ate        	?",""       ,""      ,"mv_chA","C" ,15     ,0      ,0     ,"G",""          ,"MV_PAR10","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SB1")
U_CRIASX1(cPerg,"11","Filial    De         	?",""       ,""      ,"mv_chb","C" ,02     ,0      ,0     ,"G",""          ,"MV_PAR11","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SM0")
U_CRIASX1(cPerg,"12","Filial    Ate        	?",""       ,""      ,"mv_chc","C" ,02     ,0      ,0     ,"G",""          ,"MV_PAR12","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SM0")
//U_CRIASX1(cPerg,"13","Modo                 	?",""       ,""      ,"mv_chD","N" ,01     ,0      ,0     ,"C",""          ,"MV_PAR13","Decrescimo" ,""     ,""     ,""   ,""   ,"Acrescimo",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
//Alterado por Rodrigo Feitosa (semar) - 01/10/13
U_CRIASX1(cPerg,"13","Modo                 	?",""       ,""      ,"mv_chD","N" ,01     ,0      ,0     ,"C",""          ,"MV_PAR13","Decrescimo" ,""     ,""     ,""   ,""   ,"Acrescimo",""     ,""     ,""   ,""   ,"Alinhamento"     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"14","Tipo Reajuste        	?",""       ,""      ,"mv_chF","N" ,01     ,0      ,0     ,"C",""          ,"MV_PAR14","Percentual" ,""     ,""     ,""   ,""   ,"Valor    ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"15","Percentual %         	?",""       ,""      ,"mv_chG","N" ,05     ,2      ,0     ,"G",""          ,"MV_PAR15","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"16","Preco CIF            	?",""       ,""      ,"mv_chG","N" ,10     ,2      ,0     ,"G",""          ,"MV_PAR16","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"17","Preco FOB            	?",""       ,""      ,"mv_chH","N" ,10     ,2      ,0     ,"G",""          ,"MV_PAR17","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"18","Preco Gerencial      	?",""       ,""      ,"mv_chI","N" ,10     ,2      ,0     ,"G",""          ,"MV_PAR18","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"19","Preco Unitario       	?",""       ,""      ,"mv_chJ","N" ,10     ,2      ,0     ,"G",""          ,"MV_PAR19","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
//Adicionnado por Juailson-Semar - 22/01/15 - Preco Cif Descarga
U_CRIASX1(cPerg,"20","Preco CIF Descarga  	?",""       ,""      ,"mv_chL","N" ,10     ,2      ,0     ,"G",""          ,"MV_PAR20","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

//U_CRIASX1(cPerg,"11","Tipo Cliente         	?",""       ,""      ,"mv_chb","C" ,15     ,0      ,0     ,"G","U_MZ826B()","MV_PAR11","          " ,""     ,""     ,""   ,""   ,"         ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
Return

Static function MIZ826D(nRecno,lBloq)

Local wArea := getArea()

if !lBloq
	DbSelectArea("SZI")
	DbSetOrder(1)
	DbGoTo(nRecno)
	if MsSeek(xFilial("SZI")+SZI->ZI_CLIENTE+SZI->ZI_LOJA+SZI->ZI_PRODUTO+"L")
		SZI->(RecLock("SZI",.F.))
		SZI->ZI_LIBER := "B"
		SZI->ZI_DTBLOQ := Date()
		SZI->(MsUnLock())
	endif
	DbGoTo(nRecno)
	SZI->(RecLock("SZI",.F.))
	SZI->ZI_LIBER  := "L"
	SZI->ZI_DTVIGEN:= Date()
	SZI->ZI_USRLIB := Substr(cUsuario,7,15)
	SZI->(MsUnLock())
endif

restArea(wArea)
return

//
Static Function PergRest()
_sAlias := getArea()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg2 := PadR(cPerg2,10)

aRegs:={}
//1     2     3        4        5    6       7       8      9   10    11
//Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3
//          1     2    3                              4       5   6  7 8  9  10
aAdd(aRegs,{cPerg2,"01","Mostrar os Registros:","","","mv_ch1","C",01,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","ZZC1",""})


For i:=1 to Len(aRegs)
    If !dbSeek(cPerg2+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
restArea(_sAlias)
Return


