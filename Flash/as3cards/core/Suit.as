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
 * of suits.  Meant to be an enumerated type, but 
 * because AS3 lacks this functionality, static 
 * constants are used instead.
 */
public class Suit
{
	
	public static const DIAMONDS:int = 0;
	public static const CLUBS:int = 1;
	public static const HEARTS:int = 2;
	public static const SPADES:int = 3;
	//public static const BLACK:int = 4;
	//public static const RED:int = 5;
	public static const JOKER:int = 4;	
	
	/**
	 * Helper method to determine if given suit
	 * value is red or black.
	 */
	public static function isRed( suit:int ):Boolean
	{
		return ( suit == HEARTS || suit == DIAMONDS);
	}
	
	/**
	 * Helper method to convert a Suit static constant
	 * into a string name.
	 */
	public static function getName( suit:int ):String
	{
		switch ( suit )
		{
			case HEARTS: return "Hearts";	
			case DIAMONDS: return "Diamonds";
			case CLUBS: return "Clubs";
			case SPADES: return "Spades";
			//case RED: return "Red";
			//case BLACK: return "Black";
			case JOKER: return "Joker";
			default: throw new Error( "Unknown Suit (" + suit + ")" );
		}
	}

} // end class
} // end package