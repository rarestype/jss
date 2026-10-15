#include "JavaScriptBusywait.h"

#if __has_include(<wasi/libc-busywait.h>)
#include <wasi/libc-busywait.h>
#elif defined(__wasi__) && defined(__wasm_atomics__)
// without this switch, Chrome kills the module whenever the main thread contends for a lock, so
// a threads SDK that lacks it should fail to build rather than silently lose the protection
#error "the threads SDK’s wasi-libc no longer provides <wasi/libc-busywait.h>"
#endif

void jss_enable_futex_busywait_on_current_thread(void) {
#if __has_include(<wasi/libc-busywait.h>)
    __wasilibc_enable_futex_busywait_on_current_thread();
#endif
}
