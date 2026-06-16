INCLUDE Irvine32.inc
INCLUDELIB winmm.lib


; Windows API for key detection
GetAsyncKeyState PROTO, vKey:DWORD

; Windows API for sound
Beep PROTO,
    dwFreq:DWORD,
    dwDuration:DWORD

PlaySound PROTO,
    pszSound:PTR BYTE,
    hmod:DWORD,
    fdwSound:DWORD

VK_LEFT  = 41h    ; 'A' key
VK_RIGHT = 44h    ; 'D' key  
VK_JUMP  = 57h    ; 'W' key
VK_EXIT  = 58h    ; 'X' key
VK_PAUSE = 50h    ; 'P' key
VK_SHIFT = 10h    ; Shift key for shooting

.data

; for file handling
GENERIC_WRITE EQU 40000000h
FILE_SHARE_READ EQU 00000001h
OPEN_ALWAYS EQU 4
FILE_ATTRIBUTE_NORMAL EQU 00000080h
FILE_END EQU 2
INVALID_HANDLE_VALUE EQU -1

; file handling variables
fileName BYTE "mario_save.txt", 0
fileHandle DWORD ?
playerName BYTE 50 DUP(0)
namePrompt BYTE "ENTER YOUR NAME: ", 0
saveBuffer BYTE 200 DUP(0)
bytesWritten DWORD ?

; Sound constants
SND_FILENAME    EQU 00020000h
SND_ASYNC       EQU 00000001h
SND_LOOP        EQU 00000008h

; MUSIC FILES

musicFile       BYTE "C:\Users\Lenovo\Desktop\24I-0527\mariomusic", 0


ground BYTE "------------------------------------------------------------------------------------------------------------------------",0

score WORD 0

xPos BYTE 4
yPos BYTE 27

xPosOld BYTE 4
yPosOld BYTE 27

; GRAVITY VARIABLES:
yVelocity SBYTE 0        ; Vertical velocity (can be negative or positive)
gravity SBYTE 1          ; Gravity acceleration
jumpStrength SBYTE -4    ; Initial jump velocity (negative = upward)
isOnGround BYTE 1        ; 1 = on ground, 0 = in air
groundLevel BYTE 27      ; Y position where Mario stands

xCoinPos BYTE ?
yCoinPos BYTE ?

inputChar BYTE ?

menuState BYTE 0        ; 0 = main menu, 1 = instructions, 2 = game

;TITLE SCREEN VARIABLES:

titleLine1  BYTE "   _____ _    _ _____  ______ _____  ",0
titleLine2  BYTE "  / ____| |  | |  __ \|  ____|  __ \ ",0
titleLine3  BYTE " | (___ | |  | | |__) | |__  | |__) |",0
titleLine4  BYTE "  \___ \| |  | |  ___/|  __| |  _  / ",0
titleLine5  BYTE "  ____) | |__| | |    | |____| | \ \ ",0
titleLine6  BYTE " |_____/ \____/|_|    |______|_|  \_\",0
titleLine7  BYTE "                                      ",0

titleLine8  BYTE "  __  __          _____  _____ ____  ",0
titleLine9  BYTE " |  \/  |   /\   |  __ \|_   _/ __ \ ",0
titleLine10 BYTE " | \  / |  /  \  | |__) | | || |  | |",0
titleLine11 BYTE " | |\/| | / /\ \ |  _  /  | || |  | |",0
titleLine12 BYTE " | |  | |/ ____ \| | \ \ _| || |__| |",0
titleLine13 BYTE " |_|  |_/_/    \_\_|  \_\_____\____/ ",0
titleLine14 BYTE "                                      ",0

titleLine15 BYTE "  ____  _____   ____   _____         ",0
titleLine16 BYTE " |  _ \|  __ \ / __ \ / ____|        ",0
titleLine17 BYTE " | |_) | |__) | |  | | (___          ",0
titleLine18 BYTE " |  _ <|  _  /| |  | |\___ \         ",0
titleLine19 BYTE " | |_) | | \ \| |__| |____) |        ",0
titleLine20 BYTE " |____/|_|  \_\\____/|_____/         ",0


rollNumber BYTE "         ROLL NO: 24I-0527             ",0
pressKey BYTE "      Press Any Key to Start            ",0

; MENU VARIABLES:

menuTitleLine1 BYTE "  __  __          _____ _   _   __  __ ______ _   _ _    _ ",0
menuTitleLine2 BYTE " |  \/  |   /\   |_   _| \ | | |  \/  |  ____| \ | | |  | |",0
menuTitleLine3 BYTE " | \  / |  /  \    | | |  \| | | \  / | |__  |  \| | |  | |",0
menuTitleLine4 BYTE " | |\/| | / /\ \   | | | . ` | | |\/| |  __| | . ` | |  | |",0
menuTitleLine5 BYTE " | |  | |/ ____ \ _| |_| |\  | | |  | | |____| |\  | |__| |",0
menuTitleLine6 BYTE " |_|  |_/_/    \_\_____|_| \_| |_|  |_|______|_| \_|\____/ ",0

startLine1 BYTE "  ___ _____ _   ___ _____    ___   _   __  __ ___ ",0
startLine2 BYTE " / __|_   _/_\ | _ |_   _|  / __| /_\ |  \/  | __|",0
startLine3 BYTE " \__ \ | |/ _ \|   / | |   | (_ |/ _ \| |\/| | _| ",0
startLine4 BYTE " |___/ |_/_/ \_|_|_\ |_|    \___/_/ \_|_|  |_|___|",0

instructLine1 BYTE "  ___ _  _ ___ _____ ___ _   _  ___ _____ ___ ___  _  _ ___ ",0
instructLine2 BYTE " |   | \| / __|_   _| _ | | | |/ __|_   _|_ _/ _ \| \| / __|",0
instructLine3 BYTE " | | | .` \__ \ | | |   | |_| | (__  | |  | | (_) | .` \__ \",0
instructLine4 BYTE " |___|_|\_|___/ |_| |_|_\\___/ \___| |_| |___\___/|_|\_|___/",0

highLine1 BYTE "  _  _ ___ ___ _  _   ___  ___ ___  ___ ___ ",0
highLine2 BYTE " | || |_ _/ __| || | / __|/ __/ _ \| _ | __|",0
highLine3 BYTE " | __ || | (_ | __ | \__ | (_| (_) |   | _| ",0
highLine4 BYTE " |_||_|___\___|_||_| |___/\___\___/|_|_|___|",0

exitLine1 BYTE "  _____  _____ _____ ",0
exitLine2 BYTE " | __\ \/ |_ _|_   _|",0
exitLine3 BYTE " | _| >  < | |  | |  ",0
exitLine4 BYTE " |___/_/\_|___| |_|  ",0

pauseLine1 BYTE "  ____    _    __  __ _____   ____   _    _   _ ____  _____ ____  ",0
pauseLine2 BYTE " / ___|  / \  |  \/  | ____| |  _ \ / \  | | | / ___|| ____|  _ \ ",0
pauseLine3 BYTE "| |  _  / _ \ | |\/| |  _|   | |_) / _ \ | | | \___ \|  _| | | | |",0
pauseLine4 BYTE "| |_| |/ ___ \| |  | | |___  |  __/ ___ \| |_| |___) | |___| |_| |",0
pauseLine5 BYTE " \____/_/   \_\_|  |_|_____| |_| /_/   \_\\___/|____/|_____|____/ ",0
pauseLine6 BYTE "                                                                    ",0

resumeLine1 BYTE " ____  _____ ____  _   _ __  __ _____ ",0
resumeLine2 BYTE "|  _ \| ____/ ___|| | | |  \/  | ____|",0
resumeLine3 BYTE "| |_) |  _| \___ \| | | | |\/| |  _|  ",0
resumeLine4 BYTE "|  _ <| |___ ___) | |_| | |  | | |___ ",0

levelLine1 BYTE " _     _____ _   _ _____ _     ",0
levelLine2 BYTE "| |   | ____| | | | ____| |    ",0
levelLine3 BYTE "| |   |  _| | | | |  _| | |    ",0
levelLine4 BYTE "| |___| |___| |_| | |___| |___ ",0
levelLine5 BYTE "|_____|_____|\___/|_____|_____|",0

completeLine1 BYTE "  ____  ___  __  __ ____  _     _____ _____ _____ ",0
completeLine2 BYTE " / ___|/ _ \|  \/  |  _ \| |   | ____|_   _| ____|",0
completeLine3 BYTE "| |   | | | | |\/| | |_) | |   |  _|   | | |  _|  ",0
completeLine4 BYTE "| |___| |_| | |  | |  __/| |___| |___  | | | |___ ",0
completeLine5 BYTE " \____|\___/|_|  |_|_|   |_____|_____| |_| |_____|",0

gameOverLine1 BYTE "  ____    _    __  __ _____    _____     _______ ____  ",0
gameOverLine2 BYTE " / ___|  / \  |  \/  | ____|  / _ \ \   / / ____|  _ \ ",0
gameOverLine3 BYTE "| |  _  / _ \ | |\/| |  _|   | | | \ \ / /|  _| | |_) |",0
gameOverLine4 BYTE "| |_| |/ ___ \| |  | | |___  | |_| |\ V / | |___|  _ < ",0
gameOverLine5 BYTE " \____/_/   \_\_|  |_|_____|  \___/  \_/  |_____|_| \_\",0

pausePrompt BYTE "     Press 1 to Resume or 2 to Exit     ",0

menuPrompt BYTE "   Enter your choice (1-4): ",0
menuChoice BYTE ?

instructTitle BYTE "========== INSTRUCTIONS ==========",0
instruct1 BYTE "  W - Jump                         ",0
instruct2 BYTE "  A - Move Left                    ",0
instruct3 BYTE "  D - Move Right                   ",0
instruct4 BYTE "  X - Exit Game                    ",0
instructBack BYTE "  Press any key to return      ",0

highscoreTitle BYTE "========== HIGH SCORE ==========",0
highscoreText BYTE "  Current High Score: ",0
highscoreBack BYTE "  Press any key to return      ",0
highScore WORD 0

strMario BYTE "MARIO",0
strWorld BYTE "WORLD",0
strTime BYTE "TIME",0
strLives BYTE " x ",0

worldNum BYTE 1
levelNum BYTE 1
currentLevel BYTE 1         ; Track which level (1 or 2)
isPaused BYTE 0             ; 0 = not paused, 1 = paused

timeRemaining WORD 60         ; Starting time for level1 (60 seconds)
timerCounter WORD 0           ; Frame counter for 1second intervals
coins BYTE 0
lives BYTE 3

; HUD formatting
dashChar BYTE "-",0

; LEVEL MAP SYSTEM
LEVEL_WIDTH = 120        
LEVEL_HEIGHT = 30        

; Tile types
TILE_EMPTY EQU 0         ; background
TILE_GROUND EQU 1        ; Ground block
TILE_BRICK EQU 2         ; Solid brick block  
TILE_QUESTION EQU 3      ; Question block
TILE_COIN EQU 4          ; Collectible coin
TILE_CLOUD EQU 5         ; Decorative cloud
TILE_FLAGPOLE EQU 6      ; Flagpole
TILE_FLAG EQU 7          ; Flag on pole
TILE_GROUND_UNDERGROUND EQU 8    ; Brown/orange underground ground
TILE_LAVA EQU 9          ; Deadly lava
TILE_AXE EQU 10          ; Axe to defeat Bowser
TILE_CLOCK EQU 11        ; Time Slow power-up

levelMap BYTE LEVEL_WIDTH * LEVEL_HEIGHT DUP(0)

SKY_COLOR EQU lightCyan + (blue * 16)  

; GOOMBA ENEMY SYSTEM
MAX_GOOMBAS EQU 4

; Goomba structure: x, y, direction (1=right, -1=left), alive (1=yes, 0=no)
goombaX BYTE 4 DUP(0)           ; X positions
goombaY BYTE 4 DUP(0)              ; Y positions
goombaDir SBYTE 4 DUP(1)         ; Movement direction
goombaAlive BYTE 4 DUP(1)       ; Alive status
goombaOldX BYTE 4 DUP(0)          ; Previous X positions
goombaOldY BYTE 4 DUP(0)        ; Previous Y positions
goombaFrameCounter BYTE 0       ; Movement speed counter

; koopa enemy sysstem
koopaX BYTE 0                   ; X position
koopaY BYTE 0                   ; Y position
koopaDir SBYTE 1                ; Movement direction
koopaState BYTE 1               ; 1=walking, 0=shell
koopaOldX BYTE 0                ; Previous X
koopaOldY BYTE 0                ; Previous Y
koopaFrameCounter BYTE 0        ; Movement speed counter

; bowser enemy system
bowserX BYTE 0                  ; X position
bowserY BYTE 0                  ; Y position
bowserDir SBYTE 1               ; Movement direction (-1 left, 1 right)
bowserAlive BYTE 1              ; 1=alive, 0=dead
bowserOldX BYTE 0                 ; Previous X
bowserOldY BYTE 0               ; Previous Y
bowserFrameCounter BYTE 0         ; Movement speed


; bowser fireball system
fireballActive BYTE 0           ; 0=not active, 1=active
fireballX BYTE 0                ; Fireball X position
fireballY BYTE 0                ; Fireball Y position
fireballOldX BYTE 0             ; Previous X
fireballOldY BYTE 0             ; Previous Y
fireballCounter BYTE 0          ; Shoot timer

; mario firball system
marioFireballActive BYTE 0      ; 0=not active, 1=active
marioFireballX BYTE 0           ; Fireball X position
marioFireballY BYTE 0           ; Fireball Y position
marioFireballDir SBYTE 1        ; Direction (-1=left, 1=right)
marioFireballOldX BYTE 0        ; Previous X
marioFireballOldY BYTE 0        ; Previous Y
lastMoveDir SBYTE 1             ; Track Mario's last movement direction

; TIME SLOW POWER-UP SYSTEM for creative element marks
timeSlowActive BYTE 0           ; 0=inactive, 1=active
timeSlowDuration WORD 100       ; Duration in frames (100 frames = 5 seconds)
timeSlowCounter WORD 0          ; Current timer

.code

; ========================================
; SOUND EFFECTS using Beep
; ========================================

SoundJump PROC
    INVOKE Beep, 800, 50      ; Jump: 800Hz, 50ms
    ret
SoundJump ENDP

SoundCoin PROC
    INVOKE Beep, 1000, 80    
    ret
SoundCoin ENDP

