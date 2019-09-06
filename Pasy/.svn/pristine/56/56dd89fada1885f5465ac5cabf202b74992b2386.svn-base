#INCLUDE "EECFAT.ch"
#include "EECRDM.CH"

/*
************************************************************************************************
A T E N C A O: A partir da versão 7.10, o rdmake EECFAT não será utilizado no RPO padrão, para
utilizar este rdmake configurar o parametro MV_AVG0064, conforme abaixo:
MV_AVG0064
C
Configura qual rotina será executada na integração com o Faturamento (EECFAT/EECFAT2)
EECFAT2
************************************************************************************************
*/
/*
Autor		:	Fabiano da Silva
Data		:	02/08/13
Descrição	:	Pontos de Entrada do módulo Easy Export Control (SIGAEEC)

EECPEM00()	:	EMBARQUE EXPORTACAO - GRAVAÇÃO. Caminho: Atualizações/Embarque/Cons.Manutenção/Opções Incluir ou Alterar/Botão Ok.
Descrição: 	Chamada na função AE100Grava() após a gravação da capa, despesas, agentes, instituições,NFs e itens do embarque,
atualização do status  do processo e gravação das parcelas de câmbio.Uso: Execução de rotinas de atualização de dados logo
após a gravação completa do processo de exportação e processo de embarque.
*/

User Function EECPEM00()

EE9->(dbSetOrder(2))
If EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB))
	
	_nVol := 0
	_cKey := EE9->EE9_PREEMB
	
	While EE9->(!EOF()) .AND. _cKey == EE9->EE9_PREEMB
		
		_nVol += EE9->EE9_QTDEM1
		
		EE9->(dbSkip())
	EndDo
	
	EEC->(RecLock("EEC",.F.))
	EEC->EEC_TOTVOL := _nVol
	EEC->(MsUnlock())
	
Endif

Return Nil



/*
Programa : EECFAT
Objetivo : Integracao com Siga Advanced - Modulo Faturamento
Autor    : Cristiano A. Ferreira
Data/Hora: 10/11/1999 17:14
Obs.     :
*/



Static aStrSC5,aStrEE7,aStrSC6,aStrEE8

/*
Funcao      : EECFAT
Parametros  : ParamIXB := {nOpc,cTipo}
nOpc := 3 // Inclusao
4 // Alteracao
5 // Exclusao
cTipo := "VLD" // Validacao
"GRV" // Gravacao
Retorno     :
Objetivos   :
Autor       : Cristiano A. Ferreira
Data/Hora   : 10/11/1999 17:14
Revisao     :
Obs.        : Convertido por CCF em 11/09/2000
*/
// Esta rotina considera que o EEC, ja esta posicionado.

User Function EECFAT()

Local lRet := .F.
Local nOpc, cTipo

Private cErrorLog := ""

CursorWait()

If( aStrSC5 = Nil , aStrSC5 := SC5->(dbStruct()) , )
If( aStrSC6 = Nil , aStrSC6 := SC6->(dbStruct()) , )
If( aStrEE7 = Nil , aStrEE7 := EE7->(dbStruct()) , )
If( aStrEE8 = Nil , aStrEE8 := EE8->(dbStruct()) , )

Begin Sequence

IF ! ( ValType(ParamIXB) == "A" .And. Len(ParamIXB) > 1 )
	HELP(" ",1,"AVG0005021") //MsgStop("Erro nos parametros da rotina EECFAT !","Aviso")
	Break
Endif

nOpc  := ParamIXB[1]
cTipo := ParamIXB[2]

IF cTipo == "VLD" // Validacao
	lRet := ValidFat()
	IF !lRet
		Break
	Endif
Elseif cTipo == "GRV" // Gravacao
	IF Empty(M->EE7_FATURA)
		Break
	Endif	
	lRet := GravaFat(nOpc)
