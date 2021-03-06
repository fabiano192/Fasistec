#include "rwmake.ch"
#INCLUDE "CTBA040.CH"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CTBA040  � Autor � Pilar S. Albaladejo   � Data � 04/11/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cadastramento de Itens Contabeis 			              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CTBA040()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PXH021(aRotAuto,nOpcAuto)
        
/*
PXH021A-Ctba040Inc            
PXH021B-CtbMovSaldo
  
*/
 
__lCTA040Item	:= .F.
lCTA040TOK := ExistBlock("CTA040TOK")
lCTB040AUT := .F.

aCores := {	{ "CTD_BLOQ == '1'" , "BR_VERMELHO"	},; // Conta Bloqueada
{ "CTD_BLOQ == '2' .AND. ( ( Empty( CTD_DTEXIS ) .Or. CTD_DTEXIS <= dDatabase ) .AND. ( Empty( CTD_DTEXSF ) .Or. CTD_DTEXSF >= dDatabase ) )" , "BR_VERDE"   	},; // Sem Restri��o
{ "CTD_BLOQ == '2' .AND. ( ! Empty( CTD_DTEXIS ) .AND. CTD_DTEXIS >= dDatabase )" , "BR_AMARELO"	},; // Exercicio N�o Iniciado
{ "CTD_BLOQ == '2' .AND. ( ! Empty( CTD_DTEXSF ) .AND. CTD_DTEXSF <= dDatabase )" , "BR_CINZA"		} } // Exercicio Finalizado

PRIVATE aRotina := MenuDef()


PRIVATE cCadastro := OemToAnsi(STR0006)+CtbSayApro("CTD")  //"Cadastro Itens Contabeis"
__lCTA040Item	 := PXH021B("CTD")

DEFAULT aRotAuto := {}
DEFAULT nOpcAuto := 3
/*
If !(__lCTA040Item)
	Help(" ",1,"NCONSALITE")
	Return
Endif
*/
If Len(aRotAuto) > 0
	lCTB040AUT := .T.
Else
	SetKey(VK_F12,{|a,b|AcessaPerg("CTB040",.T.)})
EndIf

// efetua o ajuste no CTD para remover os auto associamento
CtbAjSx9( "CTD" , 'CTD_ITLP' )

Pergunte("CTB040",.F.)

If lCTB040Aut
	PRIVATE aAutoCab   := Aclone(aRotAuto)
	MBrowseAuto(nOpcAuto,aAutoCab,"CTD")
Else
	//�������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para parametros						�
	//� mv_par01		// Gera Item Sup? Autom/Formula/Digit	  	�
	//� mv_par02		// Formula Item Sup?						�
	//� mv_par03		// Cadastro em Arvore (Nao/Sim/Perguntar)	�
	//���������������������������������������������������������������
	
	If mv_par03 == 2
		CtbaTree("CTD")
		SET KEY VK_F12 to
		Return
	ElseIf mv_par03 == 3
		If MsgYesNo(STR0010)
			CtbaTree("CTD")
			SET KEY VK_F12 to
			Return
		EndIf
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Endereca a funcao de BROWSE                                  �
	//����������������������������������������������������������������
	mBrowse( 6, 1,22,75,"CTD",,,,,,aCores)
	
	SET KEY VK_F12 to
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CTBA040Inc  � Autor � Lucimara Soares    � Data � 22/10/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inclus�o de Itens Contabeis         			              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ctba040Inc(ExpC1,ExpN1,ExpN2)                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PXH021A(cAlias,nReg,nOpc)

Local l040Grv	:= ExistBlock('CTB040GR')
LOCAl nY 	:= 0
LOCAL nOpcA := 0
                
cAlias := "CTD"
nReg   := 0
nOpc   := 3

PRIVATE aCposHistor := {}

If !lCTB040AUT		// SE FOR ROTINA AUTOMATICA
	nOpcA := AxInclui(cAlias,nReg,nOpc,,,,"Ct040TudOk(nOpc)")
