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

/**
 * A CardPile is a container that stores visual cards.  The spreading
 * direction determines how new cards display when they are added
 */
public class CardPile extends DraggableSprite implements Skinnable
{
	
	// Don't need an array to store the cards, we can just rely on the internal display list
	//public var visualCards:Array;
	
	/** One of the <code>SpreadingDirection</code> constants */
	private var spreadingDirection:int;
		
	/**
	 * Constructor
	 * 
	 * @param spreadingDirection defaults to SpreadingDirection.NONE
	 */
	public function CardPile( card:VisualCard = null, spreadingDirection:int = 0 )
	{
		// Save the spreading direction to know how to add cards
		this.spreadingDirection = spreadingDirection;
		
		// Create the pile with an initial card
		if ( card != null )
		{
			addCard( card );
		}
	}
	
	/**
	 * Determines if a card can be added to the card pile.  In
	 * the default base class here, there is no limitations to
	 * how cards are added, so always return true.
	 */
	public function canAdd( cardPile:CardPile ):Boolean
	{
		return true;
	}
	
	/**
	 * Adds the contens of another card pile to this one
	 */
	public function addPile( cardPile:CardPile ):void
	{
		// Save the numChildren as it'll get modified during the loop
		var total:int = cardPile.numChildren;
		
		// Reparent the visual cards from the card pile to this one
		for ( var i:int = 0; i < total; i++ )
		{
			addCard( cardPile.getChildAt( 0 ) as VisualCard );
		}
	}
	
	/**
	 * Adds a visual card to this card pile 
	 */
	public function addCard( card:VisualCard ,s:int = 0):void
	{
		// If there is a skin here and we add a card, we need to remove
		// the skin before the card is added
		if ( numChildren == 1 && !( getChildAt( 0 ) is VisualCard ) )
		{
			removeChildAt( 0 );
		}
		
		addChild( card );
		
		// Determine the new location of the card that was just added
		// to the pile
		if ( numChildren == 1 )
		{
			card.x = card.y = 0;
		}
		else if ( numChildren > 1 )
		{
			// Set the location of the card to that of the previous card
			card.x = getChildAt( numChildren - 2 ).x;
			card.y = getChildAt( numChildren - 2 ).y;
			
			// Adjust the card position based on the pile's spread direction
			switch ( spreadingDirection )
			{
				case SpreadingDirection.NORTH: 
					// TODO: get "north adjustment" amount from the skin manager
					card.y += (-15);
					break;
					
				case SpreadingDirection.SOUTH:
					// TODO: get "south adjustment" amount from the skin manager
					card.y += 15;
					break;
					
				case SpreadingDirection.EAST:
					// TODO: get "east adjustment" amount from the skin manager
					card.x += 15;
					break;
					
				case SpreadingDirection.WEST:
					// TODO: get "west adjustment" amount from the skin manager
					card.x += (-15);
					break;
				
				case SpreadingDirection.NONE: 
					// No need to change x or y, it'll just stack directly on top
					// with no offset
					break;
			}
		}
	}
	
	/**
	 * Removes a card from the pile and returns a new CardPile containing the card.  If
	 * removeAllAfter is specified, all of the cards that were added after the card that
	 * is being removed are removed along with the card (and placed in the card pile
	 * that is returned).
	 */
	public function removeCard( card:VisualCard, removeAllAfter:Boolean = true, spreadingDirection:int = 0 ):CardPile
	{
		// Get the current display list index of the card to remove
		var index:int = getChildIndex( card );
		// Add the card to the card pile that we want to return
		var cardPile:CardPile = new CardPile( card, spreadingDirection );
					
		// Add all of the cards that come after the card to the new card pile.
		if ( removeAllAfter )
		{
			// Save numChildren since it will be modified during each
			// loop iteration
			var total:int = numChildren;
			for ( var i:int = index; i < total; i++ )
			{
				// Adding a card will re-parent it to the cardPile,
				// so we don't have to worry about calling removeChildAt here.
				cardPile.addCard( VisualCard( getChildAt( index ) ) );
			}
		}
		
		return cardPile;
	}
	
	/**
	 * Creates the visual images for the card pile
	 */
	public function updateSkin():void
	{
		// TODO: loop over all of the cards in the pile and update their skins
	}

} // end class
} // end package