ElseIf cTipo == "MSG" // Mensagem no Final da Gravacao
	// by OMJ 24/02/2003 a mensagem vai aparecer no final da gravacao e somente na inclusao.
	If nOpc = 3 // Incluir
		IF ValType(GetMv("MV_EECAUTO")) == "L" .And. !GetMv("MV_EECAUTO")
			MsgInfo(STR0001+Transf(M->EE7_PEDFAT,AVSX3("C5_NUM",AV_PICTURE)),STR0002) //"Número do Pedido no Faturamento: "###"Aviso"
		Endif
	Endif
	lRet := .t.	
Else	
	lRet := .t.	
Endif

End Sequence

CursorArrow()

Return lRet

/*
Funcao      : GravaFat
Parametros  :
Retorno     :
Objetivos   : Grava Pedido no SC5
Autor       : Cristiano A. Ferreira
Data/Hora   : 22/09/2000 13:34
Revisao     :
Obs.        :
*/
Static Function GravaFat(nOpc)

LOCAL lALT,cCPOFAT,aVT,n1,n2
Local lRet := .T.
Local aOrd := SaveOrd({"SA1","WorkIt","SB2"})
Local cItem, aReg, dEntrega, i, cCF, cTES
Local aHeader, aDetail

Private aCab, aItens

Private lGeraLog := GetMv("MV_EECFLOG",,.f.)
Private lMSErroAuto := .F.
Private lMSHelpAuto := .F. // para mostrar os erros na tela

Begin Sequence

SA1->(dbSetOrder(1))
WorkIt->(dbSetOrder(1))
SB2->(dbSetOrder(1))

// aCab por dimensao:
// aCab[n,1] := Nome do Campo
// aCab[n,2] := Valor a ser gravado no campo
// aCab[n,3] := Regra de Validacao, se NIL considera do dicionario
aCab := {}

IF nOpc == 3 // Solicitar
	lALT := .F.
	IF ValType(GetMV("MV_EECAUTO")) == "L" .And. GetMV("MV_EECAUTO")
		aAdd(aCab,{"C5_NUM",AvKey(M->EE7_PEDIDO,"C5_NUM"),nil}) // Nro.do Pedido
	Else
		aAdd(aCab,{"C5_NUM",GetSXENum("SC5"),nil}) // Nro.do Pedido
	Endif
Else
	lALT := .T.
	aAdd(aCab,{"C5_NUM",M->EE7_PEDFAT,nil})
Endif

aAdd(aCab,{"C5_TIPO","N",nil}) //Tipo de Pedido - "N"-Normal

SA1->(dbSeek(xFilial("SA1")+M->EE7_IMPORT+M->EE7_IMLOJA))
aAdd(aCab,{"C5_CLIENTE",SA1->A1_COD,nil})  //Cod. Cliente
aAdd(aCab,{"C5_LOJACLI",SA1->A1_LOJA,nil}) //Loja Cliente
aAdd(aCab,{"C5_TIPOCLI","X",nil}) //Tipo Cliente

aAdd(aCab,{"C5_CONDPAG",Posicione("SY6",1,xFilial("SY6")+M->EE7_CONDPA+AvKey(M->EE7_DIASPA,"Y6_DIAS_PA"),"Y6_SIGSE4"),nil})

IF WorkIn->(dbSeek("J"))
	aAdd(aCab,{"C5_BANCO",WorkIn->EEJ_CODIGO,nil}) // Banco
Endif

aAdd(aCab,{"C5_EMISSAO",M->EE7_DTPROC,nil})

aAdd(aCab,{"C5_DESC1",0,nil})
//aAdd(aCab,{"C5_DESC1",IF(M->EE7_PRECOA $ cSim,0,M->EE7_DESCON/M->EE7_TOTPED),nil})

aAdd(aCab,{"C5_MOEDA",POSICIONE("SYF",1,XFILIAL("SYF")+M->EE7_MOEDA,"YF_MOEFAT"),nil})
aAdd(aCab,{"C5_PESOL",M->EE7_PESLIQ,nil})
aAdd(aCab,{"C5_PBRUTO",M->EE7_PESBRU,nil})
aAdd(aCab,{"C5_PEDEXP",M->EE7_PEDIDO,nil})

