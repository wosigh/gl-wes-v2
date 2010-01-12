INSTALLDIR=/usr
BUILDDIR=build
SRC=src
EXDIR=examples
CC=gcc
CC_FLAGS=-DPOSIX -ldl -Iinclude
WESOBJ= \
	$(BUILDDIR)/wes.o						\
	$(BUILDDIR)/wes_begin.o			\
	$(BUILDDIR)/wes_fragment.o	\
	$(BUILDDIR)/wes_matrix.o		\
	$(BUILDDIR)/wes_shader.o		\
	$(BUILDDIR)/wes_state.o			\
	$(BUILDDIR)/wes_texture.o

default: makedirs lib

lib:	$(WESOBJ)
	$(CC) -shared $(CC_FLAGS) -o $(BUILDDIR)/libwesGL.so $(WESOBJ)

makedirs:
	@if [ ! -d $(BUILDDIR) ];then mkdir $(BUILDDIR);fi
	@if [ ! -d $(BUILDDIR)/examples ];then mkdir $(BUILDDIR)/examples;fi

$(BUILDDIR)/%.o:	$(SRC)/%.c
	$(CC) $(CC_FLAGS) -o $@ -c $<
	
test: makedirs $(EXDIR)/test.c
	$(CC) $(CC_FLAGS) -I/usr/local/include/SDL -lwesGL -L/usr/local/lib -Wl,-rpath,/usr/local/lib -lSDL -lpthread -o $(BUILDDIR)/examples/test $(EXDIR)/test.c
	cp -r $(EXDIR)/data $(BUILDDIR)/examples/.
	
install:
	cp $(BUILDDIR)/libwesGL.so $(INSTALLDIR)/lib/.
	@if [ ! -d $(INSTALLDIR)/include/wesGL ];then mkdir $(INSTALLDIR)/include/wesGL;fi
	cp include/*.h $(INSTALLDIR)/include/wesGL/.
	cp shader/*.vsh $(INSTALLDIR)/include/wesGL/.
	
clean:
	rm -fr $(BUILDDIR)
