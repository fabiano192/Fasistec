/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PXH020   ºAutor  ³ Alexandro          º Data ³  26/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ DEMONSTRATIVO DE ADITIVO EM FORMATO HTML                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ diversos                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PXH020(cNomeArq, cPasta, _cCNPJ, cLoja)

Local cHtml     := ""
Local nTotVol   := 0
Local nTotVol   := 0
Local nTotTot   := 0
Local nTotDif   := 0
Local nTotVlt   := 0
Local cEmitente := ""
Local cRazao    := ""
Local cCidade   := ""
Local cSalvaComo:= ""
Local dData     := CtoD("//")

Private cMensagem:= GetNewPar("MAX_MENSAGE","\demonstrativo_nf\mensagem\mensagem.htm")
Private nBytes   := 0
Private cEOL     := Chr(13)

dbUseArea( .T.,,cNomeArq, "TRBHTM", .F., .F. )

cNomeFile := Left(DtoS(CtoD(TRBHTM->Emissao)),6)+"_"+Alltrim(_cCNPJ)+"_"+AllTrim(TRBHTM->Emitente)+"_"+fnCidade(TRBHTM->Cidade)+"_"+AllTrim(cLoja)+".htm"
cSalvaComo:= cPasta+"\"+cNomeFile

nHandle := fCreate(cSalvaComo)

cEmitente := TRBHTM->Emitente
cRazao    := TRBHTM->Razao
cCidade   := TRBHTM->Cidade
dData     := CtoD(TRBHTM->Emissao)

fGeraCabec(cEmitente, cRazao, cCidade, @nBytes, dData)
GeraHead(nBytes)

TRBHTM->(DbGoTop())
While !TRBHTM->(Eof())

	cVal1  := Alltrim(TRBHTM->Emissao)
	cVal2  := Alltrim(TRBHTM->NF)
	cVal3  := Alltrim(Transform(TRBHTM->Volume	,"@E 999,999,999.99"))
	cVal4  := Alltrim(Transform(TRBHTM->PrcLiq	,"@E 999,999,999.99"))
	cVal5  := Alltrim(Transform(TRBHTM->Totliq	,"@E 999,999,999.99"))
	cVal6  := Alltrim(Transform(TRBHTM->IPI		,"@E 999,999,999.99"))
	cVal7  := Alltrim(Transform(TRBHTM->TotNF		,"@E 999,999,999.99"))
	cVal8  := Alltrim(Transform(TRBHTM->Preco		,"@E 999,999,999.99"))
	cVal9  := Alltrim(Transform(TRBHTM->PRELIQ	,"@E 999,999,999.99"))
	cVal10 := Alltrim(Transform(TRBHTM->DIFCDC	,"@E 999,999,999.99"))
	cVal11 := Alltrim(Transform(TRBHTM->VLTOT		,"@E 999,999,999.99"))

	nTotVol   += TRBHTM->Volume
	nTotTot   += TRBHTM->TotNF
	nTotDif   += TRBHTM->DIFCDC
	nTotVlt   += TRBHTM->VLTOT

	GeraLinha(@nBytes)

	TRBHTM->(DbSkip())
EndDo

fGeraRodap(nTotVol, nTotTot, nTotDif,nTotVlt,@nBytes)

fClose(nHandle)
TRBHTM->(DbCloseArea())

Return



Static Function fGeraCabec(cEmitente, cRazao, cCidade, nBytes, dData)

Local cHtml := ""

cMes := Upper(MesExtenso(Month(dData)))
cAno := Alltrim(Str(Year(dData)))

