#include "rwmake.ch"

User Function PA0101()

nOpca := 0
lEnd  := .F.
@ 96, 009 TO 310, 592 DIALOG oDlg TITLE OemToAnsi('Acerto dos Saldos')
@ 18, 006 TO 066, 287
@ 29, 015 SAY OemToAnsi('Este programa tem o objetivo de Acertar os Saldos dos arquivos SB2(Sld Fisi/Finan), SB8(Saldo por') SIZE 268, 8
@ 38, 015 SAY OemToAnsi('Lote/Sub-Lote) e SBF(Saldo p/Localizacao) com base nos arquivos de Movimentacoes SD1(NF Entrada),') SIZE 268, 8
@ 48, 015 SAY OemToAnsi('SD2(NF Saida), SD3(Mov.Interno), SD5(Mov.Lote/Sub-Lote), SDB(Mov.Localizacao) e SDA(Sld a Distr).') SIZE 268, 8

//@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte(_cPerg,.T.)
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Processa({|lEnd| PA101A()}, 'Acerto dos Saldos...')
Endif

Return

Static Function PA101A()

aAreaAnt   := {}
aCriaSDB   := {}
aGravaSD5  := {}
aLocais    := {}
aSLote     := {}
aLoteSLote := {}
aSaldo     := {}
cFilSB1    := xFilial('SB1')
cCod       := ''
cLocal     := ''
cLoteCtl   := ''
cNumLote   := ''
cNumSeri   := ''
cLocaliz   := ''
cSeekSB9   := ''
cSeekSD1   := ''
cSeekSD2   := ''
cSeekSD3   := ''
cSeekSD5   := ''
cSeekSDA   := ''
cSeekSDB   := ''
cArqSDA    := ''
lRastro    := .F.
lRastroS   := .F.
lLocaliza  := .F.
nX         := 0
nY         := 0
nIndSDA    := 0
nSaldo     := 0
nDifSaldo  := 0
nSaldoSD5  := 0
nSaldoSDB  := 0
nSaldoSD5t := 0
nSaldoSDBt := 0
/*
dbSelectArea('SDA')
dbSetOrder(1)
If GetMV('MV_RASTRO')=='S'
	cArqSDA := CriaTrab('', .F.)
	IndRegua('SDA', cArqSDA, 'DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_LOTECTL+DA_NUMLOTE',,, 'Selecionando Registros...')
	nIndSDA := RetIndex('SDA')
	dbSetOrder(nIndSDA+1)
	dbGoTop()
EndIf
*/
dbSelectArea('SB9')
dbSetOrder(1)

dbSelectArea('SD5')
dbSetOrder(2)

dbSelectArea('SD3')
dbSetOrder(3)

dbSelectArea('SD2')
dbSetOrder(1)

dbSelectArea('SD1')
dbSetOrder(5)

dbSelectArea('SDB')
dbSetOrder(2)

dbSelectArea('SB1')
dbSetOrder(1)
dbGoTop()
                   
ProcRegua(RecCount(), 21, 05)

