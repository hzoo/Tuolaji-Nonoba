/*
 * Copyright (c) 2007 Darron Schall
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package as3cards.visual
{
	
import as3cards.core.Card;
import as3cards.core.CardValue;
import as3cards.core.Suit;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;

/**
 * The default skin defines the default images used for
 * the cards and deck.  Create a new class similar to this
 * one to create your own skin, and change SkinManager to
 * use your own skin class instead.  You must implement
 * the ISkinCreator interface, and then set SkinManager.skinCreator
 * to an instance of the class that creates the skin.
 */
public class DefaultSkin implements ISkinCreator
{
	
	/*[Embed(source="/../Flash/assets/skins/default/Deck.jpg")]
	private var Deck:Class;
	
	[Embed(source="/../Flash/assets/skins/default/DeckEmptyCycle.swf")]
	private var DeckEmptyCycle:Class;
	
	[Embed(source="/../Flash/assets/skins/default/DeckEmptyNoCycle.swf")]
	private var DeckEmptyNoCycle:Class;
	
	[Embed(source="/../Flash/assets/skins/default/EmptyPileBlue.swf")]
	private var EmptyPileBlue:Class;

	[Embed(source="/../Flash/assets/skins/default/EmptyPileGreen.swf")]
	private var EmptyPileGreen:Class;
	
	[Embed(source="/../Flash/assets/skins/default/TwoClubs.swf")]
	public var TwoClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/TwoDiamonds.swf")]
	public var TwoDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/TwoHearts.swf")]
	public var TwoHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/TwoSpades.swf")]
	public var TwoSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/ThreeClubs.swf")]
	public var ThreeClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/ThreeDiamonds.swf")]
	public var ThreeDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/ThreeHearts.swf")]
	public var ThreeHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/ThreeSpades.swf")]
	public var ThreeSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/FourClubs.swf")]
	public var FourClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/FourDiamonds.swf")]
	public var FourDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/FourHearts.swf")]
	public var FourHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/FourSpades.swf")]
	public var FourSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/FiveClubs.swf")]
	public var FiveClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/FiveDiamonds.swf")]
	public var FiveDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/FiveHearts.swf")]
	public var FiveHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/FiveSpades.swf")]
	public var FiveSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/SixClubs.swf")]
	public var SixClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/SixDiamonds.swf")]
	public var SixDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/SixHearts.swf")]
	public var SixHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/SixSpades.swf")]
	public var SixSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/SevenClubs.swf")]
	public var SevenClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/SevenDiamonds.swf")]
	public var SevenDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/SevenHearts.swf")]
	public var SevenHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/SevenSpades.swf")]
	public var SevenSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/EightClubs.swf")]
	public var EightClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/EightDiamonds.swf")]
	public var EightDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/EightHearts.swf")]
	public var EightHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/EightSpades.swf")]
	public var EightSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/NineClubs.swf")]
	public var NineClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/NineDiamonds.swf")]
	public var NineDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/NineHearts.swf")]
	public var NineHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/NineSpades.swf")]
	public var NineSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/TenClubs.swf")]
	public var TenClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/TenDiamonds.swf")]
	public var TenDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/TenHearts.swf")]
	public var TenHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/TenSpades.swf")]
	public var TenSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/JackClubs.swf")]
	public var JackClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/JackDiamonds.swf")]
	public var JackDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/JackHearts.swf")]
	public var JackHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/JackSpades.swf")]
	public var JackSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/QueenClubs.swf")]
	public var QueenClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/QueenDiamonds.swf")]
	public var QueenDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/QueenHearts.swf")]
	public var QueenHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/QueenSpades.swf")]
	public var QueenSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/KingClubs.swf")]
	public var KingClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/KingDiamonds.swf")]
	public var KingDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/KingHearts.swf")]
	public var KingHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/KingSpades.swf")]
	public var KingSpades:Class;
	
	[Embed(source="/../Flash/assets/skins/default/AceClubs.swf")]
	public var AceClubs:Class;
	
	[Embed(source="/../Flash/assets/skins/default/AceDiamonds.swf")]
	public var AceDiamonds:Class;
	
	[Embed(source="/../Flash/assets/skins/default/AceHearts.swf")]
	public var AceHearts:Class;
	
	[Embed(source="/../Flash/assets/skins/default/AceSpades.swf")]
	public var AceSpades:Class;
	
	//add Jokers
	[Embed(source="/../Flash/assets/skins/default/JokerBlack.swf")]
	public var JokerBlack:Class;
	
	[Embed(source="/../Flash/assets/skins/default/JokerRed.swf")]
	public var JokerRed:Class;*/
	
