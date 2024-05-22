const { ethers } = require("hardhat");

async function main() {
    const [owner] = await ethers.getSigners();
    const contractAddress = "Your_Contract_Address_Here";

    const SnipingBot = await ethers.getContractFactory("SnipingBot");
    const snipingBot = SnipingBot.attach(contractAddress);

    //Snipe a token
    const tokenIn = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"; // WETH
    const tokenOut = "0xYourTokenAddressHere";
    const fee = 3000; // Example fee tier
    const amountIn = ethers.utils.parseEther("1"); // 1 ETH
    const amountOutMin = ethers.utils.parseUnits("1000", 18); // Minimum amount of tokens expected
    const sqrtPriceLimitX96 = 0;

    await snipingBot.snipe(tokenIn, tokenOut, fee, amountIn, amountOutMin, sqrtPriceLimitX96);

    //Sell the token
    const amountOut = ethers.utils.parseEther("1");
    const amountInMax = ethers.utils.parseUnits("1000", 18);

    await snipingBot.sell(tokenOut, tokenIn, fee, amountOut, amountInMax, sqrtPriceLimitX96);

    console.log("Snipe and sell executed");
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
