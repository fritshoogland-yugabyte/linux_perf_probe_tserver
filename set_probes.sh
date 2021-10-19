TSERVER_EXEC=/opt/yugabyte/yugabyte-2.9.0.0/bin/yb-tserver
TSERVER_LIBLOG=/opt/yugabyte/yugabyte-2.9.0.0/lib/yb/liblog.so
TSERVER_LIBYB_DOCDB=/opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libyb_docdb.so
TSERVER_LIBCONSENSUS=/opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libconsensus.so
#
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/liblog.so --funcs --no-demangle --filter='*' | grep DoAppend
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/liblog.so --funcs --no-demangle --filter='*' | grep GroupWork
perf probe --no-demangle -x $TSERVER_LIBLOG --add doappend='_ZN2yb3log3Log8DoAppendEPNS0_13LogEntryBatchEbb'
perf probe --no-demangle -x $TSERVER_LIBLOG --add doappend='_ZN2yb3log3Log8DoAppendEPNS0_13LogEntryBatchEbb'
perf probe --no-demangle -x $TSERVER_LIBLOG --add groupwork='_ZN2yb3log3Log8Appender9GroupWorkEv'
perf probe --no-demangle -x $TSERVER_LIBLOG --add groupwork='_ZN2yb3log3Log8Appender9GroupWorkEv%return'
#
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libyb_docdb.so --funcs --no-demangle --filter='*' | grep ApplyInsert
perf probe --no-demangle -x $TSERVER_LIBYB_DOCDB --add applyinsert='_ZN2yb5docdb19PgsqlWriteOperation11ApplyInsertERKNS0_21DocOperationApplyDataENS_17StronglyTypedBoolINS0_12IsUpsert_TagEEE'
perf probe --no-demangle -x $TSERVER_LIBYB_DOCDB --add applyinsert='_ZN2yb5docdb19PgsqlWriteOperation11ApplyInsertERKNS0_21DocOperationApplyDataENS_17StronglyTypedBoolINS0_12IsUpsert_TagEEE%return'
#
#perf probe -x /opt/yugabyte/yugabyte-2.9.0.0/lib/yb/libconsensus.so --funcs --no-demangle --filter='*' | grep UpdateMajorityReplicated
perf probe --no-demangle -x $TSERVER_LIBCONSENSUS --add updatemajorityreplicated='_ZN2yb9consensus13RaftConsensus24UpdateMajorityReplicatedERKNS0_22MajorityReplicatedDataEPNS_4OpIdES6_'
perf probe --no-demangle -x $TSERVER_LIBCONSENSUS --add updatemajorityreplicated='_ZN2yb9consensus13RaftConsensus24UpdateMajorityReplicatedERKNS0_22MajorityReplicatedDataEPNS_4OpIdES6_%return'

# perf probe --del '*'