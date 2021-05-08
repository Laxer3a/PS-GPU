# PS-GPU
GPU Re-Implementation for PS1 Game Console in verilog.

# Support feature
- All commands are supported.
- Interlaced rendering is supported.

# Unsupported feature
- GPU top level do not export some CRT related registers (see comment in source, this is just output port to add)
  Those will proove useful at some point (cropping) for some games.
- GP1(00h) - Reset GPU / GP1(01h) - Reset Command Buffer do interrupt the primitive in flight (copy/rendering).
  But is not implemented. For now all primitives complete.

# Detail
- UV coordinate sampling and color rounding are not perfectly identical to the original but it is only visible through
  precise testing condition.
