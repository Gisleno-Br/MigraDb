#include <hmg.ch>
#include "hbthread.ch"

#define QUEBRA Chr(13)+Chr(10)


#include <set.ch>
#include <fileio.ch>
#include "directry.ch"



STATIC nPercent := 0
STATIC nTotal   := 0

Static aThread := Nil

Static oServerDb := Nil

STATIC lTermino := .f.






DECLARE Window fprogress

FUNCTION Main

   PRIVATE cServer := 'LocalHost'
   PRIVATE cUserDb := 'root'

   Private cDataBase := 'SisDb'




   Private aThread  := 0
   Private aThread1 := 0

   Private lEfeito := .f.

   Private hBitMap := Nil

   Private nContador := 0


   SET LANGUAGE TO PORTUGUESE
   SET CODEPAGE TO PORTUGUESE


   Set( _SET_DATEFORMAT, "dd/mm/yyyy" )

   HB_SetCodePage( "PT850" )
   hb_langSelect( "PT" )



   PRIVATE cPassDb := '123321'
   PRIVATE cBanco := 'sisDb'

   PRIVATE cArqT1  := ''

   PRIVATE cArqCsv := ''




   Load Window Main

   Main.Center

   Main .BtnRun. Enabled := .F.

   Main.Activate

RETURN


Function xLimpa()

   aThread := NIL

   Main .LblArq1. Value := ""

   Main .LblArqCsv. Value := ""

   Main .LblQtCampos. Value := ""

   Main .LstMap1. DeleteAllItems()

   Main .LblAndamento. Value := "   "

   Main .LblQtLinhas. Value := "       "

   // Main.BtnRun.Visible := .f.

   SetProperty( "Main",  "BtnRun", "Enabled", .f. )

   DoMethod( "fProgress", "Hide" )

Return


Function xDoPaint(  cJan, lEffect )

   LOCAL hDc

   LOCAL nRow := 0
   LOCAL nCol := 0


   LOCAL Width  := BT_ClientAreaWidth  ( cJan )
   LOCAL Height := BT_ClientAreaHeight ( cJan )

   LOCAL nW

   LOCAL BTstruct

   hDC    = BT_CreateDC ( cJan, BT_HDC_INVALIDCLIENTAREA, @BTstruct )


   If lEffect


      BT_DrawGradientFillVertical ( hDC,  0, 0,  Width,  Height, BLACK, BLACK )              //

      BT_DrawBitmapAlphaBlend ( hDC, 0,  0, nil, nil, 120, BT_COPY, hBitmap )
      BT_DeleteDC ( BTstruct )

   Else



   End If

Return


Function D1Black( cJan, nP1, nTot )

   LOCAL hDc

   LOCAL nRow := 0
   LOCAL nCol := 0

   Local hBit10


   LOCAL Width  := BT_ClientAreaWidth  ( cJan )
   LOCAL Height := BT_ClientAreaHeight ( cJan )

   LOCAL nW

   LOCAL BTstruct

   // Local nTot

   DEFAULT nP1  := 0
   DEFAULT nTot := 0


   hDC    = BT_CreateDC ( cJan, BT_HDC_INVALIDCLIENTAREA, @BTstruct )

   hBit10 := BT_BitmapLoadFile ( 'Animacao\a' + Alltrim( Str(  nP1 ) ) + '.png' )


   If ( nP1 > 0 )

      //nW := Int( ( np1 / nTot ) * Width )



      BT_DrawBitmap ( hDC,   0,  0, 200, 200, BT_STRETCH, hBit10 )


      // BT_DrawGradientFillVertical ( hDC,  nRow,  nCol,  nW,  Height, WHITE, BLACK )

   Else
       BT_DrawGradientFillVertical ( hDC,  nRow,  nCol,  Width,  Height, { 192, 192, 192 }, { 192, 192, 192 } )
   End If


   BT_DeleteDC ( BTstruct )

RETURN




