from nicotb import *
from nicotb.utils import Scoreboard, BusGetter, Stacker
from nicotb.protocol import OneWire, TwoWire
from itertools import repeat
import MyModel as M
import numpy as np

def main():
	# Calculate answer
	features = M.ComputeImages(M.LoadImages())
	features_np = np.array(features, dtype=np.int32)
	answer = np.array(M.SortFeatures(features), dtype=np.int32)
	N_IMG = 16

	# Connect to Verilog
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
	rst_out_ev, ck_ev = CreateEvents(["rst_out", "ck_ev"])

	# Initialization
	scb = Scoreboard("ISE")
	test = scb.GetTest(f"Sorter")
	st = Stacker(N_IMG, callbacks=[test.Get])
	bg = BusGetter(callbacks=[st.Get])
	master = OneWire.Master(ivalid, idata, ck_ev)
	slave = OneWire.Slave(ovalid, odata, ck_ev, callbacks=[bg.Get])
	mdata = master.values
	test.Expect((answer[:,1,np.newaxis], answer[:,0,np.newaxis]))

	# start simulation
	yield rst_out_ev
	yield ck_ev

	def Iter():
		for i in range(N_IMG):
			mdata.img_tag[0] = features_np[i,4]
			mdata.img_type[0] = features_np[i,0]
			mdata.img_num[0] = features_np[i,2]
			mdata.img_sum[0] = features_np[i,3]
			yield mdata
	yield from master.SendIter(Iter(), latency=50)

	for i in range(100):
		yield ck_ev
	assert st.is_clean
	FinishSim()

RegisterCoroutines([
	main(),
])
