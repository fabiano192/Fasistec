#INCLUDE "Protheus.ch"
#INCLUDE "SCROLLBX.CH"
#include "JPEG.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  XCONSCAM   ºAutor  ³Artur Antunes       º Data ³  13/11/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Customizada do Cadastro de 			              º±±
±±º          ³ Peso e Dimensões para Caminhões                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//static nXCONRet := 0 
static nXCONRet := ""

User function tst_2SMCONCAM()
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv('99','01',,,"FAT")
	
	u_2SMCONCAM()
	
return


User Function 2SMCONCAM()
	
	local nP,nA,nV
	Local oPanel
	Local wAreaATU	:= GetArea()
	Local cTitulo	:= 'Tipo Veiculo'
	Local cTable	:= GetNewPar("MV_SMTVEIC","ZZJ")								//Tabela de tipo de veiculo
	Local cCpoCod	:= GetNewPar("MV_SMTVCOD","CODIGO")								//Campo dentro da tabela que contem o codigo
	Local cCpoDesc	:= GetNewPar("MV_SMTVDES","VEICUL")								//Campo dentro da tabela que contem a descrição
	Local cCpoImg	:= GetNewPar("MV_SMTVIMG","BITMAP")								//Campo dentro da tabela que contem a imagem
	Local cPrefix	:= If(substr(cTable,1,1)=="S",substr(cTable,2),cTable)+"_"		//Prefixo da tabela
	Local nVeicsPL	:= GetNewPar("MV_SMTVQPL",4)									//Quantidade de veiculos por linha
	Local nLinhas
	Local nVeic		:= 1
	//Variaveis de posicionamento	
	Local nTop		:= 2	
	Local nLeft		:= 2
	Local nBottom	
	Local nRight
	Local nLine
	Local nLineSize
	//Variaveis de imagem
	Local lRep		:= GetNewPar("MV_SMTVREP",.F.)								//Define se as imagens serão buscadas do Repositorio(.T.) ou pasta(.F)
	Local cLocImgs	:= Alltrim(GetNewPar("MV_SMTVLCI","\Imagens\tipoVeiculo\"))	//Caso use imagens por pasta, elas devem estar dentro da pasta definida nesse parametro.
	Local cExtensao	:= Alltrim(GetNewPar("MV_SMTVEXT",".JPG"))					//Extensão das imagens
	//
	Private oDlg
	Private aVeics	:= {}
	
	nXCONRet := ''

	//Busca os tipos de veiculo de acordo com os parametros
	DbSelectArea(cTable)
	DbGoTop()
	While (cTable)->(!EOF())
		nPosAux := aScan(aVeics,{|x| (cTable)->&(cPrefix+cCpoCod) == x[1]})
		if nPosAux == 0
			AAdd(aVeics,{(cTable)->&(cPrefix+cCpoCod),;			// 1 - Código
							(cTable)->&(cPrefix+cCpoDesc),;		// 2 - Descrição
							(cTable)->&(cPrefix+cCpoImg)})		// 3 - Imagem
		endif
		(cTable)->(DbSkip())
	end
	
	//Tabela está zerada
	If Len(aVeics) == 0 
		Alert("Não há tipos de veiculos cadastrados, favor cadastre-os!!")
		return .F.
	endif

	//Cria o Dialog e Painel para receber os tipos de veiculo
	oDlg 	:= TDialog():New(0,0,550,1210,cTitulo,,,,,,,,,.T.)
	oPanel	:= TScrollBox():New(oDlg,1,1,274,604,.T.,.F.,.T.)
	//Divide a area inicial em 4 partes para captura dos tamanhos
	aAreaTotal1 	:= {0,0,604,274,2,2} 
	nDivisoes1		:= 4
	aProp1			:= {{0,25},{0,25},{0,25},{0,25}}
	oArea1 			:= redimensiona():New(aAreaTotal1,nDivisoes1,aProp1,.F.) 
	aArea1			:= oArea1:RetArea()
	//
	nLinhas 	:= LEN(aVeics)/nVeicsPL 		//Define o numero de linhas
	nLine		:= aArea1[1,3] - aArea1[1,1] 	//Define o tamanho da linha 
	nLeft 		:= aArea1[1,2]			
	nRight		:= aArea1[1,4] - 10				 			
	//
	for nV := 1 to nLinhas
		if nV > 1 
			nTop += nLine
		endif
		
		aAreaTotalV 	:= {nLeft,nTop,nRight,nTop+nLine,5,1} 
		nDivisoesV		:= nVeicsPL
		aPropV			:= {}
		for nP := 1 to nVeicsPL
			AAdd(aPropV,{100,0})
		next nP
		oAreaV 			:= redimensiona():New(aAreaTotalV,nDivisoesV,aPropV,.T.) 
		aAreaV			:= oAreaV:RetArea()
		
		for nA := 1 to nVeicsPL
			aAreaTotalO 	:= {aAreaV[nA,2],aAreaV[nA,1],aAreaV[nA,4],aAreaV[nA,3],0,1} 
			nDivisoesO		:= 2
			aPropO			:= {{0,80},{0,20}}
			oAreaO 			:= redimensiona():New(aAreaTotalO,nDivisoesO,aPropO,.F.) 
			aAreaO			:= oAreaO:RetArea()			
		
			if nVeic <= LEN(aVeics)
				//bBitmap := "{|| IF(MsgYesNo('Deseja selecionar o tipo de veiculo:'+CHR(10)+CHR(13)+ "
				//bBitmap += "aVeics["+cValToChar(nVeic)+",1] + ' - ' + aVeics["+cValToChar(nVeic)+",2],'Atenção'), "
				//bBitmap += "(nXCONRet := aVeics["+cValtoChar(nVeic)+",1], oDlg:End()),)}"
				//bBitmap := "{|| Alert('Clique no caminhão [' + aVeics["+cValToChar(nVeic)+",1] + ']') }"
				bBitmap := "{|| SMSEL("+cValToChar(nVeic)+") }"
				if lRep // Usa imagem por repositorio
					TBitmap():New(aAreaO[1,1],aAreaO[1,2],aAreaO[1,4]-aAreaO[1,2],aAreaO[1,3]-aAreaO[1,1],aVeics[nVeic,3],,;
									.T.,oPanel,&(bBitmap),,.F.,.F.,,,,{||},.T.)
					
				else
					TBitmap():New(aAreaO[1,1],aAreaO[1,2],aAreaO[1,4]-aAreaO[1,2],aAreaO[1,3]-aAreaO[1,1],aVeics[nVeic,3],;
									cLocImgs+Alltrim(aVeics[nVeic,3])+cExtensao,.F.,oPanel,&(bBitmap),,.F.,.F.,,,,{||},.T.)
				endif
				bSay := "{|| aVeics["+cValToChar(nVeic)+",1] + ' - ' + aVeics["+cValToChar(nVeic)+",2] }"
				TSay():New(aAreaO[2,1],aAreaO[2,2],&(bSay),oPanel,"@!",/*oFont*/,,,,.T.,/*nClrText*/,,;
							aAreaO[2,4]-aAreaO[2,2],aAreaO[2,3]-aAreaO[2,1])
				nVeic += 1
			endif
			
			//TGroup():New(aAreaV[nA,1],aAreaV[nA,2],aAreaV[nA,3],aAreaV[nA,4],'',oPanel,,,.T.)
		next nA
	
		nTop  += 2
	next nV
	
	oDlg:Activate(,,,.T.)
	
	restArea(wAreaATU)
	
return .T.

Static function SMSEL(p_nPos)

	Local nPos := p_nPos
	
	If MsgYesNo('Deseja selecionar o tipo de veiculo: '+CHR(10)+CHR(13)+aVeics[nPos,1]+' - '+aVeics[nPos,2],'Atenção')
		nXCONRet := aVeics[nPos,1]
		oDlg:End()
	endif

return

user Function 2SMRETCAM() 
return nXCONRet

User Function SMCONCAM()    // u_smconcam()

local aArea     := GetArea()
local nBloco 	:= 0
local nQtdBloco := 4  
local cRecno	:= .F.

local nLargImg 	:= 125
local nAltImg 	:= 46 // 40
local nDistHor 	:= 35 
local nDistVert := 8
local nHorB  	:= 1
local nVertB  	:= 1                     

local nLargChk 	:= 125
local nAltChk 	:= 8
local nDtHorChk := 140 
local nDtVertChk:= 47
local nHorChkini:= 7
local nHorChk  	:= nHorChkini
local nVertChk  := 47
local nVtChkInt := 7 
local nDifBloc1 := 2 
local nDifBloc2 := 3
local nDifBloc3 := 1
local nDifBloc4 := 2
local nDifBloc5 := 2
local nDifBloc6 := 2                       

local nTempInt  := 0 
local nInterv   := 3 
local nVertBot  := 260
local nLargBot	:= 30  
local nAltBot	:= 11

private nItens 	:= 0 
private aDados 	:= {}

nXCONRet := "" 
oDlg:=MSDialog():New(0,0,550,1210,"Tipo Veiculo#",,,,,CLR_BLACK,,,,.T.) // 0,0,650,850,  -> usou para teste val(m->z8_obs)
oPanel := TScrollBox():New(oDlg,01,01,250,590,.T.,.T.,.T.)            //,01,01,250,425 val(m->z8_lacre)

//dbselectarea("ZZJ")
ZZJ->(dbsetorder(1))
ZZJ->(msSeek(xFilial("ZZJ")))
  
_cKey := xFilial("ZZJ")
//ZZJ->(dbGotop())
While ZZJ->(!EOF()) .And. _cKey == ZZJ->ZZJ_FILIAL
    
//	AADD(aDados,{ZZJ->ZZJ_CODIGO,CapitalAce(Alltrim(ZZJ->ZZJ_VEICUL)),ZZJ->ZZJ_PEBRTO,ZZJ->(Recno())})
	AADD(aDados,{ZZJ->ZZJ_CODIGO,ZZJ->ZZJ_CODIGO+"-"+CapitalAce(Alltrim(ZZJ->ZZJ_VEICUL)),ZZJ->ZZJ_PEBRTO,ZZJ->(Recno())})
	
	nItens++
	nBloco++
	if nBloco > nQtdBloco
		nBloco := 1
		nHorB  := 1
		nVertB += nDistVert 
	endif	
	&("oImg"+alltrim(cvaltochar(nItens))):= TBmpRep():New(nVertB,nHorB,nLargImg,nAltImg,Alltrim(ZZJ->ZZJ_BITMAP),.f.,oPanel)
	&("oImg"+alltrim(cvaltochar(nItens))):LoadBMP(Alltrim(ZZJ->ZZJ_BITMAP))
	nHorB += nDistHor

	ZZJ->(dbskip()) 
end

if nItens >= 1
	lCheck1 := .F.                                                                        
	oCheck1 := TCheckBox():New(nVertChk, nHorChk,aDados[1,2],{|| lCheck1},oPanel,nLargChk,nAltChk,,{|| ( lCheck1:=!lCheck1,MarDesAll(lCheck1,1) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 2
	lCheck2 := .F.                                                                        
	oCheck2 := TCheckBox():New(nVertChk, nHorChk,aDados[2,2],{|| lCheck2},oPanel,nLargChk,nAltChk,,{|| ( lCheck2:=!lCheck2,MarDesAll(lCheck2,2) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 3
	lCheck3 := .F.                                                                        
	oCheck3 := TCheckBox():New(nVertChk, nHorChk,aDados[3,2],{|| lCheck3},oPanel,nLargChk,nAltChk,,{|| ( lCheck3:=!lCheck3,MarDesAll(lCheck3,3) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 4
	lCheck4 := .F.                                                                        
	oCheck4 := TCheckBox():New(nVertChk, nHorChk,aDados[4,2],{|| lCheck4},oPanel,nLargChk,nAltChk,,{|| ( lCheck4:=!lCheck4,MarDesAll(lCheck4,4) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
nHorChk  := nHorChkini
nVertChk  += nDtVertChk + nVtChkInt + nDifBloc1            
if nItens >= 5
	lCheck5 := .F.                                                                        
	oCheck5 := TCheckBox():New(nVertChk, nHorChk,aDados[5,2],{|| lCheck5},oPanel,nLargChk,nAltChk,,{|| ( lCheck5:=!lCheck5,MarDesAll(lCheck5,5) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 6
	lCheck6 := .F.                                                                        
	oCheck6 := TCheckBox():New(nVertChk, nHorChk,aDados[6,2],{|| lCheck6},oPanel,nLargChk,nAltChk,,{|| ( lCheck6:=!lCheck6,MarDesAll(lCheck6,6) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 7
	lCheck7 := .F.                                                                        
	oCheck7 := TCheckBox():New(nVertChk, nHorChk,aDados[7,2],{|| lCheck7},oPanel,nLargChk,nAltChk,,{|| ( lCheck7:=!lCheck7,MarDesAll(lCheck7,7) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 8
	lCheck8 := .F.                                                                        
	oCheck8 := TCheckBox():New(nVertChk, nHorChk,aDados[8,2],{|| lCheck8},oPanel,nLargChk,nAltChk,,{|| ( lCheck8:=!lCheck8,MarDesAll(lCheck8,8) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
nHorChk  := nHorChkini
nVertChk  += nDtVertChk + nVtChkInt + nDifBloc2               
if nItens >= 9
	lCheck9 := .F.                                                                        
	oCheck9 := TCheckBox():New(nVertChk, nHorChk,aDados[9,2],{|| lCheck9},oPanel,nLargChk,nAltChk,,{|| ( lCheck9:=!lCheck9,MarDesAll(lCheck9,9) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 10
	lCheck10 := .F.                                                                        
	oCheck10 := TCheckBox():New(nVertChk, nHorChk,aDados[10,2],{|| lCheck10},oPanel,nLargChk,nAltChk,,{|| ( lCheck10:=!lCheck10,MarDesAll(lCheck10,10) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 11
	lCheck11 := .F.                                                                        
	oCheck11 := TCheckBox():New(nVertChk, nHorChk,aDados[11,2],{|| lCheck11},oPanel,nLargChk,nAltChk,,{|| ( lCheck11:=!lCheck11,MarDesAll(lCheck11,11) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 12
	lCheck12 := .F.                                                                        
	oCheck12 := TCheckBox():New(nVertChk, nHorChk,aDados[12,2],{|| lCheck12},oPanel,nLargChk,nAltChk,,{|| ( lCheck12:=!lCheck12,MarDesAll(lCheck12,12) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
nHorChk  := nHorChkini
nVertChk  += nDtVertChk + nVtChkInt + nDifBloc3                
if nItens >= 13
	lCheck13 := .F.                                                                        
	oCheck13 := TCheckBox():New(nVertChk, nHorChk,aDados[13,2],{|| lCheck13},oPanel,nLargChk,nAltChk,,{|| ( lCheck13:=!lCheck13,MarDesAll(lCheck13,13) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 14
	lCheck14 := .F.                                                                        
	oCheck14 := TCheckBox():New(nVertChk, nHorChk,aDados[14,2],{|| lCheck14},oPanel,nLargChk,nAltChk,,{|| ( lCheck14:=!lCheck14,MarDesAll(lCheck14,14) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 15
	lCheck15 := .F.                                                                        
	oCheck15 := TCheckBox():New(nVertChk, nHorChk,aDados[15,2],{|| lCheck15},oPanel,nLargChk,nAltChk,,{|| ( lCheck15:=!lCheck15,MarDesAll(lCheck15,15) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 16
	lCheck16 := .F.                                                                        
	oCheck16 := TCheckBox():New(nVertChk, nHorChk,aDados[16,2],{|| lCheck16},oPanel,nLargChk,nAltChk,,{|| ( lCheck16:=!lCheck16,MarDesAll(lCheck16,16) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
nHorChk  := nHorChkini
nVertChk  += nDtVertChk + nVtChkInt + nDifBloc4                 
if nItens >= 17
	lCheck17 := .F.                                                                        
	oCheck17 := TCheckBox():New(nVertChk, nHorChk,aDados[17,2],{|| lCheck17},oPanel,nLargChk,nAltChk,,{|| ( lCheck17:=!lCheck17,MarDesAll(lCheck17,17) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 18
	lCheck18 := .F.                                                                        
	oCheck18 := TCheckBox():New(nVertChk, nHorChk,aDados[18,2],{|| lCheck18},oPanel,nLargChk,nAltChk,,{|| ( lCheck18:=!lCheck18,MarDesAll(lCheck18,18) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 19
	lCheck19 := .F.                                                                        
	oCheck19 := TCheckBox():New(nVertChk, nHorChk,aDados[19,2],{|| lCheck19},oPanel,nLargChk,nAltChk,,{|| ( lCheck19:=!lCheck19,MarDesAll(lCheck19,19) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 20
	lCheck20 := .F.                                                                        
	oCheck20 := TCheckBox():New(nVertChk, nHorChk,aDados[20,2],{|| lCheck20},oPanel,nLargChk,nAltChk,,{|| ( lCheck20:=!lCheck20,MarDesAll(lCheck20,20) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
nHorChk  := nHorChkini
nVertChk  += nDtVertChk + nVtChkInt + nDifBloc5                
if nItens >= 21
	lCheck21 := .F.                                                                        
	oCheck21 := TCheckBox():New(nVertChk, nHorChk,aDados[21,2],{|| lCheck21},oPanel,nLargChk,nAltChk,,{|| ( lCheck21:=!lCheck21,MarDesAll(lCheck21,21) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 22
	lCheck22 := .F.                                                                        
	oCheck22 := TCheckBox():New(nVertChk, nHorChk,aDados[22,2],{|| lCheck22},oPanel,nLargChk,nAltChk,,{|| ( lCheck22:=!lCheck22,MarDesAll(lCheck22,22) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 23
	lCheck23 := .F.                                                                        
	oCheck23 := TCheckBox():New(nVertChk, nHorChk,aDados[23,2],{|| lCheck23},oPanel,nLargChk,nAltChk,,{|| ( lCheck23:=!lCheck23,MarDesAll(lCheck23,23) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 24
	lCheck24 := .F.                                                                        
	oCheck24 := TCheckBox():New(nVertChk, nHorChk,aDados[24,2],{|| lCheck24},oPanel,nLargChk,nAltChk,,{|| ( lCheck24:=!lCheck24,MarDesAll(lCheck24,24) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
nHorChk  := nHorChkini
nVertChk  += nDtVertChk + nVtChkInt + nDifBloc6               
if nItens >= 25
	lCheck25 := .F.                                                                        
	oCheck25 := TCheckBox():New(nVertChk, nHorChk,aDados[25,2],{|| lCheck25},oPanel,nLargChk,nAltChk,,{|| ( lCheck25:=!lCheck25,MarDesAll(lCheck25,25) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 26
	lCheck26 := .F.                                                                        
	oCheck26 := TCheckBox():New(nVertChk, nHorChk,aDados[26,2],{|| lCheck26},oPanel,nLargChk,nAltChk,,{|| ( lCheck26:=!lCheck26,MarDesAll(lCheck26,26) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 27
	lCheck27 := .F.                                                                        
	oCheck27 := TCheckBox():New(nVertChk, nHorChk,aDados[27,2],{|| lCheck27},oPanel,nLargChk,nAltChk,,{|| ( lCheck27:=!lCheck27,MarDesAll(lCheck27,27) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	
if nItens >= 28
	lCheck28 := .F.                                                                        
	oCheck28 := TCheckBox():New(nVertChk, nHorChk,aDados[28,2],{|| lCheck28},oPanel,nLargChk,nAltChk,,{|| ( lCheck28:=!lCheck28,MarDesAll(lCheck28,28) )},,,,,,.T.,,,)
	nHorChk += nDtHorChk  
endif	

nTempInt += nInterv
oButOK  := TButton():New(nVertBot,nTempInt,'OK',oDlg,{|| nXCONRet:=RetMark(1),oDlg:End() },nLargBot,nAltBot,,,,.T.) 
nTempInt += nInterv + nLargBot
oButCan := TButton():New(nVertBot,nTempInt,'Cancelar',oDlg,{|| oDlg:End() },nLargBot,nAltBot,,,,.T.)
nTempInt += nInterv + nLargBot
oButVis := TButton():New(nVertBot,nTempInt,'Visualizar',oDlg,{|| VisualPadrao()},nLargBot,nAltBot,,,,.T.)

oDlg:activate(,,,.T.)
RestArea(aArea)
Return .T.  


static function MarDesAll(lMark,nItem)

local nx

for nx:=1 to nItens
	if nx # nItem
		&("lCheck"+alltrim(cvaltochar(nx))) := .F.
		&("oCheck"+alltrim(cvaltochar(nx))):Refresh()
	endif
next nx
return      


static function RetMark(nOpc)

local nx

local nRet := ""
//local nRet := 0
for nx:=1 to nItens
	if nOpc == 1
		if &("lCheck"+alltrim(cvaltochar(nx))) 
			nRet := aDados[nx,1]
		endif
	elseif nOpc == 2
		if &("lCheck"+alltrim(cvaltochar(nx))) 
			nRet := aDados[nx,4]
		endif
	endif	
next nx
return nRet


static function VisualPadrao() // Visualizar cadastro
dbselectarea("ZZJ") 
dbsetorder(1)
DbGoto(RetMark(2))
AxVisual("ZZJ",ZZJ->(RECNO()),2)                                 
return


user Function SMRETCAM() //Retorno da Consulta
return nXCONRet