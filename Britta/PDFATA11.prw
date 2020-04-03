#Include "PROTHEUS.CH"

USER FUNCTION PDFATA11()
LOCAL _lReturn := .F.

If dDataBase <> Date()
    MsgInfo("Favor Atualizar a Data do Sistema (Data Incorreta)!! ")
    Return
Endif

U_PDFAT10C()

RETURN()