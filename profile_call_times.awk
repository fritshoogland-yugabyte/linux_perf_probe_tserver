#!/usr/bin/awk -f
#
# important: sed 's/\ \[wor/_[wor/'
#
{ pid = $2;
  time = $4;
  action = $5;
  time = substr(time,1,length(time)-1);
  if ( overall_begin_time == "" )
    overall_begin_time = time;
  if ( begin_time[pid] == "" )
    begin_time[pid] = time;

  if ( action ~ /applyinsert:$/ ) {
    a_time[pid]["ApplyInsert"] = time;
  }
  if ( action ~ /applyinsert__return:$/ ) {
    if ( a_time[pid]["ApplyInsert"] != "" ) {
      total_time["ApplyInsert"] += (time - a_time[pid]["ApplyInsert"] );
      count["ApplyInsert"] += 1;
      if ( ( max["ApplyInsert"] == "" ? 0 : max["ApplyInsert"] ) < time - a_time[pid]["ApplyInsert"] )
        max["ApplyInsert"] = time - a_time[pid]["ApplyInsert"];
      a_time[pid]["ApplyInsert"] = "";
    }
  }
  if ( action ~ /doappend:$/ ) {
    a_time[pid]["DoAppend"] = time;
  }
  if ( action ~ /doappend__return:$/ ) {
    if ( a_time[pid]["DoAppend"] != "" ) {
      total_time["DoAppend"] += (time - a_time[pid]["DoAppend"] );
      count["DoAppend"] += 1;
      if ( ( max["DoAppend"] == "" ? 0 : max["DoAppend"] ) < time - a_time[pid]["DoAppend"] )
        max["DoAppend"] = time - a_time[pid]["DoAppend"];
      a_time[pid]["DoAppend"] = "";
    }
  }
  if ( action ~ /groupwork:$/ ) {
    a_time[pid]["GroupWork"] = time;
  }
  if ( action ~ /groupwork__return:$/ ) {
    if ( a_time[pid]["GroupWork"] != "" ) {
      total_time["GroupWork"] += (time - a_time[pid]["GroupWork"] );
      count["GroupWork"] += 1;
      if ( ( max["GroupWork"] == "" ? 0 : max["GroupWork"] ) < time - a_time[pid]["GroupWork"] )
        max["GroupWork"] = time - a_time[pid]["GroupWork"];
      a_time[pid]["GroupWork"] = "";
    }
  }
  if ( action ~ /updatemajorityreplicated:$/ ) {
    a_time[pid]["UpdateMajorityReplicated"] = time;
  }
  if ( action ~ /updatemajorityreplicated__return:$/ ) {
    if ( a_time[pid]["UpdateMajorityReplicated"] != "" ) {
      total_time["UpdateMajorityReplicated"] += (time - a_time[pid]["UpdateMajorityReplicated"] );
      count["UpdateMajorityReplicated"] += 1;
      if ( ( max["UpdateMajorityReplicated"] == "" ? 0 : max["UpdateMajorityReplicated"] ) < time - a_time[pid]["UpdateMajorityReplicated"] )
        max["UpdateMajorityReplicated"] = time - a_time[pid]["UpdateMajorityReplicated"];
      a_time[pid]["UpdateMajorityReplicated"] = "";
    }
  }
  end_time[pid] = time;
}
END {
  total_overall_time=time-overall_begin_time;
  printf "%-49s %15.6fs\n", "total time:", total_overall_time;

  for ( what in total_time ) {
      printf "%-40s %8d %15.6fs %7.2f%, avg: %15.6fs, max: %15.6fs\n", what, count[what], total_time[what], total_time[what]/total_overall_time*100, total_time[what]/count[what], max[what];
  }
}