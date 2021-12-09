#include <hmg.ch>


#include <set.ch>
#include <fileio.ch>
#include "directry.ch"



Declare Window fprogress

Function Main


        Private cServer := 'LocalHost'
        Private cUserDb := 'root'


        Private nPercent := 0
        Private nTotal   := 0

              

        

	      SET LANGUAGE TO PORTUGUESE
	      SET CODEPAGE TO PORTUGUESE   

   			
       	SET(_SET_DATEFORMAT , "dd/mm/yyyy" )
        
      	HB_SetCodePage( "PT850" )
      	hb_langSelect( "PT" )


        
        Private cPassDb := '123321'
        Private cBanco := 'sisDb'

        Private cArqT1  := ''

        Private cArqCsv := ''




        Load Window Main
        Main.Center


         //fProgress




        Main.BtnRun.Enabled := .f.




        Main.Activate
     
        




        

Return


Function D1Black(cJan, nP1 , nTot )

	Local hDc

	Local nRow := 0
	Local nCol := 0


	LOCAL Width  := BT_ClientAreaWidth  (cJan)
	LOCAL Height := BT_ClientAreaHeight (cJan)

   Local nW 

	LOCAL BTstruct

   DEFAULT nP1  := 0   
   DEFAULT nTot := 0



   If nP1 > 0 

      nW := Int( ( np1 / nTot) * Width )

      hDC    = BT_CreateDC ( cJan  , BT_HDC_INVALIDCLIENTAREA, @BTstruct)
      BT_DrawGradientFillVertical (hDC,  nRow  ,  nCol  ,  nW  ,  Height , WHITE , BLACK)

   //	BT_DrawBitmapAlphaBlend (hDC, nRow ,  nCol  , nil, nil, 120 , BT_COPY  , zBitmap)

      BT_DeleteDC ( BTstruct )

   End If 




Return




Function xInit()



     HMG_ChangeWindowStyle(  fProgress.Handle , NIL, WS_BORDER, .F., .T.)
     HMG_ChangeWindowStyle(  fProgress.Handle , WS_EX_STATICEDGE, NIL, .T., .T.)



          fProgress.Show()


Return 


Function Impx()

   Local oServer := GetConexao()
 
    msginfo('Conectado')



   aTexto1 := MemoRead( "Clientes.Csv" )

   aMatriz := TextToArray( aTexto1 )


   For n1 := 1 To Len(aMatriz) - 1

       cLine := aMatriz[n1]


       aZ1 := hb_ATokens(  cLine , ";" )


   Next 



   msginfo('ok')
 

      msgBox( "Processo completo!" )
 
  


Return



Function xGetRt1()

  //Local cArq := 

  Local cARq1 := GetFile ( { {"Mapeamentos ", "*.TY1"} }, NIL, GetCurrentFolder() )

  Local aMatriz := {}

  Local n1


  If !Empty(Alltrim(cArq1))
     cArqT1 := cArq1

     Main.LblArq1.Value := cArqT1

     Main.LstMap1.DeleteAllItems()

     
     aMatriz := TextToArray( MemoRead(    cArqt1 ) )


     //Main.LstMap1.Item := aMatriz 

     For n1 := 1 To Len(aMatriz)
         If !Empty(Alltrim(  aMatriz[n1] ))
            Main.LstMap1.AddItem(  aMatriz[n1]  )
         End If 
     Next

     
      Main.LblQtCampos.Value := Alltrim(Str(Len(  aMatriz   ))) + ' Campos '

     SetProperty("Main" , "LstMap1" , "Enabled" , .f.)

     Do Events

     
      //HMG_ChangeWindowStyle( hWnd, WS_EX_CLIENTEDGE, NIL, .T. )


     Main.BtnRun.Enabled := (Len(cArqt1) > 0 ) .And. (  Len(cArqCsv) > 0  )

  End If 


REturn 



Function xGetCSV()




  //Local cArq := 

  Local cARq1 := GetFile ( { {"Arquivos CSV", "*.Csv"} }, NIL, GetCurrentFolder() )
  Local aMatriz 
  Local aSub1 := {}


  If !Empty(Alltrim(cArq1))
     cArqCsv := cArq1

     Main.LblArqCSV.Value := cArqCsv
     
     aMatriz := TextToArray( MemoRead(    cArqCsv ) )

     aSub1 := hb_ATokens( aMatriz[1] , ';' )



     Main.LblQtLinhas.Value := Alltrim( Transform(Len(  aMatriz   )   , "999,999,999"  )) + ' Linhas , ' + Alltrim(Str(   Len(aSub1)   )) + ' Colunas '

     Do Events

     Main.BtnRun.Enabled := (Len(cArqt1) > 0 ) .And. (  Len(cArqCsv) > 0  )

  End If 

