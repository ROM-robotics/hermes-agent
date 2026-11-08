---
name: ti-c2000-f28379d
description: Develop and debug TI TMS320F28379D firmware
version: 1.0.0
metadata:
  hermes:
    tags: [ti, c2000, tms320f28379d, c28x, embedded]
    category: embedded
---

# TI C2000 TMS320F28379D

## When to Use

Use for firmware, control peripherals, interrupts, build configuration, and
debugging specifically targeting the TMS320F28379D or a board built around it.

## Procedure

1. Confirm the exact board, silicon revision, CPU/core (CPU1 or CPU2), boot
   mode, clock configuration, and TI compiler/CCS version.
2. Use the matching TMS320F2837xD Technical Reference Manual, device
   datasheet, silicon errata, and relevant TI compiler/driver documentation.
   Search with `datasheet-lookup`; cite document revision and section/table.
3. For peripheral work, identify the owning CPU and any ownership/clock-enable
   requirements before changing configuration. Check the official manual for
   the applicable ePWM, ADC, GPIO, PIE/interrupt, DMA, CLA, or communication
   peripheral details; do not assume a generic C2000 example applies unchanged.
4. For real-time control code, make timing assumptions explicit and account for
   interrupt latency, ADC trigger/conversion timing, PWM update boundaries,
   and shared-resource ownership using the official device documentation.
5. For a build or debug task, state the selected core, linker command file,
   startup/runtime libraries, and compiler version. Ask before programming or
   erasing the board.

## Pitfalls

- CPU1/CPU2 ownership and startup configuration affect which resources code
  can use; verify the actual project and board setup.
- C28x compiler and linker behavior is not interchangeable with GCC for
  Cortex-M. Do not transplant flags, ABI assumptions, or linker scripts.
- Peripheral timing and pin mux depend on the exact board and configuration.
- Check the errata for the target silicon revision before treating a workaround
  as unnecessary.

## Verification

Tie each device-specific answer to the matching TI source and revision. For
code, identify the core and CCS/compiler setup, and distinguish a CCS build
from execution and measurement on the target board.
