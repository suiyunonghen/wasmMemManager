//wasm每次grow都是按照页数增加内存，一页是64KB
//const PAGE_MEMORY = 65536
///|
pub struct Memory {
  offset : Int
  length : Int
} derive(Show)

///|
pub fn Memory::readInt32(self : Memory, pos : Int) -> Int? {
  if pos + 4 < self.length {
    Some(load32(pos + self.offset))
  } else {
    None
  }
}

///|
pub fn Memory::readInt32_unsafe(self : Memory, pos : Int) -> Int {
  load32(pos + self.offset)
}

///|
pub fn Memory::readUInt32(self : Memory, pos : Int) -> UInt? {
  if pos + 4 < self.length {
    Some(load32_u(pos + self.offset))
  } else {
    None
  }
}

///|
pub fn Memory::readUInt32_unsafe(self : Memory, pos : Int) -> UInt {
  load32_u(pos + self.offset)
}

///|
pub fn Memory::readByte(self : Memory, pos : Int) -> Byte? {
  if pos + 1 < self.length {
    Some(load8_u(pos + self.offset).to_byte())
  } else {
    None
  }
}

///|
pub fn Memory::readByte_unsafe(self : Memory, pos : Int) -> Byte {
  load8_u(pos + self.offset).to_byte()
}

///|
pub fn Memory::read8s(self : Memory, pos : Int) -> Int? {
  if pos + 1 < self.length {
    Some(load8_s(pos + self.offset))
  } else {
    None
  }
}

///|
pub fn Memory::read8s_unsafe(self : Memory, pos : Int) -> Int {
  load8_s(pos + self.offset)
}

///|
pub fn Memory::readU16(self : Memory, pos : Int) -> Int? {
  if pos + 2 < self.length {
    Some(load16_u(pos + self.offset))
  } else {
    None
  }
}

///|
pub fn Memory::readU16_unsafe(self : Memory, pos : Int) -> Int {
  load16_u(pos + self.offset)
}

///|
pub fn Memory::read16(self : Memory, pos : Int) -> Int? {
  if pos + 2 < self.length {
    Some(load16_s(pos + self.offset))
  } else {
    None
  }
}

///|
pub fn Memory::read16_unsafe(self : Memory, pos : Int) -> Int {
  load16_s(pos + self.offset)
}

///|
pub fn Memory::fill(
  self : Memory,
  pos : Int,
  len : Int,
  fillData : Int
) -> Unit {
  let mut writeLen = self.length - pos
  if len < writeLen {
    writeLen = len
  }
  if writeLen == 0 {
    return
  }
  memory_fill_ffi(self.offset + pos, fillData, writeLen)
}

///|
pub fn Memory::fill_unsafe(
  self : Memory,
  pos : Int,
  len : Int,
  fillData : Int
) -> Unit {
  memory_fill_ffi(self.offset + pos, fillData, len)
}

///|
pub fn Memory::moveData(
  self : Memory,
  destPos : Int,
  srcPos : Int,
  copyLen : Int
) -> Unit {
  if srcPos == destPos {
    return
  }
  let wlen = self.length - destPos
  let mut rlen = self.length - srcPos
  if rlen > copyLen {
    rlen = copyLen
  }
  if wlen < rlen {
    rlen = wlen
  }
  memory_copy_ffi(self.offset + destPos, self.offset + srcPos, rlen)
}

///|
pub fn Memory::move_unsafe(
  self : Memory,
  destPos : Int,
  srcPos : Int,
  copyLen : Int
) -> Unit {
  memory_copy_ffi(self.offset + destPos, self.offset + srcPos, copyLen)
}

///|
pub fn Memory::copyFrom(
  self : Memory,
  destPos : Int,
  src : Memory,
  srcPos : Int,
  len : Int
) -> Unit {
  if self.offset == src.offset {
    return
  }
  let wlen = self.length - destPos
  let mut rlen = src.length - srcPos
  if rlen > len {
    rlen = len
  }
  if wlen < rlen {
    rlen = wlen
  }
  memory_copy_ffi(self.offset + destPos, src.offset + srcPos, rlen)
}

///|
pub fn Memory::copyFrom_unsafe(
  self : Memory,
  destPos : Int,
  src : Memory,
  srcPos : Int,
  len : Int
) -> Unit {
  memory_copy_ffi(self.offset + destPos, src.offset + srcPos, len)
}

///|
pub fn Memory::readDouble(self : Memory, pos : Int) -> Double? {
  if pos + 8 < self.length {
    Some(loadf64(pos + self.offset))
  } else {
    None
  }
}

