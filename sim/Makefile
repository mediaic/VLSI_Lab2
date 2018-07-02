NICOTB=/opt/nicotb/lib
IRUN=irun
VFLAG=$(if $(USE_VERILOG),"+define+OLD_VERILOG_STYLE","")\

top:
	make COVERAGE=$(COV) ARGS="$(VFLAG)" Top

counter:
	make COVERAGE=$(COV) ARGS="$(VFLAG)" Counter

sorter:
	make COVERAGE=$(COV) ARGS="$(VFLAG)" Sorter

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
	+incdir+../design/ \
	+incdir+../include/ \
	$(if $(COVERAGE),-covoverwrite -coverage block -covtest $(TOP) -covdut $(TOP),) \
	$(ARGS) $(NICOTB)/verilog/Utils.sv $<

$(NICOTB)/cpp/nicotb.so:
	make -C $(NICOTB)/cpp/

clean:
	-rm -rf ncsim* novas* irun* *.rc scoreboard.db __pycache__ INCA_libs
