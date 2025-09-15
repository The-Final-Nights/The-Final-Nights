// ================================================================
// RP Management Subsystem Debug Tools (ssroleplay_management_debug.dm)
// ================================================================
// Admin tools for inspecting live RP metadata, including:
// - AboutMe records
// - Group status
// - Relationships, Memories, Chronicles
// ================================================================
/client/verb/ViewCharacterAboutMe()
	set name = "About Me View Character Record"
	set category = "IC"
	if (!GLOB.valid_character_ids.len)
		to_chat(src, "<span class='warning'>No character keys are currently registered.</span>")
		return
	var/list/options = list()
	for (var/key in GLOB.valid_character_ids)
		options += key
	var/key = tgui_input_list(src, list(
		"title" = "Select Character Key",
		"message" = "Which character would you like to inspect?",
		"options" = options
	))
	if (!key || !(key in GLOB.valid_character_ids))
		to_chat(src, "<span class='warning'>That key is not valid or doesn't exist.</span>")
		return
	var/datum/component/about_me/C = SSroleplay_management.find_aboutme_component_by_character_id(key)
	if (!C)
		to_chat(src, "<span class='warning'>No active About Me component is registered for [key]. That character may not be in-round.</span>")
		return
	C.ui_interact(src)


/client/verb/DebugRPManagement()
    set name = "AboutMe System Overview"
    set category = "IC"

    // quick counters
    var/c_aboutme_components = length(GLOB.aboutme_components)
    var/c_aboutme_records    = length(GLOB.aboutme_records)
    var/c_groups             = length(GLOB.groups)
    var/c_canon              = length(GLOB.canonical_groups)
    var/c_relationships      = length(GLOB.relationships)
    var/c_memories           = length(GLOB.memories)
    var/c_chronicles         = length(GLOB.chronicles)
    var/c_chron_entries      = length(GLOB.chronicle_entries)

    // small helpers
    #define NN(X, D) ((isnull(X) || X == "") ? (D) : (X))
    #define SAFE_NUM(X) (isnum(X) ? X : 0)

    var/list/html = list()
    html += "<html><body style='background:#0f1115;color:#e6e6e6;font:13px/1.4 monospace'>"

    // Header
    html += "<div style='font-size:16px;margin:6px 0 10px'><b>=== RP Management — Quick Debug ===</b></div>"
    html += "<div style='color:#9aa4b2;margin-bottom:12px'>"
    html += "records=[c_aboutme_records] • components=[c_aboutme_components] • groups=[c_groups] (canon=[c_canon]) • rels=[c_relationships] • memories=[c_memories] • chronicles=[c_chronicles] • entries=[c_chron_entries]"
    html += "</div>"

    // -------- COMPONENT SNAPSHOTS (concise) --------
    html += "<details open><summary><b>Players</b> (" + num2text(c_aboutme_components) + ")</summary>"
    if (!c_aboutme_components)
        html += "<div style='opacity:.7'>No active AboutMe components.</div>"
    else
        for (var/datum/component/about_me/C in GLOB.aboutme_components)
            var/mob/living/carbon/human/H = C.owner
            if (!H) continue

            var/list/payload = C.get_full_payload(H) || list()

            var/list/overview = payload["overview"] || list()
            var/list/general  = overview["general"] || list()
            var/name   = NN(general["name"], "Unknown")
            var/role   = NN(general["role"], "—")
            var/spec   = NN(general["species"], "—")

            // Groups (only the ones this player actually has)
            var/list/group_section = payload["groups"] || list()
            var/list/group_objs = group_section["group_objects"] || list()
            var/list/g_lines = list()
            for (var/gtype in group_objs)
                var/list/items = group_objs[gtype] || list()
                if (!length(items)) continue
                // collect names
                var/list/names = list()
                for (var/i in 1 to items.len)
                    var/list/GI = items[i]
                    var/gname = NN(GI["name"], "?")
                    names += gname
                g_lines += "<b>[capitalize(gtype)]</b>: " + jointext(names, ", ")

            // Relationships (to groups), concise
            var/list/rels = payload["relationships"] || list()
            var/list/rel_lines = list()
            var/rel_shown = 0
            for (var/i in 1 to rels.len)
                var/list/R = rels[i]
                if (R["kind"] != "group") continue
                var/target_id = R["target_key"]
                var/intensity = SAFE_NUM(R["intensity"])
                var/datum/group/Grel = SSroleplay_management.get_group_by_id(target_id)
                var/tname = NN(Grel?.name, target_id)
                rel_lines += "→ [tname] ([intensity])"
                rel_shown++

            // Chronicle & Memories summary
            var/list/chron = payload["chronicle"] || list()
            var/list/evs   = chron["events"] || list()
            var/chron_line = (length(evs) ? "[SAFE_NUM(length(evs))] event(s)" : "—")

            var/list/mems  = payload["memories"] || list()
            var/m_all      = SAFE_NUM(length(mems["memories_all"]))
            // common buckets, show non-empty only
            var/list/m_bullets = list()
            for (var/key in list("current","recent","goal","secret","reputation","relationship"))
                var/n = SAFE_NUM(length(mems[key]))
                if (n) m_bullets += "[capitalize(key)] [n]"

            // Render player card
            html += "<div style='border:1px solid #273043;border-radius:6px;padding:10px;margin:6px 0'>"
            html += "<div style='font-size:14px;margin-bottom:6px'><b>[name]</b> <span style='color:#9aa4b2'>([C.character_id])</span></div>"
            html += "<div style='margin-bottom:8px;color:#cbd5e1'>Role:</div><div style='margin:-6px 0 8px 50px'>[role]</div>"
            html += "<div style='margin-bottom:8px;color:#cbd5e1'>Species:</div><div style='margin:-6px 0 8px 70px'>[spec]</div>"

            if (length(g_lines))
                html += "<div style='margin-bottom:6px;color:#cbd5e1'>Groups:</div>"
                html += "<div style='margin:-6px 0 8px 65px'>" + jointext(g_lines, "<br>") + "</div>"

            if (rel_shown)
                html += "<div style='margin-bottom:6px;color:#cbd5e1'>Relationships:</div>"
                html += "<div style='margin:-6px 0 8px 110px'>" + jointext(rel_lines, "<br>") + "</div>"

            html += "<div style='display:flex;gap:18px;opacity:.9'>"
            html += "<div>Chronicle: [chron_line]</div>"
            html += "<div>Memories: total [m_all]"
            if (length(m_bullets)) html += " — " + jointext(m_bullets, ", ")
            html += "</div></div>"

            // Raw payload (hidden)
            var/raw_json = json_encode(payload, TRUE)
            html += "<details style='margin-top:8px'><summary style='color:#9aa4b2'>Raw payload</summary><pre style='white-space:pre-wrap'>[raw_json]</pre></details>"

            html += "</div>"
    html += "</details><br>"

    // -------- RUNTIME GROUPS (compact by type, only those with members/rels) --------
    var/list/by_type = list(
        GROUP_TYPE_CITY = list(), GROUP_TYPE_FACTION = list(), GROUP_TYPE_SECT = list(),
        GROUP_TYPE_CLAN = list(), GROUP_TYPE_TRIBE = list(), GROUP_TYPE_ORGANIZATION = list(),
        GROUP_TYPE_PARTY = list(), GROUP_TYPE_PLAYER = list(), "unknown" = list()
    )
    for (var/gid in GLOB.groups)
        var/datum/group/G = GLOB.groups[gid]
        if (!G) continue
        var/member_ct = length(G.members || list())
        var/list/rel_to_group = SSroleplay_management.get_relationships_to_target(gid, null) || list()
        var/rel_ct = length(rel_to_group)
        // hide completely empty runtime groups
        if (!member_ct && !rel_ct) continue
        var/t = G?.gtype || "unknown"
        (by_type[t] ||= list()) += gid

    html += "<details><summary><b>Runtime Groups</b> (non-empty only)</summary>"
    for (var/t in by_type)
        var/list/keys = by_type[t]
        if (!length(keys)) continue
        html += "<details><summary><b>[capitalize(t)]</b> ([length(keys)])</summary>"
        for (var/gid in keys)
            var/datum/group/G = GLOB.groups[gid]
            if (!G) continue
            var/leader_ct = length(G.leaders || list())
            var/officer_ct = length(G.officers || list())
            var/member_ct = length(G.members || list())
            var/list/rel_to_group = SSroleplay_management.get_relationships_to_target(gid, null) || list()
            var/rel_ct = length(rel_to_group)
            var/meta = "leaders=[leader_ct] officers=[officer_ct] members=[member_ct] rels=[rel_ct]"
            html += "<div style='margin:4px 0'><b>[G.name]</b> <span style='color:#9aa4b2'>([gid])</span> — [meta]</div>"
        html += "</details>"
    html += "</details><br>"

    // -------- RELATIONSHIPS (grouped by owner, compact) --------
    html += "<details><summary><b>Relationships</b> ([c_relationships])</summary>"
    if (!c_relationships)
        html += "<div style='opacity:.7'>No relationships.</div>"
    else
        var/list/rel_groups = list()
        for (var/rid in GLOB.relationships)
            var/datum/relationships/R = GLOB.relationships[rid]
            var/source = R?.owner || "Unknown"
            (rel_groups[source] ||= list()) += rid

        for (var/source in rel_groups)
            var/list/rids = rel_groups[source]
            html += "<details><summary><b>[source]</b> ([length(rids)])</summary>"
            for (var/rid in rids)
                var/datum/relationships/R = GLOB.relationships[rid]
                var/target_id = R?.target
                var/datum/group/G = SSroleplay_management.get_group_by_id(target_id)
                var/tname = NN(G?.name, target_id)
                html += "<div>• [rid] → [tname] ([R?.kind || "kind?"]) <span style='color:#9aa4b2'>int=[SAFE_NUM(R?.intensity)]</span></div>"
            html += "</details>"
    html += "</details><br>"

    // -------- CHRONICLES (compact) --------
    html += "<details><summary><b>Chronicles</b> ([c_chronicles])</summary>"
    if (c_chronicles)
        var/list/by_host = list()
        for (var/ckey in GLOB.chronicles)
            var/datum/chronicle/C = GLOB.chronicles[ckey]
            var/host = C.owner_key || "Unknown"
            (by_host[host] ||= list()) += ckey
        for (var/host in by_host)
            var/list/keys = by_host[host]
            html += "<details><summary><b>[host]</b> ([length(keys)])</summary>"
            for (var/ck in keys)
                var/datum/chronicle/C = GLOB.chronicles[ck]
                html += "<div>• [C.title] <span style='color:#9aa4b2'>([ck])</span> — entries=[length(C.entries||list())] status=[C.status]</div>"
            html += "</details>"
    html += "</details><br>"

    // -------- MEMORIES (compact) --------
    html += "<details><summary><b>Memories</b> ([c_memories])</summary>"
    if (c_memories)
        var/list/mem_by_owner = list()
        for (var/mid in GLOB.memories)
            var/datum/memory/M = GLOB.memories[mid]
            var/owner = M?.owner_key || "Unknown"
            (mem_by_owner[owner] ||= list()) += mid
        for (var/owner in mem_by_owner)
            var/list/mids = mem_by_owner[owner]
            html += "<details><summary><b>[owner]</b> ([length(mids)])</summary>"
            var/count = 0
            for (var/mid in mids)
                if (count >= 10) { html += "<div style='opacity:.7'>(+ more…)</div>"; break }
                var/datum/memory/M = GLOB.memories[mid]
                var/summary = (M?.summary ? M.summary : "No summary")
                var/tags = (islist(M?.tags) ? M.tags : list())
                var/tags_str = (length(tags) ? jointext(tags, ", ") : "")
                html += "<div>• [summary] <span style='color:#9aa4b2'>([mid])</span> — [tags_str]</div>"
                count++
            html += "</details>"
    html += "</details><br>"

    // -------- ORPHANS / CONSISTENCY (unchanged logic, compact output) --------
    var/list/orphans = list()
    for (var/rid in GLOB.relationships)
        var/datum/relationships/R = GLOB.relationships[rid]
        if (!R) continue
        if (!R.owner || !GLOB.aboutme_records[R.owner])
            orphans += "REL [rid]: missing owner_key=[R?.owner]"
        if (R.kind == "group" && (!R.target || !GLOB.groups[R.target]))
            orphans += "REL [rid]: missing group target=[R?.target]"
    for (var/ck in GLOB.chronicles)
        var/datum/chronicle/C = GLOB.chronicles[ck]
        for (var/eid in (C.entries || list()))
            if (!GLOB.chronicle_entries[eid])
                orphans += "CHRON [ck]: references missing entry [eid]"
    for (var/eid in GLOB.chronicle_entries)
        var/datum/chronicle_entry/E = GLOB.chronicle_entries[eid]
        if (!E?.chron_key || !GLOB.chronicles[E.chron_key])
            orphans += "ENTRY [eid]: missing chronicle [E?.chron_key]"
    for (var/gid in GLOB.groups)
        var/datum/group/G = GLOB.groups[gid]
        for (var/mkey in (G.members || list()))
            if (!GLOB.aboutme_records[mkey])
                orphans += "GROUP [gid]: member without record [mkey]"

    html += "<details><summary><b>Orphans / Consistency</b> ([length(orphans)])</summary><pre>"
    // cap the printed lines for sanity
    var/printed = 0
    for (var/line in orphans)
        if (printed >= 200) { html += "(truncated)\n"; break }
        html += "[line]\n"
        printed++
    html += "</pre></details><br>"

    // -------- Canonical Registry (collapsed, optional) --------
    html += "<details><summary><b>Canonical Groups</b> ([c_canon])</summary>"
    var/shown = 0
    for (var/gid in GLOB.canonical_groups)
        var/datum/group/Gc = GLOB.canonical_groups[gid]
        var/mini = json_encode(Gc?.GetFormattedUI() || list())
        html += "<div><b>[gid]</b> — [Gc?.name || gid]</div>"
        // keep raw minimal and collapsed per item
        html += "<details><summary style='color:#9aa4b2'>raw</summary><pre style='white-space:pre-wrap'>[mini]</pre></details>"
        shown++
        if (shown >= 25) { html += "<div style='opacity:.7'>(+ more… open raw storage to view all)</div>"; break }
    html += "</details><br>"

    html += "</body></html>"
    src << browse(html.Join(""), "window=roleplay_management_debug;size=1100x900")

    #undef NN
    #undef SAFE_NUM
