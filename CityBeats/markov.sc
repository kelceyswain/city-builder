// Modified from Jacob Joaquin
// CodeHop.com
// http://codehop.com/markov-experiment-ii/

s.boot;

(
SynthDef(\drumMachine, {|buf, amp = 1.0|
	Out.ar([0,1], PlayBuf.ar(1, buf, doneAction:2));
}).add;

~bd = Buffer.read(s, "/home/kelcey/audio/percussion/linndrum/kick.wav");
~sd = Buffer.read(s, "/home/kelcey/audio/percussion/linndrum/sd.wav");
)

(
t = Task({
	var node_list = [
		[~bd, 1, [[1, 2]]],
		[~sd, 0.5, [[0, 1], [1, 1]]]
	];

	var node_index = 0;
	var bpm = 133.0 / 60.0;  // Beats per second

	100.do({
		var weight = 0;
		var random;
		var accumulator;
		var node = node_list[node_index];
		var buf = node[0];
		var dur = node[1] / bpm;
		var paths = node[2];

		// Get total statistical weight of connected nodes
		(0 .. paths.size - 1).do {|i| weight = weight + paths[i][1]};

		// Generate random value for choosing next node
		random = weight.rand;

		// Choose next node based on statistical weights
		accumulator = paths[0][1];

		node_index = block {|break|
			paths.size.do {|i|
				if ((random < accumulator), {
					break.value(paths[i][0])
				}, {
					accumulator = accumulator + paths[i + 1][1]
				})
			}
		};

		Synth(\drumMachine, [\buf, buf, \amp -3.dbamp]);
		dur.wait;
	})
});
)

t.start;

s.quit;