///|
pub fn Memory::readDouble_unsafe(self : Memory, pos : Int) -> Double {
  loadf64(pos + self.offset)
}

///|
pub fn Memory::readInt64(self : Memory, pos : Int) -> Int64? {
  if pos + 8 < self.length {
    Some(load64(pos + self.offset))
  } else {
    None
  }
}

///|
pub fn Memory::readInt64_unsafe(self : Memory, pos : Int) -> Int64 {
  load64(pos + self.offset)
}

///|
pub fn Memory::readFloat(self : Memory, pos : Int) -> Float? {
  if pos + 4 < self.length {
    Some(loadf32(pos + self.offset))
  } else {
    None
  }
}

///|
pub fn Memory::readFloat_unsafe(self : Memory, pos : Int) -> Float {
  loadf32(pos + self.offset)
}

///|
pub fn Memory::writeInt(self : Memory, pos : Int, value : Int) -> Bool {
  if pos + 4 < self.length {
    store32(pos + self.offset, value)
    true
  } else {
    false
  }
}

///|
pub fn Memory::writeInt_unsafe(self : Memory, pos : Int, value : Int) -> Unit {
  store32(pos + self.offset, value)
}

///|
pub fn Memory::writeFloat(self : Memory, pos : Int, value : Float) -> Bool {
  if pos + 4 < self.length {
    storef32(pos + self.offset, value)
    true
  } else {
    false
  }
}

///|
pub fn Memory::writeFloat_unsafe(
  self : Memory,
  pos : Int,
  value : Float
) -> Unit {
  storef32(pos + self.offset, value)
}

///|
pub fn Memory::writeInt64(self : Memory, pos : Int, value : Int64) -> Bool {
  if pos + 8 < self.length {
    store64(pos + self.offset, value)
    true
  } else {
    false
  }
}

///|
pub fn Memory::writeInt64_unsafe(
  self : Memory,
  pos : Int,
  value : Int64
) -> Unit {
  store64(pos + self.offset, value)
}

///|
pub fn Memory::writeDouble(self : Memory, pos : Int, value : Double) -> Bool {
  if pos + 8 < self.length {
    storef64(pos + self.offset, value)
    true
  } else {
    false
  }
}

///|
pub fn Memory::writeDouble_unsafe(
  self : Memory,
  pos : Int,
  value : Double
) -> Unit {
  storef64(pos + self.offset, value)
}

///|
pub fn Memory::writeU16(self : Memory, pos : Int, value : Int) -> Bool {
  if pos + 2 < self.length {
    store16(pos + self.offset, value)
    true
  } else {
    false
  }
}

///|
pub fn Memory::writeU16_unsafe(self : Memory, pos : Int, value : Int) -> Unit {
  store16(pos + self.offset, value)
}

///|
pub fn Memory::writeByte(self : Memory, pos : Int, value : Int) -> Bool {
  if pos + 1 < self.length {
    store8(pos + self.offset, value)
    true
  } else {
    false
  }
}

///|
pub fn Memory::writeByte_unsafe(self : Memory, pos : Int, value : Int) -> Unit {
  store8(pos + self.offset, value)
}

///|
pub fn Memory::writeString(self : Memory, pos : Int, value : String) -> Unit {
  let mut canwrite = self.length - pos
  let mut start = self.offset + pos
  for char in value {
    if canwrite > 2 {
      store16(start, char.to_int())
      canwrite = canwrite - 2
      start = start + 2
    } else {
      return
    }
  }
}

///|
pub fn Memory::readString(self : Memory, pos : Int, strLen : Int) -> String {
  let mut canread = self.length - pos
  let strLen = strLen << 1
  if canread > strLen {
    canread = strLen
  }
  canread = canread >> 1
  let mut pos = pos + self.offset
  let arr : Array[Char] = Array::make(canread, Char::from_int(load16_u(pos)))
  for i in 1..<canread {
    pos += 2
    arr[i] = Char::from_int(load16_u(pos))
  }
  String::from_array(arr)
}

///|
priv struct MemoryManager {
  usedOffset : Set[Int]
  unUsedChunk : @sorted_map.T[Int, Array[Int]] //length->Array[offset]
  unUsedOffset : @sorted_map.T[Int, Int] //offset->length
  mut tailMem : Memory
} derive(Show)

