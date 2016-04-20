helloworld:file1.o file2.o
	gcc file1.o file2.o -o helloworld

file1.o:dir1/file1.c include/file2.h
	cd dir1; gcc -c file1.c -o ../file1.o

file2.o:dir2/file2.c include/file2.h
	cd dir2; gcc -c file2.c -o ../file2.o

clean:
	rm -rf *.o helloworld
