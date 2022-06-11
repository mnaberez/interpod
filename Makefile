# Requirements:
#  - ACME (https://www.mirrorservice.org/sites/ftp.cs.vu.nl/pub/minix/distfiles/backup/acme091src.tar.gz)

# default build target
all: interpod-1.6.bin diff

# assemble the source to a 2K binary
interpod-1.6.bin: interpod-1.6.asm
	acme -r interpod-1.6.lst -o interpod-1.6.bin interpod-1.6.asm

# show the assembler listing file
list: interpod-1.6.bin
	cat interpod-1.6.lst

# compare the assembled binary against the original binary
# "sp2516.bin" dumped by Chuck Hutchins
diff: interpod-1.6.bin
	echo "7659c45b73f577233f7657c4da9141dcfe8b6d97" > original.sha1
	openssl sha1 interpod-1.6.bin | cut -d ' ' -f 2 > interpod-1.6.sha1

# remove all build artifacts
clean:
	rm -f *.bin *.lst *.sha1
