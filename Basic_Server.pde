import processing.net.*;

String ipAddress; //if not declared server will bind to all interfaces
int port = 2202;

int numChnls = 4;
int r = 50;


boolean[] chnlMuteStates = new boolean[numChnls];

Server myServer;

void setup() {
  size(400, 400);
  background(0);
  //create server
  if (ipAddress != null) {
    myServer = new Server(this, port, ipAddress);
  } else {
    myServer = new Server(this, port);
  }
  // set mute states
  for (int i = 0; i < numChnls; i++) {
    chnlMuteStates[i] = random(0, 1) < 0.5;
  }
}

void draw() {
  // Get the next available client
  Client thisClient = myServer.available();
  // If the client is not null, and says something, display what it said
  if (thisClient !=null) {
    String whatClientSaid = thisClient.readStringUntil('>');
    if (whatClientSaid != null) {
      clientTraffic(thisClient, whatClientSaid);
    }
  }

  //draw channel mute states
  for (int i = 0; i < numChnls; i++) {
    int xPos = i * floor(width/numChnls) + 50;
    if (chnlMuteStates[i]) {
      fill(255, 0, 0);
    } else {
      fill(0, 255, 0);
    }
    ellipse(xPos, 100, r, r );
  }
}

void clientTraffic(Client client, String msg) {
  println(client.ip() + " says: " + msg);

  //is this a request to get a state?
  if (msg.contains("GET")) {
    // mute state?
    if (msg.contains("AUDIO_MUTE")) {
      //which channel?
      int chnl = int(msg.charAt(6))-49;
      String reply = getMute(chnl);
      client.write(reply);
      println("I have sent: " + reply + " to " + client.ip());
    }
    // is this a request to toggle a setting?
  } else if (msg.contains("TOGGLE")) {
    // mute state?
    if (msg.contains("AUDIO_MUTE")) {
      //which channel?
      int chnl = int(msg.charAt(6))-49;
      toggleMute(chnl);
      String reply = getMute(chnl);
      client.write(reply);
      println("I have sent: " + reply + " to " + client.ip());
    }
    // is this a request to set something?
  } else if (msg.contains("SET")) {// mute state?
    if (msg.contains("AUDIO_MUTE")) {
      //which channel?
      int chnl = int(msg.charAt(6))-49;
      String reply = setMute(chnl, msg.contains("ON"));
      client.write(reply);
      println("I have sent: " + reply + " to " + client.ip());
    }
  }
}

String getMute(int channel) {
  if (channel > chnlMuteStates.length) {
    return "< ERR >";
  } else {
    if (chnlMuteStates[channel]) {
      return "< REP "+ (channel + 1) + " AUDIO_MUTE ON >";
    } else {
      return "< REP "+ (channel + 1) + " AUDIO_MUTE OFF >";
    }
  }
}

String setMute(int channel, boolean setOn) {
  if (channel > chnlMuteStates.length) {
    return "< ERR >";
  } else {
    if (setOn) {
      chnlMuteStates[channel] = true;
      return "< REP "+ (channel + 1) + " AUDIO_MUTE ON >";
    } else {
      chnlMuteStates[channel] = false;
      return "< REP "+ (channel + 1) + " AUDIO_MUTE OFF >";
    }
  }
}

void toggleMute(int channel) {
  if (channel > chnlMuteStates.length) {
    // do nothing
  } else {
    if (chnlMuteStates[channel]) {
      chnlMuteStates[channel] = false;
    } else {
      chnlMuteStates[channel] = true;
    }
  }
}