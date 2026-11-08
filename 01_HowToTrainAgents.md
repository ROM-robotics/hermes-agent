# Agent များကို Specific Task များအတွက် အတွေ့အကြုံရှိလာအောင် လေ့ကျင့်နည်း

ဒီ guide က Hermes Agent ကို သင်လုပ်စေချင်တဲ့ အလုပ်တစ်ခုချင်းစီမှာ ပိုတော်လာအောင်
"လေ့ကျင့်" ပေးနည်းကို ဒီ repo ထဲက တကယ်ရှိတဲ့ system တွေအပေါ် အခြေခံပြီး ရှင်းပြထားပါတယ်။

အရေးကြီးဆုံး အချက် — Hermes က model weights ကို fine-tune လုပ်ပြီး သင်ယူတာ **မဟုတ်ပါ**။
Hermes ရဲ့ သင်ယူမှုက **context engineering** ဖြစ်ပါတယ်။ Agent ဆီကို session တိုင်း
ဘာတွေ ပြန်ရောက်လာမလဲဆိုတာကို စနစ်တကျ စုဆောင်းထိန်းသိမ်းပေးခြင်းဖြင့် အတွေ့အကြုံ
တိုးလာစေတာပါ။ လမ်းကြောင်း (၄) ခု ရှိပါတယ် —

| လမ်းကြောင်း | ဘာကို မှတ်သလဲ | ဘယ်မှာ သိမ်းသလဲ |
|---|---|---|
| **Memory** | သင့်အကြောင်း၊ ပတ်ဝန်းကျင်အကြောင်း အချက်အလက်များ | `~/.hermes/memories/MEMORY.md`, `USER.md` |
| **Skills** | Task တစ်ခုကို ဘယ်လိုလုပ်ရမလဲဆိုတဲ့ လုပ်ထုံးလုပ်နည်း (procedure) | `~/.hermes/skills/` + bundled [skills/](./skills) |
| **Session Search** | အရင် session တွေရဲ့ မှတ်တမ်းအပြည့်အစုံ | Session database (`session_search` tool) |
| **Feedback Loop** | သင် ပြင်ပေးလိုက်တဲ့ အမှားတွေ | Memory/Skill ထဲ ပြန်ရေးသွင်းခြင်း |

---

## ၁။ Learning Loop ကို နားလည်ပါ

Hermes ရဲ့ အတွေ့အကြုံစုဆောင်းမှု သံသရာက ဒီလိုပါ —

```
Task ခိုင်း → Agent လုပ် → သင် Feedback ပေး → Agent က Memory/Skill ထဲ မှတ် →
Session အသစ်စ → မှတ်ထားတာတွေ system prompt ထဲ ပြန်ဝင် → ပိုကောင်းကောင်း လုပ်နိုင်
```

ဒီ loop မှာ **session boundary (session အဆုံးသတ်ခြင်း)** က အရေးအကြီးဆုံးပါ။
Memory system တစ်ခုလုံးက session ဆုံးတဲ့အချိန်ကို အခြေခံ တည်ဆောက်ထားတာဖြစ်လို့
session တစ်ခုတည်းထဲမှာ ဘယ်လောက်ခိုင်းခိုင်း "အတွေ့အကြုံ" မစုပါဘူး —
`MEMORY.md`/`USER.md` snapshot က session အသစ်စမှသာ ပြန် load ဖြစ်ပါတယ်။

**လက်တွေ့ကျင့်စဉ် —** Task တစ်ခုပြီးတိုင်း၊ ခေါင်းစဉ်ပြောင်းတိုင်း `/new` နဲ့
session အသစ်စပါ။ Boundary တစ်ခုစီတိုင်းမှာ agent က update ဖြစ်ပြီးသား memory ကို
ပြန်ဖတ်ပြီး ကုန်ကျစရိတ်သက်သာတဲ့ context အတိုနဲ့ ပြန်စတင်ပါတယ်။

---

## ၂။ Memory — သင့်အကြောင်းနဲ့ ပတ်ဝန်းကျင်ကို မှတ်စေခြင်း

Memory file နှစ်ခု ရှိပါတယ် —

