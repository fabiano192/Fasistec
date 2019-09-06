//#INCLUDE "EECPEM10.ch"
/*
Programa        : PA0060.PRW
Objetivo        : Impressao Packing List
Autor           : Cristiano A. Ferreira
Data/Hora       : 21/01/2000 16:37
Obs.            : PAC00002.RPT

*/

#include "EECRDM.CH"



User Function PA0060

Local lRet := .f.
Local nAlias := Select()
Local aOrd := SaveOrd({"EE9","SA2","SY9","SA1","SYA","SYQ","EEK","EE5"})

Local x,cPortDest,cCodPais
Local cCod,cLoja,cRpt
 
Private nTotM3, nQty,lUnidade:=.f.,nTotPesLiq:=0,nTotPesBru:=0,;
        cPictPeso  := "9,999,999"+if(EEC->EEC_DECPES > 0, "."+Replic("9",EEC->EEC_DECPES),""),;
        cUnQtde,cUnPeso, cPictQtde:="9,999,999"+if(EEC->EEC_DECQTD > 0, "."+Replic("9",EEC->EEC_DECQTD),"")

Begin Sequence
   
   EE9->(dbSetOrder(3))
   EEK->(dbSetOrder(2))
   EE5->(dbSetOrder(1))
   
   cSeqRel := GetSXENum("SY0","Y0_SEQREL")
   ConfirmSX8()
   
   If EE9->(FieldPos("EE9_UNPES"))#0 .And. EE9->(FieldPos("EE9_UNPRC"))#0
      lUnidade:=.t. 
      cUnPeso:=CriaVar("EE9_UNPES")
      cUnQtde:=CriaVar("EE9_UNPRC")      

      IF ! TelaGets()
         lRet := .f.
         Break
      Endif
   EndIf   
   
   HEADER_P->(Add())
   
   //PROCESSO DE EMBARQUE
   HEADER_P->AVG_C15_20 := EEC->EEC_PREEMB
   
   // To
   HEADER_P->AVG_C01_60 := EEC->EEC_IMPODE
   HEADER_P->AVG_C02_60 := EEC->EEC_ENDIMP
   HEADER_P->AVG_C03_60 := EEC->EEC_END2IM
   HEADER_P->AVG_M01_06 := EEC->EEC_IMPORT   
   //HEADER_P->AVG_C04_60 := ""
   
   // Consignee
   HEADER_P->AVG_C05_60 := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_CONSIG+EEC->EEC_COLOJA,"A1_NOME")
   HEADER_P->AVG_C06_60 := EECMEND("SA1",1,EEC->EEC_CONSIG+EEC->EEC_COLOJA,.T.,,1)
   HEADER_P->AVG_C07_60 := EECMEND("SA1",1,EEC->EEC_CONSIG+EEC->EEC_COLOJA,.T.,,2)
   //HEADER_P->AVG_C08_60 :=
   
   // Route
   x := AllTrim(Posicione("SYQ",1,xFilial("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"))
   HEADER_P->AVG_C01_10 := Substr(x,At("-",x)+1)
   
   // Port of Discharge
   cPortDest := Posicione("SY9",2,xFilial("SY9")+EEC->EEC_DEST,"Y9_DESCR")
   HEADER_P->AVG_C01_20 := IF("/"$cPortDest,Subst(cPortDest,1,At("/",cPortDest)-1),cPortDest)
   
   // Coutry of Discharge 
   _cPais   := Posicione("SY9",2,xFilial("SY9")+EEC->EEC_DEST,"Y9_PAIS")  
//   _cNomPais:= Posicione("SYA",1,xFilial("SYA")+_cPais,"YA_NOIDIOM")
   cCodPais := Posicione("SYR",1,xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA,"YR_PAIS_DE")
   HEADER_P->AVG_C02_20 := Posicione("SYA",1,xFilial("SYA")+_cPais,"YA_NOIDIOM")
   
   // Invoice Nr.
   HEADER_P->AVG_C02_10 := AllTrim(EEC->EEC_NRINVO)

   HEADER_P->AVG_C03_10 := If (!lUnidade,"Kg","")
   
   // Date 
   // HEADER_P->AVG_C03_20 := Left(MesExtenso(Month(EEC->EEC_DTINVO)),3)+"/"+Padl(Day(EEC->EEC_DTINVO),2,"0")+"/"+Str(Year(EEC->EEC_DTINVO),4)    
   HEADER_P->AVG_C03_20 := Left(u_MesExtIng(Month(EEC->EEC_DTINVO)),3)+"/"+Padl(Day(EEC->EEC_DTINVO),2,"0")+"/"+Str(Year(EEC->EEC_DTINVO),4)
   
   x := Posicione("SYQ",1,xFilial("SYQ")+EEC->EEC_VIA,"YQ_COD_DI")
   
   nTotM3 := 0
   nQty   := 0 
   nTotcx := 0
   
   // 11/08/2000 CAF Especifico da 3m IF Left(x,1) == "7" .Or. Empty(x) // Via Rodoviaria
   GravaItens()
   // Endif
   
   //28/01/00 BY HEDER
   nTotM3 := EEC->EEC_CUBAGE  //CUBAGEM M3
   
   // Totais
   HEADER_P->AVG_C10_20 := Transf(nTotM3,"@E 999,999,999.99")
   HEADER_P->AVG_C16_20 := Transf(nTotcx,"@E 999")+" CARDBOARD BOXES"
   
   If lUnidade
//      HEADER_P->AVG_C11_20 := LTrim(Transf(nTotPesLiq,AVSX3("EEC_PESLIQ",6)))
//      HEADER_P->AVG_C12_20 := LTrim(Transf(nTotPesBru,AVSX3("EEC_PESBRU",6)))

      HEADER_P->AVG_C11_20 := LTrim(Transf(nTotPesLiq,cPictPeso))
      HEADER_P->AVG_C12_20 := LTrim(Transf(nTotPesBru,cPictPeso))

   Else
//      HEADER_P->AVG_C11_20 := LTrim(Transf(EEC->EEC_PESLIQ,AVSX3("EEC_PESLIQ",6)))
//      HEADER_P->AVG_C12_20 := LTrim(Transf(EEC->EEC_PESBRU,AVSX3("EEC_PESBRU",6)))

      HEADER_P->AVG_C11_20 := LTrim(Transf(EEC->EEC_PESLIQ,cPictPeso))
      HEADER_P->AVG_C12_20 := LTrim(Transf(EEC->EEC_PESBRU,cPictPeso))
   EndIf
   
   
   HEADER_P->AVG_C14_20 := LTRIM(TRANSF(nQTY,"@E 999,999,999.99"))
   
   // PACKAGE
   HEADER_P->AVG_C11_60 := ALLTRIM(EEC->EEC_PACKAGE)
   
   // Marks
   // HEADER_P->AVG_C04_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),1)  
   HEADER_P->AVG_C04_20 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))
   HEADER_P->AVG_C05_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),2)
   HEADER_P->AVG_C06_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),3)
   HEADER_P->AVG_C09_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),4)
   HEADER_P->AVG_C08_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),5)
   HEADER_P->AVG_C07_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),6)
   
   // Assinante
   IF !Empty(EEC->EEC_EXPORT)
      cCod := EEC->EEC_EXPORT
      cLoja:= EEC->EEC_EXLOJA
   Else
      cCod := EEC->EEC_FORN
      cLoja:= EEC->EEC_FOLOJA
   Endif
   
   HEADER_P->AVG_C09_60 := EECContato(CD_SA2,cCod,cLoja,"1",1,EEC->EEC_RESPON)
   
   // Exportador
   SA2->(DBSEEK(XFILIAL("SA2")+cCOD+cLOJA))
   HEADER_P->AVG_C10_60 := SA2->A2_NOME
      //PAIS DE ORIGEM EXPORTADOR 
   HEADER_P->AVG_C13_20 := Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM")
   
   HEADER_P->(dbUnlock())
  
   //*** JBJ - 19/06/01 - 11:56 - Gravar histórico de documentos - (INICIO)
   
   HEADER_H->(dbAppend())
   AvReplace("HEADER_P","HEADER_H") 

   DETAIL_P->(DBSETORDER(0),DbGoTop())
   Do While ! DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo
   DETAIL_P->(DBSETORDER(1))
   //*** (FIM) 
   HEADER_P->(DBCOMMIT())
   DETAIL_P->(DBCOMMIT())
    
   lRet := .t.
