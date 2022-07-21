set(_vendor_id)
set(_cpu_family)
set(_cpu_model)

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    file(READ "/proc/cpuinfo" _cpuinfo)
    string(REGEX REPLACE ".*vendor_id[ \t]*:[ \t]+([a-zA-Z0-9_-]+).*" "\\1" _vendor_id "${_cpuinfo}")
    string(REGEX REPLACE ".*cpu family[ \t]*:[ \t]+([a-zA-Z0-9_-]+).*" "\\1" _cpu_family "${_cpuinfo}")
    string(REGEX REPLACE ".*model[ \t]*:[ \t]+([a-zA-Z0-9_-]+).*" "\\1" _cpu_model "${_cpuinfo}")
    string(REGEX REPLACE ".*flags[ \t]*:[ \t]+([^\n]+).*" "\\1" _cpu_flags "${_cpuinfo}")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    exec_program("/usr/sbin/sysctl -n machdep.cpu.vendor machdep.cpu.model machdep.cpu.family machdep.cpu.features" OUTPUT_VARIABLE _sysctl_output_string)
    string(REPLACE "\n" ";" _sysctl_output ${_sysctl_output_string})
    list(GET _sysctl_output 0 _vendor_id)
    list(GET _sysctl_output 1 _cpu_model)
    list(GET _sysctl_output 2 _cpu_family)
    list(GET _sysctl_output 3 _cpu_flags)

    string(TOLOWER "${_cpu_flags}" _cpu_flags)
    string(REPLACE "." "_" _cpu_flags "${_cpu_flags}")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    get_filename_component(_vendor_id "[HKEY_LOCAL_MACHINE\\Hardware\\Description\\System\\CentralProcessor\\0;VendorIdentifier]" NAME CACHE)
    get_filename_component(_cpu_id "[HKEY_LOCAL_MACHINE\\Hardware\\Description\\System\\CentralProcessor\\0;Identifier]" NAME CACHE)
    mark_as_advanced(_vendor_id _cpu_id)
    string(REGEX REPLACE ".* Family ([0-9]+) .*" "\\1" _cpu_family "${_cpu_id}")
    string(REGEX REPLACE ".* Model ([0-9]+) .*" "\\1" _cpu_model "${_cpu_id}")
endif(CMAKE_SYSTEM_NAME STREQUAL "Linux")

if(_vendor_id STREQUAL "GenuineIntel")
    set(CPU_VENDOR "Intel")
elseif(_vendor_id STREQUAL "AuthenticAMD")
    set(CPU_VENDOR "AMD")
endif()