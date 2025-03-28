///|
extern "wasm" fn load32(pos : Int) -> Int =
  #|(func (param $pos i32) (result i32) (i32.load (local.get $pos)))

///|
extern "wasm" fn load64(pos : Int) -> Int64 =
  #|(func (param $pos i32) (result i64) (i64.load (local.get $pos)))

///|
extern "wasm" fn loadf32(pos : Int) -> Float =
  #|(func (param $pos i32) (result f32) (f32.load (local.get $pos)))

///|
extern "wasm" fn loadf64(pos : Int) -> Double =
  #|(func (param $pos i32) (result f64) (f64.load (local.get $pos)))

///|
extern "wasm" fn load8_s(pos : Int) -> Int =
  #|(func (param $pos i32) (result i32) (i32.load8_s (local.get $pos)))

///|
extern "wasm" fn load8_u(pos : Int) -> Int =
  #|(func (param $pos i32) (result i32) (i32.load8_u (local.get $pos)))

///|
extern "wasm" fn load16_s(pos : Int) -> Int =
  #|(func (param $pos i32) (result i32) (i32.load16_s (local.get $pos)))

///|
extern "wasm" fn load16_u(pos : Int) -> Int =
  #|(func (param $pos i32) (result i32) (i32.load16_u (local.get $pos)))

// extern "wasm" fn load32_s(pos : Int) -> Int =
//   #|(func (param $pos i32) (result i32) (i64.load32_s (local.get $pos)))
///|
extern "wasm" fn load32_u(pos : Int) -> UInt =
  #|(func (param $pos i32) (result i32) (i64.load32_u (local.get $pos)))

///|
extern "wasm" fn store32(pos : Int, value : Int) =
  #|(func (param $pos i32) (param $value i32) (i32.store (local.get $pos) (local.get $value)))

///|
extern "wasm" fn store64(pos : Int, value : Int64) =
  #|(func (param $pos i32) (param $value i64) (i64.store (local.get $pos) (local.get $value)))

///|
extern "wasm" fn storef32(pos : Int, value : Float) =
  #|(func (param $pos i32) (param $value f32) (f32.store (local.get $pos) (local.get $value)))

///|
extern "wasm" fn storef64(pos : Int, value : Double) =
  #|(func (param $pos i32) (param $value f64) (f64.store (local.get $pos) (local.get $value)))

///|
extern "wasm" fn store8(pos : Int, value : Int) =
  #|(func (param $pos i32) (param $value i32) (i32.store8 (local.get $pos) (local.get $value)))

///|
extern "wasm" fn store16(pos : Int, value : Int) =
  #|(func (param $pos i32) (param $value i32) (i32.store16 (local.get $pos) (local.get $value)))

///|
extern "wasm" fn memory_size_ffi() -> Int =
  #|(func (result i32) (memory.size))

///|
extern "wasm" fn memory_grow_ffi(delta : Int) -> Int =
  #|(func (param $delta i32) (result i32) (memory.grow (local.get $delta)))

///|
extern "wasm" fn memory_copy_ffi(dest : Int, source : Int, len : Int) =
  #|(func (param $dest i32) (param $source i32) (param $len i32) (memory.copy (local.get $dest) (local.get $source) (local.get $len)))

///|
extern "wasm" fn memory_fill_ffi(pos : Int, value : Int, len : Int) =
  #|(func (param $pos i32) (param $value i32) (param $len i32) (memory.fill (local.get $pos) (local.get $value) (local.get $len)))
