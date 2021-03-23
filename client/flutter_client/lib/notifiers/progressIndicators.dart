import 'package:flutter/material.dart';

class ProgressIndicatorStatus extends ChangeNotifier {
  bool sendFriendRequest = false;
  bool respondFriendRequest = false;
  bool joinTopic = false;
  bool profileUpdate = false;
  bool signIn = false;
  bool register = false;
  bool createChannel = false;
  bool topicPeoplesChange = false;
  bool topicLeave = false;
  bool topicRequestRespond = false;
  bool channelToggle = false;
  bool channelAddPeople = false;

  toggleSendFriendRequest() {
    sendFriendRequest = !sendFriendRequest;
    notifyListeners();
  }

  toggleRespondFriendRequest() {
    respondFriendRequest = !respondFriendRequest;
    notifyListeners();
  }

  toggleJoinTopic() {
    joinTopic = !joinTopic;
    notifyListeners();
  }

  toggleProfileUpdate() {
    profileUpdate = !profileUpdate;
    notifyListeners();
  }

  toggleSignIn() {
    signIn = !signIn;
    notifyListeners();
  }

  toggleRegister() {
    register = !register;
    notifyListeners();
  }

  toggleCreateChannel() {
    createChannel = !createChannel;
    notifyListeners();
  }

  toggleTopicPeoplesChange() {
    topicPeoplesChange = !topicPeoplesChange;
    notifyListeners();
  }

  toggleTopicLeave() {
    topicLeave = !topicLeave;
    notifyListeners();
  }

  toggleTopicRequestRespond() {
    topicRequestRespond = !topicRequestRespond;
    notifyListeners();
  }

  toggleChannelToggle() {
    channelToggle = !channelToggle;
    notifyListeners();
  }

  toggleChannelAddPeople() {
    channelAddPeople = !channelAddPeople;
    notifyListeners();
  }
}