For nInd := 1 TO Len(aStrSC5)
	cCampo := aStrSC5[nInd][1]
	If aScan(aCab,{|x| x[1] = cCampo }) = 0 .And. !("FILIAL"$cCampo)
		cCpoComum := SubStr(cCampo,4)
		cCpoEE7   := Left("EE7_" + cCpoComum,10)
		If ( nPos := aScan(aStrEE7,{|x| x[1] = cCpoEE7 }) ) > 0
			If aStrEE7[nPos][2] = aStrSC5[nInd][2] .And.;
				aStrEE7[nPos][3] = aStrSC5[nInd][3] .And.;
				aStrEE7[nPos][4] = aStrSC5[nInd][4]
				
				cCpoEE7 := "M->" + cCpoEE7
				If Type(cCpoEE7) <> "U"
					bVar := MemVarBlock(SubStr(cCpoEE7,4))
					If ValType(bVar) == "B"
						Aadd(aCab,{cCampo,Eval(bVar),Nil })
					EndIf
				EndIf
				
			EndIf
		EndIf
	EndIf
Next

aItens := {}
For i:=1 To Len(aDeletados)
	EE8->(dbGoTo(aDeletados[i]))
	
	IF SB1->(dbSeek(xFilial("SB1")+EE8->EE8_COD_I))
		IF ! SB2->(dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD))
			CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
		Endif
	Endif
	
    _aAliSZ2 := SZ2->(GETAREA())
	_cPedCli := ""    
	
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ2")+M->EE7_IMPORT+M->EE7_IMLOJA + EE8->EE8_COD_I + EE8->EE8_CODCLI+"1")
		_cPedCli := SZ2->Z2_PEDCLI
	Endif             
	RestArea(_aAliSZ2)
		
	aReg := {}
	
	aAdd(aReg,{"C6_NUM",aCab[1,2],nil})
	aAdd(aReg,{"C6_ITEM",EE8->EE8_FATIT,nil})   // Item sequencial
	aAdd(aReg,{"C6_CPROCLI",EE8->EE8_CODCLI,nil})  // Produto Cliente
//	aAdd(aReg,{"C6_PEDCLI",_cPedCli,nil})         // Pedido do Cliente
	aAdd(aReg,{"C6_PEDCLI",EE8->EE8_REFCLI,nil})  // Pedido do Cliente
	aAdd(aReg,{"C6_PEDAMOS",EE8->EE8_TIPPED,nil})  // Tipo de Pedido
	aAdd(aReg,{"C6_PRODUTO",EE8->EE8_COD_I ,nil})  // Cod.Item
	aAdd(aReg,{"C6_UM",EE8->EE8_UNIDAD,nil})  // Unidade
	aAdd(aReg,{"C6_QTDVEN",EE8->EE8_SLDINI,nil})  // Quantidade
	aAdd(aReg,{"C6_PRCVEN",EE8->EE8_PRECOI,nil})  // Preco Unit.
	If ( GetMV("MV_ARREFAT")=="S" )
		aAdd(aReg,{"C6_VALOR",Round(EE8->EE8_SLDINI * EE8->EE8_PRECOI,AvSx3("C6_VALOR",AV_TAMANHO)),nil}) // Valor Tot.
	Else
		aAdd(aReg,{"C6_VALOR",NoRound(EE8->EE8_SLDINI * EE8->EE8_PRECOI,AvSx3("C6_VALOR",AV_TAMANHO)),nil}) // Valor Tot.
	EndIf
	// ** JBJ - 05/09/01 - 11:51
	aAdd(aReg,{"C6_TES"    ,EE8->EE8_TES,nil}) // Tipo de Saida
	aAdd(aReg,{"C6_CF"     ,EE8->EE8_CF,nil})  // Classificacao Fiscal
	aAdd(aReg,{"C6_LOCAL"  ,SB1->B1_LOCPAD,nil})  // Almoxarifado
	
	dEntrega := EE8->EE8_DTENTR
	IF Empty(dEntrega)
		dEntrega := EE8->EE8_DTPREM
	Endif
	aAdd(aReg,{"C6_ENTREG" ,dEntrega,nil})  // Dt.Entrega
	aAdd(aReg,{"C6_DESCRI" ,SB1->B1_DESC,nil})
	
	aAdd(aReg,{"C6_LOTECTL",EE8->EE8_LOTECT,nil}) // Nro. Lote
	aAdd(aReg,{"C6_NUMLOTE",EE8->EE8_NUMLOT,nil}) // Sub-Lote
	aAdd(aReg,{"C6_DTVALID",EE8->EE8_DTVALI,nil}) // Data do Lote
	aAdd(aReg,{"C6_REVPED",EE8->EE8_REVPED,nil})  // Revisão Pedido
	
	aAdd(aReg,{"AUTDELETA","S",nil})
	aAdd(aItens,aClone(aReg))