FUNCTION xInit()

   oServerDb := GetConexao()

   HMG_ChangeWindowStyle(  fProgress.Handle, NIL, WS_BORDER, .F., .T. )
   HMG_ChangeWindowStyle(  fProgress.Handle, WS_EX_STATICEDGE, NIL, .T., .T. )


   fProgress.Height := 240

   fProgress.width := 240

   // fProgress.Show()



   SetProperty( "fProgress",  "Visible", .f. )

   DoMethod( "fProgress", "Hide" )


   // BT_ClientAreaInvalidateAll( 'fProgress' )

RETURN


FUNCTION Impx()

   LOCAL oServer := GetConexao()

   MsgInfo( 'Conectado' )

   aTexto1 := MemoRead( "Clientes.Csv" )

   aMatriz := TextToArray( aTexto1 )


   For n1 := 1 TO Len( aMatriz ) - 1

      cLine := aMatriz[ n1 ]


      aZ1 := hb_ATokens(  cLine, ";" )


   Next



   msginfo( 'ok' )


   msgBox( "Processo completo!" )

RETURN



FUNCTION xGetRt1()

   // Local cArq :=

   LOCAL cARq1 := GetFile ( { { "Mapeamentos ", "*.TY1" } }, NIL, GetCurrentFolder() )

   LOCAL aMatriz := {}

   LOCAL n1


   If !Empty( AllTrim( cArq1 ) )
      cArqT1 := cArq1

      Main .LblArq1. Value := cArqT1

      Main .LstMap1. DeleteAllItems()




      aMatriz := TextToArray( MemoRead(    cArqt1 ) )




      // Main.LstMap1.Item := aMatriz

      For n1 := 1 TO Len( aMatriz )
         If !Empty( AllTrim(  aMatriz[ n1 ] ) )
            Main .LstMap1. AddItem(  aMatriz[ n1 ]  )
         End If
      Next


      Main .LblQtCampos. Value := AllTrim( Str( Len(  aMatriz   ) ) ) + ' Campos '

      SetProperty( "Main", "LstMap1", "Enabled", .F. )

      DO Events




      Main .BtnRun. Enabled := ( Len( cArqt1 ) > 0 ) .AND. (  Len( cArqCsv ) > 0  )

   End If

RETURN



FUNCTION xGetCSV()

   // Local cArq :=

   LOCAL cARq1 := GetFile ( { { "Arquivos CSV", "*.Csv" } }, NIL, GetCurrentFolder() )
   LOCAL aMatriz
   LOCAL aSub1 := {}


   If !Empty( AllTrim( cArq1 ) )
      cArqCsv := cArq1

      Main .LblArqCSV. Value := cArqCsv

      aMatriz := TextToArray( MemoRead(    cArqCsv ) )

      aSub1 := hb_ATokens( aMatriz[ 1 ], ';' )



      Main .LblQtLinhas. Value := AllTrim( Transform( Len(  aMatriz   ), "999,999,999"  ) ) + ' Linhas , ' + AllTrim( Str(   Len( aSub1 )   ) ) + ' Colunas '

      DO Events

      Main .BtnRun. Enabled := ( Len( cArqt1 ) > 0 ) .AND. (  Len( cArqCsv ) > 0  )

   End If

RETURN




Function xStartProc()

   Local aM1 := {}

   If !MsgYesNo( hb_ANSIToOEM( "Confirma Execução da Importação do CSV?" ) )
      Return
   End If



   DoMethod( "fProgress", "Show" )


   hBitMap := BT_BitmapCaptureWindow ( 'Main', 31, 5, Main.Width, Main.Height  )



   BT_BitmapSaveFile ( hBitMap, "hBit2.bmp" )

   lEfeito := .t.

   aM1 :=  SetWindowControlsVisible( 'Main', .f.   )

   BT_ClientAreaInvalidateAll( 'Main' )


   aThread  := hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @xRode(), cArqT1, cArqCSV )

   // msginfo('obj Lançado')

   nContador := 0


   While !lTermino

      If ( nContador >= 12 )
         nContador := 0
      End If

      nContador++

      Do Events
   Enddo


   hb_threadDetach( aThread )   // close thread handle
   hb_threadQuitRequest( aThread )   //


   nTotal   := 0
   nPerCent := 0


   BT_ClientAreaInvalidateAll( 'fProgress' )



   xLimpa()

   Do Events

   MsgInfo( 'Processo Concluido!' )

   lEfeito := .f.



   BT_ClientAreaInvalidateAll( 'Main' )


   SetWindowControlsVisible( 'Main', .t., aM1, .t.  )