cHtml := '<title>Demonstrativo NF ARICA</title>'+cEOL
cHtml += '<body style="margin: 5.7pt 5.7pt 7.9pt 5.7pt; ">'+cEOL
cHtml += "<p class=MsoNormal align=center style='text-align:left'><span lang=PT-BR style='font-size:14.0pt;font-family:Arial'>DEMONSTRATIVO NF ARICA MÊS <b>"+cMes+" "+cAno+"</b></span></p>"+cEOL
cHtml += "<P><P><P><P>"+cEOL
cHtml += "<p class=MsoNormal><span lang=PT-BR style='font-size:10.0pt;font-family:Arial'><b>Emitente: </b>"+cEmitente+"</span></p>"+cEOL
cHtml += "<p class=MsoNormal><span lang=PT-BR style='font-size:10.0pt;font-family:Arial'><b>Razão: </b>"+cRazao+"</span></p>"+cEOL
cHtml += "<p class=MsoNormal><span lang=PT-BR style='font-size:10.0pt;font-family:Arial'><b>Cidade: </b>"+cCidade+"</span></p>"+cEOL
cHtml += "<p>"

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

Return



Static Function fGeraRodap(nTotVol, nTotTot, nTotDif, nTotVlt, nBytes)

Local cHtml := ""

cHtml += '<tr>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;"><small>Total</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;" align="right">-</td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;" align="right"><small>'+Transform(nTotVol ,"@E 999,999,999.99")+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;" align="right">-</td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;" align="right">-</td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;" align="right">-</td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;" align="right"><small>'+Transform(nTotTot ,"@E 999,999,999.99")+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;" align="right">-</td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;" align="right">-</td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;" align="right"><small>'+Transform(nTotDif ,"@E 999,999,999.99")+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;" align="right"><small>'+Transform(nTotVlt ,"@E 999,999,999.99")+'</small></td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '</tr>'+cEOL
cHtml += '</tbody>'+cEOL
cHtml += '</table>'+cEOL
cHtml += '</body>'+cEOL
cHtml += '</html>' +cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := Memoread(cMensagem)
nBytes += Len(cHtml)

Fwrite(nHandle,cHtml,nBytes)

Return



Static Function GeraLinha(nBytes)

Local cHtml := ""

cHtml += '<tr>'
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="text-align: right;"><small>'+cVal1+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 71px; text-align: right;"><small>'+cVal2+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 97px; text-align: right;"><small>'+cVal3+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 108px; text-align: right;"><small>'+cVal4+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 85px; text-align: right;"><small>'+cVal5+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 61px; text-align: right;"><small>'+cVal6+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 78px; text-align: right;"><small>'+cVal7+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 82px; text-align: right;"><small>'+cVal8+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 93px; text-align: right;"><small>'+cVal9+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 84px; text-align: right;"><small>'+cVal10+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 77px; text-align: right;"><small>'+cVal11+'</small></td>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '</tr>'+cEOL
nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

Return



Static Function GeraHead(nBytes)

Local cHtml := ""

cHtml := '<tbody>'+cEOL
cHtml += '<table style="text-align: left; width: 1003px; height: 88px;" border="2" cellpadding="2" cellspacing="2" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000">'+cEOL
cHtml += '<tr>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="font-weight: bold;">Emiss&atilde;o</td>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 71px; font-weight: bold;">NF</td>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 97px; font-weight: bold;">Qtde Granel</td>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 108px; font-weight: bold;">Pre&ccedil;o Liq.</td>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 85px; font-weight: bold;">Tot NF(IPI)</td>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 61px; font-weight: bold;">IPI</td>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 78px; font-weight: bold;">Total NF</td>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 82px; font-weight: bold;">Pre&ccedil;o Ger.</td>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 93px; font-weight: bold;">Dif Pre&ccedil;o.</td>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 84px; font-weight: bold;">Dif a Pagar</td>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

cHtml := '<td style="width: 84px; font-weight: bold;">Vr. Total</td>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</div>'+cEOL
cHtml += '</td>'+cEOL

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)
      
cHtml := '</tr>'

nBytes += Len(cHtml)
Fwrite(nHandle,cHtml,nBytes)

Return


Static Function fnCidade(wCidade)

Local cRet:=""
wCidade:=AllTrim(wCidade)
For i:=1 to Len(wCidade)
	cRet+= IIf(SubStr(wCidade,i,1) == " ","_",SubStr(wCidade,i,1))
Next

Return cRet 