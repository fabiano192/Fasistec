#INCLUDE "TOTVS.CH" 
#INCLUDE "TBICONN.CH"


User Function AS_PRENOTA(_aLinha)

	Local nOpc := 0 

	private aCabec:= {}
	private aItens:= {}
	private aLinha:= {}
	Private lMsErroAuto := .F.
	
	
	aCabec := 	{	{'F1_TIPO'	,'N'		,NIL},;		
	{'F1_FORMUL','S'		,NIL},;		
	{'F1_DOC'	,"999999"    	,NIL},;		
	{'F1_SERIE','   '		,NIL},;		
	{'F1_EMISSAO',dDataBase	,NIL},;		
	{'F1_FORNECE','000002'	,NIL},;		
	{'F1_LOJA'	,'01'		,NIL},;		
	{'F1_COND','001'		,NIL} }				

	aItens :=	{	{'D1_COD'	,"PA02"			,NIL},;		
	{'D1_UM'	,'UN'			,NIL},;				
	{'D1_QUANT',1			,NIL},;		
	{'D1_VUNIT',10000			,NIL},;		
	{'D1_TOTAL',10000			,NIL},;		
	{'D1_PEDIDO','000009'			,NIL},;		
	{'D1_ITEMPC','0001'			,NIL},;		
	{'D1_LOCAL','01'			,NIL}	}

	AAdd(aLinha,aItens)

	nOpc := 3

	MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens, nOpc)     

	If lMsErroAuto      
		mostraerro()
	Else   
		Alert("Ponto de entrada MATA140 executado com sucesso!")		
	EndIf

Return(Nil)