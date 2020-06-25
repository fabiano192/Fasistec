#include "Protheus.ch"
#include "TopConn.ch"
#include "RwMake.ch"

User Function RetCodLoja(clPessoa,clMemoCgc,clOrigem,llWeb)

Local alRet	   	  := {}
Local clPrefixo	  := SubStr(clOrigem,2,2)
Local clQry	   	  := ""
Local clCod	   	  := clPrefixo+"_COD"
Local clLoja	  := clPrefixo+"_LOJA"
Local clCgc       := clPrefixo+"_CGC"
Local clFilial	  := clPrefixo+"_FILIAL"
Local clLetra	  := Iif(clOrigem == "SA1","C","F")
Local llContinua  := .F.

Default llWeb	  := .F.

If Empty(clPessoa)
	clPessoa := "J"
EndIf

_lEntrou := .F.

If !llWeb
	//Apenas se for inclusao
	If INCLUI
		llContinua := .T.
	EndIf
Else
	llContinua := .T.
EndIf

If llContinua
	If !Empty(clMemoCgc)
		If clOrigem == "SA1"
			SA1->(dbSetOrder(3))
			If SA1->(dbSeek(xFilial("SA1") + clMemoCgc))
				If "ISEN" $ ALLTRIM(M->A1_INSCR)  .Or. Empty(M->A1_INSCR)
					MSGINFO("FAVOR INFORMAR INSCRICAO ESTADUAL VALIDA!!")
					Return(.F.)
				Else
					_cInscr := M->A1_INSCR
					clQry := "SELECT A1_INSCR FROM "+RetSqlName("SA1")+" A "
					clQry += " WHERE A1_INSCR = '"+_cInscr+"'"
					clQry += " AND "+clFilial+" = '"+xFilial(clOrigem)+"'"
					clQry += " AND D_E_L_E_T_ = ''"
					
					If Select("ZZ") > 0
						ZZ->(DbCloseArea())
					EndIf
					
					TcQuery clQry New Alias "ZZ"
					
					If !Empty(ZZ->A1_INSCR)
						MSGINFO("ATENCAO - Inscrição Estadual Já Cadastrada!!")
						ZZ->(dbCloseArea())
						Return(.F.)
					Endif
				Endif
				
				If CGC(clMemoCgc)
					clQry := "SELECT "+clCod
					clQry += " , MAX("+clLoja+") AS "+clLoja
					clQry += " FROM "+RetSqlName(clOrigem)+" "+ clOrigem
					clQry += " WHERE "+clCgc+" = '"+clMemoCgc+"'"
					clQry += " AND "+clFilial+" = '"+xFilial(clOrigem)+"'"
					clQry += " AND D_E_L_E_T_ = ''"
					clQry += " GROUP BY "+clCod
					
					If Select("ULTLOJA") > 0
						ULTLOJA->(DbCloseArea())
					EndIf
					
					TcQuery clQry New Alias "ULTLOJA"
					
					If ULTLOJA->(!Eof())
						If !llWeb
							&("M->"+clCod) 	:= &("ULTLOJA->"+clCod)
							&("M->"+clLoja)	:= Soma1(&("ULTLOJA->"+clLoja))
						Else
							aAdd(alRet,&("ULTLOJA->"+clCod))
							aAdd(alRet,Soma1(&("ULTLOJA->"+clLoja)))
						EndIf
					Endif
				Endif
			Else
				If cgc(clMemoCgc).and. existchav(clOrigem,clMemoCgc,3,clCgc)
					If clPessoa <> "F"
						&(clOrigem)->(DbSetOrder(3))
						If &(clOrigem)->(DbSeek(XFilial(clOrigem)+SubStr(clMemoCgc,1,8)))
							
							_lEntrou := .T.
							
							clQry := "SELECT "+clCod
							clQry += " , MAX("+clLoja+") AS "+clLoja
							clQry += " FROM "+RetSqlName(clOrigem)+" "+ clOrigem
							clQry += " WHERE Substring("+clCgc+",1,8) = '"+SubStr(clMemoCgc,1,8)+"'"
							clQry += " AND "+clFilial+" = '"+xFilial(clOrigem)+"'"
							clQry += " AND D_E_L_E_T_ = ''"
							clQry += " GROUP BY "+clCod
							
							If Select("ULTLOJA") > 0
								ULTLOJA->(DbCloseArea())
							EndIf
							
							TcQuery clQry New Alias "ULTLOJA"
							
							If ULTLOJA->(!Eof())
								If !llWeb
									&("M->"+clCod) 	:= &("ULTLOJA->"+clCod)
									&("M->"+clLoja)	:= Soma1(&("ULTLOJA->"+clLoja))
								Else
									aAdd(alRet,&("ULTLOJA->"+clCod))
									aAdd(alRet,Soma1(&("ULTLOJA->"+clLoja)))
								EndIf
							Endif
						Endif
					Endif
					
					If !_lEntrou
						If clOrigem == "SA1"
							_cq := " SELECT MAX(A1_COD) AS COD FROM "+RetSqlName(clOrigem)+" A "
							_cq += " WHERE A.D_E_L_E_T_ = '' and SUBSTRING(A1_COD,1,1) = 'C'	"
						Else
							_cq := " SELECT MAX(A2_COD) AS COD FROM "+RetSqlName(clOrigem)+" A "
							_cq += " WHERE A.D_E_L_E_T_ = '' and SUBSTRING(A2_COD,1,1) = 'F'	"
						Endif
						
						If Select("ZZ") > 0
							ZZ->(DbCloseArea())
						EndIf
						
						TcQuery _cQ New Alias "ZZ"
						
						_cCod := Substr(ZZ->COD,2,5)
						If !llWeb
							&("M->"+clCod)	  := clLetra + Soma1(_cCod)
							&("M->"+clLoja)  := StrZero(1,TamSx3(clLoja)[1])
						Else
							aAdd(alRet,clLetra + Soma1(_cCod))
							aAdd(alRet,StrZero(1,TamSx3(clLoja)[1]))
						EndIf
						ZZ->(dbCloseArea())
					Endif
				EndIf
			EndIf
		Else
			If cgc(clMemoCgc).and. existchav(clOrigem,clMemoCgc,3,clCgc)
				If clPessoa <> "F"
					&(clOrigem)->(DbSetOrder(3))
					If &(clOrigem)->(DbSeek(XFilial(clOrigem)+SubStr(clMemoCgc,1,8)))
						
						_lEntrou := .T.
						
						clQry := "SELECT "+clCod
						clQry += " , MAX("+clLoja+") AS "+clLoja
						clQry += " FROM "+RetSqlName(clOrigem)+" "+ clOrigem
						clQry += " WHERE Substring("+clCgc+",1,8) = '"+SubStr(clMemoCgc,1,8)+"'"
						clQry += " AND "+clFilial+" = '"+xFilial(clOrigem)+"'"
						clQry += " AND D_E_L_E_T_ = ''"
						clQry += " GROUP BY "+clCod
						
						If Select("ULTLOJA") > 0
							ULTLOJA->(DbCloseArea())
						EndIf
						
						TcQuery clQry New Alias "ULTLOJA"
						
						If ULTLOJA->(!Eof())
							If !llWeb
								&("M->"+clCod) 	:= &("ULTLOJA->"+clCod)
								&("M->"+clLoja)	:= Soma1(&("ULTLOJA->"+clLoja))
							Else
								aAdd(alRet,&("ULTLOJA->"+clCod))
								aAdd(alRet,Soma1(&("ULTLOJA->"+clLoja)))
							EndIf							
						Endif
					Endif
				Endif
				
				If !_lEntrou
					If clOrigem == "SA1"
						_cq := " SELECT MAX(A1_COD) AS COD FROM "+RetSqlName(clOrigem)+" A "
						_cq += " WHERE A.D_E_L_E_T_ = '' and SUBSTRING(A1_COD,1,1) = 'C'	"
					Else
						_cq := " SELECT MAX(A2_COD) AS COD FROM "+RetSqlName(clOrigem)+" A "
						_cq += " WHERE A.D_E_L_E_T_ = '' and SUBSTRING(A2_COD,1,1) = 'F'	"
					Endif
					
					If Select("ZZ") > 0
						ZZ->(DbCloseArea())
					EndIf
					
					TcQuery _cQ New Alias "ZZ"
					
					_cCod := Substr(ZZ->COD,2,5)
					If !llWeb
						&("M->"+clCod)	  := clLetra + Soma1(_cCod)
						&("M->"+clLoja)  := StrZero(1,TamSx3(clLoja)[1])
					Else
						aAdd(alRet,clLetra + Soma1(_cCod))
						aAdd(alRet,StrZero(1,TamSx3(clLoja)[1]))
					EndIf
					ZZ->(dbCloseArea())
					
				EndIf
			EndIf
		Endif
	Else
		Return(.T.)
	Endif
Endif

If llWeb
	_cRetorno := alRet
Else
	_cRetorno := .T.
Endif

Return(_cRetorno)