Else
	nopcA := AxInclui(cAlias,nReg,nOpc,/*aAcho*/,/*cFunc*/   ,/*aCpos*/,"Ct040TudOk(nOpc)",/*lF3*/,  ,   ,/*aParam*/,aAutoCab  ,/*lVirtual*/,/*lMaximized*/)
EndIf

If nOpcA == 1
	//�����������������������������������������������������������������������Ŀ
	//� Grava Hist�rico de Altera��es na tabela CW4.                          �
	//�������������������������������������������������������������������������
	If nOpc == 3
		CTBGrvHist(xFilial("CTD"),"CTD"		,CTD->CTD_ITEM,       ,ValType(CTD->CTD_ITEM),"CTD_ITEM",""       ,CTD->CTD_ITEM,nOpc)
		//		   cFilTabela	 ,cEntidade ,cCodigo       ,cGrupo,cTipoCampo             ,cCampo,cValorAnt,cValorNovo   ,nOpc)
	Else
		For nY := 1 To Len(aCposHistor)
			aCposHistor[nY][3] := CTD->&(EVAL(bCampo,nY))
			If aCposHistor[nY][2] <> aCposHistor[nY][3]
				CTBGrvHist(xFilial("CTD"),"CTD"     ,CTD->CTD_ITEM,      ,ValType(aCposHistor[nY][1]),aCposHistor[nY][1],aCposHistor[nY][2],aCposHistor[nY][3],nOpc)
				//           cFilTabela	 ,cEntidade ,cCodigo       ,cGrupo,cTipoCampo                 ,cCampo            ,cValorAnt         ,cValorNovo        ,nOpc)
			EndIf
		Next nY
	EndIf
EndIf
//*******************************
// P.E. apos a grava��o do Item *
//*******************************
If l040Grv .and. nOpcA == 1
	ExecBlock("CTB040GR",.F.,.F.,{nOpc})
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CTBA040Alt  � Autor � Marcos S. Lobo     � Data � 22/10/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Alteracao de Itens Contabeis         			          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ctba040Alt(ExpC1,ExpN1,ExpN2)                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function CTBA040Alt(cAlias,nReg,nOpc)

Local l040Grv	:= ExistBlock('CTB040GR')
LOCAL nY 	 := 0
LOCAL bCampo := {|nCPO| Field(nCPO)}
LOCAL nOpcA  := 0

PRIVATE aCposHistor := {}

DEFAULT nOpc := 4

If !lCTB040AUT		// SE FOR ROTINA AUTOMATICA
	nOpcA := AxAltera(cAlias,nReg,nOpc,,,,,"Ct040TudOk(4)")
Else
	nOpcA := AxAltera(cAlias,nReg,nOpc,/*aAcho*/,/*cFunc*/   ,/*aCpos*/,"Ct040TudOk(4)",/*lF3*/,  ,   ,/*aParam*/,aAutoCab  ,/*lVirtual*/,/*lMaximized*/)
EndIf

If nOpcA == 1
	//�����������������������������������������������������������������������Ŀ
	//� Grava Hist�rico de Altera��es na tabela CW4.                          �
	//�������������������������������������������������������������������������
	If nOpc == 3
		CTBGrvHist(xFilial("CTD"),"CTD"		,CTD->CTD_ITEM,       ,ValType(CTD->CTD_ITEM),"CTD_ITEM",""       ,CTD->CTD_ITEM,nOpc)
		//		   cFilTabela	 ,cEntidade ,cCodigo       ,cGrupo,cTipoCampo             ,cCampo,cValorAnt,cValorNovo   ,nOpc)
	Else
		For nY := 1 To Len(aCposHistor)
			aCposHistor[nY][3] := CTD->&(EVAL(bCampo,nY))
			If aCposHistor[nY][2] <> aCposHistor[nY][3]
				CTBGrvHist(xFilial("CTD"),"CTD"     ,CTD->CTD_ITEM,      ,ValType(aCposHistor[nY][1]),aCposHistor[nY][1],aCposHistor[nY][2],aCposHistor[nY][3],nOpc)
				//           cFilTabela	 ,cEntidade ,cCodigo       ,cGrupo,cTipoCampo                 ,cCampo            ,cValorAnt         ,cValorNovo        ,nOpc)
			EndIf
		Next nY
	EndIf
