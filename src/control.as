package
{
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*;
	import ocean.midi.MidiFile;
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
	CONFIG::web
	{
		import flash.external.ExternalInterface;
		import mx.utils.Base64Encoder;
	}
	
	public class control extends Sprite
	{
		public static var SCALE_NORMAL:int = 0;
		public static var SCALE_MAJOR:int = 1;
		public static var SCALE_MINOR:int = 2;
		public static var SCALE_BLUES:int = 3;
		public static var SCALE_HARMONIC_MINOR:int = 4;
		public static var SCALE_PENTATONIC_MAJOR:int = 5;
		public static var SCALE_PENTATONIC_MINOR:int = 6;
		public static var SCALE_PENTATONIC_BLUES:int = 7;
		public static var SCALE_PENTATONIC_NEUTRAL:int = 8;
		public static var SCALE_ROMANIAN_FOLK:int = 9;
		public static var SCALE_SPANISH_GYPSY:int = 10;
		public static var SCALE_ARABIC_MAGAM:int = 11;
		public static var SCALE_CHINESE:int = 12;
		public static var SCALE_HUNGARIAN:int = 13;
		public static var CHORD_MAJOR:int = 14;
		public static var CHORD_MINOR:int = 15;
		public static var CHORD_5TH:int = 16;
		public static var CHORD_DOM_7TH:int = 17;
		public static var CHORD_MAJOR_7TH:int = 18;
		public static var CHORD_MINOR_7TH:int = 19;
		public static var CHORD_MINOR_MAJOR_7TH:int = 20;
		public static var CHORD_SUS4:int = 21;
		public static var CHORD_SUS2:int = 22;
		
		public static var LIST_KEY:int = 0;
		public static var LIST_SCALE:int = 1;
		public static var LIST_INSTRUMENT:int = 2;
		public static var LIST_CATEGORY:int = 3;
		public static var LIST_SELECTINSTRUMENT:int = 4;
		public static var LIST_BUFFERSIZE:int = 5;
		public static var LIST_MOREEXPORTS:int = 6;
		public static var LIST_EFFECTS:int = 7;
		public static var LIST_EXPORTS:int = 8;
		public static var LIST_MIDIINSTRUMENT:int = 9;
		public static var LIST_MIDI_0_PIANO:int = 10;
		public static var LIST_MIDI_1_BELLS:int = 11;
		public static var LIST_MIDI_2_ORGAN:int = 12;
		public static var LIST_MIDI_3_GUITAR:int = 13;
		public static var LIST_MIDI_4_BASS:int = 14;
		public static var LIST_MIDI_5_STRINGS:int = 15;
		public static var LIST_MIDI_6_ENSEMBLE:int = 16;
		public static var LIST_MIDI_7_BRASS:int = 17;
		public static var LIST_MIDI_8_REED:int = 18;
		public static var LIST_MIDI_9_PIPE:int = 19;
		public static var LIST_MIDI_10_SYNTHLEAD:int = 20;
		public static var LIST_MIDI_11_SYNTHPAD:int = 21;
		public static var LIST_MIDI_12_SYNTHEFFECTS:int = 22;
		public static var LIST_MIDI_13_WORLD:int = 23;
		public static var LIST_MIDI_14_PERCUSSIVE:int = 24;
		public static var LIST_MIDI_15_SOUNDEFFECTS:int = 25;
		
		public static var MENUTAB_FILE:int = 0;
		public static var MENUTAB_ARRANGEMENTS:int = 1;
		public static var MENUTAB_INSTRUMENTS:int = 2;
		public static var MENUTAB_ADVANCED:int = 3;
		public static var MENUTAB_CREDITS:int = 4;
		public static var MENUTAB_HELP:int = 5;
		public static var MENUTAB_GITHUB:int = 6;
		
		public static function init():void
		{
			clicklist = false;
			clicksecondlist = false;
			midilistselection = -1;
			savescreencountdown = 0;
			
			// default filepath
			defaultDirectory = File.desktopDirectory;
			
			test = false;
			teststring = "TEST = True";
			patternmanagerview = 0;
			dragaction = 0;
			trashbutton = 0;
			bpm = 120;
			
			for (i = 0; i < 144; i++) notename.push("");
			for (j = 0; j < 12; j++)
			{
				scale.push(int(1));
			}
			
			for (i = 0; i < 256; i++)
			{
				pianoroll.push(i);
				invertpianoroll.push(i);
			}
			scalesize = 12;
			
			for (j = 0; j < 11; j++)
			{
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
			
			for (i = 0; i < 23; i++)
			{
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
			drumkit.push(new drumkitclass());
			drumkit.push(new drumkitclass());
			drumkit.push(new drumkitclass()); //Midi Drums
			createdrumkit(0);
			createdrumkit(1);
			createdrumkit(2);
			
			for (i = 0; i < 16; i++)
			{
				instrument.push(new instrumentclass());
				if (i == 0)
				{
					instrument[i].voice = _presets["midi.piano1"];
				}
				else
				{
					voicelist.index = int(Math.random() * voicelist.listsize);
					instrument[i].index = voicelist.index;
					instrument[i].voice = _presets[voicelist.voice[voicelist.index]];
					instrument[i].category = voicelist.category[voicelist.index];
					instrument[i].name = voicelist.name[voicelist.index];
					instrument[i].palette = voicelist.palette[voicelist.index];
				}
				instrument[i].updatefilter();
			}
			numinstrument = 1;
			instrumentmanagerview = 0;
			
			for (i = 0; i < 4096; i++)
			{
				musicbox.push(new musicphraseclass());
			}
			numboxes = 1;
			
			arrange.loopstart = 0;
			arrange.loopend = 1;
			arrange.bar[0].channel[0] = 0;
			
			setscale(SCALE_NORMAL);
			key = 0;
			updatepianoroll();
			for (i = 0; i < numboxes; i++)
			{
				musicbox[i].start = scalesize * 3;
			}
			
			currentbox = 0;
			notelength = 1;
			currentinstrument = 0;
			
			boxcount = 16;
			barcount = 4;
			
			programsettings = SharedObject.getLocal("boscaceoil_settings");
			
			if (programsettings.data.buffersize == undefined)
			{
				buffersize = 2048;
				programsettings.data.buffersize = buffersize;
				programsettings.flush();
				programsettings.close();
				programsettings.data.fullscreen = 0;
				programsettings.data.windowsize = 2;
			}
			else
			{
				buffersize = programsettings.data.buffersize;
				programsettings.flush();
				programsettings.close();
			}
			
			_driver = new SiONDriver(buffersize);
			currentbuffersize = buffersize;
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
			CONFIG::desktop
			{
				if (invokefile != "null")
				{
					invokeceol(invokefile);
					invokefile = "null";
				}
			}
		}
		
		public static function notecut():void
		{
			//This is broken, try to fix later
			//for each (var trk:SiMMLTrack in _driver.sequencer.tracks) trk.keyOff();
		}
		
		public static function updateeffects():void
		{
			//So, I can't see to figure out WHY only one effect at a time seems to work.
			//If anyone else can, please, by all means update this code!
			
			//start by turning everything off:
			_driver.effector.clear(0);
			
			if (effectvalue > 5)
			{
				if (effecttype == 0)
				{
					_driver.effector.connect(0, new SiEffectStereoDelay((300 * effectvalue) / 100, 0.1, false));
				}
				else if (effecttype == 1)
				{
					_driver.effector.connect(0, new SiEffectStereoChorus(20, 0.2, 4, 10 + ((50 * effectvalue) / 100)));
				}
				else if (effecttype == 2)
				{
					_driver.effector.connect(0, new SiEffectStereoReverb(0.7, 0.4 + ((0.5 * effectvalue) / 100), 0.8, 0.3));
				}
				else if (effecttype == 3)
				{
					_driver.effector.connect(0, new SiEffectDistortion(-20 - ((80 * effectvalue) / 100), 18, 2400, 1));
				}
				else if (effecttype == 4)
				{
					_driver.effector.connect(0, new SiFilterLowBoost(3000, 1, 4 + ((6 * effectvalue) / 100)));
				}
				else if (effecttype == 5)
				{
					_driver.effector.connect(0, new SiEffectCompressor(0.7, 50, 20, 20, -6, 0.2 + ((0.6 * effectvalue) / 100)));
				}
				else if (effecttype == 6)
				{
					_driver.effector.connect(0, new SiCtrlFilterHighPass(((1.0 * effectvalue) / 100), 0.9));
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
		
		public static function _onTimerInterruption():void
		{
			if (musicplaying)
			{
				if (looptime >= boxcount)
				{
					looptime -= boxcount;
					SetSwing();
					arrange.currentbar++;
					if (arrange.currentbar >= arrange.loopend)
					{
						arrange.currentbar = arrange.loopstart;
						if (nowexporting)
						{
							musicplaying = false;
							savewav();
						}
					}
					
					for (i = 0; i < numboxes; i++)
					{
						musicbox[i].isplayed = false;
					}
				}
				//Play everything in the current bar
				for (k = 0; k < 8; k++)
				{
					if (arrange.channelon[k])
					{
						i = arrange.bar[arrange.currentbar].channel[k];
						if (i > -1)
						{
							musicbox[i].isplayed = true;
							if (instrument[musicbox[i].instr].type == 0)
							{
								for (j = 0; j < musicbox[i].numnotes; j++)
								{
									if (musicbox[i].notes[j].width == looptime)
									{
										if (musicbox[i].notes[j].x > -1)
										{
											instrument[musicbox[i].instr].updatefilter();
											//If pattern uses recorded values, update them
											if (musicbox[i].recordfilter == 1)
											{
												instrument[musicbox[i].instr].changefilterto(musicbox[i].cutoffgraph[looptime % boxcount], musicbox[i].resonancegraph[looptime % boxcount], musicbox[i].volumegraph[looptime % boxcount]);
											}
											_driver.noteOn(int(musicbox[i].notes[j].x), instrument[musicbox[i].instr].voice, int(musicbox[i].notes[j].y));
										}
									}
								}
							}
							else
							{
								//Drumkits
								for (j = 0; j < musicbox[i].numnotes; j++)
								{
									if (musicbox[i].notes[j].width == looptime)
									{
										if (musicbox[i].notes[j].x > -1)
										{
											if (musicbox[i].notes[j].x < drumkit[instrument[musicbox[i].instr].type - 1].size)
											{
												//Change filter on first note
												if (looptime == 0) drumkit[instrument[musicbox[i].instr].type - 1].updatefilter(instrument[musicbox[i].instr].cutoff, instrument[musicbox[i].instr].resonance);
												if (looptime == 0) drumkit[instrument[musicbox[i].instr].type - 1].updatevolume(instrument[musicbox[i].instr].volume);
												//If pattern uses recorded values, update them
												if (musicbox[i].recordfilter == 1)
												{
													drumkit[instrument[musicbox[i].instr].type - 1].updatefilter(musicbox[i].cutoffgraph[looptime % boxcount], musicbox[i].resonancegraph[looptime % boxcount]);
													drumkit[instrument[musicbox[i].instr].type - 1].updatevolume(musicbox[i].volumegraph[looptime % boxcount]);
												}
												_driver.noteOn(drumkit[instrument[musicbox[i].instr].type - 1].voicenote[int(musicbox[i].notes[j].x)], drumkit[instrument[musicbox[i].instr].type - 1].voicelist[int(musicbox[i].notes[j].x)], int(musicbox[i].notes[j].y));
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
		
		private static function SetSwing():void
		{
			if (_driver == null) return;
			
			//swing goes from -10 to 10
			//fswing goes from 0.2 - 1.8
			var fswing:Number = 0.2 + (swing + 10) * (1.8 - 0.2) / 20.0;
			
			if (swing == 0)
			{
				if (swingoff == 1)
				{
					_driver.setTimerInterruption(1, _onTimerInterruption);
					swingoff = 0;
				}
			}
			else
			{
				swingoff = 1;
				if (looptime % 2 == 0)
				{
					_driver.setTimerInterruption(fswing, _onTimerInterruption);
				}
				else
				{
					_driver.setTimerInterruption(2 - fswing, _onTimerInterruption);
				}
			}
		}
		
		public static function loadscreensettings():void
		{
			programsettings = SharedObject.getLocal("boscaceoil_settings");
			
			if (programsettings.data.firstrun == null)
			{
				guiclass.firstrun = true;
				programsettings.data.firstrun = 1;
			}
			else
			{
				guiclass.firstrun = false;
			}
			
			if (programsettings.data.fullscreen == 0)
			{
				fullscreen = false;
			}
			else
			{
				fullscreen = true;
			}
			
			if (programsettings.data.scalemode == null)
			{
				gfx.changescalemode(0);
			}
			else
			{
				gfx.changescalemode(programsettings.data.scalemode);
			}
			
			if (programsettings.data.windowwidth == null)
			{
				gfx.windowwidth = 768;
				gfx.windowheight = 560;
			}
			else
			{
				gfx.windowwidth = programsettings.data.windowwidth;
				gfx.windowheight = programsettings.data.windowheight;
			}
			
			gfx.changewindowsize(gfx.windowwidth, gfx.windowheight);
			
			programsettings.flush();
			programsettings.close();
		}
		
		public static function loadfilesettings():void
		{
			programsettings = SharedObject.getLocal("boscaceoil_settings");
			
			// Add filepath memory
			if (programsettings.data.filepath == null)
			{
				filepath = defaultDirectory.resolvePath("");
			}
			else
			{
				filepath = defaultDirectory.resolvePath(programsettings.data.filepath);
			}
			
			programsettings.flush();
			programsettings.close();
		}
		
		public static function savescreensettings():void
		{
			programsettings = SharedObject.getLocal("boscaceoil_settings");
			
			programsettings.data.firstrun = 1;
			
			if (!fullscreen)
			{
				programsettings.data.fullscreen = 0;
			}
			else
			{
				programsettings.data.fullscreen = 1;
			}
			
			programsettings.data.scalemode = gfx.scalemode;
			programsettings.data.windowwidth = gfx.windowwidth;
			programsettings.data.windowheight = gfx.windowheight;
			
			programsettings.flush();
			programsettings.close();
		}
		
		public static function savefilesettings():void
		{
			programsettings = SharedObject.getLocal("boscaceoil_settings");
			
			// Add filepath memory
			if (filepath != null)
			{
				programsettings.data.filepath = filepath.nativePath;
			}
			
			programsettings.flush();
			programsettings.close();
		}
		
		public static function setbuffersize(t:int):void
		{
			if (t == 0) buffersize = 2048;
			if (t == 1) buffersize = 4096;
			if (t == 2) buffersize = 8192;
			
			programsettings = SharedObject.getLocal("boscaceoil_settings");
			programsettings.data.buffersize = buffersize;
			programsettings.flush();
			programsettings.close();
		}
		
		public static function adddrumkitnote(t:int, name:String, voice:String, note:int = 60):void
		{
			if (t == 2 && note == 60) note = 16;
			drumkit[t].voicelist.push(_presets[voice]);
			drumkit[t].voicename.push(name);
			drumkit[t].voicenote.push(note);
			if (t == 2)
			{
				//Midi drumkit
				var voicenum:String = "";
				var afterdot:Boolean = false;
				for (var i:int = 0; i < voice.length; i++)
				{
					if (afterdot)
					{
						voicenum = voicenum + voice.charAt(i);
					}
					if (i >= 8) afterdot = true;
				}
				drumkit[t].midivoice.push(int(voicenum));
			}
			drumkit[t].size++;
		}
		
		public static function createdrumkit(t:int):void
		{
			//Create Drumkit t at index
			switch (t)
			{
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
				adddrumkitnote(2, "Seq Click H", "midi.drum24", 24);
				adddrumkitnote(2, "Brush Tap", "midi.drum25", 25);
				adddrumkitnote(2, "Brush Swirl", "midi.drum26", 26);
				adddrumkitnote(2, "Brush Slap", "midi.drum27", 27);
				adddrumkitnote(2, "Brush Tap Swirl", "midi.drum28", 28);
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
				adddrumkitnote(2, "Triangle Mute", "midi.drum80");
				adddrumkitnote(2, "Triangle Open", "midi.drum81");
				adddrumkitnote(2, "Shaker", "midi.drum82");
				adddrumkitnote(2, "Jingle Bells", "midi.drum83");
				adddrumkitnote(2, "Bell Tree", "midi.drum84");
				break;
			}
		}
		
		public static function changekey(t:int):void
		{
			var keyshift:int = t - key;
			for (i = 0; i < musicbox[currentbox].numnotes; i++)
			{
				musicbox[currentbox].notes[i].x += keyshift;
			}
			musicbox[currentbox].key = t;
			key = t;
			musicbox[currentbox].setnotespan();
			updatepianoroll();
		}
		
		public static function changescale(t:int):void
		{
			setscale(t);
			updatepianoroll();
			
			//Delete notes not in scale
			for (i = 0; i < musicbox[currentbox].numnotes; i++)
			{
				if (invertpianoroll[musicbox[currentbox].notes[i].x] == -1)
				{
					musicbox[currentbox].deletenote(i);
					i--;
				}
			}
			
			musicbox[currentbox].scale = t;
			if (musicbox[currentbox].bottomnote < 250)
			{
				musicbox[currentbox].start = invertpianoroll[musicbox[currentbox].bottomnote] - 2;
				if (musicbox[currentbox].start < 0) musicbox[currentbox].start = 0;
			}
			else
			{
				musicbox[currentbox].start = (scalesize * 4) - 2;
			}
			musicbox[currentbox].setnotespan();
		}
		
		public static function changemusicbox(t:int):void
		{
			currentbox = t;
			key = musicbox[t].key;
			setscale(musicbox[t].scale);
			updatepianoroll();
			
			if (instrument[musicbox[t].instr].type == 0)
			{
				if (musicbox[t].bottomnote < 250)
				{
					musicbox[t].start = invertpianoroll[musicbox[t].bottomnote] - 2;
					if (musicbox[t].start < 0) musicbox[t].start = 0;
				}
				else
				{
					musicbox[t].start = (scalesize * 4) - 2;
				}
			}
			else
			{
				musicbox[t].start = 0;
			}
			
			guiclass.changetab(currenttab);
		}
		
		public static function _setscale(t1:int = -1, t2:int = -1, t3:int = -1, t4:int = -1, t5:int = -1, t6:int = -1, t7:int = -1, t8:int = -1, t9:int = -1, t10:int = -1, t11:int = -1, t12:int = -1):void
		{
			if (t1 == -1)
			{
				scalesize = 0;
			}
			else if (t2 == -1)
			{
				scale[0] = t1;
				scalesize = 1;
			}
			else if (t3 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scalesize = 2;
			}
			else if (t4 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scalesize = 3;
			}
			else if (t5 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scalesize = 4;
			}
			else if (t6 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scalesize = 5;
			}
			else if (t7 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scalesize = 6;
			}
			else if (t8 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scalesize = 7;
			}
			else if (t9 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scale[7] = t8;
				scalesize = 8;
			}
			else if (t10 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scale[7] = t8;
				scale[8] = t9;
				scalesize = 9;
			}
			else if (t11 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scale[7] = t8;
				scale[8] = t9;
				scale[9] = t10;
				scalesize = 10;
			}
			else if (t12 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scale[7] = t8;
				scale[8] = t9;
				scale[9] = t10;
				scale[10] = t11;
				scalesize = 11;
			}
			else
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scale[7] = t8;
				scale[8] = t9;
				scale[9] = t10;
				scale[10] = t11;
				scale[11] = t12;
				scalesize = 12;
			}
		}
		
		public static function setscale(t:int):void
		{
			currentscale = t;
			switch (t)
			{
			case SCALE_MAJOR: 
				_setscale(2, 2, 1, 2, 2, 2, 1);
				break;
			case SCALE_MINOR: 
				_setscale(2, 1, 2, 2, 2, 2, 1);
				break;
			case SCALE_BLUES: 
				_setscale(3, 2, 1, 1, 3, 2);
				break;
			case SCALE_HARMONIC_MINOR: 
				_setscale(2, 1, 2, 2, 1, 3, 1);
				break;
			case SCALE_PENTATONIC_MAJOR: 
				_setscale(2, 3, 2, 2, 3);
				break;
			case SCALE_PENTATONIC_MINOR: 
				_setscale(3, 2, 2, 3, 2);
				break;
			case SCALE_PENTATONIC_BLUES: 
				_setscale(3, 2, 1, 1, 3, 2);
				break;
			case SCALE_PENTATONIC_NEUTRAL: 
				_setscale(2, 3, 2, 3, 2);
				break;
			case SCALE_ROMANIAN_FOLK: 
				_setscale(2, 1, 3, 1, 2, 1, 2);
				break;
			case SCALE_SPANISH_GYPSY: 
				_setscale(2, 1, 3, 1, 2, 1, 2);
				break;
			case SCALE_ARABIC_MAGAM: 
				_setscale(2, 2, 1, 1, 2, 2, 2);
				break;
			case SCALE_CHINESE: 
				_setscale(4, 2, 1, 4, 1);
				break;
			case SCALE_HUNGARIAN: 
				_setscale(2, 1, 3, 1, 1, 3, 1);
				break;
			case CHORD_MAJOR: 
				_setscale(4, 3, 5);
				break;
			case CHORD_MINOR: 
				_setscale(3, 4, 5);
				break;
			case CHORD_5TH: 
				_setscale(7, 5);
				break;
			case CHORD_DOM_7TH: 
				_setscale(4, 3, 3, 2);
				break;
			case CHORD_MAJOR_7TH: 
				_setscale(4, 3, 4, 1);
				break;
			case CHORD_MINOR_7TH: 
				_setscale(3, 4, 3, 2);
				break;
			case CHORD_MINOR_MAJOR_7TH: 
				_setscale(3, 4, 4, 1);
				break;
			case CHORD_SUS4: 
				_setscale(5, 2, 5);
				break;
			case CHORD_SUS2: 
				_setscale(2, 5, 5);
				break;
			default: 
			case SCALE_NORMAL: 
				_setscale(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
				break;
			}
		}
		
		public static function updatepianoroll():void
		{
			//Set piano roll based on currently loaded scale
			var scaleiter:int = -1, pianorolliter:int = 0, lastnote:int = 0;
			
			lastnote = key;
			pianorollsize = 0;
			
			while (lastnote < 104)
			{
				pianoroll[pianorolliter] = lastnote;
				pianorollsize++;
				pianorolliter++;
				scaleiter++;
				if (scaleiter >= scalesize) scaleiter -= scalesize;
				
				lastnote = pianoroll[pianorolliter - 1] + scale[scaleiter];
			}
			
			for (i = 0; i < 104; i++)
			{
				invertpianoroll[i] = -1;
				for (j = 0; j < pianorollsize; j++)
				{
					if (pianoroll[j] == i)
					{
						invertpianoroll[i] = j;
					}
				}
			}
		}
		
		public static function addmusicbox():void
		{
			musicbox[numboxes].clear();
			musicbox[numboxes].instr = currentinstrument;
			musicbox[numboxes].palette = instrument[currentinstrument].palette;
			musicbox[numboxes].hash += currentinstrument;
			numboxes++;
		}
		
		public static function copymusicbox(a:int, b:int):void
		{
			musicbox[a].numnotes = musicbox[b].numnotes;
			
			for (j = 0; j < musicbox[a].numnotes; j++)
			{
				musicbox[a].notes[j].x = musicbox[b].notes[j].x;
				musicbox[a].notes[j].y = musicbox[b].notes[j].y;
				musicbox[a].notes[j].width = musicbox[b].notes[j].width;
				musicbox[a].notes[j].height = musicbox[b].notes[j].height;
			}
			
			for (j = 0; j < 16; j++)
			{
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
		
		public static function deletemusicbox(t:int):void
		{
			if (currentbox == t) currentbox--;
			for (i = t; i < numboxes; i++)
			{
				copymusicbox(i, i + 1);
			}
			numboxes--;
			
			for (j = 0; j < 8; j++)
			{
				for (i = 0; i < arrange.lastbar; i++)
				{
					if (arrange.bar[i].channel[j] == t)
					{
						arrange.bar[i].channel[j] = -1;
					}
					else if (arrange.bar[i].channel[j] > t)
					{
						arrange.bar[i].channel[j]--;
					}
				}
			}
		}
		
		public static function seekposition(t:int):void
		{
			//Make this smoother someday maybe
			barposition = t;
		}
		
		public static function filllist(t:int):void
		{
			list.type = t;
			switch (t)
			{
			case LIST_KEY: 
				for (i = 0; i < 12; i++)
				{
					list.item[i] = notename[i];
				}
				list.numitems = 12;
				break;
			case LIST_SCALE: 
				for (i = 0; i < 23; i++)
				{
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
				if (voicelist.sublistsize > 15)
				{
					//Need to split into several pages
					//Fix pagenum if it got broken somewhere
					if ((voicelist.pagenum * 15) > voicelist.sublistsize) voicelist.pagenum = 0;
					if (voicelist.sublistsize - (voicelist.pagenum * 15) > 15)
					{
						for (i = 0; i < 15; i++)
						{
							list.item[i] = voicelist.subname[(voicelist.pagenum * 15) + i];
						}
						list.item[15] = ">> Next Page";
						list.numitems = 16;
					}
					else
					{
						for (i = 0; i < voicelist.sublistsize - (voicelist.pagenum * 15); i++)
						{
							list.item[i] = voicelist.subname[(voicelist.pagenum * 15) + i];
						}
						list.item[voicelist.sublistsize - (voicelist.pagenum * 15)] = "<< First Page";
						list.numitems = voicelist.sublistsize - (voicelist.pagenum * 15) + 1;
					}
				}
				else
				{
					//Just a simple single page
					for (i = 0; i < voicelist.sublistsize; i++)
					{
						list.item[i] = voicelist.subname[i];
					}
					list.numitems = voicelist.sublistsize;
				}
				break;
			case LIST_MIDIINSTRUMENT: 
				midilistselection = -1;
				list.item[0] = "> Piano";
				list.item[1] = "> Bells";
				list.item[2] = "> Organ";
				list.item[3] = "> Guitar";
				list.item[4] = "> Bass";
				list.item[5] = "> Strings";
				list.item[6] = "> Ensemble";
				list.item[7] = "> Brass";
				list.item[8] = "> Reed";
				list.item[9] = "> Pipe";
				list.item[10] = "> Lead";
				list.item[11] = "> Pads";
				list.item[12] = "> Synth";
				list.item[13] = "> World";
				list.item[14] = "> Drums";
				list.item[15] = "> Effects";
				list.numitems = 16;
				break;
			case LIST_SELECTINSTRUMENT: 
				//For choosing from existing instruments
				for (i = 0; i < numinstrument; i++)
				{
					list.item[i] = String(i + 1) + " " + instrument[i].name;
				}
				list.numitems = numinstrument;
				break;
			case LIST_BUFFERSIZE: 
				list.item[0] = "2048 (default, high performance)";
				list.item[1] = "4096 (try if you get cracking on wav exports)";
				list.item[2] = "8192 (slow, not recommended)";
				list.numitems = 3;
				break;
			case LIST_EFFECTS: 
				for (i = 0; i < 7; i++)
				{
					list.item[i] = effectname[i];
				}
				list.numitems = 7;
				break;
			case LIST_MOREEXPORTS: 
				list.item[0] = "EXPORT .xm (wip)";
				list.item[1] = "EXPORT .mml (wip)";
				list.numitems = 2;
				break;
			case LIST_EXPORTS: 
				list.item[0] = "EXPORT .wav";
				list.item[1] = "EXPORT .mid";
				list.item[2] = "> More";
				list.numitems = 3;
				break;
			default: 
				//Midi list
				list.type = LIST_MIDIINSTRUMENT;
				secondlist.type = t;
				for (i = 0; i < 8; i++)
				{
					secondlist.item[i] = voicelist.name[i + ((t - 10) * 8)];
				}
				secondlist.numitems = 8;
				break;
			}
		}
		
		public static function setinstrumenttoindex(t:int):void
		{
			voicelist.index = instrument[t].index;
			if (help.Left(voicelist.voice[voicelist.index], 7) == "drumkit")
			{
				instrument[t].type = int(help.Right(voicelist.voice[voicelist.index]));
				instrument[t].updatefilter();
				drumkit[instrument[t].type - 1].updatefilter(instrument[t].cutoff, instrument[t].resonance);
			}
			else
			{
				instrument[t].type = 0;
				instrument[t].voice = _presets[voicelist.voice[voicelist.index]];
				instrument[t].updatefilter();
			}
			
			instrument[t].name = voicelist.name[voicelist.index];
			instrument[t].category = voicelist.category[voicelist.index];
			instrument[t].palette = voicelist.palette[voicelist.index];
		}
		
		public static function nextinstrument():void
		{
			//Change to the next instrument in a category
			voicelist.index = voicelist.getnext(voicelist.getvoice(instrument[currentinstrument].name));
			changeinstrumentvoice(voicelist.name[voicelist.index]);
		}
		
		public static function previousinstrument():void
		{
			//Change to the previous instrument in a category
			voicelist.index = voicelist.getprevious(voicelist.getvoice(instrument[currentinstrument].name));
			changeinstrumentvoice(voicelist.name[voicelist.index]);
		}
		
		public static function changeinstrumentvoice(t:String):void
		{
			instrument[currentinstrument].name = t;
			voicelist.index = voicelist.getvoice(t);
			instrument[currentinstrument].category = voicelist.category[voicelist.index];
			if (help.Left(voicelist.voice[voicelist.index], 7) == "drumkit")
			{
				instrument[currentinstrument].type = int(help.Right(voicelist.voice[voicelist.index]));
				instrument[currentinstrument].updatefilter();
				drumkit[instrument[currentinstrument].type - 1].updatefilter(instrument[currentinstrument].cutoff, instrument[currentinstrument].resonance);
				
				if (currentbox > -1)
				{
					if (musicbox[currentbox].start > drumkit[instrument[currentinstrument].type - 1].size)
					{
						musicbox[currentbox].start = 0;
					}
				}
			}
			else
			{
				instrument[currentinstrument].type = 0;
				instrument[currentinstrument].voice = _presets[voicelist.voice[voicelist.index]];
				instrument[currentinstrument].updatefilter();
			}
			
			instrument[currentinstrument].palette = voicelist.palette[voicelist.index];
			instrument[currentinstrument].index = voicelist.index;
			
			for (i = 0; i < numboxes; i++)
			{
				if (musicbox[i].instr == currentinstrument)
				{
					musicbox[i].palette = instrument[currentinstrument].palette;
				}
			}
		}
		
		public static function makefilestring():void
		{
			filestring = "";
			filestring += String(version) + ",";
			filestring += String(swing) + ",";
			filestring += String(effecttype) + ",";
			filestring += String(effectvalue) + ",";
			filestring += String(bpm) + ",";
			filestring += String(boxcount) + ",";
			filestring += String(barcount) + ",";
			//Instruments first!
			filestring += String(numinstrument) + ",";
			for (i = 0; i < numinstrument; i++)
			{
				filestring += String(instrument[i].index) + ",";
				filestring += String(instrument[i].type) + ",";
				filestring += String(instrument[i].palette) + ",";
				filestring += String(instrument[i].cutoff) + ",";
				filestring += String(instrument[i].resonance) + ",";
				filestring += String(instrument[i].volume) + ",";
			}
			//Next, musicboxes
			filestring += String(numboxes) + ",";
			for (i = 0; i < numboxes; i++)
			{
				filestring += String(musicbox[i].key) + ",";
				filestring += String(musicbox[i].scale) + ",";
				filestring += String(musicbox[i].instr) + ",";
				filestring += String(musicbox[i].palette) + ",";
				filestring += String(musicbox[i].numnotes) + ",";
				for (j = 0; j < musicbox[i].numnotes; j++)
				{
					filestring += String(musicbox[i].notes[j].x) + ",";
					filestring += String(musicbox[i].notes[j].y) + ",";
					filestring += String(musicbox[i].notes[j].width) + ",";
					filestring += String(musicbox[i].notes[j].height) + ",";
				}
				filestring += String(musicbox[i].recordfilter) + ",";
				if (musicbox[i].recordfilter == 1)
				{
					for (j = 0; j < 16; j++)
					{
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
			for (i = 0; i < arrange.lastbar; i++)
			{
				for (j = 0; j < 8; j++)
				{
					filestring += String(arrange.bar[i].channel[j]) + ",";
				}
			}
		}
		
		public static function newsong():void
		{
			changetab(MENUTAB_FILE);
			bpm = 120;
			boxcount = 16;
			barcount = 4;
			doublesize = false;
			effectvalue = 0;
			effecttype = 0;
			updateeffects();
			_driver.bpm = bpm;
			arrange.clear();
			musicbox[0].clear();
			changekey(0);
			changescale(0);
			arrange.bar[0].channel[0] = 0;
			numboxes = 1;
			currentbox = 0;
			numinstrument = 1;
			instrumentmanagerview = 0;
			patternmanagerview = 0;
			// set instrument to grand piano
			instrument[0] = new instrumentclass();
			instrument[0].voice = _presets["midi.piano1"];
			instrument[0].updatefilter();
			showmessage("NEW SONG CREATED");
		}
		
		public static function readfilestream():int
		{
			fi++;
			return filestream[fi - 1];
		}
		
		public static function convertfilestring():void
		{
			fi = 0;
			version = readfilestream();
			if (version == 3)
			{
				swing = readfilestream();
				effecttype = readfilestream();
				effectvalue = readfilestream();
				updateeffects();
				bpm = readfilestream();
				_driver.bpm = bpm;
				boxcount = readfilestream();
				doublesize = boxcount > 16;
				barcount = readfilestream();
				numinstrument = readfilestream();
				for (i = 0; i < numinstrument; i++)
				{
					instrument[i].index = readfilestream();
					setinstrumenttoindex(i);
					instrument[i].type = readfilestream();
					instrument[i].palette = readfilestream();
					instrument[i].cutoff = readfilestream();
					instrument[i].resonance = readfilestream();
					instrument[i].volume = readfilestream();
					instrument[i].updatefilter();
					if (instrument[i].type > 0)
					{
						drumkit[instrument[i].type - 1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
						drumkit[instrument[i].type - 1].updatevolume(instrument[i].volume);
					}
				}
				//Next, musicboxes
				numboxes = readfilestream();
				for (i = 0; i < numboxes; i++)
				{
					musicbox[i].key = readfilestream();
					musicbox[i].scale = readfilestream();
					musicbox[i].instr = readfilestream();
					musicbox[i].palette = readfilestream();
					musicbox[i].numnotes = readfilestream();
					for (j = 0; j < musicbox[i].numnotes; j++)
					{
						musicbox[i].notes[j].x = readfilestream();
						musicbox[i].notes[j].y = readfilestream();
						musicbox[i].notes[j].width = readfilestream();
						musicbox[i].notes[j].height = readfilestream();
					}
					musicbox[i].findtopnote();
					musicbox[i].findbottomnote();
					musicbox[i].notespan = musicbox[i].topnote - musicbox[i].bottomnote;
					musicbox[i].recordfilter = readfilestream();
					if (musicbox[i].recordfilter == 1)
					{
						for (j = 0; j < 16; j++)
						{
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
				for (i = 0; i < arrange.lastbar; i++)
				{
					for (j = 0; j < 8; j++)
					{
						arrange.bar[i].channel[j] = readfilestream();
					}
				}
			}
			else
			{
				//opps, the file we're loading is out of date. Let's try to convert it
				legacy_convertfilestring(version);
				version = 3;
			}
		}
		
		public static function legacy_convertfilestring(t:int):void
		{
			switch (t)
			{
			case 2: //Before effects and 32 note patterns
				swing = readfilestream();
				effecttype = 0;
				effectvalue = 0;
				bpm = readfilestream();
				_driver.bpm = bpm;
				boxcount = readfilestream();
				doublesize = boxcount > 16;
				barcount = readfilestream();
				numinstrument = readfilestream();
				for (i = 0; i < numinstrument; i++)
				{
					instrument[i].index = readfilestream();
					setinstrumenttoindex(i);
					instrument[i].type = readfilestream();
					instrument[i].palette = readfilestream();
					instrument[i].cutoff = readfilestream();
					instrument[i].resonance = readfilestream();
					instrument[i].volume = readfilestream();
					instrument[i].updatefilter();
					if (instrument[i].type > 0)
					{
						drumkit[instrument[i].type - 1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
						drumkit[instrument[i].type - 1].updatevolume(instrument[i].volume);
					}
				}
				//Next, musicboxes
				numboxes = readfilestream();
				for (i = 0; i < numboxes; i++)
				{
					musicbox[i].key = readfilestream();
					musicbox[i].scale = readfilestream();
					musicbox[i].instr = readfilestream();
					musicbox[i].palette = readfilestream();
					musicbox[i].numnotes = readfilestream();
					for (j = 0; j < musicbox[i].numnotes; j++)
					{
						musicbox[i].notes[j].x = readfilestream();
						musicbox[i].notes[j].y = readfilestream();
						musicbox[i].notes[j].width = readfilestream();
						musicbox[i].notes[j].height = readfilestream();
					}
					musicbox[i].findtopnote();
					musicbox[i].findbottomnote();
					musicbox[i].notespan = musicbox[i].topnote - musicbox[i].bottomnote;
					musicbox[i].recordfilter = readfilestream();
					if (musicbox[i].recordfilter == 1)
					{
						for (j = 0; j < 16; j++)
						{
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
				for (i = 0; i < arrange.lastbar; i++)
				{
					for (j = 0; j < 8; j++)
					{
						arrange.bar[i].channel[j] = readfilestream();
					}
				}
				break;
			case 1: //Original release, had a bug where volume info wasn't saved
				bpm = readfilestream();
				_driver.bpm = bpm;
				swing = 0;
				effecttype = 0;
				effectvalue = 0;
				boxcount = readfilestream();
				doublesize = boxcount > 16;
				barcount = readfilestream();
				numinstrument = readfilestream();
				for (i = 0; i < numinstrument; i++)
				{
					instrument[i].index = readfilestream();
					setinstrumenttoindex(i);
					instrument[i].type = readfilestream();
					instrument[i].palette = readfilestream();
					instrument[i].cutoff = readfilestream();
					instrument[i].resonance = readfilestream();
					instrument[i].updatefilter();
					if (instrument[i].type > 0)
					{
						drumkit[instrument[i].type - 1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
					}
				}
				//Next, musicboxes
				numboxes = readfilestream();
				for (i = 0; i < numboxes; i++)
				{
					musicbox[i].key = readfilestream();
					musicbox[i].scale = readfilestream();
					musicbox[i].instr = readfilestream();
					musicbox[i].palette = readfilestream();
					musicbox[i].numnotes = readfilestream();
					for (j = 0; j < musicbox[i].numnotes; j++)
					{
						musicbox[i].notes[j].x = readfilestream();
						musicbox[i].notes[j].y = readfilestream();
						musicbox[i].notes[j].width = readfilestream();
						musicbox[i].notes[j].height = readfilestream();
					}
					musicbox[i].findtopnote();
					musicbox[i].findbottomnote();
					musicbox[i].notespan = musicbox[i].topnote - musicbox[i].bottomnote;
					musicbox[i].recordfilter = readfilestream();
					if (musicbox[i].recordfilter == 1)
					{
						for (j = 0; j < 16; j++)
						{
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
				for (i = 0; i < arrange.lastbar; i++)
				{
					for (j = 0; j < 8; j++)
					{
						arrange.bar[i].channel[j] = readfilestream();
					}
				}
				break;
			}
		}
		
		// File stuff
		
		CONFIG::desktop
		{
			
			public static function fileHasExtension(file:File, extension:String):Boolean
			{
				if (!file.extension || file.extension.toLowerCase() != extension)
				{
					return false;
				}
				return true;
			}
			
			public static function addExtensionToFile(file:File, extension:String):void
			{
				file.url += "." + extension;
			}
			
			public static function saveceol():void
			{
				if (!filepath)
				{
					filepath = defaultDirectory;
				}
				file = filepath.resolvePath("*.ceol");
				file.addEventListener(Event.SELECT, onsaveceol);
				file.browseForSave("Save .ceol File");
				
				fixmouseclicks = true;
			}
			
			private static function onsaveceol(e:Event):void
			{
				file = e.currentTarget as File;
				
				if (!fileHasExtension(file, "ceol"))
				{
					addExtensionToFile(file, "ceol");
				}
				
				makefilestring();
				
				stream = new FileStream();
				stream.open(file, FileMode.WRITE);
				stream.writeUTFBytes(filestring);
				stream.close();
				
				fixmouseclicks = true;
				showmessage("SONG SAVED");
				savefilesettings();
			}
			
			public static function loadceol():void
			{
				if (!filepath)
				{
					filepath = defaultDirectory;
				}
				file = filepath.resolvePath("");
				file.addEventListener(Event.SELECT, onloadceol);
				file.browseForOpen("Load .ceol File", [ceolFilter]);
				
				fixmouseclicks = true;
			}
			
			public static function invokeceol(t:String):void
			{
				file = new File();
				file.nativePath = t;
				
				stream = new FileStream();
				stream.open(file, FileMode.READ);
				filestring = stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
				
				loadfilestring(filestring);
				_driver.play(null, false);
				
				fixmouseclicks = true;
				showmessage("SONG LOADED");
			}
			
			private static function onloadceol(e:Event):void
			{
				file = e.currentTarget as File;
				filepath = file.resolvePath("");
				
				stream = new FileStream();
				stream.open(file, FileMode.READ);
				filestring = stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
				
				loadfilestring(filestring);
				_driver.play(null, false);
				
				fixmouseclicks = true;
				showmessage("SONG LOADED");
				savefilesettings();
			}
			
			public static function exportxm():void
			{
				stopmusic();
				
				if (!filepath)
				{
					filepath = defaultDirectory;
				}
				file = filepath.resolvePath("*.xm");
				file.addEventListener(Event.SELECT, onexportxm);
				file.browseForSave("Export .XM module file");
				
				fixmouseclicks = true;
			}
			
			private static function onexportxm(e:Event):void
			{
				file = e.currentTarget as File;
				
				if (!fileHasExtension(file, "xm"))
				{
					addExtensionToFile(file, "xm");
				}
				
				var xm:TrackerModuleXM = new TrackerModuleXM();
				xm.loadFromLiveBoscaCeoilModel(file.name);
				
				stream = new FileStream();
				stream.open(file, FileMode.WRITE);
				xm.writeToStream(stream);
				stream.close();
				
				fixmouseclicks = true;
				showmessage("SONG EXPORTED AS XM");
				savefilesettings();
			}
			
			public static function exportmml():void
			{
				stopmusic();
				
				if (!filepath)
				{
					filepath = defaultDirectory;
				}
				file = filepath.resolvePath("*.mml");
				file.addEventListener(Event.SELECT, onexportmml);
				file.browseForSave("Export MML music text file");
				
				fixmouseclicks = true;
			}
			
			private static function onexportmml(e:Event):void
			{
				file = e.currentTarget as File;
				
				if (!fileHasExtension(file, "mml"))
				{
					addExtensionToFile(file, "mml");
				}
				
				var song:MMLSong = new MMLSong();
				song.loadFromLiveBoscaCeoilModel();
				
				stream = new FileStream();
				stream.open(file, FileMode.WRITE);
				song.writeToStream(stream);
				stream.close();
				
				fixmouseclicks = true;
				showmessage("SONG EXPORTED AS MML");
				savefilesettings();
			}
			
			private static function onsavewav(e:Event):void
			{
				file = e.currentTarget as File;
				
				if (!fileHasExtension(file, "wav"))
				{
					addExtensionToFile(file, "wav");
				}
				
				stream = new FileStream();
				stream.open(file, FileMode.WRITE);
				stream.writeBytes(_wav, 0, _wav.length);
				stream.close();
				
				fixmouseclicks = true;
				showmessage("SONG EXPORTED AS WAV");
				savefilesettings();
			}
		
		}
		
		CONFIG::web
		{
			public static function invokeCeolWeb(ceolStr:String):void
			{
				changetab(MENUTAB_FILE);
				if (ceolStr != "")
				{
					filestring = ceolStr;
					loadfilestring(filestring);
					showmessage("SONG LOADED");
				}
				else
				{
					newsong();
				}
				
				_driver.play(null, false);
			}
			
			public static function getCeolString():String
			{
				makefilestring();
				return filestring;
			}
		}
		
		private static function loadfilestring(s:String):void
		{
			filestream = new Array();
			filestream = s.split(",");
			
			numinstrument = 1;
			numboxes = 0;
			arrange.clear();
			arrange.currentbar = 0;
			arrange.viewstart = 0;
			
			convertfilestring();
			
			changemusicbox(0);
			looptime = 0;
		}
		
		public static function showmessage(t:String):void
		{
			message = t;
			messagedelay = 90;
		}
		
		public static function onStream(e:SiONEvent):void
		{
			e.streamBuffer.position = 0;
			while (e.streamBuffer.bytesAvailable > 0)
			{
				var d:int = e.streamBuffer.readFloat() * 32767;
				if (nowexporting) _data.writeShort(d);
			}
		}
		
		public static function pausemusic():void
		{
			if (musicplaying)
			{
				musicplaying = !musicplaying;
				if (!musicplaying) notecut();
			}
		}
		
		public static function stopmusic():void
		{
			if (musicplaying)
			{
				musicplaying = !musicplaying;
				looptime = 0;
				arrange.currentbar = arrange.loopstart;
				if (!musicplaying) notecut();
			}
		}
		
		public static function startmusic():void
		{
			if (!musicplaying)
			{
				musicplaying = !musicplaying;
			}
		}
		
		public static function exportwav():void
		{
			changetab(MENUTAB_ARRANGEMENTS);
			clicklist = true;
			arrange.loopstart = 0;
			arrange.loopend = arrange.lastbar;
			musicplaying = true;
			looptime = 0;
			arrange.currentbar = arrange.loopstart;
			SetSwing();
			
			//Clear the wav buffer
			_data = new ByteArray();
			_data.endian = Endian.LITTLE_ENDIAN;
			
			followmode = true;
			nowexporting = true;
		}
		
		public static function savewav():void
		{
			nowexporting = false;
			followmode = false;
			
			_wav = new ByteArray();
			_wav.endian = Endian.LITTLE_ENDIAN;
			_wav.writeUTFBytes("RIFF");
			var len:int = _data.length;
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
			
			CONFIG::desktop
			{
				if (!filepath)
				{
					filepath = defaultDirectory;
				}
				file = filepath.resolvePath("*.wav");
				file.addEventListener(Event.SELECT, onsavewav);
				file.browseForSave("Export .wav File");
			}
			
			CONFIG::web
			{
				var b64:Base64Encoder = new Base64Encoder();
				_wav.position = 0;
				b64.encodeBytes(_wav);
				ExternalInterface.call('Bosca._wavRecorded', b64.toString());
			}
			
			fixmouseclicks = true;
		}
		
		public static function changetab(newtab:int):void
		{
			currenttab = newtab;
			guiclass.changetab(newtab);
		}
		
		public static function changetab_ifdifferent(newtab:int):void
		{
			if (currenttab != newtab)
			{
				currenttab = newtab;
				guiclass.changetab(newtab);
			}
		}
		
		CONFIG::desktop
		{
			public static var file:File, stream:FileStream;
		}
		public static var filestring:String, fi:int;
		public static var filestream:Array;
		public static var ceolFilter:FileFilter = new FileFilter("Ceol", "*.ceol");
		
		public static var i:int, j:int, k:int;
		
		public static var fullscreen:Boolean;
		
		public static var fullscreentoggleheld:Boolean = false;
		
		public static var press_up:Boolean, press_down:Boolean, press_left:Boolean, press_right:Boolean, press_space:Boolean, press_enter:Boolean;
		public static var keypriority:int = 0;
		public static var keyheld:Boolean = false;
		;
		public static var clicklist:Boolean;
		public static var clicksecondlist:Boolean;
		public static var copykeyheld:Boolean = false;
		
		public static var keydelay:int, keyboardpressed:int = 0;
		public static var fixmouseclicks:Boolean = false;
		
		public static var mx:int, my:int;
		public static var test:Boolean, teststring:String;
		
		public static var _driver:SiONDriver;
		public static var _presets:SiONPresetVoice;
		public static var voicelist:voicelistclass;
		
		public static var instrument:Vector.<instrumentclass> = new Vector.<instrumentclass>;
		public static var numinstrument:int;
		public static var instrumentmanagerview:int;
		
		public static var musicbox:Vector.<musicphraseclass> = new Vector.<musicphraseclass>;
		public static var numboxes:int;
		public static var looptime:int;
		public static var currentbox:int;
		public static var currentnote:int;
		public static var currentinstrument:int;
		public static var boxsize:int, boxcount:int;
		public static var barsize:int, barcount:int;
		public static var notelength:int;
		public static var doublesize:Boolean;
		public static var arrangescrolldelay:int = 0;
		
		public static var barposition:Number = 0;
		public static var drawnoteposition:int, drawnotelength:int;
		
		public static var cursorx:int, cursory:int;
		public static var arrangecurx:int, arrangecury:int;
		public static var patterncury:int, timelinecurx:int;
		public static var instrumentcury:int;
		public static var notey:int;
		
		public static var notename:Vector.<String> = new Vector.<String>;
		public static var scalename:Vector.<String> = new Vector.<String>;
		
		public static var currentscale:int = 0;
		public static var scale:Vector.<int> = new Vector.<int>;
		public static var key:int;
		public static var scalesize:int;
		
		public static var pianoroll:Vector.<int> = new Vector.<int>;
		public static var invertpianoroll:Vector.<int> = new Vector.<int>;
		public static var pianorollsize:int;
		
		public static var arrange:arrangementclass = new arrangementclass();
		public static var drumkit:Vector.<drumkitclass> = new Vector.<drumkitclass>;
		
		public static var currenttab:int;
		
		public static var dragaction:int, dragx:int, dragy:int, dragpattern:int;
		public static var patternmanagerview:int;
		
		public static var trashbutton:int;
		
		public static var list:listclass = new listclass;
		public static var secondlist:listclass = new listclass;
		public static var midilistselection:int;
		
		public static var musicplaying:Boolean = true;
		public static var nowexporting:Boolean = false;
		public static var followmode:Boolean = false;
		public static var bpm:int;
		public static var version:int;
		public static var swing:int;
		public static var swingoff:int;
		
		public static var doubleclickcheck:int;
		
		public static var programsettings:SharedObject;
		public static var buffersize:int, currentbuffersize:int;
		
		private static var _data:ByteArray;
		private static var _wav:ByteArray;
		
		public static var message:String;
		public static var messagedelay:int = 0;
		public static var startup:int = 0, invokefile:String = "null";
		public static var ctrl:String;
		
		// Add filepath memory
		public static var filepath:File = null;
		public static var defaultDirectory:File = null;
		
		//Global effects
		public static var effecttype:int;
		public static var effectvalue:int;
		public static var effectname:Vector.<String> = new Vector.<String>;
		
		public static var versionnumber:String;
		public static var savescreencountdown:int;
		public static var minresizecountdown:int;
		public static var forceresize:Boolean = false;
	}
}