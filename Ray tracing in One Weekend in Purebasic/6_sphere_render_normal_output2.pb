;
; Inspired from Ray Tracing in One Weekend : 
; https://raytracing.github.io/books/RayTracingInOneWeekend.html
;
; Writed and adapted in Purebasic by threedslider
;

aspect_ratio.f = 16.0 / 9.0
image_width = 800

image_height = Int(image_width / aspect_ratio)

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

Procedure.f dot(*v1.Vec3, *v2.Vec3)
  result.f = *v1\x * *v2\x + *v1\y * *v2\y + *v1\z * *v2\z
  
  ProcedureReturn result
EndProcedure

Procedure.f v_length(*v.Ray)
  
  result.f = Sqr(*v\dir\x * *v\dir\x + *v\dir\y * *v\dir\y + *v\dir\z * *v\dir\z)
  
  ;Debug result
  
  ProcedureReturn result
EndProcedure

Procedure.f At(*rr.Ray, t.f, axe)
  
  x.f = *rr\orig\x + t * *rr\dir\x
  y.f = *rr\orig\y + t * *rr\dir\y
  z.f = *rr\orig\z + t * *rr\dir\z
  
  If axe = 1
    ProcedureReturn x
  EndIf
  
  If axe = 2
    ProcedureReturn y
  EndIf
  
  If axe = 3
    ProcedureReturn z
  EndIf
EndProcedure

Procedure.f unit_vector_y(*vy.Ray)
    
  len.f = v_length(*vy) 
  
  y.f = 0
  
  If Not len = 0 ;And Not len < 0
    y = *vy\dir\y / len
  EndIf
  
  
  ;Debug vv
  
  ProcedureReturn y
EndProcedure


Procedure.f unit_vector_normal_at(*rr.Ray, t.f, axe)
  Shared p_s.Vec3
  
   x.f = (*rr\orig\x + t * *rr\dir\x) 
   y.f = (*rr\orig\y + t * *rr\dir\y) 
   z.f = (*rr\orig\z + t * *rr\dir\z) 
  
  
  len.f = Sqr(x*x + y*y + z*z)
  
  xx.f = 0
  yy.f = 0
  zz.f = 0
  
   If Not len = 0 
    xx = x  / len
  EndIf
  
  If Not len = 0 
    yy = y / len
  EndIf
  
   If Not len = 0 
    zz = z / len
  EndIf
  
  If axe = 1
    ProcedureReturn xx
  EndIf
  
  If axe = 2
    ProcedureReturn yy
  EndIf
  
  If axe = 3
    ProcedureReturn zz
  EndIf
  
EndProcedure

Procedure.f unit_vector_normal(*rr.Ray, axe)
    
  len.f = Sqr(*rr\dir\x * *rr\dir\x + *rr\dir\y * *rr\dir\y + *rr\dir\z  * *rr\dir\z )
  
  xx.f = 0
  yy.f = 0
  zz.f = 0
  
   If Not len = 0 
    xx = *rr\dir\x / len
  EndIf
  
  If Not len = 0 
    yy = *rr\dir\y / len
  EndIf
  
   If Not len = 0 
     zz = *rr\dir\z  / len
     If axe = 3
      ProcedureReturn zz
    EndIf
  EndIf
  
  If axe = 1
    ProcedureReturn xx
  EndIf
  
  If axe = 2
    ProcedureReturn yy
  EndIf
  
  
  
EndProcedure




Procedure.f ray_color_n(*rr.Ray, axe)
  Shared p_s.Vec3

  x.f =  0.5 * ((unit_vector_normal(*rr,1) + 1.0) )

  y.f =  0.5 * ((unit_vector_normal(*rr,2) + 1.0) )
 
  z.f =  0.5 * ((unit_vector_normal(*rr,3) + 1.0) )
  
  If axe = 1
    ProcedureReturn x
  EndIf
  
  If axe = 2
    ProcedureReturn y
  EndIf
  
  If axe = 3
    ProcedureReturn z
  EndIf
   
EndProcedure



Procedure.f ray_color(*rr.Ray, axe)
  
  color1.Vec3
  color2.Vec3
  
  color1\x = 1.0
  color1\y = 1.0
  color1\z = 1.0
  
  color2\x = 0.5
  color2\y = 0.7
  color2\z = 1.0
  
  unit_direction.Vec3
    
  unit_direction\x = unit_vector_y(*rr)
  a1.f = 0.5 * (unit_direction\x + 1.0) 
  x.f =  (1.0 - a1) * color1\x + a1 * color2\x 

  unit_direction\y = unit_vector_y(*rr)
  a2.f = 0.5 * (unit_direction\y + 1.0)
  y.f =  (1.0 - a2) * color1\y + a2 * color2\y
 
  unit_direction\z = unit_vector_y(*rr)
  a3.f = 0.5 * (unit_direction\z + 1.0)
  z.f =  (1.0 - a3) * color1\z + a3 * color2\z
  
  If axe = 1
    ProcedureReturn x
  EndIf
  
  If axe = 2
    ProcedureReturn y
  EndIf
  
  If axe = 3
    ProcedureReturn z
  EndIf
   
