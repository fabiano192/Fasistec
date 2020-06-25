#include "rwmake.ch"
#XCommand ROLLBACK TRANSACTION => DisarmTransaction()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ MIZ745   ³ Autor ³ Nilton Cesar          ³ Data ³ 09.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Cadastro itens DO CTR                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RDMAKE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MIZ745()

SetPrvt("WOPCAO,LVISUALIZAR,LINCLUIR,LALTERAR,LEXCLUIR,NOPCE")
SetPrvt("NOPCG,COPCAO,NUSADO,AHEADER,ACOLS,I")
SetPrvt("WFILIAL,M->ZB_NUM,M->Z1_NUM,CTITULO,CALIASENCHOICE,CALIASGETD")
SetPrvt("CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE,LRET.wEstado,wPICMS,_nCF,wCodigo,")
Private _nnota,_nqte,_nvalunit,_nvaltot,_numseq,_nitem,aArea2, cCondPg:= 0

wOpcao      := paramixb
lVisualizar := .F.     

lIncluir    := .F.
lAlterar    := .F.
lExcluir    := .F.
Do Case
	Case wOpcao == "V" ; lVisualizar := .T. ; nOpcE := 2 ; nOpcG := 2 ; cOpcao := "VISUALIZAR"
	Case wOpcao == "I" ; lIncluir    := .T. ; nOpcE := 3 ; nOpcG := 3 ; cOpcao := "INCLUIR"
	Case wOpcao == "E"
		lExcluir    := .T.
		nOpcE := 3
		nOpcG := 3
		cOpcao := "EXCLUIR"
		
		If SZB->ZB_DTDIGIT <= GetMV("MV_DATAFIS")
			MsgBox("Atencao, o periodo ja foi fechado pelo Fiscal. Contactar Contabilidade","Atencao","ALERT")
			Return
		EndIf
		
EndCase

RegToMemory("SZB",(cOpcao=="INCLUIR"))

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZC")
nUsado  := 0
aHeader := {}
While !eof() .and. SX3->X3_ARQUIVO == "SZC"
	If  alltrim(SX3->X3_CAMPO) $ "ZC_NUM,ZC_FORNECE,ZC_LOJA,ZC_SERCTR"
		dbSkip()
		Loop
	End
	If  X3USO(SX3->X3_USADO) .and. SX3->X3_NIVEL <= cNivel
		nUsado := nUsado + 1
		aadd(aHeader,{ trim(SX3->X3_TITULO),SX3->X3_CAMPO   , ;
		SX3->X3_PICTURE     ,SX3->X3_TAMANHO , ;
		SX3->X3_DECIMAL     ,"AllwaysTrue()" , ;
		SX3->X3_USADO       ,SX3->X3_TIPO    , ;
		SX3->X3_ARQUIVO     ,SX3->X3_CONTEXT } )
	End
	
	dbSkip()
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aCols                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  lIncluir
	aCols             := {array(nUsado+1)}
	aCols[1,nUsado+1] := .F.
	For i := 1 to nUsado
		aCols[1,i] := CriaVar(aHeader[i,2])
	Next
Else
	aCols:={}
	dbSelectArea("SZC")
	dbSetOrder(4)
	dbSeek(xFilial("SZC")+M->ZB_NUM+M->ZB_SERIE+M->ZB_FORNECE+M->ZB_LOJA)
	While !eof() .and. SZC->ZC_FILIAL  == xFilial("SZC") ;
		.and. SZC->ZC_NUM     == M->ZB_NUM ;
		.and. SZC->ZC_SERCTR  == M->ZB_SERIE;
		.and. SZC->ZC_FORNECE == M->ZB_FORNECE ;
		.and. SZC->ZC_LOJA    == M->ZB_LOJA
		aadd(aCols,array(nUsado+1))
		For i := 1 to nUsado
			aCols[len(aCols),i]    := FieldGet(FieldPos(aHeader[i,2]))
		Next
		aCols[len(aCols),nUsado+1] := .F.
		dbSkip()
	End
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo        := "Cadastro de Conhecimento de Fretes"
cAliasEnchoice := "SZB"
cAliasGetD     := "SZC"
cLinOk         := 'execblock("MIZ745L",.F.,.F.,)'
cTudOk         := 'execblock("MIZ745T",.F.,.F.,)'
cFieldOk       := "AllwaysTrue()"
aCpoEnchoice   := {"ZB_NUM","ZB_FORNECE","ZB_LOJA","ZB_SERIE"}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa funcao modelo 3                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa processamento                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  lRet
	fProcessa()
