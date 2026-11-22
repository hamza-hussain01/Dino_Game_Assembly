[org 0x0100]
jmp start


bg_color:       db 20
body_color:     db 21
eye_color:      db 20
ground_color:   db 21
cloud_color:    db 22
moon_color:     db 23
star_color:     db 24
cactus_color:   db 23
bump_color:     db 26
spot_color:     db 27

intro_file:     db "intro.bin", 0


dino_idle:
    db "00000000011111110"
    db "00000000112111111"
    db "00000000111111111"
    db "00000000111110000"
    db "00000000111111110"
    db "00000000111110000"
    db "10000001111111000"
    db "10000011111101000"
    db "11000111111110000"
    db "11111111111110000"
    db "01111111111110000"
    db "00111111111100000"
    db "00011111111000000"

dino_legs_run_1:
    db "00001100110000000"
    db "00001100000000000"
    db "00001100000000000"

dino_legs_run_2:
    db "00001100110000000"
    db "00000000110000000"
    db "00000000110000000"

cloud:
    db "00000001110000000000"
    db "00000111111110000000"
    db "00111111111111100000"
    db "11111111111111111100"
    db "01111111111111111110"
    db "00011111111111111100"

moon:
    db "000001110000000"
    db "000111110000000"
    db "001111000000000"
    db "011110000000000"
    db "011100000000000"
    db "111000000000000"
    db "111000000000000"
    db "111000000000000"
    db "011100000000000"
    db "011110000000000"
    db "001111000000000"
    db "000111110000000"
    db "000001110000000"
    db "000000000000000"
    db "000000000000000"

star:
    db "010"
    db "111"
    db "010"

cactus:
    db "000111000"
    db "001111100"
    db "001212100"
    db "001111100"
    db "001111100"
    db "001222100"
    db "001111100"
    db "101111101"
    db "101111101"
    db "111111111"
    db "001111100"
    db "001111100"
    db "001111100"
    db "001111100"
    db "001111100"


state:          db 0
prev_state:     db 0
esc_flag:       db 0
jump_flag:      db 0
jumping:        db 0
jump_idx:       db 0
redraw_flag:    db 0
leg_state:      db 0
cactus_on:      db 0
cactus_x:       dw 296
cactus_n:       dw 1
cactus_wait:    dw 30
cur_h:          dw 0
score:          dw 0
score_last:     dw 0
scene_last:     dw 0
game_last:      dw 0
rand_seed:      dw 12345
tickcount:      dw 0


current:        db 0
taskSP:         dw 0, 0, 0
oldtimer:       dd 0
oldkb:          dd 0

jump_table:     db 8,16,24,32,38,43,47,50,52,53,53,52,50,47,43,38,32,24,16,8,0

cloud_1:        dw 30, 20, 7, 7, 2
cloud_2:        dw 60, 130, 12, 12, 3
cloud_3:        dw 40, 230, 18, 18, 1


music_pos:      dw 0
note_start:     dw 0
note_len:       dw 0
tempo:          dw 20
beep_flag:      db 0
beep_on:        db 0
beep_start:     dw 0

melody:
    dw 3616, 1
    dw 3616, 1
    dw 3419, 1
    dw 3044, 1
    dw 3044, 1
    dw 3419, 1
    dw 3616, 1
    dw 4059, 1
    dw 4554, 1
    dw 4554, 1
    dw 4059, 1
    dw 3616, 1
    dw 3616, 2
    dw 4059, 1
    dw 4059, 2
melody_end:


score_msg:      db "SCORE 0000"
final_msg:      db "FINAL SCORE 0000"
final_len       equ $-final_msg
gameover_msg:   db "GAME OVER"
gameover_len    equ $-gameover_msg
again_msg:      db "ENTER = AGAIN    ESC = EXIT"
again_len       equ $-again_msg
title_msg1:     db "PRESS ENTER TO START"
title_len1      equ $-title_msg1
title_msg2:     db "SPACE = JUMP    ESC = EXIT"
title_len2      equ $-title_msg2
confirm_msg1:   db "Are you sure you want to exit the game?"
confirm_len1    equ $-confirm_msg1
confirm_msg2:   db "Y = exit     any other key = resume"
confirm_len2    equ $-confirm_msg2
anykey_msg:     db "PRESS ANY KEY"
anykey_len      equ $-anykey_msg


