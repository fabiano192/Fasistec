#include "TOTVS.CH"

function u_TFlowResp()
  oWnd:= TWindow():New(0, 0, 550, 700, "Exemplo de TFlowLayout", NIL, NIL, NIL, NIL, NIL, NIL, NIL,;
    CLR_BLACK, CLR_WHITE, NIL, NIL, NIL, NIL, NIL, NIL, .T. )

  oLayout1:= tFlowLayout():New(oWnd,CONTROL_ALIGN_ALLCLIENT,0,0)
  oLayout1:SetColor(,CLR_BLUE)

  oTButton1 := TButton():New( 0, 0, "Botão 01", oLayout1,{||alert("Botão 01")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:AddInLayout(oTButton1)
  oTButton2 := TButton():New( 0, 0, "Botão 02", oLayout1,{||alert("Botão 02")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:AddInLayout(oTButton2)
  oTButton3 := TButton():New( 0, 0, "Botão 03", oLayout1,{||alert("Botão 03")}, 80,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:AddInLayout(oTButton3)
  oTButton4 := TButton():New( 0, 0, "Botão 04", oLayout1,{||alert("Botão 04")}, 80,10,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:AddInLayout(oTButton4)
  oTButton5 := TButton():New( 0, 0, "Botão 05", oLayout1,{||alert("Botão 05")}, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:AddInLayout(oTButton5)
  oTButton6 := TButton():New( 0, 0, "Botão 06", oLayout1,{||alert("Botão 06")}, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
  oLayout1:AddInLayout(oTButton6)

  cTexto1 := "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus pharetra turpis a tempor tempus. Vivamus sit amet eleifend ante, quis suscipit nulla. Morbi sollicitudin eleifend dapibus. Integer congue sapien quis augue dignissim sodales. Sed a sapien justo. Ut sodales nulla sed lacus sollicitudin, a dignissim magna convallis. Maecenas facilisis purus id aliquam tempus. Quisque tempus magna quis nunc ultrices, sit amet luctus ante facilisis."
  oTMultiget1 := tMultiget():new( 0, 0, {| u | if( pCount() > 0, cTexto1 := u, cTexto1 ) }, oLayout1, 50, 50,,,,,,.T. )
  oLayout1:AddInLayout(oTMultiget1)

  cTexto2 := "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus pharetra turpis a tempor tempus. Vivamus sit amet eleifend ante, quis suscipit nulla. Morbi sollicitudin eleifend dapibus. Integer congue sapien quis augue dignissim sodales. Sed a sapien justo. Ut sodales nulla sed lacus sollicitudin, a dignissim magna convallis. Maecenas facilisis purus id aliquam tempus. Quisque tempus magna quis nunc ultrices, sit amet luctus ante facilisis."
  oTMultiget2 := tMultiget():new( 0, 0, {| u | if( pCount() > 0, cTexto2 := u, cTexto2 ) }, oLayout1, 50, 50,,,,,,.T. )
  oLayout1:AddInLayout(oTMultiget2)

  cTexto3 := "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus pharetra turpis a tempor tempus. Vivamus sit amet eleifend ante, quis suscipit nulla. Morbi sollicitudin eleifend dapibus. Integer congue sapien quis augue dignissim sodales. Sed a sapien justo. Ut sodales nulla sed lacus sollicitudin, a dignissim magna convallis. Maecenas facilisis purus id aliquam tempus. Quisque tempus magna quis nunc ultrices, sit amet luctus ante facilisis."
  oTMultiget3 := tMultiget():new( 0, 0, {| u | if( pCount() > 0, cTexto3 := u, cTexto3 ) }, oLayout1, 100, 80,,,,,,.T. )
  oLayout1:AddInLayout(oTMultiget3)

  oWnd:Activate("MAXIMIZED")
return