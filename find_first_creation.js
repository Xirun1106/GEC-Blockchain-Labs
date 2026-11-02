
require("dotenv").config({ quiet: true });

const fs = require("fs");
const { Web3 } = require("web3");

const web3 = new Web3(process.env.INFURA_URL);

const LIMIT = 55000;
const BATCH_SIZE = 20;
const CHECKPOINT = "scan-progress.json";

const sleep = ms =>
  new Promise(resolve => setTimeout(resolve, ms));

async function getBlock(number) {
  for (let attempt = 1; attempt <= 5; attempt++) {
    try {
      return await web3.eth.getBlock(number, true);
    } catch (err) {
      if (attempt === 5) throw err;
      await sleep(attempt * 1500);
    }
  }
}

async function main() {
  let start = 0;

  if (fs.existsSync(CHECKPOINT)) {
    start = JSON.parse(
      fs.readFileSync(CHECKPOINT, "utf8")
    ).nextBlock || 0;
  }

  console.log("Starting at:", start);

  for (let i = start; i < LIMIT; i += BATCH_SIZE) {
    const end = Math.min(i + BATCH_SIZE, LIMIT);

    const blocks = await Promise.all(
      Array.from(
        { length: end - i },
        (_, j) => getBlock(i + j)
      )
    );

    for (let j = 0; j < blocks.length; j++) {
      const block = blocks[j];

      for (const tx of block.transactions) {
        if (tx.to === null) {
          const result = {
            blockNumber: i + j,
            transactionHash: tx.hash
          };

          fs.writeFileSync(
            "first-creation-result.json",
            JSON.stringify(result, null, 2)
          );

          console.log("FOUND:", result);
          return;
        }
      }
    }

    fs.writeFileSync(
      CHECKPOINT,
      JSON.stringify({ nextBlock: end })
    );

    if (end % 100 === 0) {
      console.log("Scanned through:", end - 1);
    }
  }

  console.log("No result in scanned range.");
}

main().catch(err => {
  console.error("Stopped:", err.code || err.message);
  process.exitCode = 1;
});
