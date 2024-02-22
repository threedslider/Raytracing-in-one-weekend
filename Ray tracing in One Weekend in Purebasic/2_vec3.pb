image_width = 512
image_height = 512


; Vector 
Structure Vec3
  x.f
  y.f
  z.f
EndStructure

; Write the translated [0,255] value of each color component.
Procedure write_color(*pixel_color.Vec3)
  WriteString(0, Str(Int(255.999 * *pixel_color\x)))
  WriteString(0, " ")
  WriteString(0, Str(Int(255.999 * *pixel_color\y)))
  WriteString(0, " ")
  WriteString(0, Str(Int(255.999 * *pixel_color\z)))
  WriteStringN(0, " ")
EndProcedure

; Output the image in PPM
If CreateFile(0, "image_test2.ppm")
  WriteStringN(0,"P3")
  WriteString(0,Str(image_width))
  WriteString(0," ")
  WriteString(0,Str(image_height))
  WriteStringN(0," ")
  WriteStringN(0,"255")
  WriteStringN(0," ")
  
  For j = 0 To image_height-1
    For i = 0 To image_width-1
      
      ii.f = i
      jj.f = j
      
      pix_color.Vec3
      
      pix_color\x = ii / (image_width - 1)
      pix_color\y = jj / (image_height - 1)
      pix_color\z = 0.0
      
      
     write_color(pix_color)      
     
    Next
  Next
   CloseFile(0)
EndIf

; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 42
; Folding = -
; EnableXP