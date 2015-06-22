package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	import org.si.sion.SiONVoice;
	
	public class drumkitclass {
		public function drumkitclass():void {
		  size = 0;
		}
		
		public function updatefilter(cutoff:int, resonance:int):void {
			for (var i:int = 0; i < size; i++) {
				if(voicelist[i].channelParam.cutoff != cutoff || voicelist[i].channelParam.resonance != resonance){
			    voicelist[i].setFilterEnvelop(0, cutoff, resonance);
				}
			}
		}
		
		public function updatevolume(volume:int):void {
			for (var i:int = 0; i < size; i++) {
				if(voicelist[i].velocity!=volume){
					voicelist[i].updateVolumes = true;
					voicelist[i].velocity = volume;
				}
			}
		}
		
		public var voicelist:Vector.<SiONVoice> = new Vector.<SiONVoice>;
		public var voicename:Vector.<String> = new Vector.<String>;
		public var voicenote:Vector.<int> = new Vector.<int>;
		public var midivoice:Vector.<int> = new Vector.<int>;
		public var kitname:String;
		public var size:int;
	}
}
