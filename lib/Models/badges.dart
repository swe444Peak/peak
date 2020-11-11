class Badge {

  String name;
  String description;
  int goal;
  int counter;
  bool status;
  bool congrate;

  Badge({this.name, this.description, this.goal, this.counter, this.status, this.congrate});

  static Badge fromJson(Map<String, dynamic> map){
    return Badge(
      name: map["name"],
      description: map["description"],
      goal: map["goal"],
      counter: map["counter"],
      status: map["status"],
      //congrate: map["congrate"]
      );
  }

  Map<String, dynamic> toMap(){
    return {
      "name": this.name,
      "description": this.description,
      "goal": this.goal,
      "counter": this.counter,
      "status": this.status,
      //"congrate": this.congrate,
    };
  }

  bool updateStatus({bool increment=true, int amount=1}){ //updates the status and return if bool needs update
    if(!increment){
      counter -= amount;
      if(status)
        status = false;
      return true;
    }
    if(!status){
      counter += amount;
      if(goal == counter)
        status = true;
      return true;
    }

    return false;
  }

}