EndIf
//*******************************
// P.E. apos a grava��o do Item *
//*******************************
If l040Grv .and. nOpcA == 1
	ExecBlock('CTB040GR',.F.,.F.,{4})
EndIf

Return
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Ctba040del� Autor � Pilar S. Albaladejo   � Data � 05/11/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de exclusao de Itens Contabeis                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ctba040Del(ExpC1,ExpN1,ExpN2)                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function Ctba040Del(cAlias,nReg,nOpc)

Local aSaveArea:= GetArea()
LOCAL nOpcA 	:= 0
Local lRet		:= .T.
Local oDlg
Local bCampo
Local i

PRIVATE aCposHistor := {}
DEFAULT nReg := (cAlias)->(Recno())

//��������������������������������������������������������������Ŀ
//� Carrega Variaveis de Memoria                                 �
//����������������������������������������������������������������
dbSelectArea(cAlias)
bCampo := {|nCPO| Field(nCPO) }
FOR i := 1 TO FCount()
	M->&(EVAL(bCampo,i)) := FieldGet(i)
NEXT i

Private aTELA[0][0],aGETS[0]

//��������������������������������������������Ŀ
//� Envia para processamento dos Gets          �
//����������������������������������������������
dbSelectArea(cAlias)
dbSetOrder(1)
If !SoftLock(cAlias)
	Return
EndIf


If !lCTB040AUT		// SE FOR ROTINA AUTOMATICA
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 9,0 TO 28,80 OF oMainWnd
	ENChoice( cAlias, nReg, nOpc, ,"AC",OemToAnsi(STR0004))  //"Quanto � exclus�o?"
	nOpca := 1
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 2,oDlg:End()},;
	{|| nOpca := 1,oDlg:End()})
Else
	nOpcA := 2
EndIf

