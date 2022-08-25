import 'package:flutter/material.dart';

//////////////////////////// navigator
pop(context) {
  Navigator.pop(context);
}

popalert(context) {
  Navigator.of(context).pop();
}

pushandreplace(context, route) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
    return route;
  }));
}

pushremoveUntil(context, route) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
    return route;
  }), (route) => false);
}

push(context, route) {
  Navigator.push(context, MaterialPageRoute(builder: (_) {
    return route;
  }));
}
