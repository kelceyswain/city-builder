s.boot;
(
SynthDef("pulse", {arg pitch = 60, amp = 0.5, spread = 0.3, gate = 1;
	var in, out, env, chain, igate;
	igate =  EnvGate.new(1, gate, doneAction:0) * Impulse.kr(spread.reciprocal);
	env = EnvGen.kr(Env.perc(0.02, 0.75, 1), igate);
	in = Saw.ar( LFNoise2.kr(10).range(30, 100) , env);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinScramble(chain, 0.5, 0.5, igate);
	out = IFFT(chain);
	out = Pan2.ar(out, Line.kr(-0.5, 0, 8), amp);
	DetectSilence.ar(out, 0.0001, spread, doneAction:2);
	Out.ar(0, env*out);
}).add
)

x = Synth("pulse", [\spread, (133/15).reciprocal]);
x.set(\gate, 0);

(
SynthDef("bassline", {arg pitch = 30, amp = 0.3, filter1 = 450, filter2 = 800, bpm = 133;
	var out;
	out = LFSaw.kr(bpm/60).range(0,1) * Formant.ar([pitch.midicps, (pitch*1.007).midicps], filter1, filter2, mul:amp);
	Out.ar(0, out);
}).add;
)

a = Synth("bassline");
a.set(\pitch, 30);
a.set(\filter1, 100);
a.set(\filter2, 1200);
a.set(\bpm, 750);
a.set(\amp, 0.5);



{LFSaw.kr(133/120).range(0,1)* Formant.ar([MouseX.kr(50, 400),MouseX.kr(50*1.01,400*1.01)], MouseY.kr(400, 1000), mul:0.2)}.play

s.quit;
