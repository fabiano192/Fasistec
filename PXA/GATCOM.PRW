#Include "rwmake.ch"
#Include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GATCOM   ºAutor  ³ Alexandro          º Data ³  04/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilhos do Modulo de Compra		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaEst                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GCOM001()

_aAliOri := GetArea()
_aAliSB1 := SB1->(GetArea())

_cSubGrupo := TRIM(M->B1_SUBGRUP)

SB1->(dbOrderNickName("INDSB11"))
SB1->(dbSeek(xFilial("SB1")+_cSubgrupo+"998",.T.))

SB1->(dbSkip(-1))

If Left(_cSubGrupo,1) == "P"
	If Left(SB1->B1_COD,6) == _cSubGrupo
		_cProduto := Left(SB1->B1_COD,6) + Soma1(Substr(SB1->B1_COD,7,3) )
	Else
		_cProduto := _cSubGrupo + "001"
	Endif
Else
	If Left(SB1->B1_COD,7) == _cSubGrupo
		_cProduto := Left(SB1->B1_COD,7) + Soma1(Substr(SB1->B1_COD,8,3) )
	Else
		_cProduto := _cSubGrupo + "001"
	Endif    
Endif    

M->B1_YCODBKP := _cProduto

RestArea(_aAliSB1)
RestArea(_aAliOri)


Return(_cProduto)


User Function GCOM002()

_aAliOri := GetArea()
_aAliSB1 := SB1->(GetArea())
_aAliSC7 := SC7->(GetArea())

_nPProduto := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_COD" } )
_nPPedido  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_PEDIDO" } )
_nPItemPc  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_ITEMPC" } )
_nPDescri  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_YDESPRO" } )

_cPedido   := Acols[n][_nPPedido]
_cProduto  := Acols[n][_nPProduto]
_cItemPc   := Acols[n][_nPItemPc]
_cDescri   := ""

SC7->(dbSetOrder(1))
If SC7->(dbSeek(xFilial("SC7")+_cPedido  + _cItemPc))
	_cDescri := SC7->C7_DESCRI
Else
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+_cProduto))
		_cDescri := SB1->B1_DESC
	Endif
Endif

Acols[n][_nPDescri] := _cDescri

RestArea(_aAliSB1)
RestArea(_aAliSC7)
RestArea(_aAliOri)

Return(_cDescri)


User Function GCOM003()

_aAliOri := GetArea()
_aAliSA2 := SA2->(GetArea())

_cCod := M->A2_COD

_cq := " SELECT MAX(A2_COD) AS COD FROM "+RetSqlName("SA2")+" A "
_cq += " WHERE A.D_E_L_E_T_ = '' AND SUBSTRING(A2_COD,1,1) = 'F' "

TcQuery _cq New Alias "ZZ"

_cCod := Substr(ZZ->COD,2,5)
_cCod := "F"+ Soma1(_cCod)

ZZ->(dbCloseArea())

RestArea(_aAliSA2)
RestArea(_aAliORI)

Return(_cCod)


User Function GCOM004()

Local nX

If ValType(cNFiscal)=="C"
	cNFiscal := AllTrim(cNFiscal)
	For nX := 1 To Len(cNFiscal)
		If !(SubStr(cNFiscal, nX, 1) $ "0123456789")
			Return .F.
		EndIf
	Next
	
	cNFiscal := Iif(!Empty(cNFiscal),RIGHT("00000000"+cNFiscal,9),Space(TamSX3("F1_DOC")[1]))
EndIf

Return .T.

User Function GCOM005()

_aAliOri := GetArea()
_aAliSB1 := SB1->(GetArea())
_cGrupo  := M->B1_GRUPO

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+_cGrupo+"99999",.T.))

SB1->(dbSkip(-1))

If Left(SB1->B1_COD,4) == _cGrupo
	_cProduto := Left(SB1->B1_COD,4) + Soma1(Substr(SB1->B1_COD,5,5) )
Else
	_cProduto := _cGrupo + "00001"
Endif

RestArea(_aAliSB1)
RestArea(_aAliOri)

Return(_cProduto)


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//		Gatilho validando o campo C1_UM e C7_UM
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USER FUNCTION GCOM006()

LOCAL _aAliOri := GetArea()							// Salva o ambiente ativo
LOCAL _nHProduto := 0
LOCAL _cHUniMed	 := 0


_cHUniMed	  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_UM"} )
if _cHUniMed==0
	_cHUniMed	  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C7_UM"} )
endif



