class Api {
  static const users = "/users";
  static const otp = "$users/otp";
  static const verifyOtp = "$users/otp-verify";
  static const signUp = "$users/patient-signup";
  static const signInEmail = "$users/patient-signin-with-email";
  static const patients = '/patients';
  static const profile = '$patients/profile';
  static const patientProfiles = '$patients/patient-profiles';
  static const clinicians = '/clinicians';
  static const clinician = '/clinician';
  static const modeOfConsultation = '/mode-of-consultation';
  static const clinicianTimeSlot = '/clinician-time-slot';
  static const resources = '/resources';
  static const sessions = '/sessions';
  static const mapAutoComplete =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const mapDecodePlace =
      'https://maps.googleapis.com/maps/api/place/details/json';
  static const addresses = '/addresses';
  static const updateSession = '$sessions/update-session-status';
  static const meeting = '$sessions/meeting';
  static const payment = '$sessions/payment';
  static const payments = '$sessions/payments';
  static const upload = '/common/upload';
  static const reports = '/reports';
  static const tokens = '/tokens';
  static const feedback = '/feedback';
  static const medicalRecords = '/medical-records';
  static const dashboard = '/dashboard';
  static const patientProfile = '/patientProfile';
  static const symptoms = '/symptoms';
  static const notifications = '/notifications';
  static const reviews = '/reviews';
  static const sessionClinician = '$sessions/update-session-clinician-patient';

}
