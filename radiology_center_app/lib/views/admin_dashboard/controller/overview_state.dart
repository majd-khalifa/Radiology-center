class OverviewState {
  final bool isLoading;
  final bool isError;

  final int totalDevices;
  final int totalUsers;
  final int totalAppointments;
  final int bookedAppointments;
  final int availableAppointments;

  final int todayAppointments;
  final int weeklyAppointments;

  OverviewState({
    this.isLoading = false,
    this.isError = false,
    this.totalDevices = 0,
    this.totalUsers = 0,
    this.totalAppointments = 0,
    this.bookedAppointments = 0,
    this.availableAppointments = 0,
    this.todayAppointments = 0,
    this.weeklyAppointments = 0,
  });

  OverviewState copyWith({
    bool? isLoading,
    bool? isError,
    int? totalDevices,
    int? totalUsers,
    int? totalAppointments,
    int? bookedAppointments,
    int? availableAppointments,
    int? todayAppointments,
    int? weeklyAppointments,
  }) {
    return OverviewState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      totalDevices: totalDevices ?? this.totalDevices,
      totalUsers: totalUsers ?? this.totalUsers,
      totalAppointments: totalAppointments ?? this.totalAppointments,
      bookedAppointments: bookedAppointments ?? this.bookedAppointments,
      availableAppointments:
          availableAppointments ?? this.availableAppointments,
      todayAppointments: todayAppointments ?? this.todayAppointments,
      weeklyAppointments: weeklyAppointments ?? this.weeklyAppointments,
    );
  }
}
