#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

#Define Verde "#9AFF9A"
#Define Amarelo "#FFD700"
#Define Vermelho "#FF0000"
#Define Salmao "#FF8C69"
#Define Branco "#FFFAFA"
#Define Azul "#87CEEB"
#Define Preto "#000000"
#Define Cinza "#696969"
#Define Verde_Escuro "#006400"
#Define Azul_Escuro "#191970"
#Define Vermelho_Escuro "#8B0000"
#Define Amarelo_Escuro "#8B6914"

User Function TBUTTON()

	_oTBut1	:= TButton():New( _nLiI1+005, _nCol, "Consultar" ,_oDlg,{||LjMsgRun("Consultando Tabelas de Preço, aguarde...","Tabela de Preço",{||Consulta()})}	, 40,25,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut1 :cTooltip = "Reajustar"
    _oTBut1:SetCss(+;
    "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Branco+", stop: 1 "+Verde+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Verde_Escuro+" }"+;
    "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Verde+", stop: 1 "+Branco+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Verde_Escuro+"}")

	_oTBut1	:= TButton():New( _nLiI1+005, _nCol, "Calcular" ,_oDlg,{||LjMsgRun("Calculando Reajuste, aguarde...","Tabela de Preço",{||Calcular()})}	, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut1 :cTooltip = "Calcular"
    _oTBut1:SetCss(+;
    "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Branco+", stop: 1 "+Azul+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Azul_Escuro+"}"+;
    "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Azul+", stop: 1 "+Branco+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Azul_Escuro+"}")

	_oTBut1	:= TButton():New( _nLiI4, _nColI+100, "Reajustar" ,_oDlg,{||LjMsgRun("Calculando Reajuste, aguarde...","Tabela de Preço",{||Reajustar()})}	, 60,15,,_oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut1 :cTooltip = "Reajustar"
    _oTBut1:SetCss(+;
    "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Branco+", stop: 1 "+Amarelo+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Amarelo_Escuro+" }"+;
    "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Amarelo+", stop: 1 "+Branco+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Amarelo_Escuro+" }")

	_oTBut2	:= TButton():New( _nLiI4, _nColF-100-60, "Cancelar/Sair" ,_oDlg,{||_oDlg:End()}	, 60,15,,_oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut2 :cTooltip = "Cancelar"
    _oTBut2:SetCss(+;
    "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Branco+", stop: 1 "+Salmao+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Vermelho_Escuro+" }"+;
    "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Salmao+", stop: 1 "+Branco+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Vermelho_Escuro+" }")

Return(Nil)