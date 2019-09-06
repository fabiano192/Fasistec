#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0131   ³ Autor ³ Fabiano da Silva      ³ Data ³ 07.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ficha Técnica                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaPcp / Sigaest                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function Pa0131()

Private _lPrim     := .T.
Private _lPassou   := .T.
Private _lPorta
Private _nTmp      := 0
Private _cTempo    := "",_cQtBll := "",_cQtBlR := "", _cMed2 := "",_cDesc := "",_cDesc2 := ""
private wnrel      := "PA0131"
private aOrd       := {}
//private aOrd       := {"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}
private cDesc      := "Este programa ira imprimir as Fichas Tecnicas"
private cDesc1     := ""
private cDesc2     := ""
private cString    := "SB1"
Private limite     := 80
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private tamanho    := "P"
Private titulo     := "Ficha Tecnica"
Private _cProdPa   := ""
cPerg              := "PA0131"
lEnd               := .F.
nLastKey           := 0

pergunte("PA0131",.F.)

wnrel := "PA0131"
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,cDesc1,cDesc2,.F.,aOrd,,Tamanho)

SetDefault(aReturn,cString)

_lPorta := .F.

If aReturn[5]==3
	_lPorta := .T.
Endif

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA131A(@_lFim) }
Private _cTitulo01 := 'Processando'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return NIL


Static Function PA131A(_lFim)

private CbCont,cabec1,cabec2
private nQuant     := 1
Private li         := 80

cbtxt              := SPACE(10)
cbcont             := 0
m_pag              := 1
cabec1             := ""
cabec2             := ""

_cCodCli           := ""
_cPedCli           := 0

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+MV_PAR01,.T.)

SetRegua(LastRec())

@ 0,0 PSAY AvalImp(Limite)

While !Eof() .And. !_lFim .And. SB1->B1_COD <= MV_PAR02
	
	IF _lFim
		@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
	
	cProduto  := SB1->B1_COD
	
	If !SB1->B1_GRUPO $ "PAV "
		dbSelectArea("SB1")
		dbSkip()
		Loop
	EndIf
	
	cabecOp()
	
	_aAliSB1 := SB1->(GETAREA())
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+SB1->B1_COD)
		_cProd  := SG1->G1_COD
		
		While !EOF() .And. _cProd  == SG1->G1_COD
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SG1->G1_COMP)
				If SB1->B1_FANTASM == "S"
					dbSelectArea("SG1")
					dbSkip()
					Loop
				Else
					
					@Li ,  0  PSay SB1->B1_COD 				   				// CODIGO PRODUTO
					@li ,  16 PSay Substr(SB1->B1_DESC,1,35)     			// Descrição Produto
					@Li ,  55 PSay SG1->G1_QUANT		Picture "@E 9,999.999999"			// QUANTIDADE
					//					@Li , (56+11-Len(SG1->G1_QUANT)) PSay SG1->G1_QUANT		// QUANTIDADE
					@Li ,  71 PSay SB1->B1_UM  					 	    	// UNIDADE DE MEDIDA
					@li ,  77 PSay SB1->B1_LOCPAD       	                // ALMOXARIFADO
					
					/*		@li ,  64 PSay Substr(aArray[I][7],1,12)         // LOCALIZACAO
					@li ,  76 PSay "|"+alltrim(aArray[I][8])                  // SEQUENCIA
					@li ,  79 PSay "|"
					*/
					Li++
					@Li,00 PSay REPLICATE("-",80)
					Li++
					
					IF li > 57 //63
						Li := 0
						cabecOp()		// imprime cabecalho da OP
					EndIF
				Endif
			Endif
			
			dbSelectArea("SG1")
			dbSkip()
		EndDo
	Endif
	
	dbSelectArea("SB1")
	RestArea(_aAliSB1)
	
	li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	ImpHist()
	
	m_pag++
	Li := 0					// linha inicial - ejeta automatico
	
	dbSelectArea("SB1")
	dbSkip()
EndDO

If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return NIL


Static Function CabecOp()

