INCFILS = g_raph.h wavhdr.h sndhdr.h macro.h byteorder.h
OBJFILS = plotseg.o wavhdr.o sndhdr.o byteorder.o fft2.o
GLIB = g_raph.a
CCL = cc -m32 -o
autocor: autocor.c $(INCFILS) $(OBJFILS) $(GLIB)
		$(CCL) autocor autocor.c $(OBJFILS) $(GLIB) -lm

# testfft2: testfft2.c fft2.o
# 		cc -m32 -o testfft2 testfft2.c fft2.o -lm
