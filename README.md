These scripts use linux perf probe functionality to set probes on entering and returning from tserver functions.
By doing this, we can understand the number of times, the total time and the average and maximum time per occasion spend in these.
Obviously, the probes work on a single linux server, and therefore show the time of the local tserver execution, not of the entire YugabyteDB cluster.

The way it works:
1. Run `./set_probes.sh` as root. This defines the probes in the kernel.
2. Start recording the firing of the probes: `perf record -e 'probe_*:*' -p $(pgrep tserver)`.
3. Execute the load on the YugabyteDB cluster.
4. Stop the recording (interrupt: ctrl-C). This results in a file called perf.data.
5. Use the profile_call_times.awk script to calculate the times: `perf script | sed 's/\ \[wor/_[wor/' | ./profile_call_times.awk`

The output shows something like this:
```
total time:                                              0.045204s
append_[worker] Sync                                                      2        0.039995s   88.48%, avg:        0.019997s, max:        0.039991s
append_[worker] DoAppend                                                  2        0.000122s    0.27%, avg:        0.000061s, max:        0.000079s
append_[worker] AppendVector                                              4        0.000049s    0.11%, avg:        0.000012s, max:        0.000023s
append_[worker] Appender::GroupWork                                       2        0.040107s   88.72%, avg:        0.020053s, max:        0.040074s
append_[worker] Appender::ProcessBatch                                    4        0.040245s   89.03%, avg:        0.010061s, max:        0.040078s
consensus_[work NotifyObserversOfMajorityReplOpChangeTask                 2        0.000516s    1.14%, avg:        0.000258s, max:        0.000509s
consensus_[work WriteOperation::DoReplicated                              1        0.000062s    0.14%, avg:        0.000062s, max:        0.000062s
rpc_tp_TabletSe PgsqlWriteOperation::Apply                                1        0.001430s    3.16%, avg:        0.001430s, max:        0.001430s
rpc_tp_TabletSe InboundCallTask::Run                                      1        0.003435s    7.60%, avg:        0.003435s, max:        0.003435s
rpc_tp_TabletSe DocWriteOperation::DoComplete                             1        0.001499s    3.32%, avg:        0.001499s, max:        0.001499s
```

Notes:
- The order of the lines in the output is random.
- You have to understand the sequence and if a function is called within another function to make sense of it.
- The sed script removes spaces in thread names.
