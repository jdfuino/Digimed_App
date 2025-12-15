import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_history.freezed.dart';
part 'medical_history.g.dart';

@freezed
class MedicalHistory with _$MedicalHistory{
  const factory MedicalHistory({
    @JsonKey(name: 'HasCardiovacularProblems')
    bool? hasCardiovascularProblems,
    @JsonKey(name: 'HasCancerProblems')
    bool? hasCancerProblems,
    @JsonKey(name: 'HasDiabeticsProblems')
    bool? hasDiabeticsProblems,
    @JsonKey(name: 'HasObesityProblems')
    bool? hasObesityProblems,
    @JsonKey(name: 'HasRespiratoryProblems')
    bool? hasRespiratoryProblems,
    @JsonKey(name: 'HasMentalProblems')
    bool? hasMentalProblems,
    @JsonKey(name: 'HasFrequentFluProblems')
    bool? hasFrequentFluProblems,
    @JsonKey(name: 'HaveRelativesCardiovascularProblems')
    bool? haveRelativesCardiovascularProblems,
    @JsonKey(name: 'HaveRelativesCancerProblems')
    bool? haveRelativesCancerProblems,
    @JsonKey(name: 'HaveRelativesDiabeticsProblems')
    bool? haveRelativesDiabeticsProblems,
    @JsonKey(name: 'HaveRelativesObesityProblems')
    bool? haveRelativesObesityProblems,
    @JsonKey(name: 'HaveRelativesRespiratoryProblems')
    bool? haveRelativesRespiratoryProblems,
    @JsonKey(name: 'HaveRelativesMentalProblems')
    bool? haveRelativesMentalProblems,
    @JsonKey(name: 'HasDrinkingHabit')
    bool? hasDrinkingHabit,
    @JsonKey(name: 'HasSmokingHabit')
    bool? hasSmokingHabit,
    @JsonKey(name: 'HasDrinkingCaffeineHabit')
    bool? hasDrinkingCaffeineHabit,
    @JsonKey(name: 'HasMedication')
    bool? hasMedication,
    @JsonKey(name: 'HasFitnessHabit')
    bool? hasFitnessHabit,
    @JsonKey(name: 'HasEatingAfterHoursHabit')
    bool? hasEatingAfterHoursHabit,
    @JsonKey(name: 'ConsumeCannedFood')
    bool? consumeCannedFood,
    @JsonKey(name: 'ConsumeSugaryFood')
    bool? consumeSugaryFood,
    @JsonKey(name: 'ConsumeSaturedFood')
    bool? consumeSaturedFood,
    @JsonKey(name: 'ConsumeHighlySeasonedFoods')
    bool? consumeHighlySeasonedFoods,
    @JsonKey(name: 'ConsumePreparedFoods')
    bool? consumePreparedFoods,
    @JsonKey(name: 'SatisfiedWithJob')
    bool? satisfiedWithJob,
    @JsonKey(name: 'HavePersonalGoals')
    bool? havePersonalGoals,
    @JsonKey(name: 'HaveAccessEssentialService')
    bool? haveAccessEssentialService,
    @JsonKey(name: 'HaveProperties')
    bool? haveProperties,
    @JsonKey(name: 'HaveProblemEnviromentalContamination')
    bool? haveProblemEnviromentalContamination
}) =_MedicalHistory;

  const MedicalHistory._();

  factory MedicalHistory.fromJson(Map<String, dynamic> json)
  => _$MedicalHistoryFromJson(json);

}