End Sequence

RestOrd(aOrd)
Select(nAlias)

Return lRet

/*
Funcao      : GravaItens
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 21/01/2000 16:37
Revisao     :
Obs.        :
*/
Static Function GravaItens

Local cOnThePackage := AllTrim(EEC->EEC_ONTHEP)
Local cEmb,nM3,lDescUnid:=.f.

Begin Sequence

   EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB))

   While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB

      If lUnidade                    
         If !lDescUnid
            DETAIL_P->(Add())

            // ** Pesos ...
            IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnPeso))
               MsgStop("Uniade de medida "+cUnPeso+" nao cadastrada em "+EEC->EEC_IDIOMA,"Aviso") 
            EndIf
            DETAIL_P->AVG_C04_20 := AllTrim(EE2->EE2_DESCMA)
            DETAIL_P->AVG_C05_20 := AllTrim(EE2->EE2_DESCMA)
                          
            // ** Quantidade ...
            IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnQtde))
               MsgStop("Unidade de medida "+cUnQtde+" nao cadastrada em "+EEC->EEC_IDIOMA,"Aviso") 
            EndIf
            DETAIL_P->AVG_C02_10 := AllTrim(EE2->EE2_DESCMA) // Unit
            //DETAIL_P->AVG_C06_20 := AllTrim(EE2->EE2_DESCMA)
                        
            DETAIL_P->(dbUnlock())
            lDescUnid:=.t.
         EndIf   

         
         DETAIL_P->(Add())
         
         DETAIL_P->AVG_C04_20 := AllTrim(Transf(AvTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSLQTO,.F.),cPictPeso))// Net Weight
         DETAIL_P->AVG_C05_20 := AllTrim(Transf(AvTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSBRTO,.F.),cPictPeso))// Gross Weight
 
         // ** Acumula os totais ...
         nTotPesLiq+=AvTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSLQTO,.F.)
         nTotPesBru+=AvTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSBRTO,.F.)
        
      Else
         DETAIL_P->(Add())

         DETAIL_P->AVG_C04_20 := Transf(EE9->EE9_PSLQTO,cPictPeso) // Net Weight
         DETAIL_P->AVG_C05_20 := Transf(EE9->EE9_PSBRTO,cPictPeso) // Gross Weight
      EndIf

