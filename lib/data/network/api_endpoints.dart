class Api {
  static const users = "/users";
  static const otp = "$users/otp";
  static const verifyOtp = "$users/otp-verify";
  static const signUp = "$users/patient-signup";
  static const signInEmail = "$users/patient-signin-with-email";
  static const patient = '/patients';
  static const profile = '$patient/profile';
  static const patientProfiles = '$patient/patient-profiles';
  static const clinicians = '/clinicians';
  static const clinician = '/clinician';
  static const modeOfConsultation = '/mode-of-consultation';
  static const clinicianTimeSlot = '/clinician-time-slot';
  static const resources = '/resources';
  static const sessions = '/sessions';
  static const mapAutoComplete = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const mapDecodePlace = 'https://maps.googleapis.com/maps/api/place/details/json';
  static const addresses = '/addresses';
  static const patientSessions = '/patient-sessions';
  static const updateSession = '$sessions/update-session-status';
  static const meeting = '/sessions/meeting';
}