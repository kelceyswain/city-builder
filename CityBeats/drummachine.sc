(
var kick, snare, hihat;
kick = Buffer.read(s,"/home/kelcey/audio/percussion/linndrum/kick.wav");
snare = Buffer.read(s,"/home/kelcey/audio/percussion/linndrum/sd.wav");
hihat = Buffer.read(s, "/home/kelcey/audio/percussion/tr909/HHCD2.WAV");

SynthDef(\kick, { |basefreq = 50, ratio = 7, sweeptime = 0.05, preamp = 1, amp = 1,
        decay1 = 0.3, decay1L = 0.8, decay2 = 0.15, out|
	var sig = PlayBuf.ar(1, kick.bufnum, doneAction:2);
	Out.ar(out, Pan2.ar(sig, 0)*amp)
}).add;

SynthDef(\snare, { |amp = 1, freq = 2000, rq = 3, decay = 0.3, pan, out|
	var sig = PlayBuf.ar(1, snare.bufnum, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan)*amp)
}).add;

SynthDef(\hihat, { |amp = 1, freq = 2000, rq = 3, decay = 0.3, pan, out|
	var sig = PlayBuf.ar(1, hihat.bufnum, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan)*amp)
}).add;

~commonFuncs = (
        // save starting time, to recognize the last bar of a 4-bar cycle
    init: {
        if(~startTime.isNil) { ~startTime = thisThread.clock.beats };
    },
        // convert the rhythm arrays into patterns
    pbindPairs: { |keys|
        var    pairs = Array(keys.size * 2);
        keys.do({ |key|
            if(key.envirGet.notNil) { pairs.add(key).add(Pseq(key.envirGet, 1)) };
        });
        pairs
    },
        // identify rests in the rhythm array
        // (to know where to stick notes in)
    getRestIndices: { |array|
        var    result = Array(array.size);
        array.do({ |item, i|
            if(item == 0) { result.add(i) }
        });
        result
    }
);
)

(
TempoClock.default.tempo = 80 / 60;

~kikEnvir = (
    parent: ~commonFuncs,
        // rhythm pattern that is constant in each bar
    baseAmp: #[1, 0, 0, 0,  0, 0, 0.7, 0,  0, 1, 0, 0,  0, 0, 0, 0] ,
    baseDecay: #[0.15, 0, 0, 0,  0, 0, 0.15, 0,  0, 0.15, 0, 0,  0, 0, 0, 0],
    addNotes: {
        var    beat16pos = (thisThread.clock.beats - ~startTime) % 16,
            available = ~getRestIndices.(~baseAmp);
        ~amp = ~baseAmp.copy;
        ~decay2 = ~baseDecay.copy;
            // if last bar of 4beat cycle, do busier fills
        if(beat16pos.inclusivelyBetween(12, 16)) {
            available.scramble[..rrand(5, 10)].do({ |index|
                    // crescendo
                ~amp[index] = index.linexp(0, 15, 0.2, 0.5);
                ~decay2[index] = 0.15;
            });
        } {
            available.scramble[..rrand(0, 2)].do({ |index|
                ~amp[index] = rrand(0.15, 0.3);
                ~decay2[index] = rrand(0.05, 0.1);
            });
        }
    }
);

~snrEnvir = (
    parent: ~commonFuncs,
    baseAmp: #[0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 0] ,
    baseDecay: #[0, 0, 0, 0,  0.7, 0, 0, 0,  0, 0, 0, 0,  0.4, 0, 0, 0],
    addNotes: {
        var    beat16pos = (thisThread.clock.beats - ~startTime) % 16,
            available = ~getRestIndices.(~baseAmp),
            choice;
        ~amp = ~baseAmp.copy;
        ~decay = ~baseDecay.copy;
        if(beat16pos.inclusivelyBetween(12, 16)) {
            available.scramble[..rrand(5, 9)].do({ |index|
                ~amp[index] = index.linexp(0, 15, 0.5, 1.8);
                ~decay[index] = rrand(0.2, 0.4);
            });
        } {
            available.scramble[..rrand(1, 3)].do({ |index|
                ~amp[index] = rrand(0.15, 0.3);
                ~decay[index] = rrand(0.2, 0.4);
            });
        }
    }
);


~hhEnvir = (
    parent: ~commonFuncs,
    baseAmp: 0.3 ! 16,
    baseDelta: 0.25 ! 16,
    addNotes: {
        var    beat16pos = (thisThread.clock.beats - ~startTime) % 16,
            available = (0..15),
            toAdd;
            // if last bar of 4beat cycle, do busier fills
        ~amp = ~baseAmp.copy;
        ~dur = ~baseDelta.copy;
        if(beat16pos.inclusivelyBetween(12, 16)) {
            toAdd = available.scramble[..rrand(2, 5)]
        } {
            toAdd = available.scramble[..rrand(0, 1)]
        };
        toAdd.do({ |index|
            ~amp[index] = ~doubleTimeAmps;
            ~dur[index] = ~doubleTimeDurs;
        });
    },
    doubleTimeAmps: Pseq(#[0.3, 0.2], 1),
    doubleTimeDurs: Pn(0.125, 2)
);


~kik = Penvir(~kikEnvir, Pn(Plazy({
    ~init.value;
    ~addNotes.value;
    Pbindf(
        Pbind(
            \instrument, \kick,
            \preamp, 0.4,
            \dur, 0.25,
            *(~pbindPairs.value(#[amp, decay2]))
        ),
            // default Event checks \freq --
            // if a symbol like \rest or even just \,
            // the event is a rest and no synth will be played
        \freq, Pif(Pkey(\amp) > 0, 1, \rest)
    )
}), inf)).play(quant: 4);

~snr = Penvir(~snrEnvir, Pn(Plazy({
    ~init.value;
    ~addNotes.value;
    Pbindf(
        Pbind(
            \instrument, \snare,
            \dur, 0.25,
            *(~pbindPairs.value(#[amp, decay]))
        ),
        \freq, Pif(Pkey(\amp) > 0, 5000, \rest)
    )
}), inf)).play(quant: 4);

~hh = Penvir(~hhEnvir, Pn(Plazy({
    ~init.value;
    ~addNotes.value;
    Pbindf(
        Pbind(
            \instrument, \hihat,
            \rq, 0.06,
            \amp, 1,
            \decay, 0.04,
            *(~pbindPairs.value(#[amp, dur]))
        ),
        \freq, Pif(Pkey(\amp) > 0, 12000, \rest)
    )
}), inf)).play(quant: 4);
)

// stop just before barline
t = TempoClock.default;
(t.schedAbs(t.nextTimeOnGrid(4, -0.001), {
    [~kik, ~snr, ~hh].do(_.stop);
});
)