/**
 * Copyright(C) 2008 Efishocean
 * 
 * This file is part of Midias.
 *
 * Midias is an ActionScript3 midi lib developed by Efishocean.
 * Midias was extracted from my project 'ocean' which purpose to 
 * impletement a commen audio formats libray. 
 * More infos might appear on my blog http://www.tan66.cn 
 * 
 * Midias is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Midias is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */



package ocean.midi {
	
	/**
	* General MIDI's most recognized feature is the defined list of sounds or "patches".
	* However, General MIDI does not actually define the way the sound will be reproduced,
	* only the name of that sound. Though this can obviously result in wide variations in
	* performance from the same song data on different GM sound sources, the authors of
	* General MIDI felt it important to allow each manufacturer to have their own ideas
	* and express their personal aesthetics when it comes to picking the exact timbres
	* for each sound.Each manufacturer must insure that their sounds provide an acceptable
	* representation of song data written for General MIDI. Guidelines for developing GM
	* compatible sound sets and song data are available through the MMA.
	* 2007-7-15 20:28
	* @author Efish Ocean
	* @version 0.1	
	* Created: 2007-7-15 15:16:20
	* Modified: 2007-7-15 20:57:26
	* @link http://www.tan66.com
	* @link http://www.tan66.cn
	*/
	public final class MidiInstrument {
		/**
		* Instrument Patch Map
		* Note: While GM1 does not define the actual characteristics of any sounds,
		* the names in parentheses after each of the synth leads, pads, and sound
		* effects are, in particular, intended only as guides).
		*/
		static private const _instrumentName:Array = ["Acoustic Grand Piano",
													"Bright Acoustic Piano",
													"Electric Grand Piano",
													"Honky-tonk Piano",
													"Rhodes Piano",
													"Chorused Piano",
													"Harpsichord",
													"Clavichord",
													"Celesta",
													"Glockenspiel",
													"Music box",
													"Vibraphone",
													"Marimba",
													"Xylophone",
													"Tubular Bells",
													"Dulcimer",
													"Hammond Organ",
													"Percussive Organ",
													"Rock Organ",
													"Church Organ",
													"Reed Organ",
													"Accordian",
													"Harmonica",
													"Tango Accordian",
													"Acoustic Guitar (nylon)",
													"Acoustic Guitar (steel)",
													"Electric Guitar (jazz)",
													"Electric Guitar (clean)",
													"Electric Guitar (muted)",
													"Overdriven Guitar",
													"Distortion Guitar",
													"Guitar Harmonics",
													"Acoustic Bass",
													"Electric Bass(finger)",
													"Electric Bass (pick)",
													"Fretless Bass",
													"Slap Bass 1",
													"Slap Bass 2",
													"Synth Bass 1",
													"Synth Bass 2",
													"Violin",
													"Viola",
													"Cello",
													"Contrabass",
													"Tremolo Strings",
													"Pizzicato Strings",
													"Orchestral Harp",
													"Timpani",
													"String Ensemble 1",
													"String Ensemble 2",
													"Synth Strings 1",
													"Synth Strings 2",
													"Choir Aahs",
													"Voice Oohs",
													"Synth Voice",
													"Orchestra Hit",
													"Trumpet",
													"Trombone",
													"Tuba",
													"Muted Trumpet",
													"French Horn",
													"Brass Section",
													"Synth Brass 1",
													"Synth Brass 2",
													"Soprano Sax",
													"Alto Sax",
													"Tenor Sax",
													"Baritone Sax",
													"Oboe",
													"English Horn",
													"Bassoon",
													"Clarinet",
													"Piccolo",
													"Flute",
													"Recorder",
													"Pan Flute",
													"Bottle Blow",
													"Shakuhachi",
													"Whistle",
													"Ocarina",
													"Lead 1 (square)",
													"Lead 2 (sawtooth)",
													"Lead 3 (caliope lead)",
													"Lead 4 (chiff lead)",
													"Lead 5 (charang)",
													"Lead 6 (voice)",
													"Lead 7 (fifths)",
													"Lead 8 (bass+lead)",
													"Pad 1 (new age)",
													"Pad 2 (warm)",
													"Pad 3 (polysynth)",
													"Pad 4 (choir)",
													"Pad 5 (bowed)",
													"Pad 6 (metallic)",
													"Pad 7 (halo)",
													"Pad 8 (sweep)",
													"FX 1 (rain)",
													"FX 2 (soundtrack)",
													"FX 3 (crystal)",
													"FX 4 (atmosphere)",
													"FX 5 (brightness)",
													"FX 6 (goblins)",
													"FX 7 (echoes)",
													"FX 8 (sci-fi)",
													"Sitar",
													"Banjo",
													"Shamisen",
													"Koto",
													"Kalimba",
													"Bagpipe",
													"Fiddle",
													"Shanai",
													"Tinkle Bell",
													"Agogo",
													"Steel Drums",
													"Woodblock",
													"Taiko Drum",
													"Melodic Tom",
													"Synth Drum",
													"Reverse Cymbal",
													"Guitar Fret Noise",
													"Breath Noise",
													"Seashore",
													"Bird Tweet",
													"Telephone Ring",
													"Helicopter",
													"Applause",
													"Gunshot"];
		/**
		* General MIDI Level 1 Percussion Key Map
		* On MIDI Channel 10, each MIDI Note number ("Key#") corresponds to a different drum sound,
		* as shown below. GM-compatible instruments must have the sounds on the keys shown here.
		* While many current instruments also have additional sounds above or below the range show here,
		* and may even have additional "kits" with variations of these sounds, only these sounds are
		* supported by General MIDI Level 1 devices.
		*/
		static private const _percussionName:Array = ["Acoustic Bass Drum",
												"Bass Drum 1",
												"Side Stick",
												"Acoustic Snare",
												"Hand Clap",
												"Electric Snare",
												"Low Floor Tom",
												"Closed Hi-Hat",
												"High Floor Tom",
												"Pedal Hi-Hat",
												"Low Tom",
												"Open Hi-Hat",
												"Low-Mid Tom",
												"Hi-Mid Tom",
												"Crash Cymbal 1",
												"High Tom",
												"Ride Cymbal 1",
												"Chinese Cymbal",
												"Ride Bell",
												"Tambourine",
												"Splash Cymbal",
												"Cowbell",
												"Crash Cymbal 2",
												"Vibraslap",
												"Ride Cymbal 2",
												"Hi Bongo",
												"Low Bongo",
												"Mute Hi Conga",
												"Open Hi Conga",
												"Low Conga",
												"High Timbale",
												"Low Timbale",
												"High Agogo",
												"Low Agogo",
												"Cabasa",
												"Maracas",
												"Short Whistle",
												"Long Whistle",
												"Short Guiro",
												"Long Guiro",
												"Claves",
												"Hi Wood Block",
												"Low Wood Block",
												"Mute Cuica",
												"Open Cuica",
												"Mute Triangle",
												"Open Triangle"];
												
		/**
		* Instrument Families
		* The General MIDI Level 1 instrument sounds are grouped by families.
		* In each family are 8 specific instruments.
		*/
		private static const _familyName:Array = ["Piano",
												"Chromatic Percussion",
												"Organ",
												"Guitar",
												"Bass",
												"Strings",
												"Ensemble",
												"Brass",
												"Reed",
												"Pipe",
												"Synth Lead",
												"Synth Pad",
												"Synth Effects",
												"Ethnic",
												"Percussive",
												"Sound Effects"];
		/**
		 * @param key index.
		 * @return Instrument name in GM table.
		 */
		public static function getInstrumentName(key:uint):String{
			if( key>127 || key<0 ){
				throw new Error("getInstrumentName("+key+") Error! Invalid instrument channel number. In GM1 specification, 0-127 indicate 128 program channels.");
			}else{
				return _instrumentName[key];
			}
		}
		
		/**
		 * @param key index
		 * @return Percussion name in GM table
		 */
		public static function getPercussionName(key:uint):String{
			if( key<35 || key>81 ){
				throw new Error("getPercussionName("+key+") Error! Invalid drum key number. In GM1 specification, 35-81 indicate 46 drum sounds.");
			}else{
				return _percussionName[key-35];
			}
		}
		
		/**
		 * @param	key index.
		 * @return Family name of the instrument.
		 */
		public static function getFamilyNameOf(key:uint):String{
			if( key>127 || key<0 ){
				throw new Error("getFamilyNameOf("+key+") Error! Invalid instrument channel number. In GM1 specification, 0-127 indicate 128 program channels.");
			}else{
				return _familyName[Math.floor(key/8)];
			}
		}
	}
	
}
