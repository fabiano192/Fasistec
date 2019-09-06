#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
Autor 		: Fabiano da Silva
Data 		: 23/05/12
Programa  	: PA0227
Descrição 	: Relacao de Pedidos nao entregues (E-mail)
*/

User Function PA0227()

PREPARE ENVIRONMENT Empresa "01" Filial "01"
	
_aAliOri := GetArea()       
_aAliSC6 := SC6->(GetArea())

_lEnvia    := .F.    
_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| 	PA227A(@_lFim) }
_cTitulo01 := 'Enviando E-mail !!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

RestArea(_aAliSC6)
RestArea(_aAliOri)

Return


Static Function PA227A()


Private cArq
Private nArq
Private cPath

cPath := "\ArqCSV\"

cArq  := CriaTrab(Nil, .F.)
nArq  := FCreate(cPath + cArq + ".CSV")

If nArq == -1  
	MsgAlert("Não conseguiu criar o arquivo!")
	Return
EndIf

FWrite(nArq, "CLIENTE;LOJA;NOME;PEDIDO;ITEM;EMISSAO;TIPO;PRODUTO;PROD.CLIENTE;REF.CLIENTE;DT ENTREGA;MATERIAL;INSERTO;QUANTIDADE;QTDE ENTREGUE;SALDO;ACABAMENTO;CQ;UNITARIO;TOTAL(SALDO)" + Chr(13) + Chr(10))
                                
_lEnvia := .F.

_dtIni :=  dDataBase - 365
_dtFim :=  dDataBase + 7

_cQuery := " SELECT C6_CLI,C6_LOJA,A1_NOME,C6_NUM,C6_ITEM,C5_EMISSAO,C6_PEDAMOS,C6_PRODUTO,C6_CPROCLI,C6_PEDCLI,C6_ENTREG,C6_QTDVEN,C6_QTDENT,C6_PRCVEN "
_cQuery += " FROM "+RetSqlName("SC6")+" C6 (NOLOCK) "
_cQuery += " INNER JOIN "+RetSqlName("SC5")+" C5 (NOLOCK) ON C6_NUM = C5_NUM "
_cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 (NOLOCK) ON C6_CLI+C6_LOJA = A1_COD+A1_LOJA "
_cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4 (NOLOCK) ON C6_TES = F4_CODIGO "
_cQuery += " WHERE C6.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' "
_cQuery += " AND C6_PEDAMOS IN ('N','A','D') "
_cQuery += " AND F4_DUPLIC = 'S' AND C5_TIPO = 'N' "
_cQuery += " AND C6_ENTREG BETWEEN '"+DTOS(_dtIni)+"' AND '"+DTOS(_dtFim)+"' "
_cQuery += " AND C6_QTDVEN > C6_QTDENT "
_cQuery += " AND C6_BLQ = '' "
_cQuery += " ORDER BY C6_CLI,C6_LOJA,C6_PRODUTO,C6_ENTREG"

TCQUERY _cQuery New ALIAS "ZC6"

TcSetField("ZC6","C5_EMISSAO" ,"D",8)
TcSetField("ZC6","C6_ENTREG" ,"D",8)

ZC6->(dbGoTop())

Private _aMaterial := {}
Private _aInserto  := {}
Private _aEstoque  := {}

While ZC6->(!Eof())

		_nPosMat  := aScan(_aMaterial,{|x| x[1] == ZC6->C6_PRODUTO})
		If _nPosMat = 0
			VerEstrut(1)
		Endif
		
		_nPosIns  := aScan(_aInserto,{|x| x[1] == ZC6->C6_PRODUTO})
		If _nPosIns = 0
			VerEstrut(2)
		Endif
		
		_nPosEst  := aScan(_aEstoque,{|x| x[1] == ZC6->C6_PRODUTO})
		If _nPosEst = 0
			AADD(_aEstoque,{ZC6->C6_PRODUTO,0,0})
			VerEstrut(3)
		Endif
				
		_bSee3    := {|x| x[1] == ZC6->C6_PRODUTO}
		_nPosRe3  := aScan(_aEstoque,_bSee3)


	_cCli := Alltrim(ZC6->C6_CLI)
	_cLoj := Alltrim(ZC6->C6_LOJA)
	_cNom := Alltrim(ZC6->A1_NOME)
	_cNum := Alltrim(ZC6->C6_NUM)
	_cIte := Alltrim(ZC6->C6_ITEM)
	_cEmi := dToc(ZC6->C5_EMISSAO)
	_cTip := Alltrim(ZC6->C6_PEDAMOS)
	_cPro := Alltrim(ZC6->C6_PRODUTO)
	_cPCl := Alltrim(ZC6->C6_CPROCLI)
	_cPed := Alltrim(ZC6->C6_PEDCLI)
	_cDtE := dToc(ZC6->C6_ENTREG)

	_bSee1    := {|x| x[1] == ZC6->C6_PRODUTO}
	_nPosRe1  := aScan(_aMaterial,_bSee1)
	_cMat     := " "
	If _nPosRe1 > 0
		For M := 2 to Len(_aMaterial[_nPosRe1])
			If M > 2
				_cMat += "-"
			Endif
			_cMat += Alltrim(_aMaterial[_nPosRe1][M])
		Next M
	Endif

	_bSee2    := {|x| x[1] == ZC6->C6_PRODUTO}
	_nPosRe2  := aScan(_aInserto,_bSee2)
	_cIns     := " "
	If _nPosRe2 > 0
		For I := 2 to Len(_aInserto[_nPosRe2])
			If I > 2
				_cIns += "-"
			Endif
			_cIns += Alltrim(_aInserto[_nPosRe2][I])
		Next I
	Endif

	_cQte := Alltrim(Transform(ZC6->C6_QTDVEN,"@ze 9,999,999.99"))
	_cQEn := Alltrim(Transform(ZC6->C6_QTDENT,"@ze 9,999,999.99"))
	_nSal := ZC6->C6_QTDVEN - ZC6->C6_QTDENT
	_cSal := Alltrim(Transform(_nSal,"@ze 9,999,999.99"))
	_cAca := Alltrim(Transform(_aEstoque[_nPosRe3][2],"@ze 9,999,999.99"))
	_cCQ  := Alltrim(Transform(_aEstoque[_nPosRe3][3],"@ze 9,999,999.99"))
	_cUni := Alltrim(Transform(ZC6->C6_PRCVEN,"@ze 9,999,999.99"))
	_nTot := _nSal * ZC6->C6_PRCVEN
	_cTot := Alltrim(Transform(_nTot,"@ze 9,999,999.99"))
	
	FWrite(nArq, "'"+_cCli+";'"+_cLoj+";"+_cNom+";'"+_cNum+";'"+_cIte+";"+_cEmi+";"+_cTip+";'"+_cPro+";'"+_cPCl+";'"+_cPed+";"+_cDtE+";'"+_cMat +;
	 	  ";'"+_cIns+";"+_cQte+";"+_cQEn+";"+_cSal+";"+_cAca+";"+_cCQ+";"+_cUni+";"+_cTot +	Chr(13) + Chr(10))

	_lEnvia := .T.	 

	ZC6->(dbSkip())
