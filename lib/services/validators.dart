class ValidatorsClass {
  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Please enter your email";
    } else if (!RegExp(r'^[a-zA-Z0-9_.-]+@shadhinlab\.com$').hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validateSupervisorEmail(String? value) {
    if (value!.isEmpty) {
      return "Please enter your supervisor email";
    } else if (!RegExp(r'^[a-zA-Z0-9_.-]+@shadhinlab\.com$').hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validateTaskTitle(String? value) {
    if (value!.isEmpty) {
      return "Please Enter Title";
    }
    return null;
  }
String? validateLeaveReason(String? value) {
    if (value!.isEmpty) {
      return "Please Enter your reason";
    }
    return null;
  }
  String? validateSubject(String? value) {
    if (value!.isEmpty) {
      return "Please write subject";
    }
    return null;
  }

  String? validateTaskTime(String? value) {
    if (value == null || value.isEmpty) {
      return "Select Date & Time";
    }
    return null;
  }

  String? validateTaskProject(int? value) {
    if (value == null) {
      return "Please select a project.";
    }
    return null;
  }

  String? validateTaskBoard(int? value) {
    if (value == null) {
      return "Select a board";
    }
    return null;
  }

  String? validateTaskAssign(List<int>? selectedUserIds) {
    if (selectedUserIds == null || selectedUserIds.isEmpty) {
      return "Assign at least one employee.";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Please enter your password";
    } else if (value.length < 6) {
      return "Password length atleast 6 characters";
    }
    return null;
  }

  String? noValidationRequired(String? value) {
    return null;
  }
}
