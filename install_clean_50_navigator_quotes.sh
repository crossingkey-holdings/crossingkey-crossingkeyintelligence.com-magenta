#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/clean_50_navigator_quotes_$STAMP"

mkdir -p "$BACKUP_DIR" src .ck_backups

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

if [ ! -f "src/ck-founder-newsletter.js" ]; then
  echo "Missing src/ck-founder-newsletter.js"
  echo "Install the founder newsletter banner first, then rerun this."
  exit 1
fi

cp -a src/ck-founder-newsletter.js "$BACKUP_DIR/ck-founder-newsletter.js"

python3 - <<'PY'
from pathlib import Path
import re
import json

path = Path("src/ck-founder-newsletter.js")
text = path.read_text(encoding="utf-8")

raw_quotes = r'''
**01. [Spiritual]** I don't look up to find meaning; I build it on the concrete I'm standing on.
**02. [Technical]** When the machine breaks, I don't panic. I get my hands in the wiring and force it to work.
**03. [Hard Life]** The life I lived wasn't a tragedy. It was the exact friction I needed to grind myself into a weapon.
**04. [Tough]** Being tough is for the streets. I built my mind like armor—matte-black and built to take the hit without flinching.
**05. [Addiction]** I didn't just "recover" from addiction. I ripped the compromised code out of my head and wrote a new baseline from scratch.
**06. [Motivation]** Motivation is a fleeting high for amateurs. I run on cold, engineered intent.
**07. [Shadow]** I spent years in the shadows of this system, not hiding, but learning exactly how to take it apart.
**08. [Light]** I don't wait for a light at the end of the tunnel. I strike the match and burn my own path through the dark.
**09. [Hope]** Hope is for victims waiting to be saved. I guarantee my survival through absolute execution.
**10. [Despair]** Despair is a dead end. When I hit the wall, I strip everything down to zero and start swinging a hammer.
**11. [Construction]** I don't dream about the future. I lay the iron down and build the damn thing.
**12. [Destruction]** I use destruction like a scalpel. You have to burn the old structures down to the studs before you can build an empire.
**13. [Redemption]** I'm not looking to be saved. I take the broken pieces, own the failure, and engineer a better outcome.
**14. [Damnation]** I've looked damnation in the eye. It's just another room you have to walk through to get to the work.
**15. [Condemnation]** Let them condemn my past. The ghost of who I was has absolutely no bearing on the strike I'm making today.
**16. [Incarceration]** The cell wasn't a cage; it was the violent isolation I required to burn away the noise and figure out who I actually am.
**17. [Freedom]** True freedom isn't doing whatever you want. It's having absolute control over the parameters of your own mind.
**18. [Service]** I don't serve a broken machine. I build systems that serve my exact intent, and I hold them to the fire until they deliver.
**19. [Duty]** My duty is holding the line. I take the heaviest cognitive load so the people I care about don't have to carry it.
**20. [Elite]** I don't tolerate amateur hour. I strip away the weak variables until all that's left is pure, disciplined execution.
**21. [God]** I don't sit around waiting for divine intervention. I act as the architect of the reality in front of me.
**22. [Devil]** I've danced with the devil, and I learned his rhythm. Now I extract the flaws and crush them under my own weight.
**23. [Good]** Good is subjective. I measure my actions by one metric: does it advance the objective or does it hold me back?
**24. [Evil]** Evil is just a misaligned intent. You don't negotiate with it; you aggressively correct the trajectory.
**25. [Good-inbetween-evil]** In that gray, muddy middle ground, I am the one who draws a hard line in the dirt.
**26. [Woman]** A real woman isn't a distraction. She is a vital, stabilizing pillar when the rest of the grid is tearing itself apart.
**27. [Sex]** Sex isn't an escape. It's a raw transfer of kinetic energy that pulls a high-speed mind violently back into the physical world.
**28. [Love]** Love isn't a vulnerability. It’s the highest-bandwidth connection you can forge in a world that’s constantly trying to disconnect you.
**29. [Hate]** I don't let hate consume me. I refine it into a high-yield fuel and use it to power a relentless advance.
**30. [Fight]** I left the blind street fights behind. Now, I control the theater. I decide when we clash, and I decide when it ends.
**31. [Relax]** I don't relax. I decompress. It's a calculated cooldown so the engine doesn't blow before the next strike.
**32. [Calm]** My calm isn't peace. It's the absolute zero-point focus right before I execute the command.
**33. [Turmoil]** When everything around me shakes, I lock my eyes forward, dig my heels in, and hold the center.
**34. [Adversary]** I don't fear an enemy. I study them, deconstruct their logic, and systematically take them apart.
**35. [Enemy]** The only enemy that can actually kill me is my own hesitation.
**36. [Friend]** A friend is someone who has proven they can hold the line next to you when the pressure drops.
**37. [Drugs]** I know the false frequency of drugs. I rejected that synthetic static for the raw, brutal clarity of reality.
**38. [Alcohol]** I don't drink to forget. I use the friction of a glass of whiskey to momentarily drop the shield and see where I'm bruised.
**39. [Hotels]** Hotels are just transient waystations. Temporary outposts while I push this vision forward.
**40. [Motels]** I did my quietest, most desperate work in the shadow of cheap motels, turning barren rooms into command centers.
**41. [Death]** I know death is the final reset. That's why I'm building a legacy that survives long after my hardware gives out.
**42. [Life]** Life is the raw, uncut material. You have to force it through the grinder to extract anything of value.
**43. [Rivers]** I don't float down the river. I dam the chaotic flow and force the water exactly where I need the power.
**44. [Mountains]** I don't climb the mountain for the view. I look at the geometry and figure out the fastest way to blast through the rock.
**45. [Oceans]** Staring down the deep water, I don't look for a lighthouse. I become the emerald-green Northstar of my own fleet.
**46. [Stars]** The stars aren't there to grant wishes. They're fixed coordinates so I can plot my exact trajectory.
**47. [The Sun]** I don't bask in the sun. I channel that blinding heat into a focused beam that cuts straight through the noise.
**48. [The Moon]** While the rest of the world sleeps under the silver light, I'm running the background processes, letting the pieces clash.
**49. [Discipline]** Discipline isn't a punishment. It's the absolute bedrock I had to lay down before I could build anything real.
**50. [Patience]** I weaponize patience. It's holding the kinetic tension in your hands until the exact microsecond you need to strike.
'''

