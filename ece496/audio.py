import matplotlib.pyplot as plt

from scipy.io import wavfile
import scipy.signal
import numpy as np
np.set_printoptions(threshold=np.nan)
import time
import fluidsynth





fl = fluidsynth.Synth(gain=3) #gain=[0,10]
fl.audio_driver="alsa"
sfid = fl.sfload("/home/peixin/Documents/UIUC/Matrix/Audio/soundFont/Wii_Grand_Piano.sf2")

fl.program_select(0, sfid, 0, 0)
_ = fl.cc(0, 7, 110) #fl.cc(0,7,50): chanel 0 volume is 50, range=0~127 np.random.uniform(40,100)

#fs.start("alsa")
for i in range(10):

	_ = fl.cc(0,11, np.random.randint(75,85)) #fl.cc(0,11,50): chanel 0 expression is 50, range=0~127 (0: soft, 127: hard)
	s=np.zeros((1,),dtype=np.int16)

	s = np.append(s, fl.get_samples(int(44100 * 0.2))[::2]) # we give 0.2 seconds of silent at first

	midiNum=int(np.random.choice([60,62,64,65,67,69,71]))
	fl.noteon(0, midiNum, int(np.random.randint(30,100)))

	#time.sleep(1.0)
	s = np.append(s, fl.get_samples(int(44100 * np.random.uniform(0.5,3)))[::2])


	fl.noteoff(0, midiNum)
	#time.sleep(1.0)

	s = np.append(s, fl.get_samples(44100 * 1)[::2])
	print(np.max(s))

	#plt.plot(s)
	#plt.show()



	# wavfile.write("a"+str(i)+"wav",44100,s)

fl.delete()
