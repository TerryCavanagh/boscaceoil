package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
	import flash.utils.*;
  import flash.net.*;
	import org.si.sion.SiONDriver;
	import org.si.sion.SiONData;
	import org.si.sion.utils.SiONPresetVoice;
	import org.si.sion.SiONVoice;
	import org.si.sion.sequencer.SiMMLTrack;
	import org.si.sion.effector.*;
  import org.si.sion.events.*;
	import flash.filesystem.*;
  import flash.net.FileFilter;
  import flash.system.Capabilities;
		
	public class controlclass extends Sprite{
		public var SCALE_NORMAL:int = 0;
		public var SCALE_MAJOR:int = 1;
		public var SCALE_MINOR:int = 2;
		public var SCALE_BLUES:int = 3;
		public var SCALE_HARMONIC_MINOR:int = 4;
		public var SCALE_PENTATONIC_MAJOR:int = 5;
		public var SCALE_PENTATONIC_MINOR:int = 6;
		public var SCALE_PENTATONIC_BLUES:int = 7;
		public var SCALE_PENTATONIC_NEUTRAL:int = 8;
		public var SCALE_ROMANIAN_FOLK:int = 9;
		public var SCALE_SPANISH_GYPSY:int = 10;
		public var SCALE_ARABIC_MAGAM:int = 11;
		public var SCALE_CHINESE:int = 12;
		public var SCALE_HUNGARIAN:int = 13;
		public var CHORD_MAJOR:int = 14;
		public var CHORD_MINOR:int = 15;
		public var CHORD_5TH:int = 16;
		public var CHORD_DOM_7TH:int = 17;
		public var CHORD_MAJOR_7TH:int = 18;
		public var CHORD_MINOR_7TH:int = 19;
		public var CHORD_MINOR_MAJOR_7TH:int = 20;
		public var CHORD_SUS4:int = 21;
		public var CHORD_SUS2:int = 22;
		
		public var LIST_KEY:int = 0;
		public var LIST_SCALE:int = 1;
		public var LIST_INSTRUMENT:int = 2;
		public var LIST_CATEGORY:int = 3;
		public var LIST_SELECTINSTRUMENT:int = 4;
		public var LIST_BUFFERSIZE:int = 5;
		public var LIST_SCREENSIZE:int = 6;
		public var LIST_EFFECTS:int = 7;
		
		public function controlclass():void {
			version = 3;
			clicklist = false;
			
			test = false; teststring = "TEST = True";
			patternmanagerview = 0;
			currenttab = 0;
			dragaction = 0;
			trashbutton = 0;
			bpm = 120;
			
			for (i = 0; i < 144; i++) notename.push("");			
			for (j = 0; j < 12; j++) {
				scale.push(int(1));
			}
			
			for (i = 0; i < 128; i++) {
				pianoroll.push(i);
				invertpianoroll.push(i);
			}
			scalesize = 12;
			
			for (j = 0; j < 11; j++) {
				notename[(j * 12) + 0] = "C";
				notename[(j * 12) + 1] = "C#";
				notename[(j * 12) + 2] = "D";
				notename[(j * 12) + 3] = "D#";
				notename[(j * 12) + 4] = "E";
				notename[(j * 12) + 5] = "F";
				notename[(j * 12) + 6] = "F#";
				notename[(j * 12) + 7] = "G";
				notename[(j * 12) + 8] = "G#";
				notename[(j * 12) + 9] = "A";
				notename[(j * 12) + 10] = "A#";
				notename[(j * 12) + 11] = "B";
			}
			
			for (i = 0; i < 23; i++) {
				scalename.push("");
			}
			scalename[SCALE_NORMAL] = "Scale: Normal";
			scalename[SCALE_MAJOR] = "Scale: Major";
			scalename[SCALE_MINOR] = "Scale: Minor";
			scalename[SCALE_BLUES] = "Scale: Blues";
			scalename[SCALE_HARMONIC_MINOR] = "Scale: Harmonic Minor";
			scalename[SCALE_PENTATONIC_MAJOR] = "Scale: Pentatonic Major";
			scalename[SCALE_PENTATONIC_MINOR] = "Scale: Pentatonic Minor";
			scalename[SCALE_PENTATONIC_BLUES] = "Scale: Pentatonic Blues";
			scalename[SCALE_PENTATONIC_NEUTRAL] = "Scale: Pentatonic Neutral";
			scalename[SCALE_ROMANIAN_FOLK] = "Scale: Romanian Folk";
			scalename[SCALE_SPANISH_GYPSY] = "Scale: Spanish Gypsy";
			scalename[SCALE_ARABIC_MAGAM] = "Scale: Arabic Magam";
			scalename[SCALE_CHINESE] = "Scale: Chinese";
			scalename[SCALE_HUNGARIAN] = "Scale: Hungarian";
			scalename[CHORD_MAJOR] = "Chord: Major";
			scalename[CHORD_MINOR] = "Chord: Minor";
			scalename[CHORD_5TH] = "Chord: 5th";
			scalename[CHORD_DOM_7TH] = "Chord: Dom 7th";
			scalename[CHORD_MAJOR_7TH] = "Chord: Major 7th";
			scalename[CHORD_MINOR_7TH] = "Chord: Minor 7th";
			scalename[CHORD_MINOR_MAJOR_7TH] = "Chord: Minor Major 7th";
			scalename[CHORD_SUS4] = "Chord: Sus4";
			scalename[CHORD_SUS2] = "Chord: sus2";
			
			looptime = 0;
			swingoff = 0;
			SetSwing(); //Swing functions submitted on gibhub via @increpare, cheers!
			
			_presets = new SiONPresetVoice();
			voicelist = new voicelistclass();
			
			//Setup drumkits
			drumkit.push(new drumkitclass()); //Midi Drums
			drumkit.push(new drumkitclass()); //Midi Drums
			drumkit.push(new drumkitclass()); //Midi Drums
			createdrumkit(0);
			createdrumkit(1);
			createdrumkit(2);
			
			for (i = 0; i < 16; i++) {
				instrument.push(new instrumentclass());
				if (i == 0) {
				  instrument[i].voice = _presets["midi.piano1"];
				}else {
					voicelist.index = int(Math.random() * voicelist.listsize);
					instrument[i].voice = _presets[voicelist.voice[voicelist.index]];
					instrument[i].category = voicelist.category[voicelist.index];
					instrument[i].name = voicelist.name[voicelist.index];
					instrument[i].palette = voicelist.palette[voicelist.index];
				}
				instrument[i].updatefilter();
			}
			numinstrument = 1;
			instrumentmanagerview = 0;
			
			for (i = 0; i < 128; i++) {
			  musicbox.push(new musicphraseclass());
			}
			numboxes = 1;
			
			arrange.loopstart = 0; arrange.loopend = 1;
			arrange.bar[0].channel[0] = 0;
			
			setscale(SCALE_NORMAL);
			key = 0;
			updatepianoroll();
			for (i = 0; i < numboxes; i++){
			  musicbox[i].start = scalesize * 3;
			}
			
			currentbox = 0;
			notelength = 1;
			currentinstrument = 0;
			
			boxcount = 16; barcount = 4;
			
			programsettings = SharedObject.getLocal("boscaceoil_settings");
			
			if (programsettings.data.buffersize == undefined) {
				buffersize = 2048;
				programsettings.data.buffersize = buffersize;
				programsettings.flush();
				programsettings.close();
				programsettings.data.fullscreen = 0;
				programsettings.data.windowsize = 2;
      } else {
				buffersize = programsettings.data.buffersize;
				programsettings.flush();
				programsettings.close();
      }
			
			
			_driver = new SiONDriver(buffersize); currentbuffersize = buffersize;
			_driver.setBeatCallbackInterval(1);
			_driver.setTimerInterruption(1, _onTimerInterruption);
			
			effecttype = 0;
			effectvalue = 0;
			effectname.push("DELAY"); 
			effectname.push("CHORUS"); 
			effectname.push("REVERB"); 
			effectname.push("DISTORTION"); 
			effectname.push("LOW BOOST"); 
			effectname.push("COMPRESSOR"); 
			effectname.push("HIGH PASS");  
			
			_driver.addEventListener(SiONEvent.STREAM, onStream);
			
			_driver.bpm = bpm; //Default
			_driver.play(null, false);
			
			startup = 1;
			if (invokefile != "null") {
				invokeceol(invokefile);
				invokefile = "null";
			}
		}
		
		public function notecut():void {
			for each (var trk:SiMMLTrack in _driver.sequencer.tracks) trk.keyOff();
		}
			
		public function updateeffects():void {
			//So, I can't see to figure out WHY only one effect at a time seems to work.
			//If anyone else can, please, by all means update this code!
			
			//start by turning everything off:
			_driver.effector.clear(0);
			
			if (effectvalue > 5) {
				if (effecttype == 0) {
					_driver.effector.connect(0, new SiEffectStereoDelay((300 * effectvalue) / 100, 0.1, false));
				}else if (effecttype == 1) {
					_driver.effector.connect(0, new SiEffectStereoChorus(20, 0.2, 4, 10 + ((50 * effectvalue) / 100)));
				}else if (effecttype == 2) {
					_driver.effector.connect(0, new SiEffectStereoReverb(0.7, 0.4+ ((0.5 * effectvalue) / 100), 0.8, 0.3));
				}else if (effecttype == 3) {
					_driver.effector.connect(0, new SiEffectDistortion(-20 - ((80 * effectvalue) / 100), 18, 2400, 1));
				}else if (effecttype == 4) {
					_driver.effector.connect(0, new SiFilterLowBoost(3000, 1, 4 + ((6 * effectvalue) / 100)));
				}else if (effecttype == 5) {
					_driver.effector.connect(0, new SiEffectCompressor(0.7, 50, 20, 20, -6, 0.2 + ((0.6 * effectvalue) / 100)));
				}else if (effecttype == 6) {
					_driver.effector.connect(0, new SiCtrlFilterHighPass(((1.0 * effectvalue) / 100),0.9));
				}
			}
			/*
			effectname.push("DELAY"); 
			effectname.push("CHORUS"); 
			effectname.push("REVERB"); 
			effectname.push("DISTORTION"); 
			effectname.push("LOW BOOST"); 
			effectname.push("COMPRESSOR"); 
			effectname.push("HIGH PASS");  */
		}
		
		public function _onTimerInterruption():void {
			if(musicplaying){
				if (looptime >= boxcount) {
					looptime-= boxcount;
					SetSwing();
					arrange.currentbar++;
					if (arrange.currentbar >= arrange.loopend) {
						arrange.currentbar = arrange.loopstart;
						if (nowexporting) {
							musicplaying = false;
							savewav();
						}
					}
					
					for (i = 0; i < numboxes; i++) {
						musicbox[i].isplayed = false;
					}
				}
				//Play everything in the current bar
				for (k = 0; k < 8; k++) {
					if (arrange.channelon[k]) {
						i = arrange.bar[arrange.currentbar].channel[k];
						if (i > -1) {
							musicbox[i].isplayed = true;
							if (instrument[musicbox[i].instr].type == 0) {
								for (j = 0; j < musicbox[i].numnotes; j++) {
									if (musicbox[i].notes[j].width == looptime) {
										if (musicbox[i].notes[j].x > -1) {
											instrument[musicbox[i].instr].updatefilter();
											//If pattern uses recorded values, update them
											if (musicbox[i].recordfilter == 1) {
												instrument[musicbox[i].instr].changefilterto(musicbox[i].cutoffgraph[looptime % boxcount], musicbox[i].resonancegraph[looptime % boxcount], musicbox[i].volumegraph[looptime % boxcount]);
											}
											_driver.noteOn(int(musicbox[i].notes[j].x), instrument[musicbox[i].instr].voice, int(musicbox[i].notes[j].y));
										}	
									}
								}
							}else {
								//Drumkits
								for (j = 0; j < musicbox[i].numnotes; j++) {
									if (musicbox[i].notes[j].width == looptime) {
										if (musicbox[i].notes[j].x > -1) {
											if (musicbox[i].notes[j].x < drumkit[instrument[musicbox[i].instr].type-1].size) {												
												//Change filter on first note
												if (looptime == 0) drumkit[instrument[musicbox[i].instr].type-1].updatefilter(instrument[musicbox[i].instr].cutoff, instrument[musicbox[i].instr].resonance);
												if (looptime == 0) drumkit[instrument[musicbox[i].instr].type-1].updatevolume(instrument[musicbox[i].instr].volume);
												//If pattern uses recorded values, update them
												if (musicbox[i].recordfilter == 1) {
													drumkit[instrument[musicbox[i].instr].type-1].updatefilter(musicbox[i].cutoffgraph[looptime % boxcount], musicbox[i].resonancegraph[looptime % boxcount]);
												  drumkit[instrument[musicbox[i].instr].type-1].updatevolume(musicbox[i].volumegraph[looptime % boxcount]);
												}
												_driver.noteOn(drumkit[instrument[musicbox[i].instr].type-1].voicenote[int(musicbox[i].notes[j].x)], drumkit[instrument[musicbox[i].instr].type-1].voicelist[int(musicbox[i].notes[j].x)], int(musicbox[i].notes[j].y));
											}
										}	
									}
								}
							}
						}
					}
				}
				
				looptime = looptime + 1;
				SetSwing();
			}
		}
		
	  private function SetSwing():void{  
      if (_driver == null) return;
      
      //swing goes from -10 to 10
      //fswing goes from 0.2 - 1.8
      var fswing:Number = 0.2+(swing+10)*(1.8-0.2)/20.0;
      
			if (swing == 0) {
				if (swingoff == 1) {
					_driver.setTimerInterruption(1, _onTimerInterruption);
					swingoff = 0;
				}
			}else {
				swingoff = 1;
				if (looptime%2==0)
				{
					_driver.setTimerInterruption(fswing, _onTimerInterruption);
				}
				else        
				{
					_driver.setTimerInterruption(2-fswing, _onTimerInterruption);
				}
			}
    }
		
		public function loadscreensettings(gfx:graphicsclass):void {
			programsettings = SharedObject.getLocal("boscaceoil_settings");		
			
			if (programsettings.data.fullscreen == 0) {
				fullscreen = false;
			}else {
				fullscreen = true;
			}
			
			gfx.changewindowsize(programsettings.data.windowsize);
			
			programsettings.flush();
			programsettings.close();
		}
		
		public function savescreensettings(gfx:graphicsclass):void {
			programsettings = SharedObject.getLocal("boscaceoil_settings");		
			
			if (!fullscreen){
				programsettings.data.fullscreen = 0;
			}else {
				programsettings.data.fullscreen = 1;
			}
			
			programsettings.data.windowsize = gfx.screenscale;
			
			programsettings.flush();
			programsettings.close();
		}
		
		public function setbuffersize(t:int):void {
			if (t == 0) buffersize = 2048;
			if (t == 1) buffersize = 4096;
			if (t == 2) buffersize = 8192;
			
			programsettings = SharedObject.getLocal("boscaceoil_settings");			
			programsettings.data.buffersize = buffersize;
			programsettings.flush();
			programsettings.close();
		}
		
		public function adddrumkitnote(t:int, name:String, voice:String, note:int = 60):void {
			if (t == 2 && note == 60) note = 16;
			drumkit[t].voicelist.push(_presets[voice]);
      drumkit[t].voicename.push(name);
      drumkit[t].voicenote.push(note);
			drumkit[t].size++;
		}
		
		public function createdrumkit(t:int):void {
			//Create Drumkit t at index
			switch(t) {
				case 0:
					//Simple
					drumkit[0].kitname = "Simple Drumkit";
					adddrumkitnote(0, "Bass Drum 1", "valsound.percus1", 30);
					adddrumkitnote(0, "Bass Drum 2", "valsound.percus13", 32);
					adddrumkitnote(0, "Bass Drum 3", "valsound.percus3", 30);
					adddrumkitnote(0, "Snare Drum", "valsound.percus30", 20);
					adddrumkitnote(0, "Snare Drum 2", "valsound.percus29", 48);
					adddrumkitnote(0, "Open Hi-Hat", "valsound.percus17", 60);
					adddrumkitnote(0, "Closed Hi-Hat", "valsound.percus23", 72);
					adddrumkitnote(0, "Crash Cymbal", "valsound.percus8", 48);
				break;
				case 1:
					//SiON Kit
					drumkit[1].kitname = "SiON Drumkit";
					adddrumkitnote(1, "Bass Drum 2", "valsound.percus1", 30);
					adddrumkitnote(1, "Bass Drum 3 o1f", "valsound.percus2");
					adddrumkitnote(1, "RUFINA BD o2c", "valsound.percus3", 30);
					adddrumkitnote(1, "B.D.(-vBend)", "valsound.percus4");
					adddrumkitnote(1, "BD808_2(-vBend)", "valsound.percus5");
					adddrumkitnote(1, "Cho cho 3 (o2e)", "valsound.percus6");
					adddrumkitnote(1, "Cow-Bell 1", "valsound.percus7");
					adddrumkitnote(1, "Crash Cymbal (noise)", "valsound.percus8", 48);
					adddrumkitnote(1, "Crash Noise", "valsound.percus9");
					adddrumkitnote(1, "Crash Noise Short", "valsound.percus10");
					adddrumkitnote(1, "ETHNIC Percus.0", "valsound.percus11");
					adddrumkitnote(1, "ETHNIC Percus.1", "valsound.percus12");
					adddrumkitnote(1, "Heavy BD.", "valsound.percus13", 32);
					adddrumkitnote(1, "Heavy BD2", "valsound.percus14");
					adddrumkitnote(1, "Heavy SD1", "valsound.percus15");
					adddrumkitnote(1, "Hi-Hat close 5_", "valsound.percus16");
					adddrumkitnote(1, "Hi-Hat close 4", "valsound.percus17");
					adddrumkitnote(1, "Hi-Hat close 5", "valsound.percus18");
					adddrumkitnote(1, "Hi-Hat Close 6 -808-", "valsound.percus19");
					adddrumkitnote(1, "Hi-hat #7 Metal o3-6", "valsound.percus20");
					adddrumkitnote(1, "Hi-Hat Close #8 o4", "valsound.percus21");
					adddrumkitnote(1, "Hi-hat Open o4e-g+", "valsound.percus22");
					adddrumkitnote(1, "Open-hat2 Metal o4c-", "valsound.percus23");
					adddrumkitnote(1, "Open-hat3 Metal", "valsound.percus24");
					adddrumkitnote(1, "Hi-Hat Open #4 o4f", "valsound.percus25");
					adddrumkitnote(1, "Metal ride o4c or o5c", "valsound.percus26");
					adddrumkitnote(1, "Rim Shot #1 o3c", "valsound.percus27");
					adddrumkitnote(1, "Snare Drum Light", "valsound.percus28");
					adddrumkitnote(1, "Snare Drum Lighter", "valsound.percus29");
					adddrumkitnote(1, "Snare Drum 808 o2-o3", "valsound.percus30", 20);
					adddrumkitnote(1, "Snare4 -808type- o2", "valsound.percus31");
					adddrumkitnote(1, "Snare5 o1-2(Franger)", "valsound.percus32");
					adddrumkitnote(1, "Tom (old)", "valsound.percus33");
					adddrumkitnote(1, "Synth tom 2 algo 3", "valsound.percus34");
					adddrumkitnote(1, "Synth (Noisy) Tom #3", "valsound.percus35");
					adddrumkitnote(1, "Synth Tom #3", "valsound.percus36");
					adddrumkitnote(1, "Synth -DX7- Tom #4", "valsound.percus37");
					adddrumkitnote(1, "Triangle 1 o5c", "valsound.percus38");
				break;
				case 2:
					//MIDI DRUMS
					drumkit[2].kitname = "Midi Drumkit";
					adddrumkitnote(2, "Seq Click H", "midi.drum24");
					adddrumkitnote(2, "Brush Tap", "midi.drum25");
					adddrumkitnote(2, "Brush Swirl", "midi.drum26");
					adddrumkitnote(2, "Brush Slap", "midi.drum27");
					adddrumkitnote(2, "Brush Tap Swirl", "midi.drum28");
					adddrumkitnote(2, "Snare Roll", "midi.drum29");
					adddrumkitnote(2, "Castanet", "midi.drum32");
					adddrumkitnote(2, "Snare L", "midi.drum31");
					adddrumkitnote(2, "Sticks", "midi.drum32");
					adddrumkitnote(2, "Bass Drum L", "midi.drum33");
					adddrumkitnote(2, "Open Rim Shot", "midi.drum34");
					adddrumkitnote(2, "Bass Drum M", "midi.drum35");
					adddrumkitnote(2, "Bass Drum H", "midi.drum36");
					adddrumkitnote(2, "Closed Rim Shot", "midi.drum37");
					adddrumkitnote(2, "Snare M", "midi.drum38");
					adddrumkitnote(2, "Hand Clap", "midi.drum39");
					adddrumkitnote(2, "Snare H", "midi.drum42");
					adddrumkitnote(2, "Floor Tom L", "midi.drum41");
					adddrumkitnote(2, "Hi-Hat Closed", "midi.drum42");
					adddrumkitnote(2, "Floor Tom H", "midi.drum43");
					adddrumkitnote(2, "Hi-Hat Pedal", "midi.drum44");
					adddrumkitnote(2, "Low Tom", "midi.drum45");
					adddrumkitnote(2, "Hi-Hat Open", "midi.drum46");
					adddrumkitnote(2, "Mid Tom L", "midi.drum47");
					adddrumkitnote(2, "Mid Tom H", "midi.drum48");
					adddrumkitnote(2, "Crash Cymbal 1", "midi.drum49");
					adddrumkitnote(2, "High Tom", "midi.drum52");
					adddrumkitnote(2, "Ride Cymbal 1", "midi.drum51");
					adddrumkitnote(2, "Chinese Cymbal", "midi.drum52");
					adddrumkitnote(2, "Ride Cymbal Cup", "midi.drum53");
					adddrumkitnote(2, "Tambourine", "midi.drum54");
					adddrumkitnote(2, "Splash Cymbal", "midi.drum55");
					adddrumkitnote(2, "Cowbell", "midi.drum56");
					adddrumkitnote(2, "Crash Cymbal 2", "midi.drum57");
					adddrumkitnote(2, "Vibraslap", "midi.drum58");
					adddrumkitnote(2, "Ride Cymbal 2", "midi.drum59");
					adddrumkitnote(2, "Bongo H", "midi.drum62");
					adddrumkitnote(2, "Bongo L", "midi.drum61");
					adddrumkitnote(2, "Conga H Mute", "midi.drum62");
					adddrumkitnote(2, "Conga H Open", "midi.drum63");
					adddrumkitnote(2, "Conga L", "midi.drum64");
					adddrumkitnote(2, "Timbale H", "midi.drum65");
					adddrumkitnote(2, "Timbale L", "midi.drum66");
					adddrumkitnote(2, "Agogo H", "midi.drum67");
					adddrumkitnote(2, "Agogo L", "midi.drum68");
					adddrumkitnote(2, "Cabasa", "midi.drum69");
					adddrumkitnote(2, "Maracas", "midi.drum72");
					adddrumkitnote(2, "Samba Whistle H", "midi.drum71");
					adddrumkitnote(2, "Samba Whistle L", "midi.drum72");
					adddrumkitnote(2, "Guiro Short", "midi.drum73");
					adddrumkitnote(2, "Guiro Long", "midi.drum74");
					adddrumkitnote(2, "Claves", "midi.drum75");
					adddrumkitnote(2, "Wood Block H", "midi.drum76");
					adddrumkitnote(2, "Wood Block L", "midi.drum77");
					adddrumkitnote(2, "Cuica Mute", "midi.drum78");
					adddrumkitnote(2, "Cuica Open", "midi.drum79");
					adddrumkitnote(2, "Triangle Mute", "midi.drum82");
					adddrumkitnote(2, "Triangle Open", "midi.drum81");
					adddrumkitnote(2, "Shaker", "midi.drum82");
					adddrumkitnote(2, "Jingle Bells", "midi.drum83");
					adddrumkitnote(2, "Bell Tree", "midi.drum84");
				break;
			}
		}
		
		public function changekey(t:int):void {
			var keyshift:int = t - key;
			for (i = 0; i < musicbox[currentbox].numnotes; i++) {
				musicbox[currentbox].notes[i].x += keyshift;
			}
			musicbox[currentbox].key = t;
			key = t;
			musicbox[currentbox].setnotespan();
			updatepianoroll();
		}
		
		public function changescale(t:int):void {
			for (i = 0; i < musicbox[currentbox].numnotes; i++) {
				musicbox[currentbox].notes[i].x = invertpianoroll[musicbox[currentbox].notes[i].x];
			}
			
			setscale(t);
			updatepianoroll();
			for (i = 0; i < musicbox[currentbox].numnotes; i++) {
				musicbox[currentbox].notes[i].x = pianoroll[musicbox[currentbox].notes[i].x];
			}
			musicbox[currentbox].scale = t;
			if (musicbox[currentbox].bottomnote < 250) {
				musicbox[currentbox].start = invertpianoroll[musicbox[currentbox].bottomnote] - 2;
				if (musicbox[currentbox].start < 0) musicbox[currentbox].start = 0;
			}else{
			  musicbox[currentbox].start = scalesize * 3;
			}
			musicbox[currentbox].setnotespan();
		}
		
		public function changemusicbox(t:int):void {
			currentbox = t;
			key = musicbox[t].key;
			setscale(musicbox[t].scale);			
			updatepianoroll();
			
			if (instrument[musicbox[t].instr].type == 0) {
				if (musicbox[t].bottomnote < 250) {
					musicbox[t].start = invertpianoroll[musicbox[t].bottomnote] - 2;
					if (musicbox[t].start < 0) musicbox[t].start = 0;
				}else{
					musicbox[t].start = scalesize * 3;
				}
			}else {
				musicbox[t].start = 0;
			}
		}
		
		public function _setscale(t1:int = -1, t2:int = -1, t3:int = -1, t4:int = -1, t5:int = -1, t6:int = -1,
		                          t7:int = -1, t8:int = -1, t9:int = -1, t10:int = -1, t11:int = -1, t12:int = -1):void {
		  if (t1 == -1) {
				scalesize = 0;
			}else if (t2 == -1) {
				scale[0] = t1;
				scalesize = 1;
			}else if (t3 == -1) {
				scale[0] = t1; scale[1] = t2;
				scalesize = 2;
			}else if (t4 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3;
				scalesize = 3;
			}else if (t5 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4;
				scalesize = 4;
			}else if (t6 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5;
				scalesize = 5;
			}else if (t7 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scalesize = 6;
			}else if (t8 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; 
				scalesize = 7;
			}else if (t9 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; scale[7] = t8;
				scalesize = 8;
			}else if (t10 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; scale[7] = t8; scale[8] = t9;
				scalesize = 9;
			}else if (t11 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; scale[7] = t8; scale[8] = t9; scale[9] = t10;
				scalesize = 10;
			}else if (t12 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; scale[7] = t8; scale[8] = t9; scale[9] = t10; scale[10] = t11;
				scalesize = 11;
			}else {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; scale[7] = t8; scale[8] = t9; scale[9] = t10; scale[10] = t11; scale[11] = t12;
				scalesize = 12;
			}
		}
		
		public function setscale(t:int):void {
			currentscale = t;
			switch(t) {
				case SCALE_MAJOR: _setscale(2, 2, 1, 2, 2, 2, 1); break;
				case SCALE_MINOR: _setscale(2, 1, 2, 2, 2, 2, 1); break;
				case SCALE_BLUES: _setscale(3, 2, 1, 1, 3, 2); break;
				case SCALE_HARMONIC_MINOR: _setscale(2, 1, 2, 2, 1, 3, 1); break;
				case SCALE_PENTATONIC_MAJOR: _setscale(2, 3, 2, 2, 3); break;
				case SCALE_PENTATONIC_MINOR: _setscale(3, 2, 2, 3, 2); break;
				case SCALE_PENTATONIC_BLUES: _setscale(3, 2, 1, 1, 3, 2); break;
				case SCALE_PENTATONIC_NEUTRAL: _setscale(2, 3, 2, 3, 2); break;
				case SCALE_ROMANIAN_FOLK: _setscale(2, 1, 3, 1, 2, 1, 2); break;
				case SCALE_SPANISH_GYPSY: _setscale(2, 1, 3, 1, 2, 1, 2); break;
				case SCALE_ARABIC_MAGAM: _setscale(2, 2, 1, 1, 2, 2, 2); break;
				case SCALE_CHINESE: _setscale(4, 2, 1, 4, 1); break;
				case SCALE_HUNGARIAN: _setscale(2, 1, 3, 1, 1, 3, 1); break;
				case CHORD_MAJOR: _setscale(4, 3, 5); break;
				case CHORD_MINOR: _setscale(3, 4, 5); break;
				case CHORD_5TH: _setscale(7, 5); break;
				case CHORD_DOM_7TH: _setscale(4, 3, 3, 2); break;
				case CHORD_MAJOR_7TH: _setscale(4, 3, 4, 1); break;
				case CHORD_MINOR_7TH: _setscale(3, 4, 3, 2); break;
				case CHORD_MINOR_MAJOR_7TH: _setscale(3, 4, 4, 1); break;
				case CHORD_SUS4: _setscale(5, 2, 5); break;
				case CHORD_SUS2: _setscale(2, 5, 5); break;
				default: case SCALE_NORMAL:_setscale(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);	break;
			}
		}
		
		public function updatepianoroll():void {
			//Set piano roll based on currently loaded scale
			var scaleiter:int = -1, pianorolliter:int = 0, lastnote:int = 0;
			
			lastnote = key;
			pianorollsize = 0;
			
			while (lastnote < 104){
				pianoroll[pianorolliter] = lastnote;
				pianorollsize++;
				pianorolliter++; scaleiter++;
				if (scaleiter >= scalesize) scaleiter -= scalesize;
				
				lastnote = pianoroll[pianorolliter - 1] + scale[scaleiter];
			}
			
			for (i = 0; i < 104; i++) {
				for (j = 0; j < pianorollsize; j++) {
					if (pianoroll[j] == i) {
						invertpianoroll[i] = j;
					}
				}
			}
		}
		
		public function addmusicbox():void {
			musicbox[numboxes].clear();
			musicbox[numboxes].instr = currentinstrument;
			musicbox[numboxes].palette = instrument[currentinstrument].palette;
			numboxes++;
		}
		
		public function copymusicbox(a:int, b:int):void {
		  musicbox[a].numnotes = musicbox[b].numnotes;
			
		  for (j = 0; j < musicbox[a].numnotes; j++){
			  musicbox[a].notes[j].x = musicbox[b].notes[j].x;
				musicbox[a].notes[j].y = musicbox[b].notes[j].y;
				musicbox[a].notes[j].width = musicbox[b].notes[j].width;
				musicbox[a].notes[j].height = musicbox[b].notes[j].height;
			}
			
			for (j = 0; j < 16; j++){
			  musicbox[a].cutoffgraph[j] = musicbox[b].cutoffgraph[j]
				musicbox[a].resonancegraph[j] = musicbox[b].resonancegraph[j]
				musicbox[a].volumegraph[j] = musicbox[b].volumegraph[j]
			}
			
		  musicbox[a].recordfilter = musicbox[b].recordfilter;
		  musicbox[a].topnote = musicbox[b].topnote;
			musicbox[a].bottomnote = musicbox[b].bottomnote;
			musicbox[a].notespan = musicbox[b].notespan;
			
		  musicbox[a].start = musicbox[b].start;
		  musicbox[a].key = musicbox[b].key;
		  musicbox[a].instr = musicbox[b].instr;
		  musicbox[a].palette = musicbox[b].palette;
		  musicbox[a].scale = musicbox[b].scale;
		  musicbox[a].isplayed = musicbox[b].isplayed;
		}
		
		public function deletemusicbox(t:int):void {
			if (currentbox == t) currentbox--;
			for (i = t; i < numboxes; i++) {
				copymusicbox(i, i + 1);
			}
			numboxes--;
			
			for (j = 0; j < 8; j++) {
				for (i = 0; i < arrange.lastbar; i++) {
					if (arrange.bar[i].channel[j] == t) {
						arrange.bar[i].channel[j] = -1;
					}else if (arrange.bar[i].channel[j] > t) {
						arrange.bar[i].channel[j]--;
					}
				}
			}
		}
		
		
		public function seekposition(t:int):void {
			//Make this smoother someday maybe
		  barposition = t;
		}
		
		public function filllist(t:int):void {
			list.type = t;
			switch(t) {
				case LIST_KEY:
					for (i = 0; i < 12; i++) {
						list.item[i] = notename[i];
					}
					list.numitems = 12;
				break;
				case LIST_SCALE:
					for (i = 0; i < 23; i++) {
						list.item[i] = scalename[i];
					}
					list.numitems = 23;
				break;
			  case LIST_CATEGORY:
					list.item[0] = "MIDI";
					list.item[1] = "DRUMKIT";
					list.item[2] = "CHIPTUNE";
					list.item[3] = "PIANO";
					list.item[4] = "BRASS";
					list.item[5] = "BASS";
					list.item[6] = "STRINGS";
					list.item[7] = "WIND";
					list.item[8] = "BELL";
					list.item[9] = "GUITAR";
					list.item[10] = "LEAD";
					list.item[11] = "SPECIAL";
					list.item[12] = "WORLD";
					list.numitems = 13;
				break;
			  case LIST_INSTRUMENT:
				  if (voicelist.sublistsize > 15) {
						//Need to split into several pages
						//Fix pagenum if it got broken somewhere
						if ((voicelist.pagenum * 15) > voicelist.sublistsize) voicelist.pagenum = 0;
						if (voicelist.sublistsize - (voicelist.pagenum * 15) > 15) {
							for (i = 0; i < 15; i++ ) {
								list.item[i] = voicelist.subname[(voicelist.pagenum * 15) + i];
							}
							list.item[15] = ">> Next Page";
							list.numitems = 16;
						}else{
							for (i = 0; i < voicelist.sublistsize - (voicelist.pagenum * 15); i++ ) {
								list.item[i] = voicelist.subname[(voicelist.pagenum * 15) + i];
							}
							list.item[voicelist.sublistsize - (voicelist.pagenum * 15)] = "<< First Page";
							list.numitems = voicelist.sublistsize - (voicelist.pagenum * 15)+1;
						}
					}else {
						//Just a simple single page
						for (i = 0; i < voicelist.sublistsize; i++ ) {
							list.item[i] = voicelist.subname[i];
						}
						list.numitems = voicelist.sublistsize;
					}
				break;
			  case LIST_SELECTINSTRUMENT:
				  //For choosing from existing instruments
					for (i = 0; i < numinstrument; i++ ) {
						list.item[i] = String(i + 1) + " " +instrument[i].name;
					}
					list.numitems = numinstrument;
				break;
				case LIST_BUFFERSIZE:
					list.item[0] = "2048 (default, high performance)";
					list.item[1] = "4096 (try if you get cracking on wav exports)";
					list.item[2] = "8192 (slow, not recommended)";
					list.numitems = 3;
				break;
			  case LIST_SCREENSIZE:
				  i = 1;
					var sw:int = flash.system.Capabilities.screenResolutionX;
					var sh:int = flash.system.Capabilities.screenResolutionY;
					while (384 * i < sw && 240 * i < sh) {
					  list.item[i - 1] = "x" + String(i);
						i++;
					}
					list.numitems = i - 1;
				break;
			  case LIST_EFFECTS:
				  for (i = 0; i < 7; i++) {
						list.item[i] = effectname[i];
					}
					list.numitems = 7;
				break;
			}
		}
		
		public function setinstrumenttoindex(t:int):void {
			voicelist.index = instrument[t].index;
			if (help.Left(voicelist.voice[voicelist.index], 7) == "drumkit") {
			  instrument[t].type = int(help.Right(voicelist.voice[voicelist.index]));
				instrument[t].updatefilter();
				drumkit[instrument[t].type-1].updatefilter(instrument[t].cutoff, instrument[t].resonance);
			}else {
				instrument[t].type = 0;
				instrument[t].voice = _presets[voicelist.voice[voicelist.index]];
				instrument[t].updatefilter();
			}
			
			instrument[t].name = voicelist.name[voicelist.index];
			instrument[t].category = voicelist.category[voicelist.index];
			instrument[t].palette = voicelist.palette[voicelist.index];
		}
		
		public function changeinstrumentvoice(t:String):void {
			instrument[currentinstrument].name = t;
			voicelist.index = voicelist.getvoice(t);
			if (help.Left(voicelist.voice[voicelist.index], 7) == "drumkit") {
			  instrument[currentinstrument].type = int(help.Right(voicelist.voice[voicelist.index]));
				instrument[currentinstrument].updatefilter();
				drumkit[instrument[currentinstrument].type-1].updatefilter(instrument[currentinstrument].cutoff, instrument[currentinstrument].resonance);
				
				if (currentbox > -1) {
				  if (musicbox[currentbox].start > drumkit[instrument[currentinstrument].type-1].size) {
						musicbox[currentbox].start = 0;
					}
				}
			}else {
				instrument[currentinstrument].type = 0;
				instrument[currentinstrument].voice = _presets[voicelist.voice[voicelist.index]];
				instrument[currentinstrument].updatefilter();
			}
			
			instrument[currentinstrument].palette = voicelist.palette[voicelist.index];
			instrument[currentinstrument].index = voicelist.index;
				
			for (i = 0; i < numboxes; i++) {
				if (musicbox[i].instr == currentinstrument) {
					musicbox[i].palette = instrument[currentinstrument].palette;
				}
			}
		}
		
		public function makefilestring():void {
			filestring = "";
			filestring += String(version) + ",";
			filestring += String(swing)+",";
			filestring += String(effecttype) + ",";
			filestring += String(effectvalue) + ",";
			filestring += String(bpm) + ",";
			filestring += String(boxcount) + ",";
			filestring += String(barcount) + ",";
			//Instruments first!
			filestring += String(numinstrument) + ",";
			for (i = 0; i < numinstrument; i++) {
				filestring += String(instrument[i].index) + ",";
				filestring += String(instrument[i].type) + ",";
				filestring += String(instrument[i].palette) + ",";
				filestring += String(instrument[i].cutoff) + ",";
				filestring += String(instrument[i].resonance) + ",";
				filestring += String(instrument[i].volume) + ",";
			}
			//Next, musicboxes
			filestring += String(numboxes) + ",";
			for (i = 0; i < numboxes; i++) {
			  filestring += String(musicbox[i].key) + ",";
				filestring += String(musicbox[i].scale) + ",";
				filestring += String(musicbox[i].instr) + ",";
				filestring += String(musicbox[i].palette) + ",";
			  filestring += String(musicbox[i].numnotes) + ",";
				for (j = 0; j < musicbox[i].numnotes; j++) {
				  filestring += String(musicbox[i].notes[j].x) + ",";	
				  filestring += String(musicbox[i].notes[j].y) + ",";	
				  filestring += String(musicbox[i].notes[j].width) + ",";	
				  filestring += String(musicbox[i].notes[j].height) + ",";	
				}
				filestring += String(musicbox[i].recordfilter) + ",";
				if (musicbox[i].recordfilter == 1) {
					for (j = 0; j < 32; j++) {
				    filestring += String(musicbox[i].volumegraph[j]) + ",";
				    filestring += String(musicbox[i].cutoffgraph[j]) + ",";
				    filestring += String(musicbox[i].resonancegraph[j]) + ",";
					}
				}
			}
			//Next, arrangements
			filestring += String(arrange.lastbar) + ",";
			filestring += String(arrange.loopstart) + ",";
			filestring += String(arrange.loopend) + ",";
			for (i = 0; i < arrange.lastbar; i++) {
				for (j = 0; j < 8; j++) {
			    filestring += String(arrange.bar[i].channel[j]) + ",";
				}
			}
		}
		
		public function newsong():void {
			bpm = 120; boxcount = 16; barcount = 4; doublesize = false;
			effectvalue = 0; effecttype = 0; updateeffects();
			_driver.bpm = bpm;
			arrange.clear();
			musicbox[0].clear();
			changekey(0); changescale(0);
			arrange.bar[0].channel[0] = 0;
			numboxes = 1; currentbox = 0;
			numinstrument = 1;
			instrumentmanagerview = 0;
			patternmanagerview = 0;
			showmessage("NEW SONG CREATED");
		}
		
		public function readfilestream():int {
			fi++;
			return filestream[fi-1];
		}
		
		public function convertfilestring():void {
			fi = 0;
			version = readfilestream();
			if (version == 3) {
				swing = readfilestream();
				effecttype = readfilestream();
				effectvalue = readfilestream(); updateeffects();
				bpm = readfilestream();	_driver.bpm = bpm;
				boxcount = readfilestream(); doublesize = boxcount > 16;
				barcount = readfilestream();
				numinstrument = readfilestream();
				for (i = 0; i < numinstrument; i++) {
					instrument[i].index = readfilestream();
					setinstrumenttoindex(i);
					instrument[i].type = readfilestream();
					instrument[i].palette= readfilestream();
					instrument[i].cutoff= readfilestream();
					instrument[i].resonance = readfilestream();
					instrument[i].volume = readfilestream();
					instrument[i].updatefilter();
					if(instrument[i].type>0){
						drumkit[instrument[i].type-1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
						drumkit[instrument[i].type-1].updatevolume(instrument[i].volume);
					}
				}
				//Next, musicboxes
				numboxes = readfilestream();
				for (i = 0; i < numboxes; i++) {
					musicbox[i].key = readfilestream();
					musicbox[i].scale = readfilestream();
					musicbox[i].instr = readfilestream();
					musicbox[i].palette = readfilestream();
					musicbox[i].numnotes = readfilestream();
					for (j = 0; j < musicbox[i].numnotes; j++) {
						musicbox[i].notes[j].x = readfilestream();
						musicbox[i].notes[j].y = readfilestream();
						musicbox[i].notes[j].width = readfilestream();
						musicbox[i].notes[j].height = readfilestream();
					}
					musicbox[i].findtopnote(); musicbox[i].findbottomnote(); 
					musicbox[i].notespan = musicbox[i].topnote-musicbox[i].bottomnote;
					musicbox[i].recordfilter = readfilestream();
					if (musicbox[i].recordfilter == 1) {
						for (j = 0; j < 32; j++) {
							musicbox[i].volumegraph[j] = readfilestream();
							musicbox[i].cutoffgraph[j] = readfilestream();
							musicbox[i].resonancegraph[j] = readfilestream();
						}
					}
				}
				//Next, arrangements
				arrange.lastbar = readfilestream();
				arrange.loopstart = readfilestream();
				arrange.loopend = readfilestream();
				for (i = 0; i < arrange.lastbar; i++) {
					for (j = 0; j < 8; j++) {
						arrange.bar[i].channel[j] = readfilestream();
					}
				}
			}else {
				//opps, the file we're loading is out of date. Let's try to convert it
				legacy_convertfilestring(version);
				version = 3;
			}
		}
		
		public function legacy_convertfilestring(t:int):void {
			switch(t) {
				case 2: //Before effects and 32 note patterns
					swing = readfilestream();
					effecttype = 0; effectvalue = 0;
					bpm = readfilestream();	_driver.bpm = bpm;
					boxcount = readfilestream(); doublesize = boxcount > 16;
					barcount = readfilestream();
					numinstrument = readfilestream();
					for (i = 0; i < numinstrument; i++) {
						instrument[i].index = readfilestream();
						setinstrumenttoindex(i);
						instrument[i].type = readfilestream();
						instrument[i].palette= readfilestream();
						instrument[i].cutoff= readfilestream();
						instrument[i].resonance = readfilestream();
						instrument[i].volume = readfilestream();
						instrument[i].updatefilter();
						if(instrument[i].type>0){
							drumkit[instrument[i].type-1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
							drumkit[instrument[i].type-1].updatevolume(instrument[i].volume);
						}
					}
					//Next, musicboxes
					numboxes = readfilestream();
					for (i = 0; i < numboxes; i++) {
						musicbox[i].key = readfilestream();
						musicbox[i].scale = readfilestream();
						musicbox[i].instr = readfilestream();
						musicbox[i].palette = readfilestream();
						musicbox[i].numnotes = readfilestream();
						for (j = 0; j < musicbox[i].numnotes; j++) {
							musicbox[i].notes[j].x = readfilestream();
							musicbox[i].notes[j].y = readfilestream();
							musicbox[i].notes[j].width = readfilestream();
							musicbox[i].notes[j].height = readfilestream();
						}
						musicbox[i].findtopnote(); musicbox[i].findbottomnote(); 
						musicbox[i].notespan = musicbox[i].topnote-musicbox[i].bottomnote;
						musicbox[i].recordfilter = readfilestream();
						if (musicbox[i].recordfilter == 1) {
							for (j = 0; j < 16; j++) {
								musicbox[i].volumegraph[j] = readfilestream();
								musicbox[i].cutoffgraph[j] = readfilestream();
								musicbox[i].resonancegraph[j] = readfilestream();
							}
						}
					}
					//Next, arrangements
					arrange.lastbar = readfilestream();
					arrange.loopstart = readfilestream();
					arrange.loopend = readfilestream();
					for (i = 0; i < arrange.lastbar; i++) {
						for (j = 0; j < 8; j++) {
							arrange.bar[i].channel[j] = readfilestream();
						}
					}
				break;
				case 1: //Original release, had a bug where volume info wasn't saved
					bpm = readfilestream();	_driver.bpm = bpm; 
					swing = 0; effecttype = 0; effectvalue = 0;
					boxcount = readfilestream(); doublesize = boxcount > 16;
					barcount = readfilestream();
					numinstrument = readfilestream();
					for (i = 0; i < numinstrument; i++) {
						instrument[i].index = readfilestream();
						setinstrumenttoindex(i);
						instrument[i].type = readfilestream();
						instrument[i].palette= readfilestream();
						instrument[i].cutoff= readfilestream();
						instrument[i].resonance = readfilestream();
						instrument[i].updatefilter();
						if(instrument[i].type>0){
							drumkit[instrument[i].type-1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
						}
					}
					//Next, musicboxes
					numboxes = readfilestream();
					for (i = 0; i < numboxes; i++) {
						musicbox[i].key = readfilestream();
						musicbox[i].scale = readfilestream();
						musicbox[i].instr = readfilestream();
						musicbox[i].palette = readfilestream();
						musicbox[i].numnotes = readfilestream();
						for (j = 0; j < musicbox[i].numnotes; j++) {
							musicbox[i].notes[j].x = readfilestream();
							musicbox[i].notes[j].y = readfilestream();
							musicbox[i].notes[j].width = readfilestream();
							musicbox[i].notes[j].height = readfilestream();
						}
						musicbox[i].findtopnote(); musicbox[i].findbottomnote(); 
						musicbox[i].notespan = musicbox[i].topnote-musicbox[i].bottomnote;
						musicbox[i].recordfilter = readfilestream();
						if (musicbox[i].recordfilter == 1) {
							for (j = 0; j < 16; j++) {
								musicbox[i].volumegraph[j] = readfilestream();
								musicbox[i].cutoffgraph[j] = readfilestream();
								musicbox[i].resonancegraph[j] = readfilestream();
							}
						}
					}
					//Next, arrangements
					arrange.lastbar = readfilestream();
					arrange.loopstart = readfilestream();
					arrange.loopend = readfilestream();
					for (i = 0; i < arrange.lastbar; i++) {
						for (j = 0; j < 8; j++) {
							arrange.bar[i].channel[j] = readfilestream();
						}
					}
				break;
			}
		}
		
		public function fileHasExtension(file:File, extension:String):Boolean {     
			if (!file.extension || file.extension.toLowerCase() != extension) {         
				return false;     
			}                 
			return true; 
		}
		
		public function addExtensionToFile(file:File, extension:String):void {     
			file.url += "." + extension; 
		}
		
		public function saveceol():void {
			file = File.desktopDirectory.resolvePath("*.ceol");
      file.addEventListener(Event.SELECT, onsaveceol);
			file.browseForSave("Save .ceol File");
			
			fixmouseclicks = true;
		}
		
		private function onsaveceol(e:Event):void {    
			file = e.currentTarget as File;
			
			if (!fileHasExtension(file, "ceol")) {
				addExtensionToFile(file, "ceol");
			}
			
			makefilestring();
			
			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(filestring);
			stream.close();
			
			fixmouseclicks = true;
			showmessage("SONG SAVED");
		}
		
		public function loadceol():void {
			file = File.desktopDirectory.resolvePath("");
      file.addEventListener(Event.SELECT, onloadceol);
			file.browseForOpen("Load .ceol File", [ceolFilter]);
			
			fixmouseclicks = true;
		}
		
		public function invokeceol(t:String):void { 
			file = new File();
			file.nativePath = t;
			
			stream = new FileStream();
			stream.open(file, FileMode.READ);
			filestring = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			filestream = new Array();
			filestream = filestring.split(",");
			
			numinstrument = 1;
			numboxes = 0;
			arrange.clear();
			arrange.currentbar = 0; arrange.viewstart = 0;
			
			convertfilestring();
			
			changemusicbox(0);
			looptime = 0;
			
			fixmouseclicks = true;
			showmessage("SONG LOADED");
		}
		
		private function onloadceol(e:Event):void {  
			file = e.currentTarget as File;
			
			stream = new FileStream();
			stream.open(file, FileMode.READ);
			filestring = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			filestream = new Array();
			filestream = filestring.split(",");
			
			numinstrument = 1;
			numboxes = 0;
			arrange.clear();
			arrange.currentbar = 0; arrange.viewstart = 0;
			
			convertfilestring();
			
			changemusicbox(0);
			looptime = 0;
			
			fixmouseclicks = true;
			showmessage("SONG LOADED");
		}
		
		public function showmessage(t:String):void {
			message = t;
			messagedelay = 90;
		}
		
		public function onStream(e : SiONEvent) : void{
			e.streamBuffer.position = 0;
			while(e.streamBuffer.bytesAvailable > 0){
				var d : int = e.streamBuffer.readFloat() * 32767;
				if (nowexporting) _data.writeShort(d);
			}
		}
		
		public function exportwav():void {
			currenttab = 1; clicklist = true;
			arrange.loopstart = 0; arrange.loopend = arrange.lastbar;
			musicplaying = true;
			looptime = 0;	arrange.currentbar = arrange.loopstart;
			SetSwing();
			
			//Clear the wav buffer
			_data = new ByteArray();
			_data.endian = Endian.LITTLE_ENDIAN;
			
			followmode = true;
			nowexporting = true;
		}
		
		public function savewav():void {
			nowexporting = false; followmode = false;
			
			_wav = new ByteArray();
			_wav.endian = Endian.LITTLE_ENDIAN;
			_wav.writeUTFBytes("RIFF");
			var len : int = _data.length;
			_wav.writeInt(len + 36);
			_wav.writeUTFBytes("WAVE");
			_wav.writeUTFBytes("fmt ");
			_wav.writeInt(16);
			_wav.writeShort(1);
			_wav.writeShort(2);
			_wav.writeInt(44100);
			_wav.writeInt(176400);
			_wav.writeShort(4);
			_wav.writeShort(16);
			_wav.writeUTFBytes("data");
			_wav.writeInt(len);
			_data.position = 0;
			_wav.writeBytes(_data);
			
			file = File.desktopDirectory.resolvePath("*.wav");
      file.addEventListener(Event.SELECT, onsavewav);
			file.browseForSave("Export .wav File");
			
			fixmouseclicks = true;
		}
		
		private function onsavewav(e:Event):void {    
			file = e.currentTarget as File;
			
			if (!fileHasExtension(file, "wav")) {
				addExtensionToFile(file, "wav");
			}
			
			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(_wav, 0, _wav.length);
			stream.close();
			
			fixmouseclicks = true;
			showmessage("SONG EXPORTED AS WAV");
		}
		
		public var file:File, stream:FileStream;
		public var filestring:String, fi:int;
		public var filestream:Array;
		public var ceolFilter:FileFilter = new FileFilter("Ceol", "*.ceol");
		
		public var i:int, j:int, k:int;
		
		public var fullscreen:Boolean;
		
		public var fullscreentoggleheld:Boolean = false;
		
		public var press_up:Boolean, press_down:Boolean, press_left:Boolean, press_right:Boolean, press_space:Boolean, press_enter:Boolean;
		public var keypriority:int = 0;
		public var keyheld:Boolean = false;;
		public var clicklist:Boolean;
		public var copykeyheld:Boolean = false;
		
		public var keydelay:int, keyboardpressed:int = 0;
		public var fixmouseclicks:Boolean = false;
		
		public var mx:int, my:int;
		public var test:Boolean, teststring:String;
		
		public var _driver:SiONDriver;
		public var _presets:SiONPresetVoice;
		public var voicelist:voicelistclass;
		
		public var instrument:Vector.<instrumentclass> = new Vector.<instrumentclass>;
		public var numinstrument:int;
		public var instrumentmanagerview:int;
		
		public var musicbox:Vector.<musicphraseclass> = new Vector.<musicphraseclass>;
		public var numboxes:int;
		public var looptime:int;
		public var currentbox:int;
		public var currentnote:int;
		public var currentinstrument:int;
		public var boxsize:int, boxcount:int;
		public var barsize:int, barcount:int;
		public var notelength:int;
		public var doublesize:Boolean;
		
		public var barposition:Number = 0;
		public var drawnoteposition:int, drawnotelength:int;
		
		public var cursorx:int, cursory:int;
		public var arrangecurx:int, arrangecury:int;
		public var patterncury:int, timelinecurx:int;
		public var instrumentcury:int;
		public var notey:int;
		
		public var notename:Vector.<String> = new Vector.<String>;
		public var scalename:Vector.<String> = new Vector.<String>;
		
		public var currentscale:int = 0;
		public var scale:Vector.<int> = new Vector.<int>;
		public var key:int;
		public var scalesize:int;
		
		public var pianoroll:Vector.<int> = new Vector.<int>;
		public var invertpianoroll:Vector.<int> = new Vector.<int>;
		public var pianorollsize:int;
		
		public var arrange:arrangementclass = new arrangementclass();
		public var drumkit:Vector.<drumkitclass> = new Vector.<drumkitclass>;
		
		public var currenttab:int;
		
		public var dragaction:int, dragx:int, dragy:int, dragpattern:int;
		public var patternmanagerview:int;
		
		public var trashbutton:int;
		
		public var list:listclass = new listclass;
		
		public var musicplaying:Boolean = true;
		public var nowexporting:Boolean = false;
		public var followmode:Boolean = false;
		public var bpm:int;
		public var version:int;
		public var swing:int;
		public var swingoff:int;
		
		public var doubleclickcheck:int;
		
		public var programsettings:SharedObject;
		public var buffersize:int, currentbuffersize:int;
		
		private var _data:ByteArray;
		private var _wav:ByteArray;
		
		public var message:String;
		public var messagedelay:int = 0;
		public var startup:int = 0, invokefile:String = "null";
		
		//Global effects
		public var effecttype:int;
		public var effectvalue:int;
		public var effectname:Vector.<String> = new Vector.<String>;
	}
}