| File | ရည်ရွယ်ချက် | ကန့်သတ်ချက် |
|---|---|---|
| `MEMORY.md` | Agent ရဲ့ ကိုယ်ပိုင်မှတ်စု — environment facts, conventions, သင်ယူပြီးသားအရာများ | ~2,200 chars |
| `USER.md` | User profile — သင့် preference, ဆက်သွယ်ပုံစတိုင်, မျှော်လင့်ချက်များ | ~1,375 chars |

### လေ့ကျင့်နည်း

1. **တိတိကျကျ မှတ်ခိုင်းပါ။** "ကျွန်တော့် project တွေက `~/work/` အောက်မှာရှိတယ်၊
   commit message တွေ conventional-commits format နဲ့ရေး — ဒါကို မှတ်ထားပါ" လို့
   ပြောရင် agent က memory tool နဲ့ သိမ်းသွားပါတယ်။
2. **မှတ်ထားတာ မှန်မမှန် စစ်ပါ** —

   ```bash
   cat ~/.hermes/memories/MEMORY.md
   cat ~/.hermes/memories/USER.md
   ```

3. **မှားမှတ်ထားရင် ပြင်ခိုင်းပါ** သို့မဟုတ် file ကို ကိုယ်တိုင် edit လုပ်နိုင်ပါတယ်
   (plain Markdown ပါ)။
4. **Memory က bounded ဖြစ်တယ်ဆိုတာ သတိထားပါ။** Char limit ရှိလို့ procedure
   ရှည်ရှည်တွေ မသိမ်းသင့်ပါ — လုပ်ထုံးလုပ်နည်းတွေက **Skill** ထဲ သွားသင့်ပါတယ်
   (အောက်မှာကြည့်ပါ)။

:::သတိ::: Hermes home တစ်ခုတည်းကို agent process နှစ်ခု မျှမသုံးပါနဲ့ —
memory write တွေ ရောထွေးသွားပါလိမ့်မယ်။ Agent တစ်ကောင်စီကို ကိုယ်ပိုင်
[profile](./website/docs/user-guide/profiles.md) ပေးပါ။

---

## ၃။ Skills — Task-specific အတွေ့အကြုံရဲ့ ပင်မသိုလှောင်ရုံ

**Specific task တစ်ခုမှာ agent ကို တော်စေချင်ရင် Skill က အဓိက ဖြေရှင်းချက်ပါ။**
Skill ဆိုတာ task တစ်ခုအတွက် လုပ်ထုံးလုပ်နည်း၊ သတိထားရမယ့်အချက်များ၊ helper script
များပါဝင်တဲ့ `SKILL.md` document တစ်ခုပါ။ Agent က လိုအပ်တဲ့အခါ `skill_view` နဲ့
load လုပ်ပြီး အသုံးချပါတယ် (progressive disclosure — skill အကုန်လုံးကို
တစ်ပြိုင်နက် context ထဲ မထည့်ပါ)။

### နည်းလမ်း (က) — Agent ကိုယ်တိုင် Skill ရေးခိုင်းခြင်း (အကောင်းဆုံးနည်း)

Task တစ်ခုကို agent နဲ့ အတူ အောင်မြင်အောင် လုပ်ပြီးတဲ့အခါ —

```
မင်း ခုနက deploy process ကို အဆင့်ဆင့် မှတ်ထားဖို့ skill တစ်ခု ဖန်တီးလိုက်ပါ။
နောက်တစ်ခါ "deploy" လို့ပြောရင် ဒီအတိုင်း လုပ်နိုင်အောင်။
```

Agent က `skill_manage` tool နဲ့ `~/.hermes/skills/` ထဲ skill အသစ်ရေးပါတယ်။
နောက် session တွေမှာ ဒီ skill က slash command (`/deploy`) အဖြစ်ပါ သုံးလို့ရပါတယ်။
ဒါက "experience တစ်ကြိမ်ရ → ထာဝရ မှတ်" ဆိုတဲ့ training ရဲ့ အနှစ်သာရပါပဲ။

### နည်းလမ်း (ခ) — ကိုယ်တိုင် Skill ရေးခြင်း

ပုံစံအပြည့်အစုံကို [creating-skills.md](./website/docs/developer-guide/creating-skills.md)
မှာ ကြည့်ပါ။ အကျဉ်းချုပ် —

