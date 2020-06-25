/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPXH031  บAutor  ณMarcio Aflitos      บ Data ณ  03/08/13     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CADASTRO E CONTROLE DE PARADAS DE PRODUCAO                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "TOTVS.CH"


USER Function PXH031()

Local _cAlias := "SZA"
Local aCores := {}
Local oBrowse

Private cCadastro := "Controle Paradas de Producao"
Private aRotina := {}  
Private cPerg:="PXH031"
	
IF !( _cAlias $ CARQTAB)
	Alert("EMPRESA NรO CONTROLA PARADAS DE PRODUวรO")
	RETURN 
ENDIF

AADD(aRotina,{"Pesquisar"  ,"AxPesqui",0,1})
AADD(aRotina,{"Visualizar" ,"u_PXH031_MAN",0,2})
AADD(aRotina,{"Paradas"    ,"u_PXH031_MAN",0,3})

PXh031_SX1()
SetKey( VK_F12, {|| Pergunte(cPerg,.T.) })  //PXH031_PARAM()
Pergunte(cPerg,.F.)

dbSelectArea(_cAlias) //Cadastro de Tags - faz assim pra criar a tabela se necessario
dbSetOrder(1)

mBrowse(6,1,22,75,_cAlias)

Set Key VK_F12 To

Return Nil


//MANUTENCAO REGISTROS DE PARADA DE MAQUINA
User Function PXH031_MAN(_cAlias, nReg, nOpc )

Local oFont1 := TFont():New("Arial Narrow",,028,,.F.,,,,,.F.,.F.)
Local obtSair

LOCAL aArea:=GetArea()
LOCAL aMeses:={"JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"}
LOCAL nn
LOCAL nMes
LOCAL aMotivos:={}
Local oAnoMov

PRIVATE oTFolder
PRIVATE aGetD:={}
PRIVATE lVisual :=(nOpc==2)
PRIVATE cIdTag:=""
PRIVATE cAnoMov:=""
PRIVATE cMotivos:=""


cAnoMov:=iif( Empty(MV_PAR01), Left(dTOs(DDATABASE),4), MV_PAR01)
nMes:=iif( Left(dTOs(DDATABASE),4) = MV_PAR01, Month(DDATABASE),1)

//cMotivos:="1 =Mecanica;2 =Eletrica/Autom;3 =Hidraulica;4 =Falta Material;5 =Transporte;6 =Troca Martelos"
aMotivos:=FWGetSX5 ( "ZB" ) //<cTable >, [ cKey ] )  //Criada tabela ZB para Motivos de Parada
Aeval(aMotivos,{|mm| cMotivos += PadR(Alltrim(mm[3]),2)+"="+Capital(Alltrim(mm[4]))+";" })

DbSelectArea("SZB")
SZB->(DbSetOrder(1))

cIdTag:=SZA->ZA_TAG
 
DEFINE MSDIALOG oDlg TITLE "Paradas de Producao" FROM 000,000 TO 681,858 PIXEL
// Cria a Folder    
aTFolder := aClone(aMeses)//top  lef                        larg  alt   
oTFolder := TFolder():New(   45,   0,aTFolder,,oDlg,,,,.T.,, 430, 297 )   //FOLDER - MESES

FOR nn:=1 to Len(aMeses)  //CRIA FOLDER PARA CADA MES COM GETDADOS
	AAdd(aGetD,fMSNewGetD( cAnoMov, nn, 000, 000, 284, 430))  //GETDADOS - DIAS
NEXT 

oTFolder:SetOption( nMes )
//aGetD[nMes]:goto( day(DDATABASE) )
aGetD[nMes]:goto( iif( Left(dTOs(DDATABASE),4) = MV_PAR01, day(DDATABASE), 1) )

@ 019, 019 SAY oSay1 PROMPT "ANO :" SIZE 027, 011 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
@ 017, 047 MSGET oAnoMov VAR cAnoMov SIZE 031, 014 OF oDlg COLORS 0, 16777215 FONT oFont1 PIXEL
@ 019, 358 BUTTON obtSair PROMPT "SAIR" SIZE 037, 012 OF oDlg FONT oFont1 ACTION oDlg:end() PIXEL

 
ACTIVATE DIALOG oDlg CENTERED
    
RestArea(aArea)

Return

//------------------------------------------------ 
Static Function fMSNewGetD( cAnoRef, nMes, nTop, nLef, nBot, nRig )
//------------------------------------------------ 
Local nX, nY
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields      := {"NDIA","ZB_T01","ZB_M01","ZB_T02","ZB_M02","ZB_T03","ZB_M03","ZB_T04","ZB_M04","ZB_T05","ZB_M05","ZB_T06","ZB_M06","ZB_T07","ZB_M07","ZB_T08","ZB_M08","ZB_T09","ZB_M09"}
Local aAlterFields := {"ZB_T01","ZB_M01","ZB_T02","ZB_M02","ZB_T03","ZB_M03","ZB_T04","ZB_M04","ZB_T05","ZB_M05","ZB_T06","ZB_M06","ZB_T07","ZB_M07","ZB_T08","ZB_M08","ZB_T09","ZB_M09"}
LOCAL oNewGetD
LOCAL nDia:=0
LOCAL nLastDay:=Day(LastDay(Ctod("01/"+StrZero(nMes)+"/"+cAnoRef),0))
LOCAL cChv:=""
LOCAL nModo:=0
//LOCAL cMotivos:="1=Mecanica;2=Elet/Aut;3=Hidrauli;4=FaltaMat;5=Transpor;6=TrMartel"

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))

