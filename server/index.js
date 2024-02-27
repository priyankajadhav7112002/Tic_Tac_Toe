const express = require('express');
const http = require('http');
const mongoose = require('mongoose');

const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
const Room = require('./models/room')
var io = require('socket.io')(server);

// client -> middleware -> server
// middlevare
app.use(express.json());

const DB = 'mongodb://priyanka:Priyanka_mongodb@ac-89wfcbj-shard-00-00.uvwokc6.mongodb.net:27017,ac-89wfcbj-shard-00-01.uvwokc6.mongodb.net:27017,ac-89wfcbj-shard-00-02.uvwokc6.mongodb.net:27017/?ssl=true&replicaSet=atlas-110ikc-shard-0&authSource=admin&retryWrites=true&w=majority';

io.on('connection',(socket)=>{
    console.log('connected');
   
    socket.on('createRoom', async ({nickname})=>{
        console.log(nickname);

        try{
            // room is created
        let room = new Room();
        // player is stored in the room
        let player = {
            socketID: socket.id,
            nickname: nickname,
            playerType:'X',
        };
        room.players.push(player);
        room.turn = player;
        room = await room.save();
        

        const roomId = room._id.toString();
        socket.join(roomId);

        // player is taken to the next screen
        // io -> send data to everyone
        // socket -> sending data to yourself
        io.to(roomId).emit('createRoomSuccess',room);

        }catch(e){
            console.log(e);
        }
        
    });
})

mongoose.connect(DB).then(()=>{
    console.log('Connection successful');
}).catch((e)=>{
    console.log(e);
})

server.listen(port,'0.0.0.0',()=>{
    console.log(`Server started and running on port ${port}`);
});
