espanso/src/exit_code.rs
26:pub const WORKER_ERROR_EXIT_NO_CODE: i32 = 90;

Seems to be due to:

[espanso/src/cli/daemon/mod.rs:281] status = ExitStatus(
    unix_wait_status(
        5,
    ),
)

when running

&command = Command {
    program: "/nix/store/msw5k62x0nc6dk59q84bzhvp0dpxdn1s-espanso-2.1.8/bin/espanso",
    args: [
        "/nix/store/msw5k62x0nc6dk59q84bzhvp0dpxdn1s-espanso-2.1.8/bin/espanso",
        "worker",
        "--monitor-daemon",
    ],
}

Running that command directly:

```
$ /nix/store/msw5k62x0nc6dk59q84bzhvp0dpxdn1s-espanso-2.1.8/bin/espanso \
    worker --monitor-daemon
...
02:17:45 [worker(67406)] [INFO] monitoring the status of secure input
Trace/BPT trap: 5
```

detected unexpected daemon termination, sending exit signal to the engine