///|
fn removeUnUsedChunk(
  self : MemoryManager,
  chunkSize : Int,
  offsets : Array[Int]
) -> Unit {
  match self.unUsedChunk.get(chunkSize) {
    Some(arr) => {
      if offsets.length() == 0 {
        self.unUsedChunk.remove(chunkSize)
        return
      }
      for idx, v in arr {
        for i, offset in offsets {
          if v == offset {
            let _ = offsets.remove(i)
            let _ = arr.remove(idx)
            if arr.length() == 0 {
              self.unUsedChunk.remove(chunkSize)
            }
            break
          }
        }
        if offsets.length() == 0 {
          break
        }
      }
    }
    _ => ()
  }
}

///|
fn freeMergeNextChunk(self : MemoryManager, mem : Memory) -> Unit {
  for offset, size in memManager.unUsedOffset {
    if offset > mem.offset {
      if mem.offset + mem.length == offset {
        memManager.removeUnUsedChunk(size, [offset])
        memManager.unUsedOffset.remove(offset)
        let newSize = mem.length + size
        memManager.unUsedOffset.add(mem.offset, newSize)
        match memManager.unUsedChunk.get(newSize) {
          Some(arr) => arr.push(mem.offset)
          None => memManager.unUsedChunk.add(newSize, [mem.offset])
        }
        return
      }
      break
    }
  }
  self.unUsedOffset.add(mem.offset, mem.length)
  match self.unUsedChunk.get(mem.length) {
    Some(arr) => arr.push(mem.offset)
    _ => self.unUsedChunk.add(mem.length, [mem.offset])
  }
}

///|
let memManager : MemoryManager = {
  usedOffset: Set::new(),
  unUsedChunk: @sorted_map.new(),
  unUsedOffset: @sorted_map.new(),
  tailMem: { offset: 0, length: 0 },
}

///|
pub fn getMemory(size : Int) -> Memory {
  let mut endUnUsedMemory : Memory = { offset: -1, length: 0 }
  for chunkLen, chunkOffsetArray in memManager.unUsedChunk {
    if chunkLen - size >= 0 && chunkLen - size <= 4 {
      match chunkOffsetArray.pop() {
        Some(chunkOffset) => {
          if chunkOffsetArray.length() == 0 {
            memManager.unUsedChunk.remove(chunkLen)
          }
          memManager.unUsedOffset.remove(chunkOffset)
          memManager.removeUnUsedChunk(chunkLen, [chunkOffset])
          memManager.usedOffset.add(chunkOffset)
          return { offset: chunkOffset, length: chunkLen }
        }
        None => memManager.unUsedChunk.remove(chunkLen)
      }
    } else if chunkLen > size {
      match chunkOffsetArray.pop() {
        Some(chunkOffset) => {
          let newOffset = chunkOffset + size
          let newSize = chunkLen - size
          if chunkOffsetArray.length() == 0 {
            memManager.unUsedChunk.remove(chunkLen)
          }
          memManager.unUsedOffset.remove(chunkOffset)
          memManager.unUsedOffset.add(newOffset, newSize)
          memManager.usedOffset.add(chunkOffset)
          match memManager.unUsedChunk.get(newSize) {
            Some(arr) => arr.push(newOffset)
            None => memManager.unUsedChunk.add(newSize, [newOffset])
          }
          return { offset: chunkOffset, length: size }
        }
        None => memManager.unUsedChunk.remove(chunkLen)
      }
    } else {
      //不够，然后查找到一个最后一个偏移
      for voffset in chunkOffsetArray {
        if voffset > endUnUsedMemory.offset {
          endUnUsedMemory = { offset: voffset, length: chunkLen }
        }
      }
    }
  }
  //没有找到，需要分配内存
  let memPages = memory_size_ffi()
  let memSize = memPages << 16 //目前的内存容量    
  let mut wantMemSize = memManager.tailMem.offset +
    memManager.tailMem.length +
    size
  if wantMemSize > memSize {
    //不够看看需要增加多少
    wantMemSize = wantMemSize - memSize
    if memory_grow_ffi((wantMemSize >> 16) + 1) == -1 {
      //分配失败了
      return { offset: -1, length: 0 }
    }
  }
  //看一下未使用的块中是否有最后一个块
  let endOffset = memManager.tailMem.offset + memManager.tailMem.length
  if endUnUsedMemory.offset + endUnUsedMemory.length == endOffset {
    memManager.tailMem = {
      offset: endOffset,
      length: size - endUnUsedMemory.length,
    }
    memManager.removeUnUsedChunk(endUnUsedMemory.length, [
      endUnUsedMemory.offset,
    ])
    memManager.unUsedOffset.remove(endUnUsedMemory.offset)
    memManager.usedOffset.add(endUnUsedMemory.offset)
    { offset: endUnUsedMemory.offset, length: size }
  } else {
    memManager.tailMem = { offset: endOffset, length: size }
    memManager.usedOffset.add(memManager.tailMem.offset)
    memManager.tailMem
  }
}

