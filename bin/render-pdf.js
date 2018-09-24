/**
 * node.js script to render a given HTML file into the given PDF filename.
 * Details of the API are at https://developers.google.com/web/tools/puppeteer/
 *
 * This command is invoked as:
 *
 *   $ node bin/render-pdf.js input.html output.pdf
 *
 */

const puppeteer = require("puppeteer");

const inputPath = `file://${process.argv[2]}`;
const outputPath = process.argv[3];

console.log("Input path:", inputPath);
console.log("Output path:", outputPath);

/* Usually we'd prefer not to launch puppeteer with the no-sandbox argument,
but due to issues getting it running on Heroku this option is required. */

(async () => {
  const browser = await puppeteer.launch({args: ["--no-sandbox"]});
  const page = await browser.newPage();

  console.log("Starting PDF conversion");
  await page.goto(inputPath, { waitUntil: "networkidle2" });

  // https://github.com/GoogleChrome/puppeteer/blob/v1.4.0/docs/api.md#pagepdfoptions
  await page.pdf({
    path: outputPath,
    format: "A4"
  });

  console.log("PDF conversion complete");
  await browser.close();
})();
