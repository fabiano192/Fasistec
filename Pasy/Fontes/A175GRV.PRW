#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ A175CQ ³ Autor ³Fabiano	da Silva       ³ Data ³ 29/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ BAIXA Do CQ					                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga.                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/

User Function A175GRV()

SB1->(dbsetOrder(1))
If SB1->(dbSeek(xFilial("SB1")+SD7->D7_PRODUTO))
	If SB1->B1_LOCALIZ == "S"
		GERALOC()
	Endif
Endif

Return


Static Function GERALOC()

_cChav := SD7->D7_NUMERO

SD7->(dbsetOrder(1))
IF SD7->(dbSeek(xFilial("SD7")+_cChav))
	
	While SD7->(!EOF()) .And. _cChav == SD7->D7_NUMERO
				
		If SD7->D7_LOCDEST = '99'
			_cLocal := GETMV("PA_LOCEXP")
		ElseIf SD7->D7_LOCDEST = '80'
			_cLocal := GETMV("PA_LOCREJ")
		Endif
		
		_cNumSer := CriaVar("DB_NUMSERI")
		
		_cItem   := "0001"
		_nQuant  := SD7->D7_QTDE
		
		SDA->(dbSetOrder(1))
		If SDA->(dbSeek(xFilial("SDA")+SD7->D7_PRODUTO + SD7->D7_LOCDEST + SD7->D7_NUMSEQ + SD7->D7_NUMERO ))
			CriaSDB(SDA->DA_PRODUTO,SDA->DA_LOCAL,SD7->D7_QTDE,_cLocal,_cNumSer,SDA->DA_DOC,SDA->DA_SERIE,SDA->DA_CLIFOR,SDA->DA_LOJA,SDA->DA_TIPONF,SDA->DA_ORIGEM,SD7->D7_DATA,SDA->DA_LOTECTL,SDA->DA_NUMLOTE,SDA->DA_NUMSEQ,"499","D",_cItem,.F.,0,,0)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Baixa saldo classificar do arquivo de saldos em estoque (SB2)³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			SB2->(dbSetOrder(1))
			If SB2->(dbSeek(xFilial("SB2")+SD7->D7_PRODUTO + SD7->D7_LOCDEST))
				SB2->(RecLock("SB2",.F.))
				SB2->B2_QACLASS := SB2->B2_QACLASS - SDB->DB_QUANT
				SB2->(MsUnlock())
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Baixa saldo do arquivo de Saldos a classificar   (SDA)       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			SDA->(RecLock("SDA",.F.))
			SDA->DA_SALDO   := SDA->DA_SALDO   - SDB->DB_QUANT
			SDA->DA_QTSEGUM := SDA->DA_QTSEGUM - SDB->DB_QTSEGUM
			SDA->DA_EMPENHO := SDA->DA_EMPENHO - SDB->DB_EMPENHO
			SDA->DA_EMP2    := SDA->DA_EMP2    - SDB->DB_EMP2
			SDA->(MsUnlock())
			
			GRAVASBF("SDB")
		Endif
		
		SD7->(dbSkip())
	EndDo
	
Endif

Return