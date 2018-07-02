from nicotb import *
from nicotb.utils import Scoreboard, BusGetter, Stacker
from nicotb.protocol import OneWire, TwoWire
from itertools import repeat
import MyModel as M
import numpy as np

def main():
	# Calculate answer
	images = M.LoadImages()
	features = M.ComputeImages(images)
	tags = [feature[4] for feature in features]
	answer = np.array(M.SortFeatures(features), dtype=np.int32)
	N_IMG = 16
	N_PX = 120*80

	# Connect to Verilog
	rst_out_ev, ck_ev = CreateEvents(["rst_out", "ck_ev"])

	# Initialization
	scb = Scoreboard("ISE")
	test = scb.GetTest(f"Top")
	st = Stacker(N_IMG, callbacks=[test.Get])
	bg = BusGetter(callbacks=[st.Get])

	# start simulation
	yield rst_out_ev
	yield ck_ev

	for i in range(100):
		yield ck_ev
	assert st.is_clean
	FinishSim()

RegisterCoroutines([
	main(),
])
