import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/banner_contract_admin.dart';
import 'package:digimed/app/presentation/global/widgets/banner_contract_doctor.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/routes/routes.dart';
import 'package:flutter/material.dart';

class ContractAdminPage extends StatelessWidget {
  const ContractAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              BannerContractAdmin(),
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
    // final SessionController sessionController = context.read();
    // final AccountRepository accountRepository = Repositories.account;
    //
    // final result = await accountRepository
    //     .acceptContractPatient(sessionController.patients!.patientID);
    //
    // result.when(left: (failed){
    //   failed.maybeWhen(tokenInvalided: (){
    //     showToast("Sesion expirada");
    //     sessionController.globalCloseSession();
    //   }, orElse: (){});
    // },
    //     right: (_){
    Navigator.pushReplacementNamed(
      context,
      Routes.welcome,
    );
    //     });

  }
}
