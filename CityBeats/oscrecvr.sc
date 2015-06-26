s.boot;
s.quit;

(
b = Buffer.read(s, "/home/kelcey/audio/SteinwayMono.wav");
SynthDef(\grainPiano, {arg gate = 1, amp = 0.1, sndbuf, t_trig = 0, dry = 1, pos = 0;
	    var env, freqdev;
	    env = EnvGen.kr(
		        Env([0, 1, 0], [1, 1], \sin, 1),
		        gate,
		        levelScale: amp,
		        doneAction: 2);
	    Out.ar(0,
		GVerb.ar(GrainBuf.ar(1, t_trig, 0.15, sndbuf, 1, pos, 2, 0, -1), 40, 1.24, dry, 0.95, 15, dry, -15, -11, mul: env));
    }).send(s);

SynthDef(\evilBang, { | freq, width, length = 5, cps = 6 |
	var env, synth;
	env = EnvGen.kr(Env.perc(0.01, length));
	synth = Gendy2.ar(3, 4, 2, 5, [freq, freq], freq + width, initCPs: cps, mul:0.1);
	synth = BPeakEQ.ar(synth, freq+(width * 0.5), 50, 18);
	synth = synth + (0.0075 * DynKlank.ar(`[[Rand(500, 750), Rand(750, 1000), Rand(1000 ,2000), Rand(2000, 3500)], nil, [1,0.8,0.6,0.4]], synth));
	synth = FreeVerb.ar(synth * env, room:0.5);
	DetectSilence.ar(synth, doneAction:2);
	Out.ar(0, synth);
}).add;
)


Synth(\evilBang, [\freq, 50]);

(
//o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/branch');
a = Synth(\grainPiano, [\sndbuf, b]);
o = OSCFunc({ arg msg, time, addr, recvPort; a.set(\t_trig, 1); a.set(\trigger, 0); a.set(\dry, msg[1]); a.set(\pos, msg[2])}, '/road');
p = OSCFunc({ arg msg, time, addr, recvPort; Synth(\evilBang, [\freq,  msg[1]*100+20], \width, msg[2]*20+10); }, '/branch');
)

o.free;
p.free;