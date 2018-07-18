from nicotb import *
from nicotb.utils import Scoreboard, BusGetter, Stacker
from nicotb.protocol import OneWire, TwoWire
from itertools import repeat
import MyModel as M
import numpy as np

def main():
	# Calculate answer
	# See MyModel.py for more information.
	images = M.LoadImages()
	features = M.ComputeImages(images)
	tags = [feature[4] for feature in features]
	answer = np.array(M.SortFeatures(features), dtype=np.int32)
	N_IMG = 16
	N_PX = 120*80

	# Connect to Verilog
	# Connect to the Verilog wire (please see the document)
	# TODO

	# Construct clock and reset event
	rst_out_ev, ck_ev = CreateEvents(["rst_out", "ck_ev"])

	# Initialization
	# Mostly you only need to change the size of Stacker
	scb = Scoreboard("ISE")
	test = scb.GetTest(f"Top")
	st = Stacker(N_IMG, callbacks=[test.Get])
	bg = BusGetter(callbacks=[st.Get])
	# Construct master (driver) and slave (monitor) and
	# connect slave to the scoreboard.
	# Choose to use OneWire or TwoWire accordingly.
	# TODO
	# NOTE: Construct your master with A=1, B=1 to send data in every cycle.

	# Extract the data bus of master
	# For creating the iterator (see Iter() below) easily.
	# TODO

	# Check the data at slave.
	# This create a tuple of two column vectors of size 16.
	# tag, type
	# TODO

	# Start simulation
	# Wait 1 extra cycle after reset
	yield rst_out_ev
	yield ck_ev

	# Then send to the DUT.
	# NOTE: DO NOT set latency.
	# Use an iterator to set the mdata construted above.

	# Wait 100 cycles and Finish
	for i in range(100):
		yield ck_ev
	assert st.is_clean
	FinishSim()

RegisterCoroutines([
	main(),
])
