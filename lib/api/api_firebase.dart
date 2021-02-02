//
//  Firebase Api
//

import '../app/app.dart';
import 'api.dart';
import 'package:firedart/firedart.dart';

class Api_firebase extends Api {
  Firestore db;

  Connect() {
    db = Firestore.instance;
  }

  SendMessage(String to_uid, String message)
  //
  //  Messages are identified by sender '-' receiver
  //                          or receiver '-' sender
  //
  // where lowest collated id comes first
  //
  
   {
    String _message_id = "";
    Map<String, String> _message = 
      {
        'message_id': _message_id,
        'from_uid': App.mUser.uid,
        'to_uid' : to_uid,
        'message': message,
        'encrypt': 'n',
        'sent_at': ''
      };

    db.collection("messages").document(_message_id).set(_message);
  }

  GetMessages(String from_uid) {}

  GetAllMessages() {}

  SendComp(String to_uid, String item_iod, int quantity, double price) {}

  GetComps(String from_uid) {}

  GetAllComps() {}
}
