package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import Nonoba.api.*;

	import as3cards.core.DeckType;
	import as3cards.core.Suit;
	import as3cards.core.Card;
	import as3cards.core.CardValue;
	import as3cards.visual.CardPile;
	import as3cards.visual.SkinManager;
	import as3cards.visual.SpreadingDirection;
	import as3cards.visual.VisualCard;
	import as3cards.visual.VisualDeck;
	import tuolaji.PlayerPile;

	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import mochi.as3.*; 
	import mochi.as3.MochiAd;
	import mochi.MochiBot;
	
	public dynamic class MyGame extends MovieClip {
		//public var _mochiads_game_id:String = "42fd92ea33a63987";
		private var connection:Connection;
		private var infoBox:InfoBox;
		private var tf:TextField; //timer
		private var tf2:TextField; //cards selected
		private var information:TextField;
		private var myTimer:Timer;
		private var myTimer2:Timer;
		
		private var hasTurn:Boolean = false;
		private var isSpectator:Boolean = false;
		private var gameStarted:Boolean = false;
		private var canFan:Boolean = true;
		
		private var visualDeck:VisualDeck;
		//private var dealtPile:CardPile;
		private var playerPile:PlayerPile;
		//private var bottomPile:PlayerPile;
		private var pointsWonPile:CardPile;
		
		private var playerDealtHands:Array; //array playerPiles
		private var selectedPile:Array; //array selected visualcards
		private var playerCardsChangeSuit:Array; //array of which can fan
		private var playerNames:Array; //names
		private var saveCards:Array; //clone of cards given
		private var numCardsSuit:Array;
		
		private var numDecks:int;
		private var numPiles:int;//numPlayers
		private var numCards:int;
		private var numCardsBottom:int;
		private var numCardsToDeal:int;
		public static var currentLevel:int=2;//master level
		public static var currentSuit:int=0;//trump suit
		private var numCardsChangeSuit:int;
		private var playerNum:int;
		private var numCardsSelected:int = 0;
		private var currentMaster:int = -1;
		private var firstTurn:int = -1;
		
		private var chooseTrump_btn:chooseTrump;
		private var play_btn:playbtn;
		private var spectating:MovieClip;
		private var stats:stat;
		
		//handsDealt
		private var centerX:int = 250;
		private var centerY:int = 300;
		private var radius:int = 150;
		private var angle:Number;
		
		function MyGame()
		{
			stop();
			//42fd92ea33a63987
			//MochiServices.connect("42fd92ea33a63987", root);
			//trace("stagewidth : " + stage.stageWidth + " " + "stageHeight: " + stage.stageHeight);
			
			MochiAd.showPreGameAd({clip:root, id:"642ec13795562030", res:"800x650", ad_finished:adFinished});
		}

		public function adFinished():void
		{
            //MochiBot.track(this, "mochibot_id");
			//http://www.java2s.com/Tutorial/CSharp/
			stop();
			
			// MochiBot.com -- Version 8
			// Tested with Flash 9-10, ActionScript 3
			MochiBot.track(this, "d33bb351");
			
			//init mp api
			connection=NonobaAPI.MakeMultiplayer(stage,"localhost");
			//init waiting for players in MessageEvent.MESSAGE
			connection.addEventListener(MessageEvent.MESSAGE, onMessage);
			connection.addEventListener(ConnectionEvent.DISCONNECT, function(e){
				gotoAndStop("error");
			});
			
			infoBox = new InfoBox(resetGame,joinGame);
			addChild(infoBox);
			setRegistrationPoint( infoBox, infoBox.width >> 1, infoBox.height >> 1, true, false);
			infoBox.x = 100;
			infoBox.y = 450/2-100;
			
			playerNames = new Array();
			spectating = new MovieClip();
			spectating.x = 300;
			spectating.y = 600;
			spectating.visible = false;
			addChild(spectating);
			chooseTrump_btn = new chooseTrump();
			chooseTrump_btn.x = 300;
			chooseTrump_btn.y = 250;
			chooseTrump_btn.visible = false;
			addChild(chooseTrump_btn);
			play_btn = new playbtn();
			play_btn.x = 300;
			play_btn.y = 500;
			play_btn.visible = false;
			addChild(play_btn);
			stats = new stat();
			stats.x = 8;
			stats.y = 8;
			stats.visible = false;
			addChild(stats);
			
			infoBox.Show("waiting");
		}
		
		public function siteLock(): Boolean
		{
			var url:String=stage.loaderInfo.url;
			var urlStart:Number = url.indexOf("://")+3;
			var urlEnd:Number = url.indexOf("/", urlStart);
			var domain:String = url.substring(urlStart, urlEnd);
			var LastDot:Number = domain.lastIndexOf(".")-1;
			var domEnd:Number = domain.lastIndexOf(".", LastDot)+1;
			domain = domain.substring(domEnd, domain.length);
			if (domain != "nonoba.com") 
			{
				return false;
			}
			return true;
		}
		
		private function resetGame():void {
			connection.Send("reset");
			infoBox.Show("waiting");
		}
		
		private function joinGame():void {
			connection.Send("join");
			infoBox.Show("waiting");
		}

		public function init(arr:Array):void
		{
			//cleanUp(this);
			createBoard(arr);
			dealCards();
			
			myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
		}
		
		//generic children clean up (sounds weird)
		private function cleanUp(o:Object):void
		{	
			while ( o.numChildren > 0 ){
				o.removeChildAt( 0 );
			}
		}
		
		//create the one player hand pile for each client
		//init dealing cards
		private function createBoard(cards:Array):void
		{
			//visualDeck = new VisualDeck( DeckType.WITH_JOKERS ,numDecks);
			saveCards = cards;
			visualDeck = new VisualDeck(DeckType.WITH_JOKERS,numDecks,cards);
			playerPile = new PlayerPile(cards.length/2+8);
			addChild(playerPile);
			//setRegistrationPoint( playerPile, playerPile.width >> 1, playerPile.height >> 1, true, false);
			playerPile.x = 20;
			playerPile.y = 550;
		}
		
		//cards dealt in a timer (slowly)
		private function dealCards():void
		{	
			if (myTimer.running == false)
				myTimer.start();
		
			//textfield to show time left to fan
			tf = new TextField();
			tf.autoSize = flash.text.TextFieldAutoSize.RIGHT;
			tf.background = true;
			//tf.border = true;
			tf.type = TextFieldType.DYNAMIC;
			if (tf.visible == false)
				tf.visible = true;	
			
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0xFF0000;
			format.size = 30;
			tf.defaultTextFormat = format;
			var sp:Sprite = new Sprite();
			
			sp.addChild(tf);
			addChild(sp);
			setRegistrationPoint( sp, sp.width >> 1, sp.height >> 1, true, false);
			
			tf.x = 500;
			tf.y = 650 - 100 - 50;
			
			tf2 = new TextField();
			tf2.autoSize = flash.text.TextFieldAutoSize.RIGHT;
			tf2.background = true;
			tf2.type = TextFieldType.DYNAMIC;
			if (tf2.visible == true)
				tf2.visible = false;
			var sp2:Sprite = new Sprite();
			sp2.addChild(tf2);
			addChild(sp2);
			setRegistrationPoint( sp2, sp2.width >> 1, sp2.height >> 1, true, false);
			
			//here show the 5 buttons to choose trump suit
			//create listeners if the button is enabled (cards can change the suit)
			chooseTrump_btn.visible = true;
			chooseTrump_btn.chooseDiamond.addEventListener(MouseEvent.CLICK, trumpSuitHandler );
			chooseTrump_btn.chooseClub.addEventListener(MouseEvent.CLICK, trumpSuitHandler );
			chooseTrump_btn.chooseHeart.addEventListener(MouseEvent.CLICK, trumpSuitHandler );
			chooseTrump_btn.chooseSpade.addEventListener(MouseEvent.CLICK, trumpSuitHandler );
			chooseTrump_btn.chooseJoker.addEventListener(MouseEvent.CLICK, trumpSuitHandler );
			
			if (chooseTrump_btn.chooseDiamond.hasEventListener("trumpSuitHandler"))
				trace("has listener diamond");
		}
		
		private function trumpSuitHandler(e:MouseEvent):void
		{
			var suit:String = ((e.currentTarget.name).substring(6,e.currentTarget.name.length))+"s";
			var t:int;
			if (canFan == true)
			{
				for (var i:int = 0; i < 4; i++)
				{
					if (Suit.getName(i).localeCompare(suit) == 0)//(Suit.getName(i) == suit)
					{
						t = i;
						break;
					}
				}
				if (suit.localeCompare("Jokers") == 0)//(suit == "Joker")
				{
					if (playerCardsChangeSuit[5] >= playerCardsChangeSuit[4])
						t = 5;
					else
						t = 4;
				}
				var a:Boolean = (Boolean)(playerCardsChangeSuit[t] > numCardsChangeSuit);
				var b:Boolean = (Boolean)(t != 5 && t != 4);
				var c:Boolean = (Boolean)(playerCardsChangeSuit[t] >= 2);
				var d:Boolean = (Boolean)(currentSuit != 4);
				var f:Boolean = (Boolean)(currentSuit != 5);
				var g:Boolean = (Boolean)(playerCardsChangeSuit[t] >= numCardsChangeSuit);
				if ((a && b) || ( d && f && g && c && t == 4) || (f && g && t == 5 && c))
					connection.Send("choosetrump",playerNum,t,playerCardsChangeSuit[t]);
			}
			else
			{
				if (Suit.getName(currentSuit).localeCompare(suit) == 0)
				{
					t = currentSuit;
					if (playerCardsChangeSuit[5] > numCardsChangeSuit && currentSuit == 4 || playerCardsChangeSuit[t] > numCardsChangeSuit) 
						connection.Send("choosetrump",playerNum,t,playerCardsChangeSuit[t]);
				}
			}
		}
		
		private function timerHandler(e:TimerEvent):void
		{
			var card2:VisualCard = new VisualCard( visualDeck.deal(), false );
			playerPile.addCard(card2,0);
			
			if (card2.card.value == currentLevel) {
				if (card2.card.suit == 0) {
					playerCardsChangeSuit[0] = playerCardsChangeSuit[0]+1;
				}
				else if (card2.card.suit == 1) {
					playerCardsChangeSuit[1] = playerCardsChangeSuit[1]+1;
				}
				else if (card2.card.suit == 2) {
					playerCardsChangeSuit[2] = playerCardsChangeSuit[2]+1;
				}
				else
					playerCardsChangeSuit[3] = playerCardsChangeSuit[3]+1;
			}
			if (card2.card.value == CardValue.JOKERBLACK) {
				playerCardsChangeSuit[4] = playerCardsChangeSuit[4]+1;
			}
			else if (card2.card.value == CardValue.JOKERRED) {
				playerCardsChangeSuit[5] = playerCardsChangeSuit[5]+1;
			}
		}
		private function completeHandler(e:TimerEvent):void
		{
			//could ask to fan one more time or just skip that
			//buttons/listeners removed
			//server figures out master/teams
			myTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
			myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			//time left to fan - also can be used for time left to play hand (30 sec)?
			myTimer2 = new Timer(1000,5);
			myTimer2.addEventListener(TimerEvent.TIMER, displayTimeLeft);
			myTimer2.addEventListener(TimerEvent.TIMER_COMPLETE, finishFan);
			//show time limit left to fan
			myTimer2.start();
		}
		
		private function displayTimeLeft(e:TimerEvent):void
		{
			tf.text = (myTimer2.repeatCount-myTimer2.currentCount) + "";
		}
		
		private function finishFan(e:TimerEvent):void
		{
			//after time limit
			//remember to remove on everyone else's screen
			if (playerDealtHands[0].numChildren != 0)
				cleanUp(playerDealtHands[0]);
			//set picture to currentSuit
			
			//what if no one fans?
			
			///////////////////////////////////////////////////////////////////////////////////////////////////
			if (currentSuit == 5)
				currentSuit = 4;
			
			mySort(playerPile);
			
			//remove button/listeners
			chooseTrump_btn.visible = false;
			chooseTrump_btn.chooseDiamond.removeEventListener(MouseEvent.CLICK, trumpSuitHandler );
			chooseTrump_btn.chooseClub.removeEventListener(MouseEvent.CLICK, trumpSuitHandler );
			chooseTrump_btn.chooseHeart.removeEventListener(MouseEvent.CLICK, trumpSuitHandler );
			chooseTrump_btn.chooseSpade.removeEventListener(MouseEvent.CLICK, trumpSuitHandler );
			chooseTrump_btn.chooseJoker.removeEventListener(MouseEvent.CLICK, trumpSuitHandler );
			myTimer2.removeEventListener(TimerEvent.TIMER, displayTimeLeft);
			myTimer2.removeEventListener(TimerEvent.TIMER_COMPLETE, finishFan);
			
			if (tf.text == "0")
				tf.visible = false;
			//removeChild(tf.parent);
			
			//allow cards to be selected
			for ( var i:int = 0; i < playerPile.numChildren; i++ )
			{
				configureSelect((VisualCard)(playerPile.getChildAt(i)),true);
			}
			
			//add bottom to master
			if (currentMaster == -1)
			{
				if (canFan == false)
					connection.Send("giveBottom");
				else
					connection.Send("noBottom",playerNum);
			}
			else if (currentMaster == playerNum)
					connection.Send("giveBottom");
				
		}
		
		private function mySort(p:PlayerPile):void
		{
			cleanUp(p);
			visualDeck = new VisualDeck(DeckType.WITH_JOKERS,numDecks,saveCards);
			
			numCardsSuit = new Array();
			for (var i:int = 0; i < 5; i++)
			{
				numCardsSuit[i] = 0;
			}
			
			while (visualDeck.isEmpty() != true)
			{
				var card2:VisualCard = new VisualCard( visualDeck.deal(), false );
				p.addCard(card2,currentSuit);
				//card2.buttonMode = false;
				if (isTrump(card2))
				{
					numCardsSuit[4] = numCardsSuit[4]+1;
				}
				else
				{
					numCardsSuit[card2.card.suit] = numCardsSuit[card2.card.suit]+1;
				}
			}
		}
		
		public function configureSelect(card:VisualCard, canSelect:Boolean):void
		{
			if (canSelect == true)// && card.hasEventListener("checkSelectFilter") == false)// && card.buttonMode == false)
			{
				card.addEventListener( MouseEvent.MOUSE_UP, checkSelectFilter );
				card.buttonMode = true;
			}
			else if (canSelect == false)// && card.hasEventListener("checkSelectFilter") == true)// && card.buttonMode == true)
			{
				card.removeEventListener( MouseEvent.MOUSE_UP, checkSelectFilter );
				card.buttonMode = false;
			}
		}
		
		
		private function checkSelectFilter( event:Event ):void
		{
			var card:VisualCard = ((VisualCard)(event.currentTarget));
			card.selectToggle();
			if (card.isSelected == true)
			{
				numCardsSelected = numCardsSelected + 1;
				//remove card from numCardsSuit - uses == so test it
				if (isTrump(card))
					numCardsSuit[4] = numCardsSuit[4]-1;
				else
					numCardsSuit[card.card.suit] = numCardsSuit[card.card.suit]-1;
				
				if (playerNum == firstTurn && numCardsSelected == 1)
					toggleSelectFirstCards(card);
			}
			else
			{
				numCardsSelected = numCardsSelected - 1;
				//add card from numCardsSuit
				if (isTrump(card))
					numCardsSuit[4] = numCardsSuit[4]+1;
				else
					numCardsSuit[card.card.suit] = numCardsSuit[card.card.suit]+1;
				
				if (playerNum == firstTurn && numCardsSelected == 0)
					setCardsTrue();
			}
			
			if (numCardsSelected > 0)
			{
				if (tf.visible == false)
					tf.visible = true;
				tf.text = numCardsSelected+"";
			}
			else
			{
				if (tf.visible == true)
					tf.visible = false;
			}
			
			if (gameStarted == true)
			{
				if (firstTurn != playerNum)
					toggleSelectCards();
			}
			else
			{
				tf.text = numCardsSelected+"/"+numCardsBottom;
			}
		}
		
		private function toggleSelectFirstCards(firstC:VisualCard):void
		{
			for ( var i:int = 0; i < playerPile.numChildren; i++ )
			{
				var c:VisualCard = (VisualCard)(playerPile.getChildAt(i));
				if (c.isSelected == false)
				{
					if (!isTrump(firstC) && c.card.suit == firstC.card.suit && c.card.value != currentLevel)
					{
						configureSelect(c,true);
					}
					else if (isTrump(firstC) && isTrump(c))
					{
						configureSelect(c,true);
					}
					else
					{
						configureSelect(c,false);
					}
				}
				else
				{
					configureSelect(c,true);
				}
			}
		}
		
		private function toggleSelectCards():void
		{
			trace("toggleSelectCards");
			//tf2.text = "tSc " + (playerNum != firstTurn) + playerNum + firstTurn;
			if (firstTurn != playerNum)
			{
				var whichPile:int;
				whichPile = (firstTurn+(numPiles-playerNum))%numPiles;
				var firstCard:VisualCard;
	
				firstCard = ((VisualCard)(playerDealtHands[whichPile].getChildAt(0)));
					
				//information.visible = true;
				//information.x = 100;
				//information.width = 300;
				for ( var i:int = 0; i < playerPile.numChildren; i++ )
				{
					var c:VisualCard = (VisualCard)(playerPile.getChildAt(i));
	
					if (c.isSelected == false)
					{
						//information.appendText(c + "\n");
						//information.appendText(!isTrump(firstCard) + " " + (numCardsSuit[firstCard.card.suit] > 0) + " " + (c.card.suit == firstCard.card.suit) + " " + (c.card.value != currentLevel) + "\n");
						//information.appendText(isTrump(firstCard) + " " + (numCardsSuit[4] > 0) + " " + isTrump(c));
						//information.appendText( (numCardsSuit[firstCard.card.suit] == 0) + " " + !isTrump(firstCard) + " or " + (numCardsSuit[4] > 0) + " " + isTrump(firstCard));
						if (playerNum != firstTurn)
						{
							if (!isTrump(firstCard) && numCardsSuit[firstCard.card.suit] > 0 && c.card.suit == firstCard.card.suit && c.card.value != currentLevel)
							{
								configureSelect(c,true);
							}
							else if (isTrump(firstCard) && numCardsSuit[4] > 0 && isTrump(c))
							{
								configureSelect(c,true);
							}
							else if (numCardsSuit[firstCard.card.suit] <= 0 && !isTrump(firstCard) || numCardsSuit[4] <= 0 && isTrump(firstCard))
							{
								configureSelect(c,true);
							}
						}
					}
					else
					{
						configureSelect(c,true);
					}
				}
			}
		}
		
		public function setCardsTrue():void
		{
			for ( var i:int = 0; i < playerPile.numChildren; i++ )
			{
				var c:VisualCard = (VisualCard)(playerPile.getChildAt(i));
				configureSelect(c,true);
			}
		}
		
		public function setCardsFalse():void
		{
			for ( var i:int = 0; i < playerPile.numChildren; i++ )
			{
				var c:VisualCard = (VisualCard)(playerPile.getChildAt(i));
				configureSelect(c,false);
			}
		}
		
		public function isTrump(c:VisualCard):Boolean
		{
            if (c.card.value == CardValue.JOKERBLACK || c.card.value == CardValue.JOKERRED || c.card.value == currentLevel || c.card.suit == currentSuit)
				return true;
			else
				return false;
		}

		private function onMessage(e:Object) {
			var message:Object=e.message;
			switch (message.Type) {
				case "update" :
				{
					trace("User: " + message.GetInt(0) + " Score: " + message.GetInt(1));
				};
				case "unselectall" :
				{
					setCardsFalse();
					break;
				};
				case "playerinit" :
				{
					isSpectator = false;
					spectating.visible = false;
					playerNum = message.GetInt(0);
					playerNames[message.GetInt(0)] = createTextField(message.GetInt(0),message.GetString(1));
					addChild(playerNames[message.GetInt(0)]);
					break;
				};
				case "joined" :
				{
					//cleanUp();
					for (var i:int = 0; i < message.GetString(0); i++)
                    {
						playerNames[i] = createTextField(i,message.GetString(i+1));
						addChild(playerNames[i]);
					}
					break;
				};
				case "full" : {
					infoBox.Show("full");
					break;
				};
				case "reset" :
				{
					hasTurn = false;
					canFan = true;
					
					play_btn.visible = false;
					
					var num = 1;
					currentLevel = message.GetInt(num);
					currentSuit = message.GetInt(num+1);
					numPiles = message.GetInt(num+2);
					angle = 360/numPiles;
					
					numDecks = message.GetInt(num+3);
					numCards = 54*numDecks;
					numCardsBottom = message.GetInt(num+4); //need case by case basis
					numCardsToDeal = numCards - numCardsBottom;
					currentMaster = message.GetInt(num+5);
					gameStarted = false;
					numCardsSelected = 0;
					numCardsChangeSuit = 0;
					firstTurn = -1;
					
					//numCardsChangeSuit = message.GetInt(num+5);
					playerCardsChangeSuit = new Array();
					for (var b:int = 0; b < 6; b++) {
						playerCardsChangeSuit.push(0);
					}
					
					selectedPile = new Array();
					stats.visible = true;
					myTimer = new Timer (400,numCardsToDeal/numPiles);
					
					stats.trump.text    = "";
					stats.spade.text    = "";
					stats.heart.text    = "";
					stats.club.text     = "";
					stats.diamond.text  = "";
					stats.clevel.text = "Level: " + CardValue.getName(currentLevel);
					stats.suit.text   = "Suit: ?";// + Suit.getName(currentSuit);
					
					stats.clevel.autoSize = TextFieldAutoSize.LEFT;
					stats.suit.autoSize = TextFieldAutoSize.LEFT;
					stats.master.autoSize = TextFieldAutoSize.LEFT;
					stats.turn.autoSize = TextFieldAutoSize.LEFT;
					stats.point.autoSize = TextFieldAutoSize.LEFT;
					
					if (currentMaster == -1)
					{
						stats.master.text = "Master: ?";
						stats.turn.text   = "Turn: ?";
					}
					else
					{
						stats.master.text = "Master: " + playerNames[currentMaster].text.substring(10);
						stats.turn.text   = "Turn: " + playerNames[currentMaster].text.substring(10);
					}
					stats.point.text  = "Points: 0";
					
					infoBox.Hide();
					
					/*information = new TextField();
					information.visible = false;
					//information.x = 450;
					//information.y = 100+20*(playerNum+1);
					information.autoSize = flash.text.TextFieldAutoSize.RIGHT;
					information.background = true;
					information.border = true;
		
					var format:TextFormat = new TextFormat();
					format.font = "Verdana";
					format.color = 0xFF0000;
					format.size = 10;
					information.defaultTextFormat = format;
					addChild(information);*/
					
					break;
				};
				case "dealcards" :
				{
					var a:Array = new Array();
					for (var j:int = 1; j < message.GetInt(0)*2+1; j++)
					{
						a.push(message.GetInt(j));
					}
					init(a);
					
					if (playerDealtHands != null && playerDealtHands[0] != null)
						removeChild(playerDealtHands[0]);
					
					playerDealtHands = new Array();

					for (var nump:int = 0; nump < numPiles; nump++)
					{
						var posAngle:Number = angle*nump;
						playerDealtHands[nump] = new PlayerPile();
						playerDealtHands[nump].x = centerX;
						playerDealtHands[nump].y = centerY;
						var xToAdd:int = radius*Math.cos((posAngle+90) * Math.PI/180);
						var yToAdd:int = radius*Math.sin((posAngle+90) * Math.PI/180);
						//trace("nump : " + nump);
						//trace("xAdd: " + xToAdd);
						//trace("yAdd: " + yToAdd);
						playerDealtHands[nump].x += xToAdd;
						playerDealtHands[nump].y += yToAdd;
						addChild(playerDealtHands[nump]);
					}

					break;
				}
				case "leave" :
				{
					if (playerNames[message.GetInt(0)] != null)
						playerNames[message.GetInt(0)].text = "";
					infoBox.Show("waiting",isSpectator ? "ok" : "");
					break;
				};
				//place, win
				case "spectator" :
				{
					isSpectator = true;
					
					spectating.visible = true;
					infoBox.Hide();
					break;
				};
				case "newsuit" :
				{
					//trace(message);
					//trace("newsuit - message.GetInt(0): " + message.GetInt(0));
					if (playerNum == message.GetInt(0))
						canFan = false;
					else
						canFan = true;
					
					currentSuit = message.GetInt(1);
					numCardsChangeSuit = message.GetInt(2);
					
					//playerNum has fanned
					
					if (currentSuit == 5)
						stats.suit.text = "Suit: " + Suit.getName(4);
					else
						stats.suit.text = "Suit: " + Suit.getName(currentSuit);
					if (message.GetInt(0) != -1)
						stats.turn.text = "Turn: " + playerNames[message.GetInt(0)].text.substring(10);
					//trace(Suit.getName(currentSuit));
					//trace(playerNames[message.GetInt(0)]);
					
					if (playerDealtHands[0].numChildren != 0)
						cleanUp(playerDealtHands[0]);
										
					for (var a1:int = 0; a1 < numCardsChangeSuit; a1++)
					{
						if (currentSuit != 4 && currentSuit != 5)
							playerDealtHands[0].addCard(new VisualCard(new Card(currentLevel,currentSuit)),currentSuit);
						else if (currentSuit == 4)
							playerDealtHands[0].addCard(new VisualCard(new Card(CardValue.JOKERBLACK,Suit.JOKER)),currentSuit);
						else if (currentSuit == 5)
							playerDealtHands[0].addCard(new VisualCard(new Card(CardValue.JOKERRED,Suit.JOKER)),currentSuit);
					}
					
					break;
				}
				case "getBottom" :
				{
					//information.text = "getBottom";
					for (var d:int = 1; d < message.GetInt(0)*2+1; d+=2)
					{
						var c:VisualCard = new VisualCard(new Card(message.GetInt(d),message.GetInt(d+1)));
						playerPile.addCard(c,currentSuit);
						//information.text = "card" + c;
						//c.buttonMode = false;
						if (isTrump(c))
						{
							numCardsSuit[4] = numCardsSuit[4]+1;
						}
						else
						{
							numCardsSuit[c.card.suit] = numCardsSuit[c.card.suit]+1;
						}
					}
					
					for ( var f:int = 0; f < playerPile.numChildren; f++ )
					{
						if ((VisualCard)(playerPile.getChildAt(f)).buttonMode == false)
							configureSelect((VisualCard)(playerPile.getChildAt(f)),true);
					}
					
					//show play hand btn
					if (play_btn.visible == false)
						play_btn.visible = true;
					play_btn.addEventListener(MouseEvent.CLICK,sendBottom);
					break;
				}
				case "play" :
				{
					var whoseTurn:int = message.GetInt(0);
					var whoseFirst:int = message.GetInt(2);
					
					tf2.visible = false;
					
					if (whoseTurn == playerNum) 
						hasTurn = true;
					else
						hasTurn = false;
						
					firstTurn = whoseFirst;
					
					//type to ask to play cards
					//play button visible and cards able to select and press play
					//can only select same suit unless.
					//sends the cards for verification (shuai) after checking if legit (right suit etc) using dealt hand
					if (gameStarted == false)
						gameStarted = true;

					//information.text = "hTurn: " + hasTurn + " m0: " + whoseTurn + " fT: " + firstTurn + " pNum: " + playerNum;
					
					if (hasTurn == true)
					{			
						if (play_btn.visible == false)
							play_btn.visible = true;
						
						play_btn.addEventListener(MouseEvent.CLICK,checkLegit);
					
						trace("play visible");
						
						/*tf2.visible = true;
						tf2.x = stage.stageWidth/2-150;
						tf2.text = "hTurn: " + this.hasTurn + " m0: " + message.GetInt(0) + " fT: " + firstTurn;
						tf2.width = 250;
						tf2.wordWrap = true;*/
						
						if (playerNum == firstTurn)
						{
							//information.appendText("pNum == fTurn");
							setCardsTrue();							
						}
						else
						{
							//information.appendText("pNum != fTurn");
							toggleSelectCards();
						}
						
						//message - illegit
						if (message.GetBoolean(1) == true && playerNum != firstTurn)
						{
							trace("illegit");
							tf2.x = stage.stageWidth/2-150;
							tf2.y = stage.stageHeight-600;
							tf2.visible = true;
							tf2.text = "you played illegit";
							selectedPile = new Array();
						}
					}
					else
					{
						if (play_btn.visible == true)
							play_btn.visible = false;
							
						//tf2.visible = true;
						//tf2.x = 400-150;
						//tf2.text = "hTurn: " + this.hasTurn + " m0: " + message.GetInt(0) + " fT: " + firstTurn;
					}

					stats.trump.text    = "Trump      : " + numCardsSuit[4];
					stats.spade.text    = Suit.getName(0) + ": " + numCardsSuit[0];
					stats.heart.text    = Suit.getName(1) + "       : " + numCardsSuit[1];
					stats.club.text     = Suit.getName(2) + "      : " + numCardsSuit[2];
					stats.diamond.text  = Suit.getName(3) + "    : " + numCardsSuit[3];
					stats.turn.text   = "Turn: " + playerNames[whoseTurn].text.substring(10);
					break;
				}
				case "illegit" :
				{
					trace("illegit");
					tf2.x = 400-150;
					tf2.y = 650-600;
					tf2.visible = true;
					tf2.text = (playerNames[whoseTurn].text.substring(10))  + " was illegit";
					
					var whichPile:int = (firstTurn+(numPiles-playerNum))%numPiles;
					cleanUp(playerDealtHands[whichPile]);
					
					if (playerNum == firstTurn)
					{
						setCardsFalse();
							
						if (play_btn.visible == true)
							play_btn.visible = false;

						trace(message.GetInt(0));
						
						for (var j4:int = 0; j4 < selectedPile.length; j4++)
						{
							selectedPile[j4].unselect();
						}
						selectedPile = new Array();
						
						//var shuaiFail:Array = new Array();
						for (var sf:int = 1; sf < message.GetInt(0)*2+1; sf+=2)
						{
							var sp:VisualCard = new VisualCard(new Card(message.GetInt(sf),message.GetInt(sf+1)));
							trace(sp);
							selectedPile.push(sp);
							
							for (var a2:int = 0; a2 < playerPile.numChildren; a2++)
							{
								var c4:VisualCard = ((VisualCard)(playerPile.getChildAt(a2)));
								if (c4.equals(sp))
								{
									if (c4.hasEventListener("checkSelectFilter"))
										c4.removeEventListener(MouseEvent.MOUSE_UP,checkSelectFilter);
									playerPile.removeCard(c4).getChildAt(0);
									break;
								}
							}
						}

						if (play_btn.visible == true)
							play_btn.visible = false;
						play_btn.removeEventListener(MouseEvent.CLICK,checkLegit);
						
						var m:Message = new Message("sendIfLegit");
						m.Add(selectedPile.length);
						for (var j5:int = 0; j5 < selectedPile.length; j5++)
						{
							var d4:VisualCard = selectedPile[j5];
							m.Add(d4.card.value);
							m.Add(d4.card.suit);
						}
						connection.Send(m);
					}
					break;
				}
				case "start" :
				{					
					currentMaster = message.GetInt(0);
					currentLevel = message.GetInt(1);
					
					stats.clevel.text = "Level: " + CardValue.getName(currentLevel);
					stats.suit.text   = "Suit: " + Suit.getName(currentSuit);
					stats.master.text = "Master: " + playerNames[currentMaster].text.substring(10);
					stats.turn.text   = "Turn: " + playerNames[currentMaster].text.substring(10);
					stats.point.text  = "Points: 0";
					
					//playerDealtHands = new Array();
					//playerDealtHands[0] = new PlayerPile();
					//playerDealtHands[0].x = stage.stageWidth/2-150;
					//playerDealtHands[0].y = stage.stageHeight-200;
					//addChild(playerDealtHands[0]);
					
					/*playerDealtHands[1] = new PlayerPile();
					playerDealtHands[1].x = 400;
					playerDealtHands[1].y = 650-200-150;
					addChild(playerDealtHands[1]);
					
					playerDealtHands[2] = new PlayerPile();
					playerDealtHands[2].x = 250;
					playerDealtHands[2].y = 650-200-300;
					addChild(playerDealtHands[2]);
					
					playerDealtHands[3] = new PlayerPile();
					playerDealtHands[3].x = 100;
					playerDealtHands[3].y = 650-200-150;
					addChild(playerDealtHands[3]);*/
					
					//trace("start");
					break;
				}
				case "cards":
				{
					for (var w:int = 1; w < message.GetInt(0)*2+1; w+=2)
					{
						var r:VisualCard = new VisualCard(new Card(message.GetInt(w),message.GetInt(w+1)));
						//trace(r);
					}
					break;
				}
				case "showhand" :
				{
					trace("showhand");
					//trace("numcards: " + message.GetInt(0));
					//trace("end: " + message.GetInt(0)*2+1);
					var end:int = message.GetInt(0)*2+1;
					
					var playerHand:int = (message.GetInt(end)+(numPiles-playerNum))%numPiles;
					
					for (var d2:int = 1; d2 < end; d2+=2)
					{
						var c2:VisualCard = new VisualCard(new Card(message.GetInt(d2),message.GetInt(d2+1)));
						playerDealtHands[playerHand].addCard(c2,currentSuit);
						//trace("value: " + message.GetInt(d2));
						//trace("suit : " + message.GetInt(d2+1));
					}
					break;
				};
				case "clear cards":
				{
					for each (var pp:PlayerPile in playerDealtHands)
					{
						cleanUp(pp);
					}
					/*cleanUp(playerDealtHands[0]);
					cleanUp(playerDealtHands[1]);
					cleanUp(playerDealtHands[2]);
					cleanUp(playerDealtHands[3]);*/
					break;
				}
				case "points":
				{
					stats.point.text   = "Points: " + message.GetInt(0);
					break;
				}
				case "legit":
				{
					sendCards();
					break;
				}
				case "win":
				{
					if (message.GetInt(0) == 0 || message.GetInt(0) == 2)
					{
						if (playerNum == 0 || playerNum == 2)
						{
							infoBox.Show("showWinner","you win");
						}
						else
						{
							infoBox.Show("showWinner","you lose");
						}
					}
					else
					{
						if (playerNum == 0 || playerNum == 2)
						{
							infoBox.Show("showWinner","you lose");
						}
						else
						{
							infoBox.Show("showWinner","you win");
						}
					}
					break;
				}
				case "showBottom":
				{
					for each (var pp2:PlayerPile in playerDealtHands)
					{
						cleanUp(pp2);
					}
					
					for (var d3:int = 1; d3 < message.GetInt(0)*2+1; d3+=2)
					{
						var c3:VisualCard = new VisualCard(new Card(message.GetInt(d3),message.GetInt(d3+1)));
						playerDealtHands[0].addCard(c3,currentSuit);
					}
					var ptsAdd:int = message.GetInt(message.GetInt(0)*2+1);
					var total:int = message.GetInt(message.GetInt(0)*2+2);
					stats.point.text   = "Points: " + (total-ptsAdd) + " + " + ptsAdd + " = " + total;
					//show the math

					removeChild(playerPile);
					for (var n5:int = 1; n5 < numPiles; n5++)
					{
						removeChild(playerDealtHands[n5]);
					}
					break;
				}
				case "showOrganized":
				{
					var cards:String = "";
					for (var n:int = 1; n <= message.GetInt(0); n++)
					{
						if (message.GetInt(n) != -1)
							cards += (message.GetInt(n)+"");
						else
							cards += " ";
					}
					trace(cards);
					break;
				}
				case "showOrganizedShuai":
				{
					var cards2:String = "";
					for (var n2:int = 0; n2 <= message.GetInt(0); n2++)
					{
						cards2 += (message.GetString(n2)+"\n");
					}
					trace(cards2);
					break;
				}
				default :
				{
					trace("Got unhandled message > " + message);
				};
			}
		}
		
		private function sendBottom(e:MouseEvent):void
		{
			if (numCardsSelected == numCardsBottom)
			{
				//trace("removed"); // gets to this
				for (var a:int = 0; a < playerPile.numChildren; a++)
				{
					var c:VisualCard = ((VisualCard)(playerPile.getChildAt(a)));
					//trace(c + " " + c.isSelected);
					if (c.isSelected)
					{
						if (c.hasEventListener("checkSelectFilter"))
							c.removeEventListener(MouseEvent.MOUSE_UP,checkSelectFilter);
						selectedPile.push(playerPile.removeCard(c).getChildAt(0));
						a--;
					}
				}
				if (play_btn.visible == true)
					play_btn.visible = false;
				play_btn.removeEventListener(MouseEvent.CLICK,sendBottom);
				
				var m:Message = new Message("sendBottom");
				m.Add(selectedPile.length);
				for (var j:int = 0; j < selectedPile.length; j++)
				{
					var b:VisualCard = selectedPile[j];
					m.Add(b.card.value);
					m.Add(b.card.suit);
				}
				connection.Send(m);
				
				var m2:Message = new Message("sendPlayerPile");
				m2.Add(playerPile.numChildren);
				for (var k:int = 0; k < playerPile.numChildren; k++)
				{
					var cv:VisualCard = ((VisualCard)(playerPile.getChildAt(k)));
					m2.Add(cv.card.value);
					m2.Add(cv.card.suit);
				}
				connection.Send(m2);
				selectedPile = new Array();
				connection.Send("start");
				tf2.visible = false;
				numCardsSelected = 0;
			}
		}
		
		private function checkLegit(e:MouseEvent):void
		{
			trace("clicked legit");
			if (numCardsSelected > 0)// == 1 || numCardsSelected == 2 || numCardsSelected == 4)
			{
				for (var a:int = 0; a < playerPile.numChildren; a++)
				{
					var c:VisualCard = ((VisualCard)(playerPile.getChildAt(a)));
					if (c.isSelected)
					{
						selectedPile.push(c);//playerPile.removeCard(c).getChildAt(0));
						//a--;
					}
				}
				if (play_btn.visible == true)
					play_btn.visible = false;
				play_btn.removeEventListener(MouseEvent.CLICK,checkLegit);
				
				var m:Message = new Message("sendIfLegit");
				m.Add(selectedPile.length);
				for (var j:int = 0; j < selectedPile.length; j++)
				{
					var d:VisualCard = selectedPile[j];
					m.Add(d.card.value);
					m.Add(d.card.suit);
				}
				connection.Send(m);
				//selectedPile = new Array();
			}
		}
		
		private function sendCards():void
		{
			trace("clicked send");
			for (var a:int = 0; a < playerPile.numChildren; a++)
			{
				var c:VisualCard = ((VisualCard)(playerPile.getChildAt(a)));
				if (c.isSelected)
				{
					if (c.hasEventListener("checkSelectFilter"))
						c.removeEventListener(MouseEvent.MOUSE_UP,checkSelectFilter);
					playerPile.removeCard(c).getChildAt(0);
					a--;
				}
			}
				
				//play_btn.removeEventListener(MouseEvent.CLICK,sendCards);
				if (play_btn.visible == true)
					play_btn.visible = false;
				
				var m:Message = new Message("sendCards");
				m.Add(selectedPile.length);
				for (var j:int = 0; j < selectedPile.length; j++)
				{
					var d:VisualCard = selectedPile[j];
					m.Add(d.card.value);
					m.Add(d.card.suit);
				}
				connection.Send(m);
				selectedPile = new Array();
				numCardsSelected = 0;
				tf.visible  = false;
				tf2.visible = false;
		}
		
		public function setRegistrationPoint(s:Sprite, regx:Number, regy:Number, showRegistration:Boolean, centerx:Boolean = false)
		{
			//translate movieclip 
			s.transform.matrix = new Matrix(1, 0, 0, 1, -regx, -regy);
			
			//registration point.
			if (showRegistration)
			{
				var mark:Sprite = new Sprite();
				mark.graphics.lineStyle(1, 0x000000);
				mark.graphics.moveTo(-5, -5);
				mark.graphics.lineTo(5, 5);
				mark.graphics.moveTo(-5, 5);
				mark.graphics.lineTo(5, -5);
				s.parent.addChild(mark);
			}
			
			if (centerx)
				s.x = (650-200)/2;
			//to center call setRegistrationPoint( mc, mc.width >> 1, mc.height >> 1, true); 
		}
		
		private function createTextField(playerNum:Number,playerName:String):TextField {
			var tf:TextField = new TextField();
			tf.x = 460;
			tf.y = 90+20*(playerNum+1);
			tf.autoSize = flash.text.TextFieldAutoSize.RIGHT;
			tf.background = true;
			//tf.border = true;

			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0xFF0000;
			format.size = 10;
			tf.defaultTextFormat = format;
			tf.text = "Player " + (playerNum+1) + ": " + playerName;
			addChild(tf);
            return tf;
        }
	}
};