Next i

cItem := "01"
WorkIt->(dbGoTop())
While WorkIt->(!Eof())
	
	IF SB1->(dbSeek(xFilial("SB1")+WorkIt->EE8_COD_I))
		IF ! SB2->(dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD))
			CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
		Endif
	Endif

    _aAliSZ2 := SZ2->(GETAREA())
	_cPedCli := ""    
	
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ2")+M->EE7_IMPORT+M->EE7_IMLOJA + WorkIt->EE8_COD_I + WorkIt->EE8_CODCLI+"1")
		_cPedCli := SZ2->Z2_PEDCLI
	Endif             
	RestArea(_aAliSZ2)
	
	aReg := {}
	
	aAdd(aReg,{"C6_NUM"    ,aCab[1,2],nil})
	aAdd(aReg,{"C6_ITEM"   ,IF(WorkIt->EE8_RECNO<>0,WorkIt->EE8_FATIT,cItem),nil}) // Item sequencial
	aAdd(aReg,{"C6_CPROCLI",WorkIt->EE8_CODCLI,nil})  // Produto Cliente
	aAdd(aReg,{"C6_PEDCLI" ,WorkIt->EE8_REFCLI,nil})  // Pedido do Cliente
//	aAdd(aReg,{"C6_PEDCLI",_cPedCli,nil})           // Pedido do Cliente

	aAdd(aReg,{"C6_REVPED",WorkIt->EE8_REVPED,nil})           // Pedido do Cliente
	aAdd(aReg,{"C6_PEDAMOS",WorkIt->EE8_TIPPED,nil})    // Tipo de Pedido	
	aAdd(aReg,{"C6_PRODUTO",WorkIt->EE8_COD_I,nil})  // Cod.Item
	aAdd(aReg,{"C6_UM",WorkIt->EE8_UNIDAD,nil}) // Unidade
	aAdd(aReg,{"C6_QTDVEN",WorkIt->EE8_SLDINI,nil}) // Quantidade
	aAdd(aReg,{"C6_PRCVEN",WorkIt->EE8_PRECOI,nil}) // Preco Unit.
	aAdd(aReg,{"C6_PRUNIT",WorkIt->EE8_PRECOI,nil}) // Preco Unit.
	If ( GetMV("MV_ARREFAT")=="S" )
		aAdd(aReg,{"C6_VALOR",Round(WorkIt->EE8_SLDINI * WorkIt->EE8_PRECOI,AvSx3("C6_VALOR",AV_DECIMAL)),nil}) // Valor Tot.
	Else
		aAdd(aReg,{"C6_VALOR",NoRound(WorkIt->EE8_SLDINI * WorkIt->EE8_PRECOI,AvSx3("C6_VALOR",AV_DECIMAL)),nil}) // Valor Tot.
	EndIf
	cTES := "501"
	IF Type("WorkIt->EE8_TES") == "C"
		cTES := WorkIt->EE8_TES
	Endif
	aAdd(aReg,{"C6_TES",cTES,nil}) // Tipo de Saida
	
	cCF := "663"
	IF Type("WorkIt->EE8_CF") == "C"
		cCF := WorkIt->EE8_CF
	Endif
	aAdd(aReg,{"C6_CF",cCF,nil})  // Classificacao Fiscal
	
	aAdd(aReg,{"C6_LOCAL",SB1->B1_LOCPAD,nil})  // Almoxarifado
	
	dEntrega := WorkIt->EE8_DTENTR
	
	IF Empty(dEntrega)
		dEntrega := WorkIt->EE8_DTPREM
	Endif
	
	aAdd(aReg,{"C6_ENTREG",dEntrega,nil})  // Dt.Entrega
	
	aAdd(aReg,{"C6_DESCRI",SB1->B1_DESC,nil})
					aAdd(aReg,{"C6_QTDENT",If(WorkIt->EE8_SLDATU = 0,WorkIt->EE8_SLDINI,0) ,nil}) // Quantidade Entregue
	
	For nInd := 1 TO Len(aStrSC6)
		cCampo := aStrSC6[nInd][1]
		If aScan(aReg,{|x| x[1] = cCampo }) = 0 .And. !("FILIAL"$cCampo)
			cCpoComum := SubStr(cCampo,4)
			cCpoEE8   := Left("EE8_" + cCpoComum,10)
			If ( nPos := aScan(aStrEE8,{|x| x[1] = cCpoEE8 }) ) > 0
				If aStrEE8[nPos][2] = aStrSC6[nInd][2] .And.;
					aStrEE8[nPos][3] = aStrSC6[nInd][3] .And.;
					aStrEE8[nPos][4] = aStrSC6[nInd][4]
					
					If WorkIt->(FieldPos(cCpoEE8)) > 0 .And. !Empty(WorkIt->(FieldGet(FieldPos(cCpoEE8))))
						Aadd(aReg,{cCampo,WorkIt->(FieldGet(FieldPos(cCpoEE8))),Nil })
					EndIf
					
				EndIf
			EndIf
		EndIf
	Next

	aAdd(aReg,{"AUTDELETA","N",nil})
	aAdd(aItens,aClone(aReg))
	
	IF Empty(WorkIt->EE8_FATIT)
		WorkIt->EE8_FATIT := cItem
	Endif
	
	IF cItem < WorkIt->EE8_FATIT
		cItem := WorkIt->EE8_FATIT
	Endif
	
	cItem := SomaIt(cItem)
	
	WorkIt->(dbSkip())