While !lEnd .And. !Eof()
	
	IncProc('Corrigindo os Saldos Negativos...')
	
	If lEnd
		Exit
	EndIf
	
	cCod      := B1_COD
	lRastro   := Rastro(B1_COD)
	lRastroS  := Rastro(B1_COD, 'S')
	If lRastro
		nSaldoSD5  := 0
		aGravaSD5 := {}
		dbSelectArea('SD5')
		If dbSeek(cSeekSD5:=xFilial('SD5')+cCod, .F.)
			While !Eof() .And. cSeekSD5 == D5_FILIAL+D5_PRODUTO
				If !Empty(D5_ESTORNO)
					dbSkip()
					Loop
				EndIf
				
				cLocal     := D5_LOCAL
				cLoteCtl   := D5_LOTECTL
				cNumLote   := D5_NUMLOTE
				If Empty(cLoteCtl+cNumLote)
					dbSkip()
					Loop
				EndIf
				
				nSaldoSD5  := 0
				While !Eof() .And. cSeekSD5+cLocal+cLoteCtl+cNumLote==D5_FILIAL+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE
					If !Empty(D5_ESTORNO)
						dbSkip()
						Loop
					EndIf
					
					If D5_ORIGLAN <= '500' .Or. D5_ORIGLAN $'DEúPRúMAN'
						nSaldoSD5 := nSaldoSD5+D5_QUANT
					Else
						nSaldoSD5 := nSaldoSD5-D5_QUANT
					EndIf
					dbSkip()
				EndDo
				
				If QtdComp(nSaldoSD5) < QtdComp(0)
					aAdd(aGravaSD5, {'SD5',;
					cCod,;
					cLocal,;
					cLoteCtl,;
					cNumLote,;
					ProxNum(),;
					'ACERTO',;
					'UNI',;
					'',;
					'499',;
					'',;
					'',;
					'',;
					Abs(QtdComp(nSaldoSD5)),;
					ConvUm(cCod,Abs(QtdComp(nSaldoSD5)),0,2),;
					dDataBase,;
					dDataBase+SB1->B1_PRVALID})
				EndIf
				
				dbSelectArea('SD5')
			EndDo
		EndIf
		
		aAreaAnt := GetArea()
		For nX := 1 to Len(aGravaSD5)
			GravaSD5(aGravaSD5[nX,01],aGravaSD5[nX,02],aGravaSD5[nX,03],aGravaSD5[nX,04],IIf(!Empty(aGravaSD5[nX,05]),aGravaSD5[nX,05],NextLote(aGravaSD5[nX,02])),;
			aGravaSD5[nX,06],aGravaSD5[nX,07],aGravaSD5[nX,08],aGravaSD5[nX,09],aGravaSD5[nX,10],aGravaSD5[nX,11],;
			aGravaSD5[nX,12],aGravaSD5[nX,13],aGravaSD5[nX,14],aGravaSD5[nX,15],aGravaSD5[nX,16],aGravaSD5[nX,17])
		Next nX
		RestArea(aAreaAnt)
	EndIf
	dbSelectArea('SB1')
	dbSkip()
EndDo

dbSelectArea('SB1')
ProcRegua(RecCount(), 21, 05)

dbSetOrder(1)
dbGoTop()

