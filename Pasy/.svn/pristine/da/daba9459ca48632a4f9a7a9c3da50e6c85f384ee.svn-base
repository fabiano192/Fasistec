/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥RELGRAFICO∫Autor  ≥Marcio de Lima      ∫ Data ≥  09/13/05   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Tem o objetivo de realizar um pareto com tres series       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP7                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

#include "Protheus.Ch"
//#include 'fivewin.ch'               
#include "msgraphi.ch"

// #DEFINE D_PRELAN		"9"
                              
User Function gergrafo(TITULO)     
LOCAL AAREA       := GETAREA()
Local oFld        := Nil
Local cVar        := Nil
Local oBold       := Nil 
Local oChk1       := Nil 
Local oChk2       := Nil 
Local nSerie      := 0
Local oMSGraphic  
Private oLege     := Nil 
Private Serie1    := space(20)
Private Serie2    := space(20)
Private Serie3    := space(20)
Private oBARVER1  := Nil
Private oBARVER2  := Nil
Private oBARHOR1  := Nil
Private oBARHOR2  := Nil
Private cPerg     := "EFICIE"
Private aPerg     := {}
Private aVetGr01  := {}
Private aVetGr02  := {}
Private aVetGr03  := {}
Private oOk       := LoadBitmap( GetResources(), "LBOK" )
Private oNo       := LoadBitmap( GetResources(), "LBNO" )
Private lChk1     := .F.
Private lChk2     := .F.
Private lChk3     := .F.
Private oLbx1     := Nil
Private oLbx2     := Nil
Private oLbx3     := Nil
Private oGraOk    := Nil   
Private cTitulo   := "GeraÁ„o de Graficos"
Private cArqTrab1 := ''     
Private cArqTrab2 := ''     
Private oCbt1     := Nil
Private oCbt2     := Nil
Private oCbt3     := Nil
Private cCbt1     := "Linha"
Private cCbt2     := "Linha"
Private cCbt3     := "Linha"
Private BARVER1   := Titulo
Private BARVER2   := space(47)
Private BARHOR1   := space(47)
Private BARHOR2   := space(47)                
Private nCbt1     := 1
Private nCbt2     := 1
Private nCbt3     := 1
Private nSerie1   := Nil
Private nSerie2   := Nil 
Private nSerie3   := Nil 
Private cGrafic   := .t.

Private aCbt      := {"Linha", "¡rea", "Pontos", "Barras", "Piramid", "Cilindro","Barras Horizontal",;
                      "Piramid Horizontal", "Cilindro Horizontal"}

Aadd(aVetGr01,{.t.,"JAN/05",35.5})
Aadd(aVetGr01,{.t.,"FEV/05",35.5})
Aadd(aVetGr01,{.t.,"MAR/05",35.5})
Aadd(aVetGr01,{.t.,"ABR/05",35.5})
Aadd(aVetGr01,{.t.,"MAI/05",35.5})
Aadd(aVetGr01,{.t.,"JUN/05",35.5})
Aadd(aVetGr01,{.t.,"JUL/05",50.0})
Aadd(aVetGr01,{.t.,"AGO/05",50.0})
Aadd(aVetGr01,{.t.,"SET/05",50.0})
Aadd(aVetGr01,{.t.,"OUT/05",50.0})
Aadd(aVetGr01,{.t.,"NOV/05",50.0})
Aadd(aVetGr01,{.t.,"DEZ/05",50.0})

Aadd(aVetGr02,{.t.,"JAN/05",35.5})
Aadd(aVetGr02,{.t.,"FEV/05",10.5})
Aadd(aVetGr02,{.t.,"MAR/05",05.0})
Aadd(aVetGr02,{.t.,"ABR/05",60.5})
Aadd(aVetGr02,{.t.,"MAI/05",35.5})
Aadd(aVetGr02,{.t.,"JUN/05",50.0})
Aadd(aVetGr02,{.t.,"JUL/05",30.7})
Aadd(aVetGr02,{.t.,"AGO/05",32.0})
Aadd(aVetGr02,{.t.,"SET/05",45.5})
Aadd(aVetGr02,{.t.,"OUT/05",15.5})
Aadd(aVetGr02,{.t.,"NOV/05",15.5})
Aadd(aVetGr02,{.t.,"DEZ/05",85.5})

