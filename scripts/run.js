const main = async () => {
    const [admin,act1,act2,act3,act4] = await hre.ethers.getSigners();
    console.log("running contracts with account: ", admin.address);
    const arraddr=[(admin.address),(act1.address),(act2.address),(act3.address),(act4.address)];
    
    const mswFactory = await hre.ethers.getContractFactory("Multi_Sig_Wallet");
    const mswContract = await mswFactory.deploy(arraddr,{
        value: hre.ethers.utils.parseEther(".1"),
      });
      const depContract= await mswContract.deployed();
      contractBalance = await hre.ethers.provider.getBalance(depContract.address);
      console.log(
        "Contract balance:",
        contractBalance
      );
    
    const signatories= await depContract.getSignatories();
     
    console.log("Initial balance: ,",await act4.getBalance());
   const transtnId=  await depContract.submitTranstn((act4.address),1,"0x00",{from:admin.address});
    await depContract.connect(act1).authoriseTranstn(transtnId.value);
    await depContract.connect(act2).authoriseTranstn(transtnId.value);
    await depContract.connect(act3).authoriseTranstn(transtnId.value);
   // await depContract.connect(act4).authoriseTranstn(transtnId.value);
    
     console.log("final balance: ,",await act4.getBalance());
     //console.log(transtnId);
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