Enddo

ASORT(aItens,,, { |x, y| x[2,2] < y[2,2] })      // claudia

If lGeraLog
	aHeader := aClone(aCab)
	aDetail := aClone(aItens)
	
	LogFat(nOpc,aHeader,aDetail,"1")
EndIf

ExecMata(nOpc)
IF lMSErroAuto
	lRet := .f.
Endif

If lGeraLog
	If LogFat(nOpc,aHeader,aDetail,"2") // Gravar a 2a. Parte do logo, dados que o MATA gravou nas tabelas
		If !MsgYesNo("Log com os detalhes da integração gerado com sucesso!"+Replic(ENTER,2)+;
			"Deseja deixar ativa a geração de log para a integração?","Aviso")
			
			SetMv("MV_EECFLOG",.f.)
		EndIf
	EndIf
EndIf
cErrorLog := ""

End Sequence

RestOrd(aOrd,.T.)

Return lRet

/*
Funcao      : ExecMata
Parametros  :
Retorno     :
Objetivos   :
Autor       : Heder M Oliveira
Data/Hora   : 05/02/2000 10:00
Revisao     :
Obs.        :
*/
Static Function ExecMata(nOpc)
LOCAL cPEDIDO := aCAB[1,2],LRET := .T.,aOrd

Local cOldMod := cModulo
Local nOldMod := nModulo

// Forcar como modulo de faturamento...
cModulo := "FAT"
nModulo := 5

/*
Para identificar se eh modulo de exportação dentro do MATA410: Type("lIsPed") == "L"
*/

MsExecAuto({|x,y,z| mata410(x,y,z)},aCAB,aITENS,nOpc)

// Voltar para o modulo Atual
cModulo := cOldMod
nModulo := nOldMod

IF lMSErroAuto
	MostraErro() // VI
EndIf                       

IF !lMSErroAuto .And. nOpc == 3
	M->EE7_PEDFAT := cPEDIDO
ENDIF
aOrd := SaveOrd({"SC5"})
SC5->(DBSETORDER(1))
IF ! (SC5->(DBSEEK(xFILIAL("SC5")+cPEDIDO))) .AND. nOpc = 3
	lRET := .F.