	[Embed(source="/../Flash/cards/b.swf")]
	private var Deck:Class;
	
	[Embed(source="/../Flash/assets/skins/default/DeckEmptyCycle.swf")]
	private var DeckEmptyCycle:Class;
	
	[Embed(source="/../Flash/assets/skins/default/DeckEmptyNoCycle.swf")]
	private var DeckEmptyNoCycle:Class;
	
	[Embed(source="/../Flash/assets/skins/default/EmptyPileBlue.swf")]
	private var EmptyPileBlue:Class;

	[Embed(source="/../Flash/assets/skins/default/EmptyPileGreen.swf")]
	private var EmptyPileGreen:Class;
	
	[Embed(source="/../Flash/cards/2c.swf")]
	public var TwoClubs:Class;
	
	[Embed(source="/../Flash/cards/2d.swf")]
	public var TwoDiamonds:Class;
	
	[Embed(source="/../Flash/cards/2h.swf")]
	public var TwoHearts:Class;
	
	[Embed(source="/../Flash/cards/2s.swf")]
	public var TwoSpades:Class;
	
	[Embed(source="/../Flash/cards/3c.swf")]
	public var ThreeClubs:Class;
	
	[Embed(source="/../Flash/cards/3d.swf")]
	public var ThreeDiamonds:Class;
	
	[Embed(source="/../Flash/cards/3h.swf")]
	public var ThreeHearts:Class;
	
	[Embed(source="/../Flash/cards/3s.swf")]
	public var ThreeSpades:Class;
	
	[Embed(source="/../Flash/cards/4c.swf")]
	public var FourClubs:Class;
	
	[Embed(source="/../Flash/cards/4d.swf")]
	public var FourDiamonds:Class;
	
	[Embed(source="/../Flash/cards/4h.swf")]
	public var FourHearts:Class;
	
	[Embed(source="/../Flash/cards/4s.swf")]
	public var FourSpades:Class;
	
	[Embed(source="/../Flash/cards/5c.swf")]
	public var FiveClubs:Class;
	
	[Embed(source="/../Flash/cards/5d.swf")]
	public var FiveDiamonds:Class;
	
	[Embed(source="/../Flash/cards/5h.swf")]
	public var FiveHearts:Class;
	
	[Embed(source="/../Flash/cards/5s.swf")]
	public var FiveSpades:Class;
	
	[Embed(source="/../Flash/cards/6c.swf")]
	public var SixClubs:Class;
	
	[Embed(source="/../Flash/cards/6d.swf")]
	public var SixDiamonds:Class;
	
	[Embed(source="/../Flash/cards/6h.swf")]
	public var SixHearts:Class;
	
	[Embed(source="/../Flash/cards/6s.swf")]
	public var SixSpades:Class;
	
	[Embed(source="/../Flash/cards/7c.swf")]
	public var SevenClubs:Class;
	
	[Embed(source="/../Flash/cards/7d.swf")]
	public var SevenDiamonds:Class;
	
	[Embed(source="/../Flash/cards/7h.swf")]
	public var SevenHearts:Class;
	
	[Embed(source="/../Flash/cards/7s.swf")]
	public var SevenSpades:Class;
	
	[Embed(source="/../Flash/cards/8c.swf")]
	public var EightClubs:Class;
	
	[Embed(source="/../Flash/cards/8d.swf")]
	public var EightDiamonds:Class;
	
	[Embed(source="/../Flash/cards/8h.swf")]
	public var EightHearts:Class;
	
	[Embed(source="/../Flash/cards/8s.swf")]
	public var EightSpades:Class;
	
	[Embed(source="/../Flash/cards/9c.swf")]
	public var NineClubs:Class;
	
	[Embed(source="/../Flash/cards/9d.swf")]
	public var NineDiamonds:Class;
	
	[Embed(source="/../Flash/cards/9h.swf")]
	public var NineHearts:Class;
	
	[Embed(source="/../Flash/cards/9s.swf")]
	public var NineSpades:Class;
	
	[Embed(source="/../Flash/cards/tc.swf")]
	public var TenClubs:Class;
	
	[Embed(source="/../Flash/cards/td.swf")]
	public var TenDiamonds:Class;
	
	[Embed(source="/../Flash/cards/th.swf")]
	public var TenHearts:Class;
	
	[Embed(source="/../Flash/cards/ts.swf")]
	public var TenSpades:Class;
	
	[Embed(source="/../Flash/cards/jc.swf")]
	public var JackClubs:Class;
	
	[Embed(source="/../Flash/cards/jd.swf")]
	public var JackDiamonds:Class;
	
	[Embed(source="/../Flash/cards/jh.swf")]
	public var JackHearts:Class;
	
