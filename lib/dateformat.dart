String relativeDate(DateTime now, DateTime time) {
  time = time.toLocal();
  Duration duration = now.difference(time);
  if(duration.inMinutes < 60)
    return '${duration.inMinutes}분 전';
  else if(duration.inHours < 24)
    return '${duration.inHours}시간 전';
  else if(duration.inDays < 7) {
    var nowDate = DateTime(now.year, now.month, now.day);
    var timeDate = DateTime(time.year, time.month, time.day);
    duration = nowDate.difference(timeDate);

    return '${duration.inDays}일 전';
  }
  else 
    return '${time.year}년 ${time.month}월 ${time.day}일';
}