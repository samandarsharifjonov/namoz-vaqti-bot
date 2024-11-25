import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TelegramBot {
   var botToken = Platform.environment['BOT_TOKEN'];
  //static const botToken1 = '7971765646:AAHTr_6QnG9Cfm9q8IL2gzTAiqC7WELeS1E';



  final List<String> regions = [
    'Tashkent',
    'Samarkand',
    'Bukhara',
    'Andijan',
    'Ferghana',
    'Namangan',
    'Karakalpakstan',
    'Khorezm',
    'Navoiy',
    'Jizzakh',
    'Sirdaryo',
    'Surkhandaryo'
  ];

  Future<void> init() async {
    print(botToken);
    if (botToken == null) {
      print('Error: BOT_TOKEN is not set in the environment.');
      return;
    }


    DateTime now = DateTime.now();
    String currentTime = DateFormat('HH:mm').format(now);

    final username = (await Telegram(botToken!).getMe()).username;
    final bot = TeleDart(botToken!, Event(username!));
    bot.start();

    print('start-bot');



    bot.onCommand().listen((userMessage) {
      final chatId = userMessage.chat.id;
      final messageId = userMessage.messageId;

      if(userMessage.text!.toLowerCase() != '/start' && userMessage.text!.toLowerCase() != '/region'){
        userMessage.reply("Iltimos kerakli buyruqlardan foydalaning!\nMisol uchun /region viloyatlar ro'yhatini chiqarib beradi.");
      }

      if (userMessage.text?.toLowerCase() == '/start' ||
          userMessage.text?.toLowerCase() == '/region') {
        final startTxt =
            "Assalomu Alaykum ${userMessage.from?.firstName}\nNamoz vaqtlari botiga xush kelibsiz :)";

        userMessage.reply(startTxt,
            replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
              [
                InlineKeyboardButton(
                    text: "Tashkent", callbackData: 'Tashkent'),
                InlineKeyboardButton(
                    text: "Samarkand", callbackData: 'Samarkand'),
              ],
              [
                InlineKeyboardButton(text: "Bukhara", callbackData: 'Bukhara'),
                InlineKeyboardButton(text: "Andijan", callbackData: 'Andijan'),
              ],
              [
                InlineKeyboardButton(
                    text: "Ferghana", callbackData: 'Ferghana'),
                InlineKeyboardButton(
                    text: "Namangan", callbackData: 'Namangan'),
              ],
              [
                InlineKeyboardButton(
                    text: "Karakalpakstan", callbackData: 'Karakalpakstan'),
                InlineKeyboardButton(text: "Khorezm", callbackData: 'Khorezm'),
              ],
              [
                InlineKeyboardButton(text: "Navoiy", callbackData: 'Navoiy'),
                InlineKeyboardButton(text: "Jizzakh", callbackData: 'Jizzakh'),
              ],
              [
                InlineKeyboardButton(
                    text: "Sirdaryo", callbackData: 'Sirdaryo'),
                InlineKeyboardButton(
                    text: "Surkhandaryo", callbackData: 'Surkhandaryo'),
              ],
            ]));
      }
    });

    bot.onCallbackQuery().listen((callbackQuery) async {
      final String region;
      final chatID = callbackQuery.message?.chat.id;
      final data = callbackQuery.data;
      final messageId = callbackQuery.message?.messageId;
      final response = await http.get(Uri.parse(
          'http://api.aladhan.com/v1/timingsByCity?city=${data}&country=Uzbekistan&method=2'));

      if (data!.isNotEmpty && data != 'back' && data != 'help') {
        if (response.statusCode == 200) {
          final body = json.decode(response.body);
          final timings = body['data']['timings'];
          final dates = body['data']['date'];

          final date = dates['readable'];
          final imsak = timings['Imsak'];

          final fajr = timings['Fajr']; //bomdod
          final sunrise = timings['Sunrise'];
          //final sunset = timings['Sunset'];
          final dhuhr = timings['Dhuhr']; //peshin
          final asr = timings['Asr']; // ars
          final maghrib = timings['Maghrib']; //shom
          final isha = timings['Isha'];

          print(currentTime);
          print(isha);

          final messageText = "${"<b>${date.toUpperCase()}</b>"}\n"
              "${"<b>${data.toUpperCase()}</b>"} uchun Namoz vaqtlari\n\n"
              "Bomdod:  $fajr\n"
              "Peshin:  $dhuhr\n"
              "Asr:  $asr\n"
              "Shom:  $maghrib\n"
              "Xufton  $isha\n\n"
              "Quyosh chiqishi - $sunrise\n"
              "Quyosh botishi -  $maghrib\n\n"
              "${"<b>Manba: aladhan.com</b>"}  ";

          bot.editMessageText(
            chatId: chatID,
            messageId: messageId,
            messageText,
            parseMode: "HTML",
            replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
              [
                InlineKeyboardButton(
                    text: "Orqaga qaytish", callbackData: 'back'),
              ]
            ]),
          );
        } else {
          bot.editMessageText(
              chatId: chatID,
              messageId: messageId,
              "Namoz vaqtini olishda xatolik yuz berdi");
        }
      }
    });

    bot.onCallbackQuery().listen(
      (callBackQuery) {
        final chatId = callBackQuery.message?.chat.id;
        final data = callBackQuery.data;
        final messageId = callBackQuery.message?.messageId;
        if (data == 'back') {
          bot.editMessageText(
              " ${callBackQuery.from.firstName} Viloyatni tanlang",
              messageId: messageId,
              chatId: chatId,
              replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
                [
                  InlineKeyboardButton(
                      text: "Tashkent", callbackData: 'Tashkent'),
                  InlineKeyboardButton(
                      text: "Samarkand", callbackData: 'Samarkand'),
                ],
                [
                  InlineKeyboardButton(
                      text: "Bukhara", callbackData: 'Bukhara'),
                  InlineKeyboardButton(
                      text: "Andijan", callbackData: 'Andijan'),
                ],
                [
                  InlineKeyboardButton(
                      text: "Ferghana", callbackData: 'Ferghana'),
                  InlineKeyboardButton(
                      text: "Namangan", callbackData: 'Namangan'),
                ],
                [
                  InlineKeyboardButton(
                      text: "Karakalpakstan", callbackData: 'Karakalpakstan'),
                  InlineKeyboardButton(
                      text: "Khorezm", callbackData: 'Khorezm'),
                ],
                [
                  InlineKeyboardButton(text: "Navoiy", callbackData: 'Navoiy'),
                  InlineKeyboardButton(
                      text: "Jizzakh", callbackData: 'Jizzakh'),
                ],
                [
                  InlineKeyboardButton(
                      text: "Sirdaryo", callbackData: 'Sirdaryo'),
                  InlineKeyboardButton(
                      text: "Surkhandaryo", callbackData: 'Surkhandaryo'),
                ],
                [InlineKeyboardButton(text: 'Yordam', callbackData: 'help')]
              ]));
        }
        if (data == 'help') {
          var helps =
              "${callBackQuery.from.firstName} Sizga qanday yordam bera olaman?\n"
              "adminga xabaringizni qoldiring!\n\n"
              "Mavjud buyruqlar\n"
              "/start - botni qayta ishga tushurish\n"
              "/region - Viloyatlar ro'yhati\n";
          bot.editMessageText(
              chatId: chatId,
              messageId: messageId,
              helps,
              replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
                [
                  InlineKeyboardButton(
                      text: "Adminga yozish",
                      url: 'http://t.me/SamandarbekSharifjonov'),
                ],
                [
                  InlineKeyboardButton(
                      text: "Orqaga qaytish", callbackData: 'back'),
                ]
              ]));
        }
      },
    );

    bot.onMessage().listen((userMessage) {
      userMessage.reply("${userMessage.from!.firstName} quydagi buyruqlardan foydalaning!\n/start - Botni qayta ishga tushurish\n/region - barcha viloyatlar ro'yhati");
    },);



  }
}