If nOpcA == 2
	//��������������������������������������������Ŀ
	//� Verifica se o item x conta tem valores     �
	//����������������������������������������������
	dbSelectArea("CT4")
	//   dbSetOrder(1)
	dbSetOrder(4)
	If dbSeek(xFilial()+CTD->CTD_ITEM)
		lRet:=.F.
		Help(" ",1,"ITEMOVIM")
	EndIF
	If !Ct040TudOk(nOpc)
		lRet := .F.
	Endif
	IF lRet
		dbSelectARea("CTD")
		dbSetOrder(2)
		IF CTD->CTD_CLASSE == "1"			// Sintetica
			dbSkip( )
			If !Eof() .And. CTD->CTD_FILIAL == xFilial("CTD") .and. Alltrim(M->CTD_ITEM) == alltrim(CTD->CTD_ITSUP)
				Help(" ",1,"ITEMSINT")
				lRet:=.F.
			EndIf
		EndIf
		dbSetOrder(1)
	EndIf
	IF lRet
		BEGIN TRANSACTION
		//��������������������������������������������Ŀ
		//� Deleta todos os itens	                    �
		//����������������������������������������������
		dbSelectArea( "CT4" )
		//dbSetOrder(1)
		While !Eof() .And. 	CT4->CT4_FILIAL == xFilial() .And. ;
			CT4->CT4_ITEM == CTD->CTD_ITEM
			Reclock("CT4",.F.,.T.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
		//��������������������������������������������Ŀ
		//� Deleta o Item do Cadastro                  �
		//����������������������������������������������
		dbSelectArea(cAlias)
		MsGoto(nReg)
		RecLock(cAlias,.F.,.T.)
		dbDelete()
		MsUnlock()
		
		//�����������������������������������������������������Ŀ
		//� Grava Hist�rico de Altera��es na tabela CW4.         �
		//��������������������������������������������������������
		CTBGrvHist(xFilial("CTD"),"CTD"     ,CTD->CTD_ITEM,      ,ValType(CTD->CTD_ITEM),"CTD_ITEM",CTD->CTD_ITEM,""        ,nOpc)
		//		   cFilTabela	 ,cEntidade ,cCodigo       ,cGrupo,cTipoCampo             ,cCampo          ,cValorAnt   ,cValorNovo,nOpc)
		END TRANSACTION
		
		// Ponto de entrada apos a exclusao do item contabil - BOPS:130433 - 01/11/2007
		If ExistBlock("CTA40DEL")
			If ExecBlock("CTA40DEL",.F.,.F.,nOpc)
				Return .F.
			Endif
		Endif
		
	Endif
EndIf
MsUnlockAll()
MsGoTo(nReg)
RestArea(aSaveArea)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �CtbITEMLP � Autor � Pilar S. Albaladejo   � Data � 21.02.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de exclusao de Itens Contabeis                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CtbitemLP(cCodigo)                                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do Item Contabil                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function CtbItemLP(cCodigo)

LOCAL nEndereco
LOCAL nEnd1
Local nEnd2

M->CTD_ITLP := cCodigo

If (nEndereco := Ascan(aGets,{ |x| Subs(x,9,7) == "CTD_ITLP" } )) > 0
	nEnd1 := Val(Subs(aGets[nEndereco],1,2))
	nEnd2 := Val(Subs(aGets[nEndereco],3,1))*2
	aTela[nEnd1][nEnd2] := M->CTD_ITLP
	lRefresh := .T.
EndIf

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Ctb040NoRe� Autor � Simone Mie Sato       � Data � 22/05/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se o cod. red.Item foi preenchido com Analiticas.  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �CTB040NoRe()                                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �.T./.F.		                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Valida��o no SX3 do campo CTD_RES (Cod. Reduzido)          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static FUNCTION CTB040NoRe()

Local lRet := .T.

If M->CTD_CLASSE == "2"						// Analitica
	If Empty(M->CTD_RES)
		Help(" ",1,"CA040NORES")
		lRet:=.F.
	EndIf
Else
	IF !empty(M->CTD_RES)
		Help(" ",1,"CA040SINT")
		lRet:=.F.
	EndIf
Endif

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �Ct040TudOk� Autor � Lucimara Soares       � Data � 22.10.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao da pr�via exist�ncia do Item Cont�bil            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ct040TudOk()                                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Ct040TudOk(nOpc)

LOCAL nY := 0
LOCAL bCampo := {|nCPO| Field(nCPO) }

DEFAULT nOpc := 3

If nOpc == 3
	IF FkInUse() // se a integridade estiver ligada
		If CTD->CTD_ITEM == CTD->CTD_ITLP
			// limpa o campo CTD_ITLP, afim de evitar erro de integridade
			CTD->CTD_ITLP := ''
		Endif
	Endif
	
	If ! ExistChav("CTD", M-> CTD_ITEM)
		Return .F.
	EndIf
ElseIf nOpc == 4
	IF   M-> CTD_CLASSE != CTD->CTD_CLASSE
		DbSelectArea("CT4")
		DbSetOrder(4)
		IF CT4->(DbSeek(xFilial()+M-> CTD_ITEM))
			Help( " " , 1 , "NALTCLASSE" ,, "da classe do item, pois existem movimenta��es para o mesmo." ,3,0)
			Return .F.
		ENDIF
	ENDIF
Endif
For nY := 1 To FCount()
	AADD(aCposHistor,{CTD->(FieldName(nY)),CTD->&(EVAL(bCampo,nY)),""})
Next nY

If lCTA040TOK
	If ExecBlock("CTA040TOK",.F.,.F.,nOpc)
		Return .F.
	Endif
Endif

Return .T.

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Ctb040Sup � Autor � Simone Mie Sato       � Data � 03/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Gera o c�digo do item  superior a partir do item contab. atu���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �Ctb040Sup(cCodigo)                                          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �.T.                                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Valida��o do SX3 do Campo CTD_ITEM                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do Item Contabil           				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function Ctb040Sup(cCodigo)

Local nEndereco
Local nEnd1,nEnd2
Local cMemMvs := Sv020Mem()		// Funcao que salva os mv_par??

//������������������������������������������������������Ŀ
//� Chamada a funcao que gera o cta superior             �
//��������������������������������������������������������

Pergunte("CTB040",.F.)

If mv_par01 != 3					// Automatico / Formula
	If mv_par01 == 1				// Automatico -> Formula Siga
		M->CTD_ITSUP	:= CtbItemSup(cCodigo)
	ElseIf mv_par01 == 2			// Formula -> do usuario
		If !Empty(mv_par02)
			M->CTD_ITSUP:= &(mv_par02)
		EndIf
	EndIf
EndIf

If (nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "CTD_ITSUP" } )) > 0
	//������������������������������������������������������Ŀ
	//� Exibe na tela a Conta Superior Gerada                �
	//��������������������������������������������������������
	nEnd1	:= Val(Subs(aGets[nEndereco],1,2))
	nEnd2	:= Val(Subs(aGets[nEndereco],3,1))*2
	aTela[nEnd1][nEnd2] := M->CTD_ITSUP
	lRefresh := .T.
