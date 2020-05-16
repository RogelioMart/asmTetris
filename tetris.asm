.MODEL SMALL

.STACK 100h



;totalscreen length is 
;                 "||	                                                                     ||$" about 75 pixels



.DATA
;the playable grid is 16x10
;THE tetrimino will enter through line 7(+17)
;points						  DEF start at 13 ands at 26



brdr1 DB 10, 13, '         ||          ||'
brdr3 DB 10, 13, '         ||          ||'
brdr4 DB 10, 13, '         ||          ||'
brdr5 DB 10, 13, '         --          --'
brdr6 DB 10, 13, '         ||          ||';start at +13 ands at +26
brdr7 DB 10, 13, '         ||          ||' ;+43
brdr8 DB 10, 13, '=========||          ||'
brdr9 DB 10, 13, '|  Next  ||          ||';For next
brdr10 DB 10, 13,'|        ||          ||';+3 to +10
brdr11 DB 10, 13,'|        ||          ||';+3 to +10
brdr12 DB 10, 13,'|        ||          ||';+3 to +10
brdr13 DB 10, 13,'|        ||          ||';+3 to +10
brdr14 DB 10, 13,'=========||          ||'
brdr15 DB 10, 13,'         ||          ||'
brdr16 DB 10, 13,'=========||          ||'
brdr17 DB 10, 13,'| Points ||          ||'
brdr18 DB 10, 13,'|        ||          ||'
brdr19 DB 10, 13,'|   00   ||          ||'; +6 for single +7 for double
brdr20 DB 10, 13,'=========||          ||'
brdr21 DB 10, 13,'         ||          ||'
brdr22 DB 10, 13,'         ==============', 10, 13, '$'

debug DB 10, 13, "works",10,13,'$'

.CODE
Main	PROC
	mov ax, @data
	mov ds, ax
	
start: ;label where the main begins starts
	mov ah, 0fh;gets video mode
	int 10h	   ;calls it
	mov ah, 00h;sets video mode
	int 10h    ;calls it
	
	mov ah, 09h         ;prepares to write 
	mov dx, OFFSET brdr1 ;gets the characters
	int 21h 		    ;draws GUI

	mov ah, 01h ;gives the user a moement to pause before starting the game
	int 21h     ;does the interupt
	
	mov BX, 17 ;all tetraminos will start from 17 from the brdr1 string
	
	call leftL ;this procedure creates the leftL tetramino and and moves it down (many other function need to be created to properly implement this tetramino)
	
	mov ah, 09h
	mov dx, OFFSET debug; used to know if this works
	int 21h
	

	
exit:
	mov al, 0
	mov ah, 4ch
	int 21h
	
Main ENDP

makeLeftL PROC
	;this function takes BX as its parameter and builds a left L tetramino
	;ah should be set to 17 for this to work
	

	ret
makeLeftL ENDP


;-----------------leftL-------------------------
;-------------------------------------------------
leftL PROC
	
	;this procedure takes BX as its parameter and builds a left L tetramino
	;BX should be set to 17 for this to work
	
	mov brdr1+BX, ' ';makes the top left most part of the tetramino left L
	add BX, 1		 
	mov brdr1+BX, 02h;makes the top rightmost part of the tetramino left L
	add BX, 24
	mov brdr1+BX, ' ';makes the middle layer of the tetramino
	add BX, 1
	mov brdr1+BX, 02h;makes the middle layer of the tetramino
	add BX, 24
	mov brdr1+BX, 02h;makes the bottom layer of the tetramino
	add BX, 1
	mov brdr1+BX, 02h;makes the bottom layer of the tetramino
	
	push BX ;BX and basically all other registers must be pushed into the stack before using refresh or deleteLoop
	
	mov BX, 1
	
	call deleteLoop ;deletes the top part of the tetris grid
	call refresh ;;refreshes the GUI and gives the user time to see the tetramino move
	
	pop BX ;pops BX back to use it
	
	
movLeftLLoop:

	sub BX, 50; crucial to subtract 50 from BX so that it can delete the previous part of the tetramino

	mov brdr1+BX, ' ';deletes the previous part of the tetramino
	add BX, 49
	mov brdr1+BX, ' ';deletes the previous part of the tetramino
	add BX, 1
	mov brdr1+BX, 02h;makes the new part of the tetramino
	add BX, 24
	mov brdr1+BX, 02h;makes the new bottom part of the tetramino
	add BX, 1
	mov brdr1+BX, 02h;makes the new bottom part of the tetramino
	
	push BX ;pushes BX to stack to avoid it messing up because of refresh
	
	call refresh ;refreshes the GUI and gives the user time to see the tetramino move
	
	pop BX
	
	cmp BX, 488 ;488 is the the value of the bottom left corner if BX is equal to or greater than 488 then it his the floor
	JL movLeftLLoop
	
	ret
leftL ENDP


;----------------deleteTopLoop--------------------
;-------------------------------------------------
deleteTopLoop PROC

	;deletes the top of the tetris grid

	deleteLoop:
	
	mov brdr1+BX, ' '; in order to delete the grid it just replaces the its original character with a space ' '
	
	add BX, 1
	
	cmp BX, 75 ;the top grid is composed of approx 75 char they are all delete by the end of this loop
	
	JNE deleteLoop
	
	ret
deleteTopLoop ENDP


;----------------checkToStop----------------------
;-------------------------------------------------
checkToStop PROC

checkToStop ENDP

;-----------------refresh-------------------------
;-------------------------------------------------
refresh PROC

	;this procedure doesn't take in parameters but it does seem to mess with all
	;the registers to please save all your register into the stack before using this
	;it refreshes the GUI for the user and gives it some time to wait so that the user
	;has time to reach
	
	mov ah, 0fh;gets video mode
	int 10h	   ;calls it
	mov ah, 00h;sets video mode
	int 10h    ;calls it
	
	mov ah, 09h         ;prepares to write 
	mov dx, OFFSET brdr1 ;gets the characters
	int 21h 		    ;draws UI
	
	mov al, 0
	mov ah, 86h
	mov cx, 000fh
	mov dx, 0086h ;1 sec
	int 15h	;command to wait a little bit

	ret
refresh ENDP

END Main