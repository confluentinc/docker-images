NAME=zookeeper
VERSION=1.0
RELEASE:=$(shell date -u +%Y%m%d%H%M)
BUILDDIR=.build

all: rpm

clean:
	rm -rf *.rpm ${BUILDDIR}

rpm:
	docker pull mickep76/centos-golang:latest
	docker run --rm -it -v "$$PWD":/build -w /build mickep76/centos-golang:latest make build-rpm

build-rpm:
	mkdir -p ${BUILDDIR}/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
	cp -r ${NAME}.sysconfig ${NAME}.systemd ${BUILDDIR}/SOURCES
	sed -e "s/%NAME%/${NAME}/g" -e "s/%VERSION%/${VERSION}/g" -e "s/%RELEASE%/${RELEASE}/g" \
		generic.spec >${BUILDDIR}/SPECS/${NAME}.spec
	rpmbuild -vv -bb --target="x86_64" --clean --define "_topdir $$(pwd)/${BUILDDIR}" ${BUILDDIR}/SPECS/${NAME}.spec
	mv ${BUILDDIR}/RPMS/x86_64/*.rpm .