private cCabec1 := SM0->M0_NOME+"                   F I C H A   T E C N I C A                     "
private cCabec2 := "                            C O M P O N E N T E S                             "
private cCabec3 := "CODIGO          DESCRICAO                                QUANTIDADE    UM    AL "//LOCALIZACAO |SEQ"
//                12345678901234567890123456789012345678901234567890123456789012345678901234567890
//                1         2         3         4         5         6         7         8

If li #5
	li := 0
Endif

If _lPorta
	@Li,00 PSay REPLICATE("-",80)
Else
	@Li ,   0 PSay __prtfatline()
Endif

Li++
@Li,00  PSay cCabec1
Li++

If _lPorta
	@Li,00 PSay REPLICATE("-",80)
Else
	@Li ,   0 PSay __prtfatline()
Endif

Li+= 2
@Li,00 PSay "Produto: "+SB1->B1_COD+ " " +Substr(SB1->B1_DESC,1,25)
Li+= 2

If _lPorta
	@Li,00 PSay REPLICATE("-",80)
Else
	@Li ,   0 PSay __prtfatline()
Endif

Li+=2
@Li,00 PSay cCabec2
Li+= 2
@Li,00 PSay cCabec3
Li++

@Li,00 PSay REPLICATE("-",80)

Li++

Return


Static Function ImpHist()

If SB1->B1_TIPO == "PA"    // Primeira Via - Produto Acabado
	
	//	_lPrim   := .F.
	_lPassou := .T.
	_cProdPa := SB1->B1_COD
	_cMater  := ""
	_cSobra  := ""
	_cMed    := ""
	_cMed2   := ""
	_cHor    := ""
	_cVert   := ""
	_cFerr   := ""
	
	_cTipoFer := ""
	_cEspExt  := ""
	_cTmEst   := ""
	_cPosFaca := ""
	_cQtBat   := ""
	
	nEstru := 0
	aEstru := Estrut(_cProdPa)
	
	For E:= 1 To Len(aEstru)
		
		dbSelectarea("SB1")
		dbSetOrder(1)
		If dbseek(xFilial("SB1")+aEstru[E,3])
			If SB1->B1_TIPO == "FR"
				_cFerr   := SB1->B1_COD
			ElseIf Alltrim(SB1->B1_GRUPO) == "MPVZ" .And. SB1->B1_LOCPAD == "25"
				_cMater := Substr(SB1->B1_COD,1,11)
			ElseIf SB1->B1_LOCPAD == "26"
				_cSobra := Substr(SB1->B1_COD,1,11)
			ElseIf Alltrim(SB1->B1_GRUPO) == "PIBK"
				_nTmp     := 0
				
				dbSelectArea("SG2")
				dbSetOrder(1)
				If dbSeek(xFilial("SG2")+SB1->B1_COD)
					
					_cChavSG2 := SG2->G2_PRODUTO
					While !Eof() .And. _cChavSG2 == SG2->G2_PRODUTO
						
						_cDesc := ""
						dbSelectArea("SZ9")
						dbSetOrder(1)
						If dbSeek(xFilial("SZ9")+SG2->G2_CODOPER)
							dbSelectArea("SYP")
							dbSetOrder(1)
							If dbSeek(xFilial("SYP")+SZ9->Z9_CODMEMO)
								_cChav := SZ9->Z9_CODMEMO
								
								_cDesc := ""
								nTam    := Len(SYP->YP_TEXTO)
								While !Eof() .And. _cChav == SYP->YP_CHAVE
									
									nPos := At("\13\10",Subs(SYP->YP_TEXTO,1,nTam+6))
									If ( nPos == 0 )
										_cDesc += RTrim(Subs(SYP->YP_TEXTO,1,nTam))
									Else
										_cDesc += Subs(SYP->YP_TEXTO,1,nPos-1)
									EndIf
									dbSkip()
								EndDo
							Endif
						Endif
						
						_nTmp += SG2->G2_TEMPUNI
						
						dbSelectArea("SG2")
						dbSkip()
					EndDo
				Endif
					
					_cTempo :=  Transform(_nTmp,"@E 9,999.99")
					
					dbSelectArea("SG1")
					dbSetOrder(2)
					dbSeek(xFilial("SG1")+SB1->B1_COD)
					
					If SG1->G1_CORBLAN  == "V"
						_cVert   := "X"
						_cHor    := " "
					ElseIf SG1->G1_CORBLAN  == "H"
						_cVert   := " "
						_cHor    := "X"
					Else
						_cVert   := " "
						_cHor    := " "
					Endif
					
					_nQtBLL  := 1 / SG1->G1_QUANT
					_nQtBLL  := _nQtBLL * SG1->G1_QUANT
					_cQtBLL  := Transform(_nQtBLL,"@E 999")
					_cQtBLR  := Transform(SG1->G1_QTBLROL,"@E 999")
					_cMedRolC:= Alltrim(Transform(SG1->G1_MEDROLC,"@E 99.99"))
					_cMedRolL:= Alltrim(Transform(SG1->G1_MEDROLL,"@E 99.99"))
					_cMed    := SubSTR(_cMedRolC+" X "+_cMedRolL,1,15)
					_cMedBlC := Alltrim(Transform(SG1->G1_MEDBLAC,"@E 99.99"))
					_cMedBlL := Alltrim(Transform(SG1->G1_MEDBLAL,"@E 99.99"))
					_cMed2   := Substr(_cMedBlC+" X "+_cMedBlL,1,15)
				Endif
		Endif
	Next E
	
	li++
	
	RestArea(_aAliSB1)
	If ALLTRIM(SB1->B1_GRUPO) == "PAV"
		_nTmp2 := 0
		dbSelectArea("SG2")
		dbSetOrder(1)
		If dbSeek(xFilial("SG2")+SB1->B1_COD)
			
			_cChavSG2 := SG2->G2_PRODUTO
			While !Eof() .And. _cChavSG2 == SG2->G2_PRODUTO
				
				dbSelectArea("SH4")
				dbSetOrder(1)
				If dbSeek(xFilial("SH4")+SG2->G2_FERRAM)
					If SH4->H4_TIPOFER == "S"
						_cTipoFer := "SIM"
					Else
						_cTipoFer := "NAO"
					Endif
					_cFerr   := SG2->G2_FERRAM
					_cEspExt := Alltrim(Transform(SH4->H4_ESPEXTR,"@E 999.99"))
					_cPosFaca:= Substr(SH4->H4_POSFACA,1,11)
					_cQtBat  := Alltrim(Transform(SH4->H4_QTBATID,"@E 99.99"))
				Endif
				
				_cDesc2 := ""
				dbSelectArea("SZ9")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ9")+SG2->G2_CODOPER)
					dbSelectArea("SYP")
					dbSetOrder(1)
					If dbSeek(xFilial("SYP")+SZ9->Z9_CODMEMO)
						_cChav := SZ9->Z9_CODMEMO
						
						_cDesc2 := ""
						nTam    := Len(SYP->YP_TEXTO)
						While !Eof() .And. _cChav == SYP->YP_CHAVE
							
							nPos := At("\13\10",Subs(SYP->YP_TEXTO,1,nTam+6))
							If ( nPos == 0 )
								_cDesc2 += RTrim(Subs(SYP->YP_TEXTO,1,nTam))
							Else
								_cDesc2 += Subs(SYP->YP_TEXTO,1,nPos-1)
							EndIf
							dbSkip()
						EndDo
					Endif
				Endif
				
				_nTmp2 += SG2->G2_TEMPUNI
				
				dbSelectArea("SG2")
				dbSkip()
			EndDo
		Endif
		_cTempo2 :=  Transform(_nTmp2,"@E 9,999.99")
		_nCol    := 41
		
		/*
		|________________________________________|
		999999999999999999999999999999999999999999
		0		                                 41
		*/
		//		@Li,00 PSay " ________________________________________   ______________     _______________ "
		//		LI++
		//		@Li,00 PSay "|         FICHA TECNICA DO CORTE         | |  |  |  |  |  |   |_______|_______|"
		//		LI++
		//		@Li,00 PSay "|________________________________________| |  |  |  |  |  |   |_______|_______|"
		//		LI++
		//		@Li,00 PSay " ________________________________________  |__|__|__|__|__|   |_______|_______|"
		
		@Li,00 PSay " ________________________________________              ______________ "
		LI++
		@Li,00 PSay "|         FICHA TECNICA DO CORTE         |            (______________) "
		LI++
		@Li,00 PSay "|________________________________________|            |              | "
		LI++
		@Li,00 PSay " ________________________________________"
		@Li,_nCol PSay IIF (_cVert == "X","             |       |      | ","             |              | ")
		LI++
		@Li,00    PSay "| "
		@Li,_nCol PSay IIF (_cVert == "X","|            |       |      | ","|            |              | ")
		LI++
		@Li,00    PSay "| MATERIAL ................:"+_cMater
		@Li,_nCol PSay IIF (_cVert == "X","|            |       |      | ","|            |   ------->   | ")
		LI++
		@Li,00    PSay "| QTDE BLANK NA LARGURA ...:"+_cQtBll
		@Li,_nCol PSay IIF (_cVert == "X","|            |      \ /     | ","|            |              | ")
		LI++
		@Li,00    PSay "| QTDE BLANK POR ROLO .....:"+_cQtBlR
		@Li,_nCol PSay IIF (_cVert == "X","|            |       V      | ","|            |              | ")
		LI++
		@Li,00    PSay "| MEDIDA DO BLANK .........:"+_cMed2
