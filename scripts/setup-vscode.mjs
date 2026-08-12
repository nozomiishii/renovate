import fs from "node:fs";
import path from "node:path";

const example = ".vscode/settings.example.json";
const settings = ".vscode/settings.json";

if (!fs.existsSync(example)) {
  console.log(`Skipped: ${example} does not exist.`);
} else if (fs.existsSync(settings)) {
  console.log(`Skipped: ${settings} already exists.`);
} else {
  fs.mkdirSync(path.dirname(settings), { recursive: true });
  fs.copyFileSync(example, settings);
  console.log(`Copied: ${example} -> ${settings}`);
}
