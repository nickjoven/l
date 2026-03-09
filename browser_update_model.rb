# Browser Update Knowledge & Lifecycle Model
#
# Models two things in the style of canon.d's schema primitives:
#   1. Knowledge  — what the update infrastructure knows (5 schemas)
#   2. Lifecycle  — state machine each update traverses
#
# Each schema has identity fields (composite "primary key" in CAS terms)
# and data fields. Identity projection lets topology group machines that
# are attempting the same upgrade even when they write at different times.

# ─── Schemas ─────────────────────────────────────────────────────────────────

SCHEMAS = {
  browser_version: {
    identity: %i[vendor channel version],
    fields:   %i[release_date build_id]
  },
  update_manifest: {
    identity: %i[vendor channel from_version],
    fields:   %i[to_version url signature size_bytes]
  },
  # Each state-machine transition on one machine is one update_event node.
  # Identity: (machine_id, from_version, to_version) — uniquely identifies
  # "this machine attempting this specific upgrade arc."
  update_event: {
    identity: %i[machine_id from_version to_version],
    fields:   %i[event_type status error_code timestamp]
  },
  rollout_policy: {
    identity: %i[vendor channel version],
    fields:   %i[percentage start_time flags]
  },
  feature_flag: {
    identity: %i[vendor version flag_name],
    fields:   %i[enabled rollout_pct]
  }
}.freeze

# ─── Lifecycle ────────────────────────────────────────────────────────────────
#
#  Each arrow is an update_event record (event_type carries the label).
#
#  available
#      │ download_started
#      ▼
#  downloading ──── download_failed ──► available  (retry)
#      │ download_verified
#      ▼
#  verified
#      │ stage_requested  (gated by rollout_policy.percentage)
#      ▼
#  staged
#      │ apply_started  (triggered on browser restart / idle threshold)
#      ▼
#  applying
#      │ apply_succeeded
#      ▼
#  active ──── crash_loop / regression ──► rollback_initiated
#                                               │ rollback_completed
#                                               ▼
#                                           reverted

TRANSITIONS = %w[
  download_started
  download_failed
  download_verified
  stage_requested
  apply_started
  apply_succeeded
  rollback_initiated
  rollback_completed
].freeze

TERMINAL_STATES = %w[active reverted].freeze

# ─── Topology reads (what canon.d sees across a fleet) ──────────────────────
#
# convergent_clusters:
#   Group update_event nodes by identity projection of (from_version, to_version).
#   Cluster size ≈ number of machines attempting the same upgrade arc.
#   Large cluster = broad rollout. Absent clusters = stuck / enterprise-pinned.
#
# schema_co_occurrences:
#   rollout_policy always precedes stage_requested events in lineage chains.
#   This structural pattern is enforced by the DAG, not convention.
#
# outliers:
#   Machines whose (from_version, to_version) identity doesn't appear in
#   any convergent cluster — different base version, pinned build, etc.

module TopologyReads
  def self.convergent_clusters(events)
    events.group_by { |e| [e[:from_version], e[:to_version]] }
  end

  def self.outliers(events, min_cluster_size: 2)
    clusters = convergent_clusters(events)
    clusters.select { |_, members| members.size < min_cluster_size }.values.flatten
  end
end

# ─── Demo ────────────────────────────────────────────────────────────────────

if __FILE__ == $PROGRAM_NAME
  fleet_events = [
    { machine_id: "m-001", from_version: "123.0", to_version: "124.0",
      event_type: "download_verified", status: "ok" },
    { machine_id: "m-002", from_version: "123.0", to_version: "124.0",
      event_type: "download_verified", status: "ok" },
    { machine_id: "m-003", from_version: "123.0", to_version: "124.0",
      event_type: "apply_succeeded",   status: "ok" },
    # outlier: different base version — not in the main cluster
    { machine_id: "m-999", from_version: "122.0", to_version: "124.0",
      event_type: "download_verified", status: "ok" }
  ]

  clusters = TopologyReads.convergent_clusters(fleet_events)
  puts "Convergent clusters:"
  clusters.each do |(from, to), members|
    puts "  #{from} → #{to}: #{members.size} machine(s)"
  end

  puts "\nOutliers (not in majority arc):"
  TopologyReads.outliers(fleet_events).each do |e|
    puts "  #{e[:machine_id]} (#{e[:from_version]} → #{e[:to_version]})"
  end

  puts "\nLifecycle transitions:"
  TRANSITIONS.each { |t| puts "  #{t}" }
end
