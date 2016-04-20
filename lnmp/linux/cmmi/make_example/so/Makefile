all: libtest.so hello.exe test.exe


hello.exe: test.c test_a.c
	@ sadly,I have not the glibc-static.
#	gcc -c test_a.c -o test_a.o
#	ar -crv libhelloa.a test_a.o
#	gcc -c test_b.c -o test_b.o
#	ar -crv libhellob.a test_b.o
#	gcc -c test_c.c -o test_c.o
#	ar -crv libhelloc.a test_c.o
#	gcc -o hello.exe test.c -static -L. -lhelloa -lhellob -lhelloc

libtest.so: test_a.c test_b.c test_c.c
	gcc test_a.c test_b.c test_c.c -fPIC -shared -o libtest.so

test.exe: test.c
	gcc test.c -L. -ltest -o test.exe
	@echo $(LD_LIBRARY_PATH)
	@echo WHEN YOU TEST: \
		'export LD_LIBRARY_PATH=`pwd`:$LD_LIBRARY_PATH; ldd test.exe'

clean:
	-rm ./*.so ./*.exe ./*.a ./*.o