Endif
RestOrd(aOrd,.T.)
RETURN(lRET)

/*
Funcao      : ValidFat
Parametros  :
Retorno     :
Objetivos   : Critica dados do Pedido
Autor       : Cristiano A. Ferreira
Data/Hora   : 22/09/2000 13:38
Revisao     :
Obs.        :
*/
Static Function ValidFat

Local lRet := .T.
Local aOrd := SaveOrd({"SA1","WorkIt"})
Local cItem

Begin Sequence

SA1->(dbSetOrder(1))
WorkIt->(dbSetOrder(1))


If !SA1->(dbSeek(xFilial("SA1")+M->EE7_IMPORT+M->EE7_IMLOJA))
	Help(" ",1,"AVG0005023") //MsgStop("Importador não cadastrado !","Aviso")
	lRet := .f.
	Break
Endif

M->EE7_FATURA:=dDATABASE

IF M->EE7_AMOSTR==SIM .AND. !MSGNOYES(STR0003,STR0004) //"Deseja registrar Amostra no SIGAFAT ?"###"Integração"
	M->EE7_FATURA:=CTOD("")
Else
	// verifica cond.pagto e moeda
	IF Empty(Posicione("SY6",1,xFilial("SY6")+AvKey(M->EE7_CONDPA,"Y6_COD")+AvKey(M->EE7_DIASPA,"Y6_DIAS_PA"),"Y6_SIGSE4"))
		HELP(" ",1,"AVG0005024") //MsgStop("O campo Cond.Pagto no SIGA não foi digitado no cadastro de Cond.Pagto","Aviso")
		lRet := .F.
		Break
	Endif
	
	IF Empty(Posicione("SYF",1,xFilial("SYF")+AvKey(M->EE7_MOEDA,"YF_MOEDA"),"YF_MOEFAT"))
		HELP(" ",1,"AVG0005025") //MsgStop("O campo Moeda no SIGA  não foi digitado no cadastro de Moedas","Aviso")
		lRet := .F.
		Break
	Endif
ENDIF

cItem := "01"
WorkIt->(dbGoTop())

While  ! WorkIt->(Eof())
	cItem := SomaIt(cItem)
	
	IF cItem > "Z9"
		HELP(" ",1,"AVG0005026") //MsgStop("Excedeu o limite de itens do SIGAFAT !")
		lRet := .F.
		break
	Endif
	
	WorkIt->(dbSkip())
Enddo

End Sequence

RestOrd(aOrd,.T.)

Return lRet

/*
Funcao      : LogFat.
Parametros  : nOpc    -> Operação.
aHeader -> Array com os campos a serem enviados da capa do processo de exportação.
aDetail -> Array com os campos a serem enviados dos itens do processo de exportação.
cParte  -> Parte do log que será gravada
Retorno     : .t./.f.
Objetivos   : Gerar log com detalhes do envio/gravacao no faturamento.
Autor       : Jeferson Barros Jr.
Data/Hora   : 17/02/2003 15:12.
Revisao     :
Obs.        :
*/
*------------------------------------------*

Static Function LogFat(nOpc,aHeader,aDetail,cParte)
*------------------------------------------*

Local lRet := .t., hFile
Local nTam:=0, i:=0, y:=0, z:=0
Local cBuffer := "", cBody := ENTER, cFile :="eecfat.log"
Local aKey:={{"EE7","EE7_PEDFAT"},{"SC5","C5_NUM"},{"SC6","C6_ITEM"},{"SC6","C6_NUM"}},;
aIndices:={}, aFiles:={"SC5","SC6"}, aOrd:=SaveOrd("SIX")

Begin Sequence

If !File(cFile)
	hFile := fCreate(cFile)
	If ! (hFile > 0)
		MsgStop("O arquivo de log da integração com o faturamento não pode ser gerado."+Replic(ENTER,2)+;
		"Detalhes:"+ENTER+;
		"Erro na criação do arquivo: "+cFile+".","Aviso")
		lRet:=.f.
		Break
	Endif
	fClose(hFile)
