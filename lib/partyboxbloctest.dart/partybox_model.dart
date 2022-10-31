class PartyboxModel {
  final String title;
  final String category;
  final String detail;
  final int donedate;
  final bool completed;
  final String createdby;
  final int numppl;
  final int numjoined;

  PartyboxModel(
      {required this.title,
      required this.category,
      required this.detail,
      required this.completed,
      required this.createdby,
      required this.donedate,
      required this.numjoined,
      required this.numppl});

  factory PartyboxModel.fromJson(Map<String, dynamic> json) {
    return PartyboxModel(
      title: json['title'],
      category: json['category'],
      detail: json['detail'],
      completed: json['completed'],
      createdby: json['createdby'],
      donedate: json['donedate'],
      numjoined: json['numjoined'],
      numppl: json['numppl'],
    );
  }
}