star_table:
    dw 15, 35
    dw 35, 75
    dw 12, 120
    dw 25, 175
    dw 48, 205
    dw 35, 260
    dw 65, 95
    dw 55, 175
    dw 75, 285

road_bumps:
    dw 12, 188, 3
    dw 30, 193, 1
    dw 52, 190, 2
    dw 70, 195, 5
    dw 95, 187, 1
    dw 118, 191, 3
    dw 140, 194, 2
    dw 163, 188, 1
    dw 185, 192, 4
    dw 207, 196, 2
    dw 226, 189, 1
    dw 248, 193, 3
    dw 270, 187, 2
    dw 293, 195, 1
    dw 306, 190, 3
road_end:


Draw_Block:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push di
    push es
    mov ax, 0xA000
    mov es, ax
    mov ax, [bp+10]
    mov bx, 320
    mul bx
    add ax, [bp+8]
    mov di, ax
    mov al, [bp+4]
    mov dx, [bp+6]
    cld

block_row:
    mov cx, [bp+6]
    push di
    rep stosb
    pop di
    add di, 320
    dec dx
    jnz block_row

    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8


Draw_Sprite:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push word [bp+18]
    mov si, [bp+14]
    mov dx, [bp+10]

spr_row:
    mov di, [bp+16]
    mov cx, [bp+12]

spr_col:
    mov al, [si]
    inc si
    cmp al, '0'
    je spr_skip
    mov bx, [bp+6]
    cmp al, '2'
    jne spr_draw
    mov bx, [bp+4]

spr_draw:
    push word [bp-14]
    push di
    push word [bp+8]
    push bx
    call Draw_Block

spr_skip:
    add di, [bp+8]
    loop spr_col

    mov ax, [bp+8]
    add [bp-14], ax
    dec dx
    jnz spr_row

    add sp, 2
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 16


Draw_Cloud:
    push bp
    mov bp, sp
    push word [bp+8]
    push word [bp+6]
    push word cloud
    push word 20
    push word 6
    push word [bp+4]
    push word [cloud_color]
    push word [cloud_color]
    call Draw_Sprite
    pop bp
    ret 6


Draw_Moon:
    push bp
    mov bp, sp
    push word [bp+6]
    push word [bp+4]
    push word moon
    push word 15
    push word 15
    push word 1
    push word [moon_color]
    push word [moon_color]
    call Draw_Sprite
    pop bp
    ret 4


Draw_Star:
    push bp
    mov bp, sp
    push word [bp+6]
    push word [bp+4]
    push word star
    push word 3
    push word 3
    push word 1
    push word [star_color]
    push word [star_color]
    call Draw_Sprite
    pop bp
    ret 4


Draw_Cactus:
    push bp
    mov bp, sp
    push word [bp+6]
    push word [bp+4]
    push word cactus
    push word 9
    push word 15
    push word 2
    push word [cactus_color]
    push word [spot_color]
    call Draw_Sprite
    pop bp
    ret 4


Clear_Screen:
    push ax
    push cx
    push di
    push es
    mov ax, 0xA000
    mov es, ax
    xor di, di
    mov al, [bg_color]
    mov cx, 64000
    cld
    rep stosb
    pop es
    pop di
    pop cx
    pop ax
    ret


Draw_Ground:
    push ax
    push cx
    push di
    push es
    mov ax, 0xA000
    mov es, ax
    mov di, 58880
    mov cx, 640
    mov al, [ground_color]
    cld
    rep stosb
    pop es
    pop di
    pop cx
    pop ax
    ret


Erase_Rect:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push di
    push es
    mov ax, 0xA000
    mov es, ax
    mov ax, [bp+10]
    mov bx, 320
    mul bx
    add ax, [bp+8]
    mov di, ax
    mov dx, [bp+4]
    mov al, [bg_color]
    cld

erase_rows:
    mov cx, [bp+6]
    push di
    rep stosb
    pop di
    add di, 320
    dec dx
    jnz erase_rows

    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8


Draw_Road_Texture:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es
    mov ax, 0xA000
    mov es, ax
    mov si, road_bumps
    cld

