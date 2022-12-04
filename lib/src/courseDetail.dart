import 'package:danim/src/attractionFix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:danim/src/preset.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'date_selectlist.dart';
import 'loading.dart';
import 'package:danim/src/app.dart';

class CourseDetail extends StatefulWidget {
  //const CourseDetail({super.key});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  int transit = 0; //초기값은 자차이용

  String str = '';

  void setState(VoidCallback fn) {
    str += "in SetState\n";
    super.setState(fn);
  }

  static Color getColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed) ||
        states.contains(MaterialState.focused)) {
      return Colors.lightBlue;
    }
    if (states.contains(MaterialState.focused)) {
      return Colors.lightBlue;
    } else
      return Colors.white;
  }

  //List<MaterialStateProperty<Color>> backgrouneColorList = List.generate(28, (MaterialStateProperty.resolveWith(getColor)) => []);
  List<MaterialStateProperty<Color>> backgrouneColorList = [
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
  ];

  void switchBackgroundColor(int index, int type) {
    if (type == 1) {
      setState(() {
        backgrouneColorList[index] = MaterialStateProperty.resolveWith(
            (states) => Color.fromARGB(255, 78, 194, 252));
      });
    } else if (type == 0) {
      setState(() {
        backgrouneColorList[index] =
            MaterialStateProperty.resolveWith(getColor);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      //     TextButton(
      //         onPressed: () {
      //           Navigator.popUntil(context, (route) => route.isFirst);
      //         },
      //         child: Image.asset(IconsPath.house,
      //             fit: BoxFit.contain, height: 40,ght: 20))
      //   ]),
      // ),
      appBar: AppBar(
        title: Center(
            child: Text('여행 성향(2/4)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        actions: [
          //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
          //이곳에 한개 이상의 위젯들을 가진다.

          // TextButton(
          //     onPressed: () {
          //       //Navigator.popUntil(context, (route) => route.isFirst);
          //       //첫화면까지 팝해버리는거임
          //     },
          //     child: Image.asset(
          //       IconsPath.count2,
          //       fit: BoxFit.contain,
          //       width: 60,
          //       height: 40,
          //     )),
          IconButton(
            icon: Icon(Icons.home),
            tooltip: 'Hi!',
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              //첫화면까지 팝해버리는거임
            },
          ),
          // TextButton(
          //     onPressed: () {
          //       Navigator.popUntil(context, (route) => route.isFirst);
          //       //첫화면까지 팝해버리는거임
          //     },
          //     child: Image.asset(
          //       IconsPath.house,
          //       fit: BoxFit.contain,
          //       height: 20,
          //     )),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('이번 여행, 어떤 교통수단을 이용하세요?',
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontFamily: "Neo",
                            fontWeight: FontWeight.bold,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      child: Text('자차',
                                          style: TextStyle(
                                            fontFamily: "Neo",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 13,
                                          )),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              backgrouneColorList[0]),
                                      onPressed: () => {
                                            transit = 0,
                                            print(transit),
                                            setState(() {
                                              switchBackgroundColor(0, 1);
                                              switchBackgroundColor(1, 0);
                                            })
                                          }),
                                ),
                                // MaterialStatePropertyColor.fromARGB(255, 78, 194, 252)]
                                SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                      child: Text('대중교통',
                                          style: TextStyle(
                                            fontFamily: "Neo",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 13,
                                          )),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              backgrouneColorList[1]),
                                      onPressed: () => {
                                            transit = 1,
                                            print(transit),
                                            setState(() {
                                              switchBackgroundColor(1, 1);
                                              switchBackgroundColor(0, 0);
                                            })
                                          }),
                                )
                              ])),
                      SizedBox(
                        height: 40,
                      ),
                      Text('이번 여행, 누구와 떠나시나요?',
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontFamily: "Neo",
                            fontWeight: FontWeight.bold,
                          )),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Column(children: [
                          Row(children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                  child: Text('혼자여행',
                                      style: TextStyle(
                                        fontFamily: "Neo",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                  style: ButtonStyle(
                                      backgroundColor: backgrouneColorList[2]),
                                  onPressed: () => {
                                        if (selectedList[0][0] == 0)
                                          {
                                            selectedList[0][0] = 1,
                                            setState(() {
                                              switchBackgroundColor(2, 1);
                                            })
                                          }
                                        else
                                          {
                                            selectedList[0][0] = 0,
                                            setState(() {
                                              switchBackgroundColor(2, 0);
                                            })
                                          },
                                        print(selectedList[0][0])
                                      }),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                  child: Text('커플여행',
                                      style: TextStyle(
                                        fontFamily: "Neo",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                  style: ButtonStyle(
                                      backgroundColor: backgrouneColorList[3]),
                                  onPressed: () => {
                                        if (selectedList[0][1] == 0)
                                          {
                                            selectedList[0][1] = 1,
                                            setState(() {
                                              switchBackgroundColor(3, 1);
                                            })
                                          }
                                        else
                                          {
                                            selectedList[0][1] = 0,
                                            setState(() {
                                              switchBackgroundColor(3, 0);
                                            })
                                          },
                                        print(selectedList[0][1])
                                      }),
                            ),
                          ]),
                          Row(children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                  child: Text('우정여행',
                                      style: TextStyle(
                                        fontFamily: "Neo",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                  style: ButtonStyle(
                                      backgroundColor: backgrouneColorList[4]),
                                  onPressed: () => {
                                        if (selectedList[0][2] == 0)
                                          {
                                            selectedList[0][2] = 1,
                                            setState(() {
                                              switchBackgroundColor(4, 1);
                                            })
                                          }
                                        else
                                          {
                                            selectedList[0][2] = 0,
                                            setState(() {
                                              switchBackgroundColor(4, 0);
                                            })
                                          },
                                        print(selectedList[0][2])
                                      }),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                  child: Text('가족여행',
                                      style: TextStyle(
                                        fontFamily: "Neo",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                  style: ButtonStyle(
                                      backgroundColor: backgrouneColorList[5]),
                                  onPressed: () => {
                                        if (selectedList[0][3] == 0)
                                          {
                                            selectedList[0][3] = 1,
                                            setState(() {
                                              switchBackgroundColor(5, 1);
                                            })
                                          }
                                        else
                                          {
                                            selectedList[0][3] = 0,
                                            setState(() {
                                              switchBackgroundColor(5, 0);
                                            })
                                          },
                                        print(selectedList[0][3])
                                      }),
                            ),
                          ]),
                          Row(children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                  child: Text('효도여행',
                                      style: TextStyle(
                                        fontFamily: "Neo",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                  style: ButtonStyle(
                                      backgroundColor: backgrouneColorList[6]),
                                  onPressed: () => {
                                        if (selectedList[0][4] == 0)
                                          {
                                            selectedList[0][4] = 1,
                                            setState(() {
                                              switchBackgroundColor(6, 1);
                                            })
                                          }
                                        else
                                          {
                                            selectedList[0][4] = 0,
                                            setState(() {
                                              switchBackgroundColor(6, 0);
                                            })
                                          },
                                        print(selectedList[0][4])
                                      }),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                  child: Text('어린자녀와',
                                      style: TextStyle(
                                        fontFamily: "Neo",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                  style: ButtonStyle(
                                      backgroundColor: backgrouneColorList[7]),
                                  onPressed: () => {
                                        if (selectedList[0][5] == 0)
                                          {
                                            selectedList[0][5] = 1,
                                            setState(() {
                                              switchBackgroundColor(7, 1);
                                            })
                                          }
                                        else
                                          {
                                            selectedList[0][5] = 0,
                                            setState(() {
                                              switchBackgroundColor(7, 0);
                                            })
                                          },
                                        print(selectedList[0][5])
                                      }),
                            ),
                          ]),
                          Row(children: <Widget>[
                            Expanded(
                                child: ElevatedButton(
                                    child: Text('반려견과',
                                        style: TextStyle(
                                          fontFamily: "Neo",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 13,
                                        )),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            backgrouneColorList[8]),
                                    onPressed: () => {
                                          if (selectedList[0][6] == 0)
                                            {
                                              selectedList[0][6] = 1,
                                              setState(() {
                                                switchBackgroundColor(8, 1);
                                              })
                                            }
                                          else
                                            {
                                              selectedList[0][6] = 0,
                                              setState(() {
                                                switchBackgroundColor(8, 0);
                                              })
                                            },
                                          print(selectedList[0][6])
                                        })),
                            SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(width: 10),
                            )
                          ]),
                        ]),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text('이번 여행의 테마는 무엇인가요?',
                              style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 2.0,
                                fontSize: 15.0,
                                fontFamily: "Neo",
                                fontWeight: FontWeight.bold,
                              ))),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          child: Text('힐링',
                                              style: TextStyle(
                                                fontFamily: "Neo",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13,
                                              )),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  backgrouneColorList[9]),
                                          onPressed: () => {
                                                if (selectedList[1][0] == 0)
                                                  {
                                                    selectedList[1][0] = 1,
                                                    setState(() {
                                                      switchBackgroundColor(
                                                          9, 1);
                                                    })
                                                  }
                                                else
                                                  {
                                                    selectedList[1][0] = 0,
                                                    setState(() {
                                                      switchBackgroundColor(
                                                          9, 0);
                                                    })
                                                  },
                                                print(selectedList[1][0])
                                              }),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                          child: Text('액티비티',
                                              style: TextStyle(
                                                fontFamily: "Neo",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13,
                                              )),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  backgrouneColorList[10]),
                                          onPressed: () => {
                                                if (selectedList[1][1] == 0)
                                                  {
                                                    selectedList[1][1] = 1,
                                                    setState(() {
                                                      switchBackgroundColor(
                                                          10, 1);
                                                    })
                                                  }
                                                else
                                                  {
                                                    selectedList[1][1] = 0,
                                                    setState(() {
                                                      switchBackgroundColor(
                                                          10, 0);
                                                    })
                                                  },
                                                print(selectedList[1][1])
                                              }),
                                    ),
                                  ]),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        child: Text('배움이 있는',
                                            style: TextStyle(
                                              fontFamily: "Neo",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 13,
                                            )),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                backgrouneColorList[11]),
                                        onPressed: () => {
                                              if (selectedList[1][2] == 0)
                                                {
                                                  selectedList[1][2] = 1,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        11, 1);
                                                  })
                                                }
                                              else
                                                {
                                                  selectedList[1][2] = 0,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        11, 0);
                                                  })
                                                },
                                              print(selectedList[1][2])
                                            }),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                        child: Text('맛있는',
                                            style: TextStyle(
                                              fontFamily: "Neo",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 13,
                                            )),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                backgrouneColorList[12]),
                                        onPressed: () => {
                                              if (selectedList[1][3] == 0)
                                                {
                                                  selectedList[1][3] = 1,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        12, 1);
                                                  })
                                                }
                                              else
                                                {
                                                  selectedList[1][3] = 0,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        12, 0);
                                                  })
                                                },
                                              print(selectedList[1][3])
                                            }),
                                  )
                                ],
                              )
                            ],
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text('이번 여행에서 어떤 것들을 하고 싶으세요?',
                              style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 2.0,
                                fontFamily: "Neo",
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ))),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        child: Text('레저스포츠',
                                            style: TextStyle(
                                                fontFamily: "Neo",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                backgrouneColorList[13]),
                                        onPressed: () => {
                                              if (selectedList[2][0] == 0)
                                                {
                                                  selectedList[2][0] = 1,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        13, 1);
                                                  })
                                                }
                                              else
                                                {
                                                  selectedList[2][0] = 0,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        13, 0);
                                                  })
                                                },
                                              print(selectedList[2][0])
                                            }),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                        child: Text('문화시설',
                                            style: TextStyle(
                                                fontFamily: "Neo",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                backgrouneColorList[14]),
                                        onPressed: () => {
                                              if (selectedList[2][1] == 0)
                                                {
                                                  selectedList[2][1] = 1,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        14, 1);
                                                  })
                                                }
                                              else
                                                {
                                                  selectedList[2][1] = 0,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        14, 0);
                                                  })
                                                },
                                              print(selectedList[2][1])
                                            }),
                                  ),
                                ]),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      child: Text('사진',
                                          style: TextStyle(
                                              fontFamily: "Neo",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              backgrouneColorList[15]),
                                      onPressed: () => {
                                            if (selectedList[2][2] == 0)
                                              {
                                                selectedList[2][2] = 1,
                                                setState(() {
                                                  switchBackgroundColor(15, 1);
                                                })
                                              }
                                            else
                                              {
                                                selectedList[2][2] = 0,
                                                setState(() {
                                                  switchBackgroundColor(15, 0);
                                                })
                                              },
                                            print(selectedList[2][2])
                                          }),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                      child: Text('이색체험',
                                          style: TextStyle(
                                              fontFamily: "Neo",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              backgrouneColorList[16]),
                                      onPressed: () => {
                                            if (selectedList[2][3] == 0)
                                              {
                                                selectedList[2][3] = 1,
                                                setState(() {
                                                  switchBackgroundColor(16, 1);
                                                })
                                              }
                                            else
                                              {
                                                selectedList[2][3] = 0,
                                                setState(() {
                                                  switchBackgroundColor(16, 0);
                                                })
                                              },
                                            print(selectedList[2][3])
                                          }),
                                ),
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        child: Text('문화체험',
                                            style: TextStyle(
                                                fontFamily: "Neo",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                backgrouneColorList[17]),
                                        onPressed: () => {
                                              if (selectedList[2][4] == 0)
                                                {
                                                  selectedList[2][4] = 1,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        17, 1);
                                                  })
                                                }
                                              else
                                                {
                                                  selectedList[2][4] = 0,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        17, 0);
                                                  })
                                                },
                                              print(selectedList[2][4])
                                            }),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                        child: Text('역사',
                                            style: TextStyle(
                                                fontFamily: "Neo",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                backgrouneColorList[18]),
                                        onPressed: () => {
                                              if (selectedList[2][5] == 0)
                                                {
                                                  selectedList[2][5] = 1,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        18, 1);
                                                  })
                                                }
                                              else
                                                {
                                                  selectedList[2][5] = 0,
                                                  setState(() {
                                                    switchBackgroundColor(
                                                        18, 0);
                                                  })
                                                },
                                              print(selectedList[2][5])
                                            }),
                                  )
                                ])
                          ])),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text('이번 여행, 어떤 곳들을 가고 싶으세요?',
                              style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 2.0,
                                fontFamily: "Neo",
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ))),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    child: Text('바다',
                                        style: TextStyle(
                                          fontFamily: "Neo",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 13,
                                        )),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            backgrouneColorList[19]),
                                    onPressed: () => {
                                          if (selectedList[3][0] == 0)
                                            {
                                              selectedList[3][0] = 1,
                                              setState(() {
                                                switchBackgroundColor(19, 1);
                                              })
                                            }
                                          else
                                            {
                                              selectedList[3][0] = 0,
                                              setState(() {
                                                switchBackgroundColor(19, 0);
                                              })
                                            },
                                          print(selectedList[3][0])
                                        }),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    child: Text('산',
                                        style: TextStyle(
                                          fontFamily: "Neo",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 13,
                                        )),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            backgrouneColorList[20]),
                                    onPressed: () => {
                                          if (selectedList[3][1] == 0)
                                            {
                                              selectedList[3][1] = 1,
                                              setState(() {
                                                switchBackgroundColor(20, 1);
                                              })
                                            }
                                          else
                                            {
                                              selectedList[3][1] = 0,
                                              setState(() {
                                                switchBackgroundColor(20, 0);
                                              })
                                            },
                                          print(selectedList[3][1])
                                        }),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    child: Text('드라이브 코스',
                                        style: TextStyle(
                                          fontFamily: "Neo",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 13,
                                        )),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            backgrouneColorList[21]),
                                    onPressed: () => {
                                          if (selectedList[3][2] == 0)
                                            {
                                              selectedList[3][2] = 1,
                                              setState(() {
                                                switchBackgroundColor(21, 1);
                                              })
                                            }
                                          else
                                            {
                                              selectedList[3][2] = 0,
                                              setState(() {
                                                switchBackgroundColor(21, 0);
                                              })
                                            },
                                          print(selectedList[3][2])
                                        }),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    child: Text('산책',
                                        style: TextStyle(
                                          fontFamily: "Neo",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 13,
                                        )),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            backgrouneColorList[22]),
                                    onPressed: () => {
                                          if (selectedList[3][3] == 0)
                                            {
                                              selectedList[3][3] = 1,
                                              setState(() {
                                                switchBackgroundColor(22, 1);
                                              })
                                            }
                                          else
                                            {
                                              selectedList[3][3] = 0,
                                              setState(() {
                                                switchBackgroundColor(22, 0);
                                              })
                                            },
                                          print(selectedList[3][3])
                                        }),
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  child: Text('쇼핑',
                                      style: TextStyle(
                                        fontFamily: "Neo",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                  style: ButtonStyle(
                                      backgroundColor: backgrouneColorList[23]),
                                  onPressed: () => {
                                        if (selectedList[3][4] == 0)
                                          {
                                            selectedList[3][4] = 1,
                                            setState(() {
                                              switchBackgroundColor(23, 1);
                                            })
                                          }
                                        else
                                          {
                                            selectedList[3][4] = 0,
                                            setState(() {
                                              switchBackgroundColor(23, 0);
                                            })
                                          },
                                        print(selectedList[3][4])
                                      }),
                              SizedBox(width: 10),
                              ElevatedButton(
                                  child: Text('실내여행지',
                                      style: TextStyle(
                                        fontFamily: "Neo",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                  style: ButtonStyle(
                                      backgroundColor: backgrouneColorList[24]),
                                  onPressed: () => {
                                        if (selectedList[3][5] == 0)
                                          {
                                            selectedList[3][5] = 1,
                                            setState(() {
                                              switchBackgroundColor(24, 1);
                                            })
                                          }
                                        else
                                          {
                                            selectedList[3][5] = 0,
                                            setState(() {
                                              switchBackgroundColor(24, 0);
                                            })
                                          },
                                        print(selectedList[3][5])
                                      }),
                              SizedBox(width: 10),
                              ElevatedButton(
                                  child: Text('시티투어',
                                      style: TextStyle(
                                        fontFamily: "Neo",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                  style: ButtonStyle(
                                      backgroundColor: backgrouneColorList[25]),
                                  onPressed: () => {
                                        if (selectedList[3][6] == 0)
                                          {
                                            selectedList[3][6] = 1,
                                            setState(() {
                                              switchBackgroundColor(25, 1);
                                            })
                                          }
                                        else
                                          {
                                            selectedList[3][6] = 0,
                                            setState(() {
                                              switchBackgroundColor(25, 0);
                                            })
                                          },
                                        print(selectedList[3][6])
                                      }),
                            ],
                          ),
                        ]),
                      ),

                      // Row(
                      //   children: [
                      //     ElevatedButton(
                      //         child: Text('지역축제',
                      //             style: TextStyle(
                      //                 fontFamily: "Neo",
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black)),
                      //         style: ButtonStyle(
                      //             backgroundColor:
                      //                 MaterialStateProperty.resolveWith(
                      //                     getColor)),
                      //         onPressed: () => {
                      //               if (selectedList[3][7] == 0)
                      //                 {selectedList[3][7] = 1}
                      //               else
                      //                 {selectedList[3][7] = 0},
                      //               print(selectedList[3][7])
                      //             }),
                      //     ElevatedButton(
                      //         child: Text('전통한옥',
                      //             style: TextStyle(
                      //                 fontFamily: "Neo",
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black)),
                      //         style: ButtonStyle(
                      //             backgroundColor:
                      //                 MaterialStateProperty.resolveWith(
                      //                     getColor)),
                      //         onPressed: () => {
                      //               if (selectedList[3][8] == 0)
                      //                 {selectedList[3][8] = 1}
                      //               else
                      //                 {selectedList[3][8] = 0},
                      //               print(selectedList[3][8])
                      //             })
                      //   ],
                      // ),
                    ])),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    height: 60,
                  ),
                ),
                // Container(
                //     width: 120.0,
                //     height: 70,
                //     padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                //     margin: EdgeInsets.only(bottom: 20),
                //     child: ElevatedButton(
                //         onPressed: () {
                //           //selectedList 업데이트 됐는지 출력
                //           print("selectedList: $selectedList");

                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) =>
                //                       AttractionFix(transit)));
                //         },
                //         // style: ElevatedButton.styleFrom(
                //         //   backgroundColor: Color.fromARGB(255, 78, 194, 252),
                //         // ),
                //         child: Text(
                //           '다음 단계',
                //           style: TextStyle(
                //             fontFamily: "Neo",
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ))),
              ],
            )),
      ),
      bottomSheet: (true)
          ? GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AttractionFix(transit)));
              },
              child: Container(
                width: Get.width,
                height: 60,
                color: Color.fromARGB(255, 102, 202, 252),
                child: const Center(
                  child: Text(
                    '다음 단계',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: "Neo",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              width: Get.width,
              height: 60,
              color: Color(0xffE9E9E9),
              child: const Center(
                child: Text(
                  '다음',
                  style: TextStyle(color: Color(0xffB0B0B0), fontSize: 16),
                ),
              ),
            ),
    );
  }
}
