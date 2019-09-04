#include "TOTVS.CH"

User function TGridResp()
  oWnd:= TWindow():New(0, 0, 550, 700, "Exemplo de TGridLayout", NIL, NIL, NIL, NIL, NIL, NIL, NIL,;
        CLR_BLACK, CLR_WHITE, NIL, NIL, NIL, NIL, NIL, NIL, .T. )

  oLayout1:= tGridLayout():New(oWnd,CONTROL_ALIGN_ALLCLIENT,0,0)
  oLayout1:SetColor(,CLR_BLUE)

  oTButton1 := TButton():New( 0, 0, "Bot�o 01", oLayout1,{||alert("Bot�o 01")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton1, 1, 1)
  oTButton2 := TButton():New( 0, 0, "Bot�o 02", oLayout1,{||alert("Bot�o 02")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton2, 1, 2)
  oTButton3 := TButton():New( 0, 0, "Bot�o 03", oLayout1,{||alert("Bot�o 03")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton3, 1, 3)

  oTButton4 := TButton():New( 0, 0, "Bot�o 04", oLayout1,{||alert("Bot�o 04")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton4, 2, 1)
  oTButton5 := TButton():New( 0, 0, "Bot�o 05", oLayout1,{||alert("Bot�o 05")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton5, 2, 2)
  oTButton6 := TButton():New( 0, 0, "Bot�o 06", oLayout1,{||alert("Bot�o 06")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton6, 2, 3)

  oTButton7 := TButton():New( 0, 0, "Bot�o 07", oLayout1,{||alert("Bot�o 07")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton7, 3, 1)
  oTButton8 := TButton():New( 0, 0, "Bot�o 08", oLayout1,{||alert("Bot�o 08")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton8, 3, 2)
  oTButton9 := TButton():New( 0, 0, "Bot�o 09", oLayout1,{||alert("Bot�o 09")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton9, 3, 3)

  oTButton10 := TButton():New( 0, 0, "Bot�o 10", oLayout1,{||alert("Bot�o 10")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton10, 4, 1)
  oTButton11 := TButton():New( 0, 0, "Bot�o 11", oLayout1,{||alert("Bot�o 11")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton11, 4, 2)
  oTButton12 := TButton():New( 0, 0, "Bot�o 12", oLayout1,{||alert("Bot�o 12")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:addInLayout(oTButton12, 4, 3)

  oWnd:Activate()
return


User Function TGrdLyt2()
   oWnd:= TWindow():New(0, 0, 500, 400, "TGridLayout Aninhado", NIL, NIL, NIL, NIL, NIL, NIL, NIL,;
                       CLR_BLACK, CLR_WHITE, NIL, NIL, NIL, NIL, NIL, NIL, .T. )

  // --------------------------------------------------------------------------------------------------------
  // Cria o layout principal que comportar� todos os layouts e componentes da tela
  oMainLayout:= tGridLayout():New(oWnd, CONTROL_ALIGN_ALLCLIENT, 0, 0)

  // --------------------------------------------------------------------------------------------------------
  // Cria o frame do cabe�alho
  // Cria um TPanel intermedi�rio para comportar um TAlignLayout com o conte�do
  oHeaderPnl := tPanel():New(0,0,,oMainLayout,,.T.,,,CLR_LIGHTGRAY,0,60)
  oHeaderPnl:SetCSS("QFrame{ background-color: #9933cc; margin: 5px; }")
  oMainLayout:addInLayout(oHeaderPnl, 1, 1, ,3)
  oMainLayout:AddSpacer(1,,15)
  oHeaderLyt := tLinearLayout():New(oHeaderPnl, LAYOUT_LINEAR_L2R, CONTROL_ALIGN_ALLCLIENT, 0, 0)
  oTFont := TFont():New('Lucida Sans',,16,.T.)
  oSayHeader := TSay():New(0,0,{||"<H1>T�tulo</H1>"},oHeaderLyt,,oTFont,,,,.T.,CLR_WHITE,,0,0,,,,,,.T.)
  oHeaderLyt:addInLayout(oSayHeader, LAYOUT_ALIGN_VCENTER)
  oHeaderLyt:AddSpacer(2, 1)

  // --------------------------------------------------------------------------------------------------------
  // Cria o frame central
  // Segmenta o frame central em tr�s partes, usando TPanel para esse fim. Cada TPanel ser� o parent de um
  // TAlignLayout diferente que por sua vez ser� o container dos compontentes visuais.
  oMenuPnl := tPanel():New(0,0,,oMainLayout,,.T.,,,CLR_LIGHTGRAY,0,0)
  oCenterPnl := tPanel():New(0,0,,oMainLayout,,.T.,,,CLR_CYAN,0,0)
  oQuestPnl := tPanel():New(0,0,,oMainLayout,,.T.,,,CLR_BROWN,0,0)
  oMainLayout:addInLayout(oMenuPnl,2,1)
  oMainLayout:addInLayout(oCenterPnl,2,2)
  oMainLayout:addInLayout(oQuestPnl,2,3)
  oMainLayout:AddSpacer(2,,70)

  // No primeiro TPanel, cria o layout que comportar� o menu lateral
  oMenuLyt := tLinearLayout():New(oMenuPnl, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
  oMenuLyt:SetCSS("QFrame{ margin: 15px; } TButton{ background-color: #33b5e5; color: #ffffff; text-align: left; margin-bottom: 7px; font-size: 18px; }" )
  oTButton1 := TButton():New( 0, 0, "Bot�o Um", oMenuLyt,{||conout("Bot�o Um")}, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTButton2 := TButton():New( 0, 0, "Bot�o Dois", oMenuLyt,{||conout("Bot�o Dois")}, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTButton3 := TButton():New( 0, 0, "Bot�o Tr�s", oMenuLyt,{||conout("Bot�o Tr�s")}, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTButton4 := TButton():New( 0, 0, "Bot�o Quatro", oMenuLyt,{||conout("Bot�o Quatro")}, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
  oMenuLyt:addInLayout(oTButton1)
  oMenuLyt:addInLayout(oTButton2)
  oMenuLyt:addInLayout(oTButton3)
  oMenuLyt:addInLayout(oTButton4)
  oMenuLyt:AddSpacer(5)

  // No segundo TPanel, cria o layout que comportar� o texto central
  oCenterLyt := tLinearLayout():New(oCenterPnl, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
  oCenterLyt:SetCSS("QFrame{ margin: 15px; }")
  cCity := "<h1>Conte�do</h1><br>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus pharetra turpis a tempor tempus. Vivamus sit amet eleifend ante, quis suscipit nulla. Morbi sollicitudin eleifend dapibus. Integer congue sapien quis augue dignissim sodales. Sed a sapien justo. Ut sodales nulla sed lacus sollicitudin, a dignissim magna convallis. Maecenas facilisis purus id aliquam tempus. Quisque tempus magna quis nunc ultrices, sit amet luctus ante facilisis."
  oSayCenter := TSay():New(0,0,{|| cCity},oCenterLyt,,oTFont,,,,.T.,,,0,0,,,,,,.T.)
  oCenterLyt:addInLayout(oSayCenter)

  // No terceiro TPanel, cria o layout que comportar� o texto � direita
  oQuestLyt := tLinearLayout():New(oQuestPnl, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
  oQuestLyt:SetColor(,CLR_WHITE)
  oQuestLyt:SetCss("QFrame{ margin: 5px; }")
  cPerguntas := "<h1>Item 1</h1><br>Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br><h1>Item 2</h1><br>Vivamus pharetra turpis a tempor tempus.<br><h1>Item 3</h1><br>Quisque tempus magna quis nunc ultrices, sit amet luctus ante facilisis."
  oSayQuest := TSay():New(0,0,{|| cPerguntas},oQuestLyt,,oTFont,,,,.T.,CLR_WHITE,CLR_HBLUE,0,0,,,,,,.T.)
  oSayQuest:SetCss("TSay{ qproperty-alignment: AlignCenter; background-color: #33b5e5; color: #ffffff; }")
  oQuestLyt:addInLayout(oSayQuest)

  // --------------------------------------------------------------------------------------------------------
  // Cria o frame do rodap�
  // Cria um TPanel intermedi�rio para comportar um TAlignLayout com o conte�do.
  oBottomPnl := tPanel():New(0,0,,oMainLayout,,.T.,,,CLR_LIGHTGRAY,0,40)
  oBottomPnl:SetCSS("QFrame{ background-color: #0099cc; color: #ffffff; margin: 5px; }")
  oMainLayout:addInLayout(oBottomPnl,3,1,,3)
  oMainLayout:AddSpacer(3,,15)
  oBottomLyt := tLinearLayout():New(oBottomPnl, LAYOUT_LINEAR_L2R, CONTROL_ALIGN_ALLCLIENT, 0, 0)
  oSayBottom:= TSay():New(0,0,{||"Redimensione a janela para ver como o conte�do responde ao redimensionamento."},oBottomLyt,,oTFont,,,,.T.,,,0,0,,,,,,.T.)
  oSayBottom:SetCss("TSay{ qproperty-alignment: AlignCenter; }")
  oBottomLyt:AddInLayout(oSayBottom)

  oWnd:Activate("MAXIMIZED")

return