EndIf

Sv020Mem(cMemMvs)

If FindFunction("AtuVldEnt")
	AtuVldEnt("CTD", M->CTD_ITEM)
Endif

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CTBA040LEGEN � Autor � Renato F. Campos  � Data � 29/01/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe a legenda referente ao status                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CTBA040LEGEN()                                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � CTBA040                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function Ctba040leg()

BrwLegenda(STR0011,STR0012,{	{ "BR_VERDE"    , STR0013},;  //"Legenda"###"Item do Centro de Custo"###"Sem Restri��o"
{ "BR_VERMELHO" , STR0014},;  //"Bloqueado"
{ "BR_AMARELO"	, STR0015},;  //"Exercicio N�o Inciado"
{ "BR_CINZA"	, STR0016}})  //"Exercicio Finalizado"


Return Nil

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Paulo Carnelossi      � Data �07/03/07  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados         ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MenuDef()

Local aRotina := {	{ OemToAnsi(STR0001),"AxPesqui"  ,0 , 1},;  //"Pesquisar"
{ OemToAnsi(STR0002),"AxVisual"  ,0 , 2},;  //"Visualizar"
{ OemToAnsi(STR0003),"U_PXH021A()",0 , 3},;  //"Incluir"
{ OemToAnsi(STR0004),"CTBA040Alt",0 , 4},;  //"Alterar"
{ OemToAnsi(STR0005),"Ctba040Del",0 , 5},;  //"Excluir"
{ OemToAnsi("Importar"),"Ctba040Imp",0 , 3},;	
{ OemToAnsi("Exportar"),"Ctba040Exp",0 , 4},;	
{ OemToAnsi(STR0011),"Ctba040leg",0 , 6},;	//"Legenda"
{ OemToAnsi("Conhecimento"),"MSDOCUMENT",0 , 4} }	
Return(aRotina)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTBA040Exp�Autor  �Marcelo Akama       � Data �  13/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Exporta itens contabeis para arquivo .CSV                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CTBA040Exp()

Local aRet		:=	{}


If !FindFunction("CTBExpCSV")
	Aviso("Exportar","Funcao nao disponivel",{"Fechar"})  
	Return .F.
EndIf

SaveInter()

If ParamBox({	{6,"Estrut. de itens contabeis",padr("",150),"",,"",90 ,.T.,"Arquivo .CSV |*.CSV","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE}},; 
	"Exportar para estrutura de itens contabeis",@aRet)  
	
	oProcess:= MsNewProcess():New( {|lEnd| CTBExpCSV( lEnd, oProcess, aRet[1], { {"CTD",1} } )} )
	oProcess:Activate()
	
EndIf

RestInter()

Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTBA040Imp�Autor  �Marcelo Akama       � Data �  13/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa itens contabeis de arquivo .CSV                     ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CTBA040Imp()

Local aRet	:= {}
Local aArea	:= CTD->(GetArea())
Local aCfg
Local cCampos


If !FindFunction("CTBImpCSV")
	Aviso("Importar","Funcao nao disponivel",{"Fechar"})  
	Return .F.
EndIf

CTD->(dbGoTop())
If !( CTD->(Eof()) .And. CTD->(Bof()) )
	Aviso("Importar","A importacao de itens contabeis so pode ser"+CRLF+"feita com o cadastro de itens contabeis vazio",{"Fechar"})  
	RestArea(aArea)
	Return .F.
EndIf

SaveInter()

cCampos:="CTD_ITEM,CTD_CLASSE,CTD_NORMAL,CTD_DESC01,CTD_DESC02,CTD_DESC03,CTD_DESC04,CTD_DESC05,CTD_BLOQ,CTD_DTBLIN,CTD_DTBLFI,CTD_DTEXIS,CTD_DTEXSF,CTD_ITLP,CTD_ITPON,CTD_BOOK,CTD_ITSUP,CTD_RES,CTD_CRGNV1,CTD_CRGNV2,CTD_RGNV3,CTD_CLOBRG,CTD_ACCLVL,CTD_ITVM,CTD_ITRED"

aCfg := { { "CTD", cCampos, {||MsExecAuto({|x,y| CTBA040(x,y)}, xAutoCab, 3)} } }

If ParamBox({	{6,"Estrut. de itens contabeis",padr("",150),"",,"", 90 ,.T.,"Arquivo .CVE |*.CVE","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE}},;	 
	"Importar estrutura de itens contabeis",@aRet)  
	
	oProcess:= MsNewProcess():New( {|lEnd| CTBImpCSV( lEnd, oProcess, aRet[1], aCfg )} )
	oProcess:Activate()
	lCTB040AUT := .F.
	
EndIf

RestInter()
RestArea(aArea)

Return .T.


Static Function PXH021B(cAlias, lMessage)
	
Local lRet		:= .f.
Local nPos
Local aCtbIni 	:= ReadIniCtb()
Local bSx3 		:= { |cCampo| (	SX3->(DbSetOrder(2)), SX3->(DbSeek(cCampo)),;
								SX3->(DbSetOrder(1)), SX3->X3_USADO) }

DEFAULT lMessage := .F.

If ! CtbInUse()		// Compatibilizacao com o SigaCon
	If cAlias = "CTT"
		lRet 	:= X3Uso(Eval(bSx3, "I2_CCC")) .And. X3Uso(Eval(bSx3, "I2_CCD"))
	ElseIf cAlias = "CTD"
		lRet 	:= X3Uso(Eval(bSx3, "I2_ITEMC")) .And. X3Uso(Eval(bSx3, "I2_ITEMD"))
	Else
		lRet	:= .F.
	Endif
Else
	nPos := Ascan(aCtbIni, {|x| Substr(x,20,03) = Upper(cAlias) })
	If nPos > 0
		lRet := Iif(Substr(aCtbIni[nPos],18,1) == "1",.T.,.F.)
	Endif
Endif

If ! lRet .And. lMessage .And. cAlias = "CTH"
	Help(" ",1,"NCONSALCV")
ElseIf ! lRet .And. lMessage .And. cAlias = "CTD"
	Help(" ",1,"NCONSALITE")
ElseIf ! lRet .And. lMessage .And. cAlias = "CTT"
	Help(" ",1,"NCONSALCC")
Endif

Return lRet
