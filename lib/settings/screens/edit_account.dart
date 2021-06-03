import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:chatapp/settings/setting_bloc.dart';
import 'package:chatapp/settings/setting_event.dart';
import 'package:chatapp/settings/setting_state.dart';
import 'package:chatapp/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class EditAccountScreen extends StatefulWidget {
  EditAccountScreen({Key key, @required this.info}) : super(key: key);
  final String info;
  @override
  State<StatefulWidget> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccountScreen> {
  String _value;
  Function _validator;
  DateTime _selectedDate;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              child: Icon(Icons.chevron_left),
                            ),
                            Text("Settings",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black))
                          ],
                        ),
                        onTap: () => navigateToAccount(),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Update ${widget.info.capitalize()}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            body: BlocWidget<SettingEvent, SettingState, SettingBloc>(
                builder: (BuildContext context, SettingState state) {
              if (widget.info == 'username') {
                _value = BlocProvider.of<SettingBloc>(context).getUserName();
                _validator = (String value) {
                  if (value.isNotEmpty &&
                      value.trim().isNotEmpty &&
                      value.length > 2) {
                    return true;
                  }
                  return false;
                };
              } else if (widget.info == 'email') {
                _value = BlocProvider.of<SettingBloc>(context).getUserEmail();
                _validator = (String value) {
                  return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                };
              } else {
                _value =
                    BlocProvider.of<SettingBloc>(context).getUserBirthday();
              }
              Widget content;
              if (state.loading) {
                content = Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).backgroundColor),
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                    )));
              } else if (state.error != null &&
                  state.error['message'].isNotEmpty) {
                content = AlertDialog(
                  title: Text("Something went wrong"),
                  content: Text(state.error['message']),
                  actions: [
                    TextButton(
                        child: Text("OK"),
                        onPressed: () => navigateToAccount()),
                  ],
                );
              } else {
                content = Form(
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                    decoration:
                        BoxDecoration(color: Theme.of(context).backgroundColor),
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 50,
                            child: Expanded(
                              child: Text('Current ${widget.info.capitalize()}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            )),
                        Container(
                          height: 50,
                          child: Expanded(
                            child: Text(_value,
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ),
                        ),
                        Container(
                          height: 50,
                          child: Expanded(
                            child: Text("New ${widget.info}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        widget.info != 'birthday'
                            ? Container(
                                height: 40,
                                child: TextFormField(
                                  autofocus: false,
                                  validator: (String value) {
                                    bool validName = _validator(value);
                                    return (validName)
                                        ? null
                                        : "Please enter valid ${widget.info}";
                                  },
                                  onSaved: (String value) {
                                    setState(() {
                                      _value = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: widget.info,
                                  ),
                                ),
                              )
                            : (Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () => showMaterialDatePicker(
                                            title: 'Birthday',
                                            context: context,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                            selectedDate: _selectedDate,
                                            onChanged: (value) => setState(
                                                () => _selectedDate = value),
                                          ),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5,
                                          height: 50,
                                          padding: EdgeInsets.only(
                                              left: 10, top: 10),
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(0xFFF4F9FE)),
                                          child: Column(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("Date",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF3E4347),
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Text(
                                                  _selectedDate.day.toString()),
                                            ],
                                          ))),
                                  SizedBox(width: 15),
                                  InkWell(
                                      onTap: () => showMaterialDatePicker(
                                            title: 'Birthday',
                                            context: context,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                            selectedDate: _selectedDate,
                                            onChanged: (value) => setState(
                                                () => _selectedDate = value),
                                          ),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5,
                                          height: 50,
                                          padding: EdgeInsets.only(
                                              left: 10, top: 10),
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(0xFFF4F9FE)),
                                          child: Column(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("Month",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF3E4347),
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Text(_selectedDate.month
                                                  .toString()),
                                            ],
                                          ))),
                                  SizedBox(width: 15),
                                  InkWell(
                                      onTap: () => showMaterialDatePicker(
                                            title: 'Birthday',
                                            context: context,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                            selectedDate: _selectedDate,
                                            onChanged: (value) => setState(
                                                () => _selectedDate = value),
                                          ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height: 50,
                                        padding:
                                            EdgeInsets.only(left: 10, top: 10),
                                        decoration: new BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color(0xFFF4F9FE)),
                                        child: Column(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text("Year",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF3E4347),
                                                  ),
                                                  textAlign: TextAlign.center),
                                            ),
                                            Text(_selectedDate.year.toString()),
                                          ],
                                        ),
                                      )),
                                ],
                              )),
                        Center(
                          child: ButtonTheme(
                              child: TextButton(
                                  onPressed: () => {
                                        if (_formKey.currentState.validate())
                                          {
                                            if (widget.info == 'username')
                                              {
                                                BlocProvider.of<SettingBloc>(
                                                        context)
                                                    .setUserName(_value)
                                              }
                                            else if (widget.info == 'email')
                                              {
                                                BlocProvider.of<SettingBloc>(
                                                        context)
                                                    .setEmail(_value)
                                              }
                                            else if (widget.info == 'birthday')
                                              {
                                                BlocProvider.of<SettingBloc>(
                                                        context)
                                                    .setBirthday(
                                                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}')
                                              },
                                            navigateToAccount()
                                          }
                                      },
                                  child: new Text("Update ${widget.info}",
                                      style: TextStyle(
                                          color: Color(0Xff365E7D))))),
                        )
                      ],
                    )),
                  ),
                );
              }
              return content;
            })));
  }

  void navigateToAccount() {
    NavigationHelper.navigateToAccount(context);
  }
}
