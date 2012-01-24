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
	
import flash.display.DisplayObject;
import flash.display.Sprite;
import as3cards.core.Card;

/**
 * Defines the methods that must appear on any class
 * that wants to act as the skin creator.
 */
public interface ISkinCreator
{

	/**
	 * Creats the skin for the deck
	 */
	function createDeck():DisplayObject;
	
	/**
	 * Creates the skin for a card
	 */
	function createCard( card:Card ):DisplayObject;
	
	/**
	 * Creates the "deck empty" skin.
	 */
	function createCycleDeck( dealAgain:Boolean ):DisplayObject;		
	
	/**
	 * Creates a placeholder for Aces. 
	 */
	function createEmptyAce():DisplayObject;
	
	/**
	 * Creates a placeholder for Kings. 
	 */
	function createEmptyKing():DisplayObject;
	
	/**
	 * A list of the filters that are applied to a display object
	 * when it is dragged.
	 */
	function get dragFilters():Array;
	
} // end interface
} // end package