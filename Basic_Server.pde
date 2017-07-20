import processing.net.*;

String ipAddress = "127.0.0.1";
int port = 2202;

Boolean ch1MuteState, ch2MuteState, ch3MuteState, ch4MuteState;

Server myServer;

void setup() {
  size(400, 400);
  background(0);
  //create server
  myServer = new Server(this, port, ipAddress);

  // set mute states
  ch1MuteState = random(0, 1) < 0.5;
  ch2MuteState = random(0, 1) < 0.5;
  ch3MuteState = random(0, 1) < 0.5;
  ch4MuteState = random(0, 1) < 0.5;
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
}

void clientTraffic(Client client, String msg) {
  println(client.ip() + " says: " + msg);

  //is this a request to get a state?
  if (msg.contains("GET")) {
    // mute state?
    if (msg.contains("AUDIO_MUTE")) {
      //which channel?
      int chnl = int(msg.charAt(6))-48;
      String reply = getMute(chnl);
      client.write(reply);
      println("I have sent: " + reply + " to " + client.ip());
    }
  } else if (msg.contains("AUDIO_MUTE TOGGLE")) {
    //which channel?
    int chnl = int(msg.charAt(6))-48;
    String reply = getMute(chnl);
    toggleMute(chnl);
    client.write(reply);
    println("I have sent: " + reply + " to " + client.ip());
  }
}

String getMute(int channel) {
  if (channel == 1) {
    if (ch1MuteState) {
      return "< REP 1 AUDIO_MUTE ON >";
    } else {
      return "< REP 1 AUDIO_MUTE OFF >";
    }
  } else if (channel == 2) {
    if (ch2MuteState) {
      return "< REP 2 AUDIO_MUTE ON >";
    } else {
      return "< REP 2 AUDIO_MUTE OFF >";
    }
  } else if (channel == 3) {
    if (ch3MuteState) {
      return "< REP 3 AUDIO_MUTE ON >";
    } else {
      return "< REP 3 AUDIO_MUTE OFF >";
    }
  } else if (channel == 4) {
    if (ch4MuteState) {
      return "< REP 4 AUDIO_MUTE ON >";
    } else {
      return "< REP 4 AUDIO_MUTE OFF >";
    }
  } else {
    return "< ERR >";
  }
}

void toggleMute(int channel) {
  if (channel == 1) {
    if (ch1MuteState) {
      ch1MuteState = false;
    } else {
      ch1MuteState = true;
    }
  } else if (channel == 2) {
    if (ch2MuteState) {
      ch2MuteState = false;
    } else {
      ch2MuteState = true;
    }
  } else if (channel == 3) {
    if (ch3MuteState) {
      ch3MuteState = false;
    } else {
      ch3MuteState = true;
    }
  } else if (channel == 4) {
    if (ch4MuteState) {
      ch4MuteState = false;
    } else {
      ch4MuteState = true;
    }
  }
}