SoundEnemy PROC
    INVOKE Beep, 600, 100     
    ret
SoundEnemy ENDP

SoundPowerUp PROC
    INVOKE Beep, 1200, 150    
    ret
SoundPowerUp ENDP

SoundDeath PROC
    INVOKE Beep, 400, 300     
    ret
SoundDeath ENDP


; ========================================
; Get Player Name
; ========================================

GetPlayerName PROC
    call Clrscr
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 50
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET namePrompt
    call WriteString
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 52
    mov dh, 14
    call Gotoxy
    
    mov edx, OFFSET playerName
    mov ecx, 40
    call ReadString
    
    mov eax, 500
    call Delay
    
    ret
GetPlayerName ENDP


; ========================================
; Save Game Data to File 
; ========================================

SaveToFile PROC
    pushad
    
    ; Clear buffer
    mov edi, OFFSET saveBuffer
    mov ecx, 200
    xor al, al
    rep stosb
    
    ; Build string in saveBuffer
    mov edi, OFFSET saveBuffer
    
    mov BYTE PTR [edi], 'P'
    inc edi
    mov BYTE PTR [edi], 'l'
    inc edi
    mov BYTE PTR [edi], 'a'
    inc edi
    mov BYTE PTR [edi], 'y'
    inc edi
    mov BYTE PTR [edi], 'e'
    inc edi
    mov BYTE PTR [edi], 'r'
    inc edi
    mov BYTE PTR [edi], ':'
    inc edi
    mov BYTE PTR [edi], ' '
    inc edi
    
    ; Copy player name
    mov esi, OFFSET playerName
cpName:
    lodsb
    cmp al, 0
    je nameDn
    stosb
    jmp cpName
nameDn:
    
    mov BYTE PTR [edi], ' '
    inc edi
    mov BYTE PTR [edi], '|'
    inc edi
    mov BYTE PTR [edi], ' '
    inc edi
    mov BYTE PTR [edi], 'S'
    inc edi
    mov BYTE PTR [edi], 'c'
    inc edi
    mov BYTE PTR [edi], 'o'
    inc edi
    mov BYTE PTR [edi], 'r'
    inc edi
    mov BYTE PTR [edi], 'e'
    inc edi
    mov BYTE PTR [edi], ':'
    inc edi
    mov BYTE PTR [edi], ' '
    inc edi
    
    ; Convert score
    movzx eax, score
    cmp eax, 0
    jne notZero
    mov BYTE PTR [edi], '0'
    inc edi
    jmp scoreDn
    
notZero:
    mov ebx, 10
    xor ecx, ecx
pushLoop:
    xor edx, edx
    div ebx
    push edx
    inc ecx
    cmp eax, 0
    jne pushLoop
    
popLoop:
    pop eax
    add al, '0'
    stosb
    dec ecx
    jnz popLoop
    
scoreDn:
  
    mov BYTE PTR [edi], ' '
    inc edi
    mov BYTE PTR [edi], '|'
    inc edi
    mov BYTE PTR [edi], ' '
    inc edi
    mov BYTE PTR [edi], 'L'
    inc edi
    mov BYTE PTR [edi], 'e'
    inc edi
    mov BYTE PTR [edi], 'v'
    inc edi
    mov BYTE PTR [edi], 'e'
    inc edi
    mov BYTE PTR [edi], 'l'
    inc edi
    mov BYTE PTR [edi], ':'
    inc edi
    mov BYTE PTR [edi], ' '
    inc edi
    
    movzx eax, currentLevel
    add al, '0'
    stosb
    
    mov BYTE PTR [edi], ' '
    inc edi
    mov BYTE PTR [edi], '|'
    inc edi
    mov BYTE PTR [edi], ' '
    inc edi
    mov BYTE PTR [edi], 'L'
    inc edi
    mov BYTE PTR [edi], 'i'
    inc edi
    mov BYTE PTR [edi], 'v'
    inc edi
    mov BYTE PTR [edi], 'e'
    inc edi
    mov BYTE PTR [edi], 's'
    inc edi
    mov BYTE PTR [edi], ':'
    inc edi
    mov BYTE PTR [edi], ' '
    inc edi
    
    movzx eax, lives
    add al, '0'
    stosb
    
    ; Newline
    mov BYTE PTR [edi], 13
    inc edi
    mov BYTE PTR [edi], 10
    inc edi
    
    ; NULL terminator is gud practice
    mov BYTE PTR [edi], 0
    
    ; Calculate length BEFORE opening file
    mov ebx, edi
    sub ebx, OFFSET saveBuffer
    ; EBX now has the length
    
    ; Create file
    mov edx, OFFSET fileName
    call CreateOutputFile
    jc failed
    mov fileHandle, eax
    
     
    mov ecx, ebx           
    mov edx, OFFSET saveBuffer
    call WriteToFile
    
    mov eax, fileHandle
    call CloseFile
    
failed:
    popad
    ret
SaveToFile ENDP


main PROC
	
    INVOKE PlaySound, 0, 0, 0                  
    INVOKE PlaySound, ADDR musicFile, 0, SND_FILENAME OR SND_ASYNC OR SND_LOOP

    call ShowTitleScreen
    call ShowMainMenu
    call GetPlayerName
    call Clrscr
    
    ; Set to level 1
    mov currentLevel, 1
    mov levelNum, 1

    ; Initialize Level 1
    call InitLevel1_1
    call InitGoombas
    call InitKoopa

   ; Initialize Bowser (only for Level 2 tho)
    call InitBowser
    
    ; Reset timer
    mov timeRemaining, 60
    mov timerCounter, 0

    call DrawSky
    call DrawHUD
    call DrawLevel
    call DrawPlayer
    call DrawGoombas
    call DrawKoopa
    call Randomize

gameLoop:
    ;  CHECK FOR PAUSE KEY 
    INVOKE GetAsyncKeyState, VK_PAUSE
    test ax, 8000h
    jz notPauseKey
    
    call ShowPauseMenu
    
notPauseKey:
    ; SAVE OLD POSITION FIRST 
    mov al, xPos
    mov xPosOld, al
    mov al, yPos
    mov yPosOld, al
    
    ; CHECK ALL KEYS USING GetAsyncKeyState 
    
    ; Check X 
    INVOKE GetAsyncKeyState, VK_EXIT
    test ax, 8000h
    jz notExitKey
    jmp exitGame
notExitKey:

    ; Check W 
    INVOKE GetAsyncKeyState, VK_JUMP
    test ax, 8000h
    jz notJumpKey
    cmp isOnGround, 1
    jne notJumpKey
    mov al, jumpStrength
    mov yVelocity, al
    call SoundJump
    mov isOnGround, 0
notJumpKey:

; Check Shift 
    cmp currentLevel, 1
    jne notShiftKey
    
    INVOKE GetAsyncKeyState, VK_SHIFT
    test ax, 8000h
    jz notShiftKey
    
    ; Only shoot if no active fireball
    cmp marioFireballActive, 1
    je notShiftKey
    
    ; Shoot fireball
    mov marioFireballActive, 1
    mov al, xPos
    mov marioFireballX, al
    mov al, yPos
    mov marioFireballY, al
    mov al, lastMoveDir
    mov marioFireballDir, al
    
notShiftKey:

    ; Check A 
    INVOKE GetAsyncKeyState, VK_LEFT
    test ax, 8000h
    jz notLeftKey
    
    mov al, xPos
    cmp al, 1
    jle notLeftKey
    
    ; Check collision on the left
    mov dl, xPos
    dec dl
    mov dh, yPos
    call CheckHorizontalCollision
    cmp al, 1
    je notLeftKey
    
    dec xPos
    mov lastMoveDir, -1        

notLeftKey:

    ; Check D 
    INVOKE GetAsyncKeyState, VK_RIGHT
    test ax, 8000h
    jz notRightKey
    
    mov al, xPos
    cmp al, 118
    jge notRightKey
    
    ; Check collision on the right
    mov dl, xPos
    inc dl
    mov dh, yPos
    call CheckHorizontalCollision
    cmp al, 1
    je notRightKey
    
    inc xPos
    mov lastMoveDir, 1         

notRightKey:

   
    call ApplyGravity
    call UpdateGoombas
    call UpdateKoopa
    call UpdateBowser
    call UpdateFireball
    call UpdateMarioFireball
    call UpdateTimeSlow
    
    ; CHECK MARIO-GOOMBA COLLISION 
    call CheckMarioGoombaCollision

    ; CHECK MARIO-KOOPA COLLISION 
    call CheckMarioKoopaCollision

    ; CHECK MARIO-FIREBALL COLLISION 
    call CheckMarioFireballCollision

    ; CHECK MARIO'S FIREBALL HITTING ENEMIES 
    call CheckFireballEnemyCollision

     ; CHECK QUESTION BLOCK COLLECTION 
    
    ; Check current position
    mov dl, xPos
    mov dh, yPos
    call GetTile

        cmp al, TILE_LAVA
    je marioTouchedLava

    cmp al, TILE_QUESTION
    je collectQuestionBlock
    
    ; Check left
    mov dl, xPos
    dec dl
    mov dh, yPos
    call GetTile
    cmp al, TILE_QUESTION
    je collectQuestionBlockLeft
    
    ; Check right
    mov dl, xPos
    inc dl
    mov dh, yPos
    call GetTile
    cmp al, TILE_QUESTION
    je collectQuestionBlockRight
    
    ; Check above
    mov dl, xPos
    mov dh, yPos
    dec dh
    call GetTile
    cmp al, TILE_QUESTION
    je collectQuestionBlockAbove
    
    ; Check below
    mov dl, xPos
    mov dh, yPos
    inc dh
    call GetTile
    cmp al, TILE_QUESTION
    je collectQuestionBlockBelow
    
    jmp noQuestionBlockCollected
    
collectQuestionBlock:
    mov dl, xPos
    mov dh, yPos
    jmp removeQuestionBlock
    
collectQuestionBlockLeft:
    mov dl, xPos
    dec dl
    mov dh, yPos
    jmp removeQuestionBlock
    
collectQuestionBlockRight:
    mov dl, xPos
    inc dl
    mov dh, yPos
    jmp removeQuestionBlock
    
collectQuestionBlockAbove:
    mov dl, xPos
    mov dh, yPos
    dec dh
    jmp removeQuestionBlock
    
collectQuestionBlockBelow:
    mov dl, xPos
    mov dh, yPos
    inc dh
    
removeQuestionBlock:
    ; Remove question block from map
    mov al, TILE_EMPTY
    call SetTile

     call SoundPowerUp
    
    ; Erase visually
    push edx
    call Gotoxy
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    pop edx
    
    ; Add 100 points for hitting question block
    mov ax, score
    add ax, 100
    mov score, ax
    
    ; Redraw HUD
    call DrawHUD
    
noQuestionBlockCollected:

        ;  CHECK WIN CONDITION 
    
    ; Level 1: Check flagpole
    cmp currentLevel, 1
    jne checkLevel2Win
    
    ;  LEVEL 1 FLAGPOLE CHECK 
    mov dl, xPos
    mov dh, yPos
    call GetTile
    cmp al, TILE_FLAGPOLE
    je touchedFlagpoleLevel1
    cmp al, TILE_FLAG
    je touchedFlagpoleLevel1
    
    mov dl, xPos
    dec dl
    mov dh, yPos
    call GetTile
    cmp al, TILE_FLAGPOLE
    je touchedFlagpoleLevel1
    cmp al, TILE_FLAG
    je touchedFlagpoleLevel1
    
    mov dl, xPos
    inc dl
    inc dl
    mov dh, yPos
    call GetTile
    cmp al, TILE_FLAGPOLE
    je touchedFlagpoleLevel1
    cmp al, TILE_FLAG
    je touchedFlagpoleLevel1
    
    jmp noWinTouch
    
touchedFlagpoleLevel1:
    mov ax, score
    cmp ax, 1500
    jge levelComplete
    jmp noWinTouch

checkLevel2Win:
    ;  LEVEL 2 AXE CHECK (only happens if currentLevel=2) 
    
    ; Double check we're in level 2
    cmp currentLevel, 2
    jne noWinTouch
    
    ; Check current position
    mov dl, xPos
    mov dh, yPos
    call GetTile
    cmp al, TILE_AXE
    je touchedAxeLevel2
    
    ; Check left
    mov dl, xPos
    dec dl
    mov dh, yPos
    call GetTile
    cmp al, TILE_AXE
    je touchedAxeLevel2
    
    ; Check right
    mov dl, xPos
    inc dl
    inc dl
    mov dh, yPos
    call GetTile
    cmp al, TILE_AXE
    je touchedAxeLevel2
    
    jmp noWinTouch

touchedAxeLevel2:
    ; Bowser is defeated!
    mov bowserAlive, 0
    jmp levelComplete
    
    
    levelComplete:
    call ShowLevelComplete
    
    ; Check if this was level 1
    cmp currentLevel, 1
    jne exitGame
    
    ; Level 2 setup
    mov currentLevel, 2
    mov levelNum, 2
    call Clrscr
    call InitLevel1_2
    call InitLevel2Enemies
    call InitBowser
    mov timeRemaining, 45
    mov timerCounter, 0
    mov xPos, 4
    mov yPos, 27
    mov yVelocity, 0
    call DrawUnderground
    call DrawHUD
    call DrawLevel
    call DrawPlayer
    call DrawGoombas
    call DrawKoopa
    jmp gameLoop

    noWinTouch:
    
noFlagpoleTouch:

    ; CHECK CLOCK POWER-UP COLLECTION (Level 1 only) 
    cmp currentLevel, 1
    jne noClockCheck
    
    ; Check current position
    mov dl, xPos
    mov dh, yPos
    call GetTile
    cmp al, TILE_CLOCK
    je collectClock
    
    ; Check left
    mov dl, xPos
    dec dl
    mov dh, yPos
    call GetTile
    cmp al, TILE_CLOCK
    je collectClockLeft
    
    ; Check right
    mov dl, xPos
    inc dl
    mov dh, yPos
    call GetTile
    cmp al, TILE_CLOCK
    je collectClockRight
    
    ; Check above
    mov dl, xPos
    mov dh, yPos
    dec dh
    call GetTile
    cmp al, TILE_CLOCK
    je collectClockAbove
    
    jmp noClockCheck

collectClock:
    mov dl, xPos
    mov dh, yPos
    jmp removeClock

collectClockLeft:
    mov dl, xPos
    dec dl
    mov dh, yPos
    jmp removeClock

