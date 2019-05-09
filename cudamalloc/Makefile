CC=nvcc
CFLAGS=

all: cudamalloc.exe  unifiedmalloc.exe

%.exe: %.cu
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -f *.exe
