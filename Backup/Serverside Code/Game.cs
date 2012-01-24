using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using System.Threading;
using Nonoba.GameLibrary;

namespace ServersideGameCode {
	/// <summary>
	/// Each instance of this class represents one game.
	/// 
	/// </summary>
	public class Game : NonobaGame<Player> {
		/// <summary>
		/// Game started is called *once* when an instance
		/// of your game is started. It's a good place to initialize
		/// your game.
		/// </summary>
		public override void GameStarted() {
			// You can explicitly setup how many users are allowed in your game.
			MaxUsers = 8;

			// You can schedule a onetime callback for later. 
			// In this case, we're sending out a onetime "delayedhello"
			// message 10000 milliseconds (10 seconds) after the 
			// game is started
			ScheduleCallback(delegate {
				Broadcast("delayedhello");
			}, 10000);

			// You can setup timers to issue regular callbacks
			// in this case, the tick() method will be called
			// every 100th millisecond (10 times a second).
			AddTimer(new TimerCallback(tick), 1000);
		}

		/// <summary>Timer callback scheduled to be called 10 times a second in the AddTimer() call in GameStarted()</summary>
		private void tick() {

			Console.WriteLine("Use Console.WriteLine() for easy debugging");

			RefreshDebugView(); // update the visual debugging view
			Broadcast("tick");
		}

		/// <summary>This message is called whenever a player sends a message into the game.</summary>
		public override void GotMessage(Player player, Message m) {
			// here we're sending "hi" back to any user sending in "hello"
			switch (m.Type) {
				case "hello":
					player.Send("hi");
					break;
				
			}
		}

		/// <summary>When a user enters this game instance</summary>
		public override void UserJoined(Player player) {
			player.Send("welcometogame", Users.Length); // send a message with the amount users in the game
		}

		/// <summary>When a user leaves the game instance</summary>
		public override void UserLeft(Player player) {
		}

		/// <summary>
		/// This method can be used to generate a visual debugging image, that
		/// will be displayed in the Development Server. 
		/// Call RefreshDebugView() to update image.
		/// </summary>
		public override Image GenerateDebugImage() {
			// example code creating a 100x100 image and drawing the string "hello world" on it.
			Bitmap image = new Bitmap(100, 100);
			using (Graphics g = Graphics.FromImage(image)) {
				g.FillRectangle(Brushes.DarkGray, 0, 0, 100, 100);
				g.DrawString("Hello World",new Font("verdana",10F), Brushes.Black, 0,0);
			}
			return image;
		}
	}
}