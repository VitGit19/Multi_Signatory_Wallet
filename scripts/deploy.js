const main = async () => {
    const [deployer] = await hre.ethers.getSigners();
   
    const arraddr=[deployer.address,'0xa4e0bE2b34671808603539A31A41a2336Fd493F7','0x7792Aa301673d73Cf06d221b05b299927237518b','0xcA37f37637546FB5305cDB9f6178eE5786A7f48d','0x69e7750Ff51CdacAe98Af3a6AcA3d1Ba4Bb16873'];
    
    const mswFactory = await hre.ethers.getContractFactory("Multi_Sig_Wallet");
    const mswContract = await mswFactory.deploy(arraddr,{
        value: hre.ethers.utils.parseEther(".001"),
      });
      const depContract= await mswContract.deployed();
      
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();