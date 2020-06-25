#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PXH019   �Autor  � Alexandro          � Data �  26/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PROGRAMA PARA GERAR ARQUIVOS COMPATIVEIS COM EXCEL, DOS    ���
���          � RESULTADOS DE VENDAS ENTRE AS EMPRESAS DO GRUPO            ���
�������������������������������������������������������������������������͹��
���Uso       � FATURAMENTO                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PXH019()


Local   cPerg     := "PXH019"
Local   cChave    := "Empresa+Cliente+Loja+Cidade"
Local   nRecs     := 0
Private cLocal    := ""
Private cLoja 	  := ""

ATUSX1()

If !Pergunte(cPerg)
	MsgInfo("Opera��o cancelada pelo usu�rio.")
	Return
EndIf

cLocal  := cGetFile("*.*","Selecione o diret�rio",0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY)
__CopyFile("\demonstrativo_nf\assinatura.jpg", cLocal+"\assinatura.jpg")

If fGetDados()
	nRecs := fTransfTrb(cChave)
	Processa({|| fProcessa(nRecs, cChave)})
EndIf
Return


Static Function fProcessa(nRecs, cChave)

Local cChaveAtual := ""

ProcRegua(nRecs)
While !TRBZZD->(Eof())
	If cChaveAtual <> TRBZZD->(&cChave)

		cChaveAtual := (TRBZZD->(&cChave))
		fCriaNovoTrab(cChave, cChaveAtual, TRBZZD->Empresa, TRBZZD->Filial)
	EndIf
	IncProc()
	TRBZZD->(DbSkip())
EndDo

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FGETDADOS �Autor  � ZAGO               � Data �  17/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � FUNCAO PARA RECUPERAR OS DADOS DA TABELA ZZD CONFORME OS   ���
���          � PARAMETROS PASSADOS                                        ���
�������������������������������������������������������������������������͹��
���Uso       � FATURAMENTO MIZU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetDados
Local cSQL     := ""
Local cEOL     := Chr(13)
Local cZZD     := RetSqlName("ZZD")+" ZZD"
Local cDtIni   := ValToSql(mv_par01)
Local cDtFim   := ValToSql(mv_par02)
Local cCliDe   := ValToSql(mv_par03)
Local cCliAte  := ValToSql(mv_par04)
Local cLojDe   := ValToSql(mv_par05)
Local cLojAte  := ValToSql(mv_par06)
Local cMunDe   := ValToSql(mv_par07)
Local cMunAte  := ValToSql(mv_par08)

cSQL += "SELECT 'PXHOL' AS Emitente,"+cEOL
cSQL += "       ZZD_NOME Razao,"+cEOL
cSQL += "       ZZD_EMIS, "+cEOL
cSQL += "       Substring(ZZD_EMIS,7,2)+'/'+Substring(ZZD_EMIS,5,2)+'/'+Substring(ZZD_EMIS,1,4) Emissao,"+cEOL
cSQL += "       ZZD_DOC NF,"+cEOL
cSQL += "       ZZD_QTLIQ Volume,"+cEOL
cSQL += "       ZZD_PRECO Preco_Ton,"+cEOL
cSQL += "       ZZD_PRECOG-ZZD_PRECO DIF, "+cEOL
cSQL += "       ZZD_TOTNFG-ZZD_TOTNF DIF_PAGAR, "+cEOL
cSQL += "       ZZD_PRECOG Preco,"+cEOL
cSQL += "       ZZD_TOTNFG Vlr_total,"+cEOL
cSQL += "       ZZD_TOTNF TotNf ,"+cEOL
cSQL += "       ZZD_MUNEND Cidade, "+cEOL
cSQL += "       ZZD_CODEMP Empresa, "+cEOL
cSQL += "       ZZD_CODFIL Filial,"+cEOL
cSQL += "       ZZD_CLIE Cliente,"+cEOL
cSQL += "       ZZD_LOJA Loja, "+cEOL
cSQL += "       ZZD_PRCLIQ PrcLiq, "+cEOL
cSQL += "       ZZD_TOTLIQ TotLiq, "+cEOL
cSQL += "       ZZD_IPI IPI, "+cEOL
cSQL += "       ZZD_PRECOG - ZZD_PRCLIQ PRELIQ, "+cEOL
cSQL += "       ZZD_DEVCDC DIFCDC, "+cEOL
cSQL += "       ZZD_TOTNFG + ZZD_IPI VLTOT "+cEOL
cSQL += "   FROM "+RetSqlName("ZZD")+" "+cEOL
cSQL += "   WHERE ZZD_EMIS BETWEEN !DT_INI! AND !DT_FIM!"+cEOL
cSQL += "   AND ZZD_YDEV NOT IN ('D','C')"+cEOL
cSQL += "   AND ZZD_CLIE BETWEEN   !CLI_DE! AND !CLI_ATE!"+cEOL
cSQL += "   AND ZZD_LOJA BETWEEN   !LOJ_DE! AND !LOJ_ATE!"+cEOL
cSQL += "   AND ZZD_MUNEND BETWEEN !MUN_DE! AND !MUN_ATE!"+cEOL
cSQL += "   AND D_E_L_E_T_ = ' '  "+cEOL
cSQL += "   ORDER BY ZZD_EMIS, ZZD_CLIE, ZZD_LOJA, ZZD_MUNEND"

