package {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.events.Event;
	
	public class InfoBox extends MovieClip {
		private var startCallback:Function;
		private var joinCallback:Function;
		function InfoBox(startCallback:Function, joinCallback:Function) {
			stop();
			this.playAgain.visible=false;
			this.playAgain.addEventListener(MouseEvent.CLICK, handleRestart);
			this.joinGame.visible=false;
			this.joinGame.addEventListener(MouseEvent.CLICK, handleJoin);
			this.startCallback = startCallback;
			this.joinCallback = joinCallback;
			//addEventListener(Event.ADDED, init);
		}
		/*private function init(e:Event):void
		{
			removeEventListener(Event.ADDED, init);
			this.playAgain.visible=false;
			this.playAgain.addEventListener(MouseEvent.CLICK, handleRestart);
			this.joinGame.visible=false;
			this.joinGame.addEventListener(MouseEvent.CLICK, handleJoin);
			this.startCallback = startCallback;
			this.joinCallback = joinCallback;
		}*/
		public function Hide() {
			this.visible=false;
		}
		public function Show(what:String, data:String = "") {
			this.winner.visible=false;
			this.playAgain.visible=false;
			this.joinGame.visible=false;
			switch (what) {
				case "showWinner" :
				{
					this.winner.text=data;
					this.winner.visible=true;
				};
				case "full" :
				{};
				case "waiting" :
				{
					if (data == "ok") {
						this.joinGame.visible=true;
						this.visible = true;
					}
					break;
				};
				case "tie" :
				{
					if (data=="go") {
						this.playAgain.visible=true;
					}
					break;
				};
				default :
				{
					this.playAgain.visible=true;
					break;
				};
				this.gotoAndStop(what);
				this.visible = true;
				trace("after2");
			}
		}
		
		private function handleRestart(e:MouseEvent) {
				startCallback();
		}
		private function handleJoin(e:MouseEvent) {
				joinCallback();
		}
	}
}