import 'dart:convert';

//import 'package:cryptography/cryptography.dart';
//import 'package:cryptography_flutter/cryptography_flutter.dart';

// class Encryption {
//   final algorithm = Chacha20.poly1305Aead();
//   SecretKey secretKey;
//   List<int> nonce;

//   init() async {
//     secretKey = await algorithm.newSecretKey();
//     nonce = algorithm.newNonce();
//   }

//   encrypt(String text) async {
//     return await algorithm.encrypt(
//       utf8.encode(text),
//       secretKey: secretKey,
//       nonce: nonce,
//     );
//   }

//   decrypt(SecretBox encryptedText) async {
//     return await algorithm.decrypt(
//       encryptedText,
//       secretKey: secretKey,
//     );
//   }

//   test() async {
//     await init();
//     SecretBox encrypted = await encrypt('testing - this is the encrypted text');
//     print(
//         '${'testing - this is the encrypted text'.length}  ${encrypted.cipherText.length}');
//     print(String.fromCharCodes(encrypted.cipherText));
//     print(utf8.decode(await decrypt(encrypted)));
//   }
// }