def clean_quote(line: str) -> str:
    line = line.strip()
    line = re.sub(r"^\*+", "", line)
    line = re.sub(r"\*+$", "", line)
    line = re.sub(r"^\d+\.\s*", "", line)
    line = re.sub(r"^\[\s*[^\]]+\s*\]\s*", "", line)
    line = re.sub(r"^\*+", "", line)
    line = re.sub(r"\*+", "", line)
    return line.strip()

quotes = []
for line in raw_quotes.splitlines():
    cleaned = clean_quote(line)
    if cleaned:
        quotes.append(cleaned)

if len(quotes) != 50:
    raise SystemExit(f"Expected 50 cleaned quotes, got {len(quotes)}")

array_text = "const CK_NAVIGATOR_QUOTES = " + json.dumps(quotes, ensure_ascii=False, indent=2) + ";"

# Replace the existing CK_NAVIGATOR_QUOTES array safely.
text = re.sub(
    r"const\s+CK_NAVIGATOR_QUOTES\s*=\s*\[.*?\];",
    array_text,
    text,
    count=1,
    flags=re.S
)

# Make sure the quote renderer does not add duplicate quotation marks if you later include them manually.
text = re.sub(
    r"quote\.textContent\s*=\s*`“\$\{CK_NAVIGATOR_QUOTES\[index\]\}”`;",
    'quote.textContent = CK_NAVIGATOR_QUOTES[index];',
    text
)

path.write_text(text, encoding="utf-8")
PY

echo
echo "Installed cleaned 50 Navigator quotes."
echo "Removed:"
echo "  - markdown asterisks"
echo "  - numbers"
echo "  - bracketed category labels"
echo "Backup saved to:"
echo "  $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