EndDo

FClose(nArq)

If _lEnvia
	PA227B()
Endif

ZC6->(dbCloseArea())

Return



Static Function VerEstrut(_nOpc)

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+ZC6->C6_PRODUTO)
	
	_cProd   := SG1->G1_COD
	nNivel   := 2
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+_cProd)
	
	NECESC6(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU,_nOpc)
	
Endif

Return


Static Function NECESC6(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev,_nOpc)

Local _nReg := 0
Local _nRegTrb := 0

dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	_nReg := Recno()
	
	_cGrupo := ""
	If _nOpc = 1
		_cGrupo := "PIC /MPVZ/MPC /MPL "
	ElseIf _nOpc = 2
		_cGrupo := "MPIM/PIPM"
	Endif
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	If nQuantItem > 0
		
		dbSelectArea("SB1")
		aAreaSB1:=GetArea()
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		
		_nRegTRb := Recno()
		
		If _nOpc < 3
			
			If SB1->B1_GRUPO $ _cGrupo
				
				If _nOpc = 1 //Material
					_bSee1    := {|x| x[1] == ZC6->C6_PRODUTO}
					_nPosRe1  := aScan(_aMaterial,_bSee1)
					
					If _nPosRe1 = 0
						AADD(_aMaterial,{ZC6->C6_PRODUTO,SG1->G1_COMP})
					Else
						AADD(_aMaterial[_nPosRe1],SG1->G1_COMP)
					Endif
				ElseIf _nOpc = 2 //Inserto
					_bSee2    := {|x| x[1] == ZC6->C6_PRODUTO}
					_nPosRe2  := aScan(_aInserto,_bSee2)
					
					If _nPosRe2 = 0
						AADD(_aInserto,{ZC6->C6_PRODUTO,SG1->G1_COMP})
					Else
						AADD(_aInserto[_nPosRe2],SG1->G1_COMP)
					Endif
				Endif
			Endif
			
		ElseIf _nOpc = 3

			_bSee3    := {|x| x[1] == ZC6->C6_PRODUTO}
			_nPosRe3  := aScan(_aEstoque,_bSee3)
			
			If SB1->B1_LOCPAD $ "20" //Acabamento

				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)					
					_aEstoque[_nPosRe3][2] := SB2->B2_QATU
				Endif
			Endif		

			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+ZC6->C6_PRODUTO+"98")
				_aEstoque[_nPosRe3][3] := SB2->B2_QATU
			Endif				

		Endif
		RestArea(aAreaSB1)
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+SG1->G1_COMP)
		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			
			NECESC6(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU,_nOpc)
		EndIf
		
		dbSelectArea("SG1")
		dbGoto(_nReg)
		
		dbSelectArea("SG1")
	Endif
	dbSkip()
EndDo

Return


Static Function PA227B()

Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail de Pedidos Nao Entregues:")

oProcess := TWFProcess():New( "ENVEM1", "NF" )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "PEDIDOS_NE", "\WORKFLOW\PED_NE.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

_nPerIpi  := 0
nValIPI   := 0
nTotal    := 0

oProcess:cSubject := "Pedidos não Entregues - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)
                                          
//_cTo := GETMV("MV_WEMPCP1")
//_cTo := "fabiano@assystem.com.br"
_cTo := "regis.santos@cronnos.com.br;silvana.silva@pasy.com.br;cristina.soares@pasy.com.br;helena.santos@pasy.com.br;paulo.freitas@pasy.com.br;alex.sousa@pasy.com.br;jose.vieira@pasy.com.br;maria.araujo@pasy.com.br"
_cCc := GETMV("MV_WEMTI1")
//_cCc := ""

oProcess:AttachFile(cPath + cArq + ".CSV")

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()

RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email Pedido NE iniciado!' )

oProcess:Finish()

Return
