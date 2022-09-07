#![no_std]
#![no_main]
#![allow(unreachable_code)]
#![allow(clippy::empty_loop)]

use core::panic::PanicInfo;
use core::arch::asm;

// To ensure this __main is located at 0x00000000,
// any functions must not be imported from extern packages and
// this __main is on top of this file.
#[no_mangle]
extern "C" fn __main() -> ! {
    let x = identity(1);
    let y = identity(2);
    let mut z = x + y;
    if z == 1 {
        z += 1;
    } else {
        z += 2;
    }
    unsafe {
        asm!("unimp");
    }

    let _ = identity(z);
    loop {}
}

/// Same as [`core::convert::identity`]
const fn identity<T>(value: T) -> T {
    value
}

#[panic_handler]
#[no_mangle]
fn panic(_: &PanicInfo) -> ! {
    loop {}
}