```
~/.hermes/skills/my-task/
└── SKILL.md        # frontmatter (name, description, ...) + procedure
    scripts/        # ခက်ခဲတဲ့ logic ကို helper script အဖြစ် ထည့်ပါ
    references/     # နောက်ခံ အချက်အလက်ရှည်များ
```

SKILL.md ရဲ့ စံပုံစံ — `## When to Use`, `## Prerequisites`, `## Quick Reference`,
`## Procedure`, `## Pitfalls`, `## Verification`။ **`## Pitfalls` section က
training value အမြင့်ဆုံးပါ** — agent မှားခဲ့ဖူးတာတွေကို ဒီမှာ စုထားပါ။

### နည်းလမ်း (ဂ) — ရှိပြီးသား Skill တွေ သုံးခြင်း

```bash
/skills                 # ရှိသမျှ skill စာရင်း
/skills search docker   # keyword နဲ့ ရှာ
/skills browse          # official optional skills hub
hermes skills install official/<category>/<skill>
```

Bundled skills တွေက [skills/](./skills) မှာ၊ ပိုလေးတဲ့ optional skills တွေက
[optional-skills/](./optional-skills) မှာ ရှိပါတယ်။

### Skill ကို ထပ်တိုးတိုး ပြင်ဆင်ခြင်း (iteration = training)

Agent က skill သုံးပြီး မှားသေးရင် —

```
မင်း /deploy skill ထဲမှာ staging ကို အရင် check လုပ်ဖို့ ကျန်နေတယ်။
Skill ကို update လုပ်ပြီး Pitfalls ထဲ ဒီအမှားကို မှတ်ထားလိုက်ပါ။
```

ဒီလို feedback → skill patch → ပြန်စမ်း ဆိုတဲ့ loop ကို ထပ်ခါထပ်ခါ လုပ်လေ၊
skill က ပိုပြည့်စုံလေ၊ agent ရဲ့ "အတွေ့အကြုံ" တိုးလေပါပဲ။

---

## ၄။ Curator — Skill များကို အလိုအလျောက် ထိန်းသိမ်းခြင်း

Agent ဖန်တီးထားတဲ့ skill တွေ များလာရင် [Curator](./website/docs/user-guide/features/curator.md)
က usage ကို ခြေရာခံပြီး မသုံးဖြစ်တော့တဲ့ skill တွေကို auto-archive လုပ်ပေးပါတယ်
(ဘယ်တော့မှ မဖျက်ပါ — `~/.hermes/skills/.archive/` ထဲ ရွှေ့ထားပြီး ပြန်ယူလို့ရပါတယ်)။

```bash
hermes curator status      # skill တွေရဲ့ အခြေအနေ
hermes curator pin <name>  # အရေးကြီး skill ကို auto-archive မခံရအောင် pin
hermes curator restore <name>
```

အရေးကြီးတဲ့ task skill တွေကို **pin** ထားပါ — pin ထားရင် auto-transition
အားလုံးကနေ ကင်းလွတ်ပါတယ်။

---

## ၅။ Session Search — အတိတ် Session များကို ပြန်ရှာခြင်း

Memory file ထဲ မဝင်တဲ့ အသေးစိတ်တွေကို agent က `session_search` tool နဲ့
အတိတ် session မှတ်တမ်းတွေထဲက ပြန်ရှာနိုင်ပါတယ်။ "မနေ့က ဘာဆုံးဖြတ်ခဲ့လဲ
ပြန်ကြည့်ပြီး ဆက်လုပ်ပါ" လိုမျိုး ခိုင်းလို့ရပါတယ်။ ဒါကြောင့် session တွေ
ပုံမှန် ပိတ်လည်း အတွေ့အကြုံ ဆုံးရှုံးသွားတာ မဟုတ်ပါ။

---

## ၆။ Delegation — အတွေ့အကြုံကို Subagent များနဲ့ ချဲ့ခြင်း

Task ကြီးတွေမှာ [delegation](./website/docs/user-guide/features/delegation.md) နဲ့
subagent တွေကို ခွဲခိုင်းနိုင်ပါတယ်။ Training ရှုထောင့်ကနေကြည့်ရင် —

