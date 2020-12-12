import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movies/bloc/person_bloc.dart';
import 'package:movies/model/person.dart';
import 'package:movies/model/person_response.dart';
import 'package:movies/utils/theme.dart' as Style;

class Persons extends StatefulWidget {
  @override
  _PersonsState createState() => _PersonsState();
}

class _PersonsState extends State<Persons> {
  @override
  void initState() {
    super.initState();
    personBloc..getPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 20.0),
          child: Text(
            'Trending People',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 5.0),
        StreamBuilder<PersonResponse>(
          stream: personBloc.subject.stream,
          builder: (context, AsyncSnapshot<PersonResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return buildErrorWidget(snapshot.data.error);
              }
              return buildPersonWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return buildErrorWidget(snapshot.error);
            } else {
              buildLoadingWidget();
            }
            return SizedBox();
          },
        )
      ],
    );
  }

  Widget buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: SpinKitFadingCircle(
              size: 40.0,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error: $error"),
        ],
      ),
    );
  }

  Widget buildPersonWidget(PersonResponse data) {
    List<Person> persons = data.person;
    return Container(
      height: 120.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: persons.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.only(top: 10.0, right: 8.0, left:10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                persons[index].profileImg == null
                    ? Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Icon(Icons.error)),
                      )
                    : Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://image.tmdb.org/t/p/w200" +
                                  persons[index].profileImg,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                SizedBox(height: 3.0),
                Text(
                  persons[index].name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  "Trending for ${persons[index].known}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Style.Colors.secondColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 8.0,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
