import 'package:calorica/models/dbModels.dart';
import 'package:calorica/models/diet.dart';
import 'package:calorica/providers/local_providers/dietProvider.dart';
import 'package:calorica/providers/local_providers/userProvider.dart';
import 'package:calorica/utils/dietSelector.dart';

abstract class DietSelector {
  static Future<bool> slectUserDiet() async {
    bool result = true;
    User user = await DBUserProvider.db.getUser();

    DietParams dietParams = selectDiet(user);

    Diet diet = Diet(
      user_id: user.id,
      calory: dietParams.calory,
      fat: dietParams.fat,
      carboh: dietParams.carboh,
      squi: dietParams.squi,
    );

    try {
      await DBDietProvider.db.adddiet(diet);
    } catch (error) {
      result = false;
    }
    return result;
  }
}
