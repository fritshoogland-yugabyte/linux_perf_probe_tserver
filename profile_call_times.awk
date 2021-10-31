#!/usr/bin/awk -f
#
# important: sed 's/\ \[wor/_[wor/'
#
{ process_name = $1;
  pid = $2;
  time = $4;
  action = $5;
  time = substr(time,1,length(time)-1);
  if ( overall_begin_time == "" )
    overall_begin_time = time;
  if ( begin_time[pid] == "" )
    begin_time[pid] = time;

  # 1a yb::rpc::(anonymous namespace)::Worker::Execute
  if ( action ~ /worker_execute:$/ ) {
    a_time[pid]["Worker::Execute"] = time;
  }
  if ( action ~ /worker_execute__return:$/ ) {
    if ( a_time[pid]["Worker::Execute"] != "" ) {
      total_time[process_name]["Worker::Execute"] += (time - a_time[pid]["Worker::Execute"] );
      count[process_name]["Worker::Execute"] += 1;
      if ( ( max[process_name]["Worker::Execute"] == "" ? 0 : max[process_name]["Worker::Execute"] ) < time - a_time[pid]["Worker::Execute"] )
        max[process_name]["Worker::Execute"] = time - a_time[pid]["Worker::Execute"];
      a_time[pid]["Worker::Execute"] = "";
    }
  }
  # 1b yb::rpc::InboundCall::InboundCallTask::Run
  if ( action ~ /inboundcalltask_run:$/ ) {
    a_time[pid]["InboundCallTask::Run"] = time;
  }
  if ( action ~ /inboundcalltask_run__return:$/ ) {
    if ( a_time[pid]["InboundCallTask::Run"] != "" ) {
      total_time[process_name]["InboundCallTask::Run"] += (time - a_time[pid]["InboundCallTask::Run"] );
      count[process_name]["InboundCallTask::Run"] += 1;
      if ( ( max[process_name]["InboundCallTask::Run"] == "" ? 0 : max[process_name]["InboundCallTask::Run"] ) < time - a_time[pid]["InboundCallTask::Run"] )
        max[process_name]["InboundCallTask::Run"] = time - a_time[pid]["InboundCallTask::Run"];
      a_time[pid]["InboundCallTask::Run"] = "";
    }
  }
  # 1c yb::rpc::Strand::Done
  if ( action ~ /strand_done:$/ ) {
    a_time[pid]["Strand::Done"] = time;
  }
  if ( action ~ /strand_done__return:$/ ) {
    if ( a_time[pid]["Strand::Done"] != "" ) {
      total_time[process_name]["Strand::Done"] += (time - a_time[pid]["Strand::Done"] );
      count[process_name]["Strand::Done"] += 1;
      if ( ( max[process_name]["Strand::Done"] == "" ? 0 : max[process_name]["Strand::Done"] ) < time - a_time[pid]["Strand::Done"] )
        max[process_name]["Strand::Done"] = time - a_time[pid]["Strand::Done"];
      a_time[pid]["Strand::Done"] = "";
    }
  }
  # 2 yb::tablet::DocWriteOperation::DoComplete
  if ( action ~ /docwriteop_docomplete:$/ ) {
    a_time[pid]["DocWriteOperation::DoComplete"] = time;
  }
  if ( action ~ /docwriteop_docomplete__return:$/ ) {
    if ( a_time[pid]["DocWriteOperation::DoComplete"] != "" ) {
      total_time[process_name]["DocWriteOperation::DoComplete"] += (time - a_time[pid]["DocWriteOperation::DoComplete"] );
      count[process_name]["DocWriteOperation::DoComplete"] += 1;
      if ( ( max[process_name]["DocWriteOperation::DoComplete"] == "" ? 0 : max[process_name]["DocWriteOperation::DoComplete"] ) < time - a_time[pid]["DocWriteOperation::DoComplete"] )
        max[process_name]["DocWriteOperation::DoComplete"] = time - a_time[pid]["DocWriteOperation::DoComplete"];
      a_time[pid]["DocWriteOperation::DoComplete"] = "";
    }
  }
  # 2a yb::docdb::PgsqlWriteOperation::Apply
  if ( action ~ /pgsqlwriteoperation_apply:$/ ) {
    a_time[pid]["PgsqlWriteOperation::Apply"] = time;
  }
  if ( action ~ /pgsqlwriteoperation_apply__return:$/ ) {
    if ( a_time[pid]["PgsqlWriteOperation::Apply"] != "" ) {
      total_time[process_name]["PgsqlWriteOperation::Apply"] += (time - a_time[pid]["PgsqlWriteOperation::Apply"] );
      count[process_name]["PgsqlWriteOperation::Apply"] += 1;
      if ( ( max[process_name]["PgsqlWriteOperation::Apply"] == "" ? 0 : max[process_name]["PgsqlWriteOperation::Apply"] ) < time - a_time[pid]["PgsqlWriteOperation::Apply"] )
        max[process_name]["PgsqlWriteOperation::Apply"] = time - a_time[pid]["PgsqlWriteOperation::Apply"];
      a_time[pid]["PgsqlWriteOperation::Apply"] = "";
    }
  }
  # 3 yb::log::Log::Appender::ProcessBatch
  if ( action ~ /processbatch:$/ ) {
    a_time[pid]["Appender::ProcessBatch"] = time;
  }
  if ( action ~ /processbatch__return:$/ ) {
    if ( a_time[pid]["Appender::ProcessBatch"] != "" ) {
      total_time[process_name]["Appender::ProcessBatch"] += (time - a_time[pid]["Appender::ProcessBatch"] );
      count[process_name]["Appender::ProcessBatch"] += 1;
      if ( ( max[process_name]["Appender::ProcessBatch"] == "" ? 0 : max[process_name]["Appender::ProcessBatch"] ) < time - a_time[pid]["Appender::ProcessBatch"] )
        max[process_name]["Appender::ProcessBatch"] = time - a_time[pid]["Appender::ProcessBatch"];
      a_time[pid]["Appender::ProcessBatch"] = "";
    }
  }
  # 4 yb::log::Log::Appender::GroupWork
  if ( action ~ /groupwork:$/ ) {
    a_time[pid]["Appender::GroupWork"] = time;
  }
  if ( action ~ /groupwork__return:$/ ) {
    if ( a_time[pid]["Appender::GroupWork"] != "" ) {
      total_time[process_name]["Appender::GroupWork"] += (time - a_time[pid]["Appender::GroupWork"] );
      count[process_name]["Appender::GroupWork"] += 1;
      if ( ( max[process_name]["Appender::GroupWork"] == "" ? 0 : max[process_name]["Appender::GroupWork"] ) < time - a_time[pid]["Appender::GroupWork"] )
        max[process_name]["Appender::GroupWork"] = time - a_time[pid]["Appender::GroupWork"];
      a_time[pid]["Appender::GroupWork"] = "";
    }
  }
  # 5 yb::log::Log::DoAppend
  if ( action ~ /doappend:$/ ) {
    a_time[pid]["DoAppend"] = time;
  }
  if ( action ~ /doappend__return:$/ ) {
    if ( a_time[pid]["DoAppend"] != "" ) {
      total_time[process_name]["DoAppend"] += (time - a_time[pid]["DoAppend"] );
      count[process_name]["DoAppend"] += 1;
      if ( ( max[process_name]["DoAppend"] == "" ? 0 : max[process_name]["DoAppend"] ) < time - a_time[pid]["DoAppend"] )
        max[process_name]["DoAppend"] = time - a_time[pid]["DoAppend"];
      a_time[pid]["DoAppend"] = "";
    }
  }
  # 6 yb::consensus::PeerMessageQueue::NotifyObserversOfMajorityReplOpChangeTask
  if ( action ~ /notifyobserversofmajorityreplopchangetask:$/ ) {
    a_time[pid]["NotifyObserversOfMajorityReplOpChangeTask"] = time;
  }
  if ( action ~ /notifyobserversofmajorityreplopchangetask__return:$/ ) {
    if ( a_time[pid]["NotifyObserversOfMajorityReplOpChangeTask"] != "" ) {
      total_time[process_name]["NotifyObserversOfMajorityReplOpChangeTask"] += (time - a_time[pid]["NotifyObserversOfMajorityReplOpChangeTask"] );
      count[process_name]["NotifyObserversOfMajorityReplOpChangeTask"] += 1;
      if ( ( max[process_name]["NotifyObserversOfMajorityReplOpChangeTask"] == "" ? 0 : max[process_name]["NotifyObserversOfMajorityReplOpChangeTask"] ) < time - a_time[pid]["NotifyObserversOfMajorityReplOpChangeTask"] )
        max[process_name]["NotifyObserversOfMajorityReplOpChangeTask"] = time - a_time[pid]["NotifyObserversOfMajorityReplOpChangeTask"];
      a_time[pid]["NotifyObserversOfMajorityReplOpChangeTask"] = "";
    }
  }
  # 7 yb::tablet::UpdateTxnOperation::DoReplicated
  if ( action ~ /updatetxnoperation_doreplicated:$/ ) {
    a_time[pid]["UpdateTxnOperation::DoReplicated"] = time;
  }
  if ( action ~ /updatetxnoperation_doreplicated__return:$/ ) {
    if ( a_time[pid]["UpdateTxnOperation::DoReplicated"] != "" ) {
      total_time[process_name]["UpdateTxnOperation::DoReplicated"] += (time - a_time[pid]["UpdateTxnOperation::DoReplicated"] );
      count[process_name]["UpdateTxnOperation::DoReplicated"] += 1;
      if ( ( max[process_name]["UpdateTxnOperation::DoReplicated"] == "" ? 0 : max[process_name]["UpdateTxnOperation::DoReplicated"] ) < time - a_time[pid]["UpdateTxnOperation::DoReplicated"] )
        max[process_name]["UpdateTxnOperation::DoReplicated"] = time - a_time[pid]["UpdateTxnOperation::DoReplicated"];
      a_time[pid]["UpdateTxnOperation::DoReplicated"] = "";
    }
  }
  # 8 yb::tablet::WriteOperation::DoReplicated
  if ( action ~ /writeoperation_doreplicated:$/ ) {
    a_time[pid]["WriteOperation::DoReplicated"] = time;
  }
  if ( action ~ /writeoperation_doreplicated__return:$/ ) {
    if ( a_time[pid]["WriteOperation::DoReplicated"] != "" ) {
      total_time[process_name]["WriteOperation::DoReplicated"] += (time - a_time[pid]["WriteOperation::DoReplicated"] );
      count[process_name]["WriteOperation::DoReplicated"] += 1;
      if ( ( max[process_name]["WriteOperation::DoReplicated"] == "" ? 0 : max[process_name]["WriteOperation::DoReplicated"] ) < time - a_time[pid]["WriteOperation::DoReplicated"] )
        max[process_name]["WriteOperation::DoReplicated"] = time - a_time[pid]["WriteOperation::DoReplicated"];
      a_time[pid]["WriteOperation::DoReplicated"] = "";
    }
  }
  end_time[pid] = time;
}
END {
  total_overall_time=time-overall_begin_time;
  printf "%-49s %15.6fs\n", "total time:", total_overall_time;

  for ( process in total_time ) {
    for ( what in total_time[process] ) {
      printf "%-10s %-50s %8d %15.6fs %7.2f%, avg: %15.6fs, max: %15.6fs\n", process, what, count[process][what], total_time[process][what], total_time[process][what]/total_overall_time*100, total_time[process][what]/count[process][what], max[process][what];
    }
  }
}