While !lEnd .And. !Eof() .And. cFilSB1==SB1->B1_FILIAL
	
	IncProc('Corrigindo os Saldos Divergentes...')
	
	If lEnd
		Exit
	EndIf
	cCod      := B1_COD
	lRastro   := Rastro(B1_COD)
	lRastroS  := Rastro(B1_COD, 'S')
	
	If lRastro
		aLocais := {}
		If SB1->B1_APROPRI=='I'
			aAdd(aLocais, GetMV('MV_LOCPROC'))
		EndIf
		dbSelectArea('SB9')
		If dbSeek(cSeekSB9:=xFilial('SB9')+cCod, .F.)
			Do While !Eof() .And. cSeekSB9==B9_FILIAL+B9_COD
				If aScan(aLocais, B9_LOCAL)==0
					aAdd(aLocais, B9_LOCAL)
				EndIf
				dbSkip()
			EndDo
		EndIf
		dbSelectArea('SD1')
		If dbSeek(cSeekSD1:=xFilial('SD1')+cCod, .F.)
			Do While !Eof() .And. cSeekSD1==D1_FILIAL+D1_COD
				If aScan(aLocais, D1_LOCAL)==0
					aAdd(aLocais, D1_LOCAL)
				EndIf
				dbSkip()
			EndDo
		EndIf
		dbSelectArea('SD2')
		If dbSeek(cSeekSD2:=xFilial('SD2')+cCod, .F.)
			Do While !Eof() .And. cSeekSD2==D2_FILIAL+D2_COD
				If aScan(aLocais, D2_LOCAL)==0
					aAdd(aLocais, D2_LOCAL)
				EndIf
				dbSkip()
			EndDo
		EndIf
		dbSelectArea('SD3')
		If dbSeek(cSeekSD3:=xFilial('SD3')+cCod, .F.)
			Do While !Eof() .And. cSeekSD3==D3_FILIAL+D3_COD
				If !Empty(D3_ESTORNO)
					dbSkip()
					Loop
				EndIf
				If aScan(aLocais, D3_LOCAL)==0
					aAdd(aLocais, D3_LOCAL)
				EndIf
				dbSkip()
			EndDo
		EndIf
		
		If lRastro
			dbSelectArea('SD5')
			If dbSeek(cSeekSD5:=xFilial('SD5')+cCod, .F.)
				Do While !Eof() .And. cSeekSD5 == D5_FILIAL+D5_PRODUTO
					If !Empty(D5_ESTORNO)
						dbSkip()
						Loop
					EndIf
					If aScan(aLocais, D5_LOCAL) == 0
						aAdd(aLocais, D5_LOCAL)
					EndIf
					dbSkip()
				EndDo
			EndIf
		EndIf
		aSort(aLocais,,, {|x, y| x < y})
		
		For nX := 1 to Len(aLocais)
			cLocal     := aLocais[nX]
			aSaldo     := CalcEst(cCod, cLocal, CtoD('31/12/49'))
			nSaldo     := aSaldo[1]
			nSaldoSDBt := 0
			nSaldoSD5t := 0
			
			dbSelectArea('SD5')
			If dbSeek(cSeekSD5:=xFilial('SD5')+cCod+cLocal, .F.)
				Do While !Eof() .And. cSeekSD5 == D5_FILIAL+D5_PRODUTO+D5_LOCAL
					If !Empty(D5_ESTORNO)
						dbSkip()
						Loop
					EndIf
					If D5_ORIGLAN <= '500' .Or. D5_ORIGLAN $'DEúPRúMAN'
						nSaldoSD5t := nSaldoSD5t+D5_QUANT
					Else
						nSaldoSD5t := nSaldoSD5t-D5_QUANT
					EndIf
					dbSkip()
				EndDo
			EndIf
			
			nDifSaldo := nSaldoSD5t-nSaldo
			If !QtdComp(nDifSaldo)==QtdComp(0)
				RecLock('SD3',.T.)
				Replace D3_FILIAL  With xFilial('SD3')
				Replace D3_COD     With cCod
				Replace D3_QUANT   With Abs(QtdComp(nDifSaldo))
				Replace D3_CF      With If(QtdComp(nDifSaldo)<QtdComp(0),'RE0','DE0')
				Replace D3_CHAVE   With If(QtdComp(nDifSaldo)<QtdComp(0),'E0','E9')
				Replace D3_LOCAL   With cLocal
				Replace D3_DOC     With 'ACERTO'
				Replace D3_EMISSAO With dDataBase
				Replace D3_UM      With SB1->B1_UM
				Replace D3_GRUPO   With SB1->B1_GRUPO
				Replace D3_NUMSEQ  With ProxNum()
				Replace D3_QTSEGUM With ConvUm(cCod,Abs(QtdComp(nDifSaldo)),0,2)
				Replace D3_SEGUM   With SB1->B1_SEGUM
				Replace D3_TM      With If(QtdComp(nDifSaldo)<QtdComp(0),'999','499')
				Replace D3_TIPO    With SB1->B1_TIPO
				Replace D3_CONTA   With SB1->B1_CONTA
				Replace D3_USUARIO With SubStr(cUsuario,7,15)
				Replace D3_NUMLOTE With ''
				Replace D3_LOTECTL With ''
				Replace D3_LOCALIZ With ''
				Replace D3_IDENT   With ''
				Replace D3_DTVALID With CtoD('  /  /  ')
				MsUnLock()
			EndIf
		Next nX
	EndIf
	dbSelectArea('SB1')
	dbSkip()
EndDo

If lEnd
	Aviso('ACESALDO','A Rotina de Acerto das Diferencas nos Saldos foi Interrompida!',{'Ok'})
Else
	Aviso('ACESALDO','Rotina de Acerto das Diferencas nos Saldos Concluida',{'Ok'})
EndIf

fErase(cArqSDA+OrdBagExt())

Return Nil