road_loop:
    mov ax, [si+2]
    mov bx, 320
    mul bx
    add ax, [si]
    mov di, ax
    mov cx, [si+4]
    mov al, [bump_color]
    rep stosb
    add si, 6
    cmp si, road_end
    jb road_loop

    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret


Draw_Road:
    call Draw_Ground
    call Draw_Road_Texture
    ret


Move_Road:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es
    mov ax, 0xA000
    mov ds, ax
    mov es, ax
    mov di, 58880
    mov bx, 14
    cld

road_rows:
    mov si, di
    add si, 4
    mov ax, [di]
    mov dx, [di+2]
    mov cx, 158
    rep movsw
    mov [di], ax
    mov [di+2], dx
    add di, 4
    dec bx
    jnz road_rows

    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret


Draw_Stars:
    push cx
    push si
    mov si, star_table
    mov cx, 9

stars_loop:
    push word [si]
    push word [si+2]
    call Draw_Star
    add si, 4
    loop stars_loop

    pop si
    pop cx
    ret


Draw_Clouds:
    push word [cloud_1]
    push word [cloud_1+2]
    push word [cloud_1+8]
    call Draw_Cloud
    push word [cloud_2]
    push word [cloud_2+2]
    push word [cloud_2+8]
    call Draw_Cloud
    push word [cloud_3]
    push word [cloud_3+2]
    push word [cloud_3+8]
    call Draw_Cloud
    ret


Draw_Sky:
    push word 12
    push word 280
    call Draw_Moon
    call Draw_Stars
    ret


Move_Cloud:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    mov bx, [bp+4]
    dec word [bx+4]
    jnz mcloud_done
    mov ax, [bx+6]
    mov [bx+4], ax

    push word [bx]
    push word [bx+2]

    mov ax, [bx+8]
    mov cx, 20
    mul cx
    push ax

    mov ax, [bx+8]
    mov cx, 6
    mul cx
    push ax

    call Erase_Rect
    dec word [bx+2]
    jnz mcloud_draw
    mov word [bx+2], 260

mcloud_draw:
    call Draw_Stars
    call Draw_Clouds

mcloud_done:
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2


Draw_Dino_Body:
    push ax
    mov ax, 136
    sub ax, [cur_h]
    push ax
    push word 40
    push word dino_idle
    push word 17
    push word 13
    push word 3
    push word [body_color]
    push word [eye_color]
    call Draw_Sprite
    pop ax
    ret


Draw_Legs:
    push ax
    mov ax, 175
    sub ax, [cur_h]
    push ax
    push word 40
    push word 51
    push word 9
    call Erase_Rect

    mov ax, 175
    sub ax, [cur_h]
    push ax
    push word 40
    mov ax, dino_legs_run_1
    cmp byte [leg_state], 0
    je legs_go
    mov ax, dino_legs_run_2

legs_go:
    push ax
    push word 17
    push word 3
    push word 3
    push word [body_color]
    push word [eye_color]
    call Draw_Sprite
    pop ax
    ret


Get_Random:
    push dx
    mov ax, [rand_seed]
    mov dx, 25173
    mul dx
    add ax, 13849
    mov [rand_seed], ax
    mov al, ah
    xor ah, ah
    pop dx
    ret


Start_Cactus_Timer:
    push ax
    call Get_Random
    and ax, 31
    add ax, 20
    mov [cactus_wait], ax
    pop ax
    ret


Cactus_Draw:
    push ax
    push bx
    push cx
    mov bx, [cactus_x]
    mov cx, [cactus_n]

cdraw_loop:
    cmp bx, 4
    jl cdraw_next
    push word 154
    push bx
    call Draw_Cactus

cdraw_next:
    add bx, 22
    loop cdraw_loop

    pop cx
    pop bx
    pop ax
    ret


Cactus_Erase:
    push ax
    push bx
    push cx
    mov bx, [cactus_x]
    mov cx, [cactus_n]

cerase_loop:
    cmp bx, 4
    jl cerase_next
    push word 154
    push bx
    push word 18
    push word 30
    call Erase_Rect

cerase_next:
    add bx, 22
    loop cerase_loop

    pop cx
    pop bx
    pop ax
    ret


