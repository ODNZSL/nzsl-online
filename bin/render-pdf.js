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

const [
  ,,
  inputPath,
  outputPath,
  basicAuthUsername,
  basicAuthPassword,
] = process.argv

console.log("Input path:", inputPath);
console.log("Output path:", outputPath);

/* Usually we'd prefer not to launch puppeteer with the no-sandbox argument,
but due to issues getting it running on Heroku this option is required. */

(async () => {
  const browser = await puppeteer.launch({
    args: ["--no-sandbox", "--disable-web-security", "--disable-setuid-sandbox"],
    headless: "new"
  });
  try {
    const page = await browser.newPage();

    if (basicAuthUsername) {
      await page.authenticate({ username: basicAuthUsername, password: basicAuthPassword });
    }

    await page.setDefaultTimeout(0);

    console.log("Starting PDF conversion");
    // https://github.com/GoogleChrome/puppeteer/blob/v1.4.0/docs/api.md#pagegotourl-options
    await page.goto(inputPath, { waitUntil: "load" });

    // https://github.com/GoogleChrome/puppeteer/blob/v1.4.0/docs/api.md#pagepdfoptions
    await page.pdf({
      path: outputPath,
      format: "A4"
    });

    console.log("PDF conversion complete");
  } finally {
    await browser.close();
  }
})().catch(error => {
  console.error(error)

  process.exitCode = 1
});
