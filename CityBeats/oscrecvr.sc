s.boot;
s.quit;
(
~oldTime = Clock.seconds-1;
b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "samples/Steinway-2015-06-30_whitenotes_upper.wav");
c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "samples/Steinway-2015-06-30_whitenotes_lower.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "samples/Steinway-2015-06-30_pedal.wav");
SynthDef(\grainPiano, {arg gate = 1, amp = 0.01, sndbuf, t_trig = 0, dry = 1, pos = 0;
	    var env, freqdev;
	    env = EnvGen.kr(
		        Env([0, 1, 0], [1, 1], \sin, 1),
		        gate,
		        levelScale: amp,
		        doneAction: 2);
	    Out.ar(0,
		GVerb.ar(GrainBuf.ar(1, t_trig, 1, sndbuf, 1, pos, 2, 0, -1), 40, 1.24, dry, 0.95, 15, dry, -15, -11, mul: env));
		//GrainBuf.ar(2, t_trig, 0.5, sndbuf, 1, pos, 2, LFNoise2.kr(0.1).range(-1,1), -1, 512, 1));
    }).send(s);

SynthDef(\evilBang, { | note = 36, damp=0.5 |
	var env, synth, notes;
	// freq = (freq*450)+50;
	f = note.midicps;
	damp = damp * 4.0;
	// notes = [0, 2, 4, 5, 7, 9, 11] + 36;
	// f = notes[(notes.size*freq).floor].midicps;
	synth = CombL.ar( PlayBuf.ar(2, d), 0.2, 1/f, damp, 0.15);
	Out.ar(0, synth);
	DetectSilence.ar(synth, 0.0001, 0.1, 2);
}).add;
)

(
a = Synth(\grainPiano, [\sndbuf, b]);
z = Synth(\grainPiano, [\sndbuf, c]);
o = OSCFunc(
	{
		arg msg, time, addr, recvPort;
		a.set(\t_trig, 1);
		z.set(\t_trig, 1);
		a.set(\dry, msg[1]);
		z.set(\dry, msg[2]);
		a.set(\pos, msg[2]);
		z.set(\pos, msg[1]);
	},
	'/road');
p = OSCFunc({
	arg msg, time, addr, recvPort;
	var notes;
	notes = [0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23] + 24;

	if (time - ~oldTime > 0.99) {Synth(\evilBang, [\note, notes[(notes.size*msg[1]).floor], \damp, msg[2]]); ~oldTime = time;};
	},
	'/branch');

)

o.free;
p.free;