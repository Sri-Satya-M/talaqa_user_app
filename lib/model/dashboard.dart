class Dashboard {
  Dashboard({
    this.sessionDetails,
    this.modeOfConsultation,
    this.rating,
    this.totalPatients,
    this.totalReports,
    this.sessionInfo,
  });

  SessionDetails? sessionDetails;
  ModeOfConsultation? modeOfConsultation;
  Rating? rating;
  int? totalPatients;
  int? totalReports;
  SessionInfo? sessionInfo;

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
    sessionDetails:json["sessionDetails"]==null?null: SessionDetails.fromJson(json["sessionDetails"]),
    modeOfConsultation:json["modeOfConsultation"]==null?null: ModeOfConsultation.fromJson(json["modeOfConsultation"]),
    rating:json["rating"]==null?null: Rating.fromJson(json["rating"]),
    totalPatients:json["totalPatients"]==null?null: json["totalPatients"],
    totalReports:json["totalReports"]==null?null: json["totalReports"],
    sessionInfo:json["sessionInfo"]==null?null: SessionInfo.fromJson(json["sessionInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "sessionDetails": sessionDetails?.toJson(),
    "modeOfConsultation": modeOfConsultation?.toJson(),
    "rating": rating?.toJson(),
    "totalPatients": totalPatients,
    "totalReports": totalReports,
    "sessionInfo": sessionInfo?.toJson(),
  };
}

class ModeOfConsultation {
  ModeOfConsultation({
    this.audio,
    this.video,
    this.home,
  });

  int? audio;
  int? video;
  int? home;

  factory ModeOfConsultation.fromJson(Map<String, dynamic> json) => ModeOfConsultation(
    audio: json["AUDIO"]==null?null:json["AUDIO"],
    video: json["VIDEO"]==null?null:json["VIDEO"],
    home: json["HOME"]==null?null:json["HOME"],
  );

  Map<String, dynamic> toJson() => {
    "AUDIO": audio,
    "VIDEO": video,
    "HOME": home,
  };
}

class Rating {
  Rating({
    this.averageRating,
    this.totalReviews,
  });

  int? averageRating;
  int? totalReviews;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    averageRating: json["averageRating"]==null?null:json["averageRating"],
    totalReviews: json["totalReviews"]==null?null:json["totalReviews"],
  );

  Map<String, dynamic> toJson() => {
    "averageRating": averageRating,
    "totalReviews": totalReviews,
  };
}

class SessionDetails {
  SessionDetails({
    this.rejected,
    this.pending,
    this.confirmed,
    this.approved,
    this.paid,
    this.started,
    this.completed,
    this.reportSubmitted,
    this.total,
  });

  int? rejected;
  int? pending;
  int? confirmed;
  int? approved;
  int? paid;
  int? started;
  int? completed;
  int? reportSubmitted;
  int? total;

  factory SessionDetails.fromJson(Map<String, dynamic> json) => SessionDetails(
    rejected: json["rejected"] == null ? null :json["rejected"],
    pending: json["pending"] == null ? null :json["pending"],
    confirmed: json["confirmed"] == null ? null :json["confirmed"],
    approved: json["approved"] == null ? null :json["approved"],
    paid: json["paid"] == null ? null :json["paid"],
    started: json["started"] == null ? null :json["started"],
    completed: json["completed"] == null ? null :json["completed"],
    reportSubmitted: json["reportSubmitted"] == null ? null :json["reportSubmitted"],
    total: json["total"] == null ? null :json["total"],
  );

  Map<String, dynamic> toJson() => {
    "rejected": rejected,
    "pending": pending,
    "confirmed": confirmed,
    "approved": approved,
    "paid": paid,
    "started": started,
    "completed": completed,
    "reportSubmitted": reportSubmitted,
    "total": total,
  };
}


class SessionInfo {
  SessionInfo({
    this.duration,
    this.totalAmount,
    this.totalReports,
  });

  int? duration;
  int? totalAmount;
  int? totalReports;

  factory SessionInfo.fromJson(Map<String, dynamic> json) => SessionInfo(
    duration: json["duration"]==null? null : json["duration"],
    totalAmount: json["totalAmount"]==null? null : json["totalAmount"],
    totalReports: json["totalReports"]==null? null : json["totalReports"],
  );

  Map<String, dynamic> toJson() => {
    "duration": duration,
    "totalAmount": totalAmount,
    "totalReports": totalReports,
  };
}