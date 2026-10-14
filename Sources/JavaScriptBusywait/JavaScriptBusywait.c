#include "JavaScriptBusywait.h"

#if __has_include(<wasi/libc-busywait.h>)
#include <wasi/libc-busywait.h>
#endif

void jss_enable_futex_busywait_on_current_thread(void) {
#if __has_include(<wasi/libc-busywait.h>)
    __wasilibc_enable_futex_busywait_on_current_thread();
#endif
}
