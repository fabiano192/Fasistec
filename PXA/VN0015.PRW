#Include "rwmake.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VN0015   ³ Autor ³Alexandro da Silva     ³ Data ³ 11/04/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Deletar Produtos Sem Movimento                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Estoques                     -                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VN0015()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para Atualizaçao")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Atualizacao do Cadastro de Produtos     "     SIZE 160,7
@ 18,18 SAY "                                                    "     SIZE 160,7
@ 26,18 SAY "                                                    "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Private _lFim      := .F.
	Private _cTitulo01 := 'Atualizando Cadastros!!!!'
	
	Processa( {|| VN015A() } , _cTitulo01, "Processando Arquivo...",.T.)
Endif

Return (Nil)


Static Function VN015A()

_aTabela := {{"AFJ","AFJ_COD","AFJ_CODBKP"},;
{"AFN","AFN_COD"   ,"AFN_CODBKP"},;
{"AIB","AIB_CODPRO","AIB_CODBKP"},;
{"AJ7","AJ7_COD"   ,"AJ7_CODBKP"},;
{"CD2","CD2_CODPRO","CD2_CODBKP"},;
{"DA1","DA1_CODPRO","DA1_CODBKP"},;
{"SA5","A5_PRODUTO", "A5_CODBKP"},;
{"SBF","BF_PRODUTO", "BF_CODBKP"},;
{"SBK","BK_COD"    , "BK_CODBKP"},;
{"SBL","BL_PRODUTO", "BL_CODBKP"},;
{"SC1","C1_PRODUTO", "C1_CODBKP"},;
{"SC2","C2_PRODUTO", "C2_CODBKP"},;
{"SC6","C6_PRODUTO", "C6_CODBKP"},;
{"SC7","C7_PRODUTO", "C7_CODBKP"},;
{"SC8","C8_PRODUTO", "C8_CODBKP"},;
{"SC9","C9_PRODUTO", "C9_CODBKP"},;
{"SCA","CA_PRODUTO", "CA_CODBKP"},;
{"SCP","CP_PRODUTO", "CP_CODBKP"},;
{"SCQ","CQ_PRODUTO", "CQ_CODBKP"},;
{"SCK","CK_PRODUTO", "CK_CODBKP"},;
{"SCY","CY_PRODUTO", "CY_CODBKP"},;
{"SD1","D1_COD"    , "D1_CODBKP"},;
{"SD2","D2_COD"    , "D2_CODBKP"},;
{"SD3","D3_COD"    , "D3_CODBKP"},;
{"SD4","D4_COD"    , "D4_CODBKP"},;
{"SD5","D5_PRODUTO", "D5_CODBKP"},;
{"SD7","D7_PRODUTO", "D7_CODBKP"},;
{"SDA","DA_PRODUTO", "DA_CODBKP"},;
{"SDB","DB_PRODUTO", "DB_CODBKP"},;
{"SFT","FT_PRODUTO", "FT_CODBKP"},;
{"TPG","TPG_CODIGO", "TPG_CODBKP"},;
{"TPY","TPY_CODPRO","TPY_CODBKP"},;
{"TPZ","TPZ_CODIGO","TPZ_CODBKP"}}


//{"SB2","B2_COD"    , "B2_CODBKP"},;
//{"SB3","B3_COD"    , "B3_CODBKP"},;
//{"SB6","B6_PRODUTO", "B6_CODBKP"},;
//{"SB7","B7_COD"    , "B7_CODBKP"},;
//{"SB9","B9_COD"    , "B9_CODBKP"},;
//{"SBZ","BZ_COD"    , "BZ_CODBKP"},;
//{"SF9","F9_PROD"   , "F9_CODBKP"},;
//{"SZ3","Z3_PRODUTO", "Z3_CODBKP"},;
//{"SZE","ZE_PRODUTO", "ZE_CODBKP"},;
//{"SZF","ZF_PRODUTO", "ZF_CODBKP"},;
//{"SZH","ZH_PRODUTO", "ZH_CODBKP"},;
//{"SZQ","ZQ_PRODUTO", "ZQ_CODBKP"}}

//_cQ := "SELECT * FROM SB1010 WHERE D_E_L_E_T_ = '' AND LEN(B1_COD) <> 10  AND LEFT(B1_COD,3) <> 'MOD' "
//_cQ += "ORDER BY B1_COD "

//TCQUERY _cQ NEW ALIAS "ZB1"

SB1->(dbGotop())

ProcRegua(SB1->(RecCount()))

While SB1->(!Eof())
	
	Incproc("Produto--> "+SB1->B1_COD)
	
	//If LEN(Alltrim(SB1->B1_COD)) = 10  .Or. LEFT(SB1->B1_COD,3) = "MOD"
	//	SB1->(dbSkip())
	//	Loop
	//Endif
	
	If LEFT(SB1->B1_COD,1) = "V"
		SB1->(dbSkip())
		Loop
	Endif
	
	_lCont := .F.
	
	If Len(Alltrim(SB1->B1_COD)) = 8
		For AZ:= 1 To Len(_aTabela)
			
			_cQ := " SELECT COUNT("+_aTabela[AZ,2]+") AS QTREG FROM "+RetSqlName(_aTabela[AZ,1])+" WHERE D_E_L_E_T_ = '' "
			_cQ += " AND "+_aTabela[AZ,2]+" = '"+SB1->B1_COD+"' "
			
			TCQUERY _cQ NEW ALIAS "ZZ"
			
			If ZZ->QTREG = 0
				_lCont := .T.
			Else
				AZ:= Len(_aTabela)
				_lCont := .F.
			Endif
			
			ZZ->(dbCloseArea())
		Next AZ
		
		If _lCont
			SB1->(RecLock("SB1",.F.))
			SB1->B1_YCODBKP:= "DEL-20160720"
			SB1->(dbDelete())
			SB1->(MsUnlock())
		Endif
	Endif
	SB1->(dbSkip())
EndDo

Return