Move_Cactus:
    cmp byte [cactus_on], 1
    je cactus_move

    dec word [cactus_wait]
    jnz cactus_none
    mov byte [cactus_on], 1
    call Get_Random
    and ax, 3
    mov word [cactus_n], 1
    mov word [cactus_x], 296
    jnz cactus_spawn_draw
    mov word [cactus_n], 2
    mov word [cactus_x], 274

cactus_spawn_draw:
    call Cactus_Draw
    jmp cactus_none

cactus_move:
    call Cactus_Erase
    sub word [cactus_x], 8
    mov bx, [cactus_x]
    mov ax, bx
    cmp word [cactus_n], 1
    je cactus_lastok
    add ax, 22

cactus_lastok:
    cmp ax, 4
    jge cactus_draw
    mov byte [cactus_on], 0
    call Get_Random
    and ax, 63
    add ax, 10
    mov [cactus_wait], ax
    jmp cactus_none

cactus_draw:
    call Cactus_Draw
    cmp bx, 80
    jg cactus_none
    cmp ax, 29
    jl cactus_none
    cmp word [cur_h], 30
    jae cactus_none
    mov ax, 1
    ret

cactus_none:
    mov ax, 0
    ret


Game_Frame:
    cmp byte [jump_flag], 0
    je gf_nokey
    mov byte [jump_flag], 0
    cmp byte [jumping], 0
    jne gf_nokey
    mov byte [jumping], 1
    mov byte [jump_idx], 0

gf_nokey:
    mov ax, [cur_h]
    cmp byte [jumping], 0
    je gf_hknown
    mov bl, [jump_idx]
    xor bh, bh
    mov al, [jump_table + bx]
    xor ah, ah
    inc byte [jump_idx]
    or al, al
    jnz gf_hknown
    mov byte [jumping], 0

gf_hknown:
    cmp ax, [cur_h]
    jne gf_all
    cmp byte [redraw_flag], 0
    jne gf_all

    cmp word [cur_h], 0
    jne gf_cactus
    xor byte [leg_state], 1
    call Draw_Legs
    jmp gf_cactus

gf_all:
    push ax
    mov ax, 136
    sub ax, [cur_h]
    push ax
    push word 40
    push word 51
    push word 48
    call Erase_Rect
    pop ax
    mov [cur_h], ax
    mov byte [redraw_flag], 0
    call Draw_Dino_Body
    call Draw_Legs

gf_cactus:
    call Move_Cactus
    cmp ax, 1
    jne gf_end
    mov byte [state], 3

gf_end:
    ret


task_scene:

scene_loop:
    mov ax, [tickcount]
    sub ax, [scene_last]
    cmp ax, 4
    jb scene_loop
    mov ax, [tickcount]
    mov [scene_last], ax
    cmp byte [state], 1
    jne scene_loop
    call Move_Road
    call Move_Road
    push word cloud_1
    call Move_Cloud
    push word cloud_2
    call Move_Cloud
    push word cloud_3
    call Move_Cloud
    jmp scene_loop


task_game:

game_loop:
    mov ax, [tickcount]
    sub ax, [game_last]
    cmp ax, 4
    jb game_loop
    mov ax, [tickcount]
    mov [game_last], ax
    cmp byte [state], 1
    jne game_loop
    call Game_Frame
    jmp game_loop


kbisr:
    push ax
    in al, 0x60
    test al, 0x80
    jnz kb_check
    mov byte [cs:beep_flag], 1

kb_check:
    cmp al, 0x01
    je kb_esc
    cmp al, 0x39
    je kb_space
    pop ax
    jmp far [cs:oldkb]

kb_esc:
    mov byte [cs:esc_flag], 1
    jmp kb_done

kb_space:
    mov byte [cs:jump_flag], 1

kb_done:
    mov al, 0x20
    out 0x20, al
    pop ax
    iret


timer:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push ds
    push es
    mov ax, cs
    mov ds, ax
    inc word [tickcount]

    mov bl, [current]
    xor bh, bh
    shl bx, 1
    mov [taskSP + bx], sp

    inc byte [current]
    cmp byte [current], 3
    jb timer_next
    mov byte [current], 0

timer_next:
    mov bl, [current]
    xor bh, bh
    shl bx, 1
    mov sp, [taskSP + bx]

    mov al, 0x20
    out 0x20, al
    pop es
    pop ds
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    iret