///|
pub fn freeMemory(mem : Memory) -> Unit {
  if memManager.usedOffset.remove_and_check(mem.offset) {
    //然后回收到未使用中去        
    let mut lastunUsed : Memory = { offset: -1, length: 0 }
    for offset, size in memManager.unUsedOffset {
      if offset > mem.offset {
        //第一个大于的，判定一下是否需要合并
        if lastunUsed.offset + lastunUsed.length == mem.offset {
          //这个可以和上一个合并，然后还要判定一下，是否能和当前这个合并
          let newSize = if mem.offset + mem.length == offset {
            //三个一起合并
            memManager.unUsedOffset.remove(offset)
            if lastunUsed.length == size {
              memManager.removeUnUsedChunk(size, [lastunUsed.offset, offset])
            } else {
              memManager.removeUnUsedChunk(lastunUsed.length, [
                lastunUsed.offset,
              ])
              memManager.removeUnUsedChunk(size, [offset])
            }
            lastunUsed.length + mem.length + size
          } else {
            //和上一个合并                        
            memManager.removeUnUsedChunk(lastunUsed.length, [lastunUsed.offset])
            lastunUsed.length + mem.length
          }
          memManager.unUsedOffset.add(lastunUsed.offset, newSize)
          match memManager.unUsedChunk.get(newSize) {
            Some(arr) => arr.push(lastunUsed.offset)
            None => memManager.unUsedChunk.add(newSize, [lastunUsed.offset])
          }
        } else if mem.offset + mem.length == offset {
          //和当前的合并
          memManager.removeUnUsedChunk(size, [offset])
          memManager.unUsedOffset.remove(offset)
          let newSize = mem.length + size
          memManager.unUsedOffset.add(mem.offset, newSize)
          match memManager.unUsedChunk.get(newSize) {
            Some(arr) => arr.push(mem.offset)
            None => memManager.unUsedChunk.add(newSize, [mem.offset])
          }
        } else {
          //不合并                    
          match memManager.unUsedChunk.get(mem.length) {
            Some(arr) => arr.push(mem.offset)
            None => memManager.unUsedChunk.add(mem.length, [mem.offset])
          }
          memManager.unUsedOffset.add(mem.offset, mem.length)
        }
        return
      } else {
        lastunUsed = { offset, length: size }
      }
    }
    //插入进来的是最大的一个，判定一下是否需要跟上一个合并
    if lastunUsed.offset + lastunUsed.length == mem.offset {
      //要合并
      memManager.removeUnUsedChunk(lastunUsed.length, [lastunUsed.offset])
      let newSize = lastunUsed.length + mem.length
      memManager.unUsedOffset.add(lastunUsed.offset, newSize)
      match memManager.unUsedChunk.get(newSize) {
        Some(arr) => arr.push(lastunUsed.offset)
        None => memManager.unUsedChunk.add(newSize, [lastunUsed.offset])
      }
    } else {
      //不合并
      match memManager.unUsedChunk.get(mem.length) {
        Some(arr) => arr.push(mem.offset)
        None => memManager.unUsedChunk.add(mem.length, [mem.offset])
      }
      memManager.unUsedOffset.add(mem.offset, mem.length)
    }
  }
}