//Aadd(aHeaderEx,{"Dia","NDIA","99",02,0,.T.,"๛","C","",,,,,,".T.", } ) //Item
Aadd(aHeaderEx,{"Dia","NDIA","XX", 2,0,.T.,,"C"} )
Aadd(aFieldFill, "01" ) //CriaVar(SX3->X3_CAMPO))

For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,IIF(LEFT(SX3->X3_CAMPO,4)=="ZB_T","@ZE 999.99",SX3->X3_PICTURE),SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                    SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,IIF(LEFT(SX3->X3_CAMPO,4)="ZB_M",cMotivos,SX3->X3_CBOX),SX3->X3_RELACAO})

		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX

// Define field values
Aadd(aFieldFill, .F.)  //ultima coluna da acols que define se linha esta deletada ou nao
aColsEx:=Array(nLastDay)

FOR nX:=1 to nLastDay
	
	FOR nY:=1 to Len( aHeaderEx )  //percorre Campos da linha
		IF aHeaderEx[nY,2] == "NDIA"
			aFieldFill[nY]:=StrZero(nX,2)
		ENDIF
	NEXT

	aColsEx[nX]:=aClone(aFieldFill)
NEXT


//CARREGAR DADOS
DbSelectArea("SZB")
DbSetOrder(1)
cChv:=xFilial("SZB") + cIdTag + cAnoRef + StrZero(nMes,2,0)

IF SZB->(DbSeek( cChv ))

	DO WHILE (ZB_FILIAL + ZB_TAG + Left(Dtos(ZB_DIA),6)) == cChv
		nDia:=Day( SZB->ZB_DIA )
		FOR nX:=1 to Len(aHeaderEx) 
			IF Left(aHeaderEx[nX,2],4) == 'ZB_T'
				aColsEx[nDia,nX]:=&(aHeaderEx[nX,2])
			ELSEIF Left(aHeaderEx[nX,2],4) == 'ZB_M'
				aColsEx[nDia,nX]:=&(aHeaderEx[nX,2])
			ENDIF
		NEXT
		DbSkip()
	ENDDO
ENDIF
nModo:=IIF( lVisual,0, GD_UPDATE)
oNewGetD := MsNewGetDados():New( nTop, nLef, nBot, nRig, nModo, "AllwaysTrue","AllwaysTrue", "", aAlterFields,1, nLastDay, "u_PXH031Grv", "", "AllwaysTrue", oTFolder:aDialogs[nMes], aHeaderEx, aColsEx)

Return oNewGetD



USER FUNCTION PXH031Grv()
LOCAL xInfo
LOCAL nMes:=0
LOCAL dDia:=""
LOCAL cVar:=""
LOCAL cChv:=""
LOCAL lIncl:=.F.

DbSelectArea('SZB')
OrdSetFocus(1)

nMes:=oTFolder:nOption
dDia:=Ctod( StrZero(aGetD[nMes]:nAt,2)+"/"+StrZero(nMes,2,0)+"/"+cAnoMov )

cVar :=ReadVar()
xInfo:=&(cVar) //GdFieldGet(cVar,,.T.)
cVar :=StrTran(cVar,"M->","SZB->")
cChv :=xFilial("SZB") + cIdTag + DTos( dDia )  //cIdTag+cAnoMov+StrZero(nMes,2,0)+StrZero(nDia,2,0)

IF cChv <> SZB->(ZB_FILIAL+ZB_TAG+Dtos(ZB_DIA))
	lIncl:=!( DbSeek( cChv ))
ENDIF
RecLock("SZB",lIncl)
IF lIncl
	SZB->ZB_TAG:=cIdTAg
	SZB->ZB_DIA:=dDia
ENDIF
&(cVar):=xInfo

MsUnLock()

RETURN .T.


/*
Static Function PXH031_Param()

Local aPergs := {}

Local cAnoRef := "2013"
Local aRet := {}
Local lRet

aAdd( aPergs ,{1,"Ano Referencia : ",cAnoRef,"@9",'.T.',,'.T.',50,.T.})

lREt:=ParamBox(aPergs ,"Parametros",@aRet,,,.T.,,,,("PXH031"+cFilAnt+"A"),.T.,.T.)  //ATENCAO: SE ALTERAR PERGS MUDE A VERSAO "A" PARA "B" E ASSIM POR DIANTE

Return lRet
*/

STATIC  Function PXH031_SX1()
Local aHelpPor 	:= {}
Local aHelpEsp 	:= {}              
Local aHelpIng 	:= {}
Local cStringP   := ""  // texto em portugues
Local cStringE   := ""	// texto em espanhol
Local cStringI   := ""  // texto em ingles

// incluindo Pergunta do tipo Data
Aadd( aHelpPor, "Informe o Ano de Referencia para a " )
Aadd( aHelpPor, "Tela de lan็amentos de parada      " )

aHelpIng := aHelpEsp := aHelpPor 
cStringP := "Ano Referencia"
cStringE := cStringP + " - ESP"
cStringI := cStringP + " - ING"

PutSx1(cPerg,"01",cStringP,cStringE,cStringI,;
		"mv_ch1","C",4,;
		0,0,"G",;
		"","","",;
		"","mv_par01","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		aHelpPor,aHelpIng,aHelpEsp)     

RETURN