collectClockRight:
    mov dl, xPos
    inc dl
    mov dh, yPos
    jmp removeClock

collectClockAbove:
    mov dl, xPos
    mov dh, yPos
    dec dh

removeClock:
    ; Remove clock from map
    mov al, TILE_EMPTY
    call SetTile

     call SoundPowerUp
    
    ; Erase visually
    push edx
    call Gotoxy
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    pop edx
    
    ; Activate time slow!
    mov timeSlowActive, 1
    mov timeSlowCounter, 100    ; 5 seconds (100 frames at 50ms)
    
    ; Add bonus points
    mov ax, score
    add ax, 500
    mov score, ax
    call DrawHUD

noClockCheck:

 ; === CHECK FOR LAVA COLLISION (Level 2 only) ===
    cmp currentLevel, 2
    jne noLavaTouch
    
    mov dl, xPos
    mov dh, yPos
    call GetTile
    cmp al, TILE_LAVA
    je marioTouchedLava
    
    ; Check tile below
    mov dl, xPos
    mov dh, yPos
    inc dh
    call GetTile
    cmp al, TILE_LAVA
    je marioTouchedLava
    
    jmp noLavaTouch

marioTouchedLava:

call SoundDeath

    ; FIRST: Erase Mario at current position
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    
    ; Erase with correct background for Level 2
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    
    ; THEN: Decrement lives
    dec lives
    
    ; Check if game over
    cmp lives, 0
    jne resetMarioFromLava
    call TimeUpGameOver
    exit
    
resetMarioFromLava:
    ; Reset Mario position
    mov xPos, 4
    mov yPos, 25
    mov yVelocity, 0
    
    ; Update HUD
    call DrawHUD
    
    ; Small delay
    mov eax, 500
    call Delay
    
    ; Redraw level
    call Clrscr
    call DrawUnderground
    call DrawHUD
    call DrawLevel
    call DrawPlayer
    
    jmp gameLoop


noLavaTouch:

    
    ;  CHECK COIN COLLECTION (check all 4 adjacent tiles) 
    
    ; Check current position
    mov dl, xPos
    mov dh, yPos
    call GetTile
    cmp al, TILE_COIN
    je collectCoin
    
    ; Check left
    mov dl, xPos
    dec dl
    mov dh, yPos
    call GetTile
    cmp al, TILE_COIN
    je collectCoinLeft
    
    ; Check right
    mov dl, xPos
    inc dl
    mov dh, yPos
    call GetTile
    cmp al, TILE_COIN
    je collectCoinRight
    
    ; Check above
    mov dl, xPos
    mov dh, yPos
    dec dh
    call GetTile
    cmp al, TILE_COIN
    je collectCoinAbove
    
    ; Check below
    mov dl, xPos
    mov dh, yPos
    inc dh
    call GetTile
    cmp al, TILE_COIN
    je collectCoinBelow
    
    jmp noCoinCollected
    
collectCoin:
    mov dl, xPos
    mov dh, yPos
    jmp removeCoin
    
collectCoinLeft:
    mov dl, xPos
    dec dl
    mov dh, yPos
    jmp removeCoin
    
collectCoinRight:
    mov dl, xPos
    inc dl
    mov dh, yPos
    jmp removeCoin
    
collectCoinAbove:
    mov dl, xPos
    mov dh, yPos
    dec dh
    jmp removeCoin
    
collectCoinBelow:
    mov dl, xPos
    mov dh, yPos
    inc dh
    
removeCoin:
    ; Remove coin from map
    mov al, TILE_EMPTY
    call SetTile
    
    ; Erase coin visually with correct background
    push edx
    call Gotoxy
    
    ; Check level for correct background
    cmp currentLevel, 2
    je eraseCoinBlack
    
    ; Level 1 - blue background
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    jmp eraseCoinNow
    
eraseCoinBlack:
    ; Level 2 - black background
    mov eax, lightGray + (black * 16)
    call SetTextColor
    
eraseCoinNow:
    mov al, ' '
    call WriteChar
    pop edx

    
    ; Update coins counter
    mov al, coins
    inc al
    mov coins, al
    
    ; Add 200 points to score
    mov ax, score
    add ax, 200
    mov score, ax
    
    ; Redraw HUD
    call DrawHUD

    call SoundCoin
    
noCoinCollected:

    
    ;  NOW ERASE OLD AND DRAW NEW 
    call UpdatePlayer
    
    ; Redraw any tiles that Mario erased
    mov dl, xPosOld
    mov dh, yPosOld
    call GetTile
    cmp al, TILE_EMPTY
    je redrawSky
    
    ; Redraw the tile Mario was on
    push eax
    mov dl, xPosOld
    mov dh, yPosOld
    call Gotoxy
    pop eax
    
    cmp al, TILE_GROUND
    je redrawGround2
    cmp al, TILE_GROUND_UNDERGROUND    
    je redrawGroundUnderground2        
    cmp al, TILE_BRICK
    je redrawBrick2
    cmp al, TILE_QUESTION
    je redrawQuestion2
    cmp al, TILE_COIN
    je redrawCoin2
    cmp al, TILE_CLOUD
    je redrawCloud2
    jmp redrawSky
    
redrawGround2:
    mov eax, green + (black * 16)
    call SetTextColor
    mov al, 219
    call WriteChar
    jmp noTileToRedraw
    
    redrawGroundUnderground2:
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov al, 178
    call WriteChar
    jmp noTileToRedraw

redrawBrick2:
    ; Check level for brick color
    cmp currentLevel, 2
    je redrawBrickCastle
    
    ; Level 1 - green
    mov eax, green + (black * 16)
    call SetTextColor
    jmp redrawBrickChar2
    
redrawBrickCastle:
    ; Level 2 - gray castle
    mov eax, lightGray + (black * 16)
    call SetTextColor
    
redrawBrickChar2:
    mov al, 219
    call WriteChar
    jmp noTileToRedraw

    
redrawQuestion2:
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mov al, '?'
    call WriteChar
    jmp noTileToRedraw

redrawCoin2:
    ; Check level
    cmp currentLevel, 2
    je redrawCoinUnderground
    
    ; Level 1 - yellow on blue
    mov eax, yellow + (blue * 16)
    call SetTextColor
    jmp redrawCoinChar
    
redrawCoinUnderground:
    ; Level 2 - yellow on black
    mov eax, yellow + (black * 16)
    call SetTextColor
    
redrawCoinChar:
    mov al, 'O'
    call WriteChar
    jmp noTileToRedraw


redrawCloud2:
    mov eax, white + (blue * 16)
    call SetTextColor
    mov al, 176
    call WriteChar
    jmp noTileToRedraw

redrawSky:
    ; Redraw background where Mario was
    cmp currentLevel, 2
    je redrawUndergroundBG
    
    ; Level 1 - blue sky
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    jmp redrawBGContinue
    
redrawUndergroundBG:
    ; Level 2 - black background
    mov eax, lightGray + (black * 16)
    call SetTextColor
    
redrawBGContinue:
    mov dl, xPosOld
    mov dh, yPosOld
    call Gotoxy
    mov al, ' '
    call WriteChar

    
noTileToRedraw:
    
    ; Draw Mario
    call DrawPlayer
    
    ; Draw Goombas
    call DrawGoombas

    ; Draw Koopa
    call DrawKoopa

      ; Draw Bowser
    call DrawBowser

    ; Draw Fireball
    call DrawFireball

    ; Draw Mario's Fireball
    call DrawMarioFireball
    
    ;  UPDATE TIMER 
    call UpdateTimer
    
    ;  DELAY 
    mov eax, 50
    call Delay
    
    jmp gameLoop

    exitGame:
    ; Update high score
    mov ax, score
    cmp ax, highScore
    jle skipUpdate
    mov highScore, ax
    
skipUpdate:

    ; Save to file
    call SaveToFile
   
    exit
main ENDP


DrawPlayer PROC
    push eax
    
    ; Check level for background color
    cmp currentLevel, 2
    je drawMarioUnderground
    
    ; Level 1 - green on blue
    mov eax, lightGreen + (blue * 16)
    call SetTextColor
    jmp drawMarioChar
    
drawMarioUnderground:
    ; Level 2 - green on black
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    
drawMarioChar:
    ; Move to position
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    
    ; Draw Mario
    mov al, "M"
    call WriteChar
    
    ; Reset color
    mov eax, white + (black * 16)
    call SetTextColor
    
    pop eax
    ret
DrawPlayer ENDP


UpdatePlayer PROC
    push eax
    
    ; Check which level for background color
    cmp currentLevel, 2
    je eraseUnderground
    
    ; Level 1 - erase with blue sky
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    jmp eraseOldPos
    
eraseUnderground:
    ; Level 2 - erase with black background
    mov eax, lightGray + (black * 16)
    call SetTextColor
    
eraseOldPos:
    ; Erase at OLD position
    mov dl, xPosOld
    mov dh, yPosOld
    call Gotoxy
    
    mov al, " "
    call WriteChar
    
    ; Reset color
    mov eax, white + (black * 16)
    call SetTextColor
    
    pop eax
    ret
UpdatePlayer ENDP


ApplyGravity PROC
    push ebx
    push ecx
    push edx
    
    ;  CHECK IF STANDING STILL ON GROUND 
    mov al, yVelocity
    cmp al, 0
    jne mustApplyPhysics
    
    ; Velocity is 0, check if on ground
    mov dl, xPos
    mov dh, yPos
    inc dh
    call CheckCollision
    cmp al, 1
    je stayOnGround
    
mustApplyPhysics:
    ;  APPLY GRAVITY 
    mov al, yVelocity
    add al, gravity
    
    ; Clamp to max fall speed
    cmp al, 10
    jle noClampFall
    mov al, 10
noClampFall:
    mov yVelocity, al
    
    ; Calculate new position
    movsx ax, yVelocity
    movzx bx, yPos
    add bx, ax
    
    ; Clamp to screen bounds
    cmp bx, 3
    jge notAboveScreen
    mov bx, 3
    mov yVelocity, 0
notAboveScreen:
    
    cmp bx, 29
    jle notBelowScreen
    mov bx, 29
notBelowScreen:
    
    ; CHECK COLLISION DURING MOVEMENT 
    ; Check if falling (positive velocity)
    cmp yVelocity, 0
    jle movingUpward
    
    ; FALLING DOWN , check each row between old and new position
    movzx cx, yPos
    
checkFallLoop:
    cmp cx, bx
    jg doneChecking
    
    ; Check tile below this position
    mov dl, xPos
    mov dh, cl
    inc dh
    call CheckCollision
    cmp al, 1
    je foundGroundWhileFalling
    
    inc cx
    jmp checkFallLoop
    
foundGroundWhileFalling:
    ; Stop exactly at this position (on top of the tile)
    mov yPos, cl
    mov yVelocity, 0
    mov isOnGround, 1
    jmp gravityDone
    
doneChecking:
    ; No collision found, update to new position
    mov yPos, bl
    mov isOnGround, 0
    jmp gravityDone
    
movingUpward:
    ; JUMPING UP - just update position
    mov yPos, bl
    mov isOnGround, 0
    jmp gravityDone
    
stayOnGround:
    mov yVelocity, 0
    mov isOnGround, 1
    
gravityDone:
    pop edx
    pop ecx
    pop ebx
    ret
ApplyGravity ENDP

; ========================================
; Update the game timer (counts down)
; ========================================

UpdateTimer PROC
    push eax
    push edx
    
    ; Increment frame counter
    mov ax, timerCounter
    inc ax
    mov timerCounter, ax
    
    ; Check if 1 second has passed (20 frames = 1 second at 50ms delay)
    cmp ax, 20
    jl timerDone
    
    ; Reset frame counter
    mov timerCounter, 0
    
    ; Decrease time remaining
    mov ax, timeRemaining
    cmp ax, 0
    je timerDone              ; Already at 0
    
    dec ax
    mov timeRemaining, ax
    
    ; Update HUD to show new time
    call DrawHUD
    
    ; Check if time ran out
    cmp ax, 0
    jne timerDone
    
    ; TIME'S UP! - Game Over
    call TimeUpGameOver
    
timerDone:
    pop edx
    pop eax
    ret
UpdateTimer ENDP

; ========================================
; Handle Time's Up / Game Over
; ========================================

TimeUpGameOver PROC
    push eax
    push edx
    
    ; Clear screen
    call Clrscr
    
    ;  BIG "GAME OVER" ASCII ART 
    mov eax, white + (black * 16)
    call SetTextColor
    
    ; Line 1
    mov dl, 32
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET gameOverLine1
    call WriteString
    
    ; Line 2
    mov dl, 32
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET gameOverLine2
    call WriteString
    
    ; Line 3
    mov dl, 32
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET gameOverLine3
    call WriteString
    
    ; Line 4
    mov dl, 32
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET gameOverLine4
    call WriteString
    
    ; Line 5
    mov dl, 32
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET gameOverLine5
    call WriteString
    
    ; Display Final Score 
    mov eax, white + (black * 16)
    call SetTextColor
    
    mov dl, 49
    mov dh, 13
    call Gotoxy
    mov al, 'F'
    call WriteChar
    mov al, 'i'
    call WriteChar
    mov al, 'n'
    call WriteChar
    mov al, 'a'
    call WriteChar
    mov al, 'l'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'S'
    call WriteChar
    mov al, 'c'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, 'r'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, ':'
    call WriteChar
    mov al, ' '
    call WriteChar
    
    movzx eax, score
    call WriteDec
    
    ; Wait 3 seconds
    mov eax, 3000
    call Delay
    
    ; Update high score if needed
    mov ax, score
    cmp ax, highScore
    jle skipHighScoreUpdate
    mov highScore, ax
    
skipHighScoreUpdate:
    pop edx
    pop eax
    
    ; Exit program
    exit
TimeUpGameOver ENDP



; ========================================
; Show Level Complete Screen
; ========================================

