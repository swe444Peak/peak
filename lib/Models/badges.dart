class Badge {

  String name;
  String description;
  int goal;
  int counter;
  bool status;
  List<DateTime> dates;

  Badge({this.name, this.description, this.goal, this.counter, this.status, this.dates});

  static Badge fromJson(Map<String, dynamic> map){
    return Badge(
      name: map["name"],
      description: map["description"],
      goal: map["goal"],
      counter: map["counter"],
      status: map["status"],
      dates: (map["dates"] != null)? fromTimeStamp(map["dates"]) : [],
      );
  }

  Map<String, dynamic> toMap(){
    return {
      "name": this.name,
      "description": this.description,
      "goal": this.goal,
      "counter": this.counter,
      "status": this.status,
      "dates": this.dates,
    };
  }

  bool updateStatus({bool increment=true, int amount=1}){ //updates the status and return if bool needs update
    if(!increment && isDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) && !status){
      counter -= amount;
      dates.remove(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
      return true;
    }
    if(!status){
      counter += amount;
      dates.add(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
      if(goal == counter)
        status = true;
      return true;
    }

    return false;
  }

  bool isDate(DateTime date){
    bool isDate = false;
    if(dates.isNotEmpty){
      dates.forEach((listDate) {
        if((date.year==listDate.year) && (date.month==listDate.month) && (date.day==listDate.day)){
          isDate = true;
          return;
          }
       });
    }
    return isDate;
  }

  static List<DateTime> fromTimeStamp(List stampDates){
    List<DateTime> dates = [];
    if(stampDates.isNotEmpty){
      stampDates.forEach((date) {
        dates.add(date.toDate());
       });
    }
    return dates;
  }

}