End

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
Local cparc:="ABCDEFGHIJKLMNOPQRSTUVXZ"

cli_aux  :=''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Determina posicao dos campos no aCols                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nserie   := aScan(aHeader,{|x| x[2]=="ZC_SERIE  "})
_nnota    := aScan(aHeader,{|x| x[2]=="ZC_NOTA   "})
_nqte     := aScan(aHeader,{|x| x[2]=="ZC_QTE    "})
_nvalunit := aScan(aHeader,{|x| x[2]=="ZC_VALUNIT"})
_nvaltot  := aScan(aHeader,{|x| x[2]=="ZC_VALTOT "})
_nemissao := aScan(aHeader,{|x| x[2]=="ZC_EMISSAO"})
_nTES     := aScan(aHeader,{|x| x[2]=="ZC_TES    "})
_nPedagio := aScan(aHeader,{|x| x[2]=="ZC_PEDAGIO"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica funcao utilizada                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aTransac:={} /// var. utilizara pra confirmação de deleção

Begin transaction


Do Case
	Case lIncluir
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava SZC - Itens CTR                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xfilial("SA2")+M->ZB_FORNECE+M->ZB_LOJA))

		SE2->(dbSetOrder(6))
		If SE2->(dbSeek(xFilial("SE2")+M->ZB_FORNECE+M->ZB_LOJA+M->ZB_SERIE+PADR(M->ZB_NUM,9)))
			MsgBox("Nota Fiscal Ja Cadastrada Para Esse Fornecedor")
			Return
		EndIf		
		
		IF SA2->A2_YFORCTR <> "S"
			MsgBox("O fornecedor:[ "+SA2->A2_COD+' - '+Alltrim(SA2->A2_NOME)+" ]. "+Chr(13)+Chr(10)+;
			"Não está cadastrado como fornecedor de transporte"+Chr(13)+Chr(10)+;
			"Solicitar ao responsável pelo setor acertar o campo: 'Forn CTR'","Atencao","STOP")
			Return
		EndIf
	
		dbSelectArea("SZC")
		lSZC  := .F.
		nsoma :=0
		For i := 1 to len(aCols)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o item foi deletado                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If  ! aCols[i,nUsado+1]
				DbSelectArea("SZC")
				RecLock("SZC",.T.)
				SD2->(dbSetOrder(3))
				SD2->(dbSeek(xFilial("SD2")+PADR(aCols[i,_nnota],9)+aCols[i,_nserie]))
				
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
				
				SX5->(dbSetOrder(1))
				SX5->(dbSeek(xFilial("SX5")+"Z7"+SB1->B1_TIPCAR))
				
				SA5->(dbsetOrder(1))
				SA5->(dbSeek(xFilial("SA5")+M->ZB_FORNECE+M->ZB_LOJA+SX5->X5_DESCRI))
				
				If Empty(SA5->A5_YCONDPG)
					MsgInfo("O fornecedor: [ "+SA5->A5_FORNECE+' - '+Alltrim(SA5->A5_NOMEFOR)+" ]. "+Chr(13)+Chr(10)+;
					"Nao tem condicao de pagamento cadastrada para este produto ("+SA5->A5_PRODUTO+"). Favor cadastrar em Produto X Fornecedor!")
					ROLLBACK TRANSACTION
					dbCommitAll()
					

					Return
				Endif
				 // Incluido por Gustavo Hand Strey em 14/07/11 a pedido do Sr Claudio Pereira
				if  SD2->D2_EMISSAO > M->ZB_EMISSAO
					MsgInfo("Data de Emissao do CTR esta menor que a Data de Emissao da NF. Favor Corrigir!")
					ROLLBACK TRANSACTION
					dbCommitAll()
				//	End Transaction

					Return
				endif
				 // Fim
				SZC->ZC_FILIAL  := xFilial("SZC")
				SZC->ZC_NUM     := M->ZB_NUM
				SZC->ZC_FORNECE := M->ZB_FORNECE
				SZC->ZC_LOJA    := M->ZB_LOJA
				SZC->ZC_SERIE   := aCols[i,_nserie]
				SZC->ZC_NOTA    := aCols[i,_nnota]
				SZC->ZC_QTE     := aCols[i,_nqte]
				SZC->ZC_TES     := aCols[i,_nTES]
				SZC->ZC_VALUNIT := aCols[i,_nvalunit]
				SZC->ZC_VALTOT  := aCols[i,_nvaltot]
				SZC->ZC_EMISSAO := aCols[i,_nemissao]
				SZC->ZC_DTDIGIT := dDataBase
				SZC->ZC_PEDAGIO := aCols[i,_npedagio]
				SZC->ZC_SERCTR  := M->ZB_SERIE
				nsoma +=SZC->ZC_VALTOT + aCols[i,_npedagio]
				msUnLock()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gravar numero do CTR no cabecalho da NF de saida                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SF2")
				DbSetOrder(1)
				If DbSeek(xFilial("SF2")+PADR(SZC->ZC_NOTA,9)+SZC->ZC_SERIE)
					While !RecLock("SF2",.F.) ; EndDo
					SF2->F2_YCTR   := M->ZB_NUM
					SF2->F2_YSERCTR:= M->ZB_SERIE
					SF2->F2_YFCTR  := M->ZB_FORNECE
					SF2->F2_YLCTR  := M->ZB_LOJA
					SF2->F2_YPEDAG := aCols[i,_npedagio]
					cli_aux  := SF2->F2_CLIENTE+SF2->F2_LOJA
					MsUnlock()
				EndIf
				SD2->(DbSetOrder(3))//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
				SD2->(DbSeek(xFilial("SD2")+PADR(SZC->ZC_NOTA,9)+SZC->ZC_SERIE))
				
				/*   ALTERADO EM 07/01/13
				ZZD->(dbSetOrder(8))
				dbSelectArea("ZZD")
				If ZZD->(dbSeek(xFilial("ZZD")+cEmpAnt+cFilAnt+SF2->F2_SERIE+SF2->F2_DOC))
					RecLock("ZZD",.F.)
					ZZD->ZZD_YPEDAG	:= aCols[i,_npedagio]
					ZZD->ZZD_YCTR  	:= M->ZB_NUM
					ZZD->ZZD_YSERCT := M->ZB_SERIE
					MsUnlock()
				EndIf
				*/
				
				DbSelectArea("SZC")
				lSZC := .T.
			End
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava SZB - Cabecalho ctr                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  lSZC
			dbSelectArea("SZB")
			RecLock("SZB",.T.)
			SZB->ZB_FILIAL  := xFilial("SZB")
			SZB->ZB_NUM     := M->ZB_NUM
			SZB->ZB_SERIE   := M->ZB_SERIE
			SZB->ZB_FORNECE := M->ZB_FORNECE
			SZB->ZB_LOJA    := M->ZB_LOJA
			SZB->ZB_NOME    := M->ZB_NOME
			SZB->ZB_TOTAL   := nsoma
			SZB->ZB_EMISSAO := M->ZB_EMISSAO
			SZB->ZB_DTDIGIT := dDataBase
			SZB->ZB_BICMS   := M->ZB_BICMS
			msUnLock()
		End
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava SD1/SF1/SE2/SF2                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		nCredPis:=0
		nCredCof:=0
		
		If lSZC
			_nitem  := 1
			nvalaux:= 0
			For i := 1 to len(aCols)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Acessa SIGAMAT.EMP - busca numero sequencial de movimentacao             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SM0")
				While ! Reclock("SM0",.F.) ; End
				_numseq := SM0->M0_DOCSEQ + 1
				SM0->M0_DOCSEQ := _numseq
				msUnLock()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se o item foi deletado                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If  ! aCols[i,nUsado+1]
					SA2->(DbSetOrder(1))
					SA2->(DbSeek(xFilial("SA2")+M->ZB_FORNECE+M->ZB_LOJA))

					wEstado := GetMV("MV_ESTADO")
					SF4->(dbSetorder(1))
					SF4->(dbSeek(xFilial("SF4")+aCols[i,_nTES]))
					_nCF := IIF(wEstado == SA2->A2_EST,SF4->F4_CF,"2"+SUBS(SF4->F4_CF,2,3))
					wPICMS := If(SF4->F4_ICM=="S" .AND. SF4->F4_CREDICM=="S",12,0)

					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD+SD2->D2_LOCAL))
					DbSelectArea("SD1")
					While !RecLock("SD1",.T.) ; EndDo
					SD1->D1_FILIAL  := xFilial("SD1")
					SX5->(DbSetOrder(1))
					SX5->(DbSeeK(xFilial("SX5")+"Z7"+Alltrim(SB1->B1_TIPCAR))) //TABELA GENERICA PRODUTO FRETE
					wCodigo := Alltrim(SX5->X5_DESCRI)

					SB1->(dbSeek(xFilial("SB1")+wCodigo))//Obtem informações cadastradas no produto referente ao frete
					dbSelectArea("SD1")
					SD1->D1_COD     := wCodigo
					SD1->D1_UM      := SD2->D2_UM
					SD1->D1_DESCRI  := SB1->B1_DESC					
					SD1->D1_VUNIT   := aCols[i,_nvaltot]+aCols[i,_npedagio]
					SD1->D1_TOTAL   := aCols[i,_nvaltot]+aCols[i,_npedagio]
					If SZB->ZB_BICMS > 0
						If wPICMS > 0
							SD1->D1_BASEICM := SD1->D1_TOTAL
							SD1->D1_VALICM  := Round((SZB->ZB_BICMS*SD1->D1_TOTAL/SZB->ZB_TOTAL)*12/100,2)
						EndIf
					Else
						If wPICMS > 0
							SD1->D1_BASEICM := SD1->D1_TOTAL
							SD1->D1_VALICM  := Round((aCols[i,_nvaltot]+aCols[i,_npedagio])*12/100,2) //Inluido o valor do pedagio por Gustav em 12/06/06
						EndIf
					EndIf
					SD1->D1_TES     := aCols[i,_nTES]
					SD1->D1_CF      := _nCF
					SD1->D1_PICM    := wPICMS 
					SD1->D1_CONTA   := SB1->B1_CONTA
					SD1->D1_FORNECE := M->ZB_FORNECE
					SD1->D1_LOJA    := M->ZB_LOJA
					SD1->D1_LOCAL   := SD2->D2_LOCAL
					SD1->D1_EMISSAO := M->ZB_EMISSAO
					SD1->D1_DOC     := M->ZB_NUM
					SD1->D1_DTDIGIT := dDataBase
					SD1->D1_TIPO    := "C"
					SD1->D1_SERIE   := M->ZB_SERIE 
					SD1->D1_TP      := "GG"
					SD1->D1_NUMSEQ  := strzero(_numseq,6)
					SD1->D1_NFORI   := aCols[i,_nnota]
					SD1->D1_SERIORI := aCols[i,_nserie]
					SD1->D1_ITEM    := strzero(_nitem,2)
					SD1->D1_RATEIO  := "2"
					If SF4->F4_PISCOF $ '23' .And. SF4->F4_PISCRED == '1' // Gera COF?  e Se credita de COF?
						SD1->D1_BASIMP5    := SD1->D1_TOTAL
						SD1->D1_VALIMP5     := Round(SD1->D1_TOTAL*   GETMV("MV_TXCOFIN")   /100,2)
						nCredCOF					 += SD1->D1_VALIMP5
					Endif
					
					If SF4->F4_PISCOF $ '13' .And. SF4->F4_PISCRED == '1' // Gera PIS?  e Se credita de PIS?
						SD1->D1_BASIMP6     := SD1->D1_TOTAL
						SD1->D1_VALIMP6     := Round(SD1->D1_TOTAL*   GETMV("MV_TXPIS")   /100,2)
						nCredPIS					 += SD1->D1_VALIMP6
					Endif
					
					SD1->D1_CUSTO   := SD1->D1_TOTAL - (SD1->D1_VALICM+nCredPIS+nCredCOF)
					
					SD1->D1_CC      := SB1->B1_CC
					SD1->D1_CLVL    := SB1->B1_CLVL
					SD1->D1_ITEMCTA	:= SB1->B1_ITEMCC
					
					CTT->(dbSetOrder(1)) //CTT_FILIAL+CTT_CUSTO
					CTT->(dbSeek(xFilial("CTT")+SD1->D1_CC))
					DbSelectArea("SZQ")
					
					SD1->D1_YDESCN1	:= POSICIONE("ZZ7",1,xFilial("ZZ7")+CTT->CTT_YGRDE,"ZZ7_GDESPE") //Descricao CCusto Nivel 1
					
					//--------------------------------------------------------------------
					// UTILIZADO PARA INCLUIR CÓDIGO DE VISÃO PARA FRETES DE CIMENTO
					// INCLUÍDO POR MARCUS VINICIUS 23/02/2015
					IF .NOT. (xFILIAL("SZC") $ "01/07") .AND. ALLTRIM(SD1->D1_CC) $ "0604"
						_cCodVisao := "105"
						ZZ8->(DBSETORDER(1)) // ZZ8_FILIAL+ZZ8_CODIGO
						ZZ8->(DBSEEK(xFILIAL("ZZ8")+_cCodVisao))
						SD1->D1_VISAO  := _cCodVisao
						SD1->D1_DESCVI := ZZ8->ZZ8_DESPES
					EndIf
					//--------------------------------------------------------------------
					
					ZZ4->(dbSetOrder(1)) //ZZ4_FILIAL+ZZ4_CODIGO
					ZZ4->(dbSeek(xFilial("ZZ4")+CTT->CTT_YSBDE))
					While ! Eof() .And. CTT->CTT_YSBDE == ZZ4->ZZ4_CODIGO
						If CTT->CTT_YGRDE+" " == ZZ4->ZZ4_GRDESP
							SD1->D1_YDESCN2	:= ZZ4->ZZ4_GERENC
							Exit
						EndIf
						ZZ4->(dbSkip())
					End
					
					SD1->D1_YDESCN3	:= POSICIONE("ZZ8",2,xFilial("ZZ8")+CTT->CTT_YSBDE+CTT->CTT_YDESP,"ZZ8_DESPES") //Descricao CCusto Nivel 3
					
					msUnLock()
					_nitem++
					nvalaux+=SD1->D1_VALICM
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Gera Titulo a pagar do frete                                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea("SE2")
					DbSetOrder(1)
					While !Reclock("SE2",.T.); EndDo
					SE2->E2_FILIAL  := xFilial("SE2")
					SE2->E2_PREFIXO := M->ZB_SERIE //"UNI"
					SE2->E2_NUM     := M->ZB_NUM
					SE2->E2_TIPO    := "NF"
					SA2->(DbSetOrder(1))
					SA2->(DbSeek(xFilial("SA2")+M->ZB_FORNECE+M->ZB_LOJA))
					SE2->E2_FORNECE := SA2->A2_COD
					SE2->E2_LOJA    := SA2->A2_LOJA
					SE2->E2_NOMFOR  := SA2->A2_NOME
					SE2->E2_EMISSAO := M->ZB_EMISSAO					
					SE2->E2_VALOR   := aCols[i,_nvaltot]+aCols[i,_npedagio] //Inluido o valor do pedagio por Gustav em 12/06/06
					SE2->E2_EMIS1   := M->ZB_EMISSAO
					// Incluido Por Gustavo Hand Strey em 19/07/11 - CALCULO DO VENCIMENTO
					aParc := {}
					cCondPg := POSICIONE("SA5",1,xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+wCodigo,"A5_YCONDPG")
					aParc := Condicao(SE2->E2_VALOR,cCondPg,,SE2->E2_EMIS1)
						// Verifica se e menor que o parametro MZ_VENCDIA
						// Se o vencimento for menor que 8 dias, calcula o novo vencimento 
					If (aParc[1,1] - DATE()) < Val(GETMV("MZ_VENCDIA"))
						SE2->E2_VENCTO  := DATE() + Val(GETMV("MZ_VENCDIA"))
						SE2->E2_VENCREA := DataValida(SE2->E2_VENCTO)
					Else
						SE2->E2_VENCTO  := aParc[1,1]
						SE2->E2_VENCREA := DataValida(SE2->E2_VENCTO) 
					Endif    
				    // FIM
					SE2->E2_SALDO   := aCols[i,_nvaltot]+aCols[i,_npedagio] //Inluido o valor do pedagio por Gustav em 12/06/06
					SE2->E2_VENCORI := SE2->E2_VENCTO
					SE2->E2_MOEDA   := 1
					SE2->E2_RATEIO  := "N"
					SE2->E2_VLCRUZ  := aCols[i,_nvaltot]+aCols[i,_npedagio] //Inluido o valor do pedagio por Gustav em 12/06/06
					SE2->E2_ORIGEM  := "MIZ745"
					SE2->E2_DATALIB	:= dDataBase
					SE2->E2_USUALIB := cUsername
					SE2->E2_FLUXO   := "S"
					SE2->E2_NATUREZ := "N3001"
					SE2->E2_PARCELA := Subs(cparc,i,1)
					SE2->E2_YNOTA   := aCols[i,_nnota]
					SE2->E2_LA      := "S"
				    SE2->E2_FILORIG := cFilAnt					
					If M->ZB_FORNECE == "002721" .OR. M->ZB_FORNECE == "002590"
						SE2->E2_YCC      := "C10802"
					ElseIf M->ZB_FORNECE $ "000467,001126,003024"
						SE2->E2_YCC      := "C10801"
					EndIf
					MsUnlock()
				EndIf
			Next
			DbSelectArea("SF1")
			While !RecLock("SF1",.T.) ; EndDo
			SF1->F1_FILIAL  := xFilial("SF1")
			SF1->F1_DOC     := M->ZB_NUM
			SF1->F1_SERIE   := M->ZB_SERIE //"UNI"
			SF1->F1_FORNECE := M->ZB_FORNECE
			SF1->F1_LOJA    := M->ZB_LOJA
			//SF1->F1_COND    := "007"
			SF1->F1_COND    := cCondPg //condicao de pagamento Fornecedor X Produto
			SF1->F1_DUPL    := M->ZB_NUM
			SF1->F1_EMISSAO := M->ZB_EMISSAO
			//SF1->F1_EMISSAO := dDataBase
			SF1->F1_EST     := SA2->A2_EST //"ES"
			If SZB->ZB_BICMS > 0
				If wPICMS > 0
					SF1->F1_BASEICM := SZB->ZB_BICMS
				EndIf
			Else
				If wPICMS > 0
					SF1->F1_BASEICM := SZB->ZB_TOTAL
				EndIf
			EndIf
			SF1->F1_VALICM  := Round(SF1->F1_BASEICM*wPICMS/100,2)//nvalaux
			SF1->F1_VALMERC := SZB->ZB_TOTAL
			SF1->F1_VALBRUT := SZB->ZB_TOTAL
			SF1->F1_TIPO    := "C"
			//SF1->F1_DTDIGIT := SZB->ZB_EMISSAO
			SF1->F1_DTDIGIT := dDataBase
			SF1->F1_PREFIXO := M->ZB_SERIE //"UNI"
			SF1->F1_RECBMTO := SZB->ZB_EMISSAO
			SF1->F1_STATUS  := "A"
			SF1->F1_ESPECIE := IIF(SD1->D1_TES$GETMV("MV_YTENFFR"),"NF","CTR")   //TES para Nota Fiscal de Servico de Frete
			
			// gera credito de pis/cofins
			
			If nCredCOF>= 0
				SF1->F1_BASIMP5 := SF1->F1_VALMERC
				SF1->F1_VALIMP5 := nCredCOF
			Endif
			
			If nCredPIS>= 0
				SF1->F1_BASIMP6 := SF1->F1_VALMERC
				SF1->F1_VALIMP6  := nCredPIS
			Endif
			
			// GERA LIVRO FISCAL - GUSTAVO HAND STREY - 03/12/10
			aAreaSP := GetArea()
			aOtimizacao := {}
			cAliasSP := "SF1"
			cCNAE := ""
			MaFisIniNF(1,SF1->(RecNo()),@aOtimizacao,cAliasSP,((cAliasSP)->F1_IMPORT<>"S"))
			MaFisWrite()
			MaFisAtuSF3(1,"E",SF1->(RecNo()),"","",cCNAE)
			RestArea(aAreaSP)
			dbSelectArea("SF1")
			//FIM GERAR LIVRO FISCAL
			
			//Grava arquivo SZQ. Incluido por Gustav em 26/06/06
			U_MIZ871(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,1)
			//Grava arquivo SZQ. Incluido por Gustav em 26/06/06
			
			msUnLock()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava ARQuivo DBF                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If  lSZC
				ExecBlock("MIZ915",.F.,.F.)
			EndIf
		EndIf
	Case lExcluir
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verificar se pode excluir                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		aAdd( aTransac, { "SE2", 6, xFilial("SE2")+M->ZB_FORNECE+M->ZB_LOJA+M->ZB_SERIE+PADR(M->ZB_NUM,9) } )
		
		DbSelectArea("SE2")
		DbSetOrder(6)
		//DbSeek(xFilial("SE2")+M->ZB_FORNECE+M->ZB_LOJA+"UNI"+M->ZB_NUM)
		//SE2->E2_FORNECE+SE2->E2_LOJA+"UNI"+SE2->E2_NUM==M->ZB_FORNECE+M->ZB_LOJA+"UNI"+M->ZB_NUM
		if !DbSeek(xFilial("SE2")+M->ZB_FORNECE+M->ZB_LOJA+M->ZB_SERIE+PADR(M->ZB_NUM,9))
			if !MsgYesNo("Atencao, titulo nao encontrado no finaceiro! Continuar?","Atencao","ALERT")
				ROLLBACK TRANSACTION
				Return
			endif
		endif
		Do while .not. eof() .and. E2_FILIAL==xFilial("SE2") .and.;
			SE2->E2_FORNECE+SE2->E2_LOJA+M->ZB_SERIE+SE2->E2_NUM==M->ZB_FORNECE+M->ZB_LOJA+M->ZB_SERIE+PADR(M->ZB_NUM,9)
			If SE2->E2_SALDO <> SE2->E2_VALOR
				MsgBox("Atencao, ja foram baixados titulos referentes a esse Conhecimento de Frete. Verificar com o Financeiro","Atencao","ALERT")
				ROLLBACK TRANSACTION
				Return
			EndIf
			//If SE2->E2_EMISSAO < GetMV("MV_DATAFIS") 
			If dDataBase < GetMV("MV_DATAFIS")
				MsgBox("Atencao, o periodo ja foi fechado pelo Fiscal. Contactar Contabilidade","Atencao","ALERT")
				ROLLBACK TRANSACTION
				Return
			EndIf
			
			If !EMPTY(SE2->E2_NUMBOR)
				MsgBox("Atencao, Titulo em bordero de Nr.: [ "+SE2->E2_NUMBOR+ " ]","Atencao","ALERT")
				ROLLBACK TRANSACTION
				Return
			EndIf
			
			While !Reclock("SE2",.f.);EndDo
			Delete
			MsUnlock()
			se2->(DbSkip())
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Limpar numero do CTR no cabecalho da NF de saida                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
		dbSelectArea("SZC")
		dbSetOrder(4) //ZC_FILIAL+ZC_NUM+ZC_SERCTR+ZC_FORNECE+ZC_LOJA
		dbSeek(xFilial("SZC")+M->ZB_NUM+M->ZB_SERIE+M->ZB_FORNECE+M->ZB_LOJA)
				
		DbSelectArea("SF2")
		DbSetOrder(1)
		If DbSeek(xFilial("SF2")+PADR(SZC->ZC_NOTA,9)+SZC->ZC_SERIE)
			While !RecLock("SF2",.F.) ; EndDo
			SF2->F2_YCTR   :=  Space(6)
			SF2->F2_YSERCTR:=  Space(3)
			SF2->F2_YFCTR  :=  Space(6)
			SF2->F2_YLCTR  :=  Space(2)
			MsUnlock()
		EndIf
                                         
		/* ALTERADO EM 07/01/13
		ZZD->(dbSetOrder(8))
		dbSelectArea("ZZD")
		If ZZD->(dbSeek(xFilial("ZZD")+cEmpAnt+cFilAnt+SF2->F2_SERIE+SF2->F2_DOC))
			RecLock("ZZD",.F.)
			ZZD->ZZD_YCTR  	:= " "
			ZZD->ZZD_YSERCT := " "
			MsUnlock()
		EndIf 
		*/                 
		
		dbSelectArea("SZC")
		
		aAdd( aTransac, { "SZC", 4, xFilial("SZC")+M->ZB_NUM+M->ZB_SERIE+M->ZB_FORNECE+M->ZB_LOJA } )
		
		dbSetOrder(4) //ZC_FILIAL+ZC_NUM+ZC_SERCTR+ZC_FORNECE+ZC_LOJA
		dbSeek(xFilial("SZC")+M->ZB_NUM+M->ZB_SERIE+M->ZB_FORNECE+M->ZB_LOJA)
		While !eof() .and. SZC->ZC_FILIAL  == xFilial("SZC") ;
			.and. SZC->ZC_NUM     == M->ZB_NUM ;
			.and. SZC->ZC_SERCTR  == M->ZB_SERIE;
			.and. SZC->ZC_FORNECE == M->ZB_FORNECE ;
			.and. SZC->ZC_LOJA    == M->ZB_LOJA
			While ! RecLock("SZC",.F.) ; End
			DbSelectArea("SZC")
			delete
			msUnLock()
			dbSkip()
		End
			
		DbSelectArea("SF1")
		DbSetOrder(1)
		
		aAdd( aTransac, {"SF1", 1, xFilial("SF1")+PADR(M->ZB_NUM,9)+M->ZB_SERIE+M->ZB_FORNECE+M->ZB_LOJA } )
		
		DbSeek(xFilial("SF1")+PADR(M->ZB_NUM,9)+M->ZB_SERIE+M->ZB_FORNECE+M->ZB_LOJA)
		
		U_MIZ872(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
		dbSelectArea("SF1")
		
		aAreaSP := GetArea()
		aOtimizacao := {}
		cAliasSP := "SF1"
		cCNAE := ""
		MaFisIniNF(1,SF1->(RecNo()),@aOtimizacao,cAliasSP,((cAliasSP)->F1_IMPORT<>"S"))
		MaFisWrite()
		MaFisAtuSF3(2,"E",SF1->(RecNo()),"","",cCNAE)
		RestArea(aAreaSP)
		dbSelectArea("SF1")
			
		Do while .not. eof() .and. F1_FILIAL==xFilial("SF1") .and.;
			SF1->F1_DOC+M->ZB_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == PADR(M->ZB_NUM,9)+M->ZB_SERIE+M->ZB_FORNECE+M->ZB_LOJA
			While !Reclock("SF1",.f.);EndDo
			Delete
			MsUnlock()
			DbSkip()
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui SD1                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		aAdd( aTransac, { "SD1", 1, xFilial("SD1")+PADR(M->ZB_NUM,9)+M->ZB_SERIE+M->ZB_FORNECE+M->ZB_LOJA } )
		
		DbSelectArea("SD1")
		DbSetOrder(1)
		DbSeek(xFilial("SD1")+PADR(M->ZB_NUM,9)+M->ZB_SERIE+M->ZB_FORNECE+M->ZB_LOJA)
		Do while .not. eof() .and. D1_FILIAL==xFilial("SD1") .and.;
			SD1->D1_DOC+M->ZB_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == PADR(M->ZB_NUM,9)+M->ZB_SERIE+M->ZB_FORNECE+M->ZB_LOJA
			While !Reclock("SD1",.f.);EndDo
			Delete
			MsUnlock()
			DbSkip()
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui DBF                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If file("\CTR\MIZUCON.DBF")
			Use \CTR\MIZUCON Alias "MIZUCON" Shared New  Index \CTR\MIZUCON
			If DbSeek(xFilial("SZ1")+SZB->ZB_NUM+SZB->ZB_FORNECE+SZB->ZB_LOJA)
				If Reclock("MIZUCON",.F.)
					Delete
					MsUnlock()
				EndIf
			EndIf
			DbCloseArea()
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui SZB - Cab. CTR                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SZB")
		While ! RecLock("SZB",.F.) ; End
		delete
		msUnLock()
EndCase


if lExcluir
	//confirmação de delet all
	for i:=1 to len(aTransac)
		dbselectArea(aTransac[i,1])
		dbsetOrder(aTransac[i,2])
		if dbseek( aTransac[i,3]  )
			alert('Atenção:  Registro nao deletado na tabela ['+aTransac[i,2]+'] - aTransac[i,3]   A Exclusao será cancelada!!!')
			ROLLBACK TRANSACTION
		endif
	next
endif


dbCommitAll()

End Transaction


Return