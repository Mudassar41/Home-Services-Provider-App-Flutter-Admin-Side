import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/reusableComponents/lodingbar.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/stateManagement/providers/chatProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../chatScreen.dart';

class Inbox extends StatefulWidget {
  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  ChatProvider chatProvider;
  ApiServices apiServices = ApiServices();

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context);
    apiServices.inboxList(chatProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<ChatProvider>(
          builder: (context, items, _) {
            if (items.loadingbar) {
              return Center(child: LoadingBar());
            } else {
              return items.chatList.length == 0
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'No Message',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.lightRed),
                      ),
                    ))
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0.8,
                            child: ListTile(
                                onTap: () {
                                  Get.to(ChatScreen(
                                      userId: items.chatList[index].user_1,
                                      userFname: items
                                          .chatList[index].userFirstName,
                                      userLname: items
                                          .chatList[index].userLastName));
                                },
                                title: Text(
                                  '${items.chatList[index].userFirstName[0].toUpperCase()}${items.chatList[index].userFirstName.substring(1).toLowerCase()} ${items.chatList[index].userLastName[0].toUpperCase()}${items.chatList[index].userLastName.substring(1).toLowerCase()}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  items.chatList[index].chats.last.message,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: Container(
                                  child: Center(
                                    child: Text(
                                      items.chatList[index].providerFirstName[0]
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ),
                                  height: 60,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: index.isOdd
                                          ? CustomColors.lightGreen
                                          : CustomColors.lightGreen,
                                      shape: BoxShape.circle),
                                )),
                          );
                        },
                        itemCount: items.chatList.length,
                      ),
                    );
            }
          },
        ));
  }
}
