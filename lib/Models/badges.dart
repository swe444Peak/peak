class Badges {

  String description;
  String badgeURL;
  int goal;
  int counter;
  bool status;

  

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