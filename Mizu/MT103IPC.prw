#INCLUDE 'TOTVS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ºMT103IPC         ³                    º Data ³  02/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA EXECUTADO APOS SELECIONAR O PEDIDO DE COM º±±
±±º          ³ PRAS (F5) NA TELA DO DOCUMENTO DE ENTRADA (MATA103)        º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103IPC()

Local _nIt := PARAMIXB[1]   //no do item na acols
Local nD1_DESCRI:=0
Local nD1_COD:=0     

if IsInCallStack("u_smXMLCentral") // Adicionado por Rodrigo (Semar) em 30/07/2018 - não executar quando for oriundo da Central XML
	return                                                                                                                                  
endif


SeekTag(_nIt)



_aAliOri := GetArea()
_aAliSC7 := SC7->(GetArea())

nD1_COD    := AScan(aHeader,{ |x| AllTrim(x[2])        == "D1_COD"})
nD1_DESCRI := AScan(aHeader,{ |x| AllTrim(x[2])        == "D1_DESCRI"})
_nPPedido  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_PEDIDO" } ) 
_NPQTPES   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_PESADA" } )
_nPItemPc  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_ITEMPC" } )

_cPedido   := Acols[_nIt][_nPPedido]
_cItemPc   := Acols[_nIt][_nPItemPc]
_cDescri   := ""
_nQtPesada := 0                              

SC7->(dbSetOrder(1))
If SC7->(dbSeek(xFilial("SC7")+_cPedido  + _cItemPc))
	_cDescri   := SC7->C7_DESCRI
	_nQtPesada := SC7->C7_QUANT
Endif
   
aCols[_nIt,nD1_DESCRI]:= _cDescri                            


//If cEmpAnt $ "12/50" 			Comentado por Alison - 10/10/2016
If cEmpAnt + cFilAnt $ '1201|5001|0216'
	aCols[_nIt,_NPQTPES]:= _nQtPesada
Endif

RestArea(_aAliSC7)
RestArea(_aAliOri)

Return Nil



/*/{Protheus.doc} SeekTag
Atualiza campos customizados no Documento de Entrada
@type Ponto de Entrada
@version 001
@author Fabiano
@since 04/03/2020
/*/
Static Function SeekTag(_nIt)

	Local _nPosTag  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_YTAGMAE" } )

	If _nPosTag > 0 .And. SC7->(FieldPos("C7_YTAGMAE")) > 0
		Acols[_nIt][_nPosTag] := SC7->C7_YTAGMAE
	Endif

Return(Nil)