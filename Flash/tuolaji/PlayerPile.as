package tuolaji
{

	import as3cards.core.CardValue;
	import as3cards.core.Suit;
	import as3cards.visual.CardPile;
	import as3cards.visual.SpreadingDirection;
	import as3cards.visual.VisualCard;	
	import as3cards.core.Card;
	
	public class PlayerPile extends CardPile 
	{
		
		private var shift:int = 15;
		/**
		 * Constructor
		 */
		public function PlayerPile(num:int = 15)
		{
			super( null, SpreadingDirection.EAST );
			//shift*(numcards-1)+73
			trace(num);
			if (num <= 32)
				shift = 15;
			else if (num >= 33 && num < 35)
				shift = 14;
			else if (num >= 35 && num < 37)
				shift = 13;
			else if (num >= 37 && num < 40)
				shift = 12;
			else
				shift = 12;
		}
		
		//add card in sorted order
		public override function addCard( card:VisualCard , s:int= 0):void
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
				var temp:int = numChildren-2;
				// Set the location of the card to that of the previous card
				card.x = getChildAt(temp).x;
				card.y = getChildAt(temp).y;
				
				while (temp >= 0 && card.compareTo((VisualCard)(getChildAt(temp)),s) >= 0)
				{
					card.x += -shift;
					swapChildrenAt(getChildIndex(card),temp);
					temp--;
				}
				
				for (var i:int = getChildIndex(card); i < numChildren; i++)
				{
					getChildAt(i).x += shift;
				}
			}
		}
		
		public override function removeCard( card:VisualCard, removeAllAfter:Boolean = true, spreadingDirection:int = 0 ):CardPile
		{	
			// Get the current display list index of the card to remove
			var index:int = getChildIndex( card );
			
			card.y += 10;
			var cx:int = card.x;
			var c:VisualCard = (VisualCard)(removeChildAt(index));
			c.isSelected = false;
			while (index < numChildren)
			{
				getChildAt(index).x += -shift;
				index++;
			}

			return new CardPile(c);
		}
		
		//centering pile workaround
		public function shiftAllCards()
		{
			var index:int = 0;
			while (index < numChildren)
			{
				getChildAt(index).x += shift/2;
				index++;
			}
		}
		
		/**
		 * Determines if the card pile can be added to this player pile.
		 */
		public override function canAdd( cardPile:CardPile ):Boolean
		{
			/*
			// Get the top card from the pile and the card attempting to be added
			var topCard:VisualCard = getChildAt( numChildren - 1 ) as VisualCard;
			var cardToAdd:VisualCard = cardPile.getChildAt( 0 ) as VisualCard;
			
			// TODO: if the cardPile passed in it not a KlondikePile, we shouldn't
			// allow the add
			
			// Only allow the add if the top card of the pile is face up and the
			// the card being added has the opposite color suit
			if ( !topCard.isDown && Suit.isRed( topCard.card.suit ) != Suit.isRed( cardToAdd.card.suit ) )
			{
				// Make sure that the card being added has the next sequential value
				if ( topCard.card.value == cardToAdd.card.value + 1 )
				{
					return true;
				} 
				// Check for special case of adding 2 to ace
				else if ( topCard.card.value == CardValue.TWO && cardToAdd.card.value == CardValue.ACE )
				{
					return true;
				}
			}*/
			
			return false;
		}
		
		public override function toString():String
		{
			return "[PlayerPile(name:" + ")]";	
		}
	
	}
}