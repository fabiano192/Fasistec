#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GAT001     º Autor ³ Alexandro da Silvaº Data ³  07/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consistir a Data De Entrega                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GATEST01()

_aAliOri  := GetArea()
_aAliSG1  := SG1->(GetArea())
        
Private MvPar
Private MvParDef:=""
cAlias    := Alias()                   // Salva Alias Anterior
MvPar     :=&(Alltrim(ReadVar()))      // Carrega Nome da Variavel do Get em Questao
mvRet     :=Alltrim(ReadVar())         // Iguala Nome da Variavel ao Nome variavel de Retorno

_cProduto := MV_PAR05
If Empty(_cProduto)
   _cProduto  :=MV_PAR06
Endif
	
dbSelectArea("SG1")
dbSetOrder(1)
If !dbSeek(xFilial()+_cProduto)
   Alert("Nao Existe Estrutura para Esse Produto!!!")
   MV_PAR05 := sPace(15)
   MV_PAR06 := space(15)
Endif

RestArea(_aAliSG1)
RestArea(_aAliOri)
   
mvRet:=Alltrim(ReadVar())   
Return                                                           

User Function GEST001()

_aAliOri  := GetArea()
_aAliSB2  := SB2->(GetArea())
_nQuant   := 0
_nPosProd := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D3_COD" } )
_cProd    := Acols[n][_nPosProd]        
_nPosQuant:= aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D3_QUANT" } )
_nQt      := Acols[n][_nPosQuant]                             

dbSelectArea("SB2")
dbSetOrder(1)
If dbSeek(xFilial()+_cProd+"01")
   If SB2->B2_QATU >= _nQt
      _nQUANT:= _nQt
   Endif
Endif      

RestArea(_aAliSB2)
RestArea(_aAliOri)
                      
Return (_nQuant)
                            

User Function GEST002()

_cCav := Padl(Alltrim(M->D3_YNUMCAV),3,"0")

Return(_cCav)