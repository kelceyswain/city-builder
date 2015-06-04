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

x = Synth("pulse", [\spread, 0.1]);
x.set(\gate, 0);

(
{
	50.do(
		{arg i;
			{Formant.ar(LFNoise2.kr(1).range(45, 50), LFNoise2.kr(0.1).range(100, 1000), mul:[LFNoise2.kr(1).range(0, 0.1),LFNoise2.kr(1).range(0, 0.1)]*Line.kr(1, 0, i, doneAction:2))}.play;
		}
	)
}.fork;
)

{Formant.ar(LFNoise2.kr(1).range(450, 500), LFNoise2.kr(0.1).range(100, 1000), 1250, mul:[LFNoise2.kr(1).range(0, 0.1),LFNoise2.kr(1).range(0, 0.1)]*Line.kr(1, 0, 10, doneAction:2))}.play;

{LFSaw.kr(2).range(0,1)* Formant.ar(MouseX.kr(50, 400), MouseY.kr(400, 1000), mul:0.2)}.play

s.quit;