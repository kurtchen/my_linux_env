# Makefile for twmrc
# $Fuller: myprograms/twmrc/Makefile,v 1.8 2002/07/08 08:24:12 fullermd Exp $

DESTDIR = ${HOME}/.twm

FILES = bindings bindings.ctwm functions iconmgrs menus.hash \
		menus.pl vars vars.ctwm

install:
	mkdir -p -m 700 ${DESTDIR}
	install -c -m 644 ${FILES} ${DESTDIR}
	chmod 755 ${DESTDIR}/menus.pl
	install -c -m 644 xMakefile ${DESTDIR}/Makefile

diffs:
	-@for file in ${FILES}; do \
		echo ===\> $${file}; \
		diff -u $${file} ${DESTDIR}/$${file}; \
		echo \<===; \
	done