Make_Task:
    sub bx, 24
    mov [di], bx
    mov [bx + 0], cs
    mov [bx + 2], cs
    mov [bx + 18], ax
    mov [bx + 20], cs
    mov word [bx + 22], 0x0202
    ret


Play_Note:
    push ax
    mov al, 0xB6
    out 0x43, al
    pop ax
    out 0x42, al
    mov al, ah
    out 0x42, al
    in al, 0x61
    or al, 3
    out 0x61, al
    ret


Stop_Music:
    push ax
    in al, 0x61
    and al, 0xFC
    out 0x61, al
    pop ax
    ret


Music_Update:
    push ax
    push bx
    push dx
    cmp byte [beep_flag], 0
    je mu_nobeep
    mov byte [beep_flag], 0
    mov ax, 1356
    call Play_Note
    mov ax, [tickcount]
    mov [beep_start], ax
    mov byte [beep_on], 1
    jmp mu_done

mu_nobeep:
    cmp byte [beep_on], 0
    je mu_music
    mov ax, [tickcount]
    sub ax, [beep_start]
    cmp ax, 5
    jb mu_done
    mov byte [beep_on], 0
    mov word [note_len], 0

mu_music:
    mov ax, [tickcount]
    sub ax, [note_start]
    cmp ax, [note_len]
    jb mu_done
    mov ax, [tickcount]
    mov [note_start], ax
    mov bx, [music_pos]
    mov ax, [melody + bx]
    call Play_Note
    mov ax, [melody + bx + 2]
    mul word [tempo]
    mov [note_len], ax
    add bx, 4
    cmp bx, melody_end - melody
    jb mu_save
    xor bx, bx

mu_save:
    mov [music_pos], bx

mu_done:
    pop dx
    pop bx
    pop ax
    ret


Print_Msg:
    push ax
    push bx
    push es
    push bp
    push cs
    pop es
    mov ax, 0x1301
    mov bx, 0x0018
    int 0x10
    pop bp
    pop es
    pop bx
    pop ax
    ret


Clear_Band:
    push word 80
    push word 0
    push word 320
    push word 16
    call Erase_Rect
    ret


Num_To_Str:
    push ax
    push bx
    push cx
    push dx
    push di
    add di, 3
    mov cx, 4
    mov bx, 10

nts_loop:
    xor dx, dx
    div bx
    add dl, '0'
    mov [di], dl
    dec di
    loop nts_loop

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret


Draw_Score:
    push ax
    push bx
    push cx
    push dx
    push di
    push bp
    mov ax, [score]
    mov di, score_msg + 6
    call Num_To_Str
    push word 0
    push word 240
    push word 80
    push word 8
    call Erase_Rect
    mov bp, score_msg
    mov cx, 10
    mov dh, 0
    mov dl, 30
    call Print_Msg
    pop bp
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret


Update_Score:
    mov ax, [tickcount]
    sub ax, [score_last]
    cmp ax, 10
    jb us_done
    mov ax, [tickcount]
    mov [score_last], ax
    cmp word [score], 9999
    jae us_done
    inc word [score]
    call Draw_Score

us_done:
    ret


Show_Title:
    call Clear_Band
    mov bp, title_msg1
    mov cx, title_len1
    mov dh, 10
    mov dl, (40 - title_len1) / 2
    call Print_Msg
    mov bp, title_msg2
    mov cx, title_len2
    mov dh, 11
    mov dl, (40 - title_len2) / 2
    call Print_Msg
    ret


Show_Game_Over:
    call Clear_Band
    mov bp, gameover_msg
    mov cx, gameover_len
    mov dh, 10
    mov dl, (40 - gameover_len) / 2
    call Print_Msg
    mov bp, again_msg
    mov cx, again_len
    mov dh, 11
    mov dl, (40 - again_len) / 2
    call Print_Msg
    ret


Key_Poll:
    mov ah, 1
    int 0x16
    jz kp_none
    mov ah, 0
    int 0x16
    ret

kp_none:
    xor al, al
    ret


Flush_Keys:
    mov ah, 1
    int 0x16
    jz fk_done
    mov ah, 0
    int 0x16
    jmp Flush_Keys

fk_done:
    ret


Wait_Ticks:
    push ax
    push bx
    mov bx, [tickcount]

wt_loop:
    mov ax, [tickcount]
    sub ax, bx
    cmp ax, cx
    jb wt_loop
    pop bx
    pop ax
    ret


