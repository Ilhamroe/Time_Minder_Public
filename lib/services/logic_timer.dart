import 'package:time_minder/models/list_jobs.dart';

class TimerJobs {
  final String title;
  final String description;
  final int timer;
  final int rest;
  final int interval;

  TimerJobs({
    required this.title,
    required this.description,
    required this.timer,
    required this.rest,
    required this.interval,
  });

  List<ListJobs> getAllMode(
      int inTimeMinutes, int inRestMinutes, int interval) {
    int inTimeSeconds = inTimeMinutes * 60;
    int inRestSeconds = inRestMinutes * 60;
    const timeType = ['FOKUS', 'ISTIRAHAT'];

    int totalDuration = inTimeSeconds + (interval * inRestSeconds);
    int workDuration = inTimeSeconds ~/ (interval + 1);
    int remainingWorkDuration = inTimeSeconds - (workDuration * interval);

    Map<String, int> modeMap = {};
    List<ListJobs> newJobsTimer = [];
    for (int i = 0; i < findIntervalLoop(interval); i++) {
      modeMap['workDuration${i + 1}'] = workDuration;
      modeMap['restDuration${i + 1}'] = inRestSeconds;

      // new logic
      String type = timeType[i % 2];
      int durationInSeconds = type == 'FOKUS' ? workDuration : inRestSeconds;

      newJobsTimer.add(ListJobs(
        title: type,
        description:
            '$type for ${durationInSeconds ~/ 60} minutes and ${durationInSeconds % 60} seconds',
        duration: durationInSeconds,
        type: type,
      ));
    }

    modeMap['workDuration${interval + 1}'] = remainingWorkDuration;
    print(totalDuration);

    return newJobsTimer;
  }

  int findIntervalLoop(int interval) {
    return interval * 2 + 1;
  }
}
