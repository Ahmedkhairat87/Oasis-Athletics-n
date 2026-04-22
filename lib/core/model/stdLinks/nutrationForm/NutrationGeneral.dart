class NutrationGeneral {
  NutrationGeneral({
      this.recordID, 
      this.studentID, 
      this.favoriteSnack, 
      this.dislikedFood, 
      this.waterDrink, 
      this.waterCups, 
      this.breakfastHabit, 
      this.bread, 
      this.sugarTeaspoons, 
      this.riceAmount, 
      this.eatBeforeSleep, 
      this.nightEater, 
      this.hungerOrSnack, 
      this.snackTime, 
      this.sleepHours, 
      this.eatingSpeed, 
      this.vegetablesFreq, 
      this.vegetablesDetail, 
      this.fruitsFreq, 
      this.fruitsDetail, 
      this.fruitForm, 
      this.candy, 
      this.cookingWith, 
      this.createdAt, 
      this.updatedAt,});

  NutrationGeneral.fromJson(dynamic json) {
    recordID = json['RecordID'];
    studentID = json['StudentID'];
    favoriteSnack = json['FavoriteSnack'];
    dislikedFood = json['DislikedFood'];
    waterDrink = json['WaterDrink'];
    waterCups = json['WaterCups'];
    breakfastHabit = json['BreakfastHabit'];
    bread = json['Bread'];
    sugarTeaspoons = json['SugarTeaspoons'];
    riceAmount = json['RiceAmount'];
    eatBeforeSleep = json['EatBeforeSleep'];
    nightEater = json['NightEater'];
    hungerOrSnack = json['HungerOrSnack'];
    snackTime = json['SnackTime'];
    sleepHours = json['SleepHours'];
    eatingSpeed = json['EatingSpeed'];
    vegetablesFreq = json['VegetablesFreq'];
    vegetablesDetail = json['VegetablesDetail'];
    fruitsFreq = json['FruitsFreq'];
    fruitsDetail = json['FruitsDetail'];
    fruitForm = json['FruitForm'];
    candy = json['Candy'];
    cookingWith = json['CookingWith'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }
  num? recordID;
  num? studentID;
  String? favoriteSnack;
  String? dislikedFood;
  bool? waterDrink;
  num? waterCups;
  String? breakfastHabit;
  String? bread;
  num? sugarTeaspoons;
  String? riceAmount;
  bool? eatBeforeSleep;
  bool? nightEater;
  String? hungerOrSnack;
  String? snackTime;
  num? sleepHours;
  String? eatingSpeed;
  String? vegetablesFreq;
  String? vegetablesDetail;
  String? fruitsFreq;
  String? fruitsDetail;
  String? fruitForm;
  String? candy;
  String? cookingWith;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RecordID'] = recordID;
    map['StudentID'] = studentID;
    map['FavoriteSnack'] = favoriteSnack;
    map['DislikedFood'] = dislikedFood;
    map['WaterDrink'] = waterDrink;
    map['WaterCups'] = waterCups;
    map['BreakfastHabit'] = breakfastHabit;
    map['Bread'] = bread;
    map['SugarTeaspoons'] = sugarTeaspoons;
    map['RiceAmount'] = riceAmount;
    map['EatBeforeSleep'] = eatBeforeSleep;
    map['NightEater'] = nightEater;
    map['HungerOrSnack'] = hungerOrSnack;
    map['SnackTime'] = snackTime;
    map['SleepHours'] = sleepHours;
    map['EatingSpeed'] = eatingSpeed;
    map['VegetablesFreq'] = vegetablesFreq;
    map['VegetablesDetail'] = vegetablesDetail;
    map['FruitsFreq'] = fruitsFreq;
    map['FruitsDetail'] = fruitsDetail;
    map['FruitForm'] = fruitForm;
    map['Candy'] = candy;
    map['CookingWith'] = cookingWith;
    map['CreatedAt'] = createdAt;
    map['UpdatedAt'] = updatedAt;
    return map;
  }

}