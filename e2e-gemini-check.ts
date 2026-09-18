/* Temporary end-to-end probe: writing, images and narration through the admin routing. */
import { resolveProvider } from "./src/lib/aiConfig.server";
import { askAI, generateSceneImage, generateNarration } from "./src/lib/ai.server";

async function step<T>(name: string, run: () => Promise<T>) {
  const started = Date.now();
  try {
    const value = await run();
    console.log(`PASS ${name} (${Date.now() - started}ms)`);
    return value;
  } catch (error) {
    console.log(`FAIL ${name} (${Date.now() - started}ms):`, (error as Error).message);
    return undefined;
  }
}

const llm = await resolveProvider("llm");
const image = await resolveProvider("image");
const tts = await resolveProvider("tts");
console.log("routing:", { llm: llm.id, image: image.id, tts: tts.id });

const text = await step("writing", () =>
  askAI("You are a test probe. One short sentence.", "Reply with: routing works."),
);
console.log("  text:", text?.slice(0, 120));

const img = await step("image", () => generateSceneImage("A calm sunrise over a quiet city skyline"));
console.log("  image bytes:", img?.length);

const audio = await step("narration", () =>
  generateNarration("Voice check. Your narration engine is working.", "edge-aria"),
);
console.log("  audio bytes:", audio?.length);
