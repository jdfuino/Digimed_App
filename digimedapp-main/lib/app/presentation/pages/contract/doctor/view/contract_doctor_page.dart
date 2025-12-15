import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/widgets/banner_contract.dart';
import 'package:digimed/app/presentation/global/widgets/banner_contract_doctor.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/routes/routes.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContractDoctorPage extends StatelessWidget {
  const ContractDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              BannerContractDoctor(),
              Container(
                margin: const EdgeInsets.only(right: 24, left: 24),
                child: ButtonDigimed(
                    child: Text(
                      "Aceptar",
                      style: AppTextStyle.normalWhiteContentTextStyle,
                    ),
                    onTab: () {
                      _acceptedContract(context);
                    }),
              ),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ));
  }

  void _acceptedContract(BuildContext context) async {
    final SessionController sessionController = context.read();
    final AccountRepository accountRepository = Repositories.account;

    final result = await accountRepository
        .acceptContractDoctor(sessionController.doctor!.idDoctor);

    result.when(left: (failed){
      failed.maybeWhen(tokenInvalided: (){
        showToast("Sesion expirada");
        sessionController.globalCloseSession();
      }, orElse: (){});
    },
        right: (_){
          Navigator.pushReplacementNamed(
            context,
            Routes.welcome,
          );
        });
  }
}