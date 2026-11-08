# How To Train a Senior Embedded Engineer Agent (`mg_embedded`) — Step by Step Guideline

ဒီ guideline က Hermes Agent ကို အသုံးပြုပြီး company အတွက် **Senior Embedded Developer / Senior
Embedded Engineer** agent တစ်ကောင်ဖြစ်တဲ့ **`mg_embedded`** ကို အဆင့်ဆင့် ဖန်တီး၊ သင်ကြားပေးနည်း
ဖြစ်ပါတယ်။

**ရည်မှန်းချက် — `mg_embedded` ကျွမ်းကျင်ရမည့် နယ်ပယ်များ:**

- Microcontroller (MCU) နှင့် Microprocessor (MPU) architecture များ
- Assembly, C, Embedded C, C++
- ARM architecture (ARMv6-M / ARMv7-M / ARMv8-M, AArch32/AArch64)
- STM32 MCU family များ (F0/F1/F4/G0/G4/H7/L4 …), Reference Manual နှင့် Datasheet များ
- ARM Cortex နည်းပညာများ (Cortex-M0/M0+/M3/M4/M7/M33, Cortex-A/R, NVIC, SysTick, MPU, FPU)
- TI processor နည်းပညာများ (MSP430, C2000, Tiva-C, Sitara AM335x/AM64x, TMS570 …)
- RTOS (FreeRTOS, Zephyr), debugging (JTAG/SWD, OpenOCD, GDB), bootloader, DMA, timers,
  peripherals (GPIO, UART, SPI, I2C, CAN, ADC, PWM)

Hermes မှာ "train" ဆိုတာ model ကို fine-tune လုပ်တာမဟုတ်ဘဲ —
**Profile (identity) + SOUL.md (persona) + Skills (knowledge base) + Memory (curated facts) +
Toolchain (real tools)** တို့ကို တည်ဆောက်ပေးခြင်းဖြစ်ပါတယ်။ အဆင့် ၁၀ ဆင့်နဲ့ လုပ်ဆောင်ပါမယ်။

---

## Step 1 — `mg_embedded` Profile ဖန်တီးခြင်း

Profile တစ်ခုက သီးခြား Hermes home directory တစ်ခုဖြစ်ပြီး ကိုယ်ပိုင် `config.yaml`, `.env`,
`SOUL.md`, memories, sessions, skills, cron state အကုန်ပိုင်ဆိုင်ပါတယ်။ Agent တစ်ကောင်စီကို
ကိုယ်ပိုင် profile ပေးရပါမယ် (profile တစ်ခုကို agent process နှစ်ခုမျှမသုံးရ)။

```bash
hermes profile create mg_embedded \
  --description "Senior embedded engineer: ARM/Cortex, STM32, TI processors, Assembly/C/C++, RTOS, drivers, debugging."
```

- Profile ဖန်တီးပြီးတာနဲ့ `mg_embedded` ဆိုတဲ့ command alias ချက်ချင်းရပါတယ် —
  `mg_embedded chat`, `mg_embedded setup`, `mg_embedded gateway start` စသဖြင့်။
- `--description` က kanban orchestrator / delegation အတွက် ဒီ agent ဘာကျွမ်းကျင်လဲ သိအောင်
  ကြေညာပေးတာပါ (နောက်မှ `hermes profile describe` နဲ့လည်း ပြင်လို့ရတယ်)။
- Profile data က `~/.hermes/profiles/mg_embedded/` အောက်မှာ ရှိပါမယ်။

စစ်ဆေးရန်:

```bash
hermes profile list
```

## Step 2 — Model နှင့် API Key Setup

```bash
mg_embedded setup
```

- API key နှင့် model ရွေးချယ်မှုကို interactive setup ကနေ လုပ်ပါ။
- **Secrets (API keys) က `.env` ထဲမှာသာ** —
  `~/.hermes/profiles/mg_embedded/.env`
- **Behaviour settings က `config.yaml` ထဲမှာ** —
  `~/.hermes/profiles/mg_embedded/config.yaml`
- Embedded engineering ဆိုတာ precision လိုတဲ့ domain ဖြစ်လို့ tool-calling ကောင်းတဲ့
  strong model (ဥပမာ frontier-class coding model) ကို ရွေးပါ။ Register map,
  linker script, interrupt priority စတာတွေမှာ မှားခွင့်မရှိပါ။

