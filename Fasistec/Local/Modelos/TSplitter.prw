#include "TOTVS.CH"
User Function TSplitter()
  DEFINE DIALOG oDlg TITLE "Exemplo TSplitter" FROM 180,180 TO 550,700 PIXEL
    oSplitter := tSplitter():New( 01,01,oDlg,260,184 )
    oPanel1:= tPanel():New(322,02," Painel 01",oSplitter,,,,,CLR_YELLOW,60,60)
    oPanel2:= tPanel():New(322,02," Painel 02",oSplitter,,,,,CLR_HRED,60,80)
    oPanel3:= tPanel():New(322,02," Painel 03",oSplitter,,,,,CLR_HGRAY,60,60)
  ACTIVATE DIALOG oDlg CENTERED
Return