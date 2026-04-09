// Package launchagents provides a CUE schema for validating chezmoi-managed
// launchd launch agent configuration files (.launchagents/*.yaml).
//
// Reference: https://www.manpagez.com/man/5/launchd.plist/
//
// Validate a file with:
//   cue vet -d '#LaunchAgent' schema.cue chezmoi.wesb.macos-backup.yaml
//
// File-watching keys (WatchPaths, QueueDirectories) are intentionally excluded
package launchagents

// #LaunchAgent defines the schema for a launchd launch agent plist.
// This is a closed definition — unknown fields are rejected.
#LaunchAgent: {
	// Label uniquely identifies the job to launchd.
	// Must start with "chezmoi." to be managed by the chezmoi apply script.
	// Required.
	Label!: =~"^chezmoi\\." | error("must start with 'chezmoi.' prefix")

	// UserName specifies the user to run the job as.
	// Only applicable when launchd is running as root.
	UserName?: string

	// ProgramArguments specifies the command and arguments to execute.
	// The first element is the executable; subsequent elements are arguments.
	// Required if Program is absent.
	ProgramArguments?: [...string]

	// Program specifies the path to the executable.
	// Required if ProgramArguments is absent.
	// If both are provided, Program overrides the first element of ProgramArguments.
	Program?: string

	// EnvironmentVariables sets additional environment variables before running
	// the job. Note: launchd agents do not inherit the user's shell environment,
	// so PATH and other variables must be set explicitly.
	EnvironmentVariables?: {[string]: string}

	// StandardOutPath specifies the file for stdout output.
	// The file is created if it does not exist.
	StandardOutPath?: string

	// StandardErrorPath specifies the file for stderr output.
	// The file is created if it does not exist.
	StandardErrorPath?: string

	// RunAtLoad causes the job to run once immediately when the agent is loaded.
	// Default: false.
	RunAtLoad?: bool

	// StartInterval causes the job to run every N seconds.
	// If the system is asleep when the interval fires, the job runs on next wake.
	// Cannot be combined with StartCalendarInterval.
	StartInterval?: int & >0

	// StartCalendarInterval schedules the job like crontab(5).
	// Can be a single schedule dict or a list of schedule dicts.
	// Omitted fields act as wildcards (e.g., omitting Minute runs every minute).
	// Cannot be combined with StartInterval.
	StartCalendarInterval?: #CalendarInterval | [...#CalendarInterval]

	// ThrottleInterval sets the minimum number of seconds between job spawns.
	// Prevents a crashing job from consuming excessive resources.
	// Default: 10 seconds.
	ThrottleInterval?: int & >=0

	// KeepAlive controls whether the job is kept running continuously.
	// Set to true for simple always-on behavior, or use #KeepAliveConditions
	// for conditional restart logic.
	// Default: false (demand-based / one-shot).
	KeepAlive?: bool | #KeepAliveConditions

	// ProcessType classifies the job for resource scheduling purposes.
	//   Background  — reduced CPU and I/O limits; use for background sync/backup tasks
	//   Standard    — default resource limits
	//   Adaptive    — dynamically adjusts between Background and Interactive based on usage
	//   Interactive — no resource limits; use for user-facing processes
	// Default: Standard.
	ProcessType?: "Background" | "Standard" | "Adaptive" | "Interactive"

	// Disabled hints to launchctl not to submit this job when loading.
	// The job can still be started manually. Default: false.
	Disabled?: bool

	// AbandonProcessGroup prevents launchd from killing the entire process group
	// when the main job process exits. Default: false.
	AbandonProcessGroup?: bool
}

// #CalendarInterval defines a cron-like execution schedule for StartCalendarInterval.
// All fields are optional; omitted fields act as wildcards.
// This is a closed definition — unknown fields are rejected.
#CalendarInterval: {
	// Minute: 0–59. Omit to run every minute.
	Minute?: int & >=0 & <=59

	// Hour: 0–23. Omit to run every hour.
	Hour?: int & >=0 & <=23

	// Day: 1–31 (day of month). Omit to run every day.
	Day?: int & >=1 & <=31

	// Weekday: 0–7, where 0 and 7 both represent Sunday. Omit to run every weekday.
	Weekday?: int & >=0 & <=7

	// Month: 1–12. Omit to run every month.
	Month?: int & >=1 & <=12
}

// #KeepAliveConditions provides fine-grained control over when the job is
// automatically restarted by launchd.
// This is a closed definition — unknown fields are rejected.
#KeepAliveConditions: {
	// SuccessfulExit: if true, restart only when the previous run exited with
	// status 0. If false, restart only when the previous run exited non-zero.
	SuccessfulExit?: bool

	// NetworkState: if true, keep alive only while a network interface is up.
	// If false, keep alive only while all interfaces are down.
	NetworkState?: bool

	// PathState: map of file paths to booleans. Keep alive when each path
	// exists (true) or does not exist (false).
	PathState?: {[string]: bool}

	// OtherJobEnabled: map of job labels to booleans. Keep alive when each
	// referenced job is enabled (true) or disabled (false).
	OtherJobEnabled?: {[string]: bool}
}
