# Browser Update Knowledge & Lifecycle Model
#
# Pass LANG=formal to get normal output.
# Default: brainrot mode (no cap).

BRAINROT = ENV["LANG"] != "formal"

# ─── Language layer ───────────────────────────────────────────────────────────

VOCAB = {
  formal: {
    schemas:             "Schemas",
    lifecycle:           "Lifecycle transitions",
    topology:            "Topology reads",
    convergent_clusters: "Convergent clusters",
    outliers:            "Outliers (not in majority arc)",
    machine_fmt:         ->(id, from, to) { "  #{id} (#{from} → #{to})" },
    cluster_fmt:         ->(from, to, n)  { "  #{from} → #{to}: #{n} machine(s)" }
  },
  brainrot: {
    schemas:             "ok so here's the lore on these schemas no cap",
    lifecycle:           "the pipeline be like (in order fr)",
    topology:            "what the topology slay reveals bestie",
    convergent_clusters: "squads that are all on the same grind rn",
    outliers:            "these machines said 'i do what i want' 💀",
    machine_fmt:         ->(id, from, to) { "  #{id} said byeee to #{from}, now vibing on #{to}" },
    cluster_fmt:         ->(from, to, n)  { "  #{from} → #{to}: #{n} devices said 'let's go' together" }
  }
}.freeze

def t(key) = VOCAB[BRAINROT ? :brainrot : :formal][key]

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
#      │ apply_started
#      ▼
#  applying
#      │ apply_succeeded
#      ▼
#  active ──── crash_loop ──► rollback_initiated
#                                  │ rollback_completed
#                                  ▼
#                              reverted

TRANSITIONS = {
  formal: %w[
    download_started
    download_failed
    download_verified
    stage_requested
    apply_started
    apply_succeeded
    rollback_initiated
    rollback_completed
  ],
  brainrot: %w[
    bro_started_downloading
    download_flopped_rip
    download_goes_hard_verified
    staging_era_begins
    applying_fr_fr
    we_are_so_back
    rollback_arc_incoming
    back_to_the_old_me
  ]
}.freeze

# ─── Topology reads ───────────────────────────────────────────────────────────

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
      event_type: BRAINROT ? "download_goes_hard_verified" : "download_verified", status: "ok" },
    { machine_id: "m-002", from_version: "123.0", to_version: "124.0",
      event_type: BRAINROT ? "download_goes_hard_verified" : "download_verified", status: "ok" },
    { machine_id: "m-003", from_version: "123.0", to_version: "124.0",
      event_type: BRAINROT ? "we_are_so_back" : "apply_succeeded", status: "ok" },
    { machine_id: "m-999", from_version: "122.0", to_version: "124.0",
      event_type: BRAINROT ? "download_goes_hard_verified" : "download_verified", status: "ok" }
  ]

  puts t(:schemas)
  SCHEMAS.each { |name, _| puts "  #{name}" }

  puts "\n#{t(:lifecycle)}"
  TRANSITIONS[BRAINROT ? :brainrot : :formal].each { |step| puts "  #{step}" }

  clusters = TopologyReads.convergent_clusters(fleet_events)
  puts "\n#{t(:convergent_clusters)}"
  clusters.each do |(from, to), members|
    puts t(:cluster_fmt).call(from, to, members.size)
  end

  puts "\n#{t(:outliers)}"
  TopologyReads.outliers(fleet_events).each do |e|
    puts t(:machine_fmt).call(e[:machine_id], e[:from_version], e[:to_version])
  end
end
