#ifndef JAVASCRIPT_BUSYWAIT_H
#define JAVASCRIPT_BUSYWAIT_H

/// Makes contended locks on the current thread spin instead of executing
/// `memory.atomic.wait32`, which browsers forbid on the main thread. This only
/// covers locks that go through wasi-libc, such as `pthread_mutex_lock`. It does
/// nothing outside of `wasm32-wasip1-threads`.
void jss_enable_futex_busywait_on_current_thread(void);

#endif
