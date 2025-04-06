import platform

def get_machine_specs():
  specs = {
    'HOST': platform.node(),
    'OS_RELEASE': platform.freedesktop_os_release()['PRETTY_NAME'],
    'GLIBC_VER': platform.libc_ver()[1]
  }
  return specs