Set_Video_Mode:
    push ax
    mov ax, 0x0013
    int 0x10
    pop ax
    ret


Set_Palette:
    push ax
    push bx
    push cx
    push dx

    mov ax, 0x1010
    mov bx, 20
    mov dh, 4
    mov ch, 6
    mov cl, 20
    int 0x10

    mov ax, 0x1010
    mov bx, 21
    mov dh, 45
    mov ch, 45
    mov cl, 45
    int 0x10

    mov ax, 0x1010
    mov bx, 22
    mov dh, 22
    mov ch, 25
    mov cl, 32
    int 0x10

    mov ax, 0x1010
    mov bx, 23
    mov dh, 63
    mov ch, 58
    mov cl, 38
    int 0x10

    mov ax, 0x1010
    mov bx, 24
    mov dh, 63
    mov ch, 63
    mov cl, 63
    int 0x10

    mov ax, 0x1010
    mov bx, 26
    mov dh, 30
    mov ch, 30
    mov cl, 30
    int 0x10

    mov ax, 0x1010
    mov bx, 27
    mov dh, 0
    mov ch, 0
    mov cl, 0
    int 0x10

    pop dx
    pop cx
    pop bx
    pop ax
    ret

Wait_Retrace:
    push ax
    push dx
    mov dx, 0x3DA

wr_1:
    in al, dx
    test al, 8
    jnz wr_1

wr_2:
    in al, dx
    test al, 8
    jz wr_2

    pop dx
    pop ax
    ret


Draw_Big_Moon:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es
    call Clear_Screen
    mov ax, 0xA000
    mov es, ax
    xor si, si
    mov bx, 100

bm_x:
    mov cx, 50

bm_y:
    mov ax, bx
    sub ax, 160
    imul ax
    mov di, ax
    mov ax, cx
    sub ax, 100
    imul ax
    add di, ax
    cmp di, 2500
    ja bm_next

    mov ax, bx
    sub ax, 185
    imul ax
    mov di, ax
    mov ax, cx
    sub ax, 90
    imul ax
    add di, ax
    cmp di, 1764
    jbe bm_next

    mov ax, cx
    mov dx, 320
    mul dx
    add ax, bx
    mov di, ax
    mov al, [moon_color]
    mov [es:di], al

    inc si
    test si, 15
    jnz bm_next
    call Wait_Retrace

bm_next:
    inc cx
    cmp cx, 151
    jb bm_y
    inc bx
    cmp bx, 212
    jb bm_x

    mov cx, 70

bm_hold:
    call Wait_Retrace
    loop bm_hold

    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

Show_Intro:
    push ax
    push bx
    push cx
    push dx
    push ds

    mov ax, 0x3D00
    mov dx, intro_file
    int 0x21
    jc intro_skip
    mov bx, ax

    mov ax, 0xA000
    mov ds, ax
    xor dx, dx
    mov cx, 64000
    mov ah, 0x3F
    int 0x21

    push cs
    pop ds

    mov ah, 0x3E
    int 0x21

    mov cx, 0x002D
    mov dx, 0xC6C0
    mov ah, 0x86
    int 0x15

    mov ax, 0xA000
    mov es, ax
    xor di, di
    xor al, al
    mov cx, 64000
    cld
    rep stosb

    mov cx, 0x001E
    mov dx, 0x8480
    mov ah, 0x86
    int 0x15

intro_skip:
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    ret


Draw_Scene:
    call Clear_Screen
    call Draw_Road
    call Draw_Sky
    call Draw_Clouds
    mov word [cur_h], 0
    mov byte [jumping], 0
    mov byte [jump_idx], 0
    mov byte [jump_flag], 0
    mov byte [redraw_flag], 0
    mov byte [leg_state], 0
    mov byte [cactus_on], 0
    mov word [cactus_x], 296
    mov word [cactus_n], 1
    mov word [score], 0
    call Start_Cactus_Timer
    call Draw_Dino_Body
    call Draw_Legs
    ret


Start_Game:
    mov cx, 10
    call Wait_Ticks
    mov ax, [tickcount]
    add [rand_seed], ax
    call Draw_Scene
    mov ax, [tickcount]
    mov [score_last], ax
    call Draw_Score
    mov word [tempo], 8
    mov byte [state], 1
    ret