cSQL := StrTran(cSQL,"!DT_INI!" ,cDtIni)
cSQL := StrTran(cSQL,"!DT_FIM!" ,cDtFim)
cSQL := StrTran(cSQL,"!CLI_DE!" ,cCliDe)
cSQL := StrTran(cSQL,"!CLI_ATE!",cCliAte)
cSQL := StrTran(cSQL,"!LOJ_DE!" ,cLojDe)
cSQL := StrTran(cSQL,"!LOJ_ATE!",cLojAte)
cSQL := StrTran(cSQL,"!MUN_DE!" ,cMunDe)
cSQL := StrTran(cSQL,"!MUN_ATE!",cMunAte)

cSQL := ChangeQuery(cSQL)

If Select("QRYZZD") > 1
	QRYZZD->(DbCloseArea())
EndIf

TcQuery cSQL New Alias "QRYZZD"

TcSetField("QRYZZD","DIF_PAGAR","N",14,4)
TcSetField("QRYZZD","VLR_TOTAL","N",14,4)
TcSetField("QRYZZD","TOTAL_NF","N",14,4)

Return !QRYZZD->(Eof())


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FTRANSFTRB�Autor  � ZAGO               � Data �  17/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � TRANSFERE OS DADOS DA WORKAREA PARA UM ARQUIVO FISICO EM   ���
���          � DISCO, SENDO POSSIVEL CRIACAO DE INDICES PARA O MESMO      ���
�������������������������������������������������������������������������͹��
���Uso       � FATURAMENTO MIZU                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fTransfTrb(cChave)

Local aFields := {}
Local nRecs   := 0

//aFields := QRYZZD->(DbStruct())
//cTrab   := CriaTrab(aFields)

If Select("TRBZZD") > 1
	TRBZZD->(DbCloseArea())
EndIf

dbSelectArea("QRYZZD")

cTrab := CriaTrab(NIL,.F.)
Copy To &cTrab

//dbCloseArea()

dbUseArea(.T.,,cTrab,"TRBZZD",.T.)
_cInd1 := "EMISSAO+CLIENTE+LOJA+CIDADE"
IndRegua("TRBZZD",cTrab,_cInd1,,,"Selecionando Arquivo Trabalho")

TRBZZD->(DbGoTop())

Return nRecs

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRIANOVOTR�Autor  � ZAGO               � Data �  17/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � GERA O ARQUIVO NA PASTA DEFINIDA PELO PARAMETRO MIZ_DIRDNFC���
���          � QUE POR PADRAO APONTA PARA \DEMONSTRATIVO_NF               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCriaNovoTrab(cChave, cChaveFiltro, _cEmpresa, _cFilial)

Local aFields := {}
Local cNomArq := ""
Local cData   := DtoS(mv_par01)
Local aArea   := TRBZZD->(GetArea())

Local cPasta  := GetNewPar("PXH_DIRNFC","\demonstrativo_nf")

cNomeArq := cPasta+"\"+UPPER(Alltrim(TRBZZD->Razao)+" - "+TRBZZD->Empresa+" - "+Alltrim(TRBZZD->Cidade)+" - "+alltrim(TRBZZD->Loja))+".xls"
cLoja    := alltrim(TRBZZD->Loja)

aFields  := TRBZZD->(DbStruct())

cTrab    := CriaTrab(aFields)

dbUseArea( .T.,,cTrab, "TRB", .F., .F. )

TRBZZD->(DbGoTop())

DbSelectArea("TRBZZD")
DbSelectArea("TRB")

APPEND FROM TRBZZD FOR Empresa+Cliente+Loja+Cidade == cChaveFiltro

COPY TO &cNomeArq

cCGC := fGetCNPJ(Substr(cChaveFiltro,3,6), Substr(cChaveFiltro,9,2), _cEmpresa, _cFilial)

U_PXH020(cNomeArq, cLocal, cCGC, cLoja)

TRB->(DbCloseArea())

Ferase(cTrab)

DbSelectArea("TRBZZD")

SET FILTER TO

RestArea(aArea)

Return


Static Function fGetCNPJ(_cliente, _loja, _cEmpresa, _cFilial)

Local _CNPJ   := ""

Local wcServer:= "192.168.0.22"
Local wnPort  := 5050
Local wcEnv   := "holding"

oServer := TRPC():New(wcEnv)
If oServer:Connect( wcServer, wnPort)
	oServer:CallProc("RPCSetType", 3 )
	oServer:CallProc("RPCSetEnv", _cEmpresa, _cFilial,,,,, {'SA1'})
	ConOut("Conex�o estabelecida no servidor.")
	_CNPJ := oServer:CallProc("POSICIONE", "SA1", 1, "  "+_cliente+_loja, "A1_CGC")
	oServer:Disconnect()
Else
	conout("Erro na comunica��o com o servidor "+Alltrim(wcServer)+" porta "+Alltrim(Str(wnPort))+" ambiente "+wcEnv)
EndIf

Return _CNPJ


Static Function ATUSX1()

cPerg := "PXH019"

//    	   Grupo/Ordem/Pergunta            /perg_spa   /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data De               ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Data Ate              ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""    ,"")
U_CRIASX1(cPerg,"03","Cliente De            ?",""       ,""      ,"mv_ch3","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"04","Cliente Ate           ?",""       ,""      ,"mv_ch4","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""    ,"CLI")
U_CRIASX1(cPerg,"05","Loja De               ?",""       ,""      ,"mv_ch5","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR05",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"06","Loja Ate              ?",""       ,""      ,"mv_ch6","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR06",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""    ,"")
U_CRIASX1(cPerg,"07","Municipio De          ?",""       ,""      ,"mv_ch7","C" ,25     ,0      ,0     ,"G",""            ,"MV_PAR07",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"08","Municipio Ate         ?",""       ,""      ,"mv_ch8","C" ,25     ,0      ,0     ,"G",""            ,"MV_PAR08",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""    ,"")

Return