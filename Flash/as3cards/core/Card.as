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
	import as3cards.core.CardValue;
	import as3cards.core.Suit;
/**
 * A Card consists of a value and a suit.  The value should
 * be set to one of the <code>CardValue</code> static constants, 
 * and the suit should be one of the <code>Suit</code> static
 * constants.
 * 
 * @see CardValue
 * @see Suit
 */
public class Card
{
	/** The face value of the card.  One of the <code>CardValue</code> constants. */
	// TODO: Turn into getter/setter pair to ensure only valid values are set
	public var value:int;
	
	/** The suit of the card.  One of the <code>Suit</code> constants.  */
	// TODO: Turn into getter/setter pair to ensure only valid values are set
	public var suit:int;
	
	/**
	 * Creates a new card with a given value and suit.
	 */
	public function Card( value:int, suit:int )
	{
		// TODO: Test for value values of value and suit
		this.value = value;
		this.suit = suit;
	}
	
	/**
	 * Helper method to display the value and suit of the
	 * card when the card is used in a string
	 */
	public function toString():String
	{
		// TODO: test for Joker and remove the
		// suit value since Joker's don't have a suit
		return "[Card: " + CardValue.getName( this.value ) 
				+ " of " + Suit.getName( this.suit ) + "]";
	}
	
	public function equals(card2:Card):Boolean
	{
		return (this.value == card2.value && this.suit == card2.suit);
	}
	
	public function compareTo(card2:Card,s:int = 0):int
	{
		if (this.value == CardValue.JOKERRED && card2.value != CardValue.JOKERRED)
			return 1;
		else if (this.value != CardValue.JOKERRED && card2.value == CardValue.JOKERRED)
			return -1;
		else
		{
			if (this.value == CardValue.JOKERBLACK && card2.value != CardValue.JOKERBLACK)
				return 1;
			else if (this.value != CardValue.JOKERBLACK && card2.value == CardValue.JOKERBLACK)
				return -1;
			else
			{
				if (this.value == MyGame.currentLevel && card2.value != MyGame.currentLevel)
					return 1;
				else if (this.value != MyGame.currentLevel && card2.value == MyGame.currentLevel)
					return -1;
				else 
				{
					if (this.suit == s && card2.suit != s)
						return 1;
					else if (this.suit != s && card2.suit == s)
						return -1;
					else
					{
						if (this.suit > card2.suit)
							return 1;
						else if (this.suit < card2.suit)
							return -1;
						else
						{
							if (this.value > card2.value)
								return 1;
							else if (this.value < card2.value)
								return -1;
							else
								return 0;
						}
					}
				}
			}
		}
	}

} // end class
} // end package