ShowLevelComplete PROC
    ; Calculate time bonus and add to score
    movzx eax, timeRemaining
    mov ebx, 50
    mul ebx
    add score, ax
    
    ; Clear screen
    call Clrscr
    
    ; BIG "LEVEL" ASCII ART 
    mov eax, white + (black * 16)
    call SetTextColor
    
    ; Line 1
    mov dl, 44
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET levelLine1
    call WriteString
    
    ; Line 2
    mov dl, 44
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET levelLine2
    call WriteString
    
    ; Line 3
    mov dl, 44
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET levelLine3
    call WriteString
    
    ; Line 4
    mov dl, 44
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET levelLine4
    call WriteString
    
    ; Line 5
    mov dl, 44
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET levelLine5
    call WriteString
    
    ;BIG "COMPLETE" ASCII ART 
    mov eax, white + (black * 16)
    call SetTextColor
    
    ; Line 1
    mov dl, 35
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET completeLine1
    call WriteString
    
    ; Line 2
    mov dl, 35
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET completeLine2
    call WriteString
    
    ; Line 3
    mov dl, 35
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET completeLine3
    call WriteString
    
    ; Line 4
    mov dl, 35
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET completeLine4
    call WriteString
    
    ; Line 5
    mov dl, 35
    mov dh, 16
    call Gotoxy
    mov edx, OFFSET completeLine5
    call WriteString
    
    ;  Display Score 
    mov eax, white + (black * 16)
    call SetTextColor
    
    mov dl, 53
    mov dh, 19
    call Gotoxy
    mov al, 'S'
    call WriteChar
    mov al, 'c'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, 'r'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, ':'
    call WriteChar
    mov al, ' '
    call WriteChar
    
    movzx eax, score
    call WriteDec
    
    ; Wait 3 seconds
    mov eax, 3000
    call Delay
    
    ; Update high score
    mov ax, score
    cmp ax, highScore
    jle doneComplete
    mov highScore, ax
    
doneComplete:
    ret
ShowLevelComplete ENDP


; ========================================
; Show Pause Menu
; ========================================

ShowPauseMenu PROC
    push eax
    push edx
    
    ; Set paused state
    mov isPaused, 1
    
       ; Clear screen to black
    call Clrscr
    
    ; GAME PAUSED displayy 
    
    mov eax, black + (white * 16)
    call SetTextColor
    
    ; Line 1
    mov dl, 27
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET pauseLine1
    call WriteString
    
    ; Line 2
    mov dl, 27
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET pauseLine2
    call WriteString
    
    ; Line 3
    mov dl, 27
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET pauseLine3
    call WriteString
    
    ; Line 4
    mov dl, 27
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET pauseLine4
    call WriteString
    
    ; Line 5
    mov dl, 27
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET pauseLine5
    call WriteString
    
    ;  RESUME OPTION 
    
    mov eax, black + (white * 16)
    call SetTextColor
    
    mov dl, 42
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET resumeLine1
    call WriteString
    
    mov dl, 42
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET resumeLine2
    call WriteString
    
    mov dl, 42
    mov dh, 16
    call Gotoxy
    mov edx, OFFSET resumeLine3
    call WriteString
    
    mov dl, 42
    mov dh, 17
    call Gotoxy
    mov edx, OFFSET resumeLine4
    call WriteString
    
    ;  EXIT OPTION 
    
    mov eax, black + (white * 16)
    call SetTextColor
    
    mov dl, 50
    mov dh, 19
    call Gotoxy
    mov edx, OFFSET exitLine1
    call WriteString
    
    mov dl, 50
    mov dh, 20
    call Gotoxy
    mov edx, OFFSET exitLine2
    call WriteString
    
    mov dl, 50
    mov dh, 21
    call Gotoxy
    mov edx, OFFSET exitLine3
    call WriteString
    
    mov dl, 50
    mov dh, 22
    call Gotoxy
    mov edx, OFFSET exitLine4
    call WriteString
    
    ; Instruction
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 40
    mov dh, 25
    call Gotoxy
    mov edx, OFFSET pausePrompt
    call WriteString

    
    ; Wait for input
pauseMenuLoop:
    ; Check for 1 (Resume)
    INVOKE GetAsyncKeyState, 31h
    test ax, 8000h
    jnz resumeGame
    
    ; Check for 2 (Exit)
    INVOKE GetAsyncKeyState, 32h
    test ax, 8000h
    jnz exitFromPause
    
    mov eax, 50
    call Delay
    jmp pauseMenuLoop
    
resumeGame:
    mov isPaused, 0
    call Clrscr
    
    cmp currentLevel, 2
    je redrawLevel2Pause
    call DrawSky
    jmp continuePauseRedraw
    
redrawLevel2Pause:
    call DrawUnderground
    
continuePauseRedraw:
    call DrawHUD
    call DrawLevel
    call DrawPlayer
    call DrawGoombas
    call DrawKoopa
    
    mov eax, 200
    call Delay
    
    pop edx
    pop eax
    ret
    
exitFromPause:
    pop edx
    pop eax
    exit
    
ShowPauseMenu ENDP

; ========================================
; Initialize Goombas for Level 1-1
; ========================================

InitGoombas PROC
    push eax
    push ebx
    
    ; Goomba 0: On ground at x=30
    mov goombaX[0], 30
    mov goombaY[0], 27
    mov goombaDir[0], 1
    mov goombaAlive[0], 1
    
    ; Goomba 1: On ground at x=70
    mov goombaX[1], 70
    mov goombaY[1], 27
    mov goombaDir[1], -1
    mov goombaAlive[1], 1
    
    ; Goomba 2: On platform at x=22 (first platform at y=24)
    mov goombaX[2], 22
    mov goombaY[2], 23
    mov goombaDir[2], 1
    mov goombaAlive[2], 1
    
    ; Goomba 3: On platform at x=87 (platform at y=20)
    mov goombaX[3], 87
    mov goombaY[3], 19
    mov goombaDir[3], -1
    mov goombaAlive[3], 1
    
    pop ebx
    pop eax
    ret
InitGoombas ENDP

; ========================================
; Initialize Koopa Troopa
; ========================================

InitKoopa PROC
    push eax
    
    ; Place Koopa on rightmost platform (x=96, y=17)
    ; Platform at x=95, y=18, so Koopa stands on top at y=17
    mov koopaX, 96
    mov koopaY, 17
    mov koopaDir, 1
    mov koopaState, 1           ; Walking state
    
    pop eax
    ret
InitKoopa ENDP

; ========================================
; Initialise Bowser Boss
; ========================================

InitBowser PROC
    push eax
    
    ; Place Bowser on final platform (x=105, y=26)
    mov bowserX, 105
    mov bowserY, 26
    mov bowserDir, -1           ; Start moving left
    mov bowserAlive, 1
    mov bowserFrameCounter, 0
    
    pop eax
    ret
InitBowser ENDP


; ========================================
; Initialise Enemies for Level 2 
; ========================================
InitLevel2Enemies PROC
    push eax
    push ebx
    
    ; Set all Goombas to dead (not alive)
    mov goombaAlive[0], 0
    mov goombaAlive[1], 0
    mov goombaAlive[2], 0
    mov goombaAlive[3], 0
    
    ; Set Koopa to dead (not alive)
    mov koopaState, 0
    
    ; Position them off-screen so they don't interfere
    mov goombaX[0], 200
    mov goombaX[1], 200
    mov goombaX[2], 200
    mov goombaX[3], 200
    
    mov koopaX, 200
    
    pop ebx
    pop eax
    ret
InitLevel2Enemies ENDP

; ========================================
; Update all Goombas 
; ========================================

UpdateGoombas PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Increment frame counter
    mov al, goombaFrameCounter
    inc al
    mov goombaFrameCounter, al
    
     ; Check if time slow is active
    mov cl, 2                   ; Normal speed
    cmp timeSlowActive, 1
    jne normalGoombaSpeed
    mov cl, 4                   ; Slowed down 2x slower
    
normalGoombaSpeed:
    cmp al, cl
    jl skipAllGoombas

    
    ; Reset counter
    mov goombaFrameCounter, 0
    
    ; Now update all Goombas
    xor ebx, ebx
    mov cl, MAX_GOOMBAS
    
updateGoombaLoop:
    ; Check if this Goomba is alive
    cmp goombaAlive[ebx], 0
    je skipThisGoomba
    
    ; Save old position
    mov al, goombaX[ebx]
    mov goombaOldX[ebx], al
    mov al, goombaY[ebx]
    mov goombaOldY[ebx], al
    
    ; Move Goomba
    push ebx
    push ecx
    call MoveOneGoomba
    pop ecx
    pop ebx
    
skipThisGoomba:
    inc ebx
    dec cl
    jnz updateGoombaLoop
    
skipAllGoombas:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
UpdateGoombas ENDP


; ========================================
; Move a single Goomba
; ========================================

MoveOneGoomba PROC
    push eax
    push ecx
    push edx
    
    ; Calculate new X position
    mov al, goombaX[ebx]
    movsx cx, goombaDir[ebx]
    add al, cl
    
    ; Check screen boundaries
    cmp al, 1
    jle turnAround
    cmp al, 118
    jge turnAround
    
    ; Check collision at NEW position (where goomba wants to move)
    mov dl, al                  ; New X position
    mov dh, goombaY[ebx]        ; Current Y position
    push eax
    push ebx
    call CheckCollision
    pop ebx
    cmp al, 1                   ; to check if there is a solid block
    pop eax
    je turnAround               ; turn around if there is one
    
    ; Check if ground exists below NEW position but don't walk off platform
    mov dl, goombaX[ebx]
    movsx cx, goombaDir[ebx]
    add dl, cl                  ; New X position
    mov dh, goombaY[ebx]
    inc dh                      ; Check tile below
    
    push eax
    push ebx
    call CheckCollision
    pop ebx
    cmp al, 0                   ; No ground 
    pop eax
    je turnAround               ; Turn around at edge
    
    ; Valid move - update position
    mov al, goombaX[ebx]
    movsx cx, goombaDir[ebx]
    add al, cl
    mov goombaX[ebx], al
    jmp moveDone
    
turnAround:
    ; Reverse direction
    mov al, goombaDir[ebx]
    neg al
    mov goombaDir[ebx], al
    
moveDone:
    pop edx
    pop ecx
    pop eax
    ret
MoveOneGoomba ENDP


; ========================================
; Update Koopa Troopa
; ========================================

UpdateKoopa PROC
    push eax
    push ecx
    push edx
    
    ; Increment frame counter
    mov al, koopaFrameCounter
    inc al
    mov koopaFrameCounter, al
    
       ; Check if time slow is active
    mov cl, 1                   ; Normal speed
    cmp timeSlowActive, 1
    jne normalKoopaSpeed
    mov cl, 3                   ; Slowed down
    
normalKoopaSpeed:
    cmp al, cl
    jl skipKoopaMove

    
    ; Reset counter
    mov koopaFrameCounter, 0
    
    ; Only move if in walking state
    cmp koopaState, 0
    je koopaIsShell
    
    ; Save old position
    mov al, koopaX
    mov koopaOldX, al
    mov al, koopaY
    mov koopaOldY, al
    
    ; Calculate new X position
    mov al, koopaX
    movsx cx, koopaDir
    add al, cl
    
    ; Check boundaries
    cmp al, 1
    jle koopaReverse
    cmp al, 118
    jge koopaReverse
    
    ; Check collision ahead
    mov dl, al
    mov dh, koopaY
    push eax
    call CheckCollision
    cmp al, 1
    pop eax
    je koopaReverse
    
    ; Check ground below
    mov dl, koopaX
    movsx cx, koopaDir
    add dl, cl
    mov dh, koopaY
    inc dh
    push eax
    call CheckCollision
    cmp al, 0
    pop eax
    je koopaReverse
    
    ; Valid move
    mov al, koopaX
    movsx cx, koopaDir
    add al, cl
    mov koopaX, al
    jmp skipKoopaMove
    
koopaReverse:
    mov al, koopaDir
    neg al
    mov koopaDir, al
    jmp skipKoopaMove
    
koopaIsShell:
    ; Shell doesn't move on its own
    
skipKoopaMove:
    pop edx
    pop ecx
    pop eax
    ret
UpdateKoopa ENDP

; ========================================
; Update Bowser Movement and Attacks
; ========================================

UpdateBowser PROC
    push eax
    push ecx
    push edx
    
    ; Only update if alive
    cmp bowserAlive, 0
    je skipBowserUpdate
    
    ; Only update if in Level 2
    cmp currentLevel, 2
    jne skipBowserUpdate
    
    ; Increment frame counter
    mov al, bowserFrameCounter
    inc al
    mov bowserFrameCounter, al
    
    ; Move every 5 frames
    cmp al, 5
    jl skipBowserMove
    
    ; Reset counter
    mov bowserFrameCounter, 0
    
    ; Save old position
    mov al, bowserX
    mov bowserOldX, al
    mov al, bowserY
    mov bowserOldY, al
    
    ; Calculate new X position
    mov al, bowserX
    movsx cx, bowserDir
    add al, cl
    
    ; Check platform boundaries x=95 to x=110
    cmp al, 95
    jle bowserReverse
    cmp al, 110
    jge bowserReverse
    
    ; Valid move
    mov bowserX, al
    jmp skipBowserMove
    
bowserReverse:
    ; Turn around at platform edge
    mov al, bowserDir
    neg al
    mov bowserDir, al
    
skipBowserMove:
    
    ;  FIREBALL SHOOTING LOGIC 
    
    ; Increment shoot timer
    mov al, fireballCounter
    inc al
    mov fireballCounter, al
    
    ; Shoot fireball every 60 frames when moving LEFT
    cmp al, 60
    jl skipBowserUpdate
    
    ; Reset shoot counter
    mov fireballCounter, 0
    
    ; Only shoot when moving left towards Mario
    cmp bowserDir, -1
    jne skipBowserUpdate
    
    ; Only shoot if no active fireball
    cmp fireballActive, 1
    je skipBowserUpdate
    
    ; Shoot fireball!
    mov fireballActive, 1
    mov al, bowserX
    sub al, 2               ; Spawn 2 blocks to the left
    mov fireballX, al
    mov al, bowserY
    mov fireballY, al
    
skipBowserUpdate:
    pop edx
    pop ecx
    pop eax
    ret
UpdateBowser ENDP

; ========================================
; Update Bowser's Fireball
; ========================================

UpdateFireball PROC
    push eax
    push edx
    
    ; Only update if active
    cmp fireballActive, 0
    je skipFireballUpdate
    
    ; Only in Level 2
    cmp currentLevel, 2
    jne skipFireballUpdate
    
    ; Save old position
    mov al, fireballX
    mov fireballOldX, al
    mov al, fireballY
    mov fireballOldY, al
    
    ; Calculate new position (move left)
    mov al, fireballX
    sub al, 2               ; Move 2 pixels left per frame
    
    ; Check if off screen (left edge)
    cmp al, 0
    jle deactivateFireball
    
    ; Check collision with solid tiles
    mov dl, al              ; New X position
    mov dh, fireballY
    push eax
    call GetTile
    
    ; Check if hit a solid tile (brick, ground, platform)
    cmp al, TILE_BRICK
    je hitSolidTile
    cmp al, TILE_GROUND
    je hitSolidTile
    cmp al, TILE_GROUND_UNDERGROUND
    je hitSolidTile
    
    ; No collision, update position
    pop eax
    mov fireballX, al
    jmp skipFireballUpdate
    
