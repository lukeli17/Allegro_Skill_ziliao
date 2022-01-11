;************************************************************************************
;Change Width beta1.0
;
;功能概述：用于有阻抗变更的设计，对某一层内或多层的同种线宽进行更改。
;
;使用说明：	首先加载此il文件，在pcbenv文件目录下的allegro.ilinit最后一行添加
;	   	load("change_width.il")，axlCmdRegister("cw" 'change_width))中的"cw"	
;		为启动命令关键字,可以自定义此关键字。
;         
;功能明细	1. 通过在CIW窗口输入cw或者其他已经自定义的命令，启动功能窗体。
;			2. 在active窗口选择需要操作的层，可以多选或全选，此时点击view可以单独显示这些层。
;			3. 在old width内输入源线线宽，在new width内输入目标线宽。
;			6. 可以通过点击view去亮显这些线。
;			4. 当参数输入完毕后点击change执行更改。
;			5.命令执行完后不要再执行done命令，若确定点ok，撤销点cancel。
;   
;
;作者：chen_ck of WXTB
;
;升级历史
;
;2013.6.4 代码编写完成
;2014.5.13 增加区域线宽更改
;2013.6.16 修正常规线宽更改不响应的问题
;2013.
;

axlCmdRegister("cw" , 'change_width)
defun( change_width ()
let( (items formPath p_wh)
	formPath = "./changeW_.form"
	p_wh = outfile( formPath "w")
	fprintf(p_wh "FILE_TYPE=FORM_DEFN VERSION=2\n")
	fprintf(p_wh "FORM\n")
	fprintf(p_wh "FIXED\n")
	fprintf(p_wh "PORT 45 10\n")
	fprintf(p_wh "HEADER \"Change Width\"\n")
	fprintf(p_wh "TILE\n")
/******************活动层列表**********************/	
	fprintf(p_wh "GROUP \n")
	fprintf(p_wh "FLOC 1 0\n")
	fprintf(p_wh "FSIZE 14 20\n")
	fprintf(p_wh "ENDGROUP\n")

	fprintf(p_wh "TEXT \"Active Layer:\"\n")
	fprintf(p_wh "FLOC 3 1\n")
	fprintf(p_wh "ENDTEXT\n")

	fprintf(p_wh "FIELD activelayer\n")
	fprintf(p_wh "FLOC 2 3\n")
	fprintf(p_wh "LIST \"\" 12 7\n")
	fprintf(p_wh "OPTIONS multiselect prettyprint\n")
	fprintf(p_wh "ENDFIELD\n")

	fprintf(p_wh "FIELD selall\n")
	fprintf(p_wh "FLOC 2 17\n")
	fprintf(p_wh "MENUBUTTON \"Select All\" 12 3\n")
	fprintf(p_wh "ENDFIELD\n")
	
/******************执行区域**********************/	
	fprintf(p_wh "GROUP \n")
	fprintf(p_wh "FLOC 16 0\n")
	fprintf(p_wh "FSIZE 14 20\n")
	fprintf(p_wh "ENDGROUP\n")
	
	fprintf(p_wh "TEXT \"Old Width:\"\n")
	fprintf(p_wh "FLOC 19 2\n")
	fprintf(p_wh "ENDTEXT\n")

	fprintf(p_wh "FIELD oldW\n")
	fprintf(p_wh "FLOC 18 4\n")
	fprintf(p_wh "REALFILLIN 9 10\n")
	fprintf(p_wh "MIN 0.0000\n")
	fprintf(p_wh "MAX 100.0000\n")
	fprintf(p_wh "DECIMAL 4\n")
	fprintf(p_wh "ENDFIELD\n")

	fprintf(p_wh "FIELD view\n")
	fprintf(p_wh "FLOC 17 7\n")
	fprintf(p_wh "MENUBUTTON \"Serch\" 12 3\n")
	fprintf(p_wh "ENDFIELD\n")
	
	fprintf(p_wh "TEXT \"New Width:\"\n")
	fprintf(p_wh "FLOC 19 12\n")
	fprintf(p_wh "ENDTEXT\n")

	fprintf(p_wh "FIELD newW\n")
	fprintf(p_wh "FLOC 18 14\n")
	fprintf(p_wh "REALFILLIN 9 10\n")
	fprintf(p_wh "MIN 0.0000\n")
	fprintf(p_wh "MAX 100.0000\n")
	fprintf(p_wh "DECIMAL 4\n")
	fprintf(p_wh "ENDFIELD\n")

	fprintf(p_wh "FIELD ignfix\n")
	fprintf(p_wh "FLOC 18 17\n")
	fprintf(p_wh "CHECKLIST \"Ignore Fixed\"\n")
	fprintf(p_wh "ENDFIELD\n")	
	
	
/******************范围更改区域区域**********************/

	fprintf(p_wh "GROUP \n")
	fprintf(p_wh "FLOC 31 0\n")
	fprintf(p_wh "FSIZE 14 20\n")
	fprintf(p_wh "ENDGROUP\n")
	

	fprintf(p_wh "TEXT \"Area Width:\"\n")
	fprintf(p_wh "FLOC 32 1\n")
	fprintf(p_wh "ENDTEXT\n")

	fprintf(p_wh "FIELD activewidth\n")
	fprintf(p_wh "FLOC 32 3\n")
	fprintf(p_wh "LIST \"\" 12 7\n")
	fprintf(p_wh "OPTIONS multiselect prettyprint\n")
	fprintf(p_wh "ENDFIELD\n")
	
	fprintf(p_wh "FIELD select\n")
	fprintf(p_wh "FLOC 32 17\n")
	fprintf(p_wh "MENUBUTTON \"Select Area\" 12 3\n")
	fprintf(p_wh "ENDFIELD\n")
	
;	fprintf(p_wh "FIELD desel\n")
;	fprintf(p_wh "FLOC 18 9\n")
;	fprintf(p_wh "MENUBUTTON \"Clear\" 10 3\n")
;	fprintf(p_wh "ENDFIELD\n")
/******************确认按钮**********************/	

	fprintf(p_wh "FIELD changeW\n")
	fprintf(p_wh "FLOC 7 21\n")
	fprintf(p_wh "MENUBUTTON \"Change\" 10 3\n")
	fprintf(p_wh "ENDFIELD\n")
	
	fprintf(p_wh "FIELD ok\n")
	fprintf(p_wh "FLOC 20 21\n")
	fprintf(p_wh "MENUBUTTON \"Ok\" 10 3\n")
	fprintf(p_wh "ENDFIELD\n")
	
	fprintf(p_wh "FIELD cancel\n")
	fprintf(p_wh "FLOC 33 21\n")
	fprintf(p_wh "MENUBUTTON \"Cancel\" 10 3\n")
	fprintf(p_wh "ENDFIELD\n")
	
	fprintf(p_wh "ENDTILE\n")
	fprintf(p_wh "ENDFORM\n")
	close(p_wh)
	
	ch_form = axlFormCreate( (gensym) "changeW_.form" `(ne inner "msglines" 2) `changeW_Action t nil)
	axlUIWPerm( ch_form t )
	axlFormDisplay( ch_form )
	
	etchs = axlGetParam("paramLayerGroup:ETCH")
	etchs = etchs->groupMembers
	
	axlFormSetField( ch_form "activelayer"  etchs)
	axlFormSetField( ch_form "oldW" 		  0)
	axlFormSetField( ch_form "newW" 		  nil)
	axlFormDefaultButton(ch_form 			  nil)
	view_sel = nil
	width_lst = nil
	
	deleteFile(formPath)
);let
);defun

defun( changeW_Action (ch_form)

	old_w  = nil
	new_w  = nil
	layers = nil
	
	etch = axlFormListGetSelItems(ch_form "activelayer")
	foreach(tmp etch
		layers = tconc(layers buildString( list("ETCH" tmp) "/"))
	);foreach
	layers = car(layers)
	
	case(ch_form->curField
		("selall" 		if(ch_form->multi 
							then
								ch_form->multi = nil  
							else 
								ch_form->multi = t)
						axlFormListSelAll(ch_form "activelayer" ch_form->multi)
		);#selall
		
		("view"			get_cline()
						
		);#view"
		
		("changeW" 		change_cline() 	
						axlFormRestoreField(ch_form "oldW")
						axlFormRestoreField(ch_form "newW")
		);#changeW
		("select" 		area_sel()
		);#select
;		("desel" 		;de_sel()
;		);#clear
		("activewidth" 		axlFormSetField( ch_form "oldW" ch_form->curValue)
		);#select	
		
		("ok"			axlFinishEnterFun() 
						;axlDBTransactionCommit(widthMark)
		);#ok

		("cancel"		;unless(!boundp('widthMark)
							;axlDBTransactionRollback(widthMark)
						;);unless
						axlCancelEnterFun()
		);#cancel
	);case
);defun

defun( get_cline ()
	
	view_sel = nil
	axlVisibleDesign(nil)
	foreach(db layers
		axlVisibleLayer(db t)
	);foreach
	axlVisibleUpdate(t)
	axlClearSelSet()
	axlSetFindFilter(?enabled list("noall" "clinesegs") ?onButtons list("noall" "clinesegs"))
	viewclines = axlGetSelSet(axlAddSelectAll())
	axlClearSelSet()
	if(viewclines
		then
			foreach(db3 viewclines
				if(db3->width == axlFormGetField(ch_form "oldW")
					then
						axlHighlightObject(db3)
						view_sel =  cons(db3 view_sel)
				)
			);foreach
		else
			axlUIWPrint(ch_form "NO CLINES")
	);if	

);defun

defun(	area_sel ()

	while(axlFormListDeleteItem(ch_form "activewidth" 0) nil)
	axlFormSetField( ch_form "oldW" 0)
	width_lst = nil
	axlClearSelSet()
	axlSetFindFilter(?enabled list("noall" "clinesegs") ?onButtons list("noall" "clinesegs"))
	;area_clines = axlGetSelSet(axlSelect(?groupMode nil ?prompt nil))
	axlSingleSelectBox()
	area_clines = axlGetSelSet()
	width_lst = cons(car(area_clines)->width width_lst);收集第一个宽度
	foreach(db area_clines
		unless(member(db->width width_lst)
			width_lst = cons(db->width width_lst)
			
		);unless 筛选
	);收集所有的宽度
	foreach(db3 width_lst
		axlFormSetField( ch_form "activewidth" db3)
	);foreach
);defun
defun( de_sel ()
	width_lst = nil
	while(axlFormListDeleteItem(ch_form "activewidth" 0) nil)
	;axlFormSetField( ch_form "oldW" 		  nil)
)
	
defun( change_cline ()

	;widthMark = axlDBTransactionStart()

	fixed = nil;判断有无锁定
	
	while(axlFormListDeleteItem(ch_form "activewidth" 0) nil)
	if(axlFormGetField(ch_form "ignfix")
		then
			axlDBIgnoreFixed( t)
		else
			axlDBIgnoreFixed( nil)
	);
	if(width_lst
		then 
			allclines = area_clines
		else if(view_sel 
				then 
					allclines = view_sel
				else
					axlClearSelSet()
					axlSetFindFilter(?enabled list("noall" "clinesegs") ?onButtons list("noall" "clinesegs"))
					allclines = axlGetSelSet(axlAddSelectAll())
			);if
	)
	buffer = nil
	foreach(db1 allclines
		if(db1->width == axlFormGetField(ch_form "oldW")
			then
				buffer = tconc(buffer db1)
				when(axlDBIsFixed(db1) fixed = t)
		);if
	);foreach
	buffer = car(buffer)

	foreach(db2 buffer
		axlChangeWidth(db2 , axlFormGetField(ch_form "newW"))
	);foreach
	;axlDBTransactionMark(widthMark)
	if(fixed 
		then
			axlUIWPrint(ch_form "Some clines were fixed!")
	);
	gc()
	width_lst = nil
);defun 
defun(cancel_ ()
	unless(!boundp('widthMark)
		axlDBTransactionRollback(widthMark)
	);unless
);defun
