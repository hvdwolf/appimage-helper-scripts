#! /bin/bash

# Bundle the python runtime
PYTHON_PREFIX=$(pkg-config --variable=prefix python)
PYTHON_LIBDIR=$(pkg-config --variable=libdir python)
PYTHON_VERSION=$(pkg-config --modversion python)
if [ x"${PYTHON_PREFIX}" = "x" ]; then
	echo "Could not determine PYTHON installation prefix, exiting."
	exit 1
fi
if [ x"${PYTHON_LIBDIR}" = "x" ]; then
	echo "Could not determine PYTHON library path, exiting."
	exit 1
fi
if [ x"${PYTHON_VERSION}" = "x" ]; then
	echo "Could not determine PYTHON version, exiting."
	exit 1
fi
cp -a "${PYTHON_PREFIX}/bin"/python* "$APPDIR/usr/bin" || exit 1
rm -rf "$APPDIR/usr/lib/python${PYTHON_VERSION}"
mkdir -p "$APPDIR/usr/lib"
cp -a "${PYTHON_LIBDIR}/python${PYTHON_VERSION}" "$APPDIR/usr/lib" || exit 1
PYGLIB_LIBDIR=$(pkg-config --variable=libdir pygobject-2.0)
if [ x"${PYGLIB_LIBDIR}" != "x" ]; then
	cp -a "${PYGLIB_LIBDIR}"/libpyglib*.so* "$APPDIR/usr/lib"
else
	echo "Could not determine PYGOBJECT-2.0 library path."
fi
(cd "$APPDIR/usr" && mkdir -p lib64 && cd lib64 && rm -rf python${PYTHON_VERSION} && ln -s ../lib/python${PYTHON_VERSION} .) || exit 1
ls -l "$APPDIR/usr/lib64"



gssapilib=$(ldconfig -p | grep 'libgssapi_krb5.so.2 (libc6,x86-64)'| awk 'NR==1{print $NF}')
if [ x"$gssapilib" != "x" ]; then
	gssapilibdir=$(dirname "$gssapilib")
	cp -a "$gssapilibdir"/libgssapi_krb5*.so* "$APPDIR/usr/lib"
fi

