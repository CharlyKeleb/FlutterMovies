import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movies/bloc/now_playing_bloc.dart';
import 'package:movies/model/movie.dart';
import 'package:movies/model/movie_response.dart';
import 'package:movies/utils/theme.dart' as Style;

import 'package:page_indicator/page_indicator.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  void initState() {
    super.initState();
    nowPlayingBloc.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return buildErrorWidget(snapshot.data.error);
          }
          return buildNowPlayingWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error);
        } else {
          buildLoadingWidget();
        }
        return SizedBox();
      },
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

  Widget buildNowPlayingWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("No Movies"),
          ],
        ),
      );
    } else {
      return Container(
        height: 220.0,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          indicatorSpace: 5.0,
          padding: EdgeInsets.all(5.0),
          indicatorColor: Style.Colors.titleColor,
          indicatorSelectorColor: Style.Colors.secondColor,
          length: movies.take(5).length,
          shape: IndicatorShape.circle(size: 5.0),
          pageView: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    height: 220.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://image.tmdb.org/t/p/original" +
                              movies[index].backPoster,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Style.Colors.mainColor.withOpacity(1.0),
                          Style.Colors.mainColor.withOpacity(0.0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [
                          0.0,
                          0.9,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30.0,
                    child: Container(
                      width: 250.0,
                      padding: EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movies[index].title,
                            style: TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      );
    }
  }
}
