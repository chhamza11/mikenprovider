enum FormStatus {
  pure,
  valid,
  invalid,
  submissionInProgress,
  submissionSuccess,
  submissionFailure;

  bool get isPure => this == FormStatus.pure;
  bool get isValid => this == FormStatus.valid;
  bool get isInvalid => this == FormStatus.invalid;
  bool get isValidated => this == FormStatus.valid;
  bool get isSubmissionInProgress => this == FormStatus.submissionInProgress;
  bool get isSubmissionSuccess => this == FormStatus.submissionSuccess;
  bool get isSubmissionFailure => this == FormStatus.submissionFailure;
}