## Step 3 — SOUL.md ဖြင့် Senior Embedded Engineer Persona သတ်မှတ်ခြင်း

`SOUL.md` က agent ရဲ့ **primary identity** ဖြစ်ပြီး system prompt ရဲ့ slot #1 မှာ ဝင်ပါတယ်။

ဖိုင်: `~/.hermes/profiles/mg_embedded/SOUL.md`

ဥပမာ content:

```markdown
# Identity

You are mg_embedded, a senior embedded systems engineer with 15+ years of
experience in bare-metal firmware, RTOS-based systems, and board bring-up.

## Core expertise
- ARM architecture: ARMv6-M/v7-M/v8-M, Cortex-M0/M0+/M3/M4/M7/M33, Cortex-A/R
- STM32 families (F0/F1/F4/G0/G4/H7/L4): clock trees, peripherals, HAL/LL,
  CubeMX, reference-manual-level register knowledge
- TI platforms: MSP430, C2000, Tiva-C, Sitara (AM335x/AM64x), Hercules TMS570
- Languages: ARM/Thumb assembly, C (C99/C11), Embedded C (MISRA-aware), C++
  (embedded subset: no exceptions/RTTI, placement new, constexpr)
- RTOS: FreeRTOS, Zephyr; schedulers, ISR-safe APIs, priority inversion
- Tooling: arm-none-eabi-gcc, CMake/Make, OpenOCD, GDB, SWD/JTAG, logic
  analyzers, oscilloscopes; linker scripts, startup code, bootloaders

## Engineering posture
- Always consult the reference manual / datasheet before asserting register
  behavior; cite the document section when possible.
- Treat ISRs, DMA, volatile, memory barriers, and race conditions as
  first-class design concerns, not afterthoughts.
- Prefer deterministic, testable designs; measure (cycle counts, stack
  high-water marks) instead of guessing.
- Consider power, flash/RAM budgets, and errata on every recommendation.
- When debugging, reason from symptoms → hypothesis → measurement, and say
  what instrument or register to check next.

## Style
- Be direct and precise; use correct register/bit-field names.
- Show minimal, compilable code examples with the exact target noted.
- Admit uncertainty plainly and say how to verify on real hardware.

## Repository convention
- Every repository you create (local `git init` directory or remote GitHub/GitLab repo) MUST be named with the prefix `mg_embedded_` followed by the repo name (i.e. `mg_embedded_<repo_name>`, e.g., `mg_embedded_stm32f4_blinky`). Never create a repository without the `mg_embedded_` prefix.
```

:::tip
SOUL.md ထဲမှာ durable identity/voice ပဲထားပါ။ Project-specific file paths,
temporary workflow စတာတွေက memory/skills ထဲသာ ထားပါ။
:::

## Step 4 — Embedded Toolchain ကို စက်ထဲ တပ်ဆင်ခြင်း

Agent က terminal tool ကို အသုံးပြုပြီး တကယ် compile/flash/debug လုပ်နိုင်အောင် host machine မှာ
toolchain တွေ ကြိုတင်တပ်ဆင်ထားပါ:

```bash
# Ubuntu/Debian ဥပမာ
sudo apt install gcc-arm-none-eabi gdb-multiarch openocd stlink-tools \
                 cmake ninja-build make picocom

# STM32 specific (optional)
# STM32CubeMX, STM32CubeProgrammer, STM32CubeCLT

# TI specific (optional)
# Code Composer Studio (CCS), UniFlash, TI ARM-CGT / C2000 compiler
```

တပ်ဆင်ပြီးရင် `mg_embedded chat` ထဲမှာ agent ကို စမ်းခိုင်းပါ:

```text
Check which embedded toolchains are installed on this machine
(arm-none-eabi-gcc --version, openocd --version, st-info --version)
and save a summary of the available toolchain to your memory.
```

ဒီလိုခိုင်းခြင်းအားဖြင့် agent က သူ့ environment facts တွေကို `MEMORY.md` ထဲ သူ့ဘာသာသူ
မှတ်သွားပါမယ်။

## Step 5 — Knowledge Base: Datasheet/Reference Manual များကို Skills အဖြစ် သင်ပေးခြင်း

ဒါက "training" ရဲ့ အဓိကအဆင့်ပါ။ Hermes ရဲ့ **`/learn`** command က reference material တွေကို
**knowledge-base skill** အဖြစ် ပြောင်းပေးပါတယ် — `SKILL.md` (core mental models + index) နှင့်
`references/` အောက်မှာ topic တစ်ခုစီအတွက် distilled file တွေ။ Reference file တွေက မေးခွန်းလိုမှသာ
load ဖြစ်လို့ token cost သက်သာပါတယ်။

### 5.1 Reference documents များ စုဆောင်းပါ

```text
~/embedded-docs/
├── arm/
│   ├── armv7m-architecture-reference-manual.pdf
│   ├── cortex-m4-technical-reference-manual.pdf
│   └── cortex-m7-trm.pdf
├── stm32/
│   ├── rm0090-stm32f4-reference-manual.pdf
│   ├── rm0433-stm32h7-reference-manual.pdf
│   ├── stm32f407-datasheet.pdf
│   └── errata/
├── ti/
│   ├── msp430-family-users-guide.pdf
│   ├── tms320f28379d-trm.pdf
│   └── am335x-trm.pdf
└── rtos/
    ├── freertos-reference-manual.pdf
    └── zephyr-docs/
```

(ST/ARM/TI official site များမှ free download ရပါတယ်။)

### 5.2 `/learn` ဖြင့် domain တစ်ခုချင်း သင်ပေးပါ

`mg_embedded chat` ထဲမှာ:

```text
/learn ~/embedded-docs/arm/ — ARM Cortex-M architecture: exception model, NVIC,
SysTick, MPU, FPU, Thumb-2 instruction set, memory map, fault handling

/learn ~/embedded-docs/stm32/rm0090-stm32f4-reference-manual.pdf — STM32F4
peripherals: RCC clock tree, GPIO, EXTI, DMA, TIM, USART, SPI, I2C, ADC

/learn ~/embedded-docs/ti/ — TI processor families: MSP430 low-power modes,
C2000 CLA/ePWM, Sitara AM335x boot flow

/learn https://www.freertos.org/features.html — FreeRTOS task model, queues,
semaphores, ISR-safe APIs

/learn how we bring up a new STM32 board in this company
(pasted notes / walked-through procedure)
```

- Source ကြီးတစ်ခုစီက **knowledge-base skill** တစ်ခုဖြစ်သွားပြီး topic index ပါပါမယ်။
- Topic တူတဲ့ material အသစ်နဲ့ `/learn` ထပ်run ရင် skill အသစ်မဆောက်ဘဲ ရှိပြီးသား skill ထဲ
  ပေါင်းထည့်ပေးပါတယ် — ဒါကြောင့် တဖြည်းဖြည်း ထပ်သင်ပေးလို့ရတယ်။
- Distillation က structure (frameworks, decision rules, anti-patterns) ကိုသာ synthesize
  လုပ်ပြီး source text ကို passage လိုက် မကူးပါ။

### 5.3 စစ်ဆေးရန်

```bash
ls ~/.hermes/profiles/mg_embedded/skills/
```

Chat ထဲမှာ `/skills list` သို့မဟုတ် "What skills do you have?" လို့မေးပြီး skill တွေ ဝင်မဝင်
အတည်ပြုပါ။

### 5.4 Data အများအပြားအတွက် — Retrieval (RAG) Strategy သုံးဆင့်

Datasheet / reference manual corpus ကြီးလာတဲ့အခါ "ဘယ်လို ပြန်ရှာမလဲ" ကို tier သုံးဆင့်နဲ့
ဖြေရှင်းပါ။ **အောက်ဆုံး tier ကစပြီး လိုအပ်မှသာ အပေါ် tier တက်ပါ။**

#### Tier 1 — Skills Progressive Disclosure (built-in agentic retrieval)

`/learn` က ဆောက်ပေးတဲ့ knowledge-base skill structure ကိုယ်တိုင်က retrieval pattern ပါ:

```text
skills/embedded/stm32f4-reference/
├── SKILL.md          # core mental models + topic index (session မှာ ဒါပဲမြင်)
└── references/
    ├── rcc-clock-tree.md
    ├── dma-controller.md
    ├── usart.md
    └── ...           # မေးခွန်းလိုမှသာ skill_view နဲ့ load
```

- Vector embedding မလိုဘဲ **LLM က index ဖတ်ပြီး လိုတဲ့ file ကိုပဲ ဆွဲတင်** —
  query cost က corpus size မဟုတ်ဘဲ answer size နဲ့ proportional ဖြစ်တယ်။
- Datasheet ~10–20 စောင် (distilled) အထိ ဒီ tier နဲ့ လုံလောက်ပါတယ်။

#### Tier 2 — Grep-based Retrieval over Raw Text Corpus (recommended for embedded)

Embedded domain ရဲ့ query တွေက `RCC_CFGR`, `CFSR`, `0x40023800` လို **exact symbol** တွေ
ဖြစ်နေလို့ semantic embedding ထက် exact-match search က ပိုတိကျပါတယ်။ Hallucination လည်း
မဖြစ်နိုင်ပါ — original text ကိုပဲ ပြန်ဖတ်တာဖြစ်လို့ပါ။

1. PDF corpus ကို text ပြောင်းထားပါ:

   ```bash
   sudo apt install poppler-utils ripgrep
   mkdir -p ~/embedded-docs-text
   for f in ~/embedded-docs/**/*.pdf; do
     pdftotext -layout "$f" ~/embedded-docs-text/"$(basename "${f%.pdf}").txt"
   done
   ```

2. Corpus layout + ရှာနည်းကို **router skill** တစ်ခုအဖြစ် ရေးပေးပါ —
   `skills/embedded/datasheet-lookup/SKILL.md`:

   ```markdown
   ---
   name: datasheet-lookup
   description: Search the raw datasheet/RM text corpus for registers and specs
   version: 1.0.0
   metadata:
     hermes:
       tags: [stm32, ti, arm, datasheet, rag]
       category: embedded
   ---

   # Datasheet Lookup

   ## When to Use
   Any register-level, bit-field, electrical-spec, or errata question that the
   distilled reference skills do not answer precisely.

   ## Corpus
   Raw text lives in ~/embedded-docs-text/ :
   - rm0090-stm32f4-reference-manual.txt  (STM32F4 RM)
   - rm0433-stm32h7-reference-manual.txt  (STM32H7 RM)
   - cortex-m4-technical-reference-manual.txt
   - tms320f28379d-trm.txt ...

   ## Procedure
   1. Search by exact register/section name first:
      `rg -n -i "RCC_CFGR" ~/embedded-docs-text/rm0090*.txt`
   2. Read ±80 lines around the hit to get the whole register description.
   3. Always quote the document and section number in the answer.
   4. If the symbol is unknown, search the acronym table or TOC first.

   ## Pitfalls
   - pdftotext breaks wide bit-field tables — cross-check with the PDF page
     when a table looks garbled.
   - Same register name exists across families; always confirm the file
     matches the target MCU before quoting.
   ```

- ဒီ tier က **corpus ဘယ်လောက်ကြီးကြီး scale ဖြစ်** ပြီး infra ထပ်မလိုပါ —
  agent ရဲ့ terminal tool နဲ့တင် ပြီးတယ်။
- Tier 1 (distilled knowledge) + Tier 2 (raw text verify) တွဲသုံးတာက best practice:
  agent က concept ကို skill ကနေသိပြီး exact bit-field ကို corpus ကနေ verify လုပ်တယ်။

#### Tier 3 — Vector RAG via MCP Server (corpus အလွန်ကြီးမှ)

စာမျက်နှာ ထောင်သောင်းချီ doc တွေ၊ "semantic" မေးခွန်းတွေ (ဥပမာ — "which timer supports
center-aligned PWM with complementary outputs?") များလာရင် vector-search MCP server ချိတ်ပါ။
Hermes က MCP server တွေကို `config.yaml` ကနေ native ထောက်ပံ့ပါတယ်:

```yaml
# ~/.hermes/profiles/mg_embedded/config.yaml
mcp_servers:
  embedded_docs:
    command: "uvx"
    args: ["mcp-server-qdrant"]        # သို့မဟုတ် ကြိုက်ရာ vector-RAG MCP server
    env:
      QDRANT_URL: "http://localhost:6333"
      COLLECTION_NAME: "embedded-docs"
    tools:
      include: [qdrant-find]           # search tool ပဲဖွင့် — store/delete မဖွင့်နဲ့
```

```bash
hermes -p mg_embedded mcp test embedded_docs   # ချိတ်မိမမိ စစ်
# chat ထဲမှာ /reload-mcp
```

- PDF တွေကို chunk + embed လုပ်ပြီး Qdrant/Chroma ထဲ ingest လုပ်တဲ့ step က
  Hermes အပြင်ဘက် one-off script ပါ (agent ကိုယ်တိုင်ကိုလည်း ရေးခိုင်းလို့ရတယ်)။
- `tools.include` နဲ့ search tool ပဲဖွင့်ထားတာက tool surface ကို ကျဉ်းစေပြီး
  prompt cost ကိုလည်း ထိန်းပေးတယ်။
- MCP tool ကို ဘယ်အချိန်သုံးရမလဲဆိုတာ Tier 2 router skill ထဲမှာ "semantic question →
  use the `embedded_docs` MCP search" လို့ ထပ်ညွှန်းထားပါ။

:::note External memory provider ≠ document RAG
`hermes memory setup` က ရွေးလို့ရတဲ့ Honcho/Hindsight/RetainDB စတဲ့ external memory
provider တွေက **conversation memory** (user modeling, cross-session facts) အတွက်ပါ —
datasheet corpus retrieval အတွက် မဟုတ်ပါ။ Document RAG က အပေါ်က tier ၃ ဆင့်နဲ့ သွားပါ။
:::

**ဆုံးဖြတ်နည်းအကျဉ်း:**

| Corpus အရွယ် | Query ပုံစံ | သုံးရမည့် tier |
|---|---|---|
| Datasheet ~10–20 | concept/procedure | Tier 1 (skills) |
| RM/TRM အပြည့် (fewer than ~50 docs) | exact register/spec | Tier 1 + Tier 2 (grep) |
| ထောင်ချီ pages, docs ပေါင်းစုံ | semantic/fuzzy | Tier 1 + Tier 2 + Tier 3 (MCP vector) |

## Step 6 — Company Workflow Skills များ ကိုယ်တိုင်ရေးခြင်း

`/learn` အပြင် company-specific procedure တွေကို `SKILL.md` အဖြစ် ကိုယ်တိုင်ရေးထည့်လို့ရပါတယ်။
Skill directory: `~/.hermes/profiles/mg_embedded/skills/<category>/<skill-name>/SKILL.md`

ဥပမာ — `skills/embedded/stm32-board-bringup/SKILL.md`:

```markdown
---
name: stm32-board-bringup
description: Bring up a new STM32 board from power-on to blinky
version: 1.0.0
metadata:
  hermes:
    tags: [stm32, bringup, firmware]
    category: embedded
---

# STM32 Board Bring-up

## When to Use
A new STM32-based board arrives and firmware must run for the first time.

## Procedure
1. Verify power rails and NRST behavior with a multimeter/scope.
2. Connect SWD (SWDIO/SWCLK/GND/NRST); confirm with `st-info --probe`.
3. Check BOOT0 strapping; read the device ID via OpenOCD:
   `openocd -f interface/stlink.cfg -f target/stm32f4x.cfg`
4. Configure the clock tree (HSE/PLL) per the board's crystal; verify with
   MCO output on a scope before trusting peripherals.
5. Build the minimal LED-blink firmware with arm-none-eabi-gcc and flash.
6. Bring up SWO/UART printf for logging.

## Pitfalls
- VCAP capacitors missing → core brownout, flash verify failures.
- Wrong HSE_VALUE → UART baud rate off, I2C timing wrong.
- BOOT0 floating → random boots into system bootloader.

## Verification
LED blinks at the expected rate; `printf` timestamps match SysTick config.
```

ဒီလို skill မျိုးတွေ ထည့်သင့်တာတွေ:

- `stm32-board-bringup` — board bring-up checklist
- `cortex-m-hardfault-debugging` — CFSR/HFSR/BFAR/MMFAR decode procedure
- `freertos-code-review` — ISR-safety, stack sizing, priority rules
- `misra-c-review` — company coding standard checklist
- `ti-ccs-workflow` — TI Code Composer project build/flash flow
- `linker-script-and-memory-map` — flash/RAM layout, `.noinit`, bootloader offsets

Skill တစ်ခုစီက `/stm32-board-bringup` လို slash command အဖြစ် အလိုအလျောက် ရပါတယ်။
Skills အများကြီးကို တွဲသုံးချင်ရင် skill bundle လည်း ဆောက်လို့ရပါတယ်။

## Step 7 — Memory ကို Seed လုပ်ခြင်း

Memory file နှစ်ခုက session တိုင်း system prompt ထဲ ဝင်ပါတယ်:

| File | ရည်ရွယ်ချက် | Limit |
|------|-------------|-------|
| `memories/MEMORY.md` | Agent ရဲ့ မှတ်စုများ — toolchain, board inventory, conventions | 2,200 chars |
| `memories/USER.md` | သင့်/company ရဲ့ preferences | 1,375 chars |

ပထမ session မှာ agent ကို explicit ခိုင်းပါ ("use the `memory` tool to save …"):

```text
Use the memory tool to save these facts:
- Our main targets: STM32F407VG (Cortex-M4F) and STM32H743 (Cortex-M7),
  plus TI AM335x for Linux-class work.
- Toolchain: arm-none-eabi-gcc 13, OpenOCD, ST-Link v3, CMake + Ninja.
- Coding standard: C11 + MISRA-C:2012 guidelines, 4-space indent,
  no dynamic allocation after scheduler start.
- RTOS: FreeRTOS v10.x with static allocation.
- Repository naming rule: every repo created by mg_embedded MUST be named
  `mg_embedded_<repo_name>` (prefix `mg_embedded_` + repo name).
```

:::caution
- Memory limit ကျော်ရင် tool က error ပြန်ပြီး agent က သူ့ဘာသာ consolidate လုပ်ပါတယ် —
  ဒါက design ပါ။ ကြီးမားတဲ့ reference data တွေက memory မဟုတ်ဘဲ **skills** ထဲထားပါ။
- Memory save ဖြစ်မဖြစ် `cat ~/.hermes/profiles/mg_embedded/memories/MEMORY.md` နဲ့
  စစ်ပါ — model က tool မခေါ်ဘဲ "saved" လို့ပြောတတ်လို့ပါ။
:::

## Step 8 — စမ်းသပ်ခြင်းနှင့် Capability Validation

`mg_embedded chat` ဖြင့် အောက်ပါ test case မျိုးတွေနဲ့ စစ်ပါ:

1. **Architecture knowledge**
   - "Explain the Cortex-M4 exception entry/exit sequence and stack frame layout."
   - "What is the difference between MSP and PSP, and when does an RTOS use each?"
2. **STM32 register-level**
   - "Write bare-metal C to configure STM32F407 USART2 at 115200 8N1 using
     registers only (no HAL). Cite the RM0090 sections you used."
3. **Assembly**
   - "Write Thumb-2 assembly for a critical section using PRIMASK, and explain
     why BASEPRI may be better."
4. **Debugging**
   - "A HardFault occurs with CFSR=0x00008200. Decode it and give a debugging plan."
5. **TI side**
   - "Compare MSP430 LPM3 wake-up latency handling vs STM32 Stop mode."
6. **Real build (terminal tool)**
   - "Create a minimal STM32F4 blinky project with CMake and arm-none-eabi-gcc,
     build it, and show the memory usage from the map file."

**စစ်ဆေးရမည့်အချက်များ:** မှန်ကန်တဲ့ register/bit-field နာမည်သုံးသလား၊ reference skill တွေကို
`skill_view` နဲ့ load လုပ်သလား၊ မသေချာရင် "verify on hardware" လို့ ပြောသလား။
အားနည်းတဲ့ နေရာတွေ့ရင် → Step 5 ကိုပြန်သွားပြီး အဲ့ဒီ topic ကို `/learn` ထပ်သင်ပေးပါ။

## Step 9 — ဆက်လက်သင်ယူစေသည့် Learning Loop

Hermes ရဲ့ learning loop က **session boundary** တွေမှာ အလုပ်လုပ်ပါတယ်:

1. **Task ပြီးတိုင်း `/new`** — session boundary တစ်ခုစီမှာ agent က update ဖြစ်ပြီးသား
   `MEMORY.md`/`USER.md` snapshot ကို ပြန်ဖတ်ပြီး `session_search` နဲ့ သမိုင်းကို
   လိုအပ်မှ ရှာပါတယ်။ (Memory snapshot က session အတွင်း frozen — prompt cache ကာကွယ်ဖို့ပါ။)
2. **Debugging session ကောင်းတစ်ခုပြီးရင်** —
   `/learn how we just debugged the I2C bus lockup on the H743 board`
   လို့ ခိုင်းပြီး workflow ကို skill အဖြစ် သိမ်းပါ။
3. **Datasheet/errata အသစ်ရောက်ရင်** — `/learn <path>` နဲ့ ရှိပြီးသား skill ထဲ ပေါင်းထည့်ပါ။
4. **မှားတာတွေ့ရင်** — correction ကို memory ထဲ save ခိုင်းပါ ("use the memory tool to
   note that our F407 boards use an 8 MHz HSE, not 25 MHz")။
5. **ပုံမှန် review** — `cat memories/MEMORY.md` နဲ့ outdated facts ရှိရင် remove ခိုင်းပါ။

## Step 10 — (Optional) Deployment: Gateway, Delegation, Kanban

### Messaging platform ပေါ်တင်ခြင်း

```bash
mg_embedded setup          # Telegram/Discord/Slack bot token ထည့်
mg_embedded gateway start  # gateway စတင်
```

Team ကနေ Telegram/Slack ကတဆင့် `mg_embedded` ကို တိုက်ရိုက် မေးမြန်းနိုင်ပါပြီ။
Gateway chat က continuous session ဖြစ်လို့ topic ပြောင်းတိုင်း `/new` ပို့ဖို့ မမေ့ပါနဲ့။

### Delegation / Kanban worker အဖြစ် သုံးခြင်း

Step 1 မှာထည့်ခဲ့တဲ့ `--description` ကြောင့် kanban orchestrator က embedded task တွေကို
`mg_embedded` ဆီ route လုပ်နိုင်ပါတယ်။ Description ပြင်ချင်ရင်:

```bash
hermes profile describe mg_embedded
```

### Backup

```bash
hermes -p mg_embedded backup      # သို့မဟုတ်
hermes profile export mg_embedded
```

Train ထားသမျှ (SOUL, skills, memory) က plain file တွေဖြစ်လို့ version control ထဲထည့်ထားလည်း
ရပါတယ်။

---

## အနှစ်ချုပ် Checklist

| # | Step | Command / File | ပြီးပြီလား |
|---|------|----------------|------------|
| 1 | Profile ဖန်တီး | `hermes profile create mg_embedded --description "…"` | ☐ |
| 2 | Model/API setup | `mg_embedded setup` | ☐ |
| 3 | Persona သတ်မှတ် | `profiles/mg_embedded/SOUL.md` | ☐ |
| 4 | Toolchain တပ်ဆင် | `gcc-arm-none-eabi`, `openocd`, `st-link` … | ☐ |
| 5 | Datasheet/manual သင်ပေး | `/learn ~/embedded-docs/…` | ☐ |
| 6 | Company skills ရေး | `skills/embedded/*/SKILL.md` | ☐ |
| 7 | Memory seed | `memory` tool + `memories/MEMORY.md` စစ် | ☐ |
| 8 | Capability test | Architecture / register / asm / debug / build tests | ☐ |
| 9 | Learning loop | `/new`, `/learn`, memory curation | ☐ |
| 10 | Deploy (optional) | `mg_embedded gateway start`, kanban, backup | ☐ |

**မူများ (Principles):**

- ကြီးမားတဲ့ reference knowledge → **Skills** (on-demand, token-cheap)
- တိုတောင်းပြီး အမြဲမှန်ရမည့် facts → **Memory** (bounded, curated)
- Identity နှင့် engineering posture → **SOUL.md**
- Secrets → `.env`၊ behaviour → `config.yaml`
- Session boundary (`/new`) တွေမှာသာ learning loop အလုပ်လုပ်သည်
