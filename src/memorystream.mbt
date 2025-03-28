///|
struct MemoryStream {
  mut capacity : Int
  mut size : Int
  chunks : Array[Memory]
  mut dataPosition : Int
  mut currentChunk : Int
}

///|
pub fn MemoryStream::new() -> MemoryStream {
  {
    size: 0,
    capacity: 0,
    chunks: Array::new(),
    dataPosition: 0,
    currentChunk: 0,
  }
}

///|
pub fn MemoryStream::free(self : MemoryStream) -> Unit {
  for mem in self.chunks {
    freeMemory(mem)
  }
  self.chunks.clear()
  self.size = 0
  self.capacity = 0
  self.currentChunk = 0
}

///|
pub(all) enum SeekOrigin {
  SoBeginning
  SoCurrent
  SoEnd
}

///|
pub fn MemoryStream::setSize(self : MemoryStream, size : Int) -> Unit {
  if self.size < size {
    //扩容
    if self.capacity >= size {
      return
    }
    let mallocSize = size - (self.capacity - self.size)
    match self.chunks.pop() {
      Some(mem) =>
        if mem.length <= 128 ||
          mem.offset + mem.length ==
          memManager.tailMem.offset + memManager.tailMem.length {
          let chunk = realloc(mem, mallocSize + mem.length)
          if chunk.length > 0 {
            self.chunks.push(chunk)
            self.capacity += chunk.length - mallocSize
            self.size = size
          } else {
            self.chunks.push(mem)
          }
          return
        }
      None => ()
    }
    let chunk = getMemory(mallocSize)
    if chunk.length > 0 {
      self.chunks.push(chunk)
      self.capacity += chunk.length
      self.size = size
    }
  } else if self.size > size {
    let mut deltaSize = self.capacity - size
    if deltaSize > 32 {
      loop self.chunks.pop() {
        Some(mem) => {
          if mem.length <= deltaSize {
            deltaSize -= mem.length
            freeMemory(mem)
            if deltaSize == 0 {
              self.capacity = size
              self.size = size
              break
            }
            self.capacity -= mem.length
          } else {
            if deltaSize < 32 {
              self.size = size
            } else {
              let newMem : Memory = {
                offset: mem.offset,
                length: mem.length - deltaSize,
              }
              memManager.freeMergeNextChunk({
                offset: newMem.offset + newMem.length,
                length: deltaSize,
              })
              self.chunks.push(newMem)
              self.capacity = size
              self.size = size
            }
            break
          }
          continue self.chunks.pop()
        }
        None => {
          self.size = 0
          self.capacity = 0
          self.dataPosition = 0
          self.currentChunk = 0
          return
        }
      }
    }
    if self.currentChunk >= self.chunks.length() {
      self.currentChunk = self.chunks.length() - 1
      self.dataPosition = self.chunks[self.currentChunk].length - 1
    }
  }
}

///|
pub fn MemoryStream::setPosition(self : MemoryStream, pos : Int) -> Unit {
  self.seek(pos, SoBeginning)
}

///|
pub fn MemoryStream::seek(
  self : MemoryStream,
  pos : Int,
  origin : SeekOrigin
) -> Unit {
  if pos == 0 {
    return
  }
  match origin {
    SoBeginning => {
      if pos <= 0 {
        return
      }
      let mut pos = pos
      for idx, mem in self.chunks {
        if mem.length > pos {
          self.dataPosition = pos
          self.currentChunk = idx
          return
        }
        pos -= mem.length
        if pos == 0 {
          if idx == self.chunks.length() - 1 {
            self.dataPosition = mem.length - (self.capacity - self.size) - 1
            self.currentChunk = idx
          } else {
            self.dataPosition = 0
            self.currentChunk = idx + 1
          }
          return
        }
      }
    }
    SoCurrent =>
      if pos > 0 {
        let mut moveLen = self.chunks[self.currentChunk].length -
          self.dataPosition
        if pos < moveLen {
          self.dataPosition += pos
          return
        }
        moveLen = pos - moveLen
        let len = self.chunks.length()
        while moveLen > 0 {
          self.currentChunk += 1
          if self.currentChunk >= len {
            self.currentChunk = len - 1
            self.dataPosition = self.chunks[self.currentChunk].length -
              (self.capacity - self.size) -
              1
            return
          }
          moveLen -= self.chunks[self.currentChunk].length
          if moveLen < 0 {
            self.dataPosition = moveLen
            return
          } else if moveLen == 0 {
            self.dataPosition = 0
            self.currentChunk += 1
            if self.currentChunk >= len {
              self.currentChunk = len - 1
              self.dataPosition = self.chunks[self.currentChunk].length -
                (self.capacity - self.size) -
                1
              return
            }
          }
        }
      } else {
        let newPos = pos + self.dataPosition
        if newPos >= 0 {
          self.dataPosition = newPos
          return
        }
        if self.currentChunk == 0 {
          self.dataPosition = 0
          return
        }
        loop newPos {
          curPos => {
            self.currentChunk -= 1
            let newPos = curPos + self.chunks[self.currentChunk].length - 1
            if newPos >= 0 {
              self.dataPosition = newPos
              break
            }
            continue newPos
          }
        }
      }
    SoEnd => {
      if pos >= 0 {
        return
      }
      self.currentChunk = self.chunks.length() - 1
      self.dataPosition = pos +
        self.chunks[self.currentChunk].length -
        (self.capacity - self.size) -
        1
      self.seek(pos, SoCurrent)
    }
  }
}

///|
pub fn MemoryStream::position(self : MemoryStream) -> Int {
  let mut sum = self.dataPosition
  for i in 0..<self.currentChunk {
    sum += self.chunks[i].length
  }
  sum
}

///|
test "memoryStream" {
  let stream = MemoryStream::new()
  stream.setSize(200)
  let mem1 = getMemory(30)
  println(memManager)
  println(stream.chunks)
  freeMemory(mem1)
  println(memManager)
  stream.setSize(13)
  println(stream.chunks)
  println(memManager)
  stream.free()
  println(memManager)
}