EndIf

IF cParte == "1" // 1a. Parte
	Six->(DbSetOrder(1))
	
	// ** Informações de cabeçario.
	cBody += "Processo   : "+M->EE7_PEDIDO+ENTER
	cBody += "Data/Hora  : "+Transf(dDataBase,"  /   /  ")+" - "+Time()+ENTER
	
	// ** Tipo da operação.
	If nOpc = 3
		cBody += "Operação   : Inclusão "+Replic(ENTER,2)
	ElseIf nOpc = 4
		cBody += "Operação   : Alteração"+Replic(ENTER,2)
	Else
		cBody += "Operação   : Exclusão "+Replic(ENTER,2)
	EndIf
	
	// ** Parametros.
	cBody += "Parametros"+ENTER
	cBody += "----------"+ENTER
	cBody += "MV_EECFAT  : "+Transf(GetMv("MV_EECFAT") ,"@!")+ENTER
	cBody += "MV_EECAUTO : "+Transf(GetMv("MV_EECAUTO"),"@!")+Replic(ENTER,2)
	
	// ** Estrutura dos arquivos.
	cBody += IncSpace("Campo",10,.f.)+Space(1)+IncSpace("Tam.Dicionario",15,.t.)+Space(1)+IncSpace("Tam.Base",15,.t.)+ENTER
	cBody += Replic("-",10)+Space(1)+Replic("-",15)+Space(1)+Replic("-",15)+ENTER
	
	For i:=1 To Len(aKey)
		nTam:= Len(&(aKey[i][1]+"->"+aKey[i][2]))
		
		cBody += IncSpace(aKey[i][2],10,.f.)+Space(1)+IncSpace(AllTrim(Str(AVSX3(aKey[i][2],AV_TAMANHO))),15,.t.)+Space(1)+;
		IncSpace(AllTrim(Str(nTam)),15,.t.)+ENTER
	Next
	
	cBody += ENTER
	
	// ** Informações dos Indices (Base e Sindex).
	cBody += "Indices : " + ENTER
	cBody += "--------- " + Replic(ENTER,2)
	
	For i:=1 To Len(aFiles)
		
		cBody += "Arquivo : "+aFiles[i]+ ENTER
		
		Six->(DbSeek(aFiles[i]))
		Do While Six->(!Eof()) .And. Six->INDICE == aFiles[i]
			aAdd(aIndices,{Six->ORDEM,Six->CHAVE})
			Six->(DbSkip())
		EndDo
		
		If Len(aIndices) > 0
			// ** Informações dos indices na Base.
			cBody += "Base" + ENTER
			cBody += "----" + ENTER
			cBody += IncSpace("Ordem",6,.f.)+Space(5)+IncSpace("Chave",150,.f.)+ENTER
			
			For y:=1 To Len(aIndices)
				cBody += IncSpace(AllTrim(aIndices[y][1]),6,.f.)+Space(5)+;
				IncSpace((aFiles[i])->(IndexKey(Val(aIndices[y][1]))),150,.f.)+ENTER
			Next
			
			cBody += ENTER
			
			// ** Informações dos indices no dicionário.
			cBody += "Dicionario" + ENTER
			cBody += "----" + ENTER
			cBody += IncSpace("Ordem",6,.f.)+Space(5)+IncSpace("Chave",150,.f.)+ENTER
			
			For z:=1 To Len(aIndices)
				cBody += IncSpace(AllTrim(aIndices[z][1]),6,.f.)+Space(5)+;
				IncSpace(AllTrim(aIndices[z][2]),150,.f.)+ENTER
			Next
			
			cBody += ENTER
		EndIf
		
		aIndices:={}
	Next
	
	// ** Detalhes das informações enviadas. - Capa.
	cBody += "Informações Enviadas - Capa"+ENTER
	cBody += Replic("-",27)+ENTER
	cBody += IncSpace("Campo",10,.f.)+Space(5)+IncSpace("Conteudo",60,.f.)+ENTER
	
	For i:=1 To Len(aHeader)
		If aHeader[i][1] <> "AUTDELETA"
			cBody += IncSpace(aHeader[i][1],10,.f.)+Space(5)+;
			IncSpace(AllTrim(Transf(aHeader[i][2],AVSX3(aHeader[i][1],AV_PICTURE))),10,.f.)+ENTER
		Else
			cBody += IncSpace(aHeader[i][1],10,.f.)+Space(5)+;
			IncSpace(AllTrim(Transf(aHeader[i][2],"@!")),10,.f.)+ENTER
		EndIf
	Next
	
	// ** Detalhes das informações enviadas. - Itens.
	If Len(aDetail) > 0
		cBody += ENTER
		cBody += "Informações Enviadas - Itens"+ENTER
		cBody += Replic("-",29)+ENTER
		
		For i:=1 To Len(aDetail)
			cBody += IncSpace("Campo",10,.f.)+Space(5)+IncSpace("Conteudo",60,.f.)+ENTER
			
			For y:=1 To Len(aDetail[i])
				If aDetail[i][y][1] <> "AUTDELETA"
					cBody += IncSpace(aDetail[i][y][1],10,.f.)+Space(5)+;
					IncSpace(AllTrim(Transf(aDetail[i][y][2],AVSX3(aDetail[i][y][1],AV_PICTURE))),60,.f.)+ENTER
				Else
					cBody += IncSpace(aDetail[i][y][1],10,.f.)+Space(5)+;
					IncSpace(AllTrim(Transf(aDetail[i][y][2],"@!")),60,.f.)+ENTER
				EndIf
			Next
			
			cBody += ENTER
		Next
	Else
		cBody += ENTER
		cBody += "Não foram enviadas informações de itens."+ENTER
	EndIf
