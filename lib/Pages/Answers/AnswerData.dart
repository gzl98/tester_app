import 'package:flutter/material.dart';
import 'package:tester_app/Pages/Answers/QuestionAnswerPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Rules.dart';
import 'package:tester_app/Utils/Utils.dart';


class Answer {
  final int id;
  final String username;
  final int sex;
  final String age;
  final DateTime time;
  bool isSelected = false;

  Answer(this.id, this.username, this.sex, this.age, this.time);
  getTimeStr() {
    String res = this.time.toString();
    return res.substring(0, res.length - 4);
  }
}

class AnswerTable extends DataTableSource {
  List<Answer> _answers = <Answer>[];

  int _selectCount = 0;
  bool _isRowCountApproximate = false;
  int _rowCount = 100;

  void setRowCount(int rowCount) {
    _rowCount = rowCount;
    notifyListeners();
  }

  void addAnswerData(List<Answer> a) {
    for (Answer answer in a) {
      _answers.add(answer);
    }
    notifyListeners();
  }

  void delAnswerQuestionnaire(int id) {
    _answers.removeAt(_answers.indexWhere((element) => element.id == id));
    _rowCount--;
    _selectCount--;
    notifyListeners();
  }

  void selectOne(int index, bool isSelected) {
    Answer answer = _answers[index];
    if (answer.isSelected != isSelected) {
      _selectCount = _selectCount + (isSelected ? 1 : -1);
      answer.isSelected = isSelected;
      notifyListeners();
    }
  }

  void selectAll(bool checked) {
    print("调用selectAll");
    for (Answer answer in _answers) {
      answer.isSelected = checked;
    }
    _selectCount = checked ? _answers.length : 0;
    notifyListeners();
  }

  void _sort<T>(Comparable<T> getField(Answer answer), bool b) {
    _answers.sort((Answer a1, Answer a2) {
      if (!b) {
        final Answer temp = a1;
        a1 = a2;
        a2 = temp;
      }
      final Comparable<T> a1Value = getField(a1);
      final Comparable<T> a2Value = getField(a2);
      return Comparable.compare(a1Value, a2Value);
    });
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    if (index >= _answers.length || index < 0) {
      throw FlutterError('error index');
    } else {
      final Answer answer = _answers[index];
      return DataRow.byIndex(
          cells: <DataCell>[
            DataCell(Text(answer.id.toString())),
            DataCell(Text(answer.username)),
            DataCell(Text(answer.sex == 0 ? '男' : '女')),
            DataCell(Text(answer.age)),
            DataCell(Text(answer.getTimeStr())),
            // DataCell(Text(answer.score)),
            // DataCell(Text(answer.isJudged ? '是' : '否')),
            DataCell(new Row(
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    await StorageUtil.setStringItem('questionnaireId', answer.id.toString());
                    await StorageUtil.setStringItem('testerName', answer.username);
                    await StorageUtil.setStringItem('testerId', answer.id.toString());
                    await StorageUtil.setIntItem('testerSex', answer.sex);
                    //试卷详情的跳转路由
                    await MyRouter.navigatorKey.currentState.pushNamed(QuestionAnswerPage.routerName);
                    //Navigator.pushNamedAndRemoveUntil(context, QuestionAnswerPage.routerName, (router) => false);
                  },
                  child: Text("查看"),
                ),
              ],
            )),
          ],
          selected: answer.isSelected,
          index: index,
          onSelectChanged: (isSelected) {
            selectOne(index, isSelected);
          });
    }
  }

  @override
  bool get isRowCountApproximate => _isRowCountApproximate;

  @override
  int get selectedRowCount => _selectCount;

  @override
  int get rowCount => _rowCount;

  int getRealRowCount() => _answers.length;

  List<int> getSelectedQuestionnaire() {
    List<int> questionnaireId = [];
    for (Answer answer in _answers) {
      if (answer.isSelected) {
        questionnaireId.add(answer.id);
      }
    }
    return questionnaireId;
  }
}

class PaginatedAnswerTable extends StatefulWidget {
  PaginatedAnswerTable({Key key}) : super(key: key);

  @override
  _PaginatedAnswerTableState createState() => new _PaginatedAnswerTableState();
}

class _PaginatedAnswerTableState extends State<PaginatedAnswerTable> {
  int _defaultRowPageCount = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = false;
  AnswerTable table = AnswerTable();
  String warningText = '正在删除，请等待删除完成。';
  var dialogContext;

  @override
  void initState() {
    super.initState();
    List<Answer> answers = [];
    table.addAnswerData(answers);
    table._rowCount = 0;
    getAnswers();
  }

  void getAnswers() async {
    var data = await getAnswerList();
    List<Answer> answers = [];
    for (int i = 0; i < data.length; i++) {
      String time = data[i][1]["create_date"];
      time = time.replaceAll('T', ' ');
      answers.add(Answer(data[i][1]["id"], data[i][0]["username"].toString(), data[i][0]["sex"], data[i][0]["IDcard"].toString(), DateTime.parse(time)));
    }
    table.addAnswerData(answers);
    table.setRowCount(data.length);
    table._sort((answer) => answer.id, false);
  }

  void _sort<T>(Comparable<T> getField(Answer a), int index, bool b) {
    table._sort(getField, b);
    setState(() {
      this._sortColumnIndex = index;
      this._sortAscending = b;
    });
  }

  List<DataColumn> getColumn() {
    return [
      DataColumn(
          label: Text(
            'id',
          ),
          onSort: (i, b) {
            _sort((Answer a) => a.id, i, b);
          }),
      DataColumn(label: Text('姓名')),
      DataColumn(label: Text('性别')),
      DataColumn(label: Text('身份证号')),
      DataColumn(label: Text('测试时间')),
      DataColumn(label: Text('操作')),
    ];
  }

  showAlertDialog(BuildContext context) {
    //显示对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return AlertDialog(
          title: Text("提示"),
          content: Text(warningText),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        rowsPerPage: _defaultRowPageCount,
        onRowsPerPageChanged: (value) {
          setState(() {
            _defaultRowPageCount = value;
          });
        },
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        initialFirstRowIndex: 0,
        availableRowsPerPage: [5,7,10],
        onPageChanged: (value) {
          //留作以后动态加载数据
          print(value);
        },
        onSelectAll: table.selectAll,
        header: Text('试卷'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.delete),
        //     onPressed: () async {
        //       print(table.getSelectedQuestionnaire());
        //       List<int> questionnaireId = table.getSelectedQuestionnaire();
        //       showAlertDialog(context);
        //       for (int id in questionnaireId) {
        //         if (await delAnswerQuestionnaire(id)) {
        //           table.delAnswerQuestionnaire(id);
        //         }
        //       }
        //       Navigator.pop(dialogContext);
        //     },
        //   ),
        // ],
        columns: getColumn(),
        source: table,
      ),
    );
  }
}
