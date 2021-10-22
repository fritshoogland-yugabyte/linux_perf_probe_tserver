TSERVER_EXEC=/opt/yugabyte/yugabyte-2.9.0.0/bin/yb-tserver
TSERVER_LIBLOG=/opt/yugabyte/yugabyte-2.9.0.0/lib/yb/liblog.so
TSERVER_LIBYB_DOCDB=/opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libyb_docdb.so
TSERVER_LIBCONSENSUS=/opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libconsensus.so
TSERVER_LIBTABLET=/opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libtablet.so
TSERVER_LIBRPC=/opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libyrpc.so

# 1-insert (rpc_tp_tabletserver)
# ## doesn't work ## master function: yb::rpc::(anonymous namespace)::Worker::Execute
# master function1: yb::rpc::InboundCall::InboundCallTask::Run
# master function2: yb::rpc::Strand::Done
# subfunction 1  : yb::tablet::DocWriteOperation::DoComplete
# subfunction 2  : yb::docdb::PgsqlWriteOperation::Apply
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libyrpc.so --funcs --no-demangle --filter='*' | grep Worker
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libyrpc.so --funcs --no-demangle --filter='*' | grep DoComplete
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libyb_docdb.so --funcs --no-demangle --filter='*' | grep Apply
#perf probe --no-demangle -x $TSERVER_LIBRPC --add worker_execute='_ZN2yb3rpc12_GLOBAL__N_16Worker7ExecuteEv'
#perf probe --no-demangle -x $TSERVER_LIBRPC --add worker_execute='_ZN2yb3rpc12_GLOBAL__N_16Worker7ExecuteEv%return'
perf probe --no-demangle -x $TSERVER_LIBRPC --add inboundcalltask_run='_ZN2yb3rpc11InboundCall15InboundCallTask3RunEv'
perf probe --no-demangle -x $TSERVER_LIBRPC --add inboundcalltask_run='_ZN2yb3rpc11InboundCall15InboundCallTask3RunEv%return'
perf probe --no-demangle -x $TSERVER_LIBRPC --add strand_done='_ZN2yb3rpc6Strand4DoneERKNS_6StatusE'
perf probe --no-demangle -x $TSERVER_LIBRPC --add strand_done='_ZN2yb3rpc6Strand4DoneERKNS_6StatusE%return'
perf probe --no-demangle -x $TSERVER_LIBTABLET --add docwriteop_docomplete='_ZN2yb6tablet17DocWriteOperation10DoCompleteEv'
perf probe --no-demangle -x $TSERVER_LIBTABLET --add docwriteop_docomplete='_ZN2yb6tablet17DocWriteOperation10DoCompleteEv%return'
perf probe --no-demangle -x $TSERVER_LIBYB_DOCDB --add pgsqlwriteoperation_apply='_ZN2yb5docdb19PgsqlWriteOperation5ApplyERKNS0_21DocOperationApplyDataE'
perf probe --no-demangle -x $TSERVER_LIBYB_DOCDB --add pgsqlwriteoperation_apply='_ZN2yb5docdb19PgsqlWriteOperation5ApplyERKNS0_21DocOperationApplyDataE%return'

# 2-wal entry (append [worker])
# master function: yb::log::Log::Appender::ProcessBatch
# subfunction 1  : yb::log::Log::Appender::GroupWork
# subfunction 2  : yb::log::Log::DoAppend
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/liblog.so --funcs --no-demangle --filter='*' | grep ProcessBatch
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/liblog.so --funcs --no-demangle --filter='*' | grep DoAppend
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/liblog.so --funcs --no-demangle --filter='*' | grep GroupWork
perf probe --no-demangle -x $TSERVER_LIBLOG --add processbatch='_ZN2yb3log3Log8Appender12ProcessBatchEPNS0_13LogEntryBatchE'
perf probe --no-demangle -x $TSERVER_LIBLOG --add processbatch='_ZN2yb3log3Log8Appender12ProcessBatchEPNS0_13LogEntryBatchE%return'
perf probe --no-demangle -x $TSERVER_LIBLOG --add doappend='_ZN2yb3log3Log8DoAppendEPNS0_13LogEntryBatchEbb'
perf probe --no-demangle -x $TSERVER_LIBLOG --add doappend='_ZN2yb3log3Log8DoAppendEPNS0_13LogEntryBatchEbb%return'
perf probe --no-demangle -x $TSERVER_LIBLOG --add groupwork='_ZN2yb3log3Log8Appender9GroupWorkEv'
perf probe --no-demangle -x $TSERVER_LIBLOG --add groupwork='_ZN2yb3log3Log8Appender9GroupWorkEv%return'

# 3-consensus (consensus [worker])
# master function: yb::consensus::PeerMessageQueue::NotifyObserversOfMajorityReplOpChangeTask
# subfunction 1  : yb::tablet::UpdateTxnOperation::DoReplicated
# subfunction 2  : yb::tablet::WriteOperation::DoReplicated
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libconsensus.so --funcs --no-demangle --filter='*' | grep NotifyObserversOfMajorityReplOpChangeTask
perf probe --no-demangle -x $TSERVER_LIBCONSENSUS --add notifyobserversofmajorityreplopchangetask='_ZN2yb9consensus16PeerMessageQueue41NotifyObserversOfMajorityReplOpChangeTaskERKNS0_22MajorityReplicatedDataE'
perf probe --no-demangle -x $TSERVER_LIBCONSENSUS --add notifyobserversofmajorityreplopchangetask='_ZN2yb9consensus16PeerMessageQueue41NotifyObserversOfMajorityReplOpChangeTaskERKNS0_22MajorityReplicatedDataE%return'
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libtablet.so --funcs --no-demangle --filter='*' | grep DoReplicated
perf probe --no-demangle -x $TSERVER_LIBTABLET --add updatetxnoperation_doreplicated='_ZN2yb6tablet18UpdateTxnOperation12DoReplicatedElPNS_6StatusE'
perf probe --no-demangle -x $TSERVER_LIBTABLET --add updatetxnoperation_doreplicated='_ZN2yb6tablet18UpdateTxnOperation12DoReplicatedElPNS_6StatusE%return'
perf probe --no-demangle -x $TSERVER_LIBTABLET --add writeoperation_doreplicated='_ZN2yb6tablet14WriteOperation12DoReplicatedElPNS_6StatusE'
perf probe --no-demangle -x $TSERVER_LIBTABLET --add writeoperation_doreplicated='_ZN2yb6tablet14WriteOperation12DoReplicatedElPNS_6StatusE%return'

# perf probe --del '*'