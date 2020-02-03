/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ChkAcesso ºAutor  ³Marcio Aflitos      º Data ³  08/26/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcão que acessa um cadastro de rotinas e caso encontre    º±±
±±º          ³verifica se o usuário tem acesso a ela.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
PARAMETROS:
>cRotName : É o nome da rotina/funcao/campo que se quer verificar se tem controle de acesso

>_nOper   : É a operação que se quer verificar  sendo :
1-Pesquisar
2-Visualizar
3-Incluir
4-Alterar
5-Excluir
6-Especial

>lExibeMsg : Se deve ou não exibir mensagem caso haja bloqueio (padrao =.t.)

*/
#include "TOTVS.CH"
#include "RWMAKE.CH"


USER FUNCTION ChkAcesso(cRotName, _nOper, lExibeMsg)

LOCAL cArea    := ""
LOCAL cIdUsu   := ""
LOCAL aGrpUsu  := ""
LOCAL aOption  := {{"ZZZ_PESQ","PESQUISA","Botão1"},{"ZZZ_VISUAL","VISUALIZAÇÃO","Botão2"},{"ZZZ_INCLUI","INCLUSÃO","Botão3"},{"ZZZ_ALTERA","ALTERAÇÃO","Botão4"},{"ZZZ_EXCLUI","EXCLUSÃO","Botão5"},{"ZZZ_ESPEC1","OPERAÇÃO","Operação"}}
LOCAL cStat    := ""
LOCAL cZZCodUsu:= ""
LOCAL cZZTipo  := ""
LOCAL cMsg1    := ""
Local lRet	   := .T.

_aAliOri:= GetArea()
_aAliZZZ:= ZZZ->(GetArea())

DbSelectArea("ZZZ")
ZZZ->(dbSetOrder(1))// OrdSetFocus(1))  //ZZZ_FILIAL+ZZZ_ROTINA+ZZZ_TIPO+ZZZ_NOME

cRotName:=IIf( Valtype(cRotName)<>"C",Upper(Alltrim(FunName())),Upper(cRotName))
Private _cNameUsu:= ALLTRIM(UPPER(CUSERNAME)) //Upper(Alltrim(Substr(cUsuario,7,15)))
aGrpUsu:= _GrupoUsu(_cNameUsu)
lExibeMsg:=IIf(Valtype(lExibeMsg)<>'L',.T.,lExibeMsg)
                         
If Upper(cRotName) == "A1_RISCO" 
	_lParar := .T.
Endif
If Upper(cRotName) == "A1_LC" 
	_lParar := .F.
Endif


_nOper:=_TipoOper(_nOper)

IF _cNameUsu<> "ADMINISTRADOR" .AND. (Str(_nOper,1,0)$"1;2;3;4;5;6") .AND. ZZZ->(Msseek(xFilial("ZZZ")+cRotName))
	
	DO WHILE cRotName == Upper(Alltrim(ZZZ->ZZZ_ROTINA)) .AND. .NOT. ZZZ->(Eof())
		IF ZZZ->ZZZ_ATIVO <>"N"
			cZZNome:=Alltrim(UPPER(ZZZ->ZZZ_NOME))
			IF ( (Ascan(aGrpUsu,{|zz| Alltrim(zz[2])==AllTrim(cZZNome)})<>0) .OR. (cZZNome==_cNameUsu) .OR. (ZZZ->ZZZ_TIPO=="A") ) //A=Todos
				cStat:=Eval(&("{||"+aOption[_nOper,1]+"}"))
				lRet:=(cStat $ "S;1")
				cZZTipo:=ZZZ->ZZZ_TIPO
				cMsg1:=Alltrim(ZZZ->ZZZ_NOME)
			ENDIF
		ENDIF
		ZZZ->(DbSkip())
	ENDDO
	IF .NOT. lRet .and. lExibeMsg
		MsgBox(Pad(aOption[_nOper,2]+": Acesso Bloqueado. "+IIF(cZZTipo=="A","",IIf(cZZTipo=='G','Grupo: ','Usuário: ')+cMsg1),60)+".",ProcName()+"-Controle de Acesso: "+cRotName,"INFO")
	ENDIF
ENDIF

RestArea(_aAliZZZ)
RestArea(_aAliOri)

Return lRet


STATIC Function _GrupoUsu( _cNomeUsu )

/*
LOCAL _aUser
LOCAL _aGrps:={"",""}
LOCAL _aRetGrps:={}
LOCAL cGrupo

cIdUsu:=IIf(Valtype(cIdUsu)<>"C",__CUSERID, cIdUsu)

PswOrder(1)
IF PswSeek(cIdUsu,.T.)
__Ap5NoMv(.T.)
_aUser := PswRet()
__Ap5NoMv(.F.)
_aGrps:=AClone(_aUser[1][10])
//PswOrder(1)
FOR x:=1 to Len(_aGrps)
If PswSeek( _aGrps[x], .F. )
cGrupo := PswRet()[1][2] // Retorna nome do Grupo de Usuário
//AAdd(_aRetGrps,{ _aGrps[x],cGrupo })
_aGrps[x]:={_aGrps[x],Upper(cGrupo)}
Else
_aGrps[x]:={"",""}
Endif
NEXT
ENDIF
*/
LOCAL _aUser
LOCAL _aGrps:={,}
LOCAL cGrupo,x

_cNomeUsu:=IIf(Valtype(_cNomeUsu)<>"C",cUserName, _cNomeUsu)

PswOrder(2)
IF PswSeek(_cNomeUsu,.T.)
	__Ap5NoMv(.T.)
	_aUser := PswRet()
	__Ap5NoMv(.F.)
	_aGrps:=_aUser[1][10]
	PswOrder(1)
	FOR x:=1 to Len(_aGrps)
		IF PswSeek( _aGrps[x], .F. )
			cGrupo := PswRet()[1][2] // Retorna nome do Grupo de Usuário
			_aGrps[x]:={_aGrps[x],Upper(cGrupo)}
		Else
			_aGrps[x]:={"",""}
		ENDIF
	NEXT
ENDIF

RETURN (_aGrps)


STATIC Function _TipoOper( _nOper )

LOCAL nRet

If Valtype(_nOper)<>"N"
	DO CASE
		CASE Type("PARAMIXB")=="A"
			nRet:= ParamIxb[3]
		CASE Type("INCLUI")=="L" .AND. INCLUI
			nRet:=3
		CASE Type("ALTERA")=="L" .AND. ALTERA
			nRet:=4
		OTHERWISE
			nRet:=6
	ENDCASE
ELSE
	nREt:=_nOper
ENDIF

RETURN nRet