///|
pub fn realloc(mem : Memory, newSize : Int) -> Memory {
  if newSize <= mem.length {
    return mem
  }
  if mem.offset + mem.length ==
    memManager.tailMem.offset + memManager.tailMem.length {
    //当前要扩容的本来就是最后一个内存块，直接扩容最后一个
    let memPages = memory_size_ffi()
    let memSize = memPages << 16 //目前的内存容量
    let boundSize = mem.offset + newSize
    let delta = newSize - mem.length
    if boundSize > memSize {
      //不够，需要扩容一下
      if memory_grow_ffi((delta >> 16) + 1) == -1 {
        //扩容失败
        return { offset: -1, length: 0 }
      }
    }
    memManager.tailMem = {
      offset: memManager.tailMem.offset,
      length: memManager.tailMem.length + delta,
    }
    return { offset: mem.offset, length: newSize }
  }
  //看看这个块周边是否还有未使用的内存块，如果有，就直接合并到这个上面来
  let matchMems : @sorted_map.T[Int, Int] = @sorted_map.new()
  let mut lastunUsed : Memory = { offset: -1, length: 0 }
  for offset, size in memManager.unUsedOffset {
    if offset > mem.offset {
      if mem.offset + mem.length == offset {
        //后面有一个空白的项目且空间足够                
        let mut mergeSize = size + mem.length
        if mergeSize >= newSize {
          memManager.unUsedOffset.remove(offset)
          memManager.removeUnUsedChunk(size, [offset])
          let leftSize = mergeSize - newSize
          if leftSize > 0 {
            let newOffset = mem.offset + newSize
            memManager.unUsedOffset.add(newOffset, leftSize)
            match memManager.unUsedChunk.get(leftSize) {
              Some(arr) => arr.push(newOffset)
              None => memManager.unUsedChunk.add(leftSize, [newOffset])
            }
          }
          return { offset: mem.offset, length: newSize }
        } else if lastunUsed.offset + lastunUsed.length == mem.offset {
          //空间不够，要看看跟前一个是否一致                    
          mergeSize = size + mem.length + lastunUsed.length
          if mergeSize >= newSize {
            //合并在一起
            memManager.usedOffset.remove(mem.offset)
            if lastunUsed.length == size {
              memManager.removeUnUsedChunk(size, [lastunUsed.offset, offset])
            } else {
              memManager.removeUnUsedChunk(lastunUsed.length, [
                lastunUsed.offset,
              ])
              memManager.removeUnUsedChunk(size, [offset])
            }
            memManager.unUsedOffset.remove(lastunUsed.offset)
            memManager.unUsedOffset.remove(offset)
            memManager.usedOffset.add(lastunUsed.offset)
            let result = { offset: lastunUsed.offset, length: newSize }
            result.copyFrom_unsafe(0, mem, 0, mem.length)
            let leftSize = mergeSize - newSize
            if leftSize > 0 {
              let newOffset = result.offset + newSize
              memManager.unUsedOffset.add(newOffset, leftSize)
              match memManager.unUsedChunk.get(leftSize) {
                Some(arr) => arr.push(newOffset)
                None => memManager.unUsedChunk.add(leftSize, [newOffset])
              }
            }
            return result
          }
        }
      }
    } else {
      if size >= newSize {
        matchMems.add(size, offset)
      }
      lastunUsed = { offset, length: size }
    }
  }
  //使用一个最匹配的
  for machSize, matchOffset in matchMems {
    memManager.removeUnUsedChunk(machSize, [matchOffset])
    memManager.unUsedOffset.remove(matchOffset)
    let result = { offset: matchOffset, length: newSize }
    let unAllocSize = machSize - newSize //没有分配的
    let unAllocOffset = matchOffset + newSize
    memManager.unUsedOffset.add(unAllocOffset, unAllocSize)
    match memManager.unUsedChunk.get(unAllocSize) {
      Some(arr) => arr.push(unAllocOffset)
      None => memManager.unUsedChunk.add(unAllocSize, [unAllocOffset])
    }
    result.copyFrom_unsafe(0, mem, 0, mem.length)
    freeMemory(mem)
    return result
  }
  //没有匹配的，需要分配一个
  let result = getMemory(newSize)
  result.copyFrom_unsafe(0, mem, 0, mem.length)
  freeMemory(mem)
  result
}

///|
test "mem" {
  let mem1 = getMemory(48)
  let mem2 = getMemory(12)
  let mem3 = getMemory(30)
  assert_eq!(mem1.offset == 0 && mem1.length == 48, true)
  assert_eq!(mem2.offset == 48 && mem2.length == 12, true)
  assert_eq!(mem3.offset == 60 && mem3.length == 30, true)
  assert_eq!(memManager.usedOffset.contains(0), true)
  assert_eq!(memManager.usedOffset.contains(48), true)
  assert_eq!(memManager.usedOffset.contains(60), true)
  freeMemory(mem1)
  assert_eq!(memManager.unUsedOffset[0] == Some(48), true)
  assert_eq!(memManager.unUsedChunk[48].unwrap().contains(0), true)
  freeMemory(mem3)
  assert_eq!(
    memManager.unUsedOffset[0] == Some(48) &&
    memManager.unUsedOffset[60] == Some(30),
    true,
  )
  assert_eq!(memManager.unUsedChunk[48].unwrap().contains(0), true)
  assert_eq!(memManager.unUsedChunk[30].unwrap().contains(60), true)
  mem2.writeString(3, "不得闲")
  let mem2 = realloc(mem2, 48)
  assert_eq!(mem2.readString(3, 3), "不得闲")
  freeMemory(mem2)
  assert_eq!(
    memManager.unUsedOffset[0] == Some(90) &&
    memManager.unUsedOffset[60] == None,
    true,
  )
  assert_eq!(memManager.usedOffset.is_empty(), true)
}