//	  DETAIL_P->AVG_C01_20 := "1 PALLET" // ON THE PACKAGE
	  DETAIL_P->AVG_C01_20 := Transf(EE9->EE9_QTDEM1,"@E 999")+" CARDBOARD BOXES" // ON THE PACKAGE
      DETAIL_P->AVG_C02_20 := AllTrim(EE9->EE9_REFCLI) // Order     
      nTotcx += EE9->EE9_QTDEM1
                        
      If lUnidade
         DETAIL_P->AVG_C06_20 := Transf(AvTransUnid(EE9->EE9_UNIDAD,cUnQtde,EE9->EE9_COD_I,EE9->EE9_SLDINI,.F.),cPictQtde)
         nQty +=AvTransUnid(EE9->EE9_UNIDAD,cUnQtde,EE9->EE9_COD_I,EE9->EE9_SLDINI,.F.)
      Else
         DETAIL_P->AVG_C06_20 := Transf(EE9->EE9_SLDINI,cPictQtde) // Qtde
         nQTY := nQTY+EE9->EE9_SLDINI  //TOTAL QTY
      EndIf
           
      //DETAIL_P->AVG_C02_10 := AllTrim(EE9->EE9_UNIDAD) // Unit // ** By JBJ - 10/06/02 - 11:30 
            
      DETAIL_P->AVG_C03_20 := AllTrim(EE9->EE9_COD_I)  // Stk. Nbr.
      DETAIL_P->AVG_C03_20 := AllTrim(EE9->EE9_COD_I)  // Stk. Nbr.
      DETAIL_P->AVG_C03_20 := AllTrim(EE9->EE9_COD_I)  // Stk. Nbr.
      DETAIL_P->AVG_C07_20 := Alltrim(EE9->EE9_PART_N)  
      
      cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
      
   		DETAIL_P->AVG_C01_60 := MemoLine(cMemo,29,1)
		dbSelectArea("SZ2")
		dbSetorder(1)
		IF dbSeek(xFilial("SZ2")+EEC->EEC_IMPORT + EEC->EEC_IMLOJA + EE9->EE9_COD_I + Substr(EE9->EE9_PART_N,1,15)+"1" )
		    If Empty(DETAIL_P->AVG_C01_60)
				DETAIL_P->AVG_C01_60 := SZ2->Z2_DESCCLI
			Endif	
		Endif	

      For i := 2 To MlCount(cMemo,29,3)
         IF !EMPTY(MemoLine(cMemo,29,i))
            UnLockDet()
            AppendDet()
            DETAIL_P->AVG_C01_60 := MemoLine(cMemo,29,i)
         ENDIF
      Next
	  
      IF EEK->(AVSeekLast(xFilial("EEK")+OC_EM+EEC->EEC_PREEMB+EE9->EE9_SEQEMB+EE9->EE9_EMBAL1))
         cEmb := EEK->EEK_EMB
      Else
         cEmb := EE9->EE9_EMBAL1
      Endif
      
      EE5->(dbSeek(xFilial("EE5")+cEmb))
      nM3 := EE5->EE5_HALT*EE5->EE5_LLARG*EE5->EE5_CCOM

      DETAIL_P->AVG_C08_20 := Alltrim(EE5->EE5_DIMENS)  
