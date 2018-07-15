NICOTB=/opt/nicotb/lib
TSMC13DIR=/opt/CAD/cell_lib/CBDK_IC_Contest_v2.1
IRUN=irun
ifdef SYN
VFLAG=+define+OLD_VERILOG_STYLE +define+SYN
TSMC13=$(TSMC13DIR)/Verilog/tsmc13.v
else
ifdef USE_VERILOG
VFLAG=+define+OLD_VERILOG_STYLE
endif
endif

top:
	make COVERAGE=$(COV) ARGS="$(VFLAG)" Rgb888ToYuv422

downsample:
	make COVERAGE=$(COV) ARGS="$(VFLAG)" Downsample

coeff_col:
	make COVERAGE=$(COV) ARGS="$(VFLAG)" CoeffCollect

rgb2yuv:
	make COVERAGE=$(COV) ARGS="$(VFLAG)" RgbToYuv

dump_scoreboard:
	@echo -e \
	".open scoreboard.db\n"\
	".header on\n"\
	".mode column\n"\
	".print ===============\n"\
	".print All Scoreboards\n"\
	".print ===============\n"\
	"select * from Scoreboard;\n"\
	".print\n"\
	".print =========\n"\
	".print All Tests\n"\
	".print =========\n"\
	"select * from Tests;\n"\
	 | sqlite3

%: %_test.sv $(NICOTB)/cpp/nicotb.so
	$(eval TOP=$(if $(TOPMODULE),$(TOPMODULE),$@)_test)
	GLOG_logtostderr=1 \
	GLOG_minloglevel=1 \
	TEST=$(if $(TEST),$(TEST),$@)_test \
	TOPMODULE=$(TOP) \
	PYTHONPATH=$(NICOTB)/python:. \
	$(IRUN) +access+rw -loadvpi $(NICOTB)/cpp/nicotb.so:VpiBoot \
	+nospecify +notimingchecks +delay_mode_unit \
	+incdir+../design/ \
	+incdir+../include/ \
	+incdir+../syn/ \
	$(if $(COVERAGE),-covoverwrite -coverage block -covtest $(TOP) -covdut $(TOP),) \
	$(ARGS) $(NICOTB)/verilog/Utils.sv $(TSMC13) $<

$(NICOTB)/cpp/nicotb.so:
	make -C $(NICOTB)/cpp/

clean:
	-rm -rf ncsim* novas* irun* *.rc scoreboard.db __pycache__ INCA_libs
