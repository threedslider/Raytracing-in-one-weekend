image_width = 512
image_height = 512

If CreateFile(0, "image_test.ppm")
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
      
      r.f =  ii / (image_width - 1)
      g.f =  jj / (image_height- 1)
      b.f = 0.0
      
      ir.i = Int(255.999 * r)
      ig.i = Int(255.999 * g)
      ib.i = Int(255.999 * b)
      
      WriteString(0,Str(ir))
      WriteString(0," ")
      WriteString(0,Str(ig))
      WriteString(0," ")
      WriteString(0,Str(ib))
      WriteStringN(0," ")
      
     
    Next
  Next
   CloseFile(0)
EndIf

; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 36
; EnableXP