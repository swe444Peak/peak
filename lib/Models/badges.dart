class Badge {

  String name;
  String description;
  int goal;
  int counter;
  bool status;

  Badge({this.name, this.description, this.goal, this.counter, this.status});

  static Badge fromJson(Map<String, dynamic> map){
    return Badge(
      name: map["name"],
      description: map["description"],
      goal: map["goal"],
      counter: map["counter"],
      status: map["status"]
      );
  }

  Map<String, dynamic> toMap(){
    return {
      "name": this.name,
      "description": this.description,
      "goal": this.goal,
      "counter": this.counter,
      "status": this.status
    };
  }

  bool updateStatus({bool increment=true, int amount=1}){ //updates the status and return the new status if no chane return the same
    if(!increment){
      counter -= amount;
      if(status)
        status = false;
    }
    if(!status){
      counter += amount;
      if(goal == counter)
        status = true;
    }

    return status;
  }

}