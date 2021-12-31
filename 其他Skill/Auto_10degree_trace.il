
/*
################################################################################
#                                                                              #
#                      Command: tune                                           #
#                   Skill File: tune.il                                        #
#                  How To Load: Command> (load("tune.il"))                     #
#               How To Execute: Command> tune                                  #
#                                                        				 #
#                                                         				 #
################################################################################
*/
;###############################################################
;#           DISCLAIMER:      routing 10 degree cline for user.#
;#                      	     					   #  
;#                                                        	   #
;###############################################################

axlCmdRegister("tune" 'tune)
	


procedure(tune();set main function
		(defun axlMyCancel ()   	
 			 axlClearDynamics()   	 
			 axlCancelEnterFun()   	 
			 axlUIPopupSet(nil))
		(defun axlMyDone ()   	 
			 axlClearDynamics()   	 
			 axlFinishEnterFun()   	
 			 axlUIPopupSet(nil))
mypopup = axlUIPopupDefine( nil  (list (list "MyCancel" 'axlMyCancel)  (list "MyDone" 'axlMyDone)))
			axlUIPopupSet( mypopup)

 		axlSetFindFilter(?enabled list( "noall" "clinesegs") ?onButtons list("noall" "clinesegs"))
           	axlClearSelSet(); set done and cancle cammand

	while(axlSingleSelectBox()
		 design=axlGetSelSet()
		 length=length(design)
		 ;design_dbid1=car(axlGetSelSet())
		 design_dbid1=nth(0 design)
		 layer=design_dbid1->layer
		 startEnd1=design_dbid1->startEnd
		 a=nth(0 startEnd1)
		 b=nth(1 startEnd1)
		 xa=nth(0 a)
		 ya=nth(1 a)
		 xb=nth(0 b)
		 yb=nth(1 b)
		 xminmax=min(xa xb);left
    		 xmaxmin=max(xa xb);right
		 yminup=max(ya yb);up
		 ymaxdown=min(ya yb);down

		lineType=design_dbid1->lineType
			; get need to route cline
        case(lineType

                 ;;the below is cline is horrizontal
            (horizontal 
			ylist='()
			allylist='() 
		for(l 1 length
              	mei_db=nth(l-1 design)
		  	staEnd=mei_db->startEnd
              	width=mei_db->width
			ma=nth(0 staEnd)
			mb=nth(1 staEnd)
			mxa=nth(0 ma)
			mxb=nth(0 mb)
			mxleft=min(mxa mxb)
			mxright=max(mxa mxb)
			xminmax=max(mxleft  xminmax)
			xmaxmin=min(mxright xmaxmin)
			my=nth(1 ma)
			ylist=cons(width ylist)
			ylist=cons(mxright ylist)
			ylist=cons(mxleft ylist)
			ylist=cons(my ylist)
			allylist=cons(ylist allylist)
		);end for 
			;get all need to route 10 degree information
			paixudy=sortcar(allylist 'greaterp)
			
			d=abs(xmaxmin-xminmax)-50
			
			
			add_x=atof(axlUIPrompt("please enter addx_distance" "125"))
			
			m=(floor d/(2*add_x)) ;route how much cycle
			

			firstx=nth(1 nth(0 paixudy));get max y coodrinate clines x information 

			axlDeleteObject(design)

	if(firstx==xminmax
			then


				rout=nth(0 paixudy)
				qishiy=nth(0 rout)
				qishix=nth(1 rout)
				zhongx=nth(2 rout)
				width=nth(3 rout)
				xcank=xminmax+20
				x0=xcank
         			wy1=qishiy-(add_x /5)
         			wy2=qishiy
    				path=axlPathStart(list(qishix:qishiy) width)
    				;axlDBCreateLine(list(qishix:qishiy x0:qishiy) width layer)
    				axlPathLine( path, width, x0:qishiy)

     				for(k 1 m
         			 wx1=x0+add_x
        			 wx2=wx1+add_x
        				; path=axlPathStart(list(x0:qishiy) width)
    					;axlDBCreateLine(list(x0:qishiy wx1:wy1) width layer)
   					; axlDBCreateLine(list(wx1:wy1 wx2:wy2) width layer)
    				 axlPathLine( path, width, wx1:wy1)
   				 axlPathLine( path, width, wx2:wy2)

				x0=wx2
				);for
   				   	; path=axlPathStart(list(wx2:wy2) width)
    					;axlDBCreateLine(list(wx2:wy2 zhongx:wy2) width layer)
    				axlPathLine( path, width, zhongx:wy2)
				axlDBCreatePath( path, layer)

				lasty1=wy1
				lasty2=wy2
					;x0=xminmax+5
				xlast=wx2
     	

		for(q 1 length-1
		   if((m==1) then
				
			rout=nth(q paixudy)
			chushiy=nth(0 rout)
			chushix=nth(1 rout)
			zhongx=nth(2 rout)
			width=nth(3 rout)
			spac=abs(qishiy-chushiy)
			xcank=xcank-(sqrt(26)-5)*spac-0.01
			x0=xcank
			xmm=xminmax+20
			wx1=xmm+add_x
 			wx2=wx1+add_x
			dty=sqrt(26)*spac/5+0.002
			wy1=lasty1-dty
 			wy2=lasty2-dty
			path=axlPathStart(list(chushix:chushiy) width)
			axlPathLine( path, width, x0:chushiy)  
		      axlPathLine( path, width, wx1:wy1)
			axlPathLine( path, width, (xlast+(sqrt(26)-5)*spac+0.01):chushiy)
			axlPathLine( path, width, zhongx:chushiy)
			axlDBCreatePath( path, layer)
			qishiy=chushiy
			lasty1=wy1
			lasty2=wy2
			xlast=wx2
		else

			rout=nth(q paixudy)
			chushiy=nth(0 rout)
			chushix=nth(1 rout)
			zhongx=nth(2 rout)
			width=nth(3 rout)
			spac=abs(qishiy-chushiy)
			xcank=xcank-(sqrt(26)-5)*spac-0.01
			x0=xcank
			xmm=xminmax+20
 				;x0=xminmax+5
 			wx1=xmm+add_x
 			wx2=wx1+add_x

			dty=sqrt(26)*spac/5+0.002
 			wy1=lasty1-dty
 			wy2=lasty2-dty
    			path=axlPathStart(list(chushix:chushiy) width)
   			 	;axlDBCreateLine(list(chushix:chushiy x0:chushiy) width layer)
    				;axlDBCreateLine(list(x0:chushiy wx1:wy1) width layer)
    				;axlDBCreateLine(list(wx1:wy1 wx2:wy2) width layer)
   			 axlPathLine( path, width, x0:chushiy)  
    			 axlPathLine( path, width, wx1:wy1)
    			 axlPathLine( path, width, wx2:wy2)

			x0=wx2
    			for(k 1 m-2

         		wx1=x0+add_x
         		wx2=wx1+add_x

    				;path=axlPathStart(list(x0:wy2) width)
    				;axlDBCreateLine(list(x0:wy2 wx1:wy1) width layer)
    				;axlDBCreateLine(list(wx1:wy1 wx2:wy2) width layer)
    			axlPathLine( path, width, wx1:wy1)
    			axlPathLine( path, width, wx2:wy2)

			x0=wx2
			);for
         		wx1=x0+add_x
         		wx2=xlast+(sqrt(26)-5)*spac+0.01
         			;path=axlPathStart(list(x0: wy2) width)
    				;axlDBCreateLine(list(x0:wy2 wx1:wy1) width layer)
   				 ;axlDBCreateLine(list(wx1:wy1 wx2:chushiy) width layer)
    				;axlDBCreateLine(list(wx2:chushiy zhongx:chushiy) width layer)
   			 axlPathLine( path, width, wx1:wy1)  
    			 axlPathLine( path, width, wx2:chushiy)
   			 axlPathLine( path, width, zhongx:chushiy)
			 axlDBCreatePath( path, layer)


			qishiy=chushiy
			lasty1=wy1
			lasty2=wy2
			xlast=wx2
			);if
              );for
		
		else

			

			paixudy=reverse(paixudy)
			rout=nth(0 paixudy)
			qishiy=nth(0 rout)
			qishix=nth(1 rout)
			zhongx=nth(2 rout)
			width=nth(3 rout)
			xcank=xminmax+20
			x0=xcank
         		wy1=qishiy+(add_x /5)
         		wy2=qishiy
    			path=axlPathStart(list(qishix:qishiy) width)
   				; axlDBCreateLine(list(qishix:qishiy x0:qishiy) width layer)
   			 axlPathLine( path, width, x0:qishiy)
     		for(k 1 m
         		wx1=x0+add_x
         		wx2=wx1+add_x
        			; path=axlPathStart(list(x0:qishiy) width)
    				;axlDBCreateLine(list(x0:qishiy wx1:wy1) width layer)
    				;axlDBCreateLine(list(wx1:wy1 wx2:wy2) width layer)
    			axlPathLine( path, width, wx1:wy1)
    			axlPathLine( path, width, wx2:wy2)


			x0=wx2
			);for
    				;path=axlPathStart(list(wx2:wy2) width)
  			      ; axlDBCreateLine(list(wx2:wy2 zhongx:wy2) width layer)
   				 axlPathLine( path, width, zhongx:wy2)
				 axlDBCreatePath( path, layer)
			lasty1=wy1
			lasty2=wy2
			;x0=xminmax+5
			xlast=wx2


		for(q 1 length-1
		  if((m==1) then
				
			rout=nth(q paixudy)
			chushiy=nth(0 rout)
			chushix=nth(1 rout)
			zhongx=nth(2 rout)
			width=nth(3 rout)
			spac=abs(qishiy-chushiy)
			xcank=xcank-(sqrt(26)-5)*spac-0.01
			x0=xcank
			xmm=xminmax+20
			wx1=xmm+add_x
 			wx2=wx1+add_x
			dty=sqrt(26)*spac/5+0.002
			wy1=lasty1+dty
 			wy2=lasty2+dty
			path=axlPathStart(list(chushix:chushiy) width)
			axlPathLine( path, width, x0:chushiy)  
		      axlPathLine( path, width, wx1:wy1)
			axlPathLine( path, width, (xlast+(sqrt(26)-5)*spac+0.01):chushiy)
			axlPathLine( path, width, zhongx:chushiy)
			axlDBCreatePath( path, layer)
			qishiy=chushiy
			lasty1=wy1
			lasty2=wy2
			xlast=wx2
		else


			
				
				rout=nth(q paixudy)
				chushiy=nth(0 rout)
				chushix=nth(1 rout)
				zhongx=nth(2 rout)
				width=nth(3 rout)
				spac=abs(qishiy-chushiy)
				xcank=xcank-(sqrt(26)-5)*spac-0.01
				x0=xcank
				xmm=xminmax+20
 				;x0=xminmax+5
 				wx1=xmm+add_x
 				wx2=wx1+add_x

				dty=sqrt( 26)*spac/5+0.002
 					wy1=lasty1+dty
 					wy2=lasty2+dty
    				path=axlPathStart(list(chushix:chushiy) width)
    				;axlDBCreateLine(list(chushix:chushiy x0:chushiy) width layer)
    				;axlDBCreateLine(list(x0:chushiy wx1:wy1) width layer)
    				;axlDBCreateLine(list(wx1:wy1 wx2:wy2) width layer)
    				axlPathLine( path, width, x0:chushiy)
    				axlPathLine( path, width, wx1:wy1)
   				 axlPathLine( path, width, wx2:wy2)




				x0=wx2
    			for(k 1 m-2

         				wx1=x0+add_x
         				wx2=wx1+add_x

   						; path=axlPathStart(list(x0:wy2) width)
    						;axlDBCreateLine(list(x0:wy2 wx1:wy1) width layer)
    						;axlDBCreateLine(list(wx1:wy1 wx2:wy2) width layer)
    					axlPathLine( path, width, wx1:wy1)
    					axlPathLine( path, width, wx2:wy2)

					x0=wx2
				);for
         			wx1=x0+add_x
         			wx2=xlast+(sqrt(26)-5)*spac+0.01
        			;path=axlPathStart(list(x0: wy2) width)
    				;axlDBCreateLine(list(x0:wy2 wx1:wy1) width layer)
    				;axlDBCreateLine(list(wx1:wy1 wx2:chushiy) width layer)
    				;axlDBCreateLine(list(wx2:chushiy zhongx:chushiy) width layer)
    				axlPathLine( path, width, wx1:wy1)
    				axlPathLine( path, width, wx2:chushiy)
    				axlPathLine( path, width, zhongx:chushiy)
				axlDBCreatePath( path, layer)

			qishiy=chushiy
			lasty1=wy1
			lasty2=wy2
			xlast=wx2
			);if
			);for lengthe-1


			);if first==xminmax



);horizontal 








             (vertical


			ylist='()
			allylist='() 
		for(l 1 length
              	mei_db=nth(l-1 design)
			staEnd=mei_db->startEnd
              width=mei_db->width
		  ma=nth(0 staEnd)
		  mb=nth(1 staEnd)
		  mya=nth(1 ma)
			myb=nth(1 mb)
			myup=max(mya myb)
			mydown=min(mya myb)
			yminup=min(myup  yminup);qu up min
			ymaxdown=max(mydown ymaxdown);qu down max
			mx=nth(0 ma)
			ylist=cons(width ylist)
			ylist=cons(mydown ylist)
			ylist=cons(myup ylist)
			ylist=cons(mx ylist)
			allylist=cons(ylist allylist)
			);for
		paixudy=sortcar(allylist 'greaterp)
		d=abs(yminup-ymaxdown)-50
		;mm=(floor d/add_x)
		;m=(floor mm/2)
		add_x=atof(axlUIPrompt("please enter addx_distance" "125"))
		m=(floor d/(2*add_x))

		firsty=nth(1 nth(0 paixudy))

		axlDeleteObject(design)

		if((firsty==yminup)
		then

			a=1
			rout=nth(0 paixudy)
			qishix=nth(0 rout)
			qishiy=nth(1 rout)
			zhongy=nth(2 rout)
			width=nth(3 rout)
			ycank=yminup-10
			y0=ycank
         		wx1=qishix-(add_x /5)
         		wx2=qishix
    			path=axlPathStart(list(qishix:qishiy) width)
    			
    			axlPathLine( path, width, qishix:y0)
     for(k 1 m
         wy1=y0-add_x
         wy2=wy1-add_x
         	
    		axlPathLine( path, width, wx1:wy1)
    		axlPathLine( path, width, wx2:wy2)

		y0=wy2
	);for
   		
    		axlPathLine( path, width, wx2:zhongy)
		axlDBCreatePath( path, layer)

		lastx1=wx1
		lastx2=wx2
		
		ylast=wy2


		for(q 1 length-1
			if((m==1) then
				rout=nth(q paixudy)
				chushix=nth(0 rout)
				chushiy=nth(1 rout)
				zhongy=nth(2 rout)
				width=nth(3 rout)
				spac=abs(qishix-chushix)
				ycank=ycank+(sqrt(26)-5)*spac+0.01
				y0=ycank
				ymm=yminup-10
 				wy1=ymm-add_x
 				wy2=wy1-add_x
	 			dtx=sqrt(26)*spac/5+0.002
				wx1=lastx1-dtx
 				wx2=lastx2-dtx
				path=axlPathStart(list(chushix:chushiy) width)
				axlPathLine( path, width, chushix:y0)
				axlPathLine( path, width, wx1:wy1)
				axlPathLine( path, width, chushix:(ylast-(sqrt(26)-5)*spac-0.01))
				axlPathLine( path, width, chushix:zhongy)
				axlDBCreatePath( path, layer)
				qishix=chushix
				lastx1=wx1
				lastx2=wx2
				ylast=wy2

		    		
		else	

			rout=nth(q paixudy)
			chushix=nth(0 rout)
			chushiy=nth(1 rout)
			zhongy=nth(2 rout)
			width=nth(3 rout)
			spac=abs(qishix-chushix)
			ycank=ycank+(sqrt(26)-5)*spac+0.01
			y0=ycank
			ymm=yminup-10
 			;x0=xminmax+5
 			wy1=ymm-add_x
 			wy2=wy1-add_x

		dtx=sqrt(26)*spac/5+0.002
		 	wx1=lastx1-dtx
 			wx2=lastx2-dtx
    			path=axlPathStart(list(chushix:chushiy) width)
   			 	
    			axlPathLine( path, width, chushix:y0)  
    			axlPathLine( path, width, wx1:wy1)
    			axlPathLine( path, width, wx2:wy2)
			
			

			y0=wy2
    		for(k 1 m-2

         		wy1=y0-add_x
         		wy2=wy1-add_x

   			; path=axlPathStart(list(wx2:y0) width)
   			;axlDBCreateLine(list(wx2:y0 wx1:wy1) width layer)
    			;axlDBCreateLine(list(wx1:wy1 wx2:wy2) width layer)
    			axlPathLine( path, width, wx1:wy1)
   			 axlPathLine( path, width, wx2:wy2)


			y0=wy2
		);for
         		wy1=y0-add_x
         		wy2=ylast-(sqrt(26)-5)*spac-0.01
        		; path=axlPathStart(list(wx2:y0) width)
   			 ;axlDBCreateLine(list(wx2:y0 wx1:wy1) width layer)
   			; axlDBCreateLine(list(wx1:wy1 chushix:wy2) width layer)
    			;axlDBCreateLine(list(chushix:wy2 chushix:zhongy) width layer)
    			 axlPathLine( path, width, wx1:wy1)  
   			 axlPathLine( path, width, chushix:wy2)
    			 axlPathLine( path, width, chushix:zhongy)
			 axlDBCreatePath( path, layer)


			qishix=chushix
			lastx1=wx1
			lastx2=wx2
			ylast=wy2
			);if
		);for length-1
			
	else


		a=2
		paixudy=reverse(paixudy)
		rout=nth(0 paixudy)
		qishix=nth(0 rout)
		qishiy=nth(1 rout)
		zhongy=nth(2 rout)
		width=nth(3 rout)
		ycank=yminup-10
		y0=ycank
         	wx1=qishix+(add_x /5)
         	wx2=qishix
    		path=axlPathStart(list(qishix:qishiy) width)
    		;axlDBCreateLine(list(qishix:qishiy qishix:y0) width layer)
    		axlPathLine( path, width, qishix:y0)
    	 for(k 1 m
         	wy1=y0-add_x
         	wy2=wy1-add_x
       	 ; path=axlPathStart(list(qishix:y0) width)
    		;axlDBCreateLine(list(qishix:y0 wx1:wy1) width layer)
    		;axlDBCreateLine(list(wx1:wy1 wx2:wy2) width layer)
    		axlPathLine( path, width, wx1:wy1)
    		axlPathLine( path, width, wx2:wy2)
		y0=wy2
		);for
    		;path=axlPathStart(list(wx2:wy2) width)
    		;axlDBCreateLine(list(wx2:wy2 wx2:zhongy) width layer)
    		axlPathLine( path, width, wx2:zhongy)
		axlDBCreatePath( path, layer)

		lastx1=wx1
		lastx2=wx2
		;x0=xminmax+5
		ylast=wy2


		for(q 1 length-1
			if((m==1) then
                      rout=nth(q paixudy)
				chushix=nth(0 rout)
				chushiy=nth(1 rout)
				zhongy=nth(2 rout)
				width=nth(3 rout)
				spac=abs(qishix-chushix)
				ycank=ycank+(sqrt(26)-5)*spac+0.01
				y0=ycank
				ymm=yminup-10
 				wy1=ymm-add_x
 				wy2=wy1-add_x
				dtx=sqrt(26)*spac/5+0.002
				wx1=lastx1+dtx
 				wx2=lastx2+dtx
				path=axlPathStart(list(chushix:chushiy) width)
				axlPathLine( path, width, chushix:y0)
				axlPathLine( path, width, wx1:wy1)
    			axlPathLine( path, width, chushix:wy2+(ylast-(sqrt(26)-5)*spac-0.01))
				axlPathLine( path, width, chushix:zhongy)
				axlDBCreatePath( path, layer)
				qishix=chushix
				lastx1=wx1
				lastx2=wx2
				ylast=wy2


			  else 
				rout=nth(q paixudy)
				chushix=nth(0 rout)
				chushiy=nth(1 rout)
				zhongy=nth(2 rout)
				width=nth(3 rout)
				spac=abs(qishix-chushix)
				ycank=ycank+(sqrt(26)-5)*spac+0.01
				y0=ycank
				ymm=yminup-10
 				;x0=xminmax+5
 				wy1=ymm-add_x
 				wy2=wy1-add_x

			dtx=sqrt(26)*spac/5+0.002
 			wx1=lastx1+dtx
 			wx2=lastx2+dtx
    			path=axlPathStart(list(chushix:chushiy) width)
   			; axlDBCreateLine(list(chushix:chushiy chushix:y0) width layer)
    			;axlDBCreateLine(list(chushix:y0 wx1:wy1) width layer)
    			;axlDBCreateLine(list(wx1:wy1 wx2:wy2) width layer)
    			axlPathLine( path, width, chushix:y0)
    			axlPathLine( path, width, wx1:wy1)
    			axlPathLine( path, width, wx2:wy2)
			y0=wy2
			
    for(k 1 m-2

         		wy1=y0-add_x
         		wy2=wy1-add_x

   			; path=axlPathStart(list(wx2:y0) width)
   			; axlDBCreateLine(list(wx2:y0  wx1:wy1) width layer)
    			;axlDBCreateLine(list(wx1:wy1 wx2:wy2) width layer)
    			axlPathLine( path, width, wx1:wy1)
    			axlPathLine( path, width, wx2:wy2)



		y0=wy2
		);for
         		wy1=y0-add_x
         		wy2=ylast-(sqrt(26)-5)*spac-0.01
        		; path=axlPathStart(list(wx2:y0 ) width)
  			 ; axlDBCreateLine(list(wx2:y0  wx1:wy1) width layer)
    			;axlDBCreateLine(list(wx1:wy1 chushix:wy2) width layer)
    			;axlDBCreateLine(list(chushix:wy2 chushix:zhongy) width layer)
    			axlPathLine( path, width, wx1:wy1)
    			axlPathLine( path, width, chushix:wy2)
    			axlPathLine( path, width, chushix:zhongy)
			axlDBCreatePath( path, layer)


		qishix=chushix
		lastx1=wx1
		lastx2=wx2
		ylast=wy2
		 );if m=1
		);for
		

	);if



);vertical



);case

);while

)