Confirm_Exit:
    mov al, [state]
    mov [prev_state], al
    mov byte [state], 2
    call Clear_Band
    mov bp, confirm_msg1
    mov cx, confirm_len1
    mov dh, 10
    mov dl, (40 - confirm_len1) / 2
    call Print_Msg
    mov bp, confirm_msg2
    mov cx, confirm_len2
    mov dh, 11
    mov dl, (40 - confirm_len2) / 2
    call Print_Msg
    call Flush_Keys
    mov byte [esc_flag], 0

ce_wait:
    cmp byte [esc_flag], 0
    jne ce_no
    call Key_Poll
    or al, al
    jz ce_wait
    cmp al, 'Y'
    je ce_yes
    cmp al, 'y'
    je ce_yes

ce_no:
    mov byte [esc_flag], 0
    mov byte [jump_flag], 0
    call Clear_Band
    mov al, [prev_state]
    cmp al, 1
    jne ce_notplay
    mov byte [redraw_flag], 1
    mov byte [state], 1
    ret

ce_notplay:
    cmp al, 0
    jne ce_over
    mov byte [state], 0
    call Show_Title
    ret

ce_over:
    mov byte [state], 3
    ret

ce_yes:
    jmp Exit_Game


Exit_Game:
    call Stop_Music
    call Clear_Band
    mov ax, [score]
    mov di, final_msg + 12
    call Num_To_Str
    mov bp, final_msg
    mov cx, final_len
    mov dh, 10
    mov dl, (40 - final_len) / 2
    call Print_Msg
    mov bp, anykey_msg
    mov cx, anykey_len
    mov dh, 11
    mov dl, (40 - anykey_len) / 2
    call Print_Msg
    call Flush_Keys
    mov ah, 0
    int 0x16

    cli
    xor ax, ax
    mov es, ax
    mov ax, [oldtimer]
    mov [es:8*4], ax
    mov ax, [oldtimer+2]
    mov [es:8*4+2], ax
    mov ax, [oldkb]
    mov [es:9*4], ax
    mov ax, [oldkb+2]
    mov [es:9*4+2], ax
    mov al, 0x36
    out 0x43, al
    xor al, al
    out 0x40, al
    out 0x40, al
    sti

    mov ax, 0x0003
    int 0x10
    mov ax, 0x4C00
    int 0x21


start:
    call Set_Video_Mode
    call Set_Palette
    call Show_Intro
    call Show_Intro
    call Draw_Big_Moon

    xor ax, ax
    mov es, ax
    mov ax, [es:8*4]
    mov [oldtimer], ax
    mov ax, [es:8*4+2]
    mov [oldtimer+2], ax
    mov ax, [es:9*4]
    mov [oldkb], ax
    mov ax, [es:9*4+2]
    mov [oldkb+2], ax
    push cs
    pop es

    mov ax, task_scene
    mov bx, stack1_top
    mov di, taskSP + 2
    call Make_Task
    mov ax, task_game
    mov bx, stack2_top
    mov di, taskSP + 4
    call Make_Task

    call Draw_Scene
    call Draw_Score
    call Show_Title
    mov byte [state], 0

    xor ax, ax
    mov es, ax
    cli
    mov word [es:8*4], timer
    mov word [es:8*4+2], cs
    mov word [es:9*4], kbisr
    mov word [es:9*4+2], cs
    mov al, 0x36
    out 0x43, al
    mov al, 0x9C
    out 0x40, al
    mov al, 0x2E
    out 0x40, al
    sti
    push cs
    pop es


main_loop:
    call Music_Update
    cmp byte [esc_flag], 0
    je ml_noesc
    call Confirm_Exit
    jmp main_loop

ml_noesc:
    mov al, [state]
    cmp al, 1
    je ml_playing
    cmp al, 3
    je ml_over
    call Key_Poll
    cmp al, 13
    jne main_loop
    call Start_Game
    jmp main_loop

ml_playing:
    call Update_Score
    jmp main_loop

ml_over:
    call Show_Game_Over
    mov word [tempo], 20
    mov byte [state], 4
    jmp main_loop


stack1:     times 512 dw 0
stack1_top:
stack2:     times 512 dw 0
stack2_top: