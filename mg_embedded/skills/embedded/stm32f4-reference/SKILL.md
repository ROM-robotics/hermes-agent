---
name: stm32f4-reference
description: Reason about STM32F4 firmware using official references
version: 1.0.0
metadata:
  hermes:
    tags: [stm32, stm32f4, arm-cortex-m, firmware]
    category: embedded
---

# STM32F4 Engineering

## When to Use

Use for STM32F4 architecture, firmware design, peripheral configuration,
clocking, interrupt, DMA, debugging, and board bring-up tasks.

## Procedure

1. Ask for the exact part number (for example, STM32F407VG) and board, plus
   clock source, toolchain, and HAL/LL/bare-metal preference when relevant.
2. Use `datasheet-lookup` for exact register settings, limits, and errata.
   Find the reference manual, datasheet, and errata matching that part/revision.
3. For clock-sensitive peripherals, trace the clock source, prescaler, and
   peripheral clock before calculating baud/timer values. State the assumed
   clock tree and verify it against the board and official documentation.
4. For interrupts and DMA, state the ISR/RTOS context, priorities, buffer
   ownership, and synchronization requirements. Do not assume a blocking API
   is safe in an ISR.
5. For a build, state the compiler and startup/linker assumptions. Ask before
   flashing or erasing a target.

## Pitfalls

- “STM32F4” alone does not identify a complete register map or board clock.
- HAL, LL, and direct-register code have different initialization and
  ownership assumptions; do not mix them silently.
- A successful compile does not prove correct clocks, pin mux, electrical
  levels, or runtime behavior.
- Check the device errata and board schematic for unexplained behavior.

## Verification

Give a source citation for device-specific claims. For code, identify the
target part and provide a build/test step; distinguish simulation or host
testing from on-board verification.
