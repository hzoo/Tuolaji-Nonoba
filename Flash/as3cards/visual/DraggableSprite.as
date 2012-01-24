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
	
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * A DraggableSprite is a Sprite that has the ability to interact
 * with the Mouse in drag and drop scenarios.  All Sprites have
 * the startDrop() and stopDrag() methods, but those methods only
 * update the display list during enterFrame events, instead of
 * during mouseMove events, which leads to choppy dragging.  The
 * DraggableSprite provides a drag90 method, similar to startDrag()
 * and a drop() method, similar to stopDrag(), that enable smooth
 * drag and drop operations.
 */
public class DraggableSprite extends Sprite
{

	// Store the location of the cursor within the sprite
	// so we can position correctly when the cursor moves
	private var x_offset:Number = 0;
	private var y_offset:Number = 0;
	
	// Keep track of the area where dragging is allowed
	// so the sprite can be kept in bounds.
	private var bounds:Rectangle;
	
	/**
	 * Constructor.
	 */
	public function DraggableSprite()
	{
		// Nothing to do...
	}
	
	/**
	 * Starts a smooth dragging operation, forcing the player to redraw
	 * the Sprite after every mouse move.  Cancel the drag() operation
	 * by calling the drop() method.
	 */
	public function drag( lockCenter:Boolean = false, rectangle:Rectangle = null ):void
	{
		// Save the cursor position in the sprite so we can adjust
		// the x and y locations correctly when the cursor position
		// chnages based on the lockCenter parameter.
		var pt:Point;
		if ( !lockCenter )
		{
			// lockCenter is false, use the mouse coordinates at the point
			pt = localToGlobal( new Point( mouseX, mouseY ) );
		}
		else
		{
			// lockCenter is true, ignore the mouse coordinates
			// and use (0,0) instead as the point
			pt = localToGlobal( new Point( 0, 0 ) );
		}
		
		// Save the offset values so we can compute x and y correctly
		x_offset = pt.x - x;
		y_offset = pt.y - y;
		
		// Save the bounds rectangle
		bounds = rectangle;
		
		// Write the Sprite to the mouse - whenever the mouse moves
		// invoke handleDrag to update the Sprite position
		stage.addEventListener( MouseEvent.MOUSE_MOVE, handleDrag, true, 50 );
		// Capture all mouse movements in case the mouse should happen
		// to move outside of the area of the sprite
		//setCapture();
	}
	
	/**
	 * Called everytime the mouse moves after the drag() method has
	 * been called.  Updates the position of the Sprite based on
	 * the location of the mouse cursor.
	 */
	private function handleDrag( event:MouseEvent ):void
	{	
		//event.stopImmediatePropagation();
		
		// Set the x and y location based on the mouse position
		x = event.stageX - x_offset;
		y = event.stageY - y_offset;
		
		// Keep sprite in bounds if bounds was specified in drag
		if ( bounds != null )
		{
			if ( x < bounds.left )
			{
				x = bounds.left;
			}
			else if ( x > bounds.right )
			{
				x = bounds.right;
			}
			
			if ( y < bounds.top )
			{
				y = bounds.top;	
			}
			else if ( y > bounds.bottom )
			{
				y = bounds.bottom;	
			}
		}
		
		// Force the player to re-draw the sprite after the event.
		// This makes the movement look smooth, unlike startDrag()
		event.updateAfterEvent();
	}

	/**
	 * Cancels a drag() operation
	 */
	public function drop():void
	{
		// Not interested in mouse movements anymore, so release the
		// capture we had previously set... 
		//releaseCapture();
		// ... and remove the mouse move listener
		stage.removeEventListener( MouseEvent.MOUSE_MOVE, handleDrag );
	}

} // end class
} // end package