REturn 


Function xRode()


  // HB_SETCODPAGE("PT850")
//

   Local aMap := {}
   Local a1 
   Local cCampo 
   Local cTipo 
   Local nPos
   Local c1 
   Local aZ1  := {}

   Local zk 

   Local aMap1 := {}
   Local aValores := {}

   If !MsgYesNo( Hb_AnsiToOem("Confirma Execução da Importação do CSV?") )
      Return
   End If 

   Main.Cursor := 'Hourglass.Cur'

   fProgress.Cursor := 'Hourglass.Cur'

   

   aMap := TextToArray( MemoRead(    cArqt1 ) )

   c1 := ''

   For n1 := 1 To Len(aMap)

      If !Empty(Alltrim(    aMap[n1]  ))

         a1 := hb_ATokens( aMap[n1] , ',' )

         cCampo := a1[1]

         nPos   := Val(a1[2])

         cTipo  := a1[3]

         c1 += ( Alltrim(cCampo)+",")

         Aadd(aMap1 , nPos)

      End If 

   Next

   cVal := ''


   aCsv := TextToArray( MemoRead(    cArqCsv  ) )



   For n1 := 1 To Len(aCsv)


      If !Empty(Alltrim(  aCsv[n1] ))

         aZ1  := hb_ATokens( aCsv[n1] , ';' )

         cVal := ''

         For zK := 1 To Len(aMap1)

            cVal += Alltrim(az1[ aMap1[ zk ] ]  ) + ","

         Next


         Aadd(aValores , cVal )

         Do Events

       End If 

       
      Main.LblAndamento.Value := "Processando : " + Alltrim( TRANSFORM(   n1  , "999,999,999" )) + "\" + Alltrim( Transform(  Len(aCsv)  , "999,999,999"   ))

      nTotal   := Len(aCsv) 
      nPerCent := n1

      BT_ClientAreaInvalidateAll('fProgress')

       
   Next 

   msginfo( 'Processo Concluido!' )

   
   
		
	SetWindowCursor( GetFormHandle( 'Main' ) , IDC_ARROW )
   SetWindowCursor( GetFormHandle( 'fProgress' ) , IDC_ARROW )


Return 


FUNCTION GetConexao()

   LOCAL oServer
   LOCAL lRet
   LOCAL oQuery

   oServer := TMySQLServer():New( cServer, cUserDb, cPassDb )

   IF oServer:NetErr()
      MsGInfo( "Error ao Conectar SQL Server: " + QUEBRA + oServer:Error() )
      RELEASE Window ALL
      QUIT
   ENDIF

   oServer:SelectDB( cBanco )

   IF oServer:NetErr()
      MsGInfo( "Error ao Conectar Banco " + cBanco + " : " + QUEBRA + oServer:Error() )
      RELEASE Window ALL
      QUIT
   ENDIF

RETURN ( oServer )


STATIC FUNCTION TextToArray( cString )
RETURN hb_ATokens( StrTran( cString, Chr( 13 ) ), Chr( 10 ) )



FUNCTION fTiraChar( wCampo )

   // // Remover Caracteres Especiais (/,*)

   LOCAL lRet  := .T.
   LOCAL cStr1 := ''
   LOCAL i     := 1 //'

   FOR i := 1 TO Len( wCampo )
      IF SubStr( wCampo, i, 1 ) == "'" .OR. SubStr( wCampo, i, 1 ) == ")" .OR. SubStr( wCampo, i, 1 ) == "(" .OR. SubStr( wCampo, i, 1 ) == "*" .OR. SubStr( wCampo, i, 1 ) == "/"  .OR. SubStr( wCampo, i, 1 ) == "\"  .OR. SubStr( wCampo, i, 1 ) == '%' .OR. SubStr( wCampo, i, 1 ) == "-"

      ELSE
         cStr1 += SubStr( wCampo, i, 1 )
      ENDIF
   NEXT i

   RETURN cStr1

