async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const balance = await deployer.getBalance();
    console.log("Account balance:", balance.toString());

    const SnipingBot = await ethers.getContractFactory("SnipingBot");
    const snipingBot = await SnipingBot.deploy("0x68b3465833fb72a70ecdf485e0e4c7bd8665fc45");
    console.log("SnipingBot address:", snipingBot.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