	[Embed(source="/../Flash/cards/js.swf")]
	public var JackSpades:Class;
	
	[Embed(source="/../Flash/cards/qc.swf")]
	public var QueenClubs:Class;
	
	[Embed(source="/../Flash/cards/qd.swf")]
	public var QueenDiamonds:Class;
	
	[Embed(source="/../Flash/cards/qh.swf")]
	public var QueenHearts:Class;
	
	[Embed(source="/../Flash/cards/qs.swf")]
	public var QueenSpades:Class;
	
	[Embed(source="/../Flash/cards/kc.swf")]
	public var KingClubs:Class;
	
	[Embed(source="/../Flash/cards/kd.swf")]
	public var KingDiamonds:Class;
	
	[Embed(source="/../Flash/cards/kh.swf")]
	public var KingHearts:Class;
	
	[Embed(source="/../Flash/cards/ks.swf")]
	public var KingSpades:Class;
	
	[Embed(source="/../Flash/cards/ac.swf")]
	public var AceClubs:Class;
	
	[Embed(source="/../Flash/cards/ad.swf")]
	public var AceDiamonds:Class;
	
	[Embed(source="/../Flash/cards/ah.swf")]
	public var AceHearts:Class;
	
	[Embed(source="/../Flash/cards/as.swf")]
	public var AceSpades:Class;
	
	[Embed(source="/../Flash/cards/jb.swf")]
	public var JokerBlack:Class;
	
	[Embed(source="/../Flash/cards/jr.swf")]
	public var JokerRed:Class;
	
	/** 
	 * A list of the filters that are applied to a display object
	 * when it is dragged.
	 */
	private var _dragFilters:Array;
			
	/** The default width of the cards/deck */
	private static const WIDTH:int = 72;
	
	/** The default height of the cards/deck */
	private static const HEIGHT:int = 96;
	
	/**
	 * Constructor
	 */
	public function DefaultSkin()
	{
		// Nothing to do...	
	}
	
	/**
	 * Creats the skin for the deck
	 */
	public function createDeck():DisplayObject
	{
		var s:DisplayObject = new Deck();
		
		s.cacheAsBitmap = true;
		s.width = WIDTH;
		s.height = HEIGHT;
		return s;
	}
	
	/**
	 * Creates the skin for a card
	 */
	public function createCard( card:Card ):DisplayObject
	{
		// Lookup the name of the class based on the card name and
		// suite, and return a reference to the class so that we
		// can instantiate it and get an image.
		var clazz:Class;
		if (card.suit == 4)
		{
			clazz = this[ CardValue.getName(card.value)];
		}
		else
		{
			clazz = this[ CardValue.getName( card.value )
									+ Suit.getName( card.suit ) ];
		}
	
		var s:Sprite = new clazz();
		s.cacheAsBitmap = true;
		s.width = WIDTH;
		s.height = HEIGHT;
		return s;
	}
	
	/**
	 * Creates the "deck empty" skin.
	 * 
	 * @param dealAgain When true the DeckEmptyCycle skin is used,
	 * 				when false the DeckEmptyNoCycle skin is used.
	 */
	public function createCycleDeck( dealAgain:Boolean ):DisplayObject
	{
		var s:Sprite = dealAgain ? new DeckEmptyCycle() : new DeckEmptyNoCycle();
		s.cacheAsBitmap = true;
		s.width = WIDTH;
		s.height = HEIGHT;
		return s;
	}
	
	/**
	 * Creates a placeholder for Aces.  By default this is an empty
	 * rectangle with a blue outline.
	 */
	public function createEmptyAce():DisplayObject
	{
		var s:Sprite = new EmptyPileBlue();
		s.cacheAsBitmap = true;
		s.width = WIDTH;
		s.height = HEIGHT;
		return s;
	}
	
	/**
	 * Creates a placeholder for Kings.  By default this is an empty
	 * rectangle with a green outline.
	 */
	public function createEmptyKing():DisplayObject
	{
		var s:Sprite = new EmptyPileGreen();
		s.cacheAsBitmap = true;
		s.width = WIDTH;
		s.height = HEIGHT;
		return s;
	}
	
	
	/**
	 * A list of the filters that are applied to a display object
	 * when it is dragged.
	 */
	public function get dragFilters():Array
	{
		// Create the array if it hasn't been made yet
		if ( _dragFilters == null )
		{
			_dragFilters = new Array();
		
			// Apply a drop shadow for depth (so the object looks like it's
			// been picked up)
			var dropShadow:DropShadowFilter = new DropShadowFilter( 6, 45, 0x000000, .7, 7, 7 );
			_dragFilters.push( dropShadow );
		}
		
		return _dragFilters;
	}

} // end class
} // end package