hitSolidTile:
    pop eax
    
deactivateFireball:
    mov fireballActive, 0
    
    ; Erase fireball at old position
    mov dl, fireballOldX
    mov dh, fireballOldY
    call Gotoxy
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    
skipFireballUpdate:
    pop edx
    pop eax
    ret
UpdateFireball ENDP

; ========================================
; Update Mario's Fireball
; ========================================

UpdateMarioFireball PROC
    push eax
    push edx
    
    ; Only update if active
    cmp marioFireballActive, 0
    je skipMarioFireballUpdate
    
    ; Only in Level 1
    cmp currentLevel, 1
    jne skipMarioFireballUpdate
    
    ; Save old position
    mov al, marioFireballX
    mov marioFireballOldX, al
    mov al, marioFireballY
    mov marioFireballOldY, al
    
    ; Move fireball in direction
    mov al, marioFireballX
    movsx cx, marioFireballDir
    add al, cl
    add al, cl              ; Move 2 pixels per frame
    
    ; Check if off screen
    cmp al, 0
    jle deactivateMarioFireball
    cmp al, 119
    jge deactivateMarioFireball
    
    ; Check collision with solid tiles
    mov dl, al              ; New X position
    mov dh, marioFireballY
    push eax
    call GetTile
    
    ; Check if hit a solid tile
    cmp al, TILE_BRICK
    je hitSolidTileMario
    cmp al, TILE_GROUND
    je hitSolidTileMario
    
    ; No collision, update position
    pop eax
    mov marioFireballX, al
    jmp skipMarioFireballUpdate
    
hitSolidTileMario:
    pop eax
    
deactivateMarioFireball:
    mov marioFireballActive, 0
    
    ; Erase fireball at old position
    mov dl, marioFireballOldX
    mov dh, marioFireballOldY
    call Gotoxy
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    
skipMarioFireballUpdate:
    pop edx
    pop eax
    ret
UpdateMarioFireball ENDP

; ========================================
; Update Time Slow Power-Up
; ========================================

UpdateTimeSlow PROC
    push eax
    
    ; Only in Level 1
    cmp currentLevel, 1
    jne skipTimeSlowUpdate
    
    ; Check if active
    cmp timeSlowActive, 0
    je skipTimeSlowUpdate
    
    ; Decrement counter
    mov ax, timeSlowCounter
    dec ax
    mov timeSlowCounter, ax
    
    ; Check if expired
    cmp ax, 0
    jg skipTimeSlowUpdate
    
    ; Deactivate
    mov timeSlowActive, 0
    
skipTimeSlowUpdate:
    pop eax
    ret
UpdateTimeSlow ENDP

; ========================================
; Draw all Goombas
; ========================================

DrawGoombas PROC
    push eax
    push ebx
    push ecx
    push edx
    
    xor ebx, ebx
    mov cl, MAX_GOOMBAS
    
drawGoombaLoop:
    ; Check if alive
    cmp goombaAlive[ebx], 0
    je skipThisGoomba
    
    ; Draw this goomba
    push ebx
    push ecx
    call DrawOneGoomba
    pop ecx
    pop ebx
    
skipThisGoomba:
    inc ebx
    dec cl
    jnz drawGoombaLoop
    
    ; Reset color
    mov eax, white + (blue * 16)
    call SetTextColor
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawGoombas ENDP

; ========================================
; Draw a single Goomba
; ========================================

DrawOneGoomba PROC
    push eax
    push ebx
    push edx
    
    ; Erase old position
    mov dl, goombaOldX[ebx]
    mov dh, goombaOldY[ebx]
    call Gotoxy
    
    ; Check what tile was there
    push ebx
    call GetTile
    pop ebx
    
    cmp al, TILE_EMPTY
    je eraseWithSky
    cmp al, TILE_CLOUD
    je eraseWithCloud
    cmp al, TILE_GROUND
    je eraseWithGround
    cmp al, TILE_BRICK
    je eraseWithBrick
    jmp drawNew
    
eraseWithGround:
    mov eax, green + (blue * 16)
    call SetTextColor
    mov al, 219
    call WriteChar
    jmp drawNew
    
eraseWithBrick:
    mov eax, green + (blue * 16)
    call SetTextColor
    mov al, 219
    call WriteChar
    jmp drawNew
    
eraseWithCloud:
    mov eax, white + (blue * 16)
    call SetTextColor
    mov al, 176
    call WriteChar
    jmp drawNew
    
eraseWithSky:
    ; Check which level for correct background color
    cmp currentLevel, 2
    je eraseWithBlack
    
    ; Level 1 - blue sky
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    jmp drawNew
    
eraseWithBlack:
    ; Level 2 - black underground
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar

    
drawNew:
    ; Draw Goomba at new position
    mov dl, goombaX[ebx]
    mov dh, goombaY[ebx]
    call Gotoxy
    
    ; Check level for background color
    cmp currentLevel, 2
    je drawGoombaUnderground
    
    ; Level 1 - brown on blue
    mov eax, brown + (blue * 16)
    call SetTextColor
    jmp drawGoombaChar
    
drawGoombaUnderground:
    ; Level 2 - brown on black
    mov eax, brown + (black * 16)
    call SetTextColor
    
drawGoombaChar:
    mov al, 'G'
    call WriteChar

    
    pop edx
    pop ebx
    pop eax
    ret
DrawOneGoomba ENDP

; ========================================
; Draw Koopa Troopa
; ========================================

DrawKoopa PROC
    push eax
    push edx
    
    ; Don't draw Koopa in Level 2 (Boss Level)
    cmp currentLevel, 2
    je skipKoopaDrawCompletely

    
       ; Erase old position
    mov dl, koopaOldX
    mov dh, koopaOldY
    call Gotoxy
    
    ; Check level for correct background
    cmp currentLevel, 2
    je eraseKoopaBlack
    
    ; Level 1 - blue
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    jmp eraseKoopaOld
    
eraseKoopaBlack:
    ; Level 2 - black
    mov eax, lightGray + (black * 16)
    call SetTextColor
    
eraseKoopaOld:
    mov al, ' '
    call WriteChar

    
    ; Draw at new position
    mov dl, koopaX
    mov dh, koopaY
    call Gotoxy
    
    ; Check state
    cmp koopaState, 1
    je drawWalkingKoopa
    
       ; Check level
    cmp currentLevel, 2
    je drawShellUnderground
    
    ; Level 1 - yellow on blue
    mov eax, yellow + (blue * 16)
    call SetTextColor
    jmp drawShellChar
    
drawShellUnderground:
    ; Level 2 - yellow on black
    mov eax, yellow + (black * 16)
    call SetTextColor
    
drawShellChar:
    mov al, 'S'
    call WriteChar
    jmp koopaDone2

    
drawWalkingKoopa:
    ; Check level
    cmp currentLevel, 2
    je drawKoopaUnderground
    
    ; Level 1 - red on blue
    mov eax, red + (blue * 16)
    call SetTextColor
    jmp drawKoopaK
    
drawKoopaUnderground:
    ; Level 2 - red on black
    mov eax, red + (black * 16)
    call SetTextColor
    
drawKoopaK:
    mov al, 'K'
    call WriteChar

    
koopaDone2:
    pop edx
    pop eax

    jmp l2

skipKoopaDrawCompletely:
    pop edx
    pop eax

    l2:

    ret
DrawKoopa ENDP

; ========================================
; Draw Bowser Boss
; ========================================

DrawBowser PROC
    push eax
    push edx
    
    ; Only draw if alive
    cmp bowserAlive, 0
    je skipBowserDraw
    
    ; Only draw in Level 2
    cmp currentLevel, 2
    jne skipBowserDraw
    
    ; Erase old position
    mov dl, bowserOldX
    mov dh, bowserOldY
    call Gotoxy
    
    ; Erase with black background
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    
    ; Draw Bowser at new position
    mov dl, bowserX
    mov dh, bowserY
    call Gotoxy
    
    ; Red B on black background 
    mov eax, red + (black * 16)
    call SetTextColor
    mov al, 'B'
    call WriteChar
    
skipBowserDraw:
    pop edx
    pop eax
    ret
DrawBowser ENDP

; ========================================
; Draw Bowser's Fireball
; ========================================

DrawFireball PROC
    push eax
    push edx
    
    ; Only draw if active
    cmp fireballActive, 0
    je skipFireballDraw
    
    ; Only in Level 2
    cmp currentLevel, 2
    jne skipFireballDraw
    
    ; Erase old position
    mov dl, fireballOldX
    mov dh, fireballOldY
    call Gotoxy
    
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    
    ; Draw fireball at new position
    mov dl, fireballX
    mov dh, fireballY
    call Gotoxy
    
    ; Red 'o' on black background
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov al, 'o'
    call WriteChar
    
skipFireballDraw:
    pop edx
    pop eax
    ret
DrawFireball ENDP

; ========================================
; Draw Mario's Fireball (Blue)
; ========================================

DrawMarioFireball PROC
    push eax
    push edx
    
    ; Only in Level 1
    cmp currentLevel, 1
    jne skipMarioFireballDraw
    
    ; ALWAYS erase old position first (whether active or not)
    mov dl, marioFireballOldX
    cmp dl, 0
    je skipErase
    cmp dl, 119
    jge skipErase
    
    mov dh, marioFireballOldY
    call Gotoxy
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    
skipErase:
    ; Now check if we should draw
    cmp marioFireballActive, 0
    je skipMarioFireballDraw
    
    ; Draw fireball at new position
    mov dl, marioFireballX
    mov dh, marioFireballY
    call Gotoxy
    
    mov eax, cyan + (blue * 16)
    call SetTextColor
    mov al, 'o'
    call WriteChar
    
skipMarioFireballDraw:
    pop edx
    pop eax
    ret
DrawMarioFireball ENDP


; ========================================
; Check collision between Mario and Goombas
; ========================================

CheckMarioGoombaCollision PROC
    push ebx
    push ecx
    push edx
    
    xor ebx, ebx
    mov cl, MAX_GOOMBAS
    
checkLoop:
    push ecx
    
    ; Check if Goomba is alive
    cmp goombaAlive[ebx], 0
    je nextGoomba
    
    ; STRICT X COLLISION CHECK 
    mov al, xPos
    mov dl, goombaX[ebx]
    sub al, dl
    
    cmp al, -1
    jl nextGoomba
    cmp al, 1
    jg nextGoomba
    
    ;  STRICT Y COLLISION CHECK 
    mov al, yPos
    mov dl, goombaY[ebx]
    sub al, dl
    
    cmp al, -1
    jl nextGoomba
    cmp al, 1
    jg nextGoomba
    
    ; Now we know they're colliding
    cmp al, -1
    je marioOnTop
    
    ; Same level  Mario gets hit
    jmp marioHitSide
    
marioOnTop:
    ; Kill the Goomba FIRST
    mov goombaAlive[ebx], 0

    call SoundEnemy
    
    ; Erase at CURRENT position
    mov dl, goombaX[ebx]
    mov dh, goombaY[ebx]
    push ebx
    call Gotoxy
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    pop ebx
    
    ; erase at OLD position in case it moved
    mov dl, goombaOldX[ebx]
    mov dh, goombaOldY[ebx]
    push ebx
    call Gotoxy
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    pop ebx
    
    ; Add score
    mov ax, score
    add ax, 100
    mov score, ax
    
    ; Bounce Mario
    mov yVelocity, -3
    
    ; Update HUD
    push ebx
    call DrawHUD
    pop ebx
    
    jmp nextGoomba
    
marioHitSide:
    ; Mario gets hit
    dec lives
    
    ; Check game over
    cmp lives, 0
    jne justReset
    
    ; Game over
    pop ecx
    pop edx
    pop ecx
    pop ebx
    call TimeUpGameOver
    exit
    
justReset:
    ; Update HUD
    push ebx
    call DrawHUD
    pop ebx
    
    ; Reset position
    mov xPos, 4
    mov yPos, 27
    mov yVelocity, 0
    
nextGoomba:
    pop ecx
    inc ebx
    dec cl
    jnz checkLoop
    
    pop edx
    pop ecx
    pop ebx
    ret
CheckMarioGoombaCollision ENDP

; ========================================
; Check Mario-Koopa Collision
; ========================================

CheckMarioKoopaCollision PROC
    push eax
    push edx
    
    ; Check X collision
    mov al, xPos
    mov dl, koopaX
    sub al, dl
    
    cmp al, -1
    jl noKoopaHit
    cmp al, 1
    jg noKoopaHit
    
    ; Check Y collision
    mov al, yPos
    mov dl, koopaY
    sub al, dl
    
    cmp al, -1
    jl noKoopaHit
    cmp al, 1
    jg noKoopaHit
    
    ; Collision detected
    cmp al, -1
    je marioOnKoopa

    
    ; Side hit - check if shell
    cmp koopaState, 0
    je noKoopaHit               
    
    ; Walking Koopa hurts Mario
    dec lives
    call DrawHUD
    
    cmp lives, 0
    jne resetMario2
    call TimeUpGameOver
    exit
    
resetMario2:
    mov xPos, 4
    mov yPos, 27
    mov yVelocity, 0
    jmp noKoopaHit
    
marioOnKoopa:
    ; Turn into shell
    mov koopaState, 0
    call SoundEnemy
    
    ; Add score
    mov ax, score
    add ax, 100
    mov score, ax
    
    ; Bounce Mario
    mov yVelocity, -3
    
    call DrawHUD
    
noKoopaHit:
    pop edx
    pop eax
    ret
CheckMarioKoopaCollision ENDP

; ========================================
; Check Mario-Fireball Collision
; ========================================

CheckMarioFireballCollision PROC
    push eax
    push edx
    
    ; Only check if fireball is active
    cmp fireballActive, 0
    je noFireballHit
    
    ; Only in Level 2
    cmp currentLevel, 2
    jne noFireballHit
    
    ; Check X collision
    mov al, xPos
    mov dl, fireballX
    sub al, dl
    
    ; Within 1 block horizontal
    cmp al, -1
    jl noFireballHit
    cmp al, 1
    jg noFireballHit
    
    ; Check Y collision
    mov al, yPos
    mov dl, fireballY
    sub al, dl
    
    ; Within 1 block vertical
    cmp al, -1
    jl noFireballHit
    cmp al, 1
    jg noFireballHit
    
    ; Collision detected!
    mov fireballActive, 0       ; Deactivate fireball
    
    ; Erase Mario
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    
    ; Lose a life
    dec lives
    
    cmp lives, 0
    jne resetMarioFromFireball
    call TimeUpGameOver
    exit
    
resetMarioFromFireball:
    ; Reset Mario position
    mov xPos, 4
    mov yPos, 25
    mov yVelocity, 0
    
    ; Update HUD
    call DrawHUD
    
    ; Small delay
    mov eax, 500
    call Delay
    
    ; Redraw level
    call Clrscr
    call DrawUnderground
    call DrawHUD
    call DrawLevel
    call DrawPlayer
    call DrawBowser
    
noFireballHit:
    pop edx
    pop eax
    ret
CheckMarioFireballCollision ENDP

; ========================================
; Check Mario's Fireball hitting Enemies
; ========================================

CheckFireballEnemyCollision PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Only check if fireball active
    cmp marioFireballActive, 0
    je noFireballEnemyHit
    
    ; Only in Level 1
    cmp currentLevel, 1
    jne noFireballEnemyHit
    
    ; Check Goombas
    xor ebx, ebx
    mov cl, 4               ; 4 Goombas
    
checkGoombaFireballLoop:
    cmp goombaAlive[ebx], 0
    je nextGoombaFireball
    
    ; Check X collision
    mov al, marioFireballX
    mov dl, goombaX[ebx]
    sub al, dl
    
    cmp al, -1
    jl nextGoombaFireball
    cmp al, 1
    jg nextGoombaFireball
    
    ; Check Y collision
    mov al, marioFireballY
    mov dl, goombaY[ebx]
    sub al, dl
    
    cmp al, -1
    jl nextGoombaFireball
    cmp al, 1
    jg nextGoombaFireball
    
          ;killing goomba
    mov goombaAlive[ebx], 0
    
    ; Erase Goomba
    push ebx
    mov dl, goombaX[ebx]
    mov dh, goombaY[ebx]
    call Gotoxy
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    pop ebx
    
    ; Add score
    mov ax, score
    add ax, 200
    mov score, ax
    call DrawHUD
    
    ; Deactivate fireball (DrawMarioFireball will handle erasing)
    mov marioFireballActive, 0
    jmp noFireballEnemyHit


    
nextGoombaFireball:
    inc ebx
    dec cl
    jnz checkGoombaFireballLoop
    
    ; Check Koopa
    cmp koopaState, 0
    je noFireballEnemyHit      ; Shell doesn't count
    
    ; Check X collision with Koopa
    mov al, marioFireballX
    mov dl, koopaX
    sub al, dl
    
    cmp al, -1
    jl noFireballEnemyHit
    cmp al, 1
    jg noFireballEnemyHit
    
    ; Check Y collision
    mov al, marioFireballY
    mov dl, koopaY
    sub al, dl
    
    cmp al, -1
    jl noFireballEnemyHit
    cmp al, 1
    jg noFireballEnemyHit
    
         ; shelling the Koopa 
    mov koopaState, 0
    
    ; Add score
    mov ax, score
    add ax, 200
    mov score, ax
    call DrawHUD
    
    ; Deactivate fireball (DrawMarioFireball will handle erasing)
    mov marioFireballActive, 0


    
noFireballEnemyHit:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
CheckFireballEnemyCollision ENDP

; ========================================
; Initialize Level 1-1 Layout
; ========================================

InitLevel1_1 PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Clear entire map first
    mov ecx, LEVEL_WIDTH * LEVEL_HEIGHT
    mov edi, OFFSET levelMap
    mov al, TILE_EMPTY
    rep stosb
    
    ;  DRAW GROUND (bottom 2 rows) 
    mov dh, 28
    mov ecx, 2
    
groundRowLoop:
    mov dl, 0
    push ecx
    mov ecx, LEVEL_WIDTH
    
groundColLoop:
    mov al, TILE_GROUND
    call SetTile
    inc dl
    loop groundColLoop
    
    pop ecx
    inc dh
    loop groundRowLoop
    
    ;  ADD PIPE 1 (Small pipe at x=28, height 2 blocks) 
    mov dl, 28
    mov dh, 26
    mov cl, 2
pipe1Loop:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pipe1Loop
    
    mov dl, 29
    mov dh, 26
    mov cl, 2
pipe1Loop2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pipe1Loop2
    
    ;  ADD PIPE 2 (Medium pipe at x=47, height 3 blocks) 
    mov dl, 47
    mov dh, 25
    mov cl, 3
pipe2Loop:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pipe2Loop
    
    mov dl, 48
    mov dh, 25
    mov cl, 3
pipe2Loop2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pipe2Loop2
    
    ; ADD PIPE 3 (Tall pipe at x=60, height 4 blocks) 
    mov dl, 60
    mov dh, 24
    mov cl, 4
pipe3Loop:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pipe3Loop
    
    mov dl, 61
    mov dh, 24
    mov cl, 4
pipe3Loop2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pipe3Loop2
    
    ; ADD PIPE 4 (Tall pipe at x=73, height 4 blocks) 
    mov dl, 77
    mov dh, 21
    mov cl, 7
pipe4Loop:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pipe4Loop
    
    mov dl, 78
    mov dh, 21
    mov cl, 7
pipe4Loop2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pipe4Loop2
    
    ;  FLOATING PLATFORMS TO REACH PIPES 
    
    ; Platform before Pipe 1 (step up)
    mov dl, 25
    mov dh, 26
    mov cl, 3
platformA:
    mov al, TILE_BRICK
    call SetTile
    inc dl
    dec cl
    jnz platformA
    
    ; Platform to reach Pipe 2
    mov dl, 42
    mov dh, 23
    mov cl, 4
platformB:
    mov al, TILE_BRICK
    call SetTile
    inc dl
    dec cl
    jnz platformB
    
    ; High platform between pipes
    mov dl, 54
    mov dh, 20
    mov cl, 5
platformC:
    mov al, TILE_BRICK
    call SetTile
    inc dl
    dec cl
    jnz platformC
    
    ; Platform to reach Pipe 4
    mov dl, 68
    mov dh, 22
    mov cl, 4
platformD:
    mov al, TILE_BRICK
    call SetTile
    inc dl
    dec cl
    jnz platformD
    
    
    ; Platform 1: at (20, 24) - 5 blocks wide
    mov dl, 18
    mov dh, 24
    mov cl, 7
platform1:
    mov al, TILE_BRICK
    call SetTile
    inc dl
    dec cl
    jnz platform1
    
    ; Platform 2: at (35, 22) - 4 blocks wide
    mov dl, 35
    mov dh, 22
    mov cl, 4
platform2:
    mov al, TILE_BRICK
    call SetTile
    inc dl
    dec cl
    jnz platform2
    
    ; Platform 3: at (85, 20) - 6 blocks wide
    mov dl, 85
    mov dh, 20
    mov cl, 6
platform3:
    mov al, TILE_BRICK
    call SetTile
    inc dl
    dec cl
    jnz platform3
    
    ; Platform 4: at (95, 18) - 4 blocks wide
    mov dl, 95
    mov dh, 18
    mov cl, 8
platform4:
    mov al, TILE_BRICK
    call SetTile
    inc dl
    dec cl
    jnz platform4
    
    ;  QUESTION BLOCKS (Better spacing) 
    

    ; Question block above first platform
    mov dl, 21
    mov dh, 20
    mov al, TILE_QUESTION
    call SetTile
    
    
    ; Question block reachable from platform at x=35
    mov dl, 36
    mov dh, 18
    mov al, TILE_QUESTION
    call SetTile
    
    ; Question block above Pipe 2
    mov dl, 47
    mov dh, 21
    mov al, TILE_QUESTION
    call SetTile
    
    ; Question block above high platform
    mov dl, 56
    mov dh, 14
    mov al, TILE_QUESTION
    call SetTile
    
    ; Question block above Pipe 3
    mov dl, 60
    mov dh, 20
    mov al, TILE_QUESTION
    call SetTile
    
    ; Question blocks from ground (far section - spread out)
    mov dl, 80
    mov dh, 27
    mov al, TILE_QUESTION
    call SetTile
    
    mov dl, 87
    mov dh, 14
    mov al, TILE_QUESTION
    call SetTile

    ; ADD COLLECTIBLE COINS (Better spread) 
    
    ; Coin on ground (easy starter)
    mov dl, 6
    mov dh, 25
    mov al, TILE_COIN
    call SetTile
    
    ; Coin floating mid-air (requires jump from ground)
    mov dl, 12
    mov dh, 19
    mov al, TILE_COIN
    call SetTile
    
    ; Coin above first platform (jump from platform at 24)
    mov dl, 22
    mov dh, 22
    mov al, TILE_COIN
    call SetTile
    
    ; Coin on top of Pipe 1 (requires climbing)
    mov dl, 28
    mov dh, 25
    mov al, TILE_COIN
    call SetTile
    
    ; Coin floating near platform at x=35 (jump from platform)
    mov dl, 37
    mov dh, 19
    mov al, TILE_COIN
    call SetTile
        
    ; Coin on top of Pipe 2
    mov dl, 47
    mov dh, 24
    mov al, TILE_COIN
    call SetTile
    
    ; Two coins above high platform (jump from platform at 20)
    mov dl, 88
    mov dh, 27
    mov al, TILE_COIN
    call SetTile
    
    mov dl, 58
    mov dh, 17
    mov al, TILE_COIN
    call SetTile
    
    ; Coin on top of Pipe 3 (challenging)
    mov dl, 60
    mov dh, 22
    mov al, TILE_COIN
    call SetTile
    
    ; Coin in mid-air (requires jump between pipes)
    mov dl, 66
    mov dh, 19
    mov al, TILE_COIN
    call SetTile
    
    ; Coin near platform at x=85
    mov dl, 87
    mov dh, 17
    mov al, TILE_COIN
    call SetTile
    
    ; Coins near end (reward for reaching far)
    mov dl, 96
    mov dh, 15
    mov al, TILE_COIN
    call SetTile
    
    mov dl, 110
    mov dh, 24
    mov al, TILE_COIN
    call SetTile

        ; ADD TIME SLOW CLOCK POWER-UP 
    
    ; Clock on floating platform (easy to reach)
    mov dl, 63
    mov dh, 27
    mov al, TILE_CLOCK
    call SetTile
   

    ; clouds
    
    ; Cloud 1 (small) at x=8, y=6
    mov dl, 8
    mov dh, 6
    mov al, TILE_CLOUD
    call SetTile
    mov dl, 9
    call SetTile
    mov dl, 10
    call SetTile
    
    ; Cloud 2 (medium) at x=18, y=8
    mov dl, 18
    mov dh, 8
    mov al, TILE_CLOUD
    call SetTile
    mov dl, 19
    call SetTile
    mov dl, 20
    call SetTile
    mov dl, 21
    call SetTile
    
    ; Cloud 3 (small) at x=32, y=5
    mov dl, 32
    mov dh, 5
    mov al, TILE_CLOUD
    call SetTile
    mov dl, 33
    call SetTile
    mov dl, 34
    call SetTile
    
    ; Cloud 4 (large) at x=45, y=7
    mov dl, 45
    mov dh, 7
    mov al, TILE_CLOUD
    call SetTile
    mov dl, 46
    call SetTile
    mov dl, 47
    call SetTile
    mov dl, 48
    call SetTile
    mov dl, 49
    call SetTile
    
    ; Cloud 5 (small) at x=62, y=6
    mov dl, 62
    mov dh, 6
    mov al, TILE_CLOUD
    call SetTile
    mov dl, 63
    call SetTile
    mov dl, 64
    call SetTile
    
    ; Cloud 6 (medium) at x=78, y=9
    mov dl, 78
    mov dh, 9
    mov al, TILE_CLOUD
    call SetTile
    mov dl, 79
    call SetTile
    mov dl, 80
    call SetTile
    mov dl, 81
    call SetTile
    
    ; Cloud 7 (small) at x=95, y=5
    mov dl, 95
    mov dh, 5
    mov al, TILE_CLOUD
    call SetTile
    mov dl, 96
    call SetTile
    mov dl, 97
    call SetTile
    
    ; Cloud 8 (large) at x=110, y=8
    mov dl, 110
    mov dh, 8
    mov al, TILE_CLOUD
    call SetTile
    mov dl, 111
    call SetTile
    mov dl, 112
    call SetTile
    mov dl, 113
    call SetTile
    mov dl, 114
    call SetTile
    
    ; ADD A STAIRCASE at end 
    mov dl, 103
    mov dh, 27
    mov al, TILE_BRICK
    call SetTile
    
    mov dl, 104
    mov dh, 27
    mov al, TILE_BRICK
    call SetTile
    mov dh, 26
    call SetTile
    
    mov dl, 105
    mov dh, 27
    mov al, TILE_BRICK
    call SetTile
    mov dh, 26
    call SetTile
    mov dh, 25
    call SetTile
    
    mov dl, 106
    mov dh, 27
    mov al, TILE_BRICK
    call SetTile
    mov dh, 26
    call SetTile
    mov dh, 25
    call SetTile
    mov dh, 24
    call SetTile

         ;  ADD FLAGPOLE AT EXTREME RIGHT (x=117) 
    
    ; Flagpole base (bottom) - on ground
    mov dl, 117
    mov dh, 27
    mov al, TILE_BRICK
    call SetTile
    
    ; Flagpole (vertical pole from y=20 to y=26) - 7 blocks tall
    mov dl, 117
    mov dh, 20              ; Start at y=20
    mov cl, 7               ; Only 7 blocks tall
flagpoleLoop:
    mov al, TILE_FLAGPOLE
    call SetTile
    inc dh
    dec cl
    jnz flagpoleLoop
    
    ; Flag at top (y=20, 21 - one block left of pole)
    mov dl, 116
    mov dh, 20
    mov al, TILE_FLAG
    call SetTile
    mov dh, 21
    call SetTile

    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
InitLevel1_1 ENDP

; ========================================
; Initialize Level 1-2 (BOSS CASTLE)
; ========================================

InitLevel1_2 PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Clear entire map first
    mov ecx, LEVEL_WIDTH * LEVEL_HEIGHT
    mov edi, OFFSET levelMap
    mov al, TILE_EMPTY
    rep stosb
    
    ; === DRAW GROUND (bottom 2 rows) ===
    mov dh, 28
    mov ecx, 2
    
ground2RowLoop:
    mov dl, 0
    push ecx
    mov ecx, LEVEL_WIDTH
    
ground2ColLoop:
    mov al, TILE_GROUND_UNDERGROUND
    call SetTile
    inc dl
    loop ground2ColLoop
    
    pop ecx
    inc dh
    loop ground2RowLoop
    
    ; CASTLE PILLARS/PIPES (3 blocks wide, varied heights, with gaps) 
    
    ; Pillar 1 - Short (height 3) at x=8-10
    mov dl, 8
    mov dh, 25
    mov cl, 3
pillar1_col1:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar1_col1
    
    mov dl, 9
    mov dh, 25
    mov cl, 3
pillar1_col2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar1_col2
    
    mov dl, 10
    mov dh, 25
    mov cl, 3
pillar1_col3:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar1_col3
    
    ; GAP (x=11-15 for lava later)
    
    ; Pillar 2 - Medium (height 5) at x=16-18
    mov dl, 16
    mov dh, 23
    mov cl, 5
pillar2_col1:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar2_col1
    
    mov dl, 17
    mov dh, 23
    mov cl, 5
pillar2_col2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar2_col2
    
    mov dl, 18
    mov dh, 23
    mov cl, 5
pillar2_col3:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar2_col3
    
    ; GAP (x=19-24 for lava)
    
    ; Pillar 3 - Tall (height 7) at x=25-27
    mov dl, 24
    mov dh, 21
    mov cl, 6
pillar3_col1:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar3_col1
    
    mov dl, 28
    mov dh, 21
    mov cl, 7
pillar3_col2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar3_col2
    
    mov dl, 29
    mov dh, 21
    mov cl, 7
pillar3_col3:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar3_col3
    
    ; GAP (x=28-32 for lava)
    
    ; Pillar 4 - Medium (height 4) at x=33-35
    mov dl, 35
    mov dh, 24
    mov cl, 4
pillar4_col1:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar4_col1
    
    mov dl, 36
    mov dh, 24
    mov cl, 4
pillar4_col2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar4_col2
    
    mov dl, 37
    mov dh, 24
    mov cl, 4
pillar4_col3:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar4_col3
    
    ; GAP (x=36-42 WIDE gap for lava)
    
    ; Pillar 5 - Very Tall (height 8) at x=43-45
    mov dl, 43
    mov dh, 20
    mov cl, 8
pillar5_col1:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar5_col1
    
    mov dl, 44
    mov dh, 20
    mov cl, 8
pillar5_col2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar5_col2
    
    mov dl, 45
    mov dh, 20
    mov cl, 8
pillar5_col3:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar5_col3
    
    ; GAP (x=46-51 for lava)
    
    ; Pillar 6 - Medium (height 5) at x=52-54
    mov dl, 52
    mov dh, 23
    mov cl, 5
pillar6_col1:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar6_col1
    
    mov dl, 53
    mov dh, 23
    mov cl, 5
pillar6_col2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar6_col2
    
    mov dl, 54
    mov dh, 23
    mov cl, 5
pillar6_col3:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar6_col3
    
    ; GAP (x=55-60 for lava)
    
    ; Pillar 7 - Tall (height 6) at x=61-63
    mov dl, 61
    mov dh, 22
    mov cl, 6
pillar7_col1:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar7_col1
    
    mov dl, 62
    mov dh, 22
    mov cl, 6
pillar7_col2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar7_col2
    
    mov dl, 63
    mov dh, 22
    mov cl, 6
pillar7_col3:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar7_col3
    
    ; GAP (x=64-70 for lava)
    
    ; Pillar 8 - Short (height 4) at x=71-73
    mov dl, 71
    mov dh, 24
    mov cl, 4
pillar8_col1:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar8_col1
    
    mov dl, 72
    mov dh, 24
    mov cl, 4
pillar8_col2:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar8_col2
    
    mov dl, 73
    mov dh, 24
    mov cl, 4
pillar8_col3:
    mov al, TILE_BRICK
    call SetTile
    inc dh
    dec cl
    jnz pillar8_col3
    
    ; Final platform for boss area (x=100-115, solid ground)
    mov dl, 95
    mov dh, 27
    mov cl, 16
finalPlatform:
    mov al, TILE_BRICK
    call SetTile
    inc dl
    dec cl
    jnz finalPlatform
    
 
    ;  LAVA IN GAPS (Instant Death) 
    
    ; Gap 1: x=11-15, fill from y=26-27
    mov dh, 26
lavaGap1Row:
    mov dl, 11
    mov cl, 5
lavaGap1Col:
    mov al, TILE_LAVA
    call SetTile
    inc dl
    dec cl
    jnz lavaGap1Col
    inc dh
    cmp dh, 28
    jl lavaGap1Row
    
    ; Gap 2: x=19-23, fill from y=26-27
    mov dh, 26
lavaGap2Row:
    mov dl, 19
    mov cl, 5
lavaGap2Col:
    mov al, TILE_LAVA
    call SetTile
    inc dl
    dec cl
    jnz lavaGap2Col
    inc dh
    cmp dh, 28
    jl lavaGap2Row
    
    ; Gap 3: x=30-34, fill from y=26-27
    mov dh, 26
lavaGap3Row:
    mov dl, 30
    mov cl, 5
lavaGap3Col:
    mov al, TILE_LAVA
    call SetTile
    inc dl
    dec cl
    jnz lavaGap3Col
    inc dh
    cmp dh, 28
    jl lavaGap3Row
    
    ; Gap 4: x=38-42, fill from y=26-27
    mov dh, 26
lavaGap4Row:
    mov dl, 38
    mov cl, 5
lavaGap4Col:
    mov al, TILE_LAVA
    call SetTile
    inc dl
    dec cl
    jnz lavaGap4Col
    inc dh
    cmp dh, 28
    jl lavaGap4Row
    
    ; Gap 5: x=46-51, fill from y=26-27
    mov dh, 26
lavaGap5Row:
    mov dl, 46
    mov cl, 6
lavaGap5Col:
    mov al, TILE_LAVA
    call SetTile
    inc dl
    dec cl
    jnz lavaGap5Col
    inc dh
    cmp dh, 28
    jl lavaGap5Row
    
    ; Gap 6: x=55-60, fill from y=26-27
    mov dh, 26
lavaGap6Row:
    mov dl, 55
    mov cl, 6
lavaGap6Col:
    mov al, TILE_LAVA
    call SetTile
    inc dl
    dec cl
    jnz lavaGap6Col
    inc dh
    cmp dh, 28
    jl lavaGap6Row
    
    ; Gap 7: x=64-70, fill from y=26-27
    mov dh, 26
lavaGap7Row:
    mov dl, 64
    mov cl, 7
lavaGap7Col:
    mov al, TILE_LAVA
    call SetTile
    inc dl
    dec cl
    jnz lavaGap7Col
    inc dh
    cmp dh, 28
    jl lavaGap7Row
    
    ; AXE (to defeat Bowser) 
    
    mov dl, 115
    mov dh, 27
    mov al, TILE_AXE
    call SetTile

    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
InitLevel1_2 ENDP

; ========================================
; Set a tile in the level map
; ========================================
SetTile PROC
    push eax
    push ebx
    push edx
    
    cmp dl, LEVEL_WIDTH
    jae setTileDone
    cmp dh, LEVEL_HEIGHT
    jae setTileDone
    
    movzx ebx, dh
    imul ebx, LEVEL_WIDTH
    movzx edx, dl
    add ebx, edx
    
    mov levelMap[ebx], al
    
setTileDone:
    pop edx
    pop ebx
    pop eax
    ret
SetTile ENDP

; ========================================
; Get a tile from the level map
; ========================================
GetTile PROC
    push ebx
    push edx
    
    cmp dl, LEVEL_WIDTH
    jae getTileEmpty
    cmp dh, LEVEL_HEIGHT
    jae getTileEmpty
    
    movzx ebx, dh
    imul ebx, LEVEL_WIDTH
    movzx edx, dl
    add ebx, edx
    
    mov al, levelMap[ebx]
    jmp getTileDone
    
getTileEmpty:
    mov al, TILE_EMPTY
    
getTileDone:
    pop edx
    pop ebx
    ret
GetTile ENDP

; ========================================
; Draw the entire level
; ========================================

DrawLevel PROC
    push eax
    push ebx
    push ecx
    push edx
    
    mov dh, 3
    
drawRowLoop:
    cmp dh, 30
    jge drawLevelDone
    
    mov dl, 0
    
drawColLoop:
    cmp dl, 120
    jge nextRow
    
    push edx
    call GetTile
    
    cmp al, TILE_EMPTY
    je skipTile
    
    pop edx
    push edx
    call Gotoxy
    
    cmp al, TILE_GROUND
    je drawGround
    cmp al, TILE_BRICK
    je drawBrick
    cmp al, TILE_QUESTION
    je drawQuestion
    cmp al, TILE_COIN
    je drawCoin
    cmp al, TILE_CLOUD
    je drawCloud
    cmp al, TILE_FLAGPOLE
    je drawFlagpole
    cmp al, TILE_FLAG
    je drawFlag
    cmp al, TILE_LAVA
    je drawLava
    cmp al, TILE_GROUND_UNDERGROUND
    je drawGroundUnderground
    cmp al, TILE_AXE             
    je drawAxe   
    cmp al, TILE_CLOCK
    je drawClock
    jmp skipTile

    
drawGround:
    mov eax, green + (black * 16)
    call SetTextColor
    mov al, 219
    call WriteChar
    jmp skipTile
    
drawBrick:
    ; Check level for brick color
    cmp currentLevel, 2
    je drawBrickCastle
    
    ; Level 1 - green bricks
    mov eax, green + (black * 16)
    call SetTextColor
    jmp drawBrickChar
    
drawBrickCastle:
    ; Level 2 - gray castle stone
    mov eax, lightGray + (black * 16)
    call SetTextColor
    
drawBrickChar:
    mov al, 219
    call WriteChar
    jmp skipTile

    
drawQuestion:
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mov al, '?'
    call WriteChar
    jmp skipTile
    
drawCoin:
    ; Check level for background
    cmp currentLevel, 2
    je drawCoinUnderground
    
    ; Level 1 - yellow on blue
    mov eax, yellow + (blue * 16)
    call SetTextColor
    jmp drawCoinChar
    
drawCoinUnderground:
    ; Level 2 - yellow on black
    mov eax, yellow + (black * 16)
    call SetTextColor
    
drawCoinChar:
    mov al, 'O'
    call WriteChar
    jmp skipTile


drawCloud:
    mov eax, white + (blue * 16)
    call SetTextColor
    mov al, 176
    call WriteChar

drawFlagpole:
    ; Check level
    cmp currentLevel, 2
    je drawFlagpoleUnderground
    
    ; Level 1 - white on blue
    mov eax, white + (blue * 16)
    call SetTextColor
    jmp drawFlagpoleChar
    
drawFlagpoleUnderground:
    ; Level 2 - white on black
    mov eax, white + (black * 16)
    call SetTextColor
    
drawFlagpoleChar:
    mov al, 179             ; Vertical line 
    call WriteChar
    jmp skipTile

drawFlag:
    ; Check level
    cmp currentLevel, 2
    je drawFlagUnderground
    
    ; Level 1 - red on black
    mov eax, red + (black * 16)
    call SetTextColor
    jmp drawFlagChar
    
drawFlagUnderground:
    ; Level 2 - red on brown
    mov eax, red + (brown * 16)
    call SetTextColor
    
drawFlagChar:
    mov al, 16              ; Triangle 
    call WriteChar

 drawLava:
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov al, 176    ; Stippled block 
    call WriteChar
    jmp skipTile

    drawGroundUnderground:
    mov eax, lightGray + (black * 16)    ; Gray on black
    call SetTextColor
    mov al, 178                           ; Dense stipple 
    call WriteChar
    jmp skipTile

drawAxe:                           
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov al, 206
    call WriteChar
    jmp skipTile
    
 drawClock:
    ; Check level
    cmp currentLevel, 1
    jne skipTile
    
    ; Yellow clock on blue background
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mov al, 'C'              ; Letter C for Clock
    call WriteChar
    jmp skipTile
    
skipTile:

    pop edx
    inc dl
    jmp drawColLoop
    
nextRow:
    inc dh
    jmp drawRowLoop
    
drawLevelDone:
    mov eax, white + (black * 16)
    call SetTextColor
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawLevel ENDP

; ========================================
; Check collision with tiles
; ========================================

CheckCollision PROC
    push edx
    
    call GetTile
    
    cmp al, TILE_EMPTY
    je notSolid
    cmp al, TILE_COIN
    je notSolid
    cmp al, TILE_CLOUD
    je notSolid
    cmp al, TILE_QUESTION
    je notSolid
    cmp al, TILE_FLAGPOLE
    je notSolid
    cmp al, TILE_FLAG
    je notSolid
             
    
    ; Ground and brick are solid
    mov al, 1
    jmp collisionDone
    
notSolid:
    mov al, 0
    
collisionDone:
    pop edx
    ret
CheckCollision ENDP


ShowTitleScreen PROC
    call Clrscr
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov eax, red + (black * 16)
    call SetTextColor
    
    mov dl, 39
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET titleLine1
    call WriteString
    
    mov dl, 39
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET titleLine2
    call WriteString
    
    mov dl, 39
    mov dh, 4
    call Gotoxy
    mov edx, OFFSET titleLine3
    call WriteString
    
    mov dl, 39
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET titleLine4
    call WriteString
    
    mov dl, 39
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET titleLine5
    call WriteString
    
    mov dl, 39
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET titleLine6
    call WriteString
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov dl, 39
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET titleLine8
    call WriteString
    
    mov dl, 39
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET titleLine9
    call WriteString
    
    mov dl, 39
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET titleLine10
    call WriteString
    
    mov dl, 39
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET titleLine11
    call WriteString
    
    mov dl, 39
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET titleLine12
    call WriteString
    
    mov dl, 39
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET titleLine13
    call WriteString
    
    mov eax, red + (black * 16)
    call SetTextColor
    
    mov dl, 43
    mov dh, 16
    call Gotoxy
    mov edx, OFFSET titleLine15
    call WriteString
    
    mov dl, 43
    mov dh, 17
    call Gotoxy
    mov edx, OFFSET titleLine16
    call WriteString
    
    mov dl, 43
    mov dh, 18
    call Gotoxy
    mov edx, OFFSET titleLine17
    call WriteString
    
    mov dl, 43
    mov dh, 19
    call Gotoxy
    mov edx, OFFSET titleLine18
    call WriteString
    
    mov dl, 43
    mov dh, 20
    call Gotoxy
    mov edx, OFFSET titleLine19
    call WriteString
    
    mov dl, 43
    mov dh, 21
    call Gotoxy
    mov edx, OFFSET titleLine20
    call WriteString
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 39
    mov dh, 23
    call Gotoxy
    mov edx, OFFSET rollNumber
    call WriteString
    
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dl, 39
    mov dh, 25
    call Gotoxy
    mov edx, OFFSET pressKey
    call WriteString
    
    call ReadChar
    
    call Clrscr
    
    mov eax, white + (black * 16)
    call SetTextColor
    
    ret
ShowTitleScreen ENDP

ShowMainMenu PROC
    mov menuState, 0
    
    menuLoop:
    cmp menuState, 0
    je displayMainMenu
    cmp menuState, 1
    je displayInstructions
    cmp menuState, 2
    je displayHighscore
    cmp menuState, 3
    je startGame
    
    displayMainMenu:
        call Clrscr
        
        mov eax, red + (black * 16)
        call SetTextColor
        
        mov dl, 33
        mov dh, 2
        call Gotoxy
        mov edx, OFFSET menuTitleLine1
        call WriteString
        
        mov dl, 33
        mov dh, 3
        call Gotoxy
        mov edx, OFFSET menuTitleLine2
        call WriteString
        
        mov dl, 33
        mov dh, 4
        call Gotoxy
        mov edx, OFFSET menuTitleLine3
        call WriteString
        
        mov dl, 33
        mov dh, 5
        call Gotoxy
        mov edx, OFFSET menuTitleLine4
        call WriteString
        
        mov dl, 33
        mov dh, 6
        call Gotoxy
        mov edx, OFFSET menuTitleLine5
        call WriteString
        
        mov dl, 33
        mov dh, 7
        call Gotoxy
        mov edx, OFFSET menuTitleLine6
        call WriteString
        
        mov eax, yellow + (black * 16)
        call SetTextColor
        
        mov dl, 38
        mov dh, 9
        call Gotoxy
        mov edx, OFFSET startLine1
        call WriteString
        
        mov dl, 38
        mov dh, 10
        call Gotoxy
        mov edx, OFFSET startLine2
        call WriteString
        
        mov dl, 38
        mov dh, 11
        call Gotoxy
        mov edx, OFFSET startLine3
        call WriteString
        
        mov dl, 38
        mov dh, 12
        call Gotoxy
        mov edx, OFFSET startLine4
        call WriteString
        
        mov eax, yellow + (black * 16)
        call SetTextColor
        
        mov dl, 33
        mov dh, 13
        call Gotoxy
        mov edx, OFFSET instructLine1
        call WriteString
        
        mov dl, 33
        mov dh, 14
        call Gotoxy
        mov edx, OFFSET instructLine2
        call WriteString
        
        mov dl, 33
        mov dh, 15
        call Gotoxy
        mov edx, OFFSET instructLine3
        call WriteString
        
        mov dl, 33
        mov dh, 16
        call Gotoxy
        mov edx, OFFSET instructLine4
        call WriteString
        
        mov eax, yellow + (black * 16)
        call SetTextColor
        
        mov dl, 41
        mov dh, 17
        call Gotoxy
        mov edx, OFFSET highLine1
        call WriteString
        
        mov dl, 41
        mov dh, 18
        call Gotoxy
        mov edx, OFFSET highLine2
        call WriteString
        
        mov dl, 41
        mov dh, 19
        call Gotoxy
        mov edx, OFFSET highLine3
        call WriteString
        
        mov dl, 41
        mov dh, 20
        call Gotoxy
        mov edx, OFFSET highLine4
        call WriteString
        
        mov eax, red + (black * 16)
        call SetTextColor
        
        mov dl, 51
        mov dh, 21
        call Gotoxy
        mov edx, OFFSET exitLine1
        call WriteString
        
        mov dl, 51
        mov dh, 22
        call Gotoxy
        mov edx, OFFSET exitLine2
        call WriteString
        
        mov dl, 51
        mov dh, 23
        call Gotoxy
        mov edx, OFFSET exitLine3
        call WriteString
        
        mov dl, 51
        mov dh, 24
        call Gotoxy
        mov edx, OFFSET exitLine4
        call WriteString
        
        mov eax, white + (black * 16)
        call SetTextColor
        mov dl, 46
        mov dh, 26
        call Gotoxy
        mov edx, OFFSET menuPrompt
        call WriteString
        
        call ReadChar
        mov menuChoice, al
        
        cmp menuChoice, '1'
        je setGameState
        cmp menuChoice, '2'
        je setInstructState
        cmp menuChoice, '3'
        je setHighscoreState
        cmp menuChoice, '4'
        je exitProgram
        
        jmp menuLoop
        
    setInstructState:
        mov menuState, 1
        jmp menuLoop
        
    setHighscoreState:
        mov menuState, 2
        jmp menuLoop
        
    setGameState:
        mov menuState, 3
        jmp menuLoop
    
    displayInstructions:
        call Clrscr
        
        mov eax, lightGreen + (black * 16)
        call SetTextColor
        
        mov dl, 25
        mov dh, 10
        call Gotoxy
        mov edx, OFFSET instructTitle
        call WriteString
        
        mov dl, 25
        mov dh, 12
        call Gotoxy
        mov edx, OFFSET instruct1
        call WriteString
        
        mov dl, 25
        mov dh, 13
        call Gotoxy
        mov edx, OFFSET instruct2
        call WriteString
        
        mov dl, 25
        mov dh, 14
        call Gotoxy
        mov edx, OFFSET instruct3
        call WriteString
        
        mov dl, 25
        mov dh, 15
        call Gotoxy
        mov edx, OFFSET instruct4
        call WriteString
        
        mov dl, 25
        mov dh, 17
        call Gotoxy
        mov edx, OFFSET instructBack
        call WriteString
        
        call ReadChar
        
        mov menuState, 0
        jmp menuLoop
    
    displayHighscore:
        call Clrscr
        
        mov eax, lightMagenta + (black * 16)
        call SetTextColor
        
        mov dl, 40
        mov dh, 12
        call Gotoxy
        mov edx, OFFSET highscoreTitle
        call WriteString
        
        mov dl, 40
        mov dh, 14
        call Gotoxy
        mov edx, OFFSET highscoreText
        call WriteString
        
        movzx eax, highScore
        call WriteDec
        
        mov dl, 40
        mov dh, 16
        call Gotoxy
        mov edx, OFFSET highscoreBack
        call WriteString
        
        call ReadChar
        
        mov menuState, 0
        jmp menuLoop
    
    exitProgram:
        call Clrscr
        exit
    
    startGame:
        call Clrscr
        ret
    
ShowMainMenu ENDP

DrawHUD PROC
    push eax
    push edx
    
    mov eax, white + (black * 16)
    call SetTextColor
    
    ; EXTREME LEFT: MARIO SCORE 
    mov dl, 2
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strMario
    call WriteString
    
    mov dl, 2
    mov dh, 1
    call Gotoxy
    ; Clear old score
    mov ecx, 8
    clearScoreLoop:
        mov al, ' '
        call WriteChar
        loop clearScoreLoop
    
    mov dl, 2
    mov dh, 1
    call Gotoxy
    movzx eax, score
    call WriteDec
    
    ;  CENTER: COINS
    mov dl, 55
    mov dh, 0
    call Gotoxy
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, 'C'
    call WriteChar
    mov al, 'O'
    call WriteChar
    mov al, 'I'
    call WriteChar
    mov al, 'N'
    call WriteChar
    mov al, 'S'
    call WriteChar
    
    ; Yellow O x count below
    mov dl, 55
    mov dh, 1
    call Gotoxy
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov al, 'O'
    call WriteChar
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, 'x'
    call WriteChar
    
    movzx eax, coins
    call WriteDec
    
    ;  CENTER RIGHT: WORLD 
    mov dl, 75
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strWorld
    call WriteString
    
    mov dl, 75
    mov dh, 1
    call Gotoxy
    movzx eax, worldNum
    call WriteDec
    
    mov al, '-'
    call WriteChar
    
    movzx eax, levelNum
    call WriteDec
    
    ; MORE RIGHT: LIVES x 3 
    mov dl, 93
    mov dh, 0
    call Gotoxy
    ; Write "LIVES" instead of "MARIO"
    mov al, 'L'
    call WriteChar
    mov al, 'I'
    call WriteChar
    mov al, 'V'
    call WriteChar
    mov al, 'E'
    call WriteChar
    mov al, 'S'
    call WriteChar
    
    mov dl, 93
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET strLives
    call WriteString
    
    movzx eax, lives
    call WriteDec
    
    ;  EXTREME RIGHT: TIME 
    mov dl, 108
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strTime
    call WriteString
    
    mov dl, 108
    mov dh, 1
    call Gotoxy
    movzx eax, timeRemaining
    call WriteDec
    
    ; Draw separator line
    mov dl, 0
    mov dh, 2
    call Gotoxy
    mov ecx, 120
    mov eax, white + (black * 16)
    call SetTextColor
separatorLoop:
    mov al, '-'
    call WriteChar
    loop separatorLoop

    ; DISPLAY TIME SLOW STATUS (Level 1 only) 
    cmp currentLevel, 1
    jne skipTimeSlowDisplay
    
    cmp timeSlowActive, 0
    je skipTimeSlowDisplay
    
    ; Display "TIME SLOW!" message
    mov dl, 35
    mov dh, 1
    call Gotoxy
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov al, 'T'
    call WriteChar
    mov al, 'I'
    call WriteChar
    mov al, 'M'
    call WriteChar
    mov al, 'E'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'S'
    call WriteChar
    mov al, 'L'
    call WriteChar
    mov al, 'O'
    call WriteChar
    mov al, 'W'
    call WriteChar
    mov al, 'E'
    call WriteChar
    mov al, 'D'
    call WriteChar
    
skipTimeSlowDisplay:
    
    pop edx
    pop eax
    ret
DrawHUD ENDP


; ========================================
; Draw the sky background
; ========================================

DrawSky PROC
    push eax
    push ecx
    push edx
    
    ; Set sky color
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    
    ; Draw sky from row 3 to 29
    mov dh, 3
    
skyRowLoop:
    cmp dh, 30
    jge skyDone
    
    mov dl, 0
    call Gotoxy
    
    ; Draw 120 spaces for this row
    mov ecx, 120
skyColLoop:
    mov al, ' '
    call WriteChar
    loop skyColLoop
    
    inc dh
    jmp skyRowLoop
    
skyDone:
    ; Reset color
    mov eax, white + (black * 16)
    call SetTextColor
    
    pop edx
    pop ecx
    pop eax
    ret
DrawSky ENDP

; ========================================
; Draw the underground background (black)
; ========================================

DrawUnderground PROC
    push eax
    push edx
    
    ; Fill screen with black background (your existing code)
    mov eax, lightGray + (black * 16)
    call SetTextColor
    
    mov dh, 3
    mov dl, 0
fillUndergroundLoop:
    call Gotoxy
    mov al, ' '
    call WriteChar
    inc dl
    cmp dl, 120
    jl fillUndergroundLoop
    mov dl, 0
    inc dh
    cmp dh, 30
    jl fillUndergroundLoop
    
    ; Add scattered ceiling bricks for atmosphere
    ; Add long hanging stalactites from ceiling
mov eax, lightGray + (black * 16)
call SetTextColor

; Stalactite 1 (length 5)
mov dl, 10
mov dh, 4
call Gotoxy
mov al, 178
call WriteChar
mov dh, 5
call Gotoxy
call WriteChar
mov dh, 6
call Gotoxy
call WriteChar
mov dh, 7
call Gotoxy
call WriteChar
mov dh, 8
call Gotoxy
call WriteChar

; Stalactite 2 (length 4)
mov dl, 30
mov dh, 5
call Gotoxy
mov al, 178
call WriteChar
mov dh, 6
call Gotoxy
call WriteChar
mov dh, 7
call Gotoxy
call WriteChar
mov dh, 8
call Gotoxy
call WriteChar

; Stalactite 3 (length 6)
mov dl, 50
mov dh, 4
call Gotoxy
mov al, 178
call WriteChar
mov dh, 5
call Gotoxy
call WriteChar
mov dh, 6
call Gotoxy
call WriteChar
mov dh, 7
call Gotoxy
call WriteChar
mov dh, 8
call Gotoxy
call WriteChar
mov dh, 9
call Gotoxy
call WriteChar

; Stalactite 4 (length 5)
mov dl, 70
mov dh, 5
call Gotoxy
mov al, 178
call WriteChar
mov dh, 6
call Gotoxy
call WriteChar
mov dh, 7
call Gotoxy
call WriteChar
mov dh, 8
call Gotoxy
call WriteChar
mov dh, 9
call Gotoxy
call WriteChar

; Stalactite 5 (length 4)
mov dl, 90
mov dh, 6
call Gotoxy
mov al, 178
call WriteChar
mov dh, 7
call Gotoxy
call WriteChar
mov dh, 8
call Gotoxy
call WriteChar
mov dh, 9
call Gotoxy
call WriteChar

; Stalactite 6 (length 3)
mov dl, 110
mov dh, 5
call Gotoxy
mov al, 178
call WriteChar
mov dh, 6
call Gotoxy
call WriteChar
mov dh, 7
call Gotoxy
call WriteChar
 
    pop edx
    pop eax
    ret
DrawUnderground ENDP

; ========================================
; Check horizontal collision
; ========================================

CheckHorizontalCollision PROC
    push edx
    
    call GetTile
    
    ; Check if tile is solid
    cmp al, TILE_EMPTY
    je notBlocked
    cmp al, TILE_COIN
    je notBlocked
    cmp al, TILE_CLOUD
    je notBlocked
    cmp al, TILE_QUESTION
    je notBlocked
    ; Ground and brick are solid
    mov al, 1
    jmp collisionDone
    
isBlocked:
    mov al, 1
    jmp collisionDone
    
notBlocked:
    mov al, 0
    
collisionDone:
    pop edx
    ret
CheckHorizontalCollision ENDP


END main