Aadd(aVetGr03,{.t.,"JAN/05",55.5})
Aadd(aVetGr03,{.t.,"FEV/05",55.5})
Aadd(aVetGr03,{.t.,"MAR/05",55.5})
Aadd(aVetGr03,{.t.,"ABR/05",55.5})
Aadd(aVetGr03,{.t.,"MAI/05",55.5})
Aadd(aVetGr03,{.t.,"JUN/05",55.5})
Aadd(aVetGr03,{.t.,"JUL/05",20.0})
Aadd(aVetGr03,{.t.,"AGO/05",20.0})
Aadd(aVetGr03,{.t.,"SET/05",20.0})
Aadd(aVetGr03,{.t.,"OUT/05",20.0})
Aadd(aVetGr03,{.t.,"NOV/05",20.0})
Aadd(aVetGr03,{.t.,"DEZ/05",20.0})

DEFINE MSDIALOG oGraOk FROM 0,0 TO 510,760 TITLE cTitulo PIXEL 

DEFINE FONT oBold  NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oBold2 NAME "Arial" SIZE 0, -16 BOLD

@ 014,003 FOLDER oFld OF oGraOk PROMPT "&Dados do Grafico", "&Grafico"  SIZE 374,240 PIXEL

@ 003,004 TO 110,183 LABEL "[ SERIE 2 ]"                           OF oFld:aDialogs[1] PIXEL
@ 010,008 LISTBOX oLbx1 VAR cVar FIELDS HEADER " ", "Legenda", "Valor";
 SIZE 111,095 OF oFld:aDialogs[1] PIXEL ON dblClick(aVetGr01[oLbx1:nAt,1] := !aVetGr01[oLbx1:nAt,1],oLbx1:Refresh())

oLbx1:SetArray( aVetGr01 )
oLbx1:bLine := {|| {Iif(aVetGr01[oLbx1:nAt,1],oOk,oNo),aVetGr01[oLbx1:nAt,2],aVetGr01[oLbx1:nAt,3]}}

@ 010, 123 say "Tipo"             SIZE 055,008 PIXEL OF oFld:aDialogs[1]
@ 020, 123 COMBOBOX oCbt1 VAR cCbt1 ITEMS aCbt SIZE 055, 008 OF oFld:aDialogs[1] PIXEL ON CHANGE nCbt1 := oCbt1:nAt 

@ 095, 123 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca" SIZE 55,007 PIXEL OF oFld:aDialogs[1];
           ON CLICK(Iif(lChk1,Marca1(lChk1),Marca1(lChk1)))
          
@ 003,187 TO 110,368 LABEL "[ SERIE 1 ]"                           OF oFld:aDialogs[1] PIXEL

@ 010,192 LISTBOX oLbx2 VAR cVar FIELDS HEADER " ", "Legenda", "Valor";
 SIZE 111,095 OF oFld:aDialogs[1] PIXEL ON dblClick(aVetGr02[oLbx2:nAt,1] := !aVetGr02[oLbx2:nAt,1],oLbx2:Refresh())

oLbx2:SetArray( aVetGr02 )
oLbx2:bLine := {|| {Iif(aVetGr02[oLbx2:nAt,1],oOk,oNo),aVetGr02[oLbx2:nAt,2],aVetGr02[oLbx2:nAt,3]}}

@ 010, 309 say "Tipo"             SIZE 055,008 PIXEL OF oFld:aDialogs[1]
@ 020, 309 COMBOBOX oCbt2 VAR cCbt2 ITEMS aCbt SIZE 055, 008 OF oFld:aDialogs[1] PIXEL ON CHANGE nCbt2 := oCbt2:nAt 

@ 095, 309 CHECKBOX oChk2 VAR lChk2 PROMPT "Marca/Desmarca" SIZE 55,007 PIXEL OF oFld:aDialogs[1];
           ON CLICK(Iif(lChk2,Marca2(lChk2),Marca2(lChk2)))

@ 113,004 TO 223,183 LABEL "[ SERIE 0 ]"                           OF oFld:aDialogs[1] PIXEL
@ 120,008 LISTBOX oLbx3 VAR cVar FIELDS HEADER " ", "Legenda", "Valor";
 SIZE 111,095 OF oFld:aDialogs[1] PIXEL ON dblClick(aVetGr03[oLbx3:nAt,1] := !aVetGr03[oLbx3:nAt,1],oLbx3:Refresh())

oLbx3:SetArray( aVetGr03 )
oLbx3:bLine := {|| {Iif(aVetGr03[oLbx3:nAt,1],oOk,oNo),aVetGr03[oLbx3:nAt,2],aVetGr03[oLbx3:nAt,3]}}

@ 120, 123 say "Tipo"             SIZE 055,008 PIXEL OF oFld:aDialogs[1]
@ 130, 123 COMBOBOX oCbt3 VAR cCbt3 ITEMS aCbt SIZE 055, 008 OF oFld:aDialogs[1] PIXEL ON CHANGE nCbt3 := oCbt3:nAt  

@ 205, 123 CHECKBOX oChk3 VAR lChk3 PROMPT "Marca/Desmarca" SIZE 55,007 PIXEL OF oFld:aDialogs[1];
           ON CLICK(Iif(lChk3,Marca3(lChk3),Marca3(lChk3)))

@ 113, 187 TO 223,368 LABEL "[ Complemento ]"                   OF oFld:aDialogs[1] PIXEL

@ 129, 192 say "Y - Titulo   (1)"             SIZE 055,008 PIXEL OF oFld:aDialogs[1]
@ 137, 192 get  oBARVER1 VAR BARVER1          PICTURE "@!"   SIZE 172,010 PIXEL OF oFld:aDialogs[1] FONT oBold

@ 149, 192 say "Y - Titulo   (2)"            SIZE 055,008 PIXEL OF oFld:aDialogs[1]
@ 157, 192 get  oBARVER2 VAR BARVER2          PICTURE "@!"   SIZE 172,010 PIXEL OF oFld:aDialogs[1] FONT oBold

@ 169, 192 say "X - Titulo     (1)"            SIZE 055,008 PIXEL OF oFld:aDialogs[1]
@ 177, 192 get  oBARHOR1 VAR BARHOR1          PICTURE "@!"   SIZE 172,010 PIXEL OF oFld:aDialogs[1] FONT oBold

@ 189, 192 say "X - Titulo     (2)"            SIZE 055,008 PIXEL OF oFld:aDialogs[1]
@ 197, 192 get  oBARHOR2 VAR BARHOR2          PICTURE "@!"   SIZE 172,010 PIXEL OF oFld:aDialogs[1] FONT oBold

@ 005, 005 MSGRAPHIC oMSGraphic SIZE 360, 200 OF oFld:aDialogs[2]

@ 210, 005 BUTTON "<<" SIZE 10,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGraphic:Scroll( GRP_SCRLEFT   , 10 ) // Left 10 %
@ 210, 017 BUTTON "<"  SIZE 10,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGraphic:Scroll( GRP_SCRTOP    , 10 ) // Top 10 %
@ 210, 029 BUTTON ">"  SIZE 10,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGraphic:Scroll( GRP_SCRBOTTOM , 10 ) // Bottom 10 %
@ 210, 041 BUTTON ">>" SIZE 10,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGraphic:Scroll( GRP_SCRRIGHT  , 10 ) // Right 10 %

@ 210, 075 BUTTON "&Hint"          SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGraphic:lShowHint := !oMSGraphic:lShowHint
@ 210, 105 BUTTON "&Legenda"       SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION MySetLege( oMSGraphic )
@ 210, 135 BUTTON "&Margem"        SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION MySetMargin( oMSGraphic )
@ 210, 165 BUTTON "&Destaque"      SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGraphic:SetAxisProp( CLR_MAGENTA, 8, CLR_CYAN, 8 )
@ 210, 195 BUTTON "Titulo X"       SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION MySetTitX( oMSGraphic )
@ 210, 225 BUTTON "Titulo Y"       SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION MySetTitY( oMSGraphic )
@ 210, 255 BUTTON "&3D"            SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGraphic:l3D := !oMSGraphic:l3D
@ 210, 285 BUTTON "[&Max] [Min]"   SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGraphic:lAxisVisib := !oMSGraphic:lAxisVisib

@ 210, 335 BUTTON "+"        SIZE 18,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGraphic:ZoomIn()
@ 210, 350 BUTTON "-"        SIZE 18,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGraphic:ZoomOut()

ACTIVATE MSDIALOG oGraOk CENTER ON INIT MyConBar(oGraOk,{||oGraOk:End()},oFld:aDialogs[2],oMsGraphic)

RESTAREA(AAREA)   
Return 

     
STATIC FUNCTION MyConBar(oObj,bObj,oFlx,oMSGraphic)
LOCAL oBar, lOk, lVolta, lLoop,oDBG10,oDBG02,oBtOk,oNada,oBtcl,oBtcn 

DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP    OF oObj
DEFINE BUTTON         RESOURCE "S4WB008N"  OF oBar GROUP ACTION Calculadora()                                 TOOLTIP "Calculadora"
DEFINE BUTTON         RESOURCE "S4WB010N"  OF oBar       ACTION OurSpool()                                    TOOLTIP "Gerenciador de Impress„o"
DEFINE BUTTON         RESOURCE "BAR"       OF oBar       ACTION GrafGera(oFlx,oMSGraphic)    				     TOOLTIP "Gerar Grafico"
DEFINE BUTTON         RESOURCE "ALTERA"    OF oBar       Action Grafsavbmp(oMSGraphic)           			     TOOLTIP "Salvar o Grafico"
DEFINE BUTTON         RESOURCE "IMPRESSAO" OF oBar       ACTION MontaRel(oMSGraphic) TOOLTIP "imprim"
DEFINE BUTTON oBtOk   RESOURCE "CANCEL"    OF oBar       ACTION (lLoop:=lVolta,lOk:=Eval(bObj))               TOOLTIP "Sair - <Alt+F4>"
oBar:bRClicked:={||AllwaysTrue()}
RETURN NIL
                       

Static Function Marca1(lMarca)
Local i := 0
For i := 1 To Len(aVetGr01)
   aVetGr01[i][1] := lMarca
Next i
oLbx1:Refresh()
Return

Static Function Marca2(lMarca)
Local i := 0
For i := 1 To Len(aVetGr02)
   aVetGr02[i][1] := lMarca
Next i
oLbx2:Refresh()
Return

Static Function Marca3(lMarca)
Local i := 0
For i := 1 To Len(aVetGr03)
   aVetGr03[i][1] := lMarca
Next i
oLbx3:Refresh()
Return

Static Function MySetMargin( oMSGraphic )
Local oDlg
Local nTop    := 10                                             
Local nLeft   := 10
Local nBottom := 10
Local nRight  := 14
Local lOk     := .F.      

DEFINE MSDIALOG oDlg FROM 0,0 TO 150,135 PIXEL TITLE "Valores"

@ 10, 10 SAY "Inicio" PIXEL    OF oDlg
@ 10, 40 MSGET nTop    SIZE 20,08 PIXEL OF oDlg PICTURE "9999"

@ 20, 10 SAY "Equerda" PIXEL OF oDlg
@ 20, 40 MSGET nLeft   SIZE 20,08 PIXEL OF oDlg PICTURE "9999"

@ 30, 10 SAY "Final" PIXEL OF oDlg
@ 30, 40 MSGET nBottom SIZE 20,08 PIXEL OF oDlg PICTURE "9999"

@ 40, 10 SAY "Direita" PIXEL OF oDlg
@ 40, 40 MSGET nRight  SIZE 20,08 PIXEL OF oDlg PICTURE "9999"

@ 60, 05 BUTTON "&OK"      SIZE 30,13 PIXEL OF oDlg ACTION (lOk := .T.,oDlg:End())
@ 60, 35 BUTTON "&Cancela" SIZE 30,13 PIXEL OF oDlg ACTION (lOk := .F.,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTER

If lOk
	oMSGraphic:SetMargins( nTop, nLeft, nBottom, nRight )
Endif

Return Nil


Static Function MySetLege( oMSGraphic )
Local oDlg
Local otpl
Local oCrl
Local nCrl := 1
Local ntpl := 1
Local ctpl := space(10)
Local cCrl := space(10)
Local atpl := {"Auto","Series","Valor","Las Val","Sem Legenda"}
Local aCcc := {"Amarelo","Azul","Verde"}
Local aPos := {"Inicio","Esquerda","Final","Direita"}
Local oPos
Local nPos := 1
Local cPos := space(10)
Local lOk  := .F.

DEFINE MSDIALOG oDlg FROM 0,0 TO 150,135 PIXEL TITLE "Legenda"

@ 03, 10 say "Legenda"          SIZE 055,008 PIXEL OF oDlg
@ 11, 10 COMBOBOX otpl VAR ctpl ITEMS atpl SIZE 055,008 PIXEL OF oDlg ON CHANGE  ntpl := otpl:nAt 
@ 24, 10 say "Cor"              SIZE 055,008 PIXEL OF oDlg
@ 31, 10 COMBOBOX oCrl VAR cCrl ITEMS aCcc SIZE 055,008 PIXEL OF oDlg ON CHANGE  nCrl := oCrl:nAt 
@ 44, 10 say "PosiÁ„o"              SIZE 055,008 PIXEL OF oDlg
@ 51, 10 COMBOBOX oPos VAR cPos ITEMS aPos SIZE 055,008 PIXEL OF oDlg ON CHANGE  nPos := oPos:nAt 
@ 63, 05 BUTTON "&OK"      SIZE 30,10 PIXEL OF oDlg ACTION (lOk := .T.,oDlg:End())
@ 63, 35 BUTTON "&Cancela" SIZE 30,10 PIXEL OF oDlg ACTION (lOk := .F.,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTER

If lOk
   if nCrl=1
      xcor=CLR_YELLOW
    elseif nCrl=2
      xcor=CLR_HBLUE
    elseif nCrl=3
      xcor=CLR_GREEN
   endif
   if ntpl=5
      oMSGraphic:SetLegenProp(nPos,xcor,nCrl, .F.)
   else
      oMSGraphic:SetLegenProp(nPos,xcor,nCrl, .T.)
   endif
   oMSGraphic:REFRESH()
Endif
Return Nil

Static Function MySetTitX( oMSGraphic )
Local oDlg
Local oCrl
Local nCrl := 1
Local cCrl := space(10)
Local aCcc := {"Azul","Verde","Vermelha"}
Local aPos := {"Direita","Esquerda","Centro"}
Local oPos
Local nPos := 1
Local cPos := space(10)
Local lOk  := .F.

DEFINE MSDIALOG oDlg FROM 0,0 TO 150,135 PIXEL TITLE "Titulo X"

@ 14, 10 say "Cor"              SIZE 055,008 PIXEL OF oDlg
@ 21, 10 COMBOBOX oCrl VAR cCrl ITEMS aCcc SIZE 055,008 PIXEL OF oDlg ON CHANGE  nCrl := oCrl:nAt 
@ 34, 10 say "PosiÁ„o"              SIZE 055,008 PIXEL OF oDlg
@ 41, 10 COMBOBOX oPos VAR cPos ITEMS aPos SIZE 055,008 PIXEL OF oDlg ON CHANGE  nPos := oPos:nAt 
@ 63, 05 BUTTON "&OK"      SIZE 30,10 PIXEL OF oDlg ACTION (lOk := .T.,oDlg:End())
@ 63, 35 BUTTON "&Cancela" SIZE 30,10 PIXEL OF oDlg ACTION (lOk := .F.,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTER

If lOk
   if nCrl=1
      xcor=CLR_HBLUE
    elseif nCrl=2
      xcor=CLR_GREEN
    elseif nCrl=3
      xcor=CLR_HRED
   endif

   oMSGraphic:SetTitle(BARVER1,BARVER2,xcor ,nPos,GRP_TITLE)

   oMSGraphic:REFRESH()
Endif
Return Nil


Static Function MySetTitY( oMSGraphic )
Local oDlg
Local oCrl
Local nCrl := 1
Local cCrl := space(10)
Local aCcc := {"Azul","Verde","Vermelha"}
Local aPos := {"Direita","Esquerda","Centro"}
Local oPos
Local nPos := 1
Local cPos := space(10)
Local lOk  := .F.
                        
DEFINE MSDIALOG oDlg FROM 0,0 TO 150,135 PIXEL TITLE "Titulo Y"
@ 14, 10 say "Cor"              SIZE 055,008 PIXEL OF oDlg
@ 21, 10 COMBOBOX oCrl VAR cCrl ITEMS aCcc SIZE 055,008 PIXEL OF oDlg ON CHANGE  nCrl := oCrl:nAt 
@ 34, 10 say "PosiÁ„o"              SIZE 055,008 PIXEL OF oDlg
@ 41, 10 COMBOBOX oPos VAR cPos ITEMS aPos SIZE 055,008 PIXEL OF oDlg ON CHANGE  nPos := oPos:nAt 
@ 63, 05 BUTTON "&OK"      SIZE 30,10 PIXEL OF oDlg ACTION (lOk := .T.,oDlg:End())
@ 63, 35 BUTTON "&Cancela" SIZE 30,10 PIXEL OF oDlg ACTION (lOk := .F.,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTER

If lOk
   if nCrl=1
      xcor=CLR_HBLUE
    elseif nCrl=2
      xcor=CLR_GREEN
    elseif nCrl=3
      xcor=CLR_HRED
   endif

   oMSGraphic:SetTitle(BARHOR1,BARHOR2,xcor ,nPos,GRP_FOOT)
   oMSGraphic:REFRESH()
Endif
Return Nil


Static Function GRAFGERA(oFlx,oMSGraphic)
Local nIndTask := 0
Local nIndTask2:= 0
Local nMax     := 1
if cGrafic 
   oMSGraphic:bLClicked := {|o| MsgInfo("Araste o Mouse com tecla esquerda pressionada") }
   oMSGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW,GRP_SERIES, .T.)
   oMSGraphic:lShowHint:=.t.  // Desabilita Hint  
   oMSGraphic:SetMargins( 10, 10, 10, 14 )
   oMSGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE)

   store .f. to vet1,vet2,vet3
   For _n := 1 to len(aVetGr01)
       if aVetGr01[_n][1]
          vet1=.t.
       endif   
       if aVetGr02[_n][1]
          vet2=.t.
       endif   
       if aVetGr03[_n][1]
          vet3=.t.
       endif   
   Next _n
   if vet1
      nSerie := oMSGraphic:CreateSerie(nCbt1)
        nMax := len(aVetGr01)
        xcor=CLR_YELLOW
        CorL1='BR_AMARELO'
      If nSerie <> GRP_CREATE_ERR
  	   	If nCbt1 == GRP_PIE
   	   	nMax := 1
   	   Endif
	      For _n := 1 to nMax
             if aVetGr01[_n][1]
                oMSGraphic:Add(nSerie,aVetGr01[_n][3],aVetGr01[_n][2],xcor)
              else
                oMSGraphic:Add(nSerie,0,aVetGr01[_n][2],xcor)
             endif 
   	   Next _n
	   Endif
   Endif

   if vet2
        nMax := len(aVetGr02)
       nSerie := oMSGraphic:CreateSerie(nCbt2)

      xcor=CLR_GREEN
      CorL2='BR_VERDE'
      If nSerie <> GRP_CREATE_ERR
  	   	If nCbt2 == GRP_PIE
   	   	nMax := 1
   	   Endif
	      For _n := 1 to nMax
             if aVetGr02[_n][1]
                oMSGraphic:Add(nSerie,aVetGr02[_n][3],aVetGr02[_n][2],xcor)
              else
                oMSGraphic:Add(nSerie,0,aVetGr02[_n][2],xcor)
             endif 
   	   Next _n
	   Endif
   Endif
   if vet3
        nMax := len(aVetGr03)
      nSerie := oMSGraphic:CreateSerie(nCbt3)
       xcor=CLR_HRED  
       CorL3='BR_VERMELHO'

      If nSerie <> GRP_CREATE_ERR
  		   If nCbt3 == GRP_PIE
      		nMax := 1
	      Endif
	      For _n := 1 to nMax
             if aVetGr03[_n][1]
                oMSGraphic:Add(nSerie,aVetGr03[_n][3],aVetGr03[_n][2],xcor)
              else
                oMSGraphic:Add(nSerie,0,aVetGr03[_n][2],xcor)
             endif 
   	   Next _n
	   Endif
   Endif
   oMSGraphic:REFRESH()
   cGrafic:=.f.

endif
Return 


Static Function MontaRel(oMSGraphic) 
Local cFile
cTipo :=         "Bitmap (*.BMP)          | *.BMP | "
cTipo := cTipo + "Todos os Arquivos  (*.*) |   *.*   |"

cFile := cGetFile(cTipo,"Dialogo de Selecao de Arquivos")

If Empty(cFile)
	MsgStop("Cancelada a Selecao!","Voce cancelou o Processo.")
	Return
EndIf

//Objetos para tamanho e tipo das fontes
oFont1 	:= TFont():New( "Times New Roman",,08,,.T.,,,,,.F.)
oFont2 	:= TFont():New( "Tahoma",,16,,.T.,,,,,.F.)
oFont3	:= TFont():New( "Arial"       ,,20,,.F.,,,,,.F.)
oPrn 		:= tAvPrinter():New("Graficos")
oprn:SETPAPERSIZE(9) // <==== ajuste para papel A4
oPrn:Setlandscape()
oPrn:StartPage() //Inicia uma nova p·gina // startando a impressora
oPrn:Say(0, 0, " ",oFont1,100) 

//             linha  colu     tam  largura
oPrn:Saybitmap(0100,0100,cFile,2900,2550)

oPrn:EndPage()
oPrn:Preview()
oPrn:End()

Return
                                                  
