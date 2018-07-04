from nicotb import *
from nicotb.utils import Scoreboard, BusGetter, Stacker
from nicotb.protocol import OneWire, TwoWire
from itertools import repeat
import MyModel as M
import numpy as np

def main():
	# Calculate answer.
	# This creates sorted and non-sorted features (answer and features_np).
	features = M.ComputeImages(M.LoadImages())
	features_np = np.array(features, dtype=np.int32)
	answer = np.array(M.SortFeatures(features), dtype=np.int32)
	N_IMG = 16

	# Connect to Verilog
	# Connect to the Verilog wire (please see the document)
	(
		ivalid, ovalid,
		idata, odata,
	) = CreateBuses([
		(("dut", "img_valid"),),
		(("dut", "o_valid"),),
		(
			("dut", "img_tag"),
			(None , "img_type"),
			(None , "img_num"),
			(None , "img_sum"),
		),
		(
			("dut", "o_tag"),
			(None , "o_type"),
		),
	])

	# Construct clock and reset event
	rst_out_ev, ck_ev = CreateEvents(["rst_out", "ck_ev"])

	# Initialization
	# Mostly you only need to change the size of Stacker
	scb = Scoreboard("ISE")
	test = scb.GetTest(f"Sorter")
	st = Stacker(N_IMG, callbacks=[test.Get])
	bg = BusGetter(callbacks=[st.Get])
	# Construct master (driver) and slave (monitor) and
	# connect slave to the scoreboard.
	master = OneWire.Master(ivalid, idata, ck_ev)
	slave = OneWire.Slave(ovalid, odata, ck_ev, callbacks=[bg.Get])
	# Extract the data bus of master
	# For creating the iterator (see Iter() below) easily.
	mdata = master.values
	# Check the data at slave.
	# This create a tuple of two column vectors of size 16.
	# The first one is o_tag, and the second one is o_type.
	test.Expect((answer[:,1,np.newaxis], answer[:,0,np.newaxis]))

	# Start simulation
	# Wait 1 extra cycle after reset
	yield rst_out_ev
	yield ck_ev

	# Then send to the DUT (every 50 cycles).
	# Use an iterator to set the mdata construted above.
	def Iter():
		for i in range(N_IMG):
			mdata.img_tag[0] = features_np[i,4]
			mdata.img_type[0] = features_np[i,0]
			mdata.img_num[0] = features_np[i,2]
			mdata.img_sum[0] = features_np[i,3]
			yield mdata
	yield from master.SendIter(Iter(), latency=50)

	# Wait 100 cycles and Finish
	for i in range(100):
		yield ck_ev
	assert st.is_clean
	FinishSim()

RegisterCoroutines([
	main(),
])
