---
name: datasheet-lookup
description: Search embedded manuals for exact technical facts
version: 1.0.0
metadata:
  hermes:
    tags: [embedded, datasheet, reference-manual, retrieval]
    category: embedded
---

# Embedded Datasheet Lookup

## When to Use

Use this skill for device-specific register, bit-field, memory-map, electrical,
timing, interrupt, and errata questions. Use it whenever a distilled skill is
not enough to support an exact claim.

## Corpus

The default VPS layout is:

- PDFs: `~/embedded-docs/pdf/<device-family>/`
- Extracted text: `~/embedded-docs/text/<device-family>/`

The PDF is authoritative. Extracted text is a search index, not a substitute
for checking a table or ambiguous passage in the original document.

## Procedure

1. Confirm the full target part number and, when relevant, silicon revision.
   Do not assume all STM32F4 parts share a peripheral implementation.
2. Search the narrowest matching device-family directory. Start with exact
   register, bit-field, API, or error names:

   ```bash
   rg -n -i "RCC_CFGR" "$HOME/embedded-docs/text/stm32f4"
   rg -n -i "TBCTL|EPwm1Regs" "$HOME/embedded-docs/text/ti-c2000"
   ```

3. If there is no exact hit, search the full peripheral name, likely acronym,
   and related terms separately. Do not infer a fact from a similar MCU family.
4. Read enough surrounding text to capture the conditions, reset value,
   access type, reserved bits, and any sequence or timing constraints.
5. Check the original PDF for table-heavy, multi-column, or suspiciously
   extracted text. Confirm the PDF page before reporting it.
6. Answer with the document title/number, revision, section/table, and verified
   page if available. Clearly label any inference.
7. If the matching official source is absent or the target/revision is unknown,
   say what is missing and ask for it. Never fabricate a citation or value.

## Pitfalls

- Register names and bit layouts can vary across part numbers and revisions.
- `pdftotext` may scramble wide tables, superscripts, or column order.
- `rg` line numbers refer to extracted text, not PDF page numbers.
- Errata can override normal reference-manual behavior; check it for the
  relevant silicon revision.

## Verification

Before finalizing an exact device claim, confirm that the cited file matches
the requested part and that the cited section/table is visible in the original
PDF. If either check fails, qualify the answer or request the correct document.
