class Todo {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Todo(this._title, this._date, this._priority, [this._description]);
  Todo.withId(this._id, this._title, this._date, this._priority, [this._description]);
  
  int get id => _id;
  int get priority => _priority;
  String get date => _date;
  String get description => _description;
  String get title => _title;

  set title (String novoTitulo) {
    if (novoTitulo.length <= 255) {
      _title = novoTitulo;
    }
  }
  set description (String novaDescricao) {
    if (novaDescricao.length <= 255) {
      _description = novaDescricao;
    }
  }
  set date (String novaData) {
    _date = novaData;
  }
  set priority (int novaPrioridade) {
    if (novaPrioridade >= 0 && novaPrioridade <= 3) {
      _priority = novaPrioridade;
    }
  }

  // Transforma o model num Map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["description"] = _description;
    map["priority"]  = _priority;
    map["date"] = _date;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  // transforma objeto mapeado em Todo
  Todo.fromObject(dynamic o) {
    this._id = o["id"];
    this._title = o["title"];
    this._description = o["description"];
    this._date = o["date"];
    this._priority = o["priority"];
  }
} 