- Skill ထဲမှာ "ဒီအဆင့်ကို `delegate_task` နဲ့ ခွဲလုပ်ပါ" လို့ ရေးထားနိုင်လို့
  delegation pattern ကိုယ်တိုင်လည်း သင်ပေးလို့ရတဲ့ အတွေ့အကြုံ ဖြစ်ပါတယ်။
- Pattern များ (parallel research, code review, compare alternatives) —
  [delegation-patterns.md](./website/docs/guides/delegation-patterns.md)

---

## ၇။ Cron — ထပ်ခါထပ်ခါ Task များကို အလေ့အကျင့်ဖြစ်အောင်

Skill တစ်ခုက ရင့်ကျက်သွားပြီဆိုရင် [cron](./website/docs/guides/automate-with-cron.md)
နဲ့ အချိန်ဇယားသတ်မှတ်ပြီး အလိုအလျောက် ခိုင်းထားနိုင်ပါတယ်။ Skill တစ်ခုကို
blueprint (automation ပါတဲ့ skill) အဖြစ်လည်း ရေးထားနိုင်ပါတယ် —
[creating-skills.md § Blueprints](./website/docs/developer-guide/creating-skills.md) ကြည့်ပါ။

---

## ၈။ Agent ညံ့သွားသလို ခံစားရရင်

Training မစခင် [Troubleshooting: "My Agent Feels Dumber"](./website/docs/guides/troubleshooting-agent-quality.md)
ကို အရင်စစ်ပါ —

1. `/model`, `/status` — ဘယ် model သုံးနေလဲ (model switch = capability ပြောင်းခြင်း)
2. `/usage`, `/context` — context ပြည့်နေလား၊ ပြည့်ရင် `/compress` သို့ `/new`
3. Context length ကို config ထဲ အတိအကျ သတ်မှတ်ထားလား
4. Memory snapshot က session စတုန်းက freeze ဖြစ်တယ် — session အသစ်စမှ update ရမယ်

---

## ၉။ လက်တွေ့ Workflow အကျဉ်းချုပ်

Specific task တစ်ခု (ဥပမာ — weekly report ထုတ်ခြင်း) အတွက် agent ကို
လေ့ကျင့်မယ်ဆိုရင် —

1. **ပထမအကြိမ်** — Task ကို အသေးစိတ် ရှင်းပြပြီး အတူလုပ်ပါ။ မှားရင် ချက်ချင်း ပြင်ပေးပါ။
2. **ပြီးရင်** — "ဒီ process ကို skill အဖြစ် သိမ်းထားပါ" လို့ ခိုင်းပါ။
   သင့် preference တွေကိုတော့ memory ထဲ မှတ်ခိုင်းပါ။
3. **`/new`** — session boundary ဖန်တီးပါ (memory/skill တွေ အသက်ဝင်မယ့်အချိန်)။
4. **ဒုတိယအကြိမ်** — `/weekly-report` လို့ပဲ ခိုင်းကြည့်ပါ။ လိုအပ်တာ ပြင်ပြီး
   skill ကို update ခိုင်းပါ (အထူးသဖြင့် `## Pitfalls`)။
5. **ရင့်ကျက်ရင်** — အရေးကြီး skill ကို `hermes curator pin` လုပ်ပါ၊
   ထပ်ခါထပ်ခါ လုပ်ရမယ့် task ဆိုရင် cron နဲ့ အလိုအလျောက်လုပ်ခိုင်းပါ။

ဒီ loop ကို task တစ်ခုချင်းစီအတွက် ထပ်လုပ်သွားရင် agent ရဲ့ "အတွေ့အကြုံ" က
skill library + memory အဖြစ် တဖြည်းဖြည်း စုဆောင်းမိသွားပြီး — model ဘယ်လောက်
ပြောင်းပြောင်း၊ session ဘယ်နှစ်ခါ ပိတ်ပိတ် — ပျောက်မသွားတော့ပါဘူး။

---

## ဆက်ဖတ်ရန်

- [Working with Skills](./website/docs/guides/work-with-skills.md)
- [Creating Skills](./website/docs/developer-guide/creating-skills.md)
- [Persistent Memory](./website/docs/user-guide/features/memory.md)
- [Curator](./website/docs/user-guide/features/curator.md)
- [Delegation & Parallel Work](./website/docs/guides/delegation-patterns.md)
- [Tips & Best Practices](./website/docs/guides/tips.md)
