#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VN0018   ºAutor  ³ Alexandro da Silva º Data ³  06/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza Limite de Credito                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafin                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VN0018()
	
	CONOUT("ATUALIZANDO LIMITE DE CREDITO --> VN0018")
	
	If Select("SX2") == 0
		RpcSetType(3)
		RpcSetEnv("01","00101",,,"COM",GetEnvServer(),{"ZA6"})
	EndIf
	
	_aEmpresa := {"01"}
	
	For AX:= 1 To Len(_aEmpresa)
		
		CONOUT("ATUALIZANDO LIMITE DE CREDITO DA EMPRESA "+_aEmpresa[AX])
		U_VN1801(_aEmpresa[AX])
		CONOUT("ATUALIZADO LIMITE DE CREDITO DA EMPRESA "+_aEmpresa[AX])
		
//		CONOUT("ATUALIZANDO BAIXA TITULOS PROVISORIOS DA EMPRESA "+_aEmpresa[AX])
//		U_MZ0037(_aEmpresa[AX])
//		CONOUT("ATUALIZADO  BAIXA TITULOS PROVISORIOS DA EMPRESA "+_aEmpresa[AX])
		
	Next AX
	
Return

User Function VN1801(_cEmpresa)
	
	If Select("SX2") == 0
		RpcSetType(3)
		RpcSetEnv(_cEmpresa,"00101",,,"FIN",GetEnvServer(),{"ZA6"})
	EndIf
	
	OpenSM0()
	
	IF SM0->(DBSEEK(left(_cEmpresa+"00101", 4) , .F. ) )
		RpcSetType(3)
		RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL,'schedule','schedule','FIN',,{})
	ELSE
		CONOUT("NAO ACHOU EMPRESA ...")
		SM0->(DBGOTOP())
		DBCLOSEALL()
		RpcClearEnv()
	ENDIF
	
	CONOUT("SETADA EMPRESA: "+_cEmpresa)
	
	_cQ := " UPDATE ZA6"+_cEmpresa+"0 SET ZA6_SDOTIT = 0, ZA6_SDOLIM = ZA6_VALOR WHERE ZA6_LIBER = 'L' "
	
	TCSQLEXEC(_cQ)
	
	CONOUT("CONSULTA SQL ->: "+_cQ)
	
	_aAliOri := GetArea()
	
	_cQ := " SELECT E1_CLIENTE,E1_LOJA, SUM(E1_SALDO) AS E1_SALDO FROM SE1"+_cEmpresa+"0 A WHERE A.D_E_L_E_T_ = '' AND E1_SALDO > 0 AND E1_TIPO = 'NF' "
	_cQ += " GROUP BY E1_CLIENTE,E1_LOJA "
	_cQ += " ORDER BY E1_CLIENTE,E1_LOJA "
	
	CONOUT("CONSULTA SQL ->: "+_cQ)
	
	TCQUERY _cQ NEW ALIAS "ZZ"
	
	ZZ->(dbGotop())
	
	While ZZ->(!Eof())
		
		ZA6->(dbSetOrder(1))
		If ZA6->(dbSeek(xFilial("ZA6")+ZZ->E1_CLIENTE + ZZ->E1_LOJA + "L" ))
			//		CONOUT("EMPRESA: "+_cEmpresa+" CLIENTE "+ZZ->E1_CLIENTE + ZZ->E1_LOJA)
			ZA6->(RecLock("ZA6",.F.))
			ZA6->ZA6_SDOTIT := ZZ->E1_SALDO
			ZA6->ZA6_SDOLIM := ZA6->ZA6_VALOR - ZZ->E1_SALDO
			ZA6->(MsUnlock())
		Else
			ZA6->(dbSetOrder(1))
			If ZA6->(dbSeek(xFilial("ZA6")+ZZ->E1_CLIENTE + ZZ->E1_LOJA + Space(01) ))
				ZA6->(RecLock("ZA6",.F.))
				ZA6->ZA6_SDOTIT := ZZ->E1_SALDO
				ZA6->ZA6_SDOLIM := ZA6->ZA6_VALOR - ZZ->E1_SALDO
				ZA6->(MsUnlock())
			Endif
		Endif
		
		ZZ->(dbSkip())
		
	EndDo
	
	ZZ->(dbCloseArea())
	
	RestArea(_aAliOri)
	
	If Select("SX2") > 0
		Conout("Fechando Ambiente")
		RpcClearEnv()
	Endif
	
Return
