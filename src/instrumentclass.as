package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	import org.si.sion.SiONVoice;
	
	public class instrumentclass  {
		public function instrumentclass():void {
			clear();
		}
		
		public function clear():void {
			category = "MIDI";
			name = "Grand Piano"; type = 0; index = 0;
			cutoff = 128; resonance = 0;
			palette = 0;
			volume = 256;
		}
		
		public function setfilter(c:int, r:int):void {
			cutoff = c; resonance = r;
		}
		
		public function setvolume(v:int):void {
			volume = v;
		}
		
		public function updatefilter():void {
			if (voice != null) {
				if(voice.velocity!=volume){
					voice.updateVolumes = true;
					voice.velocity = volume;
				}
				if(voice.channelParam.cutoff != cutoff || voice.channelParam.resonance != resonance){
				  voice.setFilterEnvelop(0, cutoff, resonance);
				}
			}
		}
		
		public function changefilterto(c:int, r:int, v:int):void {
			if (voice != null) {
			  voice.updateVolumes = true;
				voice.velocity = v;
				voice.setFilterEnvelop(0, c, r);
			}
		}
		
		public function changevolumeto(v:int):void {
			if (voice != null) {
			  voice.updateVolumes = true;
				voice.velocity = v;
			}
		}
		
		public var cutoff:int, resonance:int;
		public var voice:SiONVoice = new SiONVoice;
		
		public var category:String;
		public var name:String;
		public var palette:int;
		public var type:int;
		public var index:int;
		public var volume:int;
	}
}