REturn





FUNCTION xRode( cArqT12, cFileCSV  )

   // HB_SETCODPAGE("PT850")
//

   LOCAL aMap := {}
   LOCAL a1
   LOCAL cCampo
   LOCAL cTipo
   LOCAL nPos
   LOCAL c1
   LOCAL aZ1  := {}
   LOCAL cData
   LOCAL nSeq  := 0


   LOCAL zk

   LOCAL aMap1 := {}
   LOCAL aValores := {}


   // Main.CURSOR := 'Hourglass.Cur'

   fProgress.CURSOR := 'Hourglass.Cur'

   aMap := TextToArray( MemoRead(    cArqt12 ) )

   c1 := ''



   For n1 := 1 TO Len( aMap )

      If !Empty( AllTrim(    aMap[ n1 ]  ) )

         a1 := hb_ATokens( aMap[ n1 ], ',' )

         cCampo := a1[ 1 ]

         nPos   := Val( a1[ 2 ] )

         cTipo  := a1[ 3 ]

         c1 += ( AllTrim( cCampo ) + "," )

         AAdd( aMap1, { nPos, cTipo, cCampo }  )

      End If

   Next




   cVal := ''


   aCsv := TextToArray( MemoRead(    cFileCSV  ) )



   For n1 := 1 TO Len( aCsv )


      If !Empty( AllTrim(  aCsv[ n1 ] ) )

         aZ1  := hb_ATokens( aCsv[ n1 ], ';' )

         cVal := ''

         FOR zK := 1 TO Len( aMap1 )

            cTipo := aMap1[ zk ][ 2 ]

            If At( '"', az1[ aMap1[ zk ][ 1 ]   ] ) == 0

               If cTipo = 'D'
                  cData        := Left( AllTrim( az1[ aMap1[ zk ][ 1 ]   ] ), 4 ) + "-" + ;
                     SubStr(  AllTrim( az1[ aMap1[ zk ][ 1 ]   ] ), 5, 2  ) + "-" + ;
                     Right( AllTrim( az1[ aMap1[ zk ][ 1 ]   ] ), 2 )


                  cVal += '"'  +  cData +  '"'  +  ","

               End If


               If cTipo = 'N'

               End If

               If cTipo = 'C'
                  cVal += '"'  + AllTrim( az1[ aMap1[ zk ][ 1 ]   ] ) +  '"'  +  ","
               End If

            Else
               cVal += (  '"'   +  AllTrim( xRemoveAs( az1[ aMap1[ zk ][ 1 ]   ]  ) ) +   '"'  +  "," )
            End If

         Next

         AAdd( aValores, Left( cVal, Len( cVal )  )    )
         // Do Events


         nSeq++

         cSql := "Insert Into " + AllTrim(  Main .Tabela. Value ) +  "(codigo," + Left( c1, Len( c1 ) - 1 )  + ") Values (" + QuotedStr( StrZero( nSeq, 6 ) ) + "," + ;
            Left( cVal, Len( cVal ) - 1 )  + ")"

      End If




      Main .LblAndamento. Value := "Processando : " + AllTrim( Transform(   n1, "999,999,999" ) ) + "\" + AllTrim( Transform(  Len( aCsv ), "999,999,999"   ) )


      nTotal   := Len( aCsv )
      nPerCent := n1

      BT_ClientAreaInvalidateAll( 'fProgress' )

      Do Events



   Next

   lTermino := .t.






   // SetWindowCursor( GetFormHandle( 'Main' ), IDC_ARROW )
   // SetWindowCursor( GetFormHandle( 'fProgress' ), IDC_ARROW )

RETURN


