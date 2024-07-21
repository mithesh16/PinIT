
const { expect } = require("chai");
const { Contract } = require("hardhat/internal/hardhat-network/stack-traces/model");

describe("Decentragram", function () {
let decentragram;
let owner;
let otherAccount;
before(async()=>{
   [owner, otherAccount] = await ethers.getSigners();
  const Decentragram  = await ethers.getContractFactory("Decentragram");
 decentragram = await Decentragram.deploy();
      await decentragram.deployed()
     })

  
    it("Deploys successfully", async function () {
      expect(decentragram.address).to.not.equal(0x0);
      expect(decentragram.address).to.not.equal(" ");
      expect(decentragram.address).to.not.equal(null);
      expect(decentragram.address).to.not.equal(undefined);
    });
  
    it("Should set the right owner", async function () {
      expect(await decentragram.owner()).to.equal(owner.address);
    });
  

    describe("Images",function () {
      let result,pincount;     
      let pin;
      before(async()=>{
        result=await decentragram.postPin("www.imgur.com","Hello world",true);
        pincount=await decentragram.pinsCount();
        pin=await decentragram.pins(pincount);
      })
      it('Posts image',async()=>{
        //pin count
        expect(pincount).to.equal(1)
        //Checks the details of the pin
         expect(pin.id.toNumber()).to.equal(pincount.toNumber())
         expect(pin.uri).to.equal("www.imgur.com")
         expect(pin.caption).to.equal("Hello world")
         expect(pin.author.toString()).to.equal(owner.address.toString())
         expect(pin.tips.toNumber()).to.equal(0)
         expect(pin.likes.toNumber()).to.equal(0)
         expect(pin.dislikes.toNumber()).to.equal(0)
        expect(ethers.utils.formatEther(pin.mintPrice.toString(),"ether")).to.equal('1.0')
        expect(pin.enableMint).to.equal(true)
        expect(pin.isDeleted).to.equal(false)
        
      })

      it("Deletes image",async()=>{
        let tx=await decentragram.deletePin(1);
        pin=await decentragram.pins(pincount);
    expect(pin.isDeleted).to.equal(true)
      })

      it("Likes image",async()=>{
        let tx=await decentragram.likePin(1);
        pin=await decentragram.pins(pincount);
        let likes=await decentragram.showlikes(1);
        expect(pin.likes).to.equal(1);
        expect(pin.likes).to.equal(likes.toNumber())
      })

      it("Dislikes image",async()=>{
        let tx=await decentragram.likePin(1);
        pin=await decentragram.pins(pincount);
        let likes=await decentragram.showlikes(1);
        expect(pin.likes).to.equal(likes.toNumber())
      })
      })

      describe("username",function(){
       it("should set username",async()=>{
          tx=await decentragram.setUsername("mithesh");
           let username=await decentragram.usernames(owner.address);
          expect(username).to.equal("mithesh")
        })
      })
      describe("items",function(){
        before(async()=>{
          tx=await decentragram.postPin("www.dp.com","Hi world",true);
          tx=await decentragram.postPin("www","Hi",true);
          pinscount=await decentragram.pinsCount()
        })
        it("SHould show all items",async()=>{
          let pins=await decentragram.showallpins();
          for(let i=0;i<pinscount;i++){
          console.log(pins[i])
          }
          })
      })

      })

 




 

   