# PS-GPU
GPU Re-Implementation for PS1 Game Console.

# Support feature
- All commands are supported.
- Interlaced rendering is supported.

# Unsupported feature
- GPU top level do not export some CRT related register (see comment in source)
  Those will proove useful at some point (cropping) for some games.
- GP1(00h) - Reset GPU / GP1(01h) - Reset Command Buffer do interrupt the primitive in flight (copy/rendering).
  But is not implemented. For now all primitives complete.