//		@Li,00    PSay "| QTDE BLANK NA LARGURA ...:"+_cQtBll
		@Li,_nCol PSay "|            |______________| "
		LI++               
		@Li,00    PSay "| "
//		@Li,00    PSay "| QTDE BLANK POR ROLO .....:"+_cQtBlR
		@Li,_nCol PSay "|     CORTAR O BLANK NESTA POSICAO    "
		LI++
		@Li,00    PSay "| "
//		@Li,00    PSay "| MEDIDA DO BLANK .........:"+_cMed2
		@Li,00    PSay "|________________________________________| "
		LI+= 2
		
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
/*		
		li++
		@Li,00 PSay " INSTRUCAO DE PROCESSO DE CORTE:"
		@Li,79 PSAY " "
		Li++
		@Li,00 PSay " "
		Li++
		For I:= 1 to Len(_cDesc) Step 75
			@Li,00 PSay " "+Substr(_cDesc,I,75)
			@Li,79 PSay " "
			lI++
		Next I
		
		//@Li,00    PSAY "|"
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		//@Li,79    PSAY "|"
  */		
		Li++
		
		IF li > 57 //63
			Li := 0
			cabecOp()		// imprime cabecalho da OP
		EndIF
		
		//		@Li,00    PSay " ________________________________________"
		LI++
		@Li,00    PSay "        FICHA TECNICA DO BALANCIM         "
		LI++
		//		@Li,00    PSay " ________________________________________ "
		LI++
		//		@Li,00    PSay " ________________________________________"
		LI++
		@Li,00    PSay "  CODIGO DA FERRAMENTA.....: "+_cFerr
		//		@Li,_nCol PSay "|"
		LI++
		@Li,00    PSay "  FERRAMENTA C/EXTRATOR ?..: "+_cTipoFer
		@Li,_nCol PSay " "
		LI++
		@Li,00    PSay "  ESPESSURA DO EXTRATOR....: "+_cEspExt
		@Li,_nCol PSay " "
		LI++
		@Li,00    PSay "  TEMPO MIN.PARA ESTAMPAGEM: "+_cTempo2
		@Li,_nCol PSay " "
		LI++
		@Li,00    PSay "  POSICAO DA M.P. NA FACA..: "+_cPosFaca
		@Li,_nCol PSay " "
		LI++
		@Li,00    PSay "  QUANTIDADE DE BATIDAS  ..: "+_cQtBat
		@Li,_nCol PSay " "
		LI++
		//		@Li,00    PSay " ________________________________________  "
		LI+= 2
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		li++
		
		IF li > 57 //63
			Li := 0
			cabecOp()		// imprime cabecalho da OP
		EndIF
		                                                      
		@Li,71    PSay " REV.: 00 "
		    
		li++

		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		Li+=2
	Endif
	
Endif

Return