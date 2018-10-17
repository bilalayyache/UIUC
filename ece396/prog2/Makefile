INCFILS = g_raph.h wavhdr.h sndhdr.h macro.h byteorder.h
OBJFILS = plotseg.o wavhdr.o sndhdr.o byteorder.o
GLIB = g_raph.a
CCL = cc -m32 -o
plotsnd: plotsnd.c $(INCFILS) $(OBJFILS) $(GLIB)
		$(CCL) plotsnd plotsnd.c $(OBJFILS) $(GLIB) -lm
