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
package as3cards.core
{
	
/**
 * Static constants to represent different values
 * of cards.  Meant to be an enumerated type, but 
 * because AS3 lacks this functionality, static 
 * constants are used instead.
 */
public class CardValue
{
	public static const TWO:int = 2;
	public static const THREE:int = 3;
	public static const FOUR:int = 4;
	public static const FIVE:int = 5;
	public static const SIX:int = 6;
	public static const SEVEN:int = 7;
	public static const EIGHT:int = 8;
	public static const NINE:int = 9;
	public static const TEN:int = 10;
	public static const JACK:int = 11;
	public static const QUEEN:int = 12;
	public static const KING:int = 13;
	public static const ACE:int = 14;
	//public static const JOKER:int = 15;
	public static const CURRENTLEVEL:int = 15;
	public static const CURRENTLEVELSUIT:int = 16;
	public static const JOKERBLACK:int = 17;
	public static const JOKERRED:int = 18;

	/**
	 * Helper method to convert a CardValue static constant
	 * into a string name.
	 */
	public static function getName( value:int ):String
	{
		switch ( value )
		{
			case JOKERBLACK: return "JokerBlack";
			case JOKERRED: return "JokerRed";
			//case JOKER: return "Joker";
			case TWO: return "Two";
			case THREE: return "Three";
			case FOUR: return "Four";
			case FIVE: return "Five";
			case SIX: return "Six";
			case SEVEN: return "Seven";
			case EIGHT: return "Eight";
			case NINE: return "Nine";
			case TEN: return "Ten";
			case JACK: return "Jack";
			case QUEEN: return "Queen";
			case KING: return "King";
			case ACE: return "Ace";
			default: throw new Error( "Unknown Card Value (" + value + ")" );
		}
	}
	
} // end class
} // end package