FUNCTION xRemoveAs(   cCar   )

   LOCAL cStr1 :=  AllTrim( Right( cCar, Len( cCar ) - 1 ) )
   LOCAL cStr2 := Left( cStr1, Len( cStr1 ) - 1 )

RETURN cStr2



FUNCTION GetConexao()

   LOCAL oServer
   LOCAL lRet
   LOCAL oQuery

   oServer := TMySQLServer():New( cServer, cUserDb, cPassDb )

   If oServer:NetErr()
      MsGInfo( "Error ao Conectar SQL Server: " + QUEBRA + oServer:Error() )
      RELEASE Window ALL
      QUIT
   End If

   oServer:SelectDB( cDataBase )

   If oServer:NetErr()
      MsGInfo( "Error ao Conectar Banco " + cBanco + " : " + QUEBRA + oServer:Error() )
      RELEASE Window ALL
      QUIT
   End If

   Main .StatusBar. Item( 1 ) := 'Conectado em ' + cServer

   Main .StatusBar. Item( 2 ) := 'Banco de Dados : ' + cDataBase

RETURN ( oServer )


STATIC FUNCTION TextToArray( cString )
RETURN hb_ATokens( StrTran( cString, Chr( 13 ) ), Chr( 10 ) )





FUNCTION fTiraChar( wCampo )

   // // Remover Caracteres Especiais (/,*)

   LOCAL lRet  := .T.
   LOCAL cStr1 := ''
   LOCAL i     := 1 // '

   For i := 1 TO Len( wCampo )
      If  SubStr( wCampo, i, 1 ) == "'" .OR. SubStr( wCampo, i, 1 ) == '"'  .OR. SubStr( wCampo, i, 1 ) == ")" .OR. SubStr( wCampo, i, 1 ) == "(" .OR. SubStr( wCampo, i, 1 ) == "*" .OR. SubStr( wCampo, i, 1 ) == "/"  .OR. SubStr( wCampo, i, 1 ) == "\"  .OR. SubStr( wCampo, i, 1 ) == '%' .OR. SubStr( wCampo, i, 1 ) == "-"

      Else
         cStr1 += SubStr( wCampo, i, 1 )
      End If
   Next i

Return cStr1



FUNCTION QuotedStr( cVar )
Return '"' + cVar + '"'

function SetWindowControlsVisible( cForm, lVisible, aMVisible, lShow  )

   Local aControlList := {}
   Local i        := 0
   Local cCompo   := ''
   Local aM1      := {}
   Local lVisi2 := .f.
   Local nIndice := 0

   Default aMVisible := {}
   Default lShow     := .f.


// sysWait(.1)


   For i := 1 to Len( _HMG_SYSDATA[ 4 ] )
      If _HMG_SYSDATA[ 4, i ] == GetFormHandle( cForm )
         If len( alltrim( _HMG_SYSDATA[  2,i ] ) ) > 0

            lVisi2 := GetProperty( cForm, _HMG_SYSDATA[  2, i ], "Visible"  )

            If lVisible

               nIndice := Ascan( aMVisible, {| a, b | ( a[ 1 ] == cForm ) .And. ( a[ 2 ] == _HMG_SYSDATA[  2,i ] )  }  )

               If ( Len( aMVisible ) > 0 ) .And. ( nIndice > 0 )
                  Setproperty( cForm, _HMG_SYSDATA[  2, i ], "Visible", aMVisible[ nIndice ][ 3 ] )

                  If ( lShow ) .And. ( aMVisible[ nIndice ][ 3 ] )
                     DoMethod( cForm,   _HMG_SYSDATA[  2, i ], "Show" )
                  End If

               End If

            Else
               Aadd( aM1, {   cForm, _HMG_SYSDATA[  2, i ],  lVisi2 } )
               Setproperty( cForm, _HMG_SYSDATA[  2, i ], "Visible", lVisible )
            End If

            cCompo += ( cForm + ' ' +  _HMG_SYSDATA[  2, i ] )  + QUEBRA

         End If
      End If
   Next i

   hb_memowrit( 'compo1.txt', cCompo )

Return aM1