EndProcedure  
  
Procedure.f hit_sphere(*posx.Vec3, radius.f, *vx.Ray)
  oc.Vec3
  oc\x = *vx\orig\x - *posx\x
  oc\y = *vx\orig\y - *posx\y
  oc\z = *vx\orig\z - *posx\z
  a.f = dot(*vx\dir, *vx\dir)
  b.f = 2.0 * dot(oc,*vx\dir)
  c.f = dot(oc,oc) - radius*radius
  
  discriminant.f = b*b - 4*a*c
  
  If discriminant < 0
    ProcedureReturn -1.0
  Else
    dis.f = (-b - Sqr(discriminant) ) / (2.0*a)
    ProcedureReturn dis
   
  EndIf
  

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
; If CreateFile(0, "image_test4.ppm")
;   WriteStringN(0,"P3")
;   WriteString(0,Str(image_width))
;   WriteString(0," ")
;   WriteString(0,Str(image_height))
;   WriteStringN(0," ")
;   WriteStringN(0,"255")
;   WriteStringN(0," ")
;   
;   For j = 0 To image_height-1
;     For i = 0 To image_width-1
;       
;       ii.f = i
;       jj.f = j
;       
;       pixel_center.Vec3
;       
;       Define.Vec3 pixel_color
;       
;       pixel_center\x = pixel_100_loc\x + (ii * pixel_delta_u\x) + (jj * pixel_delta_v\x)
;       pixel_center\y = pixel_100_loc\y + (ii * pixel_delta_u\y) + (jj * pixel_delta_v\y)
;       pixel_center\z = pixel_100_loc\z + (ii * pixel_delta_u\z) + (jj * pixel_delta_v\z)
;       
;       ;Debug pixel_center\x
;       
;       ray_direction\x = pixel_center\x - point3\x
;       ray_direction\y = pixel_center\y - point3\y
;       ray_direction\z = pixel_center\z - point3\z
;       
;       ;Debug ray_direction\x
;       
;       Define.Ray r
;       
;       r\orig = point3
;       r\dir = ray_direction
;       
;       Define.Ray myray
;       
;       myray\orig = point3
;       myray\dir = ray_direction
;       
;       p_s.Vec3
;       
;       p_s\x = 0
;       p_s\y = 0
;       p_s\z = -1
;       
;       If hit_sphere(p_s, 0.5, r)
;         pixel_color\x = 1.0
;         pixel_color\y = 0
;         pixel_color\z = 0
;       Else
;         pixel_color\x = ray_color_x(r)
;         pixel_color\y = ray_color_y(r)
;         pixel_color\z = ray_color_z(r)
;       EndIf
;     
;       ;Debug pixel_color\x
;       write_color()    
;      
;      
;     Next
;   Next
;    CloseFile(0)
;  EndIf

InitSprite()
 
 OpenWindow(0, 0, 0, image_width, image_height, "Inspired from Raytracing in One Weekend", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
 OpenWindowedScreen(WindowID(0), 0, 0, image_width, image_height)
  
  ClearScreen(RGB(0,0,0))
  
  If StartDrawing(ScreenOutput())
    
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
      
      Define.Ray myray
      
      myray\orig = point3
      myray\dir = ray_direction
      
      p_s.Vec3
      
      
      
      p_s\x = 0.0 
      
      p_s\y = 0.0
      p_s\z = -1.0
      
      vv.Vec3
      
      vv\x = 0
      vv\y = 0
      vv\z = -1
      
     
      
      t.f = hit_sphere(p_s, 0.5, r)
      
      ray_direction\x =  At(r,t,1) - p_s\x
      ray_direction\y =  At(r,t,2) - p_s\y
      ray_direction\z =  At(r,t,3) - p_s\z
      
      Define.Ray r_n
      
      r_n\orig = point3
      r_n\dir = ray_direction
      
      
      
   Debug Int(255.999 * ray_color_n(r_n,1))*2
      If t > 0.0
        Plot(i, j, RGB(Int(255.999 * ray_color_n(r_n,1)), Int(255.999 * ray_color_n(r_n,2)), Int(255.999 * ray_color_n(r_n,3)*0.2)*255))
      Else
        Plot(i, j, RGB(Int(255.999 * ray_color(r,1)),Int(255.999 * ray_color(r,2)),Int(255.999* ray_color(r,3))))
      EndIf
     
      Next
  Next
   
  
  StopDrawing() 
  
EndIf
 Repeat
   Event = WindowEvent()
 Until  Event = #PB_Event_CloseWindow
   
 End 

; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 470
; FirstLine = 437
; Folding = --
; EnableXP