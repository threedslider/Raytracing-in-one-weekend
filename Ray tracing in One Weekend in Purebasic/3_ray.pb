
aspect_ratio.f = 16.0 / 9.0
image_width = 800

;Debug aspect_ratio

image_height = Int(image_width / aspect_ratio)

;Debug image_height

If image_height < 1
  image_height = 1
Else
  image_height = image_height
EndIf

focal_length.f = 1.0
viewport_height.f = 2.0

i_w.f = image_width
i_h.f = image_height
viewport_width.f = viewport_height * (i_w/i_h)

;Debug i_w/i_h
;Debug viewport_width


; Vector 
Structure Vec3
  x.f
  y.f
  z.f
EndStructure

; Ray
Structure Ray
  orig.Vec3
  dir.Vec3
EndStructure

point3.Vec3

point3\x = 0
point3\y = 0
point3\z = 0

ray_direction.Vec3

ray_direction\x = 0
ray_direction\y = 0
ray_direction\z = 0

viewport_u.Vec3

viewport_u\x = viewport_width
viewport_u\y = 0
viewport_u\z = 0

viewport_v.Vec3

viewport_v\x = 0
viewport_v\y = -viewport_height
viewport_v\z = 0

pixel_delta_u.Vec3

pixel_delta_u\x = viewport_u\x / i_w
pixel_delta_u\y = viewport_u\y / i_w
pixel_delta_u\z = viewport_u\z / i_w

;Debug pixel_delta_u\x

pixel_delta_v.Vec3

pixel_delta_v\x = viewport_v\x / i_h
pixel_delta_v\y = viewport_v\y / i_h
pixel_delta_v\z = viewport_v\z / i_h

;Debug pixel_delta_v\y

viewport_upper_left.Vec3

v_f.Vec3
v_f\x = 0.0
v_f\y = 0.0
v_f\z = focal_length

viewport_upper_left\x = point3\x - v_f\x - viewport_u\x / 2 - viewport_v\x / 2
viewport_upper_left\y = point3\y - v_f\y - viewport_u\y / 2 - viewport_v\y / 2
viewport_upper_left\z = point3\z - v_f\z - viewport_u\z / 2 - viewport_v\z / 2

;Debug viewport_u\x / 2 
;Debug viewport_upper_left\x

pixel_100_loc.Vec3

pixel_100_loc\x = viewport_upper_left\x + 0.5 * (pixel_delta_u\x + pixel_delta_v\x)
pixel_100_loc\y = viewport_upper_left\y + 0.5 * (pixel_delta_u\y + pixel_delta_v\y)
pixel_100_loc\z = viewport_upper_left\z + 0.5 * (pixel_delta_u\z + pixel_delta_v\z)

;Debug pixel_100_loc\x

Procedure.f v_length(*v.Ray)
  
  result.f = Sqr(*v\dir\x * *v\dir\x + *v\dir\y * *v\dir\y + *v\dir\z * *v\dir\z)
  
  ;Debug result
  
  ProcedureReturn result
EndProcedure


Procedure.f unit_vector_x(*vx.Ray)
    
  len.f = v_length(*vx) 
  
  ;Debug len
  
  If Not len = 0 ;And Not len < 0
    *vx\dir\x = *vx\dir\x / len
  EndIf
  
  
  ;Debug vv
  
  ProcedureReturn *vx\dir\x
EndProcedure

Procedure.f unit_vector_y(*vy.Ray)
    
  len.f = v_length(*vy) 
  
  ;Debug len
  
  If Not len = 0 ;And Not len < 0
    *vy\dir\y = *vy\dir\y / len
  EndIf
  
  
  ;Debug vv
  
  ProcedureReturn *vy\dir\y
EndProcedure

Procedure.f unit_vector_z(*vz.Ray)
    
  len.f = v_length(*vz) 
  
  ;Debug len
  
  If Not len = 0 ;And Not len < 0
    *vz\dir\z = *vz\dir\z / len
  EndIf
  
  
  ;Debug vv
  
  ProcedureReturn *vz\dir\z
EndProcedure

Procedure.f ray_color_x(*rx.Ray)
 
  unit_direction.Vec3
  

  unit_direction\y = unit_vector_y(*rx)

  
  ;Debug unit_direction\y
  
  a.f = 0.5 * (unit_direction\y + 1.0)
  
  ;Debug a
  
  color1.f = 1.0
  color2.f = 0.5
  
  x.f =  (1.0 - a) * color1 + a * color2
   
  ProcedureReturn x
EndProcedure

Procedure.f ray_color_y(*ry.Ray)
 
  unit_direction.Vec3
  

  unit_direction\y = unit_vector_y(*ry)

  
  ;Debug unit_direction\y
  
  a.f = 0.5 * (unit_direction\y + 1.0)
  
  ;Debug a
  
  color1.f = 1.0
  color2.f = 0.7
  
  y.f =  (1.0 - a) * color1 + a * color2
   
  
  ProcedureReturn y
EndProcedure

Procedure.f ray_color_z(*rz.Ray)
 
  unit_direction.Vec3
  

  unit_direction\y = unit_vector_y(*rz)

  
  ;Debug unit_direction\y
  
  a.f = 0.5 * (unit_direction\y + 1.0)
  
  ;Debug a
  
  color1.f = 1.0
  color2.f = 1.0
  
  z.f =  (1.0 - a) * color1 + a * color2
   
  
  ProcedureReturn z
EndProcedure

  

; Write the translated [0,255] value of each color component.
Procedure write_color()
  Shared pixel_color.Vec3
  
  WriteString(0, Str(Int(255.999 * pixel_color\x)))
  WriteString(0, " ")
  WriteString(0, Str(Int(255.999 * pixel_color\y)))
  WriteString(0, " ")
  WriteString(0, Str(Int(255.999 * pixel_color\z)))
  WriteStringN(0, " ")
  
  ;Debug Str(Int(255.999 * pixel_color\x))
EndProcedure

; Output the image in PPM
If CreateFile(0, "image_test3.ppm")
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
      
      pixel_center.Vec3
      
      Define.Vec3 pixel_color
      
      pixel_center\x = pixel_100_loc\x + (ii * pixel_delta_u\x) + (jj * pixel_delta_v\x)
      pixel_center\y = pixel_100_loc\y + (ii * pixel_delta_u\y) + (jj * pixel_delta_v\y)
      pixel_center\z = pixel_100_loc\z + (ii * pixel_delta_u\z) + (jj * pixel_delta_v\z)
      
      ;Debug pixel_center\x
      
      ray_direction\x = pixel_center\x - point3\x
      ray_direction\y = pixel_center\y - point3\y
      ray_direction\z = pixel_center\z - point3\z
      
      ;Debug ray_direction\x
      
      Define.Ray r
      
      r\orig = point3
      r\dir = ray_direction
     
      pixel_color\x = ray_color_x(r)
      pixel_color\y = ray_color_y(r)
      pixel_color\z = ray_color_z(r)
    
          
      ;Debug pixel_color\x
      write_color()    
     
     
    Next
  Next
   CloseFile(0)
EndIf

; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 288
; FirstLine = 244
; Folding = --
; EnableXP