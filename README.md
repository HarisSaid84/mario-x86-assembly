​Haris Said - 24I0527

This README summarizes the structure and features of the game.

1.Controls
A – Move left
D – Move right
W – Jump
Shift - Shoot fireball (Level 1 only).​
P – Pause game​
X – Exit game immediately​

​2.Displays:
TITLE SCREEN

MAIN MENU
-start game
-instructions
-high score
-exit​

PAUSE MENU
GAME OVER
LEVEL COMPLETE

3.Gameplay

Level 1: Grassland Adventure (Level 1)
Level 2: CastleFortress (Level 2)

4.HUD (Heads-Up Display)​

MARIO – Label for score.
Score – Increases from coins, enemies, blocks, and bonuses.
WORLD – Shows world/level numbers (e.g., 1-1, 1-2).
TIME – Countdown timer in seconds.
x with Lives count – Remaining lives.
​
5.Realistic Featues:
Gravity
Motion
Jumping 
collision detection
smooth motion

6.Level System and Tiles
The game uses a tile-based level map stored in levelMap with width 120 and height 30.​

Tile Types
TILE_EMPTY – Background.
TILE_GROUND – Ground blocks (Grassland Adventure).
TILE_BRICK – Solid bricks.
TILE_QUESTION – Question blocks with power-ups/points.​
TILE_COIN – Collectible coins.
TILE_CLOUD – Decorative clouds.
TILE_FLAGPOLE – End of Level 1 goal.
TILE_GROUND_UNDERGROUND – Castle fortress ground.
TILE_LAVA – Deadly lava (instant life loss).
TILE_AXE – Axe behind Bowser to end the boss level.
TILE_CLOCK – Time slow power-up.​

7.Enemies and Boss

4 Goombas (Level 1) (Represented as G)
They walk back and forth, turn around at edges or on collision, and respect gravity through ground checks.​
Player can defeat Goombas by jumping on them or htting them with fireball.​

Koopa Troopa (Level 1) (Represented as K)
Has walking state and direction; uses collision and ground checks similar to Goombas.​
It turns into a shell if mario jumps on it.

Bowser Boss (Level 2)

Bowser patrols a platform ​
Fires periodic fireballs using a separate fireball system.​

8.Collectibles and Power-Ups

Coins (Represented as O)
Score increases (+200).

Question Blocks (Represented as ?)
Player gets score bonus (+100).
​
Own Creative Feature (Represented as C)
​
For 5seconds:
timer slows down
enemies move 2x slower
Score bonus (+500) is awarded

9.Fireball Systems

Bowser Fireballs can kill mario
Mario’s Fireballs can kill enemies​

10.Level Progression and Win Conditions

Level 1 (Grassland Adventure)

Typical ground, pipes, bricks, clouds, coins, and enemies.
Win condition: reach flag and have at least a target score (1500).

On success: time in seconds is multiplied with 50 and added to score

Level 2 (Castle Fortress)

Lava at bottom, gray bricks, stalactites, Bowser on a platform.​
Win condition: reach the blue axe tile to defeat bowser

11.Lives start at 3
lava or enemy collisions decrement lives and reset position
​
12.Sound Effects:
Mario jumping
collecting coins
collecting question blocks
jumping on enemies
falling into lava

13.File Handling 

Store data per entry includes:

Player name (entered at start).
Score
Level at which player finished
Lives

14.Customization and Roll Number Features

“Fire Master Mario” theme for roll ending in 7.​ (24I0527)

Implemented custom features:​
Mario fireball shooting blue fireballs

HAPPY GAMING!

COAL - Fall 2025
Instructor - Usama Imran
