import 'dart:async';
import 'package:app_nutriocionista/src/pages/consulta/widgets/select_cliente/select_cliente_widget.dart';
import 'package:app_nutriocionista/src/pages/consulta/widgets/slider_select/slider_select_widget.dart';
import 'package:app_nutriocionista/src/pages/home/home_module.dart';
import 'package:app_nutriocionista/src/shared/models/alimento_model.dart';
import 'package:app_nutriocionista/src/shared/models/client_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'create_consulta_bloc.dart';

class CreateConsultaWidget extends StatefulWidget {
  @override
  _CreateConsultaWidgetState createState() => _CreateConsultaWidgetState();
}

class _CreateConsultaWidgetState extends State<CreateConsultaWidget> {
  var bloc = HomeModule.to.getBloc<CreateConsultaBloc>();
  var controller = Controller();
  var money =
      MoneyMaskedTextController(decimalSeparator: ",", leftSymbol: "R\$");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar consulta"),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0),
        child: StreamBuilder<States>(
            stream: bloc.responseOut,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                switch (snapshot.data) {
                  case States.done:
                    {
                      Timer(Duration(seconds: 1), () {
                        Navigator.pop(context);
                      });
                      return Center(
                        child: Text("Consulta adicionada com sucesso!"),
                      );
                    }

                    break;
                  default:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      SelectClienteWidget(
                        onTap: (value) {
                          bloc.model.client = ClientModel(id: value);
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SliderSelectWidget(
                        title: "Peso",
                        onChanged: (value) {
                          bloc.model.peso = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SliderSelectWidget(
                        title: "Gordura",
                        type: TypeSlider.percent,
                        onChanged: (value) {
                          bloc.model.gordura = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SliderSelectWidget(
                        title: "Calorias",
                        type: TypeSlider.number,
                        onChanged: (value) {
                          bloc.caloriasIn.add(value.toInt());
                        },
                      ),
                      StreamBuilder<List<AlimentoModel>>(
                          stream: bloc.alimentosOut,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else if (snapshot.hasData) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: snapshot.data
                                    .map((item) => Card(
                                                                          child: ListTile(
                                            title:
                                                Text(item.nome),
                                            subtitle: Text(
                                                "${item.calorias} calorias"),
                                            trailing:
                                                Text("Grupo - ${item.grupo.nome}"),
                                          ),
                                    ))
                                    .toList(),
                              );
                            } else {
                              return Container();
                            }
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: controller.formkey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                maxLines: null,
                                onSaved: (value) => bloc.model.restrict = value,
                                validator: (value) =>
                                    value.isEmpty ? "Por favor descreva" : null,
                                decoration: InputDecoration(
                                    labelText: "Descreva a sensação física"),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              color: Colors.red,
                              colorBrightness: Brightness.dark,
                              child: Text(
                                "Criar",
                              ),
                              onPressed: () {
                                if (controller.validate()) {
                                  bloc.create();
                                }
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}

class Controller {
  var formkey = GlobalKey<FormState>();

  bool validate() {
    var form = formkey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
