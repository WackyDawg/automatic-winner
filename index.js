const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();

  // Navigate to the target page
  const url = 'https://nordvpn.com/ip-lookup/'; // Replace with the actual URL
  await page.goto(url, { waitUntil: 'networkidle0' });

  // Selector for the outermost span
  const selector = 'span.micro.c-bw-1';

  try {
    // Extract all text within the element
    const textContent = await page.$eval(selector, element => element.textContent.trim());
    console.log(`Extracted Text: ${textContent}`);
  } catch (error) {
    console.error('Error extracting text:', error);
  }

  await browser.close();
})();