Else
	// 2a. Parte
	
	// ** Detalhes das informações gravadas. (Capa)
	cBody += ENTER
	cBody += "Retorno do MATA410 - lMSErroAuto : "+IF(lMSErroAuto,".T.",".F.")+ENTER
	cBody += ENTER
	cBody += "Informações Gravadas - Capa"+ENTER
	cBody += Replic("-",27)+ENTER
	
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5")+M->EE7_PEDFAT))
		cBody += IncSpace("Campo",10,.f.)+Space(5)+IncSpace("Conteudo",60,.f.)+ENTER
		
		For i := 1 To SC5->(FCount())
			cBody += IncSpace(AllTrim(SC5->(FieldName(i))),10,.f.)+Space(5)+;
			IncSpace(AllTrim(Transf(SC5->(FieldGet(i)),AVSX3(SC5->(FieldName(i)),AV_PICTURE))),60,.f.)+ENTER
		Next
		
	Else
		cBody += "Não foi encontrado nenhum registro para o pedido nro : "+AllTrim(M->EE7_PEDFAT)+ENTER
	EndIf
	
	// ** Detalhes das informações gravadas. (Itens)
	cBody += ENTER
	cBody += "Informações Gravadas - Itens"+ENTER
	cBody += Replic("-",28)+ENTER
	
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6")+M->EE7_PEDFAT))
		Do While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And.;
			SC6->C6_NUM    == M->EE7_PEDFAT
			
			cBody += IncSpace("Campo",10,.f.)+Space(5)+IncSpace("Conteudo",60,.f.)+ENTER
			For i := 1 TO SC5->(FCount())
				cBody += IncSpace(AllTrim(SC6->(FieldName(i))),10,.f.)+Space(5)+;
				IncSpace(AllTrim(Transf(SC6->(FieldGet(i)),AVSX3(SC6->(FieldName(i)),AV_PICTURE))),60,.f.)+ENTER
			Next
			cBody += ENTER
			
			SC6->(DbSkip())
		EndDo
	Else
		cBody += "Não foi encontrado nenhum item para o pedido nro : "+AllTrim(M->EE7_PEDFAT)+ENTER
	EndIf
	
	// ** Rodape.
	cBody += Replic(ENTER,2)+Replic("*",70)
Endif

cErrorLog := cBody

cBuffer:=MemoRead(cFile)
MemoWrite(cFile,cBuffer+ENTER+cBody)

End Sequence

RestOrd(aOrd)

Return lRet
