import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_patient/controller/form_new_patient_controller.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_patient/controller/state/form_new_patient_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNewPatientPage extends StatelessWidget {
  final VoidCallback onFinish;
  final int idDoctor;

  const CreateNewPatientPage(
      {super.key, required this.onFinish, required this.idDoctor});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormNewPatientController(const FormNewPatientState(),
          sessionController: context.read(),
          accountRepository: Repositories.account, doctorId: idDoctor),
      child: Builder(builder: (context){
        final controller = Provider.of<FormNewPatientController>(
          context,
          listen: true,
        );
        return Container();
      },),
    );
  }
}
