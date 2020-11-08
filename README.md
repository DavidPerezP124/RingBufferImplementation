#  An Implementation of a Ring Buffer with a Queue

This implement the Ring Buffer with a Queue of elements.

The idea is that we create an array of "fixed" size.
The write pointer and the read pointer are updated upon using.
The ring portion is implemented by reading and writing using the modulo from the pointer and the `array.count`.

example:

```swift
// Read
array[writeIndex % array.count] = element
// Write
let element = array[readIndex % array.count]
```

While letting the pointers be updated the number of times they are used.
