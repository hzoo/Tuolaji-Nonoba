[Zhu-Tuolaji](http://nonoba.com/hzoo/Tuolaji-Nonoba.)
---

**UPDATE 2013**: *nonoba.com* seems to be down or not working anymore.

![](http://i.imgur.com/LT2L81a.png)

I guess its a lesson in not finishing a game, as well as using someone else's server and server code. Maybe I'l redo do this in just HTML5 or for mobile.

Instructions
---
If you want to see it work, you should open the game in 4 windows or get some friends to join you.

Rules
---
- http://en.wikipedia.org/wiki/Bashi_Fen
- http://www.pagat.com/kt5/tractor.html.

Story..
---
- After my friends and everyone at our school started playing this game everyday, I thought why not try making it?
- Then I thought multiplayer would be cooler than singleplayer since someone already made one on kongregate (http://www.kongregate.com/games/Auway/tractor).
- Stopped working on this like 2 years ago? I tried redoing it on Player.IO...
- I didn't finish all the rules (checking for illegal card moves).
- Otherwise if everyone plays by honor system and no one disconnects it should work fine.
- Hopefully I'll be able to port this over to something that doesn't depend on someone else's server code in the future. 
- I really did spend a significant amount of time trying to get this to work and involved a lot of frustrated people to test it.


Features/Suggestions
---

Finishing the Game

- Implement forced matching (have to play a pair or w.e if you have one)
- multiply bottom correctly
- display captured points (everyone's points if ffa)
- option to show last hand (useful to find glitches maybe)

Features to add?

- even # of Players (2,4,6)
- x # of Decks
- show points already taken
- x # of Players - odd # = Finding Friends (FFA mode basically)
- Fix Card Overflow/Centering deck on screen for multiple decks
- Redo Interface
- Any Timers
- Autoplay (30 sec?)
- State what the person played (played pair of 4s)
- Keyboard Shortcuts (wasd/arrows/enter)
- Options Panel for game creator
- Meta-game/Leveling System
- Spectators (who cares? lol)
- Sounds...
- Music?
- Bots.
- if off focus - play sound if ure turn/chat
- each round show in-game ad with option to leave
- chat filter (is this really needed)
- tutorial
- If someone leaves (bot,option to invite/join)
- if someone disconnects- wait 30 to see if they come back?
- or vote to either ask someone else to play/wait


Random documentation I found
---
- Flash CS5
- SharpDevelop (or Visual Studio Express 2010)
- TortoiseSVN
- Nonoba/Player.IO (server)

Classes

- Player
    - attributes
        - value (int)
        - suit (int)
        - tuolaji reference (Tuolaji) - should be changed...
    - methods
        - getCompareValue()
        - equals
        - sameSuit
        - compareTo
- Card
- CardValue
    - Attributes
        - TWO = 2;
        - THREE = 3;
        - FOUR = 4;
        - FIVE = 5;
        - SIX = 6;
        - SEVEN = 7;
        - EIGHT = 8;
        - NINE = 9;
        - TEN = 10;
        - JACK = 11;
        - QUEEN = 12;
        - KING = 13;
        - ACE = 14;
        - CURRENTLEVEL = 15;
        - CURRENTLEVELSUIT = 16;
        - JOKERBLACK = 17;
        - JOKERRED = 18;
- Suit
    - Attributes
        - DIAMONDS = 0;
        - CLUBS = 1;
        - HEARTS = 2;
        - SPADES = 3;
        - JOKER = 4;
- ShuaiPart
    - Attributes
        - startCard (starting value of the shuaipart)
            - numSame
            - numConsecutive
            - ex: AAAKKK = A,3,2
        - methods
            - compareTo
- Tuolaji
- GameCode

Progress
----
I guess people can first give ideas for what they need in the game...
maybe important rules or variations that need to be included unlike kongregate's version.

11/22
v.001
- able to sort by suit and rank with trump card and jokers...

Add:
- make actual joker graphics rather than a colored jack.. (red and black)
- able to deal to x number of people with a bottom (i don't think there is an algorithm for this, so it might have to be a case by case basis).. but its more important to get 4 people working first of course.
- give option to choose trump suit in the beginning.

11/30
v.002
Video showing progress.
- server functionality - i know how to do stuff now.
- facelift for the cards
- only shows ure own cards instead of everyone's obviously... i thought of the smart idea (only logically idea) of transferring only needed cards (ure own + dealt)
- if you make a game - waits until specified number of people total (currently 4)
- it has the simple if you click on a card it moves up and if you click it again it moves down (up means you are selecting it to be played when you press some button)

Add:
- 5 buttons to choose trump (suits + no trump) and lets you keep changing it like kongregate.. then makes you master
- finally start the main part of the game. (wow rules)
- limit what cards you can select (when first person plays a suit, it won't let you select a different suit until you don't have the suit anymore)
- spectator mode not added yet (watch the deal's but not ppl's hands obviously)
- figure out anything to do with graphics and background.. and formatting of cards (where do you guys want the cards to be?) it seems easy with 4 players.. but what about x number of players...? should the cards be in some list... b/c it would be crowded with like 10 ppl or w.e

12/02
v.003 - tues/wed
- finished the 5 buttons to choose trump - looks horrible - the logic should work but i would rather it show up when you can overturn it and not show up when it can't
- added the bottom thing (gives you bottom if you won and lets you choose)
- it has the "play hand" button now

Add:
- graphics and anything related to that will have to change - i just need it functional right now.
- all the rules to know which cards you can play)
- spectator still
- stats like who is master, pts, point cards, trump suit, trump number/level, etc
- show what the person changed the trump suit to by showing the cards he trumped with when choosing trumps
- sort cards after trump suit is called
- organize code into more general methods

12/05
v.004
- finished choosing trump, showing the trump that is chosen when people fan so you know what they choose, sending and choosing bottom and play button, sorted cards again after final trump suit is chosen.
- stats, graphical updates based on what happens (points, cards played, master, trump level, suit)

Add: start!
- yea.. so being lazy i need someone to help me create an alg. to deal the cards out in a circular pattern given x players. il just used fixed numbers for 4 ppl for now but later it would different need some formula (simple) given that the card piles should be centered at some point.

12/12
v.005
ok i figured out the basic parts of the game and now you can play ure cards and whoever wins obviously can go first and the points add up. i'm working on the reset method to play the next round after the first though.
- i hardcoded the little square thing - so it will only work for 4 ppl.. and only team right now (across from you)
- if you want to play 1 round... feel free to try and then make a new game
- don't expect much - just a taste of what the game is obviously.

12/13-12/14
v.006
- added a selected card counter...
- primitive version of checking for illegitness... - only works for single cards lol.
- It counts ure points and tells you whose turn it is now!
- Add: reset.., custom illegit messages

12/27
v.010
- Ok so i can't believe i am not killing this whole thing right now but yea. 1 week later i found the bug go me. perseverance ftw.
- so it filters it so if you don't play first you have to play the same suit as the first turn person. points are working.. the thing at the end where you show the bottom and the points you get works..
- you can only play 1,2,4 cards right now (aka single, pair, tuolaji)
- Thus... it works in a way.

12/30
v.011
- Getting shuai done acutally (figured out one part of it)
- made it so that first turn person can only click on one suit.. same as other ppl have to follow that suit until they run out of that suit..

Add:
- fix display of information/cards... find a better layout?
- make it so the cards you hold separate black and red colors so its easier on the eyes (clubs/spades separate and hearts/diamonds separate)
- any errors? i didn't test the end game yet or what happens when you are about to win or you do win.. cuze takes too long to play through..
- let you shuai.

1/3
v.012
- uh added in shuai!! dono how well it works so people gota tell me what situations it doesn't work etc.
- Add: match format (if first person plays a pair and you have one you have to play it)
- if you can't do a shuai play the part that loses...

1/10
- its testing time/ bug finding...
