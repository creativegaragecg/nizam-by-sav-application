class AppEndPoints {
  static var baseUrl = '';

  /// Auth
  static String get login => '${baseUrl}auth/login';
  static String get changePass => '${baseUrl}auth/change-password';
  static String get forgotPass => '${baseUrl}auth/password/forgot';

  /// Profile
  static String get profile => '${baseUrl}auth/profile';
  static String get dueAmount => '${baseUrl}due-amount';

  /// Lease
  static String get myLease => '${baseUrl}leases';

  /// Units
  static String get myUnits => '${baseUrl}units';
  static String get tenantDetails => '${baseUrl}auth/tenant/';

  /// Tickets
  static String get tickets => '${baseUrl}tickets';
  static String get createTicket => '${baseUrl}ticket';
  static String get ticketTypes => '${baseUrl}tickets/types';
  static String get agents => '${baseUrl}tickets/agents';
  static String get getTenants => '${baseUrl}get-tenants';
  static String get getOwner => '${baseUrl}get-owners';

  /// Gatepass
  static String get gatePass => '${baseUrl}gate-pass-requests';
  static String get createGatePass => '${baseUrl}gate-pass-request';

  /// Visitor
  static String get visitor => '${baseUrl}visitors';
  static String get addVisitor => '${baseUrl}visitor';

  /// Unpaid bills
  static String get bills => '${baseUrl}bills';

  /// Events
  static String get events => '${baseUrl}events';

  /// Notice board
  static String get noticeBoard => '${baseUrl}notice-board';

  /// Legal notice
  static String get legalNotice => '${baseUrl}legal-notice';

  /// Unit Inspections
  static String get unitInspections => '${baseUrl}unit-inspections';

  /// Violation records
  static String get violationRecords => '${baseUrl}violation-records';

  /// Society Forums
  static String get forums => '${baseUrl}society/forums';
  static String get forumCategories => '${baseUrl}forum-categories';
  static String get forumDetails => '${baseUrl}forum';

  /// Amenities
  static String get amenities => '${baseUrl}amenities';
  static String get availableSlots => '${baseUrl}amenities/available-slots';

  /// Services
  static String get serviceTypes => '${baseUrl}service-types';
  static String get service => '${baseUrl}service-management';

  /// Notifications
  static String get notifications => '${baseUrl}notifications';

  /// Service suspensions
  static String get serviceSuspensions => '${baseUrl}service-suspensions';

  /// Health
  static String get health => '${baseUrl}tenant/health';

  /// Emergency
  static String get emergency => '${baseUrl}emergency';

  /// Owner Payment
  static String get ownerPayment => '${baseUrl}owner/payments';
  static String get book => '${baseUrl}amenities/book';
  static String get acknowledge => '${baseUrl}emergency-acknowledge';
}