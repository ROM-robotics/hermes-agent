# `mg_embedded` setup pack

This pack adds a senior-level embedded-engineering persona and four on-demand
skills to a Hermes profile. It is preconfigured for STM32F4 and the
TMS320F28379D; it does not contain vendor manuals or train/fine-tune a model.
The persona also requires GitHub repositories created for this agent or its
embedded projects to use the `mg_embedded_<repo_name>` naming convention.

The retrieval workflow starts with exact-text search over locally held manuals.
That is a good first fit for register names, addresses, bit fields, and error
codes. Keep vendor documents and company material in a private directory on the
VPS; do not commit them to this repository.

## 1. Create the profile on the VPS

Copy this `mg_embedded/` directory to the VPS, then run:

```bash
hermes profile create mg_embedded \
  --description "Senior embedded engineer: ARM Cortex, STM32F4, TI C2000 F28379D, C/C++/assembly, RTOS, drivers, and debugging."
mg_embedded setup
```

Configure the model and credentials through Hermes setup. Never put API keys in
this pack or in `SOUL.md`.

## 2. Install the persona and skills

Run these commands from the directory containing the copied `mg_embedded/`
folder. They refuse to overwrite an existing `SOUL.md` and do not overwrite
existing skill files. Back up and merge manually if you want to update an
already-installed persona or skill.

```bash
PROFILE_HOME="${HERMES_HOME:-$HOME/.hermes}/profiles/mg_embedded"
mkdir -p "$PROFILE_HOME/skills"
if [ -e "$PROFILE_HOME/SOUL.md" ]; then
  echo "Refusing to overwrite $PROFILE_HOME/SOUL.md; back it up and merge manually." >&2
  exit 1
fi
install -m 0644 mg_embedded/SOUL.md "$PROFILE_HOME/SOUL.md"
cp -rn mg_embedded/skills/embedded "$PROFILE_HOME/skills/"
```

Start a fresh session so the profile loads its new identity and skills:

```bash
hermes -p mg_embedded chat
```

## 3. Add the private document corpus

Use a layout that preserves the source family and revision in the path:

```text
~/embedded-docs/
├── pdf/
│   ├── stm32f4/
│   │   ├── RM0090-revision-21.pdf
│   │   ├── STM32F407VG-datasheet.pdf
│   │   └── STM32F407xx-errata.pdf
│   └── ti-c2000/
│       ├── TMS320F2837xD-TRM.pdf
│       ├── TMS320F28379D-datasheet.pdf
│       └── TMS320F2837xD-errata.pdf
└── text/                 # generated; keep relative paths from pdf/
```

Install the text extraction/search utilities on Debian 12:

```bash
sudo apt update
sudo apt install poppler-utils ripgrep
bash mg_embedded/scripts/convert_pdfs.sh \
  "$HOME/embedded-docs/pdf" "$HOME/embedded-docs/text"
```

The converter preserves subdirectories and source filenames. Search examples:

```bash
rg -n -i "RCC_CFGR" "$HOME/embedded-docs/text/stm32f4"
rg -n -i "EPwm[0-9]+Regs|TBCTL|CMPA" "$HOME/embedded-docs/text/ti-c2000"
```

Use the skills' exact-part and source-citation procedure for every technical
answer. `pdftotext` can scramble multi-column tables; check the original PDF
before relying on a table or giving an exact page citation.

## 4. Validate

In a new `mg_embedded` session, ask it to:

1. List the available embedded skills and identify the configured corpus path.
2. Find an exact register (for example `RCC_CFGR`) and return its source file,
   section/table, and verified PDF page.
3. Explain one TMS320F28379D peripheral using the matching TI TRM and errata.
4. Say explicitly when a source is absent or ambiguous instead of inventing a
   register value.

This VPS currently has no embedded compiler, debugger, or probe utilities
installed. Add those only when you need to build or debug on the VPS. A cloud
VPS cannot flash a physical board without an explicitly connected/forwarded
debug probe; do not treat successful compilation as hardware validation.
