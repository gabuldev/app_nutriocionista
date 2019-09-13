import 'package:app_nutriocionista/src/pages/home/home_module.dart';
import 'package:app_nutriocionista/src/shared/models/alimento_model.dart';
import 'package:app_nutriocionista/src/shared/models/consulta_model.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import '../../consulta_repository.dart';

enum States { awainting, done }

class CreateConsultaBloc extends BlocBase {
  CreateConsultaBloc() {
    responseOut = consulta.stream.switchMap(observeConsulta);
    consultaIn = consulta.sink;
    caloriasIn = calorias.sink;
    caloriasOut = calorias.stream.asBroadcastStream();
    alimentosOut = caloriasOut.switchMap(observeCaloria);
    repo = HomeModule.to.getDependency<ConsultaRepository>();
  }

  ConsultaRepository repo;
  ConsultaModel model = ConsultaModel();

  var consulta = BehaviorSubject<ConsultaModel>();
  Sink<ConsultaModel> consultaIn;
  Observable<States> responseOut;

  var calorias = BehaviorSubject<int>();
  Sink<int> caloriasIn;
  Observable<int> caloriasOut;
  Observable<List<AlimentoModel>>
   alimentosOut;

   Stream<List<AlimentoModel>> observeCaloria(int data) async* {
    try {
      var response = await repo.getAlimentos(data);
      if(response.isNotEmpty)
      yield response.map(
        (item) => AlimentoModel.fromJson(item)).toList();
      else
      throw "Nenhum alimento encontrado com calorias menores que $data";
    } catch (e) {
      throw e;
    }
  }

  Stream<States> observeConsulta(ConsultaModel data) async* {
    try {
      yield States.awainting;
      var response = await repo.create(data.toGraphQL());
      if (response) yield States.done;
    } catch (e) {
      throw e;
    }
  }

  void create() {
    consultaIn.add(model);
  }

  @override
  void dispose() {
    calorias.close();
    caloriasIn.close();
    consulta.close();
    consultaIn.close();
    super.dispose();
  }
}
