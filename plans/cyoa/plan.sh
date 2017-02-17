pkg_name=cyoa
pkg_origin=eeyun
pkg_version=0.0.1
pkg_source=http://some_source_url/releases/${pkg_name}-${pkg_version}.tar.gz
pkg_shasum=TODO
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="Some description."
pkg_license=('Apache-2.0')
pkg_bin_dirs=(bin)
pkg_build_deps=(core/make core/gcc core/virtualenv core/cacerts core/git)
pkg_deps=(core/glibc core/python2 core/postgresql/9.5.3)
pkg_exports=(
[port]=flask.port
)
pkg_exposes=(port)
pkg_svc_user=root
pkg_svc_group=root

do_download(){
    return 0
}
do_clean(){
    return 0
}
do_unpack(){
    return 0
}
do_verify(){
    return 0
}
do_prepare() {
    localedef -i en_US -f UTF-8 en_US.UTF-8
    export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    virtualenv "$pkg_prefix"
    source "$pkg_prefix/bin/activate"
}
do_strip(){
    return 0
}

do_build(){
	cp -vRap $PLAN_CONTEXT/../../source/. $HAB_CACHE_SRC_PATH/$pkg_dirname

    _runtime_python_path="$(pkg_path_for core/python2)"
    cat > ./cyoa/runtime_environment.sh <<ENVS
export PYTHON_PATH="${_runtime_python_path}"
ENVS

}

do_install(){
    pip install -r requirements.txt --prefix=${pkg_prefix}
    cp manage.py "${pkg_prefix}"
    cp -vr ./cyoa "${pkg_prefix}"/cyoa

    cd ${pkg_prefix}/lib/python2.7/site-packages/socketio
    sed -i.bak 's/-Max-Age", 3600/-Max-Age", "3600"/' handler.py
    sed -i.bak 's/-Max-Age", 3600/-Max-Age", "3600"/' transports.py
}