//      DETAIL_P->AVG_C08_20 := "1.20 X 1.00 X 0.60"
      
      DETAIL_P->AVG_N03_15 := nM3 // Total M3
      DETAIL_P->AVG_N04_15 := EE9->EE9_PSLQTO  // LIQUIDO TOTAL DO ITEM
      DETAIL_P->AVG_N05_15 := EE9->EE9_PSBRTO  // BRUTO TOTAL DO ITEM
      
      nTotM3 := nTotM3+nM3      

      DETAIL_P->(dbUnlock())
          
      cOnThePackage := ""
      
      EE9->(dbSkip())
   Enddo
End Sequence

Return NIL

/*
Funcao      : Add
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 21/01/2000 16:37
Revisao     :
Obs.        :
*/
Static Function Add

Begin Sequence
   dbAppend()

   bAux:=FieldWBlock("AVG_FILIAL",Select())

   IF ValType(bAux) == "B"
      Eval(bAux,xFilial("SY0"))
   Endif

   bAux:=FieldWBlock("AVG_CHAVE",Select())

   IF ValType(bAux) == "B"
      Eval(bAux,EEC->EEC_PREEMB)
   Endif

   bAux:=FieldWBlock("AVG_SEQREL",Select())

   IF ValType(bAux) == "B"
      Eval(bAux,cSeqRel)
   Endif
End Sequence

Return NIL

/*
Funcao      : TelaGets
Parametros  : Nenhum                  
Retorno     : .T./.F.
Objetivos   : Criar Tela de Parametos
Autor       : Jeferson Barros Jr.
Data/Hora   : 04/06/2002 - 17:20
Revisao     :
Obs.        : 
*/
*--------------------------
Static Function TelaGets()
*--------------------------
Local oDlg, bOk:= {||nOpc:=1,oDlg:End()}, bCancel:={||oDlg:End()},;
      lRet:= .f.,nOpc := 0
                               
Begin Sequence

lRet   := .T.
cUnQtde := "PC"
cUnPeso := "PC" 

End Sequence

Return(lRet) 
         
*------------------------------------------------------------------------------*
* FIM DO PROGRAMA PA0060.PRW                                                 *
*------------------------------------------------------------------------------*
