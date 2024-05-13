class FilteredSearch {
  final int userNumberSearch;
  final int selectedBenefitType;
  final int selectedRequestStatus;
  final int selectedTimingId;
  final int selectedDepartmentId;
  final bool hasWarningMessage;
  final String searchDateFrom ;
  final String searchDateTo ;


  FilteredSearch(
      {required this.userNumberSearch,
      required this.selectedBenefitType,
      required this.selectedRequestStatus,
      required this.selectedTimingId,
      required this.selectedDepartmentId,
      required this.hasWarningMessage,
      required this.searchDateFrom,
      required this.searchDateTo,

      });
}
