USER FUNCTION GRPUSU()
PRIVATE cReturn

cReturn:=M->ZZZ_CODUSU+M->ZZZ_NOME

IF M->ZZZ_TIPO="G"
	ConPad1(,,,"GRP",@CRETURN)
ELSE
	ConPad1(,,,"US2",@cReturn)
ENDIF

RETURN cReturn       


USER FUNCTION ChkUsu()
LOCAL lReturn:=.F.
LOCAL _VR:=""
LOCAL _cId
LOCAL _lUsu

_VR:=IIF( Type("M->ZZZ_CODUSU")<>"C", "ZZZ","M")
_cId:=M->ZZZ_CODUSU
_lUsu:= (M->ZZZ_TIPO=="U")

PswOrder(1)          
IF PswSeek( _cId ,_lUsu )
	lReturn:=.T.
   IIF( _VR=="M", M->ZZZ_NOME := PswRet()[1][2], NIL )
ELSE
	Alert("USUÁRIO ou GRUPO NÃO CADASTRADO")
ENDIF
RETURN lReturn