IF ALLTRIM(FUNNAME()) == "MATA110"				// SOLICITAÇÃO DE COMPRAS
	
	_nHProduto    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_PRODUTO"   } )		// Varre o aHeader e posicionando no elemento referente ao campo código do Produto retornando sua posição no array
	_cHUniMed	  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_UM"	} )		// Varre o aHeader e posicionando no elemento referente ao campo de unidade de medida do Produto retornando sua posição no array
	
ELSEIF ALLTRIM(FUNNAME()) $ "MATA12/MATA121/MATA120"  // PEDIDO DE COMPRAS
	
	_nHProduto    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C7_PRODUTO"   } )		// Varre o aHeader e posicionando no elemento referente ao campo código do Produto retornando sua posição no array
	_cHUniMed	  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C7_UM"	} )		// Varre o aHeader e posicionando no elemento referente ao campo de unidade de medida do Produto retornando sua posição no array
	
ELSEIF ALLTRIM(FUNNAME()) $ "MATA103" 			// DOCUMENTO DE ENTRADA
	
	_nHProduto    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_COD"  		} )		// Varre o aHeader e posicionando no elemento referente ao campo código do Produto retornando sua posição no array
	_cHUniMed	  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_UM"	} )		// Varre o aHeader e posicionando no elemento referente ao campo de unidade de medida do Produto retornando sua posição no array
	
ENDIF

_nProd  	 := ALLTRIM(Acols[N][_nHProduto])	// Posiciona no elemento do acols referente ao código do produto e atribui seus dados a variável _nProd
_cUniMed   	 := ALLTRIM(Acols[N][_cHUniMed] )	// Posiciona no elemento do acols referente a unidade de medida do produto e atribui seus dados a variável _cUniMed


IF .NOT. LEFT(_nProd,1) == "P"					// Validação liberando a alteração da descrição do campo C1_DESCRI apenas se o código do produto inicial com P
	
	DBSELECTAREA("SB1")							// Seleciona a tabela SB1 e disponibiliza em memória para uso
	DBSETORDER(1)								// Seleciona o índice da tabela FILIAL + CODIGO_PRODUTO
	DBSEEK(xFilial("SB1")+_nProd)				// Posiciona no produto informado através da variável _nProd
	
	_cUniMedSB1 := ALLTRIM(B1_UM)				// Atribui a descrição real do produto cadastrado na tabela SB1
	
	MSGBOX("A unidade de medida deste produto não pode ser alterada","Unidade de medida do produto","STOP")	// Exibe alerta
	
	Restarea(_aAliOri)							// Restaura um ambiente salvo anteriormente pela função GETAREA().
	RETURN (_cUniMedSB1)   						// Retorna a descrição real do produto
ENDIF


Restarea(_aAliOri)	// Restaura um ambiente salvo anteriormente pela função GETAREA().

RETURN(_cUniMed)	// Retorna a descrição alterada do produto
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//		Marcus Vinicius - 14/06/2016 - Solicitado por Heleno Zeferino Chamado: 24444
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//		Gatilho validando o campo C1_PRODUTO e C7_PRODUTO
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

USER FUNCTION GCOM007()

_aAliOri := GetArea()
_aAliSB2 := SB2->(GetArea())
_aAliSCP := SCP->(GetArea())

cProduto := space(15)

IF (nModulo == 02)
	
	cProduto := M->C1_PRODUTO
	
	SB2->(dbSetOrder(1))
	IF SB2->(dbSeek(xFilial("SB2") + M->C1_PRODUTO + "01"))
		MSGINFO(" SALDO ATUAL --> " + STR(SB2->B2_QATU))
	ENDIF
ELSEIF (nModulo == 04) .Or. nModulo == 19
	
	cProduto := M->CP_PRODUTO
	
	If nModulo == 04
		SB2->(dbSetOrder(1))
		If SB2->(dbSeek(xFilial("SB2") + M->CP_PRODUTO + "01"))
			IF SB2->B2_QATU <= 0
				MSGInfo("PRODUTO COM SALDO ZERO OU NEGATIVO")
				cProduto := ''
			ELSE
				MSGINFO(" SALDO ATUAL --> " + STR(SB2->B2_QATU))
			ENDIF
		ENDIF
	ENDIF
ENDIF

Restarea(_aAliSB2)
Restarea(_aAliSCP)
Restarea(_aAliOri)

Return(cProduto)

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//		Marcus Vinicius - 14/06/2016 - Solicitado